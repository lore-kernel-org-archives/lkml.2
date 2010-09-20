Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab0ITXeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 19:34:11 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:10675 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752665Ab0ITXeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 19:34:10 -0400
Subject: Re: [PATCH] x86,apic: V2 Add apic calibration hook.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1009202343440.2416@localhost6.localdomain6>
References: <1285017425.9954.10.camel@ank32.eng.vmware.com>
	 <alpine.LFD.2.00.1009202343440.2416@localhost6.localdomain6>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 20 Sep 2010 16:34:10 -0700
Message-Id: <1285025650.9954.43.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thanks for taking a look. Please find my replies below.

On Mon, 2010-09-20 at 15:11 -0700, Thomas Gleixner wrote:
> On Mon, 20 Sep 2010, Alok Kataria wrote:
> > diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> > index 1fa03e0..5012ee5 100644
> > --- a/arch/x86/include/asm/apic.h
> > +++ b/arch/x86/include/asm/apic.h
> > @@ -17,6 +17,10 @@
> >  
> >  #define ARCH_APICTIMER_STOPS_ON_C3	1
> >  
> > +/* Clock divisor */
> > +#define APIC_DIVISOR	16
> > +#define LAPIC_CAL_LOOPS	(HZ/10)
> > +
> 
>   What's the point of this ? Oh wait, I see. Instead of fixing the
>   apic code to use some useful units for the calibration value, you
>   make those constants global and twiddle the (hopefully sane) return
>   value of your hypervirus call.

Those constants are used just to calculate the delta value which is used
to print useful debug information, which is more useful in the native
calibration case. The calibration_result value that is used as the
apic_freq equivalent is still sane and what the hypervisor returned.

> 
> >  /*
> >   * Debugging macros
> >   */
> > @@ -238,6 +242,8 @@ extern void setup_boot_APIC_clock(void);
> >  extern void setup_secondary_APIC_clock(void);
> >  extern int APIC_init_uniprocessor(void);
> >  extern void enable_NMI_through_LVT0(void);
> > +extern int native_calibrate_apic(void);
> > +extern int initialize_lapic(long delta, unsigned int calibration_result);
> 
>   Interesting, That function is initializing the local apic? Hmm, the
>   code below makes me think it's about the local apic timer.

Yes it is initializing the local apic clockevent (timer), will call it
as initialize_lapic_timer then.

