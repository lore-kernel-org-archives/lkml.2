Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab2BICsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 21:48:52 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46234 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab2BICsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 21:48:51 -0500
Date: Thu, 9 Feb 2012 10:48:26 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
        Venki Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] sched: generalize CONFIG_IRQ_TIME_ACCOUNTING for X86 and
 ARM
Message-ID: <20120209024826.GB26152@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1328705314-20978-1-git-send-email-dmitry.antipov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1328705314-20978-1-git-send-email-dmitry.antipov@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ing PeterZ.

On Wed, Feb 08, 2012 at 04:48:34AM -0800, Dmitry Antipov wrote:
> Generalize CONFIG_IRQ_TIME_ACCOUNTING  between X86 and
> ARM, move "noirqtime=" option to common debugging code.
> For a bit of backward compatibility, "tsc=noirqtime"
> is preserved, but issues a warning.
> 
> Suggested-by: Venki Pallipadi <venki@google.com>
> Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
> ---
>  lib/Kconfig.debug             |   12 ++++++++++++
>  lib/Makefile                  |    2 ++
>  lib/irqtime.c                 |   12 ++++++++++++

Do we need a single file for this?
You know this feature is sched related, why not just move it
to kernel/sched/core.c?

Thanks,
Yong

>  7 files changed, 35 insertions(+), 14 deletions(-)
>  create mode 100644 lib/irqtime.c
> 
> diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
> index 5416c7c..56d2a9d 100644
> --- a/arch/arm/kernel/sched_clock.c
> +++ b/arch/arm/kernel/sched_clock.c
> @@ -162,5 +162,8 @@ void __init sched_clock_postinit(void)
>  	if (read_sched_clock == jiffy_sched_clock_read)
>  		setup_sched_clock(jiffy_sched_clock_read, 32, HZ);
>  
> +	if (!no_sched_irq_time)
> +		enable_sched_clock_irqtime();
> +
>  	sched_clock_poll(sched_clock_timer.data);
>  }
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 5bed94e..4759676 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -805,17 +805,6 @@ config SCHED_MC
>  	  making when dealing with multi-core CPU chips at a cost of slightly
>  	  increased overhead in some places. If unsure say N here.
>  
> -config IRQ_TIME_ACCOUNTING
> -	bool "Fine granularity task level IRQ time accounting"
> -	default n
> -	---help---
> -	  Select this option to enable fine granularity task irq time
> -	  accounting. This is done by reading a timestamp on each
> -	  transitions between softirq and hardirq state, so there can be a
> -	  small performance impact.
> -
> -	  If in doubt, say N here.
> -
>  source "kernel/Kconfig.preempt"
>  
>  config X86_UP_APIC
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index a62c201..70510a3 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -103,14 +103,15 @@ int __init notsc_setup(char *str)
>  
>  __setup("notsc", notsc_setup);
>  
> -static int no_sched_irq_time;
> -
>  static int __init tsc_setup(char *str)
>  {
>  	if (!strcmp(str, "reliable"))
>  		tsc_clocksource_reliable = 1;
> -	if (!strncmp(str, "noirqtime", 9))
> +	if (!strncmp(str, "noirqtime", 9)) {
> +		printk(KERN_WARNING "tsc: tsc=noirqtime is "
> +		       "obsolete, use noirqtime instead\n");
>  		no_sched_irq_time = 1;
> +	}
>  	return 1;
>  }
>  
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 7d379a6..b3575b5 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1966,9 +1966,11 @@ extern void sched_clock_idle_wakeup_event(u64 delta_ns);
>   * The reason for this explicit opt-in is not to have perf penalty with
>   * slow sched_clocks.
>   */
> +extern int no_sched_irq_time;
>  extern void enable_sched_clock_irqtime(void);
>  extern void disable_sched_clock_irqtime(void);
>  #else
> +#define no_sched_irq_time 1
>  static inline void enable_sched_clock_irqtime(void) {}
>  static inline void disable_sched_clock_irqtime(void) {}
>  #endif
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 8745ac7..48be210 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -299,6 +299,18 @@ config SCHEDSTATS
>  	  application, you can say N to avoid the very slight overhead
>  	  this adds.
>  
> +config IRQ_TIME_ACCOUNTING
> +	bool "Fine granularity task level IRQ time accounting"
> +	depends on (X86 || (ARM && HAVE_SCHED_CLOCK))
> +	default n
> +	---help---
> +	  Select this option to enable fine granularity task irq time
> +	  accounting. This is done by reading a timestamp on each
> +	  transitions between softirq and hardirq state, so there can be a
> +	  small performance impact.
> +
> +	  If in doubt, say N here.
> +
>  config TIMER_STATS
>  	bool "Collect kernel timers statistics"
>  	depends on DEBUG_KERNEL && PROC_FS
> diff --git a/lib/Makefile b/lib/Makefile
> index 18515f0..44d67d4 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -49,6 +49,8 @@ obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
>  obj-$(CONFIG_DEBUG_LIST) += list_debug.o
>  obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
>  
> +obj-$(CONFIG_IRQ_TIME_ACCOUNTING) += irqtime.o
> +
>  ifneq ($(CONFIG_HAVE_DEC_LOCK),y)
>    lib-y += dec_and_lock.o
>  endif
> diff --git a/lib/irqtime.c b/lib/irqtime.c
> new file mode 100644
> index 0000000..10d440d
> --- /dev/null
> +++ b/lib/irqtime.c
> @@ -0,0 +1,12 @@
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +
> +int no_sched_irq_time;
> +
> +static int __init irqtime_setup(char *str)
> +{
> +	no_sched_irq_time = 1;
> +	return 1;
> +}
> +
> +__setup("noirqtime", irqtime_setup);
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
