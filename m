Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1HYPA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:00:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46034 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1HYPAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:00:54 -0400
Date: Thu, 25 Aug 2011 15:55:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Message-ID: <20110825145558.GF8883@n2100.arm.linux.org.uk>
References: <20110823220056.GK3895@n2100.arm.linux.org.uk> <CAOS58YNuCbaOsWBfmjSUsXsArZ5ng6c0B30yswFbRAWkho6L6Q@mail.gmail.com> <20110823221314.GL3895@n2100.arm.linux.org.uk> <CAOS58YNtQEuke=Ko9J2oNGMECjabzxj=Nrg1o64X1JC3YRmJuw@mail.gmail.com> <20110825121416.GB8883@n2100.arm.linux.org.uk> <20110825121710.GK3286@htj.dyndns.org> <20110825122543.GC8883@n2100.arm.linux.org.uk> <20110825123542.GM3286@htj.dyndns.org> <20110825130414.GE8883@n2100.arm.linux.org.uk> <20110825130907.GO3286@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825130907.GO3286@htj.dyndns.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 03:09:07PM +0200, Tejun Heo wrote:
> Hey, Russell.
> 
> If you can fix it properly without going through temporary step,
> that's awesome.  Let's put the arguments behind, okay?

Here's the patch.  As the kernel I've run this against doesn't have the
change to try_to_freeze(), I added a might_sleep() in do_signal() during
my testing to verify that it fixes Mark's problem (which it does.)

I've tested functions returning -ERESTARTSYS, -ERESTARTNOHAND and
-ERESTART_RESTARTBLOCK, all of which seem to behave as expected with
signals such as SIGCONT (without handler) and SIGALRM (with handler).
I haven't tested -ERESTARTNOINTR.

I don't have a test case for the race condition I mentioned (which is
admittedly pretty difficult to construct, requiring an explicit
signal, schedule, signal sequence) but this should plug that too.

How do we achieve this?  Effectively the steps in this patch are:

1. Undo Arnd's fixups to the syscall restart processing (but don't worry,
   we restore it in step 3).

2. Introduce TIF_SYS_RESTART, which is set when we enter signal handling
   and the syscall has returned one of the restart codes.  This is used
   as a flag to indicate that we have some syscall restart processing to
   do at some point.

3. Clear TIF_SYS_RESTART whenever ptrace is used to set the GP registers
   (thereby restoring Arnd's fixup for his gdb testsuite problem - it
   would be good if Arnd could reconfirm that.)

4. When we setup a user handler to run, check TIF_SYS_RESTART and clear it.
   If it was set, we need to set things up to return -EINTR or restart the
   syscall as appropriate.  As we've cleared it, no further restart
   processing will occur.

5. Once we've run all work (signal delivery, and rescheduling events), and
   we're about to return to userspace, make a final check for TIF_SYS_RESTART.
   If it's still set, then we're returning to userspace having not setup
   any user handlers, and we need to restart the syscall.  This is mostly
   trivial, except for OABI restartblock which requires the user stack to
   be written.  We have to re-enable IRQs for this write, which means we
   have to manually re-check for rescheduling events, abort the restart,
   and try again later.

One of the side effects of reverting Arnd's patch is that we restore the
strace behaviour which we've had for years on ARM, and can still be seen
on x86: strace can see the -ERESTART return codes from the kernel syscalls,
rather than what seems to be the signal number:

Before:
rt_sigsuspend([] <unfinished ...>
--- SIGIO (I/O possible) ---
<... rt_sigsuspend resumed> )           = 29
sigreturn()                             = ? (mask now [])

vs:
rt_sigsuspend([])                       = ? ERESTARTNOHAND (To be restarted)
--- SIGIO (I/O possible) @ 0 (0) ---
sigreturn()                             = ? (mask now [])

x86:
rt_sigsuspend([])                       = ? ERESTARTNOHAND (To be restarted)
--- {si_signo=SIGIO, si_code=SI_USER} (I/O possible) ---
sigreturn()                             = ? (mask now [])

So, this patch should fix:
1. The race which I identified in the signal handling code (I think x86
   and other architectures can suffer from it too.)
2. The warning from try_to_freeze.
3. The unanticipated change to strace output.

