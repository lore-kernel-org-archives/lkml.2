Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750761Ab2JCEFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 00:05:20 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:42481 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab2JCEFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 00:05:18 -0400
Message-ID: <506BB950.3000102@linux.vnet.ibm.com>
Date: Wed, 03 Oct 2012 09:34:32 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Jiri Kosina <jkosina@suse.cz>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
Subject: Re: Lockdep complains about commit 1331e7a1bb ("rcu: Remove _rcu_barrier()
 dependency on __stop_machine()")
References: <alpine.LNX.2.00.1210021810350.23544@pobox.suse.cz> <506B50F1.8070907@linux.vnet.ibm.com> <alpine.LNX.2.00.1210030008590.23544@pobox.suse.cz> <506BB283.4010800@linux.vnet.ibm.com> <20121003034405.GB13192@linux.vnet.ibm.com>
In-Reply-To: <20121003034405.GB13192@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12100304-6102-0000-0000-000002525B8C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 09:14 AM, Paul E. McKenney wrote:
> On Wed, Oct 03, 2012 at 09:05:31AM +0530, Srivatsa S. Bhat wrote:
>> On 10/03/2012 03:47 AM, Jiri Kosina wrote:
>>> On Wed, 3 Oct 2012, Srivatsa S. Bhat wrote:
>>>
>>>> I don't see how this circular locking dependency can occur.. If you are using SLUB,
>>>> kmem_cache_destroy() releases slab_mutex before it calls rcu_barrier(). If you are
>>>> using SLAB, kmem_cache_destroy() wraps its whole operation inside get/put_online_cpus(),
>>>> which means, it cannot run concurrently with a hotplug operation such as cpu_up(). So, I'm
>>>> rather puzzled at this lockdep splat..
>>>
>>> I am using SLAB here.
>>>
>>> The scenario I think is very well possible:
>>>
>>>
>>> 	CPU 0				CPU 1
>>> 	kmem_cache_destroy()
>>
>> What about the get_online_cpus() right here at CPU0 before
>> calling mutex_lock(slab_mutex)? How can the cpu_up() proceed
>> on CPU1?? I still don't get it... :(
>>
>> (kmem_cache_destroy() uses get/put_online_cpus() around acquiring
>> and releasing slab_mutex).
> 
> The problem is that there is a CPU-hotplug notifier for slab, which
> establishes hotplug->slab.

Agreed.

>  Then having kmem_cache_destroy() call
> rcu_barrier() under the lock

Ah, that's where I disagree. kmem_cache_destroy() *cannot* proceed at
this point in time, because it has invoked get_online_cpus()! It simply
cannot be running past that point in the presence of a running hotplug
notifier! So, kmem_cache_destroy() should have been sleeping on the
hotplug lock, waiting for the notifier to release it, no?

> establishes slab->hotplug, which results
> in deadlock.  Jiri really did explain this in an earlier email
> message, but both of us managed to miss it.  ;-)
> 

Maybe I'm just being blind, sorry! ;-)

Regards,
Srivatsa S. Bhat

> 							Thanx, Paul
> 
>> Regards,
>> Srivatsa S. Bhat
>>
>>> 	mutex_lock(slab_mutex)
>>> 	 				_cpu_up()
>>> 					cpu_hotplug_begin()
>>> 					mutex_lock(cpu_hotplug.lock)
>>> 	rcu_barrier()
>>> 	_rcu_barrier()
>>> 	get_online_cpus()
>>> 	mutex_lock(cpu_hotplug.lock)
>>> 	 (blocks, CPU 1 has the mutex)
>>> 					__cpu_notify()
>>> 					mutex_lock(slab_mutex)
>>>
>>> Deadlock.
>>>
>>> Right?
>>>
>>
>>

