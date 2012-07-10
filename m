Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab2GJK72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:59:28 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53636 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab2GJK63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:58:29 -0400
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: [RFC PATCH 5/8] nouveau: Add methods preparing for prime fencing
Date: Tue, 10 Jul 2012 12:57:48 +0200
Message-Id: <1341917871-2512-6-git-send-email-m.b.lankhorst@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341917871-2512-1-git-send-email-m.b.lankhorst@gmail.com>
References: <1341917871-2512-1-git-send-email-m.b.lankhorst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

This can be used by nv84 and nvc0 to implement hardware fencing,
earlier systems will require more thought but can fall back to
software for now.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

---
 drivers/gpu/drm/nouveau/nouveau_bo.c      |    6 +-
 drivers/gpu/drm/nouveau/nouveau_channel.c |    2 +-
 drivers/gpu/drm/nouveau/nouveau_display.c |    2 +-
 drivers/gpu/drm/nouveau/nouveau_dma.h     |    1 +
 drivers/gpu/drm/nouveau/nouveau_drv.h     |    5 +
 drivers/gpu/drm/nouveau/nouveau_fence.c   |  242 ++++++++++++++++++++++++++++-
 drivers/gpu/drm/nouveau/nouveau_fence.h   |   44 +++++-
 drivers/gpu/drm/nouveau/nouveau_gem.c     |    6 +-
 drivers/gpu/drm/nouveau/nouveau_prime.c   |    2 +
 drivers/gpu/drm/nouveau/nv04_fence.c      |    4 +-
 drivers/gpu/drm/nouveau/nv10_fence.c      |    4 +-
 drivers/gpu/drm/nouveau/nv84_fence.c      |    4 +-
 drivers/gpu/drm/nouveau/nvc0_fence.c      |    4 +-
 13 files changed, 304 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 4318320..a97025a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -52,6 +52,9 @@ nouveau_bo_del_ttm(struct ttm_buffer_object *bo)
 		DRM_ERROR("bo %p still attached to GEM object\n", bo);
 
 	nv10_mem_put_tile_region(dev, nvbo->tile, NULL);
+
+	if (nvbo->fence_import_attach)
+		nouveau_fence_prime_del_bo(nvbo);
 	kfree(nvbo);
 }
 
