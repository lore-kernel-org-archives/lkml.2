Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab2LCPJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:09:50 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:58851 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab2LCPJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:09:49 -0500
Subject: [PATCH v2 3/4] uprobes/powerpc: Introduce routines for save/restore
 context
To: bigeasy@linutronix.de, oleg@redhat.com, ananth@in.ibm.com,
        srikar@linux.vnet.ibm.com
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: peterz@infradead.org, benh@kernel.crashing.org, mingo@elte.hu,
        anton@redhat.com, linux-kernel@vger.kernel.org
Date: Mon, 03 Dec 2012 20:39:35 +0530
Message-ID: <20121203150849.7727.53296.stgit@suzukikp>
In-Reply-To: <20121203150438.7727.74924.stgit@suzukikp>
References: <20121203150438.7727.74924.stgit@suzukikp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120315-8256-0000-0000-00000547772E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suzuki K. Poulose <suzuki@in.ibm.com>

Introduce routines for saving and restoring the context
befre/after the single step. No functional changes involved.

These will be extended later to save/restore more info about
the process once we replace the ptrace helpers.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 arch/powerpc/kernel/uprobes.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/uprobes.c b/arch/powerpc/kernel/uprobes.c
index bc77834..1a62353 100644
--- a/arch/powerpc/kernel/uprobes.c
+++ b/arch/powerpc/kernel/uprobes.c
@@ -52,6 +52,16 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe,
 	return 0;
 }
 
+static void uprobe_save_context_sstep(struct arch_uprobe_task *autask)
+{
+	autask->saved_trap_nr = current->thread.trap_nr;
+}
+
+static void uprobe_restore_context_sstep(struct arch_uprobe_task *autask)
+{
+	current->thread.trap_nr = autask->saved_trap_nr;
+}
+
 /*
  * arch_uprobe_pre_xol - prepare to execute out of line.
  * @auprobe: the probepoint information.
@@ -61,7 +71,7 @@ int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	struct arch_uprobe_task *autask = &current->utask->autask;
 
-	autask->saved_trap_nr = current->thread.trap_nr;
+	uprobe_save_context_sstep(autask);
 	current->thread.trap_nr = UPROBE_TRAP_NR;
 	regs->nip = current->utask->xol_vaddr;
 
@@ -111,7 +121,7 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 
 	WARN_ON_ONCE(current->thread.trap_nr != UPROBE_TRAP_NR);
 
-	current->thread.trap_nr = utask->autask.saved_trap_nr;
+	uprobe_restore_context_sstep(&utask->autask);
 
 	/*
 	 * On powerpc, except for loads and stores, most instructions
@@ -164,7 +174,7 @@ void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	struct uprobe_task *utask = current->utask;
 
-	current->thread.trap_nr = utask->autask.saved_trap_nr;
+	uprobe_restore_context_sstep(&utask->autask);
 	instruction_pointer_set(regs, utask->vaddr);
 
 	user_disable_single_step(current);

