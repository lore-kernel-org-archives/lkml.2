Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab2GJK7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:59:34 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53636 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab2GJK6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:58:46 -0400
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: [RFC PATCH 8/8] nouveau: Prime execbuffer submission synchronization
Date: Tue, 10 Jul 2012 12:57:51 +0200
Message-Id: <1341917871-2512-9-git-send-email-m.b.lankhorst@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341917871-2512-1-git-send-email-m.b.lankhorst@gmail.com>
References: <1341917871-2512-1-git-send-email-m.b.lankhorst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_gem.c |  121 +++++++++++++++++++++++++++++++--
 1 file changed, 116 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 11c9c2a..e5d36bb 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -31,6 +31,7 @@
 #include "nouveau_drm.h"
 #include "nouveau_dma.h"
 #include "nouveau_fence.h"
+#include <linux/dma-buf-mgr.h>
 
 #define nouveau_gem_pushbuf_sync(chan) 0
 
@@ -277,6 +278,7 @@ struct validate_op {
 	struct list_head vram_list;
 	struct list_head gart_list;
 	struct list_head both_list;
+	struct list_head prime_list;
 };
 
 static void
@@ -305,9 +307,36 @@ validate_fini_list(struct list_head *list, struct nouveau_fence *fence)
 static void
 validate_fini(struct validate_op *op, struct nouveau_fence* fence)
 {
+	struct list_head *entry, *tmp;
+	struct nouveau_bo *nvbo;
+	struct dma_buf *sync_buf;
+	u32 ofs, val;
+
 	validate_fini_list(&op->vram_list, fence);
 	validate_fini_list(&op->gart_list, fence);
 	validate_fini_list(&op->both_list, fence);
+
+	if (list_empty(&op->prime_list))
+		return;
+
+	if (fence &&
+	    !nouveau_fence_prime_get(fence, &sync_buf, &ofs, &val)) {
+		dmabufmgr_eu_fence_buffer_objects(sync_buf, ofs, val,
+						  &op->prime_list);
+		dma_buf_put(sync_buf);
+	} else
+		dmabufmgr_eu_backoff_reservation(&op->prime_list);
+
+	list_for_each_safe(entry, tmp, &op->prime_list) {
+		struct dmabufmgr_validate *val;
+		val = list_entry(entry, struct dmabufmgr_validate, head);
+		nvbo = val->priv;
+
+		list_del(&val->head);
+		nvbo->reserved_by = NULL;
+		drm_gem_object_unreference_unlocked(nvbo->gem);
+		kfree(val);
+	}
 }
 
 static int
