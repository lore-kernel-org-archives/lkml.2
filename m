Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1HYPKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:10:04 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34374 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab1HYPJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:55 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 090/118] drbd: Use and idr data structure to map volume numbers to mdev pointers
Date: Thu, 25 Aug 2011 17:08:26 +0200
Message-Id: <1314284934-17999-91-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    4 +++-
 drivers/block/drbd/drbd_main.c |   12 +++++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 9bd156a..4ececc3 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -40,6 +40,7 @@
 #include <linux/major.h>
 #include <linux/blkdev.h>
 #include <linux/genhd.h>
+#include <linux/idr.h>
 #include <net/tcp.h>
 #include <linux/lru_cache.h>
 #include <linux/prefetch.h>
@@ -915,8 +916,9 @@ struct drbd_tconn {			/* is a resource from the config file */
 	char *name;			/* Resource name */
 	struct list_head all_tconn;	/* List of all drbd_tconn, prot by global_state_lock */
 	struct drbd_conf *volume0;	/* TODO: Remove me again */
-	unsigned long flags;
+	struct idr volumes;             /* <tconn, vnr> to mdev mapping */
 
+	unsigned long flags;
 	struct net_conf *net_conf;	/* protected by get_net_conf() and put_net_conf() */
 	atomic_t net_cnt;		/* Users of net_conf */
 	wait_queue_head_t net_cnt_wait;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index ca40f0a..d7421b6 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2195,6 +2195,7 @@ struct drbd_tconn *drbd_new_tconn(char *name)
 
 	atomic_set(&tconn->net_cnt, 0);
 	init_waitqueue_head(&tconn->net_cnt_wait);
+	idr_init(&tconn->volumes);
 
 	write_lock_irq(&global_state_lock);
 	list_add(&tconn->all_tconn, &drbd_tconns);
@@ -2214,6 +2215,7 @@ void drbd_free_tconn(struct drbd_tconn *tconn)
 	write_lock_irq(&global_state_lock);
 	list_del(&tconn->all_tconn);
 	write_unlock_irq(&global_state_lock);
+	idr_destroy(&tconn->volumes);
 
 	kfree(tconn->name);
 	kfree(tconn->int_dig_out);
@@ -2228,6 +2230,7 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
 	struct gendisk *disk;
 	struct request_queue *q;
 	char conn_name[9]; /* drbd1234N */
+	int vnr;
 
 	/* GFP_KERNEL, we are outside of all write-out paths */
 	mdev = kzalloc(sizeof(struct drbd_conf), GFP_KERNEL);
@@ -2237,7 +2240,14 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
 	mdev->tconn = drbd_new_tconn(conn_name);
 	if (!mdev->tconn)
 		goto out_no_tconn;
-
+	if (!idr_pre_get(&mdev->tconn->volumes, GFP_KERNEL))
+		goto out_no_cpumask;
+	if (idr_get_new(&mdev->tconn->volumes, mdev, &vnr))
+		goto out_no_cpumask;
+	if (vnr != 0) {
+		dev_err(DEV, "vnr = %d\n", vnr);
+		goto out_no_cpumask;
+	}
 	if (!zalloc_cpumask_var(&mdev->cpu_mask, GFP_KERNEL))
 		goto out_no_cpumask;
 
-- 
1.7.4.1

