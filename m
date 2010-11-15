Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab0KONEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 08:04:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab0KONEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 08:04:39 -0500
Date: Mon, 15 Nov 2010 13:57:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101115125716.GA22422@redhat.com>
References: <AANLkTikjSCbcRnKOU=nd4os1sdW-GJkD6QVj=U5zPyu8@mail.gmail.com> <20101114202734.GA1627@arch.trippelsdorf.de> <AANLkTimHtjH3YvtX6i542_XjfFeuvG-AnU8i224a1R4j@mail.gmail.com> <1289778189.5154.10.camel@maggy.simson.net> <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com> <AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com> <1289783580.495.58.camel@maggy.simson.net> <1289811438.2109.474.camel@laptop> <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289821590.16406.47.camel@maggy.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I continue to play the advocatus diaboli ;)

On 11/15, Mike Galbraith wrote:
>
> +static inline bool
> +task_wants_autogroup(struct task_struct *p, struct task_group *tg)
> +{
> +	if (tg != &root_task_group)
> +		return false;
> +
> +	if (p->sched_class != &fair_sched_class)
> +		return false;
> +
> +	if (p->flags & PF_EXITING)
> +		return false;

Hmm, why? Perhaps PF_EXITING was needed in the previous version to
avoid the race with release_task(). But now it is always safe to
use signal->autogroup.

And the exiting task can do a lot before it disappears, probably
we shouldn't ignore ->autogroup.

> +static void
> +autogroup_move_group(struct task_struct *p, struct autogroup *ag)
> +{
> +	struct autogroup *prev;
> +	struct task_struct *t;
> +	struct rq *rq;
> +	unsigned long flags;
> +
> +	rq = task_rq_lock(p, &flags);
> +	prev = p->signal->autogroup;
> +	if (prev == ag) {
> +		task_rq_unlock(rq, &flags);
> +		return;
> +	}
> +
> +	p->signal->autogroup = autogroup_kref_get(ag);
> +	__sched_move_task(p, rq);
> +	task_rq_unlock(rq, &flags);
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(t, &p->thread_group, thread_group) {
> +		sched_move_task(t);
> +	}
> +	rcu_read_unlock();

Not sure I understand why do we need rq->lock...

It can't protect the change of signal->autogroup, multiple callers
can use different rq's.

However. Currently the only callers holds ->siglock, so we are safe.
Perhaps we should just document that autogroup_move_group() needs
->siglock.

This also mean the patch can be simplified even more, __sched_move_task()
is not needed.

> +void sched_autogroup_fork(struct signal_struct *sig)
> +{
> +	sig->autogroup = autogroup_kref_get(current->signal->autogroup);
> +}

Well, in theory this can race with another thread doing autogroup_move_group().
We can read the old ->autogroup, and then use it after it was already freed.

Probably this needs ->siglock too.

Oleg.

