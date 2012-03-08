Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab2CHSyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:54:16 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36344 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899Ab2CHSyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:54:12 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, dpshah@google.com,
        ctalbott@google.com, rni@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/5] blkcg: don't use percpu for merged stats
Date: Thu,  8 Mar 2012 10:53:57 -0800
Message-Id: <1331232840-16044-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331232840-16044-1-git-send-email-tj@kernel.org>
References: <1331232840-16044-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With recent plug merge updates, merged stats are no longer called for
plug merges and now only updated while holding queue_lock.  As
stats_lock is scheduled to be removed, there's no reason to use percpu
for merged stats.  Don't use percpu for merged stats.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |   26 ++++++--------------------
 block/blk-cgroup.h |    6 +++---
 2 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 622fb41..6eedf3a 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -451,27 +451,13 @@ void blkiocg_update_io_merged_stats(struct blkio_group *blkg,
 				    bool direction, bool sync)
 {
 	struct blkg_policy_data *pd = blkg->pd[pol->plid];
-	struct blkio_group_stats_cpu *stats_cpu;
+	struct blkio_group_stats *stats;
 	unsigned long flags;
 
-	/* If per cpu stats are not allocated yet, don't do any accounting. */
-	if (pd->stats_cpu == NULL)
-		return;
-
-	/*
-	 * Disabling interrupts to provide mutual exclusion between two
-	 * writes on same cpu. It probably is not needed for 64bit. Not
-	 * optimizing that case yet.
-	 */
-	local_irq_save(flags);
-
-	stats_cpu = this_cpu_ptr(pd->stats_cpu);
-
-	u64_stats_update_begin(&stats_cpu->syncp);
-	blkio_add_stat(stats_cpu->stat_arr_cpu[BLKIO_STAT_CPU_MERGED], 1,
-				direction, sync);
-	u64_stats_update_end(&stats_cpu->syncp);
-	local_irq_restore(flags);
+	spin_lock_irqsave(&blkg->stats_lock, flags);
+	stats = &pd->stats;
+	blkio_add_stat(stats->stat_arr[BLKIO_STAT_MERGED], 1, direction, sync);
+	spin_unlock_irqrestore(&blkg->stats_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_io_merged_stats);
 
@@ -1342,7 +1328,7 @@ static int blkiocg_file_read_map(struct cgroup *cgrp, struct cftype *cft,
 						BLKIO_STAT_WAIT_TIME, 1, 0);
 		case BLKIO_PROP_io_merged:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_CPU_MERGED, 1, 1);
+						BLKIO_STAT_MERGED, 1, 0);
 		case BLKIO_PROP_io_queued:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
 						BLKIO_STAT_QUEUED, 1, 0);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 1de32fe..6c8e3e3 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -29,10 +29,12 @@ enum blkio_policy_id {
 #ifdef CONFIG_BLK_CGROUP
 
 enum stat_type {
+	/* Number of IOs merged */
+	BLKIO_STAT_MERGED,
 	/* Total time spent (in ns) between request dispatch to the driver and
 	 * request completion for IOs doen by this cgroup. This may not be
 	 * accurate when NCQ is turned on. */
-	BLKIO_STAT_SERVICE_TIME = 0,
+	BLKIO_STAT_SERVICE_TIME,
 	/* Total time spent waiting in scheduler queue in ns */
 	BLKIO_STAT_WAIT_TIME,
 	/* Number of IOs queued up */
@@ -57,8 +59,6 @@ enum stat_type_cpu {
 	BLKIO_STAT_CPU_SERVICE_BYTES,
 	/* Total IOs serviced, post merge */
 	BLKIO_STAT_CPU_SERVICED,
-	/* Number of IOs merged */
-	BLKIO_STAT_CPU_MERGED,
 	BLKIO_STAT_CPU_NR
 };
 
-- 
1.7.7.3

