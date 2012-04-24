Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab2DXRro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:47:44 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:36294 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab2DXRrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:47:43 -0400
Message-ID: <4F96E6FA.40900@linux.vnet.ibm.com>
Date: Tue, 24 Apr 2012 23:16:34 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>, venki@google.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFC tip/core/rcu 1/6] rcu: Stabilize use of num_online_cpus()
 for GP short circuit
References: <20120423164159.GA13819@linux.vnet.ibm.com> <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com> <4F96C838.3090309@linux.vnet.ibm.com> <20120424165056.GB2403@linux.vnet.ibm.com>
In-Reply-To: <20120424165056.GB2403@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12042417-2000-0000-0000-0000073BED3D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 10:20 PM, Paul E. McKenney wrote:

> On Tue, Apr 24, 2012 at 09:05:20PM +0530, Srivatsa S. Bhat wrote:
> 
>>
>>> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
>>>
>>> The rcu_blocking_is_gp() function tests to see if there is only one
>>> online CPU, and if so, synchronize_sched() and friends become no-ops.
>>> However, for larger systems, num_online_cpus() scans a large vector,
>>
>>
>> Venki had posted a patch to optimize that by using a variable, so that we
>> don't calculate the value each and every time.
>> http://thread.gmane.org/gmane.linux.kernel/1240569/focus=1246659
>>
>> However, unfortunately there was some confusion around that patch and
>> even though it made it to akpm's tree and stayed there briefly, it didn't
>> go upstream. Venki had attempted to resolve the confusion here:
>> http://thread.gmane.org/gmane.linux.kernel/1240569/focus=1260702
> 
> Having a single variable tracking the online state would be good,
> but as you say it isn't there yet.
> 
>>> and might be preempted while doing so.  While preempted, any number
>>> of CPUs might come online and go offline, potentially resulting in
>>> num_online_cpus() returning 1 when there never had only been one
>>> CPU online.  This would result in a too-short RCU grace period, which
>>> could in turn result in total failure.
>>
>>
[...]

> 
> The problematic case is instead the one where we were SMP throughout,
> but rcu_blocking_is_gp() mistakenly decides that we were UP.  For example,
> consider the following sequence of events, based on the commit log's
> sentence "While preempted, any number of CPUs might come online and go
> offline, potentially resulting in num_online_cpus() returning 1 when
> there never had only been one CPU online":
> 


Oh, I didn't think in the direction illustrated below when reading that
sentence.. :-(

> o	CPUs 100 and 150 are initially online, with a long-running RCU
> 	read-side critical section on CPU 100 and rcu_blocking_is_gp()
> 	initially running on CPU 150.
> 
> o	The rcu_blocking_is_gp() function checks the bits for CPUs
> 	0-63, and counts zero online CPUs.
> 
> o	CPU 1 comes online.
> 
> o	The rcu_blocking_is_gp() function checks the bits for CPUs
> 	64-127, and counts one online CPUs, for a total thus far
> 	of one CPU online..
> 
> o	CPU 150 goes offline.  Ah, but it cannot do this, because
> 	this is non-preemptible RCU, which means that the RCU
> 	read-side critical section has disabled preemption on
> 	CPU 100, which prevents CPU 150 from going offline, which
> 	prevents this scenario from occurring.
> 
> 	So, yes, rcu_blocking_is_gp() can be fooled into incorrectly
> 	stating that the system has only one CPU (or even that it has
> 	only zero CPUs), but not while there is actually a non-preemptible
> 	RCU read-side critical section running.  Yow!
>


Awesome :-)

 
> 	I clearly had not thought this change through far enough,
> 	thank you for calling it to my attention!
> 
> So I could replace this patch with a patch that adds a comment
> explaining why this works.


Yes, that would be great..

>  Though this patch might be simpler and
> easier to understand.  ;-)


Oh well, but I completely missed the intention behind the patch!
So I guess a comment would be better ;-)

>  But not so good for real-time response
> on large systems, I suppose.
> 
> And rcu_blocking_is_gp() is called only from synchronize_sched() and
> synchronize_rcu_bh(), so it is safe for all current callers.  But it is
> defined publicly, so I should move it to somewhere like kernel/rcutree.c
> to keep new users from being fatally confused and disappointed.
> 
> I can also change the comparison from "num_online_cpus() == 1" to
> "num_online_cpus() <= 1".  That should at least serve as a caution to
> people who might attempt to use it where it shouldn't be used.  ;-)
> 


Hehe, yeah!

Regards,
Srivatsa S. Bhat

