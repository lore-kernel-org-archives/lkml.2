Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab2IUTni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:43:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:26130 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638Ab2IUTnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:43:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,464,1344236400"; 
   d="scan'208";a="225202023"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 11/11] x86, smap: Reduce the SMAP overhead for signal handling
Date: Fri, 21 Sep 2012 12:43:15 -0700
Message-Id: <1348256595-29119-12-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Signal handling contains a bunch of accesses to individual user space
items, which causes an excessive number of STAC and CLAC
instructions.  Instead, let get/put_user_try ... get/put_user_catch()
contain the STAC and CLAC instructions.

This means that get/put_user_try no longer nests, and furthermore that
it is no longer legal to use user space access functions other than
__get/put_user_ex() inside those blocks.  However, these macros are
x86-specific anyway and are only used in the signal-handling paths; a
simple reordering of moving the larger subroutine calls out of the
try...catch blocks resolves that problem.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/ia32/ia32_signal.c    |   12 +++++++-----
 arch/x86/include/asm/uaccess.h |   14 ++++++--------
 arch/x86/kernel/signal.c       |   24 ++++++++++++++----------
 3 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 673ac9b..05e62a3 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -250,11 +250,12 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 
 		get_user_ex(tmp, &sc->fpstate);
 		buf = compat_ptr(tmp);
-		err |= restore_i387_xstate_ia32(buf);
 
 		get_user_ex(*pax, &sc->ax);
 	} get_user_catch(err);
 
+	err |= restore_i387_xstate_ia32(buf);
+
 	return err;
 }
 
@@ -502,7 +503,6 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		put_user_ex(sig, &frame->sig);
 		put_user_ex(ptr_to_compat(&frame->info), &frame->pinfo);
 		put_user_ex(ptr_to_compat(&frame->uc), &frame->puc);
-		err |= copy_siginfo_to_user32(&frame->info, info);
 
 		/* Create the ucontext.  */
 		if (cpu_has_xsave)
@@ -514,9 +514,6 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		put_user_ex(sas_ss_flags(regs->sp),
 			    &frame->uc.uc_stack.ss_flags);
 		put_user_ex(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
-		err |= ia32_setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
-					     regs, set->sig[0]);
-		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
 		if (ka->sa.sa_flags & SA_RESTORER)
 			restorer = ka->sa.sa_restorer;
@@ -532,6 +529,11 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		put_user_ex(*((u64 *)&code), (u64 *)frame->retcode);
 	} put_user_catch(err);
 
+	err |= copy_siginfo_to_user32(&frame->info, info);
+	err |= ia32_setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
+				     regs, set->sig[0]);
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
 	if (err)
 		return -EFAULT;
 
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index b92ece1..a91acfb 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -416,9 +416,8 @@ do {									\
 } while (0)
 
 #define __get_user_asm_ex(x, addr, itype, rtype, ltype)			\
-	asm volatile(ASM_STAC "\n"					\
-		     "1:	mov"itype" %1,%"rtype"0\n"		\
-		     "2: " ASM_CLAC "\n"				\
+	asm volatile("1:	mov"itype" %1,%"rtype"0\n"		\
+		     "2:\n"						\
 		     _ASM_EXTABLE_EX(1b, 2b)				\
 		     : ltype(x) : "m" (__m(addr)))
 
@@ -460,9 +459,8 @@ struct __large_struct { unsigned long buf[100]; };
 		     : ltype(x), "m" (__m(addr)), "i" (errret), "0" (err))
 
 #define __put_user_asm_ex(x, addr, itype, rtype, ltype)			\
-	asm volatile(ASM_STAC "\n"					\
-		     "1:	mov"itype" %"rtype"0,%1\n"		\
-		     "2: " ASM_CLAC "\n"				\
+	asm volatile("1:	mov"itype" %"rtype"0,%1\n"		\
+		     "2:\n"						\
 		     _ASM_EXTABLE_EX(1b, 2b)				\
 		     : : ltype(x), "m" (__m(addr)))
 
@@ -470,13 +468,13 @@ struct __large_struct { unsigned long buf[100]; };
  * uaccess_try and catch
  */
 #define uaccess_try	do {						\
-	int prev_err = current_thread_info()->uaccess_err;		\
 	current_thread_info()->uaccess_err = 0;				\
+	stac();								\
 	barrier();
 
 #define uaccess_catch(err)						\
+	clac();								\
 	(err) |= (current_thread_info()->uaccess_err ? -EFAULT : 0);	\
-	current_thread_info()->uaccess_err = prev_err;			\
 } while (0)
 
 /**
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index b280908..9326128 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -114,11 +114,12 @@ int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 		regs->orig_ax = -1;		/* disable syscall checks */
 
 		get_user_ex(buf, &sc->fpstate);
-		err |= restore_i387_xstate(buf);
 
 		get_user_ex(*pax, &sc->ax);
 	} get_user_catch(err);
 
+	err |= restore_i387_xstate(buf);
+
 	return err;
 }
 
@@ -357,7 +358,6 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		put_user_ex(sig, &frame->sig);
 		put_user_ex(&frame->info, &frame->pinfo);
 		put_user_ex(&frame->uc, &frame->puc);
-		err |= copy_siginfo_to_user(&frame->info, info);
 
 		/* Create the ucontext.  */
 		if (cpu_has_xsave)
@@ -369,9 +369,6 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		put_user_ex(sas_ss_flags(regs->sp),
 			    &frame->uc.uc_stack.ss_flags);
 		put_user_ex(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
-		err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
-					regs, set->sig[0]);
-		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
 		/* Set up to return from userspace.  */
 		restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
@@ -389,6 +386,11 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		put_user_ex(*((u64 *)&rt_retcode), (u64 *)frame->retcode);
 	} put_user_catch(err);
 
+	err |= copy_siginfo_to_user(&frame->info, info);
+	err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
+				regs, set->sig[0]);
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
 	if (err)
 		return -EFAULT;
 
@@ -436,8 +438,6 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		put_user_ex(sas_ss_flags(regs->sp),
 			    &frame->uc.uc_stack.ss_flags);
 		put_user_ex(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
-		err |= setup_sigcontext(&frame->uc.uc_mcontext, fp, regs, set->sig[0]);
-		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
 		/* Set up to return from userspace.  If provided, use a stub
 		   already in userspace.  */
@@ -450,6 +450,9 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		}
 	} put_user_catch(err);
 
+	err |= setup_sigcontext(&frame->uc.uc_mcontext, fp, regs, set->sig[0]);
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
 	if (err)
 		return -EFAULT;
 
@@ -855,9 +858,6 @@ static int x32_setup_rt_frame(int sig, struct k_sigaction *ka,
 			    &frame->uc.uc_stack.ss_flags);
 		put_user_ex(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
 		put_user_ex(0, &frame->uc.uc__pad0);
-		err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
-					regs, set->sig[0]);
-		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
 		if (ka->sa.sa_flags & SA_RESTORER) {
 			restorer = ka->sa.sa_restorer;
@@ -869,6 +869,10 @@ static int x32_setup_rt_frame(int sig, struct k_sigaction *ka,
 		put_user_ex(restorer, &frame->pretcode);
 	} put_user_catch(err);
 
+	err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
+				regs, set->sig[0]);
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
 	if (err)
 		return -EFAULT;
 
-- 
1.7.6.5

