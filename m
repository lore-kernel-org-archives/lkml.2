Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab1BQBmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 20:42:01 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:40930 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab1BQBl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 20:41:59 -0500
Message-ID: <b31923f701845ddd4fb5b0aa0235ea19.squirrel@webmail.greenhost.nl>
In-Reply-To: <AANLkTinuF0na0zLOFOjFWapoNNXCUay88BdrxH0-_ybM@mail.gmail.com>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
    <20110216192658.GA7225@blimp.localdomain>
    <AANLkTinuF0na0zLOFOjFWapoNNXCUay88BdrxH0-_ybM@mail.gmail.com>
Date: Thu, 17 Feb 2011 02:41:49 +0100 (CET)
Subject: [PATCH] drm/i915: Do not handle backlight combination mode 
     specially.
From: "Indan Zupancic" <indan@nul.nu>
To: "Alex Riesen" <raa.lkml@gmail.com>
Cc: "DRI mailing list" <dri-devel@lists.freedesktop.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 025acf9a139f050bc01ccdeba87e03e0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drm/i915: Do not handle backlight combination mode specially.

The current code does not follow Intel documentation: It misses some things
and does other, undocumented things. This causes wrong backlight values in
certain conditions. Instead of adding tricky code handling badly documented
and rare corner cases, don't handle combination mode specially at all. This
way PCI_LBPC is never touched and weird things shouldn't happen.

If combination mode is enabled, then the only downside is that changing the
brightness has a greater granularity (the LBPC value), but LBPC is at most
254 and the maximum is in the thousands, so this is no real functional loss.

A potential problem with not handling combined mode is that a brightness of
max * PCI_LBPC is not bright enough. However, this is very unlikely because
from the documentation LBPC seems to act as a scaling factor and doesn't look
like it's supposed to be changed after boot. The value at boot should always
result in a bright enough screen.

IMPORTANT: However, although usually the above is true, it may not be when
people ran an older (2.6.37) kernel which messed up the LBPC register, and
they are unlucky enough to have a BIOS that saves and restores the LBPC value.
Then a good kernel may seem to not work: Max brightness isn't bright enough.
If this happens people should boot back into the old kernel, set brightness
to the maximum, and then reboot. After that everything should be fine.

For more information see the below links. This fixes bugs:

http://bugzilla.kernel.org/show_bug.cgi?id=23472
http://bugzilla.kernel.org/show_bug.cgi?id=25072

Signed-off-by: Indan Zupancic <indan@nul.nu>

---

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 5cfc689..af2fc32 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1551,17 +1551,7 @@

 /* Backlight control */
 #define BLC_PWM_CTL		0x61254
-#define   BACKLIGHT_MODULATION_FREQ_SHIFT		(17)
 #define BLC_PWM_CTL2		0x61250 /* 965+ only */
-#define   BLM_COMBINATION_MODE (1 << 30)
-/*
- * This is the most significant 15 bits of the number of backlight cycles in a
- * complete cycle of the modulated backlight control.
- *
- * The actual value is this field multiplied by two.
- */
-#define   BACKLIGHT_MODULATION_FREQ_MASK		(0x7fff << 17)
-#define   BLM_LEGACY_MODE				(1 << 16)
 /*
  * This is the number of cycles out of the backlight modulation cycle for which
  * the backlight is on.
diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index c65992d..d860abe 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -30,8 +30,6 @@

 #include "intel_drv.h"

-#define PCI_LBPC 0xf4 /* legacy/combination backlight modes */
-
 void
 intel_fixed_panel_mode(struct drm_display_mode *fixed_mode,
 		       struct drm_display_mode *adjusted_mode)
@@ -112,19 +110,6 @@ done:
 	dev_priv->pch_pf_size = (width << 16) | height;
 }

-static int is_backlight_combination_mode(struct drm_device *dev)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-
-	if (INTEL_INFO(dev)->gen >= 4)
-		return I915_READ(BLC_PWM_CTL2) & BLM_COMBINATION_MODE;
-
-	if (IS_GEN2(dev))
-		return I915_READ(BLC_PWM_CTL) & BLM_LEGACY_MODE;
-
-	return 0;
-}
-
 static u32 i915_read_blc_pwm_ctl(struct drm_i915_private *dev_priv)
 {
 	u32 val;
@@ -181,9 +166,6 @@ u32 intel_panel_get_max_backlight(struct drm_device *dev)
 			if (INTEL_INFO(dev)->gen < 4)
 				max &= ~1;
 		}
-
-		if (is_backlight_combination_mode(dev))
-			max *= 0xff;
 	}

 	DRM_DEBUG_DRIVER("max backlight PWM = %d\n", max);
@@ -201,15 +183,6 @@ u32 intel_panel_get_backlight(struct drm_device *dev)
 		val = I915_READ(BLC_PWM_CTL) & BACKLIGHT_DUTY_CYCLE_MASK;
 		if (IS_PINEVIEW(dev))
 			val >>= 1;
-
-		if (is_backlight_combination_mode(dev)){
-			u8 lbpc;
-
-			val &= ~1;
-			pci_read_config_byte(dev->pdev, PCI_LBPC, &lbpc);
-			val *= lbpc;
-			val >>= 1;
-		}
 	}

 	DRM_DEBUG_DRIVER("get backlight PWM = %d\n", val);
@@ -232,16 +205,6 @@ void intel_panel_set_backlight(struct drm_device *dev, u32 level)

 	if (HAS_PCH_SPLIT(dev))
 		return intel_pch_panel_set_backlight(dev, level);
-
-	if (is_backlight_combination_mode(dev)){
-		u32 max = intel_panel_get_max_backlight(dev);
-		u8 lpbc;
-
-		lpbc = level * 0xfe / max + 1;
-		level /= lpbc;
-		pci_write_config_byte(dev->pdev, PCI_LBPC, lpbc);
-	}
-
 	tmp = I915_READ(BLC_PWM_CTL);
 	if (IS_PINEVIEW(dev)) {
 		tmp &= ~(BACKLIGHT_DUTY_CYCLE_MASK - 1);


