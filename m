Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab0KZPqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:46:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab0KZPqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:46:50 -0500
Date: Fri, 26 Nov 2010 16:40:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz
Subject: Re: [PATCH 05/14] signal: fix premature completion of group stop
	when interfered by ptrace
Message-ID: <20101126154009.GC28177@redhat.com>
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290768569-16224-6-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Tejun Heo wrote:
>
> task->signal->group_stop_count is used to tracke the progress of group
> stop.  It's initialized to the number of tasks which need to stop for
> group stop to finish and each stopping or trapping task decrements.
> However, each task doesn't keep track of whether it decremented the
> counter or not and if woken up before the group stop is complete and
> stops again, it can decrement the counter multiple times.

Everything is fine without ptrace, I hope.

(ignoring the deprecated CLONE_STOPPED)

> Please consider the following example code.

I didn't even read the test-case ;)

Yes, known problems. ptrace is very wrong when it comes to
group_stop_count/SIGNAL_STOP_STOPPED/etc. Almost everything
is wrong.

Cough, this is fixed in utrace ;) It doesn't use ptrace_stop/
ptrace_resume/etc at all.

> This patch adds a new field task->group_stop which is protected by
> siglock and uses GROUP_STOP_CONSUME flag to track which task is still
> to consume group_stop_count to fix this bug.

Yes, currently the tracee never knows how it should react to
->group_stop_count.

> @@ -1645,7 +1658,7 @@ static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
>  	 * we must participate in the bookkeeping.
>  	 */
>  	if (current->signal->group_stop_count > 0)
> -		--current->signal->group_stop_count;
> +		consume_group_stop();

This doesn't look exactly right. If we participate (decrement the
counter), we should stop even if we race with ptrace_detach().

And what if consume_group_stop() returns true? We should set
SIGNAL_STOP_STOPPED and notify ->parent.

Otherwise looks correct at first glance...


Of course, there are more problems. To me, even
ptrace_resume()->wake_up_process() is very wrt jctl.


Cosmetic nit,

> +static bool consume_group_stop(void)
> +{
> +	if (!(current->group_stop & GROUP_STOP_CONSUME))
> +		return false;
> +
> +	current->group_stop &= ~GROUP_STOP_CONSUME;
> +
> +	if (!WARN_ON_ONCE(current->signal->group_stop_count == 0))
> +		current->signal->group_stop_count--;

Every caller should check ->group_stop_count != 0. do_signal_stop()
does this too in fact. May be it would be cleaner to move this
check into consume_group_stop() and remove WARN_ON_ONCE().

This way it is more clear why prepare_signal(SIGCONT) do not
reset task->group_stop, it has no effect unless ->group_stop_count
is set by do_signal_stop() which updates ->group_stop for every
thread.

Probably consume_group_stop() should also set SIGNAL_STOP_STOPPED
if it returns true.

But, I didn't read the next patches yet...

Oleg.

