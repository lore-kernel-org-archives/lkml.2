Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab0FYNDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:03:49 -0400
Received: from ozlabs.org ([203.10.76.45]:38684 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842Ab0FYNDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:03:46 -0400
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
       Bryan Wu <cooloney@kernel.org>, Tony Luck <tony.luck@intel.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
       anton@samba.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mike Travis <travis@sgi.com>
CC: Bryan Wu <cooloney@kernel.org>
CC: Tony Luck <tony.luck@intel.com>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mundt <lethal@linux-sh.org>
CC: "David S. Miller" <davem@davemloft.net>
CC: Ingo Molnar <mingo@redhat.com>
To: Ingo Molnar <mingo@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <201006252233.40481.rusty@rustcorp.com.au>
Date: Fri, 25 Jun 2010 22:33:39 +0930
Subject: [PATCH 2/5] cpumask: make task_struct.cpus_allowed a cpumask_var_t
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: anton@samba.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This turns it into a pointer for everyone.  Rather than churn everyone
via the tsk_cpus_allowed() wrapper, we change them directly.  If there
are any users in the meantime they can use the wrapper.

For CONFIG_CPUMASK_OFFSTACK=y, we now allocate it off the end; it
would be better to avoid the indirection and use a dangling bitmap,
but I didn't want to alter the layout of task_struct and risk breaking
carefully balanced caches.

Even better would be to point to the fixed "one cpu" and "all cpus"
masks where possible, and make a copy when setting it to something
else.  But you'd have to track down those naughty places which frob it
directly...

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: anton@samba.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mike Travis <travis@sgi.com>
---
 arch/arm/mach-integrator/cpu.c               |    4 ++--
 arch/blackfin/kernel/process.c               |    3 ++-
 arch/ia64/kernel/cpufreq/acpi-cpufreq.c      |    4 ++--
 arch/ia64/kernel/mca.c                       |    2 +-
 arch/ia64/kernel/salinfo.c                   |    2 +-
 arch/ia64/kernel/topology.c                  |    2 +-
 arch/ia64/sn/kernel/sn2/sn_hwperf.c          |    2 +-
 arch/mips/include/asm/system.h               |    3 ++-
 arch/mips/kernel/cpufreq/loongson2_cpufreq.c |    2 +-
 arch/mips/kernel/traps.c                     |    8 ++++----
 arch/powerpc/kernel/smp.c                    |    2 +-
 arch/powerpc/platforms/cell/spufs/sched.c    |    2 +-
 arch/sh/kernel/cpufreq.c                     |    2 +-
 arch/sparc/kernel/sysfs.c                    |    2 +-
 arch/sparc/kernel/us2e_cpufreq.c             |    4 ++--
 arch/sparc/kernel/us3_cpufreq.c              |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce_intel.c       |    2 +-
 drivers/acpi/processor_throttling.c          |    4 ++--
 drivers/firmware/dcdbas.c                    |    2 +-
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    6 +++---
 fs/proc/array.c                              |    4 ++--
 include/linux/cpuset.h                       |    2 +-
 include/linux/init_task.h                    |    9 ++++++++-
 include/linux/sched.h                        |    2 +-
 kernel/cpuset.c                              |    2 +-
 kernel/fork.c                                |   17 ++++++++++++++++-
 kernel/kthread.c                             |    2 +-
 kernel/sched.c                               |   18 +++++++++---------
 kernel/sched_cpupri.c                        |    4 ++--
 kernel/sched_fair.c                          |   12 ++++++------
 kernel/sched_rt.c                            |    6 +++---
 kernel/trace/trace_workqueue.c               |    6 +++---
 lib/smp_processor_id.c                       |    2 +-
 33 files changed, 86 insertions(+), 62 deletions(-)

diff --git a/arch/arm/mach-integrator/cpu.c b/arch/arm/mach-integrator/cpu.c
--- a/arch/arm/mach-integrator/cpu.c
+++ b/arch/arm/mach-integrator/cpu.c
@@ -92,7 +92,7 @@ static int integrator_set_target(struct 
 	/*
 	 * Save this threads cpus_allowed mask.
 	 */
-	cpus_allowed = current->cpus_allowed;
+	cpus_allowed = *current->cpus_allowed;
 
 	/*
 	 * Bind to the specified CPU.  When this call returns,
@@ -163,7 +163,7 @@ static unsigned int integrator_get(unsig
 	u_int cm_osc;
 	struct icst_vco vco;
 
-	cpus_allowed = current->cpus_allowed;
+	cpus_allowed = *current->cpus_allowed;
 
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	BUG_ON(cpu != smp_processor_id());
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -173,7 +173,8 @@ asmlinkage int bfin_clone(struct pt_regs
 
 #ifdef __ARCH_SYNC_CORE_DCACHE
 	if (current->rt.nr_cpus_allowed == num_possible_cpus()) {
-		current->cpus_allowed = cpumask_of_cpu(smp_processor_id());
+		cpumask_copy(current->cpus_allowed,
+			     cpumask_of(smp_processor_id()));
 		current->rt.nr_cpus_allowed = 1;
 	}
 #endif
diff --git a/arch/ia64/kernel/cpufreq/acpi-cpufreq.c b/arch/ia64/kernel/cpufreq/acpi-cpufreq.c
--- a/arch/ia64/kernel/cpufreq/acpi-cpufreq.c
+++ b/arch/ia64/kernel/cpufreq/acpi-cpufreq.c
@@ -112,7 +112,7 @@ processor_get_freq (
 
 	dprintk("processor_get_freq\n");
 
-	saved_mask = current->cpus_allowed;
+	saved_mask = *current->cpus_allowed;
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 	if (smp_processor_id() != cpu)
 		goto migrate_end;
@@ -150,7 +150,7 @@ processor_set_freq (
 
 	dprintk("processor_set_freq\n");
 
-	saved_mask = current->cpus_allowed;
+	saved_mask = *current->cpus_allowed;
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 	if (smp_processor_id() != cpu) {
 		retval = -EAGAIN;
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -1823,7 +1823,7 @@ format_mca_init_stack(void *mca_data, un
 	ti->cpu = cpu;
 	p->stack = ti;
 	p->state = TASK_UNINTERRUPTIBLE;
-	cpu_set(cpu, p->cpus_allowed);
+	cpumask_set_cpu(cpu, p->cpus_allowed);
 	INIT_LIST_HEAD(&p->tasks);
 	p->parent = p->real_parent = p->group_leader = p;
 	INIT_LIST_HEAD(&p->children);
diff --git a/arch/ia64/kernel/salinfo.c b/arch/ia64/kernel/salinfo.c
--- a/arch/ia64/kernel/salinfo.c
+++ b/arch/ia64/kernel/salinfo.c
@@ -403,7 +403,7 @@ salinfo_log_release(struct inode *inode,
 static void
 call_on_cpu(int cpu, void (*fn)(void *), void *arg)
 {
-	cpumask_t save_cpus_allowed = current->cpus_allowed;
+	cpumask_t save_cpus_allowed = *current->cpus_allowed;
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 	(*fn)(arg);
 	set_cpus_allowed_ptr(current, &save_cpus_allowed);
diff --git a/arch/ia64/kernel/topology.c b/arch/ia64/kernel/topology.c
--- a/arch/ia64/kernel/topology.c
+++ b/arch/ia64/kernel/topology.c
@@ -360,7 +360,7 @@ static int __cpuinit cache_add_dev(struc
 	if (all_cpu_cache_info[cpu].kobj.parent)
 		return 0;
 
-	oldmask = current->cpus_allowed;
+	oldmask = *current->cpus_allowed;
 	retval = set_cpus_allowed_ptr(current, cpumask_of(cpu));
 	if (unlikely(retval))
 		return retval;
diff --git a/arch/ia64/sn/kernel/sn2/sn_hwperf.c b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
--- a/arch/ia64/sn/kernel/sn2/sn_hwperf.c
+++ b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -627,7 +627,7 @@ static int sn_hwperf_op_cpu(struct sn_hw
 		}
 		else {
 			/* migrate the task before calling SAL */ 
-			save_allowed = current->cpus_allowed;
+			save_allowed = *current->cpus_allowed;
 			set_cpus_allowed_ptr(current, cpumask_of(cpu));
 			sn_hwperf_call_sal(op_info);
 			set_cpus_allowed_ptr(current, &save_allowed);
diff --git a/arch/mips/include/asm/system.h b/arch/mips/include/asm/system.h
--- a/arch/mips/include/asm/system.h
+++ b/arch/mips/include/asm/system.h
@@ -58,7 +58,8 @@ do {									\
 	    test_ti_thread_flag(__prev_ti, TIF_FPUBOUND) &&		\
 	    (!(KSTK_STATUS(prev) & ST0_CU1))) {				\
 		clear_ti_thread_flag(__prev_ti, TIF_FPUBOUND);		\
-		prev->cpus_allowed = prev->thread.user_cpus_allowed;	\
+		cpumask_copy(prev->cpus_allowed,			\
+			     prev->thread.user_cpus_allowed);		\
 	}								\
 	next->thread.emulated_fp = 0;					\
 } while(0)
diff --git a/arch/mips/kernel/cpufreq/loongson2_cpufreq.c b/arch/mips/kernel/cpufreq/loongson2_cpufreq.c
--- a/arch/mips/kernel/cpufreq/loongson2_cpufreq.c
+++ b/arch/mips/kernel/cpufreq/loongson2_cpufreq.c
@@ -64,7 +64,7 @@ static int loongson2_cpufreq_target(stru
 	if (!cpu_online(cpu))
 		return -ENODEV;
 
-	cpus_allowed = current->cpus_allowed;
+	cpus_allowed = *current->cpus_allowed;
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
 	if (cpufreq_frequency_table_target
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -860,13 +860,13 @@ static void mt_ase_fp_affinity(void)
 		 * restricted the allowed set to exclude any CPUs with FPUs,
 		 * we'll skip the procedure.
 		 */
-		if (cpus_intersects(current->cpus_allowed, mt_fpu_cpumask)) {
+		if (cpumask_intersects(current->cpus_allowed, &mt_fpu_cpumask)) {
 			cpumask_t tmask;
 
 			current->thread.user_cpus_allowed
-				= current->cpus_allowed;
-			cpus_and(tmask, current->cpus_allowed,
-				mt_fpu_cpumask);
+				= *current->cpus_allowed;
+			cpumask_and(&tmask, current->cpus_allowed,
+				    &mt_fpu_cpumask);
 			set_cpus_allowed_ptr(current, &tmask);
 			set_thread_flag(TIF_FPUBOUND);
 		}
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -575,7 +575,7 @@ void __init smp_cpus_done(unsigned int m
 	 * se we pin us down to CPU 0 for a short while
 	 */
 	alloc_cpumask_var(&old_mask, GFP_NOWAIT);
-	cpumask_copy(old_mask, &current->cpus_allowed);
+	cpumask_copy(old_mask, current->cpus_allowed);
 	set_cpus_allowed_ptr(current, cpumask_of(boot_cpuid));
 	
 	if (smp_ops && smp_ops->setup_cpu)
diff --git a/arch/powerpc/platforms/cell/spufs/sched.c b/arch/powerpc/platforms/cell/spufs/sched.c
--- a/arch/powerpc/platforms/cell/spufs/sched.c
+++ b/arch/powerpc/platforms/cell/spufs/sched.c
@@ -141,7 +141,7 @@ void __spu_update_sched_info(struct spu_
 	 * runqueue. The context will be rescheduled on the proper node
 	 * if it is timesliced or preempted.
 	 */
-	ctx->cpus_allowed = current->cpus_allowed;
+	cpumask_copy(&ctx->cpus_allowed, current->cpus_allowed);
 
 	/* Save the current cpu id for spu interrupt routing. */
 	ctx->last_ran = raw_smp_processor_id();
diff --git a/arch/sh/kernel/cpufreq.c b/arch/sh/kernel/cpufreq.c
--- a/arch/sh/kernel/cpufreq.c
+++ b/arch/sh/kernel/cpufreq.c
@@ -47,7 +47,7 @@ static int sh_cpufreq_target(struct cpuf
 	if (!cpu_online(cpu))
 		return -ENODEV;
 
-	cpus_allowed = current->cpus_allowed;
+	cpus_allowed = *current->cpus_allowed;
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
 	BUG_ON(smp_processor_id() != cpu);
diff --git a/arch/sparc/kernel/sysfs.c b/arch/sparc/kernel/sysfs.c
--- a/arch/sparc/kernel/sysfs.c
+++ b/arch/sparc/kernel/sysfs.c
@@ -103,7 +103,7 @@ static unsigned long run_on_cpu(unsigned
 			        unsigned long (*func)(unsigned long),
 				unsigned long arg)
 {
-	cpumask_t old_affinity = current->cpus_allowed;
+	cpumask_t old_affinity = *current->cpus_allowed;
 	unsigned long ret;
 
 	/* should return -EINVAL to userspace */
diff --git a/arch/sparc/kernel/us2e_cpufreq.c b/arch/sparc/kernel/us2e_cpufreq.c
--- a/arch/sparc/kernel/us2e_cpufreq.c
+++ b/arch/sparc/kernel/us2e_cpufreq.c
@@ -237,7 +237,7 @@ static unsigned int us2e_freq_get(unsign
 	if (!cpu_online(cpu))
 		return 0;
 
-	cpus_allowed = current->cpus_allowed;
+	cpus_allowed = *current->cpus_allowed;
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
 	clock_tick = sparc64_get_clock_tick(cpu) / 1000;
@@ -258,7 +258,7 @@ static void us2e_set_cpu_divider_index(u
 	if (!cpu_online(cpu))
 		return;
 
-	cpus_allowed = current->cpus_allowed;
+	cpus_allowed = *current->cpus_allowed;
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
 	new_freq = clock_tick = sparc64_get_clock_tick(cpu) / 1000;
diff --git a/arch/sparc/kernel/us3_cpufreq.c b/arch/sparc/kernel/us3_cpufreq.c
--- a/arch/sparc/kernel/us3_cpufreq.c
+++ b/arch/sparc/kernel/us3_cpufreq.c
@@ -85,7 +85,7 @@ static unsigned int us3_freq_get(unsigne
 	if (!cpu_online(cpu))
 		return 0;
 
-	cpus_allowed = current->cpus_allowed;
+	cpus_allowed = *current->cpus_allowed;
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
 	reg = read_safari_cfg();
@@ -105,7 +105,7 @@ static void us3_set_cpu_divider_index(un
 	if (!cpu_online(cpu))
 		return;
 
-	cpus_allowed = current->cpus_allowed;
+	cpus_allowed = *current->cpus_allowed;
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
 	new_freq = sparc64_get_clock_tick(cpu) / 1000;
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -176,7 +176,7 @@ void cmci_rediscover(int dying)
 		return;
 	if (!alloc_cpumask_var(&old, GFP_KERNEL))
 		return;
-	cpumask_copy(old, &current->cpus_allowed);
+	cpumask_copy(old, current->cpus_allowed);
 
 	for_each_online_cpu(cpu) {
 		if (cpu == dying)
diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -872,7 +872,7 @@ static int acpi_processor_get_throttling
 	/*
 	 * Migrate task to the cpu pointed by pr.
 	 */
-	cpumask_copy(saved_mask, &current->cpus_allowed);
+	cpumask_copy(saved_mask, current->cpus_allowed);
 	/* FIXME: use work_on_cpu() */
 	set_cpus_allowed_ptr(current, cpumask_of(pr->id));
 	ret = pr->throttling.acpi_processor_get_throttling(pr);
@@ -1049,7 +1049,7 @@ int acpi_processor_set_throttling(struct
 		return -ENOMEM;
 	}
 
-	cpumask_copy(saved_mask, &current->cpus_allowed);
+	cpumask_copy(saved_mask, current->cpus_allowed);
 	t_state.target_state = state;
 	p_throttling = &(pr->throttling);
 	cpumask_and(online_throttling_cpus, cpu_online_mask,
diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -258,7 +258,7 @@ int dcdbas_smi_request(struct smi_cmd *s
 	if (!alloc_cpumask_var(&old_mask, GFP_KERNEL))
 		return -ENOMEM;
 
-	cpumask_copy(old_mask, &current->cpus_allowed);
+	cpumask_copy(old_mask, current->cpus_allowed);
 	set_cpus_allowed_ptr(current, cpumask_of(0));
 	if (smp_processor_id() != 0) {
 		dev_dbg(&dcdbas_pdev->dev, "%s: failed to get CPU 0\n",
diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -1689,11 +1689,11 @@ static int find_best_unit(struct file *f
 	 * information.  There may be some issues with dual core numbering
 	 * as well.  This needs more work prior to release.
 	 */
-	if (!cpumask_empty(&current->cpus_allowed) &&
-	    !cpumask_full(&current->cpus_allowed)) {
+	if (!cpumask_empty(current->cpus_allowed) &&
+	    !cpumask_full(current->cpus_allowed)) {
 		int ncpus = num_online_cpus(), curcpu = -1, nset = 0;
 		for (i = 0; i < ncpus; i++)
-			if (cpumask_test_cpu(i, &current->cpus_allowed)) {
+			if (cpumask_test_cpu(i, current->cpus_allowed)) {
 				ipath_cdbg(PROC, "%s[%u] affinity set for "
 					   "cpu %d/%d\n", current->comm,
 					   current->pid, i, ncpus);
diff --git a/fs/proc/array.c b/fs/proc/array.c
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -330,10 +330,10 @@ static inline void task_context_switch_c
 static void task_cpus_allowed(struct seq_file *m, struct task_struct *task)
 {
 	seq_printf(m, "Cpus_allowed:\t");
-	seq_cpumask(m, &task->cpus_allowed);
+	seq_cpumask(m, task->cpus_allowed);
 	seq_printf(m, "\n");
 	seq_printf(m, "Cpus_allowed_list:\t");
-	seq_cpumask_list(m, &task->cpus_allowed);
+	seq_cpumask_list(m, task->cpus_allowed);
 	seq_printf(m, "\n");
 }
 
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -140,7 +140,7 @@ static inline void cpuset_cpus_allowed(s
 
 static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
 {
-	cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
+	cpumask_copy(p->cpus_allowed, cpu_possible_mask);
 	return cpumask_any(cpu_active_mask);
 }
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -102,6 +102,13 @@ extern struct cred init_cred;
 # define INIT_PERF_EVENTS(tsk)
 #endif
 
+#ifdef CONFIG_CPUMASK_OFFSTACK
+extern DECLARE_BITMAP(init_task_cpus_allowed, NR_CPUS);
+#define INIT_TASK_CPUS_ALLOWED (to_cpumask(init_task_cpus_allowed))
+#else
+#define INIT_TASK_CPUS_ALLOWED { CPU_MASK_ALL }
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -117,7 +124,7 @@ extern struct cred init_cred;
 	.static_prio	= MAX_PRIO-20,					\
 	.normal_prio	= MAX_PRIO-20,					\
 	.policy		= SCHED_NORMAL,					\
-	.cpus_allowed	= CPU_MASK_ALL,					\
+	.cpus_allowed	= INIT_TASK_CPUS_ALLOWED,			\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
 	.se		= {						\
diff --git a/include/linux/sched.h b/include/linux/sched.h
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1209,7 +1209,7 @@ struct task_struct {
 #endif
 
 	unsigned int policy;
-	cpumask_t cpus_allowed;
+	cpumask_var_t cpus_allowed;
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	int rcu_read_lock_nesting;
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -798,7 +798,7 @@ void rebuild_sched_domains(void)
 static int cpuset_test_cpumask(struct task_struct *tsk,
 			       struct cgroup_scanner *scan)
 {
-	return !cpumask_equal(&tsk->cpus_allowed,
+	return !cpumask_equal(tsk->cpus_allowed,
 			(cgroup_cs(scan->cg))->cpus_allowed);
 }
 
diff --git a/kernel/fork.c b/kernel/fork.c
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -205,9 +205,15 @@ void __init fork_init(unsigned long memp
 #ifndef ARCH_MIN_TASKALIGN
 #define ARCH_MIN_TASKALIGN	L1_CACHE_BYTES
 #endif
+	unsigned int task_size = sizeof(struct task_struct);
+
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	task_size += BITS_TO_LONGS(nr_cpu_ids) * sizeof(long);
+#endif /* CONFIG_CPUMASK_OFFSTACK */
+
 	/* create a slab on which task_structs can be allocated */
 	task_struct_cachep =
-		kmem_cache_create("task_struct", sizeof(struct task_struct),
+		kmem_cache_create("task_struct", task_size,
 			ARCH_MIN_TASKALIGN, SLAB_PANIC | SLAB_NOTRACK, NULL);
 #endif
 
@@ -254,6 +260,11 @@ static struct task_struct *dup_task_stru
 	if (!tsk)
 		return NULL;
 
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	/* cpumask sits at end of task struct. */
+	tsk->cpus_allowed = (void *)(tsk + 1);
+#endif
+
 	ti = alloc_thread_info(tsk);
 	if (!ti) {
 		free_task_struct(tsk);
@@ -1767,3 +1778,7 @@ int unshare_files(struct files_struct **
 	task_unlock(task);
 	return 0;
 }
+
+#ifdef CONFIG_CPUMASK_OFFSTACK
+DECLARE_BITMAP(init_task_cpus_allowed, NR_CPUS) = CPU_BITS_ALL;
+#endif
diff --git a/kernel/kthread.c b/kernel/kthread.c
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -166,7 +166,7 @@ void kthread_bind(struct task_struct *p,
 		return;
 	}
 
-	p->cpus_allowed = cpumask_of_cpu(cpu);
+	cpumask_copy(p->cpus_allowed, cpumask_of(cpu));
 	p->rt.nr_cpus_allowed = 1;
 	p->flags |= PF_THREAD_BOUND;
 }
diff --git a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2209,11 +2209,11 @@ static int select_fallback_rq(int cpu, s
 
 	/* Look for allowed, online CPU in same node. */
 	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
-		if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
+		if (cpumask_test_cpu(dest_cpu, p->cpus_allowed))
 			return dest_cpu;
 
 	/* Any allowed, online CPU? */
-	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
+	dest_cpu = cpumask_any_and(p->cpus_allowed, cpu_active_mask);
 	if (dest_cpu < nr_cpu_ids)
 		return dest_cpu;
 
@@ -2253,7 +2253,7 @@ int select_task_rq(struct rq *rq, struct
 	 * [ this allows ->select_task() to simply return task_cpu(p) and
 	 *   not worry about this generic constraint ]
 	 */
-	if (unlikely(!cpumask_test_cpu(cpu, &p->cpus_allowed) ||
+	if (unlikely(!cpumask_test_cpu(cpu, p->cpus_allowed) ||
 		     !cpu_online(cpu)))
 		cpu = select_fallback_rq(task_cpu(p), p);
 
@@ -3055,7 +3055,7 @@ void sched_exec(void)
 	/*
 	 * select_task_rq() can race against ->cpus_allowed
 	 */
-	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
+	if (cpumask_test_cpu(dest_cpu, p->cpus_allowed) &&
 	    likely(cpu_active(dest_cpu)) && migrate_task(p, dest_cpu)) {
 		struct migration_arg arg = { p, dest_cpu };
 
@@ -4785,7 +4785,7 @@ long sched_getaffinity(pid_t pid, struct
 		goto out_unlock;
 
 	rq = task_rq_lock(p, &flags);
-	cpumask_and(mask, &p->cpus_allowed, cpu_online_mask);
+	cpumask_and(mask, p->cpus_allowed, cpu_online_mask);
 	task_rq_unlock(rq, &flags);
 
 out_unlock:
@@ -5150,7 +5150,7 @@ void __cpuinit init_idle(struct task_str
 	idle->state = TASK_RUNNING;
 	idle->se.exec_start = sched_clock();
 
-	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
+	cpumask_copy(idle->cpus_allowed, cpumask_of(cpu));
 	__set_task_cpu(idle, cpu);
 
 	rq->curr = rq->idle = idle;
@@ -5279,7 +5279,7 @@ again:
 	}
 
 	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
-		     !cpumask_equal(&p->cpus_allowed, new_mask))) {
+		     !cpumask_equal(p->cpus_allowed, new_mask))) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -5287,7 +5287,7 @@ again:
 	if (p->sched_class->set_cpus_allowed)
 		p->sched_class->set_cpus_allowed(p, new_mask);
 	else {
-		cpumask_copy(&p->cpus_allowed, new_mask);
+		cpumask_copy(p->cpus_allowed, new_mask);
 		p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
 	}
 
@@ -5338,7 +5338,7 @@ static int __migrate_task(struct task_st
 	if (task_cpu(p) != src_cpu)
 		goto done;
 	/* Affinity changed (again). */
-	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
+	if (!cpumask_test_cpu(dest_cpu, p->cpus_allowed))
 		goto fail;
 
 	/*
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -77,11 +77,11 @@ int cpupri_find(struct cpupri *cp, struc
 		if (idx >= task_pri)
 			break;
 
-		if (cpumask_any_and(&p->cpus_allowed, vec->mask) >= nr_cpu_ids)
+		if (cpumask_any_and(p->cpus_allowed, vec->mask) >= nr_cpu_ids)
 			continue;
 
 		if (lowest_mask) {
-			cpumask_and(lowest_mask, &p->cpus_allowed, vec->mask);
+			cpumask_and(lowest_mask, p->cpus_allowed, vec->mask);
 
 			/*
 			 * We have to ensure that we have at least one bit
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1322,7 +1322,7 @@ find_idlest_group(struct sched_domain *s
 
 		/* Skip over this group if it has no CPUs allowed */
 		if (!cpumask_intersects(sched_group_cpus(group),
-					&p->cpus_allowed))
+					p->cpus_allowed))
 			continue;
 
 		local_group = cpumask_test_cpu(this_cpu,
@@ -1369,7 +1369,7 @@ find_idlest_cpu(struct sched_group *grou
 	int i;
 
 	/* Traverse only the allowed CPUs */
-	for_each_cpu_and(i, sched_group_cpus(group), &p->cpus_allowed) {
+	for_each_cpu_and(i, sched_group_cpus(group), p->cpus_allowed) {
 		load = weighted_cpuload(i);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
@@ -1412,7 +1412,7 @@ static int select_idle_sibling(struct ta
 		if (!(sd->flags & SD_SHARE_PKG_RESOURCES))
 			break;
 
-		for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
+		for_each_cpu_and(i, sched_domain_span(sd), p->cpus_allowed) {
 			if (idle_cpu(i)) {
 				target = i;
 				break;
@@ -1454,7 +1454,7 @@ select_task_rq_fair(struct rq *rq, struc
 	int sync = wake_flags & WF_SYNC;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
-		if (cpumask_test_cpu(cpu, &p->cpus_allowed))
+		if (cpumask_test_cpu(cpu, p->cpus_allowed))
 			want_affine = 1;
 		new_cpu = prev_cpu;
 	}
@@ -1780,7 +1780,7 @@ int can_migrate_task(struct task_struct 
 	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
 	 * 3) are cache-hot on their current CPU.
 	 */
-	if (!cpumask_test_cpu(this_cpu, &p->cpus_allowed)) {
+	if (!cpumask_test_cpu(this_cpu, p->cpus_allowed)) {
 		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
 		return 0;
 	}
@@ -2904,7 +2904,7 @@ redo:
 			 * moved to this_cpu
 			 */
 			if (!cpumask_test_cpu(this_cpu,
-					      &busiest->curr->cpus_allowed)) {
+					      busiest->curr->cpus_allowed)) {
 				raw_spin_unlock_irqrestore(&busiest->lock,
 							    flags);
 				all_pinned = 1;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1121,7 +1121,7 @@ static void deactivate_task(struct rq *r
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
-	    (cpu < 0 || cpumask_test_cpu(cpu, &p->cpus_allowed)) &&
+	    (cpu < 0 || cpumask_test_cpu(cpu, p->cpus_allowed)) &&
 	    (p->rt.nr_cpus_allowed > 1))
 		return 1;
 	return 0;
@@ -1256,7 +1256,7 @@ static struct rq *find_lock_lowest_rq(st
 			 */
 			if (unlikely(task_rq(task) != rq ||
 				     !cpumask_test_cpu(lowest_rq->cpu,
-						       &task->cpus_allowed) ||
+						       task->cpus_allowed) ||
 				     task_running(rq, task) ||
 				     !task->se.on_rq)) {
 
@@ -1537,7 +1537,7 @@ static void set_cpus_allowed_rt(struct t
 		update_rt_migration(&rq->rt);
 	}
 
-	cpumask_copy(&p->cpus_allowed, new_mask);
+	cpumask_copy(p->cpus_allowed, new_mask);
 	p->rt.nr_cpus_allowed = weight;
 }
 
diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -53,7 +53,7 @@ probe_workqueue_insertion(void *ignore,
 			  struct task_struct *wq_thread,
 			  struct work_struct *work)
 {
-	int cpu = cpumask_first(&wq_thread->cpus_allowed);
+	int cpu = cpumask_first(wq_thread->cpus_allowed);
 	struct cpu_workqueue_stats *node;
 	unsigned long flags;
 
@@ -75,7 +75,7 @@ probe_workqueue_execution(void *ignore,
 			  struct task_struct *wq_thread,
 			  struct work_struct *work)
 {
-	int cpu = cpumask_first(&wq_thread->cpus_allowed);
+	int cpu = cpumask_first(wq_thread->cpus_allowed);
 	struct cpu_workqueue_stats *node;
 	unsigned long flags;
 
@@ -121,7 +121,7 @@ static void
 probe_workqueue_destruction(void *ignore, struct task_struct *wq_thread)
 {
 	/* Workqueue only execute on one cpu */
-	int cpu = cpumask_first(&wq_thread->cpus_allowed);
+	int cpu = cpumask_first(wq_thread->cpus_allowed);
 	struct cpu_workqueue_stats *node, *next;
 	unsigned long flags;
 
diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -22,7 +22,7 @@ notrace unsigned int debug_smp_processor
 	 * Kernel threads bound to a single CPU can safely use
 	 * smp_processor_id():
 	 */
-	if (cpumask_equal(&current->cpus_allowed, cpumask_of(this_cpu)))
+	if (cpumask_equal(current->cpus_allowed, cpumask_of(this_cpu)))
 		goto out;
 
 	/*

