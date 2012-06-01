Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab2FALFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 07:05:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48963 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758945Ab2FALFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 07:05:07 -0400
Date: Fri, 1 Jun 2012 12:04:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        nikunj@linux.vnet.ibm.com, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 26/27] arm, smpboot: Use generic SMP booting
	infrastructure
Message-ID: <20120601110415.GG21245@n2100.arm.linux.org.uk>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091614.31979.39272.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120601091614.31979.39272.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you're expecting an ack from me, you're not going to get it because
this patch is useless on its own.  It can't be reviewed and it can't be
tested without the rest of the series.

On Fri, Jun 01, 2012 at 02:46:20PM +0530, Srivatsa S. Bhat wrote:
> Convert arm to use the generic framework to boot secondary CPUs.
> 
> Notes:
> The calls to local_irq_enable() and local_fiq_enable() which were there
> in secondary_start_kernel() originally, are retained in __cpu_post_online()
> since the generic code only calls local_irq_enable().
> Also, we were anyway going to enable interrupts in the generic code
> immediately after __cpu_post_online(), so its not like we enabled interrupts
> way too early.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: David Brown <davidb@codeaurora.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  arch/arm/kernel/smp.c |   26 +++++++++++++-------------
>  1 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index b735521..460b7e7 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -25,6 +25,7 @@
>  #include <linux/percpu.h>
>  #include <linux/clockchips.h>
>  #include <linux/completion.h>
> +#include <linux/smpboot.h>
>  
>  #include <linux/atomic.h>
>  #include <asm/cacheflush.h>
> @@ -227,6 +228,11 @@ static void percpu_timer_setup(void);
>   */
>  asmlinkage void __cpuinit secondary_start_kernel(void)
>  {
> +	smpboot_start_secondary(NULL);
> +}
> +
> +void __cpuinit __cpu_pre_starting(void *unused)
> +{
>  	struct mm_struct *mm = &init_mm;
>  	unsigned int cpu = smp_processor_id();
>  
> @@ -244,26 +250,25 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
>  	printk("CPU%u: Booted secondary processor\n", cpu);
>  
>  	cpu_init();
> -	preempt_disable();
>  	trace_hardirqs_off();
>  
>  	/*
>  	 * Give the platform a chance to do its own initialisation.
>  	 */
>  	platform_secondary_init(cpu);
> +}
>  
> -	notify_cpu_starting(cpu);
> +void __cpuinit __cpu_pre_online(void *unused)
> +{
> +	unsigned int cpu = smp_processor_id();
>  
>  	calibrate_delay();
>  
>  	smp_store_cpu_info(cpu);
> +}
>  
> -	/*
> -	 * OK, now it's safe to let the boot CPU continue.  Wait for
> -	 * the CPU migration code to notice that the CPU is online
> -	 * before we continue - which happens after __cpu_up returns.
> -	 */
> -	set_cpu_online(cpu, true);
> +void __cpuinit __cpu_post_online(void *unused)
> +{
>  	complete(&cpu_running);
>  
>  	/*
> @@ -273,11 +278,6 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
>  
>  	local_irq_enable();
>  	local_fiq_enable();
> -
> -	/*
> -	 * OK, it's off to the idle thread for us
> -	 */
> -	cpu_idle();
>  }
>  
>  void __init smp_cpus_done(unsigned int max_cpus)
> 
