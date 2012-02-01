Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab2BAVX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:23:29 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34095 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500Ab2BAVTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:40 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/11] blkcg: don't use blkg->plid in stat related functions
Date: Wed,  1 Feb 2012 13:19:13 -0800
Message-Id: <1328131156-13290-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328131156-13290-1-git-send-email-tj@kernel.org>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkg is scheduled to be unified for all policies and thus there won't
be one-to-one mapping from blkg to policy.  Update stat related
functions to take explicit @pol or @plid arguments and not use
blkg->plid.

This is painful for now but most of specific stat interface functions
will be replaced with a handful of generic helpers.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |  150 ++++++++++++++++++++++++++++----------------------
 block/blk-cgroup.h   |   80 +++++++++++++++++----------
 block/blk-throttle.c |    4 +-
 block/cfq-iosched.c  |   44 +++++++++-----
 block/cfq.h          |   96 +++++++++++++++++++-------------
 5 files changed, 224 insertions(+), 150 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 5696a8d..c121189 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -78,14 +78,14 @@ struct blkio_cgroup *task_blkio_cgroup(struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(task_blkio_cgroup);
 
-static inline void
-blkio_update_group_weight(struct blkio_group *blkg, unsigned int weight)
+static inline void blkio_update_group_weight(struct blkio_group *blkg,
+					     int plid, unsigned int weight)
 {
 	struct blkio_policy_type *blkiop;
 
 	list_for_each_entry(blkiop, &blkio_list, list) {
 		/* If this policy does not own the blkg, do not send updates */
-		if (blkiop->plid != blkg->plid)
+		if (blkiop->plid != plid)
 			continue;
 		if (blkiop->ops.blkio_update_group_weight_fn)
 			blkiop->ops.blkio_update_group_weight_fn(blkg->q,
@@ -93,15 +93,15 @@ blkio_update_group_weight(struct blkio_group *blkg, unsigned int weight)
 	}
 }
 
-static inline void blkio_update_group_bps(struct blkio_group *blkg, u64 bps,
-				int fileid)
+static inline void blkio_update_group_bps(struct blkio_group *blkg, int plid,
+					  u64 bps, int fileid)
 {
 	struct blkio_policy_type *blkiop;
 
 	list_for_each_entry(blkiop, &blkio_list, list) {
 
 		/* If this policy does not own the blkg, do not send updates */
-		if (blkiop->plid != blkg->plid)
+		if (blkiop->plid != plid)
 			continue;
 
 		if (fileid == BLKIO_THROTL_read_bps_device
@@ -117,14 +117,15 @@ static inline void blkio_update_group_bps(struct blkio_group *blkg, u64 bps,
 }
 
 static inline void blkio_update_group_iops(struct blkio_group *blkg,
-			unsigned int iops, int fileid)
+					   int plid, unsigned int iops,
+					   int fileid)
 {
 	struct blkio_policy_type *blkiop;
 
 	list_for_each_entry(blkiop, &blkio_list, list) {
 
 		/* If this policy does not own the blkg, do not send updates */
-		if (blkiop->plid != blkg->plid)
+		if (blkiop->plid != plid)
 			continue;
 
 		if (fileid == BLKIO_THROTL_read_iops_device
@@ -182,9 +183,10 @@ static void blkio_check_and_dec_stat(uint64_t *stat, bool direction, bool sync)
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 /* This should be called with the blkg->stats_lock held. */
 static void blkio_set_start_group_wait_time(struct blkio_group *blkg,
-						struct blkio_group *curr_blkg)
+					    struct blkio_policy_type *pol,
+					    struct blkio_group *curr_blkg)
 {
-	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+	struct blkg_policy_data *pd = blkg->pd[pol->plid];
 
 	if (blkio_blkg_waiting(&pd->stats))
 		return;
@@ -222,9 +224,10 @@ static void blkio_end_empty_time(struct blkio_group_stats *stats)
 	blkio_clear_blkg_empty(stats);
 }
 
-void blkiocg_update_set_idle_time_stats(struct blkio_group *blkg)
+void blkiocg_update_set_idle_time_stats(struct blkio_group *blkg,
+					struct blkio_policy_type *pol)
 {
-	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+	struct blkg_policy_data *pd = blkg->pd[pol->plid];
 	unsigned long flags;
 
 	spin_lock_irqsave(&blkg->stats_lock, flags);
@@ -235,9 +238,10 @@ void blkiocg_update_set_idle_time_stats(struct blkio_group *blkg)
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_set_idle_time_stats);
 
-void blkiocg_update_idle_time_stats(struct blkio_group *blkg)
+void blkiocg_update_idle_time_stats(struct blkio_group *blkg,
+				    struct blkio_policy_type *pol)
 {
-	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+	struct blkg_policy_data *pd = blkg->pd[pol->plid];
 	unsigned long flags;
 	unsigned long long now;
 	struct blkio_group_stats *stats;
@@ -254,9 +258,10 @@ void blkiocg_update_idle_time_stats(struct blkio_group *blkg)
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_idle_time_stats);
 
-void blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg)
+void blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg,
+					 struct blkio_policy_type *pol)
 {
-	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+	struct blkg_policy_data *pd = blkg->pd[pol->plid];
 	unsigned long flags;
 	struct blkio_group_stats *stats;
 
@@ -271,9 +276,10 @@ void blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg)
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_avg_queue_size_stats);
 
-void blkiocg_set_start_empty_time(struct blkio_group *blkg)
+void blkiocg_set_start_empty_time(struct blkio_group *blkg,
+				  struct blkio_policy_type *pol)
 {
-	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+	struct blkg_policy_data *pd = blkg->pd[pol->plid];
 	unsigned long flags;
 	struct blkio_group_stats *stats;
 
@@ -303,39 +309,43 @@ void blkiocg_set_start_empty_time(struct blkio_group *blkg)
 EXPORT_SYMBOL_GPL(blkiocg_set_start_empty_time);
 
 void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
-			unsigned long dequeue)
+				  struct blkio_policy_type *pol,
+				  unsigned long dequeue)
 {
-	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+	struct blkg_policy_data *pd = blkg->pd[pol->plid];
 
 	pd->stats.dequeue += dequeue;
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_dequeue_stats);
 #else
 static inline void blkio_set_start_group_wait_time(struct blkio_group *blkg,
-					struct blkio_group *curr_blkg) {}
-static inline void blkio_end_empty_time(struct blkio_group_stats *stats) {}
+					struct blkio_policy_type *pol,
+					struct blkio_group *curr_blkg) { }
+static inline void blkio_end_empty_time(struct blkio_group_stats *stats) { }
 #endif
 
 void blkiocg_update_io_add_stats(struct blkio_group *blkg,
-			struct blkio_group *curr_blkg, bool direction,
-			bool sync)
+				 struct blkio_policy_type *pol,
+				 struct blkio_group *curr_blkg, bool direction,
+				 bool sync)
 {
-	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+	struct blkg_policy_data *pd = blkg->pd[pol->plid];
 	unsigned long flags;
 
 	spin_lock_irqsave(&blkg->stats_lock, flags);
 	blkio_add_stat(pd->stats.stat_arr[BLKIO_STAT_QUEUED], 1, direction,
 			sync);
 	blkio_end_empty_time(&pd->stats);
-	blkio_set_start_group_wait_time(blkg, curr_blkg);
+	blkio_set_start_group_wait_time(blkg, pol, curr_blkg);
 	spin_unlock_irqrestore(&blkg->stats_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_io_add_stats);
 
 void blkiocg_update_io_remove_stats(struct blkio_group *blkg,
-						bool direction, bool sync)
+				    struct blkio_policy_type *pol,
+				    bool direction, bool sync)
 {
-	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+	struct blkg_policy_data *pd = blkg->pd[pol->plid];
 	unsigned long flags;
 
 	spin_lock_irqsave(&blkg->stats_lock, flags);
@@ -345,10 +355,12 @@ void blkiocg_update_io_remove_stats(struct blkio_group *blkg,
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_io_remove_stats);
 
-void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time,
-				unsigned long unaccounted_time)
+void blkiocg_update_timeslice_used(struct blkio_group *blkg,
+				   struct blkio_policy_type *pol,
+				   unsigned long time,
+				   unsigned long unaccounted_time)
 {
-	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+	struct blkg_policy_data *pd = blkg->pd[pol->plid];
 	unsigned long flags;
 
 	spin_lock_irqsave(&blkg->stats_lock, flags);
@@ -365,9 +377,10 @@ EXPORT_SYMBOL_GPL(blkiocg_update_timeslice_used);
  * is valid.
  */
 void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
-				uint64_t bytes, bool direction, bool sync)
+				   struct blkio_policy_type *pol,
+				   uint64_t bytes, bool direction, bool sync)
 {
-	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+	struct blkg_policy_data *pd = blkg->pd[pol->plid];
 	struct blkio_group_stats_cpu *stats_cpu;
 	unsigned long flags;
 
@@ -392,9 +405,12 @@ void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 EXPORT_SYMBOL_GPL(blkiocg_update_dispatch_stats);
 
 void blkiocg_update_completion_stats(struct blkio_group *blkg,
-	uint64_t start_time, uint64_t io_start_time, bool direction, bool sync)
+				     struct blkio_policy_type *pol,
+				     uint64_t start_time,
+				     uint64_t io_start_time, bool direction,
+				     bool sync)
 {
-	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+	struct blkg_policy_data *pd = blkg->pd[pol->plid];
 	struct blkio_group_stats *stats;
 	unsigned long flags;
 	unsigned long long now = sched_clock();
@@ -412,10 +428,11 @@ void blkiocg_update_completion_stats(struct blkio_group *blkg,
 EXPORT_SYMBOL_GPL(blkiocg_update_completion_stats);
 
 /*  Merged stats are per cpu.  */
-void blkiocg_update_io_merged_stats(struct blkio_group *blkg, bool direction,
-					bool sync)
+void blkiocg_update_io_merged_stats(struct blkio_group *blkg,
+				    struct blkio_policy_type *pol,
+				    bool direction, bool sync)
 {
-	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+	struct blkg_policy_data *pd = blkg->pd[pol->plid];
 	struct blkio_group_stats_cpu *stats_cpu;
 	unsigned long flags;
 
@@ -681,9 +698,9 @@ void __blkg_release(struct blkio_group *blkg)
 }
 EXPORT_SYMBOL_GPL(__blkg_release);
 
-static void blkio_reset_stats_cpu(struct blkio_group *blkg)
+static void blkio_reset_stats_cpu(struct blkio_group *blkg, int plid)
 {
-	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+	struct blkg_policy_data *pd = blkg->pd[plid];
 	struct blkio_group_stats_cpu *stats_cpu;
 	int i, j, k;
 	/*
@@ -754,7 +771,7 @@ blkiocg_reset_stats(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 		spin_unlock(&blkg->stats_lock);
 
 		/* Reset Per cpu stats which don't take blkg->stats_lock */
-		blkio_reset_stats_cpu(blkg);
+		blkio_reset_stats_cpu(blkg, blkg->plid);
 	}
 
 	spin_unlock_irq(&blkcg->lock);
@@ -803,10 +820,10 @@ static uint64_t blkio_fill_stat(char *str, int chars_left, uint64_t val,
 }
 
 
-static uint64_t blkio_read_stat_cpu(struct blkio_group *blkg,
+static uint64_t blkio_read_stat_cpu(struct blkio_group *blkg, int plid,
 			enum stat_type_cpu type, enum stat_sub_type sub_type)
 {
-	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+	struct blkg_policy_data *pd = blkg->pd[plid];
 	int cpu;
 	struct blkio_group_stats_cpu *stats_cpu;
 	u64 val = 0, tval;
@@ -829,7 +846,7 @@ static uint64_t blkio_read_stat_cpu(struct blkio_group *blkg,
 	return val;
 }
 
-static uint64_t blkio_get_stat_cpu(struct blkio_group *blkg,
+static uint64_t blkio_get_stat_cpu(struct blkio_group *blkg, int plid,
 				   struct cgroup_map_cb *cb, const char *dname,
 				   enum stat_type_cpu type)
 {
@@ -838,7 +855,7 @@ static uint64_t blkio_get_stat_cpu(struct blkio_group *blkg,
 	enum stat_sub_type sub_type;
 
 	if (type == BLKIO_STAT_CPU_SECTORS) {
-		val = blkio_read_stat_cpu(blkg, type, 0);
+		val = blkio_read_stat_cpu(blkg, plid, type, 0);
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1, val, cb,
 				       dname);
 	}
@@ -847,12 +864,12 @@ static uint64_t blkio_get_stat_cpu(struct blkio_group *blkg,
 			sub_type++) {
 		blkio_get_key_name(sub_type, dname, key_str, MAX_KEY_LEN,
 				   false);
-		val = blkio_read_stat_cpu(blkg, type, sub_type);
+		val = blkio_read_stat_cpu(blkg, plid, type, sub_type);
 		cb->fill(cb, key_str, val);
 	}
 
-	disk_total = blkio_read_stat_cpu(blkg, type, BLKIO_STAT_READ) +
-			blkio_read_stat_cpu(blkg, type, BLKIO_STAT_WRITE);
+	disk_total = blkio_read_stat_cpu(blkg, plid, type, BLKIO_STAT_READ) +
+		blkio_read_stat_cpu(blkg, plid, type, BLKIO_STAT_WRITE);
 
 	blkio_get_key_name(BLKIO_STAT_TOTAL, dname, key_str, MAX_KEY_LEN,
 			   false);
@@ -861,11 +878,11 @@ static uint64_t blkio_get_stat_cpu(struct blkio_group *blkg,
 }
 
 /* This should be called with blkg->stats_lock held */
-static uint64_t blkio_get_stat(struct blkio_group *blkg,
+static uint64_t blkio_get_stat(struct blkio_group *blkg, int plid,
 			       struct cgroup_map_cb *cb, const char *dname,
 			       enum stat_type type)
 {
-	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+	struct blkg_policy_data *pd = blkg->pd[plid];
 	uint64_t disk_total;
 	char key_str[MAX_KEY_LEN];
 	enum stat_sub_type sub_type;
@@ -989,29 +1006,29 @@ static int blkio_policy_parse_and_set(char *buf, enum blkio_policy_id plid,
 			goto out_unlock;
 
 		pd->conf.weight = temp;
-		blkio_update_group_weight(blkg, temp ?: blkcg->weight);
+		blkio_update_group_weight(blkg, plid, temp ?: blkcg->weight);
 		break;
 	case BLKIO_POLICY_THROTL:
 		switch(fileid) {
 		case BLKIO_THROTL_read_bps_device:
 			pd->conf.bps[READ] = temp;
-			blkio_update_group_bps(blkg, temp ?: -1, fileid);
+			blkio_update_group_bps(blkg, plid, temp ?: -1, fileid);
 			break;
 		case BLKIO_THROTL_write_bps_device:
 			pd->conf.bps[WRITE] = temp;
-			blkio_update_group_bps(blkg, temp ?: -1, fileid);
+			blkio_update_group_bps(blkg, plid, temp ?: -1, fileid);
 			break;
 		case BLKIO_THROTL_read_iops_device:
 			if (temp > THROTL_IOPS_MAX)
 				goto out_unlock;
 			pd->conf.iops[READ] = temp;
-			blkio_update_group_iops(blkg, temp ?: -1, fileid);
+			blkio_update_group_iops(blkg, plid, temp ?: -1, fileid);
 			break;
 		case BLKIO_THROTL_write_iops_device:
 			if (temp > THROTL_IOPS_MAX)
 				goto out_unlock;
 			pd->conf.iops[WRITE] = temp;
-			blkio_update_group_iops(blkg, temp ?: -1, fileid);
+			blkio_update_group_iops(blkg, plid, temp ?: -1, fileid);
 			break;
 		}
 		break;
@@ -1058,12 +1075,13 @@ static int blkiocg_file_write(struct cgroup *cgrp, struct cftype *cft,
 static void blkio_print_group_conf(struct cftype *cft, struct blkio_group *blkg,
 				   struct seq_file *m)
 {
-	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
-	const char *dname = dev_name(blkg->q->backing_dev_info.dev);
+	int plid = BLKIOFILE_POLICY(cft->private);
 	int fileid = BLKIOFILE_ATTR(cft->private);
+	struct blkg_policy_data *pd = blkg->pd[plid];
+	const char *dname = dev_name(blkg->q->backing_dev_info.dev);
 	int rw = WRITE;
 
-	switch (blkg->plid) {
+	switch (plid) {
 		case BLKIO_POLICY_PROP:
 			if (pd->conf.weight)
 				seq_printf(m, "%s\t%u\n",
@@ -1155,15 +1173,17 @@ static int blkio_read_blkg_stats(struct blkio_cgroup *blkcg,
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {
 		const char *dname = dev_name(blkg->q->backing_dev_info.dev);
+		int plid = BLKIOFILE_POLICY(cft->private);
 
-		if (BLKIOFILE_POLICY(cft->private) != blkg->plid)
+		if (plid != blkg->plid)
 			continue;
-		if (pcpu)
-			cgroup_total += blkio_get_stat_cpu(blkg, cb, dname,
-							   type);
-		else {
+		if (pcpu) {
+			cgroup_total += blkio_get_stat_cpu(blkg, plid,
+							   cb, dname, type);
+		} else {
 			spin_lock_irq(&blkg->stats_lock);
-			cgroup_total += blkio_get_stat(blkg, cb, dname, type);
+			cgroup_total += blkio_get_stat(blkg, plid,
+						       cb, dname, type);
 			spin_unlock_irq(&blkg->stats_lock);
 		}
 	}
@@ -1269,7 +1289,7 @@ static int blkio_weight_write(struct blkio_cgroup *blkcg, int plid, u64 val)
 		struct blkg_policy_data *pd = blkg->pd[blkg->plid];
 
 		if (blkg->plid == plid && !pd->conf.weight)
-			blkio_update_group_weight(blkg, blkcg->weight);
+			blkio_update_group_weight(blkg, plid, blkcg->weight);
 	}
 
 	spin_unlock_irq(&blkcg->lock);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 5dffd43..60e96b4 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -335,12 +335,17 @@ static inline void blkg_put(struct blkio_group *blkg) { }
 #define BLKIO_WEIGHT_DEFAULT	500
 
 #ifdef CONFIG_DEBUG_BLK_CGROUP
-void blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg);
+void blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg,
+					 struct blkio_policy_type *pol);
 void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
-				unsigned long dequeue);
-void blkiocg_update_set_idle_time_stats(struct blkio_group *blkg);
-void blkiocg_update_idle_time_stats(struct blkio_group *blkg);
-void blkiocg_set_start_empty_time(struct blkio_group *blkg);
+				  struct blkio_policy_type *pol,
+				  unsigned long dequeue);
+void blkiocg_update_set_idle_time_stats(struct blkio_group *blkg,
+					struct blkio_policy_type *pol);
+void blkiocg_update_idle_time_stats(struct blkio_group *blkg,
+				    struct blkio_policy_type *pol);
+void blkiocg_set_start_empty_time(struct blkio_group *blkg,
+				  struct blkio_policy_type *pol);
 
 #define BLKG_FLAG_FNS(name)						\
 static inline void blkio_mark_blkg_##name(				\
@@ -363,14 +368,16 @@ BLKG_FLAG_FNS(idling)
 BLKG_FLAG_FNS(empty)
 #undef BLKG_FLAG_FNS
 #else
-static inline void blkiocg_update_avg_queue_size_stats(
-						struct blkio_group *blkg) {}
+static inline void blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol) { }
 static inline void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
-						unsigned long dequeue) {}
-static inline void blkiocg_update_set_idle_time_stats(struct blkio_group *blkg)
-{}
-static inline void blkiocg_update_idle_time_stats(struct blkio_group *blkg) {}
-static inline void blkiocg_set_start_empty_time(struct blkio_group *blkg) {}
+			struct blkio_policy_type *pol, unsigned long dequeue) { }
+static inline void blkiocg_update_set_idle_time_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol) { }
+static inline void blkiocg_update_idle_time_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol) { }
+static inline void blkiocg_set_start_empty_time(struct blkio_group *blkg,
+			struct blkio_policy_type *pol) { }
 #endif
 
 #ifdef CONFIG_BLK_CGROUP
@@ -386,18 +393,27 @@ struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
 				       enum blkio_policy_id plid,
 				       bool for_root);
 void blkiocg_update_timeslice_used(struct blkio_group *blkg,
-					unsigned long time,
-					unsigned long unaccounted_time);
-void blkiocg_update_dispatch_stats(struct blkio_group *blkg, uint64_t bytes,
-						bool direction, bool sync);
+				   struct blkio_policy_type *pol,
+				   unsigned long time,
+				   unsigned long unaccounted_time);
+void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
+				   struct blkio_policy_type *pol,
+				   uint64_t bytes, bool direction, bool sync);
 void blkiocg_update_completion_stats(struct blkio_group *blkg,
-	uint64_t start_time, uint64_t io_start_time, bool direction, bool sync);
-void blkiocg_update_io_merged_stats(struct blkio_group *blkg, bool direction,
-					bool sync);
+				     struct blkio_policy_type *pol,
+				     uint64_t start_time,
+				     uint64_t io_start_time, bool direction,
+				     bool sync);
+void blkiocg_update_io_merged_stats(struct blkio_group *blkg,
+				    struct blkio_policy_type *pol,
+				    bool direction, bool sync);
 void blkiocg_update_io_add_stats(struct blkio_group *blkg,
-		struct blkio_group *curr_blkg, bool direction, bool sync);
+				 struct blkio_policy_type *pol,
+				 struct blkio_group *curr_blkg, bool direction,
+				 bool sync);
 void blkiocg_update_io_remove_stats(struct blkio_group *blkg,
-					bool direction, bool sync);
+				    struct blkio_policy_type *pol,
+				    bool direction, bool sync);
 #else
 struct cgroup;
 static inline struct blkio_cgroup *
