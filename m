Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab0LPMdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 07:33:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:36397 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab0LPMdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:33:14 -0500
Date: Thu, 16 Dec 2010 12:32:54 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101117222056.259707703@chello.nl>
References: <20101117222056.259707703@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Dynamic pmu types
Message-ID: <tip-2e80a82a49c4c7eca4e35734380f28298ba5db19@git.kernel.org>
Git-Commit-ID: 2e80a82a49c4c7eca4e35734380f28298ba5db19
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 12:32:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e80a82a49c4c7eca4e35734380f28298ba5db19
Gitweb:     http://git.kernel.org/tip/2e80a82a49c4c7eca4e35734380f28298ba5db19
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 17 Nov 2010 23:17:36 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 16 Dec 2010 11:36:43 +0100

perf: Dynamic pmu types

Extend the perf_pmu_register() interface to allow for named and
dynamic pmu types.

Because we need to support the existing static types we cannot use
dynamic types for everything, hence provide a type argument.

If we want to enumerate the PMUs they need a name, provide one.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101117222056.259707703@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/alpha/kernel/perf_event.c           |    2 +-
 arch/arm/kernel/perf_event.c             |    2 +-
 arch/powerpc/kernel/perf_event.c         |    2 +-
 arch/powerpc/kernel/perf_event_fsl_emb.c |    2 +-
 arch/sh/kernel/perf_event.c              |    2 +-
 arch/sparc/kernel/perf_event.c           |    2 +-
 arch/x86/kernel/cpu/perf_event.c         |    2 +-
 include/linux/perf_event.h               |    5 ++-
 kernel/hw_breakpoint.c                   |    2 +-
 kernel/perf_event.c                      |   48 ++++++++++++++++++++++++++----
 10 files changed, 54 insertions(+), 15 deletions(-)

diff --git a/arch/alpha/kernel/perf_event.c b/arch/alpha/kernel/perf_event.c
index 3283059..90561c4 100644
--- a/arch/alpha/kernel/perf_event.c
+++ b/arch/alpha/kernel/perf_event.c
@@ -882,7 +882,7 @@ int __init init_hw_perf_events(void)
 	/* And set up PMU specification */
 	alpha_pmu = &ev67_pmu;
 
-	perf_pmu_register(&pmu);
+	perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
 
 	return 0;
 }
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index d45f70e..fdfa497 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -3034,7 +3034,7 @@ init_hw_perf_events(void)
 		pr_info("no hardware support available\n");
 	}
 
-	perf_pmu_register(&pmu);
+	perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
 
 	return 0;
 }
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 3129c85..5674807 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1379,7 +1379,7 @@ int register_power_pmu(struct power_pmu *pmu)
 		freeze_events_kernel = MMCR0_FCHV;
 #endif /* CONFIG_PPC64 */
 
-	perf_pmu_register(&power_pmu);
+	perf_pmu_register(&power_pmu, "cpu", PERF_TYPE_RAW);
 	perf_cpu_notifier(power_pmu_notifier);
 
 	return 0;
diff --git a/arch/powerpc/kernel/perf_event_fsl_emb.c b/arch/powerpc/kernel/perf_event_fsl_emb.c
index 7ecca59..4dcf5f8 100644
--- a/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ b/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -681,7 +681,7 @@ int register_fsl_emb_pmu(struct fsl_emb_pmu *pmu)
 	pr_info("%s performance monitor hardware support registered\n",
 		pmu->name);
 
-	perf_pmu_register(&fsl_emb_pmu);
+	perf_pmu_register(&fsl_emb_pmu, "cpu", PERF_TYPE_RAW);
 
 	return 0;
 }
diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 5a4b334..2ee21a4 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -389,7 +389,7 @@ int __cpuinit register_sh_pmu(struct sh_pmu *_pmu)
 
 	WARN_ON(_pmu->num_events > MAX_HWEVENTS);
 
