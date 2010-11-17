Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935553Ab0KQWXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:23:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:55817 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935456Ab0KQWXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:23:07 -0500
Message-Id: <20101117222056.259707703@chello.nl>
User-Agent: quilt/0.47-1
Date: Wed, 17 Nov 2010 23:17:36 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Kyle Moffett <kyle@moffetthome.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 6/8] perf: Dynamic pmu types
References: <20101117221730.002627458@chello.nl>
Content-Disposition: inline; filename=perf-dynamic-id-register.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the perf_pmu_register() interface to allow for named and
dynamic pmu types.

Because we need to support the existing static types we cannot use
dynamic types for everything, hence provide a type argument.

If we want to enumerate the PMUs they need a name, provide one.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/alpha/kernel/perf_event.c           |    2 -
 arch/arm/kernel/perf_event.c             |    2 -
 arch/powerpc/kernel/perf_event.c         |    2 -
 arch/powerpc/kernel/perf_event_fsl_emb.c |    2 -
 arch/sh/kernel/perf_event.c              |    2 -
 arch/sparc/kernel/perf_event.c           |    2 -
 arch/x86/kernel/cpu/perf_event.c         |    2 -
 include/linux/perf_event.h               |    5 ++-
 kernel/hw_breakpoint.c                   |    2 -
 kernel/perf_event.c                      |   49 +++++++++++++++++++++++++++----
 10 files changed, 55 insertions(+), 15 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -578,6 +578,9 @@ struct perf_event;
 struct pmu {
 	struct list_head		entry;
 
+	char				*name;
+	int				type;
+
 	int * __percpu			pmu_disable_count;
 	struct perf_cpu_context * __percpu pmu_cpu_context;
 	int				task_ctx_nr;
@@ -901,7 +904,7 @@ struct perf_output_handle {
 
 #ifdef CONFIG_PERF_EVENTS
 
-extern int perf_pmu_register(struct pmu *pmu);
+extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
 extern void perf_pmu_unregister(struct pmu *pmu);
 
 extern int perf_num_counters(void);
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -13,6 +13,7 @@
 #include <linux/mm.h>
 #include <linux/cpu.h>
 #include <linux/smp.h>
+#include <linux/idr.h>
 #include <linux/file.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
@@ -4804,7 +4805,7 @@ static struct pmu perf_tracepoint = {
 
 static __init int perf_tp_init(void)
 {
-	perf_pmu_register(&perf_tracepoint);
+	perf_pmu_register(&perf_tracepoint, "tracepoint", PERF_TYPE_TRACEPOINT);
 	return 0;
 }
 early_initcall(perf_tp_init);
@@ -5111,6 +5112,8 @@ static void *find_pmu_context(int ctxn)
 	return NULL;
 }
 
+static struct idr pmu_idr;
+
 static void free_pmu_context(void * __percpu cpu_context)
 {
 	struct pmu *pmu;
@@ -5129,7 +5132,7 @@ static void free_pmu_context(void * __pe
 	mutex_unlock(&pmus_lock);
 }
 
-int perf_pmu_register(struct pmu *pmu)
+int perf_pmu_register(struct pmu *pmu, char *name, int type)
 {
 	int cpu, ret;
 
@@ -5139,13 +5142,32 @@ int perf_pmu_register(struct pmu *pmu)
 	if (!pmu->pmu_disable_count)
 		goto unlock;
 
+	pmu->type = -1;
+	if (!name)
+		goto skip_type;
+	pmu->name = name;
+
+	if (type < 0) {
+		int err = idr_pre_get(&pmu_idr, GFP_KERNEL);
+		if (!err)
+			goto free_pdc;
+
+		err = idr_get_new_above(&pmu_idr, pmu, PERF_TYPE_MAX, &type);
+		if (err) {
+			ret = err;
+			goto free_pdc;
+		}
+	}
+	pmu->type = type;
+
+skip_type:
 	pmu->pmu_cpu_context = find_pmu_context(pmu->task_ctx_nr);
 	if (pmu->pmu_cpu_context)
 		goto got_cpu_context;
 
 	pmu->pmu_cpu_context = alloc_percpu(struct perf_cpu_context);
 	if (!pmu->pmu_cpu_context)
-		goto free_pdc;
+		goto free_ird;
 
 	for_each_possible_cpu(cpu) {
 		struct perf_cpu_context *cpuctx;
@@ -5188,6 +5210,10 @@ int perf_pmu_register(struct pmu *pmu)
 
 	return ret;
 
+free_idr:
+	if (pmu->type >= PERF_TYPE_MAX)
+		idr_remove(&pmu_idr, pmu->type);
+
 free_pdc:
 	free_percpu(pmu->pmu_disable_count);
 	goto unlock;
@@ -5207,6 +5233,8 @@ void perf_pmu_unregister(struct pmu *pmu
 	synchronize_rcu();
 
 	free_percpu(pmu->pmu_disable_count);
+	if (pmu->type >= PERF_TYPE_MAX)
+		idr_remove(&pmu_idr, pmu->type);
 	free_pmu_context(pmu->pmu_cpu_context);
 }
 
@@ -5216,6 +5244,13 @@ struct pmu *perf_init_event(struct perf_
 	int idx;
 
 	idx = srcu_read_lock(&pmus_srcu);
+
+	rcu_read_lock();
+	pmu = idr_find(&pmu_idr, event->attr.type);
+	rcu_read_unlock();
+	if (pmu)
+		goto unlock;
+
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		int ret = pmu->event_init(event);
 		if (!ret)
@@ -6319,10 +6354,12 @@ perf_cpu_notify(struct notifier_block *s
 
 void __init perf_event_init(void)
 {
+	idr_init(&pmu_idr);
+
 	perf_event_init_all_cpus();
 	init_srcu_struct(&pmus_srcu);
-	perf_pmu_register(&perf_swevent);
-	perf_pmu_register(&perf_cpu_clock);
-	perf_pmu_register(&perf_task_clock);
+	perf_pmu_register(&perf_swevent, "software", PERF_TYPE_SOFTWARE);
+	perf_pmu_register(&perf_cpu_clock, NULL, -1);
+	perf_pmu_register(&perf_task_clock, NULL, -1);
 	perf_cpu_notifier(perf_cpu_notify);
 }
Index: linux-2.6/arch/alpha/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/perf_event.c
+++ linux-2.6/arch/alpha/kernel/perf_event.c
@@ -882,7 +882,7 @@ int __init init_hw_perf_events(void)
 	/* And set up PMU specification */
 	alpha_pmu = &ev67_pmu;
 
-	perf_pmu_register(&pmu);
+	perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
 
 	return 0;
 }
Index: linux-2.6/arch/arm/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/perf_event.c
+++ linux-2.6/arch/arm/kernel/perf_event.c
@@ -3034,7 +3034,7 @@ init_hw_perf_events(void)
 		pr_info("no hardware support available\n");
 	}
 
-	perf_pmu_register(&pmu);
+	perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
 
 	return 0;
 }
Index: linux-2.6/arch/powerpc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event.c
+++ linux-2.6/arch/powerpc/kernel/perf_event.c
@@ -1379,7 +1379,7 @@ int register_power_pmu(struct power_pmu 
 		freeze_events_kernel = MMCR0_FCHV;
 #endif /* CONFIG_PPC64 */
 
-	perf_pmu_register(&power_pmu);
+	perf_pmu_register(&power_pmu, "cpu", PERF_TYPE_RAW);
 	perf_cpu_notifier(power_pmu_notifier);
 
 	return 0;
Index: linux-2.6/arch/powerpc/kernel/perf_event_fsl_emb.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ linux-2.6/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -681,7 +681,7 @@ int register_fsl_emb_pmu(struct fsl_emb_
 	pr_info("%s performance monitor hardware support registered\n",
 		pmu->name);
 
-	perf_pmu_register(&fsl_emb_pmu);
+	perf_pmu_register(&fsl_emb_pmu, "cpu", PERF_TYPE_RAW);
 
 	return 0;
 }
Index: linux-2.6/arch/sh/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/perf_event.c
+++ linux-2.6/arch/sh/kernel/perf_event.c
@@ -389,7 +389,7 @@ int __cpuinit register_sh_pmu(struct sh_
 
 	WARN_ON(_pmu->num_events > MAX_HWEVENTS);
 
-	perf_pmu_register(&pmu);
+	perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
 	perf_cpu_notifier(sh_pmu_notifier);
 	return 0;
 }
Index: linux-2.6/arch/sparc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/perf_event.c
+++ linux-2.6/arch/sparc/kernel/perf_event.c
@@ -1318,7 +1318,7 @@ int __init init_hw_perf_events(void)
 
 	pr_cont("Supported PMU type is '%s'\n", sparc_pmu_type);
 
-	perf_pmu_register(&pmu);
+	perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
 	register_die_notifier(&perf_event_nmi_notifier);
 
 	return 0;
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -1418,7 +1418,7 @@ int __init init_hw_perf_events(void)
 	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_counters_fixed);
 	pr_info("... event mask:             %016Lx\n", x86_pmu.intel_ctrl);
 
-	perf_pmu_register(&pmu);
+	perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
 	perf_cpu_notifier(x86_pmu_notifier);
 
 	return 0;
Index: linux-2.6/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6.orig/kernel/hw_breakpoint.c
+++ linux-2.6/kernel/hw_breakpoint.c
@@ -641,7 +641,7 @@ static int __init init_hw_breakpoint(voi
 
 	constraints_initialized = 1;
 
-	perf_pmu_register(&perf_breakpoint);
+	perf_pmu_register(&perf_breakpoint, "breakpoint", PERF_TYPE_BREAKPOINT);
 
 	return register_die_notifier(&hw_breakpoint_exceptions_nb);
 


