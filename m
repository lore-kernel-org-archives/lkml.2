Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab1HXWeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:34:19 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60793 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1HXWeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:34:18 -0400
Date: Wed, 24 Aug 2011 15:34:12 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de, oleg@redhat.com
Subject: Re: [PATCH 06/16] freezer: make exiting tasks properly unfreezable
Message-ID: <20110824223412.GG28444@count0.beaverton.ibm.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <1313763382-12341-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313763382-12341-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 04:16:12PM +0200, Tejun Heo wrote:
> There's no point in freezing an exiting task.  The current code
> seemingly tries that by calling clear_freeze_flag() from exit_mm() but
> it's racy as freeze might happen afterwards.
> 
> This patch removes the racy clear_freeze_flag() makes do_exit() set
> PF_NOFREEZE after PTRACE_EVENT_EXIT, after which freezing doesn't make
> sense.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/exit.c          |    8 ++++++--
>  kernel/power/process.c |    3 +--
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 2913b35..ac58259 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -679,8 +679,6 @@ static void exit_mm(struct task_struct * tsk)
>  	tsk->mm = NULL;
>  	up_read(&mm->mmap_sem);
>  	enter_lazy_tlb(mm, current);
> -	/* We don't want this task to be frozen prematurely */
> -	clear_freeze_flag(tsk);

This patch doesn't look quite right. Perhaps that's because I'm
unclear why any of the freezer flags matter in the do_exit() path. How
can the task enter the refrigerator in do_exit()? Isn't it true that
we don't enter the syscall return path and thus can't freeze
anyway (the last thing it should do is schedule())? Or is this another
kthread quirk?

If we can't enter the refrigerator then why fiddle with these flags
here at all? That might explain why this race never introduced
problems.

>  	if (tsk->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
>  		atomic_dec(&mm->oom_disable_count);
>  	task_unlock(tsk);
> @@ -915,6 +913,12 @@ NORET_TYPE void do_exit(long code)
> 
>  	ptrace_event(PTRACE_EVENT_EXIT, code);
> 
> +	/*
> +	 * With ptrace notification done, there's no point in freezing from
> +	 * here on.  Disallow freezing.
> +	 */
> +	current->flags |= PF_NOFREEZE;
> +
>  	validate_creds_for_do_exit(tsk);

OK, now I'm assuming my reasoning above is wrong; that it's possible to
enter the refrigerator in do_exit().

Couldn't TIF_FREEZE already be set? Setting PF_NOFREEZE only ensures
the flag won't get set "after" this point. To fix this I think we'd need
something more like:

	current->flags |= PF_NOFREEZE;
	smp_wmb();
	clear_freeze_flag(tsk);

Otherwise TIF_FREEZE might not get cleared and, despite PF_NOFREEZE,
we could somehow enter the refrigerator. Also, I'm not sure the
smp_wmb() is sufficient since it will only affect the order the writes
appear and does not affect whether other cpus will see PF_NOFREEZE
before we clear the TIF_FREEZE flag. Perhaps we need task_lock() here.

> 
>  	/*
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index bec09c3..ddfaba4 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -25,8 +25,7 @@
>  static inline int freezable(struct task_struct * p)
>  {
>  	if ((p == current) ||
> -	    (p->flags & PF_NOFREEZE) ||
> -	    (p->exit_state != 0))
> +	    (p->flags & PF_NOFREEZE))

This patch also fiddles with the timing of adjusting or checking three
different pieces of task state:

	exit_state
	flags (PF_NOFREEZE)
	thread flags (TIF_FREEZE)

each of which get set/cleared at different times from the new
line adding PF_NOFREEZE to the flags. So I'm a little nervous that
we might be missing some important details.

Cheers,
	-Matt Helsley
