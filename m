Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab0FBUIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:08:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933120Ab0FBUIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:08:46 -0400
Date: Wed, 2 Jun 2010 22:07:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Evan Teran <eteran@alum.rit.edu>,
       Jan Kratochvil <jan.kratochvil@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Bug 16061 - single stepping in a signal handler can cause the
	single step flag to get "stuck"
Message-ID: <20100602200720.GA28062@redhat.com>
References: <20100602192318.GA26735@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602192318.GA26735@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry for noise, forgot to mention...

On 06/02, Oleg Nesterov wrote:
>
> However, what I am thinking about is the more "clever" change (it
> passed ptrace-tests).
>
> Do you think it can be correct? I am asking because I never understood
> the TIF_SINGLESTEP/TIF_FORCED_TF interaction. But otoh, shouldn't
> TIF_FORCED_TF + X86_EFLAGS_TF always imply TIF_SINGLESTEP? at least
> in handle_signal().
>
> IOW, help! To me, the patch below is also cleanup. But only if you think
> it can fly ;)

and it is not clear to me if we should keep this code

	/*
	 * Clear TF when entering the signal handler, but
	 * notify any tracer that was single-stepping it.
	 * The tracer may want to single-step inside the
	 * handler too.
	 */
	regs->flags &= ~X86_EFLAGS_TF;

in handle_signal(). If TF was set by us, it was cleared by
user_disable_single_step(). Otherwise, why should we clear it if
the tracer did set_flags(X86_EFLAGS_TF) ?

Oleg.

> --- 34-rc1/arch/x86/kernel/signal.c~BZ16061_MAYBE_FIX	2010-06-02 21:11:07.000000000 +0200
> +++ 34-rc1/arch/x86/kernel/signal.c	2010-06-02 21:11:48.000000000 +0200
> @@ -682,6 +682,7 @@ static int
>  handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
>  	      sigset_t *oldset, struct pt_regs *regs)
>  {
> +	bool stepping;
>  	int ret;
>  
>  	/* Are we from a system call? */
> @@ -706,13 +707,10 @@ handle_signal(unsigned long sig, siginfo
>  		}
>  	}
>  
> -	/*
> -	 * If TF is set due to a debugger (TIF_FORCED_TF), clear the TF
> -	 * flag so that register information in the sigcontext is correct.
> -	 */
> -	if (unlikely(regs->flags & X86_EFLAGS_TF) &&
> -	    likely(test_and_clear_thread_flag(TIF_FORCED_TF)))
> -		regs->flags &= ~X86_EFLAGS_TF;
> +	stepping = test_thread_flag(TIF_SINGLESTEP);
> +	if (stepping)
> +		// do this before setup_sigcontext()
> +		user_disable_single_step(current);
>  
>  	ret = setup_rt_frame(sig, ka, info, oldset, regs);
>  
> @@ -748,8 +746,7 @@ handle_signal(unsigned long sig, siginfo
>  	recalc_sigpending();
>  	spin_unlock_irq(&current->sighand->siglock);
>  
> -	tracehook_signal_handler(sig, info, ka, regs,
> -				 test_thread_flag(TIF_SINGLESTEP));
> +	tracehook_signal_handler(sig, info, ka, regs, stepping);
>  
>  	return 0;
>  }

