Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab1IVO4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 10:56:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab1IVO4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 10:56:40 -0400
Date: Thu, 22 Sep 2011 16:52:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, mingo <mingo@redhat.com>
Subject: Re: rt14: strace ->  migrate_disable_atomic imbalance
Message-ID: <20110922145257.GA13960@redhat.com>
References: <alpine.LFD.2.02.1109101052340.2723@ionos> <1315737307.6544.1.camel@marge.simson.net> <1315817948.26517.16.camel@twins> <1315835562.6758.3.camel@marge.simson.net> <1315839187.6758.8.camel@marge.simson.net> <1315926499.5977.19.camel@twins> <1315927699.6445.6.camel@marge.simson.net> <1315930430.5977.21.camel@twins> <1316600230.6628.6.camel@marge.simson.net> <1316691967.31429.9.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316691967.31429.9.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22, Peter Zijlstra wrote:
>
> +static void wait_task_inactive_sched_in(struct preempt_notifier *n, int cpu)
> +{
> +	struct task_struct *p;
> +	struct wait_task_inactive_blocked *blocked =
> +		container_of(n, struct wait_task_inactive_blocked, notifier);
> +
> +	hlist_del(&n->link);
> +
> +	p = ACCESS_ONCE(blocked->waiter);
> +	blocked->waiter = NULL;
> +	wake_up_process(p);
> +}
> ...
> +static void
> +wait_task_inactive_sched_out(struct preempt_notifier *n, struct task_struct *next)
> +{
> +	if (current->on_rq) /* we're not inactive yet */
> +		return;
> +
> +	hlist_del(&n->link);
> +	n->ops = &wait_task_inactive_ops_post;
> +	hlist_add_head(&n->link, &next->preempt_notifiers);
> +}

Tricky ;) Yes, the first ->sched_out() is not enough.

>  unsigned long wait_task_inactive(struct task_struct *p, long match_state)
>  {
> ...
> +	rq = task_rq_lock(p, &flags);
> +	trace_sched_wait_task(p);
> +	if (!p->on_rq) /* we're already blocked */
> +		goto done;

This doesn't look right. schedule() clears ->on_rq a long before
__switch_to/etc.

And it seems that we check ->on_cpu above, this is not UP friendly.

>
> -			set_current_state(TASK_UNINTERRUPTIBLE);
> -			schedule_hrtimeout(&to, HRTIMER_MODE_REL);
> -			continue;
> -		}
> +	hlist_add_head(&blocked.notifier.link, &p->preempt_notifiers);
> +	task_rq_unlock(rq, p, &flags);

I thought about reimplementing wait_task_inactive() too, but afaics there
is a problem: why we can't race with p doing register_preempt_notifier() ?
I guess register_ needs rq->lock too.

Oleg.

