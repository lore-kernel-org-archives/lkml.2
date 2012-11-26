Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab2KZLFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:05:52 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:59549 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab2KZLFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:05:50 -0500
Subject: [PATCH 1/2] powerpc: Move the single step enable code to a generic
 path
To: bigeasy@linutronix.de, oleg@redhat.com, ananth@in.ibm.com,
        srikar@linux.vnet.ibm.com
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: peterz@infradead.org, benh@kernel.crashing.org, mingo@elte.hu,
        anton@redhat.com, linux-kernel@vger.kernel.org
Date: Mon, 26 Nov 2012 16:35:42 +0530
Message-ID: <20121126110448.6545.90588.stgit@suzukikp.in.ibm.com>
In-Reply-To: <20121126110007.6545.43875.stgit@suzukikp.in.ibm.com>
References: <20121126110007.6545.43875.stgit@suzukikp.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12112611-8878-0000-0000-000004EE0D46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suzuki K. Poulose <suzuki@in.ibm.com>

This patch moves the single step enable code used by kprobe to a generic
routine so that, it can be re-used by other code, in this case,
uprobes.


Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Cc:	linuxppc-dev@ozlabs.org
---
 arch/powerpc/include/asm/probes.h |   29 +++++++++++++++++++++++++++++
 arch/powerpc/kernel/kprobes.c     |   21 +--------------------
 2 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/include/asm/probes.h b/arch/powerpc/include/asm/probes.h
index 5f1e15b..836e9b9 100644
--- a/arch/powerpc/include/asm/probes.h
+++ b/arch/powerpc/include/asm/probes.h
@@ -38,5 +38,34 @@ typedef u32 ppc_opcode_t;
 #define is_trap(instr)		(IS_TW(instr) || IS_TWI(instr))
 #endif /* CONFIG_PPC64 */
 
+#ifdef CONFIG_PPC_ADV_DEBUG_REGS
+#define MSR_SINGLESTEP	(MSR_DE)
+#else
+#define MSR_SINGLESTEP	(MSR_SE)
+#endif
+
+/* Enable single stepping for the current task */
+static inline void enable_single_step(struct pt_regs *regs)
+{
+
+	/* 
+	 * We turn off async exceptions to ensure that the single step will
+	 * be for the instruction we have the kprobe on, if we dont its
+	 * possible we'd get the single step reported for an exception handler
+	 * like Decrementer or External Interrupt
+	 */
+	regs->msr &= ~MSR_EE;
+	regs->msr |= MSR_SINGLESTEP;
+#ifdef CONFIG_PPC_ADV_DEBUG_REGS
+	regs->msr &= ~MSR_CE;
+	mtspr(SPRN_DBCR0, mfspr(SPRN_DBCR0) | DBCR0_IC | DBCR0_IDM);
+#ifdef CONFIG_PPC_47x
+	isync();
+#endif
+#endif
+
+}
+
+
 #endif /* __KERNEL__ */
 #endif	/* _ASM_POWERPC_PROBES_H */
diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
index e88c643..92f1be7 100644
--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -36,12 +36,6 @@
 #include <asm/sstep.h>
 #include <asm/uaccess.h>
 
-#ifdef CONFIG_PPC_ADV_DEBUG_REGS
-#define MSR_SINGLESTEP	(MSR_DE)
-#else
-#define MSR_SINGLESTEP	(MSR_SE)
-#endif
-
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
@@ -104,20 +98,7 @@ void __kprobes arch_remove_kprobe(struct kprobe *p)
 
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
 {
-	/* We turn off async exceptions to ensure that the single step will
-	 * be for the instruction we have the kprobe on, if we dont its
-	 * possible we'd get the single step reported for an exception handler
-	 * like Decrementer or External Interrupt */
-	regs->msr &= ~MSR_EE;
-	regs->msr |= MSR_SINGLESTEP;
-#ifdef CONFIG_PPC_ADV_DEBUG_REGS
-	regs->msr &= ~MSR_CE;
-	mtspr(SPRN_DBCR0, mfspr(SPRN_DBCR0) | DBCR0_IC | DBCR0_IDM);
-#ifdef CONFIG_PPC_47x
-	isync();
-#endif
-#endif
-
+	enable_single_step(regs);
 	/*
 	 * On powerpc we should single step on the original
 	 * instruction even if the probed insn is a trap

