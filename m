Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab2CHQgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 11:36:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758064Ab2CHQgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 11:36:42 -0500
Date: Thu, 8 Mar 2012 17:29:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Dmitry ADAMUSHKA (EXT)" <dmitry.adamushka_ext@softathome.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ralf Baechle <ralf@linux-mips.org>,
        wouter cloetens <wouter.cloetens@softathome.com>,
        linux-kernel@vger.kernel.org,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: 'khelper' (child) is stuck in endless loop: do_signal() and
	!user_mode(regs)
Message-ID: <20120308162913.GA12554@redhat.com>
References: <CAO6Zf6C+SDZ-TV12wr9oiO6HB-itQ6fLPHFugXk0osEiAxW22w@mail.gmail.com> <1587824623.61690.1331219566458.JavaMail.root@storentr1.softathome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587824623.61690.1331219566458.JavaMail.root@storentr1.softathome.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Dmitry ADAMUSHKA (EXT) wrote:
>
> The following quick hack "fixes" it for x86.

First of all let me repeat, I do not understand this asm ;)
Fortunately Ingo and Peter do.

But,

> --- arch/x86/kernel/entry_32.S.orig     2012-03-08 15:42:25.041296595 +0100
> +++ arch/x86/kernel/entry_32.S  2012-03-08 15:58:29.926081131 +0100
> @@ -98,12 +98,6 @@
>  #endif
>  .endm
>
> -#ifdef CONFIG_VM86
> -#define resume_userspace_sig   check_userspace
> -#else
> -#define resume_userspace_sig   resume_userspace
> -#endif
> -
>  /*
>   * User gs save/restore
>   *
> @@ -327,10 +321,19 @@ ret_from_exception:
>         preempt_stop(CLBR_ANY)
>  ret_from_intr:
>         GET_THREAD_INFO(%ebp)
> -check_userspace:
> +resume_userspace_sig:
> +#ifdef CONFIG_VM86
>         movl PT_EFLAGS(%esp), %eax      # mix EFLAGS and CS
>         movb PT_CS(%esp), %al
>         andl $(X86_EFLAGS_VM | SEGMENT_RPL_MASK), %eax
> +#else
> +/*
> + * We can be coming here from a syscall done in the kernel space,
> + * e.g. a failed kernel_execve().
> + */
> +       movl PT_CS(%esp), %eax
> +       andl $SEGMENT_RPL_MASK, %eax
> +#endif
>         cmpl $USER_RPL, %eax
>         jb resume_kernel                # not returning to v8086 or userspace

IIUC (I can be easily wrong) this breaks the endless loop, but
only after do_notify_resume() was already called.

_perhaps_ it would be better to avoid do_notify_resume() in this
case altogether. Say, fire_user_return_notifiers() doesn't look
right in this case, we are not going to return to the usermode.

Not that I think this is really wrong though.

Oleg.

