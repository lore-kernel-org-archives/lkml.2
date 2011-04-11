Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab1DKIum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:50:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43128 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab1DKIul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:50:41 -0400
Subject: Re: [RFC][PATCH 5/9] perf: Simplify and fix
 __perf_install_in_context
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <1302511465.29423.13.camel@minggr.sh.intel.com>
References: <20110409191739.813727025@chello.nl>
	 <20110409192141.870894224@chello.nl>  <1302423185.2388.4.camel@twins>
	 <1302511465.29423.13.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Apr 2011 10:50:28 +0200
Message-ID: <1302511828.2388.17.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 16:44 +0800, Lin Ming wrote:
> On Sun, 2011-04-10 at 10:13 +0200, Peter Zijlstra wrote:
> > On Sat, 2011-04-09 at 21:17 +0200, Peter Zijlstra wrote:
> > > +       if (task_ctx) {
> > > +               task_ctx_sched_out(task_ctx);
> > > +               /*
> > > +                * If the context we're installing events in is not the
> > > +                * active task_ctx, flip them.
> > > +                */

> > > +               if (ctx->task && task_ctx != ctx) {
> > > +                       raw_spin_unlock(&cpuctx->ctx.lock);
> > > +                       raw_spin_lock(&ctx->lock);
> > > +                       cpuctx->task_ctx = task_ctx = ctx;
> > > +               }
> > > +               task = task_ctx->task;
> > > +       } 
> > 
> > That is actually buggy, it should read something like:
> > 
> > 	if (task_ctx)
> > 		task_ctx_sched_out(task_ctx);
> > 
> > 	if (ctx->task && task_ctx != ctx) {
		if (task_ctx)
> > 			raw_spin_unlock(&task_ctx->lock);
> > 		raw_spin_lock(&ctx->lock);
> > 		cpuctx->task_ctx = task_ctx = ctx;
> > 	}
> > 
> > 	if (task_ctx)
> > 		task = task_ctx->task;
> > 
> > Aside from the trivial locking bug fixed, the previous version wouldn't
> > actually deal with installing a task_ctx where there was none before.

Let me place your comment with the new version, as the old one is
borken ;-)

> In which case will this happen?
> 
> For task event, we have:
> 
> perf_install_in_context
>    task_function_call(task, __perf_install_in_context, event)
>       __perf_install_in_context
> 
> Doesn't this ensure that the context we're installing events is same
> with the active task_ctx?

With __ARCH_WANT_INTERRUPTS_ON_CTXSW the IPI might land before we did
perf_event_task_sched_in(), in which case we need to set the task_ctx
our-selves.
