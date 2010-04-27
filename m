Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0D0Xln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 19:41:43 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10755 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab0D0Xlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 19:41:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5965"; a="39858996"
Message-ID: <4BD77633.9050403@codeaurora.org>
Date: Tue, 27 Apr 2010 16:41:39 -0700
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
References: <4BCFC3D0.5080904@codeaurora.org> <4BD0D9E5.3020606@codeaurora.org> <20100423184042.GA16190@Krystal> <4BD25C37.4070005@codeaurora.org> <20100424135817.GA27322@Krystal>
In-Reply-To: <20100424135817.GA27322@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

Thanks for taking the time to provide your input. More responses below.

Mathieu Desnoyers wrote:
> * Saravana Kannan (skannan@codeaurora.org) wrote:
> [...]
>> Seems a bit more complicated than what I had in mind. This is touching  
>> the scheduler I think we can get away without having to. Also, there is  
>> no simple implementation for the "slowpath" that can guarantee the delay  
>> without starting over the loop and hoping not to get interrupted or just  
>> giving up and doing a massively inaccurate delay (like msleep, etc).
> 
> Not necessarily. Another way to do it: we could keep the udelay loop counter in
> the task struct. When ondemand changes frequency, and upon migration, this
> counter would be adapted to the current cpu frequency.

This will take us back to the scalability problem because we now have to 
go through every process running on a CPU to update their udelay loop 
counters whenever the CPU freq changes.

>> I was thinking of something along the lines of this:
>>
>> udelay()
>> {
>>   if (!is_atomic())
> 
> see hardirq.h:
> 
> /*
>  * Are we running in atomic context?  WARNING: this macro cannot
>  * always detect atomic context; in particular, it cannot know about
>  * held spinlocks in non-preemptible kernels.  Thus it should not be
>  * used in the general case to determine whether sleeping is possible.
>  * Do not use in_atomic() in driver code.
>  */
> #define in_atomic()     ((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_INATOMIC_BASE)
> 
> Sorry, your scheme is broken on !PREEMPT kernels.

If it's a !PREEMPT kernel, we don't have to worry about the CPUfreq 
changing on us. CPU freq is changed in a deferrable work queue context.

>> 	down_read(&freq_sem);
>>   /* else
>> 	do nothing since cpufreq can't interrupt you.
>>   */
> 
> This comment seems broken. in_atomic() can return true because preemption is
> disabled, thus letting cpufreq interrupts coming in.

As mentioned earlier, cpufreq change can't happen when udelay is running 
in !PREEMPT kernel (which is where in_atomic() won't work). Btw, I 
actually wasn't referring to the real in_atomic() macro (I remembered it 
having limitations). But now that you mentioned the limitation, it might 
not be a problem after all.

>>   call usual code since cpufreq is not going to preempt you.
>>
>>   if (!is_atomic())
>> 	up_read(&freq_sem);
>> }
>>
>> __cpufreq_driver_target(...)
>> {
>>   down_write(&freq_sem);
>>   cpufreq_driver->target(...);
>>   up_write(&freq_sem);
>> }
>>
>> In the implementation of the cpufreq driver, they just need to make sure  
>> they always increase the LPJ _before_ increasing the freq and decrease  
>> the LPJ _after_ decreasing the freq. This is make sure that when an  
>> interrupt handler preempts the cpufreq driver code (since atomic  
>> contexts aren't looking at the r/w semaphore) the LPJ value will be good  
>> enough to satisfy the _at least_ guarantee of udelay().
>>
>> For the CPU switching issue, I think the solution I proposed is quite  
>> simple and should work.
> 
> You mean this ?
> 
>>>>> udelay(us)
>>>>> {
>>>>>    set cpu affinity to current CPU;
>>>>>    Do the usual udelay code;
>>>>>    restore cpu affinity status;
>>>>> }
> 
> Things like lock scalability and performance degradations comes to my mind. We
> can expect some drivers to make very heavy use of udelay(). This should not
> bring a 4096-core box to its knees. sched_setaffinity() is very far from being
> lightweight, as it locks cpu hotplug (that's a global mutex protecting a
> refcount), allocates memory, manipulates cpumasks, etc...

Hmm... set affinity does seem more complicated than what I expected.

>> Does my better explained solution look palatable?
> 
> Nope, not on a multiprocessor system.

Yes, set affinity seems to be a problem.

Didn't get to work on this for the past few days. Let me think more 
about this before I get back. In the mean time, if you can come up with 
a relatively simple solution without scalability issues, I would be glad 
to drop my existing solution.

Thanks again for the input.

-Saravana

