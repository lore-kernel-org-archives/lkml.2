Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1C2S7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 14:59:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:35092 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1C2S7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 14:59:47 -0400
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
 value
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20110329162851.GA6317@redhat.com>
References: <20110326161346.GA18272@redhat.com>
	 <1301157483.2250.366.camel@laptop> <20110326170922.GA20329@redhat.com>
	 <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop>
	 <20110328133033.GA8254@redhat.com> <1301324275.4859.25.camel@twins>
	 <1301327368.4859.28.camel@twins> <20110328165648.GA9304@redhat.com>
	 <1301387532.4859.54.camel@twins>  <20110329162851.GA6317@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 21:01:58 +0200
Message-ID: <1301425318.2250.485.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 18:28 +0200, Oleg Nesterov wrote:
> On 03/29, Peter Zijlstra wrote:
> >
> > On Mon, 2011-03-28 at 18:56 +0200, Oleg Nesterov wrote:
> > >
> > > jump_label_dec:
> > >
> > > 	if (atomic_dec_and_test(key))
> > > 		jump_label_disable(key);
> > >
> > > Another thread can create the PERF_ATTACH_TASK event in between
> > > and call jump_label_update(JUMP_LABEL_ENABLE) first. Looks like,
> > > jump_label_update() should ensure that "type" matches the state
> > > of the "*key" under jump_label_lock().
> >
> > No I think you're right, and I think we fixed that but it looks like
> > Ingo still didn't merge the new jump-label patches :/
> 
> OK. To remind, we have another problem, perf_install can race with exit.
> But lets ignore this for now...

Yay! ;-)

> 
> You know, I honestly tried to convince myself I can understand your
> patch. All I can say, I'll try to read it again ;) But the main idea
> is clear, we give more respect to ->nr_events and once it is zero
> task_ctx must not be active.

Right, except I'm leaking an ->is_active and was seriously considering
your clever idea of splitting the sched_in and sched_out jump-labels.

> > @@ -2114,8 +2107,19 @@ static void perf_event_context_sched_in(
> >  	struct perf_cpu_context *cpuctx;
> >
> >  	cpuctx = __get_cpu_context(ctx);
> > -	if (cpuctx->task_ctx == ctx)
> > +	raw_spin_lock(&ctx->lock);
> > +	/*
> > +	 * Serialize against perf_install_in_context(), the interesting case
> > +	 * is where perf_install_in_context() finds the context inactive and
> > +	 * another cpu is just about to schedule the task in. In that case
> > +	 * we need to avoid observing a stale ctx->nr_events.
> 
> I don't understand the comment... We can't race __perf_install_in_context,
> it can only run on the same CPU but we are called with irqs disabled.

Ah, I meant a race with perf_install_in_context() where task_function()
fails because !task_curr(), in that case we'll attempt
add_event_to_ctx() from the remote cpu. If we race wrong with sched_in
nobody might schedule the event.

> > +	ctx->is_active = 1;
> > +	if (cpuctx->task_ctx == ctx || !ctx->nr_events) {
> > +		raw_spin_lock(&ctx->lock);
> >  		return;
> 
> I guess you meant _unlock.

Yeah, utter fail day today :/

> But now I don't understand what ->is_active means. We make it true,
> but doesn't set cpuctx->task_ctx = ctx. Why __perf_event_release()
> clears ->is_active then?

Yeha, that's the big problem I have with this.

> It seems to me, instead we should change ctx_sched_in() to check
> nr_events and do nothing if it is zero.

you mean, not set ->is_active?

> > +	cpuctx->task_ctx = ctx;
> > +
> >  	ctx_sched_in(ctx, cpuctx, EVENT_PINNED, task);
> 
> But we already dropped ctx->lock, __perf_event_release() can remove
> the last event before ctx_sched_in() takes it again.
> 
> This should be moved into ctx_sched_in() afaics, but this is not simple.
> 
> So, perhaps we can take ctx->lock and check nr_events after the 2nd
> ctx_sched_in(). If it is zero, we should clear task_ctx/is_active.
> 
> Perhaps. Right now I got lost.

Yeah, you and me both.. I went to look at something else because I
simply confused myself more. Hopefully tomorrow will bring some sanity.


