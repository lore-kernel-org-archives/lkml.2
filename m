Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935865Ab1KJEkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:40:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964849Ab1KJDff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:35:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:44 2011
Message-Id: <20111109213144.206682941@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Keith Packard <keithp@keithp.com>
Subject: [021/264] drm/i915: Wrap DP EDID fetch functions to enable eDP panel power
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Packard <keithp@keithp.com>

commit 8c241fef3e6f69f3f675678ae03599ece3f562e2 upstream.

Talking to the eDP DDC channel requires that the panel be powered
up. Wrap both the EDID and modes fetch code with calls to turn the vdd
power on and back off.

Signed-off-by: Keith Packard <keithp@keithp.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_dp.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1683,6 +1683,31 @@ g4x_dp_detect(struct intel_dp *intel_dp)
 	return intel_dp_detect_dpcd(intel_dp);
 }
 
+static struct edid *
+intel_dp_get_edid(struct drm_connector *connector, struct i2c_adapter *adapter)
+{
+	struct intel_dp *intel_dp = intel_attached_dp(connector);
+	struct edid	*edid;
+
+	ironlake_edp_panel_vdd_on(intel_dp);
+	edid = drm_get_edid(connector, adapter);
+	ironlake_edp_panel_vdd_off(intel_dp);
+	return edid;
+}
+
+static int
+intel_dp_get_edid_modes(struct drm_connector *connector, struct i2c_adapter *adapter)
+{
+	struct intel_dp *intel_dp = intel_attached_dp(connector);
+	int	ret;
+
+	ironlake_edp_panel_vdd_on(intel_dp);
+	ret = intel_ddc_get_modes(connector, adapter);
+	ironlake_edp_panel_vdd_off(intel_dp);
+	return ret;
+}
+
+
 /**
  * Uses CRT_HOTPLUG_EN and CRT_HOTPLUG_STAT to detect DP connection.
  *
@@ -1715,7 +1740,7 @@ intel_dp_detect(struct drm_connector *co
 	if (intel_dp->force_audio) {
 		intel_dp->has_audio = intel_dp->force_audio > 0;
 	} else {
-		edid = drm_get_edid(connector, &intel_dp->adapter);
+		edid = intel_dp_get_edid(connector, &intel_dp->adapter);
 		if (edid) {
 			intel_dp->has_audio = drm_detect_monitor_audio(edid);
 			connector->display_info.raw_edid = NULL;
@@ -1736,7 +1761,7 @@ static int intel_dp_get_modes(struct drm
 	/* We should parse the EDID data and find out if it has an audio sink
 	 */
 
-	ret = intel_ddc_get_modes(connector, &intel_dp->adapter);
+	ret = intel_dp_get_edid_modes(connector, &intel_dp->adapter);
 	if (ret) {
 		if (is_edp(intel_dp) && !dev_priv->panel_fixed_mode) {
 			struct drm_display_mode *newmode;
@@ -1772,7 +1797,7 @@ intel_dp_detect_audio(struct drm_connect
 	struct edid *edid;
 	bool has_audio = false;
 
-	edid = drm_get_edid(connector, &intel_dp->adapter);
+	edid = intel_dp_get_edid(connector, &intel_dp->adapter);
 	if (edid) {
 		has_audio = drm_detect_monitor_audio(edid);
 


