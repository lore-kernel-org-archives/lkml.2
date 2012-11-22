Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab2KVW2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:28:14 -0500
Received: from mail.kernel.org ([198.145.19.201]:49015 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718Ab2KVSd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 110/171] libceph: make ceph_con_revoke_message() a msg op
Date: Wed, 21 Nov 2012 16:40:56 -0800
Message-Id: <20121122004044.397270484@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

(cherry picked from commit 8921d114f5574c6da2cdd00749d185633ecf88f3)

ceph_con_revoke_message() is passed both a message and a ceph
connection.  A ceph_msg allocated for incoming messages on a
connection always has a pointer to that connection, so there's no
need to provide the connection when revoking such a message.

Note that the existing logic does not preclude the message supplied
being a null/bogus message pointer.  The only user of this interface
is the OSD client, and the only value an osd client passes is a
request's r_reply field.  That is always non-null (except briefly in
an error path in ceph_osdc_alloc_request(), and that drops the
only reference so the request won't ever have a reply to revoke).
So we can safely assume the passed-in message is non-null, but add a
BUG_ON() to make it very obvious we are imposing this restriction.

Rename the function ceph_msg_revoke_incoming() to reflect that it is
really an operation on an incoming message.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ceph/messenger.h |    4 ++--
 net/ceph/messenger.c           |   22 ++++++++++++++++------
 net/ceph/osd_client.c          |    9 ++++-----
 3 files changed, 22 insertions(+), 13 deletions(-)

--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -233,8 +233,8 @@ extern void ceph_con_close(struct ceph_c
 extern void ceph_con_send(struct ceph_connection *con, struct ceph_msg *msg);
 
 extern void ceph_msg_revoke(struct ceph_msg *msg);
-extern void ceph_con_revoke_message(struct ceph_connection *con,
-				  struct ceph_msg *msg);
+extern void ceph_msg_revoke_incoming(struct ceph_msg *msg);
+
 extern void ceph_con_keepalive(struct ceph_connection *con);
 extern struct ceph_connection *ceph_con_get(struct ceph_connection *con);
 extern void ceph_con_put(struct ceph_connection *con);
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2460,17 +2460,27 @@ void ceph_msg_revoke(struct ceph_msg *ms
 /*
  * Revoke a message that we may be reading data into
  */
-void ceph_con_revoke_message(struct ceph_connection *con, struct ceph_msg *msg)
+void ceph_msg_revoke_incoming(struct ceph_msg *msg)
 {
+	struct ceph_connection *con;
+
+	BUG_ON(msg == NULL);
+	if (!msg->con) {
+		dout("%s msg %p null con\n", __func__, msg);
+
+		return;		/* Message not in our possession */
+	}
+
+	con = msg->con;
 	mutex_lock(&con->mutex);
-	if (con->in_msg && con->in_msg == msg) {
+	if (con->in_msg == msg) {
 		unsigned front_len = le32_to_cpu(con->in_hdr.front_len);
 		unsigned middle_len = le32_to_cpu(con->in_hdr.middle_len);
 		unsigned data_len = le32_to_cpu(con->in_hdr.data_len);
 
 		/* skip rest of message */
-		dout("con_revoke_pages %p msg %p revoked\n", con, msg);
-			con->in_base_pos = con->in_base_pos -
+		dout("%s %p msg %p revoked\n", __func__, con, msg);
+		con->in_base_pos = con->in_base_pos -
 				sizeof(struct ceph_msg_header) -
 				front_len -
 				middle_len -
@@ -2481,8 +2491,8 @@ void ceph_con_revoke_message(struct ceph
 		con->in_tag = CEPH_MSGR_TAG_READY;
 		con->in_seq++;
 	} else {
-		dout("con_revoke_pages %p msg %p pages %p no-op\n",
-		     con, con->in_msg, msg);
+		dout("%s %p in_msg %p msg %p no-op\n",
+		     __func__, con, con->in_msg, msg);
 	}
 	mutex_unlock(&con->mutex);
 }
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -140,10 +140,9 @@ void ceph_osdc_release_request(struct kr
 	if (req->r_request)
 		ceph_msg_put(req->r_request);
 	if (req->r_con_filling_msg) {
-		dout("release_request revoking pages %p from con %p\n",
+		dout("%s revoking pages %p from con %p\n", __func__,
 		     req->r_pages, req->r_con_filling_msg);
-		ceph_con_revoke_message(req->r_con_filling_msg,
-				      req->r_reply);
+		ceph_msg_revoke_incoming(req->r_reply);
 		req->r_con_filling_msg->ops->put(req->r_con_filling_msg);
 	}
 	if (req->r_reply)
@@ -2022,9 +2021,9 @@ static struct ceph_msg *get_reply(struct
 	}
 
 	if (req->r_con_filling_msg) {
-		dout("get_reply revoking msg %p from old con %p\n",
+		dout("%s revoking msg %p from old con %p\n", __func__,
 		     req->r_reply, req->r_con_filling_msg);
-		ceph_con_revoke_message(req->r_con_filling_msg, req->r_reply);
+		ceph_msg_revoke_incoming(req->r_reply);
 		req->r_con_filling_msg->ops->put(req->r_con_filling_msg);
 		req->r_con_filling_msg = NULL;
 	}


