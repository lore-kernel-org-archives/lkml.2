Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab2ISWoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 18:44:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46625 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab2ISWoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 18:44:10 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, lizefan@huawei.com
Cc: peterz@infradead.org, glommer@parallels.com, mhocko@suse.cz,
        kay.sievers@vrfy.org, mzxreary@0pointer.de, davej@redhat.com,
        ben@decadent.org.uk, pjt@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/3] cgroup, sched: deprecate cpuacct
Date: Wed, 19 Sep 2012 15:43:45 -0700
Message-Id: <1348094625-4471-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1348094625-4471-1-git-send-email-tj@kernel.org>
References: <1348094625-4471-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that cpu serves the same files as cpuacct and using cpuacct
separately from cpu is deprecated, we can deprecate cpuacct.  To avoid
disturbing userland which has been co-mounting cpu and cpuacct,
implement some hackery in cgroup core so that cpuacct co-mounting
still works even if cpuacct is disabled.

The goal of this patch is to accelerate disabling and removal of
cpuacct by decoupling kernel-side deprecation from userland changes.
Userland is recommended to do the following.

* If /proc/cgroups lists cpuacct, always co-mount it with cpu under
  e.g. /sys/fs/cgroup/cpu.

* Optionally create symlinks for compatibility -
  e.g. /sys/fs/cgroup/cpuacct and /sys/fs/cgroup/cpu,cpucct both
  pointing to /sys/fs/cgroup/cpu - whether cpuacct exists or not.

This compatibility hack will eventually go away.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>
Cc: Dave Jones <davej@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Paul Turner <pjt@google.com>
---
 init/Kconfig        |   11 ++++++++++-
 kernel/cgroup.c     |   41 +++++++++++++++++++++++++++++++++++++++--
 kernel/sched/core.c |    2 ++
 3 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index af6c7f8..a13cf8f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -675,11 +675,20 @@ config PROC_PID_CPUSET
 	default y
 
 config CGROUP_CPUACCT
-	bool "Simple CPU accounting cgroup subsystem"
+	bool "DEPRECATED: Simple CPU accounting cgroup subsystem"
+	default n
 	help
 	  Provides a simple Resource Controller for monitoring the
 	  total CPU consumed by the tasks in a cgroup.
 
+	  This cgroup subsystem is deprecated.  The CPU cgroup
+	  subsystem serves the same accounting files and "cpuacct"
+	  mount option is ignored if specified with "cpu".  As long as
+	  userland co-mounts cpu and cpuacct, disabling this
+	  controller should be mostly unnoticeable - one notable
+	  difference is that /proc/PID/cgroup won't list cpuacct
+	  anymore.
+
 config RESOURCE_COUNTERS
 	bool "Resource counters"
 	help
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 01c11e3..a577f6c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1157,6 +1157,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 	unsigned long mask = (unsigned long)-1;
 	int i;
 	bool module_pin_failed = false;
+	bool cpuacct_requested = false;
 
 	BUG_ON(!mutex_is_locked(&cgroup_mutex));
 
@@ -1242,8 +1243,13 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 
 			break;
 		}
-		if (i == CGROUP_SUBSYS_COUNT)
+		/* handle deprecated cpuacct specially, see below */
+		if (!strcmp(token, "cpuacct")) {
+			cpuacct_requested = true;
+			one_ss = true;
+		} else if (i == CGROUP_SUBSYS_COUNT) {
 			return -ENOENT;
+		}
 	}
 
 	/*
@@ -1270,8 +1276,25 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 	 * this creates some discrepancies in /proc/cgroups and
 	 * /proc/PID/cgroup.
 	 *
+	 * Accept and ignore "cpuacct" option if comounted with "cpu" even
+	 * when cpuacct itself is disabled to allow quick disabling and
+	 * removal of cpuacct.  This will be removed eventually.
+	 *
 	 * https://lkml.org/lkml/2012/9/13/542
 	 */
+	if (cpuacct_requested) {
+		bool comounted = false;
+
+#if IS_ENABLED(CONFIG_CGROUP_SCHED)
+		comounted = opts->subsys_bits & (1 << cpu_cgroup_subsys_id);
+#endif
+		if (!comounted) {
+			pr_warning("cgroup: mounting cpuacct separately from cpu is deprecated\n");
+#if !IS_ENABLED(CONFIG_CGROUP_CPUACCT)
+			return -EINVAL;
+#endif
+		}
+	}
 #if IS_ENABLED(CONFIG_CGROUP_SCHED) && IS_ENABLED(CONFIG_CGROUP_CPUACCT)
 	if ((opts->subsys_bits & (1 << cpu_cgroup_subsys_id)) &&
 	    (opts->subsys_bits & (1 << cpuacct_subsys_id)))
@@ -4678,6 +4701,7 @@ const struct file_operations proc_cgroup_operations = {
 /* Display information about each subsystem and each hierarchy */
 static int proc_cgroupstats_show(struct seq_file *m, void *v)
 {
+	struct cgroup_subsys *ss;
 	int i;
 
 	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\tenabled\n");
@@ -4688,7 +4712,7 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
 	 */
 	mutex_lock(&cgroup_mutex);
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
-		struct cgroup_subsys *ss = subsys[i];
+		ss = subsys[i];
 		if (ss == NULL)
 			continue;
 		seq_printf(m, "%s\t%d\t%d\t%d\n",
@@ -4696,6 +4720,19 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
 			   ss->root->number_of_cgroups, !ss->disabled);
 	}
 	mutex_unlock(&cgroup_mutex);
+
+	/*
+	 * Fake /proc/cgroups entry for cpuacct to trick userland into
+	 * cpu,cpuacct comounts.  This is to allow quick disabling and
+	 * removal of cpuacct and will be removed eventually.
+	 */
+#if IS_ENABLED(CONFIG_CGROUP_SCHED) && !IS_ENABLED(CONFIG_CGROUP_CPUACCT)
+	ss = subsys[cpu_cgroup_subsys_id];
+	if (ss) {
+		seq_printf(m, "cpuacct\t%d\t%d\t%d\n", ss->root->hierarchy_id,
+			   ss->root->number_of_cgroups, !ss->disabled);
+	}
+#endif
 	return 0;
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9648671..10176a3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8569,6 +8569,8 @@ struct cgroup_subsys cpu_cgroup_subsys = {
 
 #ifdef CONFIG_CGROUP_CPUACCT
 
+#warning CONFIG_CGROUP_CPUACCT is deprecated, read the Kconfig help message
+
 /*
  * CPU accounting code for task groups.
  *
-- 
1.7.7.3

