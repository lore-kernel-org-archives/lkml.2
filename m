Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab1CNNlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 09:41:25 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:47354 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab1CNNlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 09:41:22 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 14 Mar 2011 19:05:36 +0530
Message-Id: <20110314133536.27435.20726.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v2 2.6.38-rc8-tip 8/20]  8: uprobes: mmap and fork hooks.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Provides hooks in mmap and fork.

On fork, after the new mm is created, we need to set the count of
uprobes.  On mmap, check if the mmap region is an executable page and if
its a executable page, walk through the rbtree and insert actual
breakpoints for already registered probes corresponding to this inode.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 include/linux/uprobes.h |   11 +++++-
 kernel/fork.c           |    2 +
 kernel/uprobes.c        |   91 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/mmap.c               |    2 +
 4 files changed, 105 insertions(+), 1 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 8654a06..1f54aae 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -66,6 +66,7 @@ struct uprobe_consumer {
 struct uprobe {
 	struct rb_node		rb_node;	/* node in the rb tree */
 	atomic_t		ref;
+	struct list_head	pending_list;
 	struct rw_semaphore	consumer_rwsem;
 	struct uprobe_arch_info	arch_info;	/* arch specific info if any */
 	struct uprobe_consumer	*consumers;
@@ -99,6 +100,10 @@ extern int register_uprobe(struct inode *inode, loff_t offset,
 				struct uprobe_consumer *consumer);
 extern void unregister_uprobe(struct inode *inode, loff_t offset,
 				struct uprobe_consumer *consumer);
+
+struct vm_area_struct;
+extern void uprobe_mmap(struct vm_area_struct *vma);
+extern void uprobe_dup_mmap(struct mm_struct *old_mm, struct mm_struct *mm);
 #else /* CONFIG_UPROBES is not defined */
 static inline int register_uprobe(struct inode *inode, loff_t offset,
 				struct uprobe_consumer *consumer)
@@ -109,6 +114,10 @@ static inline void unregister_uprobe(struct inode *inode, loff_t offset,
 				struct uprobe_consumer *consumer)
 {
 }
-
+static inline void uprobe_dup_mmap(struct mm_struct *old_mm,
+		struct mm_struct *mm)
+{
+}
+static inline void uprobe_mmap(struct vm_area_struct *vma) { }
 #endif /* CONFIG_UPROBES */
 #endif	/* _LINUX_UPROBES_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 25e4291..b6d6877 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -67,6 +67,7 @@
 #include <linux/user-return-notifier.h>
 #include <linux/oom.h>
 #include <linux/khugepaged.h>
+#include <linux/uprobes.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -418,6 +419,7 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	}
 	/* a new mm has just been created */
 	arch_dup_mmap(oldmm, mm);
+	uprobe_dup_mmap(oldmm, mm);
 	retval = 0;
 out:
 	up_write(&mm->mmap_sem);
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 8730633..8ed5b77 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -378,6 +378,7 @@ static struct uprobe *uprobes_add(struct inode *inode, loff_t offset)
 	}
 	uprobe->inode = inode;
 	uprobe->offset = offset;
+	INIT_LIST_HEAD(&uprobe->pending_list);
 
 	/* add to uprobes_tree, sorted on inode:offset */
 	cur_uprobe = insert_uprobe(uprobe);
@@ -715,3 +716,93 @@ put_unlock:
 	mutex_unlock(&uprobes_mutex);
 	put_uprobe(uprobe);
 }
+
+static void add_to_temp_list(struct vm_area_struct *vma, struct inode *inode,
+		struct list_head *tmp_list)
+{
+	struct uprobe *uprobe;
+	struct rb_node *n;
+	unsigned long flags;
+
+	n = uprobes_tree.rb_node;
+	spin_lock_irqsave(&treelock, flags);
+	uprobe = __find_uprobe(inode, 0, &n);
+	for (; n; n = rb_next(n)) {
+		uprobe = rb_entry(n, struct uprobe, rb_node);
+		if (match_inode(uprobe, inode, &n)) {
+			list_add(&uprobe->pending_list, tmp_list);
+			continue;
+		}
+		break;
+	}
+	spin_unlock_irqrestore(&treelock, flags);
+}
+
+/*
+ * Called from dup_mmap.
+ * called with mm->mmap_sem and old_mm->mmap_sem acquired.
+ */
+void uprobe_dup_mmap(struct mm_struct *old_mm, struct mm_struct *mm)
+{
+	atomic_set(&old_mm->uprobes_count,
+			atomic_read(&mm->uprobes_count));
+}
+
+/*
+ * Called from mmap_region.
+ * called with mm->mmap_sem acquired.
+ */
+void uprobe_mmap(struct vm_area_struct *vma)
+{
+	struct list_head tmp_list;
+	struct uprobe *uprobe, *u;
+	struct mm_struct *mm;
+	struct inode *inode;
+	unsigned long start;
+	unsigned long pgoff;
+
+	if (!valid_vma(vma))
+		return;
+
+	INIT_LIST_HEAD(&tmp_list);
+
+	mm = vma->vm_mm;
+	inode = vma->vm_file->f_mapping->host;
+	start = vma->vm_start;
+	pgoff = vma->vm_pgoff;
+	__iget(inode);
+
+	up_write(&mm->mmap_sem);
+	mutex_lock(&uprobes_mutex);
+	down_read(&mm->mmap_sem);
+
+	vma = find_vma(mm, start);
+	/* Not the same vma */
+	if (!vma || vma->vm_start != start ||
+			vma->vm_pgoff != pgoff || !valid_vma(vma) ||
+			inode->i_mapping != vma->vm_file->f_mapping)
+		goto mmap_out;
+
+	add_to_temp_list(vma, inode, &tmp_list);
+	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
+		loff_t vaddr;
+
+		list_del(&uprobe->pending_list);
+		vaddr = vma->vm_start + uprobe->offset;
+		vaddr -= vma->vm_pgoff << PAGE_SHIFT;
+		if (vaddr > ULONG_MAX)
+			/*
+			 * We cannot have a virtual address that is
+			 * greater than ULONG_MAX
+			 */
+			continue;
+		mm->uprobes_vaddr = (unsigned long)vaddr;
+		install_uprobe(mm, uprobe);
+	}
+
+mmap_out:
+	mutex_unlock(&uprobes_mutex);
+	iput(inode);
+	up_read(&mm->mmap_sem);
+	down_write(&mm->mmap_sem);
+}
diff --git a/mm/mmap.c b/mm/mmap.c
index 2ec8eb5..3836c08 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -30,6 +30,7 @@
 #include <linux/perf_event.h>
 #include <linux/audit.h>
 #include <linux/khugepaged.h>
+#include <linux/uprobes.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1366,6 +1367,7 @@ out:
 			mm->locked_vm += (len >> PAGE_SHIFT);
 	} else if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
 		make_pages_present(addr, addr + len);
+	uprobe_mmap(vma);
 	return addr;
 
 unmap_and_free_vma:
