Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551Ab2EWGcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:32:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:32978 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2EWGcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:32:51 -0400
From: Liu Ping Fan <kernelfans@gmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>
Subject: [PATCH 1/2] sched: add virt sched domain for the guest
Date: Wed, 23 May 2012 14:32:28 +0800
Message-Id: <1337754751-9018-2-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1337754751-9018-1-git-send-email-kernelfans@gmail.com>
References: <1337754751-9018-1-git-send-email-kernelfans@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

The guest's scheduler can not see the numa info on the host and
this will result to the following scene:
  Supposing vcpu-a on nodeA, vcpu-b on nodeB, when load balance,
the tasks' pull and push between these vcpus will cost more. But
unfortunately, currently, the guest is just blind to this.

This patch want to export the host numa info to the guest, and help
guest to rebuild its sched domain based on host's info.

--todo:
  vcpu's hotplug will be considered.

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 kernel/cpuset.c      |    2 +-
 kernel/sched/core.c  |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |    5 ++++
 3 files changed, 71 insertions(+), 1 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 14f7070..1246091 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -778,7 +778,7 @@ static DECLARE_WORK(rebuild_sched_domains_work, do_rebuild_sched_domains);
  * to a separate workqueue thread, which ends up processing the
  * above do_rebuild_sched_domains() function.
  */
-static void async_rebuild_sched_domains(void)
+void async_rebuild_sched_domains(void)
 {
 	queue_work(cpuset_wq, &rebuild_sched_domains_work);
 }
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e5212ae..3f72c1a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6343,6 +6343,60 @@ static struct sched_domain_topology_level default_topology[] = {
 	{ NULL, },
 };
 
+#ifdef CONFIG_VIRT_SCHED_DOMAIN
+/* fill in by host */
+DEFINE_PER_CPU(int, virt_numa_node);
+/* todo, exchange info about HOST_NUMNODES from host */
+#define  HOST_NUMNODES  128
+/* keep map, node->cpumask; todo, make it dynamic allocated */
+static struct cpumask virt_node_to_cpumask_map[HOST_NUMNODES];
+
+static inline int virt_cpu_to_node(int cpu)
+{
+	return per_cpu(virt_numa_node, cpu);
+}
+
+const struct cpumask *virt_cpumask_of_node(int vnode)
+{
+	struct cpumask *msk = &virt_node_to_cpumask_map[vnode];
+	return msk;
+}
+
+static const struct cpumask *virt_cpu_cpu_mask(int cpu)
+{
+	return virt_cpumask_of_node(virt_cpu_to_node(cpu));
+}
+
+static struct sched_domain_topology_level virt_topology[] = {
+	{ sd_init_CPU, virt_cpu_cpu_mask, },
+#ifdef CONFIG_NUMA
+	{ sd_init_ALLNODES, cpu_allnodes_mask, },
+#endif
+	{ NULL, },
+};
+
+static int update_virt_numa_node(void)
+{
+	int i, cpu, apicid, vnode;
+	for (i = 0; i < HOST_NUMNODES; i++)
+		cpumask_clear(&virt_node_to_cpumask_map[i]);
+	for_each_possible_cpu(cpu) {
+		apicid = cpu_physical_id(cpu);
+		vnode = __vapicid_to_vnode[apicid];
+		per_cpu(virt_numa_node, cpu) = vnode;
+		cpumask_set_cpu(cpu, &virt_node_to_cpumask_map[vnode]);
+	}
+	return 0;
+}
+
+int rebuild_virt_sd(void)
+{
+	update_virt_numa_node();
+	async_rebuild_sched_domains();
+	return 0;
+}
+#endif
+
 static struct sched_domain_topology_level *sched_domain_topology = default_topology;
 
 static int __sdt_alloc(const struct cpumask *cpu_map)
@@ -6689,9 +6743,11 @@ match1:
 	/* Build new domains */
 	for (i = 0; i < ndoms_new; i++) {
 		for (j = 0; j < ndoms_cur && !new_topology; j++) {
+#ifndef CONFIG_VIRT_SCHED_DOMAIN
 			if (cpumask_equal(doms_new[i], doms_cur[j])
 			    && dattrs_equal(dattr_new, i, dattr_cur, j))
 				goto match2;
+#endif
 		}
 		/* no match - add a new doms_new */
 		build_sched_domains(doms_new[i], dattr_new ? dattr_new + i : NULL);
@@ -6837,6 +6893,15 @@ void __init sched_init_smp(void)
 {
 	cpumask_var_t non_isolated_cpus;
 
+#ifdef CONFIG_VIRT_SCHED_DOMAIN
+	int i;
+	for (i = 0; i < MAX_LOCAL_APIC; i++) {
+		/* pretend all on the same node */
+		__vapicid_to_vnode[i] = 0;
+	}
+	update_virt_numa_node();
+	sched_domain_topology = virt_topology;
+#endif
 	alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL);
 	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fb3acba..232482d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -8,6 +8,9 @@
 
 extern __read_mostly int scheduler_running;
 
+#ifdef CONFIG_VIRT_SCHED_DOMAIN
+extern s16 __vapicid_to_vnode[];
+#endif
 /*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
@@ -198,6 +201,8 @@ struct cfs_bandwidth { };
 
 #endif	/* CONFIG_CGROUP_SCHED */
 
+extern void async_rebuild_sched_domains(void);
+
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
 	struct load_weight load;
-- 
1.7.4.4

