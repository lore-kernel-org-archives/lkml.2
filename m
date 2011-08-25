Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1HYPQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:16:39 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35601 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab1HYPKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:00 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 094/118] drbd: Converted drbd_free_sock() and drbd_disconnect() from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:30 +0200
Message-Id: <1314284934-17999-95-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_main.c     |   30 +++++++-------
 drivers/block/drbd/drbd_receiver.c |   72 ++++++++++++++++++++---------------
 3 files changed, 57 insertions(+), 47 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 70509c5..388dc1d 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1164,7 +1164,7 @@ extern void tl_release(struct drbd_conf *mdev, unsigned int barrier_nr,
 		       unsigned int set_size);
 extern void tl_clear(struct drbd_conf *mdev);
 extern void _tl_add_barrier(struct drbd_conf *, struct drbd_tl_epoch *);
-extern void drbd_free_sock(struct drbd_conf *mdev);
+extern void drbd_free_sock(struct drbd_tconn *tconn);
 extern int drbd_send(struct drbd_tconn *tconn, struct socket *sock,
 		     void *buf, size_t size, unsigned msg_flags);
 extern int drbd_send_protocol(struct drbd_tconn *tconn);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 7612394..b427c1a 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2443,21 +2443,21 @@ void drbd_free_bc(struct drbd_backing_dev *ldev)
 	kfree(ldev);
 }
 
