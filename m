Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab1I3BKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:10:38 -0400
Received: from home.keithp.com ([63.227.221.253]:49910 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183Ab1I3BKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:10:36 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 10/21] drm/i915: Wrap DP EDID fetch functions to enable eDP panel power
Date: Thu, 29 Sep 2011 18:09:42 -0700
Message-Id: <1317344993-24945-11-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317344993-24945-1-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Talking to the eDP DDC channel requires that the panel be powered
up. Wrap both the EDID and modes fetch code with calls to turn the vdd
power on and back off.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |   31 ++++++++++++++++++++++++++++---
 1 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 0b462f9..9829581 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1711,6 +1711,31 @@ g4x_dp_detect(struct intel_dp *intel_dp)
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
@@ -1743,7 +1768,7 @@ intel_dp_detect(struct drm_connector *connector, bool force)
 	if (intel_dp->force_audio) {
 		intel_dp->has_audio = intel_dp->force_audio > 0;
 	} else {
-		edid = drm_get_edid(connector, &intel_dp->adapter);
+		edid = intel_dp_get_edid(connector, &intel_dp->adapter);
 		if (edid) {
 			intel_dp->has_audio = drm_detect_monitor_audio(edid);
 			connector->display_info.raw_edid = NULL;
@@ -1764,7 +1789,7 @@ static int intel_dp_get_modes(struct drm_connector *connector)
 	/* We should parse the EDID data and find out if it has an audio sink
 	 */
 
-	ret = intel_ddc_get_modes(connector, &intel_dp->adapter);
+	ret = intel_dp_get_edid_modes(connector, &intel_dp->adapter);
 	if (ret) {
 		if (is_edp(intel_dp) && !dev_priv->panel_fixed_mode) {
 			struct drm_display_mode *newmode;
@@ -1809,7 +1834,7 @@ intel_dp_detect_audio(struct drm_connector *connector)
 	struct edid *edid;
 	bool has_audio = false;
 
-	edid = drm_get_edid(connector, &intel_dp->adapter);
+	edid = intel_dp_get_edid(connector, &intel_dp->adapter);
 	if (edid) {
 		has_audio = drm_detect_monitor_audio(edid);
 
-- 
1.7.6.3

