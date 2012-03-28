Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab2C1MxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:53:20 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:38426 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab2C1MwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:52:05 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 05/14 v5] drm/i915/intel_i2c: refactor using intel_gmbus_get_adapter
Date: Wed, 28 Mar 2012 20:51:48 +0800
Message-Id: <1332939117-6513-6-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
References: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of letting other modules directly access the ->gmbus array,
introduce intel_gmbus_get_adapter() for looking up an i2c_adapter
for a given gmbus port identifier.  This will enable later refactoring
of the gmbus port list.

Note: Before requesting an adapter for a given gmbus port number, the
driver must first check its validity using i2c_intel_gmbus_is_port_valid().
If this check fails, a call to intel_gmbus_get_adapter() will WARN_ON and
return NULL.  This is relevant for parts of the driver that read a port
from VBIOS, which might be improperly initialized and contain an invalid
port.  In these cases, the driver must fall back to using a safer default
port.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/i915_drv.h    |    7 +++++++
 drivers/gpu/drm/i915/intel_bios.c  |    4 ++--
 drivers/gpu/drm/i915/intel_crt.c   |   14 ++++++++------
 drivers/gpu/drm/i915/intel_dvo.c   |    6 +++---
 drivers/gpu/drm/i915/intel_hdmi.c  |    9 ++++++---
 drivers/gpu/drm/i915/intel_i2c.c   |    8 ++++++++
 drivers/gpu/drm/i915/intel_lvds.c  |    7 ++++---
 drivers/gpu/drm/i915/intel_modes.c |    3 ++-
 drivers/gpu/drm/i915/intel_sdvo.c  |    9 +++++----
 9 files changed, 45 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index e11fcb0..44e6430 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1342,6 +1342,13 @@ extern int i915_restore_state(struct drm_device *dev);
 /* intel_i2c.c */
 extern int intel_setup_gmbus(struct drm_device *dev);
 extern void intel_teardown_gmbus(struct drm_device *dev);
+extern inline bool intel_gmbus_is_port_valid(unsigned port)
+{
+	return (port >= GMBUS_PORT_DISABLED && port <= GMBUS_PORT_RESERVED);
+}
+
+extern struct i2c_adapter *intel_gmbus_get_adapter(
+		struct drm_i915_private *dev_priv, unsigned port);
 extern void intel_gmbus_set_speed(struct i2c_adapter *adapter, int speed);
 extern void intel_gmbus_force_bit(struct i2c_adapter *adapter, bool force_bit);
 extern inline bool intel_gmbus_is_forced_bit(struct i2c_adapter *adapter)
diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index e4317da..871aa27 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -372,11 +372,11 @@ parse_general_definitions(struct drm_i915_private *dev_priv,
 		if (block_size >= sizeof(*general)) {
 			int bus_pin = general->crt_ddc_gmbus_pin;
 			DRM_DEBUG_KMS("crt_ddc_bus_pin: %d\n", bus_pin);
-			if (bus_pin >= 1 && bus_pin <= 6)
+			if (intel_gmbus_is_port_valid(bus_pin))
 				dev_priv->crt_ddc_pin = bus_pin;
 		} else {
 			DRM_DEBUG_KMS("BDB_GD too small (%d). Invalid.\n",
-				  block_size);
+				      block_size);
 		}
 	}
 }
