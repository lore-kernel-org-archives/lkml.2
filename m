Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0EUIo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:44:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58229 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753462Ab0EUIoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:44:55 -0400
Message-ID: <4BF64795.4040000@cn.fujitsu.com>
Date: Fri, 21 May 2010 16:43:01 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] io-controller: a new interface to keep track of bytes
 during group is backlogged
References: <4BF64712.1070500@cn.fujitsu.com>
In-Reply-To: <4BF64712.1070500@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new interface to keep track of how many bytes tranferred since this
group become backlogged. It'll be reset when this group dequeued.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/blk-cgroup.c  |   24 ++++++++++++++++++++++++
 block/blk-cgroup.h  |    6 ++++++
 block/cfq-iosched.c |    1 +
 3 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 60bb049..749fc6b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -292,6 +292,22 @@ void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time)
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_timeslice_used);
 
+void blkiocg_reset_active_bytes(struct blkio_group *blkg)
+{
+	int i;
+	struct blkio_group_stats *stats;
+	unsigned long flags;
+
+	spin_lock_irqsave(&blkg->stats_lock, flags);
+
+	stats = &blkg->stats;
+	for (i = 0; i < BLKIO_STAT_TOTAL; i++)
+		stats->stat_arr[BLKIO_STAT_ACTIVE_BYTES][i] = 0;
+
+	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+}
+EXPORT_SYMBOL_GPL(blkiocg_reset_active_bytes);
+
 void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 				uint64_t bytes, bool direction, bool sync)
 {
@@ -305,6 +321,8 @@ void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 			sync);
 	blkio_add_stat(stats->stat_arr[BLKIO_STAT_SERVICE_BYTES], bytes,
 			direction, sync);
+	blkio_add_stat(stats->stat_arr[BLKIO_STAT_ACTIVE_BYTES], bytes,
+			direction, sync);
 	spin_unlock_irqrestore(&blkg->stats_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_dispatch_stats);
@@ -625,6 +643,7 @@ static int blkiocg_##__VAR##_read(struct cgroup *cgroup,		\
 SHOW_FUNCTION_PER_GROUP(time, BLKIO_STAT_TIME, 0);
 SHOW_FUNCTION_PER_GROUP(sectors, BLKIO_STAT_SECTORS, 0);
 SHOW_FUNCTION_PER_GROUP(io_service_bytes, BLKIO_STAT_SERVICE_BYTES, 1);
+SHOW_FUNCTION_PER_GROUP(io_active_bytes, BLKIO_STAT_ACTIVE_BYTES, 1);
 SHOW_FUNCTION_PER_GROUP(io_serviced, BLKIO_STAT_SERVICED, 1);
 SHOW_FUNCTION_PER_GROUP(io_service_time, BLKIO_STAT_SERVICE_TIME, 1);
 SHOW_FUNCTION_PER_GROUP(io_wait_time, BLKIO_STAT_WAIT_TIME, 1);
@@ -851,6 +870,11 @@ struct cftype blkio_files[] = {
 		.read_map = blkiocg_io_service_bytes_read,
 	},
 	{
+		.name = "io_active_bytes",
+		.read_map = blkiocg_io_active_bytes_read,
+	},
+
+	{
 		.name = "io_serviced",
 		.read_map = blkiocg_io_serviced_read,
 	},
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 2b866ec..67d4284 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -30,6 +30,11 @@ enum stat_type {
 	BLKIO_STAT_SERVICE_TIME = 0,
 	/* Total bytes transferred */
 	BLKIO_STAT_SERVICE_BYTES,
+	/*
+	 * Total bytes transferred since group became backlogged, will reset
+	 * when group dequeued.
+	 */
+	BLKIO_STAT_ACTIVE_BYTES,
 	/* Total IOs serviced, post merge */
 	BLKIO_STAT_SERVICED,
 	/* Total time spent waiting in scheduler queue in ns */
@@ -144,6 +149,7 @@ struct blkio_policy_type {
 /* Blkio controller policy registration */
 extern void blkio_policy_register(struct blkio_policy_type *);
 extern void blkio_policy_unregister(struct blkio_policy_type *);
+extern void blkiocg_reset_active_bytes(struct blkio_group *);
 
 static inline char *blkg_path(struct blkio_group *blkg)
 {
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 0f3eb70..d4a3525 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -858,6 +858,7 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		cfq_rb_erase(&cfqg->rb_node, st);
 	cfqg->saved_workload_slice = 0;
 	blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
+	blkiocg_reset_active_bytes(&cfqg->blkg);
 }
 
 static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
-- 1.5.4.rc3 
