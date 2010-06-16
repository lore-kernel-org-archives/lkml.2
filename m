Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236Ab0FPQGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:06:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:33967 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759194Ab0FPQGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:06:38 -0400
Message-Id: <20100616160238.241599593@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 16 Jun 2010 18:00:30 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 3/8] perf: register pmu implementations
References: <20100616160027.590430763@chello.nl>
Content-Disposition: inline; filename=perf-register-pmu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple registration interface for struct pmu, this provides the
infrastructure for removing all the weak functions.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/arm/kernel/perf_event.c             |   36 +
 arch/powerpc/kernel/perf_event.c         |   41 +-
 arch/powerpc/kernel/perf_event_fsl_emb.c |   31 -
 arch/sh/kernel/perf_event.c              |   19 
 arch/sparc/kernel/perf_event.c           |   13 
 arch/x86/kernel/cpu/perf_event.c         |   45 +-
 include/linux/perf_event.h               |   10 
 kernel/hw_breakpoint.c                   |   35 +
 kernel/perf_event.c                      |  597 +++++++++++++++----------------
 9 files changed, 432 insertions(+), 395 deletions(-)

Index: linux-2.6/arch/arm/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/perf_event.c
+++ linux-2.6/arch/arm/kernel/perf_event.c
@@ -306,13 +306,6 @@ out:
 	return err;
 }
 
-static struct pmu pmu = {
-	.enable	    = armpmu_enable,
-	.disable    = armpmu_disable,
-	.unthrottle = armpmu_unthrottle,
-	.read	    = armpmu_read,
-};
-
 static int
 validate_event(struct cpu_hw_events *cpuc,
 	       struct perf_event *event)
@@ -491,13 +484,22 @@ __hw_perf_event_init(struct perf_event *
 	return err;
 }
 
-struct pmu *
-hw_perf_event_init(struct perf_event *event)
+static int armpmu_event_init(struct perf_event *event)
 {
 	int err = 0;
 
+	switch (event->attr.type) {
+	case PERF_TYPE_RAW:
+	case PERF_TYPE_HARDWARE:
+	case PERF_TYPE_HW_CACHE:
+		break;
+
+	default:
+		return -ENOENT;
+	}
+
 	if (!armpmu)
-		return ERR_PTR(-ENODEV);
+		return -ENODEV;
 
 	event->destroy = hw_perf_event_destroy;
 
@@ -518,15 +520,23 @@ hw_perf_event_init(struct perf_event *ev
 	}
 
 	if (err)
-		return ERR_PTR(err);
+		return err;
 
 	err = __hw_perf_event_init(event);
 	if (err)
 		hw_perf_event_destroy(event);
 
-	return err ? ERR_PTR(err) : &pmu;
+	return err;
 }
 
+static struct pmu pmu = {
+	.event_init = armpmu_event_init,
+	.enable	    = armpmu_enable,
+	.disable    = armpmu_disable,
+	.unthrottle = armpmu_unthrottle,
+	.read	    = armpmu_read,
+};
+
 void
 hw_perf_enable(void)
 {
@@ -2994,6 +3004,8 @@ init_hw_perf_events(void)
 		perf_max_events = -1;
 	}
 
+	perf_pmu_register(&pmu)
+
 	return 0;
 }
 arch_initcall(init_hw_perf_events);
Index: linux-2.6/arch/powerpc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event.c
+++ linux-2.6/arch/powerpc/kernel/perf_event.c
@@ -901,16 +901,6 @@ int power_pmu_commit_txn(struct pmu *pmu
 	return 0;
 }
 
-struct pmu power_pmu = {
-	.enable		= power_pmu_enable,
-	.disable	= power_pmu_disable,
-	.read		= power_pmu_read,
-	.unthrottle	= power_pmu_unthrottle,
-	.start_txn	= power_pmu_start_txn,
-	.cancel_txn	= power_pmu_cancel_txn,
-	.commit_txn	= power_pmu_commit_txn,
-};
-
 /*
  * Return 1 if we might be able to put event on a limited PMC,
  * or 0 if not.
@@ -1011,7 +1001,7 @@ static int hw_perf_cache_event(u64 confi
 	return 0;
 }
 
-struct pmu *hw_perf_event_init(struct perf_event *event)
+static int power_pmu_event_init(struct perf_event *event)
 {
 	u64 ev;
 	unsigned long flags;
@@ -1023,7 +1013,8 @@ struct pmu *hw_perf_event_init(struct pe
 	struct cpu_hw_events *cpuhw;
 
 	if (!ppmu)
-		return ERR_PTR(-ENXIO);
+		return -ENOENT;
+
 	switch (event->attr.type) {
 	case PERF_TYPE_HARDWARE:
 		ev = event->attr.config;
@@ -1040,8 +1031,9 @@ struct pmu *hw_perf_event_init(struct pe
 		ev = event->attr.config;
 		break;
 	default:
-		return ERR_PTR(-EINVAL);
+		return -ENOENT;
 	}
+
 	event->hw.config_base = ev;
 	event->hw.idx = 0;
 
@@ -1078,7 +1070,7 @@ struct pmu *hw_perf_event_init(struct pe
 			 */
 			ev = normal_pmc_alternative(ev, flags);
 			if (!ev)
