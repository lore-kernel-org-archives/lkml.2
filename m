Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab1HYPOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:14:42 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32936 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab1HYPKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:11 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 103/118] drbd: Converted drbd_send_ping() and related functions from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:39 +0200
Message-Id: <1314284934-17999-104-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   21 ++++++++++++++-------
 drivers/block/drbd/drbd_main.c     |   17 +++++++++--------
 drivers/block/drbd/drbd_receiver.c |   11 ++++++-----
 drivers/block/drbd/drbd_state.c    |    1 +
 drivers/block/drbd/drbd_worker.c   |   10 ++++++----
 5 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 12f0c5e..9c63b10 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -789,7 +789,6 @@ enum {
 	RESIZE_PENDING,		/* Size change detected locally, waiting for the response from
 				 * the peer, if it changed there as well. */
 	CONN_DRY_RUN,		/* Expect disconnect after resync handshake. */
-	GOT_PING_ACK,		/* set when we receive a ping_ack packet, misc wait gets woken */
 	NEW_CUR_UUID,		/* Create new current UUID when thawing IO */
 	AL_SUSPENDED,		/* Activity logging is currently suspended. */
 	AHEAD_TO_SYNC_SOURCE,   /* Ahead -> SyncSource queued */
@@ -912,6 +911,7 @@ enum {
 	DISCARD_CONCURRENT,	/* Set on one node, cleared on the peer! */
 	SEND_PING,		/* whether asender should send a ping asap */
 	SIGNAL_ASENDER,		/* whether asender wants to be interrupted */
+	GOT_PING_ACK,		/* set when we receive a ping_ack packet, ping_wait gets woken */
 };
 
 struct drbd_tconn {			/* is a resource from the config file */
@@ -924,6 +924,7 @@ struct drbd_tconn {			/* is a resource from the config file */
 	struct net_conf *net_conf;	/* protected by get_net_conf() and put_net_conf() */
 	atomic_t net_cnt;		/* Users of net_conf */
 	wait_queue_head_t net_cnt_wait;
+	wait_queue_head_t ping_wait;		/* Woken upon reception of a ping, and a state change */
 
 	struct drbd_socket data;	/* data/barrier/cstate/parameter packets */
 	struct drbd_socket meta;	/* ping/ack (metadata) packets */
@@ -1179,12 +1180,12 @@ extern int drbd_send_state(struct drbd_conf *mdev);
 extern int _conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct socket *sock,
 			  enum drbd_packet cmd, struct p_header *h, size_t size,
 			  unsigned msg_flags);
+extern int conn_send_cmd(struct drbd_tconn *tconn, int vnr, int use_data_socket,
+			 enum drbd_packet cmd, struct p_header *h, size_t size);
 extern int conn_send_cmd2(struct drbd_tconn *tconn, enum drbd_packet cmd,
 			  char *data, size_t size);
 #define USE_DATA_SOCKET 1
 #define USE_META_SOCKET 0
-extern int drbd_send_cmd(struct drbd_conf *mdev, int use_data_socket,
-			 enum drbd_packet cmd, struct p_header *h, size_t size);
 extern int drbd_send_sync_param(struct drbd_conf *mdev, struct syncer_conf *sc);
 extern int drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr,
 			u32 set_size);
@@ -1885,6 +1886,12 @@ static inline int _drbd_send_cmd(struct drbd_conf *mdev, struct socket *sock,
 	return _conn_send_cmd(mdev->tconn, mdev->vnr, sock, cmd, h, size, msg_flags);
 }
 
+static inline int drbd_send_cmd(struct drbd_conf *mdev, int use_data_socket,
+				enum drbd_packet cmd, struct p_header *h, size_t size)
+{
+	return conn_send_cmd(mdev->tconn, mdev->vnr, use_data_socket, cmd, h, size);
+}
+
 static inline int drbd_send_short_cmd(struct drbd_conf *mdev,
 				      enum drbd_packet cmd)
 {
@@ -1892,16 +1899,16 @@ static inline int drbd_send_short_cmd(struct drbd_conf *mdev,
 	return drbd_send_cmd(mdev, USE_DATA_SOCKET, cmd, &h, sizeof(h));
 }
 
-static inline int drbd_send_ping(struct drbd_conf *mdev)
+static inline int drbd_send_ping(struct drbd_tconn *tconn)
 {
 	struct p_header h;
-	return drbd_send_cmd(mdev, USE_META_SOCKET, P_PING, &h, sizeof(h));
+	return conn_send_cmd(tconn, 0, USE_META_SOCKET, P_PING, &h, sizeof(h));
 }
 
-static inline int drbd_send_ping_ack(struct drbd_conf *mdev)
+static inline int drbd_send_ping_ack(struct drbd_tconn *tconn)
 {
 	struct p_header h;
-	return drbd_send_cmd(mdev, USE_META_SOCKET, P_PING_ACK, &h, sizeof(h));
+	return conn_send_cmd(tconn, 0, USE_META_SOCKET, P_PING_ACK, &h, sizeof(h));
 }
 
 static inline void drbd_thread_stop(struct drbd_thread *thi)
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 3b49d0e..9d6eb74 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -719,29 +719,29 @@ int _conn_send_cmd(struct drbd_tconn *tconn, int vnr, struct socket *sock,
 /* don't pass the socket. we may only look at it
  * when we hold the appropriate socket mutex.
  */
-int drbd_send_cmd(struct drbd_conf *mdev, int use_data_socket,
+int conn_send_cmd(struct drbd_tconn *tconn, int vnr, int use_data_socket,
 		  enum drbd_packet cmd, struct p_header *h, size_t size)
 {
 	int ok = 0;
 	struct socket *sock;
 
 	if (use_data_socket) {
-		mutex_lock(&mdev->tconn->data.mutex);
-		sock = mdev->tconn->data.socket;
+		mutex_lock(&tconn->data.mutex);
+		sock = tconn->data.socket;
 	} else {
-		mutex_lock(&mdev->tconn->meta.mutex);
-		sock = mdev->tconn->meta.socket;
+		mutex_lock(&tconn->meta.mutex);
+		sock = tconn->meta.socket;
 	}
 
 	/* drbd_disconnect() could have called drbd_free_sock()
 	 * while we were waiting in down()... */
 	if (likely(sock != NULL))
-		ok = _drbd_send_cmd(mdev, sock, cmd, h, size, 0);
+		ok = _conn_send_cmd(tconn, vnr, sock, cmd, h, size, 0);
 
 	if (use_data_socket)
-		mutex_unlock(&mdev->tconn->data.mutex);
+		mutex_unlock(&tconn->data.mutex);
 	else
-		mutex_unlock(&mdev->tconn->meta.mutex);
+		mutex_unlock(&tconn->meta.mutex);
 	return ok;
 }
 
@@ -2203,6 +2203,7 @@ struct drbd_tconn *drbd_new_tconn(char *name)
 	spin_lock_init(&tconn->req_lock);
 	atomic_set(&tconn->net_cnt, 0);
 	init_waitqueue_head(&tconn->net_cnt_wait);
+	init_waitqueue_head(&tconn->ping_wait);
 	idr_init(&tconn->volumes);
 
 	drbd_init_workqueue(&tconn->data.work);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 55fc243..113d37f 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4282,16 +4282,17 @@ static int got_RqSReply(struct drbd_conf *mdev, enum drbd_packet cmd)
 
 static int got_Ping(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
-	return drbd_send_ping_ack(mdev);
+	return drbd_send_ping_ack(mdev->tconn);
 
 }
 
 static int got_PingAck(struct drbd_conf *mdev, enum drbd_packet cmd)
 {
+	struct drbd_tconn *tconn = mdev->tconn;
 	/* restore idle timeout */
-	mdev->tconn->meta.socket->sk->sk_rcvtimeo = mdev->tconn->net_conf->ping_int*HZ;
-	if (!test_and_set_bit(GOT_PING_ACK, &mdev->flags))
-		wake_up(&mdev->misc_wait);
+	tconn->meta.socket->sk->sk_rcvtimeo = tconn->net_conf->ping_int*HZ;
+	if (!test_and_set_bit(GOT_PING_ACK, &tconn->flags))
+		wake_up(&tconn->ping_wait);
 
 	return true;
 }
@@ -4613,7 +4614,7 @@ int drbd_asender(struct drbd_thread *thi)
 	while (get_t_state(thi) == RUNNING) {
 		drbd_thread_current_set_cpu(thi);
 		if (test_and_clear_bit(SEND_PING, &tconn->flags)) {
-			if (!drbd_send_ping(tconn->volume0)) {
+			if (!drbd_send_ping(tconn)) {
 				conn_err(tconn, "drbd_send_ping has failed\n");
 				goto reconnect;
 			}
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 30a3a1d..d577715 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -737,6 +737,7 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 
 	wake_up(&mdev->misc_wait);
 	wake_up(&mdev->state_wait);
+	wake_up(&mdev->tconn->ping_wait);
 
 	/* aborted verify run. log the last position */
 	if ((os.conn == C_VERIFY_S || os.conn == C_VERIFY_T) &&
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 418f44a..8539df2 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -730,10 +730,12 @@ static int w_resync_finished(struct drbd_work *w, int cancel)
 
 static void ping_peer(struct drbd_conf *mdev)
 {
-	clear_bit(GOT_PING_ACK, &mdev->flags);
-	request_ping(mdev->tconn);
-	wait_event(mdev->misc_wait,
-		   test_bit(GOT_PING_ACK, &mdev->flags) || mdev->state.conn < C_CONNECTED);
+	struct drbd_tconn *tconn = mdev->tconn;
+
+	clear_bit(GOT_PING_ACK, &tconn->flags);
+	request_ping(tconn);
+	wait_event(tconn->ping_wait,
+		   test_bit(GOT_PING_ACK, &tconn->flags) || mdev->state.conn < C_CONNECTED);
 }
 
 int drbd_resync_finished(struct drbd_conf *mdev)
-- 
1.7.4.1

