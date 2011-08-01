Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1HAX03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:26:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38519 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab1HAX0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:26:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:54 2011
Message-Id: <20110801232054.734836104@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [41/70] drm/radeon/kms: clean up multiple crtc handling for
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 evergreen+ (v2)

From: Alex Deucher <alexdeucher@gmail.com>

commit b7eff394670366a42935bfbaef67a6f7185627d7 upstream.

evergreen+ asics have 2-6 crtcs.  Don't access crtc registers
for crtc regs that don't exist as they have very high latency
and may cause problems on some asics.  The previous code missed
a few cases and was not fine grained enough (missed the 4 crtc
case for example).

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=38800

v2: fix typo noticed by Chris Bandy <cbandy@jbandy.com>

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Reviewed-by: Michel Dänzer <michel@daenzer.net>
Tested-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreen.c |  159 ++++++++++++++++++++++---------------
 1 file changed, 98 insertions(+), 61 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -960,17 +960,19 @@ void evergreen_mc_stop(struct radeon_dev
 {
 	save->vga_control[0] = RREG32(D1VGA_CONTROL);
 	save->vga_control[1] = RREG32(D2VGA_CONTROL);
-	save->vga_control[2] = RREG32(EVERGREEN_D3VGA_CONTROL);
-	save->vga_control[3] = RREG32(EVERGREEN_D4VGA_CONTROL);
-	save->vga_control[4] = RREG32(EVERGREEN_D5VGA_CONTROL);
-	save->vga_control[5] = RREG32(EVERGREEN_D6VGA_CONTROL);
 	save->vga_render_control = RREG32(VGA_RENDER_CONTROL);
 	save->vga_hdp_control = RREG32(VGA_HDP_CONTROL);
 	save->crtc_control[0] = RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET);
 	save->crtc_control[1] = RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET);
-	if (!(rdev->flags & RADEON_IS_IGP)) {
+	if (rdev->num_crtc >= 4) {
+		save->vga_control[2] = RREG32(EVERGREEN_D3VGA_CONTROL);
+		save->vga_control[3] = RREG32(EVERGREEN_D4VGA_CONTROL);
 		save->crtc_control[2] = RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET);
 		save->crtc_control[3] = RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET);
+	}
+	if (rdev->num_crtc >= 6) {
+		save->vga_control[4] = RREG32(EVERGREEN_D5VGA_CONTROL);
+		save->vga_control[5] = RREG32(EVERGREEN_D6VGA_CONTROL);
 		save->crtc_control[4] = RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET);
 		save->crtc_control[5] = RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET);
 	}
@@ -979,35 +981,45 @@ void evergreen_mc_stop(struct radeon_dev
 	WREG32(VGA_RENDER_CONTROL, 0);
 	WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC0_REGISTER_OFFSET, 1);
 	WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC1_REGISTER_OFFSET, 1);
-	if (!(rdev->flags & RADEON_IS_IGP)) {
+	if (rdev->num_crtc >= 4) {
 		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC2_REGISTER_OFFSET, 1);
 		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC3_REGISTER_OFFSET, 1);
+	}
+	if (rdev->num_crtc >= 6) {
 		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC4_REGISTER_OFFSET, 1);
 		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC5_REGISTER_OFFSET, 1);
 	}
 	WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET, 0);
 	WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET, 0);
-	if (!(rdev->flags & RADEON_IS_IGP)) {
+	if (rdev->num_crtc >= 4) {
 		WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET, 0);
 		WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET, 0);
+	}
+	if (rdev->num_crtc >= 6) {
 		WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET, 0);
 		WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET, 0);
 	}
 	WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC0_REGISTER_OFFSET, 0);
 	WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC1_REGISTER_OFFSET, 0);
-	if (!(rdev->flags & RADEON_IS_IGP)) {
+	if (rdev->num_crtc >= 4) {
 		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC2_REGISTER_OFFSET, 0);
 		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC3_REGISTER_OFFSET, 0);
