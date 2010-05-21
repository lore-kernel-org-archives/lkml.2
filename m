Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab0EUIqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:46:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59489 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab0EUIqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:46:03 -0400
Message-ID: <4BF647DA.2010806@cn.fujitsu.com>
Date: Fri, 21 May 2010 16:44:10 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] io-controller: a new interface to keep track of the time
 since group bacame backlogged
References: <4BF64712.1070500@cn.fujitsu.com>
In-Reply-To: <4BF64712.1070500@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new interface to keep track of the time elapsed since group became
backlogged. Will be reset when group enqueued.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/blk-cgroup.c  |   42 +++++++++++++++++++++++++++++++++++++++++-
 block/blk-cgroup.h  |    9 +++++++++
 block/cfq-iosched.c |   14 ++++++++++++++
 3 files changed, 64 insertions(+), 1 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 749fc6b..5b47655 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -308,6 +308,20 @@ void blkiocg_reset_active_bytes(struct blkio_group *blkg)
 }
 EXPORT_SYMBOL_GPL(blkiocg_reset_active_bytes);
 
+void blkiocg_update_active_start_time(struct blkio_group *blkg)
+{
+	struct blkio_group_stats *stats;
+	unsigned long flags;
+
+	spin_lock_irqsave(&blkg->stats_lock, flags);
+
+	stats = &blkg->stats;
+	stats->active_start_time = get_jiffies_64();
+
+	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+}
+EXPORT_SYMBOL_GPL(blkiocg_update_active_start_time);
+
 void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 				uint64_t bytes, bool direction, bool sync)
 {
@@ -568,6 +582,8 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg,
 	uint64_t disk_total;
 	char key_str[MAX_KEY_LEN];
 	enum stat_sub_type sub_type;
+	struct blkio_policy_type *blkiop;
+	int ret;
 
 	if (type == BLKIO_STAT_TIME)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
@@ -575,6 +591,26 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg,
 	if (type == BLKIO_STAT_SECTORS)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
 					blkg->stats.sectors, cb, dev);
+	if (type == BLKIO_STAT_ACTIVE_TIME) {
+		uint64_t delta;
+
+		delta = get_jiffies_64() -
+			blkg->stats.active_start_time;
+
+		delta = jiffies_to_msecs(delta);
+		list_for_each_entry(blkiop, &blkio_list, list) {
+			ret = blkiop->ops.blkio_is_blkg_active_fn(blkg);
+			/* If group isn't backlogged, don't show */
+			if (!ret) {
+				delta = 0;
+				break;
+			}
+		}
+
+		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
+				       delta, cb, dev);
+	}
+
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	if (type == BLKIO_STAT_AVG_QUEUE_SIZE) {
 		uint64_t sum = blkg->stats.avg_queue_size_sum;
@@ -644,6 +680,7 @@ SHOW_FUNCTION_PER_GROUP(time, BLKIO_STAT_TIME, 0);
 SHOW_FUNCTION_PER_GROUP(sectors, BLKIO_STAT_SECTORS, 0);
 SHOW_FUNCTION_PER_GROUP(io_service_bytes, BLKIO_STAT_SERVICE_BYTES, 1);
 SHOW_FUNCTION_PER_GROUP(io_active_bytes, BLKIO_STAT_ACTIVE_BYTES, 1);
+SHOW_FUNCTION_PER_GROUP(io_active_time, BLKIO_STAT_ACTIVE_TIME, 0);
 SHOW_FUNCTION_PER_GROUP(io_serviced, BLKIO_STAT_SERVICED, 1);
 SHOW_FUNCTION_PER_GROUP(io_service_time, BLKIO_STAT_SERVICE_TIME, 1);
 SHOW_FUNCTION_PER_GROUP(io_wait_time, BLKIO_STAT_WAIT_TIME, 1);
@@ -873,7 +910,10 @@ struct cftype blkio_files[] = {
 		.name = "io_active_bytes",
 		.read_map = blkiocg_io_active_bytes_read,
 	},
-
+	{
+		.name = "io_active_time",
+		.read_map = blkiocg_io_active_time_read,
+	},
 	{
 		.name = "io_serviced",
 		.read_map = blkiocg_io_serviced_read,
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 67d4284..2ae7976 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -35,6 +35,11 @@ enum stat_type {
 	 * when group dequeued.
 	 */
 	BLKIO_STAT_ACTIVE_BYTES,
+	/*
+	 * Total time (in ms) elapsed since group became backlogged, will
+	 * reset when group enqueued.
+	 */
+	BLKIO_STAT_ACTIVE_TIME,
 	/* Total IOs serviced, post merge */
 	BLKIO_STAT_SERVICED,
 	/* Total time spent waiting in scheduler queue in ns */
@@ -83,6 +88,7 @@ struct blkio_group_stats {
 	uint64_t time;
 	uint64_t sectors;
 	uint64_t stat_arr[BLKIO_STAT_QUEUED + 1][BLKIO_STAT_TOTAL];
+	uint64_t active_start_time;
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	/* Sum of number of IOs queued across all samples */
 	uint64_t avg_queue_size_sum;
@@ -135,10 +141,12 @@ extern unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
 typedef void (blkio_unlink_group_fn) (void *key, struct blkio_group *blkg);
 typedef void (blkio_update_group_weight_fn) (struct blkio_group *blkg,
 						unsigned int weight);
+typedef bool (blkio_is_blkg_active) (struct blkio_group *blkg);
 
 struct blkio_policy_ops {
 	blkio_unlink_group_fn *blkio_unlink_group_fn;
 	blkio_update_group_weight_fn *blkio_update_group_weight_fn;
+	blkio_is_blkg_active *blkio_is_blkg_active_fn;
 };
 
 struct blkio_policy_type {
@@ -150,6 +158,7 @@ struct blkio_policy_type {
 extern void blkio_policy_register(struct blkio_policy_type *);
 extern void blkio_policy_unregister(struct blkio_policy_type *);
 extern void blkiocg_reset_active_bytes(struct blkio_group *);
+extern void blkiocg_update_active_start_time(struct blkio_group *);
 
 static inline char *blkg_path(struct blkio_group *blkg)
 {
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d4a3525..b21ae10 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -834,6 +834,7 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	__cfq_group_service_tree_add(st, cfqg);
 	cfqg->on_st = true;
 	st->total_weight += cfqg->weight;
+	blkiocg_update_active_start_time(&cfqg->blkg);
 }
 
 static void
@@ -930,6 +931,18 @@ static inline struct cfq_group *cfqg_of_blkg(struct blkio_group *blkg)
 	return NULL;
 }
 
+bool is_blkg_active(struct blkio_group *blkg)
+{
+	struct cfq_group *cfqg;
+
+	cfqg = cfqg_of_blkg(blkg);
+	if (cfqg && cfqg->on_st)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(is_blkg_active);
+
 void
 cfq_update_blkio_group_weight(struct blkio_group *blkg, unsigned int weight)
 {
@@ -3944,6 +3957,7 @@ static struct blkio_policy_type blkio_policy_cfq = {
 	.ops = {
 		.blkio_unlink_group_fn =	cfq_unlink_blkio_group,
 		.blkio_update_group_weight_fn =	cfq_update_blkio_group_weight,
+		.blkio_is_blkg_active_fn = is_blkg_active,
 	},
 };
 #else
-- 1.5.4.rc3 
