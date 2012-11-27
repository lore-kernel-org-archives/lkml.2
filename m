Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab2K0Xve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:51:34 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57562 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab2K0Xvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:51:32 -0500
MIME-Version: 1.0
In-Reply-To: <1353958423.6276.54.camel@gandalf.local.home>
References: <1353680484-7302-1-git-send-email-fweisbec@gmail.com>
	<1353680484-7302-3-git-send-email-fweisbec@gmail.com>
	<1353956163.6276.46.camel@gandalf.local.home>
	<CAFTL4hxxE8Ggw4Ae-VfgBZ8rtoOMpUQnmSGUado1gxeruwQ9rg@mail.gmail.com>
	<1353958423.6276.54.camel@gandalf.local.home>
Date: Wed, 28 Nov 2012 00:51:32 +0100
Message-ID: <CAFTL4hzRmngv+RY0VWfOONCig-Gdvn-2XFVp0fzkc_a83PNO_w@mail.gmail.com>
Subject: Re: [PATCH 2/3] cputime: Rename thread_group_times to thread_group_cputime_adjusted
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/26 Steven Rostedt <rostedt@goodmis.org>:
> OK, let's take a look at the other version now:
>
> void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)

So this does the same thing than thread_group_cputime(), ie: fetch the
raw cputime stats from the task/signal struct, with a two adjustments:

* It scales the raw values with the CFS stats.
* It ensures the stats are increased monotonically across
thread_group_times() calls

More details below:

> {
>         struct signal_struct *sig = p->signal;
>         struct task_cputime cputime;
>         cputime_t rtime, utime, total;
>
>         thread_group_cputime(p, &cputime);
>
>         total = cputime.utime + cputime.stime;
>         rtime = nsecs_to_cputime(cputime.sum_exec_runtime);
>
>         if (total)
>                 utime = scale_utime(cputime.utime, rtime, total);
>         else
>                 utime = rtime;

raw cputime values (tsk->utime and tsk->stime) have a per tick
granularity. So the precision is not the best. For example a tick can
interrupt the same task 5 times while that task has actually ran for
no more than a jiffy overall. This can happen if the task runs for
short slices and get unlucky enough to often run at the same time the
tick fired.

The opposite can also happen: the task has ran for 5 jiffies but
wasn't much interrupted by the tick.

To fix this we scale utime and stime values against CFS accumulated
runtime for the task. As follows:

total_ticks_runtime = utime + stime
utime = utime * (total_cfs_runtime / total_ticks_runtime)
stime = total_cfs_runtime - utime

>
>         sig->prev_utime = max(sig->prev_utime, utime);
>         sig->prev_stime = max(sig->prev_stime, rtime - sig->prev_utime);

Now this scaling brings another problem. If between two calls of
thread_group_times(), tsk->utime has increased a lot and the cfs tsk
runtime hasn't increased that much, the resulting value of adjusted
stime may decrease from the 2nd to the 1st call of the function. But
userspace relies on the monotonicity of cputime. The same can happen
with utime if tsk->stime has increased a lot.

To fix this we apply the above monotonicity fixup.

I can add these explanations on comments in a new patch.

>
>         *ut = sig->prev_utime;
>         *st = sig->prev_stime;
> }
>
> So this version also updates the task's signal->prev_[us]times as well.
>
> I guess I'll wait for you to explain to me more about what is going
> on :-)
>
> -- Steve
>
>
