Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab1DMJYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 05:24:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:58100 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab1DMJYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 05:24:16 -0400
Subject: Re: [PATCH 04/21] sched: Change the ttwu success details
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>
Cc: Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110405152728.866866929@chello.nl>
References: <20110405152338.692966333@chello.nl>
	 <20110405152728.866866929@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Apr 2011 11:23:50 +0200
Message-ID: <1302686630.2388.125.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-05 at 17:23 +0200, Peter Zijlstra wrote:
> plain text document attachment (sched-change-ttwu-return.patch)
> try_to_wake_up() would only return a success when it would have to
> place a task on a rq, change that to every time we change p->state to
> TASK_RUNNING, because that's the real measure of wakeups.

So Ingo is reporting lockups with this patch on UP and I can't seem to
reproduce with his .config nor does it seem to make any sense.

The biggest change here is the movement of success = 1 in
try_to_wake_up(). The change to ttwu_post_activation() only affects a
tracepoint (if that changes behaviour something is seriously screwy) and
workqueue wakeups, and I doubt extra wakeups will cause lockups.

Therefore, the changes to try_to_wake_up_local() and wake_up_new_task()
are also not interesting. Leaving us with the one change in
try_to_wake_up().

> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
> ---
>  kernel/sched.c |   18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c

> @@ -2505,9 +2505,9 @@ static int try_to_wake_up(struct task_st
>  #endif /* CONFIG_SMP */
>  	ttwu_activate(p, rq, wake_flags & WF_SYNC, orig_cpu != cpu,
>  		      cpu == this_cpu, en_flags);
> -	success = 1;
>  out_running:
> -	ttwu_post_activation(p, rq, wake_flags, success);
> +	ttwu_post_activation(p, rq, wake_flags);
> +	success = 1;
>  out:
>  	task_rq_unlock(rq, &flags);
>  	put_cpu();

There we move success=1 so that out_running also returns success.

out_running is the case where the task has been marked
TASK_(UN)INTERRUPTIBLE but the schedule() function hasn't managed to
call deactivate_task() yet.

[ On UP that means ttwu took rq->lock before schedule() takes rq->lock ]

In that case we used to simply flip ->state back to TASK_RUNNING and not
return having woken up a task.

Now I think that is silly, because we most certainly did a wake-up, and
if we'd have a slightly different interleave with ttwu()/schedule() we
would have had to do a full wakeup.

So not treating that as a wakeup makes the ttwu() semantics dependent on
timing, something which IMO doesn't make any kind of sense.

Also, the only effect of also making that return a success is that
things like __wake_up_common() would see an extra wakeup and thus wakeup
one less task. But again, it actually was a real wakeup, the task would
have gone to sleep otherwise.

So I'm mighty puzzled as to how this causes grief.. and vexed for not
being able to reproduce.
