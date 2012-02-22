Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab2BVByY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:54:24 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41551 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab2BVBrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:47:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.224.9 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/36] blkcg: shoot down blkio_groups on elevator switch
Date: Tue, 21 Feb 2012 17:46:35 -0800
Message-Id: <1329875223-5102-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329875223-5102-1-git-send-email-tj@kernel.org>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elevator switch may involve changes to blkcg policies.  Implement
shoot down of blkio_groups.

Combined with the previous bypass updates, the end goal is updating
blkcg core such that it can ensure that blkcg's being affected become
quiescent and don't have any per-blkg data hanging around before
commencing any policy updates.  Until queues are made aware of the
policies that applies to them, as an interim step, all per-policy blkg
data will be shot down.

* blk-throtl doesn't need this change as it can't be disabled for a
  live queue; however, update it anyway as the scheduled blkg
  unification requires this behavior change.  This means that
  blk-throtl configuration will be unnecessarily lost over elevator
  switch.  This oddity will be removed after blkcg learns to associate
  individual policies with request_queues.

* blk-throtl dosen't shoot down root_tg.  This is to ease transition.
  Unified blkg will always have persistent root group and not shooting
  down root_tg for now eases transition to that point by avoiding
  having to update td->root_tg and is safe as blk-throtl can never be
  disabled

-v2: Vivek pointed out that group list is not guaranteed to be empty
     on return from clear function if it raced cgroup removal and
     lost.  Fix it by waiting a bit and retrying.  This kludge will
     soon be removed once locking is updated such that blkg is never
     in limbo state between blkcg and request_queue locks.

     blk-throtl no longer shoots down root_tg to avoid breaking
     td->root_tg.

     Also, Nest queue_lock inside blkio_list_lock not the other way
     around to avoid introduce possible deadlock via blkcg lock.

-v3: blkcg_clear_queue() repositioned and renamed to
     blkg_destroy_all() to increase consistency with later changes.
     cfq_clear_queue() updated to check q->elevator before
     dereferencing it to avoid NULL dereference on not fully
     initialized queues (used by later change).

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |   34 +++++++++++++++++++++++++++++++++-
 block/blk-cgroup.h   |    5 ++++-
 block/blk-throttle.c |   27 +++++++++++++++++++++++++--
 block/cfq-iosched.c  |   20 +++++++++++++++++++-
 block/elevator.c     |    3 +++
 5 files changed, 84 insertions(+), 5 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 970a717..159aef5 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -17,8 +17,9 @@
 #include <linux/err.h>
 #include <linux/blkdev.h>
 #include <linux/slab.h>
-#include "blk-cgroup.h"
 #include <linux/genhd.h>
+#include <linux/delay.h>
+#include "blk-cgroup.h"
 
 #define MAX_KEY_LEN 100
 
@@ -546,6 +547,37 @@ struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key)
 }
 EXPORT_SYMBOL_GPL(blkiocg_lookup_group);
 
