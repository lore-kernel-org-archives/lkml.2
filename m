Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab0LOKkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 05:40:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46811 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab0LOKj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 05:39:59 -0500
Message-Id: <E1PSom6-0008UE-DQ@ZenIV.linux.org.uk>
Date: Wed, 15 Dec 2010 10:39:58 +0000
To: hans-christian.egtvedt@atmel.com
Subject: [PATCH 6/6] avr32: deal with double restarts
Cc: linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


a) take handling of reschedule, signals and keychains into a new helper -
work_pending().  All looping is done there now; asm glue calls that if
we have anything for it to do.

b) do_signal() gets explicit "may restart" flag as an argument; after
the first call during that loop it gets unconditional 0.

c) sigreturn() sets a thread flag - TIF_NORESTART.  It is included into
the "work_pending() has something to do" mask.  work_pending() clears
it, clearing its may_restart flag if it had done so.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/avr32/include/asm/thread_info.h |    3 ++
 arch/avr32/kernel/entry-avr32b.S     |   45 ++++------------------------
 arch/avr32/kernel/signal.c           |   55 ++++++++++++++++++++++++----------
 3 files changed, 48 insertions(+), 55 deletions(-)

diff --git a/arch/avr32/include/asm/thread_info.h b/arch/avr32/include/asm/thread_info.h
index 7a9c03d..1e8fa49 100644
--- a/arch/avr32/include/asm/thread_info.h
+++ b/arch/avr32/include/asm/thread_info.h
@@ -85,6 +85,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_RESTORE_SIGMASK	7	/* restore signal mask in do_signal */
 #define TIF_CPU_GOING_TO_SLEEP	8	/* CPU is entering sleep 0 mode */
 #define TIF_NOTIFY_RESUME	9	/* callback before returning to user */
+#define TIF_NORESTART		10
 #define TIF_FREEZE		29
 #define TIF_DEBUG		30	/* debugging enabled */
 #define TIF_USERSPACE		31      /* true if FS sets userspace */
