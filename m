Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab2HTEOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:14:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42117 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab2HTD6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:58:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>
Subject: [ 12/32] drm/radeon: do not reenable crtc after moving vram start address
Date: Sun, 19 Aug 2012 20:57:08 -0700
Message-Id: <20120820035649.566601892@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035647.862247088@linuxfoundation.org>
References: <20120820035647.862247088@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 81ee8fb6b52ec69eeed37fe7943446af1dccecc5 upstream.

It seems we can not update the crtc scanout address. After disabling
crtc, update to base address do not take effect after crtc being
reenable leading to at least frame being scanout from the old crtc
base address. Disabling crtc display request lead to same behavior.

So after changing the vram address if we don't keep crtc disabled
we will have the GPU trying to read some random system memory address
with some iommu this will broke the crtc engine and will lead to
broken display and iommu error message.

So to avoid this, disable crtc. For flicker less boot we will need
to avoid moving the vram start address.

This patch should also fix :

https://bugs.freedesktop.org/show_bug.cgi?id=42373

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c   |   57 -----------------------------------
 drivers/gpu/drm/radeon/radeon_asic.h |    8 +---
 drivers/gpu/drm/radeon/rv515.c       |   13 -------
 3 files changed, 2 insertions(+), 76 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1117,24 +1117,8 @@ void evergreen_agp_enable(struct radeon_
 
 void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *save)
 {
-	save->vga_control[0] = RREG32(D1VGA_CONTROL);
-	save->vga_control[1] = RREG32(D2VGA_CONTROL);
 	save->vga_render_control = RREG32(VGA_RENDER_CONTROL);
 	save->vga_hdp_control = RREG32(VGA_HDP_CONTROL);
-	save->crtc_control[0] = RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET);
-	save->crtc_control[1] = RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET);
-	if (rdev->num_crtc >= 4) {
-		save->vga_control[2] = RREG32(EVERGREEN_D3VGA_CONTROL);
-		save->vga_control[3] = RREG32(EVERGREEN_D4VGA_CONTROL);
-		save->crtc_control[2] = RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET);
-		save->crtc_control[3] = RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET);
-	}
-	if (rdev->num_crtc >= 6) {
-		save->vga_control[4] = RREG32(EVERGREEN_D5VGA_CONTROL);
-		save->vga_control[5] = RREG32(EVERGREEN_D6VGA_CONTROL);
-		save->crtc_control[4] = RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET);
-		save->crtc_control[5] = RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET);
-	}
 
 	/* Stop all video */
 	WREG32(VGA_RENDER_CONTROL, 0);
