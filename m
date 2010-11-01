Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab0KAJhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 05:37:22 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39259 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab0KAJhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 05:37:20 -0400
Subject: Re: [PATCH 6/6] avr32: deal with syscall restarts
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <E1P0QOT-0008TU-0m@ZenIV.linux.org.uk>
References: <E1P0QOT-0008TU-0m@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Mon, 01 Nov 2010 10:37:05 +0100
Message-ID: <1288604225.2843.69.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Nov 2010 09:37:05.0990 (UTC) FILETIME=[58B4C660:01CB79A8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 03:58 +0100, Al Viro wrote: 
> Currently we both have signals arriving at sigreturn trigger syscall restart
> when the original handler hadn't been in the syscall at all *and* have
> multiple pending signals trigger the sitation when %pc is shifted back by
> more than one insn.
> 
> a) take handling of reschedule, signals and keychains into a new helper -
> work_pending().  All looping is done there now; asm glue calls that if
> we have anything for it to do.

Am I the only one getting a conflict with the work_pending() function in
include/linux/workqueue.h?

> b) do_signal() gets explicit "may restart" flag as an argument; after
> the first call during that loop it gets unconditional 0.
> 
> c) sigreturn() sets a thread flag - TIF_NORESTART.  It is included into
> the "work_pending() has something to do" mask.  work_pending() clears
> it, clearing its may_restart flag if it had done so.

Both sounds and look sane further below.

> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  arch/avr32/include/asm/thread_info.h |    3 ++
>  arch/avr32/kernel/entry-avr32b.S     |   45 ++++------------------------
>  arch/avr32/kernel/signal.c           |   55 ++++++++++++++++++++++++----------
>  3 files changed, 48 insertions(+), 55 deletions(-)
> 
> diff --git a/arch/avr32/include/asm/thread_info.h b/arch/avr32/include/asm/thread_info.h
> index 7a9c03d..1e8fa49 100644
> --- a/arch/avr32/include/asm/thread_info.h
> +++ b/arch/avr32/include/asm/thread_info.h
> @@ -85,6 +85,7 @@ static inline struct thread_info *current_thread_info(void)
>  #define TIF_RESTORE_SIGMASK	7	/* restore signal mask in do_signal */
>  #define TIF_CPU_GOING_TO_SLEEP	8	/* CPU is entering sleep 0 mode */
>  #define TIF_NOTIFY_RESUME	9	/* callback before returning to user */
> +#define TIF_NORESTART		10

Please add a comment after the define.

<snipp>

> diff --git a/arch/avr32/kernel/entry-avr32b.S b/arch/avr32/kernel/entry-avr32b.S
> index 5e6beb2..bb455b7 100644
> --- a/arch/avr32/kernel/entry-avr32b.S
> +++ b/arch/avr32/kernel/entry-avr32b.S
> @@ -271,28 +271,11 @@ syscall_exit_work:
>  	unmask_interrupts
>  	call	syscall_trace
>  	mask_interrupts
> -	ld.w	r1, r0[TI_flags]
> -
> -1:	bld	r1, TIF_NEED_RESCHED

Hmmm...

@ line 268
syscall_exit_work:
bld r1, TIF_SYSCALL_TRACE
brcc 1f

Which refers to the 1: label you remove here.

> -	brcc	2f
> -	unmask_interrupts
> -	call	schedule
> -	mask_interrupts
> -	ld.w	r1, r0[TI_flags]
> -	rjmp	1b
> -
> -2:	mov	r2, _TIF_SIGPENDING | _TIF_RESTORE_SIGMASK | _TIF_NOTIFY_RESUME
> -	tst	r1, r2
> -	breq	3f
> -	unmask_interrupts
>  	mov	r12, sp

Make a 1: label at this line should do the trick AFAICT.

<snipp>

> diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
> index 8e8f6ba..c4c76f5 100644
> --- a/arch/avr32/kernel/signal.c
> +++ b/arch/avr32/kernel/signal.c
> @@ -45,6 +45,8 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
>  	/* Always make any pending restarted system calls return -EINTR */
>  	current_thread_info()->restart_block.fn = do_no_restart_syscall;
>  
> +	set_thread_flag(TIF_NORESTART);
> +
>  #define COPY(x)		err |= __get_user(regs->x, &sc->x)
>  	COPY(sr);
>  	COPY(pc);
> @@ -264,7 +266,7 @@ fail:
>   * doesn't want to handle. Thus you cannot kill init even with a
>   * SIGKILL even by mistake.
>   */
> -static void do_signal(struct pt_regs *regs, int syscall)
> +static void do_signal(struct pt_regs *regs, int may_restart)
>  {
>  	siginfo_t info;
>  	int signr;
> @@ -285,7 +287,7 @@ static void do_signal(struct pt_regs *regs, int syscall)
>  		oldset = &current->blocked;
>  
>  	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
> -	if (syscall) {
> +	if (may_restart) {
>  		switch (regs->r12) {
>  		case -ERESTART_RESTARTBLOCK:
>  		case -ERESTARTNOHAND:
> @@ -317,20 +319,41 @@ static void do_signal(struct pt_regs *regs, int syscall)
>  	handle_signal(signr, &ka, &info, oldset, regs);
>  }
>  
> -asmlinkage void do_notify_resume(struct pt_regs *regs, struct thread_info *ti)
> +asmlinkage int work_pending(struct pt_regs *regs, struct thread_info *ti, int may_restart)

I get a conflict with a similar function declared in
include/linux/workqueue.h. Also, please brake it over multiple lines as
it is wider than 80 characters.

<snipp>

-- 
Hans-Christian Egtvedt

