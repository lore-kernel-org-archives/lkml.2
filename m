Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab1HYPdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:33:45 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32976 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab1HYPJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:06 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 022/118] drbd: Convert all constants in enum drbd_thread_state to upper case
Date: Thu, 25 Aug 2011 17:07:18 +0200
Message-Id: <1314284934-17999-23-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    8 +++---
 drivers/block/drbd/drbd_main.c     |   38 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_receiver.c |    6 ++--
 drivers/block/drbd/drbd_worker.c   |    8 +++---
 4 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 0d5c727..bb08714 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -649,10 +649,10 @@ union p_polymorph {
 
 /**********************************************************************/
 enum drbd_thread_state {
-	None,
-	Running,
-	Exiting,
-	Restarting
+	NONE,
+	RUNNING,
+	EXITING,
+	RESTARTING
 };
 
 struct drbd_thread {
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c5bb871..19176a1 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1627,25 +1627,25 @@ restart:
 
 	spin_lock_irqsave(&thi->t_lock, flags);
 
-	/* if the receiver has been "Exiting", the last thing it did
+	/* if the receiver has been "EXITING", the last thing it did
 	 * was set the conn state to "StandAlone",
 	 * if now a re-connect request comes in, conn state goes C_UNCONNECTED,
 	 * and receiver thread will be "started".
-	 * drbd_thread_start needs to set "Restarting" in that case.
+	 * drbd_thread_start needs to set "RESTARTING" in that case.
 	 * t_state check and assignment needs to be within the same spinlock,
-	 * so either thread_start sees Exiting, and can remap to Restarting,
-	 * or thread_start see None, and can proceed as normal.
+	 * so either thread_start sees EXITING, and can remap to RESTARTING,
+	 * or thread_start see NONE, and can proceed as normal.
 	 */
 
-	if (thi->t_state == Restarting) {
+	if (thi->t_state == RESTARTING) {
 		dev_info(DEV, "Restarting %s\n", current->comm);
-		thi->t_state = Running;
+		thi->t_state = RUNNING;
 		spin_unlock_irqrestore(&thi->t_lock, flags);
 		goto restart;
 	}
 
 	thi->task = NULL;
-	thi->t_state = None;
+	thi->t_state = NONE;
 	smp_mb();
 	complete(&thi->stop);
 	spin_unlock_irqrestore(&thi->t_lock, flags);
@@ -1662,7 +1662,7 @@ static void drbd_thread_init(struct drbd_conf *mdev, struct drbd_thread *thi,
 {
 	spin_lock_init(&thi->t_lock);
 	thi->task    = NULL;
-	thi->t_state = None;
+	thi->t_state = NONE;
 	thi->function = func;
 	thi->mdev = mdev;
 }
@@ -1683,7 +1683,7 @@ int drbd_thread_start(struct drbd_thread *thi)
 	spin_lock_irqsave(&thi->t_lock, flags);
 
 	switch (thi->t_state) {
-	case None:
+	case NONE:
 		dev_info(DEV, "Starting %s thread (from %s [%d])\n",
 				me, current->comm, current->pid);
 
@@ -1697,7 +1697,7 @@ int drbd_thread_start(struct drbd_thread *thi)
 		init_completion(&thi->stop);
 		D_ASSERT(thi->task == NULL);
 		thi->reset_cpu_mask = 1;
-		thi->t_state = Running;
+		thi->t_state = RUNNING;
 		spin_unlock_irqrestore(&thi->t_lock, flags);
 		flush_signals(current); /* otherw. may get -ERESTARTNOINTR */
 
@@ -1712,17 +1712,17 @@ int drbd_thread_start(struct drbd_thread *thi)
 		}
 		spin_lock_irqsave(&thi->t_lock, flags);
 		thi->task = nt;
-		thi->t_state = Running;
+		thi->t_state = RUNNING;
 		spin_unlock_irqrestore(&thi->t_lock, flags);
 		wake_up_process(nt);
 		break;
-	case Exiting:
-		thi->t_state = Restarting;
+	case EXITING:
+		thi->t_state = RESTARTING;
 		dev_info(DEV, "Restarting %s thread (from %s [%d])\n",
 				me, current->comm, current->pid);
 		/* fall through */
-	case Running:
-	case Restarting:
+	case RUNNING:
+	case RESTARTING:
 	default:
 		spin_unlock_irqrestore(&thi->t_lock, flags);
 		break;
@@ -1736,12 +1736,12 @@ void _drbd_thread_stop(struct drbd_thread *thi, int restart, int wait)
 {
 	unsigned long flags;
 
-	enum drbd_thread_state ns = restart ? Restarting : Exiting;
+	enum drbd_thread_state ns = restart ? RESTARTING : EXITING;
 
 	/* may be called from state engine, holding the req lock irqsave */
 	spin_lock_irqsave(&thi->t_lock, flags);
 
-	if (thi->t_state == None) {
+	if (thi->t_state == NONE) {
 		spin_unlock_irqrestore(&thi->t_lock, flags);
 		if (restart)
 			drbd_thread_start(thi);
@@ -2504,7 +2504,7 @@ static int we_should_drop_the_connection(struct drbd_conf *mdev, struct socket *
 
 	drop_it =   mdev->meta.socket == sock
 		|| !mdev->asender.task
-		|| get_t_state(&mdev->asender) != Running
+		|| get_t_state(&mdev->asender) != RUNNING
 		|| mdev->state.conn < C_CONNECTED;
 
 	if (drop_it)
@@ -3046,7 +3046,7 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 void drbd_mdev_cleanup(struct drbd_conf *mdev)
 {
 	int i;
-	if (mdev->receiver.t_state != None)
+	if (mdev->receiver.t_state != NONE)
 		dev_err(DEV, "ASSERT FAILED: receiver t_state == %d expected 0.\n",
 				mdev->receiver.t_state);
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 1762ef0..1cfcc44 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -833,7 +833,7 @@ retry:
 		if (signal_pending(current)) {
 			flush_signals(current);
 			smp_rmb();
-			if (get_t_state(&mdev->receiver) == Exiting)
+			if (get_t_state(&mdev->receiver) == EXITING)
 				goto out_release_sockets;
 		}
 
@@ -3700,7 +3700,7 @@ static void drbdd(struct drbd_conf *mdev)
 	size_t shs; /* sub header size */
 	int rv;
 
-	while (get_t_state(&mdev->receiver) == Running) {
+	while (get_t_state(&mdev->receiver) == RUNNING) {
 		drbd_thread_current_set_cpu(mdev);
 		if (!drbd_recv_header(mdev, &cmd, &packet_size))
 			goto err_out;
@@ -4490,7 +4490,7 @@ int drbd_asender(struct drbd_thread *thi)
 	current->policy = SCHED_RR;  /* Make this a realtime task! */
 	current->rt_priority = 2;    /* more important than all other tasks */
 
-	while (get_t_state(thi) == Running) {
+	while (get_t_state(thi) == RUNNING) {
 		drbd_thread_current_set_cpu(mdev);
 		if (test_and_clear_bit(SEND_PING, &mdev->flags)) {
 			ERR_IF(!drbd_send_ping(mdev)) goto reconnect;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 550617b..c2a9285 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1617,7 +1617,7 @@ int drbd_worker(struct drbd_thread *thi)
 
 	sprintf(current->comm, "drbd%d_worker", mdev_to_minor(mdev));
 
-	while (get_t_state(thi) == Running) {
+	while (get_t_state(thi) == RUNNING) {
 		drbd_thread_current_set_cpu(mdev);
 
 		if (down_trylock(&mdev->data.work.s)) {
@@ -1637,12 +1637,12 @@ int drbd_worker(struct drbd_thread *thi)
 		if (intr) {
 			D_ASSERT(intr == -EINTR);
 			flush_signals(current);
-			ERR_IF (get_t_state(thi) == Running)
+			ERR_IF (get_t_state(thi) == RUNNING)
 				continue;
 			break;
 		}
 
-		if (get_t_state(thi) != Running)
+		if (get_t_state(thi) != RUNNING)
 			break;
 		/* With this break, we have done a down() but not consumed
 		   the entry from the list. The cleanup code takes care of
@@ -1704,7 +1704,7 @@ int drbd_worker(struct drbd_thread *thi)
 
 	D_ASSERT(mdev->state.disk == D_DISKLESS && mdev->state.conn == C_STANDALONE);
 	/* _drbd_set_state only uses stop_nowait.
-	 * wait here for the Exiting receiver. */
+	 * wait here for the EXITING receiver. */
 	drbd_thread_stop(&mdev->receiver);
 	drbd_mdev_cleanup(mdev);
 
-- 
1.7.4.1