+void blkg_destroy_all(struct request_queue *q)
+{
+	struct blkio_policy_type *pol;
+
+	while (true) {
+		bool done = true;
+
+		spin_lock(&blkio_list_lock);
+		spin_lock_irq(q->queue_lock);
+
+		/*
+		 * clear_queue_fn() might return with non-empty group list
+		 * if it raced cgroup removal and lost.  cgroup removal is
+		 * guaranteed to make forward progress and retrying after a
+		 * while is enough.  This ugliness is scheduled to be
+		 * removed after locking update.
+		 */
+		list_for_each_entry(pol, &blkio_list, list)
+			if (!pol->ops.blkio_clear_queue_fn(q))
+				done = false;
+
+		spin_unlock_irq(q->queue_lock);
+		spin_unlock(&blkio_list_lock);
+
+		if (done)
+			break;
+
+		msleep(10);	/* just some random duration I like */
+	}
+}
+
 static void blkio_reset_stats_cpu(struct blkio_group *blkg)
 {
 	struct blkio_group_stats_cpu *stats_cpu;
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 3551687..e5cfcbd 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -203,7 +203,7 @@ extern unsigned int blkcg_get_write_iops(struct blkio_cgroup *blkcg,
 				     dev_t dev);
 
 typedef void (blkio_unlink_group_fn) (void *key, struct blkio_group *blkg);
-
+typedef bool (blkio_clear_queue_fn)(struct request_queue *q);
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
@@ -233,6 +234,7 @@ struct blkio_policy_type {
 /* Blkio controller policy registration */
 extern void blkio_policy_register(struct blkio_policy_type *);
 extern void blkio_policy_unregister(struct blkio_policy_type *);
+extern void blkg_destroy_all(struct request_queue *q);
 
 static inline char *blkg_path(struct blkio_group *blkg)
 {
@@ -249,6 +251,7 @@ struct blkio_policy_type {
 
 static inline void blkio_policy_register(struct blkio_policy_type *blkiop) { }
 static inline void blkio_policy_unregister(struct blkio_policy_type *blkiop) { }
+static inline void blkg_destroy_all(struct request_queue *q) { }
 
 static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 702c0e6..3699ab4 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -989,12 +989,17 @@ throtl_destroy_tg(struct throtl_data *td, struct throtl_grp *tg)
 	td->nr_undestroyed_grps--;
 }
 
-static void throtl_release_tgs(struct throtl_data *td)
+static bool throtl_release_tgs(struct throtl_data *td, bool release_root)
 {
 	struct hlist_node *pos, *n;
 	struct throtl_grp *tg;
+	bool empty = true;
 
 	hlist_for_each_entry_safe(tg, pos, n, &td->tg_list, tg_node) {
+		/* skip root? */
+		if (!release_root && tg == td->root_tg)
+			continue;
+
 		/*
 		 * If cgroup removal path got to blk_group first and removed
 		 * it from cgroup list, then it will take care of destroying
@@ -1002,7 +1007,10 @@ static void throtl_release_tgs(struct throtl_data *td)
 		 */
 		if (!blkiocg_del_blkio_group(&tg->blkg))
 			throtl_destroy_tg(td, tg);
+		else
+			empty = false;
 	}
+	return empty;
 }
 
 /*
@@ -1029,6 +1037,20 @@ void throtl_unlink_blkio_group(void *key, struct blkio_group *blkg)
 	spin_unlock_irqrestore(td->queue->queue_lock, flags);
 }
 
+static bool throtl_clear_queue(struct request_queue *q)
+{
+	lockdep_assert_held(q->queue_lock);
+
+	/*
+	 * Clear tgs but leave the root one alone.  This is necessary
+	 * because root_tg is expected to be persistent and safe because
+	 * blk-throtl can never be disabled while @q is alive.  This is a
+	 * kludge to prepare for unified blkg.  This whole function will be
+	 * removed soon.
+	 */
+	return throtl_release_tgs(q->td, false);
+}
+
 static void throtl_update_blkio_group_common(struct throtl_data *td,
 				struct throtl_grp *tg)
 {
@@ -1097,6 +1119,7 @@ static void throtl_shutdown_wq(struct request_queue *q)
 static struct blkio_policy_type blkio_policy_throtl = {
 	.ops = {
 		.blkio_unlink_group_fn = throtl_unlink_blkio_group,
+		.blkio_clear_queue_fn = throtl_clear_queue,
 		.blkio_update_group_read_bps_fn =
 					throtl_update_blkio_group_read_bps,
 		.blkio_update_group_write_bps_fn =
@@ -1282,7 +1305,7 @@ void blk_throtl_exit(struct request_queue *q)
 	throtl_shutdown_wq(q);
 
 	spin_lock_irq(q->queue_lock);
-	throtl_release_tgs(td);
+	throtl_release_tgs(td, true);
 
 	/* If there are other groups */
 	if (td->nr_undestroyed_grps > 0)
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 72680a6..61693d3 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1225,10 +1225,11 @@ static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	cfq_put_cfqg(cfqg);
 }
 
-static void cfq_release_cfq_groups(struct cfq_data *cfqd)
+static bool cfq_release_cfq_groups(struct cfq_data *cfqd)
 {
 	struct hlist_node *pos, *n;
 	struct cfq_group *cfqg;
+	bool empty = true;
 
 	hlist_for_each_entry_safe(cfqg, pos, n, &cfqd->cfqg_list, cfqd_node) {
 		/*
@@ -1238,7 +1239,10 @@ static void cfq_release_cfq_groups(struct cfq_data *cfqd)
 		 */
 		if (!cfq_blkiocg_del_blkio_group(&cfqg->blkg))
 			cfq_destroy_cfqg(cfqd, cfqg);
+		else
+			empty = false;
 	}
+	return empty;
 }
 
 /*
@@ -1265,6 +1269,19 @@ static void cfq_unlink_blkio_group(void *key, struct blkio_group *blkg)
 	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
 }
 
+static struct elevator_type iosched_cfq;
+
+static bool cfq_clear_queue(struct request_queue *q)
+{
+	lockdep_assert_held(q->queue_lock);
+
+	/* shoot down blkgs iff the current elevator is cfq */
+	if (!q->elevator || q->elevator->type != &iosched_cfq)
+		return true;
+
+	return cfq_release_cfq_groups(q->elevator->elevator_data);
+}
+
 #else /* GROUP_IOSCHED */
 static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd)
 {
@@ -3875,6 +3892,7 @@ static struct elevator_type iosched_cfq = {
 static struct blkio_policy_type blkio_policy_cfq = {
 	.ops = {
 		.blkio_unlink_group_fn =	cfq_unlink_blkio_group,
+		.blkio_clear_queue_fn = cfq_clear_queue,
 		.blkio_update_group_weight_fn =	cfq_update_blkio_group_weight,
 	},
 	.plid = BLKIO_POLICY_PROP,
diff --git a/block/elevator.c b/block/elevator.c
index 0bdea0e..8c7561f 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -38,6 +38,7 @@
 #include <trace/events/block.h>
 
 #include "blk.h"
+#include "blk-cgroup.h"
 
 static DEFINE_SPINLOCK(elv_list_lock);
 static LIST_HEAD(elv_list);
@@ -894,6 +895,8 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 	ioc_clear_queue(q);
 	spin_unlock_irq(q->queue_lock);
 
+	blkg_destroy_all(q);
+
 	/* allocate, init and register new elevator */
 	err = -ENOMEM;
 	q->elevator = elevator_alloc(q, new_e);
-- 
1.7.7.3

