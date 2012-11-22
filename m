Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab2KVSkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:40:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:49648 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026Ab2KVSkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 109/171] libceph: make ceph_con_revoke() a msg operation
Date: Wed, 21 Nov 2012 16:40:55 -0800
Message-Id: <20121122004044.300938762@linuxfoundation.org>
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

(cherry picked from commit 6740a845b2543cc46e1902ba21bac743fbadd0dc)

ceph_con_revoke() is passed both a message and a ceph connection.
Now that any message associated with a connection holds a pointer
to that connection, there's no need to provide the connection when
revoking a message.

This has the added benefit of precluding the possibility of the
providing the wrong connection pointer.  If the message's connection
pointer is null, it is not being tracked by any connection, so
revoking it is a no-op.  This is supported as a convenience for
upper layers, so they can revoke a message that is not actually
"in flight."

Rename the function ceph_msg_revoke() to reflect that it is really
an operation on a message, not a connection.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ceph/messenger.h |    3 ++-
 net/ceph/messenger.c           |    7 ++++++-
 net/ceph/mon_client.c          |    8 ++++----
 net/ceph/osd_client.c          |    4 ++--
 4 files changed, 14 insertions(+), 8 deletions(-)

--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -231,7 +231,8 @@ extern void ceph_con_open(struct ceph_co
 extern bool ceph_con_opened(struct ceph_connection *con);
 extern void ceph_con_close(struct ceph_connection *con);
 extern void ceph_con_send(struct ceph_connection *con, struct ceph_msg *msg);
-extern void ceph_con_revoke(struct ceph_connection *con, struct ceph_msg *msg);
+
+extern void ceph_msg_revoke(struct ceph_msg *msg);
 extern void ceph_con_revoke_message(struct ceph_connection *con,
 				  struct ceph_msg *msg);
 extern void ceph_con_keepalive(struct ceph_connection *con);
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2425,8 +2425,13 @@ EXPORT_SYMBOL(ceph_con_send);
 /*
  * Revoke a message that was previously queued for send
  */
-void ceph_con_revoke(struct ceph_connection *con, struct ceph_msg *msg)
+void ceph_msg_revoke(struct ceph_msg *msg)
 {
+	struct ceph_connection *con = msg->con;
+
+	if (!con)
+		return;		/* Message not in our possession */
+
 	mutex_lock(&con->mutex);
 	if (!list_empty(&msg->list_head)) {
 		dout("%s %p msg %p - was on queue\n", __func__, con, msg);
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -106,7 +106,7 @@ static void __send_prepared_auth_request
 	monc->pending_auth = 1;
 	monc->m_auth->front.iov_len = len;
 	monc->m_auth->hdr.front_len = cpu_to_le32(len);
-	ceph_con_revoke(&monc->con, monc->m_auth);
+	ceph_msg_revoke(monc->m_auth);
 	ceph_msg_get(monc->m_auth);  /* keep our ref */
 	ceph_con_send(&monc->con, monc->m_auth);
 }
@@ -117,7 +117,7 @@ static void __send_prepared_auth_request
 static void __close_session(struct ceph_mon_client *monc)
 {
 	dout("__close_session closing mon%d\n", monc->cur_mon);
-	ceph_con_revoke(&monc->con, monc->m_auth);
+	ceph_msg_revoke(monc->m_auth);
 	ceph_con_close(&monc->con);
 	monc->con.private = NULL;
 	monc->cur_mon = -1;
@@ -229,7 +229,7 @@ static void __send_subscribe(struct ceph
 
 		msg->front.iov_len = p - msg->front.iov_base;
 		msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
-		ceph_con_revoke(&monc->con, msg);
+		ceph_msg_revoke(msg);
 		ceph_con_send(&monc->con, ceph_msg_get(msg));
 
 		monc->sub_sent = jiffies | 1;  /* never 0 */
@@ -688,7 +688,7 @@ static void __resend_generic_request(str
 
 	for (p = rb_first(&monc->generic_request_tree); p; p = rb_next(p)) {
 		req = rb_entry(p, struct ceph_mon_generic_request, node);
-		ceph_con_revoke(&monc->con, req->request);
+		ceph_msg_revoke(req->request);
 		ceph_con_send(&monc->con, ceph_msg_get(req->request));
 	}
 }
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -852,7 +852,7 @@ static void __unregister_request(struct
 
 	if (req->r_osd) {
 		/* make sure the original request isn't in flight. */
-		ceph_con_revoke(&req->r_osd->o_con, req->r_request);
+		ceph_msg_revoke(req->r_request);
 
 		list_del_init(&req->r_osd_item);
 		if (list_empty(&req->r_osd->o_requests) &&
@@ -879,7 +879,7 @@ static void __unregister_request(struct
 static void __cancel_request(struct ceph_osd_request *req)
 {
 	if (req->r_sent && req->r_osd) {
-		ceph_con_revoke(&req->r_osd->o_con, req->r_request);
+		ceph_msg_revoke(req->r_request);
 		req->r_sent = 0;
 	}
 }


