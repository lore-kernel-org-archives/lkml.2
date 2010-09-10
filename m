Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab0IJP4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:56:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:55254 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab0IJP4t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:56:49 -0400
Subject: Re: [tip:perf/core] perf: Per-pmu-per-cpu contexts
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, eranian@googlemail.com,
        yanmin_zhang@linux.intel.com, robert.richter@amd.com,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20100910145426.GA5618@nowhere>
References: <tip-108b02cfce04ee90b0a07ee0b104baffd39f5934@git.kernel.org>
	 <20100910145426.GA5618@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Sep 2010 17:56:17 +0200
Message-ID: <1284134177.402.111.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 16:54 +0200, Frederic Weisbecker wrote:
> On Thu, Sep 09, 2010 at 07:51:53PM +0000, tip-bot for Peter Zijlstra wrote:
> > @@ -3745,18 +3757,20 @@ static void perf_event_task_ctx(struct perf_event_context *ctx,
> >  
> >  static void perf_event_task_event(struct perf_task_event *task_event)
> >  {
> > -	struct perf_cpu_context *cpuctx;
> >  	struct perf_event_context *ctx = task_event->task_ctx;
> > +	struct perf_cpu_context *cpuctx;
> > +	struct pmu *pmu;
> >  
> > -	rcu_read_lock();
> > -	cpuctx = &get_cpu_var(perf_cpu_context);
> > -	perf_event_task_ctx(&cpuctx->ctx, task_event);
> > +	rcu_read_lock_sched();
> > +	list_for_each_entry_rcu(pmu, &pmus, entry) {
> > +		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
> > +		perf_event_task_ctx(&cpuctx->ctx, task_event);
> > +	}
> >  	if (!ctx)
> >  		ctx = rcu_dereference(current->perf_event_ctxp);
> 
> 
> 
> So, you say below that it works because synchronize_srcu(), that
> waits for qs after touching pmus, implies synchronize_sched(), right?

yep.

> And I guess you picked rcu_read_lock_sched() here because that preempt_disable()
> at the same time.

Mostly because preemption is already disabled there, and sync_srcu() was
implemented using sync_rcu_sched() primitives.

> That looks complicated but I guess that works.

Yeah, similar to the event lists which we protect with a mutex and a
spinlock, hold either to traverse, hold both to modify.

Depending on the situation we need to traverse the pmu list preemptible
-- for example when we need to take the above mentioned mutex (see
perf_event_exit_cpu_context), or non-preemptible, the above. So we need
to guard it using two different flavours of RCU too.

> That said there is also this rcu_dereference(current->perf_event_ctxp).
> Now, this ctx is released after srcu barrier right? So this should
> be srcu_dereference(). But then you seem to actually use rcu_read_lock_sched()
> as it's compatible, so this should be rcu_dereference_sched() ?

The task context is released using call_rcu(), and should be done under
rcu_read_lock(), I guess we should hold both rcu_read_lock() and
rcu_read_lock_sched() there to be correct.

> With the current state, rcu will whine.
> Moreover there seem to be too much game between the different rcu
> flavours here, and that breaks the reviewers parsing.

:-)
