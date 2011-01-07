Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab1AGMH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 07:07:26 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53368 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1AGMHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 07:07:24 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTik0i5xeNG_+tgdfWRjC1cQAbm+-0fDNGih5KfRx@mail.gmail.com>
References: <AANLkTimsR3=BKSF8EyASu4_T_vTznw4yEqmxPS8gOQCy@mail.gmail.com>
	<AANLkTik0i5xeNG_+tgdfWRjC1cQAbm+-0fDNGih5KfRx@mail.gmail.com>
Date: Fri, 7 Jan 2011 13:07:23 +0100
Message-ID: <AANLkTimoYJkr2hPx1ruW4nkK4YnzzvUGR_h8i4pxyaPM@mail.gmail.com>
Subject: Re: [PATCH] tracing, perf : add cpu hotplug trace events
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Amit Kucheria <amit.kucheria@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        rostedt@goodmis.org, fweisbec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 January 2011 10:21, Amit Kucheria <amit.kucheria@linaro.org> wrote:
> Vincent,
>
> Adding Steve Rostedt and Frederic Weisbecker to CC list as maintainers
> of the trace subsystem
>
> Also, a sample patch against your SoC on how you plan to use this
> might be useful. You can mark the patch as RFC for now.
>

I'm going to prepare a sample patch based on my SoC.
The trace output with current proposal looks like below on my SoC . I
have added some comments :

# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
           bash-3603  [000]   133.012161: hotplug_start: type=1 step=0
cpuid=1     Start to plug cpu1
           bash-3603  [000]   133.032270: hotplug_start: type=1 step=1
cpuid=1     boot_secondary
        <idle>-0     [001]   133.032372: hotplug_end: type=1 step=2
cpuid=1         cpu1 is up
           bash-3603  [000]   133.032448: hotplug_end: type=1 step=1
cpuid=1      cpu1 is online
           bash-3603  [000]   133.074754: hotplug_end: type=1 step=0
cpuid=1      End of the plug sequence

> More comments below.
>
> On Tue, Jan 4, 2011 at 3:20 PM, Vincent Guittot
> <vincent.guittot@linaro.org> wrote:
>> Please find below a proposal for adding new trace events for cpu
>> hotplug.The goal is to measure the latency of each part (kernel,
>> architecture and platform) and also to trace the cpu hotplug activity
>> with other power events. I have tested these traces events on an arm
>> platform
>>
>> Comments are welcome.
>>
>> Date: Wed, 15 Dec 2010 11:22:21 +0100
>> Subject: [PATCH] hotplug tracepoint
>>
>> this patch adds new events for cpu hotplug tracing
>> * plug/unplug sequence
>> * architecture and machine latency measurements
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>> include/trace/events/hotplug.h |   71 ++++++++++++++++++++++++++++++++++++++++
>> 1 files changed, 71 insertions(+), 0 deletions(-)
>> create mode 100644 include/trace/events/hotplug.h
>>
>> diff --git a/include/trace/events/hotplug.h b/include/trace/events/hotplug.h
>> new file mode 100644
>> index 0000000..51c86ab
>> --- /dev/null
>> +++ b/include/trace/events/hotplug.h
>> @@ -0,0 +1,71 @@
>> +#undef TRACE_SYSTEM
>> +#define TRACE_SYSTEM hotplug
>> +
>> +#if !defined(_TRACE_HOTPLUG_H) || defined(TRACE_HEADER_MULTI_READ)
>> +#define _TRACE_HOTPLUG_H
>> +
>> +#include <linux/ktime.h>
>> +#include <linux/tracepoint.h>
>> +
>> +#ifndef _TRACE_HOTPLUG_ENUM_
>> +#define _TRACE_HOTPLUG_ENUM_
>> +enum hotplug_type {
>> + HOTPLUG_UNPLUG = 0,
>> + HOTPLUG_PLUG = 1
>> +};
>> +
>> +enum hotplug_step {
>> + HOTPLUG_KERNEL = 0,
>> + HOTPLUG_ARCH = 1,
>> + HOTPLUG_MACH = 2
>> +};
>> +#endif
>
> s/HOTPLUG_KERNEL/HOTPLUG_CORE/  ?
>

ok, I'm going to change for HOTPLUG_CORE

> Comments regarding what these mean would be nice. ARM has core, arch
> and machine level configuration, but x86, for example might not use
> machine at all.
>

ok, I'm going to add comments

The hotplug_step are used to define which kind of code is running.
-The HOTPLUG_CORE refers to code that is used whatever the system is.
-The HOTPLUG_ARCH refers to code that is dedicated to an architecture.
Typically, the 3 functions:
__cpu_up(), __cpu_disable() and __cpu_die().
-The HOTPLUG_MACH is used by architectures which have some dedicated
SW for shutting down the cpu like on Arm SoC. For the Arm
architecture, the machine step is linked to the platform_cpu_die
function.

>> +
>> +TRACE_EVENT(hotplug_start,
>> +
>> + TP_PROTO(unsigned int type, unsigned int step, unsigned int cpuid),
>> +
>> + TP_ARGS(type, step, cpuid),
>> +
>> + TP_STRUCT__entry(
>> + __field(u32, type)
>> + __field(u32, step)
>> + __field(u32, cpuid)
>> + ),
>> +
>> + TP_fast_assign(
>> + __entry->type = type;
>> + __entry->step = step;
>> + __entry->cpuid = cpuid;
>> + ),
>> +
>> + TP_printk("type=%lu step=%lu cpuid=%lu", (unsigned long)__entry->type,
>> + (unsigned long)__entry->step, (unsigned long)__entry->cpuid)
>> +);
>> +
>> +TRACE_EVENT(hotplug_end,
>> +
>> + TP_PROTO(unsigned int type, unsigned int step, unsigned int cpuid),
>> +
>> + TP_ARGS(type, step, cpuid),
>> +
>> + TP_STRUCT__entry(
>> + __field(u32, type)
>> + __field(u32, step)
>> + __field(u32, cpuid)
>> + ),
>> +
>> + TP_fast_assign(
>> + __entry->type = type;
>> + __entry->step = step;
>> + __entry->cpuid = cpuid;
>> + ),
>> +
>> + TP_printk("type=%lu step=%lu cpuid=%lu", (unsigned long)__entry->type,
>> + (unsigned long)__entry->step, (unsigned long)__entry->cpuid)
>> +);
>> +
>> +#endif /* _TRACE_HOTPLUG_H */
>> +
>> +/* This part must be outside protection */
>> +#include <trace/define_trace.h>
>> --
>> 1.7.0.4
>
