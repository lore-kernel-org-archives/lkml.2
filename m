Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030424Ab2I1TDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:03:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030445Ab2I1TDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:03:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jani Nikula <jani.nikula@intel.com>,
        Alex Ferrando <alferpal@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 188/262] drm/i915: extract connector update from intel_ddc_get_modes() for reuse
Date: Fri, 28 Sep 2012 11:51:57 -0700
Message-Id: <20120928183020.249030534@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 4eab81366465aedcfd26de960c595bc03599c09f upstream.

Refactor the connector update part of intel_ddc_get_modes() into a separate
intel_connector_update_modes() function for reuse. No functional changes.

Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=45881
Tested-by: Alex Ferrando <alferpal@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_drv.h   |    2 ++
 drivers/gpu/drm/i915/intel_modes.c |   31 ++++++++++++++++++++++---------
 2 files changed, 24 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -334,6 +334,8 @@ struct intel_fbc_work {
 	int interval;
 };
 
+int intel_connector_update_modes(struct drm_connector *connector,
+				struct edid *edid);
 int intel_ddc_get_modes(struct drm_connector *c, struct i2c_adapter *adapter);
 extern bool intel_ddc_probe(struct intel_encoder *intel_encoder, int ddc_bus);
 
--- a/drivers/gpu/drm/i915/intel_modes.c
+++ b/drivers/gpu/drm/i915/intel_modes.c
@@ -61,6 +61,25 @@ bool intel_ddc_probe(struct intel_encode
 }
 
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
@@ -71,18 +90,12 @@ int intel_ddc_get_modes(struct drm_conne
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


