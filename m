Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1BSSyM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 13:54:12 -0500
Received: from smtp-out.google.com ([216.239.44.51]:52655 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab1BSSyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 13:54:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=RQXWLct4cOi0nCK6fMWN1qvqhdbPJSzq6UQl81s5fABTpem1G171ghtDOUvWBj2ZPd
         G6XoPD8XPvqPqR2V1egg==
Date: Sat, 19 Feb 2011 10:54:00 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: supercilious.dude@gmail.com
cc: linux-kernel@vger.kernel.org
Subject: Re: KSM kernel interface
In-Reply-To: <ijnfme$snp$1@dough.gmane.org>
Message-ID: <alpine.LSU.2.00.1102191026070.5067@sister.anvils>
References: <ijnfme$snp$1@dough.gmane.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Feb 2011, supercilious.dude@gmail.com wrote:
> 
> Is there a way to enable KSM globally for all eligible pages in the system
> such that applications need not call madvise() themselves? If not, is there
> a way to do so on behalf of a particular application without an ugly
> LD_PRELOAD hack?

Sorry, there is not.

> 
> Perhaps there is a small kernel modification that might make this possible
> or provide a sysfs flag that enables it (off by default of course)?

Indeed it could be added if there were a general call for it; but ksmd
would tend to get wasteful, and the only call for it that I remember is
for testing.

I expect you've noticed the transparent_hugepage/enabled "always" option,
and you are thinking something like that could be done for KSM: yes.

> 
> I read through the code very briefly, and as far as I can tell, I need to
> add the VM_MERGEABLE flag to all eligible VMAs at the time they are created
> and also __ksm_enter() the associated mm_struct at creation also. Would that
> work?

I think that's right.

Here is the hack I use myself for testing KSM: just boot with option
"allksm" (which here disables randomize_va_space as a side-effect,
to widen the scope of sharing: cut that line out if you prefer).

You may be puzzled by the squashed comments etc: just trying not to
interfere with the line numbering in mm/mmap.c, in case I have other
patches to apply there, or hit a BUG to report.

Hugh
---

 mm/mmap.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- 2.6.37/mm/mmap.c	2011-01-04 16:50:19.000000000 -0800
+++ allksm/mm/mmap.c	2011-01-04 19:47:16.000000000 -0800
@@ -960,9 +960,9 @@ void vm_stat_account(struct mm_struct *m
 #endif /* CONFIG_PROC_FS */
 
 /*
- * The caller must hold down_write(&current->mm->mmap_sem).
- */
-
+ * The caller must hold down_write(&current->mm->mmap_sem). */
+#include <linux/ksm.h>
+unsigned long vm_mergeable;
 unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 			unsigned long len, unsigned long prot,
 			unsigned long flags, unsigned long pgoff)
@@ -1086,7 +1086,7 @@ unsigned long do_mmap_pgoff(struct file
 			/*
 			 * Set pgoff according to addr for anon_vma.
 			 */
-			pgoff = addr >> PAGE_SHIFT;
+			vm_flags |= vm_mergeable; pgoff = addr >> PAGE_SHIFT;
 			break;
 		default:
 			return -EINVAL;
@@ -1303,10 +1303,10 @@ munmap_back:
 		vma->vm_file = file;
 		get_file(file);
 		error = file->f_op->mmap(file, vma);
-		if (error)
-			goto unmap_and_free_vma;
-		if (vm_flags & VM_EXECUTABLE)
-			added_exe_file_vma(mm);
+		if (error) goto unmap_and_free_vma;
+		if (vm_flags & VM_EXECUTABLE) added_exe_file_vma(mm);
+		if (vm_mergeable)
+			ksm_madvise(vma, 0, 0, MADV_MERGEABLE,&vma->vm_flags);
 
 		/* Can addr have changed??
 		 *
@@ -2167,7 +2167,7 @@ unsigned long do_brk(unsigned long addr,
 		return error;
 
 	flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
-
+	flags |= vm_mergeable;
 	error = get_unmapped_area(NULL, addr, len, 0, MAP_FIXED);
 	if (error & ~PAGE_MASK)
 		return error;
@@ -2318,7 +2318,7 @@ int insert_vm_struct(struct mm_struct *
 	if (!vma->vm_file) {
 		BUG_ON(vma->anon_vma);
 		vma->vm_pgoff = vma->vm_start >> PAGE_SHIFT;
-	}
+		vma->vm_flags |= vm_mergeable;	}
 	__vma = find_vma_prepare(mm,vma->vm_start,&prev,&rb_link,&rb_parent);
 	if (__vma && __vma->vm_start < vma->vm_end)
 		return -ENOMEM;
@@ -2677,3 +2677,10 @@ void __init mmap_init(void)
 	ret = percpu_counter_init(&vm_committed_as, 0);
 	VM_BUG_ON(ret);
 }
+static int __init allksm(char *s)
+{
+	randomize_va_space = 0;
+	vm_mergeable = VM_MERGEABLE;
+	return 1;
+}
+__setup("allksm", allksm);
