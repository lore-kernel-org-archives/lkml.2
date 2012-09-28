Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030904Ab2I1TYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:24:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030450Ab2I1TDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:03:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jani Nikula <jani.nikula@intel.com>,
        Alex Ferrando <alferpal@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 189/262] drm/i915: fall back to bit-banging if GMBUS fails in CRT EDID reads
Date: Fri, 28 Sep 2012 11:51:58 -0700
Message-Id: <20120928183020.381733584@linuxfoundation.org>
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

commit f1a2f5b7c5f0941d23eef0a095c0b99bf8d051e6 upstream.

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
Tested-by: Alex Ferrando <alferpal@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_crt.c |   36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -284,6 +284,36 @@ static bool intel_crt_detect_hotplug(str
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
@@ -299,7 +329,7 @@ static bool intel_crt_detect_ddc(struct
 		struct i2c_adapter *i2c;
 
 		i2c = intel_gmbus_get_adapter(dev_priv, dev_priv->crt_ddc_pin);
-		edid = drm_get_edid(connector, i2c);
+		edid = intel_crt_get_edid(connector, i2c);
 		/*
 		 * This may be a DVI-I connector with a shared DDC
 		 * link between analog and digital outputs, so we
@@ -498,13 +528,13 @@ static int intel_crt_get_modes(struct dr
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