@@ -319,9 +348,9 @@ validate_init(struct nouveau_channel *chan, struct drm_file *file_priv,
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 	uint32_t sequence;
 	int trycnt = 0;
-	int ret, i;
+	int i;
 
-	sequence = atomic_add_return(1, &dev_priv->ttm.validate_sequence);
+	sequence = atomic_inc_return(&dev_priv->ttm.validate_sequence);
 retry:
 	if (++trycnt > 100000) {
 		NV_ERROR(dev, "%s failed and gave up.\n", __func__);
@@ -332,6 +361,8 @@ retry:
 		struct drm_nouveau_gem_pushbuf_bo *b = &pbbo[i];
 		struct drm_gem_object *gem;
 		struct nouveau_bo *nvbo;
+		int ret = 0, is_prime;
+		struct dmabufmgr_validate *validate = NULL;
 
 		gem = drm_gem_object_lookup(dev, file_priv, b->handle);
 		if (!gem) {
@@ -340,6 +371,7 @@ retry:
 			return -ENOENT;
 		}
 		nvbo = gem->driver_private;
+		is_prime = gem->export_dma_buf || gem->import_attach;
 
 		if (nvbo->reserved_by && nvbo->reserved_by == file_priv) {
 			NV_ERROR(dev, "multiple instances of buffer %d on "
@@ -349,7 +381,21 @@ retry:
 			return -EINVAL;
 		}
 
-		ret = ttm_bo_reserve(&nvbo->bo, true, false, true, sequence);
+		if (likely(!is_prime))
+			ret = ttm_bo_reserve(&nvbo->bo, true, false,
+					     true, sequence);
+		else {
+			validate = kzalloc(sizeof(*validate), GFP_KERNEL);
+			if (validate) {
+				if (gem->import_attach)
+					validate->bo =
+						gem->import_attach->dmabuf;
+				else
+					validate->bo = gem->export_dma_buf;
+				validate->priv = nvbo;
+			} else
+				ret = -ENOMEM;
+		}
 		if (ret) {
 			validate_fini(op, NULL);
 			if (unlikely(ret == -EAGAIN))
@@ -366,6 +412,9 @@ retry:
 		b->user_priv = (uint64_t)(unsigned long)nvbo;
 		nvbo->reserved_by = file_priv;
 		nvbo->pbbo_index = i;
+		if (is_prime) {
+			list_add_tail(&validate->head, &op->prime_list);
+		} else
 		if ((b->valid_domains & NOUVEAU_GEM_DOMAIN_VRAM) &&
 		    (b->valid_domains & NOUVEAU_GEM_DOMAIN_GART))
 			list_add_tail(&nvbo->entry, &op->both_list);
@@ -473,6 +522,60 @@ validate_list(struct nouveau_channel *chan, struct list_head *list,
 }
 
 static int
+validate_prime(struct nouveau_channel *chan, struct list_head *list,
+	       struct drm_nouveau_gem_pushbuf_bo *pbbo, uint64_t user_pbbo_ptr)
+{
+	struct drm_nouveau_private *dev_priv = chan->dev->dev_private;
+	struct drm_nouveau_gem_pushbuf_bo __user *upbbo =
+				(void __force __user *)(uintptr_t)user_pbbo_ptr;
+	struct drm_device *dev = chan->dev;
+	struct dmabufmgr_validate *validate;
+	int ret, relocs = 0;
+	bool cpu_validate = false;
+
+	ret = dmabufmgr_eu_reserve_buffers(list);
+	if (ret < 0) {
+		if (ret != -ERESTARTSYS)
+			NV_ERROR(dev, "failed to reserve prime: %d\n", ret);
+		return ret;
+	}
+
+	list_for_each_entry(validate, list, head) {
+		struct nouveau_bo *nvbo = validate->priv;
+		struct drm_nouveau_gem_pushbuf_bo *b = &pbbo[nvbo->pbbo_index];
+
+		if (!cpu_validate)
+			ret = nouveau_fence_sync_prime(chan, validate);
+		if (unlikely(ret == -ENODEV)) {
+			ret = dmabufmgr_eu_wait_completed_cpu(list, 1, 1);
+			cpu_validate = true;
+		}
+		if (unlikely(ret)) {
+			if (ret != -ERESTARTSYS)
+				NV_ERROR(dev, "failed prime sync: %d\n", ret);
+			return ret;
+		}
+
+		if (dev_priv->card_type < NV_50) {
+			if (nvbo->bo.offset == b->presumed.offset &&
+			     b->presumed.domain & NOUVEAU_GEM_DOMAIN_GART)
+				continue;
+
+			b->presumed.domain = NOUVEAU_GEM_DOMAIN_GART;
+			b->presumed.offset = nvbo->bo.offset;
+			b->presumed.valid = 0;
+			relocs++;
+
+			if (DRM_COPY_TO_USER(&upbbo[nvbo->pbbo_index].presumed,
+					     &b->presumed, sizeof(b->presumed)))
+				return -EFAULT;
+		}
+	}
+
+	return relocs;
+}
+
+static int
 nouveau_gem_pushbuf_validate(struct nouveau_channel *chan,
 			     struct drm_file *file_priv,
 			     struct drm_nouveau_gem_pushbuf_bo *pbbo,
@@ -485,6 +588,7 @@ nouveau_gem_pushbuf_validate(struct nouveau_channel *chan,
 	INIT_LIST_HEAD(&op->vram_list);
 	INIT_LIST_HEAD(&op->gart_list);
 	INIT_LIST_HEAD(&op->both_list);
+	INIT_LIST_HEAD(&op->prime_list);
 
 	if (nr_buffers == 0)
 		return 0;
@@ -523,6 +627,13 @@ nouveau_gem_pushbuf_validate(struct nouveau_channel *chan,
 	}
 	relocs += ret;
 
+	ret = validate_prime(chan, &op->prime_list, pbbo, user_buffers);
+	if (unlikely(ret < 0)) {
+		validate_fini(op, NULL);
+		return ret;
+	}
+	relocs += ret;
+
 	*apply_relocs = relocs;
 	return 0;
 }
@@ -782,11 +893,11 @@ nouveau_gem_ioctl_pushbuf(struct drm_device *dev, void *data,
 		}
 	}
 
-	ret = nouveau_fence_new(chan, &fence, false);
+	ret = nouveau_fence_new(chan, &fence, !list_empty(&op.prime_list));
 	if (ret) {
 		NV_ERROR(dev, "error fencing pushbuf: %d\n", ret);
 		WIND_RING(chan);
-		goto out;
+		nouveau_fence_unref(&fence);
 	}
 
 out:
-- 
1.7.9.5

