Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030409Ab2I1TDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:03:04 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030396Ab2I1TC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:02:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 181/262] drm/radeon: avoid turning off spread spectrum for used pll
Date: Fri, 28 Sep 2012 11:51:50 -0700
Message-Id: <20120928183019.451737426@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 5efcc76c13a745f98e7b6604d6aca49761be1970 upstream.

If spread spectrum is enabled and in use for a given pll we
should not turn it off as it will lead to turning off display
for crtc that use the pll (this behavior was observed on chelsea
edp).

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -444,11 +444,28 @@ union atom_enable_ss {
 static void atombios_crtc_program_ss(struct radeon_device *rdev,
 				     int enable,
 				     int pll_id,
+				     int crtc_id,
 				     struct radeon_atom_ss *ss)
 {
+	unsigned i;
 	int index = GetIndexIntoMasterTable(COMMAND, EnableSpreadSpectrumOnPPLL);
 	union atom_enable_ss args;
 
+	if (!enable) {
+		for (i = 0; i < 6; i++) {
+			if (rdev->mode_info.crtcs[i] &&
+			    rdev->mode_info.crtcs[i]->enabled &&
+			    i != crtc_id &&
+			    pll_id == rdev->mode_info.crtcs[i]->pll_id) {
+				/* one other crtc is using this pll don't turn
+				 * off spread spectrum as it might turn off
+				 * display on active crtc
+				 */
+				return;
+			}
+		}
+	}
+
 	memset(&args, 0, sizeof(args));
 
 	if (ASIC_IS_DCE5(rdev)) {
@@ -1036,7 +1053,7 @@ static void atombios_crtc_set_pll(struct
 		radeon_compute_pll_legacy(pll, adjusted_clock, &pll_clock, &fb_div, &frac_fb_div,
 					  &ref_div, &post_div);
 
-	atombios_crtc_program_ss(rdev, ATOM_DISABLE, radeon_crtc->pll_id, &ss);
+	atombios_crtc_program_ss(rdev, ATOM_DISABLE, radeon_crtc->pll_id, radeon_crtc->crtc_id, &ss);
 
 	atombios_crtc_program_pll(crtc, radeon_crtc->crtc_id, radeon_crtc->pll_id,
 				  encoder_mode, radeon_encoder->encoder_id, mode->clock,
@@ -1059,7 +1076,7 @@ static void atombios_crtc_set_pll(struct
 			ss.step = step_size;
 		}
 
-		atombios_crtc_program_ss(rdev, ATOM_ENABLE, radeon_crtc->pll_id, &ss);
+		atombios_crtc_program_ss(rdev, ATOM_ENABLE, radeon_crtc->pll_id, radeon_crtc->crtc_id, &ss);
 	}
 }
 
@@ -1576,11 +1593,11 @@ void radeon_atom_disp_eng_pll_init(struc
 								   ASIC_INTERNAL_SS_ON_DCPLL,
 								   rdev->clock.default_dispclk);
 		if (ss_enabled)
-			atombios_crtc_program_ss(rdev, ATOM_DISABLE, ATOM_DCPLL, &ss);
+			atombios_crtc_program_ss(rdev, ATOM_DISABLE, ATOM_DCPLL, -1, &ss);
 		/* XXX: DCE5, make sure voltage, dispclk is high enough */
 		atombios_crtc_set_disp_eng_pll(rdev, rdev->clock.default_dispclk);
 		if (ss_enabled)
-			atombios_crtc_program_ss(rdev, ATOM_ENABLE, ATOM_DCPLL, &ss);
+			atombios_crtc_program_ss(rdev, ATOM_ENABLE, ATOM_DCPLL, -1, &ss);
 	}
 
 }


