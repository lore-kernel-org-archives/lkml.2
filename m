Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422648Ab2LNWmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:42:10 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60373 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685Ab2LNWmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:42:05 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/12] cfq-iosched: add hierarchical cfq_group statistics
Date: Fri, 14 Dec 2012 14:41:25 -0800
Message-Id: <1355524885-22719-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355524885-22719-1-git-send-email-tj@kernel.org>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, at this point, there's no way to make the existing
statistics hierarchical without creating nasty surprises for the
existing users.  Just create recursive counterpart of the existing
stats.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/cfq-iosched.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ceade6e..15cb97e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1669,6 +1669,26 @@ static int cfqg_print_rwstat(struct cgroup *cgrp, struct cftype *cft,
 	return 0;
 }
 
+static int cfqg_print_stat_recursive(struct cgroup *cgrp, struct cftype *cft,
+				     struct seq_file *sf)
+{
+	struct blkcg *blkcg = cgroup_to_blkcg(cgrp);
+
+	blkcg_print_blkgs(sf, blkcg, blkg_prfill_stat_recursive,
+			  &blkcg_policy_cfq, cft->private, false);
+	return 0;
+}
+
+static int cfqg_print_rwstat_recursive(struct cgroup *cgrp, struct cftype *cft,
+				       struct seq_file *sf)
+{
+	struct blkcg *blkcg = cgroup_to_blkcg(cgrp);
+
+	blkcg_print_blkgs(sf, blkcg, blkg_prfill_rwstat_recursive,
+			  &blkcg_policy_cfq, cft->private, true);
+	return 0;
+}
+
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 static u64 cfqg_prfill_avg_queue_size(struct seq_file *sf,
 				      struct blkg_policy_data *pd, int off)
@@ -1740,6 +1760,7 @@ static struct cftype cfq_blkcg_files[] = {
 		.write_u64 = cfq_set_leaf_weight,
 	},
 
+	/* statistics, covers only the tasks in the cfqg */
 	{
 		.name = "time",
 		.private = offsetof(struct cfq_group, stats.time),
@@ -1780,6 +1801,48 @@ static struct cftype cfq_blkcg_files[] = {
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
1.7.11.7

