Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab2GMOcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 10:32:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46942 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743Ab2GMOcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 10:32:51 -0400
MIME-Version: 1.0
In-Reply-To: <1342156672-7369-1-git-send-email-wad@chromium.org>
References: <1342156672-7369-1-git-send-email-wad@chromium.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 13 Jul 2012 07:32:26 -0700
X-Google-Sender-Auth: 5dfqUiW0R3Bpcdx552hotbKVFpI
Message-ID: <CAObL_7ERh3inaYCoa56uFS3g74iBOWhdzwYqNESVok-gkraT+w@mail.gmail.com>
Subject: Re: [PATCH] x86/vsyscall: allow seccomp filter in vsyscall=emulate
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        qmewlo@gmail.com, eparis@redhat.com, keescook@chromium.org,
        james.l.morris@oracle.com, hpa@zytor.com, cevans@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 10:17 PM, Will Drewry <wad@chromium.org> wrote:
> If a seccomp filter program is installed, older static binaries and
> distributions with older libc implementations (glibc 2.13 and earlier)
> that rely on vsyscall use will be terminated regardless of the filter
> program policy when executing time, gettimeofday, or getcpu.  This is
> only the case when vsyscall emulation is in use (vsyscall=emulate is the
> default).
>
> This patch emulates system call entry inside a vsyscall=emulate trap
> such that seccomp can properly evaluate the system call.
>
> Reported-by: Owen Kibel <qmewlo@gmail.com>
> Signed-off-by: Will Drewry <wad@chromium.org>
> ---
>  arch/x86/kernel/vsyscall_64.c |   29 ++++++++++++++++++++++++++---
>  1 file changed, 26 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
> index 7515cf0..433545f 100644
> --- a/arch/x86/kernel/vsyscall_64.c
> +++ b/arch/x86/kernel/vsyscall_64.c
> @@ -139,6 +139,14 @@ static int addr_to_vsyscall_nr(unsigned long addr)
>         return nr;
>  }
>
> +static int vsyscall_seccomp(struct task_struct *tsk, int syscall_nr)
> +{
> +       if (!seccomp_mode(&tsk->seccomp))
> +               return 0;
> +       task_pt_regs(tsk)->orig_ax = syscall_nr;
> +       return __secure_computing(syscall_nr);
> +}
> +
>  static bool write_ok_or_segv(unsigned long ptr, size_t size)
>  {
>         /*
> @@ -174,6 +182,7 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
>         int vsyscall_nr;
>         int prev_sig_on_uaccess_error;
>         long ret;
> +       int skip;
>
>         /*
>          * No point in checking CS -- the only way to get here is a user mode
> @@ -205,9 +214,6 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
>         }
>
>         tsk = current;
> -       if (seccomp_mode(&tsk->seccomp))
> -               do_exit(SIGKILL);
> -
>         /*
>          * With a real vsyscall, page faults cause SIGSEGV.  We want to
>          * preserve that behavior to make writing exploits harder.
> @@ -222,8 +228,13 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
>          * address 0".
>          */
>         ret = -EFAULT;
> +       skip = 0;
>         switch (vsyscall_nr) {
>         case 0:
> +               skip = vsyscall_seccomp(tsk, __NR_gettimeofday);
> +               if (skip)
> +                       break;
> +
>                 if (!write_ok_or_segv(regs->di, sizeof(struct timeval)) ||
>                     !write_ok_or_segv(regs->si, sizeof(struct timezone)))
>                         break;
> @@ -234,6 +245,10 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
>                 break;
>
>         case 1:
> +               skip = vsyscall_seccomp(tsk, __NR_time);
> +               if (skip)
> +                       break;
> +
>                 if (!write_ok_or_segv(regs->di, sizeof(time_t)))
>                         break;
>
> @@ -241,6 +256,10 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
>                 break;
>
>         case 2:
> +               skip = vsyscall_seccomp(tsk, __NR_getcpu);
> +               if (skip)
> +                       break;
> +
>                 if (!write_ok_or_segv(regs->di, sizeof(unsigned)) ||
>                     !write_ok_or_segv(regs->si, sizeof(unsigned)))
>                         break;
> @@ -253,6 +272,9 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
>
>         current_thread_info()->sig_on_uaccess_error = prev_sig_on_uaccess_error;
>
> +       if (skip)
> +               goto do_ret;
> +
>         if (ret == -EFAULT) {
>                 /* Bad news -- userspace fed a bad pointer to a vsyscall. */
>                 warn_bad_vsyscall(KERN_INFO, regs,
> @@ -271,6 +293,7 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
>
>         regs->ax = ret;
>
> +do_ret:
>         /* Emulate a ret instruction. */
>         regs->ip = caller;
>         regs->sp += 8;

Does this work correctly in SECCOMP_RET_TRAP, TRACE, or ERRNO mode?
errno looks okay, but trap and trace still emulate the ret
instruction, which looks like it could confuse debuggers.  (If, on the
other hand, no change is made to the registers, then the debugger will
see a syscall instruction at rip, albeit one that can't actually be
executed due to the nx bit.)

--Andy
