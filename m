Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab2GFG26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:28:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49097 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721Ab2GFG24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:28:56 -0400
Date: Thu, 5 Jul 2012 23:28:40 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-v3672ziwh9damwqwh1uz3krm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, borislav.petkov@amd.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Add a microcode revision check for SNB-PEBS
Git-Commit-ID: c93dc84cbe32435be3ffa2fbde355eff94955c32
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 05 Jul 2012 23:28:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c93dc84cbe32435be3ffa2fbde355eff94955c32
Gitweb:     http://git.kernel.org/tip/c93dc84cbe32435be3ffa2fbde355eff94955c32
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 8 Jun 2012 14:50:50 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jul 2012 21:55:57 +0200

perf/x86: Add a microcode revision check for SNB-PEBS

Recent Intel microcode resolved the SNB-PEBS issues, so conditionally
enable PEBS on SNB hardware depending on the microcode revision.

Thanks to Stephane for figuring out the various microcode revisions.

Suggested-by: Stephane Eranian <eranian@google.com>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-v3672ziwh9damwqwh1uz3krm@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/perf_event.h      |    2 +
 arch/x86/kernel/cpu/perf_event.c       |   21 +++++++++----
 arch/x86/kernel/cpu/perf_event.h       |    4 ++-
 arch/x86/kernel/cpu/perf_event_intel.c |   51 ++++++++++++++++++++++++++++++--
 arch/x86/kernel/microcode_core.c       |   10 ++++--
 5 files changed, 74 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index ffdf5e0..c78f14a 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -232,6 +232,7 @@ struct perf_guest_switch_msr {
 
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
 extern void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap);
+extern void perf_check_microcode(void);
 #else
 static inline perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 {
@@ -245,6 +246,7 @@ static inline void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 }
 
 static inline void perf_events_lapic_init(void)	{ }
+static inline void perf_check_microcode(void) { }
 #endif
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3eb88eb..29557aa 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -379,7 +379,7 @@ int x86_pmu_hw_config(struct perf_event *event)
 		int precise = 0;
 
 		/* Support for constant skid */
