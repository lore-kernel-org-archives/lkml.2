Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab1GOQnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:43:49 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35831 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab1GOQnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:43:47 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 11/15] gma500: More Moorestown muddle meddling means MM maybe
 might modeset
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 15 Jul 2011 17:34:58 +0100
Message-ID: <20110715163452.28759.10942.stgit@localhost.localdomain>
In-Reply-To: <20110715163117.28759.14946.stgit@localhost.localdomain>
References: <20110715163117.28759.14946.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

There are a least three different species we need to deal with and right
now it seems the only way to sort them out is via DMI. Encapsulate the
entire pile somewhere private and out of the way.

Hopefully a saner method will emerge later.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mrst_device.c |  150 +++++++++++++++++++++++++++++-----
 drivers/staging/gma500/mrst_lvds.c   |    5 +
 drivers/staging/gma500/psb_drv.h     |    8 ++
 3 files changed, 141 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/gma500/mrst_device.c b/drivers/staging/gma500/mrst_device.c
index 20677f9..573142f 100644
--- a/drivers/staging/gma500/mrst_device.c
+++ b/drivers/staging/gma500/mrst_device.c
@@ -18,6 +18,8 @@
  **************************************************************************/
 
 #include <linux/backlight.h>
+#include <linux/module.h>
+#include <linux/dmi.h>
 #include <drm/drmP.h>
 #include <drm/drm.h>
 #include "psb_drm.h"
@@ -28,7 +30,33 @@
 #include <asm/intel_scu_ipc.h>
 #include "mid_bios.h"
 
-static const struct psb_ops oaktrail_chip_ops;
+static int devtype;
+
+module_param_named(type, devtype, int, 0600);
+MODULE_PARM_DESC(type, "Moorestown/Oaktrail device type");
+
+#define DEVICE_MOORESTOWN		1
+#define DEVICE_OAKTRAIL			2
+#define DEVICE_MOORESTOWN_MM		3
+
+static int mrst_device_ident(struct drm_device *dev)
+{
+	/* User forced */
+	if (devtype)
+		return devtype;
+	if (dmi_match(DMI_PRODUCT_NAME, "OakTrail") ||
+		dmi_match(DMI_PRODUCT_NAME, "OakTrail platform"))
+		return DEVICE_OAKTRAIL;
+#if defined(CONFIG_X86_MRST)
+	if (dmi_match(DMI_PRODUCT_NAME, "MM") ||
+		dmi_match(DMI_PRODUCT_NAME, "MM 10"))
+		return DEVICE_MOORESTOWN_MM;
+	if (mrst_identify_cpu())
+		return DEVICE_MOORESTOWN;
+#endif
+	return DEVICE_OAKTRAIL;
+}
+
 
 /* IPC message and command defines used to enable/disable mipi panel voltages */
 #define IPC_MSG_PANEL_ON_OFF    0xE9
@@ -266,8 +294,10 @@ static int mrst_save_display_registers(struct drm_device *dev)
 	dev_priv->saveOV_OGAMC5 = PSB_RVDC32(OV_OGAMC5);
 
 	/* DPST registers */