diff --git a/drivers/gpu/drm/i915/intel_crt.c b/drivers/gpu/drm/i915/intel_crt.c
index 4d3d736..d54d232 100644
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -278,9 +278,10 @@ static bool intel_crt_detect_ddc(struct drm_connector *connector)
 	if (intel_ddc_probe(&crt->base, dev_priv->crt_ddc_pin)) {
 		struct edid *edid;
 		bool is_digital = false;
+		struct i2c_adapter *i2c;
 
-		edid = drm_get_edid(connector,
-			&dev_priv->gmbus[dev_priv->crt_ddc_pin].adapter);
+		i2c = intel_gmbus_get_adapter(dev_priv, dev_priv->crt_ddc_pin);
+		edid = drm_get_edid(connector, i2c);
 		/*
 		 * This may be a DVI-I connector with a shared DDC
 		 * link between analog and digital outputs, so we
@@ -483,15 +484,16 @@ static int intel_crt_get_modes(struct drm_connector *connector)
 	struct drm_device *dev = connector->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int ret;
+	struct i2c_adapter *i2c;
 
-	ret = intel_ddc_get_modes(connector,
-				 &dev_priv->gmbus[dev_priv->crt_ddc_pin].adapter);
+	i2c = intel_gmbus_get_adapter(dev_priv, dev_priv->crt_ddc_pin);
+	ret = intel_ddc_get_modes(connector, i2c);
 	if (ret || !IS_G4X(dev))
 		return ret;
 
 	/* Try to probe digital port for output in DVI-I -> VGA mode. */
-	return intel_ddc_get_modes(connector,
-				   &dev_priv->gmbus[GMBUS_PORT_DPB].adapter);
+	i2c = intel_gmbus_get_adapter(dev_priv, GMBUS_PORT_DPB);
+	return intel_ddc_get_modes(connector, i2c);
 }
 
 static int intel_crt_set_property(struct drm_connector *connector,
diff --git a/drivers/gpu/drm/i915/intel_dvo.c b/drivers/gpu/drm/i915/intel_dvo.c
index 020a7d7..60ba50b9 100644
--- a/drivers/gpu/drm/i915/intel_dvo.c
+++ b/drivers/gpu/drm/i915/intel_dvo.c
@@ -243,7 +243,7 @@ static int intel_dvo_get_modes(struct drm_connector *connector)
 	 * that's not the case.
 	 */
 	intel_ddc_get_modes(connector,
-			    &dev_priv->gmbus[GMBUS_PORT_DPC].adapter);
+			    intel_gmbus_get_adapter(dev_priv, GMBUS_PORT_DPC));
 	if (!list_empty(&connector->probed_modes))
 		return 1;
 
@@ -375,7 +375,7 @@ void intel_dvo_init(struct drm_device *dev)
 		 * special cases, but otherwise default to what's defined
 		 * in the spec.
 		 */
-		if (dvo->gpio != 0)
+		if (intel_gmbus_is_port_valid(dvo->gpio))
 			gpio = dvo->gpio;
 		else if (dvo->type == INTEL_DVO_CHIP_LVDS)
 			gpio = GMBUS_PORT_SSC;
@@ -386,7 +386,7 @@ void intel_dvo_init(struct drm_device *dev)
 		 * It appears that everything is on GPIOE except for panels
 		 * on i830 laptops, which are on GPIOB (DVOA).
 		 */
-		i2c = &dev_priv->gmbus[gpio].adapter;
+		i2c = intel_gmbus_get_adapter(dev_priv, gpio);
 
 		intel_dvo->dev = *dvo;
 		if (!dvo->dev_ops->init(&intel_dvo->dev, i2c))
diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel_hdmi.c
index cae3e5f..1d00f61 100644
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -334,7 +334,8 @@ intel_hdmi_detect(struct drm_connector *connector, bool force)
 	intel_hdmi->has_hdmi_sink = false;
 	intel_hdmi->has_audio = false;
 	edid = drm_get_edid(connector,
-			    &dev_priv->gmbus[intel_hdmi->ddc_bus].adapter);
+			    intel_gmbus_get_adapter(dev_priv,
+						    intel_hdmi->ddc_bus));
 
 	if (edid) {
 		if (edid->input & DRM_EDID_INPUT_DIGITAL) {
@@ -367,7 +368,8 @@ static int intel_hdmi_get_modes(struct drm_connector *connector)
 	 */
 
 	return intel_ddc_get_modes(connector,
-				   &dev_priv->gmbus[intel_hdmi->ddc_bus].adapter);
+				   intel_gmbus_get_adapter(dev_priv,
+							   intel_hdmi->ddc_bus));
 }
 
 static bool
