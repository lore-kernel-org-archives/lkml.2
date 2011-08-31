Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab1HaPNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:13:09 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59957 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab1HaPLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:11:16 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 09/16] drbd: Reworked the unconfiguring and thread stopping code
Date: Wed, 31 Aug 2011 17:11:01 +0200
Message-Id: <1314803468-1201-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
References: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Moved CONFIG_PENDING and DEVICE_DYING from mdev to tconn.
* Renamed drbd_reconfig_start() and drbd_reconfig_done() to
  conn_reconfig_start() and conn_reconfig_done().

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   18 +++++++----
 drivers/block/drbd/drbd_nl.c       |   40 ++++++++++++--------------
 drivers/block/drbd/drbd_receiver.c |    6 ++--
 drivers/block/drbd/drbd_state.c    |   54 ++++++++++++++++++++++-------------
 drivers/block/drbd/drbd_state.h    |    1 +
 drivers/block/drbd/drbd_worker.c   |   31 ++++++++------------
 6 files changed, 80 insertions(+), 70 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index e065985..d53fb0f 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -787,12 +787,6 @@ enum {
 	GO_DISKLESS,		/* Disk is being detached, on io-error or admin request. */
 	WAS_IO_ERROR,		/* Local disk failed returned IO error */
 	RESYNC_AFTER_NEG,       /* Resync after online grow after the attach&negotiate finished. */
-	CONFIG_PENDING,		/* serialization of (re)configuration requests.
-				 * if set, also prevents the device from dying */
-	DEVICE_DYING,		/* device became unconfigured,
-				 * but worker thread is still handling the cleanup.
-				 * reconfiguring (nl_disk_conf, nl_net_conf) is dissalowed,
-				 * while this is set. */
 	RESIZE_PENDING,		/* Size change detected locally, waiting for the response from
 				 * the peer, if it changed there as well. */
 	CONN_DRY_RUN,		/* Expect disconnect after resync handshake. */
@@ -921,6 +915,12 @@ enum {
 	GOT_PING_ACK,		/* set when we receive a ping_ack packet, ping_wait gets woken */
 	CONN_WD_ST_CHG_OKAY,
 	CONN_WD_ST_CHG_FAIL,
+	CONFIG_PENDING,		/* serialization of (re)configuration requests.
+				 * if set, also prevents the device from dying */
+	OBJECT_DYING,		/* device became unconfigured,
+				 * but worker thread is still handling the cleanup.
+				 * reconfiguring (nl_disk_conf, nl_net_conf) is dissalowed,
+				 * while this is set. */
 };
 
 struct drbd_tconn {			/* is a resource from the config file */
@@ -1574,7 +1574,11 @@ extern void _drbd_wait_ee_list_empty(struct drbd_conf *mdev,
 		struct list_head *head);
 extern void drbd_set_recv_tcq(struct drbd_conf *mdev, int tcq_enabled);
 extern void _drbd_clear_done_ee(struct drbd_conf *mdev, struct list_head *to_be_freed);
-extern void drbd_flush_workqueue(struct drbd_conf *mdev);
+extern void conn_flush_workqueue(struct drbd_tconn *tconn);
+static inline void drbd_flush_workqueue(struct drbd_conf *mdev)
+{
+	conn_flush_workqueue(mdev->tconn);
+}
 
 /* yes, there is kernel_setsockopt, but only since 2.6.18. we don't need to
  * mess with get_fs/set_fs, we know we are KERNEL_DS always. */
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 0168587..8cdfb46 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -871,29 +871,27 @@ void drbd_reconsider_max_bio_size(struct drbd_conf *mdev)
  * or start a new one.  Flush any pending work, there may still be an
  * after_state_change queued.
  */
-static void drbd_reconfig_start(struct drbd_conf *mdev)
+static void conn_reconfig_start(struct drbd_tconn *tconn)
 {
-	wait_event(mdev->state_wait, !test_and_set_bit(CONFIG_PENDING, &mdev->flags));
-	wait_event(mdev->state_wait, !test_bit(DEVICE_DYING, &mdev->flags));
-	drbd_thread_start(&mdev->tconn->worker);
-	drbd_flush_workqueue(mdev);
+	wait_event(tconn->ping_wait, !test_and_set_bit(CONFIG_PENDING, &tconn->flags));
+	wait_event(tconn->ping_wait, !test_bit(OBJECT_DYING, &tconn->flags));
+	drbd_thread_start(&tconn->worker);
+	conn_flush_workqueue(tconn);
 }
 
 /* if still unconfigured, stops worker again.
  * if configured now, clears CONFIG_PENDING.
  * wakes potential waiters */
-static void drbd_reconfig_done(struct drbd_conf *mdev)
+static void conn_reconfig_done(struct drbd_tconn *tconn)
 {
-	spin_lock_irq(&mdev->tconn->req_lock);
-	if (mdev->state.disk == D_DISKLESS &&
-	    mdev->state.conn == C_STANDALONE &&
-	    mdev->state.role == R_SECONDARY) {
-		set_bit(DEVICE_DYING, &mdev->flags);
-		drbd_thread_stop_nowait(&mdev->tconn->worker);
+	spin_lock_irq(&tconn->req_lock);
+	if (conn_all_vols_unconf(tconn)) {
+		set_bit(OBJECT_DYING, &tconn->flags);
+		drbd_thread_stop_nowait(&tconn->worker);
 	} else
-		clear_bit(CONFIG_PENDING, &mdev->flags);
-	spin_unlock_irq(&mdev->tconn->req_lock);
-	wake_up(&mdev->state_wait);
+		clear_bit(CONFIG_PENDING, &tconn->flags);
+	spin_unlock_irq(&tconn->req_lock);
+	wake_up(&tconn->ping_wait);
 }
 
 /* Make sure IO is suspended before calling this function(). */
@@ -933,7 +931,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	enum drbd_state_rv rv;
 	int cp_discovered = 0;
 
-	drbd_reconfig_start(mdev);
+	conn_reconfig_start(mdev->tconn);
 
 	/* if you want to reconfigure, please tear down first */
 	if (mdev->state.disk > D_DISKLESS) {
@@ -1279,7 +1277,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	kobject_uevent(&disk_to_dev(mdev->vdisk)->kobj, KOBJ_CHANGE);
 	put_ldev(mdev);
 	reply->ret_code = retcode;
-	drbd_reconfig_done(mdev);
+	conn_reconfig_done(mdev->tconn);
 	return 0;
 
  force_diskless_dec:
@@ -1300,7 +1298,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	lc_destroy(resync_lru);
 
 	reply->ret_code = retcode;
-	drbd_reconfig_done(mdev);
+	conn_reconfig_done(mdev->tconn);
 	return 0;
 }
 
@@ -1344,7 +1342,7 @@ static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 	void *int_dig_vv = NULL;
 	struct sockaddr *new_my_addr, *new_peer_addr, *taken_addr;
 
-	drbd_reconfig_start(mdev);
+	conn_reconfig_start(mdev->tconn);
 
 	if (mdev->state.conn > C_STANDALONE) {
 		retcode = ERR_NET_CONFIGURED;
@@ -1530,7 +1528,7 @@ static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 
 	kobject_uevent(&disk_to_dev(mdev->vdisk)->kobj, KOBJ_CHANGE);
 	reply->ret_code = retcode;
-	drbd_reconfig_done(mdev);
+	conn_reconfig_done(mdev->tconn);
 	return 0;
 
 fail:
@@ -1543,7 +1541,7 @@ fail:
 	kfree(new_conf);
 
 	reply->ret_code = retcode;
-	drbd_reconfig_done(mdev);
+	conn_reconfig_done(mdev->tconn);
 	return 0;
 }
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 88552e1..b58dc16 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3935,14 +3935,14 @@ static void drbdd(struct drbd_tconn *tconn)
 	}
 }
 
-void drbd_flush_workqueue(struct drbd_conf *mdev)
+void conn_flush_workqueue(struct drbd_tconn *tconn)
 {
 	struct drbd_wq_barrier barr;
 
 	barr.w.cb = w_prev_work_done;
-	barr.w.mdev = mdev;
+	barr.w.tconn = tconn;
 	init_completion(&barr.done);
-	drbd_queue_work(&mdev->tconn->data.work, &barr.w);
+	drbd_queue_work(&tconn->data.work, &barr.w);
 	wait_for_completion(&barr.done);
 }
 
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 61c65f5..febefcc 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -41,13 +41,29 @@ extern void _tl_restart(struct drbd_conf *mdev, enum drbd_req_event what);
 static int w_after_state_ch(struct drbd_work *w, int unused);
 static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags);
