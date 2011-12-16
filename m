Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865Ab1LPTwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:52:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964791Ab1LPTvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:51:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:46:00 2011
Message-Id: <20111216194600.045364835@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [37/53] drm/radeon/kms: cleanup atombios_adjust_pll()
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b4f15f808b9a79b6ad9032fa5f6d8b88e1e1bf11 upstream.

The logic was messy and hard to follow.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |   41 ++++++++++-----------------------
 1 file changed, 13 insertions(+), 28 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -638,38 +638,23 @@ static u32 atombios_adjust_pll(struct dr
 				if (ss_enabled && ss->percentage)
 					args.v3.sInput.ucDispPllConfig |=
 						DISPPLL_CONFIG_SS_ENABLE;
-				if (radeon_encoder->devices & (ATOM_DEVICE_DFP_SUPPORT) ||
-				    radeon_encoder_is_dp_bridge(encoder)) {
+				if (encoder_mode == ATOM_ENCODER_MODE_DP) {
+					args.v3.sInput.ucDispPllConfig |=
+						DISPPLL_CONFIG_COHERENT_MODE;
+					/* 16200 or 27000 */
+					args.v3.sInput.usPixelClock = cpu_to_le16(dp_clock / 10);
+				} else if (radeon_encoder->devices & (ATOM_DEVICE_DFP_SUPPORT)) {
 					struct radeon_encoder_atom_dig *dig = radeon_encoder->enc_priv;
-					if (encoder_mode == ATOM_ENCODER_MODE_DP) {
+					if (encoder_mode == ATOM_ENCODER_MODE_HDMI)
+						/* deep color support */
+						args.v3.sInput.usPixelClock =
+							cpu_to_le16((mode->clock * bpc / 8) / 10);
+					if (dig->coherent_mode)
 						args.v3.sInput.ucDispPllConfig |=
 							DISPPLL_CONFIG_COHERENT_MODE;
-						/* 16200 or 27000 */
-						args.v3.sInput.usPixelClock = cpu_to_le16(dp_clock / 10);
-					} else {
-						if (encoder_mode == ATOM_ENCODER_MODE_HDMI) {
-							/* deep color support */
-							args.v3.sInput.usPixelClock =
-								cpu_to_le16((mode->clock * bpc / 8) / 10);
-						}
-						if (dig->coherent_mode)
-							args.v3.sInput.ucDispPllConfig |=
-								DISPPLL_CONFIG_COHERENT_MODE;
-						if (mode->clock > 165000)
-							args.v3.sInput.ucDispPllConfig |=
-								DISPPLL_CONFIG_DUAL_LINK;
-					}
-				} else if (radeon_encoder->devices & (ATOM_DEVICE_LCD_SUPPORT)) {
-					if (encoder_mode == ATOM_ENCODER_MODE_DP) {
+					if (mode->clock > 165000)
 						args.v3.sInput.ucDispPllConfig |=
-							DISPPLL_CONFIG_COHERENT_MODE;
-						/* 16200 or 27000 */
-						args.v3.sInput.usPixelClock = cpu_to_le16(dp_clock / 10);
-					} else if (encoder_mode != ATOM_ENCODER_MODE_LVDS) {
-						if (mode->clock > 165000)
-							args.v3.sInput.ucDispPllConfig |=
-								DISPPLL_CONFIG_DUAL_LINK;
-					}
+							DISPPLL_CONFIG_DUAL_LINK;
 				}
 				if (radeon_encoder_is_dp_bridge(encoder)) {
 					struct drm_encoder *ext_encoder = radeon_atom_get_external_encoder(encoder);


