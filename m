Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab2CAJPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 04:15:46 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:50052 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757663Ab2CAJPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 04:15:40 -0500
Message-ID: <4F4F3E16.5080703@linux.vnet.ibm.com>
Date: Thu, 01 Mar 2012 14:45:02 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <ak@linux.intel.com>, linux-fsdevel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, mc@linux.vnet.ibm.com
Subject: Re: [PATCH] cpumask: fix lg_lock/br_lock.
References: <87ehtf3lqh.fsf@rustcorp.com.au> <20120227155338.7b5110cd.akpm@linux-foundation.org> <20120228084359.GJ21106@elte.hu> <20120228132719.f375071a.akpm@linux-foundation.org> <4F4DBB26.2060907@linux.vnet.ibm.com> <20120229091732.GA11505@elte.hu> <4F4E083A.2080304@linux.vnet.ibm.com> <20120301073845.GA5350@elte.hu>
In-Reply-To: <20120301073845.GA5350@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12030109-2674-0000-0000-00000386D6EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2012 01:08 PM, Ingo Molnar wrote:

> 
> * Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> 
>> On 02/29/2012 02:47 PM, Ingo Molnar wrote:
>>
>>>
>>> * Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>>>
>>>> Hi Andrew,
>>>>
>>>> On 02/29/2012 02:57 AM, Andrew Morton wrote:
>>>>
>>>>> On Tue, 28 Feb 2012 09:43:59 +0100
>>>>> Ingo Molnar <mingo@elte.hu> wrote:
>>>>>
>>>>>> This patch should also probably go upstream through the 
>>>>>> locking/lockdep tree? Mind sending it us once you think it's 
>>>>>> ready?
>>>>>
>>>>> Oh goody, that means you own
>>>>> http://marc.info/?l=linux-kernel&m=131419353511653&w=2.
>>>>>
>>>>
>>>>
>>>> That bug got fixed sometime around Dec 2011. See commit e30e2fdf
>>>> (VFS: Fix race between CPU hotplug and lglocks)
>>>
>>> The lglocks code is still CPU-hotplug racy AFAICS, despite the 
>>> ->cpu_lock complication:
>>>
>>> Consider a taken global lock on a CPU:
>>>
>>> 	CPU#1
>>> 	...
>>> 	br_write_lock(vfsmount_lock);
>>>
>>> this takes the lock of all online CPUs: say CPU#1 and CPU#2. Now 
>>> CPU#3 comes online and takes the read lock:
>>
>>
>> CPU#3 cannot come online! :-)
>>
>> No new CPU can come online until that corresponding br_write_unlock()
>> is completed. That is because  br_write_lock acquires &name##_cpu_lock
>> and only br_write_unlock will release it.
> 
> Indeed, you are right.
> 
> Note that ->cpu_lock is an entirely superfluous complication in 
> br_write_lock(): the whole CPU hotplug race can be addressed by 
> doing a br_write_lock()/unlock() barrier in the hotplug callback 


I don't think I understood your point completely, but please see below...

> ...

> 
>>> Another detail I noticed, this bit:
>>>
>>>         register_hotcpu_notifier(&name##_lg_cpu_notifier);              \
>>>         get_online_cpus();                                              \
>>>         for_each_online_cpu(i)                                          \
>>>                 cpu_set(i, name##_cpus);                                \
>>>         put_online_cpus();                                              \
>>>
>>> could be something simpler and loop-less, like:
>>>
>>>         get_online_cpus();
>>> 	cpumask_copy(name##_cpus, cpu_online_mask);
>>> 	register_hotcpu_notifier(&name##_lg_cpu_notifier);
>>> 	put_online_cpus();
>>>
>>
>>
>> While the cpumask_copy is definitely better, we can't put the 
>> register_hotcpu_notifier() within get/put_online_cpus() 
>> because it will lead to ABBA deadlock with a newly initiated 
>> CPU Hotplug operation, the 2 locks involved being the 
>> cpu_add_remove_lock and the cpu_hotplug lock.
>>
>> IOW, at the moment there is no "absolutely race-free way" way 
>> to do CPU Hotplug callback registration. Some time ago, while 
>> going through the asynchronous booting patch by Arjan [1] I 
>> had written up a patch to fix that race because that race got 
>> transformed from "purely theoretical" to "very real" with the 
>> async boot patch, as shown by the powerpc boot failures [2].
>>
>> But then I stopped short of posting that patch to the lists 
>> because I started wondering how important that race would 
>> actually turn out to be, in case the async booting design 
>> takes a totally different approach altogether.. [And the 
>> reason why I didn't post it is also because it would require 
>> lots of changes in many parts where CPU Hotplug registration 
>> is done, and that wouldn't probably be justified (I don't 
>> know..) if the race remained only theoretical, as it is now.]
> 
> A fairly simple solution would be to eliminate the _cpus mask as 
> well, and do a for_each_possible_cpu() loop in the super-slow 
> loop - like dozens and dozens of other places do it in the 
> kernel.
> 


(I am assuming you are referring to the lglocks problem here, and not to the
ABBA deadlock/racy registration etc discussed immediately above.)

We wanted to avoid doing for_each_possible_cpu() to avoid the unnecessary
performance hit. In fact, that was the very first solution proposed, by
Cong Meng. See this:

http://thread.gmane.org/gmane.linux.file-systems/59750/
http://thread.gmane.org/gmane.linux.file-systems/59750/focus=59751


So we developed a solution that avoids for_each_possible_cpu(), and yet
works. Also, another point to be noted is that (referring to your previous
mail actually), doing for_each_online_cpu() at CPU_UP_PREPARE time won't
really work since the cpus are marked online only much later. So, the
solution we chose was to keep a consistent _cpus mask throughout the
lock-unlock sequence and perform the per-cpu lock/unlock only on the cpus
in that cpu mask; and ensuring that that mask won't change in between...
and also by delaying any new CPU online event during that time period using
the new ->cpu_lock spinlock as I mentioned in the other mail.

This (complexity) explains why the commit message of e30e2fdf looks more
like a mathematical theorem ;-)

> At a first quick glance that way the code gets a lot simpler and 
> the only CPU hotplug related change needed are the CPU_* 
> callbacks to do the lock barrier.
> 


 

Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

