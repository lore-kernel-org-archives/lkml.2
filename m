Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934518Ab1ESTij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:38:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934387Ab1ESTig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:38:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, axboe@kernel.dk
Cc: dpshah@google.com, vgoyal@redhat.com
Subject: [PATCH 02/13] blk-cgroup: move some fields of unaccounted_time file under right config option
Date: Thu, 19 May 2011 15:38:20 -0400
Message-Id: <1305833911-7717-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
References: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup unaccounted_time file is created only if CONFIG_DEBUG_BLK_CGROUP=y.
there are some fields which are out side this config option. Fix that.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |    2 ++
 block/blk-cgroup.h |    7 ++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 471fdcc..b0592bc 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -385,7 +385,9 @@ void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time,
 
 	spin_lock_irqsave(&blkg->stats_lock, flags);
 	blkg->stats.time += time;
+#ifdef CONFIG_DEBUG_BLK_CGROUP
 	blkg->stats.unaccounted_time += unaccounted_time;
+#endif
 	spin_unlock_irqrestore(&blkg->stats_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_timeslice_used);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index c774930..63f1ef4 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -49,9 +49,9 @@ enum stat_type {
 	/* All the single valued stats go below this */
 	BLKIO_STAT_TIME,
 	BLKIO_STAT_SECTORS,
+#ifdef CONFIG_DEBUG_BLK_CGROUP
 	/* Time not charged to this cgroup */
 	BLKIO_STAT_UNACCOUNTED_TIME,
-#ifdef CONFIG_DEBUG_BLK_CGROUP
 	BLKIO_STAT_AVG_QUEUE_SIZE,
 	BLKIO_STAT_IDLE_TIME,
 	BLKIO_STAT_EMPTY_TIME,
@@ -117,10 +117,11 @@ struct blkio_group_stats {
 	/* total disk time and nr sectors dispatched by this group */
 	uint64_t time;
 	uint64_t sectors;
-	/* Time not charged to this cgroup */
-	uint64_t unaccounted_time;
 	uint64_t stat_arr[BLKIO_STAT_QUEUED + 1][BLKIO_STAT_TOTAL];
 #ifdef CONFIG_DEBUG_BLK_CGROUP
+	/* Time not charged to this cgroup */
+	uint64_t unaccounted_time;
+
 	/* Sum of number of IOs queued across all samples */
 	uint64_t avg_queue_size_sum;
 	/* Count of samples taken for average */
-- 
1.7.4.4