-				return ERR_PTR(-EINVAL);
+				return -EINVAL;
 		}
 	}
 
@@ -1092,19 +1084,19 @@ struct pmu *hw_perf_event_init(struct pe
 		n = collect_events(event->group_leader, ppmu->n_counter - 1,
 				   ctrs, events, cflags);
 		if (n < 0)
-			return ERR_PTR(-EINVAL);
+			return -EINVAL;
 	}
 	events[n] = ev;
 	ctrs[n] = event;
 	cflags[n] = flags;
 	if (check_excludes(ctrs, cflags, n, 1))
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	cpuhw = &get_cpu_var(cpu_hw_events);
 	err = power_check_constraints(cpuhw, events, cflags, n + 1);
 	put_cpu_var(cpu_hw_events);
 	if (err)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	event->hw.config = events[n];
 	event->hw.event_base = cflags[n];
@@ -1129,11 +1121,19 @@ struct pmu *hw_perf_event_init(struct pe
 	}
 	event->destroy = hw_perf_event_destroy;
 
-	if (err)
-		return ERR_PTR(err);
-	return &power_pmu;
+	return err;
 }
 
+struct pmu power_pmu = {
+	.enable		= power_pmu_enable,
+	.disable	= power_pmu_disable,
+	.read		= power_pmu_read,
+	.unthrottle	= power_pmu_unthrottle,
+	.start_txn	= power_pmu_start_txn,
+	.cancel_txn	= power_pmu_cancel_txn,
+	.commit_txn	= power_pmu_commit_txn,
+};
+
 /*
  * A counter has overflowed; update its count and record
  * things if requested.  Note that interrupts are hard-disabled
@@ -1339,6 +1339,7 @@ int register_power_pmu(struct power_pmu 
 		freeze_events_kernel = MMCR0_FCHV;
 #endif /* CONFIG_PPC64 */
 
+	perf_pmu_register(&power_pmu);
 	perf_cpu_notifier(power_pmu_notifier);
 
 	return 0;
Index: linux-2.6/arch/powerpc/kernel/perf_event_fsl_emb.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ linux-2.6/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -378,13 +378,6 @@ static void fsl_emb_pmu_unthrottle(struc
 	local_irq_restore(flags);
 }
 
-static struct pmu fsl_emb_pmu = {
-	.enable		= fsl_emb_pmu_enable,
-	.disable	= fsl_emb_pmu_disable,
-	.read		= fsl_emb_pmu_read,
-	.unthrottle	= fsl_emb_pmu_unthrottle,
-};
-
 /*
  * Release the PMU if this is the last perf_event.
  */
@@ -428,7 +421,7 @@ static int hw_perf_cache_event(u64 confi
 	return 0;
 }
 