@@ -109,6 +112,7 @@ nouveau_bo_new(struct drm_device *dev, int size, int align,
 	INIT_LIST_HEAD(&nvbo->head);
 	INIT_LIST_HEAD(&nvbo->entry);
 	INIT_LIST_HEAD(&nvbo->vma_list);
+	INIT_LIST_HEAD(&nvbo->prime_chan_entries);
 	nvbo->tile_mode = tile_mode;
 	nvbo->tile_flags = tile_flags;
 	nvbo->bo.bdev = &dev_priv->ttm.bdev;
@@ -480,7 +484,7 @@ nouveau_bo_move_accel_cleanup(struct nouveau_channel *chan,
 	struct nouveau_fence *fence = NULL;
 	int ret;
 
-	ret = nouveau_fence_new(chan, &fence);
+	ret = nouveau_fence_new(chan, &fence, false);
 	if (ret)
 		return ret;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_channel.c b/drivers/gpu/drm/nouveau/nouveau_channel.c
index 629d8a2..85a8556 100644
--- a/drivers/gpu/drm/nouveau/nouveau_channel.c
+++ b/drivers/gpu/drm/nouveau/nouveau_channel.c
@@ -362,7 +362,7 @@ nouveau_channel_idle(struct nouveau_channel *chan)
 	struct nouveau_fence *fence = NULL;
 	int ret;
 
-	ret = nouveau_fence_new(chan, &fence);
+	ret = nouveau_fence_new(chan, &fence, false);
 	if (!ret) {
 		ret = nouveau_fence_wait(fence, false, false);
 		nouveau_fence_unref(&fence);
diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index 69688ef..7c76776 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -466,7 +466,7 @@ nouveau_page_flip_emit(struct nouveau_channel *chan,
 	}
 	FIRE_RING (chan);
 
-	ret = nouveau_fence_new(chan, pfence);
+	ret = nouveau_fence_new(chan, pfence, false);
 	if (ret)
 		goto fail;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_dma.h b/drivers/gpu/drm/nouveau/nouveau_dma.h
index 8db68be..d02ffd3 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dma.h
+++ b/drivers/gpu/drm/nouveau/nouveau_dma.h
@@ -74,6 +74,7 @@ enum {
 	NvEvoSema0	= 0x80000010,
 	NvEvoSema1	= 0x80000011,
 	NvNotify1       = 0x80000012,
+	NvSemaPrime	= 0x8000001f,
 
 	/* G80+ display objects */
 	NvEvoVRAM	= 0x01000000,
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
index 2c17989..ad49594 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -126,6 +126,11 @@ struct nouveau_bo {
 
 	struct ttm_bo_kmap_obj dma_buf_vmap;
 	int vmapping_count;
+
+	/* fence related stuff */
+	struct nouveau_bo *sync_bo;
+	struct list_head prime_chan_entries;
+	struct dma_buf_attachment *fence_import_attach;
 };
 
 #define nouveau_bo_tile_layout(nvbo)				\
diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.c b/drivers/gpu/drm/nouveau/nouveau_fence.c
index 3c18049..d4c9c40 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -29,17 +29,64 @@
 
 #include <linux/ktime.h>
 #include <linux/hrtimer.h>
+#include <linux/dma-buf.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_ramht.h"
 #include "nouveau_fence.h"
 #include "nouveau_software.h"
 #include "nouveau_dma.h"
+#include "nouveau_fifo.h"
+
+int nouveau_fence_prime_init(struct drm_device *dev,
+			     struct nouveau_fence_priv *priv, u32 align)
+{
+	int ret = 0;
+#ifdef CONFIG_DMA_SHARED_BUFFER
+	struct nouveau_fifo_priv *pfifo = nv_engine(dev, NVOBJ_ENGINE_FIFO);
+	u32 size = PAGE_ALIGN(pfifo->channels * align);
+
+	mutex_init(&priv->prime_lock);
+	priv->prime_align = align;
+	ret = nouveau_bo_new(dev, size, 0, TTM_PL_FLAG_TT,
+			     0, 0, NULL, &priv->prime_bo);
+	if (ret)
+		return ret;
+	ret = nouveau_bo_map(priv->prime_bo);
+	if (ret)
+		goto err;
+
+	ret = nouveau_gem_prime_export_bo(priv->prime_bo, 0400, size,
+					  &priv->prime_buf);
+	if (ret) {
+		priv->prime_buf = NULL;
+		nouveau_bo_unmap(priv->prime_bo);
+		goto err;
+	}
+	return 0;
+
+err:
+	nouveau_bo_ref(NULL, &priv->prime_bo);
+#endif
+	return ret;
+}
+
+void nouveau_fence_prime_del(struct nouveau_fence_priv *priv)
+{
+	/* Our reference to prime_bo is released by freeing prime_buf */
+	if (priv->prime_buf)
+		dma_buf_put(priv->prime_buf);
+	priv->prime_bo = NULL;
+
+}
 
 void
-nouveau_fence_context_del(struct nouveau_fence_chan *fctx)
+nouveau_fence_context_del(struct drm_device *dev,
+			  struct nouveau_fence_chan *fctx)
 {
 	struct nouveau_fence *fence, *fnext;
+	struct nouveau_fence_priv *priv = nv_engine(dev, NVOBJ_ENGINE_FENCE);
+
 	spin_lock(&fctx->lock);
 	list_for_each_entry_safe(fence, fnext, &fctx->pending, head) {
 		if (fence->work)
@@ -49,6 +96,21 @@ nouveau_fence_context_del(struct nouveau_fence_chan *fctx)
 		nouveau_fence_unref(&fence);
 	}
 	spin_unlock(&fctx->lock);
+	if (list_empty(&fctx->prime_sync_list))
+		return;
+
+	mutex_lock(&priv->prime_lock);
+	while (!list_empty(&fctx->prime_sync_list)) {
+		struct nouveau_fence_prime_bo_entry *entry;
+		entry = list_first_entry(&fctx->prime_sync_list,
+					 struct nouveau_fence_prime_bo_entry,
+					 chan_entry);
+
+		list_del(&entry->chan_entry);
+		list_del(&entry->bo_entry);
+		kfree(entry);
+	}
+	mutex_unlock(&priv->prime_lock);
 }
 
 void
@@ -56,6 +118,7 @@ nouveau_fence_context_new(struct nouveau_fence_chan *fctx)
 {
 	INIT_LIST_HEAD(&fctx->pending);
 	spin_lock_init(&fctx->lock);
+	INIT_LIST_HEAD(&fctx->prime_sync_list);
 }
 
 void
@@ -81,7 +144,8 @@ nouveau_fence_update(struct nouveau_channel *chan)
 }
 
 int
-nouveau_fence_emit(struct nouveau_fence *fence, struct nouveau_channel *chan)
+nouveau_fence_emit(struct nouveau_fence *fence,
+		   struct nouveau_channel *chan, bool prime)
 {
 	struct drm_device *dev = chan->dev;
 	struct nouveau_fence_priv *priv = nv_engine(dev, NVOBJ_ENGINE_FENCE);
@@ -92,7 +156,7 @@ nouveau_fence_emit(struct nouveau_fence *fence, struct nouveau_channel *chan)
 	fence->timeout  = jiffies + (3 * DRM_HZ);
 	fence->sequence = ++fctx->sequence;
 
-	ret = priv->emit(fence);
+	ret = priv->emit(fence, prime);
 	if (!ret) {
 		kref_get(&fence->kref);
 		spin_lock(&fctx->lock);
@@ -165,6 +229,173 @@ nouveau_fence_sync(struct nouveau_fence *fence, struct nouveau_channel *chan)
 	return ret;
 }
 
+static int
+nouveau_fence_prime_attach_sync(struct drm_device *dev,
+				struct nouveau_fence_priv *priv,
+				struct nouveau_bo *bo,
+				struct dma_buf *sync_buf)
+{
+	struct dma_buf_attachment *attach;
+	int ret;
+
+	if (bo->sync_bo &&
+	    sync_buf == bo->sync_bo->fence_import_attach->dmabuf)
+		return 0;
+
+	mutex_lock(&sync_buf->lock);
+	list_for_each_entry(attach, &sync_buf->attachments, node) {
+		if (attach->dev == dev->dev) {
+			nouveau_bo_ref(attach->priv, &bo->sync_bo);
+			mutex_unlock(&sync_buf->lock);
+			return 0;
+		}
+	}
+	mutex_unlock(&sync_buf->lock);
+
+	nouveau_bo_ref(NULL, &bo->sync_bo);
+	get_dma_buf(sync_buf);
+	ret = nouveau_prime_import_bo(dev, sync_buf, &bo->sync_bo, 0);
+	if (ret)
+		dma_buf_put(sync_buf);
+	return ret;
+}
+
+static int
+nouveau_fence_prime_attach(struct nouveau_channel *chan,
+			   struct nouveau_bo *bo,
+			   struct dma_buf *sync_buf,
+			   struct nouveau_fence_prime_bo_entry **pentry)
+{
+	struct nouveau_fence_chan *fctx = chan->engctx[NVOBJ_ENGINE_FENCE];
+	struct nouveau_fence_priv *priv;
+	struct nouveau_fence_prime_bo_entry *entry;
+	struct nouveau_bo *sync;
+	int ret;
+
+	/* new to chan or already existing */
+	priv = nv_engine(chan->dev, NVOBJ_ENGINE_FENCE);
+	ret = nouveau_fence_prime_attach_sync(chan->dev, priv, bo, sync_buf);
+	if (ret)
+		return ret;
+
+	sync = bo->sync_bo;
+	list_for_each_entry (entry, &sync->prime_chan_entries, bo_entry) {
+		if (entry->chan == chan) {
+			*pentry = entry;
+			return 0;
+		}
+	}
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	entry->chan = chan;
+	entry->bo = sync;
+	ret = priv->prime_add_import(entry);
+	if (!ret) {
+		list_add_tail(&entry->chan_entry, &fctx->prime_sync_list);
+		list_add_tail(&entry->bo_entry, &sync->prime_chan_entries);
+		*pentry = entry;
+	} else
+		kfree(entry);
+	return ret;
+}
+
+int nouveau_fence_sync_prime(struct nouveau_channel *chan,
+			     struct dmabufmgr_validate *val)
+{
+	struct drm_device *dev = chan->dev;
+	struct nouveau_fence_priv *priv = nv_engine(dev, NVOBJ_ENGINE_FENCE);
+	struct nouveau_fence_prime_bo_entry *e = NULL;
+	int ret;
+
+	if (!val->sync_buf)
+		return 0;
+	if (!priv || !priv->prime_sync ||
+	    !priv->prime_add_import || !priv->prime_del_import)
+		return -ENODEV;
+
+	if (priv->prime_buf == val->sync_buf)
+		return priv->prime_sync(chan, val->sync_buf->priv, val->sync_ofs, val->sync_val, 0);
+
+	mutex_lock(&priv->prime_lock);
+	ret = nouveau_fence_prime_attach(chan, val->priv,
+					 val->sync_buf, &e);
+	if (!ret)
+		ret = priv->prime_sync(chan, e->bo, val->sync_ofs,
+				       val->sync_val, e->sema_start);
+	mutex_unlock(&priv->prime_lock);
+	return ret;
+}
+
+int nouveau_fence_prime_get(struct nouveau_fence *fence,
+			    struct dma_buf **sync_buf, u32 *ofs, u32 *val)
+{
+	struct drm_device *dev = fence->channel->dev;
+	struct nouveau_fence_priv *priv = nv_engine(dev, NVOBJ_ENGINE_FENCE);
+
+	if (!priv->prime_sync)
+		return -ENODEV;
+
+	get_dma_buf(priv->prime_buf);
+	*sync_buf = priv->prime_buf;
+	*ofs = priv->prime_align * fence->channel->id;
+	*val = fence->sequence;
+	return 0;
+}
+
+static void
+nouveau_fence_prime_del_import(struct nouveau_bo *nvbo)
+{
+	struct drm_nouveau_private *dev_priv = nouveau_bdev(nvbo->bo.bdev);
+	struct dma_buf_attachment *attach = nvbo->fence_import_attach;
+	struct nouveau_fence_priv *priv;
+	struct dma_buf *dma_buf;
+
+	priv = (struct nouveau_fence_priv *)dev_priv->eng[NVOBJ_ENGINE_FENCE];
+
+	while (!list_empty(&nvbo->prime_chan_entries)) {
+		struct nouveau_fence_prime_bo_entry *entry;
+		entry = list_first_entry(&nvbo->prime_chan_entries,
+					 struct nouveau_fence_prime_bo_entry,
+					 bo_entry);
+
+		priv->prime_del_import(entry);
+		list_del(&entry->chan_entry);
+		list_del(&entry->bo_entry);
+		kfree(entry);
+	}
+
+	dma_buf_unmap_attachment(attach, nvbo->bo.sg, DMA_BIDIRECTIONAL);
+	dma_buf = attach->dmabuf;
+	dma_buf_detach(attach->dmabuf, attach);
+	dma_buf_put(dma_buf);
+}
+
+
+void nouveau_fence_prime_del_bo(struct nouveau_bo *nvbo)
+{
+	struct drm_nouveau_private *dev_priv = nouveau_bdev(nvbo->bo.bdev);
+	struct nouveau_fence_priv *priv;
+	priv = (struct nouveau_fence_priv *)dev_priv->eng[NVOBJ_ENGINE_FENCE];
+
+	BUG_ON(!priv->prime_del_import);
+
+	/* Impossible situation: we are a sync_bo synced to another
+	 * sync bo?
+	 */
+	BUG_ON(nvbo->sync_bo && nvbo->fence_import_attach);
+
+	if (nvbo->sync_bo) {
+		mutex_lock(&priv->prime_lock);
+		nouveau_bo_ref(NULL, &nvbo->sync_bo);
+		mutex_unlock(&priv->prime_lock);
+	}
+	else if (nvbo->fence_import_attach)
+		nouveau_fence_prime_del_import(nvbo);
+}
+
 static void
 nouveau_fence_del(struct kref *kref)
 {
@@ -188,7 +419,8 @@ nouveau_fence_ref(struct nouveau_fence *fence)
 }
 
 int
-nouveau_fence_new(struct nouveau_channel *chan, struct nouveau_fence **pfence)
+nouveau_fence_new(struct nouveau_channel *chan,
+		  struct nouveau_fence **pfence, bool prime)
 {
 	struct nouveau_fence *fence;
 	int ret = 0;
@@ -202,7 +434,7 @@ nouveau_fence_new(struct nouveau_channel *chan, struct nouveau_fence **pfence)
 	kref_init(&fence->kref);
 
 	if (chan) {
-		ret = nouveau_fence_emit(fence, chan);
+		ret = nouveau_fence_emit(fence, chan, prime);
 		if (ret)
 			nouveau_fence_unref(&fence);
 	}
diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.h b/drivers/gpu/drm/nouveau/nouveau_fence.h
index 82ba733..016502e 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fence.h
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.h
@@ -1,6 +1,8 @@
 #ifndef __NOUVEAU_FENCE_H__
 #define __NOUVEAU_FENCE_H__
 
+#include <linux/dma-buf-mgr.h>
+
 struct nouveau_fence {
 	struct list_head head;
 	struct kref kref;
@@ -13,34 +15,68 @@ struct nouveau_fence {
 	void *priv;
 };
 
-int  nouveau_fence_new(struct nouveau_channel *, struct nouveau_fence **);
+int  nouveau_fence_new(struct nouveau_channel *,
+		       struct nouveau_fence **,
+		       bool prime);
+
 struct nouveau_fence *
 nouveau_fence_ref(struct nouveau_fence *);
 void nouveau_fence_unref(struct nouveau_fence **);
 
-int  nouveau_fence_emit(struct nouveau_fence *, struct nouveau_channel *);
+int  nouveau_fence_emit(struct nouveau_fence *,
+			struct nouveau_channel *, bool prime);
 bool nouveau_fence_done(struct nouveau_fence *);
 int  nouveau_fence_wait(struct nouveau_fence *, bool lazy, bool intr);
 int  nouveau_fence_sync(struct nouveau_fence *, struct nouveau_channel *);
+int nouveau_fence_sync_prime(struct nouveau_channel *,
+			     struct dmabufmgr_validate *);
 void nouveau_fence_idle(struct nouveau_channel *);
 void nouveau_fence_update(struct nouveau_channel *);
+int nouveau_fence_prime_get(struct nouveau_fence *fence,
+			    struct dma_buf **sync_buf, u32 *ofs, u32 *val);
+void nouveau_fence_prime_del_bo(struct nouveau_bo *bo);
 
 struct nouveau_fence_chan {
 	struct list_head pending;
 	spinlock_t lock;
 	u32 sequence;
+	struct list_head prime_sync_list;
+};
+
+struct nouveau_fence_prime_bo_entry {
+	struct list_head bo_entry;
+	struct list_head chan_entry;
+	struct nouveau_bo *bo;
+	struct nouveau_channel *chan;
+
+	u64 sema_start, sema_len;
+	struct nouveau_vma vma;
 };
 
 struct nouveau_fence_priv {
 	struct nouveau_exec_engine engine;
-	int (*emit)(struct nouveau_fence *);
+	int (*emit)(struct nouveau_fence *, bool prime);
 	int (*sync)(struct nouveau_fence *, struct nouveau_channel *,
 		    struct nouveau_channel *);
 	u32 (*read)(struct nouveau_channel *);
+	int (*prime_sync)(struct nouveau_channel *chan, struct nouveau_bo *bo,
+			  u32 ofs, u32 val, u64 sema_start);
+	int (*prime_add_import)(struct nouveau_fence_prime_bo_entry *);
+	void (*prime_del_import)(struct nouveau_fence_prime_bo_entry *);
+
+	struct mutex prime_lock;
+	struct dma_buf *prime_buf;
+	struct nouveau_bo *prime_bo;
+	u32 prime_align;
 };
 
+int nouveau_fence_prime_init(struct drm_device *,
+			     struct nouveau_fence_priv *, u32 align);
+void nouveau_fence_prime_del(struct nouveau_fence_priv *priv);
+
 void nouveau_fence_context_new(struct nouveau_fence_chan *);
-void nouveau_fence_context_del(struct nouveau_fence_chan *);
+void nouveau_fence_context_del(struct drm_device *,
+			       struct nouveau_fence_chan *);
 
 int nv04_fence_create(struct drm_device *dev);
 int nv04_fence_mthd(struct nouveau_channel *, u32, u32, u32);
diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 34d0bc5..11c9c2a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -55,8 +55,10 @@ nouveau_gem_object_del(struct drm_gem_object *gem)
 		nouveau_bo_unpin(nvbo);
 	}
 
-	if (gem->import_attach)
+	if (gem->import_attach) {
+		nouveau_fence_prime_del_bo(nvbo);
 		drm_prime_gem_destroy(gem, nvbo->bo.sg);
+	}
 
 	ttm_bo_unref(&bo);
 
@@ -780,7 +782,7 @@ nouveau_gem_ioctl_pushbuf(struct drm_device *dev, void *data,
 		}
 	}
 
-	ret = nouveau_fence_new(chan, &fence);
+	ret = nouveau_fence_new(chan, &fence, false);
 	if (ret) {
 		NV_ERROR(dev, "error fencing pushbuf: %d\n", ret);
 		WIND_RING(chan);
diff --git a/drivers/gpu/drm/nouveau/nouveau_prime.c b/drivers/gpu/drm/nouveau/nouveau_prime.c
index 537154d3..3b6be0e 100644
--- a/drivers/gpu/drm/nouveau/nouveau_prime.c
+++ b/drivers/gpu/drm/nouveau/nouveau_prime.c
@@ -248,6 +248,8 @@ int nouveau_prime_import_bo(struct drm_device *dev,
 
 	if (gem)
 		(*pnvbo)->gem->import_attach = attach;
+	else
+		(*pnvbo)->fence_import_attach = attach;
 	BUG_ON(attach->priv);
 	attach->priv = *pnvbo;
 	return 0;
diff --git a/drivers/gpu/drm/nouveau/nv04_fence.c b/drivers/gpu/drm/nouveau/nv04_fence.c
index abe89db..959d072 100644
--- a/drivers/gpu/drm/nouveau/nv04_fence.c
+++ b/drivers/gpu/drm/nouveau/nv04_fence.c
@@ -38,7 +38,7 @@ struct nv04_fence_priv {
 };
 
 static int
-nv04_fence_emit(struct nouveau_fence *fence)
+nv04_fence_emit(struct nouveau_fence *fence, bool prime)
 {
 	struct nouveau_channel *chan = fence->channel;
 	int ret = RING_SPACE(chan, 2);
@@ -76,7 +76,7 @@ static void
 nv04_fence_context_del(struct nouveau_channel *chan, int engine)
 {
 	struct nv04_fence_chan *fctx = chan->engctx[engine];
-	nouveau_fence_context_del(&fctx->base);
+	nouveau_fence_context_del(chan->dev, &fctx->base);
 	chan->engctx[engine] = NULL;
 	kfree(fctx);
 }
diff --git a/drivers/gpu/drm/nouveau/nv10_fence.c b/drivers/gpu/drm/nouveau/nv10_fence.c
index 8a1b750..b7742e7 100644
--- a/drivers/gpu/drm/nouveau/nv10_fence.c
+++ b/drivers/gpu/drm/nouveau/nv10_fence.c
@@ -40,7 +40,7 @@ struct nv10_fence_priv {
 };
 
 static int
-nv10_fence_emit(struct nouveau_fence *fence)
+nv10_fence_emit(struct nouveau_fence *fence, bool prime)
 {
 	struct nouveau_channel *chan = fence->channel;
 	int ret = RING_SPACE(chan, 2);
@@ -109,7 +109,7 @@ static void
 nv10_fence_context_del(struct nouveau_channel *chan, int engine)
 {
 	struct nv10_fence_chan *fctx = chan->engctx[engine];
-	nouveau_fence_context_del(&fctx->base);
+	nouveau_fence_context_del(chan->dev, &fctx->base);
 	chan->engctx[engine] = NULL;
 	kfree(fctx);
 }
diff --git a/drivers/gpu/drm/nouveau/nv84_fence.c b/drivers/gpu/drm/nouveau/nv84_fence.c
index c2f889b..b5cfbcb 100644
--- a/drivers/gpu/drm/nouveau/nv84_fence.c
+++ b/drivers/gpu/drm/nouveau/nv84_fence.c
@@ -39,7 +39,7 @@ struct nv84_fence_priv {
 };
 
 static int
-nv84_fence_emit(struct nouveau_fence *fence)
+nv84_fence_emit(struct nouveau_fence *fence, bool prime)
 {
 	struct nouveau_channel *chan = fence->channel;
 	int ret = RING_SPACE(chan, 7);
@@ -86,7 +86,7 @@ static void
 nv84_fence_context_del(struct nouveau_channel *chan, int engine)
 {
 	struct nv84_fence_chan *fctx = chan->engctx[engine];
-	nouveau_fence_context_del(&fctx->base);
+	nouveau_fence_context_del(chan->dev, &fctx->base);
 	chan->engctx[engine] = NULL;
 	kfree(fctx);
 }
diff --git a/drivers/gpu/drm/nouveau/nvc0_fence.c b/drivers/gpu/drm/nouveau/nvc0_fence.c
index 47ab388..198e31f 100644
--- a/drivers/gpu/drm/nouveau/nvc0_fence.c
+++ b/drivers/gpu/drm/nouveau/nvc0_fence.c
@@ -40,7 +40,7 @@ struct nvc0_fence_chan {
 };
 
 static int
-nvc0_fence_emit(struct nouveau_fence *fence)
+nvc0_fence_emit(struct nouveau_fence *fence, bool prime)
 {
 	struct nouveau_channel *chan = fence->channel;
 	struct nvc0_fence_chan *fctx = chan->engctx[NVOBJ_ENGINE_FENCE];
@@ -96,7 +96,7 @@ nvc0_fence_context_del(struct nouveau_channel *chan, int engine)
 	struct nvc0_fence_chan *fctx = chan->engctx[engine];
 
 	nouveau_bo_vma_del(priv->bo, &fctx->vma);
-	nouveau_fence_context_del(&fctx->base);
+	nouveau_fence_context_del(chan->dev, &fctx->base);
 	chan->engctx[engine] = NULL;
 	kfree(fctx);
 }
-- 
1.7.9.5

