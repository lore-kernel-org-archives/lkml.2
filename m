Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab1EUADR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:03:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419Ab1EUACy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:02:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: dpshah@google.com, namhyung@gmail.com, vgoyal@redhat.com
Subject: [PATCH 2/3] cfq-iosched: Make IO merge related stats per cpu
Date: Fri, 20 May 2011 20:02:46 -0400
Message-Id: <1305936167-8932-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305936167-8932-1-git-send-email-vgoyal@redhat.com>
References: <1305936167-8932-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make BLKIO_STAT_MERGED per cpu hence gettring rid of need of taking
blkg->stats_lock.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |   22 +++++++++++++++++-----
 block/blk-cgroup.h |    4 ++--
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index e41cc6f..07371cf 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -441,15 +441,27 @@ void blkiocg_update_completion_stats(struct blkio_group *blkg,
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_completion_stats);
 
+/*  Merged stats are per cpu.  */
 void blkiocg_update_io_merged_stats(struct blkio_group *blkg, bool direction,
 					bool sync)
 {
+	struct blkio_group_stats_cpu *stats_cpu;
 	unsigned long flags;
 
-	spin_lock_irqsave(&blkg->stats_lock, flags);
-	blkio_add_stat(blkg->stats.stat_arr[BLKIO_STAT_MERGED], 1, direction,
-			sync);
-	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+	/*
+	 * Disabling interrupts to provide mutual exclusion between two
+	 * writes on same cpu. It probably is not needed for 64bit. Not
+	 * optimizing that case yet.
+	 */
+	local_irq_save(flags);
+
+	stats_cpu = this_cpu_ptr(blkg->stats_cpu);
+
+	u64_stats_update_begin(&stats_cpu->syncp);
+	blkio_add_stat(stats_cpu->stat_arr_cpu[BLKIO_STAT_CPU_MERGED], 1,
+				direction, sync);
+	u64_stats_update_end(&stats_cpu->syncp);
+	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_io_merged_stats);
 
@@ -1244,7 +1256,7 @@ static int blkiocg_file_read_map(struct cgroup *cgrp, struct cftype *cft,
 						BLKIO_STAT_WAIT_TIME, 1, 0);
 		case BLKIO_PROP_io_merged:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_MERGED, 1, 0);
+						BLKIO_STAT_CPU_MERGED, 1, 1);
 		case BLKIO_PROP_io_queued:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
 						BLKIO_STAT_QUEUED, 1, 0);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 2622267..a71d290 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -39,8 +39,6 @@ enum stat_type {
 	BLKIO_STAT_SERVICE_TIME = 0,
 	/* Total time spent waiting in scheduler queue in ns */
 	BLKIO_STAT_WAIT_TIME,
-	/* Number of IOs merged */
-	BLKIO_STAT_MERGED,
 	/* Number of IOs queued up */
 	BLKIO_STAT_QUEUED,
 	/* All the single valued stats go below this */
@@ -63,6 +61,8 @@ enum stat_type_cpu {
 	BLKIO_STAT_CPU_SERVICE_BYTES,
 	/* Total IOs serviced, post merge */
 	BLKIO_STAT_CPU_SERVICED,
+	/* Number of IOs merged */
+	BLKIO_STAT_CPU_MERGED,
 	BLKIO_STAT_CPU_NR
 };
 
-- 
1.7.4.4