-struct pmu *hw_perf_event_init(struct perf_event *event)
+static int fsl_emb_pmu_event_init(struct perf_event *event)
 {
 	u64 ev;
 	struct perf_event *events[MAX_HWEVENTS];
@@ -456,12 +449,12 @@ struct pmu *hw_perf_event_init(struct pe
 		break;
 
 	default:
-		return ERR_PTR(-EINVAL);
+		return -ENOENT;
 	}
 
 	event->hw.config = ppmu->xlate_event(ev);
 	if (!(event->hw.config & FSL_EMB_EVENT_VALID))
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	/*
 	 * If this is in a group, check if it can go on with all the
@@ -473,7 +466,7 @@ struct pmu *hw_perf_event_init(struct pe
 		n = collect_events(event->group_leader,
 		                   ppmu->n_counter - 1, events);
 		if (n < 0)
-			return ERR_PTR(-EINVAL);
+			return -EINVAL;
 	}
 
 	if (event->hw.config & FSL_EMB_EVENT_RESTRICTED) {
@@ -484,7 +477,7 @@ struct pmu *hw_perf_event_init(struct pe
 		}
 
 		if (num_restricted >= ppmu->n_restricted)
-			return ERR_PTR(-EINVAL);
+			return -EINVAL;
 	}
 
 	event->hw.idx = -1;
@@ -523,11 +516,17 @@ struct pmu *hw_perf_event_init(struct pe
 	}
 	event->destroy = hw_perf_event_destroy;
 
-	if (err)
-		return ERR_PTR(err);
-	return &fsl_emb_pmu;
+	return err;
 }
 
+static struct pmu fsl_emb_pmu = {
+	.event_init	= fsl_emb_pmu_event_init,
+	.enable		= fsl_emb_pmu_enable,
+	.disable	= fsl_emb_pmu_disable,
+	.read		= fsl_emb_pmu_read,
+	.unthrottle	= fsl_emb_pmu_unthrottle,
+};
+
 /*
  * A counter has overflowed; update its count and record
  * things if requested.  Note that interrupts are hard-disabled
@@ -650,5 +649,7 @@ int register_fsl_emb_pmu(struct fsl_emb_
 	pr_info("%s performance monitor hardware support registered\n",
 		pmu->name);
 
+	perf_pmu_register(&fsl_emb_pmu);
+
 	return 0;
 }
Index: linux-2.6/arch/sh/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/perf_event.c
+++ linux-2.6/arch/sh/kernel/perf_event.c
@@ -257,24 +257,24 @@ static void sh_pmu_read(struct perf_even
 	sh_perf_event_update(event, &event->hw, event->hw.idx);
 }
 
-static struct pmu pmu = {
-	.enable		= sh_pmu_enable,
-	.disable	= sh_pmu_disable,
-	.read		= sh_pmu_read,
-};
-
-struct pmu *hw_perf_event_init(struct perf_event *event)
+static in sh_pmu_event_init(struct perf_event *event)
 {
 	int err = __hw_perf_event_init(event);
 	if (unlikely(err)) {
 		if (event->destroy)
 			event->destroy(event);
-		return ERR_PTR(err);
 	}
 
-	return &pmu;
+	return err;
 }
 
+static struct pmu pmu = {
+	.event_init	= sh_pmu_event_init,
+	.enable		= sh_pmu_enable,
+	.disable	= sh_pmu_disable,
+	.read		= sh_pmu_read,
+};
+
 static void sh_pmu_setup(int cpu)
 {
 	struct cpu_hw_events *cpuhw = &per_cpu(cpu_hw_events, cpu);
@@ -325,6 +325,7 @@ int __cpuinit register_sh_pmu(struct sh_
 
 	WARN_ON(pmu->num_events > MAX_HWEVENTS);
 
+	perf_pmu_register(&pmu);
 	perf_cpu_notifier(sh_pmu_notifier);
 	return 0;
 }
Index: linux-2.6/arch/sparc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/perf_event.c
+++ linux-2.6/arch/sparc/kernel/perf_event.c
@@ -1024,7 +1024,7 @@ out:
 	return ret;
 }
 
-static int __hw_perf_event_init(struct perf_event *event)
+static int sparc_pmu_event_init(struct perf_event *event)
 {
 	struct perf_event_attr *attr = &event->attr;
 	struct perf_event *evts[MAX_HWEVENTS];
@@ -1142,6 +1142,7 @@ static int sparc_pmu_commit_txn(struct p
 }
 
 static struct pmu pmu = {
+	.event_init	= sparc_pmu_event_init,
 	.enable		= sparc_pmu_enable,
 	.disable	= sparc_pmu_disable,
 	.read		= sparc_pmu_read,
@@ -1151,15 +1152,6 @@ static struct pmu pmu = {
 	.commit_txn	= sparc_pmu_commit_txn,
 };
 
-struct pmu *hw_perf_event_init(struct perf_event *event)
-{
-	int err = __hw_perf_event_init(event);
-
-	if (err)
-		return ERR_PTR(err);
-	return &pmu;
-}
-
 void perf_event_print_debug(void)
 {
 	unsigned long flags;
@@ -1279,6 +1271,7 @@ void __init init_hw_perf_events(void)
 	/* All sparc64 PMUs currently have 2 events.  */
 	perf_max_events = 2;
 
+	perf_pmu_register(&pmu);
 	register_die_notifier(&perf_event_nmi_notifier);
 }
 
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -530,7 +530,7 @@ static int x86_pmu_hw_config(struct perf
 /*
  * Setup the hardware configuration for a given attr_type
  */
-static int __hw_perf_event_init(struct perf_event *event)
+static int __x86_pmu_event_init(struct perf_event *event)
 {
 	int err;
 
@@ -1381,6 +1381,7 @@ void __init init_hw_perf_events(void)
 	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_counters_fixed);
 	pr_info("... event mask:             %016Lx\n", x86_pmu.intel_ctrl);
 
+	perf_pmu_register(&pmu);
 	perf_cpu_notifier(x86_pmu_notifier);
 }
 
@@ -1450,18 +1451,6 @@ static int x86_pmu_commit_txn(struct pmu
 	return 0;
 }
 
-static struct pmu pmu = {
-	.enable		= x86_pmu_enable,
-	.disable	= x86_pmu_disable,
-	.start		= x86_pmu_start,
-	.stop		= x86_pmu_stop,
-	.read		= x86_pmu_read,
-	.unthrottle	= x86_pmu_unthrottle,
-	.start_txn	= x86_pmu_start_txn,
-	.cancel_txn	= x86_pmu_cancel_txn,
-	.commit_txn	= x86_pmu_commit_txn,
-};
-
 /*
  * validate that we can schedule this event
  */
@@ -1536,12 +1525,22 @@ out:
 	return ret;
 }
 
