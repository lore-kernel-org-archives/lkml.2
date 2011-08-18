Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1HRIdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 04:33:51 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:51029 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab1HRIdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 04:33:49 -0400
Subject: Re: [PATCH 32/41] unicore32: Use set_current_blocked()
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Matt Fleming <matt@console-pimps.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        arnd@arndb.de
In-Reply-To: <1313071035-12047-33-git-send-email-matt@console-pimps.org>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
	 <1313071035-12047-33-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Thu, 18 Aug 2011 16:34:27 +0800
Message-ID: <1313656467.2905.14.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks good to me.

And already tested by compilation.

Cc: Arnd Bergmann <arnd@arndb.de>

Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Thanks & Regards.

Guan Xuetao


On Thu, 2011-08-11 at 14:57 +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> As described in e6fa16ab ("signal: sigprocmask() should do
> retarget_shared_pending()") the modification of current->blocked is
> incorrect as we need to check whether the signal we're about to block
> is pending in the shared queue.
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/unicore32/kernel/signal.c |   15 +++++----------
>  1 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/unicore32/kernel/signal.c b/arch/unicore32/kernel/signal.c
> index b163fca..911b549 100644
> --- a/arch/unicore32/kernel/signal.c
> +++ b/arch/unicore32/kernel/signal.c
> @@ -63,10 +63,7 @@ static int restore_sigframe(struct pt_regs *regs, struct sigframe __user *sf)
>  	err = __copy_from_user(&set, &sf->uc.uc_sigmask, sizeof(set));
>  	if (err == 0) {
>  		sigdelsetmask(&set, ~_BLOCKABLE);
> -		spin_lock_irq(&current->sighand->siglock);
> -		current->blocked = set;
> -		recalc_sigpending();
> -		spin_unlock_irq(&current->sighand->siglock);
> +		set_current_blocked(&set);
>  	}
>  
>  	err |= __get_user(regs->UCreg_00, &sf->uc.uc_mcontext.regs.UCreg_00);
> @@ -321,6 +318,7 @@ static int handle_signal(unsigned long sig, struct k_sigaction *ka,
>  {
>  	struct thread_info *thread = current_thread_info();
>  	struct task_struct *tsk = current;
> +	sigset_t blocked;
>  	int usig = sig;
>  	int ret;
>  
> @@ -372,13 +370,10 @@ static int handle_signal(unsigned long sig, struct k_sigaction *ka,
>  	/*
>  	 * Block the signal if we were successful.
>  	 */
> -	spin_lock_irq(&tsk->sighand->siglock);
> -	sigorsets(&tsk->blocked, &tsk->blocked,
> -		  &ka->sa.sa_mask);
> +	sigorsets(&blocked, &tsk->blocked, &ka->sa.sa_mask);
>  	if (!(ka->sa.sa_flags & SA_NODEFER))
> -		sigaddset(&tsk->blocked, sig);
> -	recalc_sigpending();
> -	spin_unlock_irq(&tsk->sighand->siglock);
> +		sigaddset(&blocked, sig);
> +	set_current_blocked(&blocked);
>  
>  	return 0;
>  }


