Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab3AILZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:25:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757379Ab3AILZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:25:27 -0500
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>
Subject: [RFC PATCH v2 4/4] uretprobes: invoke return probe handlers
Date: Wed,  9 Jan 2013 12:24:52 +0100
Message-Id: <1357730692-3928-5-git-send-email-anton@redhat.com>
In-Reply-To: <1357730692-3928-1-git-send-email-anton@redhat.com>
References: <1357730692-3928-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uretprobe handlers are invoked when the trampoline is hit, on completion
the trampoline is replaced with the saved return address and the
uretprobe instance deleted.

v2:
  get rid of ->return_consumers
  use rp_handler()

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 arch/x86/include/asm/uprobes.h |  5 ++++
 include/linux/uprobes.h        |  4 +++
 kernel/events/uprobes.c        | 61 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index c353555..9a605b8 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -56,4 +56,9 @@ extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
 extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
 extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long rp_trampoline_vaddr, struct pt_regs *regs);
+
+static inline unsigned long arch_uretprobe_get_sp(struct pt_regs *regs)
+{
+	return (unsigned long)regs->sp;
+}
 #endif	/* _ASM_UPROBES_H */
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index cdc4d53..1a229db 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -45,7 +45,11 @@ enum uprobe_filter_ctx {
 };
 
 struct uprobe_consumer {
+	/* probe handler */
 	int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
+	/* return probe handler */
+	int (*rp_handler)(struct uprobe_consumer *self, struct pt_regs *regs);
+
 	bool (*filter)(struct uprobe_consumer *self,
 				enum uprobe_filter_ctx ctx,
 				struct mm_struct *mm);
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index d6fa497..8232c29 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1548,6 +1548,57 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 	up_read(&uprobe->register_rwsem);
 }
 
+static void handler_rp_chain(struct uprobe *uprobe, struct pt_regs *regs)
+{
+	struct uprobe_consumer *uc;
+
+	down_read(&uprobe->register_rwsem);
+	for (uc = uprobe->consumers; uc; uc = uc->next) {
+		if (uc->rp_handler)
+			uc->rp_handler(uc, regs);
+	}
+	up_read(&uprobe->register_rwsem);
+}
+
+static void handle_rp_swbp(struct pt_regs *regs)
+{
+	struct hlist_head *head;
+	struct hlist_node *r1, *r2;
+
+	struct return_uprobe_i *ri;
+	struct uprobe_task *utask;
+
+	struct xol_area *area;
+	unsigned long rp_trampoline_vaddr;
+	unsigned long orig_ret_vaddr, cur_sp;
+
+	cur_sp = arch_uretprobe_get_sp(regs);
+	utask = current->utask;
+	head = &utask->return_uprobes;
+
+	area = get_xol_area();
+	rp_trampoline_vaddr = area->vaddr;
+
+	hlist_for_each_entry_safe(ri, r1, r2, head, hlist) {
+		orig_ret_vaddr = ri->orig_ret_vaddr;
+
+		if (ri->uprobe->consumers) {
+			instruction_pointer_set(regs, orig_ret_vaddr);
+			handler_rp_chain(ri->uprobe, regs);
+		}
+
+		hlist_del(&ri->hlist);
+		kfree(ri);
+
+		if (orig_ret_vaddr != rp_trampoline_vaddr)
+			return;
+	}
+
+	printk(KERN_ERR "uretprobe: no instance with original return address!"
+			" pid/tgid=%d/%d", current->pid, current->tgid);
+	send_sig(SIGSEGV, current, 0);
+}
+
 /*
  * Run handler and ask thread to singlestep.
  * Ensure all non-fatal signals cannot interrupt thread while it singlesteps.
@@ -1555,12 +1606,20 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 static void handle_swbp(struct pt_regs *regs)
 {
 	struct uprobe *uprobe;
+	struct xol_area *area;
 	unsigned long bp_vaddr;
 	int uninitialized_var(is_swbp);
 
 	bp_vaddr = uprobe_get_swbp_addr(regs);
-	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
+	area = get_xol_area();
+	if (area) {
+		if (bp_vaddr == area->vaddr) {
+			handle_rp_swbp(regs);
+			return;
+		}
+	}
 
+	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
 	if (!uprobe) {
 		if (is_swbp > 0) {
 			/* No matching uprobe; signal SIGTRAP. */
-- 
1.8.0.2

