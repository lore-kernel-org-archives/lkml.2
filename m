Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab2BVBsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:48:04 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41551 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab2BVBr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:47:56 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.129.137 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 23/36] blkcg: make blkg->pd an array and move configuration and stats into it
Date: Tue, 21 Feb 2012 17:46:50 -0800
Message-Id: <1329875223-5102-24-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329875223-5102-1-git-send-email-tj@kernel.org>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prepare for unifying blkgs for different policies, make blkg->pd an
array with BLKIO_NR_POLICIES elements and move blkg->conf, ->stats,
and ->stats_cpu into blkg_policy_data.

This patch doesn't introduce any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |  150 ++++++++++++++++++++++++++++++++--------------------
 block/blk-cgroup.h |   18 +++---
 2 files changed, 102 insertions(+), 66 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 3c39b7e..7de64ee 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -184,12 +184,14 @@ static void blkio_check_and_dec_stat(uint64_t *stat, bool direction, bool sync)
 static void blkio_set_start_group_wait_time(struct blkio_group *blkg,
 						struct blkio_group *curr_blkg)
 {
-	if (blkio_blkg_waiting(&blkg->stats))
+	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+
+	if (blkio_blkg_waiting(&pd->stats))
 		return;
 	if (blkg == curr_blkg)
 		return;
-	blkg->stats.start_group_wait_time = sched_clock();
-	blkio_mark_blkg_waiting(&blkg->stats);
+	pd->stats.start_group_wait_time = sched_clock();
+	blkio_mark_blkg_waiting(&pd->stats);
 }
 
 /* This should be called with the blkg->stats_lock held. */
@@ -222,24 +224,26 @@ static void blkio_end_empty_time(struct blkio_group_stats *stats)
 
 void blkiocg_update_set_idle_time_stats(struct blkio_group *blkg)
 {
+	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
 	unsigned long flags;
 
 	spin_lock_irqsave(&blkg->stats_lock, flags);
-	BUG_ON(blkio_blkg_idling(&blkg->stats));
-	blkg->stats.start_idle_time = sched_clock();
-	blkio_mark_blkg_idling(&blkg->stats);
+	BUG_ON(blkio_blkg_idling(&pd->stats));
+	pd->stats.start_idle_time = sched_clock();
+	blkio_mark_blkg_idling(&pd->stats);
 	spin_unlock_irqrestore(&blkg->stats_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_set_idle_time_stats);
 
 void blkiocg_update_idle_time_stats(struct blkio_group *blkg)
 {
+	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
 	unsigned long flags;
 	unsigned long long now;
 	struct blkio_group_stats *stats;
 
 	spin_lock_irqsave(&blkg->stats_lock, flags);
-	stats = &blkg->stats;
+	stats = &pd->stats;
 	if (blkio_blkg_idling(stats)) {
 		now = sched_clock();
 		if (time_after64(now, stats->start_idle_time))
@@ -252,11 +256,12 @@ EXPORT_SYMBOL_GPL(blkiocg_update_idle_time_stats);
 
 void blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg)
 {
+	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
 	unsigned long flags;
 	struct blkio_group_stats *stats;
 
 	spin_lock_irqsave(&blkg->stats_lock, flags);
-	stats = &blkg->stats;
+	stats = &pd->stats;
 	stats->avg_queue_size_sum +=
 			stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_READ] +
 			stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_WRITE];
@@ -268,11 +273,12 @@ EXPORT_SYMBOL_GPL(blkiocg_update_avg_queue_size_stats);
 
 void blkiocg_set_start_empty_time(struct blkio_group *blkg)
 {
+	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
 	unsigned long flags;
 	struct blkio_group_stats *stats;
 
 	spin_lock_irqsave(&blkg->stats_lock, flags);
-	stats = &blkg->stats;
+	stats = &pd->stats;
 
 	if (stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_READ] ||
 			stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_WRITE]) {
@@ -299,7 +305,9 @@ EXPORT_SYMBOL_GPL(blkiocg_set_start_empty_time);
 void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
 			unsigned long dequeue)
 {
-	blkg->stats.dequeue += dequeue;
+	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+
+	pd->stats.dequeue += dequeue;
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_dequeue_stats);
 #else
