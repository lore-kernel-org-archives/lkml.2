Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946176Ab2I1VQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:16:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35006 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759408Ab2I1Ujt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:39:49 -0400
X-Sasl-enc: GVVol1l4W0azK2ApjS6CU8qRM7SrUMgGLzhTsrE0Lo+P 1348864789
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jani Nikula <jani.nikula@intel.com>,
        Alex Ferrando <alferpal@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 216/218] drm/i915: fall back to bit-banging if GMBUS fails in CRT EDID reads
Date: Fri, 28 Sep 2012 13:17:13 -0700
Message-Id: <20120928201526.398497585@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: stable@vger.kernel.org (for 3.4+3.5)
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/i915/intel_crt.c |   36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -266,6 +266,36 @@ static bool intel_crt_detect_hotplug(str
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
@@ -279,7 +309,7 @@ static bool intel_crt_detect_ddc(struct
 		struct edid *edid;
 		bool is_digital = false;
 
-		edid = drm_get_edid(connector,
+		edid = intel_crt_get_edid(connector,
 			&dev_priv->gmbus[dev_priv->crt_ddc_pin].adapter);
 		/*
 		 * This may be a DVI-I connector with a shared DDC
@@ -477,13 +507,13 @@ static int intel_crt_get_modes(struct dr
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int ret;
 
-	ret = intel_ddc_get_modes(connector,
+	ret = intel_crt_ddc_get_modes(connector,
 				 &dev_priv->gmbus[dev_priv->crt_ddc_pin].adapter);
 	if (ret || !IS_G4X(dev))
 		return ret;
 
 	/* Try to probe digital port for output in DVI-I -> VGA mode. */
-	return intel_ddc_get_modes(connector,
+	return intel_crt_ddc_get_modes(connector,
 				   &dev_priv->gmbus[GMBUS_PORT_DPB].adapter);
 }
 


