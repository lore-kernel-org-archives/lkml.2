Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab2BUBuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 20:50:51 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:33310 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab2BUBut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 20:50:49 -0500
Date: Mon, 20 Feb 2012 17:50:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu] rcu: direct algorithmic SRCU
 implementation
Message-ID: <20120221015037.GE2384@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120213020951.GA12138@linux.vnet.ibm.com>
 <4F41F315.1040900@cn.fujitsu.com>
 <20120220174418.GI2470@linux.vnet.ibm.com>
 <4F42EF53.6060400@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F42EF53.6060400@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022101-7282-0000-0000-000006B231E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 09:11:47AM +0800, Lai Jiangshan wrote:
> On 02/21/2012 01:44 AM, Paul E. McKenney wrote:
> 
> > 
> >> My conclusion, we can just remove the check-and-return path to reduce
> >> the complexity since we will introduce call_srcu().
> > 
> > If I actually submit the above upstream, that would be quite reasonable.
> > My thought is that patch remains RFC and the upstream version has
> > call_srcu().
> 
> Does the work of call_srcu() is started or drafted?

I do have a draft design, and am currently beating it into shape.
No actual code yet, though.  The general idea at the moment is as follows:

o	The state machine must be preemptible.	I recently received
	a bug report about 200-microsecond latency spikes on a system
	with more than a thousand CPUs, so the summation of the per-CPU
	counters and subsequent recheck cannot be in a preempt-disable
	region.  I am therefore currently thinking in terms of a kthread.

o	At the moment, having a per-srcu_struct kthread seems excessive.
	I am planning on a single kthread to do the counter summation
	and checking.  Further parallelism might be useful in the future,
	but I would want to see someone run into problems before adding
	more complexity.

o	There needs to be a linked list of srcu_struct structures so
	that they can be traversed by the state-machine kthread.

o	If there are expedited SRCU callbacks anywhere, the kthread
	would scan through the list of srcu_struct structures quickly
	(perhaps pausing a few microseconds between).  If there are no
	expedited SRCU callbacks, the kthread would wait a jiffy or so
	between scans.

o	If a given srcu_struct structure has been scanned too many times
	(say, more than ten times) while waiting for the counters to go
	to zero, it loses expeditedness.  It makes no sense for the kthread
	to go CPU-bound just because some SRCU reader somewhere is blocked
	in its SRCU read-side critical section.

o	Expedited SRCU callbacks cannot be delayed by normal SRCU
	callbacks, but neither can expedited callbacks be allowed to
	starve normal callbacks.  I am thinking in terms of invoking these
	from softirq context, with a pair of multi-tailed callback queues
	per CPU, stored in the same structure as the per-CPU counters.

o	There are enough srcu_struct structures in the Linux that
	it does not make sense to force softirq to dig through them all
	any time any one of them has callbacks ready to invoke.  One way
	to deal with this is to have a per-CPU set of linked lists of
	of srcu_struct_array structures, so that the kthread enqueues
	a given structure when it transitions to having callbacks ready
	to invoke, and softirq dequeues it.  This can be done locklessly
	given that there is only one producer and one consumer.

o	We can no longer use the trick of pushing callbacks to another
	CPU from the CPU_DYING notifier because it is likely that CPU
	hotplug will stop using stop_cpus().  I am therefore thinking
	in terms of a set of orphanages (two for normal, two more for
	expedited -- one set of each for callbacks ready to invoke,
	the other for still-waiting callbacks).

o	There will need to be an srcu_barrier() that can be called
	before cleanup_srcu_struct().  Otherwise, someone will end up
	freeing up an srcu_struct that still has callbacks outstanding.

But what did you have in mind?

> >> This new srcu is very great, especially the SRCU_USAGE_COUNT for every
> >> lock/unlock witch forces any increment/decrement pair changes the counter
> >> for me.
> > 
> > Glad you like it!  ;-)
> > 
> > And thank you for your review and feedback!
> 
> Could you add my Reviewed-by when this patch is last submitted?
> 
> 
> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Will do, thank you!

							Thanx, Paul