@@ -411,19 +427,23 @@ blkiocg_del_blkio_group(struct blkio_group *blkg) { return 0; }
 static inline struct blkio_group *blkg_lookup(struct blkio_cgroup *blkcg,
 					      void *key) { return NULL; }
 static inline void blkiocg_update_timeslice_used(struct blkio_group *blkg,
-						unsigned long time,
-						unsigned long unaccounted_time)
-{}
+			struct blkio_policy_type *pol, unsigned long time,
+			unsigned long unaccounted_time) { }
 static inline void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
-				uint64_t bytes, bool direction, bool sync) {}
+			struct blkio_policy_type *pol, uint64_t bytes,
+			bool direction, bool sync) { }
 static inline void blkiocg_update_completion_stats(struct blkio_group *blkg,
-		uint64_t start_time, uint64_t io_start_time, bool direction,
-		bool sync) {}
+			struct blkio_policy_type *pol, uint64_t start_time,
+			uint64_t io_start_time, bool direction, bool sync) { }
 static inline void blkiocg_update_io_merged_stats(struct blkio_group *blkg,
-						bool direction, bool sync) {}
+			struct blkio_policy_type *pol, bool direction,
+			bool sync) { }
 static inline void blkiocg_update_io_add_stats(struct blkio_group *blkg,
-		struct blkio_group *curr_blkg, bool direction, bool sync) {}
+			struct blkio_policy_type *pol,
+			struct blkio_group *curr_blkg, bool direction,
+			bool sync) { }
 static inline void blkiocg_update_io_remove_stats(struct blkio_group *blkg,
-						bool direction, bool sync) {}
+			struct blkio_policy_type *pol, bool direction,
+			bool sync) { }
 #endif
 #endif /* _BLK_CGROUP_H */
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 153ba50..b2fddaf 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -588,7 +588,8 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 	tg->bytes_disp[rw] += bio->bi_size;
 	tg->io_disp[rw]++;
 
