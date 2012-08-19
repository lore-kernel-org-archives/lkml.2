Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab2HSQoU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 12:44:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab2HSQoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 12:44:14 -0400
Date: Sun, 19 Aug 2012 18:40:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] uprobes: introduce MMF_RECALC_UPROBES
Message-ID: <20120819164040.GA25483@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120819164008.GA25454@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new MMF_RECALC_UPROBES flag, it means that MMF_HAS_UPROBES
can be false positive after remove_breakpoint() or uprobe_munmap().
It is also set by uprobe_dup_mmap(), this is not optimal but simple.
We could add the new hook, uprobe_dup_vma(), to set MMF_HAS_UPROBES
only if the new mm actually has uprobes, but I don't think this
makes sense.

The next patch will use this flag to clear MMF_HAS_UPROBES.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h   |    3 ++-
 kernel/events/uprobes.c |   39 +++++++++++++++++++++++++++++++++++----
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c0fcfb7..d6899b0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -441,7 +441,8 @@ extern int get_dumpable(struct mm_struct *mm);
 #define MMF_VM_HUGEPAGE		17	/* set when VM_HUGEPAGE is set on vma */
 #define MMF_EXE_FILE_CHANGED	18	/* see prctl_set_mm_exe_file() */
 
-#define MMF_HAS_UPROBES		19	/* might have uprobes */
+#define MMF_HAS_UPROBES		19	/* has uprobes */
+#define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index abe077e..176de8c 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -686,7 +686,9 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 		set_bit(MMF_HAS_UPROBES, &mm->flags);
 
 	ret = set_swbp(&uprobe->arch, mm, vaddr);
-	if (ret && first_uprobe)
+	if (!ret)
+		clear_bit(MMF_RECALC_UPROBES, &mm->flags);
+	else if (first_uprobe)
 		clear_bit(MMF_HAS_UPROBES, &mm->flags);
 
 	return ret;
@@ -695,6 +697,11 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 static void
 remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, unsigned long vaddr)
 {
+	/* can happen if uprobe_register() fails */
+	if (!test_bit(MMF_HAS_UPROBES, &mm->flags))
+		return;
+
+	set_bit(MMF_RECALC_UPROBES, &mm->flags);
 	set_orig_insn(&uprobe->arch, mm, vaddr);
 }
 
@@ -1027,6 +1034,25 @@ int uprobe_mmap(struct vm_area_struct *vma)
 	return 0;
 }
 
+static bool
+vma_has_uprobes(struct vm_area_struct *vma, unsigned long start, unsigned long end)
+{
+	loff_t min, max;
+	struct inode *inode;
+	struct rb_node *n;
+
+	inode = vma->vm_file->f_mapping->host;
+
+	min = vaddr_to_offset(vma, start);
+	max = min + (end - start) - 1;
+
+	spin_lock(&uprobes_treelock);
+	n = find_node_in_range(inode, min, max);
+	spin_unlock(&uprobes_treelock);
+
+	return !!n;
+}
+
 /*
  * Called in context of a munmap of a vma.
  */
@@ -1038,10 +1064,12 @@ void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned lon
 	if (!atomic_read(&vma->vm_mm->mm_users)) /* called by mmput() ? */
 		return;
 
-	if (!test_bit(MMF_HAS_UPROBES, &vma->vm_mm->flags))
+	if (!test_bit(MMF_HAS_UPROBES, &vma->vm_mm->flags) ||
+	     test_bit(MMF_RECALC_UPROBES, &vma->vm_mm->flags))
 		return;
 
-	/* TODO: unmapping uprobe(s) will need more work */
+	if (vma_has_uprobes(vma, start, end))
+		set_bit(MMF_RECALC_UPROBES, &vma->vm_mm->flags);
 }
 
 /* Slot allocation for XOL */
@@ -1147,8 +1175,11 @@ void uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm)
 {
 	newmm->uprobes_state.xol_area = NULL;
 
-	if (test_bit(MMF_HAS_UPROBES, &oldmm->flags))
+	if (test_bit(MMF_HAS_UPROBES, &oldmm->flags)) {
 		set_bit(MMF_HAS_UPROBES, &newmm->flags);
+		/* unconditionally, dup_mmap() skips VM_DONTCOPY vmas */
+		set_bit(MMF_RECALC_UPROBES, &newmm->flags);
+	}
 }
 
 /*
-- 
1.5.5.1

