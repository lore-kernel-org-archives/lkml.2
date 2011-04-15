Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab1DOTZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 15:25:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:53228 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab1DOTZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 15:25:26 -0400
Date: Fri, 15 Apr 2011 19:24:54 GMT
From: tip-bot for KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Message-ID: <tip-7d6b46707f2491a94f4bd3b4329d2d7f809e9368@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        shaohui.zheng@intel.com, tj@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        shaohui.zheng@intel.com, tj@kernel.org, tglx@linutronix.de,
        kosaki.motohiro@jp.fujitsu.com, rientjes@google.com,
        hpa@linux.intel.com, mingo@elte.hu
In-Reply-To: <20110415203928.1303.A69D9226@jp.fujitsu.com>
References: <20110415203928.1303.A69D9226@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, NUMA: Fix fakenuma boot failure
Git-Commit-ID: 7d6b46707f2491a94f4bd3b4329d2d7f809e9368
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Apr 2011 19:24:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d6b46707f2491a94f4bd3b4329d2d7f809e9368
Gitweb:     http://git.kernel.org/tip/7d6b46707f2491a94f4bd3b4329d2d7f809e9368
Author:     KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
AuthorDate: Fri, 15 Apr 2011 20:39:01 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 Apr 2011 20:28:19 +0200

x86, NUMA: Fix fakenuma boot failure

Currently, numa=fake boot parameter is broken. If it's used,
kernel may panic due to devide by zero error depending on CPU
configuration

Call Trace:
 [<ffffffff8104ad4c>] find_busiest_group+0x38c/0xd30
 [<ffffffff81086aff>] ? local_clock+0x6f/0x80
 [<ffffffff81050533>] load_balance+0xa3/0x600
 [<ffffffff81050f53>] idle_balance+0xf3/0x180
 [<ffffffff81550092>] schedule+0x722/0x7d0
 [<ffffffff81550538>] ? wait_for_common+0x128/0x190
 [<ffffffff81550a65>] schedule_timeout+0x265/0x320
 [<ffffffff81095815>] ? lock_release_holdtime+0x35/0x1a0
 [<ffffffff81550538>] ? wait_for_common+0x128/0x190
 [<ffffffff8109bb6c>] ? __lock_release+0x9c/0x1d0
 [<ffffffff815534e0>] ? _raw_spin_unlock_irq+0x30/0x40
 [<ffffffff815534e0>] ? _raw_spin_unlock_irq+0x30/0x40
 [<ffffffff81550540>] wait_for_common+0x130/0x190
 [<ffffffff81051920>] ? try_to_wake_up+0x510/0x510
 [<ffffffff8155067d>] wait_for_completion+0x1d/0x20
 [<ffffffff8107f36c>] kthread_create_on_node+0xac/0x150
 [<ffffffff81077bb0>] ? process_scheduled_works+0x40/0x40
 [<ffffffff8155045f>] ? wait_for_common+0x4f/0x190
 [<ffffffff8107a283>] __alloc_workqueue_key+0x1a3/0x590
 [<ffffffff81e0cce2>] cpuset_init_smp+0x6b/0x7b
 [<ffffffff81df3d07>] kernel_init+0xc3/0x182
 [<ffffffff8155d5e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81553cd4>] ? retint_restore_args+0x13/0x13
 [<ffffffff81df3c44>] ? start_kernel+0x400/0x400
 [<ffffffff8155d5e0>] ? gs_change+0x13/0x13

The divede by zero is caused by the following line,
group->cpu_power==0:

 kernel/sched_fair.c::update_sg_lb_stats()
        /* Adjust by relative CPU power of the group */
        sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;

This regression was caused by commit e23bba6044 ("x86-64, NUMA: Unify
emulated distance mapping") because it changes cpu -> node
mapping in the process of dropping fake_physnodes().

  old) all cpus are assinged node 0
  now) cpus are assigned round robin
       (the logic is implemented by numa_init_array())

  Note: The change in behavior only happens if the system doesn't
        have neither ACPI SRAT table nor AMD northbridge NUMA
	information.

Round robin assignment doesn't work because init_numa_sched_groups_power()
assumes all logical cpus in the same physical cpu share the same node
(then it only accounts for group_first_cpu()), and the simple round robin
breaks the above assumption.

Thus, this patch implements a reassignment of node-ids if buggy firmware
or numa emulation makes wrong cpu node map. Tt enforce all logical cpus
in the same physical cpu share the same node.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/20110415203928.1303.A69D9226@jp.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/smpboot.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c2871d3..8ed8908 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -312,6 +312,26 @@ void __cpuinit smp_store_cpu_info(int id)
 		identify_secondary_cpu(c);
 }
 
+static void __cpuinit check_cpu_siblings_on_same_node(int cpu1, int cpu2)
+{
+	int node1 = early_cpu_to_node(cpu1);
+	int node2 = early_cpu_to_node(cpu2);
+
+	/*
+	 * Our CPU scheduler assumes all logical cpus in the same physical cpu
+	 * share the same node. But, buggy ACPI or NUMA emulation might assign
+	 * them to different node. Fix it.
+	 */
+	if (node1 != node2) {
+		pr_warning("CPU %d in node %d and CPU %d in node %d are in the same physical CPU. forcing same node %d\n",
+			   cpu1, node1, cpu2, node2, node2);
+
+		numa_remove_cpu(cpu1);
+		numa_set_node(cpu1, node2);
+		numa_add_cpu(cpu1);
+	}
+}
+
 static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
 {
 	cpumask_set_cpu(cpu1, cpu_sibling_mask(cpu2));
@@ -320,6 +340,7 @@ static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
 	cpumask_set_cpu(cpu2, cpu_core_mask(cpu1));
 	cpumask_set_cpu(cpu1, cpu_llc_shared_mask(cpu2));
 	cpumask_set_cpu(cpu2, cpu_llc_shared_mask(cpu1));
+	check_cpu_siblings_on_same_node(cpu1, cpu2);
 }
 
 
@@ -361,10 +382,12 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
 			cpumask_set_cpu(i, cpu_llc_shared_mask(cpu));
 			cpumask_set_cpu(cpu, cpu_llc_shared_mask(i));
+			check_cpu_siblings_on_same_node(cpu, i);
 		}
 		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
 			cpumask_set_cpu(i, cpu_core_mask(cpu));
 			cpumask_set_cpu(cpu, cpu_core_mask(i));
+			check_cpu_siblings_on_same_node(cpu, i);
 			/*
 			 *  Does this new cpu bringup a new core?
 			 */
