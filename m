Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab2COJ7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 05:59:55 -0400
Received: from HSI-KBW-109-192-167-159.hsi6.kabel-badenwuerttemberg.de ([109.192.167.159]:57893
	"EHLO rack0slot8.osadl.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752589Ab2COJ7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 05:59:53 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Mar 2012 05:59:53 EDT
Message-Id: <20120315095357.607004685@osadl.org>
User-Agent: quilt/0.48-1
Date: Thu, 15 Mar 2012 10:52:21 +0100
From: Carsten Emde <C.Emde@osadl.org>
To: David Airlie <airlied@linux.ie>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Keith Packard <keithp@keithp.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Carsten Emde <C.Emde@osadl.org>, DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [V3 PATCH 2/2] drivers-gpu-drm-i915-quirk-backlight-inverted.patch
References: <20120315095219.520461363@osadl.org>
Content-Disposition: inline; filename=drivers-gpu-drm-i915-quirk-backlight-inverted.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the documentation of the Legacy Backlight Brightness (LBB)
Register in the configuration space of some Intel PCI graphics adapters,
setting the LBB register with the value 0x0 causes the backlight to be
turned off, and 0xFF causes the backlight to be set to 100% intensity
(http://download.intel.com/embedded/processors/Whitepaper/324567.pdf).
The Acer Aspire 5734Z, however, turns the backlight off at 0xFF and sets
it to maximum intensity at 0. In consequence, the screen of this systems
becomes dark at an early boot stage which makes it unusable. The same
inversion applies to the BLC_PWM_CTL I915 register. This problem was
introduced in kernel version 2.6.38 when the PCI device of this system
was first supported by the i915 KMS module.

This patch adds a quirk to invert the sense of the brightness variable
in case an Acer Aspire 5734Z is encountered.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>

---
 drivers/gpu/drm/i915/i915_drv.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |   12 ++++++++++++
 drivers/gpu/drm/i915/intel_panel.c   |   10 ++++++++++
 3 files changed, 23 insertions(+)

Index: linux-3.3-rc7/drivers/gpu/drm/i915/i915_drv.h
===================================================================
--- linux-3.3-rc7.orig/drivers/gpu/drm/i915/i915_drv.h
+++ linux-3.3-rc7/drivers/gpu/drm/i915/i915_drv.h
@@ -275,6 +275,7 @@ enum intel_pch {
 
 #define QUIRK_PIPEA_FORCE (1<<0)
 #define QUIRK_LVDS_SSC_DISABLE (1<<1)
+#define QUIRK_BRIGHTNESS_INVERTED (1<<2)
 
 struct intel_fbdev;
 struct intel_fbc_work;
Index: linux-3.3-rc7/drivers/gpu/drm/i915/intel_display.c
===================================================================
--- linux-3.3-rc7.orig/drivers/gpu/drm/i915/intel_display.c
+++ linux-3.3-rc7/drivers/gpu/drm/i915/intel_display.c
@@ -8950,6 +8950,15 @@ static void quirk_ssc_force_disable(stru
 	dev_priv->quirks |= QUIRK_LVDS_SSC_DISABLE;
 }
 
+/*
+ * At least one machine (Acer Aspire 5734Z) has inverted backlight brightness
+ */
+static void quirk_brightness_inverted(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	dev_priv->quirks |= QUIRK_BRIGHTNESS_INVERTED;
+}
+
 struct intel_quirk {
 	int device;
 	int subsystem_vendor;
@@ -8984,6 +8993,9 @@ struct intel_quirk intel_quirks[] = {
 
 	/* Sony Vaio Y cannot use SSC on LVDS */
 	{ 0x0046, 0x104d, 0x9076, quirk_ssc_force_disable },
+
+	/* Acer Aspire 5734Z has inverted backlight brightness */
+	{ 0x2a42, 0x1025, 0x0459, quirk_brightness_inverted },
 };
 
 static void intel_init_quirks(struct drm_device *dev)
Index: linux-3.3-rc7/drivers/gpu/drm/i915/intel_panel.c
===================================================================
--- linux-3.3-rc7.orig/drivers/gpu/drm/i915/intel_panel.c
+++ linux-3.3-rc7/drivers/gpu/drm/i915/intel_panel.c
@@ -28,6 +28,7 @@
  *      Chris Wilson <chris@chris-wilson.co.uk>
  */
 
+#include <linux/moduleparam.h>
 #include "intel_drv.h"
 
 #define PCI_LBPC 0xf4 /* legacy/combination backlight modes */
@@ -212,6 +213,10 @@ u32 intel_panel_get_backlight(struct drm
 	}
 
 	DRM_DEBUG_DRIVER("get backlight PWM = %d\n", val);
+	if (dev_priv->quirks & QUIRK_BRIGHTNESS_INVERTED) {
+		u32 max = intel_panel_get_max_backlight(dev);
+		val = max - val;
+	}
 	return val;
 }
 
@@ -229,6 +234,11 @@ static void intel_panel_actually_set_bac
 
 	DRM_DEBUG_DRIVER("set backlight PWM = %d\n", level);
 
+	if (dev_priv->quirks & QUIRK_BRIGHTNESS_INVERTED) {
+		u32 max = intel_panel_get_max_backlight(dev);
+		level = max - level;
+	}
+
 	if (HAS_PCH_SPLIT(dev))
 		return intel_pch_panel_set_backlight(dev, level);
 

