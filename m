Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab2HMKTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 06:19:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:4664 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab2HMKTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 06:19:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,759,1336374000"; 
   d="scan'208";a="179927293"
From: Jani Nikula <jani.nikula@intel.com>
To: maciej.rutecki@gmail.com, alferpal@gmail.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Cc: daniel@ffwll.ch, jani.nikula@intel.com
Subject: [PATCH 2/2] drm/i915: fall back to bit-banging if GMBUS fails in CRT EDID reads
Date: Mon, 13 Aug 2012 13:22:35 +0300
Message-Id: <03e17075b1252d819178316c8b2a12573e59ddca.1344852255.git.jani.nikula@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1344852255.git.jani.nikula@intel.com>
References: <201207271346.49259.maciej.rutecki@gmail.com>
 <cover.1344852255.git.jani.nikula@intel.com>
In-Reply-To: <cover.1344852255.git.jani.nikula@intel.com>
References: <cover.1344852255.git.jani.nikula@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GMBUS was enabled over bit-banging as the default in commits:

commit c3dfefa0a6d235bd465309e12f4c56ea16e71111
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Feb 14 22:37:25 2012 +0100

    drm/i915: reenable gmbus on gen3+ again

and

commit 0fb3f969c8683505fb7323c06bf8a999a5a45a15
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri Mar 2 19:38:30 2012 +0100

    drm/i915: enable gmbus on gen2

Unfortunately, GMBUS seems to fail on some CRT displays. Add a bit-banging
fallback to CRT EDID reads.

LKML-Reference: <201207251020.47637.maciej.rutecki@gmail.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=45881
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/intel_crt.c |   36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_crt.c b/drivers/gpu/drm/i915/intel_crt.c
index bc5e2c9..80bf311 100644
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -328,6 +328,36 @@ static bool intel_crt_detect_hotplug(struct drm_connector *connector)
 	return ret;
 }
 
+static struct edid *intel_crt_get_edid(struct drm_connector *connector,
+				struct i2c_adapter *i2c)
+{
+	struct edid *edid;
+
+	edid = drm_get_edid(connector, i2c);
+
+	if (!edid && !intel_gmbus_is_forced_bit(i2c)) {
+		DRM_DEBUG_KMS("CRT GMBUS EDID read failed, retry using GPIO bit-banging\n");
+		intel_gmbus_force_bit(i2c, true);
+		edid = drm_get_edid(connector, i2c);
+		intel_gmbus_force_bit(i2c, false);
+	}
+
+	return edid;
+}
+
+/* local version of intel_ddc_get_modes() to use intel_crt_get_edid() */
+static int intel_crt_ddc_get_modes(struct drm_connector *connector,
+				struct i2c_adapter *adapter)
+{
+	struct edid *edid;
+
+	edid = intel_crt_get_edid(connector, adapter);
+	if (!edid)
+		return 0;
+
+	return intel_connector_update_modes(connector, edid);
+}
+
 static bool intel_crt_detect_ddc(struct drm_connector *connector)
 {
 	struct intel_crt *crt = intel_attached_crt(connector);
@@ -338,7 +368,7 @@ static bool intel_crt_detect_ddc(struct drm_connector *connector)
 	BUG_ON(crt->base.type != INTEL_OUTPUT_ANALOG);
 
 	i2c = intel_gmbus_get_adapter(dev_priv, dev_priv->crt_ddc_pin);
-	edid = drm_get_edid(connector, i2c);
+	edid = intel_crt_get_edid(connector, i2c);
 
 	if (edid) {
 		bool is_digital = edid->input & DRM_EDID_INPUT_DIGITAL;
@@ -546,13 +576,13 @@ static int intel_crt_get_modes(struct drm_connector *connector)
 	struct i2c_adapter *i2c;
 
 	i2c = intel_gmbus_get_adapter(dev_priv, dev_priv->crt_ddc_pin);
-	ret = intel_ddc_get_modes(connector, i2c);
+	ret = intel_crt_ddc_get_modes(connector, i2c);
 	if (ret || !IS_G4X(dev))
 		return ret;
 
 	/* Try to probe digital port for output in DVI-I -> VGA mode. */
 	i2c = intel_gmbus_get_adapter(dev_priv, GMBUS_PORT_DPB);
-	return intel_ddc_get_modes(connector, i2c);
+	return intel_crt_ddc_get_modes(connector, i2c);
 }
 
 static int intel_crt_set_property(struct drm_connector *connector,
-- 
1.7.9.5

