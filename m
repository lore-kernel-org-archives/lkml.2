Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946916Ab2LFTTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:19:06 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47806 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946899Ab2LFTTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:19:03 -0500
Message-ID: <50C0EF49.8050700@linux.vnet.ibm.com>
Date: Fri, 07 Dec 2012 00:47:29 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: tj@kernel.org, tglx@linutronix.de, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org,
        vincent.guittot@linaro.org, sbw@mit.edu, amit.kucheria@linaro.org,
        rostedt@goodmis.org, rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 01/10] CPU hotplug: Provide APIs for "light"	atomic
 readers to prevent CPU offline
References: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com> <20121205184258.3750.31879.stgit@srivatsabhat.in.ibm.com> <50BF96DF.3000500@linux.vnet.ibm.com> <50BF979A.50304@linux.vnet.ibm.com> <50BF982D.7090704@linux.vnet.ibm.com> <50BF98F7.3030600@linux.vnet.ibm.com> <50BF999C.6030707@linux.vnet.ibm.com> <50BFAB17.3090603@linux.vnet.ibm.com> <20121206161850.GA6710@redhat.com> <50C0E88E.9050909@linux.vnet.ibm.com>
In-Reply-To: <50C0E88E.9050909@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120619-6102-0000-0000-000002AD59DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2012 12:18 AM, Srivatsa S. Bhat wrote:
> On 12/06/2012 09:48 PM, Oleg Nesterov wrote:
>> On 12/06, Srivatsa S. Bhat wrote:
>>>
>>> +void get_online_cpus_atomic(void)
>>> +{
>>> +	int c, old;
>>> +
>>> +	preempt_disable();
>>> +	read_lock(&hotplug_rwlock);
>>
>> Confused... Why it also takes hotplug_rwlock?
> 
> To avoid ABBA deadlocks.
> 
> hotplug_rwlock was meant for the "light" readers.
> The atomic counters were meant for the "heavy/full" readers.
> I wanted them to be able to nest in any manner they wanted,
> such as:
> 
> Full inside light:
> 
> get_online_cpus_atomic_light()
> 	...
> 	get_online_cpus_atomic_full()
> 	...
> 	put_online_cpus_atomic_full()
> 	...
> put_online_cpus_atomic_light()
> 
> Or, light inside full:
> 
> get_online_cpus_atomic_full()
> 	...
> 	get_online_cpus_atomic_light()
> 	...
> 	put_online_cpus_atomic_light()
> 	...
> put_online_cpus_atomic_full()
> 
> To allow this, I made the two sets of APIs take the locks
> in the same order internally.
> 
> (I had some more description of this logic in the changelog
> of 2/10; the only difference there is that instead of atomic
> counters, I used rwlocks for the full-readers as well.
> https://lkml.org/lkml/2012/12/5/320)
> 

One of the reasons why I changed everybody to global rwlocks
instead of per-cpu atomic counters was to avoid lock ordering
related deadlocks associated with per-cpu locking.

Eg:

CPU 0                         CPU 1
------                        ------

1. Acquire lock A             Increment CPU1's
                              atomic counter



2. Increment CPU0's            Try to acquire lock A
   atomic counter


Now consider what happens if a hotplug writer (cpu_down) begins,
and starts looking at CPU0, to try to decrement its atomic counter,
in between steps 1 and 2.

The hotplug writer will be successful in CPU0 because CPU0 hasn't
yet incremented its counter. So, now CPU0 spins waiting for the
hotplug writer to reset the atomic counter again.

When the hotplug writer looks at CPU1, it can't decrement the
atomic counter because CPU1 has already incremented it. So the
hotplug writer waits. CPU1 goes ahead, only to start spinning on
lock A which was acquired by CPU0. So we end up in a deadlock due
to circular locking dependency between the 3 entities.

One way to deal with this would be that the writer should abort
its loop of trying to atomic_dec per-cpu counters, whenever it has
to wait. But that might prove to be too wasteful (and overly
paranoid) in practice.

So, instead, if we have global locks (like global rwlocks that I
finally used when posting out this v2), then we won't end up in
such messy issues.

And why exactly was I concerned about all this?
Because, the current code uses the extremely flexible preempt_disable()
/preempt_enable() pair which impose absolutely no ordering
restrictions. And probably the existing code _depends_ on that.
So if our new APIs that replace preempt_disable/enable start
imposing ordering restrictions, I feared that they might become
unusable. Hence I used global rwlocks, thereby trading cache-line
bouncing (due to global rwlocks) for lock-safety and flexibility.

Regards,
Srivatsa S. Bhat

