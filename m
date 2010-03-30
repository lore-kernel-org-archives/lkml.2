Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab0C3QzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 12:55:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50364 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab0C3QzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 12:55:16 -0400
Subject: Re: [PATCH 0/3] perf/core, x86: unify perfctr bitmasks
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>
In-Reply-To: <20100330155949.GJ11907@erda.amd.com>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
	 <bd4cb8901003300311l4178891dvf1e63293a0ac51fe@mail.gmail.com>
	 <20100330134145.GI11907@erda.amd.com>
	 <bd4cb8901003300653lc8e414bp3930b03fee2fffbf@mail.gmail.com>
	 <1269961255.5258.221.camel@laptop>  <20100330155949.GJ11907@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 18:55:13 +0200
Message-ID: <1269968113.5258.442.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 17:59 +0200, Robert Richter wrote:
> > +     if (attr->type == PERF_TYPE_RAW)
> > +             return x86_pmu.raw_event(event);
> 
> We could go on with this and move this into *_hw_config(), but so far
> this change is fine to me. This would then remove .raw_event() at all.
> 

Right, I did have a brief look at that, you mentioned this before to
Cyrill IIRC, but the issue is that... ~brainwave~ how about the below..

> 
> > Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
> > +++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
> > @@ -758,6 +758,19 @@ intel_get_event_constraints(struct cpu_h
> >       return x86_get_event_constraints(cpuc, event);
> >  }
> >  
> > +static int intel_pmu_raw_event(struct perf_event *event)
> > +{
> > +     int ret = x86_pmu_raw_event(event);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if ((event->hw.config & ARCH_PERFMON_EVENTSEL_ANY) &&
> > +                     perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
> > +             return -EACCES;
> > +
> > +     return 0;
> 
> Maybe this?
> 
>         if (!(event->attr.config & ARCH_PERFMON_EVENTSEL_ANY))
>                 return 0;
>         if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
>                 return -EACCES;
>         event->hw.config |= ARCH_PERFMON_EVENTSEL_ANY;
>         return 0; 

You're right..



---
 arch/x86/kernel/cpu/perf_event.c       |   35 +++++++++-------------------
 arch/x86/kernel/cpu/perf_event_amd.c   |   17 ++++++++++----
 arch/x86/kernel/cpu/perf_event_intel.c |   30 +++++++++++++++++++++---
 arch/x86/kernel/cpu/perf_event_p4.c    |   40 ++++++++++++++++++---------------
 4 files changed, 73 insertions(+), 49 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -196,12 +196,11 @@ struct x86_pmu {
 	void		(*enable_all)(int added);
 	void		(*enable)(struct perf_event *);
 	void		(*disable)(struct perf_event *);
-	int		(*hw_config)(struct perf_event_attr *attr, struct hw_perf_event *hwc);
+	int		(*hw_config)(struct perf_event *event);
 	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
 	unsigned	eventsel;
 	unsigned	perfctr;
 	u64		(*event_map)(int);
-	u64		(*raw_event)(u64);
 	int		max_events;
 	int		num_counters;
 	int		num_counters_fixed;
@@ -426,28 +425,26 @@ set_ext_hw_attr(struct hw_perf_event *hw
 	return 0;
 }
 
-static int x86_hw_config(struct perf_event_attr *attr, struct hw_perf_event *hwc)
+static int x86_pmu_hw_config(struct perf_event *event)
 {
 	/*
 	 * Generate PMC IRQs:
 	 * (keep 'enabled' bit clear for now)
 	 */
-	hwc->config = ARCH_PERFMON_EVENTSEL_INT;
+	event->hw.config = ARCH_PERFMON_EVENTSEL_INT;
 
 	/*
 	 * Count user and OS events unless requested not to
 	 */
-	if (!attr->exclude_user)
-		hwc->config |= ARCH_PERFMON_EVENTSEL_USR;
-	if (!attr->exclude_kernel)
-		hwc->config |= ARCH_PERFMON_EVENTSEL_OS;
+	if (!event->attr.exclude_user)
+		event->hw.config |= ARCH_PERFMON_EVENTSEL_USR;
+	if (!event->attr.exclude_kernel)
+		event->hw.config |= ARCH_PERFMON_EVENTSEL_OS;
 
-	return 0;
-}
+	if (event->attr.type == PERF_TYPE_RAW)
+		event->hw.config |= event->attr.config & X86_RAW_EVENT_MASK;
 
-static u64 x86_pmu_raw_event(u64 hw_event)
-{
-	return hw_event & X86_RAW_EVENT_MASK;
+	return 0;
 }
 
 /*
@@ -489,7 +486,7 @@ static int __hw_perf_event_init(struct p
 	hwc->last_tag = ~0ULL;
 
 	/* Processor specifics */
-	err = x86_pmu.hw_config(attr, hwc);
+	err = x86_pmu.hw_config(event);
 	if (err)
 		return err;
 
@@ -508,16 +505,8 @@ static int __hw_perf_event_init(struct p
 			return -EOPNOTSUPP;
 	}
 
-	/*
-	 * Raw hw_event type provide the config in the hw_event structure
-	 */
-	if (attr->type == PERF_TYPE_RAW) {
-		hwc->config |= x86_pmu.raw_event(attr->config);
-		if ((hwc->config & ARCH_PERFMON_EVENTSEL_ANY) &&
-		    perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
-			return -EACCES;
+	if (attr->type == PERF_TYPE_RAW)
 		return 0;
-	}
 
 	if (attr->type == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, attr);
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_amd.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_amd.c
@@ -111,9 +111,19 @@ static u64 amd_pmu_event_map(int hw_even
 	return amd_perfmon_event_map[hw_event];
 }
 
-static u64 amd_pmu_raw_event(u64 hw_event)
+static int amd_pmu_hw_config(struct perf_event *event)
 {
-	return hw_event & AMD64_RAW_EVENT_MASK;
+	int ret = x86_pmu_hw_config(event);
+
+	if (ret)
+		return ret;
+
+	if (event->attr.type != PERF_TYPE_RAW)
+		return 0;
+
+	event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
+
+	return 0;
 }
 
 /*
@@ -365,12 +375,11 @@ static __initconst struct x86_pmu amd_pm
 	.enable_all		= x86_pmu_enable_all,
 	.enable			= x86_pmu_enable_event,
 	.disable		= x86_pmu_disable_event,
-	.hw_config		= x86_hw_config,
+	.hw_config		= amd_pmu_hw_config,
 	.schedule_events	= x86_schedule_events,
 	.eventsel		= MSR_K7_EVNTSEL0,
 	.perfctr		= MSR_K7_PERFCTR0,
 	.event_map		= amd_pmu_event_map,
-	.raw_event		= amd_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
 	.num_counters		= 4,
 	.cntval_bits		= 48,
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -758,6 +758,30 @@ intel_get_event_constraints(struct cpu_h
 	return x86_get_event_constraints(cpuc, event);
 }
 
+static int intel_pmu_hw_config(struct perf_event *event)
+{
+	int ret = x86_pmu_hw_config(event);
+
+	if (ret)
+		return ret;
+
+	if (event->attr.type != PERF_TYPE_RAW)
+		return 0;
+
+	if (!(event->attr.config & ARCH_PERFMON_EVENTSEL_ANY))
+		return 0;
+
+	if (x86_pmu.version < 3)
+		return -EINVAL;
+
+	if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	event->hw.config |= ARCH_PERFMON_EVENTSEL_ANY;
+
+	return 0;
+}
+
 static __initconst struct x86_pmu core_pmu = {
 	.name			= "core",
 	.handle_irq		= x86_pmu_handle_irq,
@@ -765,12 +789,11 @@ static __initconst struct x86_pmu core_p
 	.enable_all		= x86_pmu_enable_all,
 	.enable			= x86_pmu_enable_event,
 	.disable		= x86_pmu_disable_event,
-	.hw_config		= x86_hw_config,
+	.hw_config		= x86_pmu_hw_config,
 	.schedule_events	= x86_schedule_events,
 	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
 	.perfctr		= MSR_ARCH_PERFMON_PERFCTR0,
 	.event_map		= intel_pmu_event_map,
-	.raw_event		= x86_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(intel_perfmon_event_map),
 	.apic			= 1,
 	/*
@@ -804,12 +827,11 @@ static __initconst struct x86_pmu intel_
 	.enable_all		= intel_pmu_enable_all,
 	.enable			= intel_pmu_enable_event,
 	.disable		= intel_pmu_disable_event,
-	.hw_config		= x86_hw_config,
+	.hw_config		= intel_pmu_hw_config,
 	.schedule_events	= x86_schedule_events,
 	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
 	.perfctr		= MSR_ARCH_PERFMON_PERFCTR0,
 	.event_map		= intel_pmu_event_map,
-	.raw_event		= x86_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(intel_perfmon_event_map),
 	.apic			= 1,
 	/*
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_p4.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_p4.c
@@ -419,20 +419,7 @@ static u64 p4_pmu_event_map(int hw_event
 	return config;
 }
 
-/*
- * We don't control raw events so it's up to the caller
- * to pass sane values (and we don't count the thread number
- * on HT machine but allow HT-compatible specifics to be
- * passed on)
- */
-static u64 p4_pmu_raw_event(u64 hw_event)
-{
-	return hw_event &
-		(p4_config_pack_escr(P4_ESCR_MASK_HT) |
-		 p4_config_pack_cccr(P4_CCCR_MASK_HT));
-}
-
-static int p4_hw_config(struct perf_event_attr *attr, struct hw_perf_event *hwc)
+static int p4_hw_config(struct perf_event *event)
 {
 	int cpu = raw_smp_processor_id();
 	u32 escr, cccr;
@@ -444,11 +431,29 @@ static int p4_hw_config(struct perf_even
 	 */
 
 	cccr = p4_default_cccr_conf(cpu);
-	escr = p4_default_escr_conf(cpu, attr->exclude_kernel, attr->exclude_user);
-	hwc->config = p4_config_pack_escr(escr) | p4_config_pack_cccr(cccr);
+	escr = p4_default_escr_conf(cpu, event->attr.exclude_kernel,
+					 event->attr.exclude_user);
+	event->hw.config = p4_config_pack_escr(escr) |
+			   p4_config_pack_cccr(cccr);
 
 	if (p4_ht_active() && p4_ht_thread(cpu))
-		hwc->config = p4_set_ht_bit(hwc->config);
+		event->hw.config = p4_set_ht_bit(event->hw.config);
+
+	if (event->attr.type != PERF_TYPE_RAW)
+		return 0;
+
+	/*
+	 * We don't control raw events so it's up to the caller
+	 * to pass sane values (and we don't count the thread number
+	 * on HT machine but allow HT-compatible specifics to be
+	 * passed on)
+	 *
+	 * XXX: HT wide things should check perf_paranoid_cpu() &&
+	 *      CAP_SYS_ADMIN
+	 */
+	event->hw.config |= event->attr.config &
+		(p4_config_pack_escr(P4_ESCR_MASK_HT) |
+		 p4_config_pack_cccr(P4_CCCR_MASK_HT));
 
 	return 0;
 }
@@ -785,7 +790,6 @@ static __initconst struct x86_pmu p4_pmu
 	.eventsel		= MSR_P4_BPU_CCCR0,
 	.perfctr		= MSR_P4_BPU_PERFCTR0,
 	.event_map		= p4_pmu_event_map,
-	.raw_event		= p4_pmu_raw_event,
 	.max_events		= ARRAY_SIZE(p4_general_events),
 	.get_event_constraints	= x86_get_event_constraints,
 	/*


