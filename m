Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2GZPUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:20:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:45177 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2GZPUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:20:50 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] uprobes: don't enable/disable signle step if the user did it
Date: Thu, 26 Jul 2012 17:20:43 +0200
Message-Id: <1343316043-13475-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If someone is using single stepping over uprobe brackpoint then after
we pass the uprobe single step, single stepping is disabled and the user
who enebaled them in the first place does not know anything about this.

This patch avoids enabling / disabling the single step mode if it is
already enabled.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/uprobes.h |    2 ++
 kernel/events/uprobes.c |   10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index efe4b33..1be2d44 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -44,6 +44,8 @@ struct inode;
 #define UPROBE_RUN_HANDLER	0x2
 /* Can skip singlestep */
 #define UPROBE_SKIP_SSTEP	0x4
+/* user does also singlestep */
+#define UPROBE_USER_SSTEP	0x8
 
 struct uprobe_consumer {
 	int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index f935327..772eb3a 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1528,7 +1528,10 @@ static void handle_swbp(struct pt_regs *regs)
 
 	utask->state = UTASK_SSTEP;
 	if (!pre_ssout(uprobe, regs, bp_vaddr)) {
-		user_enable_single_step(current);
+		if (test_tsk_thread_flag(current, TIF_SINGLESTEP))
+			uprobe->flags |= UPROBE_USER_SSTEP;
+		else
+			user_enable_single_step(current);
 		return;
 	}
 
@@ -1569,7 +1572,10 @@ static void handle_singlestep(struct uprobe_task *utask, struct pt_regs *regs)
 	put_uprobe(uprobe);
 	utask->active_uprobe = NULL;
 	utask->state = UTASK_RUNNING;
-	user_disable_single_step(current);
+	if (uprobe->flags & UPROBE_USER_SSTEP)
+		uprobe->flags &= ~UPROBE_USER_SSTEP;
+	else
+		user_disable_single_step(current);
 	xol_free_insn_slot(current);
 
 	spin_lock_irq(&current->sighand->siglock);
-- 
1.7.10.4

