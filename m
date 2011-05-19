Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934549Ab1ESTkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:40:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934495Ab1ESTig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:38:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, axboe@kernel.dk
Cc: dpshah@google.com, vgoyal@redhat.com
Subject: [PATCH 10/13] blk-throttle: Make dispatch stats per cpu
Date: Thu, 19 May 2011 15:38:28 -0400
Message-Id: <1305833911-7717-11-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
References: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we take blkg_stat lock for even updating the stats. So even if
a group has no throttling rules (common case for root group), we end
up taking blkg_lock, for updating the stats.

Make dispatch stats per cpu so that these can be updated without taking
blkg lock.

If cpu goes offline, these stats simply disappear. No protection has
been provided for that yet. Do we really need anything for that?

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |  135 +++++++++++++++++++++++++++++++++++++-------------
 block/blk-cgroup.h   |   27 ++++++++--
 block/blk-throttle.c |    9 +++
 block/cfq-iosched.c  |   18 ++++++-
 4 files changed, 147 insertions(+), 42 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index b0592bc..34bfcef 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -392,20 +392,22 @@ void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time,
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_timeslice_used);
 
+/*
+ * should be called under rcu read lock or queue lock to make sure blkg pointer
+ * is valid.
+ */
 void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 				uint64_t bytes, bool direction, bool sync)
 {
-	struct blkio_group_stats *stats;
-	unsigned long flags;
+	struct blkio_group_stats_cpu *stats_cpu;
 
-	spin_lock_irqsave(&blkg->stats_lock, flags);
-	stats = &blkg->stats;
-	stats->sectors += bytes >> 9;
-	blkio_add_stat(stats->stat_arr[BLKIO_STAT_SERVICED], 1, direction,
-			sync);
-	blkio_add_stat(stats->stat_arr[BLKIO_STAT_SERVICE_BYTES], bytes,
-			direction, sync);
-	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+	stats_cpu = this_cpu_ptr(blkg->stats_cpu);
+
+	stats_cpu->sectors += bytes >> 9;
+	blkio_add_stat(stats_cpu->stat_arr_cpu[BLKIO_STAT_CPU_SERVICED],
+			1, direction, sync);
+	blkio_add_stat(stats_cpu->stat_arr_cpu[BLKIO_STAT_CPU_SERVICE_BYTES],
+			bytes, direction, sync);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_dispatch_stats);
 
@@ -440,6 +442,20 @@ void blkiocg_update_io_merged_stats(struct blkio_group *blkg, bool direction,
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_io_merged_stats);
 
+/*
+ * This function allocates the per cpu stats for blkio_group. Should be called
+ * from sleepable context as alloc_per_cpu() requires that.
+ */
+int blkio_alloc_blkg_stats(struct blkio_group *blkg)
+{
+	/* Allocate memory for per cpu stats */
+	blkg->stats_cpu = alloc_percpu(struct blkio_group_stats_cpu);
+	if (!blkg->stats_cpu)
+		return -ENOMEM;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(blkio_alloc_blkg_stats);
+
 void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 		struct blkio_group *blkg, void *key, dev_t dev,
 		enum blkio_policy_id plid)
@@ -600,6 +616,53 @@ static uint64_t blkio_fill_stat(char *str, int chars_left, uint64_t val,
 	return val;
 }
 
