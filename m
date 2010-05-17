Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab0EQVit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 17:38:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44038 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559Ab0EQVir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 17:38:47 -0400
Date: Mon, 17 May 2010 23:38:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] OProfile changes for v2.6.35
Message-ID: <20100517213810.GA6126@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest oprofile-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git oprofile-for-linus

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      oprofile: remove double ring buffering

Li Zefan (3):
      tracing: Convert some signal events to DEFINE_TRACE
      tracing: Update comments
      tracing: Remove side effect from module tracepoints that caused a GPF

Martin Schwidefsky (1):
      oprofile: convert oprofile from timer_hook to hrtimer

Phil Carmody (1):
      oprofile: protect from not being in an IRQ context

Robert Richter (14):
      oprofile: update file list in MAINTAINERS file
      oprofile/x86: rework error handler in nmi_setup()
      oprofile/x86: reserve counter msrs pairwise
      oprofile/x86: moving shutdown functions
      oprofile/x86: return -EBUSY if counters are already reserved
      oprofile/x86: move IBS code
      oprofile/x86: remove duplicate IBS capability check
      oprofile/x86: fix uninitialized counter usage during cpu hotplug
      oprofile/x86: remove CONFIG_SMP macros
      oprofile/x86: protect cpu hotplug sections
      oprofile/x86: stop disabled counters in nmi handler
      oprofile/x86: reordering some functions
      oprofile/x86: notify cpus only when daemon is running
      oprofile/x86: make AMD IBS hotplug capable

Steven Rostedt (4):
      tracing: Fix compile error in module tracepoints when MODULE_UNLOAD not set
      ring-buffer: Add place holder recording of dropped events
      tracing: Show the lost events in the trace_pipe output
      ring-buffer: Add lost event count to end of sub buffer


 MAINTAINERS                          |    1 +
 arch/x86/oprofile/nmi_int.c          |  199 +++++++++++++++---------
 arch/x86/oprofile/op_model_amd.c     |  280 +++++++++++++++------------------
 arch/x86/oprofile/op_model_p4.c      |   52 ++++---
 arch/x86/oprofile/op_model_ppro.c    |   77 +++++-----
 arch/x86/oprofile/op_x86_model.h     |    4 +-
 drivers/oprofile/cpu_buffer.c        |   75 +++-------
 drivers/oprofile/oprof.c             |   12 +-
 drivers/oprofile/oprof.h             |    3 +-
 drivers/oprofile/timer_int.c         |   78 +++++++++-
 include/linux/ftrace_event.h         |    1 +
 include/linux/module.h               |    6 +-
 include/linux/ring_buffer.h          |    6 +-
 include/trace/events/module.h        |   18 ++-
 include/trace/events/signal.h        |   52 +++----
 include/trace/ftrace.h               |   33 +++--
 kernel/module.c                      |    8 +-
 kernel/trace/ring_buffer.c           |  101 ++++++++++++-
 kernel/trace/ring_buffer_benchmark.c |    2 +-
 kernel/trace/trace.c                 |   30 +++-
 kernel/trace/trace_functions_graph.c |    5 +-
 kernel/trace/trace_selftest.c        |    2 +-
 22 files changed, 609 insertions(+), 436 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d5b0b1b..a4035d7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4165,6 +4165,7 @@ OPROFILE
 M:	Robert Richter <robert.richter@amd.com>
 L:	oprofile-list@lists.sf.net
 S:	Maintained
+F:	arch/*/include/asm/oprofile*.h
 F:	arch/*/oprofile/
 F:	drivers/oprofile/
 F:	include/linux/oprofile.h
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 2c505ee..b28d2f1 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -31,8 +31,9 @@ static struct op_x86_model_spec *model;
 static DEFINE_PER_CPU(struct op_msrs, cpu_msrs);
 static DEFINE_PER_CPU(unsigned long, saved_lvtpc);
 
-/* 0 == registered but off, 1 == registered and on */
-static int nmi_enabled = 0;
+/* must be protected with get_online_cpus()/put_online_cpus(): */
+static int nmi_enabled;
+static int ctr_running;
 
 struct op_counter_config counter_config[OP_MAX_COUNTER];
 
@@ -61,12 +62,16 @@ static int profile_exceptions_notify(struct notifier_block *self,
 {
 	struct die_args *args = (struct die_args *)data;
 	int ret = NOTIFY_DONE;
-	int cpu = smp_processor_id();
 
 	switch (val) {
 	case DIE_NMI:
 	case DIE_NMI_IPI:
-		model->check_ctrs(args->regs, &per_cpu(cpu_msrs, cpu));
+		if (ctr_running)
+			model->check_ctrs(args->regs, &__get_cpu_var(cpu_msrs));
+		else if (!nmi_enabled)
+			break;
+		else
+			model->stop(&__get_cpu_var(cpu_msrs));
 		ret = NOTIFY_STOP;
 		break;
 	default:
@@ -95,24 +100,36 @@ static void nmi_cpu_save_registers(struct op_msrs *msrs)
 static void nmi_cpu_start(void *dummy)
 {
 	struct op_msrs const *msrs = &__get_cpu_var(cpu_msrs);
-	model->start(msrs);
+	if (!msrs->controls)
+		WARN_ON_ONCE(1);
+	else
+		model->start(msrs);
 }
 
 static int nmi_start(void)
 {
+	get_online_cpus();
 	on_each_cpu(nmi_cpu_start, NULL, 1);
+	ctr_running = 1;
+	put_online_cpus();
 	return 0;
 }
 
 static void nmi_cpu_stop(void *dummy)
 {
 	struct op_msrs const *msrs = &__get_cpu_var(cpu_msrs);
-	model->stop(msrs);
+	if (!msrs->controls)
+		WARN_ON_ONCE(1);
+	else
+		model->stop(msrs);
 }
 
 static void nmi_stop(void)
 {
+	get_online_cpus();
 	on_each_cpu(nmi_cpu_stop, NULL, 1);
+	ctr_running = 0;
+	put_online_cpus();
 }
 
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
@@ -252,7 +269,10 @@ static int nmi_switch_event(void)
 	if (nmi_multiplex_on() < 0)
 		return -EINVAL;		/* not necessary */
 
-	on_each_cpu(nmi_cpu_switch, NULL, 1);
+	get_online_cpus();
+	if (ctr_running)
+		on_each_cpu(nmi_cpu_switch, NULL, 1);
+	put_online_cpus();
 
 	return 0;
 }
@@ -295,6 +315,7 @@ static void free_msrs(void)
 		kfree(per_cpu(cpu_msrs, i).controls);
 		per_cpu(cpu_msrs, i).controls = NULL;
 	}
+	nmi_shutdown_mux();
 }
 
 static int allocate_msrs(void)
@@ -307,14 +328,21 @@ static int allocate_msrs(void)
 		per_cpu(cpu_msrs, i).counters = kzalloc(counters_size,
 							GFP_KERNEL);
 		if (!per_cpu(cpu_msrs, i).counters)
-			return 0;
+			goto fail;
 		per_cpu(cpu_msrs, i).controls = kzalloc(controls_size,
 							GFP_KERNEL);
 		if (!per_cpu(cpu_msrs, i).controls)
-			return 0;
+			goto fail;
 	}
 
+	if (!nmi_setup_mux())
+		goto fail;
+
 	return 1;
+
+fail:
+	free_msrs();
+	return 0;
 }
 
 static void nmi_cpu_setup(void *dummy)
@@ -336,49 +364,6 @@ static struct notifier_block profile_exceptions_nb = {
 	.priority = 2
 };
 
