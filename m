Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940Ab0GUWhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 18:37:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:42821 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab0GUWhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 18:37:04 -0400
Date: Wed, 21 Jul 2010 22:36:46 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1279731838-1522-2-git-send-email-robert.richter@amd.com>
References: <1279731838-1522-2-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86, xsave: Separate fpu and xsave initialization
Message-ID: <tip-0e49bf66d2ca649b167428adddbbbe9d9bd4894c@git.kernel.org>
Git-Commit-ID: 0e49bf66d2ca649b167428adddbbbe9d9bd4894c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 22:36:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e49bf66d2ca649b167428adddbbbe9d9bd4894c
Gitweb:     http://git.kernel.org/tip/0e49bf66d2ca649b167428adddbbbe9d9bd4894c
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 21 Jul 2010 19:03:52 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 21 Jul 2010 14:06:04 -0700

x86, xsave: Separate fpu and xsave initialization

As xsave also supports other than fpu features, it should be
initialized independently of the fpu. This patch moves this out of fpu
initialization.

There is also a lot of cross referencing between fpu and xsave
code. This patch reduces this by making xsave_cntxt_init() and
init_thread_xstate() static functions.

The patch moves the cpu_has_xsave check at the beginning of
xsave_init(). All other checks may removed then.

Signed-off-by: Robert Richter <robert.richter@amd.com>
LKML-Reference: <1279731838-1522-2-git-send-email-robert.richter@amd.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/i387.h  |    1 -
 arch/x86/include/asm/xsave.h |    1 -
 arch/x86/kernel/cpu/common.c |    2 ++
 arch/x86/kernel/i387.c       |   27 +++++++++++++++++++--------
 arch/x86/kernel/xsave.c      |   10 +++++-----
 5 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 59bd93a..509ddab 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -31,7 +31,6 @@ extern void mxcsr_feature_mask_init(void);
 extern int init_fpu(struct task_struct *child);
 extern asmlinkage void math_state_restore(void);
 extern void __math_state_restore(void);
-extern void init_thread_xstate(void);
 extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 
 extern user_regset_active_fn fpregs_active, xfpregs_active;
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 94d5f84..4d3b5d1 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -28,7 +28,6 @@ extern u64 pcntxt_mask;
 extern struct xsave_struct *init_xstate_buf;
 extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
 
-extern void xsave_cntxt_init(void);
 extern void xsave_init(void);
 extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
 extern int init_fpu(struct task_struct *child);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4056108..94c36c7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1210,6 +1210,7 @@ void __cpuinit cpu_init(void)
 	dbg_restore_debug_regs();
 
 	fpu_init();
+	xsave_init();
 
 	raw_local_save_flags(kernel_eflags);
 
@@ -1270,6 +1271,7 @@ void __cpuinit cpu_init(void)
 	clear_used_math();
 	mxcsr_feature_mask_init();
 
+	fpu_init();
 	xsave_init();
 }
 #endif
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 2f32ef0..e73c54e 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -59,18 +59,18 @@ void __cpuinit mxcsr_feature_mask_init(void)
 	stts();
 }
 
-void __cpuinit init_thread_xstate(void)
+static void __cpuinit init_thread_xstate(void)
 {
+	/*
+	 * Note that xstate_size might be overwriten later during
+	 * xsave_init().
+	 */
+
 	if (!HAVE_HWFP) {
 		xstate_size = sizeof(struct i387_soft_struct);
 		return;
 	}
 
-	if (cpu_has_xsave) {
-		xsave_cntxt_init();
-		return;
-	}
-
 	if (cpu_has_fxsr)
 		xstate_size = sizeof(struct i387_fxsave_struct);
 #ifdef CONFIG_X86_32
@@ -84,6 +84,7 @@ void __cpuinit init_thread_xstate(void)
  * Called at bootup to set up the initial FPU state that is later cloned
  * into all processes.
  */
+
 void __cpuinit fpu_init(void)
 {
 	unsigned long oldcr0 = read_cr0();
@@ -93,14 +94,24 @@ void __cpuinit fpu_init(void)
 
 	write_cr0(oldcr0 & ~(X86_CR0_TS|X86_CR0_EM)); /* clear TS and EM */
 
-	xsave_init();
+	if (!smp_processor_id())
+		init_thread_xstate();
 
 	mxcsr_feature_mask_init();
 	/* clean state in init */
 	current_thread_info()->status = 0;
 	clear_used_math();
 }
-#endif	/* CONFIG_X86_64 */
+
+#else	/* CONFIG_X86_64 */
+
+void __cpuinit fpu_init(void)
+{
+	if (!smp_processor_id())
+		init_thread_xstate();
+}
+
+#endif	/* CONFIG_X86_32 */
 
 static void fpu_finit(struct fpu *fpu)
 {
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index ab9ad48..550bf45 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -362,9 +362,6 @@ unsigned int sig_xstate_size = sizeof(struct _fpstate);
  */
 static void __cpuinit __xsave_init(void)
 {
-	if (!cpu_has_xsave)
-		return;
-
 	set_in_cr4(X86_CR4_OSXSAVE);
 
 	/*
@@ -429,7 +426,7 @@ static void __init setup_xstate_init(void)
 /*
  * Enable and initialize the xsave feature.
  */
-void __ref xsave_cntxt_init(void)
+static void __cpuinit xsave_cntxt_init(void)
 {
 	unsigned int eax, ebx, ecx, edx;
 
@@ -466,10 +463,13 @@ void __ref xsave_cntxt_init(void)
 
 void __cpuinit xsave_init(void)
 {
+	if (!cpu_has_xsave)
+		return;
+
 	/*
 	 * Boot processor to setup the FP and extended state context info.
 	 */
 	if (!smp_processor_id())
-		init_thread_xstate();
+		xsave_cntxt_init();
 	__xsave_init();
 }
