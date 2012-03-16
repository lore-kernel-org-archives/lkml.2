Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946066Ab2CQABW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 20:01:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40344 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162053Ab2CPXgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:36:20 -0400
From: Tejun Heo <tj@kernel.org>
To: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Tejun Heo <tj@kernel.org>,
        Paul Menage <paul@paulmenage.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 05/10] cgroup: convert all non-memcg controllers to the new cftype interface
Date: Fri, 16 Mar 2012 16:35:58 -0700
Message-Id: <1331940963-15756-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331940963-15756-1-git-send-email-tj@kernel.org>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert debug, freezer, cpuset, cpu_cgroup, cpuacct, net_prio, blkio,
net_cls and device controllers to use the new cftype based interface.
Termination entry is added to cftype arrays and populate callbacks are
replaced with CGROUP_SUBSYS_CFTYPES() macro invocations.

This is functionally identical transformation.  There shouldn't be any
visible behavior change.

memcg is rather special and will be converted separately.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 block/blk-cgroup.c        |   10 ++--------
 kernel/cgroup.c           |   10 +++-------
 kernel/cgroup_freezer.c   |   11 +++--------
 kernel/cpuset.c           |   31 ++++++++++---------------------
 kernel/sched/core.c       |   16 ++++------------
 net/core/netprio_cgroup.c |    9 ++-------
 net/sched/cls_cgroup.c    |    9 ++-------
 security/device_cgroup.c  |   10 ++--------
 8 files changed, 28 insertions(+), 78 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 1359d63..2a542b3 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -32,7 +32,6 @@ static struct cgroup_subsys_state *blkiocg_create(struct cgroup *);
 static int blkiocg_can_attach(struct cgroup *, struct cgroup_taskset *);
 static void blkiocg_attach(struct cgroup *, struct cgroup_taskset *);
 static void blkiocg_destroy(struct cgroup *);
-static int blkiocg_populate(struct cgroup_subsys *, struct cgroup *);
 
 /* for encoding cft->private value on file */
 #define BLKIOFILE_PRIVATE(x, val)	(((x) << 16) | (val))
@@ -46,7 +45,6 @@ struct cgroup_subsys blkio_subsys = {
 	.can_attach = blkiocg_can_attach,
 	.attach = blkiocg_attach,
 	.destroy = blkiocg_destroy,
-	.populate = blkiocg_populate,
 #ifdef CONFIG_BLK_CGROUP
 	/* note: blkio_subsys_id is otherwise defined in blk-cgroup.h */
 	.subsys_id = blkio_subsys_id,
@@ -1537,13 +1535,9 @@ struct cftype blkio_files[] = {
 		.read_map = blkiocg_file_read_map,
 	},
 #endif
+	{ }	/* terminate */
 };
-
-static int blkiocg_populate(struct cgroup_subsys *subsys, struct cgroup *cgroup)
-{
-	return cgroup_add_files(cgroup, subsys, blkio_files,
-				ARRAY_SIZE(blkio_files));
-}
+CGROUP_SUBSYS_CFTYPES(blkio_subsys, blkio_files);
 
 static void blkiocg_destroy(struct cgroup *cgroup)
 {
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6c396f3..20fdff9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5350,19 +5350,15 @@ static struct cftype debug_files[] =  {
 		.name = "releasable",
 		.read_u64 = releasable_read,
 	},
-};
 
