Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497Ab2INROg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:14:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758037Ab2INROb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:14:31 -0400
Date: Fri, 14 Sep 2012 19:16:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] uprobes: Kill UTASK_BP_HIT state
Message-ID: <20120914171600.GA29649@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914171513.GA29599@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill UTASK_BP_HIT state, it buys nothing but complicates the code.
It is only used in uprobe_notify_resume() to decide who should be
called, we can check utask->active_uprobe != NULL instead. And this
allows us to simplify handle_swbp(), no need to clear utask->state.

Likewise we could kill UTASK_SSTEP, but UTASK_BP_HIT is worse and
imho should die. The problem is, it creates the special case when
task->utask is NULL, we can't distinguish RUNNING and BP_HIT. With
his patch utask == NULL always means RUNNING.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/uprobes.h |    1 -
 kernel/events/uprobes.c |   29 +++++++++--------------------
 2 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index e6f0331..18d839d 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -59,7 +59,6 @@ struct uprobe_consumer {
 #ifdef CONFIG_UPROBES
 enum uprobe_task_state {
 	UTASK_RUNNING,
-	UTASK_BP_HIT,
 	UTASK_SSTEP,
 	UTASK_SSTEP_ACK,
 	UTASK_SSTEP_TRAPPED,
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 403d2e0..4ea0f0b 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1469,10 +1469,6 @@ static void handle_swbp(struct pt_regs *regs)
 	bp_vaddr = uprobe_get_swbp_addr(regs);
 	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
 
-	utask = current->utask;
-	if (utask)
-		utask->state = UTASK_RUNNING;
-
 	if (!uprobe) {
 		if (is_swbp > 0) {
 			/* No matching uprobe; signal SIGTRAP. */
@@ -1491,6 +1487,7 @@ static void handle_swbp(struct pt_regs *regs)
 		return;
 	}
 
+	utask = current->utask;
 	if (!utask) {
 		utask = add_utask();
 		/* Cannot allocate; re-execute the instruction. */
@@ -1547,13 +1544,12 @@ static void handle_singlestep(struct uprobe_task *utask, struct pt_regs *regs)
 }
 
 /*
- * On breakpoint hit, breakpoint notifier sets the TIF_UPROBE flag.  (and on
- * subsequent probe hits on the thread sets the state to UTASK_BP_HIT) and
- * allows the thread to return from interrupt.
+ * On breakpoint hit, breakpoint notifier sets the TIF_UPROBE flag and
+ * allows the thread to return from interrupt. After that handle_swbp()
+ * sets utask->active_uprobe.
  *
- * On singlestep exception, singlestep notifier sets the TIF_UPROBE flag and
- * also sets the state to UTASK_SSTEP_ACK and allows the thread to return from
- * interrupt.
+ * On singlestep exception, singlestep notifier sets the TIF_UPROBE flag
+ * and allows the thread to return from interrupt.
  *
  * While returning to userspace, thread notices the TIF_UPROBE flag and calls
  * uprobe_notify_resume().
@@ -1563,10 +1559,10 @@ void uprobe_notify_resume(struct pt_regs *regs)
 	struct uprobe_task *utask;
 
 	utask = current->utask;
-	if (!utask || utask->state == UTASK_BP_HIT)
-		handle_swbp(regs);
-	else
+	if (utask && utask->active_uprobe)
 		handle_singlestep(utask, regs);
+	else
+		handle_swbp(regs);
 }
 
 /*
@@ -1575,17 +1571,10 @@ void uprobe_notify_resume(struct pt_regs *regs)
  */
 int uprobe_pre_sstep_notifier(struct pt_regs *regs)
 {
-	struct uprobe_task *utask;
-
 	if (!current->mm || !test_bit(MMF_HAS_UPROBES, &current->mm->flags))
 		return 0;
 
-	utask = current->utask;
-	if (utask)
-		utask->state = UTASK_BP_HIT;
-
 	set_thread_flag(TIF_UPROBE);
-
 	return 1;
 }
 
-- 
1.5.5.1

