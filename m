Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0KZMNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 07:13:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:53089 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab0KZMNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 07:13:53 -0500
Subject: Re: [patch 3/3] nohz/s390: fix arch_needs_cpu() return value on
 offline cpus
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        Frank Blaschka <frank.blaschka@de.ibm.com>,
        Horst Hartmann <horsth@linux.vnet.ibm.com>, stable@kernel.org
In-Reply-To: <20101126120235.738301376@de.ibm.com>
References: <20101126120057.879397696@de.ibm.com>
	 <20101126120235.738301376@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 26 Nov 2010 13:14:07 +0100
Message-ID: <1290773647.2145.140.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 13:01 +0100, Heiko Carstens wrote:
> plain text document attachment (003_arch_needs_cpu.diff)
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> This fixes the same problem as described in the patch "nohz: fix
> printk_needs_cpu() return value on offline cpus" for the arch_needs_cpu()
> primitive.
> This specific bug was indrocuded with 3c5d92a0 "nohz: Introduce arch_needs_cpu".
> 
> In this case a cpu hotplug notifier is used to fix the issue in order to keep
> the normal/fast path small. All we need to do is to clear the condition that
> makes arch_needs_cpu() return 1 since it is just a performance improvement which
> is supposed to keep the local tick running for a short period if a cpu goes
> idle. Nothing special needs to be done except for clearing the condition.
> 
> Cc: stable@kernel.org
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

OK, and s390 seems to be the only architecture making use of that
interface.

Did you audit all the other *_needs_cpu() interfaces for this same
problem?

Anyway, 

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Will you take this through the s390?

> ---
>  arch/s390/kernel/vtime.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> --- a/arch/s390/kernel/vtime.c
> +++ b/arch/s390/kernel/vtime.c
> @@ -19,6 +19,7 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/rcupdate.h>
>  #include <linux/posix-timers.h>
> +#include <linux/cpu.h>
>  
>  #include <asm/s390_ext.h>
>  #include <asm/timer.h>
> @@ -566,6 +567,23 @@ void init_cpu_vtimer(void)
>  	__ctl_set_bit(0,10);
>  }
>  
> +static int __cpuinit s390_nohz_notify(struct notifier_block *self,
> +				      unsigned long action, void *hcpu)
> +{
> +	struct s390_idle_data *idle;
> +	long cpu = (long) hcpu;
> +
> +	idle = &per_cpu(s390_idle, cpu);
> +	switch (action) {
> +	case CPU_DYING:
> +	case CPU_DYING_FROZEN:
> +		idle->nohz_delay = 0;
> +	default:
> +		break;
> +	}
> +	return NOTIFY_OK;
> +}
> +
>  void __init vtime_init(void)
>  {
>  	/* request the cpu timer external interrupt */
> @@ -574,5 +592,6 @@ void __init vtime_init(void)
>  
>  	/* Enable cpu timer interrupts on the boot cpu. */
>  	init_cpu_vtimer();
> +	cpu_notifier(s390_nohz_notify, 0);
>  }
>  
> 


