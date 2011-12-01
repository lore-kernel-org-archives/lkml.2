Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab1LANVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 08:21:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48348 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab1LANVn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 08:21:43 -0500
Message-ID: <1322745659.4699.17.camel@twins>
Subject: Re: [PATCH v7 3.2-rc2 3/30] uprobes: register/unregister probes.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
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
Date: Thu, 01 Dec 2011 14:20:59 +0100
In-Reply-To: <20111118110713.10512.9461.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111118110713.10512.9461.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 16:37 +0530, Srikar Dronamraju wrote:
> +static int __register_uprobe(struct inode *inode, loff_t offset,
> +                               struct uprobe *uprobe)
> +{
> +       struct list_head try_list;
> +       struct vm_area_struct *vma;
> +       struct address_space *mapping;
> +       struct vma_info *vi, *tmpvi;
> +       struct mm_struct *mm;
> +       loff_t vaddr;
> +       int ret = 0;
> +
> +       mapping = inode->i_mapping;
> +       INIT_LIST_HEAD(&try_list);
> +       while ((vi = find_next_vma_info(&try_list, offset,
> +                                               mapping, true)) != NULL) {
> +               if (IS_ERR(vi)) {
> +                       ret = -ENOMEM;
> +                       break;
> +               }
> +               mm = vi->mm;
> +               down_read(&mm->mmap_sem);
> +               vma = find_vma(mm, (unsigned long)vi->vaddr);
> +               if (!vma || !valid_vma(vma, true)) {
> +                       list_del(&vi->probe_list);
> +                       kfree(vi);
> +                       up_read(&mm->mmap_sem);
> +                       mmput(mm);
> +                       continue;
> +               }
> +               vaddr = vma->vm_start + offset;
> +               vaddr -= vma->vm_pgoff << PAGE_SHIFT;
> +               if (vma->vm_file->f_mapping->host != inode ||
> +                                               vaddr != vi->vaddr) {
> +                       list_del(&vi->probe_list);
> +                       kfree(vi);
> +                       up_read(&mm->mmap_sem);
> +                       mmput(mm);
> +                       continue;
> +               }
> +               ret = install_breakpoint(mm);
> +               up_read(&mm->mmap_sem);
> +               mmput(mm);
> +               if (ret && ret == -EEXIST)
> +                       ret = 0;
> +               if (!ret)
> +                       break;
> +       }
> +       list_for_each_entry_safe(vi, tmpvi, &try_list, probe_list) {
> +               list_del(&vi->probe_list);
> +               kfree(vi);
> +       }
> +       return ret;
> +}
> +
> +static void __unregister_uprobe(struct inode *inode, loff_t offset,
> +                                               struct uprobe *uprobe)
> +{
> +       struct list_head try_list;
> +       struct address_space *mapping;
> +       struct vma_info *vi, *tmpvi;
> +       struct vm_area_struct *vma;
> +       struct mm_struct *mm;
> +       loff_t vaddr;
> +
> +       mapping = inode->i_mapping;
> +       INIT_LIST_HEAD(&try_list);
> +       while ((vi = find_next_vma_info(&try_list, offset,
> +                                               mapping, false)) != NULL) {
> +               if (IS_ERR(vi))
> +                       break;
> +               mm = vi->mm;
> +               down_read(&mm->mmap_sem);
> +               vma = find_vma(mm, (unsigned long)vi->vaddr);
> +               if (!vma || !valid_vma(vma, false)) {
> +                       list_del(&vi->probe_list);
> +                       kfree(vi);
> +                       up_read(&mm->mmap_sem);
> +                       mmput(mm);
> +                       continue;
> +               }
> +               vaddr = vma->vm_start + offset;
> +               vaddr -= vma->vm_pgoff << PAGE_SHIFT;
> +               if (vma->vm_file->f_mapping->host != inode ||
> +                                               vaddr != vi->vaddr) {
> +                       list_del(&vi->probe_list);
> +                       kfree(vi);
> +                       up_read(&mm->mmap_sem);
> +                       mmput(mm);
> +                       continue;
> +               }
> +               remove_breakpoint(mm);
> +               up_read(&mm->mmap_sem);
> +               mmput(mm);
> +       }
> +
> +       list_for_each_entry_safe(vi, tmpvi, &try_list, probe_list) {
> +               list_del(&vi->probe_list);
> +               kfree(vi);
> +       }
> +       delete_uprobe(uprobe);
> +} 

I already mentioned on IRC that there's a lot of duplication here and
how to 'solve that'...

Something like the below, it lost the delete_uprobe() bit, and it adds a
few XXX marks where we have to deal with -ENOMEM. Also its not been near
a compiler.

---
 kernel/uprobes.c |   78 ++++++++++++++---------------------------------------
 1 files changed, 21 insertions(+), 57 deletions(-)

diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 2493191..c57284a 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -622,7 +622,7 @@ static int install_breakpoint(struct mm_struct *mm, struct uprobe *uprobe,
 }
 
 static void remove_breakpoint(struct mm_struct *mm, struct uprobe *uprobe,
-							loff_t vaddr)
+			      struct vm_area_struct *vma, loff_t vaddr)
 {
 	if (!set_orig_insn(mm, uprobe, (unsigned long)vaddr, true))
 		atomic_dec(&mm->mm_uprobes_count);
@@ -713,8 +713,10 @@ static struct vma_info *find_next_vma_info(struct list_head *head,
 	return retvi;
 }
 
-static int __register_uprobe(struct inode *inode, loff_t offset,
-				struct uprobe *uprobe)
+typedef int (*vma_func_t)(struct mm_struct *mm, struct uprobe *uprobe,
+			  struct vm_area_struct *vma, unsigned long addr);
+
+static int __for_each_vma(struct uprobe *uprobe, vma_func_t func)
 {
 	struct list_head try_list;
 	struct vm_area_struct *vma;
@@ -724,12 +726,12 @@ static int __register_uprobe(struct inode *inode, loff_t offset,
 	loff_t vaddr;
 	int ret = 0;
 
-	mapping = inode->i_mapping;
+	mapping = uprobe->inode->i_mapping;
 	INIT_LIST_HEAD(&try_list);
-	while ((vi = find_next_vma_info(&try_list, offset,
+	while ((vi = find_next_vma_info(&try_list, uprobe->offset,
 						mapping, true)) != NULL) {
 		if (IS_ERR(vi)) {
-			ret = -ENOMEM;
+			ret = PTR_ERR(vi);
 			break;
 		}
 		mm = vi->mm;
@@ -742,9 +744,9 @@ static int __register_uprobe(struct inode *inode, loff_t offset,
 			mmput(mm);
 			continue;
 		}
-		vaddr = vma->vm_start + offset;
+		vaddr = vma->vm_start + uprobe->offset;
 		vaddr -= vma->vm_pgoff << PAGE_SHIFT;
-		if (vma->vm_file->f_mapping->host != inode ||
+		if (vma->vm_file->f_mapping->host != uprobe->inode ||
 						vaddr != vi->vaddr) {
 			list_del(&vi->probe_list);
 			kfree(vi);
@@ -752,12 +754,12 @@ static int __register_uprobe(struct inode *inode, loff_t offset,
 			mmput(mm);
 			continue;
 		}
-		ret = install_breakpoint(mm, uprobe, vma, vi->vaddr);
+		ret = func(mm, uprobe, vma, vi->vaddr);
 		up_read(&mm->mmap_sem);
 		mmput(mm);
 		if (ret && ret == -EEXIST)
 			ret = 0;
-		if (!ret)
+		if (ret)
 			break;
 	}
 	list_for_each_entry_safe(vi, tmpvi, &try_list, probe_list) {
@@ -767,52 +769,14 @@ static int __register_uprobe(struct inode *inode, loff_t offset,
 	return ret;
 }
 
-static void __unregister_uprobe(struct inode *inode, loff_t offset,
-						struct uprobe *uprobe)
+static int __register_uprobe(struct uprobe *uprobe)
 {
-	struct list_head try_list;
-	struct address_space *mapping;
-	struct vma_info *vi, *tmpvi;
-	struct vm_area_struct *vma;
-	struct mm_struct *mm;
-	loff_t vaddr;
-
-	mapping = inode->i_mapping;
-	INIT_LIST_HEAD(&try_list);
-	while ((vi = find_next_vma_info(&try_list, offset,
-						mapping, false)) != NULL) {
-		if (IS_ERR(vi))
-			break;
-		mm = vi->mm;
-		down_read(&mm->mmap_sem);
-		vma = find_vma(mm, (unsigned long)vi->vaddr);
-		if (!vma || !valid_vma(vma, false)) {
-			list_del(&vi->probe_list);
-			kfree(vi);
-			up_read(&mm->mmap_sem);
-			mmput(mm);
-			continue;
-		}
-		vaddr = vma->vm_start + offset;
-		vaddr -= vma->vm_pgoff << PAGE_SHIFT;
-		if (vma->vm_file->f_mapping->host != inode ||
-						vaddr != vi->vaddr) {
-			list_del(&vi->probe_list);
-			kfree(vi);
-			up_read(&mm->mmap_sem);
-			mmput(mm);
-			continue;
-		}
-		remove_breakpoint(mm, uprobe, vi->vaddr);
-		up_read(&mm->mmap_sem);
-		mmput(mm);
-	}
+	return __for_each_vma(uprobe, install_breakpoint);
+}
 
-	list_for_each_entry_safe(vi, tmpvi, &try_list, probe_list) {
-		list_del(&vi->probe_list);
-		kfree(vi);
-	}
-	delete_uprobe(uprobe);
+static int __unregister_uprobe(struct uprobe *uprobe)
+{
+	return __for_each_vma(uprobe, remove_breakpoint);
 }
 
 /*
@@ -852,10 +816,10 @@ int register_uprobe(struct inode *inode, loff_t offset,
 	mutex_lock(uprobes_hash(inode));
 	uprobe = alloc_uprobe(inode, offset);
 	if (uprobe && !add_consumer(uprobe, consumer)) {
-		ret = __register_uprobe(inode, offset, uprobe);
+		ret = __register_uprobe(uprobe);
 		if (ret) {
 			uprobe->consumers = NULL;
-			__unregister_uprobe(inode, offset, uprobe);
+			__unregister_uprobe(uprobe); // -ENOMEM
 		} else
 			uprobe->flags |= UPROBES_RUN_HANDLER;
 	}
@@ -894,7 +858,7 @@ void unregister_uprobe(struct inode *inode, loff_t offset,
 	}
 
 	if (!uprobe->consumers) {
-		__unregister_uprobe(inode, offset, uprobe);
+		__unregister_uprobe(uprobe); // XXX -ENOMEM
 		uprobe->flags &= ~UPROBES_RUN_HANDLER;
 	}
 	mutex_unlock(uprobes_hash(inode));