-	dev_priv->saveHISTOGRAM_INT_CONTROL_REG = PSB_RVDC32(HISTOGRAM_INT_CONTROL);
-	dev_priv->saveHISTOGRAM_LOGIC_CONTROL_REG = PSB_RVDC32(HISTOGRAM_LOGIC_CONTROL);
+	dev_priv->saveHISTOGRAM_INT_CONTROL_REG =
+					PSB_RVDC32(HISTOGRAM_INT_CONTROL);
+	dev_priv->saveHISTOGRAM_LOGIC_CONTROL_REG =
+					PSB_RVDC32(HISTOGRAM_LOGIC_CONTROL);
 	dev_priv->savePWM_CONTROL_LOGIC = PSB_RVDC32(PWM_CONTROL_LOGIC);
 
 	if (dev_priv->iLVDS_enable) {
@@ -282,7 +312,7 @@ static int mrst_save_display_registers(struct drm_device *dev)
 		PSB_WVDC32(0x58000000, DSPACNTR);
 		/* Trigger the plane disable */
 		PSB_WVDC32(0, DSPASURF);
-		
+
 		/* Wait ~4 ticks */
 		msleep(4);
 
@@ -401,8 +431,10 @@ static int mrst_restore_display_registers(struct drm_device *dev)
 	PSB_WVDC32(dev_priv->saveOV_OGAMC5, OV_OGAMC5);
 
 	/* DPST registers */
-	PSB_WVDC32(dev_priv->saveHISTOGRAM_INT_CONTROL_REG, HISTOGRAM_INT_CONTROL);
-	PSB_WVDC32(dev_priv->saveHISTOGRAM_LOGIC_CONTROL_REG, HISTOGRAM_LOGIC_CONTROL);
+	PSB_WVDC32(dev_priv->saveHISTOGRAM_INT_CONTROL_REG,
+						HISTOGRAM_INT_CONTROL);
+	PSB_WVDC32(dev_priv->saveHISTOGRAM_LOGIC_CONTROL_REG,
+						HISTOGRAM_LOGIC_CONTROL);
 	PSB_WVDC32(dev_priv->savePWM_CONTROL_LOGIC, PWM_CONTROL_LOGIC);
 
 	return 0;
@@ -458,38 +490,44 @@ static int mrst_power_up(struct drm_device *dev)
 	return 0;
 }
 
-static int mrst_chip_setup(struct drm_device *dev)
+#if defined(CONFIG_X86_MRST)
+static void mrst_lvds_cache_bl(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 
-#if defined(CONFIG_X86_MRST)
-	if (mrst_identify_cpu())
-		return mid_chip_setup(dev);
-#endif
-	dev_priv->ops = &oaktrail_chip_ops;
-	mrst_hdmi_setup(dev);
-	/* Check - may be better to go via BIOS paths ? */
-	return mid_chip_setup(dev);
+	intel_scu_ipc_ioread8(0x28, &(dev_priv->saveBKLTCNT));
+	intel_scu_ipc_ioread8(0x29, &(dev_priv->saveBKLTREQ));
+	intel_scu_ipc_ioread8(0x2A, &(dev_priv->saveBKLTBRTL));
 }
 
-static void oaktrail_teardown(struct drm_device *dev)
+static void mrst_mm_bl_power(struct drm_device *dev, bool on)
 {
-	mrst_hdmi_teardown(dev);
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	if (on) {
+		intel_scu_ipc_iowrite8(0x2A, dev_priv->saveBKLTBRTL);
+		intel_scu_ipc_iowrite8(0x28, dev_priv->saveBKLTCNT);
+		intel_scu_ipc_iowrite8(0x29, dev_priv->saveBKLTREQ);
+	} else {
+		intel_scu_ipc_iowrite8(0x2A, 0);
+		intel_scu_ipc_iowrite8(0x28, 0);
+		intel_scu_ipc_iowrite8(0x29, 0);
+	}
 }
