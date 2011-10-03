Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab1JCU7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:59:19 -0400
Received: from mail09.linbit.com ([212.69.161.110]:41597 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581Ab1JCU6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:58:37 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/10] drbd: Removed the OBJECT_DYING and the CONFIG_PENDING bits
Date: Mon,  3 Oct 2011 22:58:31 +0200
Message-Id: <1317675513-12745-9-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317675513-12745-1-git-send-email-philipp.reisner@linbit.com>
References: <1317675513-12745-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

superseded by refcounting

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h    |    6 ------
 drivers/block/drbd/drbd_nl.c     |   20 +++-----------------
 drivers/block/drbd/drbd_state.c  |   16 +---------------
 drivers/block/drbd/drbd_worker.c |    3 ---
 4 files changed, 4 insertions(+), 41 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 7797879..28e7ecc 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -816,12 +816,6 @@ enum {
 	GOT_PING_ACK,		/* set when we receive a ping_ack packet, ping_wait gets woken */
 	CONN_WD_ST_CHG_OKAY,
 	CONN_WD_ST_CHG_FAIL,
-	CONFIG_PENDING,		/* serialization of (re)configuration requests.
-				 * if set, also prevents the device from dying */
-	OBJECT_DYING,		/* device became unconfigured,
-				 * but worker thread is still handling the cleanup.
-				 * reconfiguring (nl_disk_conf, nl_net_conf) is dissalowed,
-				 * while this is set. */
 	CONN_DRY_RUN,		/* Expect disconnect after resync handshake. */
 };
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 3d03114..7926491 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1062,34 +1062,20 @@ void drbd_reconsider_max_bio_size(struct drbd_conf *mdev)
 	drbd_setup_queue_param(mdev, new);
 }
 
-/* serialize deconfig (worker exiting, doing cleanup)
- * and reconfig (drbdsetup disk, drbdsetup net)
- *
- * Wait for a potentially exiting worker, then restart it,
- * or start a new one.  Flush any pending work, there may still be an
- * after_state_change queued.
- */
+/* Starts the worker thread */
 static void conn_reconfig_start(struct drbd_tconn *tconn)
 {
-	wait_event(tconn->ping_wait, !test_and_set_bit(CONFIG_PENDING, &tconn->flags));
-	wait_event(tconn->ping_wait, !test_bit(OBJECT_DYING, &tconn->flags));
 	drbd_thread_start(&tconn->worker);
 	conn_flush_workqueue(tconn);
 }
 
-/* if still unconfigured, stops worker again.
- * if configured now, clears CONFIG_PENDING.
- * wakes potential waiters */
+/* if still unconfigured, stops worker again. */
 static void conn_reconfig_done(struct drbd_tconn *tconn)
 {
 	spin_lock_irq(&tconn->req_lock);
-	if (conn_all_vols_unconf(tconn)) {
-		set_bit(OBJECT_DYING, &tconn->flags);
+	if (conn_all_vols_unconf(tconn))
 		drbd_thread_stop_nowait(&tconn->worker);
-	} else
-		clear_bit(CONFIG_PENDING, &tconn->flags);
 	spin_unlock_irq(&tconn->req_lock);
-	wake_up(&tconn->ping_wait);
 }
 
 /* Make sure IO is suspended before calling this function(). */
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 054b698..4465be8 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -908,18 +908,6 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 	mdev->tconn->susp_nod = ns.susp_nod;
 	mdev->tconn->susp_fen = ns.susp_fen;
 
-	/* solve the race between becoming unconfigured,
-	 * worker doing the cleanup, and
-	 * admin reconfiguring us:
-	 * on (re)configure, first set CONFIG_PENDING,
-	 * then wait for a potentially exiting worker,
-	 * start the worker, and schedule one no_op.
-	 * then proceed with configuration.
-	 */
-	if(conn_all_vols_unconf(mdev->tconn) &&
-	   !test_and_set_bit(CONFIG_PENDING, &mdev->tconn->flags))
-		set_bit(OBJECT_DYING, &mdev->tconn->flags);
-
 	if (os.disk == D_ATTACHING && ns.disk >= D_NEGOTIATING)
 		drbd_print_uuids(mdev, "attached to UUIDs");
 
@@ -1383,10 +1371,8 @@ struct after_conn_state_chg_work {
 
 static void after_all_state_ch(struct drbd_tconn *tconn)
 {
-	if (conn_all_vols_unconf(tconn) &&
-	    test_bit(OBJECT_DYING, &tconn->flags)) {
+	if (conn_all_vols_unconf(tconn))
 		drbd_thread_stop_nowait(&tconn->worker);
-	}
 }
 
 static int w_after_conn_state_ch(struct drbd_work *w, int unused)
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 4e14133..a8aa667 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1756,9 +1756,6 @@ int drbd_worker(struct drbd_thread *thi)
 		drbd_mdev_cleanup(mdev);
 	}
 	up_read(&drbd_cfg_rwsem);
-	clear_bit(OBJECT_DYING, &tconn->flags);
-	clear_bit(CONFIG_PENDING, &tconn->flags);
-	wake_up(&tconn->ping_wait);
 
 	return 0;
 }
-- 
1.7.4.1

