Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab0KTBlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 20:41:21 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42754 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab0KTBlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 20:41:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Y8heM/ljHpEc6itOuiCflSJUB3BxTWnOqXWAOlsJxq/G9PmwFmpFTTi6SSMozK8k5y
         2Jfq1aRfYZHgtCNsefyPXqpmZi15IhpQdk6gFpCoBprOdVzFsVnlTz4aBQyBnrGRIyxB
         sUqIyfngDHl+i1VqZFDsqYimwDTBmYiokY8wM=
Date: Sat, 20 Nov 2010 03:41:15 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: use unsigned long inside /proc/*/statm
Message-ID: <20101120014114.GA31477@core2.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/*/statm code needlessly truncates data from unsigned long to int.
One needs only 8+ TB of RAM to make truncation visible.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/array.c      |    6 +++---
 fs/proc/internal.h   |    3 ++-
 fs/proc/task_mmu.c   |    5 +++--
 fs/proc/task_nommu.c |    7 ++++---
 4 files changed, 12 insertions(+), 9 deletions(-)

--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -535,15 +535,15 @@ int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
 int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {
-	int size = 0, resident = 0, shared = 0, text = 0, lib = 0, data = 0;
+	unsigned long size = 0, resident = 0, shared = 0, text = 0, data = 0;
 	struct mm_struct *mm = get_task_mm(task);
 
 	if (mm) {
 		size = task_statm(mm, &shared, &text, &data, &resident);
 		mmput(mm);
 	}
-	seq_printf(m, "%d %d %d %d %d %d %d\n",
-			size, resident, shared, text, lib, data, 0);
+	seq_printf(m, "%lu %lu %lu %lu 0 %lu 0\n",
+			size, resident, shared, text, data);
 
 	return 0;
 }
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -96,7 +96,8 @@ extern spinlock_t proc_subdir_lock;
 struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *);
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir);
 unsigned long task_vsize(struct mm_struct *);
-int task_statm(struct mm_struct *, int *, int *, int *, int *);
+unsigned long task_statm(struct mm_struct *,
+	unsigned long *, unsigned long *, unsigned long *, unsigned long *);
 void task_mem(struct seq_file *, struct mm_struct *);
 
 static inline struct proc_dir_entry *pde_get(struct proc_dir_entry *pde)
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -66,8 +66,9 @@ unsigned long task_vsize(struct mm_struct *mm)
 	return PAGE_SIZE * mm->total_vm;
 }
 
-int task_statm(struct mm_struct *mm, int *shared, int *text,
-	       int *data, int *resident)
+unsigned long task_statm(struct mm_struct *mm,
+			 unsigned long *shared, unsigned long *text,
+			 unsigned long *data, unsigned long *resident)
 {
 	*shared = get_mm_counter(mm, MM_FILEPAGES);
 	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -92,13 +92,14 @@ unsigned long task_vsize(struct mm_struct *mm)
 	return vsize;
 }
 
-int task_statm(struct mm_struct *mm, int *shared, int *text,
-	       int *data, int *resident)
+unsigned long task_statm(struct mm_struct *mm,
+			 unsigned long *shared, unsigned long *text,
+			 unsigned long *data, unsigned long *resident)
 {
 	struct vm_area_struct *vma;
 	struct vm_region *region;
 	struct rb_node *p;
-	int size = kobjsize(mm);
+	unsigned long size = kobjsize(mm);
 
 	down_read(&mm->mmap_sem);
 	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p)) {
