Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab2EQGhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 02:37:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59545 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757595Ab2EQGhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 02:37:11 -0400
MIME-Version: 1.0
In-Reply-To: <1333651054.3680.11.camel@dimm>
References: <1333651054.3680.11.camel@dimm>
Date: Thu, 17 May 2012 08:37:10 +0200
Message-ID: <CAO6Zf6A22m8+5TcHr+opjJn0-DdDj2qF8xhBvSeDJ426B+kULg@mail.gmail.com>
Subject: Re: [PATCH] mips: fix endless loop when processing signals for kernel tasks
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So did I overlook something that makes it a non-issue on the recent mips?

On 5 April 2012 20:37, dimm <dmitry.adamushko@gmail.com> wrote:
> From: Dmitry Adamushko <dmitry.adamushka_ext@softathome.com>
>
> The problem occurs [1] when a kernel-mode task returns from a system
> call with a pending signal.
>
> A real-life scenario is a child of 'khelper' returning from a failed
> kernel_execve() in ____call_usermodehelper() [ kernel/kmod.c ].
> kernel_execve() fails due to a pending SIGKILL, which is the result of
> "kill -9 -1" (at least, busybox's init does it upon reboot).
>
> The loop is as follows:
>
> * syscall_exit_work:
>  - work_pending:            // start_of_the_loop
>  - work_notifysig:
>   - do_notify_resume()
>     - do_signal()
>       - if (!user_mode(regs)) return;
>  - resume_userspace         // TIF_SIGPENDING is still set
>  - work_pending             // so we call work_pending => goto
>                            // start_of_the_loop
>
> More information can be found in another LKML thread:
> http://www.serverphorums.com/read.php?12,457826
>
> [1] The problem was also reproduced on !CONFIG_VM86 x86, and the
> following fix was accepted.
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=29a2e2836ff9ea65a603c89df217f4198973a74f
>
> Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: linux-mips@linux-mips.org
>
> --- arch/mips/kernel/entry.S.old        2012-04-05 10:57:12.500976124 +0200
> +++ arch/mips/kernel/entry.S    2012-04-05 11:21:24.128174358 +0200
> @@ -36,6 +36,11 @@ FEXPORT(ret_from_exception)
>  FEXPORT(ret_from_irq)
>        LONG_S  s0, TI_REGS($28)
>  FEXPORT(__ret_from_irq)
> +/*
> + * We can be coming here from a syscall done in the kernel space,
> + * e.g. a failed kernel_execve().
> + */
> +resume_userspace_check:
>        LONG_L  t0, PT_STATUS(sp)               # returning to kernel mode?
>        andi    t0, t0, KU_USER
>        beqz    t0, resume_kernel
> @@ -162,7 +167,7 @@ work_notifysig:                             # deal with pending s
>        move    a0, sp
>        li      a1, 0
>        jal     do_notify_resume        # a2 already loaded
> -       j       resume_userspace
> +       j       resume_userspace_check
>
>  FEXPORT(syscall_exit_work_partial)
>        SAVE_STATIC
>
>



-- 

-- Dmitry
