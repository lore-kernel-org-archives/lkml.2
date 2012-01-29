Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2A2QNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 11:13:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab2A2QNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 11:13:48 -0500
Date: Sun, 29 Jan 2012 17:07:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, y-goto@jp.fujitsu.com,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Fix ancient race in do_exit()
Message-ID: <20120129160711.GA20803@redhat.com>
References: <20120117174031.3118.E1E9C6FF@jp.fujitsu.com> <tip-b5740f4b2cb3503b436925eb2242bc3d75cd3dfe@git.kernel.org> <CA+55aFyO0KxGQxYYUqmVrNqG6qVFnRT2g-kYYKtH5QG3vTnO=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyO0KxGQxYYUqmVrNqG6qVFnRT2g-kYYKtH5QG3vTnO=A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28, Linus Torvalds wrote:
>
> On Sat, Jan 28, 2012 at 4:03 AM, tip-bot for Yasunori Goto
> <y-goto@jp.fujitsu.com> wrote:
> >
> > sched: Fix ancient race in do_exit()
>
> Ugh.
>
> It would be much nicer to just clear the rwsem waiter->task thing
> *after* waking the task up, which would avoid this race entirely,
> afaik.

How? The problem is that wake_up_process(tsk) sees this task in
TASK_UNINTERRUPTIBLE state (the first "p->state & state" check in
try_to_wake_up), but then this task changes its state to TASK_DEAD
without schedule() and ttwu() does s/TASK_DEAD/TASK_RUNNING/.

IOW, the task doing

	current->state = TASK_A;
	...
	current->state = TASK_B;
	schedule();

can be woken up by try_to_wake_up(TASK_A), despite the fact it
sleeps in TASK_B. do_exit() is only "special" because it is not
easy to handle the spurious wakeup.
	
> Tell me, why wouldn't that work? rwsem_down_failed_common() does
>
>         /* wait to be given the lock */
>         for (;;) {
>                 if (!waiter.task)
>                         break;
>                ...
>
> so then we wouldn't need the task refcount crap in rwsem either etc,
> and we'd get rid of all races with wakeup.
>
> I wonder why we're clearing that whole waiter->task so early.

I must have missed something. I can't understand how this can help,
and "clear the rwsem waiter->task thing *after* waking" looks
obviously wrong. If we do this, then we can miss the "!!waiter.task"
condition. The loop above actually does

	set_task_state(TASK_UNINTERRUPTIBLE);

	if (!waiter.task)
		break;
	schedule();

and
	wake_up_process(tsk);
	waiter->task = NULL;

can happen right after set_task_state().

Oleg.