-static void after_all_state_ch(struct drbd_tconn *tconn, union drbd_state ns);
+static void after_all_state_ch(struct drbd_tconn *tconn);
 static enum drbd_state_rv is_valid_state(struct drbd_conf *, union drbd_state);
 static enum drbd_state_rv is_valid_soft_transition(union drbd_state, union drbd_state);
 static enum drbd_state_rv is_valid_transition(union drbd_state os, union drbd_state ns);
 static union drbd_state sanitize_state(struct drbd_conf *mdev, union drbd_state ns,
 				       const char **warn_sync_abort);
 
+int conn_all_vols_unconf(struct drbd_tconn *tconn)
+{
+	struct drbd_conf *mdev;
+	int minor, uncfg = 1;
+
+	idr_for_each_entry(&tconn->volumes, mdev, minor) {
+		uncfg &= (mdev->state.disk == D_DISKLESS &&
+			  mdev->state.conn == C_STANDALONE &&
+			  mdev->state.role == R_SECONDARY);
+		if (!uncfg)
+			break;
+	}
+
+	return uncfg;
+}
+
 /**
  * cl_wide_st_chg() - true if the state change is a cluster wide one
  * @mdev:	DRBD device.
@@ -744,20 +760,6 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 
 	print_state_change(mdev, os, ns, flags);
 
-	/* solve the race between becoming unconfigured,
-	 * worker doing the cleanup, and
-	 * admin reconfiguring us:
-	 * on (re)configure, first set CONFIG_PENDING,
-	 * then wait for a potentially exiting worker,
-	 * start the worker, and schedule one no_op.
-	 * then proceed with configuration.
-	 */
-	if (ns.disk == D_DISKLESS &&
-	    ns.conn == C_STANDALONE &&
-	    ns.role == R_SECONDARY &&
-	    !test_and_set_bit(CONFIG_PENDING, &mdev->flags))
-		set_bit(DEVICE_DYING, &mdev->flags);
-
 	/* if we are going -> D_FAILED or D_DISKLESS, grab one extra reference
 	 * on the ldev here, to be sure the transition -> D_DISKLESS resp.
 	 * drbd_ldev_destroy() won't happen before our corresponding
@@ -768,6 +770,18 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 
 	mdev->state = ns;
 
+	/* solve the race between becoming unconfigured,
+	 * worker doing the cleanup, and
+	 * admin reconfiguring us:
+	 * on (re)configure, first set CONFIG_PENDING,
+	 * then wait for a potentially exiting worker,
+	 * start the worker, and schedule one no_op.
+	 * then proceed with configuration.
+	 */
+	if(conn_all_vols_unconf(mdev->tconn) &&
+	   !test_and_set_bit(CONFIG_PENDING, &mdev->tconn->flags))
+		set_bit(OBJECT_DYING, &mdev->tconn->flags);
+
 	if (os.disk == D_ATTACHING && ns.disk >= D_NEGOTIATING)
 		drbd_print_uuids(mdev, "attached to UUIDs");
 
