Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab2KPWM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 17:12:58 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:13181
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753751Ab2KPWM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 17:12:56 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Nov 2012 17:12:56 EST
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1de0h1202h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1155h)
X-WSS-ID: 0MDLOZJ-02-0CE-02
X-M-MSG: 
Date: Fri, 16 Nov 2012 15:57:18 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: Robert Richter <rric@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf, amd: Enable northbridge performance counters
 on AMD family 15h
Message-ID: <20121116215718.GB21468@jshin-Toonie>
References: <1353015113-13262-1-git-send-email-jacob.shin@amd.com>
 <1353015113-13262-5-git-send-email-jacob.shin@amd.com>
 <20121116184344.GR2504@rric.localhost>
 <20121116190030.GA21468@jshin-Toonie>
 <20121116193224.GS2504@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121116193224.GS2504@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 08:32:24PM +0100, Robert Richter wrote:
> On 16.11.12 13:00:30, Jacob Shin wrote:
> > On Fri, Nov 16, 2012 at 07:43:44PM +0100, Robert Richter wrote:
> > > On 15.11.12 15:31:53, Jacob Shin wrote:
> > > > @@ -156,31 +161,28 @@ static inline int amd_pmu_addr_offset(int index)
> > > >  	if (offset)
> > > >  		return offset;
> > > >  
> > > > -	if (!cpu_has_perfctr_core)
> > > > +	if (!cpu_has_perfctr_core) {
> > > >  		offset = index;
> > > > -	else
> > > > +		ncore = AMD64_NUM_COUNTERS;
> > > > +	} else {
> 
> First calculation:
> 
> > > >  		offset = index << 1;
> > > > +		ncore = AMD64_NUM_COUNTERS_CORE;
> > > > +	}
> > > > +
> > > > +	/* find offset of NB counters with respect to x86_pmu.eventsel */
> > > > +	if (cpu_has_perfctr_nb) {
> > > > +		if (index >= ncore && index < (ncore + AMD64_NUM_COUNTERS_NB))
> 
> Second calculation:
> 
> > > > +			offset = (MSR_F15H_NB_PERF_CTL - x86_pmu.eventsel) +
> > > > +				 ((index - ncore) << 1);
> > > > +	}
> > > 
> > > There is duplicate calculatoin of offset in some cases. Better we
> > > avoid this.
> > 
> > Which cases? The code calculates the offset for a given index the very
> > first time it is called, stores it, and uses that stored offset from
> > then on. My [PATCH 3/4] sets that up.
> 
> One case above.
> 
> It looks like the paths should be defined more clearly.

Per comments above the function, I was logically going down the cases,
1. is this a legacy counter?
2. is this a perfctr_core counter?
3. is this a perfctr_nb counter?

To me it seems clear ..

> 
> > > > @@ -323,6 +368,16 @@ __amd_get_nb_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *ev
> > > >  	if (new == -1)
> > > >  		return &emptyconstraint;
> > > >  
> > > > +	/* set up interrupts to be delivered only to this core */
> > > > +	if (cpu_has_perfctr_nb) {
> > > > +		struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> > > > +
> > > > +		hwc->config |= AMD_PERFMON_EVENTSEL_INT_CORE_ENABLE;
> > > > +		hwc->config &= ~AMD_PERFMON_EVENTSEL_INT_CORE_SEL_MASK;
> > > > +		hwc->config |= (0ULL | (c->cpu_core_id)) <<
> > > > +			AMD_PERFMON_EVENTSEL_INT_CORE_SEL_SHIFT;
> > > > +	}
> > > 
> > > Looks like a hack to me. The constaints handler is only supposed to
> > > determine constraints and not to touch anything in the event's
> > > structure. This should be done later when setting up hwc->config in
> > > amd_nb_event_config() or so.
> > 
> > Hm.. is the hwc->config called after constraints have been set up
> > already? If so, I'll change it ..
> 
> Should be, since the hw register can be setup only after the counter
> is selected.
> 
> > 
> > > 
> > > I also do not think that smp_processor_id() is the right thing to do
> > > here. Since cpu_hw_events is per-cpu the cpu is already selected.
> > 
> > Yeah, I could not figure out how to get the cpu number from cpuc. Is
> > there a container_of kind of thing that I can do to get the cpu number
> > ?
> 
> At some point event->cpu is assigned, I think.

