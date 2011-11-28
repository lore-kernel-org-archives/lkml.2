Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1K1TM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:12:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466Ab1K1TM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:12:56 -0500
Date: Mon, 28 Nov 2011 20:07:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [PATCH 4/5] uprobes: teach set_xol_ip() to use uprobe_xol_slots[]
Message-ID: <20111128190730.GE4602@redhat.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com> <20111128190614.GA4602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128190614.GA4602@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change set_xol_ip() to use uprobe_xol_slots[] per-cpu array to
"allocate" the insn slot. We do not care if the task migrates to
another CPU before executing xol insn, set_xol_ip() will be called
again by uprobe_switch_to(). Likewise, we do not care if the task
is simply preempted or sleeps.

IOW, uprobe_xol_slots[CPU] is "owned" by cpu_curr(CPU).

This makes xol_get_insn_slot/xol_free_insn_slot unnecessary, but
uprobe_notify_resume() should set utask->vaddr. The patch updates
the callers but doesn't remove this code to simplify the review.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/uprobes.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 20007da..c9e2f65 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -1285,7 +1285,6 @@ void free_uprobe_utask(struct task_struct *tsk)
 	if (utask->active_uprobe)
 		put_uprobe(utask->active_uprobe);
 
-	xol_free_insn_slot(tsk);
 	kfree(utask);
 	tsk->utask = NULL;
 }
@@ -1347,7 +1346,15 @@ uprobe_xol_slots[UPROBES_XOL_SLOT_BYTES][NR_CPUS] __page_aligned_bss;
 
 void __weak set_xol_ip(struct pt_regs *regs)
 {
-	set_instruction_pointer(regs, current->utask->xol_vaddr);
+	int cpu = smp_processor_id();
+	struct uprobe_task *utask = current->utask;
+	struct uprobe *uprobe = utask->active_uprobe;
+
+	memcpy(uprobe_xol_slots[cpu], uprobe->insn, MAX_UINSN_BYTES);
+
+	utask->xol_vaddr = fix_to_virt(UPROBE_XOL_FIRST_PAGE)
+				+ UPROBES_XOL_SLOT_BYTES * cpu;
+	set_instruction_pointer(regs, utask->xol_vaddr);
 }
 
 /*
@@ -1390,14 +1397,12 @@ void uprobe_notify_resume(struct pt_regs *regs)
 				goto cleanup_ret;
 		}
 		utask->active_uprobe = u;
+		utask->vaddr = probept;
 		handler_chain(u, regs);
 
 		if (u->flags & UPROBES_SKIP_SSTEP && can_skip_xol(regs, u))
 			goto cleanup_ret;
 
-		if (!xol_get_insn_slot(u, probept))
-			goto cleanup_ret;
-
 		if (pre_xol(u, regs))
 			goto cleanup_ret;
 
@@ -1419,7 +1424,6 @@ void uprobe_notify_resume(struct pt_regs *regs)
 		utask->active_uprobe = NULL;
 		utask->state = UTASK_RUNNING;
 		user_disable_single_step(current);
-		xol_free_insn_slot(current);
 
 		spin_lock_irq(&current->sighand->siglock);
 		recalc_sigpending(); /* see uprobe_deny_signal() */
-- 
1.5.5.1