+
+static uint64_t blkio_read_stat_cpu(struct blkio_group *blkg,
+			enum stat_type_cpu type, enum stat_sub_type sub_type)
+{
+	int cpu;
+	struct blkio_group_stats_cpu *stats_cpu;
+	uint64_t val = 0;
+
+	for_each_possible_cpu(cpu) {
+		stats_cpu  = per_cpu_ptr(blkg->stats_cpu, cpu);
+
+		if (type == BLKIO_STAT_CPU_SECTORS)
+			val += stats_cpu->sectors;
+		else
+			val += stats_cpu->stat_arr_cpu[type][sub_type];
+	}
+
+	return val;
+}
+
+static uint64_t blkio_get_stat_cpu(struct blkio_group *blkg,
+		struct cgroup_map_cb *cb, dev_t dev, enum stat_type_cpu type)
+{
+	uint64_t disk_total, val;
+	char key_str[MAX_KEY_LEN];
+	enum stat_sub_type sub_type;
+
+	if (type == BLKIO_STAT_CPU_SECTORS) {
+		val = blkio_read_stat_cpu(blkg, type, 0);
+		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1, val, cb, dev);
+	}
+
+	for (sub_type = BLKIO_STAT_READ; sub_type < BLKIO_STAT_TOTAL;
+			sub_type++) {
+		blkio_get_key_name(sub_type, dev, key_str, MAX_KEY_LEN, false);
+		val = blkio_read_stat_cpu(blkg, type, sub_type);
+		cb->fill(cb, key_str, val);
+	}
+
+	disk_total = blkio_read_stat_cpu(blkg, type, BLKIO_STAT_READ) +
+			blkio_read_stat_cpu(blkg, type, BLKIO_STAT_WRITE);
+
+	blkio_get_key_name(BLKIO_STAT_TOTAL, dev, key_str, MAX_KEY_LEN, false);
+	cb->fill(cb, key_str, disk_total);
+	return disk_total;
+}
+
 /* This should be called with blkg->stats_lock held */
 static uint64_t blkio_get_stat(struct blkio_group *blkg,
 		struct cgroup_map_cb *cb, dev_t dev, enum stat_type type)
@@ -611,9 +674,6 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg,
 	if (type == BLKIO_STAT_TIME)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
 					blkg->stats.time, cb, dev);
-	if (type == BLKIO_STAT_SECTORS)
-		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-					blkg->stats.sectors, cb, dev);
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	if (type == BLKIO_STAT_UNACCOUNTED_TIME)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
@@ -1077,8 +1137,8 @@ static int blkiocg_file_read(struct cgroup *cgrp, struct cftype *cft,
 }
 
 static int blkio_read_blkg_stats(struct blkio_cgroup *blkcg,
-		struct cftype *cft, struct cgroup_map_cb *cb, enum stat_type type,
-		bool show_total)
+		struct cftype *cft, struct cgroup_map_cb *cb,
+		enum stat_type type, bool show_total, bool pcpu)
 {
 	struct blkio_group *blkg;
 	struct hlist_node *n;
@@ -1089,10 +1149,15 @@ static int blkio_read_blkg_stats(struct blkio_cgroup *blkcg,
 		if (blkg->dev) {
 			if (!cftype_blkg_same_policy(cft, blkg))
 				continue;
-			spin_lock_irq(&blkg->stats_lock);
-			cgroup_total += blkio_get_stat(blkg, cb, blkg->dev,
-						type);
-			spin_unlock_irq(&blkg->stats_lock);
+			if (pcpu)
+				cgroup_total += blkio_get_stat_cpu(blkg, cb,
+						blkg->dev, type);
+			else {
+				spin_lock_irq(&blkg->stats_lock);
+				cgroup_total += blkio_get_stat(blkg, cb,
+						blkg->dev, type);
+				spin_unlock_irq(&blkg->stats_lock);
+			}
 		}
 	}
 	if (show_total)
@@ -1116,47 +1181,47 @@ static int blkiocg_file_read_map(struct cgroup *cgrp, struct cftype *cft,
 		switch(name) {
 		case BLKIO_PROP_time:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_TIME, 0);
+						BLKIO_STAT_TIME, 0, 0);
 		case BLKIO_PROP_sectors:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_SECTORS, 0);
+						BLKIO_STAT_CPU_SECTORS, 0, 1);
 		case BLKIO_PROP_io_service_bytes:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_SERVICE_BYTES, 1);
+					BLKIO_STAT_CPU_SERVICE_BYTES, 1, 1);
 		case BLKIO_PROP_io_serviced:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_SERVICED, 1);
+						BLKIO_STAT_CPU_SERVICED, 1, 1);
 		case BLKIO_PROP_io_service_time:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_SERVICE_TIME, 1);
+						BLKIO_STAT_SERVICE_TIME, 1, 0);
 		case BLKIO_PROP_io_wait_time:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_WAIT_TIME, 1);
