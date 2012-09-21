Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab2IUUHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:07:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50946 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778Ab2IUUHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:07:16 -0400
Date: Fri, 21 Sep 2012 13:07:04 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-5e88353d8b5f483bc1c873ad24ac2b59a6b66c73@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1348256595-29119-12-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-12-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/smap] x86, smap:
  Reduce the SMAP overhead for signal handling
Git-Commit-ID: 5e88353d8b5f483bc1c873ad24ac2b59a6b66c73
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 21 Sep 2012 13:07:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e88353d8b5f483bc1c873ad24ac2b59a6b66c73
Gitweb:     http://git.kernel.org/tip/5e88353d8b5f483bc1c873ad24ac2b59a6b66c73
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 21 Sep 2012 12:43:15 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 21 Sep 2012 12:45:27 -0700

x86, smap: Reduce the SMAP overhead for signal handling

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
Link: http://lkml.kernel.org/r/1348256595-29119-12-git-send-email-hpa@linux.intel.com
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
 
