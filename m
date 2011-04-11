Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1DKIMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:12:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:3811 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab1DKIMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:12:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,338,1299484800"; 
   d="scan'208";a="907922249"
Subject: Re: [RFC][PATCH 5/9] perf: Simplify and fix
 __perf_install_in_context
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <20110409192141.870894224@chello.nl>
References: <20110409191739.813727025@chello.nl>
	 <20110409192141.870894224@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Apr 2011 16:12:31 +0800
Message-ID: <1302509551.29423.7.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-09 at 21:17 +0200, Peter Zijlstra wrote:
> plain text document attachment (perf_install_in_context.patch)
> Currently __perf_install_in_context() will try and schedule in the
> event irrespective of our event scheduling rules, that is, we try to
> schedule CPU-pinned, TASK-pinned, CPU-flexible, TASK-flexible, but
> when creating a new event we simply try and schedule it on top of
> whatever is already on the PMU, this can lead to errors for pinned
> events.
> 
> Therefore, simplify things and simply schedule everything out, add the
> event to the corresponding context and schedule everything back in.
> 
> This also nicely handles the case where with
> __ARCH_WANT_INTERRUPTS_ON_CTXSW the IPI can come right in the middle
> of schedule, before we managed to call perf_event_task_sched_in().
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/perf_event.c |   80 ++++++++++++++++++++++------------------------------
>  1 file changed, 35 insertions(+), 45 deletions(-)
> 
> Index: linux-2.6/kernel/perf_event.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_event.c
> +++ linux-2.6/kernel/perf_event.c
> @@ -1476,8 +1476,12 @@ static void add_event_to_ctx(struct perf
>  	event->tstamp_stopped = tstamp;
>  }
>  
> -static void perf_event_context_sched_in(struct perf_event_context *ctx,
> -					struct task_struct *tsk);
> +static void task_ctx_sched_out(struct perf_event_context *ctx);
> +static void
> +ctx_sched_in(struct perf_event_context *ctx,
> +	     struct perf_cpu_context *cpuctx,
> +	     enum event_type_t event_type,
> +	     struct task_struct *task);
>  
>  /*
>   * Cross CPU call to install and enable a performance event
> @@ -1488,20 +1492,31 @@ static int  __perf_install_in_context(vo
>  {
>  	struct perf_event *event = info;
>  	struct perf_event_context *ctx = event->ctx;
> -	struct perf_event *leader = event->group_leader;
>  	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
> -	int err;
> +	struct perf_event_context *task_ctx = cpuctx->task_ctx;
> +	struct task_struct *task = current;
> +
> +	perf_ctx_lock(cpuctx, cpuctx->task_ctx);

perf_ctx_lock(cpuctx, task_ctx)

since task_ctx is assigned with cpuctx->task_ctx.

Lin Ming