+	}
+	if (rdev->num_crtc >= 6) {
 		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC4_REGISTER_OFFSET, 0);
 		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC5_REGISTER_OFFSET, 0);
 	}
 
 	WREG32(D1VGA_CONTROL, 0);
 	WREG32(D2VGA_CONTROL, 0);
-	WREG32(EVERGREEN_D3VGA_CONTROL, 0);
-	WREG32(EVERGREEN_D4VGA_CONTROL, 0);
-	WREG32(EVERGREEN_D5VGA_CONTROL, 0);
-	WREG32(EVERGREEN_D6VGA_CONTROL, 0);
+	if (rdev->num_crtc >= 4) {
+		WREG32(EVERGREEN_D3VGA_CONTROL, 0);
+		WREG32(EVERGREEN_D4VGA_CONTROL, 0);
+	}
+	if (rdev->num_crtc >= 6) {
+		WREG32(EVERGREEN_D5VGA_CONTROL, 0);
+		WREG32(EVERGREEN_D6VGA_CONTROL, 0);
+	}
 }
 
 void evergreen_mc_resume(struct radeon_device *rdev, struct evergreen_mc_save *save)
@@ -1030,7 +1042,7 @@ void evergreen_mc_resume(struct radeon_d
 	WREG32(EVERGREEN_GRPH_SECONDARY_SURFACE_ADDRESS + EVERGREEN_CRTC1_REGISTER_OFFSET,
 	       (u32)rdev->mc.vram_start);
 
-	if (!(rdev->flags & RADEON_IS_IGP)) {
+	if (rdev->num_crtc >= 4) {
 		WREG32(EVERGREEN_GRPH_PRIMARY_SURFACE_ADDRESS_HIGH + EVERGREEN_CRTC2_REGISTER_OFFSET,
 		       upper_32_bits(rdev->mc.vram_start));
 		WREG32(EVERGREEN_GRPH_SECONDARY_SURFACE_ADDRESS_HIGH + EVERGREEN_CRTC2_REGISTER_OFFSET,
@@ -1048,7 +1060,8 @@ void evergreen_mc_resume(struct radeon_d
 		       (u32)rdev->mc.vram_start);
 		WREG32(EVERGREEN_GRPH_SECONDARY_SURFACE_ADDRESS + EVERGREEN_CRTC3_REGISTER_OFFSET,
 		       (u32)rdev->mc.vram_start);
-
+	}
+	if (rdev->num_crtc >= 6) {
 		WREG32(EVERGREEN_GRPH_PRIMARY_SURFACE_ADDRESS_HIGH + EVERGREEN_CRTC4_REGISTER_OFFSET,
 		       upper_32_bits(rdev->mc.vram_start));
 		WREG32(EVERGREEN_GRPH_SECONDARY_SURFACE_ADDRESS_HIGH + EVERGREEN_CRTC4_REGISTER_OFFSET,
@@ -1076,31 +1089,41 @@ void evergreen_mc_resume(struct radeon_d
 	/* Restore video state */
 	WREG32(D1VGA_CONTROL, save->vga_control[0]);
 	WREG32(D2VGA_CONTROL, save->vga_control[1]);
-	WREG32(EVERGREEN_D3VGA_CONTROL, save->vga_control[2]);
-	WREG32(EVERGREEN_D4VGA_CONTROL, save->vga_control[3]);
-	WREG32(EVERGREEN_D5VGA_CONTROL, save->vga_control[4]);
-	WREG32(EVERGREEN_D6VGA_CONTROL, save->vga_control[5]);
+	if (rdev->num_crtc >= 4) {
+		WREG32(EVERGREEN_D3VGA_CONTROL, save->vga_control[2]);
+		WREG32(EVERGREEN_D4VGA_CONTROL, save->vga_control[3]);
+	}
+	if (rdev->num_crtc >= 6) {
+		WREG32(EVERGREEN_D5VGA_CONTROL, save->vga_control[4]);
+		WREG32(EVERGREEN_D6VGA_CONTROL, save->vga_control[5]);
+	}
 	WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC0_REGISTER_OFFSET, 1);
 	WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC1_REGISTER_OFFSET, 1);
-	if (!(rdev->flags & RADEON_IS_IGP)) {
+	if (rdev->num_crtc >= 4) {
 		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC2_REGISTER_OFFSET, 1);
 		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC3_REGISTER_OFFSET, 1);
+	}
+	if (rdev->num_crtc >= 6) {
 		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC4_REGISTER_OFFSET, 1);
 		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC5_REGISTER_OFFSET, 1);
 	}
 	WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET, save->crtc_control[0]);
 	WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET, save->crtc_control[1]);
