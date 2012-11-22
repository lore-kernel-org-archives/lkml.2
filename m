Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030231Ab2KVWVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:21:23 -0500
Received: from mail.kernel.org ([198.145.19.201]:49342 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527Ab2KVSi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 43/83] drm/i915/sdvo: clean up connectors on intel_sdvo_init() failures
Date: Wed, 21 Nov 2012 16:42:05 -0800
Message-Id: <20121122004217.387026966@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_sdvo.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -2287,6 +2287,18 @@ intel_sdvo_output_setup(struct intel_sdv
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
@@ -2606,7 +2618,8 @@ bool intel_sdvo_init(struct drm_device *
 				    intel_sdvo->caps.output_flags) != true) {
 		DRM_DEBUG_KMS("SDVO output failed to setup on %s\n",
 			      SDVO_NAME(intel_sdvo));
-		goto err;
+		/* Output_setup can leave behind connectors! */
+		goto err_output;
 	}
 
 	/* Only enable the hotplug irq if we need it, to work around noisy
@@ -2619,12 +2632,12 @@ bool intel_sdvo_init(struct drm_device *
 
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
@@ -2644,6 +2657,9 @@ bool intel_sdvo_init(struct drm_device *
 			(SDVO_OUTPUT_TMDS1 | SDVO_OUTPUT_RGB1) ? 'Y' : 'N');
 	return true;
 
+err_output:
+	intel_sdvo_output_cleanup(intel_sdvo);
+
 err:
 	drm_encoder_cleanup(&intel_encoder->base);
 	i2c_del_adapter(&intel_sdvo->ddc);


