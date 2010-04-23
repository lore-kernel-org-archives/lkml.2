Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab0DWSkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 14:40:47 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:36937 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319Ab0DWSkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 14:40:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANuC0UtGGNqG/2dsb2JhbACcK3K+YYJLgkAE
Date: Fri, 23 Apr 2010 14:40:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: cpufreq <cpufreq@vger.kernel.org>,
       linux-arm-msm <linux-arm-msm@vger.kernel.org>,
       Dave Jones <davej@redhat.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Renninger <trenn@suse.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: CPUfreq - udelay() interaction issues
Message-ID: <20100423184042.GA16190@Krystal>
References: <4BCFC3D0.5080904@codeaurora.org> <4BD0D9E5.3020606@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4BD0D9E5.3020606@codeaurora.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:17:55 up 16 days,  4:11,  3 users,  load average: 0.22, 0.24,
	0.24
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCing Arjan, who seems to have played a lot with ondemand lately]

* Saravana Kannan (skannan@codeaurora.org) wrote:
> Resending email to "cc" the maintainers.
>
> Maintainers,
>
> Any comments?
>
> -Saravana
>
> Saravana Kannan wrote:
>> Hi,
>>
>> I think there are a couple of issues with cpufreq and udelay  
>> interaction. But that's based on my understanding of cpufreq. I have  
>> worked with it for sometime now, so hopefully I not completely wrong.  
>> So, I will list my assumptions and what I think is/are the issue(s) and 
>> their solutions.
>>
>> Please correct me if I'm wrong and let me know what you think.
>>
>> Assumptions:
>> ============
>> * Let's assume ondemand governor is being used.
>> * Ondemand uses one timer per core and they have CPU affinity set.
>> * For SMP, CPUfreq core expects the CPUfreq driver to adjust the 
>> per-CPU jiffies.
>> * P1 indicates for lower CPU perfomance levels and P2 indicates a much  
>> higher CPU pref level (say 10 times faster).
>>
>> Issue 1: UP (non-SMP) scenario
>> ==============================
>>
>> This issue is also present for SMP case, but I don't want to complicate 
>> this example with it. For future reference in this thread, let's call  
>> this "Context switch issue".
>>
>> Steps:
>> - CPU running at P1
>> - Driver context calls udelay
>> - udelay does loop calculation and starts looping
>> - Context switches to ondemand gov timer function
>> - Ondemand gov changes CPU to P2
>> - Context switches back to Driver context
>> - udelay does a delay that's 10 times shorter.
>>
>> The last point is obviously a bad thing. I'm more concerned about ARM  
>> arch for the moment, but considering x86 takes a max of 20ms (20000us)  
>> for udelay, the above scenario looks very possible.

I think your point is valid: if the CPU suddenly goes faster, the udelay
duration could be below the requested value.

I am not certain that there are any guarantee that udelay will sleep for
the exact amount requested, but I suppose it's generally assumed that it
will delay for _at least_ the amount requested. Then on top of that
interrupts, scheduler activity, etc... may make the delay longer.

Doing mutual exclusion between udelay and ondemand (as you propose
below) seems to be a solution that will complexify kernel locking a lot
for not much added value. spinlock is out of question because it would
disable preemption for 20ms durations. Any mutex or semaphore-based
solution will likely be a problem, because I suspect that udelay() is
used with preemption off somewhere.

One thing we could do, though, is to keep a per-cpu counter of the
number of frequency changes performed by ondemand. We sample the local
counter at the beginning of udelay, execute the correct number of loops,
re-sample the same counter, and if the frequency has changed while we
were executing the loops, we could go to a "slow-path" that would ensure
that we execute at least the minimum amount of loops to fill requested
time, possibly assuming the fastest frequency available on the system.
This counter could also be incremented by the scheduler migration code
so thread migrations between CPUs while udelay is running will also
trigger the "slow-path". This counter approach would take care of A-B-A
problems where frequency would go from A to B and the back to A while we
execute udelay, and also for migration from CPU A to B and back to A.

How does that sound ?

Thanks,

Mathieu

>>
>> Is there anything I missed that prevents this from happening?
>>
>> If this really is an issue, then one solution is to make cpufreq defer  
>> the freq change if some flag indicates that udelay is active. 
>> Basically, some kind of r/w semaphore or spinlock.
>>
>> Does this sound like a reasonable solution?
>>
>> Issue 2: SMP scenario
>> =====================
>>
>> For future reference in this thread, let's call this "CPU affinity issue".
>>
>> Steps:
>> - CPU0 running at P1
>> - CPU1 running at P2
>> - Driver context calls udelay in CPU0
>> - udelay does loop calculation and starts looping
>> - Driver context/thread is moved from CPU0 to CPU1
>> - udelay does a delay that's 10 times shorter.
>>
>> Again, the last point is obviously a bad thing. Am I missing anything  
>> here too? Again, I care more about ARM, but x86 (which a lot more 
>> people might care about) also seems to be broken if it doesn't use the 
>> TSC method for the delay.
>>
>> Assuming we fix Issue 1 (or it's not present) I think an ideal solution 
>> for this issue is to do something like:
>>
>> udelay(us)
>> {
>>    set cpu affinity to current CPU;
>>    Do the usual udelay code;
>>    restore cpu affinity status;
>> }
>>
>> Does this sound like a reasonable solution?
>>
>> Thanks,
>> Saravana
>

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
