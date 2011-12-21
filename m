Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1LUKoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 05:44:09 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:24681 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346Ab1LUKoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 05:44:06 -0500
Message-ID: <4EF1B86D.9030809@openvz.org>
Date: Wed, 21 Dec 2011 14:43:57 +0400
From: Andrey Vagin <avagin@openvz.org>
Reply-To: avagin@openvz.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Arun Sharma <asharma@fb.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] tracing, sched: Add a new tracepoint for sleeptime
References: <1324404558-353-1-git-send-email-asharma@fb.com> <1324404558-353-3-git-send-email-asharma@fb.com>
In-Reply-To: <1324404558-353-3-git-send-email-asharma@fb.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> +#ifdef CREATE_TRACE_POINTS
> +static inline u64 trace_get_sleeptime(struct task_struct *tsk)
> +{
> +#ifdef CONFIG_SCHEDSTATS
> +	u64 block, sleep;
> +
> +	block = tsk->se.statistics.block_start;
> +	sleep = tsk->se.statistics.sleep_start;
Arun, probably you have missed one of my comments.
block_start and sleep_start should be zeroized here.

tsk->se.statistics.block_start = 0;
tsk->se.statistics.sleep_start = 0;

The following program provokes this problem:

#include<unistd.h>
#include<time.h>
#include<sys/select.h>

int main()
{
           struct timespec ts1;
           struct timeval tv1;
           int i;
           long s;


           for (i = 0; i<  1000; i++) {
                   ts1.tv_sec = 0;
                   ts1.tv_nsec = 1000000;
                   nanosleep(&ts1, NULL);

                   tv1.tv_sec = 0;
                   tv1.tv_usec = 4000;
                   select(0, NULL, NULL, NULL,&tv1);
                   if (i % 100 == 0) {
                         s = time(NULL);
                         while (time(NULL) - s < 4);
                   }
           }
         return 1;
}

> +
> +	return block ? block : sleep ? sleep : 0;
> +#else
> +	return 0;
> +#endif
> +}
> +#endif
> +
> +/*
> + * Tracepoint for accounting sleeptime (time the task is sleeping
> + * or waiting for I/O).
> + */
> +TRACE_EVENT(sched_stat_sleeptime,
> +
> +	TP_PROTO(struct task_struct *tsk, u64 now),
> +
> +	TP_ARGS(tsk, now),
> +
> +	TP_STRUCT__entry(
> +		__array( char,	comm,	TASK_COMM_LEN	)
> +		__field( pid_t,	pid			)
> +		__field( u64,	sleeptime		)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
> +		__entry->pid		= tsk->pid;
> +		__entry->sleeptime = trace_get_sleeptime(tsk);
> +		__entry->sleeptime = __entry->sleeptime ?
> +				now - __entry->sleeptime : 0;
> +	)
> +	TP_perf_assign(
> +		__perf_count(__entry->sleeptime);
> +	),
> +
> +	TP_printk("comm=%s pid=%d sleeptime=%Lu [ns]",
> +			__entry->comm, __entry->pid,
> +			(unsigned long long)__entry->sleeptime)
> +);
> +
>   /*
>    * Tracepoint for showing priority inheritance modifying a tasks
>    * priority.
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index ca8fd44..172e6ee 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1899,6 +1899,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
>   	local_irq_enable();
>   #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
>   	finish_lock_switch(rq, prev);
> +	trace_sched_stat_sleeptime(current, rq->clock);
>
>   	fire_sched_in_preempt_notifiers(current);
>   	if (mm)

