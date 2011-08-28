Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab1H1R7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 13:59:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab1H1R7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 13:59:35 -0400
Date: Sun, 28 Aug 2011 19:56:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 09/16] freezer: make freezing indicate freeze condition
	in effect
Message-ID: <20110828175601.GB27032@redhat.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-10-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313763382-12341-10-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19, Tejun Heo wrote:
>
> This patch makes freezing indicate that freeze condition is in effect.
> A task enters and stays frozen if freezing.  This makes PF_FROZEN
> manipulation done only by the task itself and prevents wakeup from
> __thaw_task() leaking outside of refrigerator.

but this looks racy.

> @@ -44,7 +48,7 @@ bool __refrigerator(bool check_kthr_stop)
>  
>  	for (;;) {
>  		set_current_state(TASK_UNINTERRUPTIBLE);
> -		if (!frozen(current) ||
> +		if (!freezing(current) ||
>  		    (check_kthr_stop && kthread_should_stop()))
>  			break;
>  		was_frozen = true;
> @@ -54,6 +58,11 @@ bool __refrigerator(bool check_kthr_stop)
>  	/* Remove the accounting blocker */
>  	current->flags &= ~PF_FREEZING;
>  
> +	/* leave FROZEN */
> +	spin_lock_irq(&freezer_lock);
> +	current->flags &= ~PF_FROZEN;
> +	spin_unlock_irq(&freezer_lock);

What if freezing() is true again when we are going to clear
PF_FROZEN?

In this case the 2nd try_to_freeze_tasks() can see this task
as already frozen and return success while it is going to run.

Oleg.

