Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab0EQU2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 16:28:21 -0400
Received: from www.tglx.de ([62.245.132.106]:42989 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab0EQU2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 16:28:19 -0400
Date: Mon, 17 May 2010 22:27:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 2/2] x86/mrst: add more timer config options
In-Reply-To: <1274124183-23431-3-git-send-email-jacob.jun.pan@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1005172138170.3368@localhost.localdomain>
References: <1274124183-23431-1-git-send-email-jacob.jun.pan@linux.intel.com> <1274124183-23431-3-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010, Jacob Pan wrote:

> diff --git a/arch/x86/include/asm/apb_timer.h b/arch/x86/include/asm/apb_timer.h
> index c74a2ee..4127fd1 100644
> --- a/arch/x86/include/asm/apb_timer.h
> +++ b/arch/x86/include/asm/apb_timer.h
> @@ -55,7 +55,7 @@ extern unsigned long apbt_quick_calibrate(void);
>  extern int arch_setup_apbt_irqs(int irq, int trigger, int mask, int cpu);
>  extern void apbt_setup_secondary_clock(void);
>  extern unsigned int boot_cpu_id;
> -extern int disable_apbt_percpu;
> +extern int mrst_timer_options;

  Please remove this, it belongs to and is in mrst.h

>  #ifdef CONFIG_SMP
> @@ -204,9 +203,9 @@ static inline int __init setup_x86_mrst_timer(char *arg)
>  		return -EINVAL;
>  
>  	if (strcmp("apbt_only", arg) == 0)
> -		disable_apbt_percpu = 0;
> +		mrst_timer_options = MRST_TIMER_APBT_ONLY;
>  	else if (strcmp("lapic_and_apbt", arg) == 0)
> -		disable_apbt_percpu = 1;
> +		mrst_timer_options = MRST_TIMER_LAPIC_APBT;
>  	else {
>  		pr_warning("X86 MRST timer option %s not recognised"
>  			   " use x86_mrst_timer=apbt_only or lapic_and_apbt\n",

  Please move that to msrt.c It's not apbt specific. We parse the
  options where we have the variable.

>  static void __init mrst_setup_boot_clock(void)
>  {
> -	pr_info("%s: per cpu apbt flag %d \n", __func__, disable_apbt_percpu);
> -	if (disable_apbt_percpu)
> +	switch (mrst_timer_options) {
> +	case MRST_TIMER_APBT_ONLY:
> +		break;
> +	case MRST_TIMER_LAPIC_APBT:
>  		setup_boot_APIC_clock();
> +		break;
> +	default:
> +		/* check if this is Penwell */
> +		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARAT))
> +			setup_boot_APIC_clock();
> +		break;
> +	}
>  };

Did you notice that you are copying these checks all over the place ?

The first call into that code is mrst_time_init(), right ? So why not
check there and setup the function pointers once ?

void __init mrst_time_init(void)
{
	switch (mrst_timer_options) {
	case MRST_TIMER_APBT_ONLY:
		break;

	default:
		if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARAT))
		   	break;

		x86_init.timers.timer_init = x86_init_noop;

	case MRST_TIMER_LAPIC_APBT:
		x86_init.timers.setup_percpu_clockev = setup_boot_APIC_clock;
		x86_cpuinit.setup_percpu_clockev = setup_secondary_APIC_clock;
		return;
	}

        sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
	....

and change the code in x86_mrst_early_setup()

-   	 x86_init.timers.setup_percpu_clockev = mrst_setup_boot_clock;
+   	 x86_init.timers.setup_percpu_clockev = x86_init_noop;

-        x86_cpuinit.setup_percpu_clockev = mrst_setup_secondary_clock;
+        x86_cpuinit.setup_percpu_clockev = apbt_setup_secondary_clock;

So this makes everything default to apbt and in case of lapic selected
by command line or cpu type you switch everything over in one place.

That removes mrst_setup_boot_clock and mrst_setup_secondary_clock
along with all the duplicated code.

Thanks,

	tglx
