Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2J1Rir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 13:38:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917Ab2J1Rio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 13:38:44 -0400
Date: Sun, 28 Oct 2012 18:39:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] uprobes: Kill arch_uprobe_enable/disable_step() hooks
Message-ID: <20121028173936.GA14659@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121028173900.GA14621@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill arch_uprobe_enable/disable_step() hooks, they do nothing and
nobody needs them.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/uprobes.h |    2 --
 kernel/events/uprobes.c |   10 ----------
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 2459457..2615c4d 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -101,8 +101,6 @@ extern void uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm);
 extern void uprobe_free_utask(struct task_struct *t);
 extern void uprobe_copy_process(struct task_struct *t);
 extern unsigned long __weak uprobe_get_swbp_addr(struct pt_regs *regs);
-extern void __weak arch_uprobe_enable_step(struct arch_uprobe *arch);
-extern void __weak arch_uprobe_disable_step(struct arch_uprobe *arch);
 extern int uprobe_post_sstep_notifier(struct pt_regs *regs);
 extern int uprobe_pre_sstep_notifier(struct pt_regs *regs);
 extern void uprobe_notify_resume(struct pt_regs *regs);
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 916391e..02d7c5f 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1430,14 +1430,6 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 	return uprobe;
 }
 
-void __weak arch_uprobe_enable_step(struct arch_uprobe *arch)
-{
-}
-
-void __weak arch_uprobe_disable_step(struct arch_uprobe *arch)
-{
-}
-
 /*
  * Run handler and ask thread to singlestep.
  * Ensure all non-fatal signals cannot interrupt thread while it singlesteps.
@@ -1491,7 +1483,6 @@ static void handle_swbp(struct pt_regs *regs)
 		goto out;
 
 	if (!pre_ssout(uprobe, regs, bp_vaddr)) {
-		arch_uprobe_enable_step(&uprobe->arch);
 		utask->active_uprobe = uprobe;
 		utask->state = UTASK_SSTEP;
 		return;
@@ -1523,7 +1514,6 @@ static void handle_singlestep(struct uprobe_task *utask, struct pt_regs *regs)
 	else
 		WARN_ON_ONCE(1);
 
-	arch_uprobe_disable_step(&uprobe->arch);
 	put_uprobe(uprobe);
 	utask->active_uprobe = NULL;
 	utask->state = UTASK_RUNNING;
-- 
1.5.5.1

