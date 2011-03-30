Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab1C3JSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:18:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51177 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932274Ab1C3JSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:18:48 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 07/18] gma500: Add Moorestown backlight support
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 30 Mar 2011 10:00:05 +0100
Message-ID: <20110330090002.5897.78332.stgit@localhost.localdomain>
In-Reply-To: <20110330085539.5897.67919.stgit@localhost.localdomain>
References: <20110330085539.5897.67919.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which is of course different to Poulsbo.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_bl.c |  112 ++++++++++++++++++++++++++++++---------
 1 files changed, 85 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/gma500/psb_bl.c b/drivers/staging/gma500/psb_bl.c
index 70c17b3..a2729fd 100644
--- a/drivers/staging/gma500/psb_bl.c
+++ b/drivers/staging/gma500/psb_bl.c
@@ -33,7 +33,6 @@
 #define BLC_PWM_FREQ_CALC_CONSTANT 32
 #define MHz 1000000
 #define BRIGHTNESS_MIN_LEVEL 1
-#define BRIGHTNESS_MAX_LEVEL 100
 #define BRIGHTNESS_MASK	0xFF
 #define BLC_POLARITY_NORMAL 0
 #define BLC_POLARITY_INVERSE 1
@@ -59,15 +58,57 @@ int psb_set_brightness(struct backlight_device *bd)
 
 	DRM_DEBUG_DRIVER("backlight level set to %d\n", level);
 
-	/* Perform value bounds checking */
-	if (level < BRIGHTNESS_MIN_LEVEL)
-		level = BRIGHTNESS_MIN_LEVEL;
+	/* Percentage 1-100% being valid */
+	if (level < 1)
+		level = 1;
 
 	psb_intel_lvds_set_brightness(dev, level);
 	psb_brightness = level;
 	return 0;
 }
 
