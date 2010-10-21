Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab0JUKvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:51:18 -0400
Received: from mail.openrapids.net ([64.15.138.104]:53243 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755081Ab0JUKvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:51:17 -0400
Date: Thu, 21 Oct 2010 06:51:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
Message-ID: <20101021105114.GA10216@Krystal>
References: <1287479765.9920.9.camel@marge.simson.net> <1287487757.24189.40.camel@marge.simson.net> <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com> <1287511983.7417.45.camel@marge.simson.net> <1287514410.7368.10.camel@marge.simson.net> <20101020025652.GB26822@elte.hu> <1287648715.9021.20.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287648715.9021.20.camel@marge.simson.net>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 06:46:28 up 28 days, 14:48,  1 user,  load average: 1.32, 1.21,
	0.94
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith (efault@gmx.de) wrote:
[...]
> +static void
> +autogroup_attach_tty(struct task_struct *p, struct task_group **tg)
> +{
> +	struct tty_struct *tty = p->signal->tty;
> +
> +	if (!tty)
> +		return;
> +
> +	*tg = p->signal->tty->tg;
> +}
> +
> +static inline void
> +autogroup_check_attach(struct task_struct *p, struct task_group **tg)
> +{
> +	if (!sysctl_sched_autogroup_enabled || *tg != &root_task_group ||
> +			p->sched_class != &fair_sched_class)
> +		return;
> +
> +	rcu_read_lock();
> +
> +	autogroup_attach_tty(p, tg);
> +
> +	rcu_read_unlock();
> +}
> +

Hi Mike,

This per-tty task grouping approach looks very promising. I'll give it a spin
when I find the time. Meanwhile, a little question about locking here: how is
the read lock supposed to protect from p->signal (and p->signal->tty)
modifications ? What's the locking scheme here ? So maybe just simple
rcu_dereference are missing, or maybe the tsk->sighand->siglock might be
required. In all cases, I feel something is missing there. 

Thanks!

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
