Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab0KSPzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:55:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab0KSPzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:55:31 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rpurdie@rpsys.net, akpm@linux-foundation.org,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        lenb@kernel.org, =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/5] radeon: Expose backlight class device for legacy LVDS encoder
Date: Fri, 19 Nov 2010 10:53:54 -0500
Message-Id: <1290182036-30484-3-git-send-email-mjg@redhat.com>
In-Reply-To: <1290182036-30484-1-git-send-email-mjg@redhat.com>
References: <1290182036-30484-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel Dänzer <michel@daenzer.net>

Allows e.g. power management daemons to control the backlight level. Inspired
by the corresponding code in radeonfb.

(Updated to add backlight type and make the connector the parent device - mjg)

Signed-off-by: Michel Dänzer <daenzer@vmware.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/radeon/Kconfig                  |    1 +
 drivers/gpu/drm/radeon/radeon_connectors.c      |   15 ++
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |  257 ++++++++++++++++++++++-
 drivers/gpu/drm/radeon/radeon_mode.h            |   10 +
 4 files changed, 277 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/Kconfig b/drivers/gpu/drm/radeon/Kconfig
index 1c02d23..9746fee 100644
--- a/drivers/gpu/drm/radeon/Kconfig
+++ b/drivers/gpu/drm/radeon/Kconfig
@@ -1,6 +1,7 @@
 config DRM_RADEON_KMS
 	bool "Enable modesetting on radeon by default - NEW DRIVER"
 	depends on DRM_RADEON
+	select BACKLIGHT_CLASS_DEVICE
 	help
 	  Choose this option if you want kernel modesetting enabled by default.
 
diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index fe6c747..d20bc76 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -40,6 +40,10 @@ radeon_atombios_connected_scratch_regs(struct drm_connector *connector,
 				       struct drm_encoder *encoder,
 				       bool connected);
 
+extern void
+radeon_legacy_backlight_init(struct radeon_encoder *radeon_encoder,
+			     struct drm_connector *drm_connector);
+
 void radeon_connector_hotplug(struct drm_connector *connector)
 {
 	struct drm_device *dev = connector->dev;
@@ -1462,6 +1466,17 @@ radeon_add_legacy_connector(struct drm_device *dev,
 		connector->polled = DRM_CONNECTOR_POLL_HPD;
 	connector->display_info.subpixel_order = subpixel_order;
 	drm_sysfs_connector_add(connector);
+	if (connector_type == DRM_MODE_CONNECTOR_LVDS) {
+		struct drm_encoder *drm_encoder;
+
+		list_for_each_entry(drm_encoder, &dev->mode_config.encoder_list, head) {
+			struct radeon_encoder *radeon_encoder;
+
+			radeon_encoder = to_radeon_encoder(drm_encoder);
+			if (radeon_encoder->encoder_id == ENCODER_OBJECT_ID_INTERNAL_LVDS)
+				radeon_legacy_backlight_init(radeon_encoder, connector);
+		}
+	}
 	return;
 
 failed:
diff --git a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
index 0b83970..bdca317 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -28,6 +28,10 @@
 #include "radeon_drm.h"
 #include "radeon.h"
 #include "atom.h"
+#include <linux/backlight.h>
+#ifdef CONFIG_PMAC_BACKLIGHT
+#include <asm/backlight.h>
+#endif
 
 static void radeon_legacy_encoder_disable(struct drm_encoder *encoder)
 {
@@ -39,7 +43,7 @@ static void radeon_legacy_encoder_disable(struct drm_encoder *encoder)
 	radeon_encoder->active_device = 0;
 }
 
-static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int mode)
+static void radeon_legacy_lvds_update(struct drm_encoder *encoder, int mode)
 {
 	struct drm_device *dev = encoder->dev;
 	struct radeon_device *rdev = dev->dev_private;
@@ -47,15 +51,23 @@ static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int mode)
 	uint32_t lvds_gen_cntl, lvds_pll_cntl, pixclks_cntl, disp_pwr_man;
 	int panel_pwr_delay = 2000;
 	bool is_mac = false;
+	uint8_t backlight_level;
 	DRM_DEBUG_KMS("\n");
 
+	lvds_gen_cntl = RREG32(RADEON_LVDS_GEN_CNTL);
+	backlight_level = (lvds_gen_cntl >> RADEON_LVDS_BL_MOD_LEVEL_SHIFT) & 0xff;
+
 	if (radeon_encoder->enc_priv) {
 		if (rdev->is_atom_bios) {
 			struct radeon_encoder_atom_dig *lvds = radeon_encoder->enc_priv;
 			panel_pwr_delay = lvds->panel_pwr_delay;
+			if (lvds->bl_dev)
+				backlight_level = lvds->backlight_level;
 		} else {
 			struct radeon_encoder_lvds *lvds = radeon_encoder->enc_priv;
 			panel_pwr_delay = lvds->panel_pwr_delay;
+			if (lvds->bl_dev)
+				backlight_level = lvds->backlight_level;
 		}
 	}
 
@@ -82,11 +94,13 @@ static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int mode)
 		lvds_pll_cntl &= ~RADEON_LVDS_PLL_RESET;
 		WREG32(RADEON_LVDS_PLL_CNTL, lvds_pll_cntl);
 
