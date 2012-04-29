Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab2D2QeA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 12:34:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab2D2Qd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 12:33:58 -0400
Date: Sun, 29 Apr 2012 18:33:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120429163310.GB15792@redhat.com>
References: <20120426183742.GA324@redhat.com> <20120426231942.GJ6871@ZenIV.linux.org.uk> <20120427172444.GA30267@redhat.com> <20120427184528.GL6871@ZenIV.linux.org.uk> <20120427202002.8ED632C0BF@topped-with-meat.com> <20120427211244.GO6871@ZenIV.linux.org.uk> <20120427212729.652542C0AF@topped-with-meat.com> <20120427231526.GP6871@ZenIV.linux.org.uk> <20120428024208.GS6871@ZenIV.linux.org.uk> <20120428033245.GT6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120428033245.GT6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, I didn't notice this email...

On 04/28, Al Viro wrote:
>
> Actually, it looks like on i386 the loop will be broken by checks in
> resume_userspace_sig,

Yes,

> so the worst thing that might happen would be
> a bogus call of tracehook_notify_resume() if it's possible to get there
> with TIF_NOTIFY_RESUME for kernel thread.

Afaics, the kernel should never have TIF_NOTIFY_RESUME. Except (afaics!)
a user-space task with TIF_NOTIFY_RESUME does kernel_thread(), and this
flag is copied by setup_thread_stack(). But this should be forbidden and
we are going to kill daemonize(), probably it already has no callers.

> To be honest, I'd rather check for user_mode() before calling
> do_notify_resume() and go away to no_work_pending if it's true.

Agreed! I tried to suggest this when 29a2e283 was discussed, but my asm
skills are close to zero.

> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -321,7 +321,6 @@ ret_from_exception:
>  	preempt_stop(CLBR_ANY)
>  ret_from_intr:
>  	GET_THREAD_INFO(%ebp)
> -resume_userspace_sig:
>  #ifdef CONFIG_VM86
>  	movl PT_EFLAGS(%esp), %eax	# mix EFLAGS and CS
>  	movb PT_CS(%esp), %al
> @@ -628,9 +627,13 @@ work_notifysig:				# deal with pending signals and
>  					# vm86-space
>  	TRACE_IRQS_ON
>  	ENABLE_INTERRUPTS(CLBR_NONE)
> +	movb PT_CS(%esp), %bl
> +	andl $SEGMENT_RPL_MASK, %ebx
> +	cmpl $USER_RPL, %ebx
> +	jb resume_kernel
>  	xorl %edx, %edx
>  	call do_notify_resume
> -	jmp resume_userspace_sig
> +	jmp resume_userspace
>  
>  	ALIGN
>  work_notifysig_v86:
> @@ -643,9 +646,13 @@ work_notifysig_v86:
>  #endif
>  	TRACE_IRQS_ON
>  	ENABLE_INTERRUPTS(CLBR_NONE)
> +	movb PT_CS(%esp), %bl
> +	andl $SEGMENT_RPL_MASK, %ebx
> +	cmpl $USER_RPL, %ebx
> +	jb resume_kernel
>  	xorl %edx, %edx
>  	call do_notify_resume
> -	jmp resume_userspace_sig
> +	jmp resume_userspace
>  END(work_pending)
>  
>  	# perform syscall exit tracing
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index 595969f..c4aa7c5 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -738,16 +738,6 @@ static void do_signal(struct pt_regs *regs)
>  	siginfo_t info;
>  	int signr;
>  
> -	/*
> -	 * We want the common case to go fast, which is why we may in certain
> -	 * cases get here from kernel mode. Just return without doing anything
> -	 * if so.
> -	 * X86_32: vm86 regs switched out by assembly code before reaching
> -	 * here, so testing against kernel CS suffices.
> -	 */
> -	if (!user_mode(regs))
> -		return;
> -

Can't review, but like very much ;)

Oleg.

