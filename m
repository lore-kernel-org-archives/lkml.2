Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836Ab1D2SR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:17:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40250 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760760Ab1D2SR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:17:26 -0400
Date: Fri, 29 Apr 2011 20:17:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110429181707.GA9733@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Don Zickus (1):
      perf, x86, nmi: Move LVT un-masking into irq handlers

Ingo Molnar (1):
      perf events, x86: Work around the Nehalem AAJ80 erratum

Michal Simek (1):
      ftrace: Build without frame pointers on Microblaze

Peter Zijlstra (1):
      perf, x86: Fix BTS condition


 arch/x86/kernel/cpu/perf_event.c       |   16 ++++++++++++----
 arch/x86/kernel/cpu/perf_event_intel.c |   29 +++++++++++++++++++++++++++--
 arch/x86/kernel/cpu/perf_event_p4.c    |   17 +++++++++++++----
 kernel/trace/Kconfig                   |    2 +-
 4 files changed, 53 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 632e5dc..e638689 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -613,8 +613,8 @@ static int x86_setup_perfctr(struct perf_event *event)
 	/*
 	 * Branch tracing:
 	 */
-	if ((attr->config == PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
-	    (hwc->sample_period == 1)) {
+	if (attr->config == PERF_COUNT_HW_BRANCH_INSTRUCTIONS &&
+	    !attr->freq && hwc->sample_period == 1) {
 		/* BTS is not supported by this architecture. */
 		if (!x86_pmu.bts_active)
 			return -EOPNOTSUPP;
@@ -1288,6 +1288,16 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
+	/*
+	 * Some chipsets need to unmask the LVTPC in a particular spot
+	 * inside the nmi handler.  As a result, the unmasking was pushed
+	 * into all the nmi handlers.
+	 *
+	 * This generic handler doesn't seem to have any issues where the
+	 * unmasking occurs so it was left at the top.
+	 */
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		if (!test_bit(idx, cpuc->active_mask)) {
 			/*
@@ -1374,8 +1384,6 @@ perf_event_nmi_handler(struct notifier_block *self,
 		return NOTIFY_DONE;
 	}
 
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-
 	handled = x86_pmu.handle_irq(args->regs);
 	if (!handled)
 		return NOTIFY_DONE;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 43fa20b..e61539b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -25,7 +25,7 @@ struct intel_percore {
 /*
  * Intel PerfMon, used on Core and later.
  */
-static const u64 intel_perfmon_event_map[] =
+static u64 intel_perfmon_event_map[PERF_COUNT_HW_MAX] __read_mostly =
 {
   [PERF_COUNT_HW_CPU_CYCLES]		= 0x003c,
   [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
@@ -933,6 +933,16 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
+	/*
+	 * Some chipsets need to unmask the LVTPC in a particular spot
+	 * inside the nmi handler.  As a result, the unmasking was pushed
+	 * into all the nmi handlers.
+	 *
+	 * This handler doesn't seem to have any issues with the unmasking
+	 * so it was left at the top.
+	 */
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+
 	intel_pmu_disable_all();
 	handled = intel_pmu_drain_bts_buffer();
 	status = intel_pmu_get_status();
@@ -998,6 +1008,9 @@ intel_bts_constraints(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	unsigned int hw_event, bts_event;
 
+	if (event->attr.freq)
+		return NULL;
+
 	hw_event = hwc->config & INTEL_ARCH_EVENT_MASK;
 	bts_event = x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
 
@@ -1305,7 +1318,7 @@ static void intel_clovertown_quirks(void)
 	 * AJ106 could possibly be worked around by not allowing LBR
 	 *       usage from PEBS, including the fixup.
 	 * AJ68  could possibly be worked around by always programming
-	 * 	 a pebs_event_reset[0] value and coping with the lost events.
+	 *	 a pebs_event_reset[0] value and coping with the lost events.
 	 *
 	 * But taken together it might just make sense to not enable PEBS on
 	 * these chips.
@@ -1409,6 +1422,18 @@ static __init int intel_pmu_init(void)
 		x86_pmu.percore_constraints = intel_nehalem_percore_constraints;
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.extra_regs = intel_nehalem_extra_regs;
+
+		if (ebx & 0x40) {
+			/*
+			 * Erratum AAJ80 detected, we work it around by using
+			 * the BR_MISP_EXEC.ANY event. This will over-count
+			 * branch-misses, but it's still much better than the
+			 * architectural event which is often completely bogus:
+			 */
+			intel_perfmon_event_map[PERF_COUNT_HW_BRANCH_MISSES] = 0x7f89;
+
+			pr_cont("erratum AAJ80 worked around, ");
+		}
 		pr_cont("Nehalem events, ");
 		break;
 
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index d1f77e2..e93fcd5 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -950,11 +950,20 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 			x86_pmu_stop(event, 0);
 	}
 
-	if (handled) {
-		/* p4 quirk: unmask it again */
-		apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
+	if (handled)
 		inc_irq_stat(apic_perf_irqs);
-	}
+
+	/*
+	 * When dealing with the unmasking of the LVTPC on P4 perf hw, it has
+	 * been observed that the OVF bit flag has to be cleared first _before_
+	 * the LVTPC can be unmasked.
+	 *
+	 * The reason is the NMI line will continue to be asserted while the OVF
+	 * bit is set.  This causes a second NMI to generate if the LVTPC is
+	 * unmasked before the OVF bit is cleared, leading to unknown NMI
+	 * messages.
+	 */
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
 
 	return handled;
 }
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 61d7d59f..2ad39e5 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -141,7 +141,7 @@ if FTRACE
 config FUNCTION_TRACER
 	bool "Kernel Function Tracer"
 	depends on HAVE_FUNCTION_TRACER
-	select FRAME_POINTER if !ARM_UNWIND && !S390
+	select FRAME_POINTER if !ARM_UNWIND && !S390 && !MICROBLAZE
 	select KALLSYMS
 	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
