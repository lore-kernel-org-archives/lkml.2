Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1LVR6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:58:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab1LVR6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:58:36 -0500
Date: Thu, 22 Dec 2011 18:52:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] signal: Add block_sigmask() for adding sigmask to
	current->blocked
Message-ID: <20111222175244.GB4895@redhat.com>
References: <1324493221-4435-1-git-send-email-matt@console-pimps.org> <1324493221-4435-3-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324493221-4435-3-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Matt Fleming wrote:
>
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

Signed-off-by: Oleg Nesterov <oleg@redhat.com>


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
> index b3f78d0..22b6667 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2322,6 +2322,27 @@ relock:
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
> --
> 1.7.4.4
>

