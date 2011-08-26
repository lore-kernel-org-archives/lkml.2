Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab1HZKYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:24:31 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49241 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab1HZKYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:24:30 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 7/9] gma500: Fix backlight crash
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 26 Aug 2011 11:19:34 +0100
Message-ID: <20110826101927.16760.42350.stgit@localhost.localdomain>
In-Reply-To: <20110826101734.16760.64364.stgit@localhost.localdomain>
References: <20110826101734.16760.64364.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Initial changes to get backlight behaviour we want and to fix backlight crashes
on suspend/resume paths.

[Note: on some boxes this will now produce a warning about the backlight, this
 isn't a regression it's an unfixed but non harmful case I still need to nail]

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/power.c          |    2 +
 drivers/staging/gma500/psb_intel_lvds.c |   60 +++++++++++++++++--------------
 2 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/gma500/power.c b/drivers/staging/gma500/power.c
index 972bea7..9402569 100644
--- a/drivers/staging/gma500/power.c
+++ b/drivers/staging/gma500/power.c
@@ -302,7 +302,7 @@ int psb_runtime_suspend(struct device *dev)
 
 int psb_runtime_resume(struct device *dev)
 {
-	return 0;
+	return gma_power_resume(dev);;
 }
 
 int psb_runtime_idle(struct device *dev)
diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index 8b951e3..21022e1 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -68,20 +68,23 @@ struct psb_intel_lvds_priv {
 static u32 psb_intel_lvds_get_max_backlight(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	u32 retVal;
+	u32 ret;
 
 	if (gma_power_begin(dev, false)) {
-		retVal = ((REG_READ(BLC_PWM_CTL) &
-			  BACKLIGHT_MODULATION_FREQ_MASK) >>
-			  BACKLIGHT_MODULATION_FREQ_SHIFT) * 2;
-
+		ret = REG_READ(BLC_PWM_CTL);
 		gma_power_end(dev);
-	} else
-		retVal = ((dev_priv->saveBLC_PWM_CTL &
-			  BACKLIGHT_MODULATION_FREQ_MASK) >>
-			  BACKLIGHT_MODULATION_FREQ_SHIFT) * 2;
-
-	return retVal;
+	} else /* Powered off, use the saved value */
+		ret = dev_priv->saveBLC_PWM_CTL;
+
+	/* Top 15bits hold the frequency mask */
+	ret = (ret &  BACKLIGHT_MODULATION_FREQ_MASK) >>
+					BACKLIGHT_MODULATION_FREQ_SHIFT;
+
+        ret *= 2;	/* Return a 16bit range as needed for setting */
+        if (ret == 0)
+                dev_err(dev->dev, "BL bug: Reg %08x save %08X\n",
+                        REG_READ(BLC_PWM_CTL), dev_priv->saveBLC_PWM_CTL);
+	return ret;
 }
 
 /*
@@ -142,7 +145,7 @@ static int psb_lvds_pwm_set_brightness(struct drm_device *dev, int level)
 	max_pwm_blc = psb_intel_lvds_get_max_backlight(dev);
 
 	/*BLC_PWM_CTL Should be initiated while backlight device init*/
-	BUG_ON((max_pwm_blc & PSB_BLC_MAX_PWM_REG_FREQ) == 0);
+	BUG_ON(max_pwm_blc == 0);
 
 	blc_pwm_duty_cycle = level * max_pwm_blc / BRIGHTNESS_MAX_LEVEL;
 
@@ -154,6 +157,10 @@ static int psb_lvds_pwm_set_brightness(struct drm_device *dev, int level)
 		  (max_pwm_blc << PSB_BACKLIGHT_PWM_CTL_SHIFT) |
 		  (blc_pwm_duty_cycle));
 
+        dev_info(dev->dev, "Backlight lvds set brightness %08x\n",
+		  (max_pwm_blc << PSB_BACKLIGHT_PWM_CTL_SHIFT) |
+		  (blc_pwm_duty_cycle));
+
 	return 0;
 }
 
