Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab0ICTZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 15:25:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30249 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab0ICTZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 15:25:14 -0400
Message-ID: <4C814B59.1030109@kernel.org>
Date: Fri, 03 Sep 2010 12:24:09 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf, x86: Fix accidentally ack'ing a second
 event on intel perf counter
References: <1283454469-1909-2-git-send-email-dzickus@redhat.com> <tip-2e556b5b320838fde98480a1f6cf220a5af200fc@git.kernel.org> <4C80A62D.6050901@kernel.org> <20100903150055.GY4879@redhat.com> <4C812D24.8000704@kernel.org> <20100903183559.GB4879@redhat.com>
In-Reply-To: <20100903183559.GB4879@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2010 11:35 AM, Don Zickus wrote:
> On Fri, Sep 03, 2010 at 10:15:16AM -0700, Yinghai Lu wrote:
>> On 09/03/2010 08:00 AM, Don Zickus wrote:
>>> On Fri, Sep 03, 2010 at 12:39:25AM -0700, Yinghai Lu wrote:
>>>> Can you put this into perf branch ?
>>>>
>>>> Thanks
>>>>
>>>> Yinghai
>>>>
>>>> [PATCH] x86,nmi: move unknown_nmi_panic to traps.c
>>>
>>> This patch duplicates a bunch of stuff we already have in
>>> unknown_nmi_error.  The only thing I think you are interested in is using
>>> the 'unknown_nmi_panic' flag.  I am putting together a smaller patch that
>>> uses that flag in traps.c (though it would be nice to combine that flag
>>> with panic_on_unrecovered_nmi).
>>
>> please make sure
>> keep using unknown_nmi_panic in boot command line and  sysctl
>> when LOCKUP_DETECTOR is defined.
>>
>> that does work until hw nmi watchdog is merged with software lock detector.
>> assume that time hw nmi watchdog is relying on perf nmi and perf nmi would eat all unknown nmi.
>> good to have Robert/Peter/Don's patches to make per nmi not to eat all unknown nmi.
> 
> Hi Yinghai,
> 
> Here is the simpler patch I came up with.  It piggy backs off the
> unknown_nmi_error code already available.  I compile it with the old and
> new nmi watchdog and tested it with sysctl and the kernel parameter.
> Everything seems to panic properly.
> 
> Let me know if this meets your needs.
it should work. will test later
> 
> Cheers,
> Don
> 
> diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
> index cefd694..e66b16d 100644
> --- a/arch/x86/kernel/apic/hw_nmi.c
> +++ b/arch/x86/kernel/apic/hw_nmi.c
> @@ -100,7 +100,6 @@ void acpi_nmi_disable(void) { return; }
>  #endif
>  atomic_t nmi_active = ATOMIC_INIT(0);           /* oprofile uses this */
>  EXPORT_SYMBOL(nmi_active);
> -int unknown_nmi_panic;
>  void cpu_nmi_set_wd_enabled(void) { return; }
>  void stop_apic_nmi_watchdog(void *unused) { return; }
>  void setup_apic_nmi_watchdog(void *unused) { return; }
> diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
> index a43f71c..dc35af4 100644
> --- a/arch/x86/kernel/apic/nmi.c
> +++ b/arch/x86/kernel/apic/nmi.c
> @@ -37,7 +37,6 @@
>  
>  #include <asm/mach_traps.h>
>  
> -int unknown_nmi_panic;
>  int nmi_watchdog_enabled;
>  
>  /* For reliability, we're prepared to waste bits here. */
> @@ -483,13 +482,6 @@ static void disable_ioapic_nmi_watchdog(void)
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
>  static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
>  {
>  	unsigned char reason = get_nmi_reason();
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 60788de..095eea8 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -300,6 +300,16 @@ gp_in_kernel:
>  	die("general protection fault", regs, error_code);
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
> +#endif
> +
>  static notrace __kprobes void
>  mem_parity_error(unsigned char reason, struct pt_regs *regs)
>  {
> @@ -371,6 +381,10 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
>  			reason, smp_processor_id());
>  
>  	printk(KERN_EMERG "Do you have a strange power saving mode enabled?\n");
> +#if defined(CONFIG_SYSCTL) && defined(CONFIG_X86_LOCAL_APIC)
> +	if (unknown_nmi_panic)
> +		die_nmi("", regs, 1);
> +#endif

can you move it before the two printk(KERN_EMERG...)?

>  	if (panic_on_unrecovered_nmi)
>  		panic("NMI: Not continuing");

Can you merge those two panic? 

Thanks

Yinghai Lu

>  
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index ca38e8e..71516a4 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tip-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

