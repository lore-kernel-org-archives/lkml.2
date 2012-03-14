Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031283Ab2CNX5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:57:24 -0400
Received: from HSI-KBW-46-237-235-162.hsi.kabel-badenwuerttemberg.de ([46.237.235.162]:38320
	"EHLO rack0slot8.osadl.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1031205Ab2CNX5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:57:08 -0400
Message-Id: <20120314234830.227490545@osadl.org>
User-Agent: quilt/0.48-1
Date: Thu, 15 Mar 2012 00:35:46 +0100
From: Carsten Emde <C.Emde@osadl.org>
To: David Airlie <airlied@linux.ie>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [V2 PATCH 2/2] drivers-gpu-drm-i915-invert-backlight-brightness
References: <20120314233544.629616190@osadl.org>
Content-Disposition: inline; filename=drivers-gpu-drm-i915-invert-backlight-brightness.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the documentation of the Legacy Backlight Brightness (LBB)
Register in the configuration space of some Intel PCI graphics adapters,
setting the LBB register with the value 0x0 causes the backlight to be
turned off, and 0xFF causes the backlight to be set to 100% intensity
(http://download.intel.com/embedded/processors/Whitepaper/324567.pdf).
At least one of our test systems, however, turns the backlight off at
0xFF and sets it to maximum intensity at 0. In consequence, the screen
of this systems becomes dark at an early boot stage which makes it
unusable. The same inversion applies to the BLC_PWM_CTL I915 register.
This problem was introduced in kernel version 2.6.38 when the PCI device
of this system was first supported by the i915 KMS module.

This patch adds a module parameter to invert the backlight brightness
value before writing and after reading which makes the affected notebook
usable again.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>

---
 Documentation/kernel-parameters.txt |    9 +++++++++
 drivers/gpu/drm/i915/intel_panel.c  |   14 ++++++++++++++
 2 files changed, 23 insertions(+)

Index: linux-3.3-rc6/Documentation/kernel-parameters.txt
===================================================================
--- linux-3.3-rc6.orig/Documentation/kernel-parameters.txt
+++ linux-3.3-rc6/Documentation/kernel-parameters.txt
@@ -966,6 +966,15 @@ bytes respectively. Such letter suffixes
 
 	i810=		[HW,DRM]
 
+	i915.invert_brightness
+			[DRM] Invert the sense of the variable that is used to
+			set the brightness of the panel backlight. Normally a
+			value of 0 indicates backlight switched off, and the
+			maximum value sets the backlight to maximum brightness.
+			If this parameter is specified, a value of 0 sets the
+			backlight to maximum brightness, and the maximum value
+			switches the backlight off.
+
 	i8k.ignore_dmi	[HW] Continue probing hardware even if DMI data
 			indicates that the driver is running on unsupported
 			hardware.
Index: linux-3.3-rc6/drivers/gpu/drm/i915/intel_panel.c
===================================================================
--- linux-3.3-rc6.orig/drivers/gpu/drm/i915/intel_panel.c
+++ linux-3.3-rc6/drivers/gpu/drm/i915/intel_panel.c
@@ -28,6 +28,7 @@
  *      Chris Wilson <chris@chris-wilson.co.uk>
  */
 
+#include <linux/moduleparam.h>
 #include "intel_drv.h"
 
 #define PCI_LBPC 0xf4 /* legacy/combination backlight modes */
@@ -191,6 +192,10 @@ u32 intel_panel_get_max_backlight(struct
 	return max;
 }
 
+static bool brightness_inverted;
+MODULE_PARM_DESC(brightness_inverted, "Backlight brightness value is inverted "
+	"(0 = max brightness, max value = dark)");
+module_param_named(brightness_inverted, brightness_inverted, bool, 0600);
 u32 intel_panel_get_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -212,6 +217,10 @@ u32 intel_panel_get_backlight(struct drm
 	}
 
 	DRM_DEBUG_DRIVER("get backlight PWM = %d\n", val);
+	if (brightness_inverted) {
+		u32 max = intel_panel_get_max_backlight(dev);
+		val = max - val;
+	}
 	return val;
 }
 
@@ -229,6 +238,11 @@ static void intel_panel_actually_set_bac
 
 	DRM_DEBUG_DRIVER("set backlight PWM = %d\n", level);
 
+	if (brightness_inverted) {
+		u32 max = intel_panel_get_max_backlight(dev);
+		level = max - level;
+	}
+
 	if (HAS_PCH_SPLIT(dev))
 		return intel_pch_panel_set_backlight(dev, level);
 

