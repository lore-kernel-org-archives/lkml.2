Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab2ATRGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:06:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489Ab2ATRGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:06:13 -0500
Date: Fri, 20 Jan 2012 18:00:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] If init dies, log a signal which killed it, if any.
Message-ID: <20120120170010.GA14970@redhat.com>
References: <1327077547-3925-1-git-send-email-vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327077547-3925-1-git-send-email-vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20, Denys Vlasenko wrote:
>
> I just received another user's pleas for help when their
> init mystriously dies. I again explained that they need to check
> whether it dies because of bad instruction, a segv, or something else.
>
> Which prompted me to make kernel do this first step automatically.
> We can easily detect when the death is from e.g. SIGILL,
> and let user know that.
>
> The code is fairly self-explanatory. Compile-tested.
>
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> ---
>  kernel/exit.c |   23 ++++++++++++++++++++++-
>  1 files changed, 22 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 294b170..89d0892 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -710,8 +710,29 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
>
>  	if (unlikely(pid_ns->child_reaper == father)) {
>  		write_unlock_irq(&tasklist_lock);
> -		if (unlikely(pid_ns == &init_pid_ns))
> +		if (unlikely(pid_ns == &init_pid_ns)) {
> +			/*
> +			 * The situation when init segfaults is rather typical.
> +			 * Give some useful diagnostics: do we die on signal?
> +			 */
> +			if (fatal_signal_pending(father)) {

The fatal signal can be already dequeued. Although mostly this works.

> +				const char *msg = "";
> +				sigset_t *mask = &father->pending.signal;
> +				/* Only force_sig()ned signals kill init */
> +				if (sigismember(mask, SIGSEGV))
> +					msg = " SIGSEGV";
> +				if (sigismember(mask, SIGBUS))
> +					msg = " SIGBUS";
> +				if (sigismember(mask, SIGILL))
> +					msg = " SIGILL";
> +				if (sigismember(mask, SIGFPE))
> +					msg = " SIGFPE";

This doesn't look right too. Again, if it was killed by SIGSEGV
this signal can be dequeued and not pending.

> +				/* (do we want to check SIGTRAP too?) */
> +				printk(KERN_ERR
> +					"init received fatal signal%s\n", msg);
> +			}

I'd suggest this trivial change instead,

	-	panic("Attempted to kill init!");
	+	panic("Attempted to kill init! code=%08x\n",
	+		father->signal->group_exit_code ?: father->exit_code);

Oleg.

