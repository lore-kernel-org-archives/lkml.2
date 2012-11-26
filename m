Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233Ab2KZRIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:08:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47627 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202Ab2KZRIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:08:14 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 134/270] libceph: clean up con flags
Date: Mon, 26 Nov 2012 14:57:04 -0200
Message-Id: <1353949160-26803-135-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 4a8616920860920abaa51193146fe36b38ef09aa upstream.

Rename flags with CON_FLAG prefix, move the definitions into the c file,
and (better) document their meaning.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/ceph/messenger.h |   10 -------
 net/ceph/messenger.c           |   62 +++++++++++++++++++++++-----------------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index dc684f6..9844241 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -107,16 +107,6 @@ struct ceph_msg_pos {
 #define MAX_DELAY_INTERVAL	(5 * 60 * HZ)
 
 /*
- * ceph_connection flag bits
- */
-
-#define LOSSYTX         0  /* we can close channel or drop messages on errors */
-#define KEEPALIVE_PENDING      3
-#define WRITE_PENDING	4  /* we have data ready to send */
-#define SOCK_CLOSED	11 /* socket state changed to closed */
-#define BACKOFF         15
-
-/*
  * A single connection with another host.
  *
  * We maintain a queue of outgoing messages, and some session state to
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 563e46a..b872db5 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -87,6 +87,15 @@
 #define CON_STATE_OPEN          5  /* -> STANDBY, CLOSED */
 #define CON_STATE_STANDBY       6  /* -> PREOPEN, CLOSED */
 
+/*
+ * ceph_connection flag bits
+ */
+#define CON_FLAG_LOSSYTX           0  /* we can close channel or drop
+				       * messages on errors */
+#define CON_FLAG_KEEPALIVE_PENDING 1  /* we need to send a keepalive */
+#define CON_FLAG_WRITE_PENDING	   2  /* we have data ready to send */
+#define CON_FLAG_SOCK_CLOSED	   3  /* socket state changed to closed */
+#define CON_FLAG_BACKOFF           4  /* need to retry queuing delayed work */
 
 /* static tag bytes (protocol control messages) */
 static char tag_msg = CEPH_MSGR_TAG_MSG;
@@ -288,7 +297,7 @@ static void ceph_sock_write_space(struct sock *sk)
 	 * buffer. See net/ipv4/tcp_input.c:tcp_check_space()
 	 * and net/core/stream.c:sk_stream_write_space().
 	 */
-	if (test_bit(WRITE_PENDING, &con->flags)) {
+	if (test_bit(CON_FLAG_WRITE_PENDING, &con->flags)) {
 		if (sk_stream_wspace(sk) >= sk_stream_min_wspace(sk)) {
 			dout("%s %p queueing write work\n", __func__, con);
 			clear_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
@@ -313,7 +322,7 @@ static void ceph_sock_state_change(struct sock *sk)
 	case TCP_CLOSE_WAIT:
 		dout("%s TCP_CLOSE_WAIT\n", __func__);
 		con_sock_state_closing(con);
-		set_bit(SOCK_CLOSED, &con->flags);
+		set_bit(CON_FLAG_SOCK_CLOSED, &con->flags);
 		queue_con(con);
 		break;
 	case TCP_ESTABLISHED:
@@ -449,12 +458,12 @@ static int con_close_socket(struct ceph_connection *con)
 	con->sock = NULL;
 
 	/*
-	 * Forcibly clear the SOCK_CLOSE flag.  It gets set
+	 * Forcibly clear the SOCK_CLOSED flag.  It gets set
 	 * independent of the connection mutex, and we could have
 	 * received a socket close event before we had the chance to
 	 * shut the socket down.
 	 */
-	clear_bit(SOCK_CLOSED, &con->flags);
+	clear_bit(CON_FLAG_SOCK_CLOSED, &con->flags);
 	con_sock_state_closed(con);
 	return rc;
 }
@@ -516,9 +525,9 @@ void ceph_con_close(struct ceph_connection *con)
 	     ceph_pr_addr(&con->peer_addr.in_addr));
 	con->state = CON_STATE_CLOSED;
 
-	clear_bit(LOSSYTX, &con->flags);  /* so we retry next connect */
-	clear_bit(KEEPALIVE_PENDING, &con->flags);
-	clear_bit(WRITE_PENDING, &con->flags);
+	clear_bit(CON_FLAG_LOSSYTX, &con->flags); /* so we retry next connect */
+	clear_bit(CON_FLAG_KEEPALIVE_PENDING, &con->flags);
+	clear_bit(CON_FLAG_WRITE_PENDING, &con->flags);
 
 	reset_connection(con);
 	con->peer_global_seq = 0;
@@ -770,7 +779,7 @@ static void prepare_write_message(struct ceph_connection *con)
 		/* no, queue up footer too and be done */
 		prepare_write_message_footer(con);
 
-	set_bit(WRITE_PENDING, &con->flags);
+	set_bit(CON_FLAG_WRITE_PENDING, &con->flags);
 }
 
 /*
@@ -791,7 +800,7 @@ static void prepare_write_ack(struct ceph_connection *con)
 				&con->out_temp_ack);
 
 	con->out_more = 1;  /* more will follow.. eventually.. */
-	set_bit(WRITE_PENDING, &con->flags);
+	set_bit(CON_FLAG_WRITE_PENDING, &con->flags);
 }
 
 /*
@@ -802,7 +811,7 @@ static void prepare_write_keepalive(struct ceph_connection *con)
 	dout("prepare_write_keepalive %p\n", con);
 	con_out_kvec_reset(con);
 	con_out_kvec_add(con, sizeof (tag_keepalive), &tag_keepalive);
-	set_bit(WRITE_PENDING, &con->flags);
+	set_bit(CON_FLAG_WRITE_PENDING, &con->flags);
 }
 
 /*
@@ -845,7 +854,7 @@ static void prepare_write_banner(struct ceph_connection *con)
 					&con->msgr->my_enc_addr);
 
 	con->out_more = 0;
-	set_bit(WRITE_PENDING, &con->flags);
+	set_bit(CON_FLAG_WRITE_PENDING, &con->flags);
 }
 
 static int prepare_write_connect(struct ceph_connection *con)
@@ -896,7 +905,7 @@ static int prepare_write_connect(struct ceph_connection *con)
 					auth->authorizer_buf);
 
 	con->out_more = 0;
-	set_bit(WRITE_PENDING, &con->flags);
+	set_bit(CON_FLAG_WRITE_PENDING, &con->flags);
 
 	return 0;
 }
@@ -1622,7 +1631,7 @@ static int process_connect(struct ceph_connection *con)
 			le32_to_cpu(con->in_reply.connect_seq));
 
 		if (con->in_reply.flags & CEPH_MSG_CONNECT_LOSSY)
-			set_bit(LOSSYTX, &con->flags);
+			set_bit(CON_FLAG_LOSSYTX, &con->flags);
 
 		con->delay = 0;      /* reset backoff memory */
 
