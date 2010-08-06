Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964987Ab0HFShz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:37:55 -0400
Received: from kroah.org ([198.145.64.141]:48743 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964959Ab0HFSgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:36:11 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:03 2010
Message-Id: <20100806183203.149360827@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [35/38] drm/radeon/kms/r7xx: add workaround for hw issue with HDP flush
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 812d046915f48236657f02c06d7dc47140e9ceda upstream.

Use of HDP_*_COHERENCY_FLUSH_CNTL can cause a hang in certain
situations.  Add workaround.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r600.c   |   24 ++++++++++++++++++++++--
 drivers/gpu/drm/radeon/r600d.h  |    1 +
 drivers/gpu/drm/radeon/rv770.c  |    5 ++++-
 drivers/gpu/drm/radeon/rv770d.h |    1 +
 4 files changed, 28 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -869,7 +869,17 @@ void r600_pcie_gart_tlb_flush(struct rad
 	u32 tmp;
 
 	/* flush hdp cache so updates hit vram */
-	WREG32(R_005480_HDP_MEM_COHERENCY_FLUSH_CNTL, 0x1);
+	if ((rdev->family >= CHIP_RV770) && (rdev->family <= CHIP_RV740)) {
+		void __iomem *ptr = (void *)rdev->gart.table.vram.ptr;
+		u32 tmp;
+
+		/* r7xx hw bug.  write to HDP_DEBUG1 followed by fb read
+		 * rather than write to HDP_REG_COHERENCY_FLUSH_CNTL
+		 */
+		WREG32(HDP_DEBUG1, 0);
+		tmp = readl((void __iomem *)ptr);
+	} else
+		WREG32(R_005480_HDP_MEM_COHERENCY_FLUSH_CNTL, 0x1);
 
 	WREG32(VM_CONTEXT0_INVALIDATION_LOW_ADDR, rdev->mc.gtt_start >> 12);
 	WREG32(VM_CONTEXT0_INVALIDATION_HIGH_ADDR, (rdev->mc.gtt_end - 1) >> 12);
@@ -3512,5 +3522,15 @@ int r600_debugfs_mc_info_init(struct rad
  */
 void r600_ioctl_wait_idle(struct radeon_device *rdev, struct radeon_bo *bo)
 {
-	WREG32(R_005480_HDP_MEM_COHERENCY_FLUSH_CNTL, 0x1);
+	/* r7xx hw bug.  write to HDP_DEBUG1 followed by fb read
+	 * rather than write to HDP_REG_COHERENCY_FLUSH_CNTL
+	 */
+	if ((rdev->family >= CHIP_RV770) && (rdev->family <= CHIP_RV740)) {
+		void __iomem *ptr = (void *)rdev->gart.table.vram.ptr;
+		u32 tmp;
+
+		WREG32(HDP_DEBUG1, 0);
+		tmp = readl((void __iomem *)ptr);
+	} else
+		WREG32(R_005480_HDP_MEM_COHERENCY_FLUSH_CNTL, 0x1);
 }
--- a/drivers/gpu/drm/radeon/r600d.h
+++ b/drivers/gpu/drm/radeon/r600d.h
@@ -245,6 +245,7 @@
 #define	HDP_NONSURFACE_SIZE				0x2C0C
 #define HDP_REG_COHERENCY_FLUSH_CNTL			0x54A0
 #define	HDP_TILING_CONFIG				0x2F3C
+#define HDP_DEBUG1                                      0x2F34
 
 #define MC_VM_AGP_TOP					0x2184
 #define MC_VM_AGP_BOT					0x2188
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -189,7 +189,10 @@ static void rv770_mc_program(struct rade
 		WREG32((0x2c20 + j), 0x00000000);
 		WREG32((0x2c24 + j), 0x00000000);
 	}
-	WREG32(HDP_REG_COHERENCY_FLUSH_CNTL, 0);
+	/* r7xx hw bug.  Read from HDP_DEBUG1 rather
+	 * than writing to HDP_REG_COHERENCY_FLUSH_CNTL
+	 */
+	tmp = RREG32(HDP_DEBUG1);
 
 	rv515_mc_stop(rdev, &save);
 	if (r600_mc_wait_for_idle(rdev)) {
--- a/drivers/gpu/drm/radeon/rv770d.h
+++ b/drivers/gpu/drm/radeon/rv770d.h
@@ -128,6 +128,7 @@
 #define	HDP_NONSURFACE_SIZE				0x2C0C
 #define HDP_REG_COHERENCY_FLUSH_CNTL			0x54A0
 #define	HDP_TILING_CONFIG				0x2F3C
+#define HDP_DEBUG1                                      0x2F34
 
 #define MC_SHARED_CHMAP						0x2004
 #define		NOOFCHAN_SHIFT					12