@@ -1236,7 +1250,7 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 			resume_next_sg(mdev);
 	}
 
-	after_all_state_ch(mdev->tconn, ns);
+	after_all_state_ch(mdev->tconn);
 
 	drbd_md_sync(mdev);
 }
@@ -1248,10 +1262,10 @@ struct after_conn_state_chg_work {
 	enum chg_state_flags flags;
 };
 
-static void after_all_state_ch(struct drbd_tconn *tconn, union drbd_state ns)
+static void after_all_state_ch(struct drbd_tconn *tconn)
 {
-	if (ns.disk == D_DISKLESS && ns.conn == C_STANDALONE && ns.role == R_SECONDARY) {
-		/* if (test_bit(DEVICE_DYING, &mdev->flags)) TODO: DEVICE_DYING functionality */
+	if (conn_all_vols_unconf(tconn) &&
+	    test_bit(OBJECT_DYING, &tconn->flags)) {
 		drbd_thread_stop_nowait(&tconn->worker);
 	}
 }
@@ -1271,7 +1285,7 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 		drbd_thread_start(&tconn->receiver);
 
 	//conn_err(tconn, STATE_FMT, STATE_ARGS("nms", nms));
-	after_all_state_ch(tconn, nms);
+	after_all_state_ch(tconn);
 
 	return 1;
 }