-static int nmi_setup(void)
-{
-	int err = 0;
-	int cpu;
-
-	if (!allocate_msrs())
-		err = -ENOMEM;
-	else if (!nmi_setup_mux())
-		err = -ENOMEM;
-	else
-		err = register_die_notifier(&profile_exceptions_nb);
-
-	if (err) {
-		free_msrs();
-		nmi_shutdown_mux();
-		return err;
-	}
-
-	/* We need to serialize save and setup for HT because the subset
-	 * of msrs are distinct for save and setup operations
-	 */
-
-	/* Assume saved/restored counters are the same on all CPUs */
-	model->fill_in_addresses(&per_cpu(cpu_msrs, 0));
-	for_each_possible_cpu(cpu) {
-		if (!cpu)
-			continue;
-
-		memcpy(per_cpu(cpu_msrs, cpu).counters,
-		       per_cpu(cpu_msrs, 0).counters,
-		       sizeof(struct op_msr) * model->num_counters);
-
-		memcpy(per_cpu(cpu_msrs, cpu).controls,
-		       per_cpu(cpu_msrs, 0).controls,
-		       sizeof(struct op_msr) * model->num_controls);
-
-		mux_clone(cpu);
-	}
-	on_each_cpu(nmi_cpu_setup, NULL, 1);
-	nmi_enabled = 1;
-	return 0;
-}
-
 static void nmi_cpu_restore_registers(struct op_msrs *msrs)
 {
 	struct op_msr *counters = msrs->counters;
@@ -412,20 +397,24 @@ static void nmi_cpu_shutdown(void *dummy)
 	apic_write(APIC_LVTPC, per_cpu(saved_lvtpc, cpu));
 	apic_write(APIC_LVTERR, v);
 	nmi_cpu_restore_registers(msrs);
+	if (model->cpu_down)
+		model->cpu_down();
 }
 
-static void nmi_shutdown(void)
+static void nmi_cpu_up(void *dummy)
 {
-	struct op_msrs *msrs;
+	if (nmi_enabled)
+		nmi_cpu_setup(dummy);
+	if (ctr_running)
+		nmi_cpu_start(dummy);
+}
 
-	nmi_enabled = 0;
-	on_each_cpu(nmi_cpu_shutdown, NULL, 1);
-	unregister_die_notifier(&profile_exceptions_nb);
-	nmi_shutdown_mux();
-	msrs = &get_cpu_var(cpu_msrs);
-	model->shutdown(msrs);
-	free_msrs();
-	put_cpu_var(cpu_msrs);
+static void nmi_cpu_down(void *dummy)
+{
+	if (ctr_running)
+		nmi_cpu_stop(dummy);
+	if (nmi_enabled)
+		nmi_cpu_shutdown(dummy);
 }
 
 static int nmi_create_files(struct super_block *sb, struct dentry *root)
@@ -457,7 +446,6 @@ static int nmi_create_files(struct super_block *sb, struct dentry *root)
 	return 0;
 }
 
-#ifdef CONFIG_SMP
 static int oprofile_cpu_notifier(struct notifier_block *b, unsigned long action,
 				 void *data)
 {
@@ -465,10 +453,10 @@ static int oprofile_cpu_notifier(struct notifier_block *b, unsigned long action,
 	switch (action) {
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
-		smp_call_function_single(cpu, nmi_cpu_start, NULL, 0);
+		smp_call_function_single(cpu, nmi_cpu_up, NULL, 0);
 		break;
 	case CPU_DOWN_PREPARE:
-		smp_call_function_single(cpu, nmi_cpu_stop, NULL, 1);
+		smp_call_function_single(cpu, nmi_cpu_down, NULL, 1);
 		break;
 	}
 	return NOTIFY_DONE;
@@ -477,7 +465,75 @@ static int oprofile_cpu_notifier(struct notifier_block *b, unsigned long action,
 static struct notifier_block oprofile_cpu_nb = {
 	.notifier_call = oprofile_cpu_notifier
 };
-#endif
+
+static int nmi_setup(void)
+{
+	int err = 0;
+	int cpu;
+
+	if (!allocate_msrs())
+		return -ENOMEM;
+
+	/* We need to serialize save and setup for HT because the subset
+	 * of msrs are distinct for save and setup operations
+	 */
+
+	/* Assume saved/restored counters are the same on all CPUs */
+	err = model->fill_in_addresses(&per_cpu(cpu_msrs, 0));
+	if (err)
+		goto fail;
+
+	for_each_possible_cpu(cpu) {
+		if (!cpu)
+			continue;
+
+		memcpy(per_cpu(cpu_msrs, cpu).counters,
+		       per_cpu(cpu_msrs, 0).counters,
+		       sizeof(struct op_msr) * model->num_counters);
+
+		memcpy(per_cpu(cpu_msrs, cpu).controls,
+		       per_cpu(cpu_msrs, 0).controls,
+		       sizeof(struct op_msr) * model->num_controls);
+
+		mux_clone(cpu);
+	}
+
+	nmi_enabled = 0;
+	ctr_running = 0;
+	barrier();
+	err = register_die_notifier(&profile_exceptions_nb);
+	if (err)
+		goto fail;
+
+	get_online_cpus();
+	register_cpu_notifier(&oprofile_cpu_nb);
+	on_each_cpu(nmi_cpu_setup, NULL, 1);
+	nmi_enabled = 1;
+	put_online_cpus();
+
+	return 0;
+fail:
+	free_msrs();
+	return err;
+}
+
+static void nmi_shutdown(void)
+{
+	struct op_msrs *msrs;
+
+	get_online_cpus();
+	unregister_cpu_notifier(&oprofile_cpu_nb);
+	on_each_cpu(nmi_cpu_shutdown, NULL, 1);
+	nmi_enabled = 0;
+	ctr_running = 0;
+	put_online_cpus();
+	barrier();
+	unregister_die_notifier(&profile_exceptions_nb);
+	msrs = &get_cpu_var(cpu_msrs);
+	model->shutdown(msrs);
+	free_msrs();
+	put_cpu_var(cpu_msrs);
+}
 
 #ifdef CONFIG_PM
 
@@ -687,9 +743,6 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 		return -ENODEV;
 	}
 
-#ifdef CONFIG_SMP
-	register_cpu_notifier(&oprofile_cpu_nb);
-#endif
 	/* default values, can be overwritten by model */
 	ops->create_files	= nmi_create_files;
 	ops->setup		= nmi_setup;
@@ -716,12 +769,6 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 
 void op_nmi_exit(void)
 {
-	if (using_nmi) {
+	if (using_nmi)
 		exit_sysfs();
-#ifdef CONFIG_SMP
-		unregister_cpu_notifier(&oprofile_cpu_nb);
-#endif
-	}
-	if (model->exit)
-		model->exit();
 }
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 090cbbe..b67a6b5 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -30,13 +30,10 @@
 #include "op_counter.h"
 
 #define NUM_COUNTERS 4
-#define NUM_CONTROLS 4
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
 #define NUM_VIRT_COUNTERS 32
-#define NUM_VIRT_CONTROLS 32
 #else
 #define NUM_VIRT_COUNTERS NUM_COUNTERS
-#define NUM_VIRT_CONTROLS NUM_CONTROLS
 #endif
 
 #define OP_EVENT_MASK			0x0FFF
@@ -105,102 +102,6 @@ static u32 get_ibs_caps(void)
 	return ibs_caps;
 }
 
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-
-static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
-			       struct op_msrs const * const msrs)
-{
-	u64 val;
-	int i;
-
-	/* enable active counters */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
-		int virt = op_x86_phys_to_virt(i);
-		if (!reset_value[virt])
-			continue;
-		rdmsrl(msrs->controls[i].addr, val);
-		val &= model->reserved;
-		val |= op_x86_get_ctrl(model, &counter_config[virt]);
-		wrmsrl(msrs->controls[i].addr, val);
-	}
-}
-
-#endif
-
-/* functions for op_amd_spec */
-
-static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
-{
-	int i;
-
-	for (i = 0; i < NUM_COUNTERS; i++) {
-		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
-			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
-	}
-
-	for (i = 0; i < NUM_CONTROLS; i++) {
-		if (reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i))
-			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
-	}
-}
-
-static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
-			      struct op_msrs const * const msrs)
-{
-	u64 val;
-	int i;
-
-	/* setup reset_value */
-	for (i = 0; i < NUM_VIRT_COUNTERS; ++i) {
-		if (counter_config[i].enabled
-		    && msrs->counters[op_x86_virt_to_phys(i)].addr)
-			reset_value[i] = counter_config[i].count;
-		else
-			reset_value[i] = 0;
-	}
-
-	/* clear all counters */
-	for (i = 0; i < NUM_CONTROLS; ++i) {
-		if (unlikely(!msrs->controls[i].addr)) {
-			if (counter_config[i].enabled && !smp_processor_id())
-				/*
-				 * counter is reserved, this is on all
-				 * cpus, so report only for cpu #0
-				 */
-				op_x86_warn_reserved(i);
-			continue;
-		}
-		rdmsrl(msrs->controls[i].addr, val);
-		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
-			op_x86_warn_in_use(i);
-		val &= model->reserved;
-		wrmsrl(msrs->controls[i].addr, val);
-	}
-
-	/* avoid a false detection of ctr overflows in NMI handler */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if (unlikely(!msrs->counters[i].addr))
-			continue;
-		wrmsrl(msrs->counters[i].addr, -1LL);
-	}
-
-	/* enable active counters */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
-		int virt = op_x86_phys_to_virt(i);
-		if (!reset_value[virt])
-			continue;
-
-		/* setup counter registers */
-		wrmsrl(msrs->counters[i].addr, -(u64)reset_value[virt]);
-
-		/* setup control registers */
-		rdmsrl(msrs->controls[i].addr, val);
-		val &= model->reserved;
-		val |= op_x86_get_ctrl(model, &counter_config[virt]);
-		wrmsrl(msrs->controls[i].addr, val);
-	}
-}
-
 /*
  * 16-bit Linear Feedback Shift Register (LFSR)
  *
@@ -365,6 +266,125 @@ static void op_amd_stop_ibs(void)
 		wrmsrl(MSR_AMD64_IBSOPCTL, 0);
 }
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
+static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
+			       struct op_msrs const * const msrs)
+{
+	u64 val;
+	int i;
+
+	/* enable active counters */
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		int virt = op_x86_phys_to_virt(i);
+		if (!reset_value[virt])
+			continue;
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= model->reserved;
+		val |= op_x86_get_ctrl(model, &counter_config[virt]);
+		wrmsrl(msrs->controls[i].addr, val);
+	}
+}
+
+#endif
+
+/* functions for op_amd_spec */
+
+static void op_amd_shutdown(struct op_msrs const * const msrs)
+{
+	int i;
+
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		if (!msrs->counters[i].addr)
+			continue;
+		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+		release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+	}
+}
+
+static int op_amd_fill_in_addresses(struct op_msrs * const msrs)
+{
+	int i;
+
+	for (i = 0; i < NUM_COUNTERS; i++) {
+		if (!reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
+			goto fail;
+		if (!reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i)) {
+			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+			goto fail;
+		}
+		/* both registers must be reserved */
+		msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
+		msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
+		continue;
+	fail:
+		if (!counter_config[i].enabled)
+			continue;
+		op_x86_warn_reserved(i);
+		op_amd_shutdown(msrs);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
+			      struct op_msrs const * const msrs)
+{
+	u64 val;
+	int i;
+
+	/* setup reset_value */
+	for (i = 0; i < NUM_VIRT_COUNTERS; ++i) {
+		if (counter_config[i].enabled
+		    && msrs->counters[op_x86_virt_to_phys(i)].addr)
+			reset_value[i] = counter_config[i].count;
+		else
+			reset_value[i] = 0;
+	}
+
+	/* clear all counters */
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		if (!msrs->controls[i].addr)
+			continue;
+		rdmsrl(msrs->controls[i].addr, val);
+		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
+			op_x86_warn_in_use(i);
+		val &= model->reserved;
+		wrmsrl(msrs->controls[i].addr, val);
+		/*
+		 * avoid a false detection of ctr overflows in NMI
+		 * handler
+		 */
+		wrmsrl(msrs->counters[i].addr, -1LL);
+	}
+
+	/* enable active counters */
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		int virt = op_x86_phys_to_virt(i);
+		if (!reset_value[virt])
+			continue;
+
+		/* setup counter registers */
+		wrmsrl(msrs->counters[i].addr, -(u64)reset_value[virt]);
+
+		/* setup control registers */
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= model->reserved;
+		val |= op_x86_get_ctrl(model, &counter_config[virt]);
+		wrmsrl(msrs->controls[i].addr, val);
+	}
+
+	if (ibs_caps)
+		setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_NMI, 0);
+}
+
+static void op_amd_cpu_shutdown(void)
+{
+	if (ibs_caps)
+		setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
+}
+
 static int op_amd_check_ctrs(struct pt_regs * const regs,
 			     struct op_msrs const * const msrs)
 {
@@ -425,42 +445,16 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 	op_amd_stop_ibs();
 }
 
