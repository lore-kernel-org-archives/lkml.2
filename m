Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab2JASlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 14:41:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54829 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab2JASlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:41:00 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: James Morris <james.l.morris@oracle.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Will Drewry <wad@chromium.org>, x86@kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH v2 resend] seccomp: Make syscall skipping and nr changes more consistent
Date: Mon,  1 Oct 2012 11:40:45 -0700
Message-Id: <1c47b77bc4f572e9f9755b7bbccef045ee451a1b.1349116571.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes two issues that could cause incompatibility between
kernel versions:

 - If a tracer uses SECCOMP_RET_TRACE to select a syscall number
   higher than the largest known syscall, emulate the unknown
   vsyscall by returning -ENOSYS.  (This is unlikely to make a
   noticeable difference on x86-64 due to the way the system call
   entry works.)

 - On x86-64 with vsyscall=emulate, skipped vsyscalls were buggy.

This updates the documentation accordingly.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Acked-by: Will Drewry <wad@chromium.org>
---

This causes 9/10 of the tests in 'vsyscall' at
https://github.com/amluto/seccomp to pass.  Without this patch, only 3/10
pass.  (The one that fails is a different issue, and I don't see any urgency
to fixing it until another seccomp arch shows up.)

This is unchanged from the version that's been floating on lkml since
August 1.  It can be found at:

https://git.kernel.org/?p=linux/kernel/git/luto/linux.git;a=shortlog;h=refs/heads/seccomp-vsyscall/patch_v2
(Although git.kernel.org is currently caching a bogus version that I put there.
Oops.)

Once this goes in and survives for a while, I'll forward it to -stable.

 Documentation/prctl/seccomp_filter.txt |   74 ++++++++++++++++++++--
 arch/x86/kernel/vsyscall_64.c          |  110 +++++++++++++++++---------------
 kernel/seccomp.c                       |   13 +++-
 3 files changed, 137 insertions(+), 60 deletions(-)

diff --git a/Documentation/prctl/seccomp_filter.txt b/Documentation/prctl/seccomp_filter.txt
index 597c3c5..1e469ef 100644
--- a/Documentation/prctl/seccomp_filter.txt
+++ b/Documentation/prctl/seccomp_filter.txt
@@ -95,12 +95,15 @@ SECCOMP_RET_KILL:
 
 SECCOMP_RET_TRAP:
 	Results in the kernel sending a SIGSYS signal to the triggering
-	task without executing the system call.  The kernel will
-	rollback the register state to just before the system call
-	entry such that a signal handler in the task will be able to
-	inspect the ucontext_t->uc_mcontext registers and emulate
-	system call success or failure upon return from the signal
-	handler.
+	task without executing the system call.  siginfo->si_call_addr
+	will show the address of the system call instruction, and
+	siginfo->si_syscall and siginfo->si_arch will indicate which
+	syscall was attempted.  The program counter will be as though
+	the syscall happened (i.e. it will not point to the syscall
+	instruction).  The return value register will contain an arch-
+	dependent value -- if resuming execution, set it to something
+	sensible.  (The architecture dependency is because replacing
+	it with -ENOSYS could overwrite some useful information.)
 
 	The SECCOMP_RET_DATA portion of the return value will be passed
 	as si_errno.
@@ -123,6 +126,18 @@ SECCOMP_RET_TRACE:
 	the BPF program return value will be available to the tracer
 	via PTRACE_GETEVENTMSG.
 
+	The tracer can skip the system call by changing the syscall number
+	to -1.  Alternatively, the tracer can change the system call
+	requested by changing the system call to a valid syscall number.  If
+	the tracer asks to skip the system call, then the system call will
+	appear to return the value that the tracer puts in the return value
+	register.
+
+	The seccomp check will not be run again after the tracer is
+	notified.  (This means that seccomp-based sandboxes MUST NOT
+	allow use of ptrace, even of other sandboxed processes, without
+	extreme care; ptracers can use this mechanism to escape.)
+
 SECCOMP_RET_ALLOW:
 	Results in the system call being executed.
 
@@ -161,3 +176,50 @@ architecture supports both ptrace_event and seccomp, it will be able to
 support seccomp filter with minor fixup: SIGSYS support and seccomp return
 value checking.  Then it must just add CONFIG_HAVE_ARCH_SECCOMP_FILTER
 to its arch-specific Kconfig.
