Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab1AFAg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:36:57 -0500
Received: from kroah.org ([198.145.64.141]:36066 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706Ab1AFAbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:37 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:09 2011
Message-Id: <20110106002308.971118368@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [130/152] drm/radeon/kms: reorder display resume to avoid problems
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit a93f344d3c04e4b84490c65f2a574387c593be40 upstream.

On resume, we were attemping to unblank the displays before the
timing and plls had be reprogrammed which led to atom timeouts
waiting for things that are not yet programmed.  Re-program
the mode first, then reset the dpms state.

This fixes the infamous atombios timeouts on resume.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    3 ++-
 drivers/gpu/drm/radeon/radeon_device.c |    9 ++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -253,7 +253,8 @@ void atombios_crtc_dpms(struct drm_crtc
 	case DRM_MODE_DPMS_SUSPEND:
 	case DRM_MODE_DPMS_OFF:
 		drm_vblank_pre_modeset(dev, radeon_crtc->crtc_id);
-		atombios_blank_crtc(crtc, ATOM_ENABLE);
+		if (radeon_crtc->enabled)
+			atombios_blank_crtc(crtc, ATOM_ENABLE);
 		if (ASIC_IS_DCE3(rdev))
 			atombios_enable_crtc_memreq(crtc, ATOM_DISABLE);
 		atombios_enable_crtc(crtc, ATOM_DISABLE);
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -829,11 +829,6 @@ int radeon_resume_kms(struct drm_device
 	radeon_pm_resume(rdev);
 	radeon_restore_bios_scratch_regs(rdev);
 
-	/* turn on display hw */
-	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
-		drm_helper_connector_dpms(connector, DRM_MODE_DPMS_ON);
-	}
-
 	radeon_fbdev_set_suspend(rdev, 0);
 	release_console_sem();
 
@@ -841,6 +836,10 @@ int radeon_resume_kms(struct drm_device
 	radeon_hpd_init(rdev);
 	/* blat the mode back in */
 	drm_helper_resume_force_mode(dev);
+	/* turn on display hw */
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		drm_helper_connector_dpms(connector, DRM_MODE_DPMS_ON);
+	}
 	return 0;
 }
 


