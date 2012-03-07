Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab2CGLvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:51:17 -0500
Received: from mail-fa0-f74.google.com ([209.85.161.74]:50672 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab2CGLvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:51:02 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 3/9] drm/i915/intel_i2c: refactor using intel_gmbus_get_bus
Date: Wed,  7 Mar 2012 19:50:44 +0800
Message-Id: <1331121050-17857-4-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of letting other modules directly access the ->gmbus array,
introduce a new API, intel_gmbus_get_bus(), to lookup an i2c_adapter for
a given gmbus pin pair identifier.  This API enables later refactoring
of the gmbus pin pair list.

Note: It is critical that intel_setup_gmbus() gets called before
intel_gmbus_get_bus().

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/i915_drv.h    |    4 +++-
 drivers/gpu/drm/i915/intel_bios.c  |   10 ++++++----
 drivers/gpu/drm/i915/intel_crt.c   |   13 ++++++-------
 drivers/gpu/drm/i915/intel_drv.h   |    3 ++-
 drivers/gpu/drm/i915/intel_dvo.c   |    4 ++--
 drivers/gpu/drm/i915/intel_hdmi.c  |   29 ++++++++++++++---------------
 drivers/gpu/drm/i915/intel_i2c.c   |    6 ++++++
 drivers/gpu/drm/i915/intel_lvds.c  |    2 +-
 drivers/gpu/drm/i915/intel_modes.c |    6 +++---
 drivers/gpu/drm/i915/intel_sdvo.c  |   10 ++++------
 10 files changed, 47 insertions(+), 40 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 9689ca3..64d1276 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -391,7 +391,7 @@ typedef struct drm_i915_private {
 
 	struct notifier_block lid_notifier;
 
-	int crt_ddc_pin;
+	struct i2c_adapter *crt_ddc;
 	struct drm_i915_fence_reg fence_regs[I915_MAX_NUM_FENCES]; /* assume 965 */
 	int fence_reg_start; /* 4 if userland hasn't ioctl'd us yet */
 	int num_fence_regs; /* 8 on pre-965, 16 otherwise */
@@ -1274,6 +1274,8 @@ extern int i915_restore_state(struct drm_device *dev);
 /* intel_i2c.c */
 extern int intel_setup_gmbus(struct drm_device *dev);
 extern void intel_teardown_gmbus(struct drm_device *dev);
+extern struct i2c_adapter *intel_gmbus_get_bus(
+		struct drm_i915_private *dev_priv, int pin);
 extern void intel_gmbus_set_speed(struct i2c_adapter *adapter, int speed);
 extern void intel_gmbus_force_bit(struct i2c_adapter *adapter, bool force_bit);
 extern inline bool intel_gmbus_is_forced_bit(struct i2c_adapter *adapter)
diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index 63880e2..16456f7 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -330,12 +330,14 @@ parse_general_definitions(struct drm_i915_private *dev_priv,
 		u16 block_size = get_blocksize(general);
 		if (block_size >= sizeof(*general)) {
 			int bus_pin = general->crt_ddc_gmbus_pin;
+			struct i2c_adapter *i2c;
 			DRM_DEBUG_KMS("crt_ddc_bus_pin: %d\n", bus_pin);
-			if (bus_pin >= 1 && bus_pin <= 6)
-				dev_priv->crt_ddc_pin = bus_pin;
+			i2c = intel_gmbus_get_bus(dev_priv, bus_pin);
+			if (i2c)
+				dev_priv->crt_ddc = i2c;
 		} else {
 			DRM_DEBUG_KMS("BDB_GD too small (%d). Invalid.\n",
-				  block_size);
+				      block_size);
 		}
 	}
 }
