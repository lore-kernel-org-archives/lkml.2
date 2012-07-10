Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2GJK7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:59:17 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53636 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2GJK6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:58:16 -0400
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: [RFC PATCH 2/8] prime wip: i915
Date: Tue, 10 Jul 2012 12:57:45 +0200
Message-Id: <1341917871-2512-3-git-send-email-m.b.lankhorst@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341917871-2512-1-git-send-email-m.b.lankhorst@gmail.com>
References: <1341917871-2512-1-git-send-email-m.b.lankhorst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

Export the hardware status page so others can read seqno.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

---
 drivers/gpu/drm/i915/i915_gem_dmabuf.c     |   29 ++++++++--
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   87 ++++++++++++++++++++++++----
 drivers/gpu/drm/i915/intel_ringbuffer.c    |   42 ++++++++++++++
 drivers/gpu/drm/i915/intel_ringbuffer.h    |    3 +
 4 files changed, 145 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
index aa308e1..d6bcfdc 100644
--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -66,12 +66,25 @@ static void i915_gem_unmap_dma_buf(struct dma_buf_attachment *attachment,
 static void i915_gem_dmabuf_release(struct dma_buf *dma_buf)
 {
 	struct drm_i915_gem_object *obj = dma_buf->priv;
+	struct drm_device *dev = obj->base.dev;
+
+	mutex_lock(&dev->struct_mutex);
 
 	if (obj->base.export_dma_buf == dma_buf) {
-		/* drop the reference on the export fd holds */
 		obj->base.export_dma_buf = NULL;
-		drm_gem_object_unreference_unlocked(&obj->base);
+	} else {
+		drm_i915_private_t *dev_priv = dev->dev_private;
+		struct intel_ring_buffer *ring;
+		int i;
+
+		for_each_ring(ring, dev_priv, i)
+			WARN_ON(ring->sync_buf == dma_buf);
 	}
+
+	/* drop the reference on the export fd holds */
+	drm_gem_object_unreference(&obj->base);
+
+	mutex_unlock(&dev->struct_mutex);
 }
 
 static void *i915_gem_dmabuf_vmap(struct dma_buf *dma_buf)
@@ -129,21 +142,25 @@ static void i915_gem_dmabuf_vunmap(struct dma_buf *dma_buf, void *vaddr)
 
 static void *i915_gem_dmabuf_kmap_atomic(struct dma_buf *dma_buf, unsigned long page_num)
 {
-	return NULL;
+	struct drm_i915_gem_object *obj = dma_buf->priv;
+	return kmap_atomic(obj->pages[page_num]);
 }
 
 static void i915_gem_dmabuf_kunmap_atomic(struct dma_buf *dma_buf, unsigned long page_num, void *addr)
 {
-
+	kunmap_atomic(addr);
 }
+
 static void *i915_gem_dmabuf_kmap(struct dma_buf *dma_buf, unsigned long page_num)
 {
-	return NULL;
+	struct drm_i915_gem_object *obj = dma_buf->priv;
+	return kmap(obj->pages[page_num]);
 }
 
 static void i915_gem_dmabuf_kunmap(struct dma_buf *dma_buf, unsigned long page_num, void *addr)
 {
-
+	struct drm_i915_gem_object *obj = dma_buf->priv;
+	kunmap(obj->pages[page_num]);
 }
 
 static int i915_gem_dmabuf_mmap(struct dma_buf *dma_buf, struct vm_area_struct *vma)
diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index 88e2e11..245340e 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -33,6 +33,7 @@
 #include "i915_trace.h"
 #include "intel_drv.h"
 #include <linux/dma_remapping.h>
+#include <linux/dma-buf-mgr.h>
 
 struct change_domains {
 	uint32_t invalidate_domains;
@@ -556,7 +557,8 @@ err_unpin:
 static int
 i915_gem_execbuffer_reserve(struct intel_ring_buffer *ring,
 			    struct drm_file *file,
-			    struct list_head *objects)
+			    struct list_head *objects,
+			    struct list_head *prime_val)
 {
 	drm_i915_private_t *dev_priv = ring->dev->dev_private;
 	struct drm_i915_gem_object *obj;
@@ -564,6 +566,31 @@ i915_gem_execbuffer_reserve(struct intel_ring_buffer *ring,
 	bool has_fenced_gpu_access = INTEL_INFO(ring->dev)->gen < 4;
 	struct list_head ordered_objects;
 
+	list_for_each_entry(obj, objects, exec_list) {
+		struct dmabufmgr_validate *val;
+
+		if (!(obj->base.import_attach ||
+		      obj->base.export_dma_buf))
+			continue;
+
+		val = kzalloc(sizeof(*val), GFP_KERNEL);
+		if (!val)
+			return -ENOMEM;
+
+		if (obj->base.export_dma_buf)
+			val->bo = obj->base.export_dma_buf;
+		else
+			val->bo = obj->base.import_attach->dmabuf;
+		val->priv = obj;
+		list_add_tail(&val->head, prime_val);
+	}
+
+	if (!list_empty(prime_val)) {
+		ret = dmabufmgr_eu_reserve_buffers(prime_val);
+		if (ret)
+			return ret;
+	}
+
 	INIT_LIST_HEAD(&ordered_objects);
 	while (!list_empty(objects)) {
 		struct drm_i915_gem_exec_object2 *entry;
@@ -712,6 +739,7 @@ i915_gem_execbuffer_relocate_slow(struct drm_device *dev,
 				  struct drm_file *file,
 				  struct intel_ring_buffer *ring,
 				  struct list_head *objects,
+				  struct list_head *prime_val,
 				  struct eb_objects *eb,
 				  struct drm_i915_gem_exec_object2 *exec,
 				  int count)
@@ -722,6 +750,16 @@ i915_gem_execbuffer_relocate_slow(struct drm_device *dev,
 	int i, total, ret;
 
 	/* We may process another execbuffer during the unlock... */
+
+	if (!list_empty(prime_val))
+		dmabufmgr_eu_backoff_reservation(prime_val);
+	while (!list_empty(prime_val)) {
+		struct dmabufmgr_validate *val;
+		val = list_first_entry(prime_val, typeof(*val), head);
+		list_del(&val->head);
+		kfree(val);
+	}
+
 	while (!list_empty(objects)) {
 		obj = list_first_entry(objects,
 				       struct drm_i915_gem_object,
@@ -786,7 +824,7 @@ i915_gem_execbuffer_relocate_slow(struct drm_device *dev,
 		eb_add_object(eb, obj);
 	}
 
-	ret = i915_gem_execbuffer_reserve(ring, file, objects);
+	ret = i915_gem_execbuffer_reserve(ring, file, objects, prime_val);
 	if (ret)
 		goto err;
 
@@ -854,10 +892,10 @@ i915_gem_execbuffer_wait_for_flips(struct intel_ring_buffer *ring, u32 flips)
 	return 0;
 }
 
-
 static int
 i915_gem_execbuffer_move_to_gpu(struct intel_ring_buffer *ring,
-				struct list_head *objects)
+				struct list_head *objects,
+				struct list_head *prime_val)
 {
 	struct drm_i915_gem_object *obj;
 	struct change_domains cd;
@@ -941,7 +979,6 @@ i915_gem_execbuffer_move_to_active(struct list_head *objects,
 		  u32 old_read = obj->base.read_domains;
 		  u32 old_write = obj->base.write_domain;
 
-
 		obj->base.read_domains = obj->base.pending_read_domains;
 		obj->base.write_domain = obj->base.pending_write_domain;
 		obj->fenced_gpu_access = obj->pending_fenced_gpu_access;
@@ -1012,6 +1049,7 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct list_head objects;
+	struct list_head prime_val;
 	struct eb_objects *eb;
 	struct drm_i915_gem_object *batch_obj;
 	struct drm_clip_rect *cliprects = NULL;
@@ -1145,6 +1183,7 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 
 	/* Look up object handles */
 	INIT_LIST_HEAD(&objects);
+	INIT_LIST_HEAD(&prime_val);
 	for (i = 0; i < args->buffer_count; i++) {
 		struct drm_i915_gem_object *obj;
 
@@ -1176,8 +1215,14 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 			       struct drm_i915_gem_object,
 			       exec_list);
 
+	if (batch_obj->base.export_dma_buf || batch_obj->base.import_attach) {
+		DRM_DEBUG("Batch buffer should really not be prime..\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
 	/* Move the objects en-masse into the GTT, evicting if necessary. */
-	ret = i915_gem_execbuffer_reserve(ring, file, &objects);
+	ret = i915_gem_execbuffer_reserve(ring, file, &objects, &prime_val);
 	if (ret)
 		goto err;
 
@@ -1186,8 +1231,9 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 	if (ret) {
 		if (ret == -EFAULT) {
 			ret = i915_gem_execbuffer_relocate_slow(dev, file, ring,
-								&objects, eb,
-								exec,
+								&objects,
+								&prime_val,
+								eb, exec,
 								args->buffer_count);
 			BUG_ON(!mutex_is_locked(&dev->struct_mutex));
 		}
@@ -1203,7 +1249,7 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 	}
 	batch_obj->base.pending_read_domains |= I915_GEM_DOMAIN_COMMAND;
 
-	ret = i915_gem_execbuffer_move_to_gpu(ring, &objects);
+	ret = i915_gem_execbuffer_move_to_gpu(ring, &objects, &prime_val);
 	if (ret)
 		goto err;
 
@@ -1227,7 +1273,7 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 	    mode != dev_priv->relative_constants_mode) {
 		ret = intel_ring_begin(ring, 4);
 		if (ret)
-				goto err;
+			goto err;
 
 		intel_ring_emit(ring, MI_NOOP);
 		intel_ring_emit(ring, MI_LOAD_REGISTER_IMM(1));
@@ -1248,6 +1294,10 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 	if (ret)
 		goto err;
 
+	ret = dmabufmgr_eu_wait_completed_cpu(&prime_val, true, true);
+	if (ret)
+		goto err;
+
 	trace_i915_gem_ring_dispatch(ring, seqno);
 
 	exec_start = batch_obj->gtt_offset + args->batch_start_offset;
@@ -1272,8 +1322,25 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 
 	i915_gem_execbuffer_move_to_active(&objects, ring, seqno);
 	i915_gem_execbuffer_retire_commands(dev, file, ring);
+	if (!list_empty(&prime_val)) {
+		BUG_ON(!ring->sync_buf);
+		WARN_ON_ONCE(seqno == ring->outstanding_lazy_request);
+
+		dmabufmgr_eu_fence_buffer_objects(ring->sync_buf,
+						  ring->sync_seqno_ofs,
+						  seqno, &prime_val);
+	}
+	goto out;
 
 err:
+	dmabufmgr_eu_backoff_reservation(&prime_val);
+out:
+	while (!list_empty(&prime_val)) {
+		struct dmabufmgr_validate *val;
+		val = list_first_entry(&prime_val, typeof(*val), head);
+		list_del(&val->head);
+		kfree(val);
+	}
 	eb_destroy(eb);
 	while (!list_empty(&objects)) {
 		struct drm_i915_gem_object *obj;
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index d42d821..24795e1 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -33,6 +33,7 @@
 #include "i915_drm.h"
 #include "i915_trace.h"
 #include "intel_drv.h"
+#include <linux/dma-buf.h>
 
 /*
  * 965+ support PIPE_CONTROL commands, which provide finer grained control
@@ -383,6 +384,22 @@ init_pipe_control(struct intel_ring_buffer *ring)
 	if (pc->cpu_page == NULL)
 		goto err_unpin;
 
+#ifdef CONFIG_DMA_SHARED_BUFFER
+	if (IS_GEN5(ring->dev)) {
+		struct dma_buf *dmabuf;
+		dmabuf = i915_gem_prime_export(ring->dev, &obj->base, 0);
+		if (IS_ERR(dmabuf)) {
+			ret = PTR_ERR(dmabuf);
+			kunmap(obj->pages[0]);
+			pc->cpu_page = NULL;
+			goto err_unpin;
+		}
+		drm_gem_object_reference(&obj->base);
+		ring->sync_buf = dmabuf;
+		ring->sync_seqno_ofs = 0;
+	}
+#endif
+
 	pc->obj = obj;
 	ring->private = pc;
 	return 0;
@@ -419,6 +436,8 @@ static int init_render_ring(struct intel_ring_buffer *ring)
 	struct drm_device *dev = ring->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int ret = init_ring_common(ring);
+	if (ret)
+		return ret;
 
 	if (INTEL_INFO(dev)->gen > 3) {
 		I915_WRITE(MI_MODE, _MASKED_BIT_ENABLE(VS_TIMER_DISPATCH));
@@ -943,6 +962,14 @@ static void cleanup_status_page(struct intel_ring_buffer *ring)
 	if (obj == NULL)
 		return;
 
+	if (ring->sync_buf) {
+		struct dma_buf *dmabuf;
+
+		dmabuf = ring->sync_buf;
+		ring->sync_buf = NULL;
+		dma_buf_put(dmabuf);
+	}
+
 	kunmap(obj->pages[0]);
 	i915_gem_object_unpin(obj);
 	drm_gem_object_unreference(&obj->base);
@@ -974,6 +1001,21 @@ static int init_status_page(struct intel_ring_buffer *ring)
 	if (ring->status_page.page_addr == NULL) {
 		goto err_unpin;
 	}
+
+#ifdef CONFIG_DMA_SHARED_BUFFER
+	if (!IS_GEN5(ring->dev) || ring->init == init_ring_common) {
+		struct dma_buf *dmabuf;
+		dmabuf = i915_gem_prime_export(dev, &obj->base, 0);
+		if (IS_ERR(dmabuf)) {
+			ret = PTR_ERR(dmabuf);
+			kunmap(obj->pages[0]);
+			goto err_unpin;
+		}
+		drm_gem_object_reference(&obj->base);
+		ring->sync_buf = dmabuf;
+		ring->sync_seqno_ofs = I915_GEM_HWS_INDEX * 4;
+	}
+#endif
 	ring->status_page.obj = obj;
 	memset(ring->status_page.page_addr, 0, PAGE_SIZE);
 
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.h b/drivers/gpu/drm/i915/intel_ringbuffer.h
index 1d3c81f..c878b14 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.h
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.h
@@ -124,6 +124,9 @@ struct  intel_ring_buffer {
 	struct i915_hw_context *default_context;
 	struct drm_i915_gem_object *last_context_obj;
 
+	struct dma_buf *sync_buf;
+	u32 sync_seqno_ofs;
+
 	void *private;
 };
 
-- 
1.7.9.5