Arnd, can you test this to make sure your gdb test case still works, and
Mark, can you test this to make sure it fixes your problem please?

Thanks.

 arch/arm/include/asm/thread_info.h |    3 +
 arch/arm/kernel/entry-common.S     |   11 ++
 arch/arm/kernel/ptrace.c           |    2 +
 arch/arm/kernel/signal.c           |  209 ++++++++++++++++++++++++------------
 4 files changed, 155 insertions(+), 70 deletions(-)

diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 7b5cc8d..40df533 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -129,6 +129,7 @@ extern void vfp_flush_hwstate(struct thread_info *);
 /*
  * thread information flags:
  *  TIF_SYSCALL_TRACE	- syscall trace active
+ *  TIF_SYS_RESTART	- syscall restart processing
  *  TIF_SIGPENDING	- signal pending
  *  TIF_NEED_RESCHED	- rescheduling necessary
  *  TIF_NOTIFY_RESUME	- callback before returning to user
@@ -139,6 +140,7 @@ extern void vfp_flush_hwstate(struct thread_info *);
 #define TIF_NEED_RESCHED	1
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
 #define TIF_SYSCALL_TRACE	8
+#define TIF_SYS_RESTART		9
 #define TIF_POLLING_NRFLAG	16
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
@@ -147,6 +149,7 @@ extern void vfp_flush_hwstate(struct thread_info *);
 #define TIF_SECCOMP		21
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
+#define _TIF_SYS_RESTART	(1 << TIF_SYS_RESTART)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index b2a27b6..e922b85 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -45,6 +45,7 @@ ret_fast_syscall:
 fast_work_pending:
 	str	r0, [sp, #S_R0+S_OFF]!		@ returned r0
 work_pending:
+	enable_irq
 	tst	r1, #_TIF_NEED_RESCHED
 	bne	work_resched
 	tst	r1, #_TIF_SIGPENDING|_TIF_NOTIFY_RESUME
@@ -56,6 +57,13 @@ work_pending:
 	bl	do_notify_resume
 	b	ret_slow_syscall		@ Check work again
 
+work_syscall_restart:
+	mov	r0, sp				@ 'regs'
+	bl	syscall_restart			@ process system call restart
+	teq	r0, #0				@ if ret=0 -> success, so
+	beq	ret_restart			@ return to userspace directly
+	b	ret_slow_syscall		@ otherwise, we have a segfault
+
 work_resched:
 	bl	schedule
 /*
@@ -69,6 +77,9 @@ ENTRY(ret_to_user_from_irq)
 	tst	r1, #_TIF_WORK_MASK
 	bne	work_pending
 no_work_pending:
+	tst	r1, #_TIF_SYS_RESTART
+	bne	work_syscall_restart
+ret_restart:
 #if defined(CONFIG_IRQSOFF_TRACER)
 	asm_trace_hardirqs_on
 #endif
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 2491f3b..ac8c34e 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -177,6 +177,7 @@ put_user_reg(struct task_struct *task, int offset, long data)
 
 	if (valid_user_regs(&newregs)) {
 		regs->uregs[offset] = data;
+		clear_ti_thread_flag(task_thread_info(task), TIF_SYS_RESTART);
 		ret = 0;
 	}
 
@@ -604,6 +605,7 @@ static int gpr_set(struct task_struct *target,
 		return -EINVAL;
 
 	*task_pt_regs(target) = newregs;
+	clear_ti_thread_flag(task_thread_info(target), TIF_SYS_RESTART);
 	return 0;
 }
 
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 0340224..42a1521 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -649,6 +649,135 @@ handle_signal(unsigned long sig, struct k_sigaction *ka,
 }
 
 /*
+ * Syscall restarting codes
+ *
+ * -ERESTARTSYS: restart system call if no handler, or if there is a
+ *	handler but it's marked SA_RESTART.  Otherwise return -EINTR.
+ * -ERESTARTNOINTR: always restart system call
+ * -ERESTARTNOHAND: restart system call only if no handler, otherwise
+ *	return -EINTR if invoking a user signal handler.
+ * -ERESTART_RESTARTBLOCK: call restart syscall if no handler, otherwise
+ *	return -EINTR if invoking a user signal handler.
+ */
+static void setup_syscall_restart(struct pt_regs *regs)
+{
+	regs->ARM_r0 = regs->ARM_ORIG_r0;
+	regs->ARM_pc -= thumb_mode(regs) ? 2 : 4;
+}
+
+/*
+ * Depending on the signal settings we may need to revert the decision
+ * to restart the system call.  But skip this if a debugger has chosen
+ * to restart at a different PC.
+ */
+static void syscall_restart_handler(struct pt_regs *regs, struct k_sigaction *ka)
+{
+	if (test_and_clear_thread_flag(TIF_SYS_RESTART)) {
+		long r0 = regs->ARM_r0;
+
+		/*
+		 * By default, return -EINTR to the user process for any
+		 * syscall which would otherwise be restarted.
+		 */
+		regs->ARM_r0 = -EINTR;
+
+		if (r0 == -ERESTARTNOINTR ||
+		    (r0 == -ERESTARTSYS && !(ka->sa.sa_flags & SA_RESTART)))
+			setup_syscall_restart(regs);
+	}
+}
+
+/*
+ * Handle syscall restarting when there is no user handler in place for
+ * a delivered signal.  Rather than doing this as part of the normal
+ * signal processing, we do this on the final return to userspace, after
+ * we've finished handling signals and checking for schedule events.
+ *
+ * This avoids bad behaviour such as:
+ *  - syscall returns -ERESTARTNOHAND
+ *  - signal with no handler (so we set things up to restart the syscall)
+ *  - schedule
+ *  - signal with handler (eg, SIGALRM)
+ *  - we call the handler and then restart the syscall
+ *
+ * In order to avoid races with TIF_NEED_RESCHED, IRQs must be disabled
+ * when this function is called and remain disabled until we exit to
+ * userspace.
+ */
+asmlinkage int syscall_restart(struct pt_regs *regs)
+{
+	struct thread_info *thread = current_thread_info();
+
+	clear_ti_thread_flag(thread, TIF_SYS_RESTART);
+	
+	/*
+	 * Restart the system call.  We haven't setup a signal handler
+	 * to invoke, and the regset hasn't been usurped by ptrace.
+	 */
+	if (regs->ARM_r0 == -ERESTART_RESTARTBLOCK) {
+		if (thumb_mode(regs)) {
+			regs->ARM_r7 = __NR_restart_syscall - __NR_SYSCALL_BASE;
+			regs->ARM_pc -= 2;
+		} else {
+#if defined(CONFIG_AEABI) && !defined(CONFIG_OABI_COMPAT)
+			regs->ARM_r7 = __NR_restart_syscall;
+			regs->ARM_pc -= 4;
+#else
+			u32 sp = regs->ARM_sp - 4;
+			u32 __user *usp = (u32 __user *)sp;
+			int ret;
+
+			/*
+			 * For OABI, we need to play some extra games, because
+			 * we need to write to the users stack, which we can't
+			 * do reliably from IRQs-disabled context.  Temporarily
+			 * re-enable IRQs, perform the store, and then plug
+			 * the resulting race afterwards.
+			 */
+			local_irq_enable();
+			ret = put_user(regs->ARM_pc, usp);
+			local_irq_disable();
+
+			/*
+			 * Plug the reschedule race - if we need to reschedule,
+			 * abort the syscall restarting.  We haven't modified
+			 * anything other than the attempted write to the stack
+			 * so we can merely retry later.
+			 */
+			if (need_resched()) {
+				set_ti_thread_flag(thread, TIF_SYS_RESTART);
+				return -EINTR;
+			}
+
+			/*
+			 * We failed (for some reason) to write to the stack.
+			 * Terminate the task.
+			 */
+			if (ret) {
+				force_sigsegv(0, current);
+				return -EFAULT;
+			}
+
+			/*
+			 * Success, update the stack pointer and point the
+			 * PC at the restarting code.
+			 */
+			regs->ARM_sp = sp;
+			regs->ARM_pc = KERN_RESTART_CODE;
+#endif
+		}
+	} else {
+		/*
+		 * Simple restart - just back up and re-execute the last
+		 * instruction.
+		 */
+		setup_syscall_restart(regs);
+	}
+
+	return 0;
+}
+
+/*
  * Note that 'init' is a special process: it doesn't get signals it doesn't
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
  * mistake.
@@ -659,7 +788,6 @@ handle_signal(unsigned long sig, struct k_sigaction *ka,
  */
 static void do_signal(struct pt_regs *regs, int syscall)
 {
-	unsigned int retval = 0, continue_addr = 0, restart_addr = 0;
 	struct k_sigaction ka;
 	siginfo_t info;
 	int signr;
@@ -674,32 +802,16 @@ static void do_signal(struct pt_regs *regs, int syscall)
 		return;
 
 	/*
-	 * If we were from a system call, check for system call restarting...
+	 * Set the SYS_RESTART flag to indicate that we have some
+	 * cleanup of the restart state to perform when returning to
+	 * userspace.
 	 */
-	if (syscall) {
-		continue_addr = regs->ARM_pc;
-		restart_addr = continue_addr - (thumb_mode(regs) ? 2 : 4);
-		retval = regs->ARM_r0;
-
-		/*
-		 * Prepare for system call restart.  We do this here so that a
-		 * debugger will see the already changed PSW.
-		 */
-		switch (retval) {
-		case -ERESTARTNOHAND:
-		case -ERESTARTSYS:
-		case -ERESTARTNOINTR:
-			regs->ARM_r0 = regs->ARM_ORIG_r0;
-			regs->ARM_pc = restart_addr;
-			break;
-		case -ERESTART_RESTARTBLOCK:
-			regs->ARM_r0 = -EINTR;
-			break;
-		}
-	}
-
-	if (try_to_freeze())
-		goto no_signal;
+	if (syscall &&
+	    (regs->ARM_r0 == -ERESTARTSYS ||
+	     regs->ARM_r0 == -ERESTARTNOINTR ||
+	     regs->ARM_r0 == -ERESTARTNOHAND ||
+	     regs->ARM_r0 == -ERESTART_RESTARTBLOCK))
+		set_thread_flag(TIF_SYS_RESTART);
 
 	/*
 	 * Get the signal to deliver.  When running under ptrace, at this
@@ -709,19 +821,7 @@ static void do_signal(struct pt_regs *regs, int syscall)
 	if (signr > 0) {
 		sigset_t *oldset;
 
-		/*
-		 * Depending on the signal settings we may need to revert the
-		 * decision to restart the system call.  But skip this if a
-		 * debugger has chosen to restart at a different PC.
-		 */
-		if (regs->ARM_pc == restart_addr) {
-			if (retval == -ERESTARTNOHAND
-			    || (retval == -ERESTARTSYS
-				&& !(ka.sa.sa_flags & SA_RESTART))) {
-				regs->ARM_r0 = -EINTR;
-				regs->ARM_pc = continue_addr;
-			}
-		}
+		syscall_restart_handler(regs, &ka);
 
 		if (test_thread_flag(TIF_RESTORE_SIGMASK))
 			oldset = &current->saved_sigmask;
@@ -740,38 +840,7 @@ static void do_signal(struct pt_regs *regs, int syscall)
 		return;
 	}
 
- no_signal:
 	if (syscall) {
-		/*
-		 * Handle restarting a different system call.  As above,
-		 * if a debugger has chosen to restart at a different PC,
-		 * ignore the restart.
-		 */
-		if (retval == -ERESTART_RESTARTBLOCK
-		    && regs->ARM_pc == continue_addr) {
-			if (thumb_mode(regs)) {
-				regs->ARM_r7 = __NR_restart_syscall - __NR_SYSCALL_BASE;
-				regs->ARM_pc -= 2;
-			} else {
-#if defined(CONFIG_AEABI) && !defined(CONFIG_OABI_COMPAT)
-				regs->ARM_r7 = __NR_restart_syscall;
-				regs->ARM_pc -= 4;
-#else
-				u32 __user *usp;
-
-				regs->ARM_sp -= 4;
-				usp = (u32 __user *)regs->ARM_sp;
-
-				if (put_user(regs->ARM_pc, usp) == 0) {
-					regs->ARM_pc = KERN_RESTART_CODE;
-				} else {
-					regs->ARM_sp += 4;
-					force_sigsegv(0, current);
-				}
-#endif
-			}
-		}
-
 		/* If there's no signal to deliver, we just put the saved sigmask
 		 * back.
 		 */