@@ -162,14 +169,12 @@ static int psb_lvds_pwm_set_brightness(struct drm_device *dev, int level)
  */
 void psb_intel_lvds_set_brightness(struct drm_device *dev, int level)
 {
-	/*u32 blc_pwm_ctl;*/
-	struct drm_psb_private *dev_priv =
-			(struct drm_psb_private *)dev->dev_private;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 
 	dev_dbg(dev->dev, "backlight level is %d\n", level);
 
 	if (!dev_priv->lvds_bl) {
-		dev_err(dev->dev, "NO LVDS Backlight Info\n");
+		dev_err(dev->dev, "NO LVDS backlight info\n");
 		return;
 	}
 
@@ -190,11 +195,13 @@ static void psb_intel_lvds_set_backlight(struct drm_device *dev, int level)
 	u32 blc_pwm_ctl;
 
 	if (gma_power_begin(dev, false)) {
-		blc_pwm_ctl =
-			REG_READ(BLC_PWM_CTL) & ~BACKLIGHT_DUTY_CYCLE_MASK;
+		blc_pwm_ctl = REG_READ(BLC_PWM_CTL);
+		blc_pwm_ctl &= ~BACKLIGHT_DUTY_CYCLE_MASK;
 		REG_WRITE(BLC_PWM_CTL,
 				(blc_pwm_ctl |
 				(level << BACKLIGHT_DUTY_CYCLE_SHIFT)));
+		dev_priv->saveBLC_PWM_CTL = (blc_pwm_ctl |
+					(level << BACKLIGHT_DUTY_CYCLE_SHIFT));
 		gma_power_end(dev);
 	} else {
 		blc_pwm_ctl = dev_priv->saveBLC_PWM_CTL &
@@ -212,9 +219,11 @@ static void psb_intel_lvds_set_power(struct drm_device *dev,
 {
 	u32 pp_status;
 
-	if (!gma_power_begin(dev, true))
+	if (!gma_power_begin(dev, true)) {
+	        dev_err(dev->dev, "set power, chip off!\n");
 		return;
-
+        }
+        
 	if (on) {
 		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) |
 			  POWER_TARGET_ON);
@@ -296,9 +305,6 @@ static void psb_intel_lvds_restore(struct drm_connector *connector)
 {
 	struct drm_device *dev = connector->dev;
 	u32 pp_status;
-
-	/*struct drm_psb_private *dev_priv =
-				(struct drm_psb_private *)dev->dev_private;*/
 	struct psb_intel_output *psb_intel_output =
 					to_psb_intel_output(connector);
 	struct psb_intel_lvds_priv *lvds_priv =
@@ -621,7 +627,8 @@ int psb_intel_lvds_set_property(struct drm_connector *connector,
 			goto set_prop_error;
 		else {
 #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
-			struct drm_psb_private *devp = encoder->dev->dev_private;
+			struct drm_psb_private *devp =
+						encoder->dev->dev_private;
 			struct backlight_device *bd = devp->backlight_device;
 			if (bd) {
 				bd->props.brightness = value;
@@ -694,8 +701,7 @@ void psb_intel_lvds_init(struct drm_device *dev,
 	struct drm_encoder *encoder;
 	struct drm_display_mode *scan;	/* *modes, *bios_mode; */
 	struct drm_crtc *crtc;
-	struct drm_psb_private *dev_priv =
-				(struct drm_psb_private *)dev->dev_private;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 lvds;
 	int pipe;
 
@@ -711,8 +717,8 @@ void psb_intel_lvds_init(struct drm_device *dev,
 	}
 
 	psb_intel_output->dev_priv = lvds_priv;
-
 	psb_intel_output->mode_dev = mode_dev;
+
 	connector = &psb_intel_output->base;
 	encoder = &psb_intel_output->enc;
 	drm_connector_init(dev, &psb_intel_output->base,

