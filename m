Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab0FVX7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 19:59:23 -0400
Received: from smtp-out.google.com ([74.125.121.35]:9580 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab0FVX7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 19:59:21 -0400
From: Bryan Freed <bfreed@chromium.org>
To: airlied@linux.ie
Cc: airlied@redhat.com, ben@decadent.org.uk, eric@anholt.net,
       mateusz.kaduk@gmail.com, jbarnes@virtuousgeek.org,
       chris@chris-wilson.co.uk, bgamari.foss@gmail.com, apw@canonical.com,
       yakui.zhao@intel.com, zhenyuw@linux.intel.com,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Bryan Freed <bfreed@chromium.org>
Subject: [PATCH] Implement direct pineview backlight control.
Date: Tue, 22 Jun 2010 16:58:27 -0700
Message-Id: <1277251107-24828-1-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.0.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drm/i915: Add a direct interface for pineview backlight support.

This adds a Kconfig variable CONFIG_DRM_I915_DIRECT_BACKLIGHT to
optionally include the new source file i915_backlight.c.  This file
registers a couple backlight set/get routines with the standard
drivers/video/backlight interface to add a directory under
/sys/class/backlight/.

The big problem I see with this modification is that the i915 driver
_already_ supports backlight level adjustment in i915_opregion.c.
Unfortunately, that requires an IRQ to occur as the result of writing
some ASLE (ACPI Source Language Event) register, and this requires
BIOS support for the ACPI hook.  It looks like we will not have such
support in our initial custom BIOS.

So I copy a small amount of code from i915_opregion.c to make backlight
adjustment directly available to the backlight framework.

Another problem is that I do not cover all the cases handled by the
i915_opregion.c code.  It would be too much untested code copying to
do so.  I enforce the lack of support by checking for IS_PINEVIEW()
in i915_backlight_init().

Review URL: http://codereview.chromium.org/2830015
Signed-off-by: Bryan Freed <bfreed@chromium.org>

---
 drivers/gpu/drm/Kconfig               |   12 +++
 drivers/gpu/drm/i915/Makefile         |    1 +
 drivers/gpu/drm/i915/i915_backlight.c |  120 +++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_dma.c       |    5 ++
 drivers/gpu/drm/i915/i915_drv.h       |   19 +++++
 5 files changed, 157 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/i915_backlight.c

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 305c590..14e21c3 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -124,6 +124,18 @@ config DRM_I915_KMS
 	  the driver to bind to PCI devices, which precludes loading things
 	  like intelfb.
 
+config DRM_I915_DIRECT_BACKLIGHT
+	bool "Enable direct backlight control"
+	depends on DRM_I915
+	help
+	  Choose this option if you want the i915 driver to provide direct
+	  backlight control via /sys/class/backlight/i915_backlight.  This
+	  is in addition to the ACPI interface (which may also be in that
+	  directory) that uses ASLE (ACPI Source Language Events) events to
+	  get to i915_opregion.c code.
+	  Direct backlight control gives finer granularity (0-256) than ACPI
+	  and does not require BIOS support.
+
 endchoice
 
 config DRM_MGA
diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
index 9929f84..a2d6c52 100644
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@ -31,5 +31,6 @@ i915-y := i915_drv.o i915_dma.o i915_irq.o i915_mem.o \
 
 i915-$(CONFIG_ACPI)	+= i915_opregion.o
 i915-$(CONFIG_COMPAT)   += i915_ioc32.o
+i915-$(CONFIG_DRM_I915_DIRECT_BACKLIGHT)	+= i915_backlight.o
 
 obj-$(CONFIG_DRM_I915)  += i915.o
diff --git a/drivers/gpu/drm/i915/i915_backlight.c b/drivers/gpu/drm/i915/i915_backlight.c
new file mode 100644
index 0000000..18e33e7
--- /dev/null
+++ b/drivers/gpu/drm/i915/i915_backlight.c
@@ -0,0 +1,120 @@
+/*
+ *  i915_backlight.c - ChromeOS specific backlight support for pineview
+ *
+ *
+ *  Copyright (C) 2010 ChromeOS contributors
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/backlight.h>
+
+#include "drmP.h"
+#include "i915_drm.h"
+#include "i915_drv.h"
+
+/*
+ * Somewhat arbitrarily choose a max brightness level of 256 (as full "on")
+ * and a PWM frequency of 0x1000.  The frequency can be as high as 0x7fff,
+ * but we do not need that level of flexibility.
+ */
+#define MAX_BRIGHTNESS 256
+#define PWM_FREQUENCY 0x1000
+
+/*
+ * The Pineview LVDS Backlight PWM Control register is a 32 bit word split
+ * into two unsigned 16 bit words: the high order short is the cycle frequency,
+ * and the low order word is the duty cycle.  According to i915_opregion.c,
+ * the low order bit of each short is unused.
+ *
+ * While the frequency is hardcoded, these macros provide masking and shifting
+ * for the duty cycle.
+ */
+#define CTL_TO_PWM(ctl) ((ctl & BACKLIGHT_DUTY_CYCLE_MASK) >> 1)
+#define PWM_TO_CTL(pwm) ((pwm << 1) & BACKLIGHT_DUTY_CYCLE_MASK)
+
+static int i915_get_intensity(struct backlight_device *bd)
+{
+	struct drm_device *dev = bl_get_data(bd);
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	u32 blc_pwm_ctl;
+	int level, pwm_val;
+
+	blc_pwm_ctl = I915_READ(BLC_PWM_CTL);
+	pwm_val = CTL_TO_PWM(blc_pwm_ctl);
+	level = (pwm_val * MAX_BRIGHTNESS) / PWM_FREQUENCY;
+
+	return level;
+}
+
+static int i915_set_intensity(struct backlight_device *bd)
+{
+	struct drm_device *dev = bl_get_data(bd);
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	int level, pwm_val;
+	u32 blc_pwm_ctl;
+
+	level = bd->props.brightness;
+	if (level > MAX_BRIGHTNESS)
+		level = MAX_BRIGHTNESS;
+
+	pwm_val = (level * PWM_FREQUENCY) / MAX_BRIGHTNESS;
+	blc_pwm_ctl = (PWM_FREQUENCY << BACKLIGHT_MODULATION_FREQ_SHIFT) |
+		PWM_TO_CTL(pwm_val);
+	I915_WRITE(BLC_PWM_CTL, blc_pwm_ctl);
+
+	return 0;
+}
+
+static struct backlight_ops i915_bl_ops = {
+	.get_brightness = i915_get_intensity,
+	.update_status = i915_set_intensity,
+};
+
+void i915_backlight_init(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct backlight_device *bd;
+
+	if (!IS_PINEVIEW(dev)) {
+		dev_printk(KERN_WARNING, &dev->pdev->dev,
+		"i915_backlight_init only supports the pineview version\n");
+		return;
+	}
+
+	bd = backlight_device_register("i915_backlight",
+		&dev->pdev->dev, dev, &i915_bl_ops);
+	if (IS_ERR(bd)) {
+		dev_printk(KERN_WARNING, &dev->pdev->dev,
+			"Unable to register i915 backlight.\n");
+		return;
+	}
+
+	dev_priv->backlight = bd;
+	bd->props.max_brightness = MAX_BRIGHTNESS;
+	bd->props.brightness = 0;
+	backlight_update_status(bd);
+	return;
+}
+
+void i915_backlight_exit(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+
+	if (dev_priv->backlight) {
+		backlight_device_unregister(dev_priv->backlight);
+		dev_priv->backlight = NULL;
+	}
+}
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index b24e814..fe4d41c 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1504,6 +1504,9 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 
 	setup_timer(&dev_priv->hangcheck_timer, i915_hangcheck_elapsed,
 		    (unsigned long) dev);
+
+	i915_backlight_init(dev);
+
 	return 0;
 
 out_workqueue_free:
@@ -1523,6 +1526,8 @@ int i915_driver_unload(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
+	i915_backlight_exit(dev);
+
 	destroy_workqueue(dev_priv->wq);
 	del_timer_sync(&dev_priv->hangcheck_timer);
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index b99b6a8..6c82752 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -34,6 +34,10 @@
 #include "intel_bios.h"
 #include <linux/io-mapping.h>
 
+#ifdef CONFIG_DRM_I915_DIRECT_BACKLIGHT
+#include <linux/backlight.h>
+#endif
+
 /* General customization:
  */
 
@@ -590,6 +594,12 @@ typedef struct drm_i915_private {
 	int child_dev_num;
 	struct child_device_config *child_dev;
 	struct drm_connector *int_lvds_connector;
+
+#ifdef CONFIG_DRM_I915_DIRECT_BACKLIGHT
+	/* direct backlight interface */
+	struct backlight_device *backlight;
+#endif
+
 } drm_i915_private_t;
 
 /** driver private structure attached to each drm_gem_object */
@@ -939,6 +949,15 @@ static inline void ironlake_opregion_gse_intr(struct drm_device *dev) { return;
 static inline void opregion_enable_asle(struct drm_device *dev) { return; }
 #endif
 
+#ifdef CONFIG_DRM_I915_DIRECT_BACKLIGHT
+/* i915_backlight.c */
+extern void i915_backlight_init(struct drm_device *dev);
+extern void i915_backlight_exit(struct drm_device *dev);
+#else
+extern inline void i915_backlight_init(struct drm_device *dev) { return; }
+extern inline void i915_backlight_exit(struct drm_device *dev) { return; }
+#endif
+
 /* modesetting */
 extern void intel_modeset_init(struct drm_device *dev);
 extern void intel_modeset_cleanup(struct drm_device *dev);
-- 
1.7.0.1