-		lvds_gen_cntl = RREG32(RADEON_LVDS_GEN_CNTL);
-		lvds_gen_cntl |= (RADEON_LVDS_ON | RADEON_LVDS_EN | RADEON_LVDS_DIGON | RADEON_LVDS_BLON);
+		lvds_gen_cntl &= ~(RADEON_LVDS_DISPLAY_DIS |
+				   RADEON_LVDS_BL_MOD_LEVEL_MASK);
+		lvds_gen_cntl |= (RADEON_LVDS_ON | RADEON_LVDS_EN |
+				  RADEON_LVDS_DIGON | RADEON_LVDS_BLON |
+				  (backlight_level << RADEON_LVDS_BL_MOD_LEVEL_SHIFT));
 		if (is_mac)
 			lvds_gen_cntl |= RADEON_LVDS_BL_MOD_EN;
-		lvds_gen_cntl &= ~(RADEON_LVDS_DISPLAY_DIS);
 		udelay(panel_pwr_delay * 1000);
 		WREG32(RADEON_LVDS_GEN_CNTL, lvds_gen_cntl);
 		break;
@@ -95,7 +109,6 @@ static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int mode)
 	case DRM_MODE_DPMS_OFF:
 		pixclks_cntl = RREG32_PLL(RADEON_PIXCLKS_CNTL);
 		WREG32_PLL_P(RADEON_PIXCLKS_CNTL, 0, ~RADEON_PIXCLK_LVDS_ALWAYS_ONb);
-		lvds_gen_cntl = RREG32(RADEON_LVDS_GEN_CNTL);
 		lvds_gen_cntl |= RADEON_LVDS_DISPLAY_DIS;
 		if (is_mac) {
 			lvds_gen_cntl &= ~RADEON_LVDS_BL_MOD_EN;
@@ -119,6 +132,25 @@ static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int mode)
 
 }
 
