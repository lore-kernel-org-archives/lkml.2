Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab1EUACM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:02:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:33151 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab1EUACI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:02:08 -0400
X-ExtLoop1: 1
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, airlied@linux.ie,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 03/12] RADEON: Move r100_*_*reg out of line
Date: Fri, 20 May 2011 17:01:13 -0700
Message-Id: <1305936082-21304-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
References: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This shrinks the sizes of a lot of functions in the radeon driver
dramatically.

With a non force inline + -Os kernel this is default anyways.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/gpu/drm/radeon/r100.c   |   40 ++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon.h |   43 +++-----------------------------------
 2 files changed, 44 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index f2204cb..1a4de6b 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3967,3 +3967,43 @@ int r100_init(struct radeon_device *rdev)
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
index ba643b5..485acc8 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1246,45 +1246,10 @@ int radeon_device_init(struct radeon_device *rdev,
 void radeon_device_fini(struct radeon_device *rdev);
 int radeon_gpu_wait_for_idle(struct radeon_device *rdev);
 
-static inline uint32_t r100_mm_rreg(struct radeon_device *rdev, uint32_t reg)
-{
-	if (reg < rdev->rmmio_size)
-		return readl(((void __iomem *)rdev->rmmio) + reg);
-	else {
-		writel(reg, ((void __iomem *)rdev->rmmio) + RADEON_MM_INDEX);
-		return readl(((void __iomem *)rdev->rmmio) + RADEON_MM_DATA);
-	}
-}
-
-static inline void r100_mm_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v)
-{
-	if (reg < rdev->rmmio_size)
-		writel(v, ((void __iomem *)rdev->rmmio) + reg);
-	else {
-		writel(reg, ((void __iomem *)rdev->rmmio) + RADEON_MM_INDEX);
-		writel(v, ((void __iomem *)rdev->rmmio) + RADEON_MM_DATA);
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

