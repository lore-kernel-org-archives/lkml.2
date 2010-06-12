Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab0FLCfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 22:35:42 -0400
Received: from smtp-out.google.com ([74.125.121.35]:16708 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab0FLCfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 22:35:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:content-transfer-encoding;
	b=dqJ3YzjwwGbFhrEILK4WmW2fmeIyVW0d/GV7AraX2rVfIJtmbO3eAgdNBLTl5t1qr
	KIdAxLXDlUYhq1bf63oag==
Subject: [PATCH 2/2] Use ktime_get() instead of sched_clock() for blkio cgroup
	stats.
To: jaxboe@fusionio.com
From: Divyesh Shah <dpshah@google.com>
Cc: peterz@infradead.org, mingo@elte.hu, piotr@hosowicz.com,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com
Date: Fri, 11 Jun 2010 19:35:14 -0700
Message-ID: <20100612023457.14850.50439.stgit@austin.mtv.corp.google.com>
In-Reply-To: <20100612023409.14850.76309.stgit@austin.mtv.corp.google.com>
References: <20100612023409.14850.76309.stgit@austin.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will take care of the pre-emptive kernel issue and the unbounded
TSC drift problem. We will lose resolution though in some cases.

Signed-off-by: Divyesh Shah <dpshah@google.com>
---
 block/blk-cgroup.c     |   22 +++++++++++-----------
 include/linux/blkdev.h |    4 ++--
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index a680964..711766d 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -135,19 +135,19 @@ static void blkio_set_start_group_wait_time(struct blkio_group *blkg,
 		return;
 	if (blkg == curr_blkg)
 		return;
-	blkg->stats.start_group_wait_time = sched_clock();
+	blkg->stats.start_group_wait_time = ktime_to_ns(ktime_get());
 	blkio_mark_blkg_waiting(&blkg->stats);
 }
 
 /* This should be called with the blkg->stats_lock held. */
 static void blkio_update_group_wait_time(struct blkio_group_stats *stats)
 {
-	unsigned long long now;
+	u64 now;
 
 	if (!blkio_blkg_waiting(stats))
 		return;
 
-	now = sched_clock();
+	now = ktime_to_ns(ktime_get());
 	if (time_after64(now, stats->start_group_wait_time))
 		stats->group_wait_time += now - stats->start_group_wait_time;
 	blkio_clear_blkg_waiting(stats);
@@ -156,12 +156,12 @@ static void blkio_update_group_wait_time(struct blkio_group_stats *stats)
 /* This should be called with the blkg->stats_lock held. */
 static void blkio_end_empty_time(struct blkio_group_stats *stats)
 {
-	unsigned long long now;
+	u64 now;
 
 	if (!blkio_blkg_empty(stats))
 		return;
 
-	now = sched_clock();
+	now = ktime_to_ns(ktime_get());
 	if (time_after64(now, stats->start_empty_time))
 		stats->empty_time += now - stats->start_empty_time;
 	blkio_clear_blkg_empty(stats);
@@ -173,7 +173,7 @@ void blkiocg_update_set_idle_time_stats(struct blkio_group *blkg)
 
 	spin_lock_irqsave(&blkg->stats_lock, flags);
 	BUG_ON(blkio_blkg_idling(&blkg->stats));
-	blkg->stats.start_idle_time = sched_clock();
+	blkg->stats.start_idle_time = ktime_to_ns(ktime_get());
 	blkio_mark_blkg_idling(&blkg->stats);
 	spin_unlock_irqrestore(&blkg->stats_lock, flags);
 }
@@ -182,13 +182,13 @@ EXPORT_SYMBOL_GPL(blkiocg_update_set_idle_time_stats);
 void blkiocg_update_idle_time_stats(struct blkio_group *blkg)
 {
 	unsigned long flags;
-	unsigned long long now;
+	u64 now;
 	struct blkio_group_stats *stats;
 
 	spin_lock_irqsave(&blkg->stats_lock, flags);
 	stats = &blkg->stats;
 	if (blkio_blkg_idling(stats)) {
-		now = sched_clock();
+		now = ktime_to_ns(ktime_get());
 		if (time_after64(now, stats->start_idle_time))
 			stats->idle_time += now - stats->start_idle_time;
 		blkio_clear_blkg_idling(stats);
@@ -237,7 +237,7 @@ void blkiocg_set_start_empty_time(struct blkio_group *blkg)
 		return;
 	}
 
-	stats->start_empty_time = sched_clock();
+	stats->start_empty_time = ktime_to_ns(ktime_get());
 	blkio_mark_blkg_empty(stats);
 	spin_unlock_irqrestore(&blkg->stats_lock, flags);
 }
@@ -314,7 +314,7 @@ void blkiocg_update_completion_stats(struct blkio_group *blkg,
 {
 	struct blkio_group_stats *stats;
 	unsigned long flags;
-	unsigned long long now = sched_clock();
+	u64 now = ktime_to_ns(ktime_get());
 
 	spin_lock_irqsave(&blkg->stats_lock, flags);
 	stats = &blkg->stats;
@@ -464,7 +464,7 @@ blkiocg_reset_stats(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 	int i;
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	bool idling, waiting, empty;
-	unsigned long long now = sched_clock();
+	u64 now = ktime_to_ns(ktime_get());
 #endif
 
 	blkcg = cgroup_to_blkio_cgroup(cgroup);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ebe788e..f174b34 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1218,12 +1218,12 @@ int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
  */
 static inline void set_start_time_ns(struct request *req)
 {
-	req->start_time_ns = sched_clock();
+	req->start_time_ns = ktime_to_ns(ktime_get());
 }
 
 static inline void set_io_start_time_ns(struct request *req)
 {
-	req->io_start_time_ns = sched_clock();
+	req->io_start_time_ns = ktime_to_ns(ktime_get());
 }
 
 static inline uint64_t rq_start_time_ns(struct request *req)

