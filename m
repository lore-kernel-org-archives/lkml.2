Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab2AQEye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 23:54:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39979 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab2AQEyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 23:54:32 -0500
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-man@vger.kernel.org,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Subject: [PATCH] Mark thread stack correctly in proc/<pid>/maps
Date: Tue, 17 Jan 2012 10:24:55 +0530
Message-Id: <1326776095-2629-1-git-send-email-siddhesh.poyarekar@gmail.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <20120116163106.GC7180@jl-vm1.vm.bytemark.co.uk>
References: <20120116163106.GC7180@jl-vm1.vm.bytemark.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Take 2]

Memory mmaped by glibc for a thread stack currently shows up as a simple
anonymous map, which makes it difficult to differentiate between memory
usage of the thread on stack and other dynamic allocation. Since glibc
already uses MAP_STACK to request this mapping, the attached patch
uses this flag to add additional VM_STACK_FLAGS to the resulting vma
so that the mapping is treated as a stack and not any regular
anonymous mapping. Also, one may use vm_flags to decide if a vma is a
stack.

This patch also changes the maps output to annotate stack guards for
both the process stack as well as the thread stacks. Thus is born the
[stack guard] annotation, which should be exactly a page long for the
process stack and can be longer than a page (configurable in
userspace) for POSIX compliant thread stacks. A thread stack guard is
simply page(s) with PROT_NONE.

If accepted, this should also reflect in the man page for mmap since
MAP_STACK will no longer be a noop.

Signed-off-by: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
---
 fs/proc/task_mmu.c |   41 ++++++++++++++++++++++++++++++++++++-----
 include/linux/mm.h |   19 +++++++++++++++++--
 mm/mmap.c          |    3 +++
 3 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e418c5a..650330c 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -227,13 +227,42 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 		pgoff = ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
 	}
 
-	/* We don't show the stack guard page in /proc/maps */
+	/*
+	 * Mark the process stack guard, which is just one page at the
+	 * beginning of the stack within the stack vma.
+	 */
 	start = vma->vm_start;
-	if (stack_guard_page_start(vma, start))
+	if (stack_guard_page_start(vma, start)) {
+		seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
+				start,
+				start + PAGE_SIZE,
+				flags & VM_READ ? 'r' : '-',
+				flags & VM_WRITE ? 'w' : '-',
+				flags & VM_EXEC ? 'x' : '-',
+				flags & VM_MAYSHARE ? 's' : 'p',
+				pgoff,
+				MAJOR(dev), MINOR(dev), ino, &len);
+
+		pad_len_spaces(m, len);
+		seq_puts(m, "[stack guard]\n");
 		start += PAGE_SIZE;
+	}
 	end = vma->vm_end;
-	if (stack_guard_page_end(vma, end))
+	if (stack_guard_page_end(vma, end)) {
+		seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
+				end - PAGE_SIZE,
+				end,
+				flags & VM_READ ? 'r' : '-',
+				flags & VM_WRITE ? 'w' : '-',
+				flags & VM_EXEC ? 'x' : '-',
+				flags & VM_MAYSHARE ? 's' : 'p',
+				pgoff,
+				MAJOR(dev), MINOR(dev), ino, &len);
+
+		pad_len_spaces(m, len);
+		seq_puts(m, "[stack guard]\n");
 		end -= PAGE_SIZE;
+	}
 
 	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
 			start,
@@ -259,8 +288,10 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 				if (vma->vm_start <= mm->brk &&
 						vma->vm_end >= mm->start_brk) {
 					name = "[heap]";
-				} else if (vma->vm_start <= mm->start_stack &&
-					   vma->vm_end >= mm->start_stack) {
+				} else if (vma_is_stack(vma) &&
+					   vma_is_guard(vma)) {
+					name = "[stack guard]";
+				} else if (vma_is_stack(vma)) {
 					name = "[stack]";
 				}
 			} else {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 17b27cd..4e57753 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1018,12 +1018,26 @@ static inline int vma_growsdown(struct vm_area_struct *vma, unsigned long addr)
 	return vma && (vma->vm_end == addr) && (vma->vm_flags & VM_GROWSDOWN);
 }
 
+static inline int vma_is_stack(struct vm_area_struct *vma)
+{
+	return vma && (vma->vm_flags & (VM_GROWSUP | VM_GROWSDOWN));
+}
+
+/*
+ * Check guard set by userspace (PROT_NONE)
+ */
+static inline int vma_is_guard(struct vm_area_struct *vma)
+{
+	return (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC | VM_SHARED)) == 0;
+}
+
 static inline int stack_guard_page_start(struct vm_area_struct *vma,
 					     unsigned long addr)
 {
 	return (vma->vm_flags & VM_GROWSDOWN) &&
 		(vma->vm_start == addr) &&
-		!vma_growsdown(vma->vm_prev, addr);
+		!vma_growsdown(vma->vm_prev, addr) &&
+		!vma_is_guard(vma);
 }
 
 /* Is the vma a continuation of the stack vma below it? */
@@ -1037,7 +1051,8 @@ static inline int stack_guard_page_end(struct vm_area_struct *vma,
 {
 	return (vma->vm_flags & VM_GROWSUP) &&
 		(vma->vm_end == addr) &&
-		!vma_growsup(vma->vm_next, addr);
+		!vma_growsup(vma->vm_next, addr) &&
+		!vma_is_guard(vma);
 }
 
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
diff --git a/mm/mmap.c b/mm/mmap.c
index 3f758c7..2f9f540 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -992,6 +992,9 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 	vm_flags = calc_vm_prot_bits(prot) | calc_vm_flag_bits(flags) |
 			mm->def_flags | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
 
+	if (flags & MAP_STACK)
+		vm_flags |= VM_STACK_FLAGS;
+
 	if (flags & MAP_LOCKED)
 		if (!can_do_mlock())
 			return -EPERM;
-- 
1.7.7.4

