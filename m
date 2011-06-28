Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1F1WJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:09:19 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41014 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab1F1WJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:09:10 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 24/29] gma500: continue abstracting platform specific code
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:08:45 +0100
Message-ID: <20110628220843.898.72588.stgit@bob.linux.org.uk>
In-Reply-To: <20110628220151.898.15775.stgit@bob.linux.org.uk>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Next obvious target - backlight support

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Makefile           |    2 
 drivers/staging/gma500/backlight.c        |   46 +++++
 drivers/staging/gma500/mdfld_device.c     |   94 ++++++++++
 drivers/staging/gma500/mdfld_dsi_output.c |   11 +
 drivers/staging/gma500/mrst_device.c      |  137 ++++++++++++++
 drivers/staging/gma500/psb_bl.c           |  283 -----------------------------
 drivers/staging/gma500/psb_device.c       |  125 +++++++++++++
 drivers/staging/gma500/psb_drv.c          |   20 +-
 drivers/staging/gma500/psb_drv.h          |   15 +-
 drivers/staging/gma500/psb_intel_lvds.c   |   31 ++-
 10 files changed, 445 insertions(+), 319 deletions(-)
 create mode 100644 drivers/staging/gma500/backlight.c
 delete mode 100644 drivers/staging/gma500/psb_bl.c


diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index e93cbe3..dc02b2f 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -4,8 +4,8 @@
 ccflags-y += -Iinclude/drm
 
 psb_gfx-y += gem_glue.o \
+	  backlight.o \
 	  power.o \
-	  psb_bl.o \
 	  psb_drv.o \
 	  psb_gem.o \
 	  psb_fb.o \
diff --git a/drivers/staging/gma500/backlight.c b/drivers/staging/gma500/backlight.c
new file mode 100644
index 0000000..47681c9
--- /dev/null
+++ b/drivers/staging/gma500/backlight.c
@@ -0,0 +1,46 @@
+/*
+ * GMA500 Backlight Interface
+ *
+ * Copyright (c) 2009-2011, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors: Eric Knopp
+ *
+ */
+
+#include "psb_drv.h"
+#include "psb_intel_reg.h"
+#include "psb_intel_drv.h"
+#include "psb_intel_bios.h"
+#include "psb_powermgmt.h"
+
+int gma_backlight_init(struct drm_device *dev)
+{
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	return dev_priv->ops->backlight_init(dev);
+#endif
+}
+
+void gma_backlight_exit(struct drm_device *dev)
+{
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	dev_priv->backlight_device->props.brightness = 0;
+	backlight_update_status(dev_priv->backlight_device);
+	if (dev_priv->backlight_device)
+		backlight_device_unregister(dev_priv->backlight_device);
+#endif
+}
diff --git a/drivers/staging/gma500/mdfld_device.c b/drivers/staging/gma500/mdfld_device.c
index 7caa7cd..e86e476 100644
--- a/drivers/staging/gma500/mdfld_device.c
+++ b/drivers/staging/gma500/mdfld_device.c
@@ -17,6 +17,7 @@
  *
  **************************************************************************/
 
+#include <linux/backlight.h>
 #include <drm/drmP.h>
 #include <drm/drm.h>
 #include "psb_reg.h"
