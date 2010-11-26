Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab0KZTlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:41:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33008 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab0KZTlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:41:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 02/14] freezer: fix a race during freezing of TASK_STOPPED tasks
Date: Fri, 26 Nov 2010 20:40:27 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3+; KDE/4.4.4; x86_64; ; )
Cc: roland@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-3-git-send-email-tj@kernel.org>
In-Reply-To: <1290768569-16224-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201011262040.27854.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 26, 2010, Tejun Heo wrote:
> After calling freeze_task(), try_to_freeze_tasks() see whether the
> task is stopped or traced and if so, considers it to be frozen;
> however, nothing guarantees that either the task being frozen sees
> TIF_FREEZE or the freezer sees TASK_STOPPED -> TASK_RUNNING
> transition.  The task being frozen may wake up and not see TIF_FREEZE
> while the freezer fails to notice the transition and believes the task
> is still stopped.
> 
> This patch fixes the race by making freeze_task() always go through
> fake_signal_wake_up() for applicable tasks.  The function goes through
> the target task's scheduler lock and thus guarantees that either the
> target sees TIF_FREEZE or try_to_freeze_task() sees TASK_RUNNING.

Looks good.  I'll take this one to my tree, if you don't mind.

Thanks,
Rafael


> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  kernel/freezer.c       |    9 +++++++--
>  kernel/power/process.c |    6 ++++++
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index bd1d42b..66ecd2e 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -104,8 +104,13 @@ bool freeze_task(struct task_struct *p, bool sig_only)
>  	}
>  
>  	if (should_send_signal(p)) {
> -		if (!signal_pending(p))
> -			fake_signal_wake_up(p);
> +		fake_signal_wake_up(p);
> +		/*
> +		 * fake_signal_wake_up() goes through p's scheduler
> +		 * lock and guarantees that TASK_STOPPED/TRACED ->
> +		 * TASK_RUNNING transition can't race with task state
> +		 * testing in try_to_freeze_tasks().
> +		 */
>  	} else if (sig_only) {
>  		return false;
>  	} else {
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index e50b4c1..eb2c88a 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -64,6 +64,12 @@ static int try_to_freeze_tasks(bool sig_only)
>  			 * perturb a task in TASK_STOPPED or TASK_TRACED.
>  			 * It is "frozen enough".  If the task does wake
>  			 * up, it will immediately call try_to_freeze.
> +			 *
> +			 * Because freeze_task() goes through p's
> +			 * scheduler lock after setting TIF_FREEZE, it's
> +			 * guaranteed that either we see TASK_RUNNING or
> +			 * try_to_stop() after schedule() in ptrace/signal
> +			 * stop sees TIF_FREEZE.
>  			 */
>  			if (!task_is_stopped_or_traced(p) &&
>  			    !freezer_should_skip(p))
> 