-	perf_pmu_register(&pmu);
+	perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
 	perf_cpu_notifier(sh_pmu_notifier);
 	return 0;
 }
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 39348b1..7605786 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1318,7 +1318,7 @@ int __init init_hw_perf_events(void)
 
 	pr_cont("Supported PMU type is '%s'\n", sparc_pmu_type);
 
-	perf_pmu_register(&pmu);
+	perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
 	register_die_notifier(&perf_event_nmi_notifier);
 
 	return 0;
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ce27c54..0a360d1 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1465,7 +1465,7 @@ int __init init_hw_perf_events(void)
 	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_counters_fixed);
 	pr_info("... event mask:             %016Lx\n", x86_pmu.intel_ctrl);
 
-	perf_pmu_register(&pmu);
+	perf_pmu_register(&pmu, "cpu", PERF_TYPE_RAW);
 	perf_cpu_notifier(x86_pmu_notifier);
 
 	return 0;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 30e50e2..21206d2 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -588,6 +588,9 @@ struct perf_event;
 struct pmu {
 	struct list_head		entry;
 
+	char				*name;
+	int				type;
+
 	int * __percpu			pmu_disable_count;
 	struct perf_cpu_context * __percpu pmu_cpu_context;
 	int				task_ctx_nr;
@@ -916,7 +919,7 @@ struct perf_output_handle {
 
 #ifdef CONFIG_PERF_EVENTS
 
-extern int perf_pmu_register(struct pmu *pmu);
+extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
 extern void perf_pmu_unregister(struct pmu *pmu);
 
 extern int perf_num_counters(void);
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index e532582..086adf2 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -641,7 +641,7 @@ int __init init_hw_breakpoint(void)
 
 	constraints_initialized = 1;
 
-	perf_pmu_register(&perf_breakpoint);
+	perf_pmu_register(&perf_breakpoint, "breakpoint", PERF_TYPE_BREAKPOINT);
 
 	return register_die_notifier(&hw_breakpoint_exceptions_nb);
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a3d568f..8f09bc8 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -13,6 +13,7 @@
 #include <linux/mm.h>
 #include <linux/cpu.h>
 #include <linux/smp.h>
+#include <linux/idr.h>
 #include <linux/file.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
@@ -4961,7 +4962,7 @@ static struct pmu perf_tracepoint = {
 
 static inline void perf_tp_register(void)
 {
-	perf_pmu_register(&perf_tracepoint);
+	perf_pmu_register(&perf_tracepoint, "tracepoint", PERF_TYPE_TRACEPOINT);
 }
 
 static int perf_event_set_filter(struct perf_event *event, void __user *arg)
@@ -5305,8 +5306,9 @@ static void free_pmu_context(struct pmu *pmu)
 out:
 	mutex_unlock(&pmus_lock);
 }
+static struct idr pmu_idr;
 
-int perf_pmu_register(struct pmu *pmu)
+int perf_pmu_register(struct pmu *pmu, char *name, int type)
 {
 	int cpu, ret;
 
@@ -5316,13 +5318,32 @@ int perf_pmu_register(struct pmu *pmu)
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
@@ -5366,6 +5387,10 @@ unlock:
 
 	return ret;
 
+free_idr:
+	if (pmu->type >= PERF_TYPE_MAX)
+		idr_remove(&pmu_idr, pmu->type);
+
 free_pdc:
 	free_percpu(pmu->pmu_disable_count);
 	goto unlock;
@@ -5385,6 +5410,8 @@ void perf_pmu_unregister(struct pmu *pmu)
 	synchronize_rcu();
 
 	free_percpu(pmu->pmu_disable_count);
+	if (pmu->type >= PERF_TYPE_MAX)
+		idr_remove(&pmu_idr, pmu->type);
 	free_pmu_context(pmu);
 }
 
@@ -5394,6 +5421,13 @@ struct pmu *perf_init_event(struct perf_event *event)
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
@@ -6555,11 +6589,13 @@ void __init perf_event_init(void)
 {
 	int ret;
 
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
 	perf_tp_register();
 	perf_cpu_notifier(perf_cpu_notify);
 	register_reboot_notifier(&perf_reboot_notifier);
