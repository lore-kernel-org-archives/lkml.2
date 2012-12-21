Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2LULRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 06:17:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab2LULQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 06:16:53 -0500
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Anton Arapov <anton@redhat.com>
Subject: [RFC PATCH 4/6] uretprobes: invoke return probe handlers
Date: Fri, 21 Dec 2012 12:16:34 +0100
Message-Id: <1356088596-17858-5-git-send-email-anton@redhat.com>
In-Reply-To: <1356088596-17858-1-git-send-email-anton@redhat.com>
References: <1356088596-17858-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uretprobe handlers are invoked when the trampoline is hit, on completion
the trampoline is replaced with the saved return address and the uretprobe
instance deleted.

There are get stack pointer ( cur_sp = (unsigned long)regs->sp; ) and
restore ip (instruction_pointer_set(regs, orig_return_addr); ) in the
code, however I'm not sure if both is ok for any architecture and
perhaps should be moved to arch-dependent uprobes code otherwise.

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 kernel/events/uprobes.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 71 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index af424a4..a3b3a60 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -467,6 +467,16 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 	up_read(&uprobe->register_rwsem);
 }
 
+static void uretprobe_handler_chain(struct uprobe *uprobe, unsigned long bp_vaddr, struct pt_regs *regs)
+{
+	struct uprobe_consumer *uc;
+
+	down_read(&uprobe->register_rwsem);
+	for (uc = uprobe->return_consumers; uc; uc = uc->next)
+		uc->handler(uc, regs);
+	up_read(&uprobe->register_rwsem);
+}
+
 static void consumer_add(struct uprobe *uprobe, struct uprobe_consumer *uc)
 {
 	down_write(&uprobe->consumer_rwsem);
@@ -608,6 +618,12 @@ static bool filter_chain(struct uprobe *uprobe)
 		if (ret)
 			break;
 	}
+	for (uc = uprobe->return_consumers; uc; uc = uc->next) {
+		/* TODO: ret = uc->filter(...) */
+		ret = true;
+		if (ret)
+			break;
+	}
 	up_read(&uprobe->consumer_rwsem);
 
 	return ret;
@@ -1334,6 +1350,48 @@ static inline void uretprobe_bypass_instances(unsigned long cursp, struct uprobe
 	}
 }
 
+static unsigned long uretprobe_run_handlers(struct pt_regs *regs)
+{
+	struct hlist_head *head;
+	struct hlist_node *r1, *r2;
+
+	struct return_instance *ri;
+	struct uprobe_task *utask;
+
+	struct xol_area *area;
+	unsigned long rp_trampoline_vaddr;
+	unsigned long orig_return_vaddr, cur_sp;
+
+	cur_sp = (unsigned long)regs->sp;
+	utask = current->utask;
+	uretprobe_bypass_instances(cur_sp, utask);
+
+	area = get_xol_area(current->mm);
+	rp_trampoline_vaddr = area->rp_trampoline_vaddr;
+	head = &utask->return_instances;
+	hlist_for_each_entry_safe(ri, r1, r2, head, hlist) {
+		if (ri->uprobe && ri->uprobe->return_consumers)
+			uretprobe_handler_chain(ri->uprobe, ri->orig_return_vaddr, regs);
+
+		orig_return_vaddr = ri->orig_return_vaddr;
+		hlist_del(&ri->hlist);
+		kfree(ri);
+
+		if (orig_return_vaddr != rp_trampoline_vaddr)
+			/*
+			 * This is the first ri (chronologically) pushed for
+			 * this particular instance of the probed function.
+			 */
+			return orig_return_vaddr;
+	}
+
+	printk(KERN_ERR "uretprobe: no instance with original return address!"
+			" pid/tgid=%d/%d", current->pid, current->tgid);
+	utask->doomed = true;
+
+	return 0;
+}
+
 static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
 {
 	struct uprobe_task *utask;
@@ -1567,12 +1625,23 @@ static void handle_swbp(struct pt_regs *regs)
 {
 	struct uprobe_task *utask;
 	struct uprobe *uprobe;
-	unsigned long bp_vaddr;
+	struct xol_area *area;
+	unsigned long bp_vaddr, orig_return_vaddr;
 	int uninitialized_var(is_swbp);
 
 	bp_vaddr = uprobe_get_swbp_addr(regs);
-	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
+	area = get_xol_area(current->mm);
+	if (area) {
+		if (bp_vaddr == area->rp_trampoline_vaddr) {
+			orig_return_vaddr = uretprobe_run_handlers(regs);
+			instruction_pointer_set(regs, orig_return_vaddr);
+			if (current->utask->doomed)
+				send_sig(SIGSEGV, current, 0);
+			return;
+		}
+	}
 
+	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
 	if (!uprobe) {
 		if (is_swbp > 0) {
 			/* No matching uprobe; signal SIGTRAP. */
-- 
1.8.0.2

