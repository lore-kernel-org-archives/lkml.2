Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab1CBTCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:02:43 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37518 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab1CBTCm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:02:42 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103021056460.2701@localhost6.localdomain6>
References: <AANLkTinkctQ6Nek98JV7vaos34gD4Qn8nsuBzt=_Jj6T@mail.gmail.com>
	<alpine.LFD.2.00.1102241900540.2701@localhost6.localdomain6>
	<AANLkTik1Aqt8qJ62h4k0PbLOU7qu3TtA=fWn=LJ6tQjc@mail.gmail.com>
	<alpine.LFD.2.00.1103021056460.2701@localhost6.localdomain6>
Date: Wed, 2 Mar 2011 20:02:41 +0100
Message-ID: <AANLkTikqp9=w+2r+Swe_4O9v=MiD=1tjCGrOQc9grHxk@mail.gmail.com>
Subject: Re: [PATCH V5 2/2] tracing, perf : add cpu hotplug trace events
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, amit.kucheria@linaro.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 March 2011 11:08, Thomas Gleixner <tglx@linutronix.de> wrote:
> Vincent,
>
> On Mon, 28 Feb 2011, Vincent Guittot wrote:
>> On 24 February 2011 19:40, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > On Thu, 24 Feb 2011, Vincent Guittot wrote:
>
> Sorry, this mail got eaten somehow, but I got it from my archive.
>
>> >>  #ifdef CONFIG_SMP
>> >>  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
>> >>  static DEFINE_MUTEX(cpu_add_remove_lock);
>> >> @@ -197,10 +200,13 @@ struct take_cpu_down_param {
>> >>  static int __ref take_cpu_down(void *_param)
>> >>  {
>> >>       struct take_cpu_down_param *param = _param;
>> >> +     unsigned int cpu = (unsigned int)(param->hcpu);
>> >>       int err;
>> >>
>> >>       /* Ensure this CPU doesn't handle any more interrupts. */
>> >> +     trace_cpu_hotplug_disable_start(cpu);
>> >>       err = __cpu_disable();
>> >> +     trace_cpu_hotplug_disable_end(cpu);
>> >
>> > How useful. What about recording the return code of __cpu_disable()?
>> >
>>
>> The goal is to monitor the cpu hotplug activity and duration. I want
>> to detect 2 kind of cpu_down/cpu_up call, ones which succeed to
>> unplug/plug a core and ones which don't. But I'm not sure that we need
>> to sort the failed calls into to the trace. We trace them because too
>> much fails could point out a bug or a wrong use of cpu hotplug.
>
> This does not make sense at all. You want to see the failures, then
> recording the error code makes even more sense. Your way of decoding
> the error case by checking whether the next trace entry is there or
> missing is just sloppy.
>

The 1st goal was to focus on profiling and to make trace events as
simple as possible but I agree that having all information is a better
option. We can add a parameter in the trace which gets the return code
or some test result like the value of cpu_hotplug_disabled.

>> >>       if (err < 0)
>> >>               return err;
>> >
>> >> +     trace_cpu_hotplug_down_start(cpu);
>> >> +
>> >
>> > What's the point of this tracepoint _BEFORE_ the cpu_hotplug_disabled
>> > check without recording cpu_hotplug_disabled ?
>> >
>>
>> I want to trace all cpu_down call even those which returns immediately
>> which will be part of the failed calls.
>
> Decoding failure from missing entries is simply wrong.
>
>> >>       if (cpu_hotplug_disabled) {
>> >>               err = -EBUSY;
>> >>               goto out;
>> >> @@ -284,6 +294,8 @@ int __ref cpu_down(unsigned int cpu)
>> >>       err = _cpu_down(cpu, 0);
>> >>
>> >>  out:
>> >> +     trace_cpu_hotplug_down_end(cpu);
>> >
>> > And this one is misplaced as well. It wants to be only called when we
>> > actually called _cpu_down() and it wants to record the return code as
>> > well.
>> >
>>
>> It has been placed here to be called each time
>> trace_cpu_hotplug_down_start is called.
>
> That does not make sense at all. You cannot distinguish between
> cpu_hotplug_disabled set and the _cpu_down() being called case. Or do
> you want to tell me that you decode that from the time stamps? Hell
> no. We want traces which are readable w/o crystal balls.
>
> Thanks,
>
>        tglx

Thanks,
Vincent
