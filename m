Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1DKIom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:44:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:33201 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab1DKIol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:44:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,338,1299484800"; 
   d="scan'208";a="907930352"
Subject: Re: [RFC][PATCH 5/9] perf: Simplify and fix
 __perf_install_in_context
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <1302423185.2388.4.camel@twins>
References: <20110409191739.813727025@chello.nl>
	 <20110409192141.870894224@chello.nl>  <1302423185.2388.4.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Apr 2011 16:44:25 +0800
Message-ID: <1302511465.29423.13.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-10 at 10:13 +0200, Peter Zijlstra wrote:
> On Sat, 2011-04-09 at 21:17 +0200, Peter Zijlstra wrote:
> > +       if (task_ctx) {
> > +               task_ctx_sched_out(task_ctx);
> > +               /*
> > +                * If the context we're installing events in is not the
> > +                * active task_ctx, flip them.
> > +                */

In which case will this happen?

For task event, we have:

perf_install_in_context
   task_function_call(task, __perf_install_in_context, event)
      __perf_install_in_context

Doesn't this ensure that the context we're installing events is same
with the active task_ctx?

Lin Ming

> > +               if (ctx->task && task_ctx != ctx) {
> > +                       raw_spin_unlock(&cpuctx->ctx.lock);
> > +                       raw_spin_lock(&ctx->lock);
> > +                       cpuctx->task_ctx = task_ctx = ctx;
> > +               }
> > +               task = task_ctx->task;
> > +       } 
> 
> That is actually buggy, it should read something like:
> 
> 	if (task_ctx)
> 		task_ctx_sched_out(task_ctx);
> 
> 	if (ctx->task && task_ctx != ctx) {
> 		raw_spin_unlock(&task_ctx->lock);
> 		raw_spin_lock(&ctx->lock);
> 		cpuctx->task_ctx = task_ctx = ctx;
> 	}
> 
> 	if (task_ctx)
> 		task = task_ctx->task;
> 
> Aside from the trivial locking bug fixed, the previous version wouldn't
> actually deal with installing a task_ctx where there was none before.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


