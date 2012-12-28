Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab2L1UhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:37:00 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:43218 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab2L1Ugx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 15:36:53 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 24/24] cfq-iosched: add hierarchical cfq_group statistics
Date: Fri, 28 Dec 2012 12:35:46 -0800
Message-Id: <1356726946-26037-25-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, at this point, there's no way to make the existing
statistics hierarchical without creating nasty surprises for the
existing users.  Just create recursive counterpart of the existing
stats.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/cfq-iosched.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4d75b79..b66365b 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1528,6 +1528,32 @@ static void cfq_pd_offline(struct blkcg_gq *blkg)
 	cfqg_stats_xfer_dead(blkg_to_cfqg(blkg));
 }
 
+/* offset delta from cfqg->stats to cfqg->dead_stats */
+static const int dead_stats_off_delta = offsetof(struct cfq_group, dead_stats) -
+					offsetof(struct cfq_group, stats);
+
+/* to be used by recursive prfill, sums live and dead stats recursively */
+static u64 cfqg_stat_pd_recursive_sum(struct blkg_policy_data *pd, int off)
+{
+	u64 sum = 0;
+
+	sum += blkg_stat_recursive_sum(pd, off);
+	sum += blkg_stat_recursive_sum(pd, off + dead_stats_off_delta);
+	return sum;
+}
+
+/* to be used by recursive prfill, sums live and dead rwstats recursively */
+static struct blkg_rwstat cfqg_rwstat_pd_recursive_sum(struct blkg_policy_data *pd,
+						       int off)
+{
+	struct blkg_rwstat a, b;
+
+	a = blkg_rwstat_recursive_sum(pd, off);
+	b = blkg_rwstat_recursive_sum(pd, off + dead_stats_off_delta);
+	blkg_rwstat_merge(&a, &b);
+	return a;
+}
+
 static void cfq_pd_reset_stats(struct blkcg_gq *blkg)
 {
 	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
@@ -1732,6 +1758,42 @@ static int cfqg_print_rwstat(struct cgroup *cgrp, struct cftype *cft,
 	return 0;
 }
 
+static u64 cfqg_prfill_stat_recursive(struct seq_file *sf,
+				      struct blkg_policy_data *pd, int off)
+{
+	u64 sum = cfqg_stat_pd_recursive_sum(pd, off);
+
+	return __blkg_prfill_u64(sf, pd, sum);
+}
+
+static u64 cfqg_prfill_rwstat_recursive(struct seq_file *sf,
+					struct blkg_policy_data *pd, int off)
+{
+	struct blkg_rwstat sum = cfqg_rwstat_pd_recursive_sum(pd, off);
+
+	return __blkg_prfill_rwstat(sf, pd, &sum);
+}
+
+static int cfqg_print_stat_recursive(struct cgroup *cgrp, struct cftype *cft,
+				     struct seq_file *sf)
+{
+	struct blkcg *blkcg = cgroup_to_blkcg(cgrp);
+
+	blkcg_print_blkgs(sf, blkcg, cfqg_prfill_stat_recursive,
+			  &blkcg_policy_cfq, cft->private, false);
+	return 0;
+}
+
+static int cfqg_print_rwstat_recursive(struct cgroup *cgrp, struct cftype *cft,
+				       struct seq_file *sf)
+{
+	struct blkcg *blkcg = cgroup_to_blkcg(cgrp);
+
+	blkcg_print_blkgs(sf, blkcg, cfqg_prfill_rwstat_recursive,
+			  &blkcg_policy_cfq, cft->private, true);
+	return 0;
+}
+
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 static u64 cfqg_prfill_avg_queue_size(struct seq_file *sf,
 				      struct blkg_policy_data *pd, int off)
@@ -1803,6 +1865,7 @@ static struct cftype cfq_blkcg_files[] = {
 		.write_u64 = cfq_set_leaf_weight,
 	},
 
+	/* statistics, covers only the tasks in the cfqg */
 	{
 		.name = "time",
 		.private = offsetof(struct cfq_group, stats.time),
@@ -1843,6 +1906,48 @@ static struct cftype cfq_blkcg_files[] = {
 		.private = offsetof(struct cfq_group, stats.queued),
 		.read_seq_string = cfqg_print_rwstat,
 	},
+
+	/* the same statictics which cover the cfqg and its descendants */
+	{
+		.name = "time_recursive",
+		.private = offsetof(struct cfq_group, stats.time),
+		.read_seq_string = cfqg_print_stat_recursive,
+	},
+	{
+		.name = "sectors_recursive",
+		.private = offsetof(struct cfq_group, stats.sectors),
+		.read_seq_string = cfqg_print_stat_recursive,
+	},
+	{
+		.name = "io_service_bytes_recursive",
+		.private = offsetof(struct cfq_group, stats.service_bytes),
+		.read_seq_string = cfqg_print_rwstat_recursive,
+	},
+	{
+		.name = "io_serviced_recursive",
+		.private = offsetof(struct cfq_group, stats.serviced),
+		.read_seq_string = cfqg_print_rwstat_recursive,
+	},
+	{
+		.name = "io_service_time_recursive",
+		.private = offsetof(struct cfq_group, stats.service_time),
+		.read_seq_string = cfqg_print_rwstat_recursive,
+	},
+	{
+		.name = "io_wait_time_recursive",
+		.private = offsetof(struct cfq_group, stats.wait_time),
+		.read_seq_string = cfqg_print_rwstat_recursive,
+	},
+	{
+		.name = "io_merged_recursive",
+		.private = offsetof(struct cfq_group, stats.merged),
+		.read_seq_string = cfqg_print_rwstat_recursive,
+	},
+	{
+		.name = "io_queued_recursive",
+		.private = offsetof(struct cfq_group, stats.queued),
+		.read_seq_string = cfqg_print_rwstat_recursive,
+	},
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	{
 		.name = "avg_queue_size",
-- 
1.8.0.2

