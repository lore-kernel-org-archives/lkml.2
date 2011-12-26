Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab1LZPsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 10:48:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430Ab1LZPsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 10:48:45 -0500
Date: Mon, 26 Dec 2011 16:42:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <kirill.tkhai@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH]sched: stop hrtick timer if running task is switching
	from fair scheduling class to another
Message-ID: <20111226154257.GA21445@redhat.com>
References: <1324584060.4222.15.camel@hp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324584060.4222.15.camel@hp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23, Kirill Tkhai wrote:
>
> [PATCH]sched: stop hrtick timer if running task is switching from fair
> scheduling class to another
>
> We have to stop hrtick timer to avoid excess interrupt. Not-fair tasks
> are not interested in fair's hrtick. RT class uses its own fixed
> timeslice (in case of RR), which doesn't depend on current value of hrtick
> timer.

Well. I shouldn't try to comment this patch, I do not really understand
this code.

But since nobody else replies...

> @@ -5271,6 +5271,13 @@ static void switched_from_fair(struct rq *rq,
> struct task_struct *p)
>  		place_entity(cfs_rq, se, 0);
>  		se->vruntime -= cfs_rq->min_vruntime;
>  	}
> +
> +	/*
> +	 * Other scheduling classes are not interested in fair's hrtick timer.
> +	 */
> +	if (task_current(rq, p) && sched_feat(HRTICK))
> +		hrtick_clear(rq);
> +
>  }

May be... but in this case, perhaps instead we should teach
dequeue_task_fair() or put_prev_task_fair() to do this. Then we can
probably remove __schedule()->hrtick_clear().

I simply can't understand the current hrtick logic. For example,
why dequeue_task_fair() does hrtick_update() ? OK, probably
because "nr_running < sched_nr_latency" can become true. But at
least this doesn't make sense to me when p == rq->curr, say,
__schedule() path.

Hmm. In any case, how it is possible to do hrtick_start() with
rq->lock held? hrtimer_restart() may want to wakeup_softirqd().

Peter, Ingo, does this code really work? SCHED_FEAT(HRTICK) == 0
by default, and afaics you can't change it without CONFIG_SCHED_DEBUG.

Confused...

Oleg.