diff --git a/drivers/block/drbd/drbd_state.h b/drivers/block/drbd/drbd_state.h
index 5fdbdf0..d9536cd 100644
--- a/drivers/block/drbd/drbd_state.h
+++ b/drivers/block/drbd/drbd_state.h
@@ -91,6 +91,7 @@ conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_s
 		   enum chg_state_flags flags);
 
 extern void drbd_resume_al(struct drbd_conf *mdev);
+extern int conn_all_vols_unconf(struct drbd_tconn *tconn);
 
 /**
  * drbd_request_state() - Reqest a state change
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 8ee5c4f..5cb5ffc 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1643,29 +1643,13 @@ void drbd_start_resync(struct drbd_conf *mdev, enum drbd_conns side)
 	mutex_unlock(mdev->state_mutex);
 }
 
-static int _worker_dying(int vnr, void *p, void *data)
-{
-	struct drbd_conf *mdev = (struct drbd_conf *)p;
-
-	D_ASSERT(mdev->state.disk == D_DISKLESS && mdev->state.conn == C_STANDALONE);
-	/* _drbd_set_state only uses stop_nowait.
-	 * wait here for the exiting receiver. */
-	drbd_thread_stop(&mdev->tconn->receiver);
-	drbd_mdev_cleanup(mdev);
-
-	clear_bit(DEVICE_DYING, &mdev->flags);
-	clear_bit(CONFIG_PENDING, &mdev->flags);
-	wake_up(&mdev->state_wait);
-
-	return 0;
-}
-
 int drbd_worker(struct drbd_thread *thi)
 {
 	struct drbd_tconn *tconn = thi->tconn;
 	struct drbd_work *w = NULL;
+	struct drbd_conf *mdev;
 	LIST_HEAD(work_list);
-	int intr = 0;
+	int minor, intr = 0;
 
 	while (get_t_state(thi) == RUNNING) {
 		drbd_thread_current_set_cpu(thi);
@@ -1749,7 +1733,16 @@ int drbd_worker(struct drbd_thread *thi)
 	 */
 	spin_unlock_irq(&tconn->data.work.q_lock);
 
-	idr_for_each(&tconn->volumes, _worker_dying, NULL);
+	drbd_thread_stop(&tconn->receiver);
+	idr_for_each_entry(&tconn->volumes, mdev, minor) {
+		D_ASSERT(mdev->state.disk == D_DISKLESS && mdev->state.conn == C_STANDALONE);
+		/* _drbd_set_state only uses stop_nowait.
+		 * wait here for the exiting receiver. */
+		drbd_mdev_cleanup(mdev);
+	}
+	clear_bit(OBJECT_DYING, &tconn->flags);
+	clear_bit(CONFIG_PENDING, &tconn->flags);
+	wake_up(&tconn->ping_wait);
 
 	return 0;
 }
-- 
1.7.4.1

