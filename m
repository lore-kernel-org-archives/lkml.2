Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab0ICPB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 11:01:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab0ICPBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 11:01:18 -0400
Date: Fri, 3 Sep 2010 11:00:55 -0400
From: Don Zickus <dzickus@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf, x86: Fix accidentally ack'ing a second
 event on intel perf counter
Message-ID: <20100903150055.GY4879@redhat.com>
References: <1283454469-1909-2-git-send-email-dzickus@redhat.com>
 <tip-2e556b5b320838fde98480a1f6cf220a5af200fc@git.kernel.org>
 <4C80A62D.6050901@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C80A62D.6050901@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 12:39:25AM -0700, Yinghai Lu wrote:
> Can you put this into perf branch ?
> 
> Thanks
> 
> Yinghai
> 
> [PATCH] x86,nmi: move unknown_nmi_panic to traps.c

This patch duplicates a bunch of stuff we already have in
unknown_nmi_error.  The only thing I think you are interested in is using
the 'unknown_nmi_panic' flag.  I am putting together a smaller patch that
uses that flag in traps.c (though it would be nice to combine that flag
with panic_on_unrecovered_nmi).

Cheers,
Don

> 
> So we use it even LOCKUP_DETECTOR is defined.
> need Robert/Peter/Don's patch...
> 
> that will keep unknown_nmi_panic to have same behavoir before hw nmi watchdog
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
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
> @@ -739,7 +739,7 @@ static struct ctl_table kern_table[] = {
>  		.extra2		= &one,
>  	},
>  #endif
> -#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86) && !defined(CONFIG_LOCKUP_DETECTOR)
> +#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
>  	{
>  		.procname       = "unknown_nmi_panic",
>  		.data           = &unknown_nmi_panic,
> @@ -747,6 +747,8 @@ static struct ctl_table kern_table[] = {
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
