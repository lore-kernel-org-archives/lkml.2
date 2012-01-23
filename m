Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab2AWLeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 06:34:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60964 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2AWLeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 06:34:21 -0500
Message-ID: <1327318449.2446.5.camel@twins>
Subject: Re: [PATCH] trace: reset sleep/block start time on task switch
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Mon, 23 Jan 2012 12:34:09 +0100
In-Reply-To: <1327026020-32376-1-git-send-email-asharma@fb.com>
References: <1327026020-32376-1-git-send-email-asharma@fb.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-19 at 18:20 -0800, Arun Sharma wrote:
> Without this patch, the first sample we get on a
> task might be bad because of a stale sleep_start
> value that wasn't reset at the last task switch
> because the tracepoint was not active.
> 
> The problem can be worked around via perf record
> --filter "sleeptime < some-large-number" in practice
> and it's not clear if the added code to the context
> switch path is worth it.
> 
> I'm posting this patch regardless, just in case
> more people start noticing this and start wondering
> where the bogus numbers came from.
> 
> Signed-off-by: Arun Sharma <asharma@fb.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
> Cc: Andrew Vagin <avagin@openvz.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: linux-kernel@vger.kernel.org
> ---
>  include/trace/events/sched.h |    3 ---
>  kernel/sched/core.c          |    3 +++
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> index 6ba596b..814cdf1 100644
> --- a/include/trace/events/sched.h
> +++ b/include/trace/events/sched.h
> @@ -378,9 +378,6 @@ static inline u64 trace_get_sleeptime(struct task_struct *tsk)
>  
>  	block = tsk->se.statistics.block_start;
>  	sleep = tsk->se.statistics.sleep_start;
> -	tsk->se.statistics.block_start = 0;
> -	tsk->se.statistics.sleep_start = 0;
> -
>  	return block ? block : sleep ? sleep : 0;
>  #else
>  	return 0;
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 457c881..6349cee 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1937,7 +1937,10 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
>  	local_irq_enable();
>  #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
>  	finish_lock_switch(rq, prev);
> +
>  	trace_sched_stat_sleeptime(current, rq->clock);
> +	current->se.statistics.block_start = 0;
> +	current->se.statistics.sleep_start = 0;
>  
>  	fire_sched_in_preempt_notifiers(current);
>  	if (mm)


Its not just your tracepoint data being wrong, it'll wreck all related
stats :/

This'll fail to compile for !CONFIG_SCHEDSTAT I guess.. I should have
paid more attention to the initial patch, that tracepoint having
side-effects is a big no-no.

Having unconditional writes there is somewhat sad, but I suspect putting
a conditional around it isn't going to help much.. bah can we
restructure things so we don't need this?