> 
> >  
> >  /*
> >   * On 32bit this is mach-xxx local
> > diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
> > index baa579c..58f982b 100644
> > --- a/arch/x86/include/asm/x86_init.h
> > +++ b/arch/x86/include/asm/x86_init.h
> > @@ -83,11 +83,13 @@ struct x86_init_paging {
> >   *				boot cpu
> >   * @tsc_pre_init:		platform function called before TSC init
> >   * @timer_init:			initialize the platform timer (default PIT/HPET)
> > + * @calibrate_apic:		calibrate APIC bus freq (ticks per HZ)
> 
>   This is not calibrating the APIC, it's calibrating the APIC timer,
>   right ?
Right, the fact that the function pointer resided in x86_init.timers
structure, made me think it would be less confusing, but I agree its
better to be explicit, calibrate_apic_clock ?

> 
>   AFAICT, you also override the TSC calibration, right? 
> 
>   I wonder whether we could finally avoid the duplicate calibration
>   stuff and do the TSC and the lapic together and avoid the second
>   calibration loop.

Hmm, not sure how well will the apic calibration fit with all the fast
TSC calibration stuff for the native case.

> 
> >   */
> >  struct x86_init_timers {
> >  	void (*setup_percpu_clockev)(void);
> >  	void (*tsc_pre_init)(void);
> >  	void (*timer_init)(void);
> > +	int (*calibrate_apic)(void);
> >  };
> >  
> >  /**
> > diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> > index e3b534c..ca5d084 100644
> > --- a/arch/x86/kernel/apic/apic.c
> > +++ b/arch/x86/kernel/apic/apic.c
> > @@ -176,7 +176,7 @@ static struct resource lapic_resource = {
> >  	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
> >  };
> >  
> > -static unsigned int calibration_result;
> > +static unsigned int apic_calibration_res;
> 
>   calibration_result is not the best choice, but please split out this
>   cosmetic change into a separate patch. The patch probaly wants some
>   more splitup for sanity and bisectability reasons./

I can split-up the change in 2 parts, the first change can be just the
normal cleanup for the native calibration case, and in the second one I
could introduce the apic calibration hook. Below in the mail is the
first (preparatory) patch.

> 
> >  
> >  static int lapic_next_event(unsigned long delta,
> >  			    struct clock_event_device *evt);
> > @@ -326,13 +326,6 @@ int lapic_get_maxlvt(void)
> >  }
> >  
> >  /*
> > - * Local APIC timer
> > - */
> > -
> > -/* Clock divisor */
> > -#define APIC_DIVISOR 16
> > -
> > -/*
> >   * This function sets up the local APIC timer, with a timeout of
> >   * 'clocks' APIC bus clock. During calibration we actually call
> >   * this function twice on the boot CPU, once with a bogus timeout
> > @@ -431,7 +424,7 @@ static void lapic_timer_setup(enum clock_event_mode mode,
> >  	switch (mode) {
> >  	case CLOCK_EVT_MODE_PERIODIC:
> >  	case CLOCK_EVT_MODE_ONESHOT:
> > -		__setup_APIC_LVTT(calibration_result,
> > +		__setup_APIC_LVTT(apic_calibration_res,
> >  				  mode != CLOCK_EVT_MODE_PERIODIC, 1);
> >  		break;
> >  	case CLOCK_EVT_MODE_UNUSED:
> > @@ -500,8 +493,6 @@ static void __cpuinit setup_APIC_timer(void)
> >   * back to normal later in the boot process).
> >   */
> >  
> > -#define LAPIC_CAL_LOOPS		(HZ/10)
> > -
> >  static __initdata int lapic_cal_loops = -1;
> >  static __initdata long lapic_cal_t1, lapic_cal_t2;
> >  static __initdata unsigned long long lapic_cal_tsc1, lapic_cal_tsc2;
> > @@ -590,13 +581,50 @@ calibrate_by_pmtimer(long deltapm, long *delta, long *deltatsc)
> >  	return 0;
> >  }
> >  
> > -static int __init calibrate_APIC_clock(void)
> > +int __init initialize_lapic(long delta, unsigned int calibration_result)
> 
>   See above
> 
> > +{
> > +	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
> > +
> > +	/* Calculate the scaled math multiplication factor */
> > +	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
> > +				       lapic_clockevent.shift);
> > +	lapic_clockevent.max_delta_ns =
> > +		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
> > +	lapic_clockevent.min_delta_ns =
> > +		clockevent_delta2ns(0xF, &lapic_clockevent);
> > +
> > +	apic_calibration_res = calibration_result;
> > +
> > +	apic_printk(APIC_VERBOSE, "..... delta %ld\n", delta);
> > +	apic_printk(APIC_VERBOSE, "..... mult: %u\n", lapic_clockevent.mult);
> > +	apic_printk(APIC_VERBOSE, "..... calibration result: %u\n",
> > +		    calibration_result);
> > +
> > +	apic_printk(APIC_VERBOSE, "..... host bus clock speed is "
> > +		    "%u.%04u MHz.\n",
> > +		    calibration_result / (1000000 / HZ),
> > +		    calibration_result % (1000000 / HZ));
> > +
> > +	/*
> > +	 * Do a sanity check on the APIC calibration result
> > +	 */
> > +	if (calibration_result < (1000000 / HZ)) {
> > +		pr_warning("APIC frequency too slow, disabling apic timer\n");
> > +		return -1;
> > +	}
> > +
> > +	levt->features &= ~CLOCK_EVT_FEAT_DUMMY;
> > +	return 0;
> > +}
> > +
> > +int __init native_calibrate_apic(void)
> >  {
> >  	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
> >  	void (*real_handler)(struct clock_event_device *dev);
> >  	unsigned long deltaj;
> >  	long delta, deltatsc;
> >  	int pm_referenced = 0;
> > +	unsigned int calibration_result;
> >  
> >  	local_irq_disable();
> >  
> > @@ -631,20 +659,12 @@ static int __init calibrate_APIC_clock(void)
> >  	pm_referenced = !calibrate_by_pmtimer(lapic_cal_pm2 - lapic_cal_pm1,
> >  					&delta, &deltatsc);
> >  
> > -	/* Calculate the scaled math multiplication factor */
> > -	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
> > -				       lapic_clockevent.shift);
> > -	lapic_clockevent.max_delta_ns =
> > -		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
> > -	lapic_clockevent.min_delta_ns =
> > -		clockevent_delta2ns(0xF, &lapic_clockevent);
> > -
> >  	calibration_result = (delta * APIC_DIVISOR) / LAPIC_CAL_LOOPS;
> >  
> > -	apic_printk(APIC_VERBOSE, "..... delta %ld\n", delta);
> > -	apic_printk(APIC_VERBOSE, "..... mult: %u\n", lapic_clockevent.mult);
> > -	apic_printk(APIC_VERBOSE, "..... calibration result: %u\n",
> > -		    calibration_result);
> > +	if (initialize_lapic(delta, calibration_result)) {
> > +		local_irq_enable();
> > +		return -1;
> > +	}
> >  
> >  	if (cpu_has_tsc) {
> >  		apic_printk(APIC_VERBOSE, "..... CPU clock speed is "
> > @@ -653,22 +673,6 @@ static int __init calibrate_APIC_clock(void)
> >  			    (deltatsc / LAPIC_CAL_LOOPS) % (1000000 / HZ));
> >  	}
> >  
> > -	apic_printk(APIC_VERBOSE, "..... host bus clock speed is "
> > -		    "%u.%04u MHz.\n",
> > -		    calibration_result / (1000000 / HZ),
> > -		    calibration_result % (1000000 / HZ));
> > -
> > -	/*
> > -	 * Do a sanity check on the APIC calibration result
> > -	 */
> > -	if (calibration_result < (1000000 / HZ)) {
> > -		local_irq_enable();
> > -		pr_warning("APIC frequency too slow, disabling apic timer\n");
> > -		return -1;
> > -	}
> > -
> > -	levt->features &= ~CLOCK_EVT_FEAT_DUMMY;
> > -
> >  	/*
> >  	 * PM timer calibration failed or not turned on
> >  	 * so lets try APIC timer based calibration
> > @@ -706,7 +710,7 @@ static int __init calibrate_APIC_clock(void)
> >  
> >  	if (levt->features & CLOCK_EVT_FEAT_DUMMY) {
> >  		pr_warning("APIC timer disabled due to verification failure\n");
> > -			return -1;
> > +		return -1;
> >  	}
> >  
> >  	return 0;
> > @@ -738,7 +742,7 @@ void __init setup_boot_APIC_clock(void)
> >  	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n"
> >  		    "calibrating APIC timer ...\n");
> >  
> > -	if (calibrate_APIC_clock()) {
> > +	if (x86_init.timers.calibrate_apic()) {
> >  		/* No broadcast on UP ! */
> >  		if (num_possible_cpus() > 1)
> >  			setup_APIC_timer();
> > diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
> > index 227b044..e8b760e 100644
> > --- a/arch/x86/kernel/cpu/vmware.c
> > +++ b/arch/x86/kernel/cpu/vmware.c
> > @@ -26,6 +26,7 @@
> >  #include <asm/div64.h>
> >  #include <asm/x86_init.h>
> >  #include <asm/hypervisor.h>
> > +#include <asm/apic.h>
> >  
> >  #define CPUID_VMWARE_INFO_LEAF	0x40000000
> >  #define VMWARE_HYPERVISOR_MAGIC	0x564D5868
> > @@ -72,17 +73,40 @@ static unsigned long vmware_get_tsc_khz(void)
> >  	return tsc_hz;
> >  }
> >  
> > +static int __init vmware_calibrate_apic(void)
> > +{
> > +	unsigned int calibration_result;
> > +	uint32_t eax, ebx, ecx, edx;
> > +	int err;
> > +	long delta;
> > +	unsigned long flags;
> > +
> > +	VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
> > +	BUG_ON(!ecx);
> > +	calibration_result = ecx / HZ;
> > +
> > +	printk(KERN_INFO "APIC bus freq read from hypervisor\n");
> > +
> > +	delta  = (calibration_result * LAPIC_CAL_LOOPS) / APIC_DIVISOR;
> 
>   Sigh.
> 
> > +	local_irq_save(flags);
> > +	err = initialize_lapic(delta, calibration_result);
> 
>   Crap. You're function override is about calibration and not about
>   initializing. Why are you calling that here. 

The original calibrate_APIC_clock itself does a lot initializing so I
still have to do this, to maintain consistency between both the native
function and the vmware one. I could have split the initialization out
of this hook to be done after the calibration is done, but in the native
case the "APIC timer based verification" method relies on the
calibration_result value to be already set. Hence this initialization
still needs to be part of the hook.

> Either you override the
>   local apic timer setup completely or just the calibration routine.

We still want to go through the local_apic timer setup so overriding
that would mean a lot of duplicate code. 

Below is the preparatory change, will followup with the 2nd patch which
introduces the actual hook.
--
Preparatory change to add apic timer calibration hook.

From: Alok N Kataria <akataria@vmware.com>

This change moves some APIC timer calibration code to a seperate function
to facilitate adding a apic clock calibration hook. This change has no
functional effect on the calibration routine.

Signed-off-by: Alok N Kataria <akataria@vmware.com>

Index: linux-x86-tree.git/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/apic/apic.c	2010-09-20 13:45:40.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/apic/apic.c	2010-09-20 16:10:13.000000000 -0700
@@ -176,7 +176,7 @@ static struct resource lapic_resource = 
 	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
 };
 
