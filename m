Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab1EUAEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:04:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:60834 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756927Ab1EUACK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:02:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,244,1304319600"; 
   d="scan'208";a="1807300"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, airlied@linux.ie,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/12] RADEON: Move more code out of line
Date: Fri, 20 May 2011 17:01:19 -0700
Message-Id: <1305936082-21304-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
References: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

With this patch I'm only about 50k larger with DRM debugging
enables (why is that enabled by default?!?), and slightly
smaller without.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/gpu/drm/radeon/r100.c             |   39 ++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/r300_cmdbuf.c      |    2 +-
 drivers/gpu/drm/radeon/r600.c             |    4 +-
 drivers/gpu/drm/radeon/r600_blit_kms.c    |    2 +-
 drivers/gpu/drm/radeon/radeon.h           |   39 +++++----------------------
 drivers/gpu/drm/radeon/radeon_atombios.c  |    4 +-
 drivers/gpu/drm/radeon/radeon_irq.c       |    2 +-
 drivers/gpu/drm/radeon/radeon_legacy_tv.c |    2 +-
 drivers/gpu/drm/radeon/radeon_object.c    |   41 ++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon_object.h    |   42 ++--------------------------
 drivers/gpu/drm/radeon/radeon_state.c     |   16 +++++-----
 11 files changed, 106 insertions(+), 87 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 1ea31a7..2c44ef5 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -4103,3 +4103,42 @@ int r100_packet3_load_vbpntr(struct radeon_cs_parser *p,
 	}
 	return r;
 }
