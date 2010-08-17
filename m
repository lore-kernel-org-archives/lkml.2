Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0HQFHC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 01:07:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab0HQFGz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 01:06:55 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Export mlock information via smaps
Date: Tue, 17 Aug 2010 10:39:31 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-default; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008171039.31070.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is no way to find whether a process has locked its pages in
memory or not. And which of the memory regions are locked in memory.

Add a new field to perms field 'l' to export this information. The information
exported via maps file is not changed.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index a6aca87..c6a9694 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -374,13 +374,18 @@ Swap:                  0 kB
 KernelPageSize:        4 kB
 MMUPageSize:           4 kB
 
-The first  of these lines shows  the same information  as is displayed for the
-mapping in /proc/PID/maps.  The remaining lines show  the size of the mapping,
-the amount of the mapping that is currently resident in RAM, the "proportional
-set size” (divide each shared page by the number of processes sharing it), the
-number of clean and dirty shared pages in the mapping, and the number of clean
-and dirty private pages in the mapping.  The "Referenced" indicates the amount
-of memory currently marked as referenced or accessed.
+The first of these lines shows the same information as is displayed for the
+mapping in /proc/PID/maps, except for "perms", which includes an additional
+field to denote whether a mapping is locked in memory or not.
+
+ l = locked
+
+The remaining lines show  the size of the mapping, the amount of the mapping
+that is currently resident in RAM, the "proportional set size” (divide each
+shared page by the number of processes sharing it), the number of clean and
+dirty shared pages in the mapping, and the number of clean and dirty private
+pages in the mapping.  The "Referenced" indicates the amount of memory currently
+marked as referenced or accessed.
 
 This file is only present if the CONFIG_MMU kernel configuration option is
 enabled.
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index aea1d3f..5f8f344 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -203,7 +203,8 @@ static int do_maps_open(struct inode *inode, struct file *file,
 	return ret;
 }
 
-static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
+static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma,
+							int show_lock)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct file *file = vma->vm_file;
@@ -220,13 +221,14 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 		pgoff = ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
 	}
 
-	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
+	seq_printf(m, "%08lx-%08lx %c%c%c%c%s %08llx %02x:%02x %lu %n",
 			vma->vm_start,
 			vma->vm_end,
 			flags & VM_READ ? 'r' : '-',
 			flags & VM_WRITE ? 'w' : '-',
 			flags & VM_EXEC ? 'x' : '-',
 			flags & VM_MAYSHARE ? 's' : 'p',
+			show_lock ? (flags & VM_LOCKED ? "l" : "-") : "",
 			pgoff,
 			MAJOR(dev), MINOR(dev), ino, &len);
 
@@ -266,7 +268,7 @@ static int show_map(struct seq_file *m, void *v)
 	struct proc_maps_private *priv = m->private;
 	struct task_struct *task = priv->task;
 
-	show_map_vma(m, vma);
+	show_map_vma(m, vma, 0);
 
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task))? vma->vm_start: 0;
@@ -392,7 +394,7 @@ static int show_smap(struct seq_file *m, void *v)
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
 		walk_page_range(vma->vm_start, vma->vm_end, &smaps_walk);
 
-	show_map_vma(m, vma);
+	show_map_vma(m, vma, 1);
 
 	seq_printf(m,
 		   "Size:           %8lu kB\n"

