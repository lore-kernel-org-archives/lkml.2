Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab0JULZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 07:25:23 -0400
Received: from fep20.mx.upcmail.net ([62.179.121.40]:37652 "EHLO
	fep20.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab0JULZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 07:25:22 -0400
X-SourceIP: 80.56.199.130
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20101021105114.GA10216@Krystal>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287487757.24189.40.camel@marge.simson.net>
	 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
	 <1287511983.7417.45.camel@marge.simson.net>
	 <1287514410.7368.10.camel@marge.simson.net>
	 <20101020025652.GB26822@elte.hu>
	 <1287648715.9021.20.camel@marge.simson.net>
	 <20101021105114.GA10216@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 13:25:12 +0200
Message-ID: <1287660312.3488.103.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=/bZgxt9lcTTiCogXEfKVRpwqFqbGXHB0knonYiER/Vo= c=1 sm=0 a=7e7bKk0oKioA:10 a=IkcTkHD0fZMA:10 a=WwmCGJbcYGGmICQJKmYA:9 a=5DbyGMI6IuzaFf65YdQA:7 a=2TEKCAHy576c_6T0_UX7FecyLBMA:4 a=QEXdDO2ut3YA:10 a=_RhRFcbxBZMA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
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

>  Meanwhile, a little question about locking here: how is
> the read lock supposed to protect from p->signal (and p->signal->tty)
> modifications ? What's the locking scheme here ? So maybe just simple
> rcu_dereference are missing, or maybe the tsk->sighand->siglock might be
> required. In all cases, I feel something is missing there. 

Oleg, could you comment?