Great, thanks for this hint!

So here is v3, how does this look? If okay, could you add Reviewed-by or
Acked-by ? After that, I'll send out the patchbomb again with review/ack
on patch [3/4] and [4/4]

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 8c297aa..b05c722 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -167,6 +167,7 @@
 #define X86_FEATURE_TBM		(6*32+21) /* trailing bit manipulations */
 #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
 #define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
+#define X86_FEATURE_PERFCTR_NB  (6*32+24) /* core performance counter extensions */
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
@@ -308,6 +309,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
 #define cpu_has_perfctr_core	boot_cpu_has(X86_FEATURE_PERFCTR_CORE)
+#define cpu_has_perfctr_nb	boot_cpu_has(X86_FEATURE_PERFCTR_NB)
 #define cpu_has_cx8		boot_cpu_has(X86_FEATURE_CX8)
 #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
 #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 7f0edce..e67ff1e 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -157,6 +157,8 @@
 /* Fam 15h MSRs */
 #define MSR_F15H_PERF_CTL		0xc0010200
 #define MSR_F15H_PERF_CTR		0xc0010201
+#define MSR_F15H_NB_PERF_CTL		0xc0010240
+#define MSR_F15H_NB_PERF_CTR		0xc0010241
 
 /* Fam 10h MSRs */
 #define MSR_FAM10H_MMIO_CONF_BASE	0xc0010058
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 4fabcdf..df97186 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -29,9 +29,14 @@
 #define ARCH_PERFMON_EVENTSEL_INV			(1ULL << 23)
 #define ARCH_PERFMON_EVENTSEL_CMASK			0xFF000000ULL
 
+#define AMD_PERFMON_EVENTSEL_INT_CORE_ENABLE		(1ULL << 36)
 #define AMD_PERFMON_EVENTSEL_GUESTONLY			(1ULL << 40)
 #define AMD_PERFMON_EVENTSEL_HOSTONLY			(1ULL << 41)
 
+#define AMD_PERFMON_EVENTSEL_INT_CORE_SEL_SHIFT		37
+#define AMD_PERFMON_EVENTSEL_INT_CORE_SEL_MASK		\
+	(0xFULL << AMD_PERFMON_EVENTSEL_INT_CORE_SEL_SHIFT)
+
 #define AMD64_EVENTSEL_EVENT	\
 	(ARCH_PERFMON_EVENTSEL_EVENT | (0x0FULL << 32))
 #define INTEL_ARCH_EVENT_MASK	\
@@ -46,8 +51,12 @@
 #define AMD64_RAW_EVENT_MASK		\
 	(X86_RAW_EVENT_MASK          |  \
 	 AMD64_EVENTSEL_EVENT)
+#define AMD64_NB_EVENT_MASK		\
+	(AMD64_EVENTSEL_EVENT        |  \
+	 ARCH_PERFMON_EVENTSEL_UMASK)
 #define AMD64_NUM_COUNTERS				4
 #define AMD64_NUM_COUNTERS_CORE				6
+#define AMD64_NUM_COUNTERS_NB				4
 
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		0x3c
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index d6e3337..80ad803 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -132,6 +132,8 @@ static u64 amd_pmu_event_map(int hw_event)
 	return amd_perfmon_event_map[hw_event];
 }
 
+static struct event_constraint *amd_nb_event_constraint;
+
 /*
  * Previously calculated offsets
  */
@@ -143,10 +145,15 @@ static unsigned int addr_offsets[X86_PMC_IDX_MAX] __read_mostly;
  *
  * CPUs with core performance counter extensions:
  *   6 counters starting at 0xc0010200 each offset by 2
