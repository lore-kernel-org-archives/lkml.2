Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab1HQUlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:41:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58333 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab1HQUjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:39:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: Re: [patch 05/36] Hexagon: Add syscalls
Date: Wed, 17 Aug 2011 21:29:52 +0200
Message-ID: <2591841.h2qSc9nry5@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110817163520.334269161@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org> <20110817163520.334269161@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:GvuijJykXHt51dcRik17QVQPDCFQTu1yrc/q1AzJvro
 T4ZlDBWmVLqx+BxUo5UjfAi4OGaTRXsCVHrJYuH9MbWwhZkvci
 aAToqsDY7X9y6zkhahEcC9KTFbVCUfpYZzXThLAoCwFgp7nNj4
 qEdio8FoEpgMwaBfKcyjPHY4xurlPwhKdB1Wcd7csdTtYFAaTN
 n9MCczKGF8zX52EwzYySw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011 11:35:02 Richard Kuo wrote:

> +#if !defined(_ASM_HEXAGON_UNISTD_H) || defined(__SYSCALL)
> +#define _ASM_HEXAGON_UNISTD_H
> +
> +/*
> + *  The kernel pulls this unistd.h in three different ways:
> + *  1.  the "normal" way which gets all the __NR defines
> + *  2.  with __SYSCALL defined to produce function declarations
> + *  3.  with __SYSCALL defined to produce syscall table initialization
> + *  See also:  syscalltab.c
> + */
> +
> +#define __ARCH_WANT_SYSCALL_DEPRECATED
> +
> +#ifndef __GLIBC__
> +/* It seems these are all needed for uClibc...
> + * However, if glibc is compiled w/ these turned on, then it will
> + * will fail (typically with 32/64-bit compat problems). */
> +#define __ARCH_WANT_SYSCALL_OFF_T
> +#define __ARCH_WANT_SYSCALL_NO_AT
> +#define __ARCH_WANT_SYSCALL_NO_FLAGS
> +#endif

These all need to die if you want to get the code merged. uClibc is
a problem for everyone wanting to get a new architecture merged,
so I suggest you talk to the unicore32, openrisc and c64x developers
that are all facing the same problem.

One of you just has to fix uClibc to make it work for everyone.

> +/*  And the kernel itself wants these...  */
> +#define __ARCH_WANT_SYS_NICE
> +#define __ARCH_WANT_SYS_SIGPENDING

Can you elaborate? Where does the kernel want these? Can't you fix the
callers to use the more modern version?

> +/*
> + * System calls with architecture-specific wrappers.
> + * See signal.c for signal-related system call wrappers.
> + */
> +
> +asmlinkage int sys_fork(void)
> +{
> +	struct pt_regs *pregs = current_thread_info()->regs;
> +
> +	return do_fork(SIGCHLD, pregs->SP, pregs, 0, NULL, NULL);
> +}
> +
> +asmlinkage int sys_vfork(void)
> +{
> +	struct pt_regs *pregs = current_thread_info()->regs;
> +
> +	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD,
> +		       pregs->SP, pregs, 0, NULL, NULL);
> +}

These should all be handled by sys_clone.

> +/*
> + * Many archictures support both sys_mmap and sys_mmap2, which use
> + * a common do_mmap2 function to do the work.  So long as we support
> + * only mmap2, we do it all in-line here.
> + */
> +asmlinkage int sys_mmap2(unsigned long addr, size_t len, unsigned long prot,
> +			 unsigned long flags, unsigned long fd,
> +			 unsigned long pgoff)
> +{

Just use sys_mmap_pgoff instead of providing your own.

> +EXPORT_SYMBOL(kernel_execve);

Why the export?

> Index: linux-hexagon-kernel/arch/hexagon/kernel/syscalltab.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-hexagon-kernel/arch/hexagon/kernel/syscalltab.c	2011-07-20 15:19:36.655153568 -0500

The generic name for this is now sys_call_table.c, so just use that.
Or even better, submit a patch to add this to kernel/sys_call_table.c
and change score, unicore32, tile and openrisc over to use the same.

	Arnd
