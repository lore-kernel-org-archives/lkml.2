Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab2CAING (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:13:06 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:32950 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758640Ab2CAINB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:13:01 -0500
Message-ID: <4F4F2F7F.5040207@linux.vnet.ibm.com>
Date: Thu, 01 Mar 2012 13:42:47 +0530
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
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH] cpumask: fix lg_lock/br_lock.
References: <87ehtf3lqh.fsf@rustcorp.com.au> <20120227155338.7b5110cd.akpm@linux-foundation.org> <20120228084359.GJ21106@elte.hu> <20120228132719.f375071a.akpm@linux-foundation.org> <4F4DBB26.2060907@linux.vnet.ibm.com> <20120229091732.GA11505@elte.hu> <4F4E083A.2080304@linux.vnet.ibm.com>
In-Reply-To: <4F4E083A.2080304@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12030108-4790-0000-0000-00000196D40D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 04:42 PM, Srivatsa S. Bhat wrote:

> On 02/29/2012 02:47 PM, Ingo Molnar wrote:
> 
>>
>> * Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>>
>>> Hi Andrew,
>>>
>>> On 02/29/2012 02:57 AM, Andrew Morton wrote:
>>>
>>>> On Tue, 28 Feb 2012 09:43:59 +0100
>>>> Ingo Molnar <mingo@elte.hu> wrote:
>>>>
>>>>> This patch should also probably go upstream through the 
>>>>> locking/lockdep tree? Mind sending it us once you think it's 
>>>>> ready?
>>>>
>>>> Oh goody, that means you own
>>>> http://marc.info/?l=linux-kernel&m=131419353511653&w=2.
>>>>
>>>
>>>
>>> That bug got fixed sometime around Dec 2011. See commit e30e2fdf
>>> (VFS: Fix race between CPU hotplug and lglocks)
>>
>> The lglocks code is still CPU-hotplug racy AFAICS, despite the 
>> ->cpu_lock complication:
>>
>> Consider a taken global lock on a CPU:
>>
>> 	CPU#1
>> 	...
>> 	br_write_lock(vfsmount_lock);
>>
>> this takes the lock of all online CPUs: say CPU#1 and CPU#2. Now 
>> CPU#3 comes online and takes the read lock:
> 
> 
> CPU#3 cannot come online! :-)
> 
> No new CPU can come online until that corresponding br_write_unlock()
> is completed. That is because  br_write_lock acquires &name##_cpu_lock
> and only br_write_unlock will release it.
> And, CPU_UP_PREPARE callback tries to acquire that very same spinlock,
> and hence will keep spinning until br_write_unlock() is run. And hence,
> the CPU#3 or any new CPU online for that matter will not complete until
> br_write_unlock() is done.
> 
> It is of course debatable as to how good this design really is, but IMHO,
> the lglocks code is not CPU-hotplug racy now..
> 
> Here is the link to the original discussion during the development of
> that patch: thread.gmane.org/gmane.linux.file-systems/59750/
> 
>>
>> 			CPU#3
>> 			br_read_lock(vfsmount_lock);
>>
>> This will succeed while the br_write_lock() is still active, 
>> because CPU#1 has only taken the locks of CPU#1 and CPU#2. 
>>
>> Crash!
>>
>> The proper fix would be for CPU-online to serialize with all 
>> known lglocks, via the notifier callback, i.e. to do something 
>> like this:
>>
>>         case CPU_UP_PREPARE:                                            
>> 		for_each_online_cpu(cpu) {
>> 	                spin_lock(&name##_cpu_lock);                            
>> 	                spin_unlock(&name##_cpu_lock);
>> 		}
>> 	...
>>
>> I.e. in essence do:
>>
>>         case CPU_UP_PREPARE:                                            
>> 		name##_global_lock_online();
>> 		name##_global_unlock_online();
>>
>> Another detail I noticed, this bit:
>>
>>         register_hotcpu_notifier(&name##_lg_cpu_notifier);              \
>>         get_online_cpus();                                              \
>>         for_each_online_cpu(i)                                          \
>>                 cpu_set(i, name##_cpus);                                \
>>         put_online_cpus();                                              \
>>
>> could be something simpler and loop-less, like:
>>
>>         get_online_cpus();
>> 	cpumask_copy(name##_cpus, cpu_online_mask);
>> 	register_hotcpu_notifier(&name##_lg_cpu_notifier);
>> 	put_online_cpus();
>>
> 
> 
> While the cpumask_copy is definitely better, we can't put the
> register_hotcpu_notifier() within get/put_online_cpus() because it will
> lead to ABBA deadlock with a newly initiated CPU Hotplug operation, the
> 2 locks involved being the cpu_add_remove_lock and the cpu_hotplug lock.
> 
> IOW, at the moment there is no "absolutely race-free way" way to do
> CPU Hotplug callback registration. Some time ago, while going through the
> asynchronous booting patch by Arjan [1] I had written up a patch to fix
> that race because that race got transformed from "purely theoretical"
> to "very real" with the async boot patch, as shown by the powerpc boot
> failures [2].
> 
> But then I stopped short of posting that patch to the lists because I
> started wondering how important that race would actually turn out to be,
> in case the async booting design takes a totally different approach
> altogether.. [And the reason why I didn't post it is also because it
> would require lots of changes in many parts where CPU Hotplug registration
> is done, and that wouldn't probably be justified (I don't know..) if the
> race remained only theoretical, as it is now.]
> 
> [1]. http://thread.gmane.org/gmane.linux.kernel/1246209
> [2]. https://lkml.org/lkml/2012/2/13/383
>  


Ok, now that I mentioned about my patch, let me as well show it some daylight..
It is totally untested, incomplete and probably won't even compile.. (given
that I had abandoned working on it some time ago, since I was not sure in
what direction the async boot design was headed, which was the original
motivation for me to try to fix this race)

I really hate to post it when it is in such a state, but atleast let me get
the idea out, now that the discussion is around it, atleast just to get some
thoughts about whether it is even worth pursuing! 
(I'll post the patches as a reply to this mail.)

By the way, it should solve the powerpc boot failure, atleast in principle,
considering what the root cause of the failure was..

Regards,
Srivatsa S. Bhat