-struct pmu *hw_perf_event_init(struct perf_event *event)
+int x86_pmu_event_init(struct perf_event *event)
 {
 	struct pmu *tmp;
 	int err;
 
-	err = __hw_perf_event_init(event);
+	switch (event->attr.type) {
+	case PERF_TYPE_RAW:
+	case PERF_TYPE_HARDWARE:
+	case PERF_TYPE_HW_CACHE:
+		break;
+
+	default:
+		return -ENOENT;
+	}
+
+	err = __x86_pmu_event_init(event);
 	if (!err) {
 		/*
 		 * we temporarily connect event to its pmu
@@ -1561,12 +1560,24 @@ struct pmu *hw_perf_event_init(struct pe
 	if (err) {
 		if (event->destroy)
 			event->destroy(event);
-		return ERR_PTR(err);
 	}
 
-	return &pmu;
+	return err;
 }
 
+static struct pmu pmu = {
+	.event_init	= x86_pmu_event_init
+	.enable		= x86_pmu_enable,
+	.disable	= x86_pmu_disable,
+	.start		= x86_pmu_start,
+	.stop		= x86_pmu_stop,
+	.read		= x86_pmu_read,
+	.unthrottle	= x86_pmu_unthrottle,
+	.start_txn	= x86_pmu_start_txn,
+	.cancel_txn	= x86_pmu_cancel_txn,
+	.commit_txn	= x86_pmu_commit_txn,
+};
+
 /*
  * callchain support
  */
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -559,6 +559,13 @@ struct perf_event;
  * struct pmu - generic performance monitoring unit
  */
 struct pmu {
+	struct list_head		entry;
+
+	/*
+	 * Should return -ENOENT when the @event doesn't match this pmu
+	 */
+	int (*event_init)		(struct perf_event *event);
+
 	int (*enable)			(struct perf_event *event);
 	void (*disable)			(struct perf_event *event);
 	int (*start)			(struct perf_event *event);
@@ -845,7 +852,8 @@ struct perf_output_handle {
  */
 extern int perf_max_events;
 
-extern struct pmu *hw_perf_event_init(struct perf_event *event);
+extern int perf_pmu_register(struct pmu *pmu);
+extern void perf_pmu_unregister(struct pmu *pmu);
 
 extern void perf_event_task_sched_in(struct task_struct *task);
 extern void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
Index: linux-2.6/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6.orig/kernel/hw_breakpoint.c
+++ linux-2.6/kernel/hw_breakpoint.c
@@ -549,6 +549,34 @@ static struct notifier_block hw_breakpoi
 	.priority = 0x7fffffff
 };
 
+static void bp_perf_event_destroy(struct perf_event *event)
+{
+	release_bp_slot(event);
+}
+
+static struct pmu *bp_perf_event_init(struct perf_event *bp)
+{
+	int err;
+
+	if (event->attr.type != PERF_TYPE_BREAKPOINT)
+		return -ENOENT;
+
+	err = register_perf_hw_breakpoint(bp);
+	if (err)
+		return err;
+
+	bp->destroy = bp_perf_event_destroy;
+
+	return 0;
+}
+
+static struct pmu perf_breakpoint = {
+	.event_init	= hw_breakpoint_event_init,
+	.enable		= arch_install_hw_breakpoint,
+	.disable	= arch_uninstall_hw_breakpoint,
+	.read		= hw_breakpoint_pmu_read,
+};
+
 static int __init init_hw_breakpoint(void)
 {
 	unsigned int **task_bp_pinned;
@@ -570,6 +598,8 @@ static int __init init_hw_breakpoint(voi
 
 	constraints_initialized = 1;
 
+	perf_pmu_register(&perf_breakpoint);
+
 	return register_die_notifier(&hw_breakpoint_exceptions_nb);
 
  err_alloc:
@@ -585,8 +615,3 @@ static int __init init_hw_breakpoint(voi
 core_initcall(init_hw_breakpoint);
 
 
-struct pmu perf_ops_bp = {
-	.enable		= arch_install_hw_breakpoint,
-	.disable	= arch_uninstall_hw_breakpoint,
-	.read		= hw_breakpoint_pmu_read,
-};
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -31,7 +31,6 @@
 #include <linux/kernel_stat.h>
 #include <linux/perf_event.h>
 #include <linux/ftrace_event.h>
-#include <linux/hw_breakpoint.h>
 
 #include <asm/irq_regs.h>
 
@@ -72,14 +71,6 @@ static atomic64_t perf_event_id;
  */
 static DEFINE_SPINLOCK(perf_resource_lock);
 
-/*
- * Architecture provided APIs - weak aliases:
- */
-extern __weak struct pmu *hw_perf_event_init(struct perf_event *event)
-{
-	return NULL;
-}
-
 void __weak hw_perf_disable(void)		{ barrier(); }
 void __weak hw_perf_enable(void)		{ barrier(); }
 
@@ -4286,187 +4277,6 @@ static void perf_swevent_void(struct per
 {
 }
 
-static int perf_swevent_int(struct perf_event *event)
-{
-	return 0;
-}
-
-static struct pmu perf_ops_generic = {
-	.enable		= perf_swevent_enable,
-	.disable	= perf_swevent_disable,
-	.start		= perf_swevent_int,
-	.stop		= perf_swevent_void,
-	.read		= perf_swevent_read,
-	.unthrottle	= perf_swevent_void, /* hwc->interrupts already reset */
-};
-
-/*
- * hrtimer based swevent callback
- */
-
-static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
-{
-	enum hrtimer_restart ret = HRTIMER_RESTART;
-	struct perf_sample_data data;
-	struct pt_regs *regs;
-	struct perf_event *event;
-	u64 period;
-
-	event = container_of(hrtimer, struct perf_event, hw.hrtimer);
-	event->pmu->read(event);
-
-	perf_sample_data_init(&data, 0);
-	data.period = event->hw.last_period;
-	regs = get_irq_regs();
-
-	if (regs && !perf_exclude_event(event, regs)) {
-		if (!(event->attr.exclude_idle && current->pid == 0))
-			if (perf_event_overflow(event, 0, &data, regs))
-				ret = HRTIMER_NORESTART;
-	}
-
-	period = max_t(u64, 10000, event->hw.sample_period);
-	hrtimer_forward_now(hrtimer, ns_to_ktime(period));
-
-	return ret;
-}
-
-static void perf_swevent_start_hrtimer(struct perf_event *event)
-{
-	struct hw_perf_event *hwc = &event->hw;
-
-	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	hwc->hrtimer.function = perf_swevent_hrtimer;
-	if (hwc->sample_period) {
-		u64 period;
-
-		if (hwc->remaining) {
-			if (hwc->remaining < 0)
-				period = 10000;
-			else
-				period = hwc->remaining;
-			hwc->remaining = 0;
-		} else {
-			period = max_t(u64, 10000, hwc->sample_period);
-		}
-		__hrtimer_start_range_ns(&hwc->hrtimer,
-				ns_to_ktime(period), 0,
-				HRTIMER_MODE_REL, 0);
-	}
-}
-
-static void perf_swevent_cancel_hrtimer(struct perf_event *event)
-{
-	struct hw_perf_event *hwc = &event->hw;
-
-	if (hwc->sample_period) {
-		ktime_t remaining = hrtimer_get_remaining(&hwc->hrtimer);
-		hwc->remaining = ktime_to_ns(remaining);
-
-		hrtimer_cancel(&hwc->hrtimer);
-	}
-}
-
-/*
- * Software event: cpu wall time clock
- */
-
-static void cpu_clock_perf_event_update(struct perf_event *event)
-{
-	int cpu = raw_smp_processor_id();
-	s64 prev;
-	u64 now;
-
-	now = cpu_clock(cpu);
-	prev = local64_xchg(&event->hw.prev_count, now);
-	local64_add(now - prev, &event->count);
-}
-
-static int cpu_clock_perf_event_enable(struct perf_event *event)
-{
-	struct hw_perf_event *hwc = &event->hw;
-	int cpu = raw_smp_processor_id();
-
-	local64_set(&hwc->prev_count, cpu_clock(cpu));
-	perf_swevent_start_hrtimer(event);
-
-	return 0;
-}
-
-static void cpu_clock_perf_event_disable(struct perf_event *event)
-{
-	perf_swevent_cancel_hrtimer(event);
-	cpu_clock_perf_event_update(event);
-}
-
-static void cpu_clock_perf_event_read(struct perf_event *event)
-{
-	cpu_clock_perf_event_update(event);
-}
-
-static struct pmu perf_ops_cpu_clock = {
-	.enable		= cpu_clock_perf_event_enable,
-	.disable	= cpu_clock_perf_event_disable,
-	.read		= cpu_clock_perf_event_read,
-};
-
-/*
- * Software event: task time clock
- */
-
-static void task_clock_perf_event_update(struct perf_event *event, u64 now)
-{
-	u64 prev;
-	s64 delta;
-
-	prev = local64_xchg(&event->hw.prev_count, now);
-	delta = now - prev;
-	local64_add(delta, &event->count);
-}
-
-static int task_clock_perf_event_enable(struct perf_event *event)
-{
-	struct hw_perf_event *hwc = &event->hw;
-	u64 now;
-
-	now = event->ctx->time;
-
-	local64_set(&hwc->prev_count, now);
-
-	perf_swevent_start_hrtimer(event);
-
-	return 0;
-}
-
-static void task_clock_perf_event_disable(struct perf_event *event)
-{
-	perf_swevent_cancel_hrtimer(event);
-	task_clock_perf_event_update(event, event->ctx->time);
-
-}
-
-static void task_clock_perf_event_read(struct perf_event *event)
-{
-	u64 time;
-
-	if (!in_nmi()) {
-		update_context_time(event->ctx);
-		time = event->ctx->time;
-	} else {
-		u64 now = perf_clock();
-		u64 delta = now - event->ctx->timestamp;
-		time = event->ctx->time + delta;
-	}
-
-	task_clock_perf_event_update(event, time);
-}
-
-static struct pmu perf_ops_task_clock = {
-	.enable		= task_clock_perf_event_enable,
-	.disable	= task_clock_perf_event_disable,
-	.read		= task_clock_perf_event_read,
-};
-
 /* Deref the hlist from the update side */
 static inline struct swevent_hlist *
 swevent_hlist_deref(struct perf_cpu_context *cpuctx)
@@ -4573,17 +4383,61 @@ static int swevent_hlist_get(struct perf
 	return err;
 }
 
-#ifdef CONFIG_EVENT_TRACING
+atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
-static struct pmu perf_ops_tracepoint = {
-	.enable		= perf_trace_enable,
-	.disable	= perf_trace_disable,
+static void sw_perf_event_destroy(struct perf_event *event)
+{
+	u64 event_id = event->attr.config;
+
+	WARN_ON(event->parent);
+
+	atomic_dec(&perf_swevent_enabled[event_id]);
+	swevent_hlist_put(event);
+}
+
+static int perf_swevent_int(struct perf_event *event)
+{
+	if (event->attr.type != PERF_TYPE_SOFTWARE)
+		return -ENOENT;
+
+	switch (event->attr.config) {
+	case PERF_COUNT_SW_CPU_CLOCK:
+	case PERF_COUNT_SW_TASK_CLOCK:
+		return -ENOENT;
+
+	default:
+		break;
+	}
+
+	if (event->attr.config > PERF_COUNT_SW_MAX)
+		return -ENOENT;
+
+	if (!event->parent) {
+		int err;
+
+		err = swevent_hlist_get(event);
+		if (err)
+			return ERR_PTR(err);
+
+		atomic_inc(&perf_swevent_enabled[event_id]);
+		event->destroy = sw_perf_event_destroy;
+	}
+
+	return 0;
+}
+
+static struct pmu perf_swevent = {
+	.event_init	= perf_swevent_init,
+	.enable		= perf_swevent_enable,
+	.disable	= perf_swevent_disable,
 	.start		= perf_swevent_int,
 	.stop		= perf_swevent_void,
 	.read		= perf_swevent_read,
-	.unthrottle	= perf_swevent_void,
+	.unthrottle	= perf_swevent_void, /* hwc->interrupts already reset */
 };
 
+#ifdef CONFIG_EVENT_TRACING
+
 static int perf_tp_filter_match(struct perf_event *event,
 				struct perf_sample_data *data)
 {
@@ -4639,10 +4493,13 @@ static void tp_perf_event_destroy(struct
 	perf_trace_destroy(event);
 }
 
-static struct pmu *tp_perf_event_init(struct perf_event *event)
+static int perf_tp_event_init(struct perf_event *event)
 {
 	int err;
 
+	if (event->attr.type != PERF_TYPE_TRACEPOINT)
+		return -ENOENT;
+
 	/*
 	 * Raw tracepoint data is a severe data leak, only allow root to
 	 * have these.
@@ -4650,15 +4507,30 @@ static struct pmu *tp_perf_event_init(st
 	if ((event->attr.sample_type & PERF_SAMPLE_RAW) &&
 			perf_paranoid_tracepoint_raw() &&
 			!capable(CAP_SYS_ADMIN))
-		return ERR_PTR(-EPERM);
+		return -EPERM;
 
 	err = perf_trace_init(event);
 	if (err)
-		return NULL;
+		return err;
 
 	event->destroy = tp_perf_event_destroy;
 
-	return &perf_ops_tracepoint;
+	return 0
+}
+
+static struct pmu perf_tracepoint = {
+	.event_init	= perf_tp_event_init,
+	.enable		= perf_trace_enable,
+	.disable	= perf_trace_disable,
+	.start		= perf_swevent_int,
+	.stop		= perf_swevent_void,
+	.read		= perf_swevent_read,
+	.unthrottle	= perf_swevent_void,
+};
+
+static inline void perf_tp_register(void)
+{
+	perf_pmu_register(&perf_tracepoint);
 }
 
 static int perf_event_set_filter(struct perf_event *event, void __user *arg)
@@ -4686,9 +4558,8 @@ static void perf_event_free_filter(struc
 
 #else
 
-static struct pmu *tp_perf_event_init(struct perf_event *event)
+static inline void perf_tp_register(void)
 {
-	return NULL;
 }
 
 static int perf_event_set_filter(struct perf_event *event, void __user *arg)
@@ -4703,105 +4574,247 @@ static void perf_event_free_filter(struc
 #endif /* CONFIG_EVENT_TRACING */
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-static void bp_perf_event_destroy(struct perf_event *event)
+void perf_bp_event(struct perf_event *bp, void *data)
 {
-	release_bp_slot(event);
+	struct perf_sample_data sample;
+	struct pt_regs *regs = data;
+
+	perf_sample_data_init(&sample, bp->attr.bp_addr);
+
+	if (!perf_exclude_event(bp, regs))
+		perf_swevent_add(bp, 1, 1, &sample, regs);
 }
+#endif
 
-static struct pmu *bp_perf_event_init(struct perf_event *bp)
+/*
+ * hrtimer based swevent callback
+ */
+
+static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 {
-	int err;
+	enum hrtimer_restart ret = HRTIMER_RESTART;
+	struct perf_sample_data data;
+	struct pt_regs *regs;
+	struct perf_event *event;
+	u64 period;
 
-	err = register_perf_hw_breakpoint(bp);
-	if (err)
-		return ERR_PTR(err);
+	event = container_of(hrtimer, struct perf_event, hw.hrtimer);
+	event->pmu->read(event);
+
+	perf_sample_data_init(&data, 0);
+	data.period = event->hw.last_period;
+	regs = get_irq_regs();
 
-	bp->destroy = bp_perf_event_destroy;
+	if (regs && !perf_exclude_event(event, regs)) {
+		if (!(event->attr.exclude_idle && current->pid == 0))
+			if (perf_event_overflow(event, 0, &data, regs))
+				ret = HRTIMER_NORESTART;
+	}
 
-	return &perf_ops_bp;
+	period = max_t(u64, 10000, event->hw.sample_period);
+	hrtimer_forward_now(hrtimer, ns_to_ktime(period));
+
+	return ret;
 }
 
-void perf_bp_event(struct perf_event *bp, void *data)
+static void perf_swevent_start_hrtimer(struct perf_event *event)
 {
-	struct perf_sample_data sample;
-	struct pt_regs *regs = data;
+	struct hw_perf_event *hwc = &event->hw;
 
-	perf_sample_data_init(&sample, bp->attr.bp_addr);
+	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hwc->hrtimer.function = perf_swevent_hrtimer;
+	if (hwc->sample_period) {
+		u64 period;
 
-	if (!perf_exclude_event(bp, regs))
-		perf_swevent_add(bp, 1, 1, &sample, regs);
+		if (hwc->remaining) {
+			if (hwc->remaining < 0)
+				period = 10000;
+			else
+				period = hwc->remaining;
+			hwc->remaining = 0;
+		} else {
+			period = max_t(u64, 10000, hwc->sample_period);
+		}
+		__hrtimer_start_range_ns(&hwc->hrtimer,
+				ns_to_ktime(period), 0,
+				HRTIMER_MODE_REL, 0);
+	}
 }
-#else
-static struct pmu *bp_perf_event_init(struct perf_event *bp)
+
+static void perf_swevent_cancel_hrtimer(struct perf_event *event)
 {
-	return NULL;
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (hwc->sample_period) {
+		ktime_t remaining = hrtimer_get_remaining(&hwc->hrtimer);
+		hwc->remaining = ktime_to_ns(remaining);
+
+		hrtimer_cancel(&hwc->hrtimer);
+	}
 }
 
-void perf_bp_event(struct perf_event *bp, void *regs)
+/*
+ * Software event: cpu wall time clock
+ */
+
+static void cpu_clock_event_update(struct perf_event *event)
 {
+	int cpu = raw_smp_processor_id();
+	s64 prev;
+	u64 now;
+
+	now = cpu_clock(cpu);
+	prev = local64_xchg(&event->hw.prev_count, now);
+	local64_add(now - prev, &event->count);
 }
-#endif
 
-atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
+static int cpu_clock_event_enable(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	int cpu = raw_smp_processor_id();
 
-static void sw_perf_event_destroy(struct perf_event *event)
+	local64_set(&hwc->prev_count, cpu_clock(cpu));
+	perf_swevent_start_hrtimer(event);
+
+	return 0;
+}
+
+static void cpu_clock_event_disable(struct perf_event *event)
 {
-	u64 event_id = event->attr.config;
+	perf_swevent_cancel_hrtimer(event);
+	cpu_clock_event_update(event);
+}
 
-	WARN_ON(event->parent);
+static void cpu_clock_event_read(struct perf_event *event)
+{
+	cpu_clock_event_update(event);
+}
 
-	atomic_dec(&perf_swevent_enabled[event_id]);
-	swevent_hlist_put(event);
+static int cpu_clock_event_init(struct perf_event *event)
+{
+	if (event->attr.type != PERF_TYPE_SOFTWARE)
+		return -ENOENT;
+
+	if (event->attr.config != PERF_COUNT_SW_CPU_CLOCK)
+		return -ENOENT;
+
+	return 0;
 }
 
-static struct pmu *sw_perf_event_init(struct perf_event *event)
+static struct pmu perf_cpu_clock = {
+	.event_init	= cpu_clock_event_init,
+	.enable		= cpu_clock_event_enable,
+	.disable	= cpu_clock_event_disable,
+	.read		= cpu_clock_event_read,
+};
+
+/*
+ * Software event: task time clock
+ */
+
+static void task_clock_event_update(struct perf_event *event, u64 now)
 {
-	struct pmu *pmu = NULL;
-	u64 event_id = event->attr.config;
+	u64 prev;
+	s64 delta;
 
-	/*
-	 * Software events (currently) can't in general distinguish
-	 * between user, kernel and hypervisor events.
-	 * However, context switches and cpu migrations are considered
-	 * to be kernel events, and page faults are never hypervisor
-	 * events.
-	 */
-	switch (event_id) {
-	case PERF_COUNT_SW_CPU_CLOCK:
-		pmu = &perf_ops_cpu_clock;
+	prev = local64_xchg(&event->hw.prev_count, now);
+	delta = now - prev;
+	local64_add(delta, &event->count);
+}
 
-		break;
-	case PERF_COUNT_SW_TASK_CLOCK:
-		/*
-		 * If the user instantiates this as a per-cpu event,
-		 * use the cpu_clock event instead.
-		 */
-		if (event->ctx->task)
-			pmu = &perf_ops_task_clock;
-		else
-			pmu = &perf_ops_cpu_clock;
+static int task_clock_event_enable(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	u64 now;
 
-		break;
-	case PERF_COUNT_SW_PAGE_FAULTS:
-	case PERF_COUNT_SW_PAGE_FAULTS_MIN:
-	case PERF_COUNT_SW_PAGE_FAULTS_MAJ:
-	case PERF_COUNT_SW_CONTEXT_SWITCHES:
-	case PERF_COUNT_SW_CPU_MIGRATIONS:
-	case PERF_COUNT_SW_ALIGNMENT_FAULTS:
-	case PERF_COUNT_SW_EMULATION_FAULTS:
-		if (!event->parent) {
-			int err;
-
-			err = swevent_hlist_get(event);
-			if (err)
-				return ERR_PTR(err);
+	now = event->ctx->time;
+
+	local64_set(&hwc->prev_count, now);
 
-			atomic_inc(&perf_swevent_enabled[event_id]);
-			event->destroy = sw_perf_event_destroy;
+	perf_swevent_start_hrtimer(event);
+
+	return 0;
+}
+
+static void task_clock_event_disable(struct perf_event *event)
+{
+	perf_swevent_cancel_hrtimer(event);
+	task_clock_event_update(event, event->ctx->time);
+
+}
+
+static void task_clock_event_read(struct perf_event *event)
+{
+	u64 time;
+
+	if (!in_nmi()) {
+		update_context_time(event->ctx);
+		time = event->ctx->time;
+	} else {
+		u64 now = perf_clock();
+		u64 delta = now - event->ctx->timestamp;
+		time = event->ctx->time + delta;
+	}
+
+	task_clock_event_update(event, time);
+}
+
+static int task_clock_event_init(struct perf_event *event)
+{
+	if (event->attr.type != PERF_TYPE_SOFTWARE)
+		return -ENOENT;
+
+	if (event->attr.config != PERF_COUNT_SW_TASK_CLOCK)
+		return -ENOENT;
+
+	return 0;
+}
+
+static struct pmu perf_ops_clock = {
+	.event_init	= task_clock_event_init,
+	.enable		= task_clock_event_enable,
+	.disable	= task_clock_event_disable,
+	.read		= task_clock_event_read,
+};
+
+static struct list_head pmus;
+static DEFINE_SPINLOCK(pmus_lock);
+static struct srcu_struct pmus_srcu;
+
+int perf_pmu_register(struct pmu *pmu)
+{
+	spin_lock(&pmus_lock);
+	list_add_rcu(&pmu->entry, &pmus);
+	spin_unlock(&pmus_lock);
+
+	return 0;
+}
+
+void perf_pmu_unregister(struct pmu *pmu)
+{
+	spin_lock(&pmus_lock);
+	list_del_rcu(&pmu->entry);
+	spin_unlock(&pmus_lock);
+
+	synchronize_srcu(&pmus_srcu);
+}
+
+struct pmu *perf_init_event(struct perf_event *event)
+{
+	struct pmu *pmu;
+	int idx;
+
+	idx = srcu_read_lock(&pmus_srcu);
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		int ret = pmu->event_init(event);
+		if (!ret)
+			break;
+		if (ret != -ENOENT) {
+			pmu = ERR_PTR(ret);
+			break;
 		}
-		pmu = &perf_ops_generic;
-		break;
 	}
+	srcu_read_unlock(&pmus_srcu, idx);
 
 	return pmu;
 }
@@ -4882,29 +4895,8 @@ perf_event_alloc(struct perf_event_attr 
 	if (attr->inherit && (attr->read_format & PERF_FORMAT_GROUP))
 		goto done;
 
-	switch (attr->type) {
-	case PERF_TYPE_RAW:
-	case PERF_TYPE_HARDWARE:
-	case PERF_TYPE_HW_CACHE:
-		pmu = hw_perf_event_init(event);
-		break;
-
-	case PERF_TYPE_SOFTWARE:
-		pmu = sw_perf_event_init(event);
-		break;
-
-	case PERF_TYPE_TRACEPOINT:
-		pmu = tp_perf_event_init(event);
-		break;
+	pmu = perf_init_event(event);
 
-	case PERF_TYPE_BREAKPOINT:
-		pmu = bp_perf_event_init(event);
-		break;
-
-
-	default:
-		break;
-	}
 done:
 	err = 0;
 	if (!pmu)
@@ -5743,15 +5735,15 @@ perf_cpu_notify(struct notifier_block *s
 {
 	unsigned int cpu = (long)hcpu;
 
-	switch (action) {
+	switch (action & ~CPU_TASK_FROZEN) {
 
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
+	case CPU_DOWN_FAILED:
 		perf_event_init_cpu(cpu);
 		break;
 
+	case CPU_UP_CANCELED:
 	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
 		perf_event_exit_cpu(cpu);
 		break;
 
@@ -5762,22 +5754,15 @@ perf_cpu_notify(struct notifier_block *s
 	return NOTIFY_OK;
 }
 
-/*
- * This has to have a higher priority than migration_notifier in sched.c.
- */
-static struct notifier_block __cpuinitdata perf_cpu_nb = {
-	.notifier_call		= perf_cpu_notify,
-	.priority		= 20,
-};
-
 void __init perf_event_init(void)
 {
 	perf_event_init_all_cpus();
-	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_UP_PREPARE,
-			(void *)(long)smp_processor_id());
-	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_ONLINE,
-			(void *)(long)smp_processor_id());
-	register_cpu_notifier(&perf_cpu_nb);
+	init_srcu_struct(&pmus_srcu);
+	perf_pmu_register(&perf_swevent);
+	perf_pmu_register(&perf_cpu_clock);
+	perf_pmu_register(&perf_task_clock);
+	perf_tp_register();
+	perf_cpu_notifier(perf_cpu_notify);
 }
 
 static ssize_t perf_show_reserve_percpu(struct sysdev_class *class,


