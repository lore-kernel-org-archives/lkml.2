Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab1BVWVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:21:11 -0500
Received: from kroah.org ([198.145.64.141]:46550 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab1BVWVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:04 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:37 2011
Message-Id: <20110222221837.449687285@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:16:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [04/70] drm/i915/sdvo: If we have an EDID confirm it matches the mode of the connection
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 139467433e50926d22338e9dc754feaaf94b9db0 upstream.

If we have an EDID for a digital panel, but we are probing a non-TMDS
connector then we know that this is a false detection, and vice versa.
This should reduce the number of bogus outputs on multi-function
adapters that report the same output on multiple connectors.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=34101
Reported-by: Sebastien Caty <sebastien.caty@mrnf.gouv.qc.ca>
Tested-by: Sebastien Caty <sebastien.caty@mrnf.gouv.qc.ca>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_sdvo.c |   32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -46,6 +46,7 @@
                          SDVO_TV_MASK)
 
 #define IS_TV(c)	(c->output_flag & SDVO_TV_MASK)
+#define IS_TMDS(c)	(c->output_flag & SDVO_TMDS_MASK)
 #define IS_LVDS(c)	(c->output_flag & SDVO_LVDS_MASK)
 #define IS_TV_OR_LVDS(c) (c->output_flag & (SDVO_TV_MASK | SDVO_LVDS_MASK))
 
@@ -1356,7 +1357,8 @@ intel_sdvo_hdmi_sink_detect(struct drm_c
 				intel_sdvo->has_hdmi_monitor = drm_detect_hdmi_monitor(edid);
 				intel_sdvo->has_hdmi_audio = drm_detect_monitor_audio(edid);
 			}
-		}
+		} else
+			status = connector_status_disconnected;
 		connector->display_info.raw_edid = NULL;
 		kfree(edid);
 	}
@@ -1404,10 +1406,25 @@ intel_sdvo_detect(struct drm_connector *
 
 	if ((intel_sdvo_connector->output_flag & response) == 0)
 		ret = connector_status_disconnected;
-	else if (response & SDVO_TMDS_MASK)
+	else if (IS_TMDS(intel_sdvo_connector))
 		ret = intel_sdvo_hdmi_sink_detect(connector);
-	else
-		ret = connector_status_connected;
+	else {
+		struct edid *edid;
+
+		/* if we have an edid check it matches the connection */
+		edid = intel_sdvo_get_edid(connector);
+		if (edid == NULL)
+			edid = intel_sdvo_get_analog_edid(connector);
+		if (edid != NULL) {
+			if (edid->input & DRM_EDID_INPUT_DIGITAL)
+				ret = connector_status_disconnected;
+			else
+				ret = connector_status_connected;
+			connector->display_info.raw_edid = NULL;
+			kfree(edid);
+		} else
+			ret = connector_status_connected;
+	}
 
 	/* May update encoder flag for like clock for SDVO TV, etc.*/
 	if (ret == connector_status_connected) {
@@ -1443,10 +1460,15 @@ static void intel_sdvo_get_ddc_modes(str
 		edid = intel_sdvo_get_analog_edid(connector);
 
 	if (edid != NULL) {
-		if (edid->input & DRM_EDID_INPUT_DIGITAL) {
+		struct intel_sdvo_connector *intel_sdvo_connector = to_intel_sdvo_connector(connector);
+		bool monitor_is_digital = !!(edid->input & DRM_EDID_INPUT_DIGITAL);
+		bool connector_is_digital = !!IS_TMDS(intel_sdvo_connector);
+
+		if (connector_is_digital == monitor_is_digital) {
 			drm_mode_connector_update_edid_property(connector, edid);
 			drm_add_edid_modes(connector, edid);
 		}
+
 		connector->display_info.raw_edid = NULL;
 		kfree(edid);
 	}