-		if (x86_pmu.pebs_active) {
+		if (x86_pmu.pebs_active && !x86_pmu.pebs_broken) {
 			precise++;
 
 			/* Support for IP fixup */
@@ -1650,13 +1650,20 @@ static void x86_pmu_flush_branch_stack(void)
 		x86_pmu.flush_branch_stack();
 }
 
+void perf_check_microcode(void)
+{
+	if (x86_pmu.check_microcode)
+		x86_pmu.check_microcode();
+}
+EXPORT_SYMBOL_GPL(perf_check_microcode);
+
 static struct pmu pmu = {
 	.pmu_enable		= x86_pmu_enable,
 	.pmu_disable		= x86_pmu_disable,
 
-	.attr_groups	= x86_pmu_attr_groups,
+	.attr_groups		= x86_pmu_attr_groups,
 
-	.event_init	= x86_pmu_event_init,
+	.event_init		= x86_pmu_event_init,
 
 	.add			= x86_pmu_add,
 	.del			= x86_pmu_del,
@@ -1664,11 +1671,11 @@ static struct pmu pmu = {
 	.stop			= x86_pmu_stop,
 	.read			= x86_pmu_read,
 
-	.start_txn	= x86_pmu_start_txn,
-	.cancel_txn	= x86_pmu_cancel_txn,
-	.commit_txn	= x86_pmu_commit_txn,
+	.start_txn		= x86_pmu_start_txn,
+	.cancel_txn		= x86_pmu_cancel_txn,
+	.commit_txn		= x86_pmu_commit_txn,
 
-	.event_idx	= x86_pmu_event_idx,
+	.event_idx		= x86_pmu_event_idx,
 	.flush_branch_stack	= x86_pmu_flush_branch_stack,
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 83238f2..3f5c669 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -361,6 +361,8 @@ struct x86_pmu {
 	void		(*cpu_starting)(int cpu);
 	void		(*cpu_dying)(int cpu);
 	void		(*cpu_dead)(int cpu);
+
+	void		(*check_microcode)(void);
 	void		(*flush_branch_stack)(void);
 
 	/*
@@ -373,7 +375,7 @@ struct x86_pmu {
 	 * Intel DebugStore bits
 	 */
 	int		bts, pebs;
-	int		bts_active, pebs_active;
+	int		bts_active, pebs_active, pebs_broken;
 	int		pebs_record_size;
 	void		(*drain_pebs)(struct pt_regs *regs);
 	struct event_constraint *pebs_constraints;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 2e9444c..5fdedb4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1712,11 +1712,56 @@ static __init void intel_clovertown_quirk(void)
 	x86_pmu.pebs_constraints = NULL;
 }
 
+static int intel_snb_pebs_broken(int cpu)
+{
+	u32 rev = UINT_MAX; /* default to broken for unknown models */
+
+	switch (cpu_data(cpu).x86_model) {
+	case 42: /* SNB */
+		rev = 0x28;
+		break;
+
+	case 45: /* SNB-EP */
+		switch (cpu_data(cpu).x86_mask) {
+		case 6: rev = 0x618; break;
+		case 7: rev = 0x70c; break;
+		}
+	}
+
+	return (cpu_data(cpu).microcode < rev);
+}
+
+static void intel_snb_check_microcode(void)
+{
+	int pebs_broken = 0;
+	int cpu;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		if ((pebs_broken = intel_snb_pebs_broken(cpu)))
+			break;
+	}
+	put_online_cpus();
+
+	if (pebs_broken == x86_pmu.pebs_broken)
+		return;
+
+	/*
+	 * Serialized by the microcode lock..
+	 */
+	if (x86_pmu.pebs_broken) {
+		pr_info("PEBS enabled due to microcode update\n");
+		x86_pmu.pebs_broken = 0;
+	} else {
+		pr_info("PEBS disabled due to CPU errata, please upgrade microcode\n");
+		x86_pmu.pebs_broken = 1;
+	}
+}
+
 static __init void intel_sandybridge_quirk(void)
 {
-	printk(KERN_WARNING "PEBS disabled due to CPU errata.\n");
-	x86_pmu.pebs = 0;
-	x86_pmu.pebs_constraints = NULL;
+	x86_pmu.check_microcode = intel_snb_check_microcode;
+	intel_snb_check_microcode();
 }
 
 static const struct { int id; char *name; } intel_arch_events_map[] __initconst = {
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 947e4c6..1649cf8 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -87,6 +87,7 @@
 #include <asm/microcode.h>
 #include <asm/processor.h>
 #include <asm/cpu_device_id.h>
+#include <asm/perf_event.h>
 
 MODULE_DESCRIPTION("Microcode Update Driver");
 MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
@@ -277,7 +278,6 @@ static int reload_for_cpu(int cpu)
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	int err = 0;
 
-	mutex_lock(&microcode_mutex);
 	if (uci->valid) {
 		enum ucode_state ustate;
 
@@ -288,7 +288,6 @@ static int reload_for_cpu(int cpu)
 			if (ustate == UCODE_ERROR)
 				err = -EINVAL;
 	}
-	mutex_unlock(&microcode_mutex);
 
 	return err;
 }
@@ -309,6 +308,7 @@ static ssize_t reload_store(struct device *dev,
 		return size;
 
 	get_online_cpus();
+	mutex_lock(&microcode_mutex);
 	for_each_online_cpu(cpu) {
 		tmp_ret = reload_for_cpu(cpu);
 		if (tmp_ret != 0)
@@ -318,6 +318,9 @@ static ssize_t reload_store(struct device *dev,
 		if (!ret)
 			ret = tmp_ret;
 	}
+	if (!ret)
+		perf_check_microcode();
+	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
 
 	if (!ret)
@@ -557,7 +560,8 @@ static int __init microcode_init(void)
 	mutex_lock(&microcode_mutex);
 
 	error = subsys_interface_register(&mc_cpu_interface);
-
+	if (!error)
+		perf_check_microcode();
 	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
 
