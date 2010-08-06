Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935382Ab0HFFgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:36:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:39108 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937Ab0HFFgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:36:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,326,1278313200"; 
   d="scan'208";a="308873178"
Subject: Re: perf failed with kernel 2.6.35-rc
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Arjan van de Ven <arjan@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, andi.kleen@intel.com,
        shaohua.li@intel.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281004361.1923.1750.camel@laptop>
References: <1279008849.2096.913.camel@ymzhang.sh.intel.com>
	 <1280838043.1923.587.camel@laptop>
	 <1280886349.2125.32.camel@ymzhang.sh.intel.com>
	 <1280905701.1923.717.camel@laptop>
	 <1280990413.2125.50.camel@ymzhang.sh.intel.com>
	 <1281004361.1923.1750.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 06 Aug 2010 13:39:08 +0800
Message-Id: <1281073148.2125.63.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 12:32 +0200, Peter Zijlstra wrote:
> On Thu, 2010-08-05 at 14:40 +0800, Zhang, Yanmin wrote:
> 
> > Here is the new patch.
I did more tracing. It seems only PMC0 overflows unexpectedly with the Errata.

> > 
> > ---
> > 
> > --- linux-2.6.35/arch/x86/kernel/cpu/perf_event_intel.c 2010-08-02 06:11:14.000000000 +0800
> > +++ linux-2.6.35_perferrata/arch/x86/kernel/cpu/perf_event_intel.c      2010-08-06 13:43:34.000000000 +0800
> > @@ -499,21 +499,40 @@ static void intel_pmu_nhm_enable_all(int
> >  {
> >         if (added) {
> >                 struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> > +               struct perf_event *event;
> > +               int num_counters;
> >                 int i;
> >  
> > -               wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 0, 0x4300D2);
> > -               wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 1, 0x4300B1);
> > -               wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 2, 0x4300B5);
> > +               /* We always operate 4 pairs of PERF Counters */
> > +               num_counters = 4;
> 
> Either hardcode 4 (its a model specific errata after all), or use
> x86_pmu.num_counters.
Ok.

> 
> Also, please update the comment describing the new work-around.
I will add detailed steps.

> 
> > +               for (i = 0; i < num_counters; i++) {
> > +                       event = cpuc->events[i];
> > +                       if (!event)
> > +                               continue;
> > +                       x86_perf_event_update(event);
> > +               }
> >  
> > -               wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
> > +               wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 0, 0x4300B5);
> > +               wrmsrl(MSR_ARCH_PERFMON_PERFCTR0 + 0, 0x0);
> > +               wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 1, 0x4300D2);
> > +               wrmsrl(MSR_ARCH_PERFMON_PERFCTR0 + 1, 0x0);
> > +               wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 2, 0x4300B1);
> > +               wrmsrl(MSR_ARCH_PERFMON_PERFCTR0 + 2, 0x0);
> > +               wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 3, 0x4300B1);
> > +               wrmsrl(MSR_ARCH_PERFMON_PERFCTR0 + 3, 0x0);
> > +
> 
> Maybe write that as:
> 
> 	static const unsigned long magic[4] = { 0x4300B5, 0x4300D2, 0x4300B1, 0x4300B1 };
> 
> 	for (i = 0; i < 4; i++) {
> 		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, magic[i]);
> 		wrmsrl(MSR_ARCH_PERFMON_PERFCTR0 + i, 0);
> 	}
> 
> > +               wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0xf);
> >                 wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
> >  
> > -               for (i = 0; i < 3; i++) {
> > -                       struct perf_event *event = cpuc->events[i];
> > +               for (i = 0; i < num_counters; i++) {
> > +                       event = cpuc->events[i];
> >  
> > -                       if (!event)
> > +                       if (!event) {
> > +                               wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, 0x0);
> 
> Indeed, if they are counting we need to at least stop them, and clearing
> them is indeed the simplest way.
> 
> >                                 continue;
> > +                       }
> >  
> > +                       x86_perf_event_set_period(event);
> >                         __x86_pmu_enable_event(&event->hw,
> >                                                ARCH_PERFMON_EVENTSEL_ENABLE);
> >                 }
> 
> Please send the updated patch for inclusion, Thanks!
Below is the patch against 2.6.35.

