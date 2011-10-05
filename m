Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934250Ab1JEJjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:39:31 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56218 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934216Ab1JEJiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:38:11 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 13/16] drbd: fix thread stop deadlock
Date: Wed,  5 Oct 2011 11:38:01 +0200
Message-Id: <1317807484-24628-14-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
References: <1317807484-24628-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

There are races where the receiver may be exiting,
but still need the worker to process some stuff.

Do not wait for the receiver to die from an exiting worker.
The receiver must already be dead in case the worker decides to exit.
If the receiver was still alive, it may still want to queue work, and do
drbd_flush_workqueue() from it's disconnect cleanup code,
which would no longer be processed by an exiting worker.

This also would deadlock,
if the worker was to synchornously wait for the receiver to die.

Do not implicitly stop the worker.
The worker will only be stopped from configuration context, from
conn_reconfig_done(), drbd_adm_down() or drbd_adm_delete_connection(),
after making sure the receiver is already stopped.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c   |    2 +-
 drivers/block/drbd/drbd_nl.c     |   14 ++++++++++----
 drivers/block/drbd/drbd_state.c  |   14 --------------
 drivers/block/drbd/drbd_worker.c |    4 ----
 4 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 1ea12d4..e0342d0 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -503,7 +503,7 @@ restart:
 	thi->task = NULL;
 	thi->t_state = NONE;
 	smp_mb();
-	complete(&thi->stop);
+	complete_all(&thi->stop);
 	spin_unlock_irqrestore(&thi->t_lock, flags);
 
 	conn_info(tconn, "Terminating %s\n", current->comm);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 455b9a9..019f762 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1072,10 +1072,16 @@ static void conn_reconfig_start(struct drbd_tconn *tconn)
 /* if still unconfigured, stops worker again. */
 static void conn_reconfig_done(struct drbd_tconn *tconn)
 {
+	bool stop_threads;
 	spin_lock_irq(&tconn->req_lock);
-	if (conn_all_vols_unconf(tconn))
-		drbd_thread_stop_nowait(&tconn->worker);
+	stop_threads = conn_all_vols_unconf(tconn);
 	spin_unlock_irq(&tconn->req_lock);
+	if (stop_threads) {
+		/* asender is implicitly stopped by receiver
+		 * in drbd_disconnect() */
+		drbd_thread_stop(&tconn->receiver);
+		drbd_thread_stop(&tconn->worker);
+	}
 }
 
 /* Make sure IO is suspended before calling this function(). */
@@ -3169,7 +3175,6 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 
 	/* delete connection */
 	if (conn_lowest_minor(adm_ctx.tconn) < 0) {
-		drbd_thread_stop(&adm_ctx.tconn->worker);
 		list_del(&adm_ctx.tconn->all_tconn);
 		kref_put(&adm_ctx.tconn->kref, &conn_destroy);
 
@@ -3179,7 +3184,6 @@ int drbd_adm_down(struct sk_buff *skb, struct genl_info *info)
 		retcode = ERR_CONN_IN_USE;
 		drbd_msg_put_info("failed to delete connection");
 	}
-
 	up_write(&drbd_cfg_rwsem);
 	goto out;
 out_unlock:
@@ -3210,6 +3214,8 @@ int drbd_adm_delete_connection(struct sk_buff *skb, struct genl_info *info)
 	}
 	up_write(&drbd_cfg_rwsem);
 
+	if (retcode == NO_ERROR)
+		drbd_thread_stop(&adm_ctx.tconn->worker);
 out:
 	drbd_adm_finish(info, retcode);
 	return 0;
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index f2e1535..327a75e 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -41,7 +41,6 @@ extern void _tl_restart(struct drbd_tconn *, enum drbd_req_event what);
 static int w_after_state_ch(struct drbd_work *w, int unused);
 static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags);
-static void after_all_state_ch(struct drbd_tconn *tconn);
 static enum drbd_state_rv is_valid_state(struct drbd_conf *, union drbd_state);
 static enum drbd_state_rv is_valid_soft_transition(union drbd_state, union drbd_state);
 static enum drbd_state_rv is_valid_transition(union drbd_state os, union drbd_state ns);
@@ -1362,8 +1361,6 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 			resume_next_sg(mdev);
 	}
 
-	after_all_state_ch(mdev->tconn);
-
 	drbd_md_sync(mdev);
 }
 
@@ -1375,12 +1372,6 @@ struct after_conn_state_chg_work {
 	enum chg_state_flags flags;
 };
 
-static void after_all_state_ch(struct drbd_tconn *tconn)
-{
-	if (conn_all_vols_unconf(tconn))
-		drbd_thread_stop_nowait(&tconn->worker);
-}
-
 static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 {
 	struct after_conn_state_chg_work *acscw =
@@ -1443,12 +1434,7 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 			spin_unlock_irq(&tconn->req_lock);
 		}
 	}
-
-
-	//conn_err(tconn, STATE_FMT, STATE_ARGS("nms", nms));
-	after_all_state_ch(tconn);
 	kref_put(&tconn->kref, &conn_destroy);
-
 	return 0;
 }
 
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 0eed488..f22288b1 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1744,10 +1744,6 @@ int drbd_worker(struct drbd_thread *thi)
 	 */
 	spin_unlock_irq(&tconn->data.work.q_lock);
 
-	/* _drbd_set_state only uses stop_nowait.
-	 * wait here for the exiting receiver. */
-	drbd_thread_stop(&tconn->receiver);
-
 	down_read(&drbd_cfg_rwsem);
 	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 		D_ASSERT(mdev->state.disk == D_DISKLESS && mdev->state.conn == C_STANDALONE);
-- 
1.7.4.1

