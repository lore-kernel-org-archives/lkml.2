Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab1AGSZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 13:25:12 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36080 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab1AGSZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 13:25:09 -0500
MIME-Version: 1.0
In-Reply-To: <20110107151200.GB1736@nowhere>
References: <AANLkTimsR3=BKSF8EyASu4_T_vTznw4yEqmxPS8gOQCy@mail.gmail.com>
	<20110107151200.GB1736@nowhere>
Date: Fri, 7 Jan 2011 19:25:08 +0100
Message-ID: <AANLkTi=L3=_2dzHH4Wu6QWXw=AUjxtrAu60xfM3-Qwn4@mail.gmail.com>
Subject: Re: [PATCH] tracing, perf : add cpu hotplug trace events
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Amit Kucheria <amit.kucheria@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 January 2011 16:12, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Tue, Jan 04, 2011 at 10:50:36AM +0100, Vincent Guittot wrote:
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
>> +
>> +TRACE_EVENT(hotplug_start,
>
> hotplug is way too generic.
>
> cpu_hotplug may be?
>

that's fine for me

>> +
>> + TP_PROTO(unsigned int type, unsigned int step, unsigned int cpuid),
>
> I feel a bit uncomfortable with these opaque type and step.
>
> What about splitting the events:
>
>        cpu_down_start
>        cpu_down_end
>
>        cpu_up_start
>        cpu_up_end
>
> This ways they are much more self-explanatory.
>
> I also feel uncomfortable about exposing arch step details in core
> tracepoints.
>
> But if we consider the following sequence:
>
>        cpu_down() {
>                __cpu_disable() {
>                        platform_cpu_disable();
>                }
>        }
>
> Then exposing start/end of cpu_disable() makes sense, by way of:
>
>        cpu_arch_disable_start
>        cpu_arch_disable_end
>
>        cpu_arch_enable_start
>        cpu_arch_enable_end
>
>
>        cpu_arch_die_start
>        cpu_arch_die_end
>
>        cpu_arch_die_start
>        cpu_arch_die_end
>
> Because they are arch events that you can retrieve everywhere, the tracepoints
> are still called from the code code.
>
> Now for the machine part, it's very highly arch specific, most notably for arm
> so I wonder if it would make more sense to keep that seperate into arch
> tracepoints.
>

May be we could find some event names that matches for all system and
that can be kept in the same file ?

> How does that all look? I hope I'm not overengineering.
>

that's could be ok for me, I can find almost the same kind of
information with this solution. I just wonder what traces are the
easiest to treat for extracting some latency measurement or to treat
with other event like the power event.

> Creating such series of similar tracepoints is quite easy and quick using
> DECLARE_EVENT_CLASS and DEFINE_EVENT.
>

ok

>> +
>> + TP_ARGS(type, step, cpuid),
>> +
>> + TP_STRUCT__entry(
>> + __field(u32, type)
>> + __field(u32, step)
>> + __field(u32, cpuid)
>> + ),
>
> And please use a proper indentation for trace_events.
> You can have a look at the examples in include/trace/events/
>

ok, i will take example from include/trace/events/
