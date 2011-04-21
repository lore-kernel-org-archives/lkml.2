Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab1DULS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 07:18:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58394 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab1DULS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 07:18:58 -0400
Subject: Re: [PATCH -tip] sched: more sched_domain iterations fix
From: Peter Zijlstra <peterz@infradead.org>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1303384044-7646-1-git-send-email-dfeng@redhat.com>
References: <1303384044-7646-1-git-send-email-dfeng@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 13:21:32 +0200
Message-ID: <1303384893.2035.73.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 19:07 +0800, Xiaotian Feng wrote:
> sched_domain iterations needs to be protected by rcu_read_lock() now,
> this patch adds another two places which needs the rcu lock.

Changelog fails to mention how you found out about these.

> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/sched_rt.c    |    2 ++
>  kernel/sched_stats.h |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 19ecb31..901ed2a 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1282,7 +1282,9 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
>  	int cpu;
>  
>  	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
> +		rcu_read_lock();
>  		cpu = find_lowest_rq(task);
> +		rcu_read_unlock();

I would put that inside find_lowest_rq() instead of around.

>  		if ((cpu == -1) || (cpu == rq->cpu))
>  			break;
> diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
> index 48ddf43..d25c8c1 100644
> --- a/kernel/sched_stats.h
> +++ b/kernel/sched_stats.h
> @@ -38,6 +38,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
>  #ifdef CONFIG_SMP
>  		/* domain-specific stats */
>  		preempt_disable();
> +		rcu_read_lock();
>  		for_each_domain(cpu, sd) {
>  			enum cpu_idle_type itype;
>  
> @@ -64,6 +65,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
>  			    sd->ttwu_wake_remote, sd->ttwu_move_affine,
>  			    sd->ttwu_move_balance);
>  		}
> +		rcu_read_unlock();
>  		preempt_enable();

I suspect that those preempt_disable/enable are an attempt at
rcu_read_lock_sched() before that existed, which would suggest they are
now redundant.

>  #endif
>  	}



