Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab1HVCPN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 22:15:13 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:60185 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab1HVCPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 22:15:09 -0400
Subject: Re: [PATCH v2 35/43] unicore32: Use set_current_blocked() and
 block_sigmask()
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Matt Fleming <matt@console-pimps.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <1313772419-21951-36-git-send-email-matt@console-pimps.org>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
	 <1313772419-21951-36-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Mon, 22 Aug 2011 10:15:46 +0800
Message-ID: <1313979346.2905.27.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Matt
Could you add me (and other relevant people) to the patch series, or at
least the main patches in the series, since the separated patch is hard
to understand, and can't be tested.

For signal patches, I can only test it by booting up the system, running
some commands, and perhaps, running lmbench or ltp.
Is there any testsuite specified to signal part?


Cc: Arnd Bergmann <arnd@arndb.de>

Thanks Matt.
Guan Xuetao

On Fri, 2011-08-19 at 17:46 +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> As described in e6fa16ab ("signal: sigprocmask() should do
> retarget_shared_pending()") the modification of current->blocked is
> incorrect as we need to check whether the signal we're about to block
> is pending in the shared queue.
> 
> Also, use the new helper function block_sigmask() which centralises
> the code for updating current->blocked after successfully delivering a
> signal and reduces the amount of duplicate code across
> architectures. In the past some architectures got this code wrong, so
> using this helper function should stop that from happening again.
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
> 
> v2 of this patch depends on "[PATCH 01/43] signal: Add block_sigmask()
> for adding sigmask to current->blocked" so they need to go through the
> same tree but this patch would benefit from some maintainer ACK's.
> 
> Guan, I dropped your Acked-by because I felt this patch changed quite
> dramatically since v1 and warrants another review. I hope that's OK.
> 
>  arch/unicore32/kernel/signal.c |   13 ++-----------
>  1 files changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/unicore32/kernel/signal.c b/arch/unicore32/kernel/signal.c
> index b163fca..960c029 100644
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
> @@ -372,13 +369,7 @@ static int handle_signal(unsigned long sig, struct k_sigaction *ka,
>  	/*
>  	 * Block the signal if we were successful.
>  	 */
> -	spin_lock_irq(&tsk->sighand->siglock);
> -	sigorsets(&tsk->blocked, &tsk->blocked,
> -		  &ka->sa.sa_mask);
> -	if (!(ka->sa.sa_flags & SA_NODEFER))
> -		sigaddset(&tsk->blocked, sig);
> -	recalc_sigpending();
> -	spin_unlock_irq(&tsk->sighand->siglock);
> +	block_sigmask(ka, sig);
>  
>  	return 0;
>  }


