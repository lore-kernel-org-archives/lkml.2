Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643Ab0JVTIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:08:35 -0400
Received: from kroah.org ([198.145.64.141]:34260 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759420Ab0JVS4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:44 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:33 2010
Message-Id: <20101022185233.108466006@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>
Subject: [064/103] drm: Prune GEM vma entries
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 31dfbc93923c0aaa0440b809f80ff2830c6a531a upstream.

Hook the GEM vm open/close ops into the generic drm vm open/close so
that the private vma entries are created and destroy appropriately.
Fixes the leak of the drm_vma_entries during the lifetime of the filp.

Reported-by: Matt Mackall <mpm@selenic.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_gem.c |    9 ++++++++-
 drivers/gpu/drm/drm_vm.c  |   28 ++++++++++++++++++----------
 include/drm/drmP.h        |    1 +
 3 files changed, 27 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -517,6 +517,10 @@ void drm_gem_vm_open(struct vm_area_stru
 	struct drm_gem_object *obj = vma->vm_private_data;
 
 	drm_gem_object_reference(obj);
+
+	mutex_lock(&obj->dev->struct_mutex);
+	drm_vm_open_locked(vma);
+	mutex_unlock(&obj->dev->struct_mutex);
 }
 EXPORT_SYMBOL(drm_gem_vm_open);
 
@@ -524,7 +528,10 @@ void drm_gem_vm_close(struct vm_area_str
 {
 	struct drm_gem_object *obj = vma->vm_private_data;
 
-	drm_gem_object_unreference_unlocked(obj);
+	mutex_lock(&obj->dev->struct_mutex);
+	drm_vm_close_locked(vma);
+	drm_gem_object_unreference(obj);
+	mutex_unlock(&obj->dev->struct_mutex);
 }
 EXPORT_SYMBOL(drm_gem_vm_close);
 
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -433,15 +433,7 @@ static void drm_vm_open(struct vm_area_s
 	mutex_unlock(&dev->struct_mutex);
 }
 
-/**
- * \c close method for all virtual memory types.
- *
- * \param vma virtual memory area.
- *
- * Search the \p vma private data entry in drm_device::vmalist, unlink it, and
- * free it.
- */
-static void drm_vm_close(struct vm_area_struct *vma)
+void drm_vm_close_locked(struct vm_area_struct *vma)
 {
 	struct drm_file *priv = vma->vm_file->private_data;
 	struct drm_device *dev = priv->minor->dev;
@@ -451,7 +443,6 @@ static void drm_vm_close(struct vm_area_
 		  vma->vm_start, vma->vm_end - vma->vm_start);
 	atomic_dec(&dev->vma_count);
 
-	mutex_lock(&dev->struct_mutex);
 	list_for_each_entry_safe(pt, temp, &dev->vmalist, head) {
 		if (pt->vma == vma) {
 			list_del(&pt->head);
@@ -459,6 +450,23 @@ static void drm_vm_close(struct vm_area_
 			break;
 		}
 	}
+}
+
+/**
+ * \c close method for all virtual memory types.
+ *
+ * \param vma virtual memory area.
+ *
+ * Search the \p vma private data entry in drm_device::vmalist, unlink it, and
+ * free it.
+ */
+static void drm_vm_close(struct vm_area_struct *vma)
+{
+	struct drm_file *priv = vma->vm_file->private_data;
+	struct drm_device *dev = priv->minor->dev;
+
+	mutex_lock(&dev->struct_mutex);
+	drm_vm_close_locked(vma);
 	mutex_unlock(&dev->struct_mutex);
 }
 
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1149,6 +1149,7 @@ extern int drm_release(struct inode *ino
 extern int drm_mmap(struct file *filp, struct vm_area_struct *vma);
 extern int drm_mmap_locked(struct file *filp, struct vm_area_struct *vma);
 extern void drm_vm_open_locked(struct vm_area_struct *vma);
+extern void drm_vm_close_locked(struct vm_area_struct *vma);
 extern resource_size_t drm_core_get_map_ofs(struct drm_local_map * map);
 extern resource_size_t drm_core_get_reg_ofs(struct drm_device *dev);
 extern unsigned int drm_poll(struct file *filp, struct poll_table_struct *wait);


