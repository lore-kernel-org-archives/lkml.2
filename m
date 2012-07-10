Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab2GJK7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:59:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55256 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab2GJK6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:58:35 -0400
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: [RFC PATCH 6/8] nouveau: nv84 fence prime implementation
Date: Tue, 10 Jul 2012 12:57:49 +0200
Message-Id: <1341917871-2512-7-git-send-email-m.b.lankhorst@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341917871-2512-1-git-send-email-m.b.lankhorst@gmail.com>
References: <1341917871-2512-1-git-send-email-m.b.lankhorst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

Create a dma object for the prime semaphore and every imported sync bo.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/nouveau/nv84_fence.c |  121 ++++++++++++++++++++++++++++++++--
 1 file changed, 115 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nv84_fence.c b/drivers/gpu/drm/nouveau/nv84_fence.c
index b5cfbcb..f739dfc 100644
--- a/drivers/gpu/drm/nouveau/nv84_fence.c
+++ b/drivers/gpu/drm/nouveau/nv84_fence.c
@@ -31,6 +31,7 @@
 
 struct nv84_fence_chan {
 	struct nouveau_fence_chan base;
+	u32 sema_start;
 };
 
 struct nv84_fence_priv {
@@ -42,21 +43,25 @@ static int
 nv84_fence_emit(struct nouveau_fence *fence, bool prime)
 {
 	struct nouveau_channel *chan = fence->channel;
-	int ret = RING_SPACE(chan, 7);
-	if (ret == 0) {
+	int i, ret;
+
+	ret = RING_SPACE(chan, prime ? 14 : 7);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < (prime ? 2 : 1); ++i) {
 		BEGIN_NV04(chan, 0, NV11_SUBCHAN_DMA_SEMAPHORE, 1);
-		OUT_RING  (chan, NvSema);
+		OUT_RING  (chan, i ? NvSemaPrime : NvSema);
 		BEGIN_NV04(chan, 0, NV84_SUBCHAN_SEMAPHORE_ADDRESS_HIGH, 4);
 		OUT_RING  (chan, upper_32_bits(chan->id * 16));
 		OUT_RING  (chan, lower_32_bits(chan->id * 16));
 		OUT_RING  (chan, fence->sequence);
 		OUT_RING  (chan, NV84_SUBCHAN_SEMAPHORE_TRIGGER_WRITE_LONG);
-		FIRE_RING (chan);
 	}
+	FIRE_RING (chan);
 	return ret;
 }
 
-
 static int
 nv84_fence_sync(struct nouveau_fence *fence,
 		struct nouveau_channel *prev, struct nouveau_channel *chan)
@@ -82,12 +87,94 @@ nv84_fence_read(struct nouveau_channel *chan)
 	return nv_ro32(priv->mem, chan->id * 16);
 }
 
+static int
+nv84_fence_prime_sync(struct nouveau_channel *chan,
+		      struct nouveau_bo *bo,
+		      u32 ofs, u32 val, u64 sema_start)
+{
+	struct nv84_fence_priv *priv = nv_engine(chan->dev, NVOBJ_ENGINE_FENCE);
+	int ret = RING_SPACE(chan, 7);
+	u32 sema = 0;
+	if (ret < 0)
+		return ret;
+
+	if (bo == priv->base.prime_bo) {
+		sema = NvSema;
+	} else {
+		struct sg_table *sgt = bo->bo.sg;
+		struct scatterlist *sg;
+		u32 i;
+		sema = sema_start;
+		for_each_sg(sgt->sgl, sg, sgt->nents, i) {
+			if (ofs < sg->offset + sg->length) {
+				ofs -= sg->offset;
+				break;
+			}
+			sema++;
+		}
+	}
+
+	BEGIN_NV04(chan, 0, NV11_SUBCHAN_DMA_SEMAPHORE, 1);
+	OUT_RING  (chan, sema);
+	BEGIN_NV04(chan, 0, NV84_SUBCHAN_SEMAPHORE_ADDRESS_HIGH, 4);
+	OUT_RING  (chan, 0);
+	OUT_RING  (chan, ofs);
+	OUT_RING  (chan, val);
+	OUT_RING  (chan, NV84_SUBCHAN_SEMAPHORE_TRIGGER_ACQUIRE_GEQUAL);
+	FIRE_RING (chan);
+	return ret;
+}
+
+static void
+nv84_fence_prime_del_import(struct nouveau_fence_prime_bo_entry *entry) {
+	u32 i;
+	for (i = entry->sema_start; i <  entry->sema_start + entry->sema_len; ++i)
+		nouveau_ramht_remove(entry->chan, i);
+}
+
+static int
+nv84_fence_prime_add_import(struct nouveau_fence_prime_bo_entry *entry) {
+	struct sg_table *sgt = entry->bo->bo.sg;
+	struct nouveau_channel *chan = entry->chan;
+	struct nv84_fence_chan *fctx = chan->engctx[NVOBJ_ENGINE_FENCE];
+	struct scatterlist *sg;
+	u32 i, sema;
+	int ret;
+
+	sema = entry->sema_start = fctx->sema_start;
+	entry->sema_len = 0;
+
+	for_each_sg(sgt->sgl, sg, sgt->nents, i) {
+		struct nouveau_gpuobj *obj;
+		ret = nouveau_gpuobj_dma_new(chan, NV_CLASS_DMA_FROM_MEMORY,
+					     sg_dma_address(sg), PAGE_SIZE,
+					     NV_MEM_ACCESS_RO,
+					     NV_MEM_TARGET_PCI, &obj);
+		if (ret)
+			goto err;
+
+		ret = nouveau_ramht_insert(chan, sema, obj);
+		nouveau_gpuobj_ref(NULL, &obj);
+		if (ret)
+			goto err;
+		entry->sema_len++;
+		sema++;
+	}
+	fctx->sema_start += (entry->sema_len + 0xff) & ~0xff;
+	return 0;
+
+err:
+	nv84_fence_prime_del_import(entry);
+	return ret;
+}
+
 static void
 nv84_fence_context_del(struct nouveau_channel *chan, int engine)
 {
 	struct nv84_fence_chan *fctx = chan->engctx[engine];
 	nouveau_fence_context_del(chan->dev, &fctx->base);
 	chan->engctx[engine] = NULL;
+
 	kfree(fctx);
 }
 
