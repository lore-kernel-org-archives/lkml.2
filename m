Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab1GUJri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:47:38 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:39518 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab1GUJrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:47:36 -0400
Date: Thu, 21 Jul 2011 13:47:31 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH -tip] perf, x86: P4 PMU - Introduce event alias feature v2
Message-ID: <20110721094730.GQ7492@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of hw_nmi_watchdog_set_attr() weak function
and appropriate x86_pmu::hw_watchdog_set_attr() call
we introduce an event alias mechanism.

This allow us to drop this routines completely and
isolate quirks of Netburst architecture inside P4 PMU
code only.

The main idea remains the same though -- to allow
nmi-watchdog and perf top run simultaneously.

v2: A number of typo fixes pointed out by Ingo Molnar.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Don Zickus <dzickus@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Stephane Eranian <eranian@google.com>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>
---

I hope this one will fit better

 arch/x86/include/asm/perf_event_p4.h |   33 ++++++++
 arch/x86/kernel/cpu/perf_event.c     |    7 -
 arch/x86/kernel/cpu/perf_event_p4.c  |  129 +++++++++++++++++++++++++++--------
 kernel/watchdog.c                    |    2 
 4 files changed, 133 insertions(+), 38 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/perf_event_p4.h
+++ linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
@@ -102,6 +102,14 @@
 #define P4_CONFIG_HT			(1ULL << P4_CONFIG_HT_SHIFT)
 
 /*
+ * If an event has alias it should be marked
+ * with a special bit. (Don't forget to check
+ * P4_PEBS_CONFIG_MASK and related bits on
+ * modification.)
+ */
+#define P4_CONFIG_ALIASABLE		(1 << 9)
+
+/*
  * The bits we allow to pass for RAW events
  */
 #define P4_CONFIG_MASK_ESCR		\
@@ -123,6 +131,31 @@
 	(p4_config_pack_escr(P4_CONFIG_MASK_ESCR))	| \
 	(p4_config_pack_cccr(P4_CONFIG_MASK_CCCR))
 
