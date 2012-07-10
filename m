Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab2GJK7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:59:20 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53636 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab2GJK6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:58:21 -0400
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: [RFC PATCH 3/8] nouveau: Extend prime code
Date: Tue, 10 Jul 2012 12:57:46 +0200
Message-Id: <1341917871-2512-4-git-send-email-m.b.lankhorst@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341917871-2512-1-git-send-email-m.b.lankhorst@gmail.com>
References: <1341917871-2512-1-git-send-email-m.b.lankhorst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

The prime code no longer requires the bo to be backed by a gem object,
and cpu access calls have been implemented. This will be needed for
exporting fence bo's.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_drv.h   |    6 +-
 drivers/gpu/drm/nouveau/nouveau_prime.c |  106 +++++++++++++++++++++----------
 2 files changed, 79 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
index 8613cb2..7c52eba 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -1374,11 +1374,15 @@ extern int nouveau_gem_ioctl_cpu_fini(struct drm_device *, void *,
 extern int nouveau_gem_ioctl_info(struct drm_device *, void *,
 				  struct drm_file *);
 
+extern int nouveau_gem_prime_export_bo(struct nouveau_bo *nvbo, int flags,
+				       u32 size, struct dma_buf **ret);
 extern struct dma_buf *nouveau_gem_prime_export(struct drm_device *dev,
 				struct drm_gem_object *obj, int flags);
 extern struct drm_gem_object *nouveau_gem_prime_import(struct drm_device *dev,
 				struct dma_buf *dma_buf);
-
+extern int nouveau_prime_import_bo(struct drm_device *dev,
+				   struct dma_buf *dma_buf,
+				   struct nouveau_bo **pnvbo, bool gem);
 /* nouveau_display.c */
 int nouveau_display_create(struct drm_device *dev);
 void nouveau_display_destroy(struct drm_device *dev);
diff --git a/drivers/gpu/drm/nouveau/nouveau_prime.c b/drivers/gpu/drm/nouveau/nouveau_prime.c
index a25cf2c..537154d3 100644
--- a/drivers/gpu/drm/nouveau/nouveau_prime.c
+++ b/drivers/gpu/drm/nouveau/nouveau_prime.c
@@ -35,7 +35,8 @@ static struct sg_table *nouveau_gem_map_dma_buf(struct dma_buf_attachment *attac
 					  enum dma_data_direction dir)
 {
 	struct nouveau_bo *nvbo = attachment->dmabuf->priv;
-	struct drm_device *dev = nvbo->gem->dev;
+	struct drm_nouveau_private *dev_priv = nouveau_bdev(nvbo->bo.bdev);
+	struct drm_device *dev = dev_priv->dev;
 	int npages = nvbo->bo.num_pages;
 	struct sg_table *sg;
 	int nents;
@@ -59,29 +60,37 @@ static void nouveau_gem_dmabuf_release(struct dma_buf *dma_buf)
 {
 	struct nouveau_bo *nvbo = dma_buf->priv;
 
-	if (nvbo->gem->export_dma_buf == dma_buf) {
-		nvbo->gem->export_dma_buf = NULL;
+	nouveau_bo_unpin(nvbo);
+	if (!nvbo->gem)
+		nouveau_bo_ref(NULL, &nvbo);
+	else {
+		if (nvbo->gem->export_dma_buf == dma_buf)
+			nvbo->gem->export_dma_buf = NULL;
 		drm_gem_object_unreference_unlocked(nvbo->gem);
 	}
 }
 
 static void *nouveau_gem_kmap_atomic(struct dma_buf *dma_buf, unsigned long page_num)
 {
-	return NULL;
+	struct nouveau_bo *nvbo = dma_buf->priv;
+	return kmap_atomic(nvbo->bo.ttm->pages[page_num]);
 }
 
 static void nouveau_gem_kunmap_atomic(struct dma_buf *dma_buf, unsigned long page_num, void *addr)
 {
-
+	kunmap_atomic(addr);
 }
+
 static void *nouveau_gem_kmap(struct dma_buf *dma_buf, unsigned long page_num)
 {
-	return NULL;
+	struct nouveau_bo *nvbo = dma_buf->priv;
+	return kmap(nvbo->bo.ttm->pages[page_num]);
 }
 
 static void nouveau_gem_kunmap(struct dma_buf *dma_buf, unsigned long page_num, void *addr)
 {
-
+	struct nouveau_bo *nvbo = dma_buf->priv;
+	return kunmap(nvbo->bo.ttm->pages[page_num]);
 }
 
 static int nouveau_gem_prime_mmap(struct dma_buf *dma_buf, struct vm_area_struct *vma)
@@ -92,7 +101,8 @@ static int nouveau_gem_prime_mmap(struct dma_buf *dma_buf, struct vm_area_struct
 static void *nouveau_gem_prime_vmap(struct dma_buf *dma_buf)
 {
 	struct nouveau_bo *nvbo = dma_buf->priv;
-	struct drm_device *dev = nvbo->gem->dev;
+	struct drm_nouveau_private *dev_priv = nouveau_bdev(nvbo->bo.bdev);
+	struct drm_device *dev = dev_priv->dev;
 	int ret;
 
 	mutex_lock(&dev->struct_mutex);
@@ -116,7 +126,8 @@ out_unlock:
 static void nouveau_gem_prime_vunmap(struct dma_buf *dma_buf, void *vaddr)
 {
 	struct nouveau_bo *nvbo = dma_buf->priv;
-	struct drm_device *dev = nvbo->gem->dev;
+	struct drm_nouveau_private *dev_priv = nouveau_bdev(nvbo->bo.bdev);
+	struct drm_device *dev = dev_priv->dev;
 
 	mutex_lock(&dev->struct_mutex);
 	nvbo->vmapping_count--;
@@ -140,10 +151,9 @@ static const struct dma_buf_ops nouveau_dmabuf_ops =  {
 };
 
 static int
-nouveau_prime_new(struct drm_device *dev,
-		  size_t size,
+nouveau_prime_new(struct drm_device *dev, size_t size,
 		  struct sg_table *sg,
-		  struct nouveau_bo **pnvbo)
+		  struct nouveau_bo **pnvbo, bool gem)
 {
 	struct nouveau_bo *nvbo;
 	u32 flags = 0;
@@ -156,12 +166,10 @@ nouveau_prime_new(struct drm_device *dev,
 	if (ret)
 		return ret;
 	nvbo = *pnvbo;
-
-	/* we restrict allowed domains on nv50+ to only the types
-	 * that were requested at creation time.  not possibly on
-	 * earlier chips without busting the ABI.
-	 */
 	nvbo->valid_domains = NOUVEAU_GEM_DOMAIN_GART;
+	if (!gem)
+		return 0;
+
 	nvbo->gem = drm_gem_object_alloc(dev, nvbo->bo.mem.size);
 	if (!nvbo->gem) {
 		nouveau_bo_ref(NULL, pnvbo);
@@ -172,22 +180,37 @@ nouveau_prime_new(struct drm_device *dev,
 	return 0;
 }
 
-struct dma_buf *nouveau_gem_prime_export(struct drm_device *dev,
-				struct drm_gem_object *obj, int flags)
+int nouveau_gem_prime_export_bo(struct nouveau_bo *nvbo, int flags,
+				u32 size, struct dma_buf **buf)
 {
-	struct nouveau_bo *nvbo = nouveau_gem_object(obj);
 	int ret = 0;
+	*buf = NULL;
 
 	/* pin buffer into GTT */
 	ret = nouveau_bo_pin(nvbo, TTM_PL_FLAG_TT);
 	if (ret)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
+
+	*buf = dma_buf_export(nvbo, &nouveau_dmabuf_ops, size, flags);
+	if (!IS_ERR(*buf))
+		return 0;
 
-	return dma_buf_export(nvbo, &nouveau_dmabuf_ops, obj->size, flags);
+	nouveau_bo_unpin(nvbo);
+	return PTR_ERR(*buf);
+}
+
+struct dma_buf *nouveau_gem_prime_export(struct drm_device *dev,
+				struct drm_gem_object *obj, int flags)
+{
+	struct nouveau_bo *nvbo = nouveau_gem_object(obj);
+	struct dma_buf *buf;
+	nouveau_gem_prime_export_bo(nvbo, flags, obj->size, &buf);
+	return buf;
 }
 
-struct drm_gem_object *nouveau_gem_prime_import(struct drm_device *dev,
-				struct dma_buf *dma_buf)
+int nouveau_prime_import_bo(struct drm_device *dev,
+			    struct dma_buf *dma_buf,
+			    struct nouveau_bo **pnvbo, bool gem)
 {
 	struct dma_buf_attachment *attach;
 	struct sg_table *sg;
@@ -196,17 +219,22 @@ struct drm_gem_object *nouveau_gem_prime_import(struct drm_device *dev,
 
 	if (dma_buf->ops == &nouveau_dmabuf_ops) {
 		nvbo = dma_buf->priv;
-		if (nvbo->gem) {
+		if (!gem) {
+			nouveau_bo_ref(nvbo, pnvbo);
+			return 0;
+		}
+		else if (nvbo->gem) {
 			if (nvbo->gem->dev == dev) {
 				drm_gem_object_reference(nvbo->gem);
-				return nvbo->gem;
+				*pnvbo = nvbo;
+				return 0;
 			}
 		}
 	}
 	/* need to attach */
 	attach = dma_buf_attach(dma_buf, dev->dev);
 	if (IS_ERR(attach))
-		return ERR_PTR(PTR_ERR(attach));
+		return PTR_ERR(attach);
 
 	sg = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR(sg)) {
@@ -214,18 +242,32 @@ struct drm_gem_object *nouveau_gem_prime_import(struct drm_device *dev,
 		goto fail_detach;
 	}
 
-	ret = nouveau_prime_new(dev, dma_buf->size, sg, &nvbo);
+	ret = nouveau_prime_new(dev, dma_buf->size, sg, pnvbo, gem);
 	if (ret)
 		goto fail_unmap;
 
-	nvbo->gem->import_attach = attach;
-
-	return nvbo->gem;
+	if (gem)
+		(*pnvbo)->gem->import_attach = attach;
+	BUG_ON(attach->priv);
+	attach->priv = *pnvbo;
+	return 0;
 
 fail_unmap:
 	dma_buf_unmap_attachment(attach, sg, DMA_BIDIRECTIONAL);
 fail_detach:
 	dma_buf_detach(dma_buf, attach);
-	return ERR_PTR(ret);
+	return ret;
+}
+
+struct drm_gem_object *
+nouveau_gem_prime_import(struct drm_device *dev, struct dma_buf *dma_buf)
+{
+	struct nouveau_bo *nvbo = NULL;
+	int ret;
+
+	ret = nouveau_prime_import_bo(dev, dma_buf, &nvbo, true);
+	if (ret)
+		return ERR_PTR(ret);
+	return nvbo->gem;
 }
 
-- 
1.7.9.5

