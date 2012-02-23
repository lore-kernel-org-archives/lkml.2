Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab2BWWbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:31:17 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51487 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab2BWWbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:31:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.136.100 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com, akpm@linux-foundation.org,
        hughd@google.com
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, dpshah@google.com, ctalbott@google.com,
        rni@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/8] blkcg: restructure blkio_get_stat()
Date: Thu, 23 Feb 2012 14:30:45 -0800
Message-Id: <1330036246-21633-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1330036246-21633-1-git-send-email-tj@kernel.org>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restructure blkio_get_stat() to prepare for removal of stats_lock.

* Define BLKIO_STAT_ARR_NR explicitly to denote which stats have
  subtypes instead of using BLKIO_STAT_QUEUED.

* Separate out stat acquisition and printing.  After this, there are
  only two users of blkio_fill_stat().  Just open code it.

* The code was mixing MAX_KEY_LEN and MAX_KEY_LEN - 1.  There's no
  need to subtract one.  Use MAX_KEY_LEN consistently.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |  100 ++++++++++++++++++++++++++-------------------------
 block/blk-cgroup.h |    6 +++-
 2 files changed, 56 insertions(+), 50 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 614b7b3..bc2d1f3 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -833,15 +833,6 @@ static void blkio_get_key_name(enum stat_sub_type type, const char *dname,
 	}
 }
 
-static uint64_t blkio_fill_stat(char *str, int chars_left, uint64_t val,
-				struct cgroup_map_cb *cb, const char *dname)
-{
-	blkio_get_key_name(0, dname, str, chars_left, true);
-	cb->fill(cb, str, val);
-	return val;
-}
-
-
 static uint64_t blkio_read_stat_cpu(struct blkio_group *blkg, int plid,
 			enum stat_type_cpu type, enum stat_sub_type sub_type)
 {
@@ -878,8 +869,9 @@ static uint64_t blkio_get_stat_cpu(struct blkio_group *blkg, int plid,
 
 	if (type == BLKIO_STAT_CPU_SECTORS) {
 		val = blkio_read_stat_cpu(blkg, plid, type, 0);
-		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1, val, cb,
-				       dname);
+		blkio_get_key_name(0, dname, key_str, MAX_KEY_LEN, true);
+		cb->fill(cb, key_str, val);
+		return val;
 	}
 
 	for (sub_type = BLKIO_STAT_READ; sub_type < BLKIO_STAT_TOTAL;
@@ -904,50 +896,60 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg, int plid,
 			       struct cgroup_map_cb *cb, const char *dname,
 			       enum stat_type type)
 {
-	struct blkg_policy_data *pd = blkg->pd[plid];
-	uint64_t disk_total;
+	struct blkio_group_stats *stats = &blkg->pd[plid]->stats;
+	uint64_t v = 0, disk_total = 0;
 	char key_str[MAX_KEY_LEN];
-	enum stat_sub_type sub_type;
+	int st;
 
-	if (type == BLKIO_STAT_TIME)
-		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-					pd->stats.time, cb, dname);
+	if (type >= BLKIO_STAT_ARR_NR) {
+		switch (type) {
+		case BLKIO_STAT_TIME:
+			v = stats->time;
+			break;
 #ifdef CONFIG_DEBUG_BLK_CGROUP
-	if (type == BLKIO_STAT_UNACCOUNTED_TIME)
-		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-				       pd->stats.unaccounted_time, cb, dname);
-	if (type == BLKIO_STAT_AVG_QUEUE_SIZE) {
-		uint64_t sum = pd->stats.avg_queue_size_sum;
-		uint64_t samples = pd->stats.avg_queue_size_samples;
-		if (samples)
-			do_div(sum, samples);
-		else
-			sum = 0;
-		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-				       sum, cb, dname);
-	}
-	if (type == BLKIO_STAT_GROUP_WAIT_TIME)
-		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-				       pd->stats.group_wait_time, cb, dname);
-	if (type == BLKIO_STAT_IDLE_TIME)
-		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-				       pd->stats.idle_time, cb, dname);
-	if (type == BLKIO_STAT_EMPTY_TIME)
-		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-				       pd->stats.empty_time, cb, dname);
-	if (type == BLKIO_STAT_DEQUEUE)
-		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
-				       pd->stats.dequeue, cb, dname);
+		case BLKIO_STAT_UNACCOUNTED_TIME:
+			v = stats->unaccounted_time;
+			break;
+		case BLKIO_STAT_AVG_QUEUE_SIZE: {
+			uint64_t samples = stats->avg_queue_size_samples;
+
+			if (samples) {
+				v = stats->avg_queue_size_sum;
+				do_div(v, samples);
+			}
+			break;
+		}
+		case BLKIO_STAT_IDLE_TIME:
+			v = stats->idle_time;
+			break;
+		case BLKIO_STAT_EMPTY_TIME:
+			v = stats->empty_time;
+			break;
+		case BLKIO_STAT_DEQUEUE:
+			v = stats->dequeue;
+			break;
+		case BLKIO_STAT_GROUP_WAIT_TIME:
+			v = stats->group_wait_time;
+			break;
 #endif
