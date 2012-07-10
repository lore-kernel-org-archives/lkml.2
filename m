Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab2GJK7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:59:31 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53636 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab2GJK6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:58:40 -0400
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: [RFC PATCH 7/8] nouveau: nvc0 fence prime implementation
Date: Tue, 10 Jul 2012 12:57:50 +0200
Message-Id: <1341917871-2512-8-git-send-email-m.b.lankhorst@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341917871-2512-1-git-send-email-m.b.lankhorst@gmail.com>
References: <1341917871-2512-1-git-send-email-m.b.lankhorst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

Create a read-only mapping for every imported bo, and create a prime
bo in in system memory.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/nouveau/nvc0_fence.c |  104 +++++++++++++++++++++++++++++-----
 1 file changed, 89 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvc0_fence.c b/drivers/gpu/drm/nouveau/nvc0_fence.c
index 198e31f..dc6ccab 100644
--- a/drivers/gpu/drm/nouveau/nvc0_fence.c
+++ b/drivers/gpu/drm/nouveau/nvc0_fence.c
@@ -37,6 +37,7 @@ struct nvc0_fence_priv {
 struct nvc0_fence_chan {
 	struct nouveau_fence_chan base;
 	struct nouveau_vma vma;
+	struct nouveau_vma prime_vma;
 };
 
 static int
@@ -45,19 +46,23 @@ nvc0_fence_emit(struct nouveau_fence *fence, bool prime)
 	struct nouveau_channel *chan = fence->channel;
 	struct nvc0_fence_chan *fctx = chan->engctx[NVOBJ_ENGINE_FENCE];
 	u64 addr = fctx->vma.offset + chan->id * 16;
-	int ret;
+	int ret, i;
 
-	ret = RING_SPACE(chan, 5);
-	if (ret == 0) {
+	ret = RING_SPACE(chan, prime ? 10 : 5);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < (prime ? 2 : 1); ++i) {
+		if (i)
+			addr = fctx->prime_vma.offset + chan->id * 16;
 		BEGIN_NVC0(chan, 0, NV84_SUBCHAN_SEMAPHORE_ADDRESS_HIGH, 4);
 		OUT_RING  (chan, upper_32_bits(addr));
 		OUT_RING  (chan, lower_32_bits(addr));
 		OUT_RING  (chan, fence->sequence);
 		OUT_RING  (chan, NV84_SUBCHAN_SEMAPHORE_TRIGGER_WRITE_LONG);
-		FIRE_RING (chan);
 	}
-
-	return ret;
+	FIRE_RING(chan);
+	return 0;
 }
 
 static int
@@ -95,6 +100,8 @@ nvc0_fence_context_del(struct nouveau_channel *chan, int engine)
 	struct nvc0_fence_priv *priv = nv_engine(chan->dev, engine);
 	struct nvc0_fence_chan *fctx = chan->engctx[engine];
 
+	if (priv->base.prime_bo)
+		nouveau_bo_vma_del(priv->base.prime_bo, &fctx->prime_vma);
 	nouveau_bo_vma_del(priv->bo, &fctx->vma);
 	nouveau_fence_context_del(chan->dev, &fctx->base);
 	chan->engctx[engine] = NULL;
@@ -115,10 +122,16 @@ nvc0_fence_context_new(struct nouveau_channel *chan, int engine)
 	nouveau_fence_context_new(&fctx->base);
 
 	ret = nouveau_bo_vma_add(priv->bo, chan->vm, &fctx->vma);
+	if (!ret && priv->base.prime_bo)
+		ret = nouveau_bo_vma_add(priv->base.prime_bo, chan->vm,
+					 &fctx->prime_vma);
 	if (ret)
 		nvc0_fence_context_del(chan, engine);
 
-	nouveau_bo_wr32(priv->bo, chan->id * 16/4, 0x00000000);
+	fctx->base.sequence = nouveau_bo_rd32(priv->bo, chan->id * 16/4);
+	if (priv->base.prime_bo)
+		nouveau_bo_wr32(priv->base.prime_bo, chan->id * 16/4,
+				fctx->base.sequence);
 	return ret;
 }
 
@@ -140,12 +153,55 @@ nvc0_fence_destroy(struct drm_device *dev, int engine)
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 	struct nvc0_fence_priv *priv = nv_engine(dev, engine);
 
