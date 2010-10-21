Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab0JUTQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 15:16:45 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:60600 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755772Ab0JUTQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 15:16:44 -0400
Subject: Re: [PATCH 1/7] x86: Convert remaining clocksources to
	clocksource_register_hz/khz
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: John Stultz <johnstul@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "jacob.jun.pan@intel.com" <jacob.jun.pan@intel.com>,
        Glauber Costa <glommer@redhat.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris McDermott <lcm@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1287618253-13258-2-git-send-email-johnstul@us.ibm.com>
References: <1287618253-13258-1-git-send-email-johnstul@us.ibm.com>
	 <1287618253-13258-2-git-send-email-johnstul@us.ibm.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 21 Oct 2010 12:16:44 -0700
Message-Id: <1287688604.27008.16.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

vmiclock_32.c doesn't exist anymore in tip and pretty soon should
disappear from mainline too. 

Alok

On Wed, 2010-10-20 at 16:44 -0700, John Stultz wrote:
> This converts the remaining x86 clocksources to use
> clocksource_register_hz/khz. I was not able to test them, so
> any extra assistance to make sure time functions properly with
> the clocksources changeed here would be appreciated!
> 
> CC: jacob.jun.pan@intel.com
> CC: Glauber Costa <glommer@redhat.com>
> CC: Dimitri Sivanich <sivanich@sgi.com>
> CC: Alok N Kataria <akataria@vmware.com>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> CC: Jeremy Fitzhardinge <jeremy@xensource.com>
> CC: Chris McDermott <lcm@us.ibm.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> ---
>  arch/x86/kernel/apb_timer.c   |   10 +---------
>  arch/x86/kernel/i8253.c       |    6 +-----
>  arch/x86/kernel/kvmclock.c    |    6 +-----
>  arch/x86/kernel/uv_time.c     |    6 +-----
>  arch/x86/kernel/vmiclock_32.c |    9 +--------
>  arch/x86/lguest/boot.c        |    4 +---
>  arch/x86/xen/time.c           |    6 +-----
>  drivers/clocksource/cyclone.c |   10 ++--------
>  8 files changed, 9 insertions(+), 48 deletions(-)
> 
> diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
> index 8dd7780..c5ad23c 100644
> --- a/arch/x86/kernel/apb_timer.c
> +++ b/arch/x86/kernel/apb_timer.c
> @@ -177,7 +177,6 @@ static struct clocksource clocksource_apbt = {
>  	.rating		= APBT_CLOCKSOURCE_RATING,
>  	.read		= apbt_read_clocksource,
>  	.mask		= APBT_MASK,
> -	.shift		= APBT_SHIFT,
>  	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
>  	.resume		= apbt_restart_clocksource,
>  };
> @@ -598,14 +597,7 @@ static int apbt_clocksource_register(void)
>  	if (t1 == apbt_read_clocksource(&clocksource_apbt))
>  		panic("APBT counter not counting. APBT disabled\n");
>  
> -	/*
> -	 * initialize and register APBT clocksource
> -	 * convert that to ns/clock cycle
> -	 * mult = (ns/c) * 2^APBT_SHIFT
> -	 */
> -	clocksource_apbt.mult = div_sc(MSEC_PER_SEC,
> -				       (unsigned long) apbt_freq, APBT_SHIFT);
> -	clocksource_register(&clocksource_apbt);
> +	clocksource_register_khz(&clocksource_apbt,(u32)apbt_freq*1000);
>  
>  	return 0;
>  }
> diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
> index 2dfd315..212fe65 100644
> --- a/arch/x86/kernel/i8253.c
> +++ b/arch/x86/kernel/i8253.c
> @@ -188,8 +188,6 @@ static struct clocksource pit_cs = {
>  	.rating		= 110,
>  	.read		= pit_read,
>  	.mask		= CLOCKSOURCE_MASK(32),
> -	.mult		= 0,
> -	.shift		= 20,
>  };
>  
>  static int __init init_pit_clocksource(void)
> @@ -205,9 +203,7 @@ static int __init init_pit_clocksource(void)
>  	    pit_ce.mode != CLOCK_EVT_MODE_PERIODIC)
>  		return 0;
>  
> -	pit_cs.mult = clocksource_hz2mult(CLOCK_TICK_RATE, pit_cs.shift);
> -
> -	return clocksource_register(&pit_cs);
> +	return clocksource_register_hz(&pit_cs, CLOCK_TICK_RATE);
>  }
>  arch_initcall(init_pit_clocksource);
>  
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index eb9b76c..532fa9b 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -26,8 +26,6 @@
>  #include <asm/x86_init.h>
>  #include <asm/reboot.h>
>  
> -#define KVM_SCALE 22
> -
>  static int kvmclock = 1;
>  static int msr_kvm_system_time = MSR_KVM_SYSTEM_TIME;
>  static int msr_kvm_wall_clock = MSR_KVM_WALL_CLOCK;
> @@ -120,8 +118,6 @@ static struct clocksource kvm_clock = {
>  	.read = kvm_clock_get_cycles,
>  	.rating = 400,
>  	.mask = CLOCKSOURCE_MASK(64),
> -	.mult = 1 << KVM_SCALE,
> -	.shift = KVM_SCALE,
>  	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
>  };
>  
> @@ -212,7 +208,7 @@ void __init kvmclock_init(void)
>  	machine_ops.crash_shutdown  = kvm_crash_shutdown;
>  #endif
>  	kvm_get_preset_lpj();
> -	clocksource_register(&kvm_clock);
> +	clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);
>  	pv_info.paravirt_enabled = 1;
>  	pv_info.name = "KVM";
>  
> diff --git a/arch/x86/kernel/uv_time.c b/arch/x86/kernel/uv_time.c
> index 56e421b..6f86d74 100644
> --- a/arch/x86/kernel/uv_time.c
> +++ b/arch/x86/kernel/uv_time.c
> @@ -40,7 +40,6 @@ static struct clocksource clocksource_uv = {
>  	.rating		= 400,
>  	.read		= uv_read_rtc,
>  	.mask		= (cycle_t)UVH_RTC_REAL_TIME_CLOCK_MASK,
> -	.shift		= 10,
>  	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
>  };
>  
> @@ -370,14 +369,11 @@ static __init int uv_rtc_setup_clock(void)
>  	if (!is_uv_system())
>  		return -ENODEV;
>  
> -	clocksource_uv.mult = clocksource_hz2mult(sn_rtc_cycles_per_second,
> -				clocksource_uv.shift);
> -
>  	/* If single blade, prefer tsc */
>  	if (uv_num_possible_blades() == 1)
>  		clocksource_uv.rating = 250;
>  
> -	rc = clocksource_register(&clocksource_uv);
> +	rc = clocksource_register_hz(&clocksource_uv, sn_rtc_cycles_per_second);
>  	if (rc)
>  		printk(KERN_INFO "UV RTC clocksource failed rc %d\n", rc);
>  	else
> diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
> index 5e1ff66..e3401ec 100644
> --- a/arch/x86/kernel/vmiclock_32.c
> +++ b/arch/x86/kernel/vmiclock_32.c
> @@ -290,8 +290,6 @@ static struct clocksource clocksource_vmi = {
>  	.rating			= 450,
>  	.read			= read_real_cycles,
>  	.mask			= CLOCKSOURCE_MASK(64),
> -	.mult			= 0, /* to be set */
> -	.shift			= 22,
>  	.flags			= CLOCK_SOURCE_IS_CONTINUOUS,
>  };
>  
> @@ -305,13 +303,8 @@ static int __init init_vmi_clocksource(void)
>  	cycles_per_msec = vmi_timer_ops.get_cycle_frequency();
>  	(void)do_div(cycles_per_msec, 1000);
>  
> -	/* Note that clocksource.{mult, shift} converts in the opposite direction
> -	 * as clockevents.  */
> -	clocksource_vmi.mult = clocksource_khz2mult(cycles_per_msec,
> -						    clocksource_vmi.shift);
> -
>  	printk(KERN_WARNING "vmi: registering clock source khz=%lld\n", cycles_per_msec);
> -	return clocksource_register(&clocksource_vmi);
> +	return clocksource_register_khz(&clocksource_vmi, cycles_per_msec);
>  
>  }
>  module_init(init_vmi_clocksource);
> diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
> index 9d5f558..3f2fd65 100644
> --- a/arch/x86/lguest/boot.c
> +++ b/arch/x86/lguest/boot.c
> @@ -910,8 +910,6 @@ static struct clocksource lguest_clock = {
>  	.rating		= 200,
>  	.read		= lguest_clock_read,
>  	.mask		= CLOCKSOURCE_MASK(64),
> -	.mult		= 1 << 22,
> -	.shift		= 22,
>  	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
>  };
>  
> @@ -994,7 +992,7 @@ static void lguest_time_init(void)
>  	/* Set up the timer interrupt (0) to go to our simple timer routine */
>  	set_irq_handler(0, lguest_time_irq);
>  
> -	clocksource_register(&lguest_clock);
> +	clocksource_register_hz(&lguest_clock, NSEC_PER_SEC);
>  
>  	/* We can't set cpumask in the initializer: damn C limitations!  Set it
>  	 * here and register our timer device. */
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index b2bb5aa..ce02ef8 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -26,8 +26,6 @@
>  
>  #include "xen-ops.h"
>  
> -#define XEN_SHIFT 22
> -
>  /* Xen may fire a timer up to this many ns early */
>  #define TIMER_SLOP	100000
>  #define NS_PER_TICK	(1000000000LL / HZ)
> @@ -211,8 +209,6 @@ static struct clocksource xen_clocksource __read_mostly = {
>  	.rating = 400,
>  	.read = xen_clocksource_get_cycles,
>  	.mask = ~0,
> -	.mult = 1<<XEN_SHIFT,		/* time directly in nanoseconds */
> -	.shift = XEN_SHIFT,
>  	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
>  };
>  
> @@ -444,7 +440,7 @@ static __init void xen_time_init(void)
>  	int cpu = smp_processor_id();
>  	struct timespec tp;
>  
> -	clocksource_register(&xen_clocksource);
> +	clocksource_register_hz(&xen_clocksource, NSEC_PER_SEC);
>  
>  	if (HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL) == 0) {
>  		/* Successfully turned off 100Hz tick, so we have the
> diff --git a/drivers/clocksource/cyclone.c b/drivers/clocksource/cyclone.c
> index 64e528e..72f811f 100644
> --- a/drivers/clocksource/cyclone.c
> +++ b/drivers/clocksource/cyclone.c
> @@ -29,8 +29,6 @@ static struct clocksource clocksource_cyclone = {
>  	.rating		= 250,
>  	.read		= read_cyclone,
>  	.mask		= CYCLONE_TIMER_MASK,
> -	.mult		= 10,
> -	.shift		= 0,
>  	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
>  };
>  
> @@ -108,12 +106,8 @@ static int __init init_cyclone_clocksource(void)
>  	}
>  	cyclone_ptr = cyclone_timer;
>  
> -	/* sort out mult/shift values: */
> -	clocksource_cyclone.shift = 22;
> -	clocksource_cyclone.mult = clocksource_hz2mult(CYCLONE_TIMER_FREQ,
> -						clocksource_cyclone.shift);
> -
> -	return clocksource_register(&clocksource_cyclone);
> +	return clocksource_register_hz(&clocksource_cyclone,
> +					CYCLONE_TIMER_FREQ);
>  }
>  
>  arch_initcall(init_cyclone_clocksource);

