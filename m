Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1A0W0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 17:26:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab1A0W0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 17:26:54 -0500
Date: Thu, 27 Jan 2011 23:18:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
Message-ID: <20110127221856.GA10539@redhat.com>
References: <20110121130323.GA12900@elte.hu> <1295617185.28776.273.camel@laptop> <20110121142616.GA31165@redhat.com> <1295622304.28776.293.camel@laptop> <20110121204014.GA2870@nowhere> <20110124114234.GA12166@redhat.com> <20110126175322.GA28617@redhat.com> <1296134077.15234.161.camel@laptop> <20110127165712.GC25060@redhat.com> <1296148294.15234.242.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296148294.15234.242.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27, Peter Zijlstra wrote:
>
> On Thu, 2011-01-27 at 17:57 +0100, Oleg Nesterov wrote:
> >
> > > With, however, things are more interesting. 2 seems to be adequately
> > > covered by the patch I just send, the IPI will bail and the next
> > > sched-in of the relevant task will pick matters up. 1 otoh doesn't seem
> > > covered, the IPI will bail, leaving us stranded.
> >
> > Hmm, yes... Strangely, I missed that when I was thinking about in_ctxsw.
> >
> > Perhaps, we can change task_oncpu_function_call() so that it returns
> > -EAGAIN in case it hits in_ctxsw != 0? If the caller sees -EAGAIN, it
> > should always retry even if !ctx->is_active.
>
> That would be very easy to do, we can pass a return value through the
> task_function_call structure.

Yes.

Perhaps task_oncpu_function_call() should retry itself to simplify the
callers. I wonder if we should also retry if rq->curr != p...



Oh. You know, I am starting to think I will never understand this.
Forget about the problems with __ARCH_WANT_INTERRUPT_ON_CTXSW.

perf_install_in_context() does task_oncpu_function_call() and then


	// ctx->is_active == 0

	/*
	 * The lock prevents that this context is scheduled in so we
	 * can add the event safely, if it the call above did not
	 * succeed.
	 */
	if (list_empty(&event->group_entry))
		add_event_to_ctx(event, ctx);

This assumes that the task is not running.

Why? Because (I guess) we assume that either task_oncpu_function_call()
should see task_curr() == T, or if the task becomes running after that
it should see the new ->perf_event_ctxp[ctxn] != NULL. And I do not see
how we can prove this.

If find_get_context() sets the new context, the only guarantee we have
is: perf_event_exit_task() can't miss this context. The task, however,
can be scheduled in and miss the new value in perf_event_ctxp[].
And, task_oncpu_function_call() can equally miss rq->curr == task.

But. I think this all falls into the absolutely theoretical category,
and in the worst case nothing really bad can happen, just event_sched_in()
will be delayed until this task reshedules.


So, I think your patch should fix all problems with schedule. Just it
needs the couple of changes we already discussed:

	- finish_task_switch() should clear rq->in_ctxsw before
	  local_irq_enable()

	- task_oncpu_function_call() (or its callers) should always
	  retry the "if (task_curr(p))" code if ->in_ctxsw is true.

If you think we have other problems here please don't tell me,
I already got lost ;)

Oleg.