@@ -98,6 +99,7 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_CPU_GOING_TO_SLEEP (1 << TIF_CPU_GOING_TO_SLEEP)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
+#define _TIF_NORESTART		(1 << TIF_NORESTART)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 /* Note: The masks below must never span more than 16 bits! */
@@ -106,6 +108,7 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_WORK_MASK				\
 	((1 << TIF_SIGPENDING)			\
 	 | _TIF_NOTIFY_RESUME			\
+	 | _TIF_NORESTART			\
 	 | (1 << TIF_NEED_RESCHED)		\
 	 | (1 << TIF_POLLING_NRFLAG)		\
 	 | (1 << TIF_BREAKPOINT)		\
diff --git a/arch/avr32/kernel/entry-avr32b.S b/arch/avr32/kernel/entry-avr32b.S
index 5e6beb2..bb455b7 100644
--- a/arch/avr32/kernel/entry-avr32b.S
+++ b/arch/avr32/kernel/entry-avr32b.S
@@ -271,28 +271,11 @@ syscall_exit_work:
 	unmask_interrupts
 	call	syscall_trace
 	mask_interrupts
-	ld.w	r1, r0[TI_flags]
-
-1:	bld	r1, TIF_NEED_RESCHED
-	brcc	2f
-	unmask_interrupts
-	call	schedule
-	mask_interrupts
-	ld.w	r1, r0[TI_flags]
-	rjmp	1b
-
-2:	mov	r2, _TIF_SIGPENDING | _TIF_RESTORE_SIGMASK | _TIF_NOTIFY_RESUME
-	tst	r1, r2
-	breq	3f
-	unmask_interrupts
 	mov	r12, sp
 	mov	r11, r0
-	call	do_notify_resume
-	mask_interrupts
-	ld.w	r1, r0[TI_flags]
-	rjmp	1b
-
-3:	bld	r1, TIF_BREAKPOINT
+	mov	r10, 1
+	call	work_pending
+	bld	r12, TIF_BREAKPOINT
 	brcc	syscall_exit_cont
 	rjmp	enter_monitor_mode
 
@@ -576,29 +559,13 @@ irq_exit_work:
 	mtsr	SYSREG_SR, r8
 	sub	pc, -2
 	get_thread_info r0
-	ld.w	r1, r0[TI_flags]
 
 fault_exit_work:
-	bld	r1, TIF_NEED_RESCHED
-	brcc	1f
-	unmask_interrupts
-	call	schedule
-	mask_interrupts
-	ld.w	r1, r0[TI_flags]
-	rjmp	fault_exit_work
-
-1:	mov	r2, _TIF_SIGPENDING | _TIF_RESTORE_SIGMASK | _TIF_NOTIFY_RESUME
-	tst	r1, r2
-	breq	2f
-	unmask_interrupts
 	mov	r12, sp
 	mov	r11, r0
-	call	do_notify_resume
-	mask_interrupts
-	ld.w	r1, r0[TI_flags]
-	rjmp	fault_exit_work
-
-2:	bld	r1, TIF_BREAKPOINT
+	mov	r10, 0
+	call	work_pending
+	bld	r12, TIF_BREAKPOINT
 	brcc	fault_resume_user
 	rjmp	enter_monitor_mode
 
diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
index 3b4bb5a..f0c6d71 100644
--- a/arch/avr32/kernel/signal.c
+++ b/arch/avr32/kernel/signal.c
@@ -45,6 +45,8 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
 	/* Always make any pending restarted system calls return -EINTR */
 	current_thread_info()->restart_block.fn = do_no_restart_syscall;
 
+	set_thread_flag(TIF_NORESTART);
+
 #define COPY(x)		err |= __get_user(regs->x, &sc->x)
 	COPY(sr);
 	COPY(pc);
@@ -262,7 +264,7 @@ fail:
  * doesn't want to handle. Thus you cannot kill init even with a
  * SIGKILL even by mistake.
  */
-static void do_signal(struct pt_regs *regs, int syscall)
+static void do_signal(struct pt_regs *regs, int may_restart)
 {
 	siginfo_t info;
 	int signr;
@@ -283,7 +285,7 @@ static void do_signal(struct pt_regs *regs, int syscall)
 		oldset = &current->blocked;
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (syscall) {
+	if (may_restart) {
 		switch (regs->r12) {
 		case -ERESTART_RESTARTBLOCK:
 		case -ERESTARTNOHAND:
@@ -315,20 +317,41 @@ static void do_signal(struct pt_regs *regs, int syscall)
 	handle_signal(signr, &ka, &info, oldset, regs);
 }
 
-asmlinkage void do_notify_resume(struct pt_regs *regs, struct thread_info *ti)
+asmlinkage int work_pending(struct pt_regs *regs, struct thread_info *ti, int may_restart)
 {
-	int syscall = 0;
-
-	if ((sysreg_read(SR) & MODE_MASK) == MODE_SUPERVISOR)
-		syscall = 1;
-
-	if (ti->flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
-		do_signal(regs, syscall);
-
-	if (ti->flags & _TIF_NOTIFY_RESUME) {
-		clear_thread_flag(TIF_NOTIFY_RESUME);
-		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
+	int flags = ti->flags;
+	if (unlikely(flags & _TIF_NORESTART)) {
+		ti->flags &= ~_TIF_NORESTART;
+		may_restart = 0;
+	}
+	while (1) {
+		if (flags & _TIF_NEED_RESCHED) {
+			local_irq_enable();
+			schedule();
+			local_irq_disable();
+			flags = ti->flags;
+			continue;
+		}
+		if (flags & _TIF_SIGPENDING) {
+			local_irq_enable();
+			if ((sysreg_read(SR) & MODE_MASK) != MODE_SUPERVISOR)
+				may_restart = 0;
+			do_signal(regs, may_restart);
+			may_restart = 0;
+			local_irq_disable();
+			flags = ti->flags;
+			continue;
+		}
+		if (flags & _TIF_NOTIFY_RESUME) {
+			ti->flags &= ~_TIF_NOTIFY_RESUME;
+			local_irq_enable();
+			tracehook_notify_resume(regs);
+			if (current->replacement_session_keyring)
+				key_replace_session_keyring();
+			local_irq_disable();
+			flags = ti->flags;
+			continue;
+		}
+		return flags;
 	}
 }
-- 
1.5.6.5


