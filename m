Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab1ACQ7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 11:59:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab1ACQ7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 11:59:38 -0500
Date: Mon, 3 Jan 2011 11:59:14 -0500
From: Don Zickus <dzickus@redhat.com>
To: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        yanzheng@21cn.com
Subject: Re: [PATCH] x86: hpet: Fix HPET timer + NMI watchdog panic
Message-ID: <20110103165914.GA5685@redhat.com>
References: <4D1AA079.8040603@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1AA079.8040603@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 10:44:09AM +0800, Yan, Zheng wrote:
> HPET doesn't use timer_interrupt() as interrupt handler now. So count of
> HPET interrupt isn't recorded in per_cpu(irq_stat, cpu).irq0_irqs. This
> confuses NMI watchdog when using HPET as tick device.
> 
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>

Not sure if this patch is needed because x86/kerne/apic/nmi.c will most
likely disappear in 2.6.38 (it is already in gone in linux-next).  The new
nmi watchdog doesn't rely on HPET stats but instead uses a more generic
approach of a HRES timer.

Cheers,
Don

> 
> ---
> diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
> index 55e4de6..cca94f2 100644
> --- a/arch/x86/include/asm/hardirq.h
> +++ b/arch/x86/include/asm/hardirq.h
> @@ -12,6 +12,9 @@ typedef struct {
>  	unsigned int apic_timer_irqs;	/* arch dependent */
>  	unsigned int irq_spurious_count;
>  #endif
> +#ifdef CONFIG_HPET_TIMER
> +	unsigned int hpet_timer_irqs;
> +#endif
>  	unsigned int x86_platform_ipis;	/* arch dependent */
>  	unsigned int apic_perf_irqs;
>  	unsigned int apic_irq_work_irqs;
> diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
> index c90041c..cdb38d9 100644
> --- a/arch/x86/kernel/apic/nmi.c
> +++ b/arch/x86/kernel/apic/nmi.c
> @@ -80,8 +80,15 @@ static inline int mce_in_progress(void)
>   */
>  static inline unsigned int get_timer_irqs(int cpu)
>  {
> -	return per_cpu(irq_stat, cpu).apic_timer_irqs +
> +	unsigned int irqs; 
> +#ifdef CONFIG_HPET_TIMER
> +	irqs = per_cpu(irq_stat, cpu).hpet_timer_irqs;
> +#else
> +	irqs = 0;
> +#endif
> +	irqs += per_cpu(irq_stat, cpu).apic_timer_irqs +
>  		per_cpu(irq_stat, cpu).irq0_irqs;
> +	return irqs;
>  }
>  
>  #ifdef CONFIG_SMP
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index 4ff5968..b536474c 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -517,6 +517,7 @@ static irqreturn_t hpet_interrupt_handler(int irq, void *data)
>  	struct hpet_dev *dev = (struct hpet_dev *)data;
>  	struct clock_event_device *hevt = &dev->evt;
>  
> +	inc_irq_stat(hpet_timer_irqs);
>  	if (!hevt->event_handler) {
>  		printk(KERN_INFO "Spurious HPET timer interrupt on HPET timer %d\n",
>  				dev->num);
> diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
> index fb5cc5e1..2098c56 100644
> --- a/arch/x86/kernel/time.c
> +++ b/arch/x86/kernel/time.c
> @@ -56,7 +56,7 @@ unsigned long profile_pc(struct pt_regs *regs)
>  EXPORT_SYMBOL(profile_pc);
>  
>  /*
> - * Default timer interrupt handler for PIT/HPET
> + * Default timer interrupt handler for PIT
>   */
>  static irqreturn_t timer_interrupt(int irq, void *dev_id)
>  {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
