Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab0KLOUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 09:20:50 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43215 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab0KLOUt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 09:20:49 -0500
MIME-Version: 1.0
X-Originating-IP: [81.245.35.244]
In-Reply-To: <1289498595-25806-3-git-send-email-trenn@suse.de>
References: <1289498595-25806-1-git-send-email-trenn@suse.de>
	<1289498595-25806-3-git-send-email-trenn@suse.de>
Date: Fri, 12 Nov 2010 15:20:47 +0100
Message-ID: <AANLkTi=PdncRr8Yst03rZSPzbH3Saq-97e0H6AKDMjwg@mail.gmail.com>
Subject: Re: [PATCH 2/3] PERF(kernel): Cleanup power events
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Thomas Renninger <trenn@suse.de>
Cc: mingo@elte.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Thanks for the patches re-spin!

Here are my comments inlined.

On Thu, Nov 11, 2010 at 7:03 PM, Thomas Renninger <trenn@suse.de> wrote:
> Recent changes:
>  - Enable EVENT_POWER_TRACING_DEPRECATED by default
>
> New power trace events:
> power:cpu_idle
> power:cpu_frequency
> power:machine_suspend
>
>
> C-state/idle accounting events:
>  power:power_start
>  power:power_end
> are replaced with:
>  power:cpu_idle
>
> and
>  power:power_frequency
> is replaced with:
>  power:cpu_frequency
>
> power:machine_suspend
> is newly introduced.
> Jean Pihet has a patch integrated into the generic layer
> (kernel/power/suspend.c) which will make use of it.
>
> the type= field got removed from both, it was never
> used and the type is differed by the event type itself.
>
> perf timechart
> userspace tool gets adjusted in a separate patch.
>
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> Acked-by: Arjan van de Ven <arjan@linux.intel.com>
> Acked-by: Jean Pihet <jean.pihet@newoldbits.com>
> CC: Arjan van de Ven <arjan@linux.intel.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: rjw@sisk.pl
> CC: linux-kernel@vger.kernel.org
> ---
>  arch/x86/kernel/process.c    |    7 +++-
>  arch/x86/kernel/process_32.c |    2 +-
>  arch/x86/kernel/process_64.c |    2 +
>  drivers/cpufreq/cpufreq.c    |    1 +
>  drivers/cpuidle/cpuidle.c    |    1 +
>  drivers/idle/intel_idle.c    |    1 +
>  include/trace/events/power.h |   87 +++++++++++++++++++++++++++++++++++++++++-
>  kernel/trace/Kconfig         |   15 +++++++
>  kernel/trace/power-traces.c  |    3 +
>  9 files changed, 116 insertions(+), 3 deletions(-)
>
...
> diff --git a/include/trace/events/power.h b/include/trace/events/power.h
> index 286784d..ab26d8e 100644
> --- a/include/trace/events/power.h
> +++ b/include/trace/events/power.h
> @@ -7,6 +7,67 @@
>  #include <linux/ktime.h>
>  #include <linux/tracepoint.h>
>
> +DECLARE_EVENT_CLASS(cpu,
> +
> +       TP_PROTO(unsigned int state, unsigned int cpu_id),
> +
> +       TP_ARGS(state, cpu_id),
> +
> +       TP_STRUCT__entry(
> +               __field(        u32,            state           )
> +               __field(        u32,            cpu_id          )
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->state = state;
> +               __entry->cpu_id = cpu_id;
> +       ),
> +
> +       TP_printk("state=%lu cpu_id=%lu", (unsigned long)__entry->state,
> +                 (unsigned long)__entry->cpu_id)
Using %lu for the state field causes PWR_EVENT_EXIT to appear as
4294967295 instead of -1. Can the field be of a signed type?

> +);
> +
> +DEFINE_EVENT(cpu, cpu_idle,
> +
> +       TP_PROTO(unsigned int state, unsigned int cpu_id),
> +
> +       TP_ARGS(state, cpu_id)
> +);
> +
> +/* This file can get included multiple times, TRACE_HEADER_MULTI_READ at top */
> +#ifndef _PWR_EVENT_AVOID_DOUBLE_DEFINING
> +#define _PWR_EVENT_AVOID_DOUBLE_DEFINING
> +
> +#define PWR_EVENT_EXIT -1
> +
> +#endif
> +
> +DEFINE_EVENT(cpu, cpu_frequency,
> +
> +       TP_PROTO(unsigned int frequency, unsigned int cpu_id),
> +
> +       TP_ARGS(frequency, cpu_id)
> +);
> +
> +TRACE_EVENT(machine_suspend,
> +
> +       TP_PROTO(unsigned int state),
> +
> +       TP_ARGS(state),
> +
> +       TP_STRUCT__entry(
> +               __field(        u32,            state           )
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->state = state;
> +       ),
> +
> +       TP_printk("state=%lu", (unsigned long)__entry->state)
Same remark about the unsigned type for the state field.

> +);
> +
> +#ifdef CONFIG_EVENT_POWER_TRACING_DEPRECATED
> +
>  #ifndef _TRACE_POWER_ENUM_
>  #define _TRACE_POWER_ENUM_
>  enum {
> @@ -153,8 +214,32 @@ DEFINE_EVENT(power_domain, power_domain_target,
>
>        TP_ARGS(name, state, cpu_id)
>  );
> -
> +#endif /* CONFIG_EVENT_POWER_TRACING_DEPRECATED */
The clock and power_domain events have been recently introduced and so
must be part of the new API. Can this #endif be moved right after the
definition of power_end?

>  #endif /* _TRACE_POWER_H */
Should this be at the very end of the file?

>
> +/* Deprecated dummy functions must be protected against multi-declartion */
> +#ifndef EVENT_POWER_TRACING_DEPRECATED_PART_H
> +#define EVENT_POWER_TRACING_DEPRECATED_PART_H
> +
> +#ifndef CONFIG_EVENT_POWER_TRACING_DEPRECATED
> +
> +#ifndef _TRACE_POWER_ENUM_
> +#define _TRACE_POWER_ENUM_
> +enum {
> +       POWER_NONE = 0,
> +       POWER_CSTATE = 1,
> +       POWER_PSTATE = 2,
> +};
> +#endif
> +
> +static inline void trace_power_start(u64 type, u64 state, u64 cpuid) {};
> +static inline void trace_power_end(u64 cpuid) {};
> +static inline void trace_power_frequency(u64 type, u64 state, u64 cpuid) {};
> +#endif /* CONFIG_EVENT_POWER_TRACING_DEPRECATED */
> +
> +#endif /* EVENT_POWER_TRACING_DEPRECATED_PART_H */
> +
> +
> +
>  /* This part must be outside protection */
>  #include <trace/define_trace.h>
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index e04b8bc..0be2e7f 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -69,6 +69,21 @@ config EVENT_TRACING
>        select CONTEXT_SWITCH_TRACER
>        bool
>
> +config EVENT_POWER_TRACING_DEPRECATED
> +       depends on EVENT_TRACING
> +       bool
A string is needed here. Without it it is impossible to have the option unset.
This does the trick: +bool "Deprecated power event trace API, to be removed"

> +       default y
> +       help
> +         Provides old power event types:
> +         C-state/idle accounting events:
> +         power:power_start
> +         power:power_end
> +         and old cpufreq accounting event:
> +         power:power_frequency
> +         This is for userspace compatibility
> +         and will vanish after 5 kernel iterations,
> +         namely 2.6.41.
> +
>  config CONTEXT_SWITCH_TRACER
>        bool
>
...

Thanks,
Jean
