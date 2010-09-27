Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540Ab0I0UFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 16:05:32 -0400
Received: from server109-228-6-235.live-servers.net ([109.228.6.235]:58438
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755947Ab0I0UFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 16:05:31 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] drm: Prune GEM vma entries
Date: Mon, 27 Sep 2010 21:08:36 +0100
Message-Id: <1285618116-10086-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100927115207.633024b1.akpm@linux-foundation.org>
References: <20100927115207.633024b1.akpm@linux-foundation.org>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hook the GEM vm open/close ops into the generic drm vm open/close so
that the vma entries are created and destroy appropriately.

Reported-by: Matt Mackall <mpm@selenic.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/drm_gem.c |    9 ++++++++-
 drivers/gpu/drm/drm_vm.c  |   28 ++++++++++++++++++----------
 include/drm/drmP.h        |    1 +
 3 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index bf92d07..6fe2cd2 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -528,6 +528,10 @@ void drm_gem_vm_open(struct vm_area_struct *vma)
 	struct drm_gem_object *obj = vma->vm_private_data;
 
 	drm_gem_object_reference(obj);
+
+	mutex_lock(&obj->dev->struct_mutex);
+	drm_vm_open_locked(vma);
+	mutex_unlock(&obj->dev->struct_mutex);
 }
 EXPORT_SYMBOL(drm_gem_vm_open);
 
@@ -535,7 +539,10 @@ void drm_gem_vm_close(struct vm_area_struct *vma)
 {
 	struct drm_gem_object *obj = vma->vm_private_data;
 
-	drm_gem_object_unreference_unlocked(obj);
+	mutex_lock(&obj->dev->struct_mutex);
+	drm_vm_close_locked(vma);
+	drm_gem_object_unreference(obj);
+	mutex_unlock(&obj->dev->struct_mutex);
 }
 EXPORT_SYMBOL(drm_gem_vm_close);
 
diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index fda6746..5df4506 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -433,15 +433,7 @@ static void drm_vm_open(struct vm_area_struct *vma)
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
@@ -451,7 +443,6 @@ static void drm_vm_close(struct vm_area_struct *vma)
 		  vma->vm_start, vma->vm_end - vma->vm_start);
 	atomic_dec(&dev->vma_count);
 
-	mutex_lock(&dev->struct_mutex);
 	list_for_each_entry_safe(pt, temp, &dev->vmalist, head) {
 		if (pt->vma == vma) {
 			list_del(&pt->head);
@@ -459,6 +450,23 @@ static void drm_vm_close(struct vm_area_struct *vma)
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
 
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 7809d23..774e1d4 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1175,6 +1175,7 @@ extern int drm_release(struct inode *inode, struct file *filp);
 extern int drm_mmap(struct file *filp, struct vm_area_struct *vma);
 extern int drm_mmap_locked(struct file *filp, struct vm_area_struct *vma);
 extern void drm_vm_open_locked(struct vm_area_struct *vma);
+extern void drm_vm_close_locked(struct vm_area_struct *vma);
 extern resource_size_t drm_core_get_map_ofs(struct drm_local_map * map);
 extern resource_size_t drm_core_get_reg_ofs(struct drm_device *dev);
 extern unsigned int drm_poll(struct file *filp, struct poll_table_struct *wait);
-- 
1.7.1

