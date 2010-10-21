Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab0JUL10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 07:27:26 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53063 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756721Ab0JUL1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 07:27:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX180J048wWs0ZzzgUocipQ/AU7fLTjwPJcMevqOTiH
	KR5n9QnxQ2k0kf
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
In-Reply-To: <20101021105114.GA10216@Krystal>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287487757.24189.40.camel@marge.simson.net>
	 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
	 <1287511983.7417.45.camel@marge.simson.net>
	 <1287514410.7368.10.camel@marge.simson.net>
	 <20101020025652.GB26822@elte.hu>
	 <1287648715.9021.20.camel@marge.simson.net>
	 <20101021105114.GA10216@Krystal>
Content-Type: text/plain
Date: Thu, 21 Oct 2010 13:27:20 +0200
Message-Id: <1287660440.16101.20.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 06:51 -0400, Mathieu Desnoyers wrote:
> * Mike Galbraith (efault@gmx.de) wrote:
> [...]
> > +static void
> > +autogroup_attach_tty(struct task_struct *p, struct task_group **tg)
> > +{
> > +	struct tty_struct *tty = p->signal->tty;
> > +
> > +	if (!tty)
> > +		return;
> > +
> > +	*tg = p->signal->tty->tg;
> > +}
> > +
> > +static inline void
> > +autogroup_check_attach(struct task_struct *p, struct task_group **tg)
> > +{
> > +	if (!sysctl_sched_autogroup_enabled || *tg != &root_task_group ||
> > +			p->sched_class != &fair_sched_class)
> > +		return;
> > +
> > +	rcu_read_lock();
> > +
> > +	autogroup_attach_tty(p, tg);
> > +
> > +	rcu_read_unlock();
> > +}
> > +
> 
> Hi Mike,
> 
> This per-tty task grouping approach looks very promising. I'll give it a spin
> when I find the time. Meanwhile, a little question about locking here: how is
> the read lock supposed to protect from p->signal (and p->signal->tty)
> modifications ? What's the locking scheme here ? So maybe just simple
> rcu_dereference are missing, or maybe the tsk->sighand->siglock might be
> required. In all cases, I feel something is missing there.

My assumption is that no additional locking is needed.  The tty is
refcounted, dropped in release_task()->__exit_signal(), at which point
the task is unhashed, is history.  The tty can't go away until the last
task referencing it goes away.

	-Mike

