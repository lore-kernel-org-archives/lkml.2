Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab1BPAZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:25:18 -0500
Received: from kroah.org ([198.145.64.141]:49853 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757658Ab1BPAZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:25:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:50 2011
Message-Id: <20110216001450.091942368@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:15:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [250/272] drm/radeon/kms: Enable new pll calculation for avivo+ asics
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 619efb105924d8cafa0c1dd9389e9ab506f5425d upstream.

New algo is used for r5xx+ and legacy is used for
r1xx-r4xx, rv515.

I've tested on all relevant GPUs and monitors that I
have access to and have found no problems.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=26562
https://bugzilla.kernel.org/show_bug.cgi?id=26552
May fix:
https://bugs.freedesktop.org/show_bug.cgi?id=32556

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_crtc.c   |   18 ++++++++++++++++--
 drivers/gpu/drm/radeon/radeon_atombios.c |   10 ----------
 drivers/gpu/drm/radeon/radeon_display.c  |    3 +++
 3 files changed, 19 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -531,6 +531,7 @@ static u32 atombios_adjust_pll(struct dr
 					dp_clock = dig_connector->dp_clock;
 				}
 			}
+/* this might work properly with the new pll algo */
 #if 0 /* doesn't work properly on some laptops */
 			/* use recommended ref_div for ss */
 			if (radeon_encoder->devices & (ATOM_DEVICE_LCD_SUPPORT)) {
@@ -548,6 +549,11 @@ static u32 atombios_adjust_pll(struct dr
 					adjusted_clock = mode->clock * 2;
 				if (radeon_encoder->active_device & (ATOM_DEVICE_TV_SUPPORT))
 					pll->flags |= RADEON_PLL_PREFER_CLOSEST_LOWER;
+				/* rv515 needs more testing with this option */
+				if (rdev->family != CHIP_RV515) {
+					if (radeon_encoder->devices & (ATOM_DEVICE_LCD_SUPPORT))
+						pll->flags |= RADEON_PLL_IS_LCD;
+				}
 			} else {
 				if (encoder->encoder_type != DRM_MODE_ENCODER_DAC)
 					pll->flags |= RADEON_PLL_NO_ODD_POST_DIV;
@@ -915,8 +921,16 @@ static void atombios_crtc_set_pll(struct
 	/* adjust pixel clock as needed */
 	adjusted_clock = atombios_adjust_pll(crtc, mode, pll, ss_enabled, &ss);
 
-	radeon_compute_pll_legacy(pll, adjusted_clock, &pll_clock, &fb_div, &frac_fb_div,
-				  &ref_div, &post_div);
+	/* rv515 seems happier with the old algo */
+	if (rdev->family == CHIP_RV515)
+		radeon_compute_pll_legacy(pll, adjusted_clock, &pll_clock, &fb_div, &frac_fb_div,
+					  &ref_div, &post_div);
+	else if (ASIC_IS_AVIVO(rdev))
+		radeon_compute_pll_avivo(pll, adjusted_clock, &pll_clock, &fb_div, &frac_fb_div,
+					 &ref_div, &post_div);
+	else
+		radeon_compute_pll_legacy(pll, adjusted_clock, &pll_clock, &fb_div, &frac_fb_div,
+					  &ref_div, &post_div);
 
 	atombios_crtc_program_ss(crtc, ATOM_DISABLE, radeon_crtc->pll_id, &ss);
 
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1136,16 +1136,6 @@ bool radeon_atom_get_clock_info(struct d
 				p1pll->pll_out_min = 64800;
 			else
 				p1pll->pll_out_min = 20000;
-		} else if (p1pll->pll_out_min > 64800) {
-			/* Limiting the pll output range is a good thing generally as
-			 * it limits the number of possible pll combinations for a given
-			 * frequency presumably to the ones that work best on each card.
-			 * However, certain duallink DVI monitors seem to like
-			 * pll combinations that would be limited by this at least on
-			 * pre-DCE 3.0 r6xx hardware.  This might need to be adjusted per
-			 * family.
-			 */
-			p1pll->pll_out_min = 64800;
 		}
 
 		p1pll->pll_in_min =
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -603,6 +603,9 @@ void radeon_compute_pll_legacy(struct ra
 		pll_out_max = pll->pll_out_max;
 	}
 
+	if (pll_out_min > 64800)
+		pll_out_min = 64800;
+
 	if (pll->flags & RADEON_PLL_USE_REF_DIV)
 		min_ref_div = max_ref_div = pll->reference_div;
 	else {


