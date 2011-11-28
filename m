Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1K1TMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:12:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab1K1TL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:11:58 -0500
Date: Mon, 28 Nov 2011 20:06:37 +0100
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
Subject: [PATCH 1/5] uprobes: kill pre_ssout(), introduce set_xol_ip()
Message-ID: <20111128190637.GB4602@redhat.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com> <20111128190614.GA4602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128190614.GA4602@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, preparation.

- Do not change regs->ip in pre_xol().

- Kill pre_ssout(), move its code into the single caller.

- Add the new __weak helper, set_xol_ip(). Currently it simply does
  regs->ip = utask->xol_vaddr.

- Change uprobe_notify_resume() to do set_xol_ip() after pre_xol().

IOW, before this patch uprobe_notify_resume() does:

	utask->state = UTASK_SSTEP;
	pre_ssout:
		xol_get_insn_slot();
		pre_xol();		// <----- sets regs->ip
	user_enable_single_step(current);

after:

	xol_get_insn_slot();
	pre_xol();		// <------ doesn't change regs->ip
	user_enable_single_step(current);
	utask->state = UTASK_SSTEP;
	set_xol_ip();		// <----- sets regs->ip

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |    2 --
 include/linux/uprobes.h   |    1 +
 kernel/uprobes.c          |   27 +++++++++++++--------------
 3 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 40f9f75..cd086be 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -429,7 +429,6 @@ int pre_xol(struct uprobe *uprobe, struct pt_regs *regs)
 	tskinfo->saved_trap_no = current->thread.trap_no;
 	current->thread.trap_no = UPROBE_TRAP_NO;
 
-	regs->ip = current->utask->xol_vaddr;
 	if (uprobe->fixups & UPROBES_FIX_RIP_AX) {
 		tskinfo->saved_scratch_register = regs->ax;
 		regs->ax = current->utask->vaddr;
@@ -449,7 +448,6 @@ int pre_xol(struct uprobe *uprobe, struct pt_regs *regs)
 	tskinfo->saved_trap_no = current->thread.trap_no;
 	current->thread.trap_no = UPROBE_TRAP_NO;
 
-	regs->ip = current->utask->xol_vaddr;
 	return 0;
 }
 #endif
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 20bdd0a..c9ff67a 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -140,6 +140,7 @@ extern int uprobe_bkpt_notifier(struct pt_regs *regs);
 extern void uprobe_notify_resume(struct pt_regs *regs);
 extern bool uprobe_deny_signal(void);
 extern bool __weak can_skip_xol(struct pt_regs *regs, struct uprobe *u);
+extern void __weak set_xol_ip(struct pt_regs *regs);
 #else /* CONFIG_UPROBES is not defined */
 static inline int register_uprobe(struct inode *inode, loff_t offset,
 				struct uprobe_consumer *consumer)
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 2493191..b596432 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -1311,15 +1311,6 @@ static struct uprobe_task *add_utask(void)
 	return utask;
 }
 
-/* Prepare to single-step probed instruction out of line. */
-static int pre_ssout(struct uprobe *uprobe, struct pt_regs *regs,
-				unsigned long vaddr)
-{
-	if (xol_get_insn_slot(uprobe, vaddr) && !pre_xol(uprobe, regs))
-		return 0;
-	return -EFAULT;
-}
-
 bool uprobe_deny_signal(void)
 {
 	struct task_struct *tsk = current;
@@ -1351,6 +1342,11 @@ bool __weak can_skip_xol(struct pt_regs *regs, struct uprobe *u)
 	return false;
 }
 
+void __weak set_xol_ip(struct pt_regs *regs)
+{
+	set_instruction_pointer(regs, current->utask->xol_vaddr);
+}
+
 /*
  * uprobe_notify_resume gets called in task context just before returning
  * to userspace.
@@ -1396,12 +1392,15 @@ void uprobe_notify_resume(struct pt_regs *regs)
 		if (u->flags & UPROBES_SKIP_SSTEP && can_skip_xol(regs, u))
 			goto cleanup_ret;
 
-		utask->state = UTASK_SSTEP;
-		if (!pre_ssout(u, regs, probept))
-			user_enable_single_step(current);
-		else
-			/* Cannot Singlestep; re-execute the instruction. */
+		if (!xol_get_insn_slot(u, probept))
+			goto cleanup_ret;
+
+		if (pre_xol(u, regs))
 			goto cleanup_ret;
+
+		user_enable_single_step(current);
+		utask->state = UTASK_SSTEP;
+		set_xol_ip(regs);
 	} else {
 		u = utask->active_uprobe;
 		if (utask->state == UTASK_SSTEP_ACK)
-- 
1.5.5.1


