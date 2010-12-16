Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab0LPKB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:01:28 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:39331 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab0LPKBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:01:23 -0500
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
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 16 Dec 2010 15:28:48 +0530
Message-Id: <20101216095848.23751.73144.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
Subject: [RFC] [PATCH 2.6.37-rc5-tip 8/20]  8: uprobes: mmap and fork hooks.
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
 include/linux/uprobes.h |   11 +++++
 kernel/fork.c           |    2 +
 kernel/uprobes.c        |   96 +++++++++++++++++++++++++++++++++++++++++++++++
 mm/mmap.c               |    2 +
 4 files changed, 110 insertions(+), 1 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index f62c7b0..0d4f5e3 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -73,6 +73,7 @@ struct uprobe_consumer {
 struct uprobe {
 	struct rb_node		rb_node;	/* node in the rb tree */
 	atomic_t		ref;
+	struct list_head	pending_list;
 	struct rw_semaphore	consumer_rwsem;
 	struct uprobe_arch_info	arch_info;	/* arch specific info if any */
 	struct uprobe_consumer	*consumers;
@@ -107,6 +108,10 @@ extern int register_uprobe(struct inode *inode, unsigned long offset,
 				struct uprobe_consumer *consumer);
 extern void unregister_uprobe(struct inode *inode, unsigned long offset,
 				struct uprobe_consumer *consumer);
+
+struct vm_area_struct;
+extern void uprobe_mmap(struct vm_area_struct *vma);
+extern void uprobe_dup_mmap(struct mm_struct *old_mm, struct mm_struct *mm);
 #else /* CONFIG_UPROBES is not defined */
 static inline int register_uprobe(struct inode *inode, unsigned long offset,
 				struct uprobe_consumer *consumer)
@@ -117,6 +122,10 @@ static inline void unregister_uprobe(struct inode *inode, unsigned long offset,
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
index 70ea75f..b135d1b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -66,6 +66,7 @@
 #include <linux/posix-timers.h>
 #include <linux/user-return-notifier.h>
 #include <linux/oom.h>
+#include <linux/uprobes.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -415,6 +416,7 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	}
 	/* a new mm has just been created */
 	arch_dup_mmap(oldmm, mm);
+	uprobe_dup_mmap(oldmm, mm);
 	retval = 0;
 out:
 	up_write(&mm->mmap_sem);
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 858ddb1..31867a6 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -380,6 +380,7 @@ static struct uprobe *uprobes_add(struct inode *inode,
 	}
 	uprobe->inode = inode;
 	uprobe->offset = offset;
+	INIT_LIST_HEAD(&uprobe->pending_list);
 
 	/* add to uprobes_tree, sorted on inode:offset */
 	cur_uprobe = insert_uprobe_rb_node(uprobe);
@@ -649,3 +650,98 @@ put_unlock:
 	put_uprobe(uprobe);
 }
 
+static void search_within_subtree(struct rb_node *n, struct inode *inode,
+		struct list_head *tmp_list);
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
+	while (n) {
+		uprobe = rb_entry(n, struct uprobe, rb_node);
+		if (match_inode(uprobe, inode, &n)) {
+			list_add(&uprobe->pending_list, tmp_list);
+			search_within_subtree(n, inode, tmp_list);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&treelock, flags);
+}
+
+static void __search_within_subtree(struct rb_node *p, struct inode *inode,
+		struct list_head *tmp_list)
+{
+	struct uprobe *uprobe;
+
+	uprobe = rb_entry(p, struct uprobe, rb_node);
+	if (match_inode(uprobe, inode, &p)) {
+		list_add(&uprobe->pending_list, tmp_list);
+		search_within_subtree(p, inode, tmp_list);
+	}
+
+
+}
+
+static void search_within_subtree(struct rb_node *n, struct inode *inode,
+		struct list_head *tmp_list)
+{
+	struct rb_node *p;
+
+	p = n->rb_left;
+	if (p)
+		__search_within_subtree(p, inode, tmp_list);
+
+	p = n->rb_right;
+	if (p)
+		__search_within_subtree(p, inode, tmp_list);
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
+void uprobe_mmap(struct vm_area_struct *vma)
+{
+	struct list_head tmp_list;
+	struct uprobe *uprobe, *u;
+	struct mm_struct *mm;
+	struct inode *inode;
+
+	if (!valid_vma(vma))
+		return;
+
+	INIT_LIST_HEAD(&tmp_list);
+
+	/*
+	 * The vma was just allocated and this routine gets called
+	 * while holding write lock for mmap_sem.  Function called
+	 * in context of a thread that has a reference to mm.
+	 * Hence no need to take a reference to mm
+	 */
+	mm = vma->vm_mm;
+	up_write(&mm->mmap_sem);
+	mutex_lock(&uprobes_mutex);
+
+	inode = vma->vm_file->f_mapping->host;
+	add_to_temp_list(vma, inode, &tmp_list);
+
+	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
+		mm->uprobes_vaddr = vma->vm_start + uprobe->offset;
+		install_uprobe(mm, uprobe);
+		list_del(&uprobe->pending_list);
+	}
+	mutex_unlock(&uprobes_mutex);
+	down_write(&mm->mmap_sem);
+}
+
diff --git a/mm/mmap.c b/mm/mmap.c
index b179abb..df7307f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -29,6 +29,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/perf_event.h>
 #include <linux/audit.h>
+#include <linux/uprobes.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1353,6 +1354,7 @@ out:
 			mm->locked_vm += (len >> PAGE_SHIFT);
 	} else if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
 		make_pages_present(addr, addr + len);
+	uprobe_mmap(vma);
 	return addr;
 
 unmap_and_free_vma:
