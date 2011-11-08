Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1KHAeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 19:34:09 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46589 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1KHAeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 19:34:06 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 1/2] x86-64: Set siginfo and context on vsyscall emulation faults
Date: Mon,  7 Nov 2011 16:33:40 -0800
Message-Id: <4c8f91de7ec5cd2ef0f59521a04e1015f11e42b4.1320712291.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <cover.1320712291.git.luto@amacapital.net>
References: <CALCETrXAiHs9PyziHBm-gZRiyahYafbxxUSxJUcFh=a-0th0EQ@mail.gmail.com>
 <cover.1320712291.git.luto@amacapital.net>
In-Reply-To: <cover.1320712291.git.luto@amacapital.net>
References: <cover.1320712291.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make this work, we teach the page fault handler how to send
signals on failed uaccess.  This only works for user addresses
(kernel addresses will never hit the page fault handler in the
first place), so we need to generate signals for those
separately.

This gets the tricky case right: if the user buffer spans
multiple pages and only the second page is invalid, we set
cr2 and si_addr correctly.  UML relies on this behavior to
"fault in" pages as needed.

We steal a bit from thread_info.uaccess_err to enable this.
Before this change, uaccess_err was a 32-bit boolean value.

This fixes issues with UML when vsyscall=emulate.

Reported-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/thread_info.h |    3 +-
 arch/x86/include/asm/uaccess.h     |    2 +-
 arch/x86/kernel/vsyscall_64.c      |   75 ++++++++++++++++++++++++++++++++----
 arch/x86/mm/extable.c              |    2 +-
 arch/x86/mm/fault.c                |   22 ++++++++---
 5 files changed, 87 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index a1fe5c1..25ebd79 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -40,7 +40,8 @@ struct thread_info {
 						*/
 	__u8			supervisor_stack[0];
 #endif
-	int			uaccess_err;
+	int			sig_on_uaccess_error:1;
+	int			uaccess_err:1;	/* uaccess failed */
 };
 
 #define INIT_THREAD_INFO(tsk)			\
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 36361bf..8be5f54 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -462,7 +462,7 @@ struct __large_struct { unsigned long buf[100]; };
 	barrier();
 
 #define uaccess_catch(err)						\
-	(err) |= current_thread_info()->uaccess_err;			\
+	(err) |= (current_thread_info()->uaccess_err ? -EFAULT : 0);	\
 	current_thread_info()->uaccess_err = prev_err;			\
 } while (0)
 
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index b56c65de..9b05546 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -139,11 +139,40 @@ static int addr_to_vsyscall_nr(unsigned long addr)
 	return nr;
 }
 