@@ -27,7 +28,93 @@
 #include "mdfld_dsi_output.h"
 
 /*
- *	Provide the Medfield specific chip logic and low level methods
+ *	Provide the Medfield specific backlight management
+ */
+
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+
+static int mdfld_brightness;
+struct backlight_device *mdfld_backlight_device;
+
+static int mfld_set_brightness(struct backlight_device *bd)
+{
+	struct drm_device *dev = bl_get_data(mdfld_backlight_device);
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int level = bd->props.brightness;
+
+	/* Percentage 1-100% being valid */
+	if (level < 1)
+		level = 1;
+
+	if (gma_power_begin(dev, 0)) {
+		/* Calculate and set the brightness value */
+		u32 adjusted_level;
+
+		/* Adjust the backlight level with the percent in
+		 * dev_priv->blc_adj2;
+		 */
+		adjusted_level = level * dev_priv->blc_adj2;
+		adjusted_level = adjusted_level / 100;
+#if 0
+#ifndef CONFIG_MDFLD_DSI_DPU
+		if(!(dev_priv->dsr_fb_update & MDFLD_DSR_MIPI_CONTROL) && 
+			(dev_priv->dbi_panel_on || dev_priv->dbi_panel_on2)){
+			mdfld_dsi_dbi_exit_dsr(dev,MDFLD_DSR_MIPI_CONTROL, 0, 0);
+			dev_dbg(dev->dev, "Out of DSR before set brightness to %d.\n",adjusted_level);
+		}
+#endif
+		mdfld_dsi_brightness_control(dev, 0, adjusted_level);
+
+		if ((dev_priv->dbi_panel_on2) || (dev_priv->dpi_panel_on2))
+			mdfld_dsi_brightness_control(dev, 2, adjusted_level);
+#endif
+		gma_power_end(dev);
+	}
+	mdfld_brightness = level;
+	return 0;
+}
+
+int psb_get_brightness(struct backlight_device *bd)
+{
+	/* return locally cached var instead of HW read (due to DPST etc.) */
+	/* FIXME: ideally return actual value in case firmware fiddled with
+	   it */
+	return mdfld_brightness;
+}
+
+static const struct backlight_ops mfld_ops = {
+	.get_brightness = psb_get_brightness,
+	.update_status  = mfld_set_brightness,
+};
+
+static int mdfld_backlight_init(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct backlight_properties props;
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = 100;
+	props.type = BACKLIGHT_PLATFORM;
+
+	mdfld_backlight_device = backlight_device_register("mfld-bl",
+					NULL, (void *)dev, &mfld_ops, &props);
+					
+	if (IS_ERR(mdfld_backlight_device))
+		return PTR_ERR(mdfld_backlight_device);
+
+	dev_priv->blc_adj1 = 100;
+	dev_priv->blc_adj2 = 100;
+	mdfld_backlight_device->props.brightness = 100;
+	mdfld_backlight_device->props.max_brightness = 100;
+	backlight_update_status(mdfld_backlight_device);
+	dev_priv->backlight_device = mdfld_backlight_device;
+	return 0;
+}
+
+#endif
+
+/*
+ *	Provide the Medfield specific chip logic and low level methods for
+ *	power management.
  */
 
 static void mdfld_init_pm(struct drm_device *dev)
