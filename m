Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab0ITWLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 18:11:20 -0400
Received: from www.tglx.de ([62.245.132.106]:51702 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab0ITWLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 18:11:19 -0400
Date: Tue, 21 Sep 2010 00:11:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alok Kataria <akataria@vmware.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,apic: V2 Add apic calibration hook.
In-Reply-To: <1285017425.9954.10.camel@ank32.eng.vmware.com>
Message-ID: <alpine.LFD.2.00.1009202343440.2416@localhost6.localdomain6>
References: <1285017425.9954.10.camel@ank32.eng.vmware.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010, Alok Kataria wrote:
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index 1fa03e0..5012ee5 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -17,6 +17,10 @@
>  
>  #define ARCH_APICTIMER_STOPS_ON_C3	1
>  
> +/* Clock divisor */
> +#define APIC_DIVISOR	16
> +#define LAPIC_CAL_LOOPS	(HZ/10)
> +

  What's the point of this ? Oh wait, I see. Instead of fixing the
  apic code to use some useful units for the calibration value, you
  make those constants global and twiddle the (hopefully sane) return
  value of your hypervirus call.

>  /*
>   * Debugging macros
>   */
> @@ -238,6 +242,8 @@ extern void setup_boot_APIC_clock(void);
>  extern void setup_secondary_APIC_clock(void);
>  extern int APIC_init_uniprocessor(void);
>  extern void enable_NMI_through_LVT0(void);
> +extern int native_calibrate_apic(void);
> +extern int initialize_lapic(long delta, unsigned int calibration_result);

  Interesting, That function is initializing the local apic? Hmm, the
  code below makes me think it's about the local apic timer.

>  
>  /*
>   * On 32bit this is mach-xxx local
> diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
> index baa579c..58f982b 100644
> --- a/arch/x86/include/asm/x86_init.h
> +++ b/arch/x86/include/asm/x86_init.h
> @@ -83,11 +83,13 @@ struct x86_init_paging {
>   *				boot cpu
>   * @tsc_pre_init:		platform function called before TSC init
>   * @timer_init:			initialize the platform timer (default PIT/HPET)
> + * @calibrate_apic:		calibrate APIC bus freq (ticks per HZ)

  This is not calibrating the APIC, it's calibrating the APIC timer,
  right ?

  AFAICT, you also override the TSC calibration, right? 

  I wonder whether we could finally avoid the duplicate calibration
  stuff and do the TSC and the lapic together and avoid the second
  calibration loop.

>   */
>  struct x86_init_timers {
>  	void (*setup_percpu_clockev)(void);
>  	void (*tsc_pre_init)(void);
>  	void (*timer_init)(void);
> +	int (*calibrate_apic)(void);
>  };
>  
>  /**
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index e3b534c..ca5d084 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -176,7 +176,7 @@ static struct resource lapic_resource = {
>  	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
>  };
>  
> -static unsigned int calibration_result;
> +static unsigned int apic_calibration_res;

  calibration_result is not the best choice, but please split out this
  cosmetic change into a separate patch. The patch probaly wants some
  more splitup for sanity and bisectability reasons./

>  
>  static int lapic_next_event(unsigned long delta,
>  			    struct clock_event_device *evt);
> @@ -326,13 +326,6 @@ int lapic_get_maxlvt(void)
>  }
>  
>  /*
> - * Local APIC timer
> - */
> -
> -/* Clock divisor */
> -#define APIC_DIVISOR 16
> -
> -/*
>   * This function sets up the local APIC timer, with a timeout of
>   * 'clocks' APIC bus clock. During calibration we actually call
>   * this function twice on the boot CPU, once with a bogus timeout
> @@ -431,7 +424,7 @@ static void lapic_timer_setup(enum clock_event_mode mode,
>  	switch (mode) {
>  	case CLOCK_EVT_MODE_PERIODIC:
>  	case CLOCK_EVT_MODE_ONESHOT:
> -		__setup_APIC_LVTT(calibration_result,
> +		__setup_APIC_LVTT(apic_calibration_res,
>  				  mode != CLOCK_EVT_MODE_PERIODIC, 1);
>  		break;
>  	case CLOCK_EVT_MODE_UNUSED:
> @@ -500,8 +493,6 @@ static void __cpuinit setup_APIC_timer(void)
>   * back to normal later in the boot process).
>   */
>  
> -#define LAPIC_CAL_LOOPS		(HZ/10)
> -
>  static __initdata int lapic_cal_loops = -1;
>  static __initdata long lapic_cal_t1, lapic_cal_t2;
>  static __initdata unsigned long long lapic_cal_tsc1, lapic_cal_tsc2;
> @@ -590,13 +581,50 @@ calibrate_by_pmtimer(long deltapm, long *delta, long *deltatsc)
>  	return 0;
>  }
>  
> -static int __init calibrate_APIC_clock(void)
> +int __init initialize_lapic(long delta, unsigned int calibration_result)

  See above

