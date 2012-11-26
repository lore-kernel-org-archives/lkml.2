Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab2KZLHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:07:06 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:40650 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab2KZLHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:07:04 -0500
Subject: [PATCH 2/2] uprobes/powerpc: Make use of generic routines to enable
 single step
To: bigeasy@linutronix.de, oleg@redhat.com, ananth@in.ibm.com,
        srikar@linux.vnet.ibm.com
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: peterz@infradead.org, benh@kernel.crashing.org, mingo@elte.hu,
        anton@redhat.com, linux-kernel@vger.kernel.org
Date: Mon, 26 Nov 2012 16:36:56 +0530
Message-ID: <20121126110548.6545.53281.stgit@suzukikp.in.ibm.com>
In-Reply-To: <20121126110007.6545.43875.stgit@suzukikp.in.ibm.com>
References: <20121126110007.6545.43875.stgit@suzukikp.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12112611-6102-0000-0000-0000029F6F7D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suzuki K. Poulose <suzuki@in.ibm.com>

Replace the ptrace helpers with the powerpc generic routines to
enable/disable single step. We save/restore the MSR (and DCBR for BookE)
across for the operation.


Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 arch/powerpc/include/asm/uprobes.h |    4 ++++
 arch/powerpc/kernel/uprobes.c      |   11 +++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/uprobes.h b/arch/powerpc/include/asm/uprobes.h
index b532060..884be93 100644
--- a/arch/powerpc/include/asm/uprobes.h
+++ b/arch/powerpc/include/asm/uprobes.h
@@ -43,6 +43,10 @@ struct arch_uprobe {
 
 struct arch_uprobe_task {
 	unsigned long	saved_trap_nr;
+	unsigned long	saved_msr;
+#ifdef CONFIG_PPC_ADV_DEBUG_REGS
+	unsigned long	saved_dbcr;
+#endif
 };
 
 extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
diff --git a/arch/powerpc/kernel/uprobes.c b/arch/powerpc/kernel/uprobes.c
index bc77834..c407c07 100644
--- a/arch/powerpc/kernel/uprobes.c
+++ b/arch/powerpc/kernel/uprobes.c
@@ -62,10 +62,14 @@ int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	struct arch_uprobe_task *autask = &current->utask->autask;
 
 	autask->saved_trap_nr = current->thread.trap_nr;
+	autask->saved_msr = regs->msr;
+#ifdef CONFIG_PPC_ADV_DEBUG_REGS
+	autask->saved_dbcr = mfspr(SPRN_DBCR0);
+#endif
 	current->thread.trap_nr = UPROBE_TRAP_NR;
 	regs->nip = current->utask->xol_vaddr;
 
-	user_enable_single_step(current);
+	enable_single_step(regs);
 	return 0;
 }
 
@@ -121,8 +125,11 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	 * to be executed.
 	 */
 	regs->nip = utask->vaddr + MAX_UINSN_BYTES;
+	regs->msr = utask->autask.saved_msr;
+#ifdef CONFIG_PPC_ADV_DEBUG_REGS
+	mtspr(SPRN_DBCR0, utask->autask.saved_dbcr);
+#endif
 
-	user_disable_single_step(current);
 	return 0;
 }
 

