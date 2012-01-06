Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab2AFNym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 08:54:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab2AFNyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 08:54:41 -0500
Date: Fri, 6 Jan 2012 14:48:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special
	condition
Message-ID: <20120106134834.GA19462@redhat.com>
References: <20111226171151.GA4472@redhat.com> <20111227154828.5120.E1E9C6FF@jp.fujitsu.com> <20120106192256.AB15.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106192256.AB15.E1E9C6FF@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06, Yasunori Goto wrote:
>
> +change_task_state_cmpxchg(struct task_struct *p, unsigned int target_state,
> +			  unsigned int new)
>  {
> -	trace_sched_wakeup(p, true);
> -	check_preempt_curr(rq, p, wake_flags);
> +	unsigned int old, tmp;
>
> -	p->state = TASK_RUNNING;
> +	old = p->state;
> +
> +	while (1) {
> +		if (old == new)
> +			return 1;
> +
> +		if (unlikely(!(old & target_state)))
> +			return 0;
> +
> +		tmp = cmpxchg(&p->state, old, new);
> +		if (likely(tmp == old))
> +			return 1;
> +
> +		old = tmp;
> +	}

I do not really think we should retry if cmpxchg fails. The state was
changed after initial check, we can pretend it was changed after we
change it succesfully.

> @@ -2828,11 +2883,18 @@ try_to_wake_up(struct task_struct *p, un
>  	if (!(p->state & state))
>  		goto out;
>
> -	success = 1; /* we're going to change ->state */
>  	cpu = task_cpu(p);
>
> -	if (p->on_rq && ttwu_remote(p, wake_flags))
> -		goto stat;
> +	if (p->on_rq) {
> +		int ret;
> +		ret = ttwu_remote(p, state, wake_flags);
> +		if (likely(ret == 1)) {
> +			success = 1;
> +			goto stat;
> +		} else if (unlikely(ret < 0))
> +			goto out;
> +	}
> +	success = 1; /* we're going to change ->state */

But this is not enough, you should also recheck the state below. Although
in this case you do not need atomic ops, the target can do nothing with
its ->state.

Anyway. I have to agree with Peter even if I suggested this initially.
This adds the unpleasant complications. Hopefully you found the only
case when the spurious wakeup really hurts, probably it is better to
fix do_exit().

Oleg.