-	if (!(rdev->flags & RADEON_IS_IGP)) {
+	if (rdev->num_crtc >= 4) {
 		WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET, save->crtc_control[2]);
 		WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET, save->crtc_control[3]);
+	}
+	if (rdev->num_crtc >= 6) {
 		WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET, save->crtc_control[4]);
 		WREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET, save->crtc_control[5]);
 	}
 	WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC0_REGISTER_OFFSET, 0);
 	WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC1_REGISTER_OFFSET, 0);
-	if (!(rdev->flags & RADEON_IS_IGP)) {
+	if (rdev->num_crtc >= 4) {
 		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC2_REGISTER_OFFSET, 0);
 		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC3_REGISTER_OFFSET, 0);
+	}
+	if (rdev->num_crtc >= 6) {
 		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC4_REGISTER_OFFSET, 0);
 		WREG32(EVERGREEN_CRTC_UPDATE_LOCK + EVERGREEN_CRTC5_REGISTER_OFFSET, 0);
 	}
@@ -2327,18 +2350,22 @@ void evergreen_disable_interrupt_state(s
 	WREG32(GRBM_INT_CNTL, 0);
 	WREG32(INT_MASK + EVERGREEN_CRTC0_REGISTER_OFFSET, 0);
 	WREG32(INT_MASK + EVERGREEN_CRTC1_REGISTER_OFFSET, 0);
-	if (!(rdev->flags & RADEON_IS_IGP)) {
+	if (rdev->num_crtc >= 4) {
 		WREG32(INT_MASK + EVERGREEN_CRTC2_REGISTER_OFFSET, 0);
 		WREG32(INT_MASK + EVERGREEN_CRTC3_REGISTER_OFFSET, 0);
+	}
+	if (rdev->num_crtc >= 6) {
 		WREG32(INT_MASK + EVERGREEN_CRTC4_REGISTER_OFFSET, 0);
 		WREG32(INT_MASK + EVERGREEN_CRTC5_REGISTER_OFFSET, 0);
 	}
 
 	WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET, 0);
 	WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET, 0);
-	if (!(rdev->flags & RADEON_IS_IGP)) {
+	if (rdev->num_crtc >= 4) {
 		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET, 0);
 		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET, 0);
+	}
+	if (rdev->num_crtc >= 6) {
 		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET, 0);
 		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET, 0);
 	}
@@ -2457,19 +2484,25 @@ int evergreen_irq_set(struct radeon_devi
 
 	WREG32(INT_MASK + EVERGREEN_CRTC0_REGISTER_OFFSET, crtc1);
 	WREG32(INT_MASK + EVERGREEN_CRTC1_REGISTER_OFFSET, crtc2);
-	if (!(rdev->flags & RADEON_IS_IGP)) {
+	if (rdev->num_crtc >= 4) {
 		WREG32(INT_MASK + EVERGREEN_CRTC2_REGISTER_OFFSET, crtc3);
 		WREG32(INT_MASK + EVERGREEN_CRTC3_REGISTER_OFFSET, crtc4);
+	}
+	if (rdev->num_crtc >= 6) {
 		WREG32(INT_MASK + EVERGREEN_CRTC4_REGISTER_OFFSET, crtc5);
 		WREG32(INT_MASK + EVERGREEN_CRTC5_REGISTER_OFFSET, crtc6);
 	}
 
 	WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET, grph1);
 	WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET, grph2);
