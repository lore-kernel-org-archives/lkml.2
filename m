Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab2AVD0Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 22:26:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34431 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2AVDZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 22:25:50 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Date: Sat, 21 Jan 2012 19:25:16 -0800
Message-Id: <1327202725-3383-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327202725-3383-1-git-send-email-tj@kernel.org>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elevator switch may involve changes to blkcg policies.  Shoot down all
blkg's while preparing for elevator switch.  Combined with the
previous bypass updates, this ensures that no blkg exists until
elevator switch is complete and will allow moving blkg management to
blkcg core layer.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |   12 ++++++++++++
 block/blk-cgroup.h   |    6 +++++-
 block/blk-throttle.c |    7 +++++++
 block/cfq-iosched.c  |   11 +++++++++++
 block/elevator.c     |    2 ++
 5 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index cbaad8c..f344b53 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1619,6 +1619,18 @@ done:
 	return &blkcg->css;
 }
 
+void blkcg_clear_queue(struct request_queue *q)
+{
+	struct blkio_policy_type *pol;
+
+	lockdep_assert_held(q->queue_lock);
+
+	spin_lock(&blkio_list_lock);
+	list_for_each_entry(pol, &blkio_list, list)
+		pol->ops.blkio_clear_queue_fn(q);
+	spin_unlock(&blkio_list_lock);
+}
+
 /*
  * We cannot support shared io contexts, as we have no mean to support
  * two tasks with the same ioc in two different groups without major rework
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 3551687..6fa49cb 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -203,7 +203,7 @@ extern unsigned int blkcg_get_write_iops(struct blkio_cgroup *blkcg,
 				     dev_t dev);
 
 typedef void (blkio_unlink_group_fn) (void *key, struct blkio_group *blkg);
-
+typedef void (blkio_clear_queue_fn)(struct request_queue *q);
 typedef void (blkio_update_group_weight_fn) (void *key,
 			struct blkio_group *blkg, unsigned int weight);
 typedef void (blkio_update_group_read_bps_fn) (void * key,
@@ -217,6 +217,7 @@ typedef void (blkio_update_group_write_iops_fn) (void *key,
 
 struct blkio_policy_ops {
 	blkio_unlink_group_fn *blkio_unlink_group_fn;
+	blkio_clear_queue_fn *blkio_clear_queue_fn;
 	blkio_update_group_weight_fn *blkio_update_group_weight_fn;
 	blkio_update_group_read_bps_fn *blkio_update_group_read_bps_fn;
 	blkio_update_group_write_bps_fn *blkio_update_group_write_bps_fn;
@@ -230,6 +231,8 @@ struct blkio_policy_type {
 	enum blkio_policy_id plid;
 };
 
+extern void blkcg_clear_queue(struct request_queue *q);
+
 /* Blkio controller policy registration */
 extern void blkio_policy_register(struct blkio_policy_type *);
 extern void blkio_policy_unregister(struct blkio_policy_type *);
@@ -247,6 +250,7 @@ struct blkio_group {
 struct blkio_policy_type {
 };
 
+static inline void blkcg_clear_queue(struct request_queue *q) { }
 static inline void blkio_policy_register(struct blkio_policy_type *blkiop) { }
 static inline void blkio_policy_unregister(struct blkio_policy_type *blkiop) { }
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 702c0e6..3bc1cc9 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1029,6 +1029,12 @@ void throtl_unlink_blkio_group(void *key, struct blkio_group *blkg)
 	spin_unlock_irqrestore(td->queue->queue_lock, flags);
 }
 
+static void throtl_clear_queue(struct request_queue *q)
+{
+	lockdep_assert_held(q->queue_lock);
+	throtl_release_tgs(q->td);
+}
+
 static void throtl_update_blkio_group_common(struct throtl_data *td,
 				struct throtl_grp *tg)
 {
@@ -1097,6 +1103,7 @@ static void throtl_shutdown_wq(struct request_queue *q)
 static struct blkio_policy_type blkio_policy_throtl = {
 	.ops = {
 		.blkio_unlink_group_fn = throtl_unlink_blkio_group,
+		.blkio_clear_queue_fn = throtl_clear_queue,
 		.blkio_update_group_read_bps_fn =
 					throtl_update_blkio_group_read_bps,
 		.blkio_update_group_write_bps_fn =
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f3d6b04..b110cd8 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1265,6 +1265,16 @@ static void cfq_unlink_blkio_group(void *key, struct blkio_group *blkg)
 	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
 }
 
+static struct elevator_type iosched_cfq;
+
+static void cfq_clear_queue(struct request_queue *q)
+{
+	lockdep_assert_held(q->queue_lock);
+	/* shoot down blkgs iff the current elevator is cfq */
+	if (q->elevator->type == &iosched_cfq)
+		cfq_release_cfq_groups(q->elevator->elevator_data);
+}
+
 #else /* GROUP_IOSCHED */
 static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd)
 {
@@ -3881,6 +3891,7 @@ static struct elevator_type iosched_cfq = {
 static struct blkio_policy_type blkio_policy_cfq = {
 	.ops = {
 		.blkio_unlink_group_fn =	cfq_unlink_blkio_group,
+		.blkio_clear_queue_fn = cfq_clear_queue,
 		.blkio_update_group_weight_fn =	cfq_update_blkio_group_weight,
 	},
 	.plid = BLKIO_POLICY_PROP,
diff --git a/block/elevator.c b/block/elevator.c
index 078a491..5e371e4 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -38,6 +38,7 @@
 #include <trace/events/block.h>
 
 #include "blk.h"
+#include "blk-cgroup.h"
 
 static DEFINE_SPINLOCK(elv_list_lock);
 static LIST_HEAD(elv_list);
@@ -939,6 +940,7 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 
 	spin_lock_irq(q->queue_lock);
 	ioc_clear_queue(q);
+	blkcg_clear_queue(q);
 	spin_unlock_irq(q->queue_lock);
 
 	/* allocate, init and register new elevator */
-- 
1.7.7.3

