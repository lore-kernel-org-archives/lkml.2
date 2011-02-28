Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab1B1NhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 08:37:25 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:62561 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab1B1NhX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 08:37:23 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1102241900540.2701@localhost6.localdomain6>
References: <AANLkTinkctQ6Nek98JV7vaos34gD4Qn8nsuBzt=_Jj6T@mail.gmail.com>
	<alpine.LFD.2.00.1102241900540.2701@localhost6.localdomain6>
Date: Mon, 28 Feb 2011 14:36:40 +0100
Message-ID: <AANLkTik1Aqt8qJ62h4k0PbLOU7qu3TtA=fWn=LJ6tQjc@mail.gmail.com>
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

On 24 February 2011 19:40, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 24 Feb 2011, Vincent Guittot wrote:
>
> Please send full patch series not a single V5 2/2 which lacks any
> references to 0/2 1/2.
>

I'm going to create a complete patch series and add a 0/2 reference
with more details about the patch purpose.

This patch adds traces for 2 main goals. The 1st one is to detect the
plug and unplug of a core. As explained by Nicolas, smp arm platforms
use the cpu hotplug feature. In fact, the state of a core can modify
the cpuidle activity because some Arm SoC can't go into deep idle
state when more than one core is plugged and also because running into
mono core mode makes the cpuidle job easier and more efficient which
results in the improvement of powersaving of some use cases. That's
why it's interesting to monitor the plug state of cores and to
correlate it with cpuidle traces. The goal is not to make cpu hotplug
feature part of cpuidle one but to use cpu hotplug in a low frequency
manner (few dozens of seconds or minutes), we plug several cpus only
when needed by the system activity.
Then, the 2nd goal of these traces is to measure the duration of cpu
plug/unplug sequence across various use cases and cpu load. Cpu
hotplug is known to be an expensive operation which also takes a
variable time depending of other processes' activity (from hundreds of
ms up to few seconds). I have seen with these traces that the arch
part stays almost constant whatever the cpu load is on arm platform,
and I have also seen that the core duration depends of threads
creation when we plug a cpu.

>> Please find below a new proposal for adding trace events for cpu hotplug:
>
> Either it's a patch or a proposal. Darn, why think people that
> proposal is such a important word? It's just useless. You don't have
> to sell anything to your manager. You provide a patch which is judged
> on it's technical merits and correctness. Nothing else.
>
>> -the lock/unlock of cpu_add_remove_lock mutex is now outside the trace
>>
>> The goal is to measure the latency of each part (kernel, architecture)
>> and also to trace the cpu hotplug activity with other power events. I
>> have tested these traces events on an arm platform.
>
> This belongs into a cover mail [0/2] not into the patch itself
>
>> Subject: [PATCH 2/2] add hotplug tracepoint
>
> While your mail subject is correct, this is not.
>
> If you would have sent a [0/2] cover mail with all the above blurb in
> it then this extra subject line would be not needed at all.
>
>> this patch adds new events for cpu hotplug tracing
>
> Sentences start with an upper case letter.
>
> Also we already know that this is a patch. Where is the value of this
> changelog? It does not tell more than the subject line.
>
>>  * plug/unplug sequence
>
> How surprising.
>
>>  * core and architecture latency measurements
>
> No it does not. It does not add latency measurements. It merily adds
> tracepoints which allow you to compute the time spent in the various
> steps of the hotplug state machine and the overall time.
>
>>  #ifdef CONFIG_SMP
>>  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
>>  static DEFINE_MUTEX(cpu_add_remove_lock);
>> @@ -197,10 +200,13 @@ struct take_cpu_down_param {
>>  static int __ref take_cpu_down(void *_param)
>>  {
>>       struct take_cpu_down_param *param = _param;
>> +     unsigned int cpu = (unsigned int)(param->hcpu);
>>       int err;
>>
>>       /* Ensure this CPU doesn't handle any more interrupts. */
>> +     trace_cpu_hotplug_disable_start(cpu);
>>       err = __cpu_disable();
>> +     trace_cpu_hotplug_disable_end(cpu);
>
> How useful. What about recording the return code of __cpu_disable()?
>

The goal is to monitor the cpu hotplug activity and duration. I want
to detect 2 kind of cpu_down/cpu_up call, ones which succeed to
unplug/plug a core and ones which don't. But I'm not sure that we need
to sort the failed calls into to the trace. We trace them because too
much fails could point out a bug or a wrong use of cpu hotplug.

>>       if (err < 0)
>>               return err;
>
>> +     trace_cpu_hotplug_down_start(cpu);
>> +
>
> What's the point of this tracepoint _BEFORE_ the cpu_hotplug_disabled
> check without recording cpu_hotplug_disabled ?
>

I want to trace all cpu_down call even those which returns immediately
which will be part of the failed calls.

>>       if (cpu_hotplug_disabled) {
>>               err = -EBUSY;
>>               goto out;
>> @@ -284,6 +294,8 @@ int __ref cpu_down(unsigned int cpu)
>>       err = _cpu_down(cpu, 0);
>>
>>  out:
>> +     trace_cpu_hotplug_down_end(cpu);
>
> And this one is misplaced as well. It wants to be only called when we
> actually called _cpu_down() and it wants to record the return code as
> well.
>

It has been placed here to be called each time
trace_cpu_hotplug_down_start is called.

>> +
>>       cpu_maps_update_done();
>>       return err;
>>  }
>> @@ -310,7 +322,9 @@ static int __cpuinit _cpu_up(unsigned int cpu, int
>> tasks_frozen)
>>       }
>>
>>       /* Arch-specific enabling code. */
>> +     trace_cpu_hotplug_arch_up_start(cpu);
>>       ret = __cpu_up(cpu);
>> +     trace_cpu_hotplug_arch_up_end(cpu);
>
> See above.
>
>>       if (ret != 0)
>>               goto out_notify;
>>       BUG_ON(!cpu_online(cpu));
>> @@ -369,6 +383,8 @@ int __cpuinit cpu_up(unsigned int cpu)
>>
>>       cpu_maps_update_begin();
>>
>> +     trace_cpu_hotplug_up_start(cpu);
>> +
>
> Ditto
>
>>       if (cpu_hotplug_disabled) {
>>               err = -EBUSY;
>>               goto out;
>> @@ -377,6 +393,8 @@ int __cpuinit cpu_up(unsigned int cpu)
>>       err = _cpu_up(cpu, 0);
>>
>>  out:
>> +     trace_cpu_hotplug_up_end(cpu);
>> +
>
> Sigh.
>
>>       cpu_maps_update_done();
>>       return err;
>
> Thanks,
>
>        tglx
>

Thanks,
Vincent
