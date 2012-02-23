Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab2BWWbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:31:12 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52037 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2BWWbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:31:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.190.226 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com, akpm@linux-foundation.org,
        hughd@google.com
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, dpshah@google.com, ctalbott@google.com,
        rni@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/8] blkcg: don't use percpu for merged stats
Date: Thu, 23 Feb 2012 14:30:43 -0800
Message-Id: <1330036246-21633-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1330036246-21633-1-git-send-email-tj@kernel.org>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
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
 block/blk-cgroup.c |   22 ++++++----------------
 block/blk-cgroup.h |    6 +++---
 2 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index c7e0de5..ced9acd 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -455,23 +455,13 @@ void blkiocg_update_io_merged_stats(struct blkio_group *blkg,
 				    bool direction, bool sync)
 {
 	struct blkg_policy_data *pd = blkg->pd[pol->plid];
-	struct blkio_group_stats_cpu *stats_cpu;
+	struct blkio_group_stats *stats;
 	unsigned long flags;
 
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
 
@@ -1287,7 +1277,7 @@ static int blkiocg_file_read_map(struct cgroup *cgrp, struct cftype *cft,
 						BLKIO_STAT_WAIT_TIME, 1, 0);
 		case BLKIO_PROP_io_merged:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_CPU_MERGED, 1, 1);
+						BLKIO_STAT_MERGED, 1, 0);
 		case BLKIO_PROP_io_queued:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
 						BLKIO_STAT_QUEUED, 1, 0);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 4bf4c7b..af6e00a 100644
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

