Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab2CVMtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 08:49:25 -0400
Received: from fw.wantstofly.org ([80.101.37.227]:61836 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab2CVMtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 08:49:24 -0400
Date: Thu, 22 Mar 2012 13:49:19 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: alexander.deucher@amd.com
Subject: radeon + DVI->mDP converter + mDP display blank screen issue since
 3.0
Message-ID: <20120322124919.GG28523@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Since Linux 3.0, a system with a Radeon HD 5450 (1002:68f9) connected
to a 27" Apple LED cinema display via an Atlona AT-DP400 Dual Link DVI
to Mini DisplayPort converter has started to stop giving screen
output on switching from text mode to graphical framebuffer during
system startup.

I finally had some time to look at this, and it seems to have stopped
working after this commit:

	commit df271bec805b42527d864777ed035fcbb42e76c0
	Author: Alex Deucher <alexdeucher@gmail.com>
	Date:   Fri May 20 04:34:15 2011 -0400

	    drm/radeon/kms: properly handle bpc >8 in atom command tables
	    
	    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
	    Signed-off-by: Dave Airlie <airlied@redhat.com>

...and with the patch below (i.e. reverting part of the commit above)
applied to 3.3 I get screen output again.

Even though the monitor seems to have an 8 bit panel, it reports 10
bits per channel in its EDID:

	[...]
	Manufacturer: APP Model 9226 Serial Number 41959462
	Made week 38 of 2010
	EDID version: 1.4
	Digital display
	10 bits per primary color channel
	DisplayPort interface
	Maximum image size: 60 cm x 34 cm
	[...]

The (active, dual link) DVI->mDP converter spec sheet says it supports
24 bit color, and I'm guessing that it can't deal with 30.  Is the
converter at fault here for passing through the EDID unchanged?

Also, what would be the right way to handle this, a kernel command
line or module option to limit color depth or something like that?
("Buy a video card with DP output." is a valid answer, I suppose.)

I have no clue at all about graphics, and I have no idea whatsoever
what I'm doing here, but I just wanted to post this somewhere for
Google to find in case someone else runs into this!


thanks,
Lennert



diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index 742f17f..77a6a04 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -513,11 +513,9 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc,
 	struct radeon_device *rdev = dev->dev_private;
 	struct drm_encoder *encoder = NULL;
 	struct radeon_encoder *radeon_encoder = NULL;
-	struct drm_connector *connector = NULL;
 	u32 adjusted_clock = mode->clock;
 	int encoder_mode = 0;
 	u32 dp_clock = mode->clock;
-	int bpc = 8;
 	bool is_duallink = false;
 
 	/* reset the pll flags */
@@ -549,13 +547,11 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc,
 	list_for_each_entry(encoder, &dev->mode_config.encoder_list, head) {
 		if (encoder->crtc == crtc) {
 			radeon_encoder = to_radeon_encoder(encoder);
-			connector = radeon_get_connector_for_encoder(encoder);
-			if (connector && connector->display_info.bpc)
-				bpc = connector->display_info.bpc;
 			encoder_mode = atombios_get_encoder_mode(encoder);
 			is_duallink = radeon_dig_monitor_is_duallink(encoder, mode->clock);
 			if ((radeon_encoder->devices & (ATOM_DEVICE_LCD_SUPPORT | ATOM_DEVICE_DFP_SUPPORT)) ||
 			    (radeon_encoder_get_dp_bridge_encoder_id(encoder) != ENCODER_OBJECT_ID_NONE)) {
+				struct drm_connector *connector = radeon_get_connector_for_encoder(encoder);
 				if (connector) {
 					struct radeon_connector *radeon_connector = to_radeon_connector(connector);
 					struct radeon_connector_atom_dig *dig_connector =
@@ -645,7 +641,7 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc,
 					if (encoder_mode == ATOM_ENCODER_MODE_HDMI)
 						/* deep color support */
 						args.v3.sInput.usPixelClock =
-							cpu_to_le16((mode->clock * bpc / 8) / 10);
+							cpu_to_le16(mode->clock / 10);
 					if (dig->coherent_mode)
 						args.v3.sInput.ucDispPllConfig |=
 							DISPPLL_CONFIG_COHERENT_MODE;
@@ -753,7 +749,6 @@ static void atombios_crtc_program_pll(struct drm_crtc *crtc,
 				      u32 fb_div,
 				      u32 frac_fb_div,
 				      u32 post_div,
-				      int bpc,
 				      bool ss_enabled,
 				      struct radeon_atom_ss *ss)
 {
@@ -817,15 +812,6 @@ static void atombios_crtc_program_pll(struct drm_crtc *crtc,
 			args.v5.ucMiscInfo = 0; /* HDMI depth, etc. */
 			if (ss_enabled && (ss->type & ATOM_EXTERNAL_SS_MASK))
 				args.v5.ucMiscInfo |= PIXEL_CLOCK_V5_MISC_REF_DIV_SRC;
-			switch (bpc) {
-			case 8:
-			default:
-				args.v5.ucMiscInfo |= PIXEL_CLOCK_V5_MISC_HDMI_24BPP;
-				break;
-			case 10:
-				args.v5.ucMiscInfo |= PIXEL_CLOCK_V5_MISC_HDMI_30BPP;
-				break;
-			}
 			args.v5.ucTransmitterID = encoder_id;
 			args.v5.ucEncoderMode = encoder_mode;
 			args.v5.ucPpll = pll_id;
@@ -839,21 +825,6 @@ static void atombios_crtc_program_pll(struct drm_crtc *crtc,
 			args.v6.ucMiscInfo = 0; /* HDMI depth, etc. */
 			if (ss_enabled && (ss->type & ATOM_EXTERNAL_SS_MASK))
 				args.v6.ucMiscInfo |= PIXEL_CLOCK_V6_MISC_REF_DIV_SRC;
-			switch (bpc) {
-			case 8:
-			default:
-				args.v6.ucMiscInfo |= PIXEL_CLOCK_V6_MISC_HDMI_24BPP;
-				break;
-			case 10:
-				args.v6.ucMiscInfo |= PIXEL_CLOCK_V6_MISC_HDMI_30BPP;
-				break;
-			case 12:
-				args.v6.ucMiscInfo |= PIXEL_CLOCK_V6_MISC_HDMI_36BPP;
-				break;
-			case 16:
-				args.v6.ucMiscInfo |= PIXEL_CLOCK_V6_MISC_HDMI_48BPP;
-				break;
-			}
 			args.v6.ucTransmitterID = encoder_id;
 			args.v6.ucEncoderMode = encoder_mode;
 			args.v6.ucPpll = pll_id;
@@ -885,7 +856,6 @@ static void atombios_crtc_set_pll(struct drm_crtc *crtc, struct drm_display_mode
 	int encoder_mode = 0;
 	struct radeon_atom_ss ss;
 	bool ss_enabled = false;
-	int bpc = 8;
 
 	list_for_each_entry(encoder, &dev->mode_config.encoder_list, head) {
 		if (encoder->crtc == crtc) {
@@ -922,7 +892,6 @@ static void atombios_crtc_set_pll(struct drm_crtc *crtc, struct drm_display_mode
 		struct radeon_connector_atom_dig *dig_connector =
 			radeon_connector->con_priv;
 		int dp_clock;
-		bpc = connector->display_info.bpc;
 
 		switch (encoder_mode) {
 		case ATOM_ENCODER_MODE_DP_MST:
@@ -995,7 +964,7 @@ static void atombios_crtc_set_pll(struct drm_crtc *crtc, struct drm_display_mode
 
 	atombios_crtc_program_pll(crtc, radeon_crtc->crtc_id, radeon_crtc->pll_id,
 				  encoder_mode, radeon_encoder->encoder_id, mode->clock,
-				  ref_div, fb_div, frac_fb_div, post_div, bpc, ss_enabled, &ss);
+				  ref_div, fb_div, frac_fb_div, post_div, ss_enabled, &ss);
 
 	if (ss_enabled) {
 		/* calculate ss amount and step size */
@@ -1587,7 +1556,7 @@ static void atombios_crtc_disable(struct drm_crtc *crtc)
 	case ATOM_PPLL2:
 		/* disable the ppll */
 		atombios_crtc_program_pll(crtc, radeon_crtc->crtc_id, radeon_crtc->pll_id,
-					  0, 0, ATOM_DISABLE, 0, 0, 0, 0, 0, false, &ss);
+					  0, 0, ATOM_DISABLE, 0, 0, 0, 0, false, &ss);
 		break;
 	default:
 		break;
