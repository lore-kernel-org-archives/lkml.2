Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2GMXA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 19:00:27 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46811 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab2GMXAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 19:00:25 -0400
MIME-Version: 1.0
In-Reply-To: <1342199195-2078-1-git-send-email-wad@chromium.org>
References: <1342156672-7369-1-git-send-email-wad@chromium.org> <1342199195-2078-1-git-send-email-wad@chromium.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 13 Jul 2012 16:00:04 -0700
X-Google-Sender-Auth: wm87z_q5w_FVnx6j6RmhGIUfAJI
Message-ID: <CAObL_7GaPDNops_cL2u4yU9Afj14f6ju_ZW7qRjhSy25qsbfkw@mail.gmail.com>
Subject: Re: [PATCH v2] x86/vsyscall: allow seccomp filter in vsyscall=emulate
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        qmewlo@gmail.com, eparis@redhat.com, keescook@chromium.org,
        james.l.morris@oracle.com, hpa@zytor.com, cevans@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 10:06 AM, Will Drewry <wad@chromium.org> wrote:
> If a seccomp filter program is installed, older static binaries and
> distributions with older libc implementations (glibc 2.13 and earlier)
> that rely on vsyscall use will be terminated regardless of the filter
> program policy when executing time, gettimeofday, or getcpu.  This is
> only the case when vsyscall emulation is in use (vsyscall=emulate is the
> default).
>
> This patch emulates system call entry inside a vsyscall=emulate by
> populating regs->ax and regs->orig_ax with the system call number prior
> to calling into seccomp such that all seccomp-dependencies function
> normally.  Additionally, system call return behavior is emulated in line
> with other vsyscall entrypoints for the trace/trap cases.
>
> Reported-by: Owen Kibel <qmewlo@gmail.com>
> Signed-off-by: Will Drewry <wad@chromium.org>
>
> v2: - fixed ip and sp on SECCOMP_RET_TRAP/TRACE (thanks to luto@mit.edu)

> @@ -253,6 +273,12 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
>
>         current_thread_info()->sig_on_uaccess_error = prev_sig_on_uaccess_error;
>
> +       if (skip) {
> +               if ((long)regs->ax <= 0L) /* seccomp errno emulation */
> +                       goto do_ret;
> +               goto done; /* seccomp trace/trap */
> +       }
> +
>         if (ret == -EFAULT) {
>                 /* Bad news -- userspace fed a bad pointer to a vsyscall. */
>                 warn_bad_vsyscall(KERN_INFO, regs,
> @@ -271,10 +297,11 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
>
>         regs->ax = ret;
>
> +do_ret:
>         /* Emulate a ret instruction. */
>         regs->ip = caller;
>         regs->sp += 8;
> -
> +done:
>         return true;
>
>  sigsegv:
> --
> 1.7.9.5
>

This has the same odd property as the sigsegv path that the faulting
instruction will appear to be the mov, not the syscall.  That seems to
be okay, though -- various pieces of code that try to restart the segv
are okay with that.

Is there any code that assumes that changing rax (i.e. the syscall
number) and restarting a syscall after SIGSYS will invoke the new
syscall?  (The RET_TRACE path might be similar -- does the
ptrace_event(PTRACE_EVENT_SECCOMP, data) in seccomp.c give a debugger
a chance to synchronously cancel or change the syscall?

If those issues aren't problems, then:

Reviewed-by: Andy Lutomirski <luto@amacapital.net>

(If the syscall number needs to change after the fact in the
SECCOMP_RET_TRAP case, it'll be a mess.)

--Andy
