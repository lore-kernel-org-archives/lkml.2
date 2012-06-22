Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358Ab2FVPrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:47:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39505 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab2FVPrN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:47:13 -0400
Message-ID: <1340380019.18025.82.camel@twins>
Subject: Re: [PATCH -v2 1/2] x86, microcode: Sanitize per-cpu microcode
 reloading interface
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: X86-ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Stephane Eranian <eranian@google.com>
Date: Fri, 22 Jun 2012 17:46:59 +0200
In-Reply-To: <1340280437-7718-2-git-send-email-bp@amd64.org>
References: <1340280437-7718-1-git-send-email-bp@amd64.org>
	 <1340280437-7718-2-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What about something like so on top of those two microcode_core patches?

Since we don't have to worry about per-cpu loads, we can do a single
callback after the entire machine is updated.

---
 arch/x86/include/asm/perf_event.h      |    2 +
 arch/x86/kernel/cpu/perf_event.c       |   21 +++++++++-----
 arch/x86/kernel/cpu/perf_event.h       |    4 ++
 arch/x86/kernel/cpu/perf_event_intel.c |   49 ++++++++++++++++++++++++++++++---
 arch/x86/kernel/microcode_core.c       |   10 ++++--
 5 files changed, 72 insertions(+), 14 deletions(-)

--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -232,6 +232,7 @@ struct perf_guest_switch_msr {
 
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
 extern void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap);
+extern void perf_check_microcode(void);
 #else
 static inline perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 {
@@ -245,6 +246,7 @@ static inline void perf_get_x86_pmu_capa
 }
 
 static inline void perf_events_lapic_init(void)	{ }
+static inline void perf_check_microcode(void) { }
 #endif
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -378,7 +378,7 @@ int x86_pmu_hw_config(struct perf_event
 		int precise = 0;
 
 		/* Support for constant skid */
-		if (x86_pmu.pebs_active) {
+		if (x86_pmu.pebs_active && !x86_pmu.pebs_broken) {
 			precise++;
 
 			/* Support for IP fixup */
@@ -1649,13 +1649,20 @@ static void x86_pmu_flush_branch_stack(v
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
@@ -1663,11 +1670,11 @@ static struct pmu pmu = {
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
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1714,11 +1714,54 @@ static __init void intel_clovertown_quir
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
+	for_each_online_cpu(cpu)
+		pebs_broken |= intel_snb_pebs_broken(cpu);
+	put_online_cpus();
+
+	if (pebs_broken == x86_pmu.pebs_broken)
+		return;
+
+	/*
+	 * Serialized by the microcode lock..
+	 */
+	if (x86_pmu.pebs_broken) {
+		pr_info("PEBS enabled due to micro-code update\n");
+		x86_pmu.pebs_broken = 0;
+	} else {
+		pr_info("PEBS disabled due to CPU errata, please upgrade micro-code\n");
+		x86_pmu.pebs_broken = 1;
+	}
+}
+
 static __init void intel_sandybridge_quirk(void)
 {
-	pr_warn("PEBS disabled due to CPU errata\n");
-	x86_pmu.pebs = 0;
-	x86_pmu.pebs_constraints = NULL;
+	x86_pmu.check_microcode = intel_snb_check_microcode;
+	intel_snb_check_microcode();
 }
 
 static const struct { int id; char *name; } intel_arch_events_map[] __initconst = {
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
@@ -309,6 +308,7 @@ static ssize_t reload_store(struct devic
 		return size;
 
 	get_online_cpus();
+	mutex_lock(&microcode_mutex);
 	for_each_online_cpu(cpu) {
 		tmp_ret = reload_for_cpu(cpu);
 		if (tmp_ret != 0)
@@ -318,6 +318,9 @@ static ssize_t reload_store(struct devic
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
 

