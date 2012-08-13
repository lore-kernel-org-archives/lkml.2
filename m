Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab2HMKTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 06:19:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:38583 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab2HMKS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 06:18:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,759,1336374000"; 
   d="scan'208";a="199583660"
From: Jani Nikula <jani.nikula@intel.com>
To: maciej.rutecki@gmail.com, alferpal@gmail.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Cc: daniel@ffwll.ch, jani.nikula@intel.com
Subject: [PATCH 1/2] drm/i915: extract connector update from intel_ddc_get_modes() for reuse
Date: Mon, 13 Aug 2012 13:22:34 +0300
Message-Id: <82479a0d3bcd3962d7feca49dbc458bb346052a5.1344852255.git.jani.nikula@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1344852255.git.jani.nikula@intel.com>
References: <201207271346.49259.maciej.rutecki@gmail.com>
 <cover.1344852255.git.jani.nikula@intel.com>
In-Reply-To: <cover.1344852255.git.jani.nikula@intel.com>
References: <cover.1344852255.git.jani.nikula@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the connector update part of intel_ddc_get_modes() into a separate
intel_connector_update_modes() function for reuse. No functional changes.

Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/intel_drv.h   |    2 ++
 drivers/gpu/drm/i915/intel_modes.c |   31 ++++++++++++++++++++++---------
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 13f0467..8a224ca 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -357,6 +357,8 @@ struct intel_fbc_work {
 	int interval;
 };
 
+int intel_connector_update_modes(struct drm_connector *connector,
+				struct edid *edid);
 int intel_ddc_get_modes(struct drm_connector *c, struct i2c_adapter *adapter);
 
 extern void intel_attach_force_audio_property(struct drm_connector *connector);
diff --git a/drivers/gpu/drm/i915/intel_modes.c b/drivers/gpu/drm/i915/intel_modes.c
index 45848b9..29b7259 100644
--- a/drivers/gpu/drm/i915/intel_modes.c
+++ b/drivers/gpu/drm/i915/intel_modes.c
@@ -33,6 +33,25 @@
 #include "i915_drv.h"
 
 /**
+ * intel_connector_update_modes - update connector from edid
+ * @connector: DRM connector device to use
+ * @edid: previously read EDID information
+ */
+int intel_connector_update_modes(struct drm_connector *connector,
+				struct edid *edid)
+{
+	int ret;
+
+	drm_mode_connector_update_edid_property(connector, edid);
+	ret = drm_add_edid_modes(connector, edid);
+	drm_edid_to_eld(connector, edid);
+	connector->display_info.raw_edid = NULL;
+	kfree(edid);
+
+	return ret;
+}
+
+/**
  * intel_ddc_get_modes - get modelist from monitor
  * @connector: DRM connector device to use
  * @adapter: i2c adapter
@@ -43,18 +62,12 @@ int intel_ddc_get_modes(struct drm_connector *connector,
 			struct i2c_adapter *adapter)
 {
 	struct edid *edid;
-	int ret = 0;
 
 	edid = drm_get_edid(connector, adapter);
-	if (edid) {
-		drm_mode_connector_update_edid_property(connector, edid);
-		ret = drm_add_edid_modes(connector, edid);
-		drm_edid_to_eld(connector, edid);
-		connector->display_info.raw_edid = NULL;
-		kfree(edid);
-	}
+	if (!edid)
+		return 0;
 
-	return ret;
+	return intel_connector_update_modes(connector, edid);
 }
 
 static const struct drm_prop_enum_list force_audio_names[] = {
-- 
1.7.9.5

