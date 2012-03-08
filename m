Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab2CHPyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 10:54:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757258Ab2CHPyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 10:54:03 -0500
Date: Thu, 8 Mar 2012 16:46:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Dmitry ADAMUSHKA (EXT)" <dmitry.adamushka_ext@softathome.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ralf Baechle <ralf@linux-mips.org>,
        wouter cloetens <wouter.cloetens@softathome.com>,
        linux-kernel@vger.kernel.org,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: 'khelper' (child) is stuck in endless loop: do_signal() and
	!user_mode(regs)
Message-ID: <20120308154641.GA10380@redhat.com>
References: <139779962.60750.1331202718116.JavaMail.root@storentr1.softathome.com> <1331646690.60780.1331203030720.JavaMail.root@storentr1.softathome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331646690.60780.1331203030720.JavaMail.root@storentr1.softathome.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

I think you are right, but I am not expert. Add Peter.

On 03/08, Dmitry ADAMUSHKA (EXT) wrote:
>
> Oleg,
>
> I'm able to reproduce this problem on x86 (32 bits)

And I guess "32 bits" is important.
arch/x86/kernel/sys_i386_32.c:kernel_execve() does "int 0x80".

If do_execve() fails before start_thread() and TIF_SIGPENDING
is set, entry_32.S calls do_notify_resume() and we lost.

I guess this is what you meant from the very beginning ;)

> It happens only when CONFIG_VM86 is disabled (I tried both). Supposedly,
> due to the following bits of the VM86-specific code that let us break out
> of the endless-loop.
>
> #ifdef CONFIG_VM86
> #define resume_userspace_sig    check_userspace
> #else
> [...]
>
> there is the specific are-we-a-kernel-task? check here
>
> check_userspace:
>         movl PT_EFLAGS(%esp), %eax      # mix EFLAGS and C
>         movb PT_CS(%esp), %al
>         andl $(X86_EFLAGS_VM | SEGMENT_RPL_MASK), %eax
>         cmpl $USER_RPL, %eax
>         jb resume_kernel                # not returning to v8086 or userspace

Agreed, we need the USER_RPL check.

> So here are the patches to simulate the problem. Is this approach not
> valid for one or another reason?
>
> Thanks in advance.
>
>
> === copy-pasted ===
>
> --- kernel/kmod.c.orig  2012-03-08 10:26:05.504752023 +0100
> +++ kernel/kmod.c       2012-03-08 11:25:05.028661835 +0100
> @@ -154,6 +154,15 @@ static int ____call_usermodehelper(void
>         /* We can run anywhere, unlike our parent keventd(). */
>         set_cpus_allowed_ptr(current, cpu_all_mask);
>
> +       printk(KERN_EMERG "Unleash the signal...\n");
> +
> +       /*
> +        * (1) here we emulate receiving a signal.
> +        *     In the original case, a signal should be delivered from outside,
> +        *     say, by "kill(-1, SIGKILL)" in busybox.
> +        */
> +       send_sig(SIGUSR1, current, 0);

Yes, this kills the task, kernel_execve() can't succeed,

>         /*
>          * Our parent is keventd, which runs with elevated scheduling priority.
>          * Avoid propagating that into the userspace child.
> @@ -181,6 +190,19 @@ static int ____call_usermodehelper(void
>
>         commit_creds(new);
>
> +       /* (2) here we emulate the failure of kernel_execve().
> +        *     In real life, the failure can be due to a memory shortage,
> +        *     or something else.
> +         *     In our case, it happens when a board reboots - same as (1) above.
> +        */
> +       retval = kernel_execve(NULL,
> +                              (const char *const *)sub_info->argv,
> +                              (const char *const *)sub_info->envp);

and I guess it can't even return.

> +       printk(KERN_EMERG "x86 is rock-solid!");
> +       flush_signals(current);
> +
> +       /* If we survived the test, let's continue so the user should not notice. */
>         retval = kernel_execve(sub_info->path,
>                                (const char *const *)sub_info->argv,
>                                (const char *const *)sub_info->envp);
>
> and another one
>
> --- arch/x86/kernel/signal.c.orig       2012-03-08 11:18:19.702651943 +0100
> +++ arch/x86/kernel/signal.c    2012-03-08 10:31:18.682304346 +0100
> @@ -765,8 +765,11 @@ static void do_signal(struct pt_regs *re
>          * X86_32: vm86 regs switched out by assembly code before reaching
>          * here, so testing against kernel CS suffices.
>          */
> -       if (!user_mode(regs))
> +       if (!user_mode(regs)) {
> +               printk(KERN_EMERG "* endless loop\n");
> +               dump_stack();
>                 return;
> +       }

so yes, it enters the endless loop.

I do not know what should be fixed, kernel_execve() or system_call paths.

Oleg.

