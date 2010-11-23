Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab0KWWmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 17:42:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:45864 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab0KWWmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 17:42:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,244,1288594800"; 
   d="scan'208";a="680410891"
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Tino Keitel <tino.keitel@tikei.de>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915/sdvo: Always fallback to querying the shared DDC line
Date: Tue, 23 Nov 2010 22:42:32 +0000
Message-Id: <1290552152-16026-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20101123214704.GA26884@mac.home>
References: <20101123214704.GA26884@mac.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a few devices, like the Mac Mini, the CRT DDC pins are shared between
the analog connector and the digital connector. In this scenario, use
the EDID to determine if a digital panel is connected to the digital
connector.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---

Looking closer I can't see any rationale for checking whether or not the
analog device is attached since we check whether the display is digital
before accepting the EDID.

---
 drivers/gpu/drm/i915/intel_sdvo.c |   45 +-----------------------------------
 1 files changed, 2 insertions(+), 43 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 8431825..906696f 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1296,55 +1296,14 @@ intel_sdvo_get_edid(struct drm_connector *connector)
 	return drm_get_edid(connector, &sdvo->ddc);
 }
 
-static struct drm_connector *
-intel_find_analog_connector(struct drm_device *dev)
-{
-	struct drm_connector *connector;
-	struct intel_sdvo *encoder;
-
-	list_for_each_entry(encoder,
-			    &dev->mode_config.encoder_list,
-			    base.base.head) {
-		if (encoder->base.type == INTEL_OUTPUT_ANALOG) {
-			list_for_each_entry(connector,
-					    &dev->mode_config.connector_list,
-					    head) {
-				if (&encoder->base ==
-				    intel_attached_encoder(connector))
-					return connector;
-			}
-		}
-	}
-
-	return NULL;
-}
-
-static int
-intel_analog_is_connected(struct drm_device *dev)
-{
-	struct drm_connector *analog_connector;
-
-	analog_connector = intel_find_analog_connector(dev);
-	if (!analog_connector)
-		return false;
-
-	if (analog_connector->funcs->detect(analog_connector, false) ==
-			connector_status_disconnected)
-		return false;
-
-	return true;
-}
-
 /* Mac mini hack -- use the same DDC as the analog connector */
 static struct edid *
 intel_sdvo_get_analog_edid(struct drm_connector *connector)
 {
 	struct drm_i915_private *dev_priv = connector->dev->dev_private;
 
-	if (!intel_analog_is_connected(connector->dev))
-		return NULL;
-
-	return drm_get_edid(connector, &dev_priv->gmbus[dev_priv->crt_ddc_pin].adapter);
+	return drm_get_edid(connector,
+			    &dev_priv->gmbus[dev_priv->crt_ddc_pin].adapter);
 }
 
 enum drm_connector_status
-- 
1.7.2.3

