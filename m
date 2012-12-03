Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab2LCPK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:10:56 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:53276 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab2LCPKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:10:55 -0500
Subject: [PATCH v2 4/4] uprobes/powerpc: Make use of generic routines to
 enable single step
To: bigeasy@linutronix.de, oleg@redhat.com, ananth@in.ibm.com,
        srikar@linux.vnet.ibm.com
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: peterz@infradead.org, benh@kernel.crashing.org, mingo@elte.hu,
        anton@redhat.com, linux-kernel@vger.kernel.org
Date: Mon, 03 Dec 2012 20:40:32 +0530
Message-ID: <20121203150946.7727.82735.stgit@suzukikp>
In-Reply-To: <20121203150438.7727.74924.stgit@suzukikp>
References: <20121203150438.7727.74924.stgit@suzukikp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120315-7014-0000-0000-0000024A3DC2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suzuki K. Poulose <suzuki@in.ibm.com>

Replace the ptrace helpers with the powerpc generic routines to
enable/disable single step. We save/restore the MSR (and DCBR for BookE)
across for the operation. We don't have to disable the single step,
as restoring the MSR/DBCR would restore the previous state.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 arch/powerpc/include/asm/uprobes.h |    4 ++++
 arch/powerpc/kernel/uprobes.c      |   26 +++++++++++++++++---------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/include/asm/uprobes.h b/arch/powerpc/include/asm/uprobes.h
index b532060..10a521c 100644
--- a/arch/powerpc/include/asm/uprobes.h
+++ b/arch/powerpc/include/asm/uprobes.h
@@ -43,6 +43,10 @@ struct arch_uprobe {
 
 struct arch_uprobe_task {
 	unsigned long	saved_trap_nr;
+	unsigned long	saved_msr;
+#ifdef CONFIG_PPC_ADV_DEBUG_REGS
+	unsigned long	saved_dbcr0;
+#endif
 };
 
 extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
diff --git a/arch/powerpc/kernel/uprobes.c b/arch/powerpc/kernel/uprobes.c
index 1a62353..6af55c4 100644
--- a/arch/powerpc/kernel/uprobes.c
+++ b/arch/powerpc/kernel/uprobes.c
@@ -52,14 +52,25 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe,
 	return 0;
 }
 
-static void uprobe_save_context_sstep(struct arch_uprobe_task *autask)
+static void uprobe_save_context_sstep(struct arch_uprobe_task *autask,
+					struct pt_regs *regs)
 {
 	autask->saved_trap_nr = current->thread.trap_nr;
+	autask->saved_msr = regs->msr;
+#ifdef CONFIG_PPC_ADV_DEBUG_REGS
+	autask->saved_dbcr0 = mfspr(SPRN_DBCR0);
+#endif
 }
 
-static void uprobe_restore_context_sstep(struct arch_uprobe_task *autask)
+static void uprobe_restore_context_sstep(struct arch_uprobe_task *autask,
+						struct pt_regs *regs)
 {
 	current->thread.trap_nr = autask->saved_trap_nr;
+
+	regs->msr = autask->saved_msr;
+#ifdef CONFIG_PPC_ADV_DEBUG_REGS
+	mtspr(SPRN_DBCR0, autask->saved_dbcr0);
+#endif
 }
 
 /*
@@ -71,11 +82,11 @@ int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	struct arch_uprobe_task *autask = &current->utask->autask;
 
-	uprobe_save_context_sstep(autask);
+	uprobe_save_context_sstep(autask, regs);
 	current->thread.trap_nr = UPROBE_TRAP_NR;
 	regs->nip = current->utask->xol_vaddr;
 
-	user_enable_single_step(current);
+	enable_single_step(regs);
 	return 0;
 }
 
@@ -121,7 +132,7 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 
 	WARN_ON_ONCE(current->thread.trap_nr != UPROBE_TRAP_NR);
 
-	uprobe_restore_context_sstep(&utask->autask);
+	uprobe_restore_context_sstep(&utask->autask, regs);
 
 	/*
 	 * On powerpc, except for loads and stores, most instructions
@@ -132,7 +143,6 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	 */
 	regs->nip = utask->vaddr + MAX_UINSN_BYTES;
 
-	user_disable_single_step(current);
 	return 0;
 }
 
@@ -174,10 +184,8 @@ void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	struct uprobe_task *utask = current->utask;
 
-	uprobe_restore_context_sstep(&utask->autask);
+	uprobe_restore_context_sstep(&utask->autask, regs);
 	instruction_pointer_set(regs, utask->vaddr);
-
-	user_disable_single_step(current);
 }
 
 /*