-static void op_amd_shutdown(struct op_msrs const * const msrs)
-{
-	int i;
-
-	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if (msrs->counters[i].addr)
-			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-	}
-	for (i = 0; i < NUM_CONTROLS; ++i) {
-		if (msrs->controls[i].addr)
-			release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
-	}
-}
-
-static u8 ibs_eilvt_off;
-
-static inline void apic_init_ibs_nmi_per_cpu(void *arg)
-{
-	ibs_eilvt_off = setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_NMI, 0);
-}
-
-static inline void apic_clear_ibs_nmi_per_cpu(void *arg)
-{
-	setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
-}
-
-static int init_ibs_nmi(void)
+static int __init_ibs_nmi(void)
 {
 #define IBSCTL_LVTOFFSETVAL		(1 << 8)
 #define IBSCTL				0x1cc
 	struct pci_dev *cpu_cfg;
 	int nodes;
 	u32 value = 0;
+	u8 ibs_eilvt_off;
 
-	/* per CPU setup */
-	on_each_cpu(apic_init_ibs_nmi_per_cpu, NULL, 1);
+	ibs_eilvt_off = setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
 
 	nodes = 0;
 	cpu_cfg = NULL;
@@ -490,22 +484,15 @@ static int init_ibs_nmi(void)
 	return 0;
 }
 
-/* uninitialize the APIC for the IBS interrupts if needed */
-static void clear_ibs_nmi(void)
-{
-	if (ibs_caps)
-		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
-}
-
 /* initialize the APIC for the IBS interrupts if available */
-static void ibs_init(void)
+static void init_ibs(void)
 {
 	ibs_caps = get_ibs_caps();
 
 	if (!ibs_caps)
 		return;
 
-	if (init_ibs_nmi()) {
+	if (__init_ibs_nmi()) {
 		ibs_caps = 0;
 		return;
 	}
@@ -514,14 +501,6 @@ static void ibs_init(void)
 	       (unsigned)ibs_caps);
 }
 
-static void ibs_exit(void)
-{
-	if (!ibs_caps)
-		return;
-
-	clear_ibs_nmi();
-}
-
 static int (*create_arch_files)(struct super_block *sb, struct dentry *root);
 
 static int setup_ibs_files(struct super_block *sb, struct dentry *root)
@@ -570,27 +549,22 @@ static int setup_ibs_files(struct super_block *sb, struct dentry *root)
 
 static int op_amd_init(struct oprofile_operations *ops)
 {
-	ibs_init();
+	init_ibs();
 	create_arch_files = ops->create_files;
 	ops->create_files = setup_ibs_files;
 	return 0;
 }
 
-static void op_amd_exit(void)
-{
-	ibs_exit();
-}
-
 struct op_x86_model_spec op_amd_spec = {
 	.num_counters		= NUM_COUNTERS,
-	.num_controls		= NUM_CONTROLS,
+	.num_controls		= NUM_COUNTERS,
 	.num_virt_counters	= NUM_VIRT_COUNTERS,
 	.reserved		= MSR_AMD_EVENTSEL_RESERVED,
 	.event_mask		= OP_EVENT_MASK,
 	.init			= op_amd_init,
-	.exit			= op_amd_exit,
 	.fill_in_addresses	= &op_amd_fill_in_addresses,
 	.setup_ctrs		= &op_amd_setup_ctrs,
+	.cpu_down		= &op_amd_cpu_shutdown,
 	.check_ctrs		= &op_amd_check_ctrs,
 	.start			= &op_amd_start,
 	.stop			= &op_amd_stop,
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index e6a160a..182558d 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -385,8 +385,26 @@ static unsigned int get_stagger(void)
 
 static unsigned long reset_value[NUM_COUNTERS_NON_HT];
 
+static void p4_shutdown(struct op_msrs const * const msrs)
+{
+	int i;
 
-static void p4_fill_in_addresses(struct op_msrs * const msrs)
+	for (i = 0; i < num_counters; ++i) {
+		if (msrs->counters[i].addr)
+			release_perfctr_nmi(msrs->counters[i].addr);
+	}
+	/*
+	 * some of the control registers are specially reserved in
+	 * conjunction with the counter registers (hence the starting offset).
+	 * This saves a few bits.
+	 */
+	for (i = num_counters; i < num_controls; ++i) {
+		if (msrs->controls[i].addr)
+			release_evntsel_nmi(msrs->controls[i].addr);
+	}
+}
+
+static int p4_fill_in_addresses(struct op_msrs * const msrs)
 {
 	unsigned int i;
 	unsigned int addr, cccraddr, stag;
@@ -468,6 +486,18 @@ static void p4_fill_in_addresses(struct op_msrs * const msrs)
 			msrs->controls[i++].addr = MSR_P4_CRU_ESCR5;
 		}
 	}
