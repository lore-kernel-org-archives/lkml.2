Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab1KRLhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:37:55 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58515 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757663Ab1KRLhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:37:53 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
Date: Fri, 18 Nov 2011 16:41:39 +0530
Message-Id: <20111118111139.10512.21445.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH v7 3.2-rc2 25/30] uprobes: call post_xol() unconditionally
x-cbid: 11111801-0260-0000-0000-0000000EED4E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Kill sstep_complete(), change uprobe_notify_resume() to use
post_xol() unconditionally.

It is wrong to assume that regs->ip always changes after the step.
rep or jmp/call to self for example. We know that this task has
already done the step, we can rely on DIE_DEBUG notification.

Original-patch-from: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 include/linux/uprobes.h |    3 ++-
 kernel/uprobes.c        |   38 ++++++++++++--------------------------
 2 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index add5222..70d639c 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -74,7 +74,8 @@ struct uprobe {
 enum uprobe_task_state {
 	UTASK_RUNNING,
 	UTASK_BP_HIT,
-	UTASK_SSTEP
+	UTASK_SSTEP,
+	UTASK_SSTEP_ACK,
 };
 
 /*
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index b440acd..50cde86 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -1313,24 +1313,6 @@ static int pre_ssout(struct uprobe *uprobe, struct pt_regs *regs,
 }
 
 /*
- * Verify from Instruction Pointer if singlestep has indeed occurred.
- * If Singlestep has occurred, then do post singlestep fix-ups.
- */
-static bool sstep_complete(struct uprobe *uprobe, struct pt_regs *regs)
-{
-	unsigned long vaddr = instruction_pointer(regs);
-
-	/*
-	 * If we have executed out of line, Instruction pointer
-	 * cannot be same as virtual address of XOL slot.
-	 */
-	if (vaddr == current->utask->xol_vaddr)
-		return false;
-	post_xol(uprobe, regs);
-	return true;
-}
-
-/*
  * uprobe_notify_resume gets called in task context just before returning
  * to userspace.
  *
@@ -1377,15 +1359,18 @@ void uprobe_notify_resume(struct pt_regs *regs)
 		else
 			/* Cannot Singlestep; re-execute the instruction. */
 			goto cleanup_ret;
-	} else if (utask->state == UTASK_SSTEP) {
+	} else {
 		u = utask->active_uprobe;
-		if (sstep_complete(u, regs)) {
-			put_uprobe(u);
-			utask->active_uprobe = NULL;
-			utask->state = UTASK_RUNNING;
-			user_disable_single_step(current);
-			xol_free_insn_slot(current);
-		}
+		if (utask->state == UTASK_SSTEP_ACK)
+			post_xol(u, regs);
+		else
+			WARN_ON_ONCE(1);
+
+		put_uprobe(u);
+		utask->active_uprobe = NULL;
+		utask->state = UTASK_RUNNING;
+		user_disable_single_step(current);
+		xol_free_insn_slot(current);
 	}
 	return;
 
@@ -1435,6 +1420,7 @@ int uprobe_post_notifier(struct pt_regs *regs)
 		/* task is currently not uprobed */
 		return 0;
 
+	utask->state = UTASK_SSTEP_ACK;
 	set_thread_flag(TIF_UPROBE);
 	return 1;
 }

