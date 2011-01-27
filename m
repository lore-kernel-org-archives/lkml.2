Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab1A0NOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:14:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:40558 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab1A0NOJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:14:09 -0500
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110126175322.GA28617@redhat.com>
References: <20101108145725.GA3434@redhat.com>
	 <20110119182141.GA12183@redhat.com> <20110120193033.GA13924@redhat.com>
	 <1295611905.28776.269.camel@laptop> <20110121130323.GA12900@elte.hu>
	 <1295617185.28776.273.camel@laptop> <20110121142616.GA31165@redhat.com>
	 <1295622304.28776.293.camel@laptop> <20110121204014.GA2870@nowhere>
	 <20110124114234.GA12166@redhat.com>  <20110126175322.GA28617@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 Jan 2011 14:14:37 +0100
Message-ID: <1296134077.15234.161.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 18:53 +0100, Oleg Nesterov wrote:
>         void task_force_schedule(struct task_struct *p)
>         {
>                 struct rq *rq;
> 
>                 preempt_disable();
>                 rq = task_rq(p);
>                 if (rq->curr == p)
>                         wake_up_process(rq->stop);
>                 preempt_enable();
>         }
> 
>         static void
>         perf_install_in_context(struct perf_event_context *ctx,
>                                 struct perf_event *event,
>                                 int cpu)
>         {
>                 struct task_struct *task = ctx->task;
> 
>                 event->ctx = ctx;
> 
>                 if (!task) {
>                         /*
>                          * Per cpu events are installed via an smp call and
>                          * the install is always successful.
>                          */
>                         smp_call_function_single(cpu, __perf_install_in_context,
>                                                  event, 1);
>                         return;
>                 }
> 
>                 for (;;) {
>                         raw_spin_lock_irq(&ctx->lock);
>                         /*
>                          * The lock prevents that this context is
>                          * scheduled in, we can add the event safely.
>                          */
>                         if (!ctx->is_active)
>                                 add_event_to_ctx(event, ctx);
>                         raw_spin_unlock_irq(&ctx->lock);
> 
>                         if (event->attach_state & PERF_ATTACH_CONTEXT) {
>                                 task_force_schedule(task);
>                                 break;
>                         }
> 
>                         task_oncpu_function_call(task, __perf_install_in_context,
>                                                         event);
>                         if (event->attach_state & PERF_ATTACH_CONTEXT)
>                                 break;
>                 }
>         } 

Right, so the fact of introducing extra scheduling makes me feel
uncomfortable... the whole purpose is to observe without perturbing (as
much as possible).

So the whole crux of the matter is adding a ctx to a running process. If
the ctx exists, ->is_active will be tracked properly and much of the
problem goes away.

  rcu_assign_pointer(task->perf_event_ctx[n], new_ctx);
  task_oncpu_function_call(task, __perf_install_in_context, event);

Should I think suffice to get the ctx in sync with the task state, we've
got the following cases:
 1) task is in the middle of scheduling in
 2) task is in the middle of scheduling out
 3) task is running

Without __ARCH_WANT_INTERRUPT_ON_CTXSW everything is boring and works,
1: the IPI will be delayed until 3, 2: the IPI finds another task and
the next schedule in will sort things.

With, however, things are more interesting. 2 seems to be adequately
covered by the patch I just send, the IPI will bail and the next
sched-in of the relevant task will pick matters up. 1 otoh doesn't seem
covered, the IPI will bail, leaving us stranded.

To fix this it seems we need to make task_oncpu_function_call() wait
until the ctx is done, while (cpu_rq(cpu)->in_ctxsw) cpu_relax(); before
sending the IPI like, however that would require adding a few memory
barriers I think... 

/me goes search for implied barriers around there.
