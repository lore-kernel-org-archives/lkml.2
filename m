Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab1ITMOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 08:14:36 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:45416 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab1ITMOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 08:14:35 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 20 Sep 2011 17:30:57 +0530
Message-Id: <20110920120057.25326.63780.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH v5 3.1.0-rc4-tip 5/26]   Uprobes: copy of the original instruction.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When inserting the first probepoint, save a copy of the original
instruction.  This copy is later used for fixup analysis, copied to the slot
on probe-hit and for restoring the original instruction.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 arch/Kconfig            |    1 
 include/linux/uprobes.h |   12 ++++
 kernel/uprobes.c        |  142 +++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 143 insertions(+), 12 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index dedd489..d6a4e1d 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -63,6 +63,7 @@ config OPTPROBES
 
 config UPROBES
 	bool "User-space probes (EXPERIMENTAL)"
+	select MM_OWNER
 	help
 	  Uprobes enables kernel subsystems to establish probepoints
 	  in user applications and execute handler functions when
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index b4de058..50a8c67 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -26,6 +26,12 @@
 #include <linux/rbtree.h>
 
 struct vm_area_struct;
+#ifdef CONFIG_ARCH_SUPPORTS_UPROBES
+#include <asm/uprobes.h>
+#else
+
+#define MAX_UINSN_BYTES 4
+#endif
 
 struct uprobe_consumer {
 	int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
@@ -46,9 +52,15 @@ struct uprobe {
 	struct uprobe_consumer	*consumers;
 	struct inode		*inode;		/* Also hold a ref to inode */
 	loff_t			offset;
+	int			copy;
+	u8			insn[MAX_UINSN_BYTES];
 };
 
 #ifdef CONFIG_UPROBES
+extern int __weak set_bkpt(struct task_struct *tsk, struct uprobe *uprobe,
+							unsigned long vaddr);
+extern int __weak set_orig_insn(struct task_struct *tsk,
+		struct uprobe *uprobe, unsigned long vaddr, bool verify);
 extern int register_uprobe(struct inode *inode, loff_t offset,
 				struct uprobe_consumer *consumer);
 extern void unregister_uprobe(struct inode *inode, loff_t offset,
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 5bc3f90..e0e10dd 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -23,6 +23,7 @@
 
 #include <linux/kernel.h>
 #include <linux/highmem.h>
+#include <linux/pagemap.h>	/* grab_cache_page */
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/uprobes.h>
@@ -59,6 +60,20 @@ static bool valid_vma(struct vm_area_struct *vma)
 	return false;
 }
 
+int __weak set_bkpt(struct task_struct *tsk, struct uprobe *uprobe,
+						unsigned long vaddr)
+{
+	/* placeholder: yet to be implemented */
+	return 0;
+}
+
+int __weak set_orig_insn(struct task_struct *tsk, struct uprobe *uprobe,
+					unsigned long vaddr, bool verify)
+{
+	/* placeholder: yet to be implemented */
+	return 0;
+}
+
 static int match_uprobe(struct uprobe *l, struct uprobe *r, int *match_inode)
 {
 	/*
@@ -248,22 +263,125 @@ static bool del_consumer(struct uprobe *uprobe,
 	return ret;
 }
 
+static int __copy_insn(struct address_space *mapping,
+			struct vm_area_struct *vma, char *insn,
+			unsigned long nbytes, unsigned long offset)
+{
+	struct file *filp = vma->vm_file;
+	struct page *page;
+	void *vaddr;
+	unsigned long off1;
+	unsigned long idx;
+
+	if (!filp)
+		return -EINVAL;
+
+	idx = (unsigned long) (offset >> PAGE_CACHE_SHIFT);
+	off1 = offset &= ~PAGE_MASK;
+
+	/*
+	 * Ensure that the page that has the original instruction is
+	 * populated and in page-cache.
+	 */
+	page_cache_sync_readahead(mapping, &filp->f_ra, filp, idx, 1);
+	page = grab_cache_page(mapping, idx);
+	if (!page)
+		return -ENOMEM;
+
+	vaddr = kmap_atomic(page);
+	memcpy(insn, vaddr + off1, nbytes);
+	kunmap_atomic(vaddr);
+	unlock_page(page);
+	page_cache_release(page);
+	return 0;
+}
+
+static int copy_insn(struct uprobe *uprobe, struct vm_area_struct *vma,
+					unsigned long addr)
+{
+	struct address_space *mapping;
+	int bytes;
+	unsigned long nbytes;
+
+	addr &= ~PAGE_MASK;
+	nbytes = PAGE_SIZE - addr;
+	mapping = uprobe->inode->i_mapping;
+
+	/* Instruction at end of binary; copy only available bytes */
+	if (uprobe->offset + MAX_UINSN_BYTES > uprobe->inode->i_size)
+		bytes = uprobe->inode->i_size - uprobe->offset;
+	else
+		bytes = MAX_UINSN_BYTES;
+
+	/* Instruction at the page-boundary; copy bytes in second page */
+	if (nbytes < bytes) {
+		if (__copy_insn(mapping, vma, uprobe->insn + nbytes,
+				bytes - nbytes, uprobe->offset + nbytes))
+			return -ENOMEM;
+		bytes = nbytes;
+	}
+	return __copy_insn(mapping, vma, uprobe->insn, bytes, uprobe->offset);
+}
+
+static struct task_struct *get_mm_owner(struct mm_struct *mm)
+{
+	struct task_struct *tsk;
+
+	rcu_read_lock();
+	tsk = rcu_dereference(mm->owner);
+	if (tsk)
+		get_task_struct(tsk);
+	rcu_read_unlock();
+	return tsk;
+}
 
-static int install_breakpoint(struct mm_struct *mm, struct uprobe *uprobe)
+static int install_breakpoint(struct mm_struct *mm, struct uprobe *uprobe,
+				struct vm_area_struct *vma, loff_t vaddr)
 {
-	/* Placeholder: Yet to be implemented */
+	struct task_struct *tsk;
+	unsigned long addr;
+	int ret = -EINVAL;
+
 	if (!uprobe->consumers)
 		return 0;
 
-	atomic_inc(&mm->mm_uprobes_count);
-	return 0;
+	tsk = get_mm_owner(mm);
+	if (!tsk)	/* task is probably exiting; bail-out */
+		return -ESRCH;
+
+	if (vaddr > TASK_SIZE_OF(tsk))
+		goto put_return;
+
+	addr = (unsigned long) vaddr;
+	if (!uprobe->copy) {
+		ret = copy_insn(uprobe, vma, addr);
+		if (ret)
+			goto put_return;
+		/* TODO : Analysis and verification of instruction */
+		uprobe->copy = 1;
+	}
+
+	ret = set_bkpt(tsk, uprobe, addr);
+	if (!ret)
+		atomic_inc(&mm->mm_uprobes_count);
+
+put_return:
+	put_task_struct(tsk);
+	return ret;
 }
 
-static void remove_breakpoint(struct mm_struct *mm, struct uprobe *uprobe)
+static void remove_breakpoint(struct mm_struct *mm, struct uprobe *uprobe,
+							loff_t vaddr)
 {
-	/* Placeholder: Yet to be implemented */
-	atomic_dec(&mm->mm_uprobes_count);
-	return;
+	struct task_struct *tsk = get_mm_owner(mm);
+
+	if (!tsk)	/* task is probably exiting; bail-out */
+		return;
+
+	if (!set_orig_insn(tsk, uprobe, (unsigned long) vaddr, true))
+		atomic_dec(&mm->mm_uprobes_count);
+
+	put_task_struct(tsk);
 }
 
 static void delete_uprobe(struct uprobe *uprobe)
@@ -362,7 +480,7 @@ static int __register_uprobe(struct inode *inode, loff_t offset,
 			mmput(mm);
 			continue;
 		}
-		ret = install_breakpoint(mm, uprobe);
+		ret = install_breakpoint(mm, uprobe, vma, vi->vaddr);
 		if (ret && (ret != -ESRCH || ret != -EEXIST)) {
 			up_read(&mm->mmap_sem);
 			mmput(mm);
@@ -404,7 +522,7 @@ static void __unregister_uprobe(struct inode *inode, loff_t offset,
 			mmput(mm);
 			continue;
 		}
-		remove_breakpoint(mm, uprobe);
+		remove_breakpoint(mm, uprobe, vi->vaddr);
 		up_read(&mm->mmap_sem);
 		mmput(mm);
 	}
@@ -564,8 +682,8 @@ int mmap_uprobe(struct vm_area_struct *vma)
 			vaddr -= vma->vm_pgoff << PAGE_SHIFT;
 			if (vaddr < vma->vm_start || vaddr >= vma->vm_end)
 				continue;
-			ret = install_breakpoint(vma->vm_mm, uprobe);
-
+			ret = install_breakpoint(vma->vm_mm, uprobe, vma,
+								vaddr);
 			if (ret && (ret == -ESRCH || ret == -EEXIST))
 				ret = 0;
 		}
