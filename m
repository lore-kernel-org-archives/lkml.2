Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab0IJHtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 03:49:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43328 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab0IJHtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 03:49:31 -0400
Subject: Re: 2.6.36-rc3 suspend issue (was: 2.6.35-rc4 / X201 issues)
From: Peter Zijlstra <peterz@infradead.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Nico Schottelius <nico-nospam@schottelius.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Nico Schottelius <nico-linux-20100709@schottelius.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Florian Pritz <flo@xssn.at>, Suresh Siddha <suresh.b.siddha@intel.com>,
        stable@kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.1009101324280.3056@boston.corp.fedex.com>
References: <Pine.LNX.4.64.1009101324280.3056@boston.corp.fedex.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Sep 2010 09:48:40 +0200
Message-ID: <1284104920.402.21.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 13:36 +0800, Jeff Chua wrote:

> 
> I've bisected and it's pointing to the following commit causing the 
> errors after resume. Reverting the commit solves the problem.

"the errors" being those at the end of this email?

> commit cd7240c0b900eb6d690ccee088a6c9b46dae815a
> Author: Suresh Siddha <suresh.b.siddha@intel.com>
> Date:   Thu Aug 19 17:03:38 2010 -0700
> 
>      x86, tsc, sched: Recompute cyc2ns_offset's during resume from sleep states
> 

> diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
> index c042729..1ca132f 100644
> --- a/arch/x86/include/asm/tsc.h
> +++ b/arch/x86/include/asm/tsc.h
> @@ -59,5 +59,7 @@ extern void check_tsc_sync_source(int cpu);
>   extern void check_tsc_sync_target(void);
> 
>   extern int notsc_setup(char *);
> +extern void save_sched_clock_state(void);
> +extern void restore_sched_clock_state(void);
> 
>   #endif /* _ASM_X86_TSC_H */
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index ce8e502..d632934 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -626,6 +626,44 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
>   	local_irq_restore(flags);
>   }
> 
> +static unsigned long long cyc2ns_suspend;
> +
> +void save_sched_clock_state(void)
> +{
> +	if (!sched_clock_stable)
> +		return;
> +
> +	cyc2ns_suspend = sched_clock();
> +}
> +
> +/*
> + * Even on processors with invariant TSC, TSC gets reset in some the
> + * ACPI system sleep states. And in some systems BIOS seem to reinit TSC to
> + * arbitrary value (still sync'd across cpu's) during resume from such sleep
> + * states. To cope up with this, recompute the cyc2ns_offset for each cpu so
> + * that sched_clock() continues from the point where it was left off during
> + * suspend.
> + */
> +void restore_sched_clock_state(void)
> +{
> +	unsigned long long offset;
> +	unsigned long flags;
> +	int cpu;
> +
> +	if (!sched_clock_stable)
> +		return;
> +
> +	local_irq_save(flags);
> +
> +	get_cpu_var(cyc2ns_offset) = 0;
> +	offset = cyc2ns_suspend - sched_clock();
> +
> +	for_each_possible_cpu(cpu)
> +		per_cpu(cyc2ns_offset, cpu) = offset;
> +
> +	local_irq_restore(flags);
> +}
> +
>   #ifdef CONFIG_CPU_FREQ
> 
>   /* Frequency scaling support. Adjust the TSC based timer when the cpu frequency
> diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
> index e7e8c5f..87bb35e 100644
> --- a/arch/x86/power/cpu.c
> +++ b/arch/x86/power/cpu.c
> @@ -113,6 +113,7 @@ static void __save_processor_state(struct saved_context *ctxt)
>   void save_processor_state(void)
>   {
>   	__save_processor_state(&saved_context);
> +	save_sched_clock_state();
>   }
>   #ifdef CONFIG_X86_32
>   EXPORT_SYMBOL(save_processor_state);
> @@ -229,6 +230,7 @@ static void __restore_processor_state(struct saved_context *ctxt)
>   void restore_processor_state(void)
>   {
>   	__restore_processor_state(&saved_context);
> +	restore_sched_clock_state();
>   }
>   #ifdef CONFIG_X86_32
>   EXPORT_SYMBOL(restore_processor_state);
> 
> 
> 
> 
> Errors like the one below:
> 
> cpi_ds_exec_end_op+0x8e/0x3cd
>   [<ffffffff8121497d>] ? acpi_ps_parse_loop+0x7dd/0x96c
>   [<ffffffff81213af7>] ? acpi_ps_parse_aml+0x8e/0x29a
>   [<ffffffff8121512e>] ? acpi_ps_execute_method+0x1bf/0x28d
>   [<ffffffff81210741>] ? acpi_ns_evaluate+0xdd/0x19a
>   [<ffffffff812101f3>] ? acpi_evaluate_object+0x145/0x246
>   [<ffffffff811f79b2>] ? acpi_os_signal_semaphore+0x23/0x27
>   [<ffffffff811fa41e>] ? acpi_device_resume+0x0/0x2b
>   [<ffffffff81222892>] ? acpi_battery_get_state+0x7f/0x121
>   [<ffffffff812118c2>] ? acpi_get_handle+0x7b/0x99
>   [<ffffffff81222b99>] ? acpi_battery_update+0x265/0x26e
>   [<ffffffff81222c70>] ? acpi_battery_resume+0x25/0x2a
>   [<ffffffff81295c8d>] ? legacy_resume+0x1e/0x55
>   [<ffffffff81295d24>] ? device_resume+0x60/0xdd
>   [<ffffffff811c2102>] ? kobject_get+0x12/0x17
>   [<ffffffff812963e1>] ? dpm_resume_end+0xf2/0x349
>   [<ffffffff8105c9a4>] ? suspend_devices_and_enter+0x15b/0x188
>   [<ffffffff8105ca6a>] ? enter_state+0x99/0xcb
>   [<ffffffff8105c2da>] ? state_store+0xb1/0xcf
>   [<ffffffff810e9f0f>] ? sysfs_write_file+0xd6/0x112
>   [<ffffffff810a2f82>] ? vfs_write+0xad/0x132
>   [<ffffffff810a30bd>] ? sys_write+0x45/0x6e
>   [<ffffffff81001f02>] ? system_call_fastpath+0x16/0x1b
> BUG: scheduling while atomic: lid/2486/0x00000002
> 

That just doesn't make any sense, the TSC restore code doesn't involve
acpi, nor does it actually schedule.