+/*
+ * In case of event aliasing we need to preserve some
+ * caller bits, otherwise the mapping won't be complete.
+ */
+#define P4_CONFIG_EVENT_ALIAS_MASK			  \
+	(p4_config_pack_escr(P4_CONFIG_MASK_ESCR)	| \
+	 p4_config_pack_cccr(P4_CCCR_EDGE		| \
+			     P4_CCCR_THRESHOLD_MASK	| \
+			     P4_CCCR_COMPLEMENT		| \
+			     P4_CCCR_COMPARE))
+
+#define  P4_CONFIG_EVENT_ALIAS_IMMUTABLE_BITS		  \
+	((P4_CONFIG_HT)					| \
+	 p4_config_pack_escr(P4_ESCR_T0_OS		| \
+			     P4_ESCR_T0_USR		| \
+			     P4_ESCR_T1_OS		| \
+			     P4_ESCR_T1_USR)		| \
+	 p4_config_pack_cccr(P4_CCCR_OVF		| \
+			     P4_CCCR_CASCADE		| \
+			     P4_CCCR_FORCE_OVF		| \
+			     P4_CCCR_THREAD_ANY		| \
+			     P4_CCCR_OVF_PMI_T0		| \
+			     P4_CCCR_OVF_PMI_T1		| \
+			     P4_CONFIG_ALIASABLE))
+
 static inline bool p4_is_event_cascaded(u64 config)
 {
 	u32 cccr = p4_config_unpack_cccr(config);
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -274,7 +274,6 @@ struct x86_pmu {
 	void		(*enable_all)(int added);
 	void		(*enable)(struct perf_event *);
 	void		(*disable)(struct perf_event *);
-	void		(*hw_watchdog_set_attr)(struct perf_event_attr *attr);
 	int		(*hw_config)(struct perf_event *event);
 	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
 	unsigned	eventsel;
@@ -360,12 +359,6 @@ static u64 __read_mostly hw_cache_extra_
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
 
-void hw_nmi_watchdog_set_attr(struct perf_event_attr *wd_attr)
-{
-	if (x86_pmu.hw_watchdog_set_attr)
-		x86_pmu.hw_watchdog_set_attr(wd_attr);
-}
-
 /*
  * Propagate event elapsed time into the generic event.
  * Can only be executed on the CPU where the event is active.
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -570,11 +570,86 @@ static __initconst const u64 p4_hw_cache
  },
 };
 
+/*
+ * Because of Netburst being quite restricted in how many
+ * identical events may run simultaneously, we introduce event aliases,
+ * ie the different events which have the same functionality but
+ * utilize non-intersected resources (ESCR/CCCR/counter registers).
+ *
+ * This allow us to relax restrictions a bit and run two or more
+ * identical events together.
+ *
+ * Never set any custom internal bits such as P4_CONFIG_HT,
+ * P4_CONFIG_ALIASABLE or bits for P4_PEBS_METRIC, they are
+ * either up to date automatically or not applicable at all.
+ */
+struct p4_event_alias {
+	u64 original;
+	u64 alternative;
+} p4_event_aliases[] = {
+	{
+		/*
+		 * Non-halted cycles can be substituted with non-sleeping cycles (see
+		 * Intel SDM Vol3b for details). We need this alias to be able
+		 * to run nmi-watchdog and 'perf top' (or any other user space tool
+		 * which is interested in running PERF_COUNT_HW_CPU_CYCLES)
+		 * simultaneously.
+		 */
+	.original	=
+		p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_GLOBAL_POWER_EVENTS)		|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_GLOBAL_POWER_EVENTS, RUNNING)),
+	.alternative	=
+		p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_EXECUTION_EVENT)		|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS0)|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS1)|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS2)|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS3)|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS0)	|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS1)	|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS2)	|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS3))|
+		p4_config_pack_cccr(P4_CCCR_THRESHOLD(15) | P4_CCCR_COMPLEMENT		|
+				    P4_CCCR_COMPARE),
+ 	},
+};
+
+static u64 p4_get_alias_event(u64 config)
+{
+	u64 config_match;
+	int i;
+
+	/*
+	 * Only event with special mark is allowed,
+	 * we're to be sure it didn't come as malformed
+	 * RAW event.
+	 */
+	if (!(config & P4_CONFIG_ALIASABLE))
+		return 0;
+
+	config_match = config & P4_CONFIG_EVENT_ALIAS_MASK;
+
+	for (i = 0; i < ARRAY_SIZE(p4_event_aliases); i++) {
+		if (config_match == p4_event_aliases[i].original) {
+			config_match = p4_event_aliases[i].alternative;
+			break;
+		} else if (config_match == p4_event_aliases[i].alternative) {
+			config_match = p4_event_aliases[i].original;
+			break;
+		}
+	}
+
+	if (i >= ARRAY_SIZE(p4_event_aliases))
+		return 0;
+
+	return config_match | (config & P4_CONFIG_EVENT_ALIAS_IMMUTABLE_BITS);
+}
+
 static u64 p4_general_events[PERF_COUNT_HW_MAX] = {
   /* non-halted CPU clocks */
   [PERF_COUNT_HW_CPU_CYCLES] =
 	p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_GLOBAL_POWER_EVENTS)		|
