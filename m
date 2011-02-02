Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab1BBAtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:49:46 -0500
Received: from mga14.intel.com ([143.182.124.37]:3685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab1BBApL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960976"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: alexdeucher@gmail.com, airlied@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [122/139] drm/radeon/kms: reorder display resume to avoid problems
Message-Id: <20110202004521.70CFA3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    3 ++-
 drivers/gpu/drm/radeon/radeon_device.c |    9 ++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6.35.y/drivers/gpu/drm/radeon/atombios_crtc.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/radeon/atombios_crtc.c
+++ linux-2.6.35.y/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -259,7 +259,8 @@ void atombios_crtc_dpms(struct drm_crtc 
 	case DRM_MODE_DPMS_SUSPEND:
 	case DRM_MODE_DPMS_OFF:
 		drm_vblank_pre_modeset(dev, radeon_crtc->crtc_id);
-		atombios_blank_crtc(crtc, ATOM_ENABLE);
+		if (radeon_crtc->enabled)
+			atombios_blank_crtc(crtc, ATOM_ENABLE);
 		if (ASIC_IS_DCE3(rdev))
 			atombios_enable_crtc_memreq(crtc, ATOM_DISABLE);
 		atombios_enable_crtc(crtc, ATOM_DISABLE);
Index: linux-2.6.35.y/drivers/gpu/drm/radeon/radeon_device.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/radeon/radeon_device.c
+++ linux-2.6.35.y/drivers/gpu/drm/radeon/radeon_device.c
@@ -799,11 +799,6 @@ int radeon_resume_kms(struct drm_device 
 	radeon_pm_resume(rdev);
 	radeon_restore_bios_scratch_regs(rdev);
 
-	/* turn on display hw */
-	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
-		drm_helper_connector_dpms(connector, DRM_MODE_DPMS_ON);
-	}
-
 	radeon_fbdev_set_suspend(rdev, 0);
 	release_console_sem();
 
@@ -811,6 +806,10 @@ int radeon_resume_kms(struct drm_device 
 	radeon_hpd_init(rdev);
 	/* blat the mode back in */
 	drm_helper_resume_force_mode(dev);
+	/* turn on display hw */
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		drm_helper_connector_dpms(connector, DRM_MODE_DPMS_ON);
+	}
 	return 0;
 }
 
