Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab1GDNIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 09:08:52 -0400
Received: from relay.parallels.com ([195.214.232.42]:47178 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941Ab1GDNIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 09:08:41 -0400
Subject: [PATCH RFC 2/2] blkio-cgroup: add max wait time statistics
To: Jens Axboe <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Mon, 4 Jul 2011 17:08:39 +0400
Message-ID: <20110704130839.27757.47444.stgit@localhost6>
In-Reply-To: <20110704130838.27757.87486.stgit@localhost6>
References: <20110704130838.27757.87486.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds blk-cgroup attribute blkio.io_wait_max to show
maximum time spent waiting in scheduler queue.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 block/blk-cgroup.c |   27 ++++++++++++++++++++++++++-
 block/blk-cgroup.h |    3 +++
 2 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bcaf16e..cadb4dc 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -197,6 +197,19 @@ static void blkio_add_stat(uint64_t *stat, uint64_t add, bool direction,
 		stat[BLKIO_STAT_ASYNC] += add;
 }
 
+static void blkio_max_stat(uint64_t *stat, uint64_t cur, bool direction,
+				bool sync)
+{
+	if (direction)
+		stat[BLKIO_STAT_WRITE] = max(stat[BLKIO_STAT_WRITE], cur);
+	else
+		stat[BLKIO_STAT_READ] = max(stat[BLKIO_STAT_READ], cur);
+	if (sync)
+		stat[BLKIO_STAT_SYNC] = max(stat[BLKIO_STAT_SYNC], cur);
+	else
+		stat[BLKIO_STAT_ASYNC] = max(stat[BLKIO_STAT_ASYNC], cur);
+}
+
 /*
  * Decrements the appropriate stat variable if non-zero depending on the
  * request type. Panics on value being zero.
@@ -432,9 +445,12 @@ void blkiocg_update_completion_stats(struct blkio_group *blkg,
 	if (time_after64(now, io_start_time))
 		blkio_add_stat(stats->stat_arr[BLKIO_STAT_SERVICE_TIME],
 				now - io_start_time, direction, sync);
-	if (time_after64(io_start_time, start_time))
+	if (time_after64(io_start_time, start_time)) {
 		blkio_add_stat(stats->stat_arr[BLKIO_STAT_WAIT_TIME],
 				io_start_time - start_time, direction, sync);
+		blkio_max_stat(stats->stat_arr[BLKIO_STAT_WAIT_MAX],
+				io_start_time - start_time, direction, sync);
+	}
 	spin_unlock_irqrestore(&blkg->stats_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_completion_stats);
@@ -1252,6 +1268,9 @@ static int blkiocg_file_read_map(struct cgroup *cgrp, struct cftype *cft,
 		case BLKIO_PROP_io_wait_time:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
 						BLKIO_STAT_WAIT_TIME, 1, 0);
+		case BLKIO_PROP_io_wait_max:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_WAIT_MAX, 0, 0);
 		case BLKIO_PROP_io_merged:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
 						BLKIO_STAT_CPU_MERGED, 1, 1);
@@ -1423,6 +1442,12 @@ struct cftype blkio_files[] = {
 		.read_map = blkiocg_file_read_map,
 	},
 	{
+		.name = "io_wait_max",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_io_wait_max),
+		.read_map = blkiocg_file_read_map,
+	},
+	{
 		.name = "io_merged",
 		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
 				BLKIO_PROP_io_merged),
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index a71d290..8538699 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -39,6 +39,8 @@ enum stat_type {
 	BLKIO_STAT_SERVICE_TIME = 0,
 	/* Total time spent waiting in scheduler queue in ns */
 	BLKIO_STAT_WAIT_TIME,
+	/* Maximum time spent waiting in scheduler queue in ns */
+	BLKIO_STAT_WAIT_MAX,
 	/* Number of IOs queued up */
 	BLKIO_STAT_QUEUED,
 	/* All the single valued stats go below this */
@@ -92,6 +94,7 @@ enum blkcg_file_name_prop {
 	BLKIO_PROP_unaccounted_time,
 	BLKIO_PROP_io_service_time,
 	BLKIO_PROP_io_wait_time,
+	BLKIO_PROP_io_wait_max,
 	BLKIO_PROP_io_merged,
 	BLKIO_PROP_io_queued,
 	BLKIO_PROP_avg_queue_size,

