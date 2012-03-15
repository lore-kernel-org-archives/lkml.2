Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030682Ab2COPAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:00:24 -0400
Received: from HSI-KBW-109-192-167-159.hsi6.kabel-badenwuerttemberg.de ([109.192.167.159]:38400
	"EHLO rack0slot8.osadl.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965190Ab2COO7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:59:03 -0400
Message-Id: <20120315145828.308069018@osadl.org>
User-Agent: quilt/0.48-1
Date: Thu, 15 Mar 2012 15:56:25 +0100
From: Carsten Emde <C.Emde@osadl.org>
To: David Airlie <airlied@linux.ie>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Keith Packard <keithp@keithp.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Carsten Emde <C.Emde@osadl.org>, DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [V5 PATCH 2/4] drivers-gpu-drm-i915-panel-invert-brightness-via-parameter.patch
References: <20120315145623.486070468@osadl.org>
Content-Disposition: inline; filename=drivers-gpu-drm-i915-panel-invert-brightness-via-parameter.patch
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

This patch adds a parameter to the i915 module to enable inversion of
the brightness variable (i915.invert_brightness).

Signed-off-by: Carsten Emde <C.Emde@osadl.org>

---
 Documentation/kernel-parameters.txt |    9 +++++++++
 drivers/gpu/drm/i915/intel_panel.c  |   17 +++++++++++++++++
 2 files changed, 26 insertions(+)

Index: linux-3.3-rc7/Documentation/kernel-parameters.txt
===================================================================
--- linux-3.3-rc7.orig/Documentation/kernel-parameters.txt
+++ linux-3.3-rc7/Documentation/kernel-parameters.txt
@@ -979,6 +979,15 @@ bytes respectively. Such letter suffixes
 	i8k.restricted	[HW] Allow controlling fans only if SYS_ADMIN
 			capability is set.
 
+	i915.invert_brightness
+			[DRM] Invert the sense of the variable that is used to
+			set the brightness of the panel backlight. Normally a
+			value of 0 indicates backlight switched off, and the
+			maximum value sets the backlight to maximum brightness.
+			If this parameter is specified, a value of 0 sets the
+			backlight to maximum brightness, and the maximum value
+			switches the backlight off.
+
 	icn=		[HW,ISDN]
 			Format: <io>[,<membase>[,<icn_id>[,<icn_id2>]]]
 
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
@@ -191,6 +192,20 @@ u32 intel_panel_get_max_backlight(struct
 	return max;
 }
 
+static bool i915_panel_invert_brightness;
+MODULE_PARM_DESC(invert_brightness, "Invert backlight brightness, please "
+	"report PCI device ID, subsystem vendor and subsystem device ID "
+	"to dri-devel@lists.freedesktop.org, if your machine needs it. "
+	"It will then be included in an upcoming module version.");
+module_param_named(invert_brightness, i915_panel_invert_brightness, bool, 0600);
+static u32 intel_panel_compute_brightness(struct drm_device *dev, u32 val)
+{
+	if (i915_panel_invert_brightness)
+		return intel_panel_get_max_backlight(dev) - val;
+
+	return val;
+}
+
 u32 intel_panel_get_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -211,6 +226,7 @@ u32 intel_panel_get_backlight(struct drm
 		}
 	}
 
+	val = intel_panel_compute_brightness(dev, val);
 	DRM_DEBUG_DRIVER("get backlight PWM = %d\n", val);
 	return val;
 }
@@ -228,6 +244,7 @@ static void intel_panel_actually_set_bac
 	u32 tmp;
 
 	DRM_DEBUG_DRIVER("set backlight PWM = %d\n", level);
+	level = intel_panel_compute_brightness(dev, level);
 
 	if (HAS_PCH_SPLIT(dev))
 		return intel_pch_panel_set_backlight(dev, level);

