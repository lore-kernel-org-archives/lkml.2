Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab2KZRFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:05:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47408 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab2KZRE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:04:56 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 083/270] libceph: embed ceph connection structure in mon_client
Date: Mon, 26 Nov 2012 14:56:13 -0200
Message-Id: <1353949160-26803-84-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 67130934fb579fdf0f2f6d745960264378b57dc8 upstream.

A monitor client has a pointer to a ceph connection structure in it.
This is the only one of the three ceph client types that do it this
way; the OSD and MDS clients embed the connection into their main
structures.  There is always exactly one ceph connection for a
monitor client, so there is no need to allocate it separate from the
monitor client structure.

So switch the ceph_mon_client structure to embed its
ceph_connection structure.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/ceph/mon_client.h |    2 +-
 net/ceph/mon_client.c           |   47 +++++++++++++++++----------------------
 2 files changed, 21 insertions(+), 28 deletions(-)

diff --git a/include/linux/ceph/mon_client.h b/include/linux/ceph/mon_client.h
index 545f859..2113e38 100644
--- a/include/linux/ceph/mon_client.h
+++ b/include/linux/ceph/mon_client.h
@@ -70,7 +70,7 @@ struct ceph_mon_client {
 	bool hunting;
 	int cur_mon;                       /* last monitor i contacted */
 	unsigned long sub_sent, sub_renew_after;
-	struct ceph_connection *con;
+	struct ceph_connection con;
 	bool have_fsid;
 
 	/* pending generic requests */
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 37c4cd7..ec75996 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -106,9 +106,9 @@ static void __send_prepared_auth_request(struct ceph_mon_client *monc, int len)
 	monc->pending_auth = 1;
 	monc->m_auth->front.iov_len = len;
 	monc->m_auth->hdr.front_len = cpu_to_le32(len);
-	ceph_con_revoke(monc->con, monc->m_auth);
+	ceph_con_revoke(&monc->con, monc->m_auth);
 	ceph_msg_get(monc->m_auth);  /* keep our ref */
-	ceph_con_send(monc->con, monc->m_auth);
+	ceph_con_send(&monc->con, monc->m_auth);
 }
 
 /*
@@ -117,8 +117,8 @@ static void __send_prepared_auth_request(struct ceph_mon_client *monc, int len)
 static void __close_session(struct ceph_mon_client *monc)
 {
 	dout("__close_session closing mon%d\n", monc->cur_mon);
-	ceph_con_revoke(monc->con, monc->m_auth);
-	ceph_con_close(monc->con);
+	ceph_con_revoke(&monc->con, monc->m_auth);
+	ceph_con_close(&monc->con);
 	monc->cur_mon = -1;
 	monc->pending_auth = 0;
 	ceph_auth_reset(monc->auth);
@@ -142,9 +142,9 @@ static int __open_session(struct ceph_mon_client *monc)
 		monc->want_next_osdmap = !!monc->want_next_osdmap;
 
 		dout("open_session mon%d opening\n", monc->cur_mon);
-		monc->con->peer_name.type = CEPH_ENTITY_TYPE_MON;
-		monc->con->peer_name.num = cpu_to_le64(monc->cur_mon);
-		ceph_con_open(monc->con,
+		monc->con.peer_name.type = CEPH_ENTITY_TYPE_MON;
+		monc->con.peer_name.num = cpu_to_le64(monc->cur_mon);
+		ceph_con_open(&monc->con,
 			      &monc->monmap->mon_inst[monc->cur_mon].addr);
 
 		/* initiatiate authentication handshake */
@@ -226,8 +226,8 @@ static void __send_subscribe(struct ceph_mon_client *monc)
 
 		msg->front.iov_len = p - msg->front.iov_base;
 		msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
-		ceph_con_revoke(monc->con, msg);
-		ceph_con_send(monc->con, ceph_msg_get(msg));
+		ceph_con_revoke(&monc->con, msg);
+		ceph_con_send(&monc->con, ceph_msg_get(msg));
 
 		monc->sub_sent = jiffies | 1;  /* never 0 */
 	}
