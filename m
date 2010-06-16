Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab0FPJ3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 05:29:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab0FPJ3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 05:29:13 -0400
Message-ID: <4C189927.1010402@redhat.com>
Date: Wed, 16 Jun 2010 12:28:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Eric Dumazet <eric.dumazet@gmail.com>,
       Mike Galbraith <efault@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Really lazy fpu
References: <1276441427-31514-1-git-send-email-avi@redhat.com> <4C187C22.2080505@redhat.com> <4C187DF1.9030007@zytor.com> <4C188527.9040305@redhat.com> <20100616083941.GA27151@elte.hu>
In-Reply-To: <20100616083941.GA27151@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 11:39 AM, Ingo Molnar wrote:
> (Cc:-ed various performance/optimization folks)
>
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 06/16/2010 10:32 AM, H. Peter Anvin wrote:
>>      
>>> On 06/16/2010 12:24 AM, Avi Kivity wrote:
>>>        
>>>> Ingo, Peter, any feedback on this?
>>>>          
>>> Conceptually, this makes sense to me.  However, I have a concern what
>>> happens when a task is scheduled on another CPU, while its FPU state is
>>> still in registers in the original CPU.  That would seem to require
>>> expensive IPIs to spill the state in order for the rescheduling to
>>> proceed, and this could really damage performance.
>>>        
>> Right, this optimization isn't free.
>>
>> I think the tradeoff is favourable since task migrations are much
>> less frequent than context switches within the same cpu, can the
>> scheduler experts comment?
>>      
> This cannot be stated categorically without precise measurements of
> known-good, known-bad, average FPU usage and average CPU usage scenarios. All
> these workloads have different characteristics.
>
> I can imagine bad effects across all sorts of workloads: tcpbench, AIM7,
> various lmbench components, X benchmarks, tiobench - you name it. Combined
> with the fact that most micro-benchmarks wont be using the FPU, while in the
> long run most processes will be using the FPU due to SIMM instructions. So
> even a positive result might be skewed in practice. Has to be measured
> carefully IMO - and i havent seen a _single_ performance measurement in the
> submission mail. This is really essential.
>    

I have really no idea what to measure.  Which would you most like to see?

> So this does not look like a patch-set we could apply without gathering a
> _ton_ of hard data about advantages and disadvantages.
>    

I agree (not to mention that I'm not really close to having an applyable 
patchset).

Note some of the advantages will not be in throughput but in latency 
(making kernel_fpu_begin() preemptible, and reducing context switch time 
for event threads).

>> We can also mitigate some of the IPIs if we know that we're migrating on the
>> cpu we're migrating from (i.e. we're pushing tasks to another cpu, not
>> pulling them from their cpu).  Is that a common case, and if so, where can I
>> hook a call to unlazy_fpu() (or its new equivalent)?
>>      
> When the system goes from idle to less idle then most of the 'fast' migrations
> happen on a 'push' model - on a busy CPU we wake up a new task and push it out
> to a known-idle CPU. At that point we can indeed unlazy the FPU with probably
> little cost.
>    

Can you point me to the code which does this?

> But on busy servers where most wakeups are IRQ based the chance of being on
> the right CPU is 1/nr_cpus - i.e. decreasing with every new generation of
> CPUs.
>    

But don't we usually avoid pulls due to NUMA and cache considerations?

> If there's some sucky corner case in theory we could approach it statistically
> and measure the ratio of fast vs. slow migration vs. local context switches -
> but that looks a bit complex.
>
>    

I certainly wouldn't want to start with it.

> Dunno.
>    

-- 
error compiling committee.c: too many arguments to function

