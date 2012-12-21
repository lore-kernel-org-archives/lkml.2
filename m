Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab2LULRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 06:17:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab2LULQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 06:16:51 -0500
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Anton Arapov <anton@redhat.com>
Subject: [RFC PATCH 3/6] uretprobes: return probe entry, prepare uretprobe
Date: Fri, 21 Dec 2012 12:16:33 +0100
Message-Id: <1356088596-17858-4-git-send-email-anton@redhat.com>
In-Reply-To: <1356088596-17858-1-git-send-email-anton@redhat.com>
References: <1356088596-17858-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a uprobe with return consumer is hit, prepare_uretprobe function is
invoked. It creates return_instance, hijacks return address and replaces
it with the trampoline.

This patch introduces return_consumer field in uprobe_task. It creates
additional overhead in filter_chain(), but this is the least evil at the
moment.

The other approach might be: use only consumers field for both probes and
return probes with additional flag introduction for distinguishing them.
This will remove the overhead in some functions like filter_chain(), however
it will comlicate handler_chain() and consumer_add()/_remove() routines.
And uprobes development moves towards reducing flags number so the field
can be removed eventually.

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 include/linux/uprobes.h |  4 +++
 kernel/events/uprobes.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 68780b6..1222a2c 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -59,6 +59,10 @@ struct uprobe_task {
 	enum uprobe_task_state		state;
 	struct arch_uprobe_task		autask;
 
+	/*
+	 * list for tracking uprobes with return consumers
+	 */
+	struct hlist_head		return_instances;
 	struct uprobe			*active_uprobe;
 
 	unsigned long			xol_vaddr;
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index f0dbbd0..af424a4 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -63,6 +63,8 @@ static struct percpu_rw_semaphore dup_mmap_sem;
 /* Can skip singlestep */
 #define UPROBE_SKIP_SSTEP	1
 
+static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs);
+
 struct uprobe {
 	struct rb_node		rb_node;	/* node in the rb tree */
 	atomic_t		ref;
@@ -70,12 +72,20 @@ struct uprobe {
 	struct rw_semaphore	consumer_rwsem;
 	struct list_head	pending_list;
 	struct uprobe_consumer	*consumers;
+	struct uprobe_consumer  *return_consumers;
 	struct inode		*inode;		/* Also hold a ref to inode */
 	loff_t			offset;
 	unsigned long		flags;
 	struct arch_uprobe	arch;
 };
 
+struct return_instance {
+	struct uprobe		*uprobe;
+	struct hlist_node	hlist;		/* node in list */
+	unsigned long		orig_return_vaddr;
+	unsigned long		sp;
+};
+
 /*
  * valid_vma: Verify if the specified vma is an executable vma
  * Relax restrictions while unregistering: vm_flags might have
@@ -424,6 +434,8 @@ static struct uprobe *alloc_uprobe(struct inode *inode, loff_t offset)
 
 	uprobe->inode = igrab(inode);
 	uprobe->offset = offset;
+	uprobe->consumers = NULL;
+	uprobe->return_consumers = NULL;
 	init_rwsem(&uprobe->register_rwsem);
 	init_rwsem(&uprobe->consumer_rwsem);
 	/* For now assume that the instruction need not be single-stepped */
@@ -447,6 +459,9 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 	struct uprobe_consumer *uc;
 
 	down_read(&uprobe->register_rwsem);
+	if (uprobe->return_consumers)
+		prepare_uretprobe(uprobe, regs);
+
 	for (uc = uprobe->consumers; uc; uc = uc->next)
 		uc->handler(uc, regs);
 	up_read(&uprobe->register_rwsem);
@@ -1284,6 +1299,75 @@ static unsigned long xol_get_trampoline_slot(void)
 	return area->rp_trampoline_vaddr;
 }
 
+/* Returns true if @ri_sp lies outside the stack (beyond @cursp). */
+static inline bool compare_stack_ptrs(unsigned long cursp, unsigned long ri_sp)
+{
+#ifdef CONFIG_STACK_GROWSUP
+	if (cursp < ri_sp)
+		return true;
+#else
+	if (cursp > ri_sp)
+		return true;
+#endif
+	return false;
+}
+
+/*
+ * A longjmp may cause one or more uretprobed functions to terminate without
+ * returning. Those functions' return_instances need to be recycled.
+ * We detect this when any uretprobed function is subsequently called
+ * or returns. A bypassed return_instance's stack pointer is beyond the
+ * current stack.
+ */
+static inline void uretprobe_bypass_instances(unsigned long cursp, struct uprobe_task *utask)
+{
+	struct hlist_node *r1, *r2;
+	struct return_instance *ri;
+	struct hlist_head *head = &utask->return_instances;
+
+	hlist_for_each_entry_safe(ri, r1, r2, head, hlist) {
+		if (compare_stack_ptrs(cursp, ri->sp)) {
+			hlist_del(&ri->hlist);
+			kfree(ri);
+		} else
+			return;
+	}
+}
+
+static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
+{
+	struct uprobe_task *utask;
+	struct xol_area *area;
+	struct return_instance *ri;
+	unsigned long rp_trampoline_vaddr = 0;
+
+	utask = current->utask;
+	area = get_xol_area(current->mm);
+	if (area)
+		rp_trampoline_vaddr = area->rp_trampoline_vaddr;
+
+	if (!rp_trampoline_vaddr) {
+		rp_trampoline_vaddr = xol_get_trampoline_slot();
+		if (!rp_trampoline_vaddr)
+			return;
+	}
+
+	ri = (struct return_instance *)kzalloc(sizeof(struct return_instance),
+						GFP_KERNEL);
+	if (!ri)
+		return;
+
+	ri->orig_return_vaddr = arch_uretprobe_hijack_return_addr(rp_trampoline_vaddr, regs);
+	if (likely(ri->orig_return_vaddr)) {
+		ri->sp = arch_uretprobe_predict_sp_at_return(regs, current);
+		uretprobe_bypass_instances(ri->sp, utask);
+		ri->uprobe = uprobe;
+		INIT_HLIST_NODE(&ri->hlist);
+		hlist_add_head(&ri->hlist, &utask->return_instances);
+	} else
+		kfree(ri);
+}
+
 /**
  * uprobe_get_swbp_addr - compute address of swbp given post-swbp regs
  * @regs: Reflects the saved state of the task after it has hit a breakpoint
@@ -1339,6 +1423,7 @@ static struct uprobe_task *add_utask(void)
 		return NULL;
 
 	utask->doomed = false;
+	INIT_HLIST_HEAD(&utask->return_instances);
 	current->utask = utask;
 	return utask;
 }
-- 
1.8.0.2

