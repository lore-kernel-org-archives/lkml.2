Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab0DMVqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 17:46:16 -0400
Received: from smtp-out.google.com ([74.125.121.35]:20130 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab0DMVqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 17:46:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=iY6ImXl+3tO5ie/hTyZQPudZpUNTGvTS0VYO6QyxJdl2ahNcnmdWU891BKKO5vOtc
	MLFUMOGEdJDQdESZo+OcA==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH] blkio: Fix compile errors
To: jens.axboe@oracle.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, ctalbott@google.com
Date: Tue, 13 Apr 2010 14:45:47 -0700
Message-ID: <20100413214425.10757.20478.stgit@austin.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes compile errors in blk-cgroup code for empty_time stat and a merge fix in
CFQ. The first error was when CONFIG_DEBUG_CFQ_IOSCHED is not set.

Signed-off-by: Divyesh Shah <dpshah@google.com>
---

 block/blk-cgroup.c  |   54 ++++++++++++++++++++++++++-------------------------
 block/cfq-iosched.c |    2 +-
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index aa97cd4..80c1261 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -219,6 +219,33 @@ void blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg)
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_avg_queue_size_stats);
 
+void blkiocg_set_start_empty_time(struct blkio_group *blkg, bool ignore)
+{
+	unsigned long flags;
+	struct blkio_group_stats *stats;
+
+	spin_lock_irqsave(&blkg->stats_lock, flags);
+	stats = &blkg->stats;
+
+	if (stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_READ] ||
+			stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_WRITE]) {
+		spin_unlock_irqrestore(&blkg->stats_lock, flags);
+		return;
+	}
+
+	/*
+	 * If ignore is set, we do not panic on the empty flag being set
+	 * already. This is to avoid cases where there are superfluous timeslice
+	 * complete events (for eg., forced_dispatch in CFQ) when no IOs are
+	 * served which could result in triggering the empty check incorrectly.
+	 */
+	BUG_ON(!ignore && blkio_blkg_empty(stats));
+	stats->start_empty_time = sched_clock();
+	blkio_mark_blkg_empty(stats);
+	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+}
+EXPORT_SYMBOL_GPL(blkiocg_set_start_empty_time);
+
 void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
 			unsigned long dequeue)
 {
@@ -268,33 +295,6 @@ void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time)
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_timeslice_used);
 
-void blkiocg_set_start_empty_time(struct blkio_group *blkg, bool ignore)
-{
-	unsigned long flags;
-	struct blkio_group_stats *stats;
-
-	spin_lock_irqsave(&blkg->stats_lock, flags);
-	stats = &blkg->stats;
-
-	if (stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_READ] ||
-			stats->stat_arr[BLKIO_STAT_QUEUED][BLKIO_STAT_WRITE]) {
-		spin_unlock_irqrestore(&blkg->stats_lock, flags);
-		return;
-	}
-
-	/*
-	 * If ignore is set, we do not panic on the empty flag being set
-	 * already. This is to avoid cases where there are superfluous timeslice
-	 * complete events (for eg., forced_dispatch in CFQ) when no IOs are
-	 * served which could result in triggering the empty check incorrectly.
-	 */
-	BUG_ON(!ignore && blkio_blkg_empty(stats));
-	stats->start_empty_time = sched_clock();
-	blkio_mark_blkg_empty(stats);
-	spin_unlock_irqrestore(&blkg->stats_lock, flags);
-}
-EXPORT_SYMBOL_GPL(blkiocg_set_start_empty_time);
-
 void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 				uint64_t bytes, bool direction, bool sync)
 {
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9e0df2b..0177109 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2231,7 +2231,7 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 	int dispatched = 0;
 
 	/* Expire the timeslice of the current active queue first */
-	cfq_slice_expired(cfqd, 0);
+	cfq_slice_expired(cfqd, 0, true);
 	while ((cfqq = cfq_get_next_queue_forced(cfqd)) != NULL) {
 		__cfq_set_active_queue(cfqd, cfqq);
 		dispatched += __cfq_forced_dispatch_cfqq(cfqq);

