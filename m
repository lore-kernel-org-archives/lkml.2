Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab1AUPEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:04:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:40297 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab1AUPEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:04:37 -0500
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110121142616.GA31165@redhat.com>
References: <20101108145647.GA3426@redhat.com>
	 <20101108145725.GA3434@redhat.com> <20110119182141.GA12183@redhat.com>
	 <20110120193033.GA13924@redhat.com> <1295611905.28776.269.camel@laptop>
	 <20110121130323.GA12900@elte.hu> <1295617185.28776.273.camel@laptop>
	 <20110121142616.GA31165@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 21 Jan 2011 16:05:04 +0100
Message-ID: <1295622304.28776.293.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 15:26 +0100, Oleg Nesterov wrote:
> 
> > Ah, I think I see how that works:
> 
> Hmm. I don't...
> 
> >
> >   __perf_event_task_sched_out()
> >     perf_event_context_sched_out()
> >       if (do_switch)
> >         cpuctx->task_ctx = NULL;
> 
> exactly, this clears ->task_ctx
> 
> > vs
> >
> >   __perf_install_in_context()
> >    if (cpu_ctx->task_ctx != ctx)
> 
> And then __perf_install_in_context() sets cpuctx->task_ctx = ctx,
> because ctx->task == current && cpuctx->task_ctx == NULL.

Hrm,. right, so the comment suggests it should do what it doesn't :-)

It looks like Paul's a63eaf34ae60bd (perf_counter: Dynamically allocate
tasks' perf_counter_context struct), relevant hunk below, wrecked it:

@@ -568,11 +582,17 @@ static void __perf_install_in_context(void *info)
         * If this is a task context, we need to check whether it is
         * the current task context of this cpu. If not it has been
         * scheduled out before the smp call arrived.
+        * Or possibly this is the right context but it isn't
+        * on this cpu because it had no counters.
         */
-       if (ctx->task && cpuctx->task_ctx != ctx)
-               return;
+       if (ctx->task && cpuctx->task_ctx != ctx) {
+               if (cpuctx->task_ctx || ctx->task != current)
+                       return;
+               cpuctx->task_ctx = ctx;
+       }
 
        spin_lock_irqsave(&ctx->lock, flags);
+       ctx->is_active = 1;
        update_context_time(ctx);
 
        /*


I can't really seem to come up with a sane test that isn't racy with
something, my cold seems to have clogged not only my nose :/
