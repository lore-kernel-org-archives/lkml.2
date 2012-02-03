Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2BCIaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 03:30:16 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37476 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab2BCIaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 03:30:15 -0500
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Mohd. Faris" <mohdfarisq2010@gmail.com>,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] arm: vfp: Raising SIGFPE on invalid floating point operation
Date: Fri,  3 Feb 2012 14:06:24 +0530
Message-Id: <1328258184-23082-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a lot of ARM/VFP hardware which does not invoke the
undefined instruction exception handler (i.e. __und_usr) at all
even in case of an invalid floating point operation in usermode.
For example, 100.0 divided by 0.0 will not lead to the undefined
instruction exception being called by the processor although the
hardware does reliably set the DZC bit in the FPSCR.

Currently, the usermode code will simply proceed to execute without
the SIGFPE signal being raised on that process thus limiting the
developer's knowledge of what really went wrong in his code logic.

This patch enables the kernel to raise the SIGFPE signal when the
faulting thread next calls schedule() in any of the following ways:
- When the thread is interrupted by IRQ
- When the thread calls a system call
- When the thread encounters exception

Although the SIGFPE is not delivered at the exact faulting instruction,
this patch at least allows the system to handle FPU exception scenarios
in a more generic "Linux/Unix" manner.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Signed-off-by: Mohd. Faris <mohdfarisq2010@gmail.com>
---
 arch/arm/include/asm/vfp.h |    2 ++
 arch/arm/vfp/vfpmodule.c   |   15 ++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/vfp.h b/arch/arm/include/asm/vfp.h
index f4ab34f..a37c265 100644
--- a/arch/arm/include/asm/vfp.h
+++ b/arch/arm/include/asm/vfp.h
@@ -71,6 +71,8 @@
 #define FPSCR_UFC		(1<<3)
 #define FPSCR_IXC		(1<<4)
 #define FPSCR_IDC		(1<<7)
+#define FPSCR_CUMULATIVE_EXCEPTION_MASK	\
+		(FPSCR_IOC|FPSCR_DZC|FPSCR_OFC|FPSCR_UFC|FPSCR_IXC|FPSCR_IDC)
 
 /* MVFR0 bits */
 #define MVFR0_A_SIMD_BIT	(0)
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 8f3ccdd..39824a1 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -52,6 +52,8 @@ unsigned int VFP_arch;
  */
 union vfp_state *vfp_current_hw_state[NR_CPUS];
 
+static void vfp_raise_sigfpe(unsigned int, struct pt_regs *);
+
 /*
  * Is 'thread's most up to date state stored in this CPUs hardware?
  * Must be called from non-preemptible context.
@@ -72,8 +74,13 @@ static bool vfp_state_in_hw(unsigned int cpu, struct thread_info *thread)
  */
 static void vfp_force_reload(unsigned int cpu, struct thread_info *thread)
 {
+	unsigned int fpexc = fmrx(FPEXC);
+
 	if (vfp_state_in_hw(cpu, thread)) {
-		fmxr(FPEXC, fmrx(FPEXC) & ~FPEXC_EN);
+		if ((fpexc & FPEXC_EN) &&
+			(fmrx(FPSCR) & FPSCR_CUMULATIVE_EXCEPTION_MASK))
+			vfp_raise_sigfpe(0, task_pt_regs(current));
+		fmxr(FPEXC, fpexc & ~FPEXC_EN);
 		vfp_current_hw_state[cpu] = NULL;
 	}
 #ifdef CONFIG_SMP
@@ -100,6 +107,8 @@ static void vfp_thread_flush(struct thread_info *thread)
 	cpu = get_cpu();
 	if (vfp_current_hw_state[cpu] == vfp)
 		vfp_current_hw_state[cpu] = NULL;
+	if (fmrx(FPSCR) & FPSCR_CUMULATIVE_EXCEPTION_MASK)
+		vfp_raise_sigfpe(0, task_pt_regs(current));
 	fmxr(FPEXC, fmrx(FPEXC) & ~FPEXC_EN);
 	put_cpu();
 
@@ -181,6 +190,10 @@ static int vfp_notifier(struct notifier_block *self, unsigned long cmd, void *v)
 			vfp_save_state(vfp_current_hw_state[cpu], fpexc);
 #endif
 
+		if ((fpexc & FPEXC_EN) &&
+				(fmrx(FPSCR) & FPSCR_CUMULATIVE_EXCEPTION_MASK))
+			vfp_raise_sigfpe(0, task_pt_regs(current));
+
 		/*
 		 * Always disable VFP so we can lazily save/restore the
 		 * old state.
-- 
1.7.6

