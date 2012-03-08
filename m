Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217Ab2CHXn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 18:43:56 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:54874 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759056Ab2CHXnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 18:43:53 -0500
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH] Staging: android: binder: Fix use-after-free bug
Date: Thu,  8 Mar 2012 15:43:36 -0800
Message-Id: <1331250216-20666-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <20120306041015.GP23916@ZenIV.linux.org.uk>
References: <20120306041015.GP23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

binder_update_page_range could read freed memory if the vma of the
selected process was freed right before the check that the vma
belongs to the mm struct it just locked.

If the vm_mm pointer in that freed vma struct had also been rewritten
with a value that matched the locked mm struct, then the code would
proceed and possibly modify the freed vma.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/staging/android/binder.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 4350425..be42bf2 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -288,6 +288,7 @@ struct binder_proc {
 	struct rb_root refs_by_node;
 	int pid;
 	struct vm_area_struct *vma;
+	struct mm_struct *vma_vm_mm;
 	struct task_struct *tsk;
 	struct files_struct *files;
 	struct hlist_node deferred_work_node;
@@ -633,7 +634,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 	if (mm) {
 		down_write(&mm->mmap_sem);
 		vma = proc->vma;
-		if (vma && mm != vma->vm_mm) {
+		if (vma && mm != proc->vma_vm_mm) {
 			pr_err("binder: %d: vma mm and task mm mismatch\n",
 				proc->pid);
 			vma = NULL;
@@ -2776,6 +2777,7 @@ static void binder_vma_close(struct vm_area_struct *vma)
 		     (vma->vm_end - vma->vm_start) / SZ_1K, vma->vm_flags,
 		     (unsigned long)pgprot_val(vma->vm_page_prot));
 	proc->vma = NULL;
+	proc->vma_vm_mm = NULL;
 	binder_defer_work(proc, BINDER_DEFERRED_PUT_FILES);
 }
 
@@ -2858,6 +2860,7 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 	barrier();
 	proc->files = get_files_struct(proc->tsk);
 	proc->vma = vma;
+	proc->vma_vm_mm = vma->vm_mm;
 
 	/*printk(KERN_INFO "binder_mmap: %d %lx-%lx maps %p\n",
 		 proc->pid, vma->vm_start, vma->vm_end, proc->buffer);*/
-- 
1.7.7.3

