Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab0DFQf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:35:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756841Ab0DFQfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:35:51 -0400
Message-ID: <4BBB62E1.2080308@suse.de>
Date: Tue, 06 Apr 2010 22:05:45 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: High priority threads causing severe CPU load imbalances
References: <4BBB334D.5040308@suse.de> <1270562890.1595.438.camel@laptop>
In-Reply-To: <1270562890.1595.438.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 07:38 PM, Peter Zijlstra wrote:
> On Tue, 2010-04-06 at 18:42 +0530, Suresh Jayaraman wrote:
>> I have a simple test program that accepts number of threads(pthreads) to
>> be created as a input. Each of these threads that gets created invokes a
>> function which is just a infinite while loop. The main function after
>> creating those threads goes in a infinite loop itself
>>
>> My test machine is a Dual Core AMD Opteron(tm) 860 with 8
>> sockets(non-HT), I run this test program with number of threads ==
>> number of CPUs:
>>
>>    ./loadcpu -t 16
>>
>> I see 100% CPU utilization on almost all CPUs (via mpstat/htop/vmstat).
>>
>> When the above threads are running, if I introduce a few high priority
>> threads by doing:
>>
>>    nice -n -13 ./loadcpu -t 3
>>
>> After a short while, I see a few CPUs becoming idle at ~0% utilization
>> (the number of CPUs becoming idle equals roughly the number of high
>> priority threads i.e. 3). When I stop the high priority threads, the CPU
>> utilization comes back to normal i.e. ~100%.
>>
>> This is reproducible on 2.6.32.10 stable kernel with all the recent all
>> SMT fixes (I hope) and I think it would be reproducible in current
>> upstream as well.
> 
> Why bother using -stable for reporting bugs?

It was not intentional. It just happened that I first noticed the bug on
a 32.10 kernel.

>> sched_mc_power_savings has been always set to 0.
>>
>> I spent a while staring at the load balancing and the thread migration
>> code, but could not figure out why this is happening. Would appreciate
>> any pointers.
> 
> Right, except its not a severe imbalance as the subject suggests. For
> some reason it seems to end up in a semi-stable state that is actually
> quite balanced.

In my reproduction attempt the number of CPUs becoming idle increased
with the number of high priority threads. For e.g.

 3 (out of 16 CPUs) become idle when there were 3 high priority threads
 5 CPUs become idle when there were 4 high priority threads
 7 CPUs become idle when there were 5 high priority threads (~40% )

But, I also starting to think it is some wierd combination of normal
priority threads and high priority threads make the problem worse or
good. Because with 7 or higher threads the utilization becomes smoother
again.

The increasing number of idle CPUs made me think that it could be severe..


> 
> for ((i=0; i<8; i++)) do while :; do :; done & done
> for ((i=0; i<3; i++)) do while :; do :; done & renice -n -15 -p $! ;
> done
> 
> gets me:
> 
> Cpu0  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu1  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu2  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu3  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu4  : 99.0%us,  1.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu5  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu6  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Mem:  16440840k total,  1073672k used, 15367168k free,   105844k buffers
> Swap: 16777212k total,        0k used, 16777212k free,   296504k cached
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  4370 root       5 -15  105m  804  304 R 100.1  0.0   0:45.02 bash
>  4374 root       5 -15  105m  804  304 R 100.1  0.0   0:44.95 bash
>  4372 root       5 -15  105m  804  304 R 99.1  0.0   0:45.00 bash
>  4364 root      20   0  105m  804  304 R 51.0  0.0   0:33.06 bash
>  4362 root      20   0  105m  800  300 R 50.0  0.0   0:33.17 bash
>  4365 root      20   0  105m  804  304 R 50.0  0.0   0:33.75 bash
>  4368 root      20   0  105m  804  304 R 50.0  0.0   0:33.32 bash
>  4369 root      20   0  105m  804  304 R 50.0  0.0   0:33.38 bash
>  4363 root      20   0  105m  804  304 R 49.1  0.0   0:33.65 bash
>  4366 root      20   0  105m  804  304 R 49.1  0.0   0:33.29 bash
>  4367 root      20   0  105m  804  304 R 49.1  0.0   0:33.54 bash 
> 
> So we have the 3 -15 loops on a cpu each, and the 8 0 loops on 2 cpus
> each, and 1 cpu idle. That is actually quite balanced, 'better' would be
> if those 0 loops would rotate over the 5 available cpus, but that would
> also trash more caches I guess.

Perhaps there is a chance that with more CPUs, different number of high
priority threads the problem could get worser as I mentioned above..?


Thanks,

-- 
Suresh Jayaraman
