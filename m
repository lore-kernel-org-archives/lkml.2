Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab1BASHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:07:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56909 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab1BASHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:07:22 -0500
Subject: Re: [PATCH] perf: Cure task_oncpu_function_call() races
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110201172757.GA4586@redhat.com>
References: <20110127221856.GA10539@redhat.com>
	 <1296215577.15234.333.camel@laptop> <1296226667.15234.337.camel@laptop>
	 <20110128162847.GA25088@redhat.com> <1296238278.15234.340.camel@laptop>
	 <20110131172626.GA5407@redhat.com> <1296498205.26581.54.camel@laptop>
	 <20110131191109.GA10906@redhat.com> <1296502154.26581.72.camel@laptop>
	 <1296569037.26581.194.camel@laptop>  <20110201172757.GA4586@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 19:08:18 +0100
Message-ID: <1296583698.26581.279.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 18:27 +0100, Oleg Nesterov wrote:
> On 02/01, Peter Zijlstra wrote:
> >
> > Oleg, I've actually run-tested the below and all seems well (clearly
> > I've never actually hit the races found before either, so in that
> > respect its not a conclusive test).
> >
> > Can you agree with this patch?
> 
> You know, I already wrote the i-think-it-is-correct email. But then
> I decided to read it once again.

:-)

> > -static void __perf_event_remove_from_context(void *info)
> > +static int __perf_remove_from_context(void *info)
> >  {
> >  	struct perf_event *event = info;
> >  	struct perf_event_context *ctx = event->ctx;
> >  	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
> >
> > -	/*
> > -	 * If this is a task context, we need to check whether it is
> > -	 * the current task context of this cpu. If not it has been
> > -	 * scheduled out before the smp call arrived.
> > -	 */
> > -	if (ctx->task && cpuctx->task_ctx != ctx)
> > -		return;
> 
> OK, I think this is right... event_sched_out() will see
> PERF_EVENT_STATE_INACTIVE if perf_event_task_sched_in() was not
> called yet.

Right

> But,
> 
> > -static void perf_event_remove_from_context(struct perf_event *event)
> > +static void perf_remove_from_context(struct perf_event *event)
> >  {
> > ...
> >  	raw_spin_lock_irq(&ctx->lock);
> >  	/*
> > -	 * If the context is active we need to retry the smp call.
> > +	 * If we failed to find a running task, but find it running now that
> > +	 * we've acquired the ctx->lock, retry.
> >  	 */
> > -	if (ctx->nr_active && !list_empty(&event->group_entry)) {
> > +	if (task_curr(task)) {
> >  		raw_spin_unlock_irq(&ctx->lock);
> >  		goto retry;
> >  	}
> >
> >  	/*
> > -	 * The lock prevents that this context is scheduled in so we
> > -	 * can remove the event safely, if the call above did not
> > -	 * succeed.
> > +	 * Since the task isn't running, its safe to remove the event, us
> > +	 * holding the ctx->lock ensures the task won't get scheduled in.
> >  	 */
> > -	if (!list_empty(&event->group_entry))
> > -		list_del_event(event, ctx);
> > +	list_del_event(event, ctx);
> 
> this looks suspicious (the same for perf_install_in_context).
> 
> Unlike the IPI handler, this can see schedule-in-progress in any state.
> In particular, we can see rq->curr == next (so that task_curr() == F),
> but before "prev" has already called perf_event_task_sched_out().
> 
> So we have to check ctx->is_active, or schedule() should change rq->curr
> after perf_event_task_sched_out().

I only considered current == next in that case, not current == prev, let
me undo some of those sched.c bits and put a comment.

> > @@ -753,13 +819,13 @@ void perf_event_disable(struct perf_event *event)
> > ...
> >  	 */
> >  	if (event->state == PERF_EVENT_STATE_ACTIVE) {
> >  		raw_spin_unlock_irq(&ctx->lock);
> > +		/*
> > +		 * Reload the task pointer, it might have been changed by
> > +		 * a concurrent perf_event_context_sched_out().
> > +		 */
> > +		task = ctx->task;
> >  		goto retry;
> 
> I am wondering why only perf_event_disable() needs this...

perf_event_enable() also has it, but you made me re-asses all that and I
think there's more to it.

perf_install_in_context() works on a ctx obtained by find_get_context(),
that context is either new (uncloned) or existing in which case it
called unclone_ctx(). So I was thinking there was no race with the ctx
flipping in perf_event_context_sched_out(), _however_ since it only
acquires ctx->mutex after calling unclone_ctx() there is a race window
with perf_event_init_task().

This race we should fix with perf_pin_task_context()

perf_remove_from_context() seems ok though, we only call that on the
install ctx, which we should fix above, or on a dying uncloned context
(no race with fork because exit doesn't clone).

> Just curious, this is equally needed without this patch?

Yes, I think it is a pre-existing problem.