+int mrst_set_brightness(struct backlight_device *bd)
+{
+	struct drm_device *dev = bl_get_data(psb_backlight_device);
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int level = bd->props.brightness;
+	u32 blc_pwm_ctl;
+	u32 max_pwm_blc;
+
+	DRM_DEBUG_DRIVER("backlight level set to %d\n", level);
+
+	/* Percentage 1-100% being valid */
+	if (level < 1)
+		level = 1;
+
+	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, OSPM_UHB_ONLY_IF_ON)) {
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
+		if (blc_pol == BLC_POLARITY_INVERSE)
+			blc_pwm_ctl = max_pwm_blc - blc_pwm_ctl;
+		/* force PWM bit on */
+		REG_WRITE(BLC_PWM_CTL2, (0x80000000 | REG_READ(BLC_PWM_CTL2)));
+		REG_WRITE(BLC_PWM_CTL, (max_pwm_blc << 16) | blc_pwm_ctl);
+		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	}
+	psb_brightness = level;
+	return 0;
+}
+
 int psb_get_brightness(struct backlight_device *bd)
 {
 	DRM_DEBUG_DRIVER("brightness = 0x%x\n", psb_brightness);
@@ -85,24 +126,33 @@ static const struct backlight_ops psb_ops = {
 
 static int device_backlight_init(struct drm_device *dev)
 {
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	unsigned long core_clock;
 	/* u32 bl_max_freq; */
 	/* unsigned long value; */
 	u16 bl_max_freq;
 	uint32_t value;
 	uint32_t blc_pwm_precision_factor;
-	struct drm_psb_private *dev_priv = dev->dev_private;
 
-	/* get bl_max_freq and pol from dev_priv*/
-	if (!dev_priv->lvds_bl) {
-		DRM_ERROR("Has no valid LVDS backlight info\n");
-		return 1;
+	if (IS_MRST(dev)) {
+		dev_priv->blc_adj1 = BLC_ADJUSTMENT_MAX;
+		dev_priv->blc_adj2 = BLC_ADJUSTMENT_MAX;
+		bl_max_freq = 256;
+		/* this needs to be set elsewhere */
+		blc_pol = BLC_POLARITY_NORMAL;
+		blc_pwm_precision_factor = BLC_PWM_PRECISION_FACTOR;
+	} else {
+		/* get bl_max_freq and pol from dev_priv*/
+		if (!dev_priv->lvds_bl) {
+			DRM_ERROR("Has no valid LVDS backlight info\n");
+			return 1;
+		}
+		bl_max_freq = dev_priv->lvds_bl->freq;
+		blc_pol = dev_priv->lvds_bl->pol;
+		blc_pwm_precision_factor = PSB_BLC_PWM_PRECISION_FACTOR;
+		blc_brightnesscmd = dev_priv->lvds_bl->brightnesscmd;
+		blc_type = dev_priv->lvds_bl->type;
 	}
-	bl_max_freq = dev_priv->lvds_bl->freq;
-	blc_pol = dev_priv->lvds_bl->pol;
-	blc_pwm_precision_factor = PSB_BLC_PWM_PRECISION_FACTOR;
-	blc_brightnesscmd = dev_priv->lvds_bl->brightnesscmd;
-	blc_type = dev_priv->lvds_bl->type;
 
 	core_clock = dev_priv->core_freq;
 
@@ -113,16 +163,24 @@ static int device_backlight_init(struct drm_device *dev)
 
 	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
 						OSPM_UHB_ONLY_IF_ON)) {
-		/* Check: may be MFLD only */
-		if (
-		 value > (unsigned long long)PSB_BLC_MAX_PWM_REG_FREQ ||
-		 value < (unsigned long long)PSB_BLC_MIN_PWM_REG_FREQ)
-			return 2;
-		else {
-			value &= PSB_BACKLIGHT_PWM_POLARITY_BIT_CLEAR;
-			REG_WRITE(BLC_PWM_CTL,
-				(value << PSB_BACKLIGHT_PWM_CTL_SHIFT) |
-				(value));
+		if (IS_MRST(dev)) {
+			if (value > (unsigned long long)MRST_BLC_MAX_PWM_REG_FREQ)
+				return 2;
+			else {
+				REG_WRITE(BLC_PWM_CTL2,
+					(0x80000000 | REG_READ(BLC_PWM_CTL2)));
+				REG_WRITE(BLC_PWM_CTL, value | (value << 16));
+			}
+		} else {
+			if (value > (unsigned long long)PSB_BLC_MAX_PWM_REG_FREQ ||
+			 value < (unsigned long long)PSB_BLC_MIN_PWM_REG_FREQ)
+				return 2;
+			else {
+				value &= PSB_BACKLIGHT_PWM_POLARITY_BIT_CLEAR;
+				REG_WRITE(BLC_PWM_CTL,
+					(value << PSB_BACKLIGHT_PWM_CTL_SHIFT) |
+					(value));
+			}
 		}
 		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
 	}
@@ -136,7 +194,7 @@ int psb_backlight_init(struct drm_device *dev)
 
 	struct backlight_properties props;
 	memset(&props, 0, sizeof(struct backlight_properties));
-	props.max_brightness = BRIGHTNESS_MAX_LEVEL;
+	props.max_brightness = 100;
 
 	psb_backlight_device = backlight_device_register("psb-bl", NULL,
 						(void *)dev, &psb_ops, &props);
@@ -147,8 +205,8 @@ int psb_backlight_init(struct drm_device *dev)
 	if (ret < 0)
 		return ret;
 
-	psb_backlight_device->props.brightness = BRIGHTNESS_MAX_LEVEL;
-	psb_backlight_device->props.max_brightness = BRIGHTNESS_MAX_LEVEL;
+	psb_backlight_device->props.brightness = 100;
+	psb_backlight_device->props.max_brightness = 100;
 	backlight_update_status(psb_backlight_device);
 #endif
 	return 0;

