Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420Ab0GWMz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:55:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894Ab0GWMz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:55:27 -0400
Date: Fri, 23 Jul 2010 08:55:05 -0400
From: Don Zickus <dzickus@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: fweisbec@gmail.com, peterz@infradead.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] x86: perf swallows all NMIs when registered with a user
Message-ID: <20100723125505.GQ7330@redhat.com>
References: <20100722215136.GA23517@redhat.com>
 <4C48CD0D.5020201@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C48CD0D.5020201@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 03:58:21PM -0700, Yinghai Lu wrote:
> cool, with your patch and following patch i can use nmi button now with CONFIG_LOCKUP_DETECTOR defined
> 
> [PATCH] x86,nmi: move unknown_nmi_panic to traps.c
> 
> So we use it even LOCKUP_DETECTOR is defined.
> 
> need Don's patch...

Thanks for the feedback Yinghai!
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

With regards to your patch, I am still a little uncomfortable with it, as
it seems to be redundant with what is used in unknown_nmi_error() and the
panic_on_unrecovered_nmi flag.  I agree that keeping the familiar flag
'unknown_nmi_panic' is needed.  But I was still wondering if wrapping it
around 'panic_on_unrecovered_nmi' would be simpler and less code.

Cheers,
Don

> 
> ---
>  arch/x86/include/asm/nmi.h    |    8 --------
>  arch/x86/kernel/apic/hw_nmi.c |    1 -
>  arch/x86/kernel/apic/nmi.c    |   27 ---------------------------
>  arch/x86/kernel/traps.c       |   29 ++++++++++++++++++++++++++++-
>  kernel/sysctl.c               |    4 +++-
>  5 files changed, 31 insertions(+), 38 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/apic/nmi.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/nmi.c
> +++ linux-2.6/arch/x86/kernel/apic/nmi.c
> @@ -37,7 +37,6 @@
>  
>  #include <asm/mach_traps.h>
>  
> -int unknown_nmi_panic;
>  int nmi_watchdog_enabled;
>  
>  /* For reliability, we're prepared to waste bits here. */
> @@ -483,23 +482,6 @@ static void disable_ioapic_nmi_watchdog(
>  	on_each_cpu(stop_apic_nmi_watchdog, NULL, 1);
>  }
>  
> -static int __init setup_unknown_nmi_panic(char *str)
> -{
> -	unknown_nmi_panic = 1;
> -	return 1;
> -}
> -__setup("unknown_nmi_panic", setup_unknown_nmi_panic);
> -
> -static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
> -{
> -	unsigned char reason = get_nmi_reason();
> -	char buf[64];
> -
> -	sprintf(buf, "NMI received for unknown reason %02x\n", reason);
> -	die_nmi(buf, regs, 1); /* Always panic here */
> -	return 0;
> -}
> -
>  /*
>   * proc handler for /proc/sys/kernel/nmi
>   */
> @@ -540,15 +522,6 @@ int proc_nmi_enabled(struct ctl_table *t
>  
>  #endif /* CONFIG_SYSCTL */
>  
> -int do_nmi_callback(struct pt_regs *regs, int cpu)
> -{
> -#ifdef CONFIG_SYSCTL
> -	if (unknown_nmi_panic)
> -		return unknown_nmi_panic_callback(regs, cpu);
> -#endif
> -	return 0;
> -}
> -
>  void arch_trigger_all_cpu_backtrace(void)
>  {
>  	int i;
> Index: linux-2.6/arch/x86/kernel/apic/hw_nmi.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/hw_nmi.c
> +++ linux-2.6/arch/x86/kernel/apic/hw_nmi.c
> @@ -100,7 +100,6 @@ void acpi_nmi_disable(void) { return; }
>  #endif
>  atomic_t nmi_active = ATOMIC_INIT(0);           /* oprofile uses this */
>  EXPORT_SYMBOL(nmi_active);
> -int unknown_nmi_panic;
>  void cpu_nmi_set_wd_enabled(void) { return; }
>  void stop_apic_nmi_watchdog(void *unused) { return; }
>  void setup_apic_nmi_watchdog(void *unused) { return; }
> Index: linux-2.6/arch/x86/kernel/traps.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/traps.c
> +++ linux-2.6/arch/x86/kernel/traps.c
> @@ -377,6 +377,33 @@ unknown_nmi_error(unsigned char reason,
>  	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
>  }
>  
> +#if defined(CONFIG_SYSCTL) && defined(CONFIG_X86_LOCAL_APIC)
> +int unknown_nmi_panic;
> +static int __init setup_unknown_nmi_panic(char *str)
> +{
> +	unknown_nmi_panic = 1;
> +	return 1;
> +}
> +__setup("unknown_nmi_panic", setup_unknown_nmi_panic);
> +
> +static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
> +{
> +	unsigned char reason = get_nmi_reason();
> +	char buf[64];
> +
> +	sprintf(buf, "NMI received for unknown reason %02x\n", reason);
> +	die_nmi(buf, regs, 1); /* Always panic here */
> +	return 0;
> +}
> +
> +static int do_nmi_callback(struct pt_regs *regs, int cpu)
> +{
> +	if (unknown_nmi_panic)
> +		return unknown_nmi_panic_callback(regs, cpu);
> +	return 0;
> +}
> +#endif
> +
>  static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>  {
>  	unsigned char reason = 0;
> @@ -405,8 +432,8 @@ static notrace __kprobes void default_do
>  		 */
>  		if (nmi_watchdog_tick(regs, reason))
>  			return;
> -		if (!do_nmi_callback(regs, cpu))
>  #endif /* !CONFIG_LOCKUP_DETECTOR */
> +		if (!do_nmi_callback(regs, cpu))
>  			unknown_nmi_error(reason, regs);
>  #else
>  		unknown_nmi_error(reason, regs);
> Index: linux-2.6/kernel/sysctl.c
> ===================================================================
> --- linux-2.6.orig/kernel/sysctl.c
> +++ linux-2.6/kernel/sysctl.c
> @@ -741,7 +741,7 @@ static struct ctl_table kern_table[] = {
>  		.extra2		= &one,
>  	},
>  #endif
> -#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86) && !defined(CONFIG_LOCKUP_DETECTOR)
> +#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
>  	{
>  		.procname       = "unknown_nmi_panic",
>  		.data           = &unknown_nmi_panic,
> @@ -749,6 +749,8 @@ static struct ctl_table kern_table[] = {
>  		.mode           = 0644,
>  		.proc_handler   = proc_dointvec,
>  	},
> +#endif
> +#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86) && !defined(CONFIG_LOCKUP_DETECTOR)
>  	{
>  		.procname       = "nmi_watchdog",
>  		.data           = &nmi_watchdog_enabled,
> Index: linux-2.6/arch/x86/include/asm/nmi.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/nmi.h
> +++ linux-2.6/arch/x86/include/asm/nmi.h
> @@ -7,14 +7,6 @@
>  
>  #ifdef ARCH_HAS_NMI_WATCHDOG
>  
> -/**
> - * do_nmi_callback
> - *
> - * Check to see if a callback exists and execute it.  Return 1
> - * if the handler exists and was handled successfully.
> - */
> -int do_nmi_callback(struct pt_regs *regs, int cpu);
> -
>  extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
>  extern int check_nmi_watchdog(void);
>  #if !defined(CONFIG_LOCKUP_DETECTOR)
> 
