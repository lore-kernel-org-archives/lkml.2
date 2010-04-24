Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab0DXCta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:49:30 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45332 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab0DXCt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:49:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5961"; a="39518029"
Message-ID: <4BD25C37.4070005@codeaurora.org>
Date: Fri, 23 Apr 2010 19:49:27 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: cpufreq <cpufreq@vger.kernel.org>,
       linux-arm-msm <linux-arm-msm@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: CPUfreq - udelay() interaction issues
References: <4BCFC3D0.5080904@codeaurora.org> <4BD0D9E5.3020606@codeaurora.org> <20100423184042.GA16190@Krystal>
In-Reply-To: <20100423184042.GA16190@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Venkatesh since his email is bouncing with "unknown address".

Mathieu Desnoyers wrote:
>> Saravana Kannan wrote:
>>>
>>> Assumptions:
>>> ============
>>> * Let's assume ondemand governor is being used.
>>> * Ondemand uses one timer per core and they have CPU affinity set.
>>> * For SMP, CPUfreq core expects the CPUfreq driver to adjust the 
>>> per-CPU jiffies.
>>> * P1 indicates for lower CPU perfomance levels and P2 indicates a much  
>>> higher CPU pref level (say 10 times faster).
>>>
>>> Issue 1: UP (non-SMP) scenario
>>> ==============================
>>>
>>> This issue is also present for SMP case, but I don't want to complicate 
>>> this example with it. For future reference in this thread, let's call  
>>> this "Context switch issue".
>>>
>>> Steps:
>>> - CPU running at P1
>>> - Driver context calls udelay
>>> - udelay does loop calculation and starts looping
>>> - Context switches to ondemand gov timer function
>>> - Ondemand gov changes CPU to P2
>>> - Context switches back to Driver context
>>> - udelay does a delay that's 10 times shorter.
>>>
>>> The last point is obviously a bad thing. I'm more concerned about ARM  
>>> arch for the moment, but considering x86 takes a max of 20ms (20000us)  
>>> for udelay, the above scenario looks very possible.
> 
> I think your point is valid: if the CPU suddenly goes faster, the udelay
> duration could be below the requested value.
> 
> I am not certain that there are any guarantee that udelay will sleep for
> the exact amount requested, but I suppose it's generally assumed that it
> will delay for _at least_ the amount requested. Then on top of that
> interrupts, scheduler activity, etc... may make the delay longer.

Yes, udelay has an _at least_ guarantee. Extra delay is not much of a 
concern and is probably unavoidable.

> Doing mutual exclusion between udelay and ondemand (as you propose
> below) seems to be a solution that will complexify kernel locking a lot
> for not much added value.

A lot of device drivers use udelay to meet h/w or protocol spec 
requirements and if we randomly don't meet it, we would hit issues that 
are hard to debug. So, I think proper working of udelay is quite a bit 
important.

> spinlock is out of question because it would
> disable preemption for 20ms durations. Any mutex or semaphore-based
> solution will likely be a problem, because I suspect that udelay() is
> used with preemption off somewhere.

I agree, a spin lock would be a no-no for many reasons. Semaphore is not 
really a problem in atomic contexts because cpufreq can't interrupt us 
either -- so we don't need to grab a semaphore.

I was testing the waters about the actual existence of the bug before I 
spent time to propose a clear solution. I guess I could have explained 
the solution better -- explain further down.

> One thing we could do, though, is to keep a per-cpu counter of the
> number of frequency changes performed by ondemand. We sample the local
> counter at the beginning of udelay, execute the correct number of loops,
> re-sample the same counter, and if the frequency has changed while we
> were executing the loops, we could go to a "slow-path" that would ensure
> that we execute at least the minimum amount of loops to fill requested
> time, possibly assuming the fastest frequency available on the system.
> This counter could also be incremented by the scheduler migration code
> so thread migrations between CPUs while udelay is running will also
> trigger the "slow-path". This counter approach would take care of A-B-A
> problems where frequency would go from A to B and the back to A while we
> execute udelay, and also for migration from CPU A to B and back to A.
> 
> How does that sound ?

Seems a bit more complicated than what I had in mind. This is touching 
the scheduler I think we can get away without having to. Also, there is 
no simple implementation for the "slowpath" that can guarantee the delay 
without starting over the loop and hoping not to get interrupted or just 
giving up and doing a massively inaccurate delay (like msleep, etc).

I was thinking of something along the lines of this:

udelay()
{
   if (!is_atomic())
	down_read(&freq_sem);
   /* else
	do nothing since cpufreq can't interrupt you.
   */

   call usual code since cpufreq is not going to preempt you.

   if (!is_atomic())
	up_read(&freq_sem);
}

__cpufreq_driver_target(...)
{
   down_write(&freq_sem);
   cpufreq_driver->target(...);
   up_write(&freq_sem);
}

In the implementation of the cpufreq driver, they just need to make sure 
they always increase the LPJ _before_ increasing the freq and decrease 
the LPJ _after_ decreasing the freq. This is make sure that when an 
interrupt handler preempts the cpufreq driver code (since atomic 
contexts aren't looking at the r/w semaphore) the LPJ value will be good 
enough to satisfy the _at least_ guarantee of udelay().

For the CPU switching issue, I think the solution I proposed is quite 
simple and should work.

Does my better explained solution look palatable?

Thanks,
Saravana

>>> Is there anything I missed that prevents this from happening?
>>>
>>> If this really is an issue, then one solution is to make cpufreq defer  
>>> the freq change if some flag indicates that udelay is active. 
>>> Basically, some kind of r/w semaphore or spinlock.
>>>
>>> Does this sound like a reasonable solution?
>>>
>>> Issue 2: SMP scenario
>>> =====================
>>>
>>> For future reference in this thread, let's call this "CPU affinity issue".
>>>
>>> Steps:
>>> - CPU0 running at P1
>>> - CPU1 running at P2
>>> - Driver context calls udelay in CPU0
>>> - udelay does loop calculation and starts looping
>>> - Driver context/thread is moved from CPU0 to CPU1
>>> - udelay does a delay that's 10 times shorter.
>>>
>>> Again, the last point is obviously a bad thing. Am I missing anything  
>>> here too? Again, I care more about ARM, but x86 (which a lot more 
>>> people might care about) also seems to be broken if it doesn't use the 
>>> TSC method for the delay.
>>>
>>> Assuming we fix Issue 1 (or it's not present) I think an ideal solution 
>>> for this issue is to do something like:
>>>
>>> udelay(us)
>>> {
>>>    set cpu affinity to current CPU;
>>>    Do the usual udelay code;
>>>    restore cpu affinity status;
>>> }
>>>
>>> Does this sound like a reasonable solution?
>>>
>>> Thanks,
>>> Saravana
> 