-	
-const struct psb_ops mrst_chip_ops = {
-	.name = "Moorestown",
+
+static const struct psb_ops mrst_mm_chip_ops = {
+	.name = "Moorestown MM ",
 	.accel_2d = 1,
 	.pipes = 1,
 	.crtcs = 1,
 	.sgx_offset = MRST_SGX_OFFSET,
 
-	.chip_setup = mrst_chip_setup,
 	.crtc_helper = &mrst_helper_funcs,
 	.crtc_funcs = &psb_intel_crtc_funcs,
 
 	.output_init = mrst_output_init,
 
+	.lvds_bl_power = mrst_mm_bl_power,
 #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
 	.backlight_init = mrst_backlight_init,
 #endif
@@ -499,8 +537,17 @@ const struct psb_ops mrst_chip_ops = {
 	.restore_regs = mrst_restore_display_registers,
 	.power_down = mrst_power_down,
 	.power_up = mrst_power_up,
+
+	.i2c_bus = 0,
 };
 
+#endif
+
+static void oaktrail_teardown(struct drm_device *dev)
+{
+	mrst_hdmi_teardown(dev);
+}
+
 static const struct psb_ops oaktrail_chip_ops = {
 	.name = "Oaktrail",
 	.accel_2d = 1,
@@ -524,5 +571,66 @@ static const struct psb_ops oaktrail_chip_ops = {
 	.restore_regs = mrst_restore_display_registers,
 	.power_down = mrst_power_down,
 	.power_up = mrst_power_up,
+
+	.i2c_bus = 1,
+};
+
+/**
+ *	mrst_chip_setup		-	perform the initial chip init
+ *	@dev: Our drm_device
+ *
+ *	Figure out which incarnation we are and then scan the firmware for
+ *	tables and information.
+ */
+static int mrst_chip_setup(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	switch (mrst_device_ident(dev)) {
+	case DEVICE_OAKTRAIL:
+		/* Dual CRTC, PC compatible, HDMI, I2C #2 */
+		dev_priv->ops = &oaktrail_chip_ops;
+		mrst_hdmi_setup(dev);
+		return mid_chip_setup(dev);
+#if defined(CONFIG_X86_MRST)
+	case DEVICE_MOORESTOWN_MM:
+		/* Single CRTC, No HDMI, I2C #0, BL control */
+		mrst_lvds_cache_bl(dev);
+		dev_priv->ops = &mrst_mm_chip_ops;
+		return mid_chip_setup(dev);
+	case DEVICE_MOORESTOWN:
+		/* Dual CRTC, No HDMI(?), I2C #1 */
+		return mid_chip_setup(dev);
+#endif
+	default:
+		dev_err(dev->dev, "unsupported device type.\n");
+		return -ENODEV;
+	}
+}
+
+const struct psb_ops mrst_chip_ops = {
+	.name = "Moorestown",
+	.accel_2d = 1,
+	.pipes = 2,
+	.crtcs = 2,
+	.sgx_offset = MRST_SGX_OFFSET,
+
+	.chip_setup = mrst_chip_setup,
+	.crtc_helper = &mrst_helper_funcs,
+	.crtc_funcs = &psb_intel_crtc_funcs,
+
+	.output_init = mrst_output_init,
+
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+	.backlight_init = mrst_backlight_init,
+#endif
+
+	.init_pm = mrst_init_pm,
+	.save_regs = mrst_save_display_registers,
+	.restore_regs = mrst_restore_display_registers,
+	.power_down = mrst_power_down,
+	.power_up = mrst_power_up,
+
+	.i2c_bus = 2,
 };
 
diff --git a/drivers/staging/gma500/mrst_lvds.c b/drivers/staging/gma500/mrst_lvds.c
index 3e15ecd..108f245 100644
--- a/drivers/staging/gma500/mrst_lvds.c
+++ b/drivers/staging/gma500/mrst_lvds.c
@@ -58,7 +58,11 @@ static void mrst_lvds_set_power(struct drm_device *dev,
 			pp_status = REG_READ(PP_STATUS);
 		} while ((pp_status & (PP_ON | PP_READY)) == PP_READY);
 		dev_priv->is_lvds_on = true;
+	        if (dev_priv->ops->lvds_bl_power)
+	                dev_priv->ops->lvds_bl_power(dev, true);
 	} else {
+	        if (dev_priv->ops->lvds_bl_power)
+	                dev_priv->ops->lvds_bl_power(dev, false);
 		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) &
 			  ~POWER_TARGET_ON);
 		do {
@@ -67,7 +71,6 @@ static void mrst_lvds_set_power(struct drm_device *dev,
 		dev_priv->is_lvds_on = false;
 		pm_request_idle(&dev->pdev->dev);
 	}
-
 	gma_power_end(dev);
 }
 
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 25275f7..829657b 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -388,6 +388,11 @@ struct drm_psb_private {
 	uint32_t dspcntr1;
 	uint32_t dspcntr2;
 
+	/* Moorestown MM backlight cache */
+	uint8_t saveBKLTCNT;
+	uint8_t saveBKLTREQ;
+	uint8_t saveBKLTBRTL;
+
 	/*
 	 * Register state
 	 */
@@ -644,10 +649,13 @@ struct psb_ops {
 	int (*restore_regs)(struct drm_device *dev);
 	int (*power_up)(struct drm_device *dev);
 	int (*power_down)(struct drm_device *dev);
+
+	void (*lvds_bl_power)(struct drm_device *dev, bool on);
 #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
 	/* Backlight */
 	int (*backlight_init)(struct drm_device *dev);
 #endif
+	int i2c_bus;		/* I2C bus identifier for Moorestown */
 };
 
 