+ *
+ * CPUs with north bridge performance counter extensions:
+ *   4 additional counters starting at 0xc0010240 each offset by 2
+ *   (indexed right above either one of the above core counters)
  */
 static inline int amd_pmu_addr_offset(int index)
 {
 	int offset;
+	int ncore;
 
 	if (!index)
 		return index;
@@ -156,31 +163,27 @@ static inline int amd_pmu_addr_offset(int index)
 	if (offset)
 		return offset;
 
-	if (!cpu_has_perfctr_core)
+	if (!cpu_has_perfctr_core) {
 		offset = index;
-	else
+		ncore = AMD64_NUM_COUNTERS;
+	} else {
 		offset = index << 1;
+		ncore = AMD64_NUM_COUNTERS_CORE;
+	}
+
+	/* find offset of NB counters with respect to x86_pmu.eventsel */
+	if (amd_nb_event_constraint &&
+	    test_bit(index, amd_nb_event_constraint->idxmsk))
+		offset = (MSR_F15H_NB_PERF_CTL - x86_pmu.eventsel) +
+			 ((index - ncore) << 1);
 
 	addr_offsets[index] = offset;
 
 	return offset;
 }
 
-static int amd_pmu_hw_config(struct perf_event *event)
+static int __amd_core_hw_config(struct perf_event *event)
 {
-	int ret;
-
-	/* pass precise event sampling to ibs: */
-	if (event->attr.precise_ip && get_ibs_caps())
-		return -ENOENT;
-
-	ret = x86_pmu_hw_config(event);
-	if (ret)
-		return ret;
-
-	if (has_branch_stack(event))
-		return -EOPNOTSUPP;
-
 	if (event->attr.exclude_host && event->attr.exclude_guest)
 		/*
 		 * When HO == GO == 1 the hardware treats that as GO == HO == 0
@@ -194,10 +197,41 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	else if (event->attr.exclude_guest)
 		event->hw.config |= AMD_PERFMON_EVENTSEL_HOSTONLY;
 
-	if (event->attr.type != PERF_TYPE_RAW)
-		return 0;
+	return 0;
+}
+
+/*
+ * NB counters do not support the following event select bits:
+ *   Host/Guest only
+ *   Counter mask
+ *   Invert counter mask
+ *   Edge detect
+ *   OS/User mode
+ */
+static int __amd_nb_hw_config(struct perf_event *event)
+{
+	if (event->attr.exclude_user || event->attr.exclude_kernel ||
+	    event->attr.exclude_host || event->attr.exclude_guest)
+		return -EINVAL;
+
+	/* set up interrupts to be delivered only to this core */
+	if (cpu_has_perfctr_nb) {
+		struct cpuinfo_x86 *c = &cpu_data(event->cpu);
+
+		event->hw.config |= AMD_PERFMON_EVENTSEL_INT_CORE_ENABLE;
+		event->hw.config &= ~AMD_PERFMON_EVENTSEL_INT_CORE_SEL_MASK;
+		event->hw.config |= (0ULL | (c->cpu_core_id)) <<
+			AMD_PERFMON_EVENTSEL_INT_CORE_SEL_SHIFT;
+	}
+
+	event->hw.config &= ~(ARCH_PERFMON_EVENTSEL_USR |
+			      ARCH_PERFMON_EVENTSEL_OS);
 
-	event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
+	if (event->hw.config & ~(AMD64_NB_EVENT_MASK                  |
+				 ARCH_PERFMON_EVENTSEL_INT            |
+				 AMD_PERFMON_EVENTSEL_INT_CORE_ENABLE |
+				 AMD_PERFMON_EVENTSEL_INT_CORE_SEL_MASK))
+		return -EINVAL;
 
 	return 0;
 }
@@ -215,6 +249,11 @@ static inline int amd_is_nb_event(struct hw_perf_event *hwc)
 	return (hwc->config & 0xe0) == 0xe0;
 }
 
