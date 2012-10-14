Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab2JNTXo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 15:23:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65331 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2JNTXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 15:23:42 -0400
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, oleg@redhat.com,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 3/9] uprobes: allow ignoring of probe hits
Date: Sun, 14 Oct 2012 21:23:07 +0200
Message-Id: <1350242593-17761-3-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350242593-17761-1-git-send-email-rabin@rab.in>
References: <1350242593-17761-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow arches to decided to ignore a probe hit.  ARM will use this to
only call handlers if the conditions to execute a conditionally executed
instruction are satisfied.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 include/linux/uprobes.h |    1 +
 kernel/events/uprobes.c |   14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index ac90704..da21b66 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -128,6 +128,7 @@ extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
 extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
 extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
+extern bool __weak arch_uprobe_ignore(struct arch_uprobe *aup, struct pt_regs *regs);
 #else /* !CONFIG_UPROBES */
 struct uprobes_state {
 };
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index db4e3ab..a0e1a38 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1419,6 +1419,11 @@ static void mmf_recalc_uprobes(struct mm_struct *mm)
 	clear_bit(MMF_HAS_UPROBES, &mm->flags);
 }
 
+bool __weak arch_uprobe_ignore(struct arch_uprobe *aup, struct pt_regs *regs)
+{
+	return false;
+}
+
 static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 {
 	struct mm_struct *mm = current->mm;
@@ -1469,6 +1474,7 @@ static void handle_swbp(struct pt_regs *regs)
 	struct uprobe *uprobe;
 	unsigned long bp_vaddr;
 	int uninitialized_var(is_swbp);
+	bool ignored = false;
 
 	bp_vaddr = uprobe_get_swbp_addr(regs);
 	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
@@ -1499,6 +1505,12 @@ static void handle_swbp(struct pt_regs *regs)
 			goto cleanup_ret;
 	}
 	utask->active_uprobe = uprobe;
+
+	if (arch_uprobe_ignore(&uprobe->arch, regs)) {
+		ignored = true;
+		goto cleanup_ret;
+	}
+
 	handler_chain(uprobe, regs);
 	if (uprobe->flags & UPROBE_SKIP_SSTEP && can_skip_sstep(uprobe, regs))
 		goto cleanup_ret;
@@ -1514,7 +1526,7 @@ cleanup_ret:
 		utask->active_uprobe = NULL;
 		utask->state = UTASK_RUNNING;
 	}
-	if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
+	if (!ignored && !(uprobe->flags & UPROBE_SKIP_SSTEP))
 
 		/*
 		 * cannot singlestep; cannot skip instruction;
-- 
1.7.9.5