> +{
> +	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
> +
> +	/* Calculate the scaled math multiplication factor */
> +	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
> +				       lapic_clockevent.shift);
> +	lapic_clockevent.max_delta_ns =
> +		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
> +	lapic_clockevent.min_delta_ns =
> +		clockevent_delta2ns(0xF, &lapic_clockevent);
> +
> +	apic_calibration_res = calibration_result;
> +
> +	apic_printk(APIC_VERBOSE, "..... delta %ld\n", delta);
> +	apic_printk(APIC_VERBOSE, "..... mult: %u\n", lapic_clockevent.mult);
> +	apic_printk(APIC_VERBOSE, "..... calibration result: %u\n",
> +		    calibration_result);
> +
> +	apic_printk(APIC_VERBOSE, "..... host bus clock speed is "
> +		    "%u.%04u MHz.\n",
> +		    calibration_result / (1000000 / HZ),
> +		    calibration_result % (1000000 / HZ));
> +
> +	/*
> +	 * Do a sanity check on the APIC calibration result
> +	 */
> +	if (calibration_result < (1000000 / HZ)) {
> +		pr_warning("APIC frequency too slow, disabling apic timer\n");
> +		return -1;
> +	}
> +
> +	levt->features &= ~CLOCK_EVT_FEAT_DUMMY;
> +	return 0;
> +}
> +
> +int __init native_calibrate_apic(void)
>  {
>  	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
>  	void (*real_handler)(struct clock_event_device *dev);
>  	unsigned long deltaj;
>  	long delta, deltatsc;
>  	int pm_referenced = 0;
> +	unsigned int calibration_result;
>  
>  	local_irq_disable();
>  
> @@ -631,20 +659,12 @@ static int __init calibrate_APIC_clock(void)
>  	pm_referenced = !calibrate_by_pmtimer(lapic_cal_pm2 - lapic_cal_pm1,
>  					&delta, &deltatsc);
>  
> -	/* Calculate the scaled math multiplication factor */
> -	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
> -				       lapic_clockevent.shift);
> -	lapic_clockevent.max_delta_ns =
> -		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
> -	lapic_clockevent.min_delta_ns =
> -		clockevent_delta2ns(0xF, &lapic_clockevent);
> -
>  	calibration_result = (delta * APIC_DIVISOR) / LAPIC_CAL_LOOPS;
>  
> -	apic_printk(APIC_VERBOSE, "..... delta %ld\n", delta);
> -	apic_printk(APIC_VERBOSE, "..... mult: %u\n", lapic_clockevent.mult);
> -	apic_printk(APIC_VERBOSE, "..... calibration result: %u\n",
> -		    calibration_result);
> +	if (initialize_lapic(delta, calibration_result)) {
> +		local_irq_enable();
> +		return -1;
> +	}
>  
>  	if (cpu_has_tsc) {
>  		apic_printk(APIC_VERBOSE, "..... CPU clock speed is "
> @@ -653,22 +673,6 @@ static int __init calibrate_APIC_clock(void)
>  			    (deltatsc / LAPIC_CAL_LOOPS) % (1000000 / HZ));
>  	}
>  
> -	apic_printk(APIC_VERBOSE, "..... host bus clock speed is "
> -		    "%u.%04u MHz.\n",
> -		    calibration_result / (1000000 / HZ),
> -		    calibration_result % (1000000 / HZ));
> -
> -	/*
> -	 * Do a sanity check on the APIC calibration result
> -	 */
> -	if (calibration_result < (1000000 / HZ)) {
> -		local_irq_enable();
> -		pr_warning("APIC frequency too slow, disabling apic timer\n");
> -		return -1;
> -	}
> -
> -	levt->features &= ~CLOCK_EVT_FEAT_DUMMY;
> -
>  	/*
>  	 * PM timer calibration failed or not turned on
>  	 * so lets try APIC timer based calibration
> @@ -706,7 +710,7 @@ static int __init calibrate_APIC_clock(void)
>  
>  	if (levt->features & CLOCK_EVT_FEAT_DUMMY) {
>  		pr_warning("APIC timer disabled due to verification failure\n");
> -			return -1;
> +		return -1;
>  	}
>  
>  	return 0;
> @@ -738,7 +742,7 @@ void __init setup_boot_APIC_clock(void)
>  	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n"
>  		    "calibrating APIC timer ...\n");
>  
> -	if (calibrate_APIC_clock()) {
> +	if (x86_init.timers.calibrate_apic()) {
>  		/* No broadcast on UP ! */
>  		if (num_possible_cpus() > 1)
>  			setup_APIC_timer();
> diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
> index 227b044..e8b760e 100644
> --- a/arch/x86/kernel/cpu/vmware.c
> +++ b/arch/x86/kernel/cpu/vmware.c
> @@ -26,6 +26,7 @@
>  #include <asm/div64.h>
>  #include <asm/x86_init.h>
>  #include <asm/hypervisor.h>
> +#include <asm/apic.h>
>  
>  #define CPUID_VMWARE_INFO_LEAF	0x40000000
>  #define VMWARE_HYPERVISOR_MAGIC	0x564D5868
> @@ -72,17 +73,40 @@ static unsigned long vmware_get_tsc_khz(void)
>  	return tsc_hz;
>  }
>  
> +static int __init vmware_calibrate_apic(void)
> +{
> +	unsigned int calibration_result;
> +	uint32_t eax, ebx, ecx, edx;
> +	int err;
> +	long delta;
> +	unsigned long flags;
> +
> +	VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
> +	BUG_ON(!ecx);
> +	calibration_result = ecx / HZ;
> +
> +	printk(KERN_INFO "APIC bus freq read from hypervisor\n");
> +
> +	delta  = (calibration_result * LAPIC_CAL_LOOPS) / APIC_DIVISOR;

  Sigh.

> +	local_irq_save(flags);
> +	err = initialize_lapic(delta, calibration_result);

  Crap. You're function override is about calibration and not about
  initializing. Why are you calling that here. Either you override the
  local apic timer setup completely or just the calibration routine.

Thanks,

	tglx
