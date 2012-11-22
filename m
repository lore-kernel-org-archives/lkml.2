Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab2KVWjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:39:24 -0500
Received: from mail.kernel.org ([198.145.19.201]:49023 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab2KVSdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 159/171] libceph: change ceph_con_in_msg_alloc convention to be less weird
Date: Wed, 21 Nov 2012 16:41:45 -0800
Message-Id: <20121122004049.307758673@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

(cherry picked from commit 4740a623d20c51d167da7f752b63e2b8714b2543)

This function's calling convention is very limiting.  In particular,
we can't return any error other than ENOMEM (and only implicitly),
which is a problem (see next patch).

Instead, return an normal 0 or error code, and make the skip a pointer
output parameter.  Drop the useless in_hdr argument (we have the con
pointer).

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   56 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1733,9 +1733,7 @@ static int read_partial_message_section(
 	return 1;
 }
 
-static bool ceph_con_in_msg_alloc(struct ceph_connection *con,
-				struct ceph_msg_header *hdr);
-
+static int ceph_con_in_msg_alloc(struct ceph_connection *con, int *skip);
 
 static int read_partial_message_pages(struct ceph_connection *con,
 				      struct page **pages,
@@ -1864,9 +1862,14 @@ static int read_partial_message(struct c
 
 	/* allocate message? */
 	if (!con->in_msg) {
+		int skip = 0;
+
 		dout("got hdr type %d front %d data %d\n", con->in_hdr.type,
 		     con->in_hdr.front_len, con->in_hdr.data_len);
-		if (ceph_con_in_msg_alloc(con, &con->in_hdr)) {
+		ret = ceph_con_in_msg_alloc(con, &skip);
+		if (ret < 0)
+			return ret;
+		if (skip) {
 			/* skip this message */
 			dout("alloc_msg said skip message\n");
 			BUG_ON(con->in_msg);
@@ -1876,12 +1879,8 @@ static int read_partial_message(struct c
 			con->in_seq++;
 			return 0;
 		}
-		if (!con->in_msg) {
-			con->error_msg =
-				"error allocating memory for incoming message";
-			return -ENOMEM;
-		}
 
+		BUG_ON(!con->in_msg);
 		BUG_ON(con->in_msg->con != con);
 		m = con->in_msg;
 		m->front.iov_len = 0;    /* haven't read it yet */
@@ -2715,43 +2714,50 @@ static int ceph_alloc_middle(struct ceph
  * connection, and save the result in con->in_msg.  Uses the
  * connection's private alloc_msg op if available.
  *
- * Returns true if the message should be skipped, false otherwise.
- * If true is returned (skip message), con->in_msg will be NULL.
- * If false is returned, con->in_msg will contain a pointer to the
- * newly-allocated message, or NULL in case of memory exhaustion.
+ * Returns 0 on success, or a negative error code.
+ *
+ * On success, if we set *skip = 1:
+ *  - the next message should be skipped and ignored.
+ *  - con->in_msg == NULL
+ * or if we set *skip = 0:
+ *  - con->in_msg is non-null.
+ * On error (ENOMEM, EAGAIN, ...),
+ *  - con->in_msg == NULL
  */
-static bool ceph_con_in_msg_alloc(struct ceph_connection *con,
-				struct ceph_msg_header *hdr)
+static int ceph_con_in_msg_alloc(struct ceph_connection *con, int *skip)
 {
+	struct ceph_msg_header *hdr = &con->in_hdr;
 	int type = le16_to_cpu(hdr->type);
 	int front_len = le32_to_cpu(hdr->front_len);
 	int middle_len = le32_to_cpu(hdr->middle_len);
-	int ret;
+	int ret = 0;
 
 	BUG_ON(con->in_msg != NULL);
 
 	if (con->ops->alloc_msg) {
-		int skip = 0;
-
 		mutex_unlock(&con->mutex);
-		con->in_msg = con->ops->alloc_msg(con, hdr, &skip);
+		con->in_msg = con->ops->alloc_msg(con, hdr, skip);
 		mutex_lock(&con->mutex);
 		if (con->in_msg) {
 			con->in_msg->con = con->ops->get(con);
 			BUG_ON(con->in_msg->con == NULL);
 		}
-		if (skip)
+		if (*skip) {
 			con->in_msg = NULL;
-
-		if (!con->in_msg)
-			return skip != 0;
+			return 0;
+		}
+		if (!con->in_msg) {
+			con->error_msg =
+				"error allocating memory for incoming message";
+			return -ENOMEM;
+		}
 	}
 	if (!con->in_msg) {
 		con->in_msg = ceph_msg_new(type, front_len, GFP_NOFS, false);
 		if (!con->in_msg) {
 			pr_err("unable to allocate msg type %d len %d\n",
 			       type, front_len);
-			return false;
+			return -ENOMEM;
 		}
 		con->in_msg->con = con->ops->get(con);
 		BUG_ON(con->in_msg->con == NULL);
@@ -2767,7 +2773,7 @@ static bool ceph_con_in_msg_alloc(struct
 		}
 	}
 
-	return false;
+	return ret;
 }
 
 