+						BLKIO_STAT_WAIT_TIME, 1, 0);
 		case BLKIO_PROP_io_merged:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_MERGED, 1);
+						BLKIO_STAT_MERGED, 1, 0);
 		case BLKIO_PROP_io_queued:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_QUEUED, 1);
+						BLKIO_STAT_QUEUED, 1, 0);
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 		case BLKIO_PROP_unaccounted_time:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_UNACCOUNTED_TIME, 0);
+					BLKIO_STAT_UNACCOUNTED_TIME, 0, 0);
 		case BLKIO_PROP_dequeue:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_DEQUEUE, 0);
+						BLKIO_STAT_DEQUEUE, 0, 0);
 		case BLKIO_PROP_avg_queue_size:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_AVG_QUEUE_SIZE, 0);
+					BLKIO_STAT_AVG_QUEUE_SIZE, 0, 0);
 		case BLKIO_PROP_group_wait_time:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_GROUP_WAIT_TIME, 0);
+					BLKIO_STAT_GROUP_WAIT_TIME, 0, 0);
 		case BLKIO_PROP_idle_time:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_IDLE_TIME, 0);
+						BLKIO_STAT_IDLE_TIME, 0, 0);
 		case BLKIO_PROP_empty_time:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_EMPTY_TIME, 0);
+						BLKIO_STAT_EMPTY_TIME, 0, 0);
 #endif
 		default:
 			BUG();
@@ -1166,10 +1231,10 @@ static int blkiocg_file_read_map(struct cgroup *cgrp, struct cftype *cft,
 		switch(name){
 		case BLKIO_THROTL_io_service_bytes:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_SERVICE_BYTES, 1);
+						BLKIO_STAT_CPU_SERVICE_BYTES, 1, 1);
 		case BLKIO_THROTL_io_serviced:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_SERVICED, 1);