-static int debug_populate(struct cgroup_subsys *ss, struct cgroup *cont)
-{
-	return cgroup_add_files(cont, ss, debug_files,
-				ARRAY_SIZE(debug_files));
-}
+	{ }	/* terminate */
+};
+CGROUP_SUBSYS_CFTYPES(debug_subsys, debug_files);
 
 struct cgroup_subsys debug_subsys = {
 	.name = "debug",
 	.create = debug_create,
 	.destroy = debug_destroy,
-	.populate = debug_populate,
 	.subsys_id = debug_subsys_id,
 };
 #endif /* CONFIG_CGROUP_DEBUG */
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index f86e939..b89f7c4 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -358,23 +358,18 @@ static int freezer_write(struct cgroup *cgroup,
 static struct cftype files[] = {
 	{
 		.name = "state",
+		.flags = CFTYPE_NOT_ON_ROOT,
 		.read_seq_string = freezer_read,
 		.write_string = freezer_write,
 	},
+	{ }	/* terminate */
 };
-
-static int freezer_populate(struct cgroup_subsys *ss, struct cgroup *cgroup)
-{
-	if (!cgroup->parent)
-		return 0;
-	return cgroup_add_files(cgroup, ss, files, ARRAY_SIZE(files));
-}
+CGROUP_SUBSYS_CFTYPES(freezer_subsys, files);
 
 struct cgroup_subsys freezer_subsys = {
 	.name		= "freezer",
 	.create		= freezer_create,
 	.destroy	= freezer_destroy,
-	.populate	= freezer_populate,
 	.subsys_id	= freezer_subsys_id,
 	.can_attach	= freezer_can_attach,
 	.fork		= freezer_fork,
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 5d57583..2e38198 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1792,28 +1792,18 @@ static struct cftype files[] = {
 		.write_u64 = cpuset_write_u64,
 		.private = FILE_SPREAD_SLAB,
 	},
-};
-
-static struct cftype cft_memory_pressure_enabled = {
-	.name = "memory_pressure_enabled",
-	.read_u64 = cpuset_read_u64,
-	.write_u64 = cpuset_write_u64,
-	.private = FILE_MEMORY_PRESSURE_ENABLED,
-};
 
-static int cpuset_populate(struct cgroup_subsys *ss, struct cgroup *cont)
-{
-	int err;
+	{
+		.name = "memory_pressure_enabled",
+		.flags = CFTYPE_ONLY_ON_ROOT,
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_MEMORY_PRESSURE_ENABLED,
+	},
 
-	err = cgroup_add_files(cont, ss, files, ARRAY_SIZE(files));
-	if (err)
-		return err;
-	/* memory_pressure_enabled is in root cpuset only */
-	if (!cont->parent)
-		err = cgroup_add_file(cont, ss,
-				      &cft_memory_pressure_enabled);
-	return err;
-}
+	{ }	/* terminate */
+};
+CGROUP_SUBSYS_CFTYPES(cpuset_subsys, files);
 
 /*
  * post_clone() is called during cgroup_create() when the
@@ -1914,7 +1904,6 @@ struct cgroup_subsys cpuset_subsys = {
 	.destroy = cpuset_destroy,
 	.can_attach = cpuset_can_attach,
 	.attach = cpuset_attach,
-	.populate = cpuset_populate,
 	.post_clone = cpuset_post_clone,
 	.subsys_id = cpuset_subsys_id,
 	.early_init = 1,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ff12f72..4d69359 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7902,12 +7902,9 @@ static struct cftype cpu_files[] = {
 		.write_u64 = cpu_rt_period_write_uint,
 	},
 #endif
+	{ }	/* terminate */
 };
-
-static int cpu_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *cont)
-{
-	return cgroup_add_files(cont, ss, cpu_files, ARRAY_SIZE(cpu_files));
-}
+CGROUP_SUBSYS_CFTYPES(cpu_cgroup_subsys, cpu_files);
 
 struct cgroup_subsys cpu_cgroup_subsys = {
 	.name		= "cpu",
@@ -7916,7 +7913,6 @@ struct cgroup_subsys cpu_cgroup_subsys = {
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
 	.exit		= cpu_cgroup_exit,
-	.populate	= cpu_cgroup_populate,
 	.subsys_id	= cpu_cgroup_subsys_id,
 	.early_init	= 1,
 };
@@ -8102,12 +8098,9 @@ static struct cftype files[] = {
 		.name = "stat",
 		.read_map = cpuacct_stats_show,
 	},
+	{ }	/* terminate */
 };
