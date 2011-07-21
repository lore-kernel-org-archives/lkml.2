Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab1GUKB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:01:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:55849 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab1GUKBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:01:23 -0400
Date: Thu, 21 Jul 2011 10:00:45 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Message-ID: <tip-f91298709790b9a483752ca3c967845537df2af3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
        ming.m.lin@intel.com, tglx@linutronix.de, dzickus@redhat.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
In-Reply-To: <20110708201712.GS23657@sun>
References: <20110708201712.GS23657@sun>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: P4 PMU - Introduce event alias feature
Git-Commit-ID: f91298709790b9a483752ca3c967845537df2af3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:00:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f91298709790b9a483752ca3c967845537df2af3
Gitweb:     http://git.kernel.org/tip/f91298709790b9a483752ca3c967845537df2af3
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sat, 9 Jul 2011 00:17:12 +0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 14 Jul 2011 17:25:04 -0400

perf, x86: P4 PMU - Introduce event alias feature

Instead of hw_nmi_watchdog_set_attr() weak function
and appropriate x86_pmu::hw_watchdog_set_attr() call
we introduce even alias mechanism which allow us
to drop this routines completely and isolate quirks
of Netburst architecture inside P4 PMU code only.

The main idea remains the same though -- to allow
nmi-watchdog and perf top run simultaneously.

Note the aliasing mechanism applies to generic
PERF_COUNT_HW_CPU_CYCLES event only because arbitrary
event (say passed as RAW initially) might have some
additional bits set inside ESCR register changing
the behaviour of event and we can't guarantee anymore
that alias event will give the same result.

P.S. Thanks a huge to Don and Steven for for testing
     and early review.

Acked-by: Don Zickus <dzickus@redhat.com>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Stephane Eranian <eranian@google.com>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/20110708201712.GS23657@sun
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/perf_event_p4.h |   33 ++++++++
 arch/x86/kernel/cpu/perf_event.c     |    7 --
 arch/x86/kernel/cpu/perf_event_p4.c  |  135 ++++++++++++++++++++++++++-------
 kernel/watchdog.c                    |    2 -
 4 files changed, 139 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index 56fd9e3..4d86c86 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
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
+ * caller bits otherwise the mapping won't be complete.
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
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c53d433..b7a010f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -274,7 +274,6 @@ struct x86_pmu {
 	void		(*enable_all)(int added);
 	void		(*enable)(struct perf_event *);
 	void		(*disable)(struct perf_event *);
-	void		(*hw_watchdog_set_attr)(struct perf_event_attr *attr);
 	int		(*hw_config)(struct perf_event *event);
 	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
 	unsigned	eventsel;
@@ -360,12 +359,6 @@ static u64 __read_mostly hw_cache_extra_regs
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
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index fb901c5..8b7a0c3 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -570,11 +570,92 @@ static __initconst const u64 p4_hw_cache_event_ids
  },
 };
 
+/*
+ * Because of Netburst being quite restricted in now
+ * many same events can run simultaneously, we use
+ * event aliases, ie different events which have the
+ * same functionallity but use non-intersected resources
+ * (ESCR/CCCR/couter registers). This allow us to run
+ * two or more semi-same events together. It is done
+ * transparently to a user space.
+ *
+ * Never set any cusom internal bits such as P4_CONFIG_HT,
+ * P4_CONFIG_ALIASABLE or bits for P4_PEBS_METRIC, they are
+ * either up-to-dated automatically either not appliable
+ * at all.
+ *
+ * And be really carefull choosing aliases!
+ */
+struct p4_event_alias {
+	u64 orig;
+	u64 alter;
+} p4_event_aliases[] = {
+	{
+		/*
+		 * Non-halted cycles can be substituted with
+		 * non-sleeping cycles (see Intel SDM Vol3b for
+		 * details).
+		 */
+	.orig	=
+		p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_GLOBAL_POWER_EVENTS)		|
+				    P4_ESCR_EMASK_BIT(P4_EVENT_GLOBAL_POWER_EVENTS, RUNNING)),
+	.alter	=
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
+	},
+};
+
+static u64 p4_get_alias_event(u64 config)
+{
+	u64 config_match;
+	int i;
+
+	/*
+	 * Probably we're lucky and don't have to do
+	 * matching over all config bits.
+	 */
+	if (!(config & P4_CONFIG_ALIASABLE))
+		return 0;
+
+	config_match = config & P4_CONFIG_EVENT_ALIAS_MASK;
+
+	/*
+	 * If an event was previously swapped to the alter config
+	 * we should swap it back otherwise contnention on registers
+	 * will return back.
+	 */
+	for (i = 0; i < ARRAY_SIZE(p4_event_aliases); i++) {
+		if (config_match == p4_event_aliases[i].orig) {
+			config_match = p4_event_aliases[i].alter;
+			break;
+		} else if (config_match == p4_event_aliases[i].alter) {
+			config_match = p4_event_aliases[i].orig;
+			break;
+		}
+	}
+
+	if (i >= ARRAY_SIZE(p4_event_aliases))
+		return 0;
+
+	return config_match |
+		(config & P4_CONFIG_EVENT_ALIAS_IMMUTABLE_BITS);
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
@@ -719,31 +800,6 @@ static int p4_validate_raw_event(struct perf_event *event)
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
@@ -1159,6 +1215,8 @@ static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign
 	struct p4_event_bind *bind;
 	unsigned int i, thread, num;
 	int cntr_idx, escr_idx;
+	u64 config_alias;
+	int pass;
 
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
 	bitmap_zero(escr_mask, P4_ESCR_MSR_TABLE_SIZE);
@@ -1167,6 +1225,17 @@ static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign
 
 		hwc = &cpuc->event_list[i]->hw;
 		thread = p4_ht_thread(cpu);
+		pass = 0;
+
+again:
+		/*
+		 * Aliases are swappable so we may hit circular
+		 * lock if both original config and alias need
+		 * resources (MSR registers) which already busy.
+		 */
+		if (pass > 2)
+			goto done;
+
 		bind = p4_config_get_bind(hwc->config);
 		escr_idx = p4_get_escr_idx(bind->escr_msr[thread]);
 		if (unlikely(escr_idx == -1))
@@ -1180,8 +1249,17 @@ static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign
 		}
 
 		cntr_idx = p4_next_cntr(thread, used_mask, bind);
-		if (cntr_idx == -1 || test_bit(escr_idx, escr_mask))
-			goto done;
+		if (cntr_idx == -1 || test_bit(escr_idx, escr_mask)) {
+			/*
+			 * Probably an event alias is still available.
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
@@ -1218,7 +1296,6 @@ static __initconst const struct x86_pmu p4_pmu = {
 	.cntval_bits		= ARCH_P4_CNTRVAL_BITS,
 	.cntval_mask		= ARCH_P4_CNTRVAL_MASK,
 	.max_period		= (1ULL << (ARCH_P4_CNTRVAL_BITS - 1)) - 1,
-	.hw_watchdog_set_attr	= p4_hw_watchdog_set_attr,
 	.hw_config		= p4_hw_config,
 	.schedule_events	= p4_pmu_schedule_events,
 	/*
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index a933e3a..36491cd 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -200,7 +200,6 @@ static int is_softlockup(unsigned long touch_ts)
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
