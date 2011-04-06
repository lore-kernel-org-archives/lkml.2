Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab1DFWEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:04:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:45664 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab1DFWEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:04:08 -0400
Date: Wed, 6 Apr 2011 22:03:55 GMT
From: tip-bot for Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel@vger.kernel.org, hans.rosenfeld@amd.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, hans.rosenfeld@amd.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: 1302018656-586370-2-git-send-email-hans.rosenfeld@amd.com
References: 1302018656-586370-2-git-send-email-hans.rosenfeld@amd.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86, xsave: cleanup fpu/xsave support
Message-ID: <tip-26bce4e4c56f5929f96a4b82e7eb10ec2f61998d@git.kernel.org>
Git-Commit-ID: 26bce4e4c56f5929f96a4b82e7eb10ec2f61998d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 06 Apr 2011 22:03:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26bce4e4c56f5929f96a4b82e7eb10ec2f61998d
Gitweb:     http://git.kernel.org/tip/26bce4e4c56f5929f96a4b82e7eb10ec2f61998d
Author:     Hans Rosenfeld <hans.rosenfeld@amd.com>
AuthorDate: Tue, 5 Apr 2011 17:50:49 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 6 Apr 2011 14:15:16 -0700

x86, xsave: cleanup fpu/xsave support

Removed the functions fpu_fxrstor_checking() and restore_fpu_checking()
because they weren't doing anything. Removed redundant xsave/xrstor
implementations. Since xsave/xrstor is not specific to the FPU, and also
for consistency, all xsave/xrstor functions now take a xsave_struct
argument.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
Link: http://lkml.kernel.org/r/1302018656-586370-2-git-send-email-hans.rosenfeld@amd.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/i387.h  |   20 +++-------
 arch/x86/include/asm/xsave.h |   81 +++++++++++++++---------------------------
 arch/x86/kernel/traps.c      |    2 +-
 arch/x86/kernel/xsave.c      |    4 +-
 4 files changed, 38 insertions(+), 69 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index ef32890..d908383 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -227,12 +227,14 @@ static inline void fpu_fxsave(struct fpu *fpu)
 static inline void fpu_save_init(struct fpu *fpu)
 {
 	if (use_xsave()) {
-		fpu_xsave(fpu);
+		struct xsave_struct *xstate = &fpu->state->xsave;
+
+		fpu_xsave(xstate);
 
 		/*
 		 * xsave header may indicate the init state of the FP.
 		 */
-		if (!(fpu->state->xsave.xsave_hdr.xstate_bv & XSTATE_FP))
+		if (!(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
 			return;
 	} else if (use_fxsr()) {
 		fpu_fxsave(fpu);
@@ -262,22 +264,12 @@ static inline void __save_init_fpu(struct task_struct *tsk)
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
-static inline int fpu_fxrstor_checking(struct fpu *fpu)
-{
-	return fxrstor_checking(&fpu->state->fxsave);
-}
-
 static inline int fpu_restore_checking(struct fpu *fpu)
 {
 	if (use_xsave())
-		return fpu_xrstor_checking(fpu);
+		return xrstor_checking(&fpu->state->xsave, -1);
 	else
-		return fpu_fxrstor_checking(fpu);
-}
-
-static inline int restore_fpu_checking(struct task_struct *tsk)
-{
-	return fpu_restore_checking(&tsk->thread.fpu);
+		return fxrstor_checking(&fpu->state->fxsave);
 }
 
 /*
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index c6ce245..8bcbbce 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -42,10 +42,11 @@ extern int check_for_xstate(struct i387_fxsave_struct __user *buf,
 			    void __user *fpstate,
 			    struct _fpx_sw_bytes *sw);
 
-static inline int fpu_xrstor_checking(struct fpu *fpu)
+static inline int xrstor_checking(struct xsave_struct *fx, u64 mask)
 {
-	struct xsave_struct *fx = &fpu->state->xsave;
 	int err;
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
 
 	asm volatile("1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
 		     "2:\n"
@@ -55,13 +56,23 @@ static inline int fpu_xrstor_checking(struct fpu *fpu)
 		     ".previous\n"
 		     _ASM_EXTABLE(1b, 3b)
 		     : [err] "=r" (err)
-		     : "D" (fx), "m" (*fx), "a" (-1), "d" (-1), "0" (0)
+		     : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask), "0" (0)
 		     : "memory");
 
 	return err;
 }
 
-static inline int xsave_user(struct xsave_struct __user *buf)
+static inline void xrstor_state(struct xsave_struct *fx, u64 mask)
+{
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+
+	asm volatile(".byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
+		     : : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+		     :   "memory");
+}
+
+static inline int xsave_checking(struct xsave_struct __user *buf)
 {
 	int err;
 
@@ -74,58 +85,24 @@ static inline int xsave_user(struct xsave_struct __user *buf)
 	if (unlikely(err))
 		return -EFAULT;
 
-	__asm__ __volatile__("1: .byte " REX_PREFIX "0x0f,0xae,0x27\n"
-			     "2:\n"
-			     ".section .fixup,\"ax\"\n"
-			     "3:  movl $-1,%[err]\n"
-			     "    jmp  2b\n"
-			     ".previous\n"
-			     ".section __ex_table,\"a\"\n"
-			     _ASM_ALIGN "\n"
-			     _ASM_PTR "1b,3b\n"
-			     ".previous"
-			     : [err] "=r" (err)
-			     : "D" (buf), "a" (-1), "d" (-1), "0" (0)
-			     : "memory");
+	asm volatile("1: .byte " REX_PREFIX "0x0f,0xae,0x27\n"
+		     "2:\n"
+		     ".section .fixup,\"ax\"\n"
+		     "3:  movl $-1,%[err]\n"
+		     "    jmp  2b\n"
+		     ".previous\n"
+		     _ASM_EXTABLE(1b,3b)
+		     : [err] "=r" (err)
+		     : "D" (buf), "a" (-1), "d" (-1), "0" (0)
+		     : "memory");
+
 	if (unlikely(err) && __clear_user(buf, xstate_size))
 		err = -EFAULT;
-	/* No need to clear here because the caller clears USED_MATH */
-	return err;
-}
-
-static inline int xrestore_user(struct xsave_struct __user *buf, u64 mask)
-{
-	int err;
-	struct xsave_struct *xstate = ((__force struct xsave_struct *)buf);
-	u32 lmask = mask;
-	u32 hmask = mask >> 32;
 
-	__asm__ __volatile__("1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n"
-			     "2:\n"
-			     ".section .fixup,\"ax\"\n"
-			     "3:  movl $-1,%[err]\n"
-			     "    jmp  2b\n"
-			     ".previous\n"
-			     ".section __ex_table,\"a\"\n"
-			     _ASM_ALIGN "\n"
-			     _ASM_PTR "1b,3b\n"
-			     ".previous"
-			     : [err] "=r" (err)
-			     : "D" (xstate), "a" (lmask), "d" (hmask), "0" (0)
-			     : "memory");	/* memory required? */
+	/* No need to clear here because the caller clears USED_MATH */
 	return err;
 }
 
-static inline void xrstor_state(struct xsave_struct *fx, u64 mask)
-{
-	u32 lmask = mask;
-	u32 hmask = mask >> 32;
-
-	asm volatile(".byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
-		     : : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
-		     :   "memory");
-}
-
 static inline void xsave_state(struct xsave_struct *fx, u64 mask)
 {
 	u32 lmask = mask;
@@ -136,7 +113,7 @@ static inline void xsave_state(struct xsave_struct *fx, u64 mask)
 		     :   "memory");
 }
 
-static inline void fpu_xsave(struct fpu *fpu)
+static inline void fpu_xsave(struct xsave_struct *fx)
 {
 	/* This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
@@ -144,7 +121,7 @@ static inline void fpu_xsave(struct fpu *fpu)
 		".byte " REX_PREFIX "0x0f,0xae,0x27",
 		".byte " REX_PREFIX "0x0f,0xae,0x37",
 		X86_FEATURE_XSAVEOPT,
-		[fx] "D" (&fpu->state->xsave), "a" (-1), "d" (-1) :
+		[fx] "D" (fx), "a" (-1), "d" (-1) :
 		"memory");
 }
 #endif
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b9b6716..32f3043 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -728,7 +728,7 @@ void __math_state_restore(void)
 	/*
 	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
 	 */
-	if (unlikely(restore_fpu_checking(tsk))) {
+	if (unlikely(fpu_restore_checking(&tsk->thread.fpu))) {
 		stts();
 		force_sig(SIGSEGV, tsk);
 		return;
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index a391134..6b063d7 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -170,7 +170,7 @@ int save_i387_xstate(void __user *buf)
 
 	if (task_thread_info(tsk)->status & TS_USEDFPU) {
 		if (use_xsave())
-			err = xsave_user(buf);
+			err = xsave_checking(buf);
 		else
 			err = fxsave_user(buf);
 
@@ -247,7 +247,7 @@ static int restore_user_xstate(void __user *buf)
 	/*
 	 * restore the state passed by the user.
 	 */
-	err = xrestore_user(buf, mask);
+	err = xrstor_checking((__force struct xsave_struct *)buf, mask);
 	if (err)
 		return err;
 
