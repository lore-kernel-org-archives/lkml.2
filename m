Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab1GGP2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:28:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35213 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873Ab1GGP2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:28:53 -0400
Date: Thu, 7 Jul 2011 19:28:49 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [rfc] perf p4 events aliases
Message-ID: <20110707152849.GV5485@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don, if you have a chance could you please check if this
patch does a trick for nmi-watchdog and perf top? The idea
is to use aliases as being proposed early.

Note I commented out hw_watchdog_set_attr method to be sure
this hook doesn't take place so you get "defined but not used"
warning but it's known to happen.

Some details -- I think alias should be allowed for general
events only so any raw event will never fit aliasing feature.

Compile tested only, so I guess most probably something will
goes wrong or fail, but anyway ;) Thanks!

Patch is on top of current -tip/perf/core

 | commit 931da6137e8e8c622f59251e8b645467aea293f1

	Cyrill
---
 arch/x86/include/asm/perf_event_p4.h |    6 ++
 arch/x86/kernel/cpu/perf_event_p4.c  |   80 +++++++++++++++++++++++++++++++++--
 2 files changed, 82 insertions(+), 4 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/perf_event_p4.h
+++ linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
@@ -757,6 +757,12 @@ enum P4_ESCR_EMASKS {
 #define P4_PEBS_CONFIG_MASK		0xff
 
 /*
+ * If event may have alias it should be marked
+ * with special bit.
+ */
+#define P4_CONFIG_ALIASABLE		(1 << 9)
+
+/*
  * mem: Only counters MSR_IQ_COUNTER4 (16) and
  * MSR_IQ_COUNTER5 (17) are allowed for PEBS sampling
  */
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -570,11 +570,72 @@ static __initconst const u64 p4_hw_cache
  },
 };
 
+/*
+ * Because of Netburst being quite restricted in now
+ * many similar events can run simultaneously we use
+ * that named event aliases, ie different events which
+ * have the same functionallity but use non-intersected
+ * ESCR/CCCR/couter registers which relax restrictions a
+ * bit and run two or more semi-same events together.
+ * This is done transparently to a user space.
+ *
+ * Never set P4_CONFIG_HT bit here nor the P4_PEBS_METRIC,
+ * they either up-to-dated automatically either not appliable
+ * at all, so be really carefull choosing aliases.
+ *
+ */
+struct p4_event_alias {
+	u64 orig;
+	u64 alter;
+} p4_event_aliases[] = {
+  {
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
+  },
+};
+
+static u64 p4_get_alias_event(u64 config)
+{
+	int i;
+
+	if (!(config & P4_CONFIG_ALIASABLE))
+		return 0;
+
+	config &= P4_CONFIG_MASK;
+
+	/*
+	 * If an event was previously already swapped to
+	 * alter config we can swap it back when needed.
+	 */
+	for (i = 0; i < ARRAY_SIZE(p4_event_aliases); i++) {
+		if (config == p4_event_aliases[i].orig)
+			return p4_event_aliases[i].alter | P4_CONFIG_ALIASABLE;
+		else if (config == p4_event_aliases[i].alter)
+			return p4_event_aliases[i].orig | P4_CONFIG_ALIASABLE;
+	}
+
+	return 0;
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
@@ -1159,6 +1220,7 @@ static int p4_pmu_schedule_events(struct
 	struct p4_event_bind *bind;
 	unsigned int i, thread, num;
 	int cntr_idx, escr_idx;
+	u64 config_alias;
 
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
 	bitmap_zero(escr_mask, P4_ESCR_MSR_TABLE_SIZE);
@@ -1167,6 +1229,7 @@ static int p4_pmu_schedule_events(struct
 
 		hwc = &cpuc->event_list[i]->hw;
 		thread = p4_ht_thread(cpu);
+again:
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
+			 * Probably an event alias is still available.
+			 */
+			config_alias = p4_get_alias_event(hwc->config);
+			if (!config_alias)
+				goto done;
+			/* Don't forget to restore HT */
+			hwc->config = thread ? p4_set_ht_bit(config_alias) : config_alias;
+			goto again;
+		}
 
 		p4_pmu_swap_config_ts(hwc, cpu);
 		if (assign)
@@ -1218,7 +1290,7 @@ static __initconst const struct x86_pmu 
 	.cntval_bits		= ARCH_P4_CNTRVAL_BITS,
 	.cntval_mask		= ARCH_P4_CNTRVAL_MASK,
 	.max_period		= (1ULL << (ARCH_P4_CNTRVAL_BITS - 1)) - 1,
-	.hw_watchdog_set_attr	= p4_hw_watchdog_set_attr,
+	/* .hw_watchdog_set_attr	= p4_hw_watchdog_set_attr, */
 	.hw_config		= p4_hw_config,
 	.schedule_events	= p4_pmu_schedule_events,
 	/*
