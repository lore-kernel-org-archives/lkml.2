Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab2ARO0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:26:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757651Ab2ARO0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:26:17 -0500
Date: Wed, 18 Jan 2012 15:20:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special
	condition
Message-ID: <20120118142005.GB10105@redhat.com>
References: <20120116205140.6120.E1E9C6FF@jp.fujitsu.com> <1326721082.2442.234.camel@twins> <20120117174031.3118.E1E9C6FF@jp.fujitsu.com> <20120117090605.GD7612@elte.hu> <20120117151242.GA13290@redhat.com> <20120118094219.GE5842@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118094219.GE5842@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18, Ingo Molnar wrote:
>
> Well, but does the -rt kernel suffer from the same race?

I think yes.

To remind, the problem is generic, it is not bound to this
particular place. Let me repeat:

Suppose that the task T does

	set_current_state(TASK_INTERRUPTIBLE);

	set_current_state(TASK_UNINTERRUPTIBLE);
	schedule();

try_to_wake_up(TASK_UNINTERRUPTIBLE) in between can observe this task
in TASK_INTERRUPTIBLE state. Then it can set RUNNING/WAKING after T
sets ->state = TASK_UNINTERRUPTIBLE.

For example, this is possibly if T simply does wait_event() twice when
the the 1st wait_event() doesn't sleep.


do_exit() is different because it can not handle the spurious wakeup.
Well, may be we can? we can simply do

		for (;;) {
			tsk->state = TASK_DEAD;
			schedule();
		}

__schedule() can't race with ttwu() once it takes rq->lock. If the
exiting task is deactivated, finish_task_switch() will see EXIT_DEAD.
Unless I missed something, the only problem is preempt_disable(),
but schedule_debug() checks ->exit_state.

OTOH, if we fix this race then probably schedule_debug() should
check state == EXIT_DEAD instead.

> So if there's something in the -rt kernel that fixes this race
> we'd like to have that. If the bug is present in the -rt kernel
> then why didn't it ever get triggered? We caught much more
> narrow races in -rt, and very early on in the project.

I do not know.

Oleg.

