Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab0EJUkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 16:40:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:56023 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945Ab0EJUj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 16:39:56 -0400
Date: Mon, 10 May 2010 20:39:40 GMT
From: tip-bot for Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, avi@redhat.com
In-Reply-To: <1273135546-29690-2-git-send-email-avi@redhat.com>
References: <1273135546-29690-2-git-send-email-avi@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86: Eliminate TS_XSAVE
Message-ID: <tip-c9ad488289144ae5ef53b012e15895ef1f5e4bb6@git.kernel.org>
Git-Commit-ID: c9ad488289144ae5ef53b012e15895ef1f5e4bb6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 10 May 2010 20:39:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9ad488289144ae5ef53b012e15895ef1f5e4bb6
Gitweb:     http://git.kernel.org/tip/c9ad488289144ae5ef53b012e15895ef1f5e4bb6
Author:     Avi Kivity <avi@redhat.com>
AuthorDate: Thu, 6 May 2010 11:45:45 +0300
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 10 May 2010 10:39:33 -0700

x86: Eliminate TS_XSAVE

The fpu code currently uses current->thread_info->status & TS_XSAVE as
a way to distinguish between XSAVE capable processors and older processors.
The decision is not really task specific; instead we use the task status to
avoid a global memory reference - the value should be the same across all
threads.

Eliminate this tie-in into the task structure by using an alternative
instruction keyed off the XSAVE cpu feature; this results in shorter and
faster code, without introducing a global memory reference.

[ hpa: in the future, this probably should use an asm jmp ]

Signed-off-by: Avi Kivity <avi@redhat.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1273135546-29690-2-git-send-email-avi@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/i387.h        |   20 ++++++++++++++++----
 arch/x86/include/asm/thread_info.h |    1 -
 arch/x86/kernel/cpu/common.c       |    5 +----
 arch/x86/kernel/i387.c             |    5 +----
 arch/x86/kernel/xsave.c            |    6 +++---
 5 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index da29309..a301a68 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -56,6 +56,18 @@ extern int restore_i387_xstate_ia32(void __user *buf);
 
 #define X87_FSW_ES (1 << 7)	/* Exception Summary */
 
+static inline bool use_xsave(void)
+{
+	u8 has_xsave;
+
+	alternative_io("mov $0, %0",
+		       "mov $1, %0",
+		       X86_FEATURE_XSAVE,
+		       "=g"(has_xsave));
+
+	return has_xsave;
+}
+
 #ifdef CONFIG_X86_64
 
 /* Ignore delayed exceptions from user space */
@@ -99,7 +111,7 @@ static inline void clear_fpu_state(struct task_struct *tsk)
 	/*
 	 * xsave header may indicate the init state of the FP.
 	 */
-	if ((task_thread_info(tsk)->status & TS_XSAVE) &&
+	if (use_xsave() &&
 	    !(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
 		return;
 
@@ -164,7 +176,7 @@ static inline void fxsave(struct task_struct *tsk)
 
 static inline void __save_init_fpu(struct task_struct *tsk)
 {
-	if (task_thread_info(tsk)->status & TS_XSAVE)
+	if (use_xsave())
 		xsave(tsk);
 	else
 		fxsave(tsk);
@@ -218,7 +230,7 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
  */
 static inline void __save_init_fpu(struct task_struct *tsk)
 {
-	if (task_thread_info(tsk)->status & TS_XSAVE) {
+	if (use_xsave()) {
 		struct xsave_struct *xstate = &tsk->thread.xstate->xsave;
 		struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
 
@@ -266,7 +278,7 @@ end:
 
 static inline int restore_fpu_checking(struct task_struct *tsk)
 {
-	if (task_thread_info(tsk)->status & TS_XSAVE)
+	if (use_xsave())
 		return xrstor_checking(&tsk->thread.xstate->xsave);
 	else
 		return fxrstor_checking(&tsk->thread.xstate->fxsave);
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e0d2890..e9e3415 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -244,7 +244,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TS_POLLING		0x0004	/* true if in idle loop
 					   and not sleeping */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
-#define TS_XSAVE		0x0010	/* Use xsave/xrstor */
 
 #define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4868e4a..c1c00d0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1243,10 +1243,7 @@ void __cpuinit cpu_init(void)
 	/*
 	 * Force FPU initialization:
 	 */
-	if (cpu_has_xsave)
-		current_thread_info()->status = TS_XSAVE;
-	else
-		current_thread_info()->status = 0;
+	current_thread_info()->status = 0;
 	clear_used_math();
 	mxcsr_feature_mask_init();
 
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 54c31c2..14ca1dc 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -102,10 +102,7 @@ void __cpuinit fpu_init(void)
 
 	mxcsr_feature_mask_init();
 	/* clean state in init */
-	if (cpu_has_xsave)
-		current_thread_info()->status = TS_XSAVE;
-	else
-		current_thread_info()->status = 0;
+	current_thread_info()->status = 0;
 	clear_used_math();
 }
 #endif	/* CONFIG_X86_64 */
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 782c3a3..c1b0a11 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -99,7 +99,7 @@ int save_i387_xstate(void __user *buf)
 		if (err)
 			return err;
 
-		if (task_thread_info(tsk)->status & TS_XSAVE)
+		if (use_xsave())
 			err = xsave_user(buf);
 		else
 			err = fxsave_user(buf);
@@ -116,7 +116,7 @@ int save_i387_xstate(void __user *buf)
 
 	clear_used_math(); /* trigger finit */
 
-	if (task_thread_info(tsk)->status & TS_XSAVE) {
+	if (use_xsave()) {
 		struct _fpstate __user *fx = buf;
 		struct _xstate __user *x = buf;
 		u64 xstate_bv;
@@ -225,7 +225,7 @@ int restore_i387_xstate(void __user *buf)
 		clts();
 		task_thread_info(current)->status |= TS_USEDFPU;
 	}
-	if (task_thread_info(tsk)->status & TS_XSAVE)
+	if (use_xsave())
 		err = restore_user_xstate(buf);
 	else
 		err = fxrstor_checking((__force struct i387_fxsave_struct *)