+
+
+
+Caveats
+-------
+
+The vDSO can cause some system calls to run entirely in userspace,
+leading to surprises when you run programs on different machines that
+fall back to real syscalls.  To minimize these surprises on x86, make
+sure you test with
+/sys/devices/system/clocksource/clocksource0/current_clocksource set to
+something like acpi_pm.
+
+On x86-64, vsyscall emulation is enabled by default.  (vsyscalls are
+legacy variants on vDSO calls.)  Currently, emulated vsyscalls will honor seccomp, with a few oddities:
+
+- A return value of SECCOMP_RET_TRAP will set a si_call_addr pointing to
+  the vsyscall entry for the given call and not the address after the
+  'syscall' instruction.  Any code which wants to restart the call
+  should be aware that (a) a ret instruction has been emulated and (b)
+  trying to resume the syscall will again trigger the standard vsyscall
+  emulation security checks, making resuming the syscall mostly
+  pointless.
+
+- A return value of SECCOMP_RET_TRACE will signal the tracer as usual,
+  but the syscall may not be changed to another system call using the
+  orig_rax register. It may only be changed to -1 order to skip the
+  currently emulated call. Any other change MAY terminate the process.
+  The rip value seen by the tracer will be the syscall entry address;
+  this is different from normal behavior.  The tracer MUST NOT modify
+  rip or rsp.  (Do not rely on other changes terminating the process.
+  They might work.  For example, on some kernels, choosing a syscall
+  that only exists in future kernels will be correctly emulated (by
+  returning -ENOSYS).
+
+To detect this quirky behavior, check for addr & ~0x0C00 ==
+0xFFFFFFFFFF600000.  (For SECCOMP_RET_TRACE, use rip.  For
+SECCOMP_RET_TRAP, use siginfo->si_call_addr.)  Do not check any other
+condition: future kernels may improve vsyscall emulation and current
+kernels in vsyscall=native mode will behave differently, but the
+instructions at 0xF...F600{0,4,8,C}00 will not be system calls in these
+cases.
+
+Note that modern systems are unlikely to use vsyscalls at all -- they
+are a legacy feature and they are considerably slower than standard
+syscalls.  New code will use the vDSO, and vDSO-issued system calls
+are indistinguishable from normal system calls.
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 8d141b3..b2e58a2 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -136,19 +136,6 @@ static int addr_to_vsyscall_nr(unsigned long addr)
 	return nr;
 }
 
-#ifdef CONFIG_SECCOMP
-static int vsyscall_seccomp(struct task_struct *tsk, int syscall_nr)
-{
-	if (!seccomp_mode(&tsk->seccomp))
-		return 0;
-	task_pt_regs(tsk)->orig_ax = syscall_nr;
-	task_pt_regs(tsk)->ax = syscall_nr;
-	return __secure_computing(syscall_nr);
-}
-#else
-#define vsyscall_seccomp(_tsk, _nr) 0
-#endif
-
 static bool write_ok_or_segv(unsigned long ptr, size_t size)
 {
 	/*
@@ -181,10 +168,9 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 {
 	struct task_struct *tsk;
 	unsigned long caller;
-	int vsyscall_nr;
+	int vsyscall_nr, syscall_nr, tmp;
 	int prev_sig_on_uaccess_error;
 	long ret;
-	int skip;
 
 	/*
 	 * No point in checking CS -- the only way to get here is a user mode
@@ -216,56 +202,84 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 	}
 
 	tsk = current;
-	/*
-	 * With a real vsyscall, page faults cause SIGSEGV.  We want to
-	 * preserve that behavior to make writing exploits harder.
-	 */
-	prev_sig_on_uaccess_error = current_thread_info()->sig_on_uaccess_error;
-	current_thread_info()->sig_on_uaccess_error = 1;
 
 	/*
+	 * Check for access_ok violations and find the syscall nr.
+	 *
 	 * NULL is a valid user pointer (in the access_ok sense) on 32-bit and
 	 * 64-bit, so we don't need to special-case it here.  For all the
 	 * vsyscalls, NULL means "don't write anything" not "write it at
 	 * address 0".
 	 */
-	ret = -EFAULT;
-	skip = 0;
 	switch (vsyscall_nr) {
 	case 0:
-		skip = vsyscall_seccomp(tsk, __NR_gettimeofday);
-		if (skip)
-			break;
-
 		if (!write_ok_or_segv(regs->di, sizeof(struct timeval)) ||
-		    !write_ok_or_segv(regs->si, sizeof(struct timezone)))
-			break;
+		    !write_ok_or_segv(regs->si, sizeof(struct timezone))) {
+			ret = -EFAULT;
+			goto check_fault;
+		}
+
+		syscall_nr = __NR_gettimeofday;
+		break;
+
+	case 1:
+		if (!write_ok_or_segv(regs->di, sizeof(time_t))) {
+			ret = -EFAULT;
+			goto check_fault;
+		}
+
+		syscall_nr = __NR_time;
+		break;
+
+	case 2:
+		if (!write_ok_or_segv(regs->di, sizeof(unsigned)) ||
+		    !write_ok_or_segv(regs->si, sizeof(unsigned))) {
+			ret = -EFAULT;
+			goto check_fault;
+		}
+
+		syscall_nr = __NR_getcpu;
+		break;
+	}
+
+	/*
+	 * Handle seccomp.  regs->ip must be the original value.
+	 * See seccomp_send_sigsys and Documentation/prctl/seccomp_filter.txt.
+	 *
+	 * We could optimize the seccomp disabled case, but performance
+	 * here doesn't matter.
+	 */
+	regs->orig_ax = syscall_nr;
+	regs->ax = -ENOSYS;
+	tmp = secure_computing(syscall_nr);
+	if ((!tmp && regs->orig_ax != syscall_nr) || regs->ip != address) {
+		warn_bad_vsyscall(KERN_DEBUG, regs,
+				  "seccomp tried to change syscall nr or ip");
+		do_exit(SIGSYS);
+	}
+	if (tmp)
+		goto do_ret;  /* skip requested */
 