@@ -1245,47 +1229,6 @@ void evergreen_mc_resume(struct radeon_d
 	/* Unlock host access */
 	WREG32(VGA_HDP_CONTROL, save->vga_hdp_control);
 	mdelay(1);
-	/* Restore video state */
-	WREG32(D1VGA_CONTROL, save->vga_control[0]);
-	WREG32(D2VGA_CONTROL, save->vga_control[1]);
-	if (rdev->num_crtc >= 4) {
-		WREG32(EVERGREEN_D3VGA_CONTROL, save->vga_control[2]);
-		WREG32(EVERGREEN_D4VGA_CONTROL, save->vga_control[3]);
-	}
-	if (rdev->num_crtc >= 6) {
-		WREG32(EVERGREEN_D5VGA_CONTROL, save->vga_control[4]);
-		WREG32(EVERGREEN_D6VGA_CONTROL, save->vga_control[5]);
-	}
-	WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC0_REGISTER_OFFSET, 1);
-	WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC1_REGISTER_OFFSET, 1);
-	if (rdev->num_crtc >= 4) {
-		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC2_REGISTER_OFFSET, 1);
-		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC3_REGISTER_OFFSET, 1);
-	}
-	if (rdev->num_crtc >= 6) {
-		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC4_REGISTER_OFFSET, 1);
-		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC5_REGISTER_OFFSET, 1);
-	}
-	WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET, save->crtc_control[0]);
-	WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET, save->crtc_control[1]);
-	if (rdev->num_crtc >= 4) {
-		WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET, save->crtc_control[2]);
-		WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET, save->crtc_control[3]);
-	}
-	if (rdev->num_crtc >= 6) {
-		WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET, save->crtc_control[4]);
-		WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET, save->crtc_control[5]);
-	}
-	WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC0_REGISTER_OFFSET, 0);
-	WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC1_REGISTER_OFFSET, 0);
-	if (rdev->num_crtc >= 4) {
-		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC2_REGISTER_OFFSET, 0);
-		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC3_REGISTER_OFFSET, 0);
-	}
-	if (rdev->num_crtc >= 6) {
-		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC4_REGISTER_OFFSET, 0);
-		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC5_REGISTER_OFFSET, 0);
-	}
 	WREG32(VGA_RENDER_CONTROL, save->vga_render_control);
 }
 
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -262,13 +262,10 @@ extern int rs690_mc_wait_for_idle(struct
  * rv515
  */
 struct rv515_mc_save {
-	u32 d1vga_control;
-	u32 d2vga_control;
 	u32 vga_render_control;
 	u32 vga_hdp_control;
-	u32 d1crtc_control;
-	u32 d2crtc_control;
 };
+
 int rv515_init(struct radeon_device *rdev);
 void rv515_fini(struct radeon_device *rdev);
 uint32_t rv515_mc_rreg(struct radeon_device *rdev, uint32_t reg);
@@ -401,11 +398,10 @@ void r700_cp_fini(struct radeon_device *
  * evergreen
  */
 struct evergreen_mc_save {
-	u32 vga_control[6];
 	u32 vga_render_control;
 	u32 vga_hdp_control;
-	u32 crtc_control[6];
 };
+
 void evergreen_pcie_gart_tlb_flush(struct radeon_device *rdev);
 int evergreen_init(struct radeon_device *rdev);
 void evergreen_fini(struct radeon_device *rdev);
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -281,12 +281,8 @@ int rv515_debugfs_ga_info_init(struct ra
 
 void rv515_mc_stop(struct radeon_device *rdev, struct rv515_mc_save *save)
 {
-	save->d1vga_control = RREG32(R_000330_D1VGA_CONTROL);
-	save->d2vga_control = RREG32(R_000338_D2VGA_CONTROL);
 	save->vga_render_control = RREG32(R_000300_VGA_RENDER_CONTROL);
 	save->vga_hdp_control = RREG32(R_000328_VGA_HDP_CONTROL);
-	save->d1crtc_control = RREG32(R_006080_D1CRTC_CONTROL);
-	save->d2crtc_control = RREG32(R_006880_D2CRTC_CONTROL);
 
 	/* Stop all video */
 	WREG32(R_0068E8_D2CRTC_UPDATE_LOCK, 0);
@@ -311,15 +307,6 @@ void rv515_mc_resume(struct radeon_devic
 	/* Unlock host access */
 	WREG32(R_000328_VGA_HDP_CONTROL, save->vga_hdp_control);
 	mdelay(1);
-	/* Restore video state */
-	WREG32(R_000330_D1VGA_CONTROL, save->d1vga_control);
-	WREG32(R_000338_D2VGA_CONTROL, save->d2vga_control);
-	WREG32(R_0060E8_D1CRTC_UPDATE_LOCK, 1);
-	WREG32(R_0068E8_D2CRTC_UPDATE_LOCK, 1);
-	WREG32(R_006080_D1CRTC_CONTROL, save->d1crtc_control);
-	WREG32(R_006880_D2CRTC_CONTROL, save->d2crtc_control);
-	WREG32(R_0060E8_D1CRTC_UPDATE_LOCK, 0);
-	WREG32(R_0068E8_D2CRTC_UPDATE_LOCK, 0);
 	WREG32(R_000300_VGA_RENDER_CONTROL, save->vga_render_control);
 }
 