+	nouveau_fence_prime_del(&priv->base);
 	nouveau_bo_unmap(priv->bo);
+	nouveau_bo_unpin(priv->bo);
 	nouveau_bo_ref(NULL, &priv->bo);
 	dev_priv->eng[engine] = NULL;
 	kfree(priv);
 }
 
+static int
+nvc0_fence_prime_sync(struct nouveau_channel *chan,
+		      struct nouveau_bo *bo,
+		      u32 ofs, u32 val, u64 sema_start)
+{
+	struct nvc0_fence_chan *fctx = chan->engctx[NVOBJ_ENGINE_FENCE];
+	struct nvc0_fence_priv *priv = nv_engine(chan->dev, NVOBJ_ENGINE_FENCE);
+	int ret = RING_SPACE(chan, 5);
+	if (ret)
+		return ret;
+
+	if (bo == priv->base.prime_bo)
+		sema_start = fctx->prime_vma.offset;
+	else
+		NV_ERROR(chan->dev, "syncing with %08Lx + %08x >= %08x\n",
+			sema_start, ofs, val);
+	sema_start += ofs;
+
+	BEGIN_NVC0(chan, 0, NV84_SUBCHAN_SEMAPHORE_ADDRESS_HIGH, 4);
+	OUT_RING  (chan, upper_32_bits(sema_start));
+	OUT_RING  (chan, lower_32_bits(sema_start));
+	OUT_RING  (chan, val);
+	OUT_RING  (chan, NV84_SUBCHAN_SEMAPHORE_TRIGGER_ACQUIRE_GEQUAL |
+			 NVC0_SUBCHAN_SEMAPHORE_TRIGGER_YIELD);
+	FIRE_RING (chan);
+	return ret;
+}
+
+static void
+nvc0_fence_prime_del_import(struct nouveau_fence_prime_bo_entry *entry) {
+	nouveau_bo_vma_del(entry->bo, &entry->vma);
+}
+
+static int
+nvc0_fence_prime_add_import(struct nouveau_fence_prime_bo_entry *entry) {
+	int ret = nouveau_bo_vma_add_access(entry->bo, entry->chan->vm,
+					    &entry->vma, NV_MEM_ACCESS_RO);
+	entry->sema_start = entry->vma.offset;
+	return ret;
+}
+
 int
 nvc0_fence_create(struct drm_device *dev)
 {
@@ -168,17 +224,35 @@ nvc0_fence_create(struct drm_device *dev)
 	priv->base.read = nvc0_fence_read;
 	dev_priv->eng[NVOBJ_ENGINE_FENCE] = &priv->base.engine;
 
+	priv->base.prime_sync = nvc0_fence_prime_sync;
+	priv->base.prime_add_import = nvc0_fence_prime_add_import;
+	priv->base.prime_del_import = nvc0_fence_prime_del_import;
+
 	ret = nouveau_bo_new(dev, 16 * pfifo->channels, 0, TTM_PL_FLAG_VRAM,
 			     0, 0, NULL, &priv->bo);
-	if (ret == 0) {
-		ret = nouveau_bo_pin(priv->bo, TTM_PL_FLAG_VRAM);
-		if (ret == 0)
-			ret = nouveau_bo_map(priv->bo);
-		if (ret)
-			nouveau_bo_ref(NULL, &priv->bo);
-	}
+	if (ret)
+		goto err;
+	ret = nouveau_bo_pin(priv->bo, TTM_PL_FLAG_VRAM);
+	if (ret)
+		goto err_ref;
 
+	ret = nouveau_bo_map(priv->bo);
 	if (ret)
-		nvc0_fence_destroy(dev, NVOBJ_ENGINE_FENCE);
+		goto err_unpin;
+
+	ret = nouveau_fence_prime_init(dev, &priv->base, 16);
+	if (ret)
+		goto err_unmap;
+	return 0;
+
+err_unmap:
+	nouveau_bo_unmap(priv->bo);
+err_unpin:
+	nouveau_bo_unpin(priv->bo);
+err_ref:
+	nouveau_bo_ref(NULL, &priv->bo);
+err:
+	dev_priv->eng[NVOBJ_ENGINE_FENCE] = NULL;
+	kfree(priv);
 	return ret;
 }
-- 
1.7.9.5