@@ -599,7 +601,7 @@ init_vbt_defaults(struct drm_i915_private *dev_priv)
 {
 	struct drm_device *dev = dev_priv->dev;
 
-	dev_priv->crt_ddc_pin = GMBUS_PORT_VGADDC;
+	dev_priv->crt_ddc = intel_gmbus_get_bus(dev_priv, GMBUS_PORT_VGADDC);
 
 	/* LFP panel data */
 	dev_priv->lvds_dither = 1;
diff --git a/drivers/gpu/drm/i915/intel_crt.c b/drivers/gpu/drm/i915/intel_crt.c
index dd729d4..71d6a50 100644
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -275,12 +275,11 @@ static bool intel_crt_detect_ddc(struct drm_connector *connector)
 	if (crt->base.type != INTEL_OUTPUT_ANALOG)
 		return false;
 
-	if (intel_ddc_probe(&crt->base, dev_priv->crt_ddc_pin)) {
+	if (intel_ddc_probe(&crt->base, dev_priv->crt_ddc)) {
 		struct edid *edid;
 		bool is_digital = false;
 
-		edid = drm_get_edid(connector,
-			&dev_priv->gmbus[dev_priv->crt_ddc_pin].adapter);
+		edid = drm_get_edid(connector, dev_priv->crt_ddc);
 		/*
 		 * This may be a DVI-I connector with a shared DDC
 		 * link between analog and digital outputs, so we
@@ -484,14 +483,14 @@ static int intel_crt_get_modes(struct drm_connector *connector)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int ret;
 
-	ret = intel_ddc_get_modes(connector,
-				 &dev_priv->gmbus[dev_priv->crt_ddc_pin].adapter);
+	ret = intel_ddc_get_modes(connector, dev_priv->crt_ddc);
 	if (ret || !IS_G4X(dev))
 		return ret;
 
 	/* Try to probe digital port for output in DVI-I -> VGA mode. */
-	return intel_ddc_get_modes(connector,
-				   &dev_priv->gmbus[GMBUS_PORT_DPB].adapter);
+	return intel_ddc_get_modes(
+			connector,
+			intel_gmbus_get_bus(dev_priv, GMBUS_PORT_DPB));
 }
 
 static int intel_crt_set_property(struct drm_connector *connector,
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 1348705..7538f2e 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -285,7 +285,8 @@ struct intel_fbc_work {
 };
 
 int intel_ddc_get_modes(struct drm_connector *c, struct i2c_adapter *adapter);
-extern bool intel_ddc_probe(struct intel_encoder *intel_encoder, int ddc_bus);
+extern bool intel_ddc_probe(struct intel_encoder *intel_encoder,
+			    struct i2c_adapter *adapter);
 
 extern void intel_attach_force_audio_property(struct drm_connector *connector);
 extern void intel_attach_broadcast_rgb_property(struct drm_connector *connector);
diff --git a/drivers/gpu/drm/i915/intel_dvo.c b/drivers/gpu/drm/i915/intel_dvo.c
index 6eda1b5..5c2174b 100644
--- a/drivers/gpu/drm/i915/intel_dvo.c
+++ b/drivers/gpu/drm/i915/intel_dvo.c
@@ -244,7 +244,7 @@ static int intel_dvo_get_modes(struct drm_connector *connector)
 	 * that's not the case.
 	 */
 	intel_ddc_get_modes(connector,
-			    &dev_priv->gmbus[GMBUS_PORT_DPC].adapter);
+			    intel_gmbus_get_bus(dev_priv, GMBUS_PORT_DPC));
 	if (!list_empty(&connector->probed_modes))
 		return 1;
 
@@ -387,7 +387,7 @@ void intel_dvo_init(struct drm_device *dev)
 		 * It appears that everything is on GPIOE except for panels
 		 * on i830 laptops, which are on GPIOB (DVOA).
 		 */
-		i2c = &dev_priv->gmbus[gpio].adapter;
+		i2c = intel_gmbus_get_bus(dev_priv, gpio);
 
 		intel_dvo->dev = *dvo;
 		if (!dvo->dev_ops->init(&intel_dvo->dev, i2c))
diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel_hdmi.c
index 64541f7..87015bf 100644
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -40,7 +40,7 @@
 struct intel_hdmi {
 	struct intel_encoder base;
 	u32 sdvox_reg;
-	int ddc_bus;
+	struct i2c_adapter *ddc_bus;
 	uint32_t color_range;
 	bool has_hdmi_sink;
 	bool has_audio;
@@ -327,14 +327,12 @@ static enum drm_connector_status
 intel_hdmi_detect(struct drm_connector *connector, bool force)
 {
 	struct intel_hdmi *intel_hdmi = intel_attached_hdmi(connector);
-	struct drm_i915_private *dev_priv = connector->dev->dev_private;
 	struct edid *edid;
 	enum drm_connector_status status = connector_status_disconnected;
 
 	intel_hdmi->has_hdmi_sink = false;
 	intel_hdmi->has_audio = false;
-	edid = drm_get_edid(connector,
-			    &dev_priv->gmbus[intel_hdmi->ddc_bus].adapter);
+	edid = drm_get_edid(connector, intel_hdmi->ddc_bus);
 
 	if (edid) {
 		if (edid->input & DRM_EDID_INPUT_DIGITAL) {
@@ -357,26 +355,22 @@ intel_hdmi_detect(struct drm_connector *connector, bool force)
 static int intel_hdmi_get_modes(struct drm_connector *connector)
 {
 	struct intel_hdmi *intel_hdmi = intel_attached_hdmi(connector);
-	struct drm_i915_private *dev_priv = connector->dev->dev_private;
 
 	/* We should parse the EDID data and find out if it's an HDMI sink so
 	 * we can send audio to it.
 	 */
 
-	return intel_ddc_get_modes(connector,
-				   &dev_priv->gmbus[intel_hdmi->ddc_bus].adapter);
+	return intel_ddc_get_modes(connector, intel_hdmi->ddc_bus);
 }
 
 static bool
 intel_hdmi_detect_audio(struct drm_connector *connector)
 {
 	struct intel_hdmi *intel_hdmi = intel_attached_hdmi(connector);
-	struct drm_i915_private *dev_priv = connector->dev->dev_private;
 	struct edid *edid;
 	bool has_audio = false;
 
-	edid = drm_get_edid(connector,
-			    &dev_priv->gmbus[intel_hdmi->ddc_bus].adapter);
+	edid = drm_get_edid(connector, intel_hdmi->ddc_bus);
 	if (edid) {
 		if (edid->input & DRM_EDID_INPUT_DIGITAL)
 			has_audio = drm_detect_monitor_audio(edid);
@@ -521,23 +515,28 @@ void intel_hdmi_init(struct drm_device *dev, int sdvox_reg)
 	/* Set up the DDC bus. */
 	if (sdvox_reg == SDVOB) {
 		intel_encoder->clone_mask = (1 << INTEL_HDMIB_CLONE_BIT);
-		intel_hdmi->ddc_bus = GMBUS_PORT_DPB;
+		intel_hdmi->ddc_bus = intel_gmbus_get_bus(dev_priv,
+							  GMBUS_PORT_DPB);
 		dev_priv->hotplug_supported_mask |= HDMIB_HOTPLUG_INT_STATUS;
 	} else if (sdvox_reg == SDVOC) {
 		intel_encoder->clone_mask = (1 << INTEL_HDMIC_CLONE_BIT);
-		intel_hdmi->ddc_bus = GMBUS_PORT_DPC;
+		intel_hdmi->ddc_bus = intel_gmbus_get_bus(dev_priv,
+							  GMBUS_PORT_DPC);
 		dev_priv->hotplug_supported_mask |= HDMIC_HOTPLUG_INT_STATUS;
 	} else if (sdvox_reg == HDMIB) {
 		intel_encoder->clone_mask = (1 << INTEL_HDMID_CLONE_BIT);
-		intel_hdmi->ddc_bus = GMBUS_PORT_DPB;
+		intel_hdmi->ddc_bus = intel_gmbus_get_bus(dev_priv,
+							  GMBUS_PORT_DPB);
 		dev_priv->hotplug_supported_mask |= HDMIB_HOTPLUG_INT_STATUS;
 	} else if (sdvox_reg == HDMIC) {
 		intel_encoder->clone_mask = (1 << INTEL_HDMIE_CLONE_BIT);
-		intel_hdmi->ddc_bus = GMBUS_PORT_DPC;
+		intel_hdmi->ddc_bus = intel_gmbus_get_bus(dev_priv,
+							  GMBUS_PORT_DPC);
 		dev_priv->hotplug_supported_mask |= HDMIC_HOTPLUG_INT_STATUS;
 	} else if (sdvox_reg == HDMID) {
 		intel_encoder->clone_mask = (1 << INTEL_HDMIF_CLONE_BIT);
-		intel_hdmi->ddc_bus = GMBUS_PORT_DPD;
+		intel_hdmi->ddc_bus = intel_gmbus_get_bus(dev_priv,
+							  GMBUS_PORT_DPD);
 		dev_priv->hotplug_supported_mask |= HDMID_HOTPLUG_INT_STATUS;
 	}
 
diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 45ce1d2..dd8c699 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -427,6 +427,12 @@ err:
 	return ret;
 }
 
+struct i2c_adapter *intel_gmbus_get_bus(struct drm_i915_private *dev_priv,
+					int pin)
+{
+	return (pin < GMBUS_NUM_PORTS) ? &dev_priv->gmbus[pin].adapter : NULL;
+}
+
 void intel_gmbus_set_speed(struct i2c_adapter *adapter, int speed)
 {
 	struct intel_gmbus *bus = to_intel_gmbus(adapter);
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index aa84832..735e024 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -948,7 +948,7 @@ bool intel_lvds_init(struct drm_device *dev)
 	 * preferred mode is the right one.
 	 */
 	intel_lvds->edid = drm_get_edid(connector,
-					&dev_priv->gmbus[pin].adapter);
+					intel_gmbus_get_bus(dev_priv, pin));
 	if (intel_lvds->edid) {
 		if (drm_add_edid_modes(connector,
 				       intel_lvds->edid)) {
diff --git a/drivers/gpu/drm/i915/intel_modes.c b/drivers/gpu/drm/i915/intel_modes.c
index be2c6fe..095c1ae 100644
--- a/drivers/gpu/drm/i915/intel_modes.c
+++ b/drivers/gpu/drm/i915/intel_modes.c
@@ -35,9 +35,9 @@
  * intel_ddc_probe
  *
  */
-bool intel_ddc_probe(struct intel_encoder *intel_encoder, int ddc_bus)
+bool intel_ddc_probe(struct intel_encoder *intel_encoder,
+		     struct i2c_adapter *ddc_bus)
 {
-	struct drm_i915_private *dev_priv = intel_encoder->base.dev->dev_private;
 	u8 out_buf[] = { 0x0, 0x0};
 	u8 buf[2];
 	struct i2c_msg msgs[] = {
@@ -55,7 +55,7 @@ bool intel_ddc_probe(struct intel_encoder *intel_encoder, int ddc_bus)
 		}
 	};
 
-	return i2c_transfer(&dev_priv->gmbus[ddc_bus].adapter, msgs, 2) == 2;
+	return i2c_transfer(ddc_bus, msgs, 2) == 2;
 }
 
 /**
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index e334ec3..41f2a66 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1251,9 +1251,7 @@ static struct edid *
 intel_sdvo_get_analog_edid(struct drm_connector *connector)
 {
 	struct drm_i915_private *dev_priv = connector->dev->dev_private;
-
-	return drm_get_edid(connector,
-			    &dev_priv->gmbus[dev_priv->crt_ddc_pin].adapter);
+	return drm_get_edid(connector, dev_priv->crt_ddc);
 }
 
 enum drm_connector_status
@@ -1921,12 +1919,12 @@ intel_sdvo_select_i2c_bus(struct drm_i915_private *dev_priv,
 	if (mapping->initialized)
 		pin = mapping->i2c_pin;
 
-	if (pin < GMBUS_NUM_PORTS) {
-		sdvo->i2c = &dev_priv->gmbus[pin].adapter;
+	sdvo->i2c = intel_gmbus_get_bus(dev_priv, pin);
+	if (sdvo->i2c) {
 		intel_gmbus_set_speed(sdvo->i2c, GMBUS_RATE_1MHZ);
 		intel_gmbus_force_bit(sdvo->i2c, true);
 	} else {
-		sdvo->i2c = &dev_priv->gmbus[GMBUS_PORT_DPB].adapter;
+		sdvo->i2c = intel_gmbus_get_bus(dev_priv, GMBUS_PORT_DPB);
 	}
 }
 
-- 
1.7.7.3

