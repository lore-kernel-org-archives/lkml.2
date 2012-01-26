Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab2AZQct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:32:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab2AZQcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:32:48 -0500
Date: Thu, 26 Jan 2012 17:26:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yasunori Goto <y-goto@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special
	condition
Message-ID: <20120126162611.GA1982@redhat.com>
References: <20120117090605.GD7612@elte.hu> <20120117151242.GA13290@redhat.com> <20120118094219.GE5842@elte.hu> <20120118142005.GB10105@redhat.com> <1327400349.2614.10.camel@laptop> <1327402527.2614.17.camel@laptop> <20120125154547.GA6671@redhat.com> <1327510290.2614.95.camel@laptop> <20120125174330.GA23303@redhat.com> <1327591943.2446.111.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327591943.2446.111.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, Peter Zijlstra wrote:
>
> So since we never call schedule() the p->on_rq thing will always be
> true. This means we don't need to consider all the icky ttwu after that,
> it also means the whole thing is inside ->pi_lock.
>
> So we only have to consider the exact case Yasunori-San illustrated, and
> waiting on ->pi_lock is sufficient.

Yes, and this is why I think Yasunori-san's patch should work. Because,
to remind, it adds unlock_wait(pi_lock).

> However I think your proposal:
>
> >                 for (;;) {
> >                         tsk->state = TASK_DEAD;
> >                         schedule();
> >                 }
>
> should equally work, if we hit the race and call schedule() with ->state
> = TASK_RUNNING,

Yes, in this case everything is fine, but we can shedule() with TASK_DEAD
state. preempt_disable() can't (and shouldn't) prevent deactivate_task().

To simplify, try_to_wake_up() does

		spin_lock(pi_lock);

		if (!(p->state & state))
			goto out;

		/* WINDOW */

		if (p->on_rq) {
			... everything is fine ...
		}

		p->state = TASK_WAKING;
		ttwu_queue(p, cpu);

And the exiting task does

	// but do not sleep ...
	current->state = TASK_UNINTERRUPTIBLE;
							// ttwu() checks ->state
	...
	tsk->state = TASK_DEAD;
	schedule();
		-> deactivate_task();
		-> tsk->on_rq = 0;
		-> finish_task_switch();

							// ttwu() checks ->on_rq

In theory it can do this all in the WINDOW above. In this case we
can wake it up again, after finish_task_switch()-put_task_struct().

No?

Oleg.