+
+	for (i = 0; i < num_counters; ++i) {
+		if (!counter_config[i].enabled)
+			continue;
+		if (msrs->controls[i].addr)
+			continue;
+		op_x86_warn_reserved(i);
+		p4_shutdown(msrs);
+		return -EBUSY;
+	}
+
+	return 0;
 }
 
 
@@ -668,26 +698,6 @@ static void p4_stop(struct op_msrs const * const msrs)
 	}
 }
 
-static void p4_shutdown(struct op_msrs const * const msrs)
-{
-	int i;
-
-	for (i = 0; i < num_counters; ++i) {
-		if (msrs->counters[i].addr)
-			release_perfctr_nmi(msrs->counters[i].addr);
-	}
-	/*
-	 * some of the control registers are specially reserved in
-	 * conjunction with the counter registers (hence the starting offset).
-	 * This saves a few bits.
-	 */
-	for (i = num_counters; i < num_controls; ++i) {
-		if (msrs->controls[i].addr)
-			release_evntsel_nmi(msrs->controls[i].addr);
-	}
-}
-
-
 #ifdef CONFIG_SMP
 struct op_x86_model_spec op_p4_ht2_spec = {
 	.num_counters		= NUM_COUNTERS_HT2,
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 2bf90fa..1fd17cf 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -30,19 +30,46 @@ static int counter_width = 32;
 
 static u64 *reset_value;
 
-static void ppro_fill_in_addresses(struct op_msrs * const msrs)
+static void ppro_shutdown(struct op_msrs const * const msrs)
 {
 	int i;
 
-	for (i = 0; i < num_counters; i++) {
-		if (reserve_perfctr_nmi(MSR_P6_PERFCTR0 + i))
-			msrs->counters[i].addr = MSR_P6_PERFCTR0 + i;
+	for (i = 0; i < num_counters; ++i) {
+		if (!msrs->counters[i].addr)
+			continue;
+		release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
+		release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
+	}
+	if (reset_value) {
+		kfree(reset_value);
+		reset_value = NULL;
 	}
+}
+
+static int ppro_fill_in_addresses(struct op_msrs * const msrs)
+{
+	int i;
 
 	for (i = 0; i < num_counters; i++) {
-		if (reserve_evntsel_nmi(MSR_P6_EVNTSEL0 + i))
-			msrs->controls[i].addr = MSR_P6_EVNTSEL0 + i;
+		if (!reserve_perfctr_nmi(MSR_P6_PERFCTR0 + i))
+			goto fail;
+		if (!reserve_evntsel_nmi(MSR_P6_EVNTSEL0 + i)) {
+			release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
+			goto fail;
+		}
+		/* both registers must be reserved */
+		msrs->counters[i].addr = MSR_P6_PERFCTR0 + i;
+		msrs->controls[i].addr = MSR_P6_EVNTSEL0 + i;
+		continue;
+	fail:
+		if (!counter_config[i].enabled)
+			continue;
+		op_x86_warn_reserved(i);
+		ppro_shutdown(msrs);
+		return -EBUSY;
 	}
+
+	return 0;
 }
 
 
@@ -78,26 +105,17 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* clear all counters */
 	for (i = 0; i < num_counters; ++i) {
-		if (unlikely(!msrs->controls[i].addr)) {
-			if (counter_config[i].enabled && !smp_processor_id())
-				/*
-				 * counter is reserved, this is on all
-				 * cpus, so report only for cpu #0
-				 */
-				op_x86_warn_reserved(i);
+		if (!msrs->controls[i].addr)
 			continue;
-		}
 		rdmsrl(msrs->controls[i].addr, val);
 		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
 			op_x86_warn_in_use(i);
 		val &= model->reserved;
 		wrmsrl(msrs->controls[i].addr, val);
-	}
-
-	/* avoid a false detection of ctr overflows in NMI handler */
-	for (i = 0; i < num_counters; ++i) {
-		if (unlikely(!msrs->counters[i].addr))
-			continue;
+		/*
+		 * avoid a false detection of ctr overflows in NMI *
+		 * handler
+		 */
 		wrmsrl(msrs->counters[i].addr, -1LL);
 	}
 
@@ -189,25 +207,6 @@ static void ppro_stop(struct op_msrs const * const msrs)
 	}
 }
 
