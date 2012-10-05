Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab2JENDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 09:03:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34656 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab2JENDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 09:03:01 -0400
Date: Fri, 5 Oct 2012 06:02:45 -0700
From: tip-bot for Tang Chen <tangchen@cn.fujitsu.com>
Message-ID: <tip-301a5cba2887d1f640e6d5184b05a6d7132017d5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        wency@cn.fujitsu.com, a.p.zijlstra@chello.nl, tangchen@cn.fujitsu.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        wency@cn.fujitsu.com, a.p.zijlstra@chello.nl, tangchen@cn.fujitsu.com,
        tglx@linutronix.de
In-Reply-To: <1348578751-16904-3-git-send-email-tangchen@cn.fujitsu.com>
References: <1348578751-16904-3-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Update sched_domains_numa_masks[][]
  when new cpus are onlined
Git-Commit-ID: 301a5cba2887d1f640e6d5184b05a6d7132017d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 06:02:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  301a5cba2887d1f640e6d5184b05a6d7132017d5
Gitweb:     http://git.kernel.org/tip/301a5cba2887d1f640e6d5184b05a6d7132017d5
Author:     Tang Chen <tangchen@cn.fujitsu.com>
AuthorDate: Tue, 25 Sep 2012 21:12:31 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 5 Oct 2012 13:54:48 +0200

sched: Update sched_domains_numa_masks[][] when new cpus are onlined

Once array sched_domains_numa_masks[] []is defined, it is never updated.

When a new cpu on a new node is onlined, the coincident member in
sched_domains_numa_masks[][] is not initialized, and all the masks are 0.
As a result, the build_overlap_sched_groups() will initialize a NULL
sched_group for the new cpu on the new node, which will lead to kernel panic:

[ 3189.403280] Call Trace:
[ 3189.403286]  [<ffffffff8106c36f>] warn_slowpath_common+0x7f/0xc0
[ 3189.403289]  [<ffffffff8106c3ca>] warn_slowpath_null+0x1a/0x20
[ 3189.403292]  [<ffffffff810b1d57>] build_sched_domains+0x467/0x470
[ 3189.403296]  [<ffffffff810b2067>] partition_sched_domains+0x307/0x510
[ 3189.403299]  [<ffffffff810b1ea2>] ? partition_sched_domains+0x142/0x510
[ 3189.403305]  [<ffffffff810fcc93>] cpuset_update_active_cpus+0x83/0x90
[ 3189.403308]  [<ffffffff810b22a8>] cpuset_cpu_active+0x38/0x70
[ 3189.403316]  [<ffffffff81674b87>] notifier_call_chain+0x67/0x150
[ 3189.403320]  [<ffffffff81664647>] ? native_cpu_up+0x18a/0x1b5
[ 3189.403328]  [<ffffffff810a044e>] __raw_notifier_call_chain+0xe/0x10
[ 3189.403333]  [<ffffffff81070470>] __cpu_notify+0x20/0x40
[ 3189.403337]  [<ffffffff8166663e>] _cpu_up+0xe9/0x131
[ 3189.403340]  [<ffffffff81666761>] cpu_up+0xdb/0xee
[ 3189.403348]  [<ffffffff8165667c>] store_online+0x9c/0xd0
[ 3189.403355]  [<ffffffff81437640>] dev_attr_store+0x20/0x30
[ 3189.403361]  [<ffffffff8124aa63>] sysfs_write_file+0xa3/0x100
[ 3189.403368]  [<ffffffff811ccbe0>] vfs_write+0xd0/0x1a0
[ 3189.403371]  [<ffffffff811ccdb4>] sys_write+0x54/0xa0
[ 3189.403375]  [<ffffffff81679c69>] system_call_fastpath+0x16/0x1b
[ 3189.403377] ---[ end trace 1e6cf85d0859c941 ]---
[ 3189.403398] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018

This patch registers a new notifier for cpu hotplug notify chain, and
updates sched_domains_numa_masks every time a new cpu is onlined or offlined.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
[ fixed compile warning ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1348578751-16904-3-git-send-email-tangchen@cn.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f895fdd..8322d73 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6190,10 +6190,65 @@ static void sched_init_numa(void)
 
 	sched_domains_numa_levels = level;
 }
+
+static void sched_domains_numa_masks_set(int cpu)
+{
+	int i, j;
+	int node = cpu_to_node(cpu);
+
+	for (i = 0; i < sched_domains_numa_levels; i++) {
+		for (j = 0; j < nr_node_ids; j++) {
+			if (node_distance(j, node) <= sched_domains_numa_distance[i])
+				cpumask_set_cpu(cpu, sched_domains_numa_masks[i][j]);
+		}
+	}
+}
+
+static void sched_domains_numa_masks_clear(int cpu)
+{
+	int i, j;
+	for (i = 0; i < sched_domains_numa_levels; i++) {
+		for (j = 0; j < nr_node_ids; j++)
+			cpumask_clear_cpu(cpu, sched_domains_numa_masks[i][j]);
+	}
+}
+
+/*
+ * Update sched_domains_numa_masks[level][node] array when new cpus
+ * are onlined.
+ */
+static int sched_domains_numa_masks_update(struct notifier_block *nfb,
+					   unsigned long action,
+					   void *hcpu)
+{
+	int cpu = (long)hcpu;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_ONLINE:
+		sched_domains_numa_masks_set(cpu);
+		break;
+
+	case CPU_DEAD:
+		sched_domains_numa_masks_clear(cpu);
+		break;
+
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
 #else
 static inline void sched_init_numa(void)
 {
 }
+
+static int sched_domains_numa_masks_update(struct notifier_block *nfb,
+					   unsigned long action,
+					   void *hcpu)
+{
+	return 0;
+}
 #endif /* CONFIG_NUMA */
 
 static int __sdt_alloc(const struct cpumask *cpu_map)
@@ -6642,6 +6697,7 @@ void __init sched_init_smp(void)
 	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();
 
+	hotcpu_notifier(sched_domains_numa_masks_update, CPU_PRI_SCHED_ACTIVE);
 	hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
 	hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);
 
