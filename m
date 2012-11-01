Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760328Ab2KAUeC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:34:02 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35194 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923Ab2KAUeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:34:00 -0400
Date: Thu, 1 Nov 2012 20:33:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Will Drewry <wad@chromium.org>, Geremy Condra <gcondra@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 2/4] arch/arm: move secure_computing into trace
Message-ID: <20121101203338.GU21164@n2100.arm.linux.org.uk>
References: <1351799199-6853-1-git-send-email-keescook@chromium.org> <1351799199-6853-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351799199-6853-3-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 12:46:37PM -0700, Kees Cook wrote:
>  #ifdef CONFIG_SECCOMP
> -	tst	r10, #_TIF_SECCOMP
> -	beq	1f
> -	mov	r0, scno
> -	bl	__secure_computing	
> -	add	r0, sp, #S_R0 + S_OFF		@ pointer to regs
> -	ldmia	r0, {r0 - r3}			@ have to reload r0 - r3
> -1:
> +	tst	r10, #_TIF_SECCOMP		@ is seccomp enabled?
> +	bne	__sys_trace
>  #endif
>  
>  	tst	r10, #_TIF_SYSCALL_WORK		@ are we tracing syscalls?

It's pointless having:

	tst	r10, #_TIF_SECCOMP
	bne	__sys_trace
	tst	r10, #_TIF_SYSCALL_WORK
	bne	__sys_trace

Instead, make TIF_SECCOMP be bit 11, combine it into _TIF_SYSCALL_WORK, and
eliminate all of that CONFIG_SECCOMP block.

> diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
> index 739db3a..6b0e14b 100644
> --- a/arch/arm/kernel/ptrace.c
> +++ b/arch/arm/kernel/ptrace.c
> @@ -916,13 +916,15 @@ enum ptrace_syscall_dir {
>  	PTRACE_SYSCALL_EXIT,
>  };
>  
> -static int ptrace_syscall_trace(struct pt_regs *regs, int scno,
> -				enum ptrace_syscall_dir dir)
> +asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
>  {
>  	unsigned long ip;
>  
>  	current_thread_info()->syscall = scno;
>  
> +	if (secure_computing(scno) == -1)
> +		return -1;
> +
>  	if (!test_thread_flag(TIF_SYSCALL_TRACE))
>  		return scno;

I'm not sure this change is correct (combined with your hunk below).
What if we have auditing enabled but trace disabled?  How do we reach
audit_syscall_entry()?  Or the tracehook stuff?

This patch looks wrong in too many ways.

> @@ -931,20 +933,13 @@ static int ptrace_syscall_trace(struct pt_regs *regs, int scno,
>  	 * IP = 0 -> entry, =1 -> exit
>  	 */
>  	ip = regs->ARM_ip;
> -	regs->ARM_ip = dir;
> -
> -	if (dir == PTRACE_SYSCALL_EXIT)
> -		tracehook_report_syscall_exit(regs, 0);
> -	else if (tracehook_report_syscall_entry(regs))
> +	regs->ARM_ip = PTRACE_SYSCALL_ENTER;
> +	if (tracehook_report_syscall_entry(regs))
>  		current_thread_info()->syscall = -1;
> -
>  	regs->ARM_ip = ip;
> -	return current_thread_info()->syscall;
> -}
>  
> -asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
> -{
> -	scno = ptrace_syscall_trace(regs, scno, PTRACE_SYSCALL_ENTER);
> +	scno = current_thread_info()->syscall;
> +
>  	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
>  		trace_sys_enter(regs, scno);
>  	audit_syscall_entry(AUDIT_ARCH_ARM, scno, regs->ARM_r0, regs->ARM_r1,
> @@ -954,7 +949,23 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
>  
>  asmlinkage int syscall_trace_exit(struct pt_regs *regs, int scno)
>  {
> -	scno = ptrace_syscall_trace(regs, scno, PTRACE_SYSCALL_EXIT);
> +	unsigned long ip;
> +
> +	current_thread_info()->syscall = scno;
> +
> +	if (!test_thread_flag(TIF_SYSCALL_TRACE))
> +		return scno;
> +
> +	/*
> +	 * IP is used to denote syscall entry/exit:
> +	 * IP = 0 -> entry, =1 -> exit
> +	 */
> +	ip = regs->ARM_ip;
> +	regs->ARM_ip = PTRACE_SYSCALL_EXIT;
> +	tracehook_report_syscall_exit(regs, 0);
> +	regs->ARM_ip = ip;
> +
> +	scno = current_thread_info()->syscall;
>  	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
>  		trace_sys_exit(regs, scno);
>  	audit_syscall_exit(regs);
> -- 
> 1.7.9.5
> 
