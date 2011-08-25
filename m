Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab1HYPKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:10:15 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32936 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab1HYPKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:08 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 098/118] drbd: Converted drbd_asender() from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:34 +0200
Message-Id: <1314284934-17999-99-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |  125 ++++++++++++++++++++----------------
 1 files changed, 69 insertions(+), 56 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index cc5e937..3434ca9 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -392,9 +392,7 @@ int drbd_release_ee(struct drbd_conf *mdev, struct list_head *list)
 }
 
 
-/*
- * This function is called from _asender only_
- * but see also comments in _req_mod(,BARRIER_ACKED)
+/* See also comments in _req_mod(,BARRIER_ACKED)
  * and receive_Barrier.
  *
  * Move entries from net_ee to done_ee, if ready.
@@ -4558,66 +4556,85 @@ static struct asender_cmd *get_asender_cmd(int cmd)
 	return &asender_tbl[cmd];
 }
 
+static int _drbd_process_done_ee(int vnr, void *p, void *data)
+{
+	struct drbd_conf *mdev = (struct drbd_conf *)p;
+	return !drbd_process_done_ee(mdev);
+}
+
+static int _check_ee_empty(int vnr, void *p, void *data)
+{
+	struct drbd_conf *mdev = (struct drbd_conf *)p;
+	struct drbd_tconn *tconn = mdev->tconn;
+	int not_empty;
+
+	spin_lock_irq(&tconn->req_lock);
+	not_empty = !list_empty(&mdev->done_ee);
+	spin_unlock_irq(&tconn->req_lock);
+
+	return not_empty;
+}
+
+static int tconn_process_done_ee(struct drbd_tconn *tconn)
+{
+	int not_empty, err;
+
+	do {
+		clear_bit(SIGNAL_ASENDER, &tconn->flags);
+		flush_signals(current);
+		err = idr_for_each(&tconn->volumes, _drbd_process_done_ee, NULL);
+		if (err)
+			return err;
+		set_bit(SIGNAL_ASENDER, &tconn->flags);
+		not_empty = idr_for_each(&tconn->volumes, _check_ee_empty, NULL);
+	} while (not_empty);
+
+	return 0;
+}
+
 int drbd_asender(struct drbd_thread *thi)
 {
-	struct drbd_conf *mdev = thi->mdev;
-	struct p_header *h = &mdev->tconn->meta.rbuf.header;
+	struct drbd_tconn *tconn = thi->mdev->tconn;
+	struct p_header *h = &tconn->meta.rbuf.header;
 	struct asender_cmd *cmd = NULL;
 	struct packet_info pi;
-
 	int rv;
 	void *buf    = h;
 	int received = 0;
 	int expect   = sizeof(struct p_header);
 	int ping_timeout_active = 0;
-	int empty;
 
 	current->policy = SCHED_RR;  /* Make this a realtime task! */
 	current->rt_priority = 2;    /* more important than all other tasks */
 
 	while (get_t_state(thi) == RUNNING) {
 		drbd_thread_current_set_cpu(thi);
-		if (test_and_clear_bit(SEND_PING, &mdev->tconn->flags)) {
-			if (!drbd_send_ping(mdev)) {
-				dev_err(DEV, "drbd_send_ping has failed\n");
+		if (test_and_clear_bit(SEND_PING, &tconn->flags)) {
+			if (!drbd_send_ping(tconn->volume0)) {
+				conn_err(tconn, "drbd_send_ping has failed\n");
 				goto reconnect;
 			}
-			mdev->tconn->meta.socket->sk->sk_rcvtimeo =
-				mdev->tconn->net_conf->ping_timeo*HZ/10;
+			tconn->meta.socket->sk->sk_rcvtimeo =
+				tconn->net_conf->ping_timeo*HZ/10;
 			ping_timeout_active = 1;
 		}
 
-		/* conditionally cork;
-		 * it may hurt latency if we cork without much to send */
-		if (!mdev->tconn->net_conf->no_cork &&
-			3 < atomic_read(&mdev->unacked_cnt))
-			drbd_tcp_cork(mdev->tconn->meta.socket);
-		while (1) {
-			clear_bit(SIGNAL_ASENDER, &mdev->tconn->flags);
-			flush_signals(current);
-			if (!drbd_process_done_ee(mdev))
-				goto reconnect;
-			/* to avoid race with newly queued ACKs */
-			set_bit(SIGNAL_ASENDER, &mdev->tconn->flags);
-			spin_lock_irq(&mdev->tconn->req_lock);
-			empty = list_empty(&mdev->done_ee);
-			spin_unlock_irq(&mdev->tconn->req_lock);
-			/* new ack may have been queued right here,
-			 * but then there is also a signal pending,
-			 * and we start over... */
-			if (empty)
-				break;
-		}
+		/* TODO: conditionally cork; it may hurt latency if we cork without
+		   much to send */
+		if (!tconn->net_conf->no_cork)
+			drbd_tcp_cork(tconn->meta.socket);
+		if (tconn_process_done_ee(tconn))
+			goto reconnect;
 		/* but unconditionally uncork unless disabled */
-		if (!mdev->tconn->net_conf->no_cork)
-			drbd_tcp_uncork(mdev->tconn->meta.socket);
+		if (!tconn->net_conf->no_cork)
+			drbd_tcp_uncork(tconn->meta.socket);
 
 		/* short circuit, recv_msg would return EINTR anyways. */
 		if (signal_pending(current))
 			continue;
 
-		rv = drbd_recv_short(mdev->tconn->meta.socket, buf, expect-received, 0);
-		clear_bit(SIGNAL_ASENDER, &mdev->tconn->flags);
+		rv = drbd_recv_short(tconn->meta.socket, buf, expect-received, 0);
+		clear_bit(SIGNAL_ASENDER, &tconn->flags);
 
 		flush_signals(current);
 
@@ -4635,47 +4652,46 @@ int drbd_asender(struct drbd_thread *thi)
 			received += rv;
 			buf	 += rv;
 		} else if (rv == 0) {
-			dev_err(DEV, "meta connection shut down by peer.\n");
+			conn_err(tconn, "meta connection shut down by peer.\n");
 			goto reconnect;
 		} else if (rv == -EAGAIN) {
 			/* If the data socket received something meanwhile,
 			 * that is good enough: peer is still alive. */
-			if (time_after(mdev->tconn->last_received,
-				jiffies - mdev->tconn->meta.socket->sk->sk_rcvtimeo))
+			if (time_after(tconn->last_received,
+				jiffies - tconn->meta.socket->sk->sk_rcvtimeo))
 				continue;
 			if (ping_timeout_active) {
-				dev_err(DEV, "PingAck did not arrive in time.\n");
+				conn_err(tconn, "PingAck did not arrive in time.\n");
 				goto reconnect;
 			}
-			set_bit(SEND_PING, &mdev->tconn->flags);
+			set_bit(SEND_PING, &tconn->flags);
 			continue;
 		} else if (rv == -EINTR) {
 			continue;
 		} else {
-			dev_err(DEV, "sock_recvmsg returned %d\n", rv);
+			conn_err(tconn, "sock_recvmsg returned %d\n", rv);
 			goto reconnect;
 		}
 
 		if (received == expect && cmd == NULL) {
-			if (!decode_header(mdev->tconn, h, &pi))
+			if (!decode_header(tconn, h, &pi))
 				goto reconnect;
 			cmd = get_asender_cmd(pi.cmd);
 			if (unlikely(cmd == NULL)) {
-				dev_err(DEV, "unknown command %d on meta (l: %d)\n",
+				conn_err(tconn, "unknown command %d on meta (l: %d)\n",
 					pi.cmd, pi.size);
 				goto disconnect;
 			}
 			expect = cmd->pkt_size;
 			if (pi.size != expect - sizeof(struct p_header)) {
-				dev_err(DEV, "Wrong packet size on meta (c: %d, l: %d)\n",
+				conn_err(tconn, "Wrong packet size on meta (c: %d, l: %d)\n",
 					pi.cmd, pi.size);
 				goto reconnect;
 			}
 		}
 		if (received == expect) {
-			mdev->tconn->last_received = jiffies;
-			D_ASSERT(cmd != NULL);
-			if (!cmd->process(mdev, pi.cmd))
+			tconn->last_received = jiffies;
+			if (!cmd->process(vnr_to_mdev(tconn, pi.vnr), pi.cmd))
 				goto reconnect;
 
 			/* the idle_timeout (ping-int)
@@ -4692,18 +4708,15 @@ int drbd_asender(struct drbd_thread *thi)
 
 	if (0) {
 reconnect:
-		drbd_force_state(mdev, NS(conn, C_NETWORK_FAILURE));
-		drbd_md_sync(mdev);
+		drbd_force_state(tconn->volume0, NS(conn, C_NETWORK_FAILURE));
 	}
 	if (0) {
 disconnect:
-		drbd_force_state(mdev, NS(conn, C_DISCONNECTING));
-		drbd_md_sync(mdev);
+		drbd_force_state(tconn->volume0, NS(conn, C_DISCONNECTING));
 	}
-	clear_bit(SIGNAL_ASENDER, &mdev->tconn->flags);
+	clear_bit(SIGNAL_ASENDER, &tconn->flags);
 
-	D_ASSERT(mdev->state.conn < C_CONNECTED);
-	dev_info(DEV, "asender terminated\n");
+	conn_info(tconn, "asender terminated\n");
 
 	return 0;
 }
-- 
1.7.4.1