-	blkiocg_update_dispatch_stats(tg_to_blkg(tg), bio->bi_size, rw, sync);
+	blkiocg_update_dispatch_stats(tg_to_blkg(tg), &blkio_policy_throtl,
+				      bio->bi_size, rw, sync);
 }
 
 static void throtl_add_bio_tg(struct throtl_data *td, struct throtl_grp *tg,
@@ -1000,6 +1001,7 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 	if (tg) {
 		if (tg_no_rule_group(tg, rw)) {
 			blkiocg_update_dispatch_stats(tg_to_blkg(tg),
+						      &blkio_policy_throtl,
 						      bio->bi_size, rw,
 						      rw_is_sync(bio->bi_rw));
 			goto out_unlock_rcu;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5ce81a8..0cb3908 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -945,7 +945,8 @@ cfq_group_notify_queue_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
 	cfq_group_service_tree_del(st, cfqg);
 	cfqg->saved_workload_slice = 0;
-	cfq_blkiocg_update_dequeue_stats(cfqg_to_blkg(cfqg), 1);
+	cfq_blkiocg_update_dequeue_stats(cfqg_to_blkg(cfqg),
+					 &blkio_policy_cfq, 1);
 }
 
 static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq,
@@ -1017,9 +1018,9 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 		     "sl_used=%u disp=%u charge=%u iops=%u sect=%lu",
 		     used_sl, cfqq->slice_dispatch, charge,
 		     iops_mode(cfqd), cfqq->nr_sectors);
-	cfq_blkiocg_update_timeslice_used(cfqg_to_blkg(cfqg), used_sl,
-					  unaccounted_sl);
-	cfq_blkiocg_set_start_empty_time(cfqg_to_blkg(cfqg));
+	cfq_blkiocg_update_timeslice_used(cfqg_to_blkg(cfqg), &blkio_policy_cfq,
+					  used_sl, unaccounted_sl);
+	cfq_blkiocg_set_start_empty_time(cfqg_to_blkg(cfqg), &blkio_policy_cfq);
 }
 
 /**
@@ -1463,9 +1464,11 @@ static void cfq_reposition_rq_rb(struct cfq_queue *cfqq, struct request *rq)
 	elv_rb_del(&cfqq->sort_list, rq);
 	cfqq->queued[rq_is_sync(rq)]--;
 	cfq_blkiocg_update_io_remove_stats(cfqg_to_blkg(RQ_CFQG(rq)),
-					rq_data_dir(rq), rq_is_sync(rq));
+					   &blkio_policy_cfq, rq_data_dir(rq),
+					   rq_is_sync(rq));
 	cfq_add_rq_rb(rq);
 	cfq_blkiocg_update_io_add_stats(cfqg_to_blkg(RQ_CFQG(rq)),
+					&blkio_policy_cfq,
 					cfqg_to_blkg(cfqq->cfqd->serving_group),
 					rq_data_dir(rq), rq_is_sync(rq));
 }
@@ -1524,7 +1527,8 @@ static void cfq_remove_request(struct request *rq)
 
 	cfqq->cfqd->rq_queued--;
 	cfq_blkiocg_update_io_remove_stats(cfqg_to_blkg(RQ_CFQG(rq)),
-					rq_data_dir(rq), rq_is_sync(rq));
+					   &blkio_policy_cfq, rq_data_dir(rq),
+					   rq_is_sync(rq));
 	if (rq->cmd_flags & REQ_PRIO) {
 		WARN_ON(!cfqq->prio_pending);
 		cfqq->prio_pending--;
@@ -1560,7 +1564,8 @@ static void cfq_bio_merged(struct request_queue *q, struct request *req,
 				struct bio *bio)
 {
 	cfq_blkiocg_update_io_merged_stats(cfqg_to_blkg(RQ_CFQG(req)),
-					bio_data_dir(bio), cfq_bio_sync(bio));
+					   &blkio_policy_cfq, bio_data_dir(bio),
+					   cfq_bio_sync(bio));
 }
 
 static void
@@ -1583,7 +1588,8 @@ cfq_merged_requests(struct request_queue *q, struct request *rq,
 		cfqq->next_rq = rq;
 	cfq_remove_request(next);
 	cfq_blkiocg_update_io_merged_stats(cfqg_to_blkg(RQ_CFQG(rq)),
-					rq_data_dir(next), rq_is_sync(next));
+					   &blkio_policy_cfq, rq_data_dir(next),
+					   rq_is_sync(next));
 
 	cfqq = RQ_CFQQ(next);
 	/*
@@ -1631,7 +1637,8 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 static inline void cfq_del_timer(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	del_timer(&cfqd->idle_slice_timer);
-	cfq_blkiocg_update_idle_time_stats(cfqg_to_blkg(cfqq->cfqg));
+	cfq_blkiocg_update_idle_time_stats(cfqg_to_blkg(cfqq->cfqg),
+					   &blkio_policy_cfq);
 }
 
 static void __cfq_set_active_queue(struct cfq_data *cfqd,
@@ -1640,7 +1647,8 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 	if (cfqq) {
 		cfq_log_cfqq(cfqd, cfqq, "set_active wl_prio:%d wl_type:%d",
 				cfqd->serving_prio, cfqd->serving_type);
-		cfq_blkiocg_update_avg_queue_size_stats(cfqg_to_blkg(cfqq->cfqg));
+		cfq_blkiocg_update_avg_queue_size_stats(cfqg_to_blkg(cfqq->cfqg),
+							&blkio_policy_cfq);
 		cfqq->slice_start = 0;
 		cfqq->dispatch_start = jiffies;
 		cfqq->allocated_slice = 0;
@@ -1988,7 +1996,8 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 		sl = cfqd->cfq_slice_idle;
 
 	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
-	cfq_blkiocg_update_set_idle_time_stats(cfqg_to_blkg(cfqq->cfqg));
+	cfq_blkiocg_update_set_idle_time_stats(cfqg_to_blkg(cfqq->cfqg),
+					       &blkio_policy_cfq);
 	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu group_idle: %d", sl,
 			group_idle ? 1 : 0);
 }
@@ -2012,8 +2021,8 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
 	cfqq->nr_sectors += blk_rq_sectors(rq);
 	cfq_blkiocg_update_dispatch_stats(cfqg_to_blkg(cfqq->cfqg),
-					  blk_rq_bytes(rq), rq_data_dir(rq),
-					  rq_is_sync(rq));
+					  &blkio_policy_cfq, blk_rq_bytes(rq),
+					  rq_data_dir(rq), rq_is_sync(rq));
 }
 
 /*
@@ -3100,7 +3109,8 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 				__blk_run_queue(cfqd->queue);
 			} else {
 				cfq_blkiocg_update_idle_time_stats(
-						cfqg_to_blkg(cfqq->cfqg));
+						cfqg_to_blkg(cfqq->cfqg),
+						&blkio_policy_cfq);
 				cfq_mark_cfqq_must_dispatch(cfqq);
 			}
 		}
@@ -3128,6 +3138,7 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
 	list_add_tail(&rq->queuelist, &cfqq->fifo);
 	cfq_add_rq_rb(rq);
 	cfq_blkiocg_update_io_add_stats(cfqg_to_blkg(RQ_CFQG(rq)),
+					&blkio_policy_cfq,
 					cfqg_to_blkg(cfqd->serving_group),
 					rq_data_dir(rq), rq_is_sync(rq));
 	cfq_rq_enqueued(cfqd, cfqq, rq);
@@ -3226,8 +3237,9 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	cfqq->dispatched--;
 	(RQ_CFQG(rq))->dispatched--;
 	cfq_blkiocg_update_completion_stats(cfqg_to_blkg(cfqq->cfqg),
-			rq_start_time_ns(rq), rq_io_start_time_ns(rq),
-			rq_data_dir(rq), rq_is_sync(rq));
+			&blkio_policy_cfq, rq_start_time_ns(rq),
+			rq_io_start_time_ns(rq), rq_data_dir(rq),
+			rq_is_sync(rq));
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
 
diff --git a/block/cfq.h b/block/cfq.h
index 3987601..5584e1b 100644
--- a/block/cfq.h
+++ b/block/cfq.h
@@ -4,67 +4,79 @@
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 static inline void cfq_blkiocg_update_io_add_stats(struct blkio_group *blkg,
-	struct blkio_group *curr_blkg, bool direction, bool sync)
+			struct blkio_policy_type *pol,
+			struct blkio_group *curr_blkg,
+			bool direction, bool sync)
 {
-	blkiocg_update_io_add_stats(blkg, curr_blkg, direction, sync);
+	blkiocg_update_io_add_stats(blkg, pol, curr_blkg, direction, sync);
 }
 
 static inline void cfq_blkiocg_update_dequeue_stats(struct blkio_group *blkg,
-			unsigned long dequeue)
+			struct blkio_policy_type *pol, unsigned long dequeue)
 {
-	blkiocg_update_dequeue_stats(blkg, dequeue);
+	blkiocg_update_dequeue_stats(blkg, pol, dequeue);
 }
 
 static inline void cfq_blkiocg_update_timeslice_used(struct blkio_group *blkg,
-			unsigned long time, unsigned long unaccounted_time)
+			struct blkio_policy_type *pol, unsigned long time,
+			unsigned long unaccounted_time)
 {
-	blkiocg_update_timeslice_used(blkg, time, unaccounted_time);
+	blkiocg_update_timeslice_used(blkg, pol, time, unaccounted_time);
 }
 
-static inline void cfq_blkiocg_set_start_empty_time(struct blkio_group *blkg)
+static inline void cfq_blkiocg_set_start_empty_time(struct blkio_group *blkg,
+			struct blkio_policy_type *pol)
 {
-	blkiocg_set_start_empty_time(blkg);
+	blkiocg_set_start_empty_time(blkg, pol);
 }
 
 static inline void cfq_blkiocg_update_io_remove_stats(struct blkio_group *blkg,
-				bool direction, bool sync)
+			struct blkio_policy_type *pol, bool direction,
+			bool sync)
 {
-	blkiocg_update_io_remove_stats(blkg, direction, sync);
+	blkiocg_update_io_remove_stats(blkg, pol, direction, sync);
 }
 
 static inline void cfq_blkiocg_update_io_merged_stats(struct blkio_group *blkg,
-		bool direction, bool sync)
+			struct blkio_policy_type *pol, bool direction,
+			bool sync)
 {
-	blkiocg_update_io_merged_stats(blkg, direction, sync);
+	blkiocg_update_io_merged_stats(blkg, pol, direction, sync);
 }
 
-static inline void cfq_blkiocg_update_idle_time_stats(struct blkio_group *blkg)
+static inline void cfq_blkiocg_update_idle_time_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol)
 {
-	blkiocg_update_idle_time_stats(blkg);
+	blkiocg_update_idle_time_stats(blkg, pol);
 }
 
 static inline void
-cfq_blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg)
+cfq_blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol)
 {
-	blkiocg_update_avg_queue_size_stats(blkg);
+	blkiocg_update_avg_queue_size_stats(blkg, pol);
 }
 
 static inline void
-cfq_blkiocg_update_set_idle_time_stats(struct blkio_group *blkg)
+cfq_blkiocg_update_set_idle_time_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol)
 {
-	blkiocg_update_set_idle_time_stats(blkg);
+	blkiocg_update_set_idle_time_stats(blkg, pol);
 }
 
 static inline void cfq_blkiocg_update_dispatch_stats(struct blkio_group *blkg,
-				uint64_t bytes, bool direction, bool sync)
+			struct blkio_policy_type *pol, uint64_t bytes,
+			bool direction, bool sync)
 {
-	blkiocg_update_dispatch_stats(blkg, bytes, direction, sync);
+	blkiocg_update_dispatch_stats(blkg, pol, bytes, direction, sync);
 }
 
-static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg, uint64_t start_time, uint64_t io_start_time, bool direction, bool sync)
+static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol, uint64_t start_time,
+			uint64_t io_start_time, bool direction, bool sync)
 {
-	blkiocg_update_completion_stats(blkg, start_time, io_start_time,
-				direction, sync);
+	blkiocg_update_completion_stats(blkg, pol, start_time, io_start_time,
+					direction, sync);
 }
 
 static inline int cfq_blkiocg_del_blkio_group(struct blkio_group *blkg)
@@ -74,30 +86,38 @@ static inline int cfq_blkiocg_del_blkio_group(struct blkio_group *blkg)
 
 #else /* CFQ_GROUP_IOSCHED */
 static inline void cfq_blkiocg_update_io_add_stats(struct blkio_group *blkg,
-	struct blkio_group *curr_blkg, bool direction, bool sync) {}
-
+			struct blkio_policy_type *pol,
+			struct blkio_group *curr_blkg, bool direction,
+			bool sync) { }
 static inline void cfq_blkiocg_update_dequeue_stats(struct blkio_group *blkg,
-			unsigned long dequeue) {}
-
+			struct blkio_policy_type *pol, unsigned long dequeue) { }
 static inline void cfq_blkiocg_update_timeslice_used(struct blkio_group *blkg,
-			unsigned long time, unsigned long unaccounted_time) {}
-static inline void cfq_blkiocg_set_start_empty_time(struct blkio_group *blkg) {}
+			struct blkio_policy_type *pol, unsigned long time,
+			unsigned long unaccounted_time) { }
+static inline void cfq_blkiocg_set_start_empty_time(struct blkio_group *blkg,
+			struct blkio_policy_type *pol) { }
 static inline void cfq_blkiocg_update_io_remove_stats(struct blkio_group *blkg,
-				bool direction, bool sync) {}
+			struct blkio_policy_type *pol, bool direction,
+			bool sync) { }
 static inline void cfq_blkiocg_update_io_merged_stats(struct blkio_group *blkg,
-		bool direction, bool sync) {}
-static inline void cfq_blkiocg_update_idle_time_stats(struct blkio_group *blkg)
-{
-}
+			struct blkio_policy_type *pol, bool direction,
+			bool sync) { }
+static inline void cfq_blkiocg_update_idle_time_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol) { }
 static inline void
-cfq_blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg) {}
+cfq_blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg,
+					struct blkio_policy_type *pol) { }
 
 static inline void
-cfq_blkiocg_update_set_idle_time_stats(struct blkio_group *blkg) {}
+cfq_blkiocg_update_set_idle_time_stats(struct blkio_group *blkg,
+				       struct blkio_policy_type *pol) { }
 
 static inline void cfq_blkiocg_update_dispatch_stats(struct blkio_group *blkg,
-				uint64_t bytes, bool direction, bool sync) {}
-static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg, uint64_t start_time, uint64_t io_start_time, bool direction, bool sync) {}
+			struct blkio_policy_type *pol, uint64_t bytes,
+			bool direction, bool sync) { }
+static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg,
+			struct blkio_policy_type *pol, uint64_t start_time,
+			uint64_t io_start_time, bool direction, bool sync) { }
 
 static inline int cfq_blkiocg_del_blkio_group(struct blkio_group *blkg)
 {
-- 
1.7.7.3

