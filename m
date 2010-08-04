Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab0HDPtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 11:49:04 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26778 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab0HDPtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 11:49:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=iJq20SCa8tph5GoaGSSnKVhV631IQEBrA6lG3TvCgaynvG6PwDQ2TzqrFhkEKq3Au
	v6uS8pJd8mHfKPKAzLX7g==
MIME-Version: 1.0
In-Reply-To: <1280838043.1923.587.camel@laptop>
References: <1279008849.2096.913.camel@ymzhang.sh.intel.com>
	<1280838043.1923.587.camel@laptop>
Date: Wed, 4 Aug 2010 17:48:56 +0200
Message-ID: <AANLkTin3MdJbb-RgoRYvQB3OKyt2KeMBkkxHAN1_9DSr@mail.gmail.com>
Subject: Re: perf failed with kernel 2.6.35-rc
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 2:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-07-13 at 16:14 +0800, Zhang, Yanmin wrote:
>
>> If I comment out the workaround in function intel_pmu_nhm_enable_all,
>> perf could work.
>>
>> A quick glance shows:
>> wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
>> should be:
>> wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
>
> Correct, I've got a patch for that laying around,.. posted it several
> times in the struct pmu rework series.
>
>> I triggered sysrq to dump PMU registers and found the last bit of
>> global status register is 1. I added a status reset operation like below patch:
>>
>> --- linux-2.6.35-rc5/arch/x86/kernel/cpu/perf_event_intel.c   2010-07-14 09:38:11.000000000 +0800
>> +++ linux-2.6.35-rc5_fork/arch/x86/kernel/cpu/perf_event_intel.c      2010-07-14 14:41:42.000000000 +0800
>> @@ -505,8 +505,13 @@ static void intel_pmu_nhm_enable_all(int
>>               wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 1, 0x4300B1);
>>               wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 2, 0x4300B5);
>>
>> -             wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
>> +             wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
>>               wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
>> +             /*
>> +              * Reset the last 3 bits of global status register in case
>> +              * previous enabling causes overflows.
>> +              */
>> +             wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, 0x7);
>
> Like Stephane already pointed out (and the comment above this function
> mentions), these counters should be non-counting, and thus should not
> cause an overflow (and this function gets called with GLOBAL_CTRL
> cleared, so it shouldn't be counting to begin with).
>
> The Nehalem-EX errata BA72 seems to agree (assuming Xeon-7500 is indeed
> the EX, Intel really should do something about this naming madness)
> http://www.intel.com/Assets/en_US/PDF/specupdate/323344.pdf
>
> [ Also see the trace outout below, PERFCTR[12] stay 0 ]
>
>>               for (i = 0; i < 3; i++) {
>>                       struct perf_event *event = cpuc->events[i];
>>
>>
>>
>> However, it still doesn't work. Current right way is to comment out
>> the workaround.
>
> So I frobbed the below patchlet to debug things, as it appears I can
> indeed reproduce on my westmere.
>
> ---
>  arch/x86/kernel/cpu/perf_event.c       |   24 +++++++++++++++++++++++-
>  arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
>  2 files changed, 24 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index f2da20f..2ca41f7 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -31,7 +31,7 @@
>  #include <asm/nmi.h>
>  #include <asm/compat.h>
>
> -#if 0
> +#if 1
>  #undef wrmsrl
>  #define wrmsrl(msr, val)                                       \
>  do {                                                           \
> @@ -42,6 +42,16 @@ do {                                                         \
>  } while (0)
>  #endif
>
> +#if 1
> +#undef rdmsrl
> +#define rdmsrl(msr, val)                                       \
> +do {                                                           \
> +       (val) = native_read_msr(msr);                           \
> +       trace_printk("rdmsrl(%lx, %lx)\n", (unsigned long)(msr),\
> +                       (unsigned long)(val));                  \
> +} while (0)
> +#endif
> +
>  /*
>  * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
>  */
> @@ -583,6 +593,14 @@ static void x86_pmu_disable_all(void)
>        }
>  }
>
> +static void noinline check_status(void)
> +{
> +       u64 status;
> +       rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
> +       if (WARN_ON(status))
> +               perf_event_print_debug();
> +}
> +
>  void hw_perf_disable(void)
>  {
>        struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> @@ -598,6 +616,8 @@ void hw_perf_disable(void)
>        barrier();
>
>        x86_pmu.disable_all();
> +
> +       check_status();
>  }
>
>  static void x86_pmu_enable_all(int added)
> @@ -816,6 +836,8 @@ void hw_perf_enable(void)
>        if (cpuc->enabled)
>                return;
>
> +       check_status();
> +
>        if (cpuc->n_added) {
>                int n_running = cpuc->n_events - cpuc->n_added;
>                /*
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 214ac86..56ce7dc 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -505,7 +505,7 @@ static void intel_pmu_nhm_enable_all(int added)
>                wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 1, 0x4300B1);
>                wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 2, 0x4300B5);
>
> -               wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
> +               wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
>                wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
>
>                for (i = 0; i < 3; i++) {
> ---
>
> It results in the below trace (edited out some superfluous stack traces:
>
>           <...>-1871  [000]    96.759853: intel_pmu_disable_all: wrmsrl(38f, 0)
>           <...>-1871  [000]    96.759853: <stack trace>
>  => hw_perf_disable
>  => perf_disable
>  => perf_ctx_adjust_freq
>  => perf_event_task_tick
>  => scheduler_tick
>  => update_process_times
>  => tick_sched_timer
>  => __run_hrtimer
>           <...>-1871  [000]    96.759872: check_status: rdmsrl(38e, 1)
>           <...>-1871  [000]    96.759872: <stack trace>
>  => hw_perf_disable
>  => perf_disable
>  => perf_ctx_adjust_freq
>  => perf_event_task_tick
>  => scheduler_tick
>  => update_process_times
>  => tick_sched_timer
>  => __run_hrtimer
>           <...>-1871  [000]    96.760180: perf_event_print_debug: rdmsrl(38f, 0)
>           <...>-1871  [000]    96.760186: perf_event_print_debug: rdmsrl(38e, 1)
>           <...>-1871  [000]    96.760191: perf_event_print_debug: rdmsrl(390, 0)
>           <...>-1871  [000]    96.760196: perf_event_print_debug: rdmsrl(38d, 0)
>           <...>-1871  [000]    96.760201: perf_event_print_debug: rdmsrl(3f1, 0)
>           <...>-1871  [000]    96.760248: perf_event_print_debug: rdmsrl(186, 53003c)
>           <...>-1871  [000]    96.760258: perf_event_print_debug: rdmsrl(c1, d1e91)
>           <...>-1871  [000]    96.760285: perf_event_print_debug: rdmsrl(187, 4300b1)
>           <...>-1871  [000]    96.760290: perf_event_print_debug: rdmsrl(c2, 0)
>           <...>-1871  [000]    96.760320: perf_event_print_debug: rdmsrl(188, 4300b5)
>           <...>-1871  [000]    96.760340: perf_event_print_debug: rdmsrl(c3, 0)
>           <...>-1871  [000]    96.760359: perf_event_print_debug: rdmsrl(189, 0)
>           <...>-1871  [000]    96.760379: perf_event_print_debug: rdmsrl(c4, 0)
>           <...>-1871  [000]    96.760398: perf_event_print_debug: rdmsrl(309, 0)
>           <...>-1871  [000]    96.760417: perf_event_print_debug: rdmsrl(30a, 0)
>           <...>-1871  [000]    96.760432: perf_event_print_debug: rdmsrl(30b, 0)
>           <...>-1871  [000]    96.760432: <stack trace>
>  => check_status
>  => hw_perf_disable
>  => perf_disable
>  => perf_ctx_adjust_freq
>  => perf_event_task_tick
>  => scheduler_tick
>  => update_process_times
>  => tick_sched_timer
>
> Which seems to indicate we somehow disable the PMU (clear GLOBAL_CTRL)
> with a pending overflow (as indicated by GLOBAL_STATUS and PERFCTR0).
>
At the time you stop the PMU, you could have an in-flight overflow, i.e., it may
take some time to set the overflow status bit. But this seems far
fetched because
it would be very hard to reproduce. Do you get the same problem is you restrict
the event to counting at the user level, for instance?

Another good source of infos is the Intel VTUNE/PTU driver, called SEP. The
source is provided when you download PTU. I checked the code and they do
have a fix for the same errata. It seems to issue many more wrmsrl().
