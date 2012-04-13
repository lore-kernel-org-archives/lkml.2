Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab2DMUOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 16:14:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37922 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab2DMULn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 16:11:43 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/11] cfq: fix build breakage & warnings
Date: Fri, 13 Apr 2012 13:11:25 -0700
Message-Id: <1334347895-6268-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334347895-6268-1-git-send-email-tj@kernel.org>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* CFQ_WEIGHT_* defined inside CONFIG_BLK_CGROUP causes cfq-iosched.c
  compile failure when the config is disabled.  Move it outside the
  ifdef block.

* Dummy cfqg_stats_*() definitions were lacking inline modifiers
  causing unused functions warning if !CONFIG_CFQ_GROUP_IOSCHED.  Add
  them.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.h  |    4 ++--
 block/cfq-iosched.c |   17 ++++++++---------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index ca0ff7c..64392ac 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -27,13 +27,13 @@ enum blkio_policy_id {
 /* Max limits for throttle policy */
 #define THROTL_IOPS_MAX		UINT_MAX
 
-#ifdef CONFIG_BLK_CGROUP
-
 /* CFQ specific, out here for blkcg->cfq_weight */
 #define CFQ_WEIGHT_MIN		10
 #define CFQ_WEIGHT_MAX		1000
 #define CFQ_WEIGHT_DEFAULT	500
 
+#ifdef CONFIG_BLK_CGROUP
+
 enum blkg_rwstat_type {
 	BLKG_RWSTAT_READ,
 	BLKG_RWSTAT_WRITE,
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index cff8b5b..7a8c3e0 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -17,7 +17,7 @@
 #include "blk.h"
 #include "blk-cgroup.h"
 
-static struct blkio_policy_type blkio_policy_cfq;
+static struct blkio_policy_type blkio_policy_cfq __maybe_unused;
 
 /*
  * tunables
@@ -541,14 +541,13 @@ static void cfqg_stats_update_avg_queue_size(struct cfq_group *cfqg)
 
 #else	/* CONFIG_CFQ_GROUP_IOSCHED && CONFIG_DEBUG_BLK_CGROUP */
 
-static void cfqg_stats_set_start_group_wait_time(struct cfq_group *cfqg,
-						 struct cfq_group *curr_cfqg) { }
-static void cfqg_stats_end_empty_time(struct cfqg_stats *stats) { }
-static void cfqg_stats_update_dequeue(struct cfq_group *cfqg) { }
-static void cfqg_stats_set_start_empty_time(struct cfq_group *cfqg) { }
-static void cfqg_stats_update_idle_time(struct cfq_group *cfqg) { }
-static void cfqg_stats_set_start_idle_time(struct cfq_group *cfqg) { }
-static void cfqg_stats_update_avg_queue_size(struct cfq_group *cfqg) { }
+static inline void cfqg_stats_set_start_group_wait_time(struct cfq_group *cfqg, struct cfq_group *curr_cfqg) { }
+static inline void cfqg_stats_end_empty_time(struct cfqg_stats *stats) { }
+static inline void cfqg_stats_update_dequeue(struct cfq_group *cfqg) { }
+static inline void cfqg_stats_set_start_empty_time(struct cfq_group *cfqg) { }
+static inline void cfqg_stats_update_idle_time(struct cfq_group *cfqg) { }
+static inline void cfqg_stats_set_start_idle_time(struct cfq_group *cfqg) { }
+static inline void cfqg_stats_update_avg_queue_size(struct cfq_group *cfqg) { }
 
 #endif	/* CONFIG_CFQ_GROUP_IOSCHED && CONFIG_DEBUG_BLK_CGROUP */
 
-- 
1.7.7.3

