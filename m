Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab2HSKMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 06:12:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46418 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2HSKMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 06:12:15 -0400
Message-ID: <5030BBF9.4020200@gmail.com>
Date: Sun, 19 Aug 2012 12:12:09 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins> <20120816143145.GI2213@e103687>
In-Reply-To: <20120816143145.GI2213@e103687>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I can probably add some bits to the discussion, after all I'm preparing 
a talk for Plumbers that is strictly related :-). My points are not CFS 
related (so feel free to ignore me), but they would probably be 
interesting if we talk about power aware scheduling in Linux in general.

On 08/16/2012 04:31 PM, Morten Rasmussen wrote:
> Hi all,
>
> On Wed, Aug 15, 2012 at 12:05:38PM +0100, Peter Zijlstra wrote:
>>>
>>> sub proposal:
>>> 1, If it's possible to balance task on idlest cpu not appointed 'balance
>>> cpu'. If so, it may can reduce one more time balancing.
>>> The idlest cpu can prefer the new idle cpu;  and is the least load cpu;
>>> 2, se or task load is good for running time setting.
>>> but it should the second basis in load balancing. The first basis of LB
>>> is running tasks' number in group/cpu. Since whatever of the weight of
>>> groups is, if the tasks number is less than cpu number, the group is
>>> still has capacity to take more tasks. (will consider the SMT cpu power
>>> or other big/little cpu capacity on ARM.)
>>
>> Ah, no we shouldn't balance on nr_running, but on the amount of time
>> consumed. Imagine two tasks being woken at the same time, both tasks
>> will only run a fraction of the available time, you don't want this to
>> exceed your capacity because ran back to back the one cpu will still be
>> mostly idle.
>>
>> What you want it to keep track of a per-cpu utilization level (inverse
>> of idle-time) and using PJTs per-task runnable avg see if placing the
>> new task on will exceed the utilization limit.
>>
>> I think some of the Linaro people actually played around with this,
>> Vincent?
>>
>
> I agree. A better measure of cpu load and task weight than nr_running
> and the current task load weight are necessary to do proper task
> packing.
>
> I have used PJTs per-task load-tracking for scheduling experiments on
> heterogeneous systems and my experience is that it works quite well for
> determining the load of a specific task. Something like PJTs work
> would be a good starting point for power aware scheduling and better
> support for heterogeneous systems.
>

I didn't tried PJTs work myself (it's on my todo list), but with 
SCHED_DEADLINE you can see the picture from the other side and, instead 
of tracking per-task load, you can enforce a task not to exceed its 
allowed "load".
This is done reserving some fraction of CPU time (runtime or budget) 
every predefined interval of time (period). Than this allocated 
bandwidth is enforced with proper scheduling mechanisms (BTW, I have 
another talk at Plumbers explaining the SCHED_DEADLINE patchset in more 
details).

> One of the biggest challenges here for load-balancing is translating
> task load from one cpu to another as the task load is influenced by the
> total load of its cpu. So a task that appears to be heavy on an
> oversubscribed cpu might not be so heavy after all when it is moved to a
> cpu with plenty cpu time to spare. This issue is likely to be more
> pronounced on heterogeneous systems and system with aggressive frequency
> scaling. It might be possible to avoid having to translate load or that
> it doesn't really matter, but I haven't completely convinced myself yet.
>

This is probably a key point where deadline scheduling could be helpful. 
A task load in this case cannot be influenced by other tasks in the 
system and it is one of the known variables. Actually, this is however 
half true. Isolation is achieved only considering CPU time between 
concurrently executing task, other terms like cache interferences etc. 
cannot be controlled. The nice fact is that a misbehaving task, one that 
tries or experiments deviations from its allowed CPU fraction, is 
throttled and cannot influence other tasks behavior.
As I will show during my talk (power aware deadline scheduling), other 
techniques are required when a task execution time it is not stricly 
known beforehand, beeing this due to interferences or intrinsic 
variability on the performed activity. They fall in the domain of 
adaptive/feedback scheduling.

> My point is that getting the task load right or at least better is a
> fundamental requirement for improving power aware scheduling.
>

Fully agree :-).

As I said, I just wanted to add something, sorry if I misinterpret the 
purpose of this discussion.

Best Regards,

- Juri Lelli