+
+/* Better place? */
+u32 radeon_get_ib_value(struct radeon_cs_parser *p, int idx)
+{
+	struct radeon_cs_chunk *ibc = &p->chunks[p->chunk_ib_idx];
+	u32 pg_idx, pg_offset;
+	u32 idx_value = 0;
+	int new_page;
+
+	pg_idx = (idx * 4) / PAGE_SIZE;
+	pg_offset = (idx * 4) % PAGE_SIZE;
+
+	if (ibc->kpage_idx[0] == pg_idx)
+		return ibc->kpage[0][pg_offset/4];
+	if (ibc->kpage_idx[1] == pg_idx)
+		return ibc->kpage[1][pg_offset/4];
+
+	new_page = radeon_cs_update_pages(p, pg_idx);
+	if (new_page < 0) {
+		p->parser_error = new_page;
+		return 0;
+	}
+
+	idx_value = ibc->kpage[new_page][pg_offset/4];
+	return idx_value;
+}
+
+void radeon_ring_write(struct radeon_device *rdev, uint32_t v)
+{
+#if DRM_DEBUG_CODE
+	if (rdev->cp.count_dw <= 0) {
+		DRM_ERROR("radeon: writting more dword to ring than expected !\n");
+	}
+#endif
+	rdev->cp.ring[rdev->cp.wptr++] = v;
+	rdev->cp.wptr &= rdev->cp.ptr_mask;
+	rdev->cp.count_dw--;
+	rdev->cp.ring_free_dw--;
+}
diff --git a/drivers/gpu/drm/radeon/r300_cmdbuf.c b/drivers/gpu/drm/radeon/r300_cmdbuf.c
index c5c2742..1fe98b4 100644
--- a/drivers/gpu/drm/radeon/r300_cmdbuf.c
+++ b/drivers/gpu/drm/radeon/r300_cmdbuf.c
@@ -791,7 +791,7 @@ static __inline__ int r300_emit_packet3(drm_radeon_private_t *dev_priv,
 /**
  * Emit the sequence to pacify R300.
  */
-static __inline__ void r300_pacify(drm_radeon_private_t *dev_priv)
+static void r300_pacify(drm_radeon_private_t *dev_priv)
 {
 	uint32_t cache_z, cache_3d, cache_2d;
 	RING_LOCALS;
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 6f27593..3b69c99 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -3125,7 +3125,7 @@ int r600_irq_set(struct radeon_device *rdev)
 	return 0;
 }
 
-static inline void r600_irq_ack(struct radeon_device *rdev)
+static void r600_irq_ack(struct radeon_device *rdev)
 {
 	u32 tmp;
 
@@ -3226,7 +3226,7 @@ void r600_irq_disable(struct radeon_device *rdev)
 	r600_disable_interrupt_state(rdev);
 }
 
-static inline u32 r600_get_ih_wptr(struct radeon_device *rdev)
+static u32 r600_get_ih_wptr(struct radeon_device *rdev)
 {
 	u32 wptr, tmp;
 
diff --git a/drivers/gpu/drm/radeon/r600_blit_kms.c b/drivers/gpu/drm/radeon/r600_blit_kms.c
index 9aa74c3..bbbafe6 100644
--- a/drivers/gpu/drm/radeon/r600_blit_kms.c
+++ b/drivers/gpu/drm/radeon/r600_blit_kms.c
@@ -450,7 +450,7 @@ set_default_state(struct radeon_device *rdev)
 	radeon_ring_write(rdev, sq_stack_resource_mgmt_2);
 }
 
-static inline uint32_t i2f(uint32_t input)
+static uint32_t i2f(uint32_t input)
 {
 	u32 result, i, exponent, fraction;
 
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 485acc8..25cead7 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -598,32 +598,7 @@ struct radeon_cs_parser {
 
 extern int radeon_cs_update_pages(struct radeon_cs_parser *p, int pg_idx);
 extern int radeon_cs_finish_pages(struct radeon_cs_parser *p);
-
-
-static inline u32 radeon_get_ib_value(struct radeon_cs_parser *p, int idx)
-{
-	struct radeon_cs_chunk *ibc = &p->chunks[p->chunk_ib_idx];
-	u32 pg_idx, pg_offset;
-	u32 idx_value = 0;
-	int new_page;
-
-	pg_idx = (idx * 4) / PAGE_SIZE;
-	pg_offset = (idx * 4) % PAGE_SIZE;
-
-	if (ibc->kpage_idx[0] == pg_idx)
-		return ibc->kpage[0][pg_offset/4];
-	if (ibc->kpage_idx[1] == pg_idx)
-		return ibc->kpage[1][pg_offset/4];
-
-	new_page = radeon_cs_update_pages(p, pg_idx);
-	if (new_page < 0) {
-		p->parser_error = new_page;
-		return 0;
-	}
-
-	idx_value = ibc->kpage[new_page][pg_offset/4];
-	return idx_value;
-}
+extern u32 radeon_get_ib_value(struct radeon_cs_parser *p, int idx);
 
 struct radeon_cs_packet {
 	unsigned	idx;
@@ -1372,19 +1347,19 @@ void radeon_atombios_fini(struct radeon_device *rdev);
 /*
  * RING helpers.
  */
+
+#if DRM_DEBUG_CODE == 0
 static inline void radeon_ring_write(struct radeon_device *rdev, uint32_t v)
 {
-#if DRM_DEBUG_CODE
-	if (rdev->cp.count_dw <= 0) {
-		DRM_ERROR("radeon: writting more dword to ring than expected !\n");
-	}
-#endif
 	rdev->cp.ring[rdev->cp.wptr++] = v;
 	rdev->cp.wptr &= rdev->cp.ptr_mask;
 	rdev->cp.count_dw--;
 	rdev->cp.ring_free_dw--;
 }
-
+#else
+/* With debugging this is just too big to inline */
+void radeon_ring_write(struct radeon_device *rdev, uint32_t v);
+#endif
 
 /*
  * ASICs macro.
diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 90dfb2b..ae5abac 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -62,7 +62,7 @@ union atom_supported_devices {
 	struct _ATOM_SUPPORTED_DEVICES_INFO_2d1 info_2d1;
 };
 
-static inline struct radeon_i2c_bus_rec radeon_lookup_i2c_gpio(struct radeon_device *rdev,
+static struct radeon_i2c_bus_rec radeon_lookup_i2c_gpio(struct radeon_device *rdev,
 							       uint8_t id)
 {
 	struct atom_context *ctx = rdev->mode_info.atom_context;
@@ -228,7 +228,7 @@ void radeon_atombios_i2c_init(struct radeon_device *rdev)
 	}
 }
 
-static inline struct radeon_gpio_rec radeon_lookup_gpio(struct radeon_device *rdev,
+static struct radeon_gpio_rec radeon_lookup_gpio(struct radeon_device *rdev,
 							u8 id)
 {
 	struct atom_context *ctx = rdev->mode_info.atom_context;
diff --git a/drivers/gpu/drm/radeon/radeon_irq.c b/drivers/gpu/drm/radeon/radeon_irq.c
index 465746b..00da384 100644
--- a/drivers/gpu/drm/radeon/radeon_irq.c
+++ b/drivers/gpu/drm/radeon/radeon_irq.c
@@ -129,7 +129,7 @@ void radeon_disable_vblank(struct drm_device *dev, int crtc)
 	}
 }
 
-static inline u32 radeon_acknowledge_irqs(drm_radeon_private_t *dev_priv, u32 *r500_disp_int)
+static u32 radeon_acknowledge_irqs(drm_radeon_private_t *dev_priv, u32 *r500_disp_int)
 {
 	u32 irqs = RADEON_READ(RADEON_GEN_INT_STATUS);
 	u32 irq_mask = RADEON_SW_INT_TEST;
diff --git a/drivers/gpu/drm/radeon/radeon_legacy_tv.c b/drivers/gpu/drm/radeon/radeon_legacy_tv.c
index c7b6cb4..b37ec0f 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_tv.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_tv.c
@@ -864,7 +864,7 @@ void radeon_legacy_tv_adjust_crtc_reg(struct drm_encoder *encoder,
 	*v_sync_strt_wid = tmp;
 }
 
-static inline int get_post_div(int value)
+static int get_post_div(int value)
 {
 	int post_div;
 	switch (value) {
diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index 976c3b1..1c85152 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -515,3 +515,44 @@ int radeon_bo_fault_reserve_notify(struct ttm_buffer_object *bo)
 	}
 	return 0;
 }
+
+int radeon_bo_wait(struct radeon_bo *bo, u32 *mem_type, bool no_wait)
+{
+	int r;
+
+	r = ttm_bo_reserve(&bo->tbo, true, no_wait, false, 0);
+	if (unlikely(r != 0))
+		return r;
+	spin_lock(&bo->tbo.bdev->fence_lock);
+	if (mem_type)
+		*mem_type = bo->tbo.mem.mem_type;
+	if (bo->tbo.sync_obj)
+		r = ttm_bo_wait(&bo->tbo, true, true, no_wait);
+	spin_unlock(&bo->tbo.bdev->fence_lock);
+	ttm_bo_unreserve(&bo->tbo);
+	return r;
+}
+
+
+/**
+ * radeon_bo_reserve - reserve bo
+ * @bo:		bo structure
+ * @no_wait:		don't sleep while trying to reserve (return -EBUSY)
+ *
+ * Returns:
+ * -EBUSY: buffer is busy and @no_wait is true
+ * -ERESTARTSYS: A wait for the buffer to become unreserved was interrupted by
+ * a signal. Release all buffer reservations and return to user-space.
+ */
+int radeon_bo_reserve(struct radeon_bo *bo, bool no_wait)
+{
+	int r;
+
+	r = ttm_bo_reserve(&bo->tbo, true, no_wait, false, 0);
+	if (unlikely(r != 0)) {
+		if (r != -ERESTARTSYS)
+			dev_err(bo->rdev->dev, "%p reserve failed\n", bo);
+		return r;
+	}
+	return 0;
+}
diff --git a/drivers/gpu/drm/radeon/radeon_object.h b/drivers/gpu/drm/radeon/radeon_object.h
index ede6c13..b07f0f9 100644
--- a/drivers/gpu/drm/radeon/radeon_object.h
+++ b/drivers/gpu/drm/radeon/radeon_object.h
@@ -52,28 +52,7 @@ static inline unsigned radeon_mem_type_to_domain(u32 mem_type)
 	return 0;
 }
 
-/**
- * radeon_bo_reserve - reserve bo
- * @bo:		bo structure
- * @no_wait:		don't sleep while trying to reserve (return -EBUSY)
- *
- * Returns:
- * -EBUSY: buffer is busy and @no_wait is true
- * -ERESTARTSYS: A wait for the buffer to become unreserved was interrupted by
- * a signal. Release all buffer reservations and return to user-space.
- */
-static inline int radeon_bo_reserve(struct radeon_bo *bo, bool no_wait)
-{
-	int r;
-
-	r = ttm_bo_reserve(&bo->tbo, true, no_wait, false, 0);
-	if (unlikely(r != 0)) {
-		if (r != -ERESTARTSYS)
-			dev_err(bo->rdev->dev, "%p reserve failed\n", bo);
-		return r;
-	}
-	return 0;
-}
+int radeon_bo_reserve(struct radeon_bo *bo, bool no_wait);
 
 static inline void radeon_bo_unreserve(struct radeon_bo *bo)
 {
@@ -118,23 +97,8 @@ static inline u64 radeon_bo_mmap_offset(struct radeon_bo *bo)
 	return bo->tbo.addr_space_offset;
 }
 
-static inline int radeon_bo_wait(struct radeon_bo *bo, u32 *mem_type,
-					bool no_wait)
-{
-	int r;
-
-	r = ttm_bo_reserve(&bo->tbo, true, no_wait, false, 0);
-	if (unlikely(r != 0))
-		return r;
-	spin_lock(&bo->tbo.bdev->fence_lock);
-	if (mem_type)
-		*mem_type = bo->tbo.mem.mem_type;
-	if (bo->tbo.sync_obj)
-		r = ttm_bo_wait(&bo->tbo, true, true, no_wait);
-	spin_unlock(&bo->tbo.bdev->fence_lock);
-	ttm_bo_unreserve(&bo->tbo);
-	return r;
-}
+extern int radeon_bo_wait(struct radeon_bo *bo, u32 *mem_type,
+			  bool no_wait);
 
 extern int radeon_bo_create(struct radeon_device *rdev,
 				unsigned long size, int byte_align,
diff --git a/drivers/gpu/drm/radeon/radeon_state.c b/drivers/gpu/drm/radeon/radeon_state.c
index 92e7ea7..e8422ae 100644
--- a/drivers/gpu/drm/radeon/radeon_state.c
+++ b/drivers/gpu/drm/radeon/radeon_state.c
@@ -272,12 +272,12 @@ static __inline__ int radeon_check_and_fixup_packets(drm_radeon_private_t *
 	return 0;
 }
 
-static __inline__ int radeon_check_and_fixup_packet3(drm_radeon_private_t *
-						     dev_priv,
-						     struct drm_file *file_priv,
-						     drm_radeon_kcmd_buffer_t *
-						     cmdbuf,
-						     unsigned int *cmdsz)
+static int radeon_check_and_fixup_packet3(drm_radeon_private_t *
+					  dev_priv,
+					  struct drm_file *file_priv,
+					  drm_radeon_kcmd_buffer_t *
+					  cmdbuf,
+					  unsigned int *cmdsz)
 {
 	u32 *cmd = drm_buffer_pointer_to_dword(cmdbuf->buffer, 0);
 	u32 offset, narrays;
@@ -446,8 +446,8 @@ static __inline__ int radeon_check_and_fixup_packet3(drm_radeon_private_t *
  * CP hardware state programming functions
  */
 
-static __inline__ void radeon_emit_clip_rect(drm_radeon_private_t * dev_priv,
-					     struct drm_clip_rect * box)
+static void radeon_emit_clip_rect(drm_radeon_private_t * dev_priv,
+				  struct drm_clip_rect * box)
 {
 	RING_LOCALS;
 
-- 
1.7.4.4

