Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab1BPAZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:25:44 -0500
Received: from kroah.org ([198.145.64.141]:49897 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757800Ab1BPAZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:25:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:50 2011
Message-Id: <20110216001450.771212148@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:15:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?David=20M=C3=BCller?= <d.mueller@elsoft.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [257/272] drm/i915/crt: Check for a analog monitor in case of DVI-I
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?David=20M=C3=BCller?= <d.mueller@elsoft.ch>

commit f5afcd3dd0dca7fe869311c51da54d5a889191ba upstream.

Since Linux 2.6.36 the digital output on my system (855GME + DVI-I) is
not working any longer. The analog output is always activated
regardless of the type of monitor attached.

The culprit seems to be intel_crt_detect_ddc(), which returns true as
soon as an ACK from the EDID device is received. Obviously this
approach does not work with DVI-I where the analog and digital outputs
share a common DDC bus.

In a similar manner to the shared DDC wire, ala the "Mac Mini Hack", we
need an additional check to make sure that there really is an analog
device attached to the DDC.

Signed-off-by: David Müller <d.mueller@elsoft.ch>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_crt.c |   30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -30,6 +30,7 @@
 #include "drm.h"
 #include "drm_crtc.h"
 #include "drm_crtc_helper.h"
+#include "drm_edid.h"
 #include "intel_drv.h"
 #include "i915_drm.h"
 #include "i915_drv.h"
@@ -287,8 +288,9 @@ static bool intel_crt_ddc_probe(struct d
 	return i2c_transfer(&dev_priv->gmbus[ddc_bus].adapter, msgs, 1) == 1;
 }
 
-static bool intel_crt_detect_ddc(struct intel_crt *crt)
+static bool intel_crt_detect_ddc(struct drm_connector *connector)
 {
+	struct intel_crt *crt = intel_attached_crt(connector);
 	struct drm_i915_private *dev_priv = crt->base.base.dev->dev_private;
 
 	/* CRT should always be at 0, but check anyway */
@@ -301,8 +303,26 @@ static bool intel_crt_detect_ddc(struct
 	}
 
 	if (intel_ddc_probe(&crt->base, dev_priv->crt_ddc_pin)) {
-		DRM_DEBUG_KMS("CRT detected via DDC:0x50 [EDID]\n");
-		return true;
+		struct edid *edid;
+		bool is_digital = false;
+
+		edid = drm_get_edid(connector,
+			&dev_priv->gmbus[dev_priv->crt_ddc_pin].adapter);
+		/*
+		 * This may be a DVI-I connector with a shared DDC
+		 * link between analog and digital outputs, so we
+		 * have to check the EDID input spec of the attached device.
+		 */
+		if (edid != NULL) {
+			is_digital = edid->input & DRM_EDID_INPUT_DIGITAL;
+			connector->display_info.raw_edid = NULL;
+			kfree(edid);
+		}
+
+		if (!is_digital) {
+			DRM_DEBUG_KMS("CRT detected via DDC:0x50 [EDID]\n");
+			return true;
+		}
 	}
 
 	return false;
@@ -458,7 +478,7 @@ intel_crt_detect(struct drm_connector *c
 		}
 	}
 
-	if (intel_crt_detect_ddc(crt))
+	if (intel_crt_detect_ddc(connector))
 		return connector_status_connected;
 
 	if (!force)
@@ -472,7 +492,7 @@ intel_crt_detect(struct drm_connector *c
 		crtc = intel_get_load_detect_pipe(&crt->base, connector,
 						  NULL, &dpms_mode);
 		if (crtc) {
-			if (intel_crt_detect_ddc(crt))
+			if (intel_crt_detect_ddc(connector))
 				status = connector_status_connected;
 			else
 				status = intel_crt_load_detect(crtc, crt);


