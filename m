Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab2FQSXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:23:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50159 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757971Ab2FQSWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:19 -0400
Message-Id: <20120617175951.375230652@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 69/69] drm/radeon: add some additional 6xx/7xx/EG register init
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b866d1334ba2d544bc575d75357dea6bdcdc7f46 upstream.

- SMX_SAR_CTL0 needs to be programmed correctly to prevent
problems with memory exports in certain cases.
- VC_ENHANCE needs to be initialized on 6xx/7xx.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/evergreen.c  |    3 +++
 drivers/gpu/drm/radeon/evergreend.h |    1 +
 drivers/gpu/drm/radeon/r600.c       |    1 +
 drivers/gpu/drm/radeon/r600d.h      |    1 +
 drivers/gpu/drm/radeon/rv770.c      |    5 ++++-
 drivers/gpu/drm/radeon/rv770d.h     |    3 +++
 6 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 01550d0..7fb3d2e 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1932,6 +1932,9 @@ static void evergreen_gpu_init(struct radeon_device *rdev)
 	smx_dc_ctl0 |= NUMBER_OF_SETS(rdev->config.evergreen.sx_num_of_sets);
 	WREG32(SMX_DC_CTL0, smx_dc_ctl0);
 
+	if (rdev->family <= CHIP_SUMO2)
+		WREG32(SMX_SAR_CTL0, 0x00010000);
+
 	WREG32(SX_EXPORT_BUFFER_SIZES, (COLOR_BUFFER_SIZE((rdev->config.evergreen.sx_max_export_size / 4) - 1) |
 					POSITION_BUFFER_SIZE((rdev->config.evergreen.sx_max_export_pos_size / 4) - 1) |
 					SMX_BUFFER_SIZE((rdev->config.evergreen.sx_max_export_smx_size / 4) - 1)));
diff --git a/drivers/gpu/drm/radeon/evergreend.h b/drivers/gpu/drm/radeon/evergreend.h
index 2773039..b50b15c 100644
--- a/drivers/gpu/drm/radeon/evergreend.h
+++ b/drivers/gpu/drm/radeon/evergreend.h
@@ -503,6 +503,7 @@
 #define	SCRATCH_UMSK					0x8540
 #define	SCRATCH_ADDR					0x8544
 
+#define	SMX_SAR_CTL0					0xA008
 #define	SMX_DC_CTL0					0xA020
 #define		USE_HASH_FUNCTION				(1 << 0)
 #define		NUMBER_OF_SETS(x)				((x) << 1)
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index f30dc95..bff6272 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -1839,6 +1839,7 @@ void r600_gpu_init(struct radeon_device *rdev)
 	WREG32(PA_CL_ENHANCE, (CLIP_VTX_REORDER_ENA |
 			       NUM_CLIP_SEQ(3)));
 	WREG32(PA_SC_ENHANCE, FORCE_EOV_MAX_CLK_CNT(4095));
+	WREG32(VC_ENHANCE, 0);
 }
 
 
diff --git a/drivers/gpu/drm/radeon/r600d.h b/drivers/gpu/drm/radeon/r600d.h
index a0dbf1f..c6857e8 100644
--- a/drivers/gpu/drm/radeon/r600d.h
+++ b/drivers/gpu/drm/radeon/r600d.h
@@ -485,6 +485,7 @@
 #define		TC_L2_SIZE(x)					((x)<<5)
 #define		L2_DISABLE_LATE_HIT				(1<<9)
 
+#define	VC_ENHANCE					0x9714
 
 #define	VGT_CACHE_INVALIDATION				0x88C4
 #define		CACHE_INVALIDATION(x)				((x)<<0)
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index 4ad0281..b4f51c5 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -616,6 +616,9 @@ static void rv770_gpu_init(struct radeon_device *rdev)
 				       ACK_FLUSH_CTL(3) |
 				       SYNC_FLUSH_CTL));
 
+	if (rdev->family != CHIP_RV770)
+		WREG32(SMX_SAR_CTL0, 0x00003f3f);
+
 	db_debug3 = RREG32(DB_DEBUG3);
 	db_debug3 &= ~DB_CLK_OFF_DELAY(0x1f);
 	switch (rdev->family) {
@@ -792,7 +795,7 @@ static void rv770_gpu_init(struct radeon_device *rdev)
 
 	WREG32(PA_CL_ENHANCE, (CLIP_VTX_REORDER_ENA |
 					  NUM_CLIP_SEQ(3)));
-
+	WREG32(VC_ENHANCE, 0);
 }
 
 void r700_vram_gtt_location(struct radeon_device *rdev, struct radeon_mc *mc)
diff --git a/drivers/gpu/drm/radeon/rv770d.h b/drivers/gpu/drm/radeon/rv770d.h
index fdc0898..b0adfc5 100644
--- a/drivers/gpu/drm/radeon/rv770d.h
+++ b/drivers/gpu/drm/radeon/rv770d.h
@@ -211,6 +211,7 @@
 #define	SCRATCH_UMSK					0x8540
 #define	SCRATCH_ADDR					0x8544
 
+#define	SMX_SAR_CTL0					0xA008
 #define	SMX_DC_CTL0					0xA020
 #define		USE_HASH_FUNCTION				(1 << 0)
 #define		CACHE_DEPTH(x)					((x) << 1)
@@ -310,6 +311,8 @@
 #define	TCP_CNTL					0x9610
 #define	TCP_CHAN_STEER					0x9614
 
+#define	VC_ENHANCE					0x9714
+
 #define	VGT_CACHE_INVALIDATION				0x88C4
 #define		CACHE_INVALIDATION(x)				((x)<<0)
 #define			VC_ONLY						0