-void drbd_free_sock(struct drbd_conf *mdev)
+void drbd_free_sock(struct drbd_tconn *tconn)
 {
-	if (mdev->tconn->data.socket) {
-		mutex_lock(&mdev->tconn->data.mutex);
-		kernel_sock_shutdown(mdev->tconn->data.socket, SHUT_RDWR);
-		sock_release(mdev->tconn->data.socket);
-		mdev->tconn->data.socket = NULL;
-		mutex_unlock(&mdev->tconn->data.mutex);
+	if (tconn->data.socket) {
+		mutex_lock(&tconn->data.mutex);
+		kernel_sock_shutdown(tconn->data.socket, SHUT_RDWR);
+		sock_release(tconn->data.socket);
+		tconn->data.socket = NULL;
+		mutex_unlock(&tconn->data.mutex);
 	}
-	if (mdev->tconn->meta.socket) {
-		mutex_lock(&mdev->tconn->meta.mutex);
-		kernel_sock_shutdown(mdev->tconn->meta.socket, SHUT_RDWR);
-		sock_release(mdev->tconn->meta.socket);
-		mdev->tconn->meta.socket = NULL;
-		mutex_unlock(&mdev->tconn->meta.mutex);
+	if (tconn->meta.socket) {
+		mutex_lock(&tconn->meta.mutex);
+		kernel_sock_shutdown(tconn->meta.socket, SHUT_RDWR);
+		sock_release(tconn->meta.socket);
+		tconn->meta.socket = NULL;
+		mutex_unlock(&tconn->meta.mutex);
 	}
 }
 
@@ -2475,7 +2475,7 @@ void drbd_free_resources(struct drbd_conf *mdev)
 	crypto_free_hash(mdev->tconn->integrity_r_tfm);
 	mdev->tconn->integrity_r_tfm = NULL;
 
-	drbd_free_sock(mdev);
+	drbd_free_sock(mdev->tconn);
 
 	__no_warn(local,
 		  drbd_free_bc(mdev->ldev);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 1d6df7a..c280fa8 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -62,6 +62,7 @@ enum finish_epoch {
 
 static int drbd_do_handshake(struct drbd_tconn *tconn);
 static int drbd_do_auth(struct drbd_tconn *tconn);
+static int drbd_disconnected(int vnr, void *p, void *data);
 
 static enum finish_epoch drbd_may_finish_epoch(struct drbd_conf *, struct drbd_epoch *, enum epoch_event);
 static int e_end_block(struct drbd_conf *, struct drbd_work *, int);
@@ -3832,19 +3833,49 @@ void drbd_flush_workqueue(struct drbd_tconn *tconn)
 	wait_for_completion(&barr.done);
 }
 
-static void drbd_disconnect(struct drbd_conf *mdev)
+static void drbd_disconnect(struct drbd_tconn *tconn)
 {
-	enum drbd_fencing_p fp;
 	union drbd_state os, ns;
 	int rv = SS_UNKNOWN_ERROR;
-	unsigned int i;
 
-	if (mdev->state.conn == C_STANDALONE)
+	if (tconn->volume0->state.conn == C_STANDALONE)
 		return;
 
 	/* asender does not clean up anything. it must not interfere, either */
-	drbd_thread_stop(&mdev->tconn->asender);
-	drbd_free_sock(mdev);
+	drbd_thread_stop(&tconn->asender);
+	drbd_free_sock(tconn);
+
+	idr_for_each(&tconn->volumes, drbd_disconnected, tconn);
+
+	conn_info(tconn, "Connection closed\n");
+
+	spin_lock_irq(&tconn->req_lock);
+	os = tconn->volume0->state;
+	if (os.conn >= C_UNCONNECTED) {
+		/* Do not restart in case we are C_DISCONNECTING */
+		ns.i = os.i;
+		ns.conn = C_UNCONNECTED;
+		rv = _drbd_set_state(tconn->volume0, ns, CS_VERBOSE, NULL);
+	}
+	spin_unlock_irq(&tconn->req_lock);
+
+	if (os.conn == C_DISCONNECTING) {
+		wait_event(tconn->net_cnt_wait, atomic_read(&tconn->net_cnt) == 0);
+
+		crypto_free_hash(tconn->cram_hmac_tfm);
+		tconn->cram_hmac_tfm = NULL;
+
+		kfree(tconn->net_conf);
+		tconn->net_conf = NULL;
+		drbd_request_state(tconn->volume0, NS(conn, C_STANDALONE));
+	}
+}
+
+static int drbd_disconnected(int vnr, void *p, void *data)
+{
+	struct drbd_conf *mdev = (struct drbd_conf *)p;
+	enum drbd_fencing_p fp;
+	unsigned int i;
 
 	/* wait for current activity to cease. */
 	spin_lock_irq(&mdev->tconn->req_lock);
@@ -3890,8 +3921,6 @@ static void drbd_disconnect(struct drbd_conf *mdev)
 	if (!is_susp(mdev->state))
 		tl_clear(mdev);
 
-	dev_info(DEV, "Connection closed\n");
-
 	drbd_md_sync(mdev);
 
 	fp = FP_DONT_CARE;
@@ -3903,27 +3932,6 @@ static void drbd_disconnect(struct drbd_conf *mdev)
 	if (mdev->state.role == R_PRIMARY && fp >= FP_RESOURCE && mdev->state.pdsk >= D_UNKNOWN)
 		drbd_try_outdate_peer_async(mdev);
 
-	spin_lock_irq(&mdev->tconn->req_lock);
-	os = mdev->state;
-	if (os.conn >= C_UNCONNECTED) {
-		/* Do not restart in case we are C_DISCONNECTING */
-		ns = os;
-		ns.conn = C_UNCONNECTED;
-		rv = _drbd_set_state(mdev, ns, CS_VERBOSE, NULL);
-	}
-	spin_unlock_irq(&mdev->tconn->req_lock);
-
-	if (os.conn == C_DISCONNECTING) {
-		wait_event(mdev->tconn->net_cnt_wait, atomic_read(&mdev->tconn->net_cnt) == 0);
-
-		crypto_free_hash(mdev->tconn->cram_hmac_tfm);
-		mdev->tconn->cram_hmac_tfm = NULL;
-
-		kfree(mdev->tconn->net_conf);
-		mdev->tconn->net_conf = NULL;
-		drbd_request_state(mdev, NS(conn, C_STANDALONE));
-	}
-
 	/* serialize with bitmap writeout triggered by the state change,
 	 * if any. */
 	wait_event(mdev->misc_wait, !test_bit(BITMAP_IO, &mdev->flags));
@@ -3953,6 +3961,8 @@ static void drbd_disconnect(struct drbd_conf *mdev)
 	/* ok, no more ee's on the fly, it is safe to reset the epoch_size */
 	atomic_set(&mdev->current_epoch->epoch_size, 0);
 	D_ASSERT(list_empty(&mdev->current_epoch->list));
+
+	return 0;
 }
 
 /*
@@ -4229,7 +4239,7 @@ int drbdd_init(struct drbd_thread *thi)
 	do {
 		h = drbd_connect(mdev->tconn);
 		if (h == 0) {
-			drbd_disconnect(mdev);
+			drbd_disconnect(mdev->tconn);
 			schedule_timeout_interruptible(HZ);
 		}
 		if (h == -1) {
@@ -4245,7 +4255,7 @@ int drbdd_init(struct drbd_thread *thi)
 		}
 	}
 
-	drbd_disconnect(mdev);
+	drbd_disconnect(mdev->tconn);
 
 	dev_info(DEV, "receiver terminated\n");
 	return 0;
-- 
1.7.4.1

