Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab1HVKTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:19:44 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:49832 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461Ab1HVKTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:19:37 -0400
Subject: Re: [PATCH 01/43] signal: Add block_sigmask() for adding sigmask
 to current->blocked
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-arch@vger.kernel.org
In-Reply-To: <1313772419-21951-2-git-send-email-matt@console-pimps.org>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
	 <1313772419-21951-2-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Aug 2011 11:19:22 +0100
Message-ID: <1314008362.19751.22.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding linux-arch to Cc so arch maintainers will hopefully see this)

On Fri, 2011-08-19 at 17:46 +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> This patch abstracts the code sequence for adding a signal handler's
> sa_mask to current->blocked because the sequence is identical for all
> architectures. Furthermore, in the past some architectures actually
> got this code wrong, so introduce a wrapper that all architectures can
> use.
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/x86/kernel/signal.c |    6 +-----
>  include/linux/signal.h   |    1 +
>  kernel/signal.c          |   21 +++++++++++++++++++++
>  3 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index 54ddaeb2..46a01bd 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -682,7 +682,6 @@ static int
>  handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
>  		struct pt_regs *regs)
>  {
> -	sigset_t blocked;
>  	int ret;
>  
>  	/* Are we from a system call? */
> @@ -733,10 +732,7 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
>  	 */
>  	regs->flags &= ~X86_EFLAGS_TF;
>  
> -	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
> -	if (!(ka->sa.sa_flags & SA_NODEFER))
> -		sigaddset(&blocked, sig);
> -	set_current_blocked(&blocked);
> +	block_sigmask(ka, sig);
>  
>  	tracehook_signal_handler(sig, info, ka, regs,
>  				 test_thread_flag(TIF_SINGLESTEP));
> diff --git a/include/linux/signal.h b/include/linux/signal.h
> index a822300..7987ce74 100644
> --- a/include/linux/signal.h
> +++ b/include/linux/signal.h
> @@ -254,6 +254,7 @@ extern void set_current_blocked(const sigset_t *);
>  extern int show_unhandled_signals;
>  
>  extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
> +extern void block_sigmask(struct k_sigaction *ka, int signr);
>  extern void exit_signals(struct task_struct *tsk);
>  
>  extern struct kmem_cache *sighand_cachep;
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 291c970..7a08164 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2314,6 +2314,27 @@ relock:
>  	return signr;
>  }
>  
> +/**
> + * block_sigmask - add @ka's signal mask to current->blocked
> + * @ka: action for @signr
> + * @signr: signal that has been successfully delivered
> + *
> + * This function should be called when a signal has succesfully been
> + * delivered. It adds the mask of signals for @ka to current->blocked
> + * so that they are blocked during the execution of the signal
> + * handler. In addition, @signr will be blocked unless %SA_NODEFER is
> + * set in @ka->sa.sa_flags.
> + */
> +void block_sigmask(struct k_sigaction *ka, int signr)
> +{
> +	sigset_t blocked;
> +
> +	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
> +	if (!(ka->sa.sa_flags & SA_NODEFER))
> +		sigaddset(&blocked, signr);
> +	set_current_blocked(&blocked);
> +}
> +
>  /*
>   * It could be that complete_signal() picked us to notify about the
>   * group-wide signal. Other threads should be notified now to take