+	/*
+	 * With a real vsyscall, page faults cause SIGSEGV.  We want to
+	 * preserve that behavior to make writing exploits harder.
+	 */
+	prev_sig_on_uaccess_error = current_thread_info()->sig_on_uaccess_error;
+	current_thread_info()->sig_on_uaccess_error = 1;
+
+	ret = -EFAULT;
+	switch (vsyscall_nr) {
+	case 0:
 		ret = sys_gettimeofday(
 			(struct timeval __user *)regs->di,
 			(struct timezone __user *)regs->si);
 		break;
 
 	case 1:
-		skip = vsyscall_seccomp(tsk, __NR_time);
-		if (skip)
-			break;
-
-		if (!write_ok_or_segv(regs->di, sizeof(time_t)))
-			break;
-
 		ret = sys_time((time_t __user *)regs->di);
 		break;
 
 	case 2:
-		skip = vsyscall_seccomp(tsk, __NR_getcpu);
-		if (skip)
-			break;
-
-		if (!write_ok_or_segv(regs->di, sizeof(unsigned)) ||
-		    !write_ok_or_segv(regs->si, sizeof(unsigned)))
-			break;
-
 		ret = sys_getcpu((unsigned __user *)regs->di,
 				 (unsigned __user *)regs->si,
 				 NULL);
@@ -274,12 +288,7 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 
 	current_thread_info()->sig_on_uaccess_error = prev_sig_on_uaccess_error;
 
-	if (skip) {
-		if ((long)regs->ax <= 0L) /* seccomp errno emulation */
-			goto do_ret;
-		goto done; /* seccomp trace/trap */
-	}
-
+check_fault:
 	if (ret == -EFAULT) {
 		/* Bad news -- userspace fed a bad pointer to a vsyscall. */
 		warn_bad_vsyscall(KERN_INFO, regs,
@@ -302,7 +311,6 @@ do_ret:
 	/* Emulate a ret instruction. */
 	regs->ip = caller;
 	regs->sp += 8;
-done:
 	return true;
 
 sigsegv:
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index ee376be..5af44b5 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -396,25 +396,29 @@ int __secure_computing(int this_syscall)
 #ifdef CONFIG_SECCOMP_FILTER
 	case SECCOMP_MODE_FILTER: {
 		int data;
+		struct pt_regs *regs = task_pt_regs(current);
 		ret = seccomp_run_filters(this_syscall);
 		data = ret & SECCOMP_RET_DATA;
 		ret &= SECCOMP_RET_ACTION;
 		switch (ret) {
 		case SECCOMP_RET_ERRNO:
 			/* Set the low-order 16-bits as a errno. */
-			syscall_set_return_value(current, task_pt_regs(current),
+			syscall_set_return_value(current, regs,
 						 -data, 0);
 			goto skip;
 		case SECCOMP_RET_TRAP:
 			/* Show the handler the original registers. */
-			syscall_rollback(current, task_pt_regs(current));
+			syscall_rollback(current, regs);
 			/* Let the filter pass back 16 bits of data. */
 			seccomp_send_sigsys(this_syscall, data);
 			goto skip;
 		case SECCOMP_RET_TRACE:
 			/* Skip these calls if there is no tracer. */
-			if (!ptrace_event_enabled(current, PTRACE_EVENT_SECCOMP))
+			if (!ptrace_event_enabled(current, PTRACE_EVENT_SECCOMP)) {
+				syscall_set_return_value(current, regs,
+							 -ENOSYS, 0);
 				goto skip;
+			}
 			/* Allow the BPF to provide the event message */
 			ptrace_event(PTRACE_EVENT_SECCOMP, data);
 			/*
@@ -425,6 +429,9 @@ int __secure_computing(int this_syscall)
 			 */
 			if (fatal_signal_pending(current))
 				break;
+			if (syscall_get_nr(current, regs) < 0)
+				goto skip;  /* Explicit request to skip. */
+
 			return 0;
 		case SECCOMP_RET_ALLOW:
 			return 0;
-- 
1.7.7.6

