Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab1HYPO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:14:57 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33049 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab1HYPKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:09 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 101/118] drbd: Moved some initializing code into drbd_new_tconn()
Date: Thu, 25 Aug 2011 17:08:37 +0200
Message-Id: <1314284934-17999-102-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index dca4832..8f04fd0 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1813,17 +1813,9 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 	atomic_set(&mdev->ap_in_flight, 0);
 
 	mutex_init(&mdev->md_io_mutex);
-	mutex_init(&mdev->tconn->data.mutex);
-	mutex_init(&mdev->tconn->meta.mutex);
-	sema_init(&mdev->tconn->data.work.s, 0);
-	sema_init(&mdev->tconn->meta.work.s, 0);
 	mutex_init(&mdev->state_mutex);
 
-	spin_lock_init(&mdev->tconn->data.work.q_lock);
-	spin_lock_init(&mdev->tconn->meta.work.q_lock);
-
 	spin_lock_init(&mdev->al_lock);
-	spin_lock_init(&mdev->tconn->req_lock);
 	spin_lock_init(&mdev->peer_seq_lock);
 	spin_lock_init(&mdev->epoch_lock);
 
@@ -1833,8 +1825,6 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 	INIT_LIST_HEAD(&mdev->read_ee);
 	INIT_LIST_HEAD(&mdev->net_ee);
 	INIT_LIST_HEAD(&mdev->resync_reads);
-	INIT_LIST_HEAD(&mdev->tconn->data.work.q);
-	INIT_LIST_HEAD(&mdev->tconn->meta.work.q);
 	INIT_LIST_HEAD(&mdev->resync_work.list);
 	INIT_LIST_HEAD(&mdev->unplug_work.list);
 	INIT_LIST_HEAD(&mdev->go_diskless.list);
@@ -2191,6 +2181,13 @@ out:
 	return r;
 }
 
+static void drbd_init_workqueue(struct drbd_work_queue* wq)
+{
+	sema_init(&wq->s, 0);
+	spin_lock_init(&wq->q_lock);
+	INIT_LIST_HEAD(&wq->q);
+}
+
 struct drbd_tconn *drbd_new_tconn(char *name)
 {
 	struct drbd_tconn *tconn;
@@ -2203,10 +2200,17 @@ struct drbd_tconn *drbd_new_tconn(char *name)
 	if (!tconn->name)
 		goto fail;
 
+	spin_lock_init(&tconn->req_lock);
 	atomic_set(&tconn->net_cnt, 0);
 	init_waitqueue_head(&tconn->net_cnt_wait);
 	idr_init(&tconn->volumes);
 
+	drbd_init_workqueue(&tconn->data.work);
+	mutex_init(&tconn->data.mutex);
+
+	drbd_init_workqueue(&tconn->meta.work);
+	mutex_init(&tconn->meta.mutex);
+
 	drbd_thread_init(tconn, &tconn->receiver, drbdd_init, "receiver");
 	drbd_thread_init(tconn, &tconn->worker, drbd_worker, "worker");
 	drbd_thread_init(tconn, &tconn->asender, drbd_asender, "asender");
-- 
1.7.4.1