@@ -247,7 +247,7 @@ static void handle_subscribe_ack(struct ceph_mon_client *monc,
 	if (monc->hunting) {
 		pr_info("mon%d %s session established\n",
 			monc->cur_mon,
-			ceph_pr_addr(&monc->con->peer_addr.in_addr));
+			ceph_pr_addr(&monc->con.peer_addr.in_addr));
 		monc->hunting = false;
 	}
 	dout("handle_subscribe_ack after %d seconds\n", seconds);
@@ -461,7 +461,7 @@ static int do_generic_request(struct ceph_mon_client *monc,
 	req->request->hdr.tid = cpu_to_le64(req->tid);
 	__insert_generic_request(monc, req);
 	monc->num_generic_requests++;
-	ceph_con_send(monc->con, ceph_msg_get(req->request));
+	ceph_con_send(&monc->con, ceph_msg_get(req->request));
 	mutex_unlock(&monc->mutex);
 
 	err = wait_for_completion_interruptible(&req->completion);
@@ -684,8 +684,8 @@ static void __resend_generic_request(struct ceph_mon_client *monc)
 
 	for (p = rb_first(&monc->generic_request_tree); p; p = rb_next(p)) {
 		req = rb_entry(p, struct ceph_mon_generic_request, node);
-		ceph_con_revoke(monc->con, req->request);
-		ceph_con_send(monc->con, ceph_msg_get(req->request));
+		ceph_con_revoke(&monc->con, req->request);
+		ceph_con_send(&monc->con, ceph_msg_get(req->request));
 	}
 }
 
@@ -705,7 +705,7 @@ static void delayed_work(struct work_struct *work)
 		__close_session(monc);
 		__open_session(monc);  /* continue hunting */
 	} else {
-		ceph_con_keepalive(monc->con);
+		ceph_con_keepalive(&monc->con);
 
 		__validate_auth(monc);
 
@@ -760,19 +760,16 @@ int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl)
 		goto out;
 
 	/* connection */
-	monc->con = kmalloc(sizeof(*monc->con), GFP_KERNEL);
-	if (!monc->con)
-		goto out_monmap;
-	ceph_con_init(&monc->client->msgr, monc->con);
-	monc->con->private = monc;
-	monc->con->ops = &mon_con_ops;
+	ceph_con_init(&monc->client->msgr, &monc->con);
+	monc->con.private = monc;
+	monc->con.ops = &mon_con_ops;
 
 	/* authentication */
 	monc->auth = ceph_auth_init(cl->options->name,
 				    cl->options->key);
 	if (IS_ERR(monc->auth)) {
 		err = PTR_ERR(monc->auth);
-		goto out_con;
+		goto out_monmap;
 	}
 	monc->auth->want_keys =
 		CEPH_ENTITY_TYPE_AUTH | CEPH_ENTITY_TYPE_MON |
@@ -824,8 +821,6 @@ out_subscribe_ack:
 	ceph_msg_put(monc->m_subscribe_ack);
 out_auth:
 	ceph_auth_destroy(monc->auth);
-out_con:
-	monc->con->ops->put(monc->con);
 out_monmap:
 	kfree(monc->monmap);
 out:
@@ -841,9 +836,7 @@ void ceph_monc_stop(struct ceph_mon_client *monc)
 	mutex_lock(&monc->mutex);
 	__close_session(monc);
 
-	monc->con->private = NULL;
-	monc->con->ops->put(monc->con);
-	monc->con = NULL;
+	monc->con.private = NULL;
 
 	mutex_unlock(&monc->mutex);
 
@@ -1029,7 +1022,7 @@ static void mon_fault(struct ceph_connection *con)
 	if (!monc->hunting)
 		pr_info("mon%d %s session lost, "
 			"hunting for new mon\n", monc->cur_mon,
-			ceph_pr_addr(&monc->con->peer_addr.in_addr));
+			ceph_pr_addr(&monc->con.peer_addr.in_addr));
 
 	__close_session(monc);
 	if (!monc->hunting) {
-- 
1.7.9.5