-static void ppro_shutdown(struct op_msrs const * const msrs)
-{
-	int i;
-
-	for (i = 0; i < num_counters; ++i) {
-		if (msrs->counters[i].addr)
-			release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
-	}
-	for (i = 0; i < num_counters; ++i) {
-		if (msrs->controls[i].addr)
-			release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
-	}
-	if (reset_value) {
-		kfree(reset_value);
-		reset_value = NULL;
-	}
-}
-
-
 struct op_x86_model_spec op_ppro_spec = {
 	.num_counters		= 2,
 	.num_controls		= 2,
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index ff82a75..89017fa 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -40,10 +40,10 @@ struct op_x86_model_spec {
 	u64		reserved;
 	u16		event_mask;
 	int		(*init)(struct oprofile_operations *ops);
-	void		(*exit)(void);
-	void		(*fill_in_addresses)(struct op_msrs * const msrs);
+	int		(*fill_in_addresses)(struct op_msrs * const msrs);
 	void		(*setup_ctrs)(struct op_x86_model_spec const *model,
 				      struct op_msrs const * const msrs);
+	void		(*cpu_down)(void);
 	int		(*check_ctrs)(struct pt_regs * const regs,
 				      struct op_msrs const * const msrs);
 	void		(*start)(struct op_msrs const * const msrs);
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 166b67e..219f79e 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -30,23 +30,7 @@
 
 #define OP_BUFFER_FLAGS	0
 
-/*
- * Read and write access is using spin locking. Thus, writing to the
- * buffer by NMI handler (x86) could occur also during critical
- * sections when reading the buffer. To avoid this, there are 2
- * buffers for independent read and write access. Read access is in
- * process context only, write access only in the NMI handler. If the
- * read buffer runs empty, both buffers are swapped atomically. There
- * is potentially a small window during swapping where the buffers are
- * disabled and samples could be lost.
- *
- * Using 2 buffers is a little bit overhead, but the solution is clear
- * and does not require changes in the ring buffer implementation. It
- * can be changed to a single buffer solution when the ring buffer
- * access is implemented as non-locking atomic code.
- */
-static struct ring_buffer *op_ring_buffer_read;
-static struct ring_buffer *op_ring_buffer_write;
+static struct ring_buffer *op_ring_buffer;
 DEFINE_PER_CPU(struct oprofile_cpu_buffer, op_cpu_buffer);
 
 static void wq_sync_buffer(struct work_struct *work);
@@ -68,12 +52,9 @@ void oprofile_cpu_buffer_inc_smpl_lost(void)
 
 void free_cpu_buffers(void)
 {
-	if (op_ring_buffer_read)
-		ring_buffer_free(op_ring_buffer_read);
-	op_ring_buffer_read = NULL;
-	if (op_ring_buffer_write)
-		ring_buffer_free(op_ring_buffer_write);
-	op_ring_buffer_write = NULL;
+	if (op_ring_buffer)
+		ring_buffer_free(op_ring_buffer);
+	op_ring_buffer = NULL;
 }
 
 #define RB_EVENT_HDR_SIZE 4
@@ -86,11 +67,8 @@ int alloc_cpu_buffers(void)
 	unsigned long byte_size = buffer_size * (sizeof(struct op_sample) +
 						 RB_EVENT_HDR_SIZE);
 
-	op_ring_buffer_read = ring_buffer_alloc(byte_size, OP_BUFFER_FLAGS);
-	if (!op_ring_buffer_read)
-		goto fail;
-	op_ring_buffer_write = ring_buffer_alloc(byte_size, OP_BUFFER_FLAGS);
-	if (!op_ring_buffer_write)
+	op_ring_buffer = ring_buffer_alloc(byte_size, OP_BUFFER_FLAGS);
+	if (!op_ring_buffer)
 		goto fail;
 
 	for_each_possible_cpu(i) {
@@ -162,16 +140,11 @@ struct op_sample
 *op_cpu_buffer_write_reserve(struct op_entry *entry, unsigned long size)
 {
 	entry->event = ring_buffer_lock_reserve
-		(op_ring_buffer_write, sizeof(struct op_sample) +
+		(op_ring_buffer, sizeof(struct op_sample) +
 		 size * sizeof(entry->sample->data[0]));
-	if (entry->event)
-		entry->sample = ring_buffer_event_data(entry->event);
-	else
-		entry->sample = NULL;
-
-	if (!entry->sample)
+	if (!entry->event)
 		return NULL;
-
+	entry->sample = ring_buffer_event_data(entry->event);
 	entry->size = size;
 	entry->data = entry->sample->data;
 
@@ -180,25 +153,16 @@ struct op_sample
 
 int op_cpu_buffer_write_commit(struct op_entry *entry)
 {
-	return ring_buffer_unlock_commit(op_ring_buffer_write, entry->event);
+	return ring_buffer_unlock_commit(op_ring_buffer, entry->event);
 }
 
 struct op_sample *op_cpu_buffer_read_entry(struct op_entry *entry, int cpu)
 {
 	struct ring_buffer_event *e;
-	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
-	if (e)
-		goto event;
-	if (ring_buffer_swap_cpu(op_ring_buffer_read,
-				 op_ring_buffer_write,
-				 cpu))
+	e = ring_buffer_consume(op_ring_buffer, cpu, NULL, NULL);
+	if (!e)
 		return NULL;
-	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
-	if (e)
-		goto event;
-	return NULL;
 
-event:
 	entry->event = e;
 	entry->sample = ring_buffer_event_data(e);
 	entry->size = (ring_buffer_event_length(e) - sizeof(struct op_sample))
@@ -209,8 +173,7 @@ event:
 
 unsigned long op_cpu_buffer_entries(int cpu)
 {
-	return ring_buffer_entries_cpu(op_ring_buffer_read, cpu)
-		+ ring_buffer_entries_cpu(op_ring_buffer_write, cpu);
+	return ring_buffer_entries_cpu(op_ring_buffer, cpu);
 }
 
 static int
@@ -356,8 +319,16 @@ void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 
 void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 {
-	int is_kernel = !user_mode(regs);
-	unsigned long pc = profile_pc(regs);
+	int is_kernel;
+	unsigned long pc;
+
+	if (likely(regs)) {
+		is_kernel = !user_mode(regs);
+		pc = profile_pc(regs);
+	} else {
+		is_kernel = 0;    /* This value will not be used */
+		pc = ESCAPE_CODE; /* as this causes an early return. */
+	}
 
 	__oprofile_add_ext_sample(pc, regs, event, is_kernel);
 }
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index dc8a042..b336cd9 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -253,22 +253,26 @@ static int __init oprofile_init(void)
 	int err;
 
 	err = oprofile_arch_init(&oprofile_ops);
-
 	if (err < 0 || timer) {
 		printk(KERN_INFO "oprofile: using timer interrupt.\n");
-		oprofile_timer_init(&oprofile_ops);
+		err = oprofile_timer_init(&oprofile_ops);
+		if (err)
+			goto out_arch;
 	}
-
 	err = oprofilefs_register();
 	if (err)
-		oprofile_arch_exit();
+		goto out_arch;
+	return 0;
 
+out_arch:
+	oprofile_arch_exit();
 	return err;
 }
 
 
 static void __exit oprofile_exit(void)
 {
+	oprofile_timer_exit();
 	oprofilefs_unregister();
 	oprofile_arch_exit();
 }
diff --git a/drivers/oprofile/oprof.h b/drivers/oprofile/oprof.h
index cb92f5c..47e12cb 100644
--- a/drivers/oprofile/oprof.h
+++ b/drivers/oprofile/oprof.h
@@ -34,7 +34,8 @@ struct super_block;
 struct dentry;
 
 void oprofile_create_files(struct super_block *sb, struct dentry *root);
-void oprofile_timer_init(struct oprofile_operations *ops);
+int oprofile_timer_init(struct oprofile_operations *ops);
+void oprofile_timer_exit(void);
 
 int oprofile_set_backtrace(unsigned long depth);
 int oprofile_set_timeout(unsigned long time);
diff --git a/drivers/oprofile/timer_int.c b/drivers/oprofile/timer_int.c
index 333f915..dc0ae4d 100644
--- a/drivers/oprofile/timer_int.c
+++ b/drivers/oprofile/timer_int.c
@@ -13,34 +13,94 @@
 #include <linux/oprofile.h>
 #include <linux/profile.h>
 #include <linux/init.h>
+#include <linux/cpu.h>
+#include <linux/hrtimer.h>
+#include <asm/irq_regs.h>
 #include <asm/ptrace.h>
 
 #include "oprof.h"
 
-static int timer_notify(struct pt_regs *regs)
+static DEFINE_PER_CPU(struct hrtimer, oprofile_hrtimer);
+
+static enum hrtimer_restart oprofile_hrtimer_notify(struct hrtimer *hrtimer)
+{
+	oprofile_add_sample(get_irq_regs(), 0);
+	hrtimer_forward_now(hrtimer, ns_to_ktime(TICK_NSEC));
+	return HRTIMER_RESTART;
+}
+
+static void __oprofile_hrtimer_start(void *unused)
+{
+	struct hrtimer *hrtimer = &__get_cpu_var(oprofile_hrtimer);
+
+	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer->function = oprofile_hrtimer_notify;
+
+	hrtimer_start(hrtimer, ns_to_ktime(TICK_NSEC),
+		      HRTIMER_MODE_REL_PINNED);
+}
+
+static int oprofile_hrtimer_start(void)
 {
-	oprofile_add_sample(regs, 0);
+	on_each_cpu(__oprofile_hrtimer_start, NULL, 1);
 	return 0;
 }
 
-static int timer_start(void)
+static void __oprofile_hrtimer_stop(int cpu)
 {
-	return register_timer_hook(timer_notify);
+	struct hrtimer *hrtimer = &per_cpu(oprofile_hrtimer, cpu);
+
+	hrtimer_cancel(hrtimer);
 }
 
+static void oprofile_hrtimer_stop(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		__oprofile_hrtimer_stop(cpu);
+}
 
-static void timer_stop(void)
+static int __cpuinit oprofile_cpu_notify(struct notifier_block *self,
+					 unsigned long action, void *hcpu)
 {
-	unregister_timer_hook(timer_notify);
+	long cpu = (long) hcpu;
+
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		smp_call_function_single(cpu, __oprofile_hrtimer_start,
+					 NULL, 1);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		__oprofile_hrtimer_stop(cpu);
+		break;
+	}
+	return NOTIFY_OK;
 }
 
+static struct notifier_block __refdata oprofile_cpu_notifier = {
+	.notifier_call = oprofile_cpu_notify,
+};
 
-void __init oprofile_timer_init(struct oprofile_operations *ops)
+int __init oprofile_timer_init(struct oprofile_operations *ops)
 {
+	int rc;
+
+	rc = register_hotcpu_notifier(&oprofile_cpu_notifier);
+	if (rc)
+		return rc;
 	ops->create_files = NULL;
 	ops->setup = NULL;
 	ops->shutdown = NULL;
-	ops->start = timer_start;
-	ops->stop = timer_stop;
+	ops->start = oprofile_hrtimer_start;
+	ops->stop = oprofile_hrtimer_stop;
 	ops->cpu_type = "timer";
+	return 0;
+}
+
+void __exit oprofile_timer_exit(void)
+{
+	unregister_hotcpu_notifier(&oprofile_cpu_notifier);
 }
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index c0f4b36..39e71b0 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -58,6 +58,7 @@ struct trace_iterator {
 	/* The below is zeroed out in pipe_read */
 	struct trace_seq	seq;
 	struct trace_entry	*ent;
+	unsigned long		lost_events;
 	int			leftover;
 	int			cpu;
 	u64			ts;
diff --git a/include/linux/module.h b/include/linux/module.h
index 515d53a..6914fca 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -465,8 +465,7 @@ static inline void __module_get(struct module *module)
 	if (module) {
 		preempt_disable();
 		__this_cpu_inc(module->refptr->incs);
-		trace_module_get(module, _THIS_IP_,
-				 __this_cpu_read(module->refptr->incs));
+		trace_module_get(module, _THIS_IP_);
 		preempt_enable();
 	}
 }
@@ -480,8 +479,7 @@ static inline int try_module_get(struct module *module)
 
 		if (likely(module_is_live(module))) {
 			__this_cpu_inc(module->refptr->incs);
-			trace_module_get(module, _THIS_IP_,
-				__this_cpu_read(module->refptr->incs));
+			trace_module_get(module, _THIS_IP_);
 		} else
 			ret = 0;
 
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 5fcc31e..c829776 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -120,9 +120,11 @@ int ring_buffer_write(struct ring_buffer *buffer,
 		      unsigned long length, void *data);
 
 struct ring_buffer_event *
-ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts);
+ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts,
+		 unsigned long *lost_events);
 struct ring_buffer_event *
-ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts);
+ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts,
+		    unsigned long *lost_events);
 
 struct ring_buffer_iter *
 ring_buffer_read_start(struct ring_buffer *buffer, int cpu);
diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index 4b0f48b..c7bb2f0 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -51,11 +51,14 @@ TRACE_EVENT(module_free,
 	TP_printk("%s", __get_str(name))
 );
 
+#ifdef CONFIG_MODULE_UNLOAD
+/* trace_module_get/put are only used if CONFIG_MODULE_UNLOAD is defined */
+
 DECLARE_EVENT_CLASS(module_refcnt,
 
-	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
+	TP_PROTO(struct module *mod, unsigned long ip),
 
-	TP_ARGS(mod, ip, refcnt),
+	TP_ARGS(mod, ip),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	ip		)
@@ -65,7 +68,7 @@ DECLARE_EVENT_CLASS(module_refcnt,
 
 	TP_fast_assign(
 		__entry->ip	= ip;
-		__entry->refcnt	= refcnt;
+		__entry->refcnt	= __this_cpu_read(mod->refptr->incs) + __this_cpu_read(mod->refptr->decs);
 		__assign_str(name, mod->name);
 	),
 
@@ -75,17 +78,18 @@ DECLARE_EVENT_CLASS(module_refcnt,
 
 DEFINE_EVENT(module_refcnt, module_get,
 
-	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
+	TP_PROTO(struct module *mod, unsigned long ip),
 
-	TP_ARGS(mod, ip, refcnt)
+	TP_ARGS(mod, ip)
 );
 
 DEFINE_EVENT(module_refcnt, module_put,
 
-	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
+	TP_PROTO(struct module *mod, unsigned long ip),
 
-	TP_ARGS(mod, ip, refcnt)
+	TP_ARGS(mod, ip)
 );
+#endif /* CONFIG_MODULE_UNLOAD */
 
 TRACE_EVENT(module_request,
 
diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index a510b75..814566c 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -100,18 +100,7 @@ TRACE_EVENT(signal_deliver,
 		  __entry->sa_handler, __entry->sa_flags)
 );
 
-/**
- * signal_overflow_fail - called when signal queue is overflow
- * @sig: signal number
- * @group: signal to process group or not (bool)
- * @info: pointer to struct siginfo
- *
- * Kernel fails to generate 'sig' signal with 'info' siginfo, because
- * siginfo queue is overflow, and the signal is dropped.
- * 'group' is not 0 if the signal will be sent to a process group.
- * 'sig' is always one of RT signals.
- */
-TRACE_EVENT(signal_overflow_fail,
+DECLARE_EVENT_CLASS(signal_queue_overflow,
 
 	TP_PROTO(int sig, int group, struct siginfo *info),
 
@@ -135,6 +124,24 @@ TRACE_EVENT(signal_overflow_fail,
 );
 
 /**
+ * signal_overflow_fail - called when signal queue is overflow
+ * @sig: signal number
+ * @group: signal to process group or not (bool)
+ * @info: pointer to struct siginfo
+ *
+ * Kernel fails to generate 'sig' signal with 'info' siginfo, because
+ * siginfo queue is overflow, and the signal is dropped.
+ * 'group' is not 0 if the signal will be sent to a process group.
+ * 'sig' is always one of RT signals.
+ */
+DEFINE_EVENT(signal_queue_overflow, signal_overflow_fail,
+
+	TP_PROTO(int sig, int group, struct siginfo *info),
+
+	TP_ARGS(sig, group, info)
+);
+
+/**
  * signal_lose_info - called when siginfo is lost
  * @sig: signal number
  * @group: signal to process group or not (bool)
@@ -145,28 +152,13 @@ TRACE_EVENT(signal_overflow_fail,
  * 'group' is not 0 if the signal will be sent to a process group.
  * 'sig' is always one of non-RT signals.
  */
-TRACE_EVENT(signal_lose_info,
+DEFINE_EVENT(signal_queue_overflow, signal_lose_info,
 
 	TP_PROTO(int sig, int group, struct siginfo *info),
 
-	TP_ARGS(sig, group, info),
-
-	TP_STRUCT__entry(
-		__field(	int,	sig	)
-		__field(	int,	group	)
-		__field(	int,	errno	)
-		__field(	int,	code	)
-	),
-
-	TP_fast_assign(
-		__entry->sig	= sig;
-		__entry->group	= group;
-		TP_STORE_SIGINFO(__entry, info);
-	),
-
-	TP_printk("sig=%d group=%d errno=%d code=%d",
-		  __entry->sig, __entry->group, __entry->errno, __entry->code)
+	TP_ARGS(sig, group, info)
 );
+
 #endif /* _TRACE_SIGNAL_H */
 
 /* This part must be outside protection */
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index ea6f9d4..75dd778 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -154,9 +154,11 @@
  *
  *	field = (typeof(field))entry;
  *
- *	p = get_cpu_var(ftrace_event_seq);
+ *	p = &get_cpu_var(ftrace_event_seq);
  *	trace_seq_init(p);
- *	ret = trace_seq_printf(s, <TP_printk> "\n");
+ *	ret = trace_seq_printf(s, "%s: ", <call>);
+ *	if (ret)
+ *		ret = trace_seq_printf(s, <TP_printk> "\n");
  *	put_cpu();
  *	if (!ret)
  *		return TRACE_TYPE_PARTIAL_LINE;
@@ -450,38 +452,38 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
  *
  * static void ftrace_raw_event_<call>(proto)
  * {
+ *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
  *	struct ring_buffer_event *event;
  *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
  *	struct ring_buffer *buffer;
  *	unsigned long irq_flags;
+ *	int __data_size;
  *	int pc;
  *
  *	local_save_flags(irq_flags);
  *	pc = preempt_count();
  *
+ *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
+ *
  *	event = trace_current_buffer_lock_reserve(&buffer,
  *				  event_<call>.id,
- *				  sizeof(struct ftrace_raw_<call>),
+ *				  sizeof(*entry) + __data_size,
  *				  irq_flags, pc);
  *	if (!event)
  *		return;
  *	entry	= ring_buffer_event_data(event);
  *
- *	<assign>;  <-- Here we assign the entries by the __field and
- *			__array macros.
+ *	{ <assign>; }  <-- Here we assign the entries by the __field and
+ *			   __array macros.
  *
- *	trace_current_buffer_unlock_commit(buffer, event, irq_flags, pc);
+ *	if (!filter_current_check_discard(buffer, event_call, entry, event))
+ *		trace_current_buffer_unlock_commit(buffer,
+ *						   event, irq_flags, pc);
  * }
  *
  * static int ftrace_raw_reg_event_<call>(struct ftrace_event_call *unused)
  * {
- *	int ret;
- *
- *	ret = register_trace_<call>(ftrace_raw_event_<call>);
- *	if (!ret)
- *		pr_info("event trace: Could not activate trace point "
- *			"probe to <call>");
- *	return ret;
+ *	return register_trace_<call>(ftrace_raw_event_<call>);
  * }
  *
  * static void ftrace_unreg_event_<call>(struct ftrace_event_call *unused)
@@ -493,6 +495,8 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
  *	.trace			= ftrace_raw_output_<call>, <-- stage 2
  * };
  *
+ * static const char print_fmt_<call>[] = <TP_printk>;
+ *
  * static struct ftrace_event_call __used
  * __attribute__((__aligned__(4)))
  * __attribute__((section("_ftrace_events"))) event_<call> = {
@@ -501,6 +505,8 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
  *	.raw_init		= trace_event_raw_init,
  *	.regfunc		= ftrace_reg_event_<call>,
  *	.unregfunc		= ftrace_unreg_event_<call>,
+ *	.print_fmt		= print_fmt_<call>,
+ *	.define_fields		= ftrace_define_fields_<call>,
  * }
  *
  */
@@ -569,7 +575,6 @@ ftrace_raw_event_id_##call(struct ftrace_event_call *event_call,	\
 		return;							\
 	entry	= ring_buffer_event_data(event);			\
 									\
-									\
 	tstruct								\
 									\
 	{ assign; }							\
diff --git a/kernel/module.c b/kernel/module.c
index 1016b75..b8a1e31 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -59,8 +59,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
 
-EXPORT_TRACEPOINT_SYMBOL(module_get);
-
 #if 0
 #define DEBUGP printk
 #else
@@ -515,6 +513,9 @@ MODINFO_ATTR(srcversion);
 static char last_unloaded_module[MODULE_NAME_LEN+1];
 
 #ifdef CONFIG_MODULE_UNLOAD
+
+EXPORT_TRACEPOINT_SYMBOL(module_get);
+
 /* Init the unload section of the module. */
 static void module_unload_init(struct module *mod)
 {
@@ -867,8 +868,7 @@ void module_put(struct module *module)
 		smp_wmb(); /* see comment in module_refcount */
 		__this_cpu_inc(module->refptr->decs);
 
-		trace_module_put(module, _RET_IP_,
-				 __this_cpu_read(module->refptr->decs));
+		trace_module_put(module, _RET_IP_);
 		/* Maybe they're waiting for us to drop reference? */
 		if (unlikely(!module_is_live(module)))
 			wake_up_process(module->waiter);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 41ca394..5885cdf 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -319,6 +319,11 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 #define TS_MASK		((1ULL << TS_SHIFT) - 1)
 #define TS_DELTA_TEST	(~TS_MASK)
 
+/* Flag when events were overwritten */
+#define RB_MISSED_EVENTS	(1 << 31)
+/* Missed count stored at end */
+#define RB_MISSED_STORED	(1 << 30)
+
 struct buffer_data_page {
 	u64		 time_stamp;	/* page time stamp */
 	local_t		 commit;	/* write committed index */
@@ -338,6 +343,7 @@ struct buffer_page {
 	local_t		 write;		/* index for next write */
 	unsigned	 read;		/* index for next read */
 	local_t		 entries;	/* entries on this page */
+	unsigned long	 real_end;	/* real end of data */
 	struct buffer_data_page *page;	/* Actual data page */
 };
 
@@ -417,6 +423,12 @@ int ring_buffer_print_page_header(struct trace_seq *s)
 			       (unsigned int)sizeof(field.commit),
 			       (unsigned int)is_signed_type(long));
 
+	ret = trace_seq_printf(s, "\tfield: int overwrite;\t"
+			       "offset:%u;\tsize:%u;\tsigned:%u;\n",
+			       (unsigned int)offsetof(typeof(field), commit),
+			       1,
+			       (unsigned int)is_signed_type(long));
+
 	ret = trace_seq_printf(s, "\tfield: char data;\t"
 			       "offset:%u;\tsize:%u;\tsigned:%u;\n",
 			       (unsigned int)offsetof(typeof(field), data),
@@ -440,6 +452,8 @@ struct ring_buffer_per_cpu {
 	struct buffer_page		*tail_page;	/* write to tail */
 	struct buffer_page		*commit_page;	/* committed pages */
 	struct buffer_page		*reader_page;
+	unsigned long			lost_events;
+	unsigned long			last_overrun;
 	local_t				commit_overrun;
 	local_t				overrun;
 	local_t				entries;
@@ -1762,6 +1776,13 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	kmemcheck_annotate_bitfield(event, bitfield);
 
 	/*
+	 * Save the original length to the meta data.
+	 * This will be used by the reader to add lost event
+	 * counter.
+	 */
+	tail_page->real_end = tail;
+
+	/*
 	 * If this event is bigger than the minimum size, then
 	 * we need to be careful that we don't subtract the
 	 * write counter enough to allow another writer to slip
@@ -2838,6 +2859,7 @@ static struct buffer_page *
 rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct buffer_page *reader = NULL;
+	unsigned long overwrite;
 	unsigned long flags;
 	int nr_loops = 0;
 	int ret;
@@ -2879,6 +2901,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	local_set(&cpu_buffer->reader_page->write, 0);
 	local_set(&cpu_buffer->reader_page->entries, 0);
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
+	cpu_buffer->reader_page->real_end = 0;
 
  spin:
 	/*
@@ -2899,6 +2922,18 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	rb_set_list_to_head(cpu_buffer, &cpu_buffer->reader_page->list);
 
 	/*
+	 * We want to make sure we read the overruns after we set up our
+	 * pointers to the next object. The writer side does a
+	 * cmpxchg to cross pages which acts as the mb on the writer
+	 * side. Note, the reader will constantly fail the swap
+	 * while the writer is updating the pointers, so this
+	 * guarantees that the overwrite recorded here is the one we
+	 * want to compare with the last_overrun.
+	 */
+	smp_mb();
+	overwrite = local_read(&(cpu_buffer->overrun));
+
+	/*
 	 * Here's the tricky part.
 	 *
 	 * We need to move the pointer past the header page.
@@ -2929,6 +2964,11 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->reader_page = reader;
 	rb_reset_reader_page(cpu_buffer);
 
+	if (overwrite != cpu_buffer->last_overrun) {
+		cpu_buffer->lost_events = overwrite - cpu_buffer->last_overrun;
+		cpu_buffer->last_overrun = overwrite;
+	}
+
 	goto again;
 
  out:
@@ -3005,8 +3045,14 @@ static void rb_advance_iter(struct ring_buffer_iter *iter)
 		rb_advance_iter(iter);
 }
 
+static int rb_lost_events(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return cpu_buffer->lost_events;
+}
+
 static struct ring_buffer_event *
-rb_buffer_peek(struct ring_buffer_per_cpu *cpu_buffer, u64 *ts)
+rb_buffer_peek(struct ring_buffer_per_cpu *cpu_buffer, u64 *ts,
+	       unsigned long *lost_events)
 {
 	struct ring_buffer_event *event;
 	struct buffer_page *reader;
@@ -3058,6 +3104,8 @@ rb_buffer_peek(struct ring_buffer_per_cpu *cpu_buffer, u64 *ts)
 			ring_buffer_normalize_time_stamp(cpu_buffer->buffer,
 							 cpu_buffer->cpu, ts);
 		}
+		if (lost_events)
+			*lost_events = rb_lost_events(cpu_buffer);
 		return event;
 
 	default:
@@ -3168,12 +3216,14 @@ static inline int rb_ok_to_lock(void)
  * @buffer: The ring buffer to read
  * @cpu: The cpu to peak at
  * @ts: The timestamp counter of this event.
+ * @lost_events: a variable to store if events were lost (may be NULL)
  *
  * This will return the event that will be read next, but does
  * not consume the data.
  */
 struct ring_buffer_event *
-ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
+ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts,
+		 unsigned long *lost_events)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	struct ring_buffer_event *event;
@@ -3188,7 +3238,7 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	local_irq_save(flags);
 	if (dolock)
 		spin_lock(&cpu_buffer->reader_lock);
-	event = rb_buffer_peek(cpu_buffer, ts);
+	event = rb_buffer_peek(cpu_buffer, ts, lost_events);
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		rb_advance_reader(cpu_buffer);
 	if (dolock)
@@ -3230,13 +3280,17 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 /**
  * ring_buffer_consume - return an event and consume it
  * @buffer: The ring buffer to get the next event from
+ * @cpu: the cpu to read the buffer from
+ * @ts: a variable to store the timestamp (may be NULL)
+ * @lost_events: a variable to store if events were lost (may be NULL)
  *
  * Returns the next event in the ring buffer, and that event is consumed.
  * Meaning, that sequential reads will keep returning a different event,
  * and eventually empty the ring buffer if the producer is slower.
  */
 struct ring_buffer_event *
-ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
+ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts,
+		    unsigned long *lost_events)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event = NULL;
@@ -3257,9 +3311,11 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 	if (dolock)
 		spin_lock(&cpu_buffer->reader_lock);
 
-	event = rb_buffer_peek(cpu_buffer, ts);
-	if (event)
+	event = rb_buffer_peek(cpu_buffer, ts, lost_events);
+	if (event) {
+		cpu_buffer->lost_events = 0;
 		rb_advance_reader(cpu_buffer);
+	}
 
 	if (dolock)
 		spin_unlock(&cpu_buffer->reader_lock);
@@ -3408,6 +3464,9 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->write_stamp = 0;
 	cpu_buffer->read_stamp = 0;
 
+	cpu_buffer->lost_events = 0;
+	cpu_buffer->last_overrun = 0;
+
 	rb_head_page_activate(cpu_buffer);
 }
 
@@ -3683,6 +3742,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	struct ring_buffer_event *event;
 	struct buffer_data_page *bpage;
 	struct buffer_page *reader;
+	unsigned long missed_events;
 	unsigned long flags;
 	unsigned int commit;
 	unsigned int read;
@@ -3719,6 +3779,9 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	read = reader->read;
 	commit = rb_page_commit(reader);
 
+	/* Check if any events were dropped */
+	missed_events = cpu_buffer->lost_events;
+
 	/*
 	 * If this page has been partially read or
 	 * if len is not big enough to read the rest of the page or
@@ -3779,9 +3842,35 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		local_set(&reader->entries, 0);
 		reader->read = 0;
 		*data_page = bpage;
+
+		/*
+		 * Use the real_end for the data size,
+		 * This gives us a chance to store the lost events
+		 * on the page.
+		 */
+		if (reader->real_end)
+			local_set(&bpage->commit, reader->real_end);
 	}
 	ret = read;
 
+	cpu_buffer->lost_events = 0;
+	/*
+	 * Set a flag in the commit field if we lost events
+	 */
+	if (missed_events) {
+		commit = local_read(&bpage->commit);
+
+		/* If there is room at the end of the page to save the
+		 * missed events, then record it there.
+		 */
+		if (BUF_PAGE_SIZE - commit >= sizeof(missed_events)) {
+			memcpy(&bpage->data[commit], &missed_events,
+			       sizeof(missed_events));
+			local_add(RB_MISSED_STORED, &bpage->commit);
+		}
+		local_add(RB_MISSED_EVENTS, &bpage->commit);
+	}
+
  out_unlock:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index df74c79..dc56556 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -81,7 +81,7 @@ static enum event_status read_event(int cpu)
 	int *entry;
 	u64 ts;
 
-	event = ring_buffer_consume(buffer, cpu, &ts);
+	event = ring_buffer_consume(buffer, cpu, &ts, NULL);
 	if (!event)
 		return EVENT_DROPPED;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 44f916a..60f3b62 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1545,7 +1545,8 @@ static void trace_iterator_increment(struct trace_iterator *iter)
 }
 
 static struct trace_entry *
-peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts)
+peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts,
+		unsigned long *lost_events)
 {
 	struct ring_buffer_event *event;
 	struct ring_buffer_iter *buf_iter = iter->buffer_iter[cpu];
@@ -1556,7 +1557,8 @@ peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts)
 	if (buf_iter)
 		event = ring_buffer_iter_peek(buf_iter, ts);
 	else
