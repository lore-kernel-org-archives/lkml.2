Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab1AURmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:42:00 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:64672 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab1AURl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:41:59 -0500
MIME-Version: 1.0
In-Reply-To: <20110121164404.GA2520@nowhere>
References: <AANLkTinNoYbDe5huY4_Q6YidbWxqXqVWbVP2_7o-=P3W@mail.gmail.com>
	<20110120161101.GA17218@nowhere>
	<AANLkTinhX6UwQA0HFhuu5=jbq84woVhqtahuzA5hEo2o@mail.gmail.com>
	<20110121164404.GA2520@nowhere>
Date: Fri, 21 Jan 2011 18:41:58 +0100
Message-ID: <AANLkTi=Tx3DYczwf9U=QS9XGs6C8sjKwVZr+RLuo781V@mail.gmail.com>
Subject: Re: [PATCH V2] tracing, perf : add cpu hotplug trace events
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        rostedt@goodmis.org, amit.kucheria@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 January 2011 17:44, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Fri, Jan 21, 2011 at 09:43:18AM +0100, Vincent Guittot wrote:
>> On 20 January 2011 17:11, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> > On Thu, Jan 20, 2011 at 09:25:54AM +0100, Vincent Guittot wrote:
>> >> Please find below a new proposal for adding trace events for cpu hotplug.
>> >> The goal is to measure the latency of each part (kernel, architecture)
>> >> and also to trace the cpu hotplug activity with other power events. I
>> >> have tested these traces events on an arm platform.
>> >>
>> >> Changes since previous version:
>> >> -Use cpu_hotplug for trace name
>> >> -Define traces for kernel core and arch parts only
>> >> -Use DECLARE_EVENT_CLASS and DEFINE_EVENT
>> >> -Use proper indentation
>> >>
>> >> Subject: [PATCH] cpu hotplug tracepoint
>> >>
>> >> this patch adds new events for cpu hotplug tracing
>> >>  * plug/unplug sequence
>> >>  * core and architecture latency measurements
>> >>
>> >> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.com>
>> >> ---
>> >>  include/trace/events/cpu_hotplug.h |  117 ++++++++++++++++++++++++++++++++++++
>> >
>> > Note we can't apply new tracepoints if they are not inserted in the code.
>>
>> I agree, i just want to have 1st feedbacks on the tracepoint interface
>> before providing a patch which inserts the trace in the code.
>>
>> >
>> >> +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_wait_die_start,
>> >> +
>> >> +     TP_PROTO(unsigned int cpuid),
>> >> +
>> >> +     TP_ARGS(cpuid)
>> >> +);
>> >> +
>> >> +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_wait_die_end,
>> >> +
>> >> +     TP_PROTO(unsigned int cpuid),
>> >> +
>> >> +     TP_ARGS(cpuid)
>> >> +);
>> >
>> > What is wait die, compared to die for example?
>> >
>>
>> The arch_wait_die is used to trace the process which waits for the cpu
>> to die (__cpu_die) and the arch_die is used to trace when the cpu dies
>> (cpu_die)
>
> I still can't find the difference.
>
> Having:
>
> trace_cpu_hotplug_arch_die_start(cpu)
> __cpu_die();
> trace_cpu_hotplug_arch_die_end(cpu)
>
> Is not enough to get both the information that a cpu dies
> and the time took to do so?
>

it's quite interesting to trace the cpu_die function because the cpu
really dies in this one. The __cpu_die function can't return if the
cpu fails to die in the very last step and then wake up. But this
could be detected with some cpu_die traces.

for a normal use case we have something like :
cpu 0 enters __cpu_die
cpu 1 enters cpu_die
cpu1 acks that it is going to died
cpu0 returns from __cpu_die

if the cpu 1 fails to die at the very last step, we could have:
cpu 0 enters __cpu_die
cpu 1 enters cpu_idle --> cpu_die
cpu1 leaves cpu_die because of some issues and comes back into cpu_idle.
cpu0 returns from __cpu_die after a timeout or an error ack

Then, cpu_die traces can be used with power traces for profiling the
cpu power state. May be, the power.h trace file is a better place for
the cpu_die traces ?