-static unsigned int calibration_result;
+static unsigned int apic_calibration_res;
 
 static int lapic_next_event(unsigned long delta,
 			    struct clock_event_device *evt);
@@ -431,7 +431,7 @@ static void lapic_timer_setup(enum clock
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 	case CLOCK_EVT_MODE_ONESHOT:
-		__setup_APIC_LVTT(calibration_result,
+		__setup_APIC_LVTT(apic_calibration_res,
 				  mode != CLOCK_EVT_MODE_PERIODIC, 1);
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
@@ -590,13 +590,50 @@ calibrate_by_pmtimer(long deltapm, long 
 	return 0;
 }
 
-static int __init calibrate_APIC_clock(void)
+int __init initialize_lapic_timer(long delta, unsigned int calibration_result)
+{
+	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
+
+	/* Calculate the scaled math multiplication factor */
+	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
+				       lapic_clockevent.shift);
+	lapic_clockevent.max_delta_ns =
+		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
+	lapic_clockevent.min_delta_ns =
+		clockevent_delta2ns(0xF, &lapic_clockevent);
+
+	apic_calibration_res = calibration_result;
+
+	apic_printk(APIC_VERBOSE, "..... delta %ld\n", delta);
+	apic_printk(APIC_VERBOSE, "..... mult: %u\n", lapic_clockevent.mult);
+	apic_printk(APIC_VERBOSE, "..... calibration result: %u\n",
+		    calibration_result);
+
+	apic_printk(APIC_VERBOSE, "..... host bus clock speed is "
+		    "%u.%04u MHz.\n",
+		    calibration_result / (1000000 / HZ),
+		    calibration_result % (1000000 / HZ));
+
+	/*
+	 * Do a sanity check on the APIC calibration result
+	 */
+	if (calibration_result < (1000000 / HZ)) {
+		pr_warning("APIC frequency too slow, disabling apic timer\n");
+		return -1;
+	}
+
+	levt->features &= ~CLOCK_EVT_FEAT_DUMMY;
+	return 0;
+}
+
+int __init native_calibrate_apic_clock(void)
 {
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 	void (*real_handler)(struct clock_event_device *dev);
 	unsigned long deltaj;
 	long delta, deltatsc;
 	int pm_referenced = 0;
+	unsigned int calibration_result;
 
 	local_irq_disable();
 
@@ -631,20 +668,12 @@ static int __init calibrate_APIC_clock(v
 	pm_referenced = !calibrate_by_pmtimer(lapic_cal_pm2 - lapic_cal_pm1,
 					&delta, &deltatsc);
 
-	/* Calculate the scaled math multiplication factor */
-	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
-				       lapic_clockevent.shift);
-	lapic_clockevent.max_delta_ns =
-		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
-	lapic_clockevent.min_delta_ns =
-		clockevent_delta2ns(0xF, &lapic_clockevent);
-
 	calibration_result = (delta * APIC_DIVISOR) / LAPIC_CAL_LOOPS;
 
-	apic_printk(APIC_VERBOSE, "..... delta %ld\n", delta);
-	apic_printk(APIC_VERBOSE, "..... mult: %u\n", lapic_clockevent.mult);
-	apic_printk(APIC_VERBOSE, "..... calibration result: %u\n",
-		    calibration_result);
+	if (initialize_lapic_timer(delta, calibration_result)) {
+		local_irq_enable();
+		return -1;
+	}
 
 	if (cpu_has_tsc) {
 		apic_printk(APIC_VERBOSE, "..... CPU clock speed is "
@@ -653,22 +682,6 @@ static int __init calibrate_APIC_clock(v
 			    (deltatsc / LAPIC_CAL_LOOPS) % (1000000 / HZ));
 	}
 
-	apic_printk(APIC_VERBOSE, "..... host bus clock speed is "
-		    "%u.%04u MHz.\n",
-		    calibration_result / (1000000 / HZ),
-		    calibration_result % (1000000 / HZ));
-
-	/*
-	 * Do a sanity check on the APIC calibration result
-	 */
-	if (calibration_result < (1000000 / HZ)) {
-		local_irq_enable();
-		pr_warning("APIC frequency too slow, disabling apic timer\n");
-		return -1;
-	}
-
-	levt->features &= ~CLOCK_EVT_FEAT_DUMMY;
-
 	/*
 	 * PM timer calibration failed or not turned on
 	 * so lets try APIC timer based calibration
@@ -706,7 +719,7 @@ static int __init calibrate_APIC_clock(v
 
 	if (levt->features & CLOCK_EVT_FEAT_DUMMY) {
 		pr_warning("APIC timer disabled due to verification failure\n");
-			return -1;
+		return -1;
 	}
 
 	return 0;
@@ -738,7 +751,7 @@ void __init setup_boot_APIC_clock(void)
 	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n"
 		    "calibrating APIC timer ...\n");
 
-	if (calibrate_APIC_clock()) {
+	if (native_calibrate_apic_clock()) {
 		/* No broadcast on UP ! */
 		if (num_possible_cpus() > 1)
 			setup_APIC_timer();