+		default:
+			WARN_ON_ONCE(1);
+		}
 
-	for (sub_type = BLKIO_STAT_READ; sub_type < BLKIO_STAT_TOTAL;
-			sub_type++) {
-		blkio_get_key_name(sub_type, dname, key_str, MAX_KEY_LEN,
-				   false);
-		cb->fill(cb, key_str, pd->stats.stat_arr[type][sub_type]);
+		blkio_get_key_name(0, dname, key_str, MAX_KEY_LEN, true);
+		cb->fill(cb, key_str, v);
+		return v;
 	}
-	disk_total = pd->stats.stat_arr[type][BLKIO_STAT_READ] +
-			pd->stats.stat_arr[type][BLKIO_STAT_WRITE];
+
+	for (st = BLKIO_STAT_READ; st < BLKIO_STAT_TOTAL; st++) {
+		v = stats->stat_arr[type][st];
+
+		blkio_get_key_name(st, dname, key_str, MAX_KEY_LEN, false);
+		cb->fill(cb, key_str, v);
+		if (st == BLKIO_STAT_READ || st == BLKIO_STAT_WRITE)
+			disk_total += v;
+	}
+
 	blkio_get_key_name(BLKIO_STAT_TOTAL, dname, key_str, MAX_KEY_LEN,
 			   false);
 	cb->fill(cb, key_str, disk_total);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 3937a9e..1425de1 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -39,6 +39,7 @@ enum stat_type {
 	BLKIO_STAT_WAIT_TIME,
 	/* Number of IOs queued up */
 	BLKIO_STAT_QUEUED,
+
 	/* All the single valued stats go below this */
 	BLKIO_STAT_TIME,
 #ifdef CONFIG_DEBUG_BLK_CGROUP
@@ -52,6 +53,9 @@ enum stat_type {
 #endif
 };
 
+/* Types lower than this live in stat_arr and have subtypes */
+#define BLKIO_STAT_ARR_NR	(BLKIO_STAT_QUEUED + 1)
+
 /* Per cpu stats */
 enum stat_type_cpu {
 	BLKIO_STAT_CPU_SECTORS,
@@ -117,7 +121,7 @@ struct blkio_cgroup {
 struct blkio_group_stats {
 	/* total disk time and nr sectors dispatched by this group */
 	uint64_t time;
-	uint64_t stat_arr[BLKIO_STAT_QUEUED + 1][BLKIO_STAT_TOTAL];
+	uint64_t stat_arr[BLKIO_STAT_ARR_NR][BLKIO_STAT_TOTAL];
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	/* Time not charged to this cgroup */
 	uint64_t unaccounted_time;
-- 
1.7.7.3