+static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int mode)
+{
+	struct radeon_device *rdev = encoder->dev->dev_private;
+	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
+	DRM_DEBUG("\n");
+
+	if (radeon_encoder->enc_priv) {
+		if (rdev->is_atom_bios) {
+			struct radeon_encoder_atom_dig *lvds = radeon_encoder->enc_priv;
+			lvds->dpms_mode = mode;
+		} else {
+			struct radeon_encoder_lvds *lvds = radeon_encoder->enc_priv;
+			lvds->dpms_mode = mode;
+		}
+	}
+
+	radeon_legacy_lvds_update(encoder, mode);
+}
+
 static void radeon_legacy_lvds_prepare(struct drm_encoder *encoder)
 {
 	struct radeon_device *rdev = encoder->dev->dev_private;
@@ -237,9 +269,222 @@ static const struct drm_encoder_helper_funcs radeon_legacy_lvds_helper_funcs = {
 	.disable = radeon_legacy_encoder_disable,
 };
 
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+
+#define MAX_RADEON_LEVEL 0xFF
+
+struct radeon_backlight_privdata {
+	struct radeon_encoder *encoder;
+	uint8_t negative;
+};
+
+static uint8_t radeon_legacy_lvds_level(struct backlight_device *bd)
+{
+	struct radeon_backlight_privdata *pdata = bl_get_data(bd);
+	uint8_t level;
+
+	/* Convert brightness to hardware level */
+	if (bd->props.brightness < 0)
+		level = 0;
+	else if (bd->props.brightness > MAX_RADEON_LEVEL)
+		level = MAX_RADEON_LEVEL;
+	else
+		level = bd->props.brightness;
+
+	if (pdata->negative)
+		level = MAX_RADEON_LEVEL - level;
+
+	return level;
+}
+
+static int radeon_legacy_backlight_update_status(struct backlight_device *bd)
+{
+	struct radeon_backlight_privdata *pdata = bl_get_data(bd);
+	struct radeon_encoder *radeon_encoder = pdata->encoder;
+	struct drm_device *dev = radeon_encoder->base.dev;
+	struct radeon_device *rdev = dev->dev_private;
+	int dpms_mode = DRM_MODE_DPMS_ON;
+
+	if (radeon_encoder->enc_priv) {
+		if (rdev->is_atom_bios) {
+			struct radeon_encoder_atom_dig *lvds = radeon_encoder->enc_priv;
+			dpms_mode = lvds->dpms_mode;
+			lvds->backlight_level = radeon_legacy_lvds_level(bd);
+		} else {
+			struct radeon_encoder_lvds *lvds = radeon_encoder->enc_priv;
+			dpms_mode = lvds->dpms_mode;
+			lvds->backlight_level = radeon_legacy_lvds_level(bd);
+		}
+	}
+
+	if (bd->props.brightness > 0)
+		radeon_legacy_lvds_update(&radeon_encoder->base, dpms_mode);
+	else
+		radeon_legacy_lvds_update(&radeon_encoder->base, DRM_MODE_DPMS_OFF);
+
+	return 0;
+}
+
+static int radeon_legacy_backlight_get_brightness(struct backlight_device *bd)
+{
+	struct radeon_backlight_privdata *pdata = bl_get_data(bd);
+	struct radeon_encoder *radeon_encoder = pdata->encoder;
+	struct drm_device *dev = radeon_encoder->base.dev;
+	struct radeon_device *rdev = dev->dev_private;
+	uint8_t backlight_level;
+
+	backlight_level = (RREG32(RADEON_LVDS_GEN_CNTL) >>
+			   RADEON_LVDS_BL_MOD_LEVEL_SHIFT) & 0xff;
+
+	return pdata->negative ? MAX_RADEON_LEVEL - backlight_level : backlight_level;
+}
+
+static const struct backlight_ops radeon_backlight_ops = {
+	.get_brightness = radeon_legacy_backlight_get_brightness,
+	.update_status	= radeon_legacy_backlight_update_status,
+};
+
+void radeon_legacy_backlight_init(struct radeon_encoder *radeon_encoder,
+				  struct drm_connector *drm_connector)
+{
+	struct drm_device *dev = radeon_encoder->base.dev;
+	struct radeon_device *rdev = dev->dev_private;
+	struct backlight_device *bd;
+	struct backlight_properties props;
+	struct radeon_backlight_privdata *pdata;
+	uint8_t backlight_level;
+
+	if (!radeon_encoder->enc_priv)
+		return;
+
+#ifdef CONFIG_PMAC_BACKLIGHT
+	if (!pmac_has_backlight_type("ati") &&
+	    !pmac_has_backlight_type("mnca"))
+		return;
+#endif
+
+	pdata = kmalloc(sizeof(struct radeon_backlight_privdata), GFP_KERNEL);
+	if (!pdata) {
+		DRM_ERROR("Memory allocation failed\n");
+		goto error;
+	}
+
+	props.max_brightness = MAX_RADEON_LEVEL;
+	props.type = BACKLIGHT_RAW;
+	bd = backlight_device_register("radeon_bl", &drm_connector->kdev,
+				       pdata, &radeon_backlight_ops, &props);
+	if (IS_ERR(bd)) {
+		DRM_ERROR("Backlight registration failed\n");
+		goto error;
+	}
+
+	pdata->encoder = radeon_encoder;
+
+	backlight_level = (RREG32(RADEON_LVDS_GEN_CNTL) >>
+			   RADEON_LVDS_BL_MOD_LEVEL_SHIFT) & 0xff;
+
+	/* First, try to detect backlight level sense based on the assumption
+	 * that firmware set it up at full brightness
+	 */
+	if (backlight_level == 0)
+		pdata->negative = true;
+	else if (backlight_level == 0xff)
+		pdata->negative = false;
+	else {
+		/* XXX hack... maybe some day we can figure out in what direction
+		 * backlight should work on a given panel?
+		 */
+		pdata->negative = (rdev->family != CHIP_RV200 &&
+				   rdev->family != CHIP_RV250 &&
+				   rdev->family != CHIP_RV280 &&
+				   rdev->family != CHIP_RV350);
+
+#ifdef CONFIG_PMAC_BACKLIGHT
+		pdata->negative = (pdata->negative ||
+				   of_machine_is_compatible("PowerBook4,3") ||
+				   of_machine_is_compatible("PowerBook6,3") ||
+				   of_machine_is_compatible("PowerBook6,5"));
+#endif
+	}
+
+	if (rdev->is_atom_bios) {
+		struct radeon_encoder_atom_dig *lvds = radeon_encoder->enc_priv;
+		lvds->bl_dev = bd;
+	} else {
+		struct radeon_encoder_lvds *lvds = radeon_encoder->enc_priv;
+		lvds->bl_dev = bd;
+	}
+
+	bd->props.brightness = radeon_legacy_backlight_get_brightness(bd);
+	bd->props.power = FB_BLANK_UNBLANK;
+	backlight_update_status(bd);
+
+	DRM_INFO("radeon legacy LVDS backlight initialized\n");
+
+	return;
+
+error:
+	kfree(pdata);
+	return;
+}
+
+static void radeon_legacy_backlight_exit(struct radeon_encoder *radeon_encoder)
+{
+	struct drm_device *dev = radeon_encoder->base.dev;
+	struct radeon_device *rdev = dev->dev_private;
+	struct backlight_device *bd = NULL;
+
+	if (!radeon_encoder->enc_priv)
+		return;
+
+	if (rdev->is_atom_bios) {
+		struct radeon_encoder_atom_dig *lvds = radeon_encoder->enc_priv;
+		bd = lvds->bl_dev;
+		lvds->bl_dev = NULL;
+	} else {
+		struct radeon_encoder_lvds *lvds = radeon_encoder->enc_priv;
+		bd = lvds->bl_dev;
+		lvds->bl_dev = NULL;
+	}
+
+	if (bd) {
+		struct radeon_legacy_backlight_privdata *pdata;
+
+		pdata = bl_get_data(bd);
+		backlight_device_unregister(bd);
+		kfree(pdata);
+
+		DRM_INFO("radeon legacy LVDS backlight unloaded\n");
+	}
+}
+
+#else /* !CONFIG_BACKLIGHT_CLASS_DEVICE */
+
+static void radeon_legacy_backlight_init(struct radeon_encoder *encoder)
+{
+}
+
+static void radeon_legacy_backlight_exit(struct radeon_encoder *encoder)
+{
+}
+
+#endif
+
+
+static void radeon_lvds_enc_destroy(struct drm_encoder *encoder)
+{
+	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
+
+	if (radeon_encoder->enc_priv) {
+		radeon_legacy_backlight_exit(radeon_encoder);
+		kfree(radeon_encoder->enc_priv);
+	}
+	drm_encoder_cleanup(encoder);
+	kfree(radeon_encoder);
+}
 
 static const struct drm_encoder_funcs radeon_legacy_lvds_enc_funcs = {
-	.destroy = radeon_enc_destroy,
+	.destroy = radeon_lvds_enc_destroy,
 };
 
 static void radeon_legacy_primary_dac_dpms(struct drm_encoder *encoder, int mode)
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index 680f576..994f297 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -297,6 +297,11 @@ struct radeon_encoder_lvds {
 	uint32_t lvds_gen_cntl;
 	/* panel mode */
 	struct drm_display_mode native_mode;
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+	struct backlight_device *bl_dev;
+	int      dpms_mode;
+	uint8_t  backlight_level;
+#endif
 };
 
 struct radeon_encoder_tv_dac {
@@ -350,6 +355,11 @@ struct radeon_encoder_atom_dig {
 	uint32_t lcd_ss_id;
 	/* panel mode */
 	struct drm_display_mode native_mode;
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+	struct backlight_device *bl_dev;
+	int dpms_mode;
+	uint8_t backlight_level;
+#endif
 };
 
 struct radeon_encoder_atom_dac {
-- 
1.7.3.2