+static bool write_ok_or_segv(unsigned long ptr, size_t size)
+{
+	/*
+	 * XXX: if access_ok, get_user, and put_user handled
+	 * sig_on_uaccess_error, this could go away.
+	 */
+
+	if (!access_ok(VERIFY_WRITE, (void __user *)ptr, size)) {
+		siginfo_t info;
+		struct thread_struct *thread = &current->thread;
+
+		thread->error_code	= 6;  /* user fault, no page, write */
+		thread->cr2		= ptr;
+		thread->trap_no		= 14;
+
+		memset(&info, 0, sizeof(info));
+		info.si_signo		= SIGSEGV;
+		info.si_errno		= 0;
+		info.si_code		= SEGV_MAPERR;
+		info.si_addr		= (void __user *)ptr;
+
+		force_sig_info(SIGSEGV, &info, current);
+		return false;
+	} else {
+		return true;
+	}
+}
+
 bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 {
 	struct task_struct *tsk;
 	unsigned long caller;
 	int vsyscall_nr;
+	int prev_sig_on_uaccess_error;
 	long ret;
 
 	/*
@@ -179,35 +208,65 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 	if (seccomp_mode(&tsk->seccomp))
 		do_exit(SIGKILL);
 
+	/*
+	 * With a real vsyscall, page faults cause SIGSEGV.  We want to
+	 * preserve that behavior to make writing exploits harder.
+	 */
+	prev_sig_on_uaccess_error = current_thread_info()->sig_on_uaccess_error;
+	current_thread_info()->sig_on_uaccess_error = 1;
+
+	/*
+	 * 0 is a valid user pointer (in the access_ok sense) on 32-bit and
+	 * 64-bit, so we don't need to special-case it here.  For all the
+	 * vsyscalls, 0 means "don't write anything" not "write it at
+	 * address 0".
+	 */
+	ret = -EFAULT;
 	switch (vsyscall_nr) {
 	case 0:
+		if (!write_ok_or_segv(regs->di, sizeof(struct timeval)) ||
+		    !write_ok_or_segv(regs->si, sizeof(struct timezone)))
+			break;
+
 		ret = sys_gettimeofday(
 			(struct timeval __user *)regs->di,
 			(struct timezone __user *)regs->si);
 		break;
 
 	case 1:
+		if (!write_ok_or_segv(regs->di, sizeof(time_t)))
+			break;
+
 		ret = sys_time((time_t __user *)regs->di);
 		break;
 
 	case 2:
+		if (!write_ok_or_segv(regs->di, sizeof(unsigned)) ||
+		    !write_ok_or_segv(regs->si, sizeof(unsigned)))
+			break;
+
 		ret = sys_getcpu((unsigned __user *)regs->di,
 				 (unsigned __user *)regs->si,
 				 0);
 		break;
 	}
 
+	current_thread_info()->sig_on_uaccess_error = prev_sig_on_uaccess_error;
+
 	if (ret == -EFAULT) {
-		/*
-		 * Bad news -- userspace fed a bad pointer to a vsyscall.
-		 *
-		 * With a real vsyscall, that would have caused SIGSEGV.
-		 * To make writing reliable exploits using the emulated
-		 * vsyscalls harder, generate SIGSEGV here as well.
-		 */
+		/* Bad news -- userspace fed a bad pointer to a vsyscall. */
 		warn_bad_vsyscall(KERN_INFO, regs,
 				  "vsyscall fault (exploit attempt?)");
-		goto sigsegv;
+
+		/*
+		 * If we failed to generate a signal for any reason,
+		 * generate one here.  (This should be impossible.)
+		 */
+		if (WARN_ON_ONCE(!sigismember(&tsk->pending.signal, SIGBUS) &&
+				 !sigismember(&tsk->pending.signal, SIGSEGV)))
+			goto sigsegv;
+
+		return true;  /* Don't emulate the ret. */
 	}
 
 	regs->ax = ret;
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index d0474ad..1fb85db 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -25,7 +25,7 @@ int fixup_exception(struct pt_regs *regs)
 	if (fixup) {
 		/* If fixup is less than 16, it means uaccess error */
 		if (fixup->fixup < 16) {
-			current_thread_info()->uaccess_err = -EFAULT;
+			current_thread_info()->uaccess_err = 1;
 			regs->ip += fixup->fixup;
 			return 1;
 		}
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 0d17c8c..85bec26 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -620,7 +620,7 @@ pgtable_bad(struct pt_regs *regs, unsigned long error_code,
 
 static noinline void
 no_context(struct pt_regs *regs, unsigned long error_code,
-	   unsigned long address)
+	   unsigned long address, int signal, int si_code)
 {
 	struct task_struct *tsk = current;
 	unsigned long *stackend;
@@ -628,8 +628,17 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 	int sig;
 
 	/* Are we prepared to handle this kernel fault? */
-	if (fixup_exception(regs))
+	if (fixup_exception(regs)) {
+		if (current_thread_info()->sig_on_uaccess_error && signal) {
+			tsk->thread.trap_no = 14;
+			tsk->thread.error_code = error_code | PF_USER;
+			tsk->thread.cr2 = address;
+
+			/* XXX: hwpoison faults will set the wrong code. */
+			force_sig_info_fault(signal, si_code, address, tsk, 0);
+		}
 		return;
+	}
 
 	/*
 	 * 32-bit:
@@ -749,7 +758,7 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
 	if (is_f00f_bug(regs, address))
 		return;
 
-	no_context(regs, error_code, address);
+	no_context(regs, error_code, address, SIGSEGV, si_code);
 }
 
 static noinline void
@@ -813,7 +822,7 @@ do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
 
 	/* Kernel mode? Handle exceptions or die: */
 	if (!(error_code & PF_USER)) {
-		no_context(regs, error_code, address);
+		no_context(regs, error_code, address, SIGBUS, BUS_ADRERR);
 		return;
 	}
 
@@ -848,7 +857,7 @@ mm_fault_error(struct pt_regs *regs, unsigned long error_code,
 		if (!(fault & VM_FAULT_RETRY))
 			up_read(&current->mm->mmap_sem);
 		if (!(error_code & PF_USER))
-			no_context(regs, error_code, address);
+			no_context(regs, error_code, address, 0, 0);
 		return 1;
 	}
 	if (!(fault & VM_FAULT_ERROR))
@@ -858,7 +867,8 @@ mm_fault_error(struct pt_regs *regs, unsigned long error_code,
 		/* Kernel mode? Handle exceptions or die: */
 		if (!(error_code & PF_USER)) {
 			up_read(&current->mm->mmap_sem);
-			no_context(regs, error_code, address);
+			no_context(regs, error_code, address,
+				   SIGSEGV, SEGV_MAPERR);
 			return 1;
 		}
 
-- 
1.7.6.4

