Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab2HGQNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:13:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:53142 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab2HGQNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:13:06 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/5] uprobes: Use a helper instead of ptrace's single step enable
Date: Tue,  7 Aug 2012 18:12:28 +0200
Message-Id: <1344355952-2382-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de>
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Oleg pointed out in [0] utrace should not use the ptrace interface
for enabling/disabling single stepping.

[0] http://lkml.kernel.org/20120730141638.GA5306@redhat.com

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/uprobes.h |    2 ++
 kernel/events/uprobes.c |   14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index efe4b33..0fc6585 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -111,6 +111,8 @@ extern void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsig
 extern void uprobe_free_utask(struct task_struct *t);
 extern void uprobe_copy_process(struct task_struct *t);
 extern unsigned long __weak uprobe_get_swbp_addr(struct pt_regs *regs);
+extern void __weak arch_uprobe_enable_step(struct arch_uprobe *arch);
+extern void __weak arch_uprobe_disable_step(struct arch_uprobe *arch);
 extern int uprobe_post_sstep_notifier(struct pt_regs *regs);
 extern int uprobe_pre_sstep_notifier(struct pt_regs *regs);
 extern void uprobe_notify_resume(struct pt_regs *regs);
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index c08a22d..41a2555 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1463,6 +1463,16 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 	return uprobe;
 }
 
+void __weak arch_uprobe_enable_step(struct arch_uprobe *arch)
+{
+	user_enable_single_step(current);
+}
+
+void __weak arch_uprobe_disable_step(struct arch_uprobe *arch)
+{
+	user_disable_single_step(current);
+}
+
 /*
  * Run handler and ask thread to singlestep.
  * Ensure all non-fatal signals cannot interrupt thread while it singlesteps.
@@ -1509,7 +1519,7 @@ static void handle_swbp(struct pt_regs *regs)
 
 	utask->state = UTASK_SSTEP;
 	if (!pre_ssout(uprobe, regs, bp_vaddr)) {
-		user_enable_single_step(current);
+		arch_uprobe_enable_step(&uprobe->arch);
 		return;
 	}
 
@@ -1550,7 +1560,7 @@ static void handle_singlestep(struct uprobe_task *utask, struct pt_regs *regs)
 	put_uprobe(uprobe);
 	utask->active_uprobe = NULL;
 	utask->state = UTASK_RUNNING;
-	user_disable_single_step(current);
+	arch_uprobe_disable_step(&uprobe->arch);
 	xol_free_insn_slot(current);
 
 	spin_lock_irq(&current->sighand->siglock);
-- 
1.7.10.4

