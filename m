Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab2BUXDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 18:03:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35715 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070Ab2BUXC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 18:02:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: Re: [PATCH] PM/Freezer: Remove references to TIF_FREEZE in comments
Date: Wed, 22 Feb 2012 00:06:55 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: len.brown@intel.com, pavel@ucw.cz, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
References: <1329860115-2130-1-git-send-email-marcos.mage@gmail.com>
In-Reply-To: <1329860115-2130-1-git-send-email-marcos.mage@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201202220006.56033.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 21, 2012, Marcos Paulo de Souza wrote:
> This patch removes all the references in the code about TIF_FREEZE(flag removed by
> the commit a3201227f803ad7fd43180c5195dbe5a2bf998aa).
> 
> Suggested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>

Applied.

Thanks,
Rafael


> ---
> 
> Sent again to put lkml and linux-pm int cc'ing... Sorry for it...
> 
> 
> Still there are some references to TIF_FREEZE in 
> Documentation/power/freezing-of-tasks.txt, but it looks like that documentation
> needs a more thorough work to reflect how the new freezer works, and hence merely
> removing the references to TIF_FREEZE won't really help. So I have not touched that
> part in this patch.
> 
>  kernel/exit.c          |    2 +-
>  kernel/freezer.c       |    6 +++---
>  kernel/power/process.c |    8 +++-----
>  3 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 4b4042f..8e6b0e6 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -424,7 +424,7 @@ void daemonize(const char *name, ...)
>  	 */
>  	exit_mm(current);
>  	/*
> -	 * We don't want to have TIF_FREEZE set if the system-wide hibernation
> +	 * We don't want to get frozen, in case system-wide hibernation
>  	 * or suspend transition begins right now.
>  	 */
>  	current->flags |= (PF_NOFREEZE | PF_KTHREAD);
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index 9815b8d..11f82a4 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -99,9 +99,9 @@ static void fake_signal_wake_up(struct task_struct *p)
>   * freeze_task - send a freeze request to given task
>   * @p: task to send the request to
>   *
> - * If @p is freezing, the freeze request is sent by setting %TIF_FREEZE
> - * flag and either sending a fake signal to it or waking it up, depending
> - * on whether it has %PF_FREEZER_NOSIG set.
> + * If @p is freezing, the freeze request is sent either by sending a fake
> + * signal (if it's not a kernel thread) or waking it up (if it's a kernel
> + * thread).
>   *
>   * RETURNS:
>   * %false, if @p is not freezing or already frozen; %true, otherwise
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index 7e42645..ccb8088 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -53,11 +53,9 @@ static int try_to_freeze_tasks(bool user_only)
>  			 * It is "frozen enough".  If the task does wake
>  			 * up, it will immediately call try_to_freeze.
>  			 *
> -			 * Because freeze_task() goes through p's
> -			 * scheduler lock after setting TIF_FREEZE, it's
> -			 * guaranteed that either we see TASK_RUNNING or
> -			 * try_to_stop() after schedule() in ptrace/signal
> -			 * stop sees TIF_FREEZE.
> +			 * Because freeze_task() goes through p's scheduler lock, it's
> +			 * guaranteed that TASK_STOPPED/TRACED -> TASK_RUNNING
> +			 * transition can't race with task state testing here.
>  			 */
>  			if (!task_is_stopped_or_traced(p) &&
>  			    !freezer_should_skip(p))
> 