+						BLKIO_STAT_CPU_SERVICED, 1, 1);
 		default:
 			BUG();
 		}
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 63f1ef4..fd730a2 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -36,10 +36,6 @@ enum stat_type {
 	 * request completion for IOs doen by this cgroup. This may not be
 	 * accurate when NCQ is turned on. */
 	BLKIO_STAT_SERVICE_TIME = 0,
-	/* Total bytes transferred */
-	BLKIO_STAT_SERVICE_BYTES,
-	/* Total IOs serviced, post merge */
-	BLKIO_STAT_SERVICED,
 	/* Total time spent waiting in scheduler queue in ns */
 	BLKIO_STAT_WAIT_TIME,
 	/* Number of IOs merged */
@@ -48,7 +44,6 @@ enum stat_type {
 	BLKIO_STAT_QUEUED,
 	/* All the single valued stats go below this */
 	BLKIO_STAT_TIME,
-	BLKIO_STAT_SECTORS,
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	/* Time not charged to this cgroup */
 	BLKIO_STAT_UNACCOUNTED_TIME,
@@ -60,6 +55,16 @@ enum stat_type {
 #endif
 };
 
+/* Per cpu stats */
+enum stat_type_cpu {
+	BLKIO_STAT_CPU_SECTORS,
+	/* Total bytes transferred */
+	BLKIO_STAT_CPU_SERVICE_BYTES,
+	/* Total IOs serviced, post merge */
+	BLKIO_STAT_CPU_SERVICED,
+	BLKIO_STAT_CPU_NR
+};
+
 enum stat_sub_type {
 	BLKIO_STAT_READ = 0,
 	BLKIO_STAT_WRITE,
@@ -116,7 +121,6 @@ struct blkio_cgroup {
 struct blkio_group_stats {
 	/* total disk time and nr sectors dispatched by this group */
 	uint64_t time;
-	uint64_t sectors;
 	uint64_t stat_arr[BLKIO_STAT_QUEUED + 1][BLKIO_STAT_TOTAL];
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	/* Time not charged to this cgroup */
@@ -146,6 +150,12 @@ struct blkio_group_stats {
 #endif
 };
 
+/* Per cpu blkio group stats */
+struct blkio_group_stats_cpu {
+	uint64_t sectors;
+	uint64_t stat_arr_cpu[BLKIO_STAT_CPU_NR][BLKIO_STAT_TOTAL];
+};
+
 struct blkio_group {
 	/* An rcu protected unique identifier for the group */
 	void *key;
@@ -161,6 +171,8 @@ struct blkio_group {
 	/* Need to serialize the stats in the case of reset/update */
 	spinlock_t stats_lock;
 	struct blkio_group_stats stats;
+	/* Per cpu stats pointer */
+	struct blkio_group_stats_cpu __percpu *stats_cpu;
 };
 
 struct blkio_policy_node {
@@ -296,6 +308,7 @@ extern struct blkio_cgroup *task_blkio_cgroup(struct task_struct *tsk);
 extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 	struct blkio_group *blkg, void *key, dev_t dev,
 	enum blkio_policy_id plid);
+extern int blkio_alloc_blkg_stats(struct blkio_group *blkg);
 extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
 extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
 						void *key);
@@ -323,6 +336,8 @@ static inline void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 		struct blkio_group *blkg, void *key, dev_t dev,
 		enum blkio_policy_id plid) {}
 
+static inline int blkio_alloc_blkg_stats(struct blkio_group *blkg) { return 0; }
+
 static inline int
 blkiocg_del_blkio_group(struct blkio_group *blkg) { return 0; }
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 90ad407..c29a5a8 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -158,6 +158,7 @@ static void throtl_free_tg(struct rcu_head *head)
 	struct throtl_grp *tg;
 
 	tg = container_of(head, struct throtl_grp, rcu_head);
+	free_percpu(tg->blkg.stats_cpu);
 	kfree(tg);
 }
 
@@ -249,11 +250,19 @@ static void throtl_init_add_tg_lists(struct throtl_data *td,
 static struct throtl_grp *throtl_alloc_tg(struct throtl_data *td)
 {
 	struct throtl_grp *tg = NULL;
+	int ret;
 
 	tg = kzalloc_node(sizeof(*tg), GFP_ATOMIC, td->queue->node);
 	if (!tg)
 		return NULL;
 
+	ret = blkio_alloc_blkg_stats(&tg->blkg);
+
+	if (ret) {
+		kfree(tg);
+		return NULL;
+	}
+
 	throtl_init_group(tg);
 	return tg;
 }
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 606020f..d646b27 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1051,7 +1051,7 @@ static void cfq_init_add_cfqg_lists(struct cfq_data *cfqd,
 static struct cfq_group * cfq_alloc_cfqg(struct cfq_data *cfqd)
 {
 	struct cfq_group *cfqg = NULL;
-	int i, j;
+	int i, j, ret;
 	struct cfq_rb_root *st;
 
 	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC, cfqd->queue->node);
@@ -1069,6 +1069,13 @@ static struct cfq_group * cfq_alloc_cfqg(struct cfq_data *cfqd)
 	 * or cgroup deletion path depending on who is exiting first.
 	 */
 	cfqg->ref = 1;
+
+	ret = blkio_alloc_blkg_stats(&cfqg->blkg);
+	if (ret) {
+		kfree(cfqg);
+		return NULL;
+	}
+
 	return cfqg;
 }
 
@@ -1183,6 +1190,7 @@ static void cfq_put_cfqg(struct cfq_group *cfqg)
 		return;
 	for_each_cfqg_st(cfqg, i, j, st)
 		BUG_ON(!RB_EMPTY_ROOT(&st->rb));
+	free_percpu(cfqg->blkg.stats_cpu);
 	kfree(cfqg);
 }
 
@@ -3995,7 +4003,15 @@ static void *cfq_init_queue(struct request_queue *q)
 	 * throtl_data goes away.
 	 */
 	cfqg->ref = 2;
+
+	if (blkio_alloc_blkg_stats(&cfqg->blkg)) {
+		kfree(cfqg);
+		kfree(cfqd);
+		return NULL;
+	}
+
 	rcu_read_lock();
+
 	cfq_blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg,
 					(void *)cfqd, 0);
 	rcu_read_unlock();
-- 
1.7.4.4

