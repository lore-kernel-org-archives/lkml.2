Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab1IWLBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 07:01:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53105 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab1IWLBW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 07:01:22 -0400
Subject: Re: [PATCH 19/21] tracing: Account for preempt off in
 preempt_schedule()
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 23 Sep 2011 13:00:48 +0200
In-Reply-To: <20110922221029.678324653@goodmis.org>
References: <20110922220935.537134016@goodmis.org>
	 <20110922221029.678324653@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316775648.9084.1.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 18:09 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0019-tracing-Account-for-preempt-off-in-preempt_schedule.patch)
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The preempt_schedule() uses the preempt_disable_notrace() version
> because it can cause infinite recursion by the function tracer as
> the function tracer uses preempt_enable_notrace() which may call
> back into the preempt_schedule() code as the NEED_RESCHED is still
> set and the PREEMPT_ACTIVE has not been set yet.
> 
> See commit: d1f74e20b5b064a130cd0743a256c2d3cfe84010 that made this
> change.
> 
> The preemptoff and preemptirqsoff latency tracers require the first
> and last preempt count modifiers to enable tracing. But this skips
> the checks. Since we can not convert them back to the non notrace
> version, we can use the idle() hooks for the latency tracers here.
> That is, the start/stop_critical_timings() works well to manually
> start and stop the latency tracer for preempt off timings.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/sched.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index ccacdbd..4b096cc 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4435,7 +4435,16 @@ asmlinkage void __sched notrace preempt_schedule(void)
>  
>  	do {
>  		add_preempt_count_notrace(PREEMPT_ACTIVE);
> +		/*
> +		 * The add/subtract must not be traced by the function
> +		 * tracer. But we still want to account for the
> +		 * preempt off latency tracer. Since the _notrace versions
> +		 * of add/subtract skip the accounting for latency tracer
> +		 * we must force it manually.
> +		 */
> +		start_critical_timings();
>  		schedule();
> +		stop_critical_timings();
>  		sub_preempt_count_notrace(PREEMPT_ACTIVE);
>  
>  		/*

This won't apply, you're patching ancient code.

Anyway, this all stinks, and reading the changelog of
d1f74e20b5b064a130cd0743a256c2d3cfe84010 and the above just makes me
confused.


