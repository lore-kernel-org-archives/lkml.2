Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab1EUAFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:05:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:59481 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756903Ab1EUACK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:02:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,244,1304319600"; 
   d="scan'208";a="1807299"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, airlied@linux.ie,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 08/12] RADEON: Remove more bogus inlines in the radeon driver.
Date: Fri, 20 May 2011 17:01:18 -0700
Message-Id: <1305936082-21304-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
References: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Remove bogus inlines in evergreen and r100.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/gpu/drm/radeon/evergreen.c          |    4 +-
 drivers/gpu/drm/radeon/evergreen_blit_kms.c |    2 +-
 drivers/gpu/drm/radeon/r100.c               |  100 +++++++++++++++++++++++++-
 drivers/gpu/drm/radeon/r100_track.h         |  103 ++-------------------------
 4 files changed, 108 insertions(+), 101 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 9073e3b..9b94658 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2477,7 +2477,7 @@ int evergreen_irq_set(struct radeon_device *rdev)
 	return 0;
 }
 
-static inline void evergreen_irq_ack(struct radeon_device *rdev)
+static void evergreen_irq_ack(struct radeon_device *rdev)
 {
 	u32 tmp;
 
@@ -2584,7 +2584,7 @@ void evergreen_irq_suspend(struct radeon_device *rdev)
 	r600_rlc_stop(rdev);
 }
 
-static inline u32 evergreen_get_ih_wptr(struct radeon_device *rdev)
+static u32 evergreen_get_ih_wptr(struct radeon_device *rdev)
 {
 	u32 wptr, tmp;
 
diff --git a/drivers/gpu/drm/radeon/evergreen_blit_kms.c b/drivers/gpu/drm/radeon/evergreen_blit_kms.c
index ba06a69..3c42c21 100644
--- a/drivers/gpu/drm/radeon/evergreen_blit_kms.c
+++ b/drivers/gpu/drm/radeon/evergreen_blit_kms.c
@@ -520,7 +520,7 @@ set_default_state(struct radeon_device *rdev)
 
 }
 
-static inline uint32_t i2f(uint32_t input)
+static uint32_t i2f(uint32_t input)
 {
 	u32 result, i, exponent, fraction;
 
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 1a4de6b..1ea31a7 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -588,7 +588,7 @@ void r100_irq_disable(struct radeon_device *rdev)
 	WREG32(R_000044_GEN_INT_STATUS, tmp);
 }
 
-static inline uint32_t r100_irq_ack(struct radeon_device *rdev)
+static uint32_t r100_irq_ack(struct radeon_device *rdev)
 {
 	uint32_t irqs = RREG32(RADEON_GEN_INT_STATUS);
 	uint32_t irq_mask = RADEON_SW_INT_TEST |
@@ -3149,7 +3149,7 @@ void r100_bandwidth_update(struct radeon_device *rdev)
 	}
 }
 
-static inline void r100_cs_track_texture_print(struct r100_cs_track_texture *t)
+static void r100_cs_track_texture_print(struct r100_cs_track_texture *t)
 {
 	DRM_ERROR("pitch                      %d\n", t->pitch);
 	DRM_ERROR("use_pitch                  %d\n", t->use_pitch);
@@ -4007,3 +4007,99 @@ void r100_io_wreg(struct radeon_device *rdev, u32 reg, u32 v)
 		iowrite32(v, rdev->rio_mem + RADEON_MM_DATA);
 	}
 }
