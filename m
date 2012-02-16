Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab2BPJ3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:29:05 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48173 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab2BPJ2z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:28:55 -0500
MIME-Version: 1.0
In-Reply-To: <1329219673-28711-7-git-send-email-matt@console-pimps.org>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
	<1329219673-28711-7-git-send-email-matt@console-pimps.org>
Date: Thu, 16 Feb 2012 17:28:54 +0800
Message-ID: <CAA_GA1efV+DMrvKF2N5TMQ_1XaGyJM7h4jMUaaFka5XqBNDb7g@mail.gmail.com>
Subject: Re: [PATCH 06/40] blackfin: Use set_current_blocked() and block_sigmask()
From: Bob Liu <lliubbo@gmail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-arch@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 7:40 PM, Matt Fleming <matt@console-pimps.org> wrote:
> From: Matt Fleming <matt.fleming@intel.com>
>
> As described in e6fa16ab ("signal: sigprocmask() should do
> retarget_shared_pending()") the modification of current->blocked is
> incorrect as we need to check whether the signal we're about to block
> is pending in the shared queue.
>
> Also, use the new helper function introduced in commit 5e6292c0f28f
> ("signal: add block_sigmask() for adding sigmask to current->blocked")
> which centralises the code for updating current->blocked after
> successfully delivering a signal and reduces the amount of duplicate
> code across architectures. In the past some architectures got this
> code wrong, so using this helper function should stop that from
> happening again.
>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Acked-by: Mike Frysinger <vapier@gentoo.org>
> Cc: uclinux-dist-devel@blackfin.uclinux.org
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/blackfin/kernel/signal.c |   17 ++++-------------
>  1 files changed, 4 insertions(+), 13 deletions(-)
>
> diff --git a/arch/blackfin/kernel/signal.c b/arch/blackfin/kernel/signal.c
> index d536f35..05ece02 100644
> --- a/arch/blackfin/kernel/signal.c
> +++ b/arch/blackfin/kernel/signal.c
> @@ -99,10 +99,7 @@ asmlinkage int do_rt_sigreturn(unsigned long __unused)
>                goto badframe;
>
>        sigdelsetmask(&set, ~_BLOCKABLE);
> -       spin_lock_irq(&current->sighand->siglock);
> -       current->blocked = set;
> -       recalc_sigpending();
> -       spin_unlock_irq(&current->sighand->siglock);
> +       set_current_blocked(&set);
>
>        if (rt_restore_sigcontext(regs, &frame->uc.uc_mcontext, &r0))
>                goto badframe;
> @@ -266,15 +263,9 @@ handle_signal(int sig, siginfo_t *info, struct k_sigaction *ka,
>        /* set up the stack frame */
>        ret = setup_rt_frame(sig, ka, info, oldset, regs);
>
> -       if (ret == 0) {
> -               spin_lock_irq(&current->sighand->siglock);
> -               sigorsets(&current->blocked, &current->blocked,
> -                         &ka->sa.sa_mask);
> -               if (!(ka->sa.sa_flags & SA_NODEFER))
> -                       sigaddset(&current->blocked, sig);
> -               recalc_sigpending();
> -               spin_unlock_irq(&current->sighand->siglock);
> -       }
> +       if (ret == 0)
> +               block_sigmask(ka, sig);
> +
>        return ret;
>  }
>

Thanks. I'll apply it.

-- 
Regards,
--Bob
