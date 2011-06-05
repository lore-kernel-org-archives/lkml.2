Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab1FETOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 15:14:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab1FETOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 15:14:45 -0400
Date: Sun, 5 Jun 2011 21:12:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: RCU-protect __set_task_cpu() in set_task_cpu()
Message-ID: <20110605191233.GA20462@redhat.com>
References: <20110531172651.GA4478@swordfish.minsk.epam.com> <1307115427.2353.3456.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307115427.2353.3456.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, Peter Zijlstra wrote:
>
> @@ -2200,6 +2201,16 @@ void set_task_cpu(struct task_struct *p,
>  			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
>
>  #ifdef CONFIG_LOCKDEP
> +	/*
> +	 * The caller should hold either p->pi_lock or rq->lock, when changing
> +	 * a task's CPU.

Is it literally true? IIRC, we need ->pi_lock if the task is not active,
and rq->lock if p->on_rq = 1. And that is why we do not clear p->on_rq
between deactivate_task() + activate_task(), correct?

> +	 *
> +	 * sched_move_task() holds both and thus holding either pins the cgroup,
> +	 * see set_task_rq().
> +	 *
> +	 * Furthermore, all task_rq users should acquire both locks, see
> +	 * task_rq_lock().
> +	 */
>  	WARN_ON_ONCE(debug_locks && !(lockdep_is_held(&p->pi_lock) ||
>  				      lockdep_is_held(&task_rq(p)->lock)));

IOW, perhaps this should be

	WARN_ON_ONCE(debug_locks && !lockdep_is_held(p->on_rq ?
					&task_rq(p)->lock : &p->pi_lock))

?

Not that I really suggest to change this WARN_ON(), I am just trying
to recall the new rules.

Oleg.

