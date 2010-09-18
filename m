Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab0IRTQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:16:27 -0400
Received: from kroah.org ([198.145.64.141]:43902 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217Ab0IRTQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:25 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:07 2010
Message-Id: <20100918191307.081234318@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [114/129] drm/radeon/kms: fix a regression on r7xx AGP due to the HDP flush fix
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 87cbf8f2c5d1b1fc4642c3dc0bb6efc587479603 upstream.

commit: 812d046915f48236657f02c06d7dc47140e9ceda
drm/radeon/kms/r7xx: add workaround for hw issue with HDP flush
breaks on AGP boards since there is no VRAM gart table.

This patch fixes the issue by creating a VRAM scratch page so that
can be used on both AGP and PCIE.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=29834

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r600.c   |    2 -
 drivers/gpu/drm/radeon/radeon.h |    6 ++++
 drivers/gpu/drm/radeon/rv770.c  |   52 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -3526,7 +3526,7 @@ void r600_ioctl_wait_idle(struct radeon_
 	 * rather than write to HDP_REG_COHERENCY_FLUSH_CNTL
 	 */
 	if ((rdev->family >= CHIP_RV770) && (rdev->family <= CHIP_RV740)) {
-		void __iomem *ptr = (void *)rdev->gart.table.vram.ptr;
+		void __iomem *ptr = (void *)rdev->vram_scratch.ptr;
 		u32 tmp;
 
 		WREG32(HDP_DEBUG1, 0);
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -997,6 +997,11 @@ int radeon_gem_set_tiling_ioctl(struct d
 int radeon_gem_get_tiling_ioctl(struct drm_device *dev, void *data,
 				struct drm_file *filp);
 
+/* VRAM scratch page for HDP bug */
+struct r700_vram_scratch {
+	struct radeon_bo		*robj;
+	volatile uint32_t		*ptr;
+};
 
 /*
  * Core structure, functions and helpers.
@@ -1060,6 +1065,7 @@ struct radeon_device {
 	const struct firmware *pfp_fw;	/* r6/700 PFP firmware */
 	const struct firmware *rlc_fw;	/* r6/700 RLC firmware */
 	struct r600_blit r600_blit;
+	struct r700_vram_scratch vram_scratch;
 	int msi_enabled; /* msi enabled */
 	struct r600_ih ih; /* r6/700 interrupt ring */
 	struct workqueue_struct *wq;
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -889,6 +889,54 @@ static void rv770_gpu_init(struct radeon
 
 }
 
+static int rv770_vram_scratch_init(struct radeon_device *rdev)
+{
+	int r;
+	u64 gpu_addr;
+
+	if (rdev->vram_scratch.robj == NULL) {
+		r = radeon_bo_create(rdev, NULL, RADEON_GPU_PAGE_SIZE,
+					true, RADEON_GEM_DOMAIN_VRAM,
+					&rdev->vram_scratch.robj);
+		if (r) {
+			return r;
+		}
+	}
+
+	r = radeon_bo_reserve(rdev->vram_scratch.robj, false);
+	if (unlikely(r != 0))
+		return r;
+	r = radeon_bo_pin(rdev->vram_scratch.robj,
+			  RADEON_GEM_DOMAIN_VRAM, &gpu_addr);
+	if (r) {
+		radeon_bo_unreserve(rdev->vram_scratch.robj);
+		return r;
+	}
+	r = radeon_bo_kmap(rdev->vram_scratch.robj,
+				(void **)&rdev->vram_scratch.ptr);
+	if (r)
+		radeon_bo_unpin(rdev->vram_scratch.robj);
+	radeon_bo_unreserve(rdev->vram_scratch.robj);
+
+	return r;
+}
+
+static void rv770_vram_scratch_fini(struct radeon_device *rdev)
+{
+	int r;
+
+	if (rdev->vram_scratch.robj == NULL) {
+		return;
+	}
+	r = radeon_bo_reserve(rdev->vram_scratch.robj, false);
+	if (likely(r == 0)) {
+		radeon_bo_kunmap(rdev->vram_scratch.robj);
+		radeon_bo_unpin(rdev->vram_scratch.robj);
+		radeon_bo_unreserve(rdev->vram_scratch.robj);
+	}
+	radeon_bo_unref(&rdev->vram_scratch.robj);
+}
+
 int rv770_mc_init(struct radeon_device *rdev)
 {
 	u32 tmp;
@@ -954,6 +1002,9 @@ static int rv770_startup(struct radeon_d
 		if (r)
 			return r;
 	}
+	r = rv770_vram_scratch_init(rdev);
+	if (r)
+		return r;
 	rv770_gpu_init(rdev);
 	r = r600_blit_init(rdev);
 	if (r) {
@@ -1179,6 +1230,7 @@ void rv770_fini(struct radeon_device *rd
 	r600_irq_fini(rdev);
 	radeon_irq_kms_fini(rdev);
 	rv770_pcie_gart_fini(rdev);
+	rv770_vram_scratch_fini(rdev);
 	radeon_gem_fini(rdev);
 	radeon_fence_driver_fini(rdev);
 	radeon_clocks_fini(rdev);


