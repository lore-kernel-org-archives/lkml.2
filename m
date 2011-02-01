Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab1BASRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:17:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:49337 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1BASRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:17:15 -0500
Subject: Re: [PATCH] perf: Cure task_oncpu_function_call() races
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1296583698.26581.279.camel@laptop>
References: <20110127221856.GA10539@redhat.com>
	 <1296215577.15234.333.camel@laptop> <1296226667.15234.337.camel@laptop>
	 <20110128162847.GA25088@redhat.com> <1296238278.15234.340.camel@laptop>
	 <20110131172626.GA5407@redhat.com> <1296498205.26581.54.camel@laptop>
	 <20110131191109.GA10906@redhat.com> <1296502154.26581.72.camel@laptop>
	 <1296569037.26581.194.camel@laptop>  <20110201172757.GA4586@redhat.com>
	 <1296583698.26581.279.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 19:18:13 +0100
Message-ID: <1296584293.26581.281.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 19:08 +0100, Peter Zijlstra wrote:
> > > +static void perf_remove_from_context(struct perf_event *event)
> > >  {
> > > ...
> > >     raw_spin_lock_irq(&ctx->lock);
> > >     /*
> > > +    * If we failed to find a running task, but find it running now that
> > > +    * we've acquired the ctx->lock, retry.
> > >      */
> > > +   if (task_curr(task)) {
> > >             raw_spin_unlock_irq(&ctx->lock);
> > >             goto retry;
> > >     }
> > >
> > >     /*
> > > +    * Since the task isn't running, its safe to remove the event, us
> > > +    * holding the ctx->lock ensures the task won't get scheduled in.
> > >      */
> > > +   list_del_event(event, ctx);
> > 
> > this looks suspicious (the same for perf_install_in_context).
> > 
> > Unlike the IPI handler, this can see schedule-in-progress in any state.
> > In particular, we can see rq->curr == next (so that task_curr() == F),
> > but before "prev" has already called perf_event_task_sched_out().
> > 
> > So we have to check ctx->is_active, or schedule() should change rq->curr
> > after perf_event_task_sched_out().
> 
> I only considered current == next in that case, not current == prev, let
> me undo some of those sched.c bits and put a comment. 

On second thought, your proposed ->is_active check seems to result in
much nicer code in sched.c. Let me think through that.

