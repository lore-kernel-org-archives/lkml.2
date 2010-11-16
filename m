Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934468Ab0KPNLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 08:11:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756379Ab0KPNLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 08:11:12 -0500
Date: Tue, 16 Nov 2010 14:04:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101116130413.GA29368@redhat.com>
References: <AANLkTimHtjH3YvtX6i542_XjfFeuvG-AnU8i224a1R4j@mail.gmail.com> <1289778189.5154.10.camel@maggy.simson.net> <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com> <AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com> <1289783580.495.58.camel@maggy.simson.net> <1289811438.2109.474.camel@laptop> <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net> <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289856350.14719.135.camel@maggy.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15, Mike Galbraith wrote:
>
> On Mon, 2010-11-15 at 13:57 +0100, Oleg Nesterov wrote:
>
> > And the exiting task can do a lot before it disappears, probably
> > we shouldn't ignore ->autogroup.

I don't really understand what makes the exiting task different,
but OK.

However, I must admit I dislike this check. Because, looking at this
code, it is not clear why do we check PF_EXITING. It looks as if it
is needed for correctness.

OK, this is minor. I think the patch is correct, just one nit below.

> > It can't protect the change of signal->autogroup, multiple callers
> > can use different rq's.
>
> Guaranteed live ->autogroup should be good enough for heuristic use, and
> had better be so.  Having to take ->siglock in the fast path would kill
> using ->signal.

Yes, sure, rq->lock should ensure signal->autogroup can't go away.
(even if it can be changed under us). And it does, we are moving all
threads before kref_put().

> +static void
> +autogroup_move_group(struct task_struct *p, struct autogroup *ag)
> +{
> +	struct autogroup *prev;
> +	struct task_struct *t;
> +
> +	prev = p->signal->autogroup;
> +	if (prev == ag)
> +		return;
> +
> +	p->signal->autogroup = autogroup_kref_get(ag);
> +	sched_move_task(p);
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(t, &p->thread_group, thread_group) {
> +		sched_move_task(t);
> +	}
> +	rcu_read_unlock();
> +
> +	autogroup_kref_put(prev);
> +}

Well, this looks a bit strange (but correct).

We are changing ->autogroup assuming the caller holds ->siglock.
But if we hold ->siglock we do not need rcu_read_lock() to iterate
over the thread_group, we can just do

	p->signal->autogroup = autogroup_kref_get(ag);

	t = p;
	do {
		sched_move_task(t);
	} while_each_thread(p, t);

Again, this is minor, I won't insist.

Oleg.

