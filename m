Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726Ab2BJWyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:54:55 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51143 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999Ab2BJWuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:50:06 -0500
MIME-Version: 1.0
Message-Id: <20120210224852.150132339@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:47:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [15/21] Staging: android: binder: Fix crashes when sharing a binder file between processes
In-Reply-To: <20120210224858.GA30752@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Arve Hjønnevåg <arve@android.com>

commit bd1eff9741af27378b241b347041c724bb28e857 upstream.

Opening the binder driver and sharing the file returned with
other processes (e.g. by calling fork) can crash the kernel.
Prevent these crashes with the following changes:
- Add a mutex to protect against two processes mmapping the
  same binder_proc.
- After locking mmap_sem, check that the vma we want to access
  (still) points to the same mm_struct.
- Use proc->tsk instead of current to get the files struct since
  this is where we get the rlimit from.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/android/binder.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -36,6 +36,7 @@
 
 static DEFINE_MUTEX(binder_lock);
 static DEFINE_MUTEX(binder_deferred_lock);
+static DEFINE_MUTEX(binder_mmap_lock);
 
 static HLIST_HEAD(binder_procs);
 static HLIST_HEAD(binder_deferred_list);
@@ -614,6 +615,11 @@ static int binder_update_page_range(stru
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
@@ -2784,6 +2790,7 @@ static int binder_mmap(struct file *filp
 	}
 	vma->vm_flags = (vma->vm_flags | VM_DONTCOPY) & ~VM_MAYWRITE;
 
+	mutex_lock(&binder_mmap_lock);
 	if (proc->buffer) {
 		ret = -EBUSY;
 		failure_string = "already mapped";
@@ -2798,6 +2805,7 @@ static int binder_mmap(struct file *filp
 	}
 	proc->buffer = area->addr;
 	proc->user_buffer_offset = vma->vm_start - (uintptr_t)proc->buffer;
+	mutex_unlock(&binder_mmap_lock);
 
 #ifdef CONFIG_CPU_CACHE_VIPT
 	if (cache_is_vipt_aliasing()) {
@@ -2830,7 +2838,7 @@ static int binder_mmap(struct file *filp
 	binder_insert_free_buffer(proc, buffer);
 	proc->free_async_space = proc->buffer_size / 2;
 	barrier();
-	proc->files = get_files_struct(current);
+	proc->files = get_files_struct(proc->tsk);
 	proc->vma = vma;
 
 	/*printk(KERN_INFO "binder_mmap: %d %lx-%lx maps %p\n",
@@ -2841,10 +2849,12 @@ err_alloc_small_buf_failed:
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


