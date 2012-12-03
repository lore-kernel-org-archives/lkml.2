Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab2LCO5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:57:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43563 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932104Ab2LCOfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:35:47 -0500
Message-Id: <20121203143148.291044737@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:31:56 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jani Nikula <jani.nikula@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 10/89] drm/i915/sdvo: clean up connectors on intel_sdvo_init() failures
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_sdvo.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -2264,6 +2264,18 @@ intel_sdvo_output_setup(struct intel_sdv
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
@@ -2596,7 +2608,8 @@ bool intel_sdvo_init(struct drm_device *
 				    intel_sdvo->caps.output_flags) != true) {
 		DRM_DEBUG_KMS("SDVO output failed to setup on SDVO%c\n",
 			      IS_SDVOB(sdvo_reg) ? 'B' : 'C');
-		goto err;
+		/* Output_setup can leave behind connectors! */
+		goto err_output;
 	}
 
 	/* Only enable the hotplug irq if we need it, to work around noisy
@@ -2609,12 +2622,12 @@ bool intel_sdvo_init(struct drm_device *
 
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
@@ -2634,6 +2647,9 @@ bool intel_sdvo_init(struct drm_device *
 			(SDVO_OUTPUT_TMDS1 | SDVO_OUTPUT_RGB1) ? 'Y' : 'N');
 	return true;
 
+err_output:
+	intel_sdvo_output_cleanup(intel_sdvo);
+
 err:
 	drm_encoder_cleanup(&intel_encoder->base);
 	i2c_del_adapter(&intel_sdvo->ddc);


