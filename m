Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1HSVHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 17:07:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53642 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab1HSVHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 17:07:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 01/16] freezer: fix current->state restoration race in refrigerator()
Date: Fri, 19 Aug 2011 23:08:59 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: menage@google.com, linux-kernel@vger.kernel.org, arnd@arndb.de,
        oleg@redhat.com
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-2-git-send-email-tj@kernel.org>
In-Reply-To: <1313763382-12341-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201108192308.59705.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 19, 2011, Tejun Heo wrote:
> refrigerator() saves current->state before entering frozen state and
> restores it before returning using __set_current_state(); however,
> this is racy, for example, please consider the following sequence.
> 
> 	set_current_state(TASK_INTERRUPTIBLE);
> 	try_to_sleep();

Did you mean try_to_freeze() here?

> 	if (kthread_should_stop())
> 		break;
> 	schedule();
> 
> If kthread_stop() races with ->state restoration, the restoration can
> restore ->state to TASK_INTERRUPTIBLE after kthread_stop() sets it to
> TASK_RUNNING but kthread_should_stop() may still see zero
> ->should_stop because there's no memory barrier between restoring
> TASK_INTERRUPTIBLE and kthread_should_stop() test.
> 
> This isn't restricted to kthread_should_stop().  current->state is
> often used in memory barrier based synchronization and silently
> restoring it w/o mb breaks them.
> 
> Use set_current_state() instead.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/freezer.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index 7b01de9..575f863 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -58,7 +58,13 @@ void refrigerator(void)
>  	current->flags &= ~PF_FREEZING;
>  
>  	pr_debug("%s left refrigerator\n", current->comm);
> -	__set_current_state(save);
> +
> +	/*
> +	 * Restore saved task state before returning.  The mb'd version
> +	 * needs to be used; otherwise, it might silently break
> +	 * synchronization which depends on ordered task state change.
> +	 */
> +	set_current_state(save);

I think the change is correct.

>  }
>  EXPORT_SYMBOL(refrigerator);

Thanks,
Rafael
