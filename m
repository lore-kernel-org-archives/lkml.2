Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935829Ab1KJDfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:35:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935748Ab1KJDfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:35:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:44 2011
Message-Id: <20111109213144.306756044@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
        Keith Packard <keithp@keithp.com>
Subject: [022/264] drm/i915/panel: Always record the backlight level again (but cleverly)
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit f52c619a590fa75276c07dfcaf380dee53e4ea4c upstream.

The commit 47356eb67285014527a5ab87543ba1fae3d1e10a introduced a
mechanism to record the backlight level only at disabling time, but it
also introduced a regression.  Since intel_lvds_enable() may be called
without disabling (e.g. intel_lvds_commit() calls it unconditionally),
the backlight gets back to the last recorded value.  For example, this
happens when you dim the backlight, close the lid and open the lid,
then the backlight suddenly goes to the brightest.

This patch fixes the bug by recording the backlight level always
when changed via intel_panel_set_backlight().  And,
intel_panel_{enable|disable}_backlight() call the internal function not
to update the recorded level wrongly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_panel.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -226,7 +226,7 @@ static void intel_pch_panel_set_backligh
 	I915_WRITE(BLC_PWM_CPU_CTL, val | level);
 }
 
-void intel_panel_set_backlight(struct drm_device *dev, u32 level)
+static void intel_panel_actually_set_backlight(struct drm_device *dev, u32 level)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 tmp;
@@ -254,16 +254,21 @@ void intel_panel_set_backlight(struct dr
 	I915_WRITE(BLC_PWM_CTL, tmp | level);
 }
 
-void intel_panel_disable_backlight(struct drm_device *dev)
+void intel_panel_set_backlight(struct drm_device *dev, u32 level)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
-	if (dev_priv->backlight_enabled) {
-		dev_priv->backlight_level = intel_panel_get_backlight(dev);
-		dev_priv->backlight_enabled = false;
-	}
+	dev_priv->backlight_level = level;
+	if (dev_priv->backlight_enabled)
+		intel_panel_actually_set_backlight(dev, level);
+}
+
+void intel_panel_disable_backlight(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
 
-	intel_panel_set_backlight(dev, 0);
+	dev_priv->backlight_enabled = false;
+	intel_panel_actually_set_backlight(dev, 0);
 }
 
 void intel_panel_enable_backlight(struct drm_device *dev)
@@ -273,8 +278,8 @@ void intel_panel_enable_backlight(struct
 	if (dev_priv->backlight_level == 0)
 		dev_priv->backlight_level = intel_panel_get_max_backlight(dev);
 
-	intel_panel_set_backlight(dev, dev_priv->backlight_level);
 	dev_priv->backlight_enabled = true;
+	intel_panel_actually_set_backlight(dev, dev_priv->backlight_level);
 }
 
 static void intel_panel_init_backlight(struct drm_device *dev)


