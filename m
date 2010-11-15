Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab0KOI5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 03:57:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:53429 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab0KOI5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 03:57:14 -0500
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1289783580.495.58.camel@maggy.simson.net>
References: <1289489200.11397.21.camel@maggy.simson.net>
	 <20101111202703.GA16282@redhat.com>
	 <1289514000.21413.204.camel@maggy.simson.net>
	 <20101112181240.GB8659@redhat.com>
	 <1289648524.22764.149.camel@maggy.simson.net>
	 <1289755150.3228.44.camel@maggy.simson.net>
	 <20101114174921.GA1569@arch.trippelsdorf.de>
	 <1289758238.17491.12.camel@maggy.simson.net>
	 <AANLkTimy5DdF8qwGuk09iT3wHfXMjkiwRKxo-LuvEJzW@mail.gmail.com>
	 <AANLkTikjSCbcRnKOU=nd4os1sdW-GJkD6QVj=U5zPyu8@mail.gmail.com>
	 <20101114202734.GA1627@arch.trippelsdorf.de>
	 <AANLkTimHtjH3YvtX6i542_XjfFeuvG-AnU8i224a1R4j@mail.gmail.com>
	 <1289778189.5154.10.camel@maggy.simson.net>
	 <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com>
	 <AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com>
	 <1289783580.495.58.camel@maggy.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 15 Nov 2010 09:57:18 +0100
Message-ID: <1289811438.2109.474.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-14 at 18:13 -0700, Mike Galbraith wrote:
> +static inline struct task_group *
> +autogroup_task_group(struct task_struct *p, struct task_group *tg)
> +{
> +       int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
> +
> +       enabled &= (tg == &root_task_group);
> +       enabled &= (p->sched_class == &fair_sched_class);
> +       enabled &= (!(p->flags & PF_EXITING));
> +
> +       if (enabled)
> +               return p->signal->autogroup->tg;
> +
> +       return tg;
> +} 


That made me go wtf.. curious way of writing things.

I guess the usual way of writing that (which is admittedly a little more
verbose) would be something like:

static bool 
task_wants_autogroup(struct task_struct *tsk, struct task_group *tg)
{
	if (tg != &root_task_group)
		return false;

	if (tsk->sched_class != &fair_sched_class)
		return false;

	if (tsk->flags & PF_EXITING)
		return false;

	return true;
}

static inline struct task_group *
autogroup_task_group(struct task_struct *tsk, struct task_group *tg)
{
	if (task_wants_autogroup(tsk, tg))
		return tsk->signal->autogroup->tg;

	return tg;
}


