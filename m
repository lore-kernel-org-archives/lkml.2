Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab2IQAwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:52:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34003 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754857Ab2IQAvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:41 -0400
Message-Id: <20120917003629.437073607@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        =?ISO-8859-15?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>
Subject: [ 023/135] drm/radeon: dont disable plls that are in use by other crtcs
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4e58591c8961b3e31709313f75819f2eec06e322 upstream.

Some plls are shared for DP.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
[bwh: Backported to 3.2: add the dev and rdev variables, previously added
 upstream to support DCE6.1 which isn't supported in this version]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1578,10 +1578,25 @@ static void atombios_crtc_commit(struct
 static void atombios_crtc_disable(struct drm_crtc *crtc)
 {
 	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
+	struct drm_device *dev = crtc->dev;
+	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_atom_ss ss;
+	int i;
 
 	atombios_crtc_dpms(crtc, DRM_MODE_DPMS_OFF);
 
+	for (i = 0; i < rdev->num_crtc; i++) {
+		if (rdev->mode_info.crtcs[i] &&
+		    rdev->mode_info.crtcs[i]->enabled &&
+		    i != radeon_crtc->crtc_id &&
+		    radeon_crtc->pll_id == rdev->mode_info.crtcs[i]->pll_id) {
+			/* one other crtc is using this pll don't turn
+			 * off the pll
+			 */
+			goto done;
+		}
+	}
+
 	switch (radeon_crtc->pll_id) {
 	case ATOM_PPLL1:
 	case ATOM_PPLL2:
@@ -1592,6 +1607,7 @@ static void atombios_crtc_disable(struct
 	default:
 		break;
 	}
+done:
 	radeon_crtc->pll_id = -1;
 }
 


