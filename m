Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab2DXQva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:51:30 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58659 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab2DXQv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:51:28 -0400
Date: Tue, 24 Apr 2012 09:50:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>, venki@google.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFC tip/core/rcu 1/6] rcu: Stabilize use of
 num_online_cpus() for GP short circuit
Message-ID: <20120424165056.GB2403@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120423164159.GA13819@linux.vnet.ibm.com>
 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <4F96C838.3090309@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F96C838.3090309@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042416-1780-0000-0000-000005038DB8
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000271; HX=3.00000187; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00133716; UDB=6.00031334; UTC=2012-04-24
 16:51:27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 09:05:20PM +0530, Srivatsa S. Bhat wrote:

Thank you for looking this over!

> On 04/23/2012 10:12 PM, Paul E. McKenney wrote:
> 
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > The rcu_blocking_is_gp() function tests to see if there is only one
> > online CPU, and if so, synchronize_sched() and friends become no-ops.
> > However, for larger systems, num_online_cpus() scans a large vector,
> 
> 
> Venki had posted a patch to optimize that by using a variable, so that we
> don't calculate the value each and every time.
> http://thread.gmane.org/gmane.linux.kernel/1240569/focus=1246659
> 
> However, unfortunately there was some confusion around that patch and
> even though it made it to akpm's tree and stayed there briefly, it didn't
> go upstream. Venki had attempted to resolve the confusion here:
> http://thread.gmane.org/gmane.linux.kernel/1240569/focus=1260702

Having a single variable tracking the online state would be good,
but as you say it isn't there yet.

> > and might be preempted while doing so.  While preempted, any number
> > of CPUs might come online and go offline, potentially resulting in
> > num_online_cpus() returning 1 when there never had only been one
> > CPU online.  This would result in a too-short RCU grace period, which
> > could in turn result in total failure.
> > 
> 
> 
> So, if I understand correctly, the "too-short RCU grace period being
> troublesome" case occurs when we move from UP to SMP (ie., RCU thought
> that the system is in UP judging by the value returned by num_online_cpus(),
> but underneath, some CPUs got onlined in the meantime and hence the system
> now became SMP).

No, the UP-to-SMP case is OK.  If we were UP at any point during the
execution of synchronize_rcu(), a non-preemptible RCU grace period can
be a no-op.

The problematic case is instead the one where we were SMP throughout,
but rcu_blocking_is_gp() mistakenly decides that we were UP.  For example,
consider the following sequence of events, based on the commit log's
sentence "While preempted, any number of CPUs might come online and go
offline, potentially resulting in num_online_cpus() returning 1 when
there never had only been one CPU online":

o	CPUs 100 and 150 are initially online, with a long-running RCU
	read-side critical section on CPU 100 and rcu_blocking_is_gp()
	initially running on CPU 150.

o	The rcu_blocking_is_gp() function checks the bits for CPUs
	0-63, and counts zero online CPUs.

o	CPU 1 comes online.

o	The rcu_blocking_is_gp() function checks the bits for CPUs
	64-127, and counts one online CPUs, for a total thus far
	of one CPU online..

o	CPU 150 goes offline.  Ah, but it cannot do this, because
	this is non-preemptible RCU, which means that the RCU
	read-side critical section has disabled preemption on
	CPU 100, which prevents CPU 150 from going offline, which
	prevents this scenario from occurring.

	So, yes, rcu_blocking_is_gp() can be fooled into incorrectly
	stating that the system has only one CPU (or even that it has
	only zero CPUs), but not while there is actually a non-preemptible
	RCU read-side critical section running.  Yow!

	I clearly had not thought this change through far enough,
	thank you for calling it to my attention!

So I could replace this patch with a patch that adds a comment
explaining why this works.  Though this patch might be simpler and
easier to understand.  ;-)  But not so good for real-time response
on large systems, I suppose.

And rcu_blocking_is_gp() is called only from synchronize_sched() and
synchronize_rcu_bh(), so it is safe for all current callers.  But it is
defined publicly, so I should move it to somewhere like kernel/rcutree.c
to keep new users from being fatally confused and disappointed.

I can also change the comparison from "num_online_cpus() == 1" to
"num_online_cpus() <= 1".  That should at least serve as a caution to
people who might attempt to use it where it shouldn't be used.  ;-)

> > This commit therefore protects the num_online_cpus() with preempt_disable().
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  include/linux/rcutree.h |    7 ++++++-
> >  1 files changed, 6 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> > index e8ee5dd..997179f 100644
> > --- a/include/linux/rcutree.h
> > +++ b/include/linux/rcutree.h
> > @@ -101,8 +101,13 @@ extern void rcu_sched_force_quiescent_state(void);
> >  /* A context switch is a grace period for RCU-sched and RCU-bh. */
> >  static inline int rcu_blocking_is_gp(void)
> >  {
> > +	int ret;
> > +
> 
> 
> Wouldn't it be more appropriate to return a bool? (and of course change the
> function prototype as well..)

Sounds like a separate patch, but yes it does.

> >  	might_sleep();  /* Check for RCU read-side critical section. */
> > -	return num_online_cpus() == 1;
> > +	preempt_disable();  /* Prevent CPU hotplug from confusing us. */
> 
> 
> Preempt disable only prevents CPU offline from occurring concurrently.  So
> even if we use preempt_disable/enable(), new CPUs can always come online!
> And going by the above concern about RCU grace periods being too-short, I
> guess we should also protect against CPUs from coming online concurrently
> right?
> 
> [By the way, we don't really need to protect against CPU offlining, because
> an SMP -> UP switch is harmless; we'll just miss a fast-path in the worst
> case, but the code correctness is still guaranteed.]

Yes, CPUs coming online are harmless, so it is OK that disabling preemption
does not prevent this.

> > +	ret = num_online_cpus() == 1;
> > +	preempt_enable();
> > +	return ret;
> >  }
> 
> Maybe I am missing something, but how is this code safe? Isn't it still racy?
> Even if we use:
> 
> {
> 	might_sleep();
> 	get_online_cpus(); /* Prevent both CPU offline and CPU online */
> 	ret = num_online_cpus() == 1;
> 	put_online_cpus();
> 			<===============
> 	return ret;
> }
> 
> What prevents a CPU Hotplug from happening right before we return from this
> function, thereby rendering our num_online_cpus() calculation out-dated and
> hence useless?

Nothing prevents CPU hotplug from happening at the indicated point,
but the function is still safe.

The reason for this safety is that if we were UP at any time during the
execution of synchronize_rcu(), we had to have been running on that single
CPU, which means that a non-preemptible RCU read-side critical section
could not possibly have also been running.  Because non-preemptible
RCU read-side critical sections run with preemption disabled, this in
turn means that all prior RCU read-side critical sections have to have
completed, which means that synchronize_rcu() doesn't need to do anything.

							Thanx, Paul

