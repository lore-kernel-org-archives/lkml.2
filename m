Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab2AUD5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 22:57:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33910 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab2AUD4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 22:56:41 -0500
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Christopher Lais <chris+android@zenthought.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/2] Staging: android: binder: Add some error checks
Date: Fri, 20 Jan 2012 19:56:20 -0800
Message-Id: <1327118181-3542-2-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327118181-3542-1-git-send-email-arve@android.com>
References: <1327118181-3542-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Add a mutex to protect against two processes mmapping the
  same binder_proc.
- After locking mmap_sem, check that the vma we want to access
  (still) points to the same mm_struct.
- Use proc->tsk instead of current to get the files struct since
  this is where we get the rlimit from.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/staging/android/binder.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 7491801..846b429 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -38,6 +38,7 @@
 
 static DEFINE_MUTEX(binder_lock);
 static DEFINE_MUTEX(binder_deferred_lock);
+static DEFINE_MUTEX(binder_mmap_lock);
 
 static HLIST_HEAD(binder_procs);
 static HLIST_HEAD(binder_deferred_list);
@@ -632,6 +633,11 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 	if (mm) {
 		down_write(&mm->mmap_sem);
 		vma = proc->vma;
+		if (vma && mm != vma->vm_mm) {
+			pr_err("binder: %d: vma mm and task mm mismatch\n",
+				proc->pid);
+			vma = NULL;
+		}
 	}
 
 	if (allocate == 0)
@@ -2803,6 +2809,7 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 	}
 	vma->vm_flags = (vma->vm_flags | VM_DONTCOPY) & ~VM_MAYWRITE;
 
+	mutex_lock(&binder_mmap_lock);
 	if (proc->buffer) {
 		ret = -EBUSY;
 		failure_string = "already mapped";
@@ -2817,6 +2824,7 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 	}
 	proc->buffer = area->addr;
 	proc->user_buffer_offset = vma->vm_start - (uintptr_t)proc->buffer;
+	mutex_unlock(&binder_mmap_lock);
 
 #ifdef CONFIG_CPU_CACHE_VIPT
 	if (cache_is_vipt_aliasing()) {
@@ -2849,7 +2857,7 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 	binder_insert_free_buffer(proc, buffer);
 	proc->free_async_space = proc->buffer_size / 2;
 	barrier();
-	proc->files = get_files_struct(current);
+	proc->files = get_files_struct(proc->tsk);
 	proc->vma = vma;
 
 	/*printk(KERN_INFO "binder_mmap: %d %lx-%lx maps %p\n",
@@ -2860,10 +2868,12 @@ err_alloc_small_buf_failed:
 	kfree(proc->pages);
 	proc->pages = NULL;
 err_alloc_pages_failed:
+	mutex_lock(&binder_mmap_lock);
 	vfree(proc->buffer);
 	proc->buffer = NULL;
 err_get_vm_area_failed:
 err_already_mapped:
+	mutex_unlock(&binder_mmap_lock);
 err_bad_arg:
 	printk(KERN_ERR "binder_mmap: %d %lx-%lx %s failed %d\n",
 	       proc->pid, vma->vm_start, vma->vm_end, failure_string, ret);
-- 
1.7.7.3

