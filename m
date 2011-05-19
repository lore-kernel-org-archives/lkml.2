Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934582Ab1ESTjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:39:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934519Ab1ESTij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:38:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, axboe@kernel.dk
Cc: dpshah@google.com, vgoyal@redhat.com
Subject: [PATCH 11/13] blk-cgroup: Make 64bit per cpu stats safe on 32bit arch
Date: Thu, 19 May 2011 15:38:29 -0400
Message-Id: <1305833911-7717-12-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
References: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the stats are 64bit and updation will be non atomic on 32bit
architecture. Use sequence counters on 32bit arch to make reading
of stats safe.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |   27 ++++++++++++++++++++++-----
 block/blk-cgroup.h |    2 ++
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 34bfcef..3622518e 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -400,14 +400,25 @@ void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 				uint64_t bytes, bool direction, bool sync)
 {
 	struct blkio_group_stats_cpu *stats_cpu;
+	unsigned long flags;
+
+	/*
+	 * Disabling interrupts to provide mutual exclusion between two
+	 * writes on same cpu. It probably is not needed for 64bit. Not
+	 * optimizing that case yet.
+	 */
+	local_irq_save(flags);
 
 	stats_cpu = this_cpu_ptr(blkg->stats_cpu);
 
+	u64_stats_update_begin(&stats_cpu->syncp);
 	stats_cpu->sectors += bytes >> 9;
 	blkio_add_stat(stats_cpu->stat_arr_cpu[BLKIO_STAT_CPU_SERVICED],
 			1, direction, sync);
 	blkio_add_stat(stats_cpu->stat_arr_cpu[BLKIO_STAT_CPU_SERVICE_BYTES],
 			bytes, direction, sync);
+	u64_stats_update_end(&stats_cpu->syncp);
+	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_dispatch_stats);
 
@@ -622,15 +633,21 @@ static uint64_t blkio_read_stat_cpu(struct blkio_group *blkg,
 {
 	int cpu;
 	struct blkio_group_stats_cpu *stats_cpu;
-	uint64_t val = 0;
+	u64 val = 0, tval;
 
 	for_each_possible_cpu(cpu) {
+		unsigned int start;
 		stats_cpu  = per_cpu_ptr(blkg->stats_cpu, cpu);
 
-		if (type == BLKIO_STAT_CPU_SECTORS)
-			val += stats_cpu->sectors;
-		else
-			val += stats_cpu->stat_arr_cpu[type][sub_type];
+		do {
+			start = u64_stats_fetch_begin(&stats_cpu->syncp);
+			if (type == BLKIO_STAT_CPU_SECTORS)
+				tval = stats_cpu->sectors;
+			else
+				tval = stats_cpu->stat_arr_cpu[type][sub_type];
+		} while(u64_stats_fetch_retry(&stats_cpu->syncp, start));
+
+		val += tval;
 	}
 
 	return val;
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index fd730a2..2622267 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -14,6 +14,7 @@
  */
 
 #include <linux/cgroup.h>
+#include <linux/u64_stats_sync.h>
 
 enum blkio_policy_id {
 	BLKIO_POLICY_PROP = 0,		/* Proportional Bandwidth division */
@@ -154,6 +155,7 @@ struct blkio_group_stats {
 struct blkio_group_stats_cpu {
 	uint64_t sectors;
 	uint64_t stat_arr_cpu[BLKIO_STAT_CPU_NR][BLKIO_STAT_TOTAL];
+	struct u64_stats_sync syncp;
 };
 
 struct blkio_group {
-- 
1.7.4.4

