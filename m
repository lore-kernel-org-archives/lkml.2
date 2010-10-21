Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab0JURcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 13:32:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab0JURcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 13:32:47 -0400
Date: Thu, 21 Oct 2010 18:29:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
Message-ID: <20101021162924.GA3225@redhat.com>
References: <1287479765.9920.9.camel@marge.simson.net> <1287487757.24189.40.camel@marge.simson.net> <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com> <1287511983.7417.45.camel@marge.simson.net> <1287514410.7368.10.camel@marge.simson.net> <20101020025652.GB26822@elte.hu> <1287648715.9021.20.camel@marge.simson.net> <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287660312.3488.103.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21, Peter Zijlstra wrote:
>
> On Thu, 2010-10-21 at 06:51 -0400, Mathieu Desnoyers wrote:
> > * Mike Galbraith (efault@gmx.de) wrote:
> > [...]
> > > +static void
> > > +autogroup_attach_tty(struct task_struct *p, struct task_group **tg)
> > > +{
> > > +	struct tty_struct *tty = p->signal->tty;
> > > +
> > > +	if (!tty)
> > > +		return;
> > > +
> > > +	*tg = p->signal->tty->tg;
> > > +}

minor nit, I think in theory this needs barrier(), or

	struct tty_struct *tty = ACCESS_ONCE(p->signal->tty);

	if (tty)
		*tg = tty->tg;

> > > +static inline void
> > > +autogroup_check_attach(struct task_struct *p, struct task_group **tg)
> > > +{
> > > +	if (!sysctl_sched_autogroup_enabled || *tg != &root_task_group ||
> > > +			p->sched_class != &fair_sched_class)
> > > +		return;
> > > +
> > > +	rcu_read_lock();
> > > +
> > > +	autogroup_attach_tty(p, tg);
> > > +
> > > +	rcu_read_unlock();
> > > +}
> > > +
>
> >  Meanwhile, a little question about locking here: how is
> > the read lock supposed to protect from p->signal (and p->signal->tty)
> > modifications ? What's the locking scheme here ? So maybe just simple
> > rcu_dereference are missing, or maybe the tsk->sighand->siglock might be
> > required. In all cases, I feel something is missing there.
>
> Oleg, could you comment?

No, I don't understand this ;) But I know nothig about task groups,
most probably this is OK.

It is not clear to me why do we need rcu_read_lock() and how it can help.
The tty can go away right after dereferencing signal->tty.

Even if the task doesn't exit, it (or its sub-thread) can do sys_setsid()
at any moment and free this tty. If any thread was moved to tty->sg, doesn't
this mean that, say, ->cfs_rq will point to the already freed tg->cfs_rq?

>From http://marc.info/?l=linux-kernel&m=128764874422614

	+int sched_autogroup_handler(struct ctl_table *table, int write,
	+		void __user *buffer, size_t *lenp, loff_t *ppos)
	+{
	+	struct task_struct *p, *t;
	+	struct task_group *tg;
	+	int ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
	+
	+	if (ret || !write)
	+		return ret;
	+
	+	for_each_process(p) {

Hmm. This needs rcu lock at least?

	+		tg = task_group(p);

Why?

	+		sched_move_task(p);
	+		list_for_each_entry_rcu(t, &p->thread_group, thread_group) {
	+			sched_move_task(t);
	+		}
	+	}

Looks like, you can just do

	do_each_thread(p, t) {
		sched_move_task(t);
	} while_each_thread(p, t);

With the same effect.

Oleg.

