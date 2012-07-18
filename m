Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab2GRCNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 22:13:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55049 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab2GRCNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 22:13:13 -0400
MIME-Version: 1.0
In-Reply-To: <912c85ae09ccb083110ae451d4f59260ae65296f.1342566495.git.luto@amacapital.net>
References: <cover.1342566495.git.luto@amacapital.net>
	<912c85ae09ccb083110ae451d4f59260ae65296f.1342566495.git.luto@amacapital.net>
Date: Tue, 17 Jul 2012 21:13:11 -0500
Message-ID: <CABqD9hbKws1FRQBh3ctCCcYd5Jd=J5pW2a+ApFKso5s5ajqqFw@mail.gmail.com>
Subject: Re: [PATCH 3.5 2/2] seccomp: Future-proof against silly tracers
From: Will Drewry <wad@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 6:19 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> Currently, if a tracer changes a syscall nr to __NR_future_enosys,
> behavior will differ between kernels that know about
> __NR_future_enosys (and return -ENOSYS) and older kernels (which
> return the value from pt_regs).  This is silly; we should just
> return -ENOSYS.
>
> This is unlikely to ever happen on x86 because the return value in
> pt_regs starts out as -ENOSYS, but a silly tracer can change that.
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> Cc: Will Drewry <wad@chromium.org>
> ---
>  arch/x86/include/asm/syscall.h |   11 +++++++++++
>  kernel/seccomp.c               |   15 +++++++++++++++
>  2 files changed, 26 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
> index 1ace47b..8191e057 100644
> --- a/arch/x86/include/asm/syscall.h
> +++ b/arch/x86/include/asm/syscall.h

Since this is used in an arch-wide location, the prototype and comment
should be in asm-generic/syscall.h too.

> @@ -70,6 +70,17 @@ static inline void syscall_set_return_value(struct task_struct *task,
>         regs->ax = (long) error ?: val;
>  }
>
> +static inline bool syscall_is_nr_future(struct task_struct *task,
> +                                       struct pt_regs *regs)
> +{
> +#ifdef CONFIG_IA32_EMULATION
> +       if (task_thread_info(task)->status & TS_COMPAT)
> +               return syscall_get_nr(task, regs) > __NR_ia32_syscall_max;
> +#endif
> +
> +       return syscall_get_nr(task, regs) > __NR_syscall_max;

I'm not sure how easy this will be to implement on some of the arches
where this data isn't bubbled up.  It'd be good if some non-x86 arch
maintainers chimed in (since x86 is easy and already works as expected
:).

> +}
> +
>  #ifdef CONFIG_X86_32
>
>  static inline void syscall_get_arguments(struct task_struct *task,
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 5af44b5..bd7527d 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -429,6 +429,21 @@ int __secure_computing(int this_syscall)
>                          */
>                         if (fatal_signal_pending(current))
>                                 break;
> +
> +                       if (syscall_is_nr_future(current, regs)) {
> +                               /*
> +                                * If the tracer selects a system call that
> +                                * only future kernels know about, we still need
> +                                * to execute that syscall by returning
> +                                * -ENOSYS.  (On x86, this only matters if the
> +                                * tracer changed the return value, which would
> +                                * be silly, but user code can be silly.)
> +                                */
> +                               syscall_set_return_value(current, regs,
> +                                                        -ENOSYS, 0);
> +                               goto skip;
> +                       }
> +
>                         if (syscall_get_nr(current, regs) < 0)
>                                 goto skip;  /* Explicit request to skip. */
>
> --
> 1.7.7.6
>

thanks!
will
