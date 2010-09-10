Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab0IJPh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:37:57 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36500 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab0IJPhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:37:55 -0400
Date: Fri, 10 Sep 2010 08:37:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, eranian@googlemail.com,
        a.p.zijlstra@chello.nl, yanmin_zhang@linux.intel.com,
        robert.richter@amd.com, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Per-pmu-per-cpu contexts
Message-ID: <20100910153750.GC2400@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-108b02cfce04ee90b0a07ee0b104baffd39f5934@git.kernel.org>
 <20100910145426.GA5618@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910145426.GA5618@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 04:54:29PM +0200, Frederic Weisbecker wrote:
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

Ook...  My current plans to fold SRCU into TREE_RCU would invalidate
this assumption.

Maybe we need some sort of primitive that concurrently waits for
multiple types of RCU grace periods?

							Thanx, Paul

> And I guess you picked rcu_read_lock_sched() here because that preempt_disable()
> at the same time.
> 
> That looks complicated but I guess that works.
> 
> That said there is also this rcu_dereference(current->perf_event_ctxp).
> Now, this ctx is released after srcu barrier right? So this should
> be srcu_dereference(). But then you seem to actually use rcu_read_lock_sched()
> as it's compatible, so this should be rcu_dereference_sched() ?
> 
> With the current state, rcu will whine.
> Moreover there seem to be too much game between the different rcu
> flavours here, and that breaks the reviewers parsing.
> 
