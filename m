Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab1HYPJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:09:19 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32955 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1HYPJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:13 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 036/118] drbd: Made drbd_flush_workqueue() to take a tconn instead of an mdev
Date: Thu, 25 Aug 2011 17:07:32 +0200
Message-Id: <1314284934-17999-37-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_nl.c       |    6 +++---
 drivers/block/drbd/drbd_receiver.c |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 65f0e78..75c760f 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1609,7 +1609,7 @@ extern void _drbd_wait_ee_list_empty(struct drbd_conf *mdev,
 		struct list_head *head);
 extern void drbd_set_recv_tcq(struct drbd_conf *mdev, int tcq_enabled);
 extern void _drbd_clear_done_ee(struct drbd_conf *mdev, struct list_head *to_be_freed);
-extern void drbd_flush_workqueue(struct drbd_conf *mdev);
+extern void drbd_flush_workqueue(struct drbd_tconn *tconn);
 
 /* yes, there is kernel_setsockopt, but only since 2.6.18. we don't need to
  * mess with get_fs/set_fs, we know we are KERNEL_DS always. */
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 0836808..8b8894e 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -876,7 +876,7 @@ static void drbd_reconfig_start(struct drbd_conf *mdev)
 	wait_event(mdev->state_wait, !test_and_set_bit(CONFIG_PENDING, &mdev->flags));
 	wait_event(mdev->state_wait, !test_bit(DEVICE_DYING, &mdev->flags));
 	drbd_thread_start(&mdev->tconn->worker);
-	drbd_flush_workqueue(mdev);
+	drbd_flush_workqueue(mdev->tconn);
 }
 
 /* if still unconfigured, stops worker again.
@@ -1076,7 +1076,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	/* also wait for the last barrier ack. */
 	wait_event(mdev->misc_wait, !atomic_read(&mdev->ap_pending_cnt) || is_susp(mdev->state));
 	/* and for any other previously queued work */
-	drbd_flush_workqueue(mdev);
+	drbd_flush_workqueue(mdev->tconn);
 
 	rv = _drbd_request_state(mdev, NS(disk, D_ATTACHING), CS_VERBOSE);
 	retcode = rv;  /* FIXME: Type mismatch. */
@@ -1520,7 +1520,7 @@ static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 		}
 	}
 
-	drbd_flush_workqueue(mdev);
+	drbd_flush_workqueue(mdev->tconn);
 	spin_lock_irq(&mdev->tconn->req_lock);
 	if (mdev->tconn->net_conf != NULL) {
 		retcode = ERR_NET_CONFIGURED;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 4b37010..fbf9382 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3747,13 +3747,13 @@ static void drbdd(struct drbd_conf *mdev)
 	drbd_md_sync(mdev);
 }
 
-void drbd_flush_workqueue(struct drbd_conf *mdev)
+void drbd_flush_workqueue(struct drbd_tconn *tconn)
 {
 	struct drbd_wq_barrier barr;
 
 	barr.w.cb = w_prev_work_done;
 	init_completion(&barr.done);
-	drbd_queue_work(&mdev->tconn->data.work, &barr.w);
+	drbd_queue_work(&tconn->data.work, &barr.w);
 	wait_for_completion(&barr.done);
 }
 
@@ -3803,7 +3803,7 @@ static void drbd_disconnect(struct drbd_conf *mdev)
 	/* wait for all w_e_end_data_req, w_e_end_rsdata_req, w_send_barrier,
 	 * w_make_resync_request etc. which may still be on the worker queue
 	 * to be "canceled" */
-	drbd_flush_workqueue(mdev);
+	drbd_flush_workqueue(mdev->tconn);
 
 	/* This also does reclaim_net_ee().  If we do this too early, we might
 	 * miss some resync ee and pages.*/
-- 
1.7.4.1

