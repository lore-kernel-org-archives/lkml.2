Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab1JMXJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 19:09:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:14192 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876Ab1JMXJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 19:09:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,343,1315206000"; 
   d="scan'208";a="73443405"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, David Airlie <airlied@linux.ie>
Subject: [PATCH 02/12] RADEON: Move r100_*_*reg out of line
Date: Thu, 13 Oct 2011 16:08:42 -0700
Message-Id: <1318547332-23155-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
References: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This shrinks the sizes of a lot of functions in the radeon driver
dramatically.

With a non force inline + -Os kernel this is default anyways.

Cc: David Airlie <airlied@linux.ie>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/gpu/drm/radeon/r100.c   |   40 ++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon.h |   43 +++-----------------------------------
 2 files changed, 44 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 7fcdbbb..9a1efac 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3965,3 +3965,43 @@ int r100_init(struct radeon_device *rdev)
 	}
 	return 0;
 }
+
+uint32_t r100_mm_rreg(struct radeon_device *rdev, uint32_t reg)
+{
+	if (reg < rdev->rmmio_size)
+		return readl(((void __iomem *)rdev->rmmio) + reg);
+	else {
+		writel(reg, ((void __iomem *)rdev->rmmio) + RADEON_MM_INDEX);
+		return readl(((void __iomem *)rdev->rmmio) + RADEON_MM_DATA);
+	}
+}
+
+void r100_mm_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v)
+{
+	if (reg < rdev->rmmio_size)
+		writel(v, ((void __iomem *)rdev->rmmio) + reg);
+	else {
+		writel(reg, ((void __iomem *)rdev->rmmio) + RADEON_MM_INDEX);
+		writel(v, ((void __iomem *)rdev->rmmio) + RADEON_MM_DATA);
+	}
+}
+
+u32 r100_io_rreg(struct radeon_device *rdev, u32 reg)
+{
+	if (reg < rdev->rio_mem_size)
+		return ioread32(rdev->rio_mem + reg);
+	else {
+		iowrite32(reg, rdev->rio_mem + RADEON_MM_INDEX);
+		return ioread32(rdev->rio_mem + RADEON_MM_DATA);
+	}
+}
+
+void r100_io_wreg(struct radeon_device *rdev, u32 reg, u32 v)
+{
+	if (reg < rdev->rio_mem_size)
+		iowrite32(v, rdev->rio_mem + reg);
+	else {
+		iowrite32(reg, rdev->rio_mem + RADEON_MM_INDEX);
+		iowrite32(v, rdev->rio_mem + RADEON_MM_DATA);
+	}
+}
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index c1e056b..8ac6cba 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1252,45 +1252,10 @@ int radeon_device_init(struct radeon_device *rdev,
 void radeon_device_fini(struct radeon_device *rdev);
 int radeon_gpu_wait_for_idle(struct radeon_device *rdev);
 
-static inline uint32_t r100_mm_rreg(struct radeon_device *rdev, uint32_t reg)
-{
-	if (reg < rdev->rmmio_size)
-		return readl((rdev->rmmio) + reg);
-	else {
-		writel(reg, (rdev->rmmio) + RADEON_MM_INDEX);
-		return readl((rdev->rmmio) + RADEON_MM_DATA);
-	}
-}
-
-static inline void r100_mm_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v)
-{
-	if (reg < rdev->rmmio_size)
-		writel(v, (rdev->rmmio) + reg);
-	else {
-		writel(reg, (rdev->rmmio) + RADEON_MM_INDEX);
-		writel(v, (rdev->rmmio) + RADEON_MM_DATA);
-	}
-}
-
-static inline u32 r100_io_rreg(struct radeon_device *rdev, u32 reg)
-{
-	if (reg < rdev->rio_mem_size)
-		return ioread32(rdev->rio_mem + reg);
-	else {
-		iowrite32(reg, rdev->rio_mem + RADEON_MM_INDEX);
-		return ioread32(rdev->rio_mem + RADEON_MM_DATA);
-	}
-}
-
-static inline void r100_io_wreg(struct radeon_device *rdev, u32 reg, u32 v)
-{
-	if (reg < rdev->rio_mem_size)
-		iowrite32(v, rdev->rio_mem + reg);
-	else {
-		iowrite32(reg, rdev->rio_mem + RADEON_MM_INDEX);
-		iowrite32(v, rdev->rio_mem + RADEON_MM_DATA);
-	}
-}
+uint32_t r100_mm_rreg(struct radeon_device *rdev, uint32_t reg);
+void r100_mm_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
+u32 r100_io_rreg(struct radeon_device *rdev, u32 reg);
+void r100_io_wreg(struct radeon_device *rdev, u32 reg, u32 v);
 
 /*
  * Cast helper
-- 
1.7.4.4

