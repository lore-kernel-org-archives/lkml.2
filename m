Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab0JUTLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 15:11:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:47984 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755038Ab0JUTLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 15:11:39 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/+F94mZ6H+12MJjWnKME3u5KRb7oP4fzJe89hEJ2
	M7mqktTA6ZEWoa
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
In-Reply-To: <20101021162924.GA3225@redhat.com>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287487757.24189.40.camel@marge.simson.net>
	 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
	 <1287511983.7417.45.camel@marge.simson.net>
	 <1287514410.7368.10.camel@marge.simson.net>
	 <20101020025652.GB26822@elte.hu>
	 <1287648715.9021.20.camel@marge.simson.net>
	 <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins>
	 <20101021162924.GA3225@redhat.com>
Content-Type: text/plain
Date: Thu, 21 Oct 2010 21:11:34 +0200
Message-Id: <1287688294.7436.36.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 18:29 +0200, Oleg Nesterov wrote:
> On 10/21, Peter Zijlstra wrote:
> >
> > On Thu, 2010-10-21 at 06:51 -0400, Mathieu Desnoyers wrote:
> > > * Mike Galbraith (efault@gmx.de) wrote:
> > > [...]
> > > > +static void
> > > > +autogroup_attach_tty(struct task_struct *p, struct task_group **tg)
> > > > +{
> > > > +	struct tty_struct *tty = p->signal->tty;
> > > > +
> > > > +	if (!tty)
> > > > +		return;
> > > > +
> > > > +	*tg = p->signal->tty->tg;
> > > > +}
> 
> minor nit, I think in theory this needs barrier(), or
> 
> 	struct tty_struct *tty = ACCESS_ONCE(p->signal->tty);
> 
> 	if (tty)
> 		*tg = tty->tg;

Thanks.

> > > > +static inline void
> > > > +autogroup_check_attach(struct task_struct *p, struct task_group **tg)
> > > > +{
> > > > +	if (!sysctl_sched_autogroup_enabled || *tg != &root_task_group ||
> > > > +			p->sched_class != &fair_sched_class)
> > > > +		return;
> > > > +
> > > > +	rcu_read_lock();
> > > > +
> > > > +	autogroup_attach_tty(p, tg);
> > > > +
> > > > +	rcu_read_unlock();
> > > > +}
> > > > +
> >
> > >  Meanwhile, a little question about locking here: how is
> > > the read lock supposed to protect from p->signal (and p->signal->tty)
> > > modifications ? What's the locking scheme here ? So maybe just simple
> > > rcu_dereference are missing, or maybe the tsk->sighand->siglock might be
> > > required. In all cases, I feel something is missing there.
> >
> > Oleg, could you comment?
> 
> No, I don't understand this ;) But I know nothig about task groups,
> most probably this is OK.
> 
> It is not clear to me why do we need rcu_read_lock() and how it can help.
> The tty can go away right after dereferencing signal->tty.

It was inherited.

> Even if the task doesn't exit, it (or its sub-thread) can do sys_setsid()
> at any moment and free this tty. If any thread was moved to tty->sg, doesn't
> this mean that, say, ->cfs_rq will point to the already freed tg->cfs_rq?

Ah, so isn't as safe as it looked. Thanks!

> >From http://marc.info/?l=linux-kernel&m=128764874422614
> 
> 	+int sched_autogroup_handler(struct ctl_table *table, int write,
> 	+		void __user *buffer, size_t *lenp, loff_t *ppos)
> 	+{
> 	+	struct task_struct *p, *t;
> 	+	struct task_group *tg;
> 	+	int ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
> 	+
> 	+	if (ret || !write)
> 	+		return ret;
> 	+
> 	+	for_each_process(p) {
> 
> Hmm. This needs rcu lock at least?

(used to be paranoid locking there.. vs required locking)

> 	+		tg = task_group(p);
> 
> Why?

A cleanup leftover.

> 
> 	+		sched_move_task(p);
> 	+		list_for_each_entry_rcu(t, &p->thread_group, thread_group) {
> 	+			sched_move_task(t);
> 	+		}
> 	+	}
> 
> Looks like, you can just do
> 
> 	do_each_thread(p, t) {
> 		sched_move_task(t);
> 	} while_each_thread(p, t);
> 
> With the same effect.

Yeah.

So in theory, the tty can go away on me.  I knew this was too easy.

	-Mike


