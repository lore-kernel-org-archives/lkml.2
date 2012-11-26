Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab2KZSDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:03:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47427 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab2KZRFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:05:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 087/270] libceph: tweak ceph_alloc_msg()
Date: Mon, 26 Nov 2012 14:56:17 -0200
Message-Id: <1353949160-26803-88-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 1c20f2d26795803fc4f5155fe4fca5717a5944b6 upstream.

The function ceph_alloc_msg() is only used to allocate a message
that will be assigned to a connection's in_msg pointer.  Rename the
function so this implied usage is more clear.

In addition, make that assignment inside the function (again, since
that's precisely what it's intended to be used for).  This allows us
to return what is now provided via the passed-in address of a "skip"
variable.  The return type is now Boolean to be explicit that there
are only two possible outcomes.

Make sure the result of an ->alloc_msg method call always sets the
value of *skip properly.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c  |   61 +++++++++++++++++++++++++++----------------------
 net/ceph/mon_client.c |    3 +++
 net/ceph/osd_client.c |    1 +
 3 files changed, 38 insertions(+), 27 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index d8986e8..9e12806 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1659,9 +1659,8 @@ static int read_partial_message_section(struct ceph_connection *con,
 	return 1;
 }
 
-static struct ceph_msg *ceph_alloc_msg(struct ceph_connection *con,
-				struct ceph_msg_header *hdr,
-				int *skip);
+static bool ceph_con_in_msg_alloc(struct ceph_connection *con,
+				struct ceph_msg_header *hdr);
 
 
 static int read_partial_message_pages(struct ceph_connection *con,
@@ -1744,7 +1743,6 @@ static int read_partial_message(struct ceph_connection *con)
 	int ret;
 	unsigned int front_len, middle_len, data_len;
 	bool do_datacrc = !con->msgr->nocrc;
-	int skip;
 	u64 seq;
 	u32 crc;
 
@@ -1797,9 +1795,7 @@ static int read_partial_message(struct ceph_connection *con)
 	if (!con->in_msg) {
 		dout("got hdr type %d front %d data %d\n", con->in_hdr.type,
 		     con->in_hdr.front_len, con->in_hdr.data_len);
-		skip = 0;
-		con->in_msg = ceph_alloc_msg(con, &con->in_hdr, &skip);
-		if (skip) {
+		if (ceph_con_in_msg_alloc(con, &con->in_hdr)) {
 			/* skip this message */
 			dout("alloc_msg said skip message\n");
 			BUG_ON(con->in_msg);
@@ -2581,46 +2577,57 @@ static int ceph_alloc_middle(struct ceph_connection *con, struct ceph_msg *msg)
 }
 
 /*
- * Generic message allocator, for incoming messages.
+ * Allocate a message for receiving an incoming message on a
+ * connection, and save the result in con->in_msg.  Uses the
+ * connection's private alloc_msg op if available.
+ *
+ * Returns true if the message should be skipped, false otherwise.
+ * If true is returned (skip message), con->in_msg will be NULL.
+ * If false is returned, con->in_msg will contain a pointer to the
+ * newly-allocated message, or NULL in case of memory exhaustion.
  */
-static struct ceph_msg *ceph_alloc_msg(struct ceph_connection *con,
-				struct ceph_msg_header *hdr,
-				int *skip)
+static bool ceph_con_in_msg_alloc(struct ceph_connection *con,
+				struct ceph_msg_header *hdr)
 {
 	int type = le16_to_cpu(hdr->type);
 	int front_len = le32_to_cpu(hdr->front_len);
 	int middle_len = le32_to_cpu(hdr->middle_len);
-	struct ceph_msg *msg = NULL;
 	int ret;
 
+	BUG_ON(con->in_msg != NULL);
+
 	if (con->ops->alloc_msg) {
+		int skip = 0;
+
 		mutex_unlock(&con->mutex);
-		msg = con->ops->alloc_msg(con, hdr, skip);
+		con->in_msg = con->ops->alloc_msg(con, hdr, &skip);
 		mutex_lock(&con->mutex);
-		if (!msg || *skip)
-			return NULL;
+		if (skip)
+			con->in_msg = NULL;
+
+		if (!con->in_msg)
+			return skip != 0;
 	}
-	if (!msg) {
-		*skip = 0;
-		msg = ceph_msg_new(type, front_len, GFP_NOFS, false);
-		if (!msg) {
+	if (!con->in_msg) {
+		con->in_msg = ceph_msg_new(type, front_len, GFP_NOFS, false);
+		if (!con->in_msg) {
 			pr_err("unable to allocate msg type %d len %d\n",
 			       type, front_len);
-			return NULL;
+			return false;
 		}
-		msg->page_alignment = le16_to_cpu(hdr->data_off);
+		con->in_msg->page_alignment = le16_to_cpu(hdr->data_off);
 	}
-	memcpy(&msg->hdr, &con->in_hdr, sizeof(con->in_hdr));
+	memcpy(&con->in_msg->hdr, &con->in_hdr, sizeof(con->in_hdr));
 
-	if (middle_len && !msg->middle) {
-		ret = ceph_alloc_middle(con, msg);
+	if (middle_len && !con->in_msg->middle) {
+		ret = ceph_alloc_middle(con, con->in_msg);
 		if (ret < 0) {
-			ceph_msg_put(msg);
-			return NULL;
+			ceph_msg_put(con->in_msg);
+			con->in_msg = NULL;
 		}
 	}
 
-	return msg;
+	return false;
 }
 
 
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index dad0abb..f65111c 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -442,6 +442,7 @@ static struct ceph_msg *get_generic_reply(struct ceph_connection *con,
 		m = NULL;
 	} else {
 		dout("get_generic_reply %lld got %p\n", tid, req->reply);
+		*skip = 0;
 		m = ceph_msg_get(req->reply);
 		/*
 		 * we don't need to track the connection reading into
@@ -990,6 +991,8 @@ static struct ceph_msg *mon_alloc_msg(struct ceph_connection *con,
 	case CEPH_MSG_MDS_MAP:
 	case CEPH_MSG_OSD_MAP:
 		m = ceph_msg_new(type, front_len, GFP_NOFS, false);
+		if (!m)
+			return NULL;	/* ENOMEM--return skip == 0 */
 		break;
 	}
 
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 01ec0ac..d137bf0 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2077,6 +2077,7 @@ static struct ceph_msg *alloc_msg(struct ceph_connection *con,
 	int type = le16_to_cpu(hdr->type);
 	int front = le32_to_cpu(hdr->front_len);
 
+	*skip = 0;
 	switch (type) {
 	case CEPH_MSG_OSD_MAP:
 	case CEPH_MSG_WATCH_NOTIFY:
-- 
1.7.9.5

