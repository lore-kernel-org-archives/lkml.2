Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab2BTAUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:20:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57384 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2BTAUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:20:42 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 26/30] x32: Signal-related system calls
Date: Sun, 19 Feb 2012 16:08:04 -0800
Message-Id: <1329696488-16970-27-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:20:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

x32 uses the 64-bit signal frame format, obviously, but there are some
structures which mixes that with pointers or sizeof(long) types, as
such we have to create a handful of system calls specific to x32.  By
and large these are a mixture of the 64-bit and the compat system
calls.

Originally-by: H. J. Lu <hjl.tools@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/entry_64.S |   19 +++++++
 arch/x86/kernel/signal.c   |  118 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 136 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index a17b342..53dc821 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -746,6 +746,25 @@ ENTRY(stub_rt_sigreturn)
 	CFI_ENDPROC
 END(stub_rt_sigreturn)
 
+#ifdef CONFIG_X86_X32_ABI
+	PTREGSCALL stub_x32_sigaltstack, sys32_sigaltstack, %rdx
+
+ENTRY(stub_x32_rt_sigreturn)
+	CFI_STARTPROC
+	addq $8, %rsp
+	PARTIAL_FRAME 0
+	SAVE_REST
+	movq %rsp,%rdi
+	FIXUP_TOP_OF_STACK %r11
+	call sys32_x32_rt_sigreturn
+	movq %rax,RAX(%rsp) # fixme, this could be done at the higher layer
+	RESTORE_REST
+	jmp int_ret_from_sys_call
+	CFI_ENDPROC
+END(stub_x32_rt_sigreturn)
+
+#endif
+
 /*
  * Build the entry stubs and pointer table with some assembler magic.
  * We pack 7 stubs into a single 32-byte chunk, which will fit in a
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 450fb25..c3846b6 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -29,6 +29,7 @@
 #ifdef CONFIG_X86_64
 #include <asm/proto.h>
 #include <asm/ia32_unistd.h>
+#include <asm/sys_ia32.h>
 #endif /* CONFIG_X86_64 */
 
 #include <asm/syscall.h>
@@ -632,6 +633,16 @@ static int signr_convert(int sig)
 #define is_ia32	0
 #endif /* CONFIG_IA32_EMULATION */
 
+#ifdef CONFIG_X86_X32_ABI
+#define is_x32	test_thread_flag(TIF_X32)
+
+static int x32_setup_rt_frame(int sig, struct k_sigaction *ka,
+			      siginfo_t *info, compat_sigset_t *set,
+			      struct pt_regs *regs);
+#else /* !CONFIG_X86_X32_ABI */
+#define is_x32	0
+#endif /* CONFIG_X86_X32_ABI */
+
 int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		sigset_t *set, struct pt_regs *regs);
 int ia32_setup_frame(int sig, struct k_sigaction *ka,
@@ -656,8 +667,14 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 			ret = ia32_setup_rt_frame(usig, ka, info, set, regs);
 		else
 			ret = ia32_setup_frame(usig, ka, set, regs);
-	} else
+#ifdef CONFIG_X86_X32_ABI
+	} else if (is_x32) {
+		ret = x32_setup_rt_frame(usig, ka, info,
+					 (compat_sigset_t *)set, regs);
+#endif
+	} else {
 		ret = __setup_rt_frame(sig, ka, info, set, regs);
+	}
 
 	if (ret) {
 		force_sigsegv(sig, current);
@@ -840,3 +857,102 @@ void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
 
 	force_sig(SIGSEGV, me);
 }
+
+#ifdef CONFIG_X86_X32_ABI
+static int x32_setup_rt_frame(int sig, struct k_sigaction *ka,
+			      siginfo_t *info, compat_sigset_t *set,
+			      struct pt_regs *regs)
+{
+	struct rt_sigframe_x32 __user *frame;
+	void __user *restorer;
+	int err = 0;
+	void __user *fpstate = NULL;
+
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
+
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+		return -EFAULT;
+
+	if (ka->sa.sa_flags & SA_SIGINFO) {
+		if (copy_siginfo_to_user32(&frame->info, info))
+			return -EFAULT;
+	}
+
+	put_user_try {
+		/* Create the ucontext.  */
+		if (cpu_has_xsave)
+			put_user_ex(UC_FP_XSTATE, &frame->uc.uc_flags);
+		else
+			put_user_ex(0, &frame->uc.uc_flags);
+		put_user_ex(0, &frame->uc.uc_link);
+		put_user_ex(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
+		put_user_ex(sas_ss_flags(regs->sp),
+			    &frame->uc.uc_stack.ss_flags);
+		put_user_ex(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
+		put_user_ex(0, &frame->uc.uc__pad0);
+		err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
+					regs, set->sig[0]);
+		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
+		if (ka->sa.sa_flags & SA_RESTORER) {
+			restorer = ka->sa.sa_restorer;
+		} else {
+			/* could use a vstub here */
+			restorer = NULL;
+			err |= -EFAULT;
+		}
+		put_user_ex(restorer, &frame->pretcode);
+	} put_user_catch(err);
+
+	if (err)
+		return -EFAULT;
+
+	/* Set up registers for signal handler */
+	regs->sp = (unsigned long) frame;
+	regs->ip = (unsigned long) ka->sa.sa_handler;
+
+	/* We use the x32 calling convention here... */
+	regs->di = sig;
+	regs->si = (unsigned long) &frame->info;
+	regs->dx = (unsigned long) &frame->uc;
+
+	loadsegment(ds, __USER_DS);
+	loadsegment(es, __USER_DS);
+
+	regs->cs = __USER_CS;
+	regs->ss = __USER_DS;
+
+	return 0;
+}
+
+asmlinkage long sys32_x32_rt_sigreturn(struct pt_regs *regs)
+{
+	struct rt_sigframe_x32 __user *frame;
+	sigset_t set;
+	unsigned long ax;
+	struct pt_regs tregs;
+
+	frame = (struct rt_sigframe_x32 __user *)(regs->sp - 8);
+
+	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
+		goto badframe;
+
+	sigdelsetmask(&set, ~_BLOCKABLE);
+	set_current_blocked(&set);
+
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
+		goto badframe;
+
+	tregs = *regs;
+	if (sys32_sigaltstack(&frame->uc.uc_stack, NULL, &tregs) == -EFAULT)
+		goto badframe;
+
+	return ax;
+
+badframe:
+	signal_fault(regs, frame, "x32 rt_sigreturn");
+	return 0;
+}
+#endif
-- 
1.7.6.5

