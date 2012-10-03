Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab2JCJ7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 05:59:31 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:34997 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab2JCJ73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 05:59:29 -0400
Message-ID: <506C0C39.1060302@linux.vnet.ibm.com>
Date: Wed, 03 Oct 2012 15:28:17 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: paulmck@linux.vnet.ibm.com, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
Subject: Re: Lockdep complains about commit 1331e7a1bb ("rcu: Remove _rcu_barrier()
 dependency on __stop_machine()")
References: <alpine.LNX.2.00.1210021810350.23544@pobox.suse.cz> <506B50F1.8070907@linux.vnet.ibm.com> <alpine.LNX.2.00.1210030008590.23544@pobox.suse.cz> <506BB283.4010800@linux.vnet.ibm.com> <20121003034405.GB13192@linux.vnet.ibm.com> <506BB950.3000102@linux.vnet.ibm.com> <alpine.LNX.2.00.1210030937490.23544@pobox.suse.cz> <506BF339.6020201@linux.vnet.ibm.com> <alpine.LNX.2.00.1210031013110.23544@pobox.suse.cz> <506BF795.7000604@linux.vnet.ibm.com> <alpine.LNX.2.00.1210031107050.23544@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1210031107050.23544@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12100309-5490-0000-0000-00000239DE18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 02:54 PM, Jiri Kosina wrote:
> On Wed, 3 Oct 2012, Srivatsa S. Bhat wrote:
> 
>>>> static void cpu_hotplug_begin(void)
>>>> {
>>>>         cpu_hotplug.active_writer = current;
>>>>
>>>>         for (;;) {
>>>>                 mutex_lock(&cpu_hotplug.lock);
>>>>                 if (likely(!cpu_hotplug.refcount))   <================ This one!
>>>>                         break;
>>>>                 __set_current_state(TASK_UNINTERRUPTIBLE);
>>>>                 mutex_unlock(&cpu_hotplug.lock);
>>>>                 schedule();
>>>>         }   
>>>> }
>>>
>>> I acutally just came to the same conclusion (7 hours of sleep later, the 
>>> mind indeed seems to be brighter ... what a poet I am).
>>>
>>> Lockdep doesn't know about this semantics of cpu_hotplug_begin(), and 
>>> therefore gets confused by the fact that mutual exclusion is actually 
>>> achieved through the refcount instead of mutex (and the same apparently 
>>> happened to me).
>>
>> No, that's not the problem. Lockdep is fine. The calltrace clearly shows that
>> our refcounting has messed up somewhere. As a result, we really *are* running
>> a hotplug-reader and a hotplug-writer at the same time! We really need to fix
>> *that*! So please try the second debug patch I sent just now (with the BUG_ON()
>> in put_online_cpus()). We need to know who is calling put_online_cpus() twice
>> and fix that culprit!
> 
> I don't think so.
> 
> Lockdep is complaining, because
> 
> (a) during system bootup, the smp_init() -> cpu_up() -> cpuup_callback() 
>     teaches him about hotplug.lock -> slab_mutex dependency
> 
> (b) many many jiffies later, nf_conntrack_cleanup_net() calls 
>     kmem_cache_destroy(), which introduces slab_mutex -> hotplug.lock 
>     dependency
> 
> Lockdep rightfully (from his POV) sees this as potential ABBA, and reports 
> it, it's as simple as that.
> It has no way of knowing the fact that the ABBA can actually never happen, 
> because of special semantics of cpu_hotplug.refcount and it's handling in 
> cpu_hotplug_begin().
>

Hmm, you are right.
 
> The "neither cpu_up() nor cpu_down() will proceed past cpu_hotplug_begin() 
> until everyone who called get_online_cpus() will call put_online_cpus()" 
> is totally invisible to lockdep.

I see your point..

> 
>>> So right, now I agree that the deadlock scenario I have come up with is 
>>> indeed bogus (*), and we just have to annotate this fact to lockdep 
>>> somehow.
>>
>> Yes, the deadlock scenario is bogus, but the refcounting leak is for real
>> and needs fixing.
> 
> With your patch applied, the BUG_ON() in put_online_cpus() didn't trigger 
> for me at all. Which is what I expected.

Oh, ok..

> 
>> I'm fine with this, but the real problem is elsewhere, like I mentioned above.
>> This one is only a good-to-have, not a fix.
>>  
>>> (*) I have seen machine locking hard reproducibly, but that was only with 
>>> additional Paul's patch, so I guess the lock order there actually was 
>>> wrong
>>
>> If refcounting was working fine, Paul's patch wouldn't have caused *any* issues.
>> With that patch in place, the 2 places where rcu_barrier() get invoked (ie.,
>> kmem_cache_destroy() and deactivate_locked_super()) both start waiting on
>> get_online_cpus() until the slab cpu hotplug notifier as well as the entire
>> cpu_up operation completes. Absolutely no problem in that! So the fact that
>> you are seeing lock-ups here is another indication that the problem is really
>> elsewhere!
> 
> I don't agree. The reason why Paul's patch (1331e7a1bb) started to trigger 
> this, is that (b) above doesn't exist in pre-1331e7a1bb kernels.
>

So basically what you are saying is, the calltraces in the lockdep splat are from
different points in time right? Then I see why its just a false positive and not
a real bug.
 
Regards,
Srivatsa S. Bhat

