Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965495Ab2I1TWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:22:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030538Ab2I1TEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:04:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>
Subject: =?UTF-8?q?=5B=20200/262=5D=20drm/radeon=3A=20dont=20disable=20plls=20that=20are=20in=20use=20by=20other=20crtcs?=
Date: Fri, 28 Sep 2012 11:52:09 -0700
Message-Id: <20120928183021.704790093@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4e58591c8961b3e31709313f75819f2eec06e322 upstream.

Some plls are shared for DP.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1668,9 +1668,22 @@ static void atombios_crtc_disable(struct
 	struct drm_device *dev = crtc->dev;
 	struct radeon_device *rdev = dev->dev_private;
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
@@ -1687,6 +1700,7 @@ static void atombios_crtc_disable(struct
 	default:
 		break;
 	}
+done:
 	radeon_crtc->pll_id = -1;
 }
 


