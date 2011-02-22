Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1BVWf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:35:56 -0500
Received: from kroah.org ([198.145.64.141]:46586 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab1BVWVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:38 2011
Message-Id: <20110222221838.074402339@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:16:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [10/70] drm/radeon/kms: hopefully fix pll issues for real (v3)
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 5b40ddf888398ce4cccbf3b9d0a18d90149ed7ff upstream.

The problematic boards have a recommended reference divider
to be used when spread spectrum is enabled on the laptop panel.
Enable the use of the recommended reference divider along with
the new pll algo.

v2: testing options

v3: When using the fixed reference divider with LVDS, prefer
min m to max p and use fractional feedback dividers.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=28852
https://bugzilla.kernel.org/show_bug.cgi?id=24462
https://bugzilla.kernel.org/show_bug.cgi?id=26552
MacbookPro issues reported by Justin Mattock <justinmattock@gmail.com>

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -514,7 +514,6 @@ static u32 atombios_adjust_pll(struct dr
 			pll->flags |= RADEON_PLL_PREFER_HIGH_FB_DIV;
 		else
 			pll->flags |= RADEON_PLL_PREFER_LOW_REF_DIV;
-
 	}
 
 	list_for_each_entry(encoder, &dev->mode_config.encoder_list, head) {
@@ -531,29 +530,28 @@ static u32 atombios_adjust_pll(struct dr
 					dp_clock = dig_connector->dp_clock;
 				}
 			}
-/* this might work properly with the new pll algo */
-#if 0 /* doesn't work properly on some laptops */
+
 			/* use recommended ref_div for ss */
 			if (radeon_encoder->devices & (ATOM_DEVICE_LCD_SUPPORT)) {
+				pll->flags |= RADEON_PLL_PREFER_MINM_OVER_MAXP;
 				if (ss_enabled) {
 					if (ss->refdiv) {
 						pll->flags |= RADEON_PLL_USE_REF_DIV;
 						pll->reference_div = ss->refdiv;
+						if (ASIC_IS_AVIVO(rdev))
+							pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
 					}
 				}
 			}
-#endif
+
 			if (ASIC_IS_AVIVO(rdev)) {
 				/* DVO wants 2x pixel clock if the DVO chip is in 12 bit mode */
 				if (radeon_encoder->encoder_id == ENCODER_OBJECT_ID_INTERNAL_KLDSCP_DVO1)
 					adjusted_clock = mode->clock * 2;
 				if (radeon_encoder->active_device & (ATOM_DEVICE_TV_SUPPORT))
 					pll->flags |= RADEON_PLL_PREFER_CLOSEST_LOWER;
-				/* rv515 needs more testing with this option */
-				if (rdev->family != CHIP_RV515) {
-					if (radeon_encoder->devices & (ATOM_DEVICE_LCD_SUPPORT))
-						pll->flags |= RADEON_PLL_IS_LCD;
-				}
+				if (radeon_encoder->devices & (ATOM_DEVICE_LCD_SUPPORT))
+					pll->flags |= RADEON_PLL_IS_LCD;
 			} else {
 				if (encoder->encoder_type != DRM_MODE_ENCODER_DAC)
 					pll->flags |= RADEON_PLL_NO_ODD_POST_DIV;
@@ -921,11 +919,7 @@ static void atombios_crtc_set_pll(struct
 	/* adjust pixel clock as needed */
 	adjusted_clock = atombios_adjust_pll(crtc, mode, pll, ss_enabled, &ss);
 
-	/* rv515 seems happier with the old algo */
-	if (rdev->family == CHIP_RV515)
-		radeon_compute_pll_legacy(pll, adjusted_clock, &pll_clock, &fb_div, &frac_fb_div,
-					  &ref_div, &post_div);
-	else if (ASIC_IS_AVIVO(rdev))
+	if (ASIC_IS_AVIVO(rdev))
 		radeon_compute_pll_avivo(pll, adjusted_clock, &pll_clock, &fb_div, &frac_fb_div,
 					 &ref_div, &post_div);
 	else


