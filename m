Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab1AUUkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 15:40:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50795 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab1AUUkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 15:40:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m3FkqG77Tmup/C9ObBLqYYhFe0P8wSdSpFd67wfcfqlFlpPbrSdvlZJbFYqAdXnRXj
         c5UOXIh2g/e7eoOEyahJsP5bjwjvoestOLhcRM/lfkrQqJ0brnpjGGD9TqPFz8RmoWXy
         9OVP93q9mLreBzmvzzofXG51QqhZwxKpkiaRo=
Date: Fri, 21 Jan 2011 21:40:17 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
Message-ID: <20110121204014.GA2870@nowhere>
References: <20101108145647.GA3426@redhat.com>
 <20101108145725.GA3434@redhat.com>
 <20110119182141.GA12183@redhat.com>
 <20110120193033.GA13924@redhat.com>
 <1295611905.28776.269.camel@laptop>
 <20110121130323.GA12900@elte.hu>
 <1295617185.28776.273.camel@laptop>
 <20110121142616.GA31165@redhat.com>
 <1295622304.28776.293.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295622304.28776.293.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 04:05:04PM +0100, Peter Zijlstra wrote:
> On Fri, 2011-01-21 at 15:26 +0100, Oleg Nesterov wrote:
> > 
> > > Ah, I think I see how that works:
> > 
> > Hmm. I don't...
> > 
> > >
> > >   __perf_event_task_sched_out()
> > >     perf_event_context_sched_out()
> > >       if (do_switch)
> > >         cpuctx->task_ctx = NULL;
> > 
> > exactly, this clears ->task_ctx
> > 
> > > vs
> > >
> > >   __perf_install_in_context()
> > >    if (cpu_ctx->task_ctx != ctx)
> > 
> > And then __perf_install_in_context() sets cpuctx->task_ctx = ctx,
> > because ctx->task == current && cpuctx->task_ctx == NULL.
> 
> Hrm,. right, so the comment suggests it should do what it doesn't :-)
> 
> It looks like Paul's a63eaf34ae60bd (perf_counter: Dynamically allocate
> tasks' perf_counter_context struct), relevant hunk below, wrecked it:
> 
> @@ -568,11 +582,17 @@ static void __perf_install_in_context(void *info)
>          * If this is a task context, we need to check whether it is
>          * the current task context of this cpu. If not it has been
>          * scheduled out before the smp call arrived.
> +        * Or possibly this is the right context but it isn't
> +        * on this cpu because it had no counters.
>          */
> -       if (ctx->task && cpuctx->task_ctx != ctx)
> -               return;
> +       if (ctx->task && cpuctx->task_ctx != ctx) {
> +               if (cpuctx->task_ctx || ctx->task != current)
> +                       return;
> +               cpuctx->task_ctx = ctx;
> +       }
>  
>         spin_lock_irqsave(&ctx->lock, flags);
> +       ctx->is_active = 1;
>         update_context_time(ctx);
>  
>         /*
> 
> 
> I can't really seem to come up with a sane test that isn't racy with
> something, my cold seems to have clogged not only my nose :/


What do you think about the following (only compile tested yet), it
probably needs more comments, factorizing the checks betwee, perf_event_enable()
and perf_install_in_context(), build-cond against __ARCH_WANT_INTERRUPTS_ON_CTXSW,
but the (good or bad) idea is there.


diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c5fa717..e97472b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -928,6 +928,8 @@ static void add_event_to_ctx(struct perf_event *event,
 	event->tstamp_stopped = tstamp;
 }
 
+static DEFINE_PER_CPU(int, task_events_schedulable);
+
 /*
  * Cross CPU call to install and enable a performance event
  *
@@ -949,7 +951,8 @@ static void __perf_install_in_context(void *info)
 	 * on this cpu because it had no events.
 	 */
 	if (ctx->task && cpuctx->task_ctx != ctx) {
-		if (cpuctx->task_ctx || ctx->task != current)
+		if (cpuctx->task_ctx || ctx->task != current
+		    || !__get_cpu_var(task_events_schedulable))
 			return;
 		cpuctx->task_ctx = ctx;
 	}
@@ -1091,7 +1094,8 @@ static void __perf_event_enable(void *info)
 	 * event's task is the current task on this cpu.
 	 */
 	if (ctx->task && cpuctx->task_ctx != ctx) {
-		if (cpuctx->task_ctx || ctx->task != current)
+		if (cpuctx->task_ctx || ctx->task != current
+		    || !__get_cpu_var(task_events_schedulable))
 			return;
 		cpuctx->task_ctx = ctx;
 	}
@@ -1414,6 +1418,9 @@ void __perf_event_task_sched_out(struct task_struct *task,
 {
 	int ctxn;
 
+	__get_cpu_var(task_events_schedulable) = 0;
+	barrier(); /* Must be visible by enable/install_in_context IPI */
+
 	for_each_task_context_nr(ctxn)
 		perf_event_context_sched_out(task, ctxn, next);
 }
@@ -1587,6 +1594,8 @@ void __perf_event_task_sched_in(struct task_struct *task)
 	struct perf_event_context *ctx;
 	int ctxn;
 
+	__get_cpu_var(task_events_schedulable) = 1;
+
 	for_each_task_context_nr(ctxn) {
 		ctx = task->perf_event_ctxp[ctxn];
 		if (likely(!ctx))
@@ -5964,6 +5973,18 @@ SYSCALL_DEFINE5(perf_event_open,
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 
+	/*
+	 * Every pending sched switch must finish so that
+	 * we ensure every pending calls to perf_event_task_sched_in/out are
+	 * finished. We ensure the next ones will correctly handle the
+	 * perf_task_events label and then the task_events_schedulable
+	 * state. So perf_install_in_context() won't install events
+	 * in the tiny race window between perf_event_task_sched_out()
+	 * and perf_event_task_sched_in() in the __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	 * case.
+	 */
+	synchronize_sched();
+
 	if (move_group) {
 		perf_install_in_context(ctx, group_leader, cpu);
 		get_ctx(ctx);