@@ -601,6 +688,11 @@ static int mdfld_power_up(struct drm_device *dev)
 
 const struct psb_ops mdfld_chip_ops = {
 	.output_init = mdfld_output_init,
+
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+	.backlight_init = mdfld_backlight_init,
+#endif
+
 	.init_pm = mdfld_init_pm,
 	.save_regs = mdfld_save_registers,
 	.restore_regs = mdfld_restore_registers,
diff --git a/drivers/staging/gma500/mdfld_dsi_output.c b/drivers/staging/gma500/mdfld_dsi_output.c
index 44ee3f6..b88dfc2 100644
--- a/drivers/staging/gma500/mdfld_dsi_output.c
+++ b/drivers/staging/gma500/mdfld_dsi_output.c
@@ -468,6 +468,7 @@ static int mdfld_dsi_connector_set_property(struct drm_connector * connector,
 {
 	struct drm_encoder * encoder = connector->encoder;
 	struct backlight_device * psb_bd;
+	struct drm_psb_private * dev_priv = encoder->dev->dev_private;
 
 	if (!strcmp(property->name, "scaling mode") && encoder) {
 		struct psb_intel_crtc * psb_crtc = to_psb_intel_crtc(encoder->crtc);
@@ -512,6 +513,7 @@ static int mdfld_dsi_connector_set_property(struct drm_connector * connector,
 						     &psb_crtc->saved_adjusted_mode);
 			}
 		}
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
 	} else if (!strcmp(property->name, "backlight") && encoder) {
 		dev_dbg(encoder->dev->dev, "backlight level = %d\n", (int)value);
 		if (drm_connector_property_set_value(connector, property, value))
@@ -519,20 +521,21 @@ static int mdfld_dsi_connector_set_property(struct drm_connector * connector,
 		else {
 			dev_dbg(encoder->dev->dev,
 			                "set brightness to %d", (int)value);
-			psb_bd = psb_get_backlight_device();
-			if(psb_bd) {
+			psb_bd = dev_priv->backlight_device;
+			if (psb_bd) {
 				psb_bd->props.brightness = value;
-				psb_set_brightness(psb_bd);
+				backlight_update_status(psb_bd);
 			}
 		}
 	} 
+#endif
 set_prop_done:
     return 0;
 set_prop_error:
     return -1;
 }
 
-static void mdfld_dsi_connector_destroy(struct drm_connector * connector)
+static void mdfld_dsi_connector_destroy(struct drm_connector *connector)
 {
 	struct psb_intel_output * psb_output = to_psb_intel_output(connector);
 	struct mdfld_dsi_connector * dsi_connector = MDFLD_DSI_CONNECTOR(psb_output);
diff --git a/drivers/staging/gma500/mrst_device.c b/drivers/staging/gma500/mrst_device.c
index 5cd8283..daeeb18 100644
--- a/drivers/staging/gma500/mrst_device.c
+++ b/drivers/staging/gma500/mrst_device.c
@@ -17,6 +17,7 @@
  *
  **************************************************************************/
 
+#include <linux/backlight.h>
 #include <drm/drmP.h>
 #include <drm/drm.h>
 #include "psb_drm.h"
@@ -42,7 +43,138 @@ static int mrst_output_init(struct drm_device *dev)
 }
 
 /*
+ *	Provide the low level interfaces for the Moorestown backlight
+ */
+
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+
+#define MRST_BLC_MAX_PWM_REG_FREQ	    0xFFFF
+#define BLC_PWM_PRECISION_FACTOR 100	/* 10000000 */
+#define BLC_PWM_FREQ_CALC_CONSTANT 32
+#define MHz 1000000
+#define BLC_ADJUSTMENT_MAX 100
+
+static struct backlight_device *mrst_backlight_device;
+static int mrst_brightness;
+
+static int mrst_set_brightness(struct backlight_device *bd)
+{
+	struct drm_device *dev = bl_get_data(mrst_backlight_device);
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int level = bd->props.brightness;
+	u32 blc_pwm_ctl;
+	u32 max_pwm_blc;
+
+	/* Percentage 1-100% being valid */
+	if (level < 1)
+		level = 1;
+
+	if (gma_power_begin(dev, 0)) {
+		/* Calculate and set the brightness value */
+		max_pwm_blc = REG_READ(BLC_PWM_CTL) >> 16;
+		blc_pwm_ctl = level * max_pwm_blc / 100;
+
+		/* Adjust the backlight level with the percent in
+		 * dev_priv->blc_adj1;
+		 */
+		blc_pwm_ctl = blc_pwm_ctl * dev_priv->blc_adj1;
+		blc_pwm_ctl = blc_pwm_ctl / 100;
+
+		/* Adjust the backlight level with the percent in
+		 * dev_priv->blc_adj2;
+		 */
+		blc_pwm_ctl = blc_pwm_ctl * dev_priv->blc_adj2;
+		blc_pwm_ctl = blc_pwm_ctl / 100;
+
+		/* force PWM bit on */
+		REG_WRITE(BLC_PWM_CTL2, (0x80000000 | REG_READ(BLC_PWM_CTL2)));
+		REG_WRITE(BLC_PWM_CTL, (max_pwm_blc << 16) | blc_pwm_ctl);
+		gma_power_end(dev);
+	}
+	mrst_brightness = level;
+	return 0;
+}
+
+static int mrst_get_brightness(struct backlight_device *bd)
+{
+	/* return locally cached var instead of HW read (due to DPST etc.) */
+	/* FIXME: ideally return actual value in case firmware fiddled with
+	   it */
+	return mrst_brightness;
+}
+
+static int device_backlight_init(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	unsigned long core_clock;
+	u16 bl_max_freq;
+	uint32_t value;
+	uint32_t blc_pwm_precision_factor;
+
+	dev_priv->blc_adj1 = BLC_ADJUSTMENT_MAX;
+	dev_priv->blc_adj2 = BLC_ADJUSTMENT_MAX;
+	bl_max_freq = 256;
+	/* this needs to be set elsewhere */
+	blc_pwm_precision_factor = BLC_PWM_PRECISION_FACTOR;
+
+	core_clock = dev_priv->core_freq;
+
+	value = (core_clock * MHz) / BLC_PWM_FREQ_CALC_CONSTANT;
+	value *= blc_pwm_precision_factor;
+	value /= bl_max_freq;
+	value /= blc_pwm_precision_factor;
+
+	if (gma_power_begin(dev, false)) {
+		if (value > (unsigned long long)MRST_BLC_MAX_PWM_REG_FREQ)
+				return -ERANGE;
+		else {
+			REG_WRITE(BLC_PWM_CTL2,
+					(0x80000000 | REG_READ(BLC_PWM_CTL2)));
+			REG_WRITE(BLC_PWM_CTL, value | (value << 16));
+		}
+		gma_power_end(dev);
+	}
+	return 0;
+}
+
+static const struct backlight_ops mrst_ops = {
+	.get_brightness = mrst_get_brightness,
+	.update_status  = mrst_set_brightness,
+};
+
+int mrst_backlight_init(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int ret;
+	struct backlight_properties props;
+
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = 100;
+	props.type = BACKLIGHT_PLATFORM;
+
+	mrst_backlight_device = backlight_device_register("mrst-bl",
+					NULL, (void *)dev, &mrst_ops, &props);
+					
+	if (IS_ERR(mrst_backlight_device))
+		return PTR_ERR(mrst_backlight_device);
+
+	ret = device_backlight_init(dev);
+	if (ret < 0) {
+		backlight_device_unregister(mrst_backlight_device);
+		return ret;
+	}
+	mrst_backlight_device->props.brightness = 100;
+	mrst_backlight_device->props.max_brightness = 100;
+	backlight_update_status(mrst_backlight_device);
+	dev_priv->backlight_device = mrst_backlight_device;
+	return 0;
+}
+
+#endif
+
+/*
  *	Provide the Moorestown specific chip logic and low level methods
+ *	for power management
  */
 
 static void mrst_init_pm(struct drm_device *dev)
@@ -221,6 +353,11 @@ static int mrst_power_up(struct drm_device *dev)
 
 const struct psb_ops mrst_chip_ops = {
 	.output_init = mrst_output_init,
+
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+	.backlight_init = mrst_backlight_init,
+#endif
+	
 	.init_pm = mrst_init_pm,
 	.save_regs = mrst_save_display_registers,
 	.restore_regs = mrst_restore_display_registers,
diff --git a/drivers/staging/gma500/psb_bl.c b/drivers/staging/gma500/psb_bl.c
deleted file mode 100644
index c84d261..0000000
--- a/drivers/staging/gma500/psb_bl.c
+++ /dev/null
@@ -1,283 +0,0 @@
-/*
- * GMA500 Backlight Interface
- *
- * Copyright (c) 2009-2011, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- *
- * Authors: Eric Knopp
- *
- */
-
-#include <linux/backlight.h>
-#include <linux/version.h>
-#include "psb_drv.h"
-#include "psb_intel_reg.h"
-#include "psb_intel_drv.h"
-#include "psb_intel_bios.h"
-#include "psb_powermgmt.h"
-
-#define MRST_BLC_MAX_PWM_REG_FREQ	    0xFFFF
-#define BLC_PWM_PRECISION_FACTOR 100	/* 10000000 */
-#define BLC_PWM_FREQ_CALC_CONSTANT 32
-#define MHz 1000000
-#define BRIGHTNESS_MIN_LEVEL 1
-#define BRIGHTNESS_MASK	0xFF
-#define BLC_POLARITY_NORMAL 0
-#define BLC_POLARITY_INVERSE 1
-#define BLC_ADJUSTMENT_MAX 100
-
-#define PSB_BLC_PWM_PRECISION_FACTOR    10
-#define PSB_BLC_MAX_PWM_REG_FREQ        0xFFFE
-#define PSB_BLC_MIN_PWM_REG_FREQ        0x2
-
-#define PSB_BACKLIGHT_PWM_POLARITY_BIT_CLEAR (0xFFFE)
-#define PSB_BACKLIGHT_PWM_CTL_SHIFT	(16)
-
-static int psb_brightness;
-static struct backlight_device *psb_backlight_device;
-static u8 blc_brightnesscmd;
-static u8 blc_pol;
-static u8 blc_type;
-
-int psb_set_brightness(struct backlight_device *bd)
-{
-	struct drm_device *dev = bl_get_data(psb_backlight_device);
-	int level = bd->props.brightness;
-
-	/* Percentage 1-100% being valid */
-	if (level < 1)
-		level = 1;
-
-	psb_intel_lvds_set_brightness(dev, level);
-	psb_brightness = level;
-	return 0;
-}
-
-int mrst_set_brightness(struct backlight_device *bd)
-{
-	struct drm_device *dev = bl_get_data(psb_backlight_device);
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	int level = bd->props.brightness;
-	u32 blc_pwm_ctl;
-	u32 max_pwm_blc;
-
-	/* Percentage 1-100% being valid */
-	if (level < 1)
-		level = 1;
-
-	if (gma_power_begin(dev, 0)) {
-		/* Calculate and set the brightness value */
-		max_pwm_blc = REG_READ(BLC_PWM_CTL) >> 16;
-		blc_pwm_ctl = level * max_pwm_blc / 100;
-
-		/* Adjust the backlight level with the percent in
-		 * dev_priv->blc_adj1;
-		 */
-		blc_pwm_ctl = blc_pwm_ctl * dev_priv->blc_adj1;
-		blc_pwm_ctl = blc_pwm_ctl / 100;
-
-		/* Adjust the backlight level with the percent in
-		 * dev_priv->blc_adj2;
-		 */
-		blc_pwm_ctl = blc_pwm_ctl * dev_priv->blc_adj2;
-		blc_pwm_ctl = blc_pwm_ctl / 100;
-
-		if (blc_pol == BLC_POLARITY_INVERSE)
-			blc_pwm_ctl = max_pwm_blc - blc_pwm_ctl;
-		/* force PWM bit on */
-		REG_WRITE(BLC_PWM_CTL2, (0x80000000 | REG_READ(BLC_PWM_CTL2)));
-		REG_WRITE(BLC_PWM_CTL, (max_pwm_blc << 16) | blc_pwm_ctl);
-		gma_power_end(dev);
-	}
-	psb_brightness = level;
-	return 0;
-}
-
-int mfld_set_brightness(struct backlight_device *bd)
-{
-	struct drm_device *dev = bl_get_data(psb_backlight_device);
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	int level = bd->props.brightness;
-
-	DRM_DEBUG_DRIVER("backlight level set to %d\n", level);
-
-	/* Percentage 1-100% being valid */
-	if (level < 1)
-		level = 1;
-
-	if (gma_power_begin(dev, 0)) {
-		/* Calculate and set the brightness value */
-		u32 adjusted_level;
-
-		/* Adjust the backlight level with the percent in
-		 * dev_priv->blc_adj2;
-		 */
-		adjusted_level = level * dev_priv->blc_adj2;
-		adjusted_level = adjusted_level / BLC_ADJUSTMENT_MAX;
-#if 0
-#ifndef CONFIG_MDFLD_DSI_DPU
-		if(!(dev_priv->dsr_fb_update & MDFLD_DSR_MIPI_CONTROL) && 
-			(dev_priv->dbi_panel_on || dev_priv->dbi_panel_on2)){
-			mdfld_dsi_dbi_exit_dsr(dev,MDFLD_DSR_MIPI_CONTROL, 0, 0);
-			dev_dbg(dev->dev, "Out of DSR before set brightness to %d.\n",adjusted_level);
-		}
-#endif
-		mdfld_dsi_brightness_control(dev, 0, adjusted_level);
-
-		if ((dev_priv->dbi_panel_on2) || (dev_priv->dpi_panel_on2))
-			mdfld_dsi_brightness_control(dev, 2, adjusted_level);
-#endif
-		gma_power_end(dev);
-	}
-	psb_brightness = level;
-	return 0;
-}
-
-int psb_get_brightness(struct backlight_device *bd)
-{
-	/* return locally cached var instead of HW read (due to DPST etc.) */
-	/* FIXME: ideally return actual value in case firmware fiddled with
-	   it */
-	return psb_brightness;
-}
-
-static const struct backlight_ops psb_ops = {
-	.get_brightness = psb_get_brightness,
-	.update_status  = psb_set_brightness,
-};
-
-static const struct backlight_ops mrst_ops = {
-	.get_brightness = psb_get_brightness,
-	.update_status  = mrst_set_brightness,
-};
-
-static const struct backlight_ops mfld_ops = {
-	.get_brightness = psb_get_brightness,
-	.update_status  = mfld_set_brightness,
-};
-
-static int device_backlight_init(struct drm_device *dev)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	unsigned long core_clock;
-	/* u32 bl_max_freq; */
-	/* unsigned long value; */
-	u16 bl_max_freq;
-	uint32_t value;
-	uint32_t blc_pwm_precision_factor;
-
-	if (IS_MFLD(dev)) {
-		dev_priv->blc_adj1 = BLC_ADJUSTMENT_MAX;
-		dev_priv->blc_adj2 = BLC_ADJUSTMENT_MAX;
-		return 0;
-	} else if (IS_MRST(dev)) {
-		dev_priv->blc_adj1 = BLC_ADJUSTMENT_MAX;
-		dev_priv->blc_adj2 = BLC_ADJUSTMENT_MAX;
-		bl_max_freq = 256;
-		/* this needs to be set elsewhere */
-		blc_pol = BLC_POLARITY_NORMAL;
-		blc_pwm_precision_factor = BLC_PWM_PRECISION_FACTOR;
-	} else {
-		/* get bl_max_freq and pol from dev_priv*/
-		if (!dev_priv->lvds_bl) {
-			dev_err(dev->dev, "Has no valid LVDS backlight info\n");
-			return 1;
-		}
-		bl_max_freq = dev_priv->lvds_bl->freq;
-		blc_pol = dev_priv->lvds_bl->pol;
-		blc_pwm_precision_factor = PSB_BLC_PWM_PRECISION_FACTOR;
-		blc_brightnesscmd = dev_priv->lvds_bl->brightnesscmd;
-		blc_type = dev_priv->lvds_bl->type;
-	}
-
-	core_clock = dev_priv->core_freq;
-
-	value = (core_clock * MHz) / BLC_PWM_FREQ_CALC_CONSTANT;
-	value *= blc_pwm_precision_factor;
-	value /= bl_max_freq;
-	value /= blc_pwm_precision_factor;
-
-	if (gma_power_begin(dev, false)) {
-		if (IS_MRST(dev)) {
-			if (value > (unsigned long long)MRST_BLC_MAX_PWM_REG_FREQ)
-				return 2;
-			else {
-				REG_WRITE(BLC_PWM_CTL2,
-					(0x80000000 | REG_READ(BLC_PWM_CTL2)));
-				REG_WRITE(BLC_PWM_CTL, value | (value << 16));
-			}
-		} else {
-			if (value > (unsigned long long)PSB_BLC_MAX_PWM_REG_FREQ ||
-			 value < (unsigned long long)PSB_BLC_MIN_PWM_REG_FREQ)
-				return 2;
-			else {
-				value &= PSB_BACKLIGHT_PWM_POLARITY_BIT_CLEAR;
-				REG_WRITE(BLC_PWM_CTL,
-					(value << PSB_BACKLIGHT_PWM_CTL_SHIFT) |
-					(value));
-			}
-		}
-		gma_power_end(dev);
-	}
-	return 0;
-}
-
-int psb_backlight_init(struct drm_device *dev)
-{
-#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
-	int ret = 0;
-
-	struct backlight_properties props;
-	memset(&props, 0, sizeof(struct backlight_properties));
-	props.max_brightness = 100;
-	props.type = BACKLIGHT_PLATFORM;
-
-	if (IS_MFLD(dev))
-		psb_backlight_device = backlight_device_register("mfld-bl",
-					NULL, (void *)dev, &mfld_ops, &props);
-	else if (IS_MRST(dev))
-		psb_backlight_device = backlight_device_register("mrst-bl",
-					NULL, (void *)dev, &psb_ops, &props);
-	else
-		psb_backlight_device = backlight_device_register("psb-bl",
-					NULL, (void *)dev, &psb_ops, &props);
-					
-	if (IS_ERR(psb_backlight_device))
-		return PTR_ERR(psb_backlight_device);
-
-	ret = device_backlight_init(dev);
-	if (ret < 0)
-		return ret;
-
-	psb_backlight_device->props.brightness = 100;
-	psb_backlight_device->props.max_brightness = 100;
-	backlight_update_status(psb_backlight_device);
-#endif
-	return 0;
-}
-
-void psb_backlight_exit(void)
-{
-#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
-	psb_backlight_device->props.brightness = 0;
-	backlight_update_status(psb_backlight_device);
-	backlight_device_unregister(psb_backlight_device);
-#endif
-}
-
-struct backlight_device *psb_get_backlight_device(void)
-{
-	return psb_backlight_device;
-}
diff --git a/drivers/staging/gma500/psb_device.c b/drivers/staging/gma500/psb_device.c
index 97e25ab..4a3c516 100644
--- a/drivers/staging/gma500/psb_device.c
+++ b/drivers/staging/gma500/psb_device.c
@@ -17,12 +17,15 @@
  *
  **************************************************************************/
 
+#include <linux/backlight.h>
 #include <drm/drmP.h>
 #include <drm/drm.h>
 #include "psb_drm.h"
 #include "psb_drv.h"
 #include "psb_reg.h"
 #include "psb_intel_reg.h"
+#include "psb_intel_bios.h"
+
 
 static int psb_output_init(struct drm_device *dev)
 {
@@ -32,8 +35,123 @@ static int psb_output_init(struct drm_device *dev)
 	return 0;
 }
 
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+
+/*
+ *	Poulsbo Backlight Interfaces
+ */
+
+#define BLC_PWM_PRECISION_FACTOR 100	/* 10000000 */
+#define BLC_PWM_FREQ_CALC_CONSTANT 32
+#define MHz 1000000
+
+#define PSB_BLC_PWM_PRECISION_FACTOR    10
+#define PSB_BLC_MAX_PWM_REG_FREQ        0xFFFE
+#define PSB_BLC_MIN_PWM_REG_FREQ        0x2
+
+#define PSB_BACKLIGHT_PWM_POLARITY_BIT_CLEAR (0xFFFE)
+#define PSB_BACKLIGHT_PWM_CTL_SHIFT	(16)
+
+static int psb_brightness;
+static struct backlight_device *psb_backlight_device;
+
+static int psb_get_brightness(struct backlight_device *bd)
+{
+	/* return locally cached var instead of HW read (due to DPST etc.) */
+	/* FIXME: ideally return actual value in case firmware fiddled with
+	   it */
+	return psb_brightness;
+}
+
+
+static int psb_backlight_setup(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	unsigned long core_clock;
+	/* u32 bl_max_freq; */
+	/* unsigned long value; */
+	u16 bl_max_freq;
+	uint32_t value;
+	uint32_t blc_pwm_precision_factor;
+
+	/* get bl_max_freq and pol from dev_priv*/
+	if (!dev_priv->lvds_bl) {
+		dev_err(dev->dev, "Has no valid LVDS backlight info\n");
+		return -ENOENT;
+	}
+	bl_max_freq = dev_priv->lvds_bl->freq;
+	blc_pwm_precision_factor = PSB_BLC_PWM_PRECISION_FACTOR;
+
+	core_clock = dev_priv->core_freq;
+
+	value = (core_clock * MHz) / BLC_PWM_FREQ_CALC_CONSTANT;
+	value *= blc_pwm_precision_factor;
+	value /= bl_max_freq;
+	value /= blc_pwm_precision_factor;
+
+	if (value > (unsigned long long)PSB_BLC_MAX_PWM_REG_FREQ ||
+		 value < (unsigned long long)PSB_BLC_MIN_PWM_REG_FREQ)
+				return -ERANGE;
+	else {
+		value &= PSB_BACKLIGHT_PWM_POLARITY_BIT_CLEAR;
+		REG_WRITE(BLC_PWM_CTL,
+			(value << PSB_BACKLIGHT_PWM_CTL_SHIFT) | (value));
+	}
+	return 0;
+}
+
+static int psb_set_brightness(struct backlight_device *bd)
+{
+	struct drm_device *dev = bl_get_data(psb_backlight_device);
+	int level = bd->props.brightness;
+
+	/* Percentage 1-100% being valid */
+	if (level < 1)
+		level = 1;
+
+	psb_intel_lvds_set_brightness(dev, level);
+	psb_brightness = level;
+	return 0;
+}
+
+static const struct backlight_ops psb_ops = {
+	.get_brightness = psb_get_brightness,
+	.update_status  = psb_set_brightness,
+};
+
+static int psb_backlight_init(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int ret;
+	struct backlight_properties props;
+
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = 100;
+	props.type = BACKLIGHT_PLATFORM;
+
+	psb_backlight_device = backlight_device_register("psb-bl",
+					NULL, (void *)dev, &psb_ops, &props);
+	if (IS_ERR(psb_backlight_device))
+		return PTR_ERR(psb_backlight_device);
+
+	ret = psb_backlight_setup(dev);
+	if (ret < 0) {
+		backlight_device_unregister(psb_backlight_device);
+		psb_backlight_device = NULL;
+		return ret;
+	}
+	psb_backlight_device->props.brightness = 100;
+	psb_backlight_device->props.max_brightness = 100;
+	backlight_update_status(psb_backlight_device);
+	dev_priv->backlight_device = psb_backlight_device;
+	return 0;
+}
+
+#endif
+
 /*
  *	Provide the Poulsbo specific chip logic and low level methods
+ *	for power management
  */
 
 static void psb_init_pm(struct drm_device *dev)
@@ -165,10 +283,15 @@ int psb_power_up(struct drm_device *dev)
 
 const struct psb_ops psb_chip_ops = {
 	.output_init = psb_output_init,
+
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+	.backlight_init = psb_backlight_init,
+#endif
+
 	.init_pm = psb_init_pm,
 	.save_regs = psb_save_display_registers,
 	.restore_regs = psb_restore_display_registers,
 	.power_down = psb_power_down,
-	.power_up = psb_power_up,
+	.power_up = psb_power_up,	
 };
 
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 6c57234..bb6b68f 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -261,7 +261,7 @@ static int psb_driver_unload(struct drm_device *dev)
 
 	/* Kill vblank etc here */
 
-	psb_backlight_exit(); /*writes minimum value to backlight HW reg */
+	gma_backlight_exit(dev);
 
 	if (drm_psb_no_fb == 0)
 		psb_modeset_cleanup(dev);
@@ -455,7 +455,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 
 		switch (psb_intel_output->type) {
 		case INTEL_OUTPUT_LVDS:
-			ret = psb_backlight_init(dev);
+			ret = gma_backlight_init(dev);
 			break;
 		}
 	}
@@ -554,12 +554,14 @@ static int psb_dpst_bl_ioctl(struct drm_device *dev, void *data,
 {
 	struct drm_psb_private *dev_priv = psb_priv(dev);
 	uint32_t *arg = data;
-	struct backlight_device bd;
+	struct backlight_device *bd = dev_priv->backlight_device;
 	dev_priv->blc_adj2 = *arg;
 
 #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
-	bd.props.brightness = psb_get_brightness(&bd);
-	psb_set_brightness(&bd);
+	if (bd) {
+		bd->props.brightness = bd->ops->get_brightness(bd);
+		backlight_update_status(bd);
+	}
 #endif
 	return 0;
 }
@@ -569,12 +571,14 @@ static int psb_adb_ioctl(struct drm_device *dev, void *data,
 {
 	struct drm_psb_private *dev_priv = psb_priv(dev);
 	uint32_t *arg = data;
-	struct backlight_device bd;
+	struct backlight_device *bd = dev_priv->backlight_device;
 	dev_priv->blc_adj1 = *arg;
 
 #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
-	bd.props.brightness = psb_get_brightness(&bd);
-	psb_set_brightness(&bd);
+	if (bd) {
+		bd->props.brightness = bd->ops->get_brightness(bd);
+		backlight_update_status(bd);
+	}
 #endif
 	return 0;
 }
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index d1c49e7..b0908f2 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -588,12 +588,12 @@ struct drm_psb_private {
 	 * Used for modifying backlight from
 	 * xrandr -- consider removing and using HAL instead
 	 */
+	struct backlight_device *backlight_device;
 	struct drm_property *backlight_property;
 	uint32_t blc_adj1;
 	uint32_t blc_adj2;
 
 	void *fbdev;
-
 	/* DPST state */
 	uint32_t dsr_idle_count;
 	bool is_in_idle;
@@ -625,6 +625,10 @@ struct psb_ops {
 	int (*restore_regs)(struct drm_device *dev);
 	int (*power_up)(struct drm_device *dev);
 	int (*power_down)(struct drm_device *dev);
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+	/* Backlight */
+	int (*backlight_init)(struct drm_device *dev);
+#endif
 };
 
 
@@ -744,12 +748,9 @@ extern void psb_modeset_init(struct drm_device *dev);
 extern void psb_modeset_cleanup(struct drm_device *dev);
 extern int psb_fbdev_init(struct drm_device *dev);
 
-/* psb_bl.c */
-int psb_backlight_init(struct drm_device *dev);
-void psb_backlight_exit(void);
-int psb_set_brightness(struct backlight_device *bd);
-int psb_get_brightness(struct backlight_device *bd);
-struct backlight_device *psb_get_backlight_device(void);
+/* backlight.c */
+int gma_backlight_init(struct drm_device *dev);
+void gma_backlight_exit(struct drm_device *dev);
 
 /* mrst_crtc.c */
 extern const struct drm_crtc_helper_funcs mrst_helper_funcs;
diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index 850d07d..41b96d2 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -575,11 +575,12 @@ int psb_intel_lvds_set_property(struct drm_connector *connector,
 				       struct drm_property *property,
 				       uint64_t value)
 {
-	struct drm_encoder *pEncoder = connector->encoder;
+	struct drm_encoder *encoder = connector->encoder;
+	struct drm_psb_private *dev_priv = encoder->dev->dev_private;
 
-	if (!strcmp(property->name, "scaling mode") && pEncoder) {
+	if (!strcmp(property->name, "scaling mode") && encoder) {
 		struct psb_intel_crtc *pPsbCrtc =
-					to_psb_intel_crtc(pEncoder->crtc);
+					to_psb_intel_crtc(encoder->crtc);
 		uint64_t curValue;
 
 		if (!pPsbCrtc)
@@ -611,29 +612,31 @@ int psb_intel_lvds_set_property(struct drm_connector *connector,
 
 		if (pPsbCrtc->saved_mode.hdisplay != 0 &&
 		    pPsbCrtc->saved_mode.vdisplay != 0) {
-			if (!drm_crtc_helper_set_mode(pEncoder->crtc,
+			if (!drm_crtc_helper_set_mode(encoder->crtc,
 						      &pPsbCrtc->saved_mode,
-						      pEncoder->crtc->x,
-						      pEncoder->crtc->y,
-						      pEncoder->crtc->fb))
+						      encoder->crtc->x,
+						      encoder->crtc->y,
+						      encoder->crtc->fb))
 				goto set_prop_error;
 		}
-	} else if (!strcmp(property->name, "backlight") && pEncoder) {
+	} else if (!strcmp(property->name, "backlight") && encoder) {
 		if (drm_connector_property_set_value(connector,
 							property,
 							value))
 			goto set_prop_error;
 		else {
 #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
-			struct backlight_device bd;
-			bd.props.brightness = value;
-			psb_set_brightness(&bd);
+			struct backlight_device *bd = dev_priv->backlight_device;
+			if (bd) {
+        			bd->props.brightness = value;
+	        		backlight_update_status(bd);
+                        }
 #endif
 		}
-	} else if (!strcmp(property->name, "DPMS") && pEncoder) {
+	} else if (!strcmp(property->name, "DPMS") && encoder) {
 		struct drm_encoder_helper_funcs *pEncHFuncs
-						= pEncoder->helper_private;
-		pEncHFuncs->dpms(pEncoder, value);
+						= encoder->helper_private;
+		pEncHFuncs->dpms(encoder, value);
 	}
 
 set_prop_done:

