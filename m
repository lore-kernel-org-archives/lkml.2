Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab0LNKAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:00:07 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:55807 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573Ab0LNKAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:00:05 -0500
Date: Tue, 14 Dec 2010 15:30:13 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch 3/21] Make vma_dump_size() generic
Message-ID: <20101214153013.07878e76@suzukikp>
In-Reply-To: <20101214152259.67896960@suzukikp>
References: <20101214152259.67896960@suzukikp>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vma_dump_size calculates the file size of a vma area in the core file. It 
assumes the vma belongs to the "current". Make it generic to work for any task.
This will be reused by application core dump infrastructure.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 fs/binfmt_elf.c                  |    6 +++---
 fs/elfcore-common.c              |   21 ++++++++++++++-------
 include/linux/elfcore-internal.h |    4 ++--
 3 files changed, 19 insertions(+), 12 deletions(-)

Index: linux-2.6.36-rc7/fs/binfmt_elf.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/binfmt_elf.c
+++ linux-2.6.36-rc7/fs/binfmt_elf.c
@@ -1735,7 +1735,7 @@ static size_t elf_core_vma_data_size(str
 
 	for (vma = first_vma(current, gate_vma); vma != NULL;
 	     vma = next_vma(vma, gate_vma))
-		size += vma_dump_size(vma, mm_flags);
+		size += vma_dump_size(current, vma, mm_flags);
 	return size;
 }
 
@@ -1860,7 +1860,7 @@ static int elf_core_dump(struct coredump
 		phdr.p_offset = offset;
 		phdr.p_vaddr = vma->vm_start;
 		phdr.p_paddr = 0;
-		phdr.p_filesz = vma_dump_size(vma, cprm->mm_flags);
+		phdr.p_filesz = vma_dump_size(current, vma, cprm->mm_flags);
 		phdr.p_memsz = vma->vm_end - vma->vm_start;
 		offset += phdr.p_filesz;
 		phdr.p_flags = vma->vm_flags & VM_READ ? PF_R : 0;
@@ -1895,7 +1895,7 @@ static int elf_core_dump(struct coredump
 		unsigned long addr;
 		unsigned long end;
 
-		end = vma->vm_start + vma_dump_size(vma, cprm->mm_flags);
+		end = vma->vm_start + vma_dump_size(current, vma, cprm->mm_flags);
 
 		for (addr = vma->vm_start; addr < end; addr += PAGE_SIZE) {
 			struct page *page;
Index: linux-2.6.36-rc7/fs/elfcore-common.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/elfcore-common.c
+++ linux-2.6.36-rc7/fs/elfcore-common.c
@@ -50,8 +50,8 @@ struct vm_area_struct *next_vma(struct v
 /*
  * Decide what to dump of a segment, part, all or none.
  */
-unsigned long vma_dump_size(struct vm_area_struct *vma,
-					 unsigned long mm_flags)
+unsigned long vma_dump_size(struct task_struct *p, struct vm_area_struct *vma,
+				unsigned long mm_flags)
 {
 #define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
 
@@ -97,7 +97,6 @@ unsigned long vma_dump_size(struct vm_ar
 	    vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ)) {
 		u32 __user *header = (u32 __user *) vma->vm_start;
 		u32 word;
-		mm_segment_t fs = get_fs();
 		/*
 		 * Doing it this way gets the constant folded by GCC.
 		 */
@@ -114,10 +113,18 @@ unsigned long vma_dump_size(struct vm_ar
 		 * Switch to the user "segment" for get_user(),
 		 * then put back what elf_core_dump() had in place.
 		 */
-		set_fs(USER_DS);
-		if (unlikely(get_user(word, header)))
-			word = 0;
-		set_fs(fs);
+		if (p->group_leader == current->group_leader) {
+			mm_segment_t fs = get_fs();
+			set_fs(USER_DS);
+			if (unlikely(get_user(word, header)))
+				word = 0;
+			set_fs(fs);
+		} else {
+			int bytes = access_process_vm(p, (unsigned long)header,
+						&word, sizeof (word), 0);
+			if (bytes != sizeof(word))
+				word = 0;
+		}
 		if (word == magic.cmp)
 			return PAGE_SIZE;
 	}
Index: linux-2.6.36-rc7/include/linux/elfcore-internal.h
===================================================================
--- linux-2.6.36-rc7.orig/include/linux/elfcore-internal.h
+++ linux-2.6.36-rc7/include/linux/elfcore-internal.h
@@ -37,8 +37,8 @@ extern struct vm_area_struct *first_vma(
 					struct vm_area_struct *gate_vma);
 extern struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
 					struct vm_area_struct *gate_vma);
-extern unsigned long vma_dump_size(struct vm_area_struct *vma,
-					 unsigned long mm_flags);
+extern unsigned long vma_dump_size(struct task_struct *task,
+			struct vm_area_struct *vma, unsigned long mm_flags);
 
 #endif
 #endif
