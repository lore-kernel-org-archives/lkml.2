Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab0EQW2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:28:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12924 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348Ab0EQW1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:27:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=LWfHIKecyllmq6hvtphBfbc/pp6Wq0/4uvJeYinGSb7nZVp8HLshvxdKONn/8E52R
	o1cULl5gFqrjRKOlL8vrQ==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 10/10] Use down_read_critical() for /sys/<pid>/exe and /sys/<pid>/maps files
Date: Mon, 17 May 2010 15:25:54 -0700
Message-Id: <1274135154-24082-11-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1274135154-24082-1-git-send-email-walken@google.com>
References: <1274135154-24082-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helps in the following situation:
- Thread A takes a page fault while reading or writing memory.
  do_page_fault() acquires the mmap_sem for read and blocks on disk
  (either reading the page from file, or hitting swap) for a long time.
- Thread B does an mmap call and blocks trying to acquire the mmap_sem
  for write
- Thread C is a monitoring process trying to read every /proc/pid/maps
  in the system. This requires acquiring the mmap_sem for read. Thread C
  blocks behind B, waiting for A to release the rwsem.  If thread C
  could be allowed to run in parallel with A, it would probably get done
  long before thread A's disk access completes, thus not actually slowing
  down thread B.

Test results with down_read_critical_test (10 seconds):

2.6.33.3:
threadA completes ~600 faults
threadB completes ~300 mmap/munmap cycles
threadC completes ~600 /proc/pid/maps reads

2.6.33.3 + down_read_critical:
threadA completes ~600 faults
threadB completes ~300 mmap/munmap cycles
threadC completes ~160000 /proc/pid/maps reads

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 fs/proc/base.c          |    4 ++--
 fs/proc/task_mmu.c      |   24 +++++++++++++++++-------
 include/linux/proc_fs.h |    1 +
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 8418fcc..9201762 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1367,11 +1367,11 @@ struct file *get_mm_exe_file(struct mm_struct *mm)
 
 	/* We need mmap_sem to protect against races with removal of
 	 * VM_EXECUTABLE vmas */
-	down_read(&mm->mmap_sem);
+	down_read_critical(&mm->mmap_sem);
 	exe_file = mm->exe_file;
 	if (exe_file)
 		get_file(exe_file);
-	up_read(&mm->mmap_sem);
+	up_read_critical(&mm->mmap_sem);
 	return exe_file;
 }
 
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 47f5b14..83f9353 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -89,7 +89,10 @@ static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
 {
 	if (vma && vma != priv->tail_vma) {
 		struct mm_struct *mm = vma->vm_mm;
-		up_read(&mm->mmap_sem);
+		if (priv->critical)
+			up_read_critical(&mm->mmap_sem);
+		else
+			up_read(&mm->mmap_sem);
 		mmput(mm);
 	}
 }
@@ -123,7 +126,10 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	mm = mm_for_maps(priv->task);
 	if (!mm)
 		return NULL;
-	down_read(&mm->mmap_sem);
+	if (priv->critical)
+		down_read_critical(&mm->mmap_sem);
+	else
+		down_read(&mm->mmap_sem);
 
 	tail_vma = get_gate_vma(priv->task);
 	priv->tail_vma = tail_vma;
@@ -156,7 +162,10 @@ out:
 
 	/* End of vmas has been reached */
 	m->version = (tail_vma != NULL)? 0: -1UL;
-	up_read(&mm->mmap_sem);
+	if (priv->critical)
+		up_read_critical(&mm->mmap_sem);
+	else
+		up_read(&mm->mmap_sem);
 	mmput(mm);
 	return tail_vma;
 }
@@ -185,13 +194,14 @@ static void m_stop(struct seq_file *m, void *v)
 }
 
 static int do_maps_open(struct inode *inode, struct file *file,
-			const struct seq_operations *ops)
+			const struct seq_operations *ops, int critical)
 {
 	struct proc_maps_private *priv;
 	int ret = -ENOMEM;
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (priv) {
 		priv->pid = proc_pid(inode);
+		priv->critical = critical;
 		ret = seq_open(file, ops);
 		if (!ret) {
 			struct seq_file *m = file->private_data;
@@ -282,7 +292,7 @@ static const struct seq_operations proc_pid_maps_op = {
 
 static int maps_open(struct inode *inode, struct file *file)
 {
-	return do_maps_open(inode, file, &proc_pid_maps_op);
+	return do_maps_open(inode, file, &proc_pid_maps_op, 1);
 }
 
 const struct file_operations proc_maps_operations = {
@@ -432,7 +442,7 @@ static const struct seq_operations proc_pid_smaps_op = {
 
 static int smaps_open(struct inode *inode, struct file *file)
 {
-	return do_maps_open(inode, file, &proc_pid_smaps_op);
+	return do_maps_open(inode, file, &proc_pid_smaps_op, 0);
 }
 
 const struct file_operations proc_smaps_operations = {
@@ -808,7 +818,7 @@ static const struct seq_operations proc_pid_numa_maps_op = {
 
 static int numa_maps_open(struct inode *inode, struct file *file)
 {
-	return do_maps_open(inode, file, &proc_pid_numa_maps_op);
+	return do_maps_open(inode, file, &proc_pid_numa_maps_op, 0);
 }
 
 const struct file_operations proc_numa_maps_operations = {
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 379eaed..66785e7 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -291,6 +291,7 @@ struct proc_maps_private {
 	struct task_struct *task;
 #ifdef CONFIG_MMU
 	struct vm_area_struct *tail_vma;
+	int critical;
 #endif
 };
 
-- 
1.7.0.1