-		event = ring_buffer_peek(iter->tr->buffer, cpu, ts);
+		event = ring_buffer_peek(iter->tr->buffer, cpu, ts,
+					 lost_events);
 
 	ftrace_enable_cpu();
 
@@ -1564,10 +1566,12 @@ peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts)
 }
 
 static struct trace_entry *
-__find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
+__find_next_entry(struct trace_iterator *iter, int *ent_cpu,
+		  unsigned long *missing_events, u64 *ent_ts)
 {
 	struct ring_buffer *buffer = iter->tr->buffer;
 	struct trace_entry *ent, *next = NULL;
+	unsigned long lost_events, next_lost = 0;
 	int cpu_file = iter->cpu_file;
 	u64 next_ts = 0, ts;
 	int next_cpu = -1;
@@ -1580,7 +1584,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 	if (cpu_file > TRACE_PIPE_ALL_CPU) {
 		if (ring_buffer_empty_cpu(buffer, cpu_file))
 			return NULL;
-		ent = peek_next_entry(iter, cpu_file, ent_ts);
+		ent = peek_next_entry(iter, cpu_file, ent_ts, missing_events);
 		if (ent_cpu)
 			*ent_cpu = cpu_file;
 
@@ -1592,7 +1596,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 		if (ring_buffer_empty_cpu(buffer, cpu))
 			continue;
 
-		ent = peek_next_entry(iter, cpu, &ts);
+		ent = peek_next_entry(iter, cpu, &ts, &lost_events);
 
 		/*
 		 * Pick the entry with the smallest timestamp:
@@ -1601,6 +1605,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 			next = ent;
 			next_cpu = cpu;
 			next_ts = ts;
+			next_lost = lost_events;
 		}
 	}
 
@@ -1610,6 +1615,9 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 	if (ent_ts)
 		*ent_ts = next_ts;
 
+	if (missing_events)
+		*missing_events = next_lost;
+
 	return next;
 }
 
@@ -1617,13 +1625,14 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
 					  int *ent_cpu, u64 *ent_ts)
 {
-	return __find_next_entry(iter, ent_cpu, ent_ts);
+	return __find_next_entry(iter, ent_cpu, NULL, ent_ts);
 }
 
 /* Find the next real entry, and increment the iterator to the next entry */
 static void *find_next_entry_inc(struct trace_iterator *iter)
 {
-	iter->ent = __find_next_entry(iter, &iter->cpu, &iter->ts);
+	iter->ent = __find_next_entry(iter, &iter->cpu,
+				      &iter->lost_events, &iter->ts);
 
 	if (iter->ent)
 		trace_iterator_increment(iter);
@@ -1635,7 +1644,8 @@ static void trace_consume(struct trace_iterator *iter)
 {
 	/* Don't allow ftrace to trace into the ring buffers */
 	ftrace_disable_cpu();
-	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts);
+	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts,
+			    &iter->lost_events);
 	ftrace_enable_cpu();
 }
 
@@ -2030,6 +2040,10 @@ static enum print_line_t print_trace_line(struct trace_iterator *iter)
 {
 	enum print_line_t ret;
 
+	if (iter->lost_events)
+		trace_seq_printf(&iter->seq, "CPU:%d [LOST %lu EVENTS]\n",
+				 iter->cpu, iter->lost_events);
+
 	if (iter->trace && iter->trace->print_line) {
 		ret = iter->trace->print_line(iter);
 		if (ret != TRACE_TYPE_UNHANDLED)
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 9aed1a5..669b9c3 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -490,9 +490,10 @@ get_return_for_leaf(struct trace_iterator *iter,
 			 * We need to consume the current entry to see
 			 * the next one.
 			 */
-			ring_buffer_consume(iter->tr->buffer, iter->cpu, NULL);
+			ring_buffer_consume(iter->tr->buffer, iter->cpu,
+					    NULL, NULL);
 			event = ring_buffer_peek(iter->tr->buffer, iter->cpu,
-						 NULL);
+						 NULL, NULL);
 		}
 
 		if (!event)
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 81003b4..9398034 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -30,7 +30,7 @@ static int trace_test_buffer_cpu(struct trace_array *tr, int cpu)
 	struct trace_entry *entry;
 	unsigned int loops = 0;
 
-	while ((event = ring_buffer_consume(tr->buffer, cpu, NULL))) {
+	while ((event = ring_buffer_consume(tr->buffer, cpu, NULL, NULL))) {
 		entry = ring_buffer_event_data(event);
 
 		/*
