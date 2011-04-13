Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab1DMHCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 03:02:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54337 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab1DMHCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 03:02:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Subject: [PATCH] x86-64, NUMA: fix fakenuma boot failure
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Brian Gerst <brgerst@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>
In-Reply-To: <20110412071318.GA10425@mtj.dyndns.org>
References: <20110412153212.B514.A69D9226@jp.fujitsu.com> <20110412071318.GA10425@mtj.dyndns.org>
Message-Id: <20110413160239.D72A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 13 Apr 2011 16:02:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello, KOSAKI.
> 
> On Tue, Apr 12, 2011 at 03:31:42PM +0900, KOSAKI Motohiro wrote:
> > Unfortunately, don't work.
> > full dmesg is below.
> ...
> > [    0.220979] ERROR: groups don't span domain->span
> > [    0.222122] divide error: 0000 [#1] SMP
> > [    0.222975] last sysfs file:
> > [    0.222975] CPU 0
> > [    0.222975] Modules linked in:
> > [    0.222975]
> > [    0.222975] Pid: 1, comm: swapper Not tainted 2.6.39-rc1+ #2 FUJITSU-SV   
> 
> Hmmm... looks like the added condition didn't trigger at all.  I'm
> travelling until the end of the next week and can only test using qemu
> which I don't think supports sibling topology.  Can you please add
> some printks in the sibling link function and find out why the
> condition isn't triggering?  Thank you.

Your patch have two mistake.

 1) link_thread_siblings() is for HT
    set_cpu_sibling_map() has another sibling calculations.
 2) numa_set_node() is not enough. scheduler is using node_to_cpumask_map[] too.

If we need to take your approach, correct patch is below.


btw, Please see cpu_coregroup_mask(). its return value depend on 
sched_mc_power_savings and sched_smt_power_savings. then, we need to care
both cpu_core_mask and cpu_llc_shared_mask. I think.

====================================

>From fb61272ddf9a7f913a020da6001d70a2950af695 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 13 Apr 2011 15:47:12 +0900
Subject: [PATCH] x86-64, NUMA: fix fakenuma boot failure

Currently, numa=fake boot parameter is broken. If it's used, kernel
doesn't boot and makes panic by zero divide error.

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

The zero divede is caused following line. (ie group->cpu_power==0)

update_sg_lb_stats()
        /* Adjust by relative CPU power of the group */
        sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) /
group->cpu_power;

This is regression  since commit e23bba6044 (x86-64, NUMA: Unify
emulated distance mapping). Because It drop fake_physnodes() and
then cpu-node mapping was changed.

old) all cpus are assinged node 0
now) cpus are assigned round robin
     (the logic is implemented by numa_init_array())

Why round robin assignment doesn't work? Because init_numa_sched_groups_power()
assume all logical cpus in the same physical cpu are assigned the same node.
(Then it only account group_first_cpu()). But the simple round robin
broke the above assumption.

IOW, the breakage is not numa emulation only. No acpi fallback code is
broken. and commit e23bba6044 (unify numa emulation and generic fallback code)
broke the kernel.

Thus, this patch implement to reassigne node-id if buggy firmware or numa
emulation makes wrong cpu node map.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/smpboot.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c2871d3..1084fbb 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -312,6 +312,26 @@ void __cpuinit smp_store_cpu_info(int id)
 		identify_secondary_cpu(c);
 }
 
+static void __cpuinit node_cpumap_same_phys(int cpu1, int cpu2)
+{
+	int node1 = early_cpu_to_node(cpu1);
+	int node2 = early_cpu_to_node(cpu2);
+
+	/*
+	 * Our CPU scheduler assume all cpus in the same physical cpu package
+	 * are assigned the same node. But, Buggy ACPI table or NUMA emulation
+	 * might assigne them to different node. Fix it.
+	*/
+	if (node1 != node2) {
+		pr_warning("CPU %d in node %d and CPU %d in node %d are in the same physical CPU. forcing same node %d\n",
+			   cpu1, node1, cpu2, node2, node2);
+
+		numa_set_node(cpu1, node2);
+		cpumask_set_cpu(cpu1, node_to_cpumask_map[node2]);
+		cpumask_clear_cpu(cpu1, node_to_cpumask_map[node1]);
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
+	node_cpumap_same_phys(cpu1, cpu2);
 }
 
 
@@ -361,10 +382,12 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
 			cpumask_set_cpu(i, cpu_llc_shared_mask(cpu));
 			cpumask_set_cpu(cpu, cpu_llc_shared_mask(i));
+			node_cpumap_same_phys(cpu, i);
 		}
 		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
 			cpumask_set_cpu(i, cpu_core_mask(cpu));
 			cpumask_set_cpu(cpu, cpu_core_mask(i));
+			node_cpumap_same_phys(cpu, i);
 			/*
 			 *  Does this new cpu bringup a new core?
 			 */
-- 
1.7.3.1