+
+int r100_reloc_pitch_offset(struct radeon_cs_parser *p,
+			    struct radeon_cs_packet *pkt,
+			    unsigned idx,
+			    unsigned reg)
+{
+	int r;
+	u32 tile_flags = 0;
+	u32 tmp;
+	struct radeon_cs_reloc *reloc;
+	u32 value;
+
+	r = r100_cs_packet_next_reloc(p, &reloc);
+	if (r) {
+		DRM_ERROR("No reloc for ib[%d]=0x%04X\n",
+			  idx, reg);
+		r100_cs_dump_packet(p, pkt);
+		return r;
+	}
+	value = radeon_get_ib_value(p, idx);
+	tmp = value & 0x003fffff;
+	tmp += (((u32)reloc->lobj.gpu_offset) >> 10);
+
+	if (reloc->lobj.tiling_flags & RADEON_TILING_MACRO)
+		tile_flags |= RADEON_DST_TILE_MACRO;
+	if (reloc->lobj.tiling_flags & RADEON_TILING_MICRO) {
+		if (reg == RADEON_SRC_PITCH_OFFSET) {
+			DRM_ERROR("Cannot src blit from microtiled surface\n");
+			r100_cs_dump_packet(p, pkt);
+			return -EINVAL;
+		}
+		tile_flags |= RADEON_DST_TILE_MICRO;
+	}
+
+	tmp |= tile_flags;
+	p->ib->ptr[idx] = (value & 0x3fc00000) | tmp;
+	return 0;
+}
+
+int r100_packet3_load_vbpntr(struct radeon_cs_parser *p,
+			     struct radeon_cs_packet *pkt,
+			     int idx)
+{
+	unsigned c, i;
+	struct radeon_cs_reloc *reloc;
+	struct r100_cs_track *track;
+	int r = 0;
+	volatile uint32_t *ib;
+	u32 idx_value;
+
+	ib = p->ib->ptr;
+	track = (struct r100_cs_track *)p->track;
+	c = radeon_get_ib_value(p, idx++) & 0x1F;
+	track->num_arrays = c;
+	for (i = 0; i < (c - 1); i+=2, idx+=3) {
+		r = r100_cs_packet_next_reloc(p, &reloc);
+		if (r) {
+			DRM_ERROR("No reloc for packet3 %d\n",
+				  pkt->opcode);
+			r100_cs_dump_packet(p, pkt);
+			return r;
+		}
+		idx_value = radeon_get_ib_value(p, idx);
+		ib[idx+1] = radeon_get_ib_value(p, idx + 1) + ((u32)reloc->lobj.gpu_offset);
+
+		track->arrays[i + 0].esize = idx_value >> 8;
+		track->arrays[i + 0].robj = reloc->robj;
+		track->arrays[i + 0].esize &= 0x7F;
+		r = r100_cs_packet_next_reloc(p, &reloc);
+		if (r) {
+			DRM_ERROR("No reloc for packet3 %d\n",
+				  pkt->opcode);
+			r100_cs_dump_packet(p, pkt);
+			return r;
+		}
+		ib[idx+2] = radeon_get_ib_value(p, idx + 2) + ((u32)reloc->lobj.gpu_offset);
+		track->arrays[i + 1].robj = reloc->robj;
+		track->arrays[i + 1].esize = idx_value >> 24;
+		track->arrays[i + 1].esize &= 0x7F;
+	}
+	if (c & 1) {
+		r = r100_cs_packet_next_reloc(p, &reloc);
+		if (r) {
+			DRM_ERROR("No reloc for packet3 %d\n",
+					  pkt->opcode);
+			r100_cs_dump_packet(p, pkt);
+			return r;
+		}
+		idx_value = radeon_get_ib_value(p, idx);
+		ib[idx+1] = radeon_get_ib_value(p, idx + 1) + ((u32)reloc->lobj.gpu_offset);
+		track->arrays[i + 0].robj = reloc->robj;
+		track->arrays[i + 0].esize = idx_value >> 8;
+		track->arrays[i + 0].esize &= 0x7F;
+	}
+	return r;
+}
diff --git a/drivers/gpu/drm/radeon/r100_track.h b/drivers/gpu/drm/radeon/r100_track.h
index 2fef9de..16634f7 100644
--- a/drivers/gpu/drm/radeon/r100_track.h
+++ b/drivers/gpu/drm/radeon/r100_track.h
@@ -92,100 +92,11 @@ int r200_packet0_check(struct radeon_cs_parser *p,
 		       struct radeon_cs_packet *pkt,
 		       unsigned idx, unsigned reg);
 
+int r100_reloc_pitch_offset(struct radeon_cs_parser *p,
+			    struct radeon_cs_packet *pkt,
+			    unsigned idx,
+			    unsigned reg);
+int r100_packet3_load_vbpntr(struct radeon_cs_parser *p,
+			     struct radeon_cs_packet *pkt,
+			     int idx);
 