-
-static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
-{
-	return cgroup_add_files(cgrp, ss, files, ARRAY_SIZE(files));
-}
+CGROUP_SUBSYS_CFTYPES(cpuacct_subsys, files);
 
 /*
  * charge this task's execution time to its accounting group.
@@ -8140,7 +8133,6 @@ struct cgroup_subsys cpuacct_subsys = {
 	.name = "cpuacct",
 	.create = cpuacct_create,
 	.destroy = cpuacct_destroy,
-	.populate = cpuacct_populate,
 	.subsys_id = cpuacct_subsys_id,
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 22036ab..1aee978 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -25,13 +25,11 @@
 
 static struct cgroup_subsys_state *cgrp_create(struct cgroup *cgrp);
 static void cgrp_destroy(struct cgroup *cgrp);
-static int cgrp_populate(struct cgroup_subsys *ss, struct cgroup *cgrp);
 
 struct cgroup_subsys net_prio_subsys = {
 	.name		= "net_prio",
 	.create		= cgrp_create,
 	.destroy	= cgrp_destroy,
-	.populate	= cgrp_populate,
 #ifdef CONFIG_NETPRIO_CGROUP
 	.subsys_id	= net_prio_subsys_id,
 #endif
@@ -256,12 +254,9 @@ static struct cftype ss_files[] = {
 		.read_map = read_priomap,
 		.write_string = write_priomap,
 	},
+	{ }	/* terminate */
 };
-
-static int cgrp_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
-{
-	return cgroup_add_files(cgrp, ss, ss_files, ARRAY_SIZE(ss_files));
-}
+CGROUP_SUBSYS_CFTYPES(net_prio_subsys, ss_files);
 
 static int netprio_device_event(struct notifier_block *unused,
 				unsigned long event, void *ptr)
diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index 1afaa28..1a856d8 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -24,13 +24,11 @@
 
 static struct cgroup_subsys_state *cgrp_create(struct cgroup *cgrp);
 static void cgrp_destroy(struct cgroup *cgrp);
-static int cgrp_populate(struct cgroup_subsys *ss, struct cgroup *cgrp);
 
 struct cgroup_subsys net_cls_subsys = {
 	.name		= "net_cls",
 	.create		= cgrp_create,
 	.destroy	= cgrp_destroy,
-	.populate	= cgrp_populate,
 #ifdef CONFIG_NET_CLS_CGROUP
 	.subsys_id	= net_cls_subsys_id,
 #endif
@@ -86,12 +84,9 @@ static struct cftype ss_files[] = {
 		.read_u64 = read_classid,
 		.write_u64 = write_classid,
 	},
+	{ }	/* terminate */
 };
-
-static int cgrp_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
-{
-	return cgroup_add_files(cgrp, ss, ss_files, ARRAY_SIZE(ss_files));
-}
+CGROUP_SUBSYS_CFTYPES(net_cls_subsys, ss_files);
 
 struct cls_cgroup_head {
 	u32			handle;
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index c43a332..11cf061 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -447,21 +447,15 @@ static struct cftype dev_cgroup_files[] = {
 		.read_seq_string = devcgroup_seq_read,
 		.private = DEVCG_LIST,
 	},
+	{ }	/* terminate */
 };
-
-static int devcgroup_populate(struct cgroup_subsys *ss,
-				struct cgroup *cgroup)
-{
-	return cgroup_add_files(cgroup, ss, dev_cgroup_files,
-					ARRAY_SIZE(dev_cgroup_files));
-}
+CGROUP_SUBSYS_CFTYPES(devices_subsys, dev_cgroup_files);
 
 struct cgroup_subsys devices_subsys = {
 	.name = "devices",
 	.can_attach = devcgroup_can_attach,
 	.create = devcgroup_create,
 	.destroy = devcgroup_destroy,
-	.populate = devcgroup_populate,
 	.subsys_id = devices_subsys_id,
 };
 
-- 
1.7.7.3

