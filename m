Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab1AEUyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 15:54:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab1AEUys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 15:54:48 -0500
Date: Wed, 5 Jan 2011 21:47:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 18/18] sched: Sort hotplug vs ttwu queueing
Message-ID: <20110105204700.GA1313@redhat.com>
References: <20110104145929.772813816@chello.nl> <20110104150103.214765376@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104150103.214765376@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04, Peter Zijlstra wrote:
>
> +#ifdef CONFIG_HOTPLUG_CPU
> +static void ttwu_queue_unplug(struct rq *rq)
> +{
> +	struct task_struct *p, *list = xchg(&rq->wake_list, NULL);
> +	unsigned long flags;
> +	int cpu;
> +
> +	if (!list)
> +		return;
> +
> +	while (list) {
> +		p = list;
> +		list = list->wake_entry;
> +
> +		raw_spin_lock_irqsave(&p->pi_lock, flags);
> +		cpu = select_task_rq(p, SD_BALANCE_WAKE, 0);
> +		set_task_cpu(p, cpu);
> +		ttwu_queue(p, cpu);
> +		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
> +	}
> +}
> +#endif
> +
>  /**
>   * try_to_wake_up - wake up a thread
>   * @p: the thread to be awakened
> @@ -6151,6 +6174,11 @@ migration_call(struct notifier_block *nf
>  		migrate_nr_uninterruptible(rq);
>  		calc_global_load_remove(rq);
>  		break;
> +
> +	case CPU_DEAD:
> +		ttwu_queue_unplug(cpu_rq(cpu));

I think this is not strictly needed...

Afaics, take_cpu_down() can simply call sched_ttwu_pending() at the
start. This will activate the pending tasks on the (almost) dead
cpu but we don't care, they will be migrated later.

When __stop_machine(take_cpu_down) returns nobody can use this CPU
as a target, iow rq->wake_list can't be used again.

Oleg.