-		P4_ESCR_EMASK_BIT(P4_EVENT_GLOBAL_POWER_EVENTS, RUNNING)),
+		P4_ESCR_EMASK_BIT(P4_EVENT_GLOBAL_POWER_EVENTS, RUNNING))	|
+		P4_CONFIG_ALIASABLE,
 
   /*
    * retired instructions
@@ -719,31 +794,6 @@ static int p4_validate_raw_event(struct 
 	return 0;
 }
 
-static void p4_hw_watchdog_set_attr(struct perf_event_attr *wd_attr)
-{
-	/*
-	 * Watchdog ticks are special on Netburst, we use
-	 * that named "non-sleeping" ticks as recommended
-	 * by Intel SDM Vol3b.
-	 */
-	WARN_ON_ONCE(wd_attr->type	!= PERF_TYPE_HARDWARE ||
-		     wd_attr->config	!= PERF_COUNT_HW_CPU_CYCLES);
-
-	wd_attr->type	= PERF_TYPE_RAW;
-	wd_attr->config	=
-		p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_EXECUTION_EVENT)		|
-			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS0)		|
-			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS1)		|
-			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS2)		|
-			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS3)		|
-			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS0)		|
-			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS1)		|
-			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS2)		|
-			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS3))		|
-		p4_config_pack_cccr(P4_CCCR_THRESHOLD(15) | P4_CCCR_COMPLEMENT		|
-			P4_CCCR_COMPARE);
-}
-
 static int p4_hw_config(struct perf_event *event)
 {
 	int cpu = get_cpu();
@@ -1159,6 +1209,8 @@ static int p4_pmu_schedule_events(struct
 	struct p4_event_bind *bind;
 	unsigned int i, thread, num;
 	int cntr_idx, escr_idx;
+	u64 config_alias;
+	int pass;
 
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
 	bitmap_zero(escr_mask, P4_ESCR_MSR_TABLE_SIZE);
@@ -1167,6 +1219,17 @@ static int p4_pmu_schedule_events(struct
 
 		hwc = &cpuc->event_list[i]->hw;
 		thread = p4_ht_thread(cpu);
+		pass = 0;
+
+again:
+		/*
+		 * It's possible to hit a circular lock
+		 * between original and alternative events
+		 * if both are scheduled already.
+		 */
+		if (pass > 2)
+			goto done;
+
 		bind = p4_config_get_bind(hwc->config);
 		escr_idx = p4_get_escr_idx(bind->escr_msr[thread]);
 		if (unlikely(escr_idx == -1))
@@ -1180,8 +1243,17 @@ static int p4_pmu_schedule_events(struct
 		}
 
 		cntr_idx = p4_next_cntr(thread, used_mask, bind);
-		if (cntr_idx == -1 || test_bit(escr_idx, escr_mask))
-			goto done;
+		if (cntr_idx == -1 || test_bit(escr_idx, escr_mask)) {
+			/*
+			 * Check whether an event alias is still available.
+			 */
+			config_alias = p4_get_alias_event(hwc->config);
+			if (!config_alias)
+				goto done;
+			hwc->config = config_alias;
+			pass++;
+			goto again;
+		}
 
 		p4_pmu_swap_config_ts(hwc, cpu);
 		if (assign)
@@ -1218,7 +1290,6 @@ static __initconst const struct x86_pmu 
 	.cntval_bits		= ARCH_P4_CNTRVAL_BITS,
 	.cntval_mask		= ARCH_P4_CNTRVAL_MASK,
 	.max_period		= (1ULL << (ARCH_P4_CNTRVAL_BITS - 1)) - 1,
-	.hw_watchdog_set_attr	= p4_hw_watchdog_set_attr,
 	.hw_config		= p4_hw_config,
 	.schedule_events	= p4_pmu_schedule_events,
 	/*
Index: linux-2.6.git/kernel/watchdog.c
===================================================================
--- linux-2.6.git.orig/kernel/watchdog.c
+++ linux-2.6.git/kernel/watchdog.c
@@ -200,7 +200,6 @@ static int is_softlockup(unsigned long t
 }
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
-void __weak hw_nmi_watchdog_set_attr(struct perf_event_attr *wd_attr) { }
 
 static struct perf_event_attr wd_hw_attr = {
 	.type		= PERF_TYPE_HARDWARE,
@@ -372,7 +371,6 @@ static int watchdog_nmi_enable(int cpu)
 
 	wd_attr = &wd_hw_attr;
 	wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
-	hw_nmi_watchdog_set_attr(wd_attr);
 
 	/* Try to register using hardware perf events */
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback, NULL);