@@ -104,6 +191,7 @@ nv84_fence_context_new(struct nouveau_channel *chan, int engine)
 		return -ENOMEM;
 
 	nouveau_fence_context_new(&fctx->base);
+	fctx->sema_start = 0xc0000000 | (chan->id << 20);
 
 	ret = nouveau_gpuobj_dma_new(chan, NV_CLASS_DMA_FROM_MEMORY,
 				     priv->mem->vinst, priv->mem->size,
@@ -112,7 +200,21 @@ nv84_fence_context_new(struct nouveau_channel *chan, int engine)
 	if (ret == 0) {
 		ret = nouveau_ramht_insert(chan, NvSema, obj);
 		nouveau_gpuobj_ref(NULL, &obj);
-		nv_wo32(priv->mem, chan->id * 16, 0x00000000);
+		fctx->base.sequence = nv_ro32(priv->mem, chan->id * 16);
+	}
+
+	if (priv->base.prime_bo) {
+		struct nouveau_mem *mem = priv->base.prime_bo->bo.mem.mm_node;
+		ret = nouveau_gpuobj_dma_new(chan, NV_CLASS_DMA_FROM_MEMORY,
+					    mem->pages[0], PAGE_SIZE,
+					    NV_MEM_ACCESS_RW,
+					    NV_MEM_TARGET_PCI, &obj);
+		if (ret == 0) {
+			ret = nouveau_ramht_insert(chan, NvSemaPrime, obj);
+			nouveau_gpuobj_ref(NULL, &obj);
+			nouveau_bo_wr32(priv->base.prime_bo, chan->id * 4,
+					fctx->base.sequence);
+		}
 	}
 
 	if (ret)
@@ -138,6 +240,7 @@ nv84_fence_destroy(struct drm_device *dev, int engine)
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 	struct nv84_fence_priv *priv = nv_engine(dev, engine);
 
+	nouveau_fence_prime_del(&priv->base);
 	nouveau_gpuobj_ref(NULL, &priv->mem);
 	dev_priv->eng[engine] = NULL;
 	kfree(priv);
@@ -163,6 +266,10 @@ nv84_fence_create(struct drm_device *dev)
 	priv->base.emit = nv84_fence_emit;
 	priv->base.sync = nv84_fence_sync;
 	priv->base.read = nv84_fence_read;
+
+	priv->base.prime_sync = nv84_fence_prime_sync;
+	priv->base.prime_add_import = nv84_fence_prime_add_import;
+	priv->base.prime_del_import = nv84_fence_prime_del_import;
 	dev_priv->eng[NVOBJ_ENGINE_FENCE] = &priv->base.engine;
 
 	ret = nouveau_gpuobj_new(dev, NULL, 16 * pfifo->channels,
@@ -170,6 +277,8 @@ nv84_fence_create(struct drm_device *dev)
 	if (ret)
 		goto out;
 
+	ret = nouveau_fence_prime_init(dev, &priv->base, 16);
+
 out:
 	if (ret)
 		nv84_fence_destroy(dev, NVOBJ_ENGINE_FENCE);
-- 
1.7.9.5