-
-static inline int r100_reloc_pitch_offset(struct radeon_cs_parser *p,
-					  struct radeon_cs_packet *pkt,
-					  unsigned idx,
-					  unsigned reg)
-{
-	int r;
-	u32 tile_flags = 0;
-	u32 tmp;
-	struct radeon_cs_reloc *reloc;
-	u32 value;
-
-	r = r100_cs_packet_next_reloc(p, &reloc);
-	if (r) {
-		DRM_ERROR("No reloc for ib[%d]=0x%04X\n",
-			  idx, reg);
-		r100_cs_dump_packet(p, pkt);
-		return r;
-	}
-	value = radeon_get_ib_value(p, idx);
-	tmp = value & 0x003fffff;
-	tmp += (((u32)reloc->lobj.gpu_offset) >> 10);
-
-	if (reloc->lobj.tiling_flags & RADEON_TILING_MACRO)
-		tile_flags |= RADEON_DST_TILE_MACRO;
-	if (reloc->lobj.tiling_flags & RADEON_TILING_MICRO) {
-		if (reg == RADEON_SRC_PITCH_OFFSET) {
-			DRM_ERROR("Cannot src blit from microtiled surface\n");
-			r100_cs_dump_packet(p, pkt);
-			return -EINVAL;
-		}
-		tile_flags |= RADEON_DST_TILE_MICRO;
-	}
-
-	tmp |= tile_flags;
-	p->ib->ptr[idx] = (value & 0x3fc00000) | tmp;
-	return 0;
-}
-
-static inline int r100_packet3_load_vbpntr(struct radeon_cs_parser *p,
-					   struct radeon_cs_packet *pkt,
-					   int idx)
-{
-	unsigned c, i;
-	struct radeon_cs_reloc *reloc;
-	struct r100_cs_track *track;
-	int r = 0;
-	volatile uint32_t *ib;
-	u32 idx_value;
-
-	ib = p->ib->ptr;
-	track = (struct r100_cs_track *)p->track;
-	c = radeon_get_ib_value(p, idx++) & 0x1F;
-	track->num_arrays = c;
-	for (i = 0; i < (c - 1); i+=2, idx+=3) {
-		r = r100_cs_packet_next_reloc(p, &reloc);
-		if (r) {
-			DRM_ERROR("No reloc for packet3 %d\n",
-				  pkt->opcode);
-			r100_cs_dump_packet(p, pkt);
-			return r;
-		}
-		idx_value = radeon_get_ib_value(p, idx);
-		ib[idx+1] = radeon_get_ib_value(p, idx + 1) + ((u32)reloc->lobj.gpu_offset);
-
-		track->arrays[i + 0].esize = idx_value >> 8;
-		track->arrays[i + 0].robj = reloc->robj;
-		track->arrays[i + 0].esize &= 0x7F;
-		r = r100_cs_packet_next_reloc(p, &reloc);
-		if (r) {
-			DRM_ERROR("No reloc for packet3 %d\n",
-				  pkt->opcode);
-			r100_cs_dump_packet(p, pkt);
-			return r;
-		}
-		ib[idx+2] = radeon_get_ib_value(p, idx + 2) + ((u32)reloc->lobj.gpu_offset);
-		track->arrays[i + 1].robj = reloc->robj;
-		track->arrays[i + 1].esize = idx_value >> 24;
-		track->arrays[i + 1].esize &= 0x7F;
-	}
-	if (c & 1) {
-		r = r100_cs_packet_next_reloc(p, &reloc);
-		if (r) {
-			DRM_ERROR("No reloc for packet3 %d\n",
-					  pkt->opcode);
-			r100_cs_dump_packet(p, pkt);
-			return r;
-		}
-		idx_value = radeon_get_ib_value(p, idx);
-		ib[idx+1] = radeon_get_ib_value(p, idx + 1) + ((u32)reloc->lobj.gpu_offset);
-		track->arrays[i + 0].robj = reloc->robj;
-		track->arrays[i + 0].esize = idx_value >> 8;
-		track->arrays[i + 0].esize &= 0x7F;
-	}
-	return r;
-}
-- 
1.7.4.4