@@ -2061,14 +2070,15 @@ do_next:
 			prepare_write_ack(con);
 			goto more;
 		}
-		if (test_and_clear_bit(KEEPALIVE_PENDING, &con->flags)) {
+		if (test_and_clear_bit(CON_FLAG_KEEPALIVE_PENDING,
+				       &con->flags)) {
 			prepare_write_keepalive(con);
 			goto more;
 		}
 	}
 
 	/* Nothing to do! */
-	clear_bit(WRITE_PENDING, &con->flags);
+	clear_bit(CON_FLAG_WRITE_PENDING, &con->flags);
 	dout("try_write nothing else to write.\n");
 	ret = 0;
 out:
@@ -2241,7 +2251,7 @@ static void con_work(struct work_struct *work)
 
 	mutex_lock(&con->mutex);
 restart:
-	if (test_and_clear_bit(SOCK_CLOSED, &con->flags)) {
+	if (test_and_clear_bit(CON_FLAG_SOCK_CLOSED, &con->flags)) {
 		switch (con->state) {
 		case CON_STATE_CONNECTING:
 			con->error_msg = "connection failed";
@@ -2260,7 +2270,7 @@ restart:
 		goto fault;
 	}
 
-	if (test_and_clear_bit(BACKOFF, &con->flags)) {
+	if (test_and_clear_bit(CON_FLAG_BACKOFF, &con->flags)) {
 		dout("con_work %p backing off\n", con);
 		if (queue_delayed_work(ceph_msgr_wq, &con->work,
 				       round_jiffies_relative(con->delay))) {
@@ -2336,7 +2346,7 @@ static void ceph_fault(struct ceph_connection *con)
 
 	con_close_socket(con);
 
-	if (test_bit(LOSSYTX, &con->flags)) {
+	if (test_bit(CON_FLAG_LOSSYTX, &con->flags)) {
 		dout("fault on LOSSYTX channel, marking CLOSED\n");
 		con->state = CON_STATE_CLOSED;
 		goto out_unlock;
@@ -2356,9 +2366,9 @@ static void ceph_fault(struct ceph_connection *con)
 	/* If there are no messages queued or keepalive pending, place
 	 * the connection in a STANDBY state */
 	if (list_empty(&con->out_queue) &&
-	    !test_bit(KEEPALIVE_PENDING, &con->flags)) {
+	    !test_bit(CON_FLAG_KEEPALIVE_PENDING, &con->flags)) {
 		dout("fault %p setting STANDBY clearing WRITE_PENDING\n", con);
-		clear_bit(WRITE_PENDING, &con->flags);
+		clear_bit(CON_FLAG_WRITE_PENDING, &con->flags);
 		con->state = CON_STATE_STANDBY;
 	} else {
 		/* retry after a delay. */
@@ -2383,7 +2393,7 @@ static void ceph_fault(struct ceph_connection *con)
 			 * that when con_work restarts we schedule the
 			 * delay then.
 			 */
-			set_bit(BACKOFF, &con->flags);
+			set_bit(CON_FLAG_BACKOFF, &con->flags);
 		}
 	}
 
@@ -2440,8 +2450,8 @@ static void clear_standby(struct ceph_connection *con)
 		dout("clear_standby %p and ++connect_seq\n", con);
 		con->state = CON_STATE_PREOPEN;
 		con->connect_seq++;
-		WARN_ON(test_bit(WRITE_PENDING, &con->flags));
-		WARN_ON(test_bit(KEEPALIVE_PENDING, &con->flags));
+		WARN_ON(test_bit(CON_FLAG_WRITE_PENDING, &con->flags));
+		WARN_ON(test_bit(CON_FLAG_KEEPALIVE_PENDING, &con->flags));
 	}
 }
 
@@ -2482,7 +2492,7 @@ void ceph_con_send(struct ceph_connection *con, struct ceph_msg *msg)
 
 	/* if there wasn't anything waiting to send before, queue
 	 * new work */
-	if (test_and_set_bit(WRITE_PENDING, &con->flags) == 0)
+	if (test_and_set_bit(CON_FLAG_WRITE_PENDING, &con->flags) == 0)
 		queue_con(con);
 }
 EXPORT_SYMBOL(ceph_con_send);
@@ -2571,8 +2581,8 @@ void ceph_con_keepalive(struct ceph_connection *con)
 	mutex_lock(&con->mutex);
 	clear_standby(con);
 	mutex_unlock(&con->mutex);
-	if (test_and_set_bit(KEEPALIVE_PENDING, &con->flags) == 0 &&
-	    test_and_set_bit(WRITE_PENDING, &con->flags) == 0)
+	if (test_and_set_bit(CON_FLAG_KEEPALIVE_PENDING, &con->flags) == 0 &&
+	    test_and_set_bit(CON_FLAG_WRITE_PENDING, &con->flags) == 0)
 		queue_con(con);
 }
 EXPORT_SYMBOL(ceph_con_keepalive);
-- 
1.7.9.5

