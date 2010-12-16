Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab0LPKCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:02:35 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56750 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab0LPKBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:01:16 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 16 Dec 2010 15:28:17 +0530
Message-Id: <20101216095817.23751.76989.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
Subject: [RFC] [PATCH 2.6.37-rc5-tip 5/20]  5: Uprobes: register/unregister probes.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A probe is specified by a file:offset.  While registering, a breakpoint
is inserted for the first consumer, On subsequent probes, the consumer
gets appended to the existing consumers. While unregistering a
breakpoint is removed if the consumer happens to be the last consumer.
All other unregisterations, the consumer is deleted from the list of
consumers.

Probe specifications are maintained in a rb tree. A probe specification
is converted into a uprobe before store in a rb tree.  A uprobe can be
shared by many consumers.

Given a inode, we get a list of mm's that have mapped the inode.
However we want to limit the probes to certain processes/threads.  The
filtering should be at thread level. To limit the probes to a certain
processes/threads, we would want to walk through the list of threads
whose mm member refer to a given mm.

Here are the options that I thought of:
1. Use mm->owner and walk thro the thread_group of mm->owner, siblings
of mm->owner, siblings of parent of mm->owner.  This should be
good list to traverse. Not sure if this is an exhaustive
enough list that all tasks that have a mm set to this mm_struct are
walked through.

2. Install probes on all mm's that have mapped the probes and filter
only at probe hit time.

3. walk thro do_each_thread; while_each_thread; I think this will catch
all tasks that have a mm set to the given mm. However this might
be too heavy esp if mm corresponds to a library.

4. add a list_head element to the mm struct and update the list whenever
the task->mm thread gets updated. This could mean extending the current
mm->owner. However there is some maintainance overhead.

Currently we use the second approach, i.e probe all mm's that have mapped
the probes and filter only at probe hit.

Also would be interested to know if there are ways to call
replace_page without having to take mmap_sem.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 include/linux/mm_types.h |    5 +
 include/linux/uprobes.h  |   32 +++++++++
 kernel/uprobes.c         |  161 +++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 187 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index bb7288a..af2b55d 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -312,6 +312,11 @@ struct mm_struct {
 #endif
 	/* How many tasks sharing this mm are OOM_DISABLE */
 	atomic_t oom_disable_count;
+#ifdef CONFIG_UPROBES
+	unsigned long uprobes_vaddr;
+	struct list_head uprobes_list;
+	atomic_t uprobes_count;
+#endif
 };
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 94557ff..f62c7b0 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -31,6 +31,7 @@
  * ARCH_SUPPORTS_UPROBES has not be defined.
  */
 typedef u8 uprobe_opcode_t;
+struct uprobe_arch_info	{};		/* arch specific info*/
 
 /* Post-execution fixups.  Some architectures may define others. */
 #endif /* CONFIG_ARCH_SUPPORTS_UPROBES */
@@ -69,6 +70,19 @@ struct uprobe_consumer {
 	void *fvalue;	/* filter value */
 };
 
+struct uprobe {
+	struct rb_node		rb_node;	/* node in the rb tree */
+	atomic_t		ref;
+	struct rw_semaphore	consumer_rwsem;
+	struct uprobe_arch_info	arch_info;	/* arch specific info if any */
+	struct uprobe_consumer	*consumers;
+	struct inode		*inode;		/* Also hold a ref to inode */
+	unsigned long		offset;
+	uprobe_opcode_t		opcode;
+	u16			fixups;
+	int			copy;
+	u8			insn[MAX_UINSN_BYTES];	/* orig instruction */
+};
 
 /*
  * Most architectures can use the default versions of @read_opcode(),
@@ -87,4 +101,22 @@ struct uprobe_consumer {
  *	You may modify @user_bkpt->insn (e.g., the x86_64 port does this
  *	for rip-relative instructions).
  */
+
+#ifdef CONFIG_UPROBES
+extern int register_uprobe(struct inode *inode, unsigned long offset,
+				struct uprobe_consumer *consumer);
+extern void unregister_uprobe(struct inode *inode, unsigned long offset,
+				struct uprobe_consumer *consumer);
+#else /* CONFIG_UPROBES is not defined */
+static inline int register_uprobe(struct inode *inode, unsigned long offset,
+				struct uprobe_consumer *consumer)
+{
+	return -ENOSYS;
+}
+static inline void unregister_uprobe(struct inode *inode, unsigned long offset,
+				struct uprobe_consumer *consumer)
+{
+}
+
+#endif /* CONFIG_UPROBES */
 #endif	/* _LINUX_UPROBES_H */
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index ba8ff99..8a5da38 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -33,17 +33,6 @@
 #include <linux/uprobes.h>
 #include <linux/rmap.h> /* needed for anon_vma_prepare */
 
