Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab1JESrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 14:47:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:34202 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406Ab1JESrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 14:47:49 -0400
Date: Wed, 5 Oct 2011 20:47:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fenghua Yu <fenghua.yu@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] x86, apic.c: Disable irq0 if CPU enables ARAT for
 local apic timer
In-Reply-To: <1317832759-10223-2-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.LFD.2.02.1110052045430.18778@ionos>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com> <1317832759-10223-2-git-send-email-fenghua.yu@intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011, Fenghua Yu wrote:

> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> irq0 won't generate any interrupt after local apic timers is enabled and ARAT
> is enabled. Disable irq0 in this case. Thus irq0 won't block BSP offline.

Why would it do so ?
 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/kernel/apic/apic.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 52fa563..8813acf 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -506,6 +506,7 @@ static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
>  static void __cpuinit setup_APIC_timer(void)
>  {
>  	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
> +	int cpu = smp_processor_id();
>  
>  	if (this_cpu_has(X86_FEATURE_ARAT)) {
>  		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_C3STOP;
> @@ -517,6 +518,10 @@ static void __cpuinit setup_APIC_timer(void)
>  	levt->cpumask = cpumask_of(smp_processor_id());
>  
>  	clockevents_register_device(levt);
> +
> +	/* irq0 won't be used any more if CPU supports ARAT feature. */
> +	if (cpu == 0 && this_cpu_has(X86_FEATURE_ARAT))
> +		disable_irq(0);

This is completely wrong. If we want to shut that interrupt down, then
we do it in the clockevents set mode functions of PIT or HPET and not
at some random place in the apic timer code.

Thanks,

	tglx
