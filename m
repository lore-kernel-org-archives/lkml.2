Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1HRUTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 16:19:24 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:60733 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752277Ab1HRUTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 16:19:23 -0400
Date: Thu, 18 Aug 2011 21:19:11 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <david.daney@cavium.com>
Cc: Yong Zhang <yong.zhang@windriver.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: use 32-bit wrapper for compat_sys_futex
Message-ID: <20110818201911.GF22920@linux-mips.org>
References: <1313546094-11882-1-git-send-email-yong.zhang@windriver.com>
 <4E4BF7C0.80703@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4BF7C0.80703@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 10:17:52AM -0700, David Daney wrote:

> >diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
> >index 46c4763..f48b18e 100644
> >--- a/arch/mips/kernel/scall64-o32.S
> >+++ b/arch/mips/kernel/scall64-o32.S
> >@@ -441,7 +441,7 @@ sys_call_table:
> >  	PTR	sys_fremovexattr		/* 4235 */
> >  	PTR	sys_tkill
> >  	PTR	sys_sendfile64
> >-	PTR	compat_sys_futex
> >+	PTR	sys_32_futex
> 
> This change is redundant, scall64-o32.S already does the right thing
> so additional zero extending is not needed and is just extra
> instructions to execute for no reason.

Compat_sys_futex is a syscall entry point and for some configurations
such as CONFIG_FTRACE_SYSCALLS SYSCALL_DEFINE*() will do additional work
beyond cleaning up the arguments.  The 3 unnecessary shifts are the
overhead we just gotta live with.

> >  	PTR	compat_sys_sched_setaffinity
> >  	PTR	compat_sys_sched_getaffinity	/* 4240 */
> >  	PTR	compat_sys_io_setup
> 
> But really I think this patch fixes things at the wrong level.  Each
> architecture potentially needs a similar patch.  What would happen if
> we did something like:

> +++ b/kernel/futex_compat.c
> @@ -180,9 +180,9 @@ err_unlock:
>  	return ret;
>  }
> 
> -asmlinkage long compat_sys_futex(u32 __user *uaddr, int op, u32 val,
> -		struct compat_timespec __user *utime, u32 __user *uaddr2,
> -		u32 val3)
> +SYSCALL_DEFINE6(compat_sys_futex, u32 __user *, uaddr, int , op, u32, val,
> +		struct compat_timespec __user *, utime, u32 __user *, uaddr2,
> +		u32, val3)
>  {
>  	struct timespec ts;
>  	ktime_t t, *tp = NULL;
> 
> Obviously the function name is wrong, but a varient of
> SYSCALL_DEFINE*() could be created so the proper function names are
> produced.

Right now none of the the generic compat_ functions is wrapped in
SYSCALL_DEFINE* because for some architectures a further wrapper function
is needed.  It seems some architectures call compat_ calls directly
without SYSCALL_DEFINE* which with CONFIG_FTRACE_SYSCALLS is a bug ...

  Ralf