+static inline int amd_is_perfctr_nb_event(struct hw_perf_event *hwc)
+{
+	return amd_nb_event_constraint && amd_is_nb_event(hwc);
+}
+
 static inline int amd_has_nb(struct cpu_hw_events *cpuc)
 {
 	struct amd_nb *nb = cpuc->amd_nb;
@@ -222,6 +261,30 @@ static inline int amd_has_nb(struct cpu_hw_events *cpuc)
 	return nb && nb->nb_id != -1;
 }
 
+static int amd_pmu_hw_config(struct perf_event *event)
+{
+	int ret;
+
+	/* pass precise event sampling to ibs: */
+	if (event->attr.precise_ip && get_ibs_caps())
+		return -ENOENT;
+
+	if (has_branch_stack(event))
+		return -EOPNOTSUPP;
+
+	ret = x86_pmu_hw_config(event);
+	if (ret)
+		return ret;
+
+	if (event->attr.type == PERF_TYPE_RAW)
+		event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
+
+	if (amd_is_perfctr_nb_event(&event->hw))
+		return __amd_nb_hw_config(event);
+
+	return __amd_core_hw_config(event);
+}
+
 static void __amd_put_nb_event_constraints(struct cpu_hw_events *cpuc,
 					   struct perf_event *event)
 {
@@ -422,7 +485,10 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	if (!(amd_has_nb(cpuc) && amd_is_nb_event(&event->hw)))
 		return &unconstrained;
 
-	return __amd_get_nb_event_constraints(cpuc, event, &unconstrained);
+	return __amd_get_nb_event_constraints(cpuc, event,
+					      amd_nb_event_constraint ? 
+					      amd_nb_event_constraint :
+					      &unconstrained);
 }
 
 static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
@@ -521,6 +587,9 @@ static struct event_constraint amd_f15_PMC30 = EVENT_CONSTRAINT_OVERLAP(0, 0x09,
 static struct event_constraint amd_f15_PMC50 = EVENT_CONSTRAINT(0, 0x3F, 0);
 static struct event_constraint amd_f15_PMC53 = EVENT_CONSTRAINT(0, 0x38, 0);
 
+static struct event_constraint amd_NBPMC96 = EVENT_CONSTRAINT(0, 0x3C0, 0);
+static struct event_constraint amd_NBPMC74 = EVENT_CONSTRAINT(0, 0xF0, 0);
+
 static struct event_constraint *
 amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
@@ -586,8 +655,11 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *ev
 			return &amd_f15_PMC20;
 		}
 	case AMD_EVENT_NB:
-		/* not yet implemented */
-		return &emptyconstraint;
+		if (cpuc->is_fake)
+			return amd_nb_event_constraint;
+
+		return __amd_get_nb_event_constraints(cpuc, event,
+						      amd_nb_event_constraint);
 	default:
 		return &emptyconstraint;
 	}
@@ -625,7 +697,7 @@ static __initconst const struct x86_pmu amd_pmu = {
 
 static int setup_event_constraints(void)
 {
-	if (boot_cpu_data.x86 >= 0x15)
+	if (boot_cpu_data.x86 == 0x15)
 		x86_pmu.get_event_constraints = amd_get_event_constraints_f15h;
 	return 0;
 }
@@ -655,6 +727,23 @@ static int setup_perfctr_core(void)
 	return 0;
 }
 
+static int setup_perfctr_nb(void)
+{
+	if (!cpu_has_perfctr_nb)
+		return -ENODEV;
+
+	x86_pmu.num_counters += AMD64_NUM_COUNTERS_NB;
+
+	if (cpu_has_perfctr_core)
+		amd_nb_event_constraint = &amd_NBPMC96;
+	else
+		amd_nb_event_constraint = &amd_NBPMC74;
+
+	printk(KERN_INFO "perf: AMD northbridge performance counters detected\n");
+
+	return 0;
+}
+
 __init int amd_pmu_init(void)
 {
 	/* Performance-monitoring supported from K7 and later: */
@@ -665,6 +754,7 @@ __init int amd_pmu_init(void)
 
 	setup_event_constraints();
 	setup_perfctr_core();
+	setup_perfctr_nb();
 
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,