-	WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET, grph3);
-	WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET, grph4);
-	WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET, grph5);
-	WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET, grph6);
+	if (rdev->num_crtc >= 4) {
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET, grph3);
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET, grph4);
+	}
+	if (rdev->num_crtc >= 6) {
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET, grph5);
+		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET, grph6);
+	}
 
 	WREG32(DC_HPD1_INT_CONTROL, hpd1);
 	WREG32(DC_HPD2_INT_CONTROL, hpd2);
@@ -2493,53 +2526,57 @@ static inline void evergreen_irq_ack(str
 	rdev->irq.stat_regs.evergreen.disp_int_cont5 = RREG32(DISP_INTERRUPT_STATUS_CONTINUE5);
 	rdev->irq.stat_regs.evergreen.d1grph_int = RREG32(GRPH_INT_STATUS + EVERGREEN_CRTC0_REGISTER_OFFSET);
 	rdev->irq.stat_regs.evergreen.d2grph_int = RREG32(GRPH_INT_STATUS + EVERGREEN_CRTC1_REGISTER_OFFSET);
-	rdev->irq.stat_regs.evergreen.d3grph_int = RREG32(GRPH_INT_STATUS + EVERGREEN_CRTC2_REGISTER_OFFSET);
-	rdev->irq.stat_regs.evergreen.d4grph_int = RREG32(GRPH_INT_STATUS + EVERGREEN_CRTC3_REGISTER_OFFSET);
-	rdev->irq.stat_regs.evergreen.d5grph_int = RREG32(GRPH_INT_STATUS + EVERGREEN_CRTC4_REGISTER_OFFSET);
-	rdev->irq.stat_regs.evergreen.d6grph_int = RREG32(GRPH_INT_STATUS + EVERGREEN_CRTC5_REGISTER_OFFSET);
+	if (rdev->num_crtc >= 4) {
+		rdev->irq.stat_regs.evergreen.d3grph_int = RREG32(GRPH_INT_STATUS + EVERGREEN_CRTC2_REGISTER_OFFSET);
+		rdev->irq.stat_regs.evergreen.d4grph_int = RREG32(GRPH_INT_STATUS + EVERGREEN_CRTC3_REGISTER_OFFSET);
+	}
+	if (rdev->num_crtc >= 6) {
+		rdev->irq.stat_regs.evergreen.d5grph_int = RREG32(GRPH_INT_STATUS + EVERGREEN_CRTC4_REGISTER_OFFSET);
+		rdev->irq.stat_regs.evergreen.d6grph_int = RREG32(GRPH_INT_STATUS + EVERGREEN_CRTC5_REGISTER_OFFSET);
+	}
 
 	if (rdev->irq.stat_regs.evergreen.d1grph_int & GRPH_PFLIP_INT_OCCURRED)
 		WREG32(GRPH_INT_STATUS + EVERGREEN_CRTC0_REGISTER_OFFSET, GRPH_PFLIP_INT_CLEAR);
 	if (rdev->irq.stat_regs.evergreen.d2grph_int & GRPH_PFLIP_INT_OCCURRED)
 		WREG32(GRPH_INT_STATUS + EVERGREEN_CRTC1_REGISTER_OFFSET, GRPH_PFLIP_INT_CLEAR);
-	if (rdev->irq.stat_regs.evergreen.d3grph_int & GRPH_PFLIP_INT_OCCURRED)
-		WREG32(GRPH_INT_STATUS + EVERGREEN_CRTC2_REGISTER_OFFSET, GRPH_PFLIP_INT_CLEAR);
-	if (rdev->irq.stat_regs.evergreen.d4grph_int & GRPH_PFLIP_INT_OCCURRED)
-		WREG32(GRPH_INT_STATUS + EVERGREEN_CRTC3_REGISTER_OFFSET, GRPH_PFLIP_INT_CLEAR);
-	if (rdev->irq.stat_regs.evergreen.d5grph_int & GRPH_PFLIP_INT_OCCURRED)
-		WREG32(GRPH_INT_STATUS + EVERGREEN_CRTC4_REGISTER_OFFSET, GRPH_PFLIP_INT_CLEAR);
-	if (rdev->irq.stat_regs.evergreen.d6grph_int & GRPH_PFLIP_INT_OCCURRED)
-		WREG32(GRPH_INT_STATUS + EVERGREEN_CRTC5_REGISTER_OFFSET, GRPH_PFLIP_INT_CLEAR);
-
 	if (rdev->irq.stat_regs.evergreen.disp_int & LB_D1_VBLANK_INTERRUPT)
 		WREG32(VBLANK_STATUS + EVERGREEN_CRTC0_REGISTER_OFFSET, VBLANK_ACK);
 	if (rdev->irq.stat_regs.evergreen.disp_int & LB_D1_VLINE_INTERRUPT)
 		WREG32(VLINE_STATUS + EVERGREEN_CRTC0_REGISTER_OFFSET, VLINE_ACK);
-
 	if (rdev->irq.stat_regs.evergreen.disp_int_cont & LB_D2_VBLANK_INTERRUPT)
 		WREG32(VBLANK_STATUS + EVERGREEN_CRTC1_REGISTER_OFFSET, VBLANK_ACK);
 	if (rdev->irq.stat_regs.evergreen.disp_int_cont & LB_D2_VLINE_INTERRUPT)
 		WREG32(VLINE_STATUS + EVERGREEN_CRTC1_REGISTER_OFFSET, VLINE_ACK);
 
-	if (rdev->irq.stat_regs.evergreen.disp_int_cont2 & LB_D3_VBLANK_INTERRUPT)
-		WREG32(VBLANK_STATUS + EVERGREEN_CRTC2_REGISTER_OFFSET, VBLANK_ACK);
-	if (rdev->irq.stat_regs.evergreen.disp_int_cont2 & LB_D3_VLINE_INTERRUPT)
-		WREG32(VLINE_STATUS + EVERGREEN_CRTC2_REGISTER_OFFSET, VLINE_ACK);
-
-	if (rdev->irq.stat_regs.evergreen.disp_int_cont3 & LB_D4_VBLANK_INTERRUPT)
-		WREG32(VBLANK_STATUS + EVERGREEN_CRTC3_REGISTER_OFFSET, VBLANK_ACK);
-	if (rdev->irq.stat_regs.evergreen.disp_int_cont3 & LB_D4_VLINE_INTERRUPT)
-		WREG32(VLINE_STATUS + EVERGREEN_CRTC3_REGISTER_OFFSET, VLINE_ACK);
-
-	if (rdev->irq.stat_regs.evergreen.disp_int_cont4 & LB_D5_VBLANK_INTERRUPT)
-		WREG32(VBLANK_STATUS + EVERGREEN_CRTC4_REGISTER_OFFSET, VBLANK_ACK);
-	if (rdev->irq.stat_regs.evergreen.disp_int_cont4 & LB_D5_VLINE_INTERRUPT)
-		WREG32(VLINE_STATUS + EVERGREEN_CRTC4_REGISTER_OFFSET, VLINE_ACK);
-
-	if (rdev->irq.stat_regs.evergreen.disp_int_cont5 & LB_D6_VBLANK_INTERRUPT)
-		WREG32(VBLANK_STATUS + EVERGREEN_CRTC5_REGISTER_OFFSET, VBLANK_ACK);
-	if (rdev->irq.stat_regs.evergreen.disp_int_cont5 & LB_D6_VLINE_INTERRUPT)
-		WREG32(VLINE_STATUS + EVERGREEN_CRTC5_REGISTER_OFFSET, VLINE_ACK);
+	if (rdev->num_crtc >= 4) {
+		if (rdev->irq.stat_regs.evergreen.d3grph_int & GRPH_PFLIP_INT_OCCURRED)
+			WREG32(GRPH_INT_STATUS + EVERGREEN_CRTC2_REGISTER_OFFSET, GRPH_PFLIP_INT_CLEAR);
+		if (rdev->irq.stat_regs.evergreen.d4grph_int & GRPH_PFLIP_INT_OCCURRED)
+			WREG32(GRPH_INT_STATUS + EVERGREEN_CRTC3_REGISTER_OFFSET, GRPH_PFLIP_INT_CLEAR);
+		if (rdev->irq.stat_regs.evergreen.disp_int_cont2 & LB_D3_VBLANK_INTERRUPT)
+			WREG32(VBLANK_STATUS + EVERGREEN_CRTC2_REGISTER_OFFSET, VBLANK_ACK);
+		if (rdev->irq.stat_regs.evergreen.disp_int_cont2 & LB_D3_VLINE_INTERRUPT)
+			WREG32(VLINE_STATUS + EVERGREEN_CRTC2_REGISTER_OFFSET, VLINE_ACK);
+		if (rdev->irq.stat_regs.evergreen.disp_int_cont3 & LB_D4_VBLANK_INTERRUPT)
+			WREG32(VBLANK_STATUS + EVERGREEN_CRTC3_REGISTER_OFFSET, VBLANK_ACK);
+		if (rdev->irq.stat_regs.evergreen.disp_int_cont3 & LB_D4_VLINE_INTERRUPT)
+			WREG32(VLINE_STATUS + EVERGREEN_CRTC3_REGISTER_OFFSET, VLINE_ACK);
+	}
+
+	if (rdev->num_crtc >= 6) {
+		if (rdev->irq.stat_regs.evergreen.d5grph_int & GRPH_PFLIP_INT_OCCURRED)
+			WREG32(GRPH_INT_STATUS + EVERGREEN_CRTC4_REGISTER_OFFSET, GRPH_PFLIP_INT_CLEAR);
+		if (rdev->irq.stat_regs.evergreen.d6grph_int & GRPH_PFLIP_INT_OCCURRED)
+			WREG32(GRPH_INT_STATUS + EVERGREEN_CRTC5_REGISTER_OFFSET, GRPH_PFLIP_INT_CLEAR);
+		if (rdev->irq.stat_regs.evergreen.disp_int_cont4 & LB_D5_VBLANK_INTERRUPT)
+			WREG32(VBLANK_STATUS + EVERGREEN_CRTC4_REGISTER_OFFSET, VBLANK_ACK);
+		if (rdev->irq.stat_regs.evergreen.disp_int_cont4 & LB_D5_VLINE_INTERRUPT)
+			WREG32(VLINE_STATUS + EVERGREEN_CRTC4_REGISTER_OFFSET, VLINE_ACK);
+		if (rdev->irq.stat_regs.evergreen.disp_int_cont5 & LB_D6_VBLANK_INTERRUPT)
+			WREG32(VBLANK_STATUS + EVERGREEN_CRTC5_REGISTER_OFFSET, VBLANK_ACK);
+		if (rdev->irq.stat_regs.evergreen.disp_int_cont5 & LB_D6_VLINE_INTERRUPT)
+			WREG32(VLINE_STATUS + EVERGREEN_CRTC5_REGISTER_OFFSET, VLINE_ACK);
+	}
 
 	if (rdev->irq.stat_regs.evergreen.disp_int & DC_HPD1_INTERRUPT) {
 		tmp = RREG32(DC_HPD1_INT_CONTROL);


