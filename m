Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab0KBN62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 09:58:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:35705 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab0KBN6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 09:58:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,281,1286175600"; 
   d="scan'208";a="853362287"
Subject: Re: [DRAFT PATCH 0/3] perf: Add Intel Nehalem uncore pmu support
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "paulus@samba.org" <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        CoreyAshford <cjashfor@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1288700970.2039.26.camel@laptop>
References: <1288682858.12061.105.camel@minggr.sh.intel.com>
	 <1288700970.2039.26.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 21:58:23 +0800
Message-Id: <1288706303.2457.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-02 at 20:29 +0800, Peter Zijlstra wrote:
> On Tue, 2010-11-02 at 15:27 +0800, Lin Ming wrote:
> > Any comment is very appreciated.
> 
> Right, so I was hoping to use the sysfs bits to expose things, I'll try
> and get around to looking at your latest effort in that area soonish.
> I'll try and sit down with gregkh one of these days to talk it over.
> 
> I'm not too sure about 1/3's change to x86_perf_event_update(), but its
> not too aweful, the change to x86_perf_event_set_period() however does
> look quite gruesome.
> 
> It might make sense to simple duplicate that code in the uncore bits,.
> dunno.

How about below?

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index fafa0f9..b22aa95 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -80,10 +80,52 @@ static int uncore_pmu_event_init(struct perf_event *event)
 	return 0;
 }
 
+static int
+uncore_perf_event_set_period(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	s64 left = local64_read(&hwc->period_left);
+	s64 period = hwc->sample_period;
+	u64 max_period = (1ULL << UNCORE_NUM_COUNTERS) - 1;
+	int ret = 0, idx = hwc->idx;
+
+	/*
+	 * If we are way outside a reasonable range then just skip forward:
+	 */
+	if (unlikely(left <= -period)) {
+		left = period;
+		local64_set(&hwc->period_left, left);
+		hwc->last_period = period;
+		ret = 1;
+	}
+
+	if (unlikely(left <= 0)) {
+		left += period;
+		local64_set(&hwc->period_left, left);
+		hwc->last_period = period;
+		ret = 1;
+	}
+
+	if (left > max_period)
+		left = max_period;
+
+	/*
+	 * The hw event starts counting from this event offset,
+	 * mark it to be able to extra future deltas:
+	 */
+	local64_set(&hwc->prev_count, (u64)-left);
+
+	wrmsrl(hwc->event_base + idx, (u64)(-left) & max_period);
+
+	perf_event_update_userpage(event);
+
+	return ret;
+}
+
 static void uncore_pmu_start(struct perf_event *event, int flags)
 {
 	if (flags & PERF_EF_RELOAD)
-		x86_perf_event_set_period(event);
+		uncore_perf_event_set_period(event);
 
 	uncore_pmu_enable_event(event);
 
@@ -200,7 +242,7 @@ static inline void uncore_pmu_ack_status(u64 ack)
 static int uncore_pmu_save_and_restart(struct perf_event *event)
 {
 	x86_perf_event_update(event, UNCORE_CNTVAL_BITS);
-	return x86_perf_event_set_period(event);
+	return uncore_perf_event_set_period(event);
 }
 
 int uncore_pmu_handle_irq(struct pt_regs *regs)


> 
> 2/3 looks ok, but I think it would be nice if it would be more self
> contained, that is, not be part of the include mess and possibly have
> its own NMI_DIE notifier entry.

How about below to make uncore code more self contained?
I'll look at the NMI DIE notifier thing later.

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 550e26b..8df4e13 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -127,6 +127,7 @@ union cpuid10_edx {
 #ifdef CONFIG_PERF_EVENTS
 extern void init_hw_perf_events(void);
 extern void perf_events_lapic_init(void);
+extern void init_uncore_pmu(void);
 
 #define PERF_EVENT_INDEX_OFFSET			0
 
@@ -138,6 +139,7 @@ extern void perf_events_lapic_init(void);
 #define PERF_EFLAGS_EXACT	(1UL << 3)
 
 struct pt_regs;
+extern int uncore_pmu_handle_irq(struct pt_regs *regs);
 extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
 extern unsigned long perf_misc_flags(struct pt_regs *regs);
 #define perf_misc_flags(regs)	perf_misc_flags(regs)
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 3f0ebe4..db4bf99 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
 obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 
 obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
+obj-$(CONFIG_PERF_EVENTS)		+= perf_event_intel_uncore.o
 
 obj-$(CONFIG_X86_MCE)			+= mcheck/
 obj-$(CONFIG_MTRR)			+= mtrr/
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index cca07b4..330e4f4 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1215,8 +1215,6 @@ struct pmu_nmi_state {
 
 static DEFINE_PER_CPU(struct pmu_nmi_state, pmu_nmi);
 
-static int uncore_pmu_handle_irq(struct pt_regs *regs);
-
 static int __kprobes
 perf_event_nmi_handler(struct notifier_block *self,
 			 unsigned long cmd, void *__args)
@@ -1308,7 +1306,6 @@ x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 #include "perf_event_intel_lbr.c"
 #include "perf_event_intel_ds.c"
 #include "perf_event_intel.c"
-#include "perf_event_intel_uncore.c"
 
 static int __cpuinit
 x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index b22aa95..b9f15f2 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -3,6 +3,7 @@
 static struct node_hw_events uncore_events[MAX_NUMNODES];
 static DEFINE_PER_CPU(struct uncore_cpu_hw_events, uncore_cpu_hw_events);
 static bool uncore_pmu_initialized;
+static atomic_t active_events;
 
 static void uncore_pmu_enable_event(struct perf_event *event)
 {
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 33b9b5e..0a5e6d4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -78,3 +78,4 @@ struct uncore_cpu_hw_events {
 	unsigned long active_mask[BITS_TO_LONGS(UNCORE_NUM_COUNTERS)];
 };
 
+extern u64 x86_perf_event_update(struct perf_event *event, int cntval_bits);


> 
> All in all, Thanks for doing this, its a good start!

Thanks for the quick response.

Lin Ming