@@ -379,7 +381,8 @@ intel_hdmi_detect_audio(struct drm_connector *connector)
 	bool has_audio = false;
 
 	edid = drm_get_edid(connector,
-			    &dev_priv->gmbus[intel_hdmi->ddc_bus].adapter);
+			    intel_gmbus_get_adapter(dev_priv,
+						    intel_hdmi->ddc_bus));
 	if (edid) {
 		if (edid->input & DRM_EDID_INPUT_DIGITAL)
 			has_audio = drm_detect_monitor_audio(edid);
diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 1bb6362..2f65d01 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -449,6 +449,14 @@ err:
 	return ret;
 }
 
+struct i2c_adapter *intel_gmbus_get_adapter(struct drm_i915_private *dev_priv,
+					    unsigned port)
+{
+	WARN_ON(!intel_gmbus_is_port_valid(port));
+	return (intel_gmbus_is_port_valid(port)) ?
+		&dev_priv->gmbus[port].adapter : NULL;
+}
+
 void intel_gmbus_set_speed(struct i2c_adapter *adapter, int speed)
 {
 	struct intel_gmbus *bus = to_intel_gmbus(adapter);
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index c5c0973..4f92a11 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -837,8 +837,8 @@ static bool lvds_is_present_in_vbt(struct drm_device *dev,
 		    child->device_type != DEVICE_TYPE_LFP)
 			continue;
 
-		if (child->i2c_pin)
-		    *i2c_pin = child->i2c_pin;
+		if (intel_gmbus_is_port_valid(child->i2c_pin))
+			*i2c_pin = child->i2c_pin;
 
 		/* However, we cannot trust the BIOS writers to populate
 		 * the VBT correctly.  Since LVDS requires additional
@@ -979,7 +979,8 @@ bool intel_lvds_init(struct drm_device *dev)
 	 * preferred mode is the right one.
 	 */
 	intel_lvds->edid = drm_get_edid(connector,
-					&dev_priv->gmbus[pin].adapter);
+					intel_gmbus_get_adapter(dev_priv,
+								pin));
 	if (intel_lvds->edid) {
 		if (drm_add_edid_modes(connector,
 				       intel_lvds->edid)) {
diff --git a/drivers/gpu/drm/i915/intel_modes.c b/drivers/gpu/drm/i915/intel_modes.c
index 2978a3f..cc682a0 100644
--- a/drivers/gpu/drm/i915/intel_modes.c
+++ b/drivers/gpu/drm/i915/intel_modes.c
@@ -55,7 +55,8 @@ bool intel_ddc_probe(struct intel_encoder *intel_encoder, int ddc_bus)
 		}
 	};
 
-	return i2c_transfer(&dev_priv->gmbus[ddc_bus].adapter, msgs, 2) == 2;
+	return i2c_transfer(intel_gmbus_get_adapter(dev_priv, ddc_bus),
+			    msgs, 2) == 2;
 }
 
 /**
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 70fb275..830c8b5 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1254,7 +1254,8 @@ intel_sdvo_get_analog_edid(struct drm_connector *connector)
 	struct drm_i915_private *dev_priv = connector->dev->dev_private;
 
 	return drm_get_edid(connector,
-			    &dev_priv->gmbus[dev_priv->crt_ddc_pin].adapter);
+			    intel_gmbus_get_adapter(dev_priv,
+						    dev_priv->crt_ddc_pin));
 }
 
 enum drm_connector_status
@@ -1922,12 +1923,12 @@ intel_sdvo_select_i2c_bus(struct drm_i915_private *dev_priv,
 	if (mapping->initialized)
 		pin = mapping->i2c_pin;
 
-	if (pin < GMBUS_NUM_PORTS) {
-		sdvo->i2c = &dev_priv->gmbus[pin].adapter;
+	if (intel_gmbus_is_port_valid(pin)) {
+		sdvo->i2c = intel_gmbus_get_adapter(dev_priv, pin);
 		intel_gmbus_set_speed(sdvo->i2c, GMBUS_RATE_1MHZ);
 		intel_gmbus_force_bit(sdvo->i2c, true);
 	} else {
-		sdvo->i2c = &dev_priv->gmbus[GMBUS_PORT_DPB].adapter;
+		sdvo->i2c = intel_gmbus_get_adapter(dev_priv, GMBUS_PORT_DPB);
 	}
 }
 
-- 
1.7.7.3