@@ -312,12 +320,13 @@ void blkiocg_update_io_add_stats(struct blkio_group *blkg,
 			struct blkio_group *curr_blkg, bool direction,
 			bool sync)
 {
+	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
 	unsigned long flags;
 
 	spin_lock_irqsave(&blkg->stats_lock, flags);
-	blkio_add_stat(blkg->stats.stat_arr[BLKIO_STAT_QUEUED], 1, direction,
+	blkio_add_stat(pd->stats.stat_arr[BLKIO_STAT_QUEUED], 1, direction,
 			sync);
-	blkio_end_empty_time(&blkg->stats);
+	blkio_end_empty_time(&pd->stats);
 	blkio_set_start_group_wait_time(blkg, curr_blkg);
 	spin_unlock_irqrestore(&blkg->stats_lock, flags);
 }
@@ -326,10 +335,11 @@ EXPORT_SYMBOL_GPL(blkiocg_update_io_add_stats);
 void blkiocg_update_io_remove_stats(struct blkio_group *blkg,
 						bool direction, bool sync)
 {
+	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
 	unsigned long flags;
 
 	spin_lock_irqsave(&blkg->stats_lock, flags);
-	blkio_check_and_dec_stat(blkg->stats.stat_arr[BLKIO_STAT_QUEUED],
+	blkio_check_and_dec_stat(pd->stats.stat_arr[BLKIO_STAT_QUEUED],
 					direction, sync);
 	spin_unlock_irqrestore(&blkg->stats_lock, flags);
 }
@@ -338,12 +348,13 @@ EXPORT_SYMBOL_GPL(blkiocg_update_io_remove_stats);
 void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time,
 				unsigned long unaccounted_time)
 {
+	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
 	unsigned long flags;
 
 	spin_lock_irqsave(&blkg->stats_lock, flags);
-	blkg->stats.time += time;
+	pd->stats.time += time;
 #ifdef CONFIG_DEBUG_BLK_CGROUP
-	blkg->stats.unaccounted_time += unaccounted_time;
+	pd->stats.unaccounted_time += unaccounted_time;
 #endif
 	spin_unlock_irqrestore(&blkg->stats_lock, flags);
 }
@@ -356,6 +367,7 @@ EXPORT_SYMBOL_GPL(blkiocg_update_timeslice_used);
 void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 				uint64_t bytes, bool direction, bool sync)
 {
+	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
 	struct blkio_group_stats_cpu *stats_cpu;
 	unsigned long flags;
 
@@ -366,7 +378,7 @@ void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 	 */
 	local_irq_save(flags);
 
-	stats_cpu = this_cpu_ptr(blkg->stats_cpu);
+	stats_cpu = this_cpu_ptr(pd->stats_cpu);
 
 	u64_stats_update_begin(&stats_cpu->syncp);
 	stats_cpu->sectors += bytes >> 9;
@@ -382,12 +394,13 @@ EXPORT_SYMBOL_GPL(blkiocg_update_dispatch_stats);
 void blkiocg_update_completion_stats(struct blkio_group *blkg,
 	uint64_t start_time, uint64_t io_start_time, bool direction, bool sync)
 {
+	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
 	struct blkio_group_stats *stats;
 	unsigned long flags;
 	unsigned long long now = sched_clock();
 
 	spin_lock_irqsave(&blkg->stats_lock, flags);
-	stats = &blkg->stats;
+	stats = &pd->stats;
 	if (time_after64(now, io_start_time))
 		blkio_add_stat(stats->stat_arr[BLKIO_STAT_SERVICE_TIME],
 				now - io_start_time, direction, sync);
@@ -402,6 +415,7 @@ EXPORT_SYMBOL_GPL(blkiocg_update_completion_stats);
 void blkiocg_update_io_merged_stats(struct blkio_group *blkg, bool direction,
 					bool sync)
 {
+	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
 	struct blkio_group_stats_cpu *stats_cpu;
 	unsigned long flags;
 
@@ -412,7 +426,7 @@ void blkiocg_update_io_merged_stats(struct blkio_group *blkg, bool direction,
 	 */
 	local_irq_save(flags);
 
-	stats_cpu = this_cpu_ptr(blkg->stats_cpu);
+	stats_cpu = this_cpu_ptr(pd->stats_cpu);
 
 	u64_stats_update_begin(&stats_cpu->syncp);
 	blkio_add_stat(stats_cpu->stat_arr_cpu[BLKIO_STAT_CPU_MERGED], 1,
@@ -430,11 +444,17 @@ EXPORT_SYMBOL_GPL(blkiocg_update_io_merged_stats);
  */
 static void blkg_free(struct blkio_group *blkg)
 {
-	if (blkg) {
-		free_percpu(blkg->stats_cpu);
-		kfree(blkg->pd);
-		kfree(blkg);
+	struct blkg_policy_data *pd;
+
+	if (!blkg)
+		return;
+
+	pd = blkg->pd[blkg->plid];
+	if (pd) {
+		free_percpu(pd->stats_cpu);
+		kfree(pd);
 	}
+	kfree(blkg);
 }
 
 /**
@@ -453,6 +473,7 @@ static struct blkio_group *blkg_alloc(struct blkio_cgroup *blkcg,
 				      struct blkio_policy_type *pol)
 {
 	struct blkio_group *blkg;
+	struct blkg_policy_data *pd;
 
 	/* alloc and init base part */
 	blkg = kzalloc_node(sizeof(*blkg), GFP_ATOMIC, q->node);
@@ -466,23 +487,26 @@ static struct blkio_group *blkg_alloc(struct blkio_cgroup *blkcg,
 	blkg->refcnt = 1;
 	cgroup_path(blkcg->css.cgroup, blkg->path, sizeof(blkg->path));
 
-	/* alloc per-policy data */
-	blkg->pd = kzalloc_node(sizeof(*blkg->pd) + pol->pdata_size, GFP_ATOMIC,
-				q->node);
-	if (!blkg->pd) {
+	/* alloc per-policy data and attach it to blkg */
+	pd = kzalloc_node(sizeof(*pd) + pol->pdata_size, GFP_ATOMIC,
+			  q->node);
+	if (!pd) {
 		blkg_free(blkg);
 		return NULL;
 	}
 
+	blkg->pd[pol->plid] = pd;
+	pd->blkg = blkg;
+
 	/* broken, read comment in the callsite */
-	blkg->stats_cpu = alloc_percpu(struct blkio_group_stats_cpu);
-	if (!blkg->stats_cpu) {
+
+	pd->stats_cpu = alloc_percpu(struct blkio_group_stats_cpu);
+	if (!pd->stats_cpu) {
 		blkg_free(blkg);
 		return NULL;
 	}
 
-	/* attach pd to blkg and invoke per-policy init */
-	blkg->pd->blkg = blkg;
+	/* invoke per-policy init */
 	pol->ops.blkio_init_group_fn(blkg);
 	return blkg;
 }
@@ -659,6 +683,7 @@ EXPORT_SYMBOL_GPL(__blkg_release);
 
 static void blkio_reset_stats_cpu(struct blkio_group *blkg)
 {
+	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
 	struct blkio_group_stats_cpu *stats_cpu;
 	int i, j, k;
 	/*
@@ -673,7 +698,7 @@ static void blkio_reset_stats_cpu(struct blkio_group *blkg)
 	 * unless this becomes a real issue.
 	 */
 	for_each_possible_cpu(i) {
-		stats_cpu = per_cpu_ptr(blkg->stats_cpu, i);
+		stats_cpu = per_cpu_ptr(pd->stats_cpu, i);
 		stats_cpu->sectors = 0;
 		for(j = 0; j < BLKIO_STAT_CPU_NR; j++)
 			for (k = 0; k < BLKIO_STAT_TOTAL; k++)
@@ -698,8 +723,10 @@ blkiocg_reset_stats(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 	blkcg = cgroup_to_blkio_cgroup(cgroup);
 	spin_lock_irq(&blkcg->lock);
 	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
+		struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+
 		spin_lock(&blkg->stats_lock);
-		stats = &blkg->stats;
+		stats = &pd->stats;
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 		idling = blkio_blkg_idling(stats);
 		waiting = blkio_blkg_waiting(stats);
@@ -779,13 +806,14 @@ static uint64_t blkio_fill_stat(char *str, int chars_left, uint64_t val,
 static uint64_t blkio_read_stat_cpu(struct blkio_group *blkg,
 			enum stat_type_cpu type, enum stat_sub_type sub_type)
 {
+	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
 	int cpu;
 	struct blkio_group_stats_cpu *stats_cpu;
 	u64 val = 0, tval;
 
 	for_each_possible_cpu(cpu) {
 		unsigned int start;
-		stats_cpu  = per_cpu_ptr(blkg->stats_cpu, cpu);
+		stats_cpu = per_cpu_ptr(pd->stats_cpu, cpu);
 
 		do {
 			start = u64_stats_fetch_begin(&stats_cpu->syncp);
@@ -837,20 +865,21 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg,
 			       struct cgroup_map_cb *cb, const char *dname,
 			       enum stat_type type)
 {
+	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
 	uint64_t disk_total;
 	char key_str[MAX_KEY_LEN];
 	enum stat_sub_type sub_type;
 
 	if (type == BLKIO_STAT_TIME)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-					blkg->stats.time, cb, dname);
+					pd->stats.time, cb, dname);
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	if (type == BLKIO_STAT_UNACCOUNTED_TIME)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-				       blkg->stats.unaccounted_time, cb, dname);
+				       pd->stats.unaccounted_time, cb, dname);
 	if (type == BLKIO_STAT_AVG_QUEUE_SIZE) {
-		uint64_t sum = blkg->stats.avg_queue_size_sum;
-		uint64_t samples = blkg->stats.avg_queue_size_samples;
+		uint64_t sum = pd->stats.avg_queue_size_sum;
+		uint64_t samples = pd->stats.avg_queue_size_samples;
 		if (samples)
 			do_div(sum, samples);
 		else
@@ -860,26 +889,26 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg,
 	}
 	if (type == BLKIO_STAT_GROUP_WAIT_TIME)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-				       blkg->stats.group_wait_time, cb, dname);
+				       pd->stats.group_wait_time, cb, dname);
 	if (type == BLKIO_STAT_IDLE_TIME)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-				       blkg->stats.idle_time, cb, dname);
+				       pd->stats.idle_time, cb, dname);
 	if (type == BLKIO_STAT_EMPTY_TIME)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-				       blkg->stats.empty_time, cb, dname);
+				       pd->stats.empty_time, cb, dname);
 	if (type == BLKIO_STAT_DEQUEUE)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-				       blkg->stats.dequeue, cb, dname);
+				       pd->stats.dequeue, cb, dname);
 #endif
 
 	for (sub_type = BLKIO_STAT_READ; sub_type < BLKIO_STAT_TOTAL;
 			sub_type++) {
 		blkio_get_key_name(sub_type, dname, key_str, MAX_KEY_LEN,
 				   false);
-		cb->fill(cb, key_str, blkg->stats.stat_arr[type][sub_type]);
+		cb->fill(cb, key_str, pd->stats.stat_arr[type][sub_type]);
 	}
-	disk_total = blkg->stats.stat_arr[type][BLKIO_STAT_READ] +
-			blkg->stats.stat_arr[type][BLKIO_STAT_WRITE];
+	disk_total = pd->stats.stat_arr[type][BLKIO_STAT_READ] +
+			pd->stats.stat_arr[type][BLKIO_STAT_WRITE];
 	blkio_get_key_name(BLKIO_STAT_TOTAL, dname, key_str, MAX_KEY_LEN,
 			   false);
 	cb->fill(cb, key_str, disk_total);
@@ -891,6 +920,7 @@ static int blkio_policy_parse_and_set(char *buf, enum blkio_policy_id plid,
 {
 	struct gendisk *disk = NULL;
 	struct blkio_group *blkg = NULL;
+	struct blkg_policy_data *pd;
 	char *s[4], *p, *major_s = NULL, *minor_s = NULL;
 	unsigned long major, minor;
 	int i = 0, ret = -EINVAL;
@@ -950,35 +980,37 @@ static int blkio_policy_parse_and_set(char *buf, enum blkio_policy_id plid,
 		goto out_unlock;
 	}
 
+	pd = blkg->pd[plid];
+
 	switch (plid) {
 	case BLKIO_POLICY_PROP:
 		if ((temp < BLKIO_WEIGHT_MIN && temp > 0) ||
 		     temp > BLKIO_WEIGHT_MAX)
 			goto out_unlock;
 
-		blkg->conf.weight = temp;
+		pd->conf.weight = temp;
 		blkio_update_group_weight(blkg, temp ?: blkcg->weight);
 		break;
 	case BLKIO_POLICY_THROTL:
 		switch(fileid) {
 		case BLKIO_THROTL_read_bps_device:
-			blkg->conf.bps[READ] = temp;
+			pd->conf.bps[READ] = temp;
 			blkio_update_group_bps(blkg, temp ?: -1, fileid);
 			break;
 		case BLKIO_THROTL_write_bps_device:
-			blkg->conf.bps[WRITE] = temp;
+			pd->conf.bps[WRITE] = temp;
 			blkio_update_group_bps(blkg, temp ?: -1, fileid);
 			break;
 		case BLKIO_THROTL_read_iops_device:
 			if (temp > THROTL_IOPS_MAX)
 				goto out_unlock;
-			blkg->conf.iops[READ] = temp;
+			pd->conf.iops[READ] = temp;
 			blkio_update_group_iops(blkg, temp ?: -1, fileid);
 			break;
 		case BLKIO_THROTL_write_iops_device:
 			if (temp > THROTL_IOPS_MAX)
 				goto out_unlock;
-			blkg->conf.iops[WRITE] = temp;
+			pd->conf.iops[WRITE] = temp;
 			blkio_update_group_iops(blkg, temp ?: -1, fileid);
 			break;
 		}
@@ -1026,31 +1058,32 @@ static int blkiocg_file_write(struct cgroup *cgrp, struct cftype *cft,
 static void blkio_print_group_conf(struct cftype *cft, struct blkio_group *blkg,
 				   struct seq_file *m)
 {
+	struct blkg_policy_data *pd = blkg->pd[blkg->plid];
 	const char *dname = dev_name(blkg->q->backing_dev_info.dev);
 	int fileid = BLKIOFILE_ATTR(cft->private);
 	int rw = WRITE;
 
 	switch (blkg->plid) {
 		case BLKIO_POLICY_PROP:
-			if (blkg->conf.weight)
+			if (pd->conf.weight)
 				seq_printf(m, "%s\t%u\n",
-					   dname, blkg->conf.weight);
+					   dname, pd->conf.weight);
 			break;
 		case BLKIO_POLICY_THROTL:
 			switch (fileid) {
 			case BLKIO_THROTL_read_bps_device:
 				rw = READ;
 			case BLKIO_THROTL_write_bps_device:
-				if (blkg->conf.bps[rw])
+				if (pd->conf.bps[rw])
 					seq_printf(m, "%s\t%llu\n",
-						   dname, blkg->conf.bps[rw]);
+						   dname, pd->conf.bps[rw]);
 				break;
 			case BLKIO_THROTL_read_iops_device:
 				rw = READ;
 			case BLKIO_THROTL_write_iops_device:
-				if (blkg->conf.iops[rw])
+				if (pd->conf.iops[rw])
 					seq_printf(m, "%s\t%u\n",
-						   dname, blkg->conf.iops[rw]);
+						   dname, pd->conf.iops[rw]);
 				break;
 			}
 			break;
@@ -1232,9 +1265,12 @@ static int blkio_weight_write(struct blkio_cgroup *blkcg, int plid, u64 val)
 	spin_lock_irq(&blkcg->lock);
 	blkcg->weight = (unsigned int)val;
 
-	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node)
-		if (blkg->plid == plid && !blkg->conf.weight)
+	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
+		struct blkg_policy_data *pd = blkg->pd[blkg->plid];
+
+		if (blkg->plid == plid && !pd->conf.weight)
 			blkio_update_group_weight(blkg, blkcg->weight);
+	}
 
 	spin_unlock_irq(&blkcg->lock);
 	spin_unlock(&blkio_list_lock);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 7da1068..5dffd43 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -164,6 +164,13 @@ struct blkg_policy_data {
 	/* the blkg this per-policy data belongs to */
 	struct blkio_group *blkg;
 
+	/* Configuration */
+	struct blkio_group_conf conf;
+
+	struct blkio_group_stats stats;
+	/* Per cpu stats pointer */
+	struct blkio_group_stats_cpu __percpu *stats_cpu;
+
 	/* pol->pdata_size bytes of private data used by policy impl */
 	char pdata[] __aligned(__alignof__(unsigned long long));
 };
@@ -180,16 +187,9 @@ struct blkio_group {
 	/* reference count */
 	int refcnt;
 
-	/* Configuration */
-	struct blkio_group_conf conf;
-
 	/* Need to serialize the stats in the case of reset/update */
 	spinlock_t stats_lock;
-	struct blkio_group_stats stats;
-	/* Per cpu stats pointer */
-	struct blkio_group_stats_cpu __percpu *stats_cpu;
-
-	struct blkg_policy_data *pd;
+	struct blkg_policy_data *pd[BLKIO_NR_POLICIES];
 
 	struct rcu_head rcu_head;
 };
@@ -249,7 +249,7 @@ extern void blkg_destroy_all(struct request_queue *q);
 static inline void *blkg_to_pdata(struct blkio_group *blkg,
 			      struct blkio_policy_type *pol)
 {
-	return blkg ? blkg->pd->pdata : NULL;
+	return blkg ? blkg->pd[pol->plid]->pdata : NULL;
 }
 
 /**
-- 
1.7.7.3

