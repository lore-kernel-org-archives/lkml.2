Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab2JCIbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 04:31:07 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:43198 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2JCIa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 04:30:59 -0400
Message-ID: <506BF795.7000604@linux.vnet.ibm.com>
Date: Wed, 03 Oct 2012 14:00:13 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: paulmck@linux.vnet.ibm.com, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
Subject: Re: Lockdep complains about commit 1331e7a1bb ("rcu: Remove _rcu_barrier()
 dependency on __stop_machine()")
References: <alpine.LNX.2.00.1210021810350.23544@pobox.suse.cz> <506B50F1.8070907@linux.vnet.ibm.com> <alpine.LNX.2.00.1210030008590.23544@pobox.suse.cz> <506BB283.4010800@linux.vnet.ibm.com> <20121003034405.GB13192@linux.vnet.ibm.com> <506BB950.3000102@linux.vnet.ibm.com> <alpine.LNX.2.00.1210030937490.23544@pobox.suse.cz> <506BF339.6020201@linux.vnet.ibm.com> <alpine.LNX.2.00.1210031013110.23544@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1210031013110.23544@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12100308-0260-0000-0000-000001EDDD27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 01:49 PM, Jiri Kosina wrote:
> On Wed, 3 Oct 2012, Srivatsa S. Bhat wrote:
> 
>> On 10/03/2012 01:13 PM, Jiri Kosina wrote:
>>> On Wed, 3 Oct 2012, Srivatsa S. Bhat wrote:
>>>
>>>>>>> 	CPU 0				CPU 1
>>>>>>> 	kmem_cache_destroy()
>>>>>>
>>>>>> What about the get_online_cpus() right here at CPU0 before
>>>>>> calling mutex_lock(slab_mutex)? How can the cpu_up() proceed
>>>>>> on CPU1?? I still don't get it... :(
>>>>>>
>>>>>> (kmem_cache_destroy() uses get/put_online_cpus() around acquiring
>>>>>> and releasing slab_mutex).
>>>>>
>>>>> The problem is that there is a CPU-hotplug notifier for slab, which
>>>>> establishes hotplug->slab.
>>>>
>>>> Agreed.
>>>>
>>>>>  Then having kmem_cache_destroy() call
>>>>> rcu_barrier() under the lock
>>>>
>>>> Ah, that's where I disagree. kmem_cache_destroy() *cannot* proceed at
>>>> this point in time, because it has invoked get_online_cpus()! It simply
>>>> cannot be running past that point in the presence of a running hotplug
>>>> notifier! So, kmem_cache_destroy() should have been sleeping on the
>>>> hotplug lock, waiting for the notifier to release it, no?
>>>
>>> Please look carefully at the scenario again. kmem_cache_destroy() calls 
>>> get_online_cpus() before the hotplug notifier even starts. Hence it has no 
>>> reason to block there (noone is holding hotplug lock).
>>>
>>
>> Agreed.
>>
>>> *Then* hotplug notifier fires up, succeeds obtaining hotplug lock, 
>>
>> Ah, that's the problem! The hotplug reader-writer synchronization is not just
>> via a simple mutex. Its a refcount underneath. If kmem_cache_destroy() incremented
>> the refcount, the hotplug-writer (cpu_up) will release the hotplug lock immediately
>> and try again. IOW, a hotplug-reader (kmem_cache_destroy()) and a hotplug-writer
>> (cpu_up) can *NEVER* run concurrently. If they do, we are totally screwed!
>>
>>
>> Take a look at the hotplug lock acquire function at the writer side:
>>
>> static void cpu_hotplug_begin(void)
>> {
>>         cpu_hotplug.active_writer = current;
>>
>>         for (;;) {
>>                 mutex_lock(&cpu_hotplug.lock);
>>                 if (likely(!cpu_hotplug.refcount))   <================ This one!
>>                         break;
>>                 __set_current_state(TASK_UNINTERRUPTIBLE);
>>                 mutex_unlock(&cpu_hotplug.lock);
>>                 schedule();
>>         }   
>> }
> 
> I acutally just came to the same conclusion (7 hours of sleep later, the 
> mind indeed seems to be brighter ... what a poet I am).
> 
> Lockdep doesn't know about this semantics of cpu_hotplug_begin(), and 
> therefore gets confused by the fact that mutual exclusion is actually 
> achieved through the refcount instead of mutex (and the same apparently 
> happened to me).

No, that's not the problem. Lockdep is fine. The calltrace clearly shows that
our refcounting has messed up somewhere. As a result, we really *are* running
a hotplug-reader and a hotplug-writer at the same time! We really need to fix
*that*! So please try the second debug patch I sent just now (with the BUG_ON()
in put_online_cpus()). We need to know who is calling put_online_cpus() twice
and fix that culprit!

> 
> So right, now I agree that the deadlock scenario I have come up with is 
> indeed bogus (*), and we just have to annotate this fact to lockdep 
> somehow.

Yes, the deadlock scenario is bogus, but the refcounting leak is for real
and needs fixing.

> 
> And I actually believe that moving the slab_mutex around in 
> kmem_cache_destroy() is a good anotation (maybe worth a separate comment 
> in the code), as it not only makes the lockdep false positive go away, but 
> it also reduces the mutex hold time.
>

I'm fine with this, but the real problem is elsewhere, like I mentioned above.
This one is only a good-to-have, not a fix.
 
> (*) I have seen machine locking hard reproducibly, but that was only with 
> additional Paul's patch, so I guess the lock order there actually was 
> wrong

If refcounting was working fine, Paul's patch wouldn't have caused *any* issues.
With that patch in place, the 2 places where rcu_barrier() get invoked (ie.,
kmem_cache_destroy() and deactivate_locked_super()) both start waiting on
get_online_cpus() until the slab cpu hotplug notifier as well as the entire
cpu_up operation completes. Absolutely no problem in that! So the fact that
you are seeing lock-ups here is another indication that the problem is really
elsewhere!

Regards,
Srivatsa S. Bhat

