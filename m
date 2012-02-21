Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab2BUIkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 03:40:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57506 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab2BUIkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 03:40:09 -0500
Message-ID: <4F435966.9020106@cn.fujitsu.com>
Date: Tue, 21 Feb 2012 16:44:22 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu] rcu: direct algorithmic SRCU implementation
References: <20120213020951.GA12138@linux.vnet.ibm.com> <4F41F315.1040900@cn.fujitsu.com> <20120220174418.GI2470@linux.vnet.ibm.com> <4F42EF53.6060400@cn.fujitsu.com> <20120221015037.GE2384@linux.vnet.ibm.com>
In-Reply-To: <20120221015037.GE2384@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-21 16:38:13,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-21 16:38:27,
	Serialize complete at 2012-02-21 16:38:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 09:50 AM, Paul E. McKenney wrote:
> On Tue, Feb 21, 2012 at 09:11:47AM +0800, Lai Jiangshan wrote:
>> On 02/21/2012 01:44 AM, Paul E. McKenney wrote:
>>
>>>
>>>> My conclusion, we can just remove the check-and-return path to reduce
>>>> the complexity since we will introduce call_srcu().
>>>
>>> If I actually submit the above upstream, that would be quite reasonable.
>>> My thought is that patch remains RFC and the upstream version has
>>> call_srcu().
>>
>> Does the work of call_srcu() is started or drafted?
> 
> I do have a draft design, and am currently beating it into shape.
> No actual code yet, though.  The general idea at the moment is as follows:

If you don't mind, I will implement it.(it requires your new version of SRCU implementation)

> 
> o	The state machine must be preemptible.	I recently received
> 	a bug report about 200-microsecond latency spikes on a system
> 	with more than a thousand CPUs, so the summation of the per-CPU
> 	counters and subsequent recheck cannot be in a preempt-disable
> 	region.  I am therefore currently thinking in terms of a kthread.

sure.

Addition:
	Srcu callbacks must run on process context and sleepable,
	(and therefore they finish orderless). We can't change
	the current rcu-callback, we must design a new for srcu.
	These do not introduce any complexity, we reuse the workqueue.
	All ready srcu-callback will be delivered to workqueue.
	so state-machine-thread only to do counter summation
	and checking and delivering.

	workqueue do all the complexity for us, it will auto
	alloc threads when needed(when the callback is sleep, or
	there are too much ready callbacks).

	struct srcu_head is a little bigger than struct rcu_head, 
	it contain a union for struct work_struct.

	(synchronize_srcu()'s callbacks are special handled)

> 
> o	At the moment, having a per-srcu_struct kthread seems excessive.
> 	I am planning on a single kthread to do the counter summation
> 	and checking.  Further parallelism might be useful in the future,
> 	but I would want to see someone run into problems before adding
> 	more complexity.

Simple is important, I vote for a single kthread to do the counter summation
and checking, and left the convenient that we can introduce parallelism
thread easy.

> 
> o	There needs to be a linked list of srcu_struct structures so
> 	that they can be traversed by the state-machine kthread.
> 
> o	If there are expedited SRCU callbacks anywhere, the kthread
> 	would scan through the list of srcu_struct structures quickly
> 	(perhaps pausing a few microseconds between).  If there are no
> 	expedited SRCU callbacks, the kthread would wait a jiffy or so
> 	between scans.

Sure
But I think generic expedited SRCU callbacks are make no sense,
we could just allow expedited SRCU callbacks for synchronize_srcu_expedited()
only.

> 
> o	If a given srcu_struct structure has been scanned too many times
> 	(say, more than ten times) while waiting for the counters to go
> 	to zero, it loses expeditedness.  It makes no sense for the kthread
> 	to go CPU-bound just because some SRCU reader somewhere is blocked
> 	in its SRCU read-side critical section.
> 
> o	Expedited SRCU callbacks cannot be delayed by normal SRCU
> 	callbacks, but neither can expedited callbacks be allowed to
> 	starve normal callbacks.  I am thinking in terms of invoking these
> 	from softirq context, with a pair of multi-tailed callback queues
> 	per CPU, stored in the same structure as the per-CPU counters.

My Addition design, callbacks are not running in softirq context.
And state-machine-thread is not delay by any normal callbacks.

But all synchronize_srcu()'s callback are done in state-machine-thread
(it is just a wake up), not in workqueue.

Since we allow expedited SRCU callbacks for synchronize_srcu_expedited() only,
Expedited SRCU callbacks will not be delayed by normal srcu callbacks.

I don't think we need to use per CPU callback queues, since SRCU callbacks
are rare(compared to rcu callbacks)

> 
> o	There are enough srcu_struct structures in the Linux that
> 	it does not make sense to force softirq to dig through them all
> 	any time any one of them has callbacks ready to invoke.  One way
> 	to deal with this is to have a per-CPU set of linked lists of
> 	of srcu_struct_array structures, so that the kthread enqueues
> 	a given structure when it transitions to having callbacks ready
> 	to invoke, and softirq dequeues it.  This can be done locklessly
> 	given that there is only one producer and one consumer.
> 
> o	We can no longer use the trick of pushing callbacks to another
> 	CPU from the CPU_DYING notifier because it is likely that CPU
> 	hotplug will stop using stop_cpus().  I am therefore thinking
> 	in terms of a set of orphanages (two for normal, two more for
> 	expedited -- one set of each for callbacks ready to invoke,
> 	the other for still-waiting callbacks).

no such issues in srcu.c if we use workqueue.

> 
> o	There will need to be an srcu_barrier() that can be called
> 	before cleanup_srcu_struct().  Otherwise, someone will end up
> 	freeing up an srcu_struct that still has callbacks outstanding.

Sure.

when use workqueue, the delivering is ordered.

srcu_barrier()
{
	synchronzie_srcu();
	flush_workqueue();
}


> 
> But what did you have in mind?

I agree most of your design, but my relaxing the ability for callbacks and
using workqueue ideas make things simpler.

Thanks,
Lai

> 
>>>> This new srcu is very great, especially the SRCU_USAGE_COUNT for every
>>>> lock/unlock witch forces any increment/decrement pair changes the counter
>>>> for me.
>>>
>>> Glad you like it!  ;-)
>>>
>>> And thank you for your review and feedback!
>>
>> Could you add my Reviewed-by when this patch is last submitted?
>>
>>
>> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Will do, thank you!
> 
> 							Thanx, Paul
> 
> 

