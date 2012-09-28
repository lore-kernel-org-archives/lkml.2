Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030536Ab2I1TD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:03:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030513Ab2I1TDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:03:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 197/262] drm/radeon/atom: powergating fixes for DCE6
Date: Fri, 28 Sep 2012 11:52:06 -0700
Message-Id: <20120928183021.343754072@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit c205b232a64fed6d26edd7e40985b396de99a27f upstream.

Power gating is per crtc pair, but the powergating registers
should be called individually.  The hw handles power up/down
properly.  The pair is powered up if either crtc in the pair
is powered up and the pair is not powered down until both
crtcs in the pair are powered down.  This simplifies
programming and should save additional power as the previous
code never actually power gated the crtc pair.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |   22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -258,7 +258,6 @@ void atombios_crtc_dpms(struct drm_crtc
 		radeon_crtc->enabled = true;
 		/* adjust pm to dpms changes BEFORE enabling crtcs */
 		radeon_pm_compute_clocks(rdev);
-		/* disable crtc pair power gating before programming */
 		if (ASIC_IS_DCE6(rdev) && !radeon_crtc->in_mode_set)
 			atombios_powergate_crtc(crtc, ATOM_DISABLE);
 		atombios_enable_crtc(crtc, ATOM_ENABLE);
@@ -278,25 +277,8 @@ void atombios_crtc_dpms(struct drm_crtc
 			atombios_enable_crtc_memreq(crtc, ATOM_DISABLE);
 		atombios_enable_crtc(crtc, ATOM_DISABLE);
 		radeon_crtc->enabled = false;
-		/* power gating is per-pair */
-		if (ASIC_IS_DCE6(rdev) && !radeon_crtc->in_mode_set) {
-			struct drm_crtc *other_crtc;
-			struct radeon_crtc *other_radeon_crtc;
-			list_for_each_entry(other_crtc, &rdev->ddev->mode_config.crtc_list, head) {
-				other_radeon_crtc = to_radeon_crtc(other_crtc);
-				if (((radeon_crtc->crtc_id == 0) && (other_radeon_crtc->crtc_id == 1)) ||
-				    ((radeon_crtc->crtc_id == 1) && (other_radeon_crtc->crtc_id == 0)) ||
-				    ((radeon_crtc->crtc_id == 2) && (other_radeon_crtc->crtc_id == 3)) ||
-				    ((radeon_crtc->crtc_id == 3) && (other_radeon_crtc->crtc_id == 2)) ||
-				    ((radeon_crtc->crtc_id == 4) && (other_radeon_crtc->crtc_id == 5)) ||
-				    ((radeon_crtc->crtc_id == 5) && (other_radeon_crtc->crtc_id == 4))) {
-					/* if both crtcs in the pair are off, enable power gating */
-					if (other_radeon_crtc->enabled == false)
-						atombios_powergate_crtc(crtc, ATOM_ENABLE);
-					break;
-				}
-			}
-		}
+		if (ASIC_IS_DCE6(rdev) && !radeon_crtc->in_mode_set)
+			atombios_powergate_crtc(crtc, ATOM_ENABLE);
 		/* adjust pm to dpms changes AFTER disabling crtcs */
 		radeon_pm_compute_clocks(rdev);
 		break;