-struct uprobe {
-	struct rb_node		rb_node;	/* node in the rb tree */
-	atomic_t		ref;		/* lifetime muck */
-	struct rw_semaphore	consumer_rwsem;
-	struct uprobe_consumer	*consumers;
-	struct inode		*inode;		/* we hold a ref */
-	unsigned long		offset;
-	uprobe_opcode_t		opcode;
-	u16			fixups;
-};
-
 /**
  * uprobes_read_vm - Read @nbytes at @vaddr from @tsk into @kbuf.
  * @tsk: The probed task
@@ -459,3 +448,153 @@ static int del_consumer(struct uprobe *uprobe,
 	return ret;
 }
 
+static int install_uprobe(struct mm_struct *mm, struct uprobe *uprobe)
+{
+	int ret = 0;
+
+	/*TODO: install breakpoint */
+	if (!ret)
+		atomic_inc(&mm->uprobes_count);
+	return ret;
+}
+
+static int remove_uprobe(struct mm_struct *mm, struct uprobe *uprobe)
+{
+	int ret = 0;
+
+	/*TODO: remove breakpoint */
+	if (!ret)
+		atomic_dec(&mm->uprobes_count);
+
+	return ret;
+}
+
+/* Returns 0 if it can install one probe */
+int register_uprobe(struct inode *inode, unsigned long offset,
+				struct uprobe_consumer *consumer)
+{
+	struct prio_tree_iter iter;
+	struct list_head tmp_list;
+	struct address_space *mapping;
+	struct mm_struct *mm, *tmpmm;
+	struct vm_area_struct *vma;
+	struct uprobe *uprobe;
+	int ret = -1;
+
+	if (!inode || !consumer || consumer->next)
+		return -EINVAL;
+	uprobe = uprobes_add(inode, offset);
+	INIT_LIST_HEAD(&tmp_list);
+
+	mapping = inode->i_mapping;
+
+	mutex_lock(&uprobes_mutex);
+	if (uprobe->consumers) {
+		ret = 0;
+		goto consumers_add;
+	}
+
+	spin_lock(&mapping->i_mmap_lock);
+	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, 0) {
+		if (!atomic_inc_not_zero(&vma->vm_mm->mm_users))
+			continue;
+
+		mm = vma->vm_mm;
+		if (!valid_vma(vma)) {
+			mmput(mm);
+			continue;
+		}
+
+		list_add(&mm->uprobes_list, &tmp_list);
+		mm->uprobes_vaddr = vma->vm_start + offset;
+	}
+	spin_unlock(&mapping->i_mmap_lock);
+
+	if (list_empty(&tmp_list)) {
+		ret = 0;
+		goto consumers_add;
+	}
+	list_for_each_entry_safe(mm, tmpmm, &tmp_list, uprobes_list) {
+		if (!install_uprobe(mm, uprobe))
+			ret = 0;
+		list_del(&mm->uprobes_list);
+		mmput(mm);
+	}
+
+consumers_add:
+	add_consumer(uprobe, consumer);
+	mutex_unlock(&uprobes_mutex);
+	put_uprobe(uprobe);
+	return ret;
+}
+
+void unregister_uprobe(struct inode *inode, unsigned long offset,
+				struct uprobe_consumer *consumer)
+{
+	struct prio_tree_iter iter;
+	struct list_head tmp_list;
+	struct address_space *mapping;
+	struct mm_struct *mm, *tmpmm;
+	struct vm_area_struct *vma;
+	struct uprobe *uprobe;
+
+	if (!inode || !consumer)
+		return;
+
+	uprobe = find_uprobe(inode, offset);
+	if (!uprobe) {
+		printk(KERN_ERR "No uprobe found with inode:offset %p %lu\n",
+				inode, offset);
+		return;
+	}
+
+	if (!del_consumer(uprobe, consumer)) {
+		printk(KERN_ERR "No uprobe found with consumer %p\n",
+				consumer);
+		return;
+	}
+
+	INIT_LIST_HEAD(&tmp_list);
+
+	mapping = inode->i_mapping;
+
+	mutex_lock(&uprobes_mutex);
+	if (uprobe->consumers)
+		goto put_unlock;
+
+	spin_lock(&mapping->i_mmap_lock);
+	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, 0) {
+		if (!atomic_inc_not_zero(&vma->vm_mm->mm_users))
+			continue;
+
+		mm = vma->vm_mm;
+
+		if (!atomic_read(&mm->uprobes_count)) {
+			mmput(mm);
+			continue;
+		}
+
+		if (valid_vma(vma)) {
+			list_add(&mm->uprobes_list, &tmp_list);
+			mm->uprobes_vaddr = vma->vm_start + offset;
+		} else
+			mmput(mm);
+	}
+	spin_unlock(&mapping->i_mmap_lock);
+	list_for_each_entry_safe(mm, tmpmm, &tmp_list, uprobes_list) {
+		remove_uprobe(mm, uprobe);
+		list_del(&mm->uprobes_list);
+		mmput(mm);
+	}
+
+	if (atomic_read(&uprobe->ref) == 1) {
+		synchronize_sched();
+		rb_erase(&uprobe->rb_node, &uprobes_tree);
+		iput(uprobe->inode);
+	}
+
+put_unlock:
+	mutex_unlock(&uprobes_mutex);
+	put_uprobe(uprobe);
+}
+
