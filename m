Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab2LMOGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:06:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44388 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561Ab2LMOGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:06:17 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 089/241] drm/i915/sdvo: clean up connectors on intel_sdvo_init() failures
Date: Thu, 13 Dec 2012 11:57:34 -0200
Message-Id: <1355407206-17100-90-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit d0ddfbd3d1346c1f481ec2289eef350cdba64b42 upstream.

Any failures in intel_sdvo_init() after the intel_sdvo_setup_output() call
left behind ghost connectors, attached (with a dangling pointer) to the
sdvo that has been cleaned up and freed. Properly destroy any connectors
attached to the encoder.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=46381
CC: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Tested-by: bjo@nord-west.org
[danvet: added a comment to explain why we need to clean up connectors
even when sdvo_output_setup fails.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/intel_sdvo.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 9bb8168..1af5db5 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -2278,6 +2278,18 @@ intel_sdvo_output_setup(struct intel_sdvo *intel_sdvo, uint16_t flags)
 	return true;
 }
 
+static void intel_sdvo_output_cleanup(struct intel_sdvo *intel_sdvo)
+{
+	struct drm_device *dev = intel_sdvo->base.base.dev;
+	struct drm_connector *connector, *tmp;
+
+	list_for_each_entry_safe(connector, tmp,
+				 &dev->mode_config.connector_list, head) {
+		if (intel_attached_encoder(connector) == &intel_sdvo->base)
+			intel_sdvo_destroy(connector);
+	}
+}
+
 static bool intel_sdvo_tv_create_property(struct intel_sdvo *intel_sdvo,
 					  struct intel_sdvo_connector *intel_sdvo_connector,
 					  int type)
@@ -2584,7 +2596,8 @@ bool intel_sdvo_init(struct drm_device *dev, uint32_t sdvo_reg, bool is_sdvob)
 				    intel_sdvo->caps.output_flags) != true) {
 		DRM_DEBUG_KMS("SDVO output failed to setup on %s\n",
 			      SDVO_NAME(intel_sdvo));
-		goto err;
+		/* Output_setup can leave behind connectors! */
+		goto err_output;
 	}
 
 	/* Only enable the hotplug irq if we need it, to work around noisy
@@ -2601,12 +2614,12 @@ bool intel_sdvo_init(struct drm_device *dev, uint32_t sdvo_reg, bool is_sdvob)
 
 	/* Set the input timing to the screen. Assume always input 0. */
 	if (!intel_sdvo_set_target_input(intel_sdvo))
-		goto err;
+		goto err_output;
 
 	if (!intel_sdvo_get_input_pixel_clock_range(intel_sdvo,
 						    &intel_sdvo->pixel_clock_min,
 						    &intel_sdvo->pixel_clock_max))
-		goto err;
+		goto err_output;
 
 	DRM_DEBUG_KMS("%s device VID/DID: %02X:%02X.%02X, "
 			"clock range %dMHz - %dMHz, "
@@ -2626,6 +2639,9 @@ bool intel_sdvo_init(struct drm_device *dev, uint32_t sdvo_reg, bool is_sdvob)
 			(SDVO_OUTPUT_TMDS1 | SDVO_OUTPUT_RGB1) ? 'Y' : 'N');
 	return true;
 
+err_output:
+	intel_sdvo_output_cleanup(intel_sdvo);
+
 err:
 	drm_encoder_cleanup(&intel_encoder->base);
 	i2c_del_adapter(&intel_sdvo->ddc);
-- 
1.7.9.5

