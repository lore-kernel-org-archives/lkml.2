Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab1JMXKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 19:10:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:61259 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896Ab1JMXI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 19:08:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="62778874"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, airlied@linux.ie
Subject: [PATCH 06/12] RADEON: Remove more bogus inlines in the radeon driver.
Date: Thu, 13 Oct 2011 16:08:46 -0700
Message-Id: <1318547332-23155-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
References: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Remove bogus inlines in evergreen and r100.

Cc: airlied@linux.ie
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/gpu/drm/radeon/evergreen.c          |    4 +-
 drivers/gpu/drm/radeon/evergreen_blit_kms.c |    2 +-
 drivers/gpu/drm/radeon/r100.c               |  106 +++++++++++++++++++++++++-
 drivers/gpu/drm/radeon/r100_track.h         |  110 ++-------------------------
 4 files changed, 114 insertions(+), 108 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index c4ffa14f..1c5cd09 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2586,7 +2586,7 @@ int evergreen_irq_set(struct radeon_device *rdev)
 	return 0;
 }
 
-static inline void evergreen_irq_ack(struct radeon_device *rdev)
+static void evergreen_irq_ack(struct radeon_device *rdev)
 {
 	u32 tmp;
 
@@ -2697,7 +2697,7 @@ void evergreen_irq_suspend(struct radeon_device *rdev)
 	r600_rlc_stop(rdev);
 }
 
-static inline u32 evergreen_get_ih_wptr(struct radeon_device *rdev)
+static u32 evergreen_get_ih_wptr(struct radeon_device *rdev)
 {
 	u32 wptr, tmp;
 
diff --git a/drivers/gpu/drm/radeon/evergreen_blit_kms.c b/drivers/gpu/drm/radeon/evergreen_blit_kms.c
index 2eb2518..7eb78b3 100644
--- a/drivers/gpu/drm/radeon/evergreen_blit_kms.c
+++ b/drivers/gpu/drm/radeon/evergreen_blit_kms.c
@@ -584,7 +584,7 @@ set_default_state(struct radeon_device *rdev)
 
 }
 
-static inline uint32_t i2f(uint32_t input)
+static uint32_t i2f(uint32_t input)
 {
 	u32 result, i, exponent, fraction;
 
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 9a1efac..6720929 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -68,6 +68,108 @@ MODULE_FIRMWARE(FIRMWARE_R520);
  * r100,rv100,rs100,rv200,rs200,r200,rv250,rs300,rv280
  */
 
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
+	if (c > 16) {
+	    DRM_ERROR("Only 16 vertex buffers are allowed %d\n",
+		      pkt->opcode);
+	    r100_cs_dump_packet(p, pkt);
+	    return -EINVAL;
+	}
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
+
 void r100_pre_page_flip(struct radeon_device *rdev, int crtc)
 {
 	/* enable the pflip int */
@@ -588,7 +690,7 @@ void r100_irq_disable(struct radeon_device *rdev)
 	WREG32(R_000044_GEN_INT_STATUS, tmp);
 }
 
-static inline uint32_t r100_irq_ack(struct radeon_device *rdev)
+static uint32_t r100_irq_ack(struct radeon_device *rdev)
 {
 	uint32_t irqs = RREG32(RADEON_GEN_INT_STATUS);
 	uint32_t irq_mask = RADEON_SW_INT_TEST |
@@ -3147,7 +3249,7 @@ void r100_bandwidth_update(struct radeon_device *rdev)
 	}
 }
 
-static inline void r100_cs_track_texture_print(struct r100_cs_track_texture *t)
+static void r100_cs_track_texture_print(struct r100_cs_track_texture *t)
 {
 	DRM_ERROR("pitch                      %d\n", t->pitch);
 	DRM_ERROR("use_pitch                  %d\n", t->use_pitch);
diff --git a/drivers/gpu/drm/radeon/r100_track.h b/drivers/gpu/drm/radeon/r100_track.h
index 686f9dc..6a603b3 100644
--- a/drivers/gpu/drm/radeon/r100_track.h
+++ b/drivers/gpu/drm/radeon/r100_track.h
@@ -92,106 +92,10 @@ int r200_packet0_check(struct radeon_cs_parser *p,
 		       struct radeon_cs_packet *pkt,
 		       unsigned idx, unsigned reg);
 
-
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
-	if (c > 16) {
-	    DRM_ERROR("Only 16 vertex buffers are allowed %d\n",
-		      pkt->opcode);
-	    r100_cs_dump_packet(p, pkt);
-	    return -EINVAL;
-	}
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
+int r100_reloc_pitch_offset(struct radeon_cs_parser *p,
+			    struct radeon_cs_packet *pkt,
+			    unsigned idx,
+			    unsigned reg);
+int r100_packet3_load_vbpntr(struct radeon_cs_parser *p,
+			     struct radeon_cs_packet *pkt,
+			     int idx);
-- 
1.7.4.4