Fix Errata AAK100/AAP53/BD53.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

--- linux-2.6.35/arch/x86/kernel/cpu/perf_event_intel.c	2010-08-02 06:11:14.000000000 +0800
+++ linux-2.6.35_perferrata/arch/x86/kernel/cpu/perf_event_intel.c	2010-08-07 10:06:03.000000000 +0800
@@ -492,32 +492,73 @@ static void intel_pmu_enable_all(int add
  *   Intel Errata BD53   (model 44)
  *
  * These chips need to be 'reset' when adding counters by programming
- * the magic three (non counting) events 0x4300D2, 0x4300B1 and 0x4300B5
+ * the magic three (non counting) events 0x4300B5, 0x4300D2, and 0x4300B1
  * either in sequence on the same PMC or on different PMCs.
  */
-static void intel_pmu_nhm_enable_all(int added)
+static void intel_pmu_nhm_workaround(void)
 {
-	if (added) {
-		struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-		int i;
-
-		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 0, 0x4300D2);
-		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 1, 0x4300B1);
-		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 2, 0x4300B5);
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	static const unsigned long nhm_magic[4] = {
+		0x4300B5,
+		0x4300D2,
+		0x4300B1,
+		0x4300B1
+	};
+	struct perf_event *event;
+	int i;
+
+	/*
+	 * The Errata requires below steps:
+	 * 1) Clear MSR_IA32_PEBS_ENABLE and MSR_CORE_PERF_GLOBAL_CTRL;
+	 * 2) Configure 4 PERFEVTSELx with the magic number and clear
+	 *    the corresponding PMCx;
+	 * 3) set bit0~bit3 of MSR_CORE_PERF_GLOBAL_CTRL;
+	 * 4) Clear MSR_CORE_PERF_GLOBAL_CTRL;
+	 * 5) Clear 4 pairs of ERFEVTSELx and PMCx;
+	 */
 
-		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
-		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
+	/*
+	 * The real steps we choose are a little different from above.
+	 * A) To reduce MSR operations, we don't run step 1) as they
+	 *    are already cleared before this function is called;
+	 * B) Call x86_perf_event_update to save PMCx before configuring
+	 *    PERFEVTSELx with magic number;
+	 * C) With step 5), we do clear only when the PERFEVTSELx is
+	 *    not used currently.
+	 * D) Call x86_perf_event_set_period to restore PMCx;
+	 */
 
-		for (i = 0; i < 3; i++) {
-			struct perf_event *event = cpuc->events[i];
+	/* We always operate 4 pairs of PERF Counters */
+	for (i = 0; i < 4; i++) {
+		event = cpuc->events[i];
+		if (event)
+			x86_perf_event_update(event);
+	}
 
-			if (!event)
-				continue;
+	for (i = 0; i < 4; i++) {
+		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, nhm_magic[i]);
+		wrmsrl(MSR_ARCH_PERFMON_PERFCTR0 + i, 0x0);
+	}
 
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0xf);
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
+
+	for (i = 0; i < 4; i++) {
+		event = cpuc->events[i];
+
+		if (event) {
+			x86_perf_event_set_period(event);
 			__x86_pmu_enable_event(&event->hw,
-					       ARCH_PERFMON_EVENTSEL_ENABLE);
-		}
+					ARCH_PERFMON_EVENTSEL_ENABLE);
+		} else
+			wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, 0x0);
 	}
+}
+
+static void intel_pmu_nhm_enable_all(int added)
+{
+	if (added)
+		intel_pmu_nhm_workaround();
 	intel_pmu_enable_all(added);
 }
 


