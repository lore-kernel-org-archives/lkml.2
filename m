Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab1GOQng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:43:36 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35829 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1GOQne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:43:34 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 10/15] gma500: Add the Oaktrail HDMI support
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 15 Jul 2011 17:34:41 +0100
Message-ID: <20110715163438.28759.63646.stgit@localhost.localdomain>
In-Reply-To: <20110715163117.28759.14946.stgit@localhost.localdomain>
References: <20110715163117.28759.14946.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This differs enough from the Cedarview HDMI sufficiently to want to keep
them separated.

We need to sort out the power management for Oaktrail/Moorestown in order
to plumb this lot into the register handling logic.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Makefile        |    4 
 drivers/staging/gma500/mrst.h          |   35 +
 drivers/staging/gma500/mrst_device.c   |  246 +++++++--
 drivers/staging/gma500/mrst_hdmi.c     |  852 ++++++++++++++++++++++++++++++++
 drivers/staging/gma500/mrst_hdmi_i2c.c |  327 ++++++++++++
 drivers/staging/gma500/psb_drv.c       |    2 
 drivers/staging/gma500/psb_drv.h       |    4 
 7 files changed, 1401 insertions(+), 69 deletions(-)
 create mode 100644 drivers/staging/gma500/mrst_hdmi.c
 create mode 100644 drivers/staging/gma500/mrst_hdmi_i2c.c

diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index e515edf..fe34f18 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -32,7 +32,9 @@ psb_gfx-$(CONFIG_DRM_PSB_CDV) +=  cdv_device.o \
 
 psb_gfx-$(CONFIG_DRM_PSB_MRST) += mrst_device.o \
 	  mrst_crtc.o \
-	  mrst_lvds.o
+	  mrst_lvds.o \
+	  mrst_hdmi.o \
+	  mrst_hdmi_i2c.o
 
 psb_gfx-$(CONFIG_DRM_PSB_MFLD) += mdfld_device.o \
 	  mdfld_output.o \
diff --git a/drivers/staging/gma500/mrst.h b/drivers/staging/gma500/mrst.h
index 7bacb9a..b563dbc 100644
--- a/drivers/staging/gma500/mrst.h
+++ b/drivers/staging/gma500/mrst.h
@@ -215,3 +215,38 @@ struct mrst_gct_data {
 
 #define GCT_R10_HEADER_SIZE		16
 #define GCT_R10_DISPLAY_DESC_SIZE	28
+
+/*
+ *	Moorestown HDMI interfaces
+ */
+
+struct mrst_hdmi_dev {
+	struct pci_dev *dev;
+	void __iomem *regs;
+	unsigned int mmio, mmio_len;
+	int dpms_mode;
+	struct hdmi_i2c_dev *i2c_dev;
+
+	/* register state */
+	u32 saveDPLL_CTRL;
+	u32 saveDPLL_DIV_CTRL;
+	u32 saveDPLL_ADJUST;
+	u32 saveDPLL_UPDATE;
+	u32 saveDPLL_CLK_ENABLE;
+	u32 savePCH_HTOTAL_B;
+	u32 savePCH_HBLANK_B;
+	u32 savePCH_HSYNC_B;
+	u32 savePCH_VTOTAL_B;
+	u32 savePCH_VBLANK_B;
+	u32 savePCH_VSYNC_B;
+	u32 savePCH_PIPEBCONF;
+	u32 savePCH_PIPEBSRC;
+};
+
+extern void mrst_hdmi_setup(struct drm_device *dev);
+extern void mrst_hdmi_teardown(struct drm_device *dev);
+extern int  mrst_hdmi_i2c_init(struct pci_dev *dev);
+extern void mrst_hdmi_i2c_exit(struct pci_dev *dev);
+extern void mrst_hdmi_save(struct drm_device *dev);
+extern void mrst_hdmi_restore(struct drm_device *dev);
+extern void mrst_hdmi_init(struct drm_device *dev, struct psb_intel_mode_device *mode_dev);
diff --git a/drivers/staging/gma500/mrst_device.c b/drivers/staging/gma500/mrst_device.c
index 3d525a0..20677f9 100644
--- a/drivers/staging/gma500/mrst_device.c
+++ b/drivers/staging/gma500/mrst_device.c
@@ -38,12 +38,13 @@ static const struct psb_ops oaktrail_chip_ops;
 static int mrst_output_init(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	if (dev_priv->iLVDS_enable) {
+	if (dev_priv->iLVDS_enable)
 		mrst_lvds_init(dev, &dev_priv->mode_dev);
-		return 0;
-	}
-	dev_err(dev->dev, "DSI is not supported\n");
-	return -ENODEV;
+	else
+		dev_err(dev->dev, "DSI is not supported\n");
+	if (dev_priv->hdmi_priv)
+		mrst_hdmi_init(dev, &dev_priv->mode_dev);
+	return 0;
 }
 
 /*
@@ -195,8 +196,8 @@ static void mrst_init_pm(struct drm_device *dev)
 static int mrst_save_display_registers(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct drm_crtc *crtc;
-	struct drm_connector *connector;
+	int i;
+	u32 pp_stat;
 
 	/* Display arbitration control + watermarks */
 	dev_priv->saveDSPARB = PSB_RVDC32(DSPARB);
@@ -208,17 +209,91 @@ static int mrst_save_display_registers(struct drm_device *dev)
 	dev_priv->saveDSPFW6 = PSB_RVDC32(DSPFW6);
 	dev_priv->saveCHICKENBIT = PSB_RVDC32(DSPCHICKENBIT);
 
-	/* Save crtc and output state */
-	mutex_lock(&dev->mode_config.mutex);
-	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
-		if (drm_helper_crtc_in_use(crtc))
-			crtc->funcs->save(crtc);
-	}
+	/* Pipe & plane A info */
+	dev_priv->savePIPEACONF = PSB_RVDC32(PIPEACONF);
+	dev_priv->savePIPEASRC = PSB_RVDC32(PIPEASRC);
+	dev_priv->saveFPA0 = PSB_RVDC32(MRST_FPA0);
+	dev_priv->saveFPA1 = PSB_RVDC32(MRST_FPA1);
+	dev_priv->saveDPLL_A = PSB_RVDC32(MRST_DPLL_A);
+	dev_priv->saveHTOTAL_A = PSB_RVDC32(HTOTAL_A);
+	dev_priv->saveHBLANK_A = PSB_RVDC32(HBLANK_A);
+	dev_priv->saveHSYNC_A = PSB_RVDC32(HSYNC_A);
+	dev_priv->saveVTOTAL_A = PSB_RVDC32(VTOTAL_A);
+	dev_priv->saveVBLANK_A = PSB_RVDC32(VBLANK_A);
+	dev_priv->saveVSYNC_A = PSB_RVDC32(VSYNC_A);
+	dev_priv->saveBCLRPAT_A = PSB_RVDC32(BCLRPAT_A);
+	dev_priv->saveDSPACNTR = PSB_RVDC32(DSPACNTR);
+	dev_priv->saveDSPASTRIDE = PSB_RVDC32(DSPASTRIDE);
+	dev_priv->saveDSPAADDR = PSB_RVDC32(DSPABASE);
+	dev_priv->saveDSPASURF = PSB_RVDC32(DSPASURF);
+	dev_priv->saveDSPALINOFF = PSB_RVDC32(DSPALINOFF);
+	dev_priv->saveDSPATILEOFF = PSB_RVDC32(DSPATILEOFF);
+
+	/* Save cursor regs */
+	dev_priv->saveDSPACURSOR_CTRL = PSB_RVDC32(CURACNTR);
+	dev_priv->saveDSPACURSOR_BASE = PSB_RVDC32(CURABASE);
+	dev_priv->saveDSPACURSOR_POS = PSB_RVDC32(CURAPOS);
+
+	/* Save palette (gamma) */
+	for (i = 0; i < 256; i++)
+		dev_priv->save_palette_a[i] = PSB_RVDC32(PALETTE_A + (i << 2));
+
+	if (dev_priv->hdmi_priv)
+		mrst_hdmi_save(dev);
+
+	/* Save performance state */
+	dev_priv->savePERF_MODE = PSB_RVDC32(MRST_PERF_MODE);
+
+	/* LVDS state */
+	dev_priv->savePP_CONTROL = PSB_RVDC32(PP_CONTROL);
+	dev_priv->savePFIT_PGM_RATIOS = PSB_RVDC32(PFIT_PGM_RATIOS);
+	dev_priv->savePFIT_AUTO_RATIOS = PSB_RVDC32(PFIT_AUTO_RATIOS);
+	dev_priv->saveBLC_PWM_CTL = PSB_RVDC32(BLC_PWM_CTL);
+	dev_priv->saveBLC_PWM_CTL2 = PSB_RVDC32(BLC_PWM_CTL2);
+	dev_priv->saveLVDS = PSB_RVDC32(LVDS);
+	dev_priv->savePFIT_CONTROL = PSB_RVDC32(PFIT_CONTROL);
+	dev_priv->savePP_ON_DELAYS = PSB_RVDC32(LVDSPP_ON);
+	dev_priv->savePP_OFF_DELAYS = PSB_RVDC32(LVDSPP_OFF);
+	dev_priv->savePP_DIVISOR = PSB_RVDC32(PP_CYCLE);
+
+	/* HW overlay */
+	dev_priv->saveOV_OVADD = PSB_RVDC32(OV_OVADD);
+	dev_priv->saveOV_OGAMC0 = PSB_RVDC32(OV_OGAMC0);
+	dev_priv->saveOV_OGAMC1 = PSB_RVDC32(OV_OGAMC1);
+	dev_priv->saveOV_OGAMC2 = PSB_RVDC32(OV_OGAMC2);
+	dev_priv->saveOV_OGAMC3 = PSB_RVDC32(OV_OGAMC3);
+	dev_priv->saveOV_OGAMC4 = PSB_RVDC32(OV_OGAMC4);
+	dev_priv->saveOV_OGAMC5 = PSB_RVDC32(OV_OGAMC5);
+
+	/* DPST registers */
+	dev_priv->saveHISTOGRAM_INT_CONTROL_REG = PSB_RVDC32(HISTOGRAM_INT_CONTROL);
+	dev_priv->saveHISTOGRAM_LOGIC_CONTROL_REG = PSB_RVDC32(HISTOGRAM_LOGIC_CONTROL);
+	dev_priv->savePWM_CONTROL_LOGIC = PSB_RVDC32(PWM_CONTROL_LOGIC);
+
+	if (dev_priv->iLVDS_enable) {
+		/* Shut down the panel */
+		PSB_WVDC32(0, PP_CONTROL);
 
-	list_for_each_entry(connector, &dev->mode_config.connector_list, head)
-		connector->funcs->save(connector);
+		do {
+			pp_stat = PSB_RVDC32(PP_STATUS);
+		} while (pp_stat & 0x80000000);
 
-	mutex_unlock(&dev->mode_config.mutex);
+		/* Turn off the plane */
+		PSB_WVDC32(0x58000000, DSPACNTR);
+		/* Trigger the plane disable */
+		PSB_WVDC32(0, DSPASURF);
+		
+		/* Wait ~4 ticks */
+		msleep(4);
+
+		/* Turn off pipe */
+		PSB_WVDC32(0x0, PIPEACONF);
+		/* Wait ~8 ticks */
+		msleep(8);
+
+		/* Turn off PLLs */
+		PSB_WVDC32(0, MRST_DPLL_A);
+	}
 	return 0;
 }
 
@@ -231,18 +306,8 @@ static int mrst_save_display_registers(struct drm_device *dev)
 static int mrst_restore_display_registers(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct drm_crtc *crtc;
-	struct drm_connector *connector;
-	int pp_stat;
-
-	if (!dev_priv->iLVDS_enable) {
-#ifdef CONFIG_X86_MRST
-		intel_scu_ipc_simple_command(IPC_MSG_PANEL_ON_OFF,
-							IPC_CMD_PANEL_ON);
-		/* FIXME: can we avoid this delay ? */
-		msleep(2000); /* wait 2 seconds */
-#endif
-	}
+	u32 pp_stat;
+	int i;
 
 	/* Display arbitration + watermarks */
 	PSB_WVDC32(dev_priv->saveDSPARB, DSPARB);
@@ -254,54 +319,92 @@ static int mrst_restore_display_registers(struct drm_device *dev)
 	PSB_WVDC32(dev_priv->saveDSPFW6, DSPFW6);
 	PSB_WVDC32(dev_priv->saveCHICKENBIT, DSPCHICKENBIT);
 
-	/*make sure VGA plane is off. it initializes to on after reset!*/
+	/* Make sure VGA plane is off. it initializes to on after reset!*/
 	PSB_WVDC32(0x80000000, VGACNTRL);
 
-	mutex_lock(&dev->mode_config.mutex);
-	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head)
-		if (drm_helper_crtc_in_use(crtc))
-			crtc->funcs->restore(crtc);
+	/* set the plls */
+	PSB_WVDC32(dev_priv->saveFPA0, MRST_FPA0);
+	PSB_WVDC32(dev_priv->saveFPA1, MRST_FPA1);
 
-	list_for_each_entry(connector, &dev->mode_config.connector_list, head)
-		connector->funcs->restore(connector);
+	/* Actually enable it */
+	PSB_WVDC32(dev_priv->saveDPLL_A, MRST_DPLL_A);
+	DRM_UDELAY(150);
 
-	mutex_unlock(&dev->mode_config.mutex);
+	/* Restore mode */
+	PSB_WVDC32(dev_priv->saveHTOTAL_A, HTOTAL_A);
+	PSB_WVDC32(dev_priv->saveHBLANK_A, HBLANK_A);
+	PSB_WVDC32(dev_priv->saveHSYNC_A, HSYNC_A);
+	PSB_WVDC32(dev_priv->saveVTOTAL_A, VTOTAL_A);
+	PSB_WVDC32(dev_priv->saveVBLANK_A, VBLANK_A);
+	PSB_WVDC32(dev_priv->saveVSYNC_A, VSYNC_A);
+	PSB_WVDC32(dev_priv->savePIPEASRC, PIPEASRC);
+	PSB_WVDC32(dev_priv->saveBCLRPAT_A, BCLRPAT_A);
 
-	if (dev_priv->iLVDS_enable) {
-		/*shutdown the panel*/
-		PSB_WVDC32(0, PP_CONTROL);
-		do {
-			pp_stat = PSB_RVDC32(PP_STATUS);
-		} while (pp_stat & 0x80000000);
+	/* Restore performance mode*/
+	PSB_WVDC32(dev_priv->savePERF_MODE, MRST_PERF_MODE);
 
-		/* Turn off the plane */
-		PSB_WVDC32(0x58000000, DSPACNTR);
-		PSB_WVDC32(0, DSPASURF);/*trigger the plane disable*/
-		/* Wait ~4 ticks */
-		msleep(4);
-		/* Turn off pipe */
-		PSB_WVDC32(0x0, PIPEACONF);
-		/* Wait ~8 ticks */
-		msleep(8);
+	/* Enable the pipe*/
+	if (dev_priv->iLVDS_enable)
+		PSB_WVDC32(dev_priv->savePIPEACONF, PIPEACONF);
 
-		/* Turn off PLLs */
-		PSB_WVDC32(0, MRST_DPLL_A);
-	} else {
-		PSB_WVDC32(DPI_SHUT_DOWN, DPI_CONTROL_REG);
-		PSB_WVDC32(0x0, PIPEACONF);
-		PSB_WVDC32(0x2faf0000, BLC_PWM_CTL);
-		while (REG_READ(0x70008) & 0x40000000)
-			cpu_relax();
-		while ((PSB_RVDC32(GEN_FIFO_STAT_REG) & DPI_FIFO_EMPTY)
-			!= DPI_FIFO_EMPTY)
-			cpu_relax();
-		PSB_WVDC32(0, DEVICE_READY_REG);
-		/* Turn off panel power */
-#ifdef CONFIG_X86_MRST	/* FIXME: kill define once modular */
-		intel_scu_ipc_simple_command(IPC_MSG_PANEL_ON_OFF,
-							IPC_CMD_PANEL_OFF);
-#endif
+	/* Set up the plane*/
+	PSB_WVDC32(dev_priv->saveDSPALINOFF, DSPALINOFF);
+	PSB_WVDC32(dev_priv->saveDSPASTRIDE, DSPASTRIDE);
+	PSB_WVDC32(dev_priv->saveDSPATILEOFF, DSPATILEOFF);
+
+	/* Enable the plane */
+	PSB_WVDC32(dev_priv->saveDSPACNTR, DSPACNTR);
+	PSB_WVDC32(dev_priv->saveDSPASURF, DSPASURF);
+
+	/* Enable Cursor A */
+	PSB_WVDC32(dev_priv->saveDSPACURSOR_CTRL, CURACNTR);
+	PSB_WVDC32(dev_priv->saveDSPACURSOR_POS, CURAPOS);
+	PSB_WVDC32(dev_priv->saveDSPACURSOR_BASE, CURABASE);
+
+	/* Restore palette (gamma) */
+	for (i = 0; i < 256; i++)
+		PSB_WVDC32(dev_priv->save_palette_a[i], PALETTE_A + (i << 2));
+
+	if (dev_priv->hdmi_priv)
+		mrst_hdmi_restore(dev);
+
+	if (dev_priv->iLVDS_enable) {
+		PSB_WVDC32(dev_priv->saveBLC_PWM_CTL2, BLC_PWM_CTL2);
+		PSB_WVDC32(dev_priv->saveLVDS, LVDS); /*port 61180h*/
+		PSB_WVDC32(dev_priv->savePFIT_CONTROL, PFIT_CONTROL);
+		PSB_WVDC32(dev_priv->savePFIT_PGM_RATIOS, PFIT_PGM_RATIOS);
+		PSB_WVDC32(dev_priv->savePFIT_AUTO_RATIOS, PFIT_AUTO_RATIOS);
+		PSB_WVDC32(dev_priv->saveBLC_PWM_CTL, BLC_PWM_CTL);
+		PSB_WVDC32(dev_priv->savePP_ON_DELAYS, LVDSPP_ON);
+		PSB_WVDC32(dev_priv->savePP_OFF_DELAYS, LVDSPP_OFF);
+		PSB_WVDC32(dev_priv->savePP_DIVISOR, PP_CYCLE);
+		PSB_WVDC32(dev_priv->savePP_CONTROL, PP_CONTROL);
 	}
+
+	/* Wait for cycle delay */
+	do {
+		pp_stat = PSB_RVDC32(PP_STATUS);
+	} while (pp_stat & 0x08000000);
+
+	/* Wait for panel power up */
+	do {
+		pp_stat = PSB_RVDC32(PP_STATUS);
+	} while (pp_stat & 0x10000000);
+
+	/* Restore HW overlay */
+	PSB_WVDC32(dev_priv->saveOV_OVADD, OV_OVADD);
+	PSB_WVDC32(dev_priv->saveOV_OGAMC0, OV_OGAMC0);
+	PSB_WVDC32(dev_priv->saveOV_OGAMC1, OV_OGAMC1);
+	PSB_WVDC32(dev_priv->saveOV_OGAMC2, OV_OGAMC2);
+	PSB_WVDC32(dev_priv->saveOV_OGAMC3, OV_OGAMC3);
+	PSB_WVDC32(dev_priv->saveOV_OGAMC4, OV_OGAMC4);
+	PSB_WVDC32(dev_priv->saveOV_OGAMC5, OV_OGAMC5);
+
+	/* DPST registers */
+	PSB_WVDC32(dev_priv->saveHISTOGRAM_INT_CONTROL_REG, HISTOGRAM_INT_CONTROL);
+	PSB_WVDC32(dev_priv->saveHISTOGRAM_LOGIC_CONTROL_REG, HISTOGRAM_LOGIC_CONTROL);
+	PSB_WVDC32(dev_priv->savePWM_CONTROL_LOGIC, PWM_CONTROL_LOGIC);
+
 	return 0;
 }
 
@@ -364,9 +467,15 @@ static int mrst_chip_setup(struct drm_device *dev)
 		return mid_chip_setup(dev);
 #endif
 	dev_priv->ops = &oaktrail_chip_ops;
+	mrst_hdmi_setup(dev);
 	/* Check - may be better to go via BIOS paths ? */
 	return mid_chip_setup(dev);
 }
+
+static void oaktrail_teardown(struct drm_device *dev)
+{
+	mrst_hdmi_teardown(dev);
+}
 	
 const struct psb_ops mrst_chip_ops = {
 	.name = "Moorestown",
@@ -400,6 +509,7 @@ static const struct psb_ops oaktrail_chip_ops = {
 	.sgx_offset = MRST_SGX_OFFSET,
 
 	.chip_setup = mid_chip_setup,
+	.chip_teardown = oaktrail_teardown,
 	.crtc_helper = &mrst_helper_funcs,
 	.crtc_funcs = &psb_intel_crtc_funcs,
 
diff --git a/drivers/staging/gma500/mrst_hdmi.c b/drivers/staging/gma500/mrst_hdmi.c
new file mode 100644
index 0000000..d6a5179
--- /dev/null
+++ b/drivers/staging/gma500/mrst_hdmi.c
@@ -0,0 +1,852 @@
+/*
+ * Copyright © 2010 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ *	Li Peng <peng.li@intel.com>
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include "psb_intel_drv.h"
+#include "psb_intel_reg.h"
+#include "psb_drv.h"
+
+#define HDMI_READ(reg)		readl(hdmi_dev->regs + (reg))
+#define HDMI_WRITE(reg, val)	writel(val, hdmi_dev->regs + (reg))
+
+#define HDMI_HCR	0x1000
+#define HCR_ENABLE_HDCP		(1 << 5)
+#define HCR_ENABLE_AUDIO	(1 << 2)
+#define HCR_ENABLE_PIXEL	(1 << 1)
+#define HCR_ENABLE_TMDS		(1 << 0)
+
+#define HDMI_HICR	0x1004
+#define HDMI_HSR	0x1008
+#define HDMI_HISR	0x100C
+#define HDMI_DETECT_HDP		(1 << 0)
+
+#define HDMI_VIDEO_REG	0x3000
+#define HDMI_UNIT_EN		(1 << 7)
+#define HDMI_MODE_OUTPUT	(1 << 0)
+#define HDMI_HBLANK_A	0x3100
+
+#define HDMI_AUDIO_CTRL	0x4000
+#define HDMI_ENABLE_AUDIO	(1 << 0)
+
+#define PCH_HTOTAL_B	0x3100
+#define PCH_HBLANK_B	0x3104
+#define PCH_HSYNC_B	0x3108
+#define PCH_VTOTAL_B	0x310C
+#define PCH_VBLANK_B	0x3110
+#define PCH_VSYNC_B	0x3114
+#define PCH_PIPEBSRC	0x311C
+
+#define PCH_PIPEB_DSL	0x3800
+#define PCH_PIPEB_SLC	0x3804
+#define PCH_PIPEBCONF	0x3808
+#define PCH_PIPEBSTAT	0x3824
+
+#define CDVO_DFT	0x5000
+#define CDVO_SLEWRATE	0x5004
+#define CDVO_STRENGTH	0x5008
+#define CDVO_RCOMP	0x500C
+
+#define DPLL_CTRL       0x6000
+#define DPLL_PDIV_SHIFT		16
+#define DPLL_PDIV_MASK		(0xf << 16)
+#define DPLL_PWRDN		(1 << 4)
+#define DPLL_RESET		(1 << 3)
+#define DPLL_FASTEN		(1 << 2)
+#define DPLL_ENSTAT		(1 << 1)
+#define DPLL_DITHEN		(1 << 0)
+
+#define DPLL_DIV_CTRL   0x6004
+#define DPLL_CLKF_MASK		0xffffffc0
+#define DPLL_CLKR_MASK		(0x3f)
+
+#define DPLL_CLK_ENABLE 0x6008
+#define DPLL_EN_DISP		(1 << 31)
+#define DPLL_SEL_HDMI		(1 << 8)
+#define DPLL_EN_HDMI		(1 << 1)
+#define DPLL_EN_VGA		(1 << 0)
+
+#define DPLL_ADJUST     0x600C
+#define DPLL_STATUS     0x6010
+#define DPLL_UPDATE     0x6014
+#define DPLL_DFT        0x6020
+
+struct intel_range {
+	int	min, max;
+};
+
+struct mrst_hdmi_limit {
+	struct intel_range vco, np, nr, nf;
+};
+
+struct mrst_hdmi_clock {
+	int np;
+	int nr;
+	int nf;
+	int dot;
+};
+
+#define VCO_MIN		320000
+#define VCO_MAX		1650000
+#define	NP_MIN		1
+#define	NP_MAX		15
+#define	NR_MIN		1
+#define	NR_MAX		64
+#define NF_MIN		2
+#define NF_MAX		4095
+
+static const struct mrst_hdmi_limit mrst_hdmi_limit = {
+	.vco = { .min = VCO_MIN,		.max = VCO_MAX },
+	.np  = { .min = NP_MIN,			.max = NP_MAX  },
+	.nr  = { .min = NR_MIN,			.max = NR_MAX  },
+	.nf  = { .min = NF_MIN,			.max = NF_MAX  },
+};
+
+static void wait_for_vblank(struct drm_device *dev)
+{
+	/* FIXME: Can we do this as a sleep ? */
+	/* Wait for 20ms, i.e. one cycle at 50hz. */
+	udelay(20000);
+}
+
+static void scu_busy_loop(void *scu_base)
+{
+	u32 status = 0;
+	u32 loop_count = 0;
+
+	status = readl(scu_base + 0x04);
+	while (status & 1) {
+		udelay(1); /* scu processing time is in few u secods */
+		status = readl(scu_base + 0x04);
+		loop_count++;
+		/* break if scu doesn't reset busy bit after huge retry */
+		if (loop_count > 1000) {
+			DRM_DEBUG_KMS("SCU IPC timed out");
+			return;
+		}
+	}
+}
+
+static void mrst_hdmi_reset(struct drm_device *dev)
+{
+	void *base;
+	/* FIXME: at least make these defines */
+	unsigned int scu_ipc_mmio = 0xff11c000;
+	int scu_len = 1024;
+
+	base = ioremap((resource_size_t)scu_ipc_mmio, scu_len);
+	if (base == NULL) {
+		DRM_ERROR("failed to map SCU mmio\n");
+		return;
+	}
+
+	/* scu ipc: assert hdmi controller reset */
+	writel(0xff11d118, base + 0x0c);
+	writel(0x7fffffdf, base + 0x80);
+	writel(0x42005, base + 0x0);
+	scu_busy_loop(base);
+
+	/* scu ipc: de-assert hdmi controller reset */
+	writel(0xff11d118, base + 0x0c);
+	writel(0x7fffffff, base + 0x80);
+	writel(0x42005, base + 0x0);
+	scu_busy_loop(base);
+
+	iounmap(base);
+}
+
+static void mrst_hdmi_audio_enable(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mrst_hdmi_dev *hdmi_dev = dev_priv->hdmi_priv;
+
+	HDMI_WRITE(HDMI_HCR, 0x67);
+	HDMI_READ(HDMI_HCR);
+
+	HDMI_WRITE(0x51a8, 0x10);
+	HDMI_READ(0x51a8);
+
+	HDMI_WRITE(HDMI_AUDIO_CTRL, 0x1);
+	HDMI_READ(HDMI_AUDIO_CTRL);
+}
+
+static void mrst_hdmi_audio_disable(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mrst_hdmi_dev *hdmi_dev = dev_priv->hdmi_priv;
+
+	HDMI_WRITE(0x51a8, 0x0);
+	HDMI_READ(0x51a8);
+
+	HDMI_WRITE(HDMI_AUDIO_CTRL, 0x0);
+	HDMI_READ(HDMI_AUDIO_CTRL);
+
+	HDMI_WRITE(HDMI_HCR, 0x47);
+	HDMI_READ(HDMI_HCR);
+}
+
+void mrst_crtc_hdmi_dpms(struct drm_crtc *crtc, int mode)
+{
+	struct drm_device *dev = crtc->dev;
+	u32 temp;
+
+	switch (mode) {
+	case DRM_MODE_DPMS_OFF:
+		/* Disable VGACNTRL */
+		REG_WRITE(VGACNTRL, 0x80000000);
+
+		/* Disable plane */
+		temp = REG_READ(DSPBCNTR);
+		if ((temp & DISPLAY_PLANE_ENABLE) != 0) {
+			REG_WRITE(DSPBCNTR, temp & ~DISPLAY_PLANE_ENABLE);
+			REG_READ(DSPBCNTR);
+			/* Flush the plane changes */
+			REG_WRITE(DSPBSURF, REG_READ(DSPBSURF));
+			REG_READ(DSPBSURF);
+		}
+
+		/* Disable pipe B */
+		temp = REG_READ(PIPEBCONF);
+		if ((temp & PIPEACONF_ENABLE) != 0) {
+			REG_WRITE(PIPEBCONF, temp & ~PIPEACONF_ENABLE);
+			REG_READ(PIPEBCONF);
+		}
+
+		/* Disable LNW Pipes, etc */
+		temp = REG_READ(PCH_PIPEBCONF);
+		if ((temp & PIPEACONF_ENABLE) != 0) {
+			REG_WRITE(PCH_PIPEBCONF, temp & ~PIPEACONF_ENABLE);
+			REG_READ(PCH_PIPEBCONF);
+		}
+		/* wait for pipe off */
+		udelay(150);
+		/* Disable dpll */
+		temp = REG_READ(DPLL_CTRL);
+		if ((temp & DPLL_PWRDN) == 0) {
+			REG_WRITE(DPLL_CTRL, temp | (DPLL_PWRDN | DPLL_RESET));
+			REG_WRITE(DPLL_STATUS, 0x1);
+		}
+		/* wait for dpll off */
+		udelay(150);
+		break;
+	case DRM_MODE_DPMS_ON:
+	case DRM_MODE_DPMS_STANDBY:
+	case DRM_MODE_DPMS_SUSPEND:
+		/* Enable dpll */
+		temp = REG_READ(DPLL_CTRL);
+		if ((temp & DPLL_PWRDN) != 0) {
+			REG_WRITE(DPLL_CTRL, temp & ~(DPLL_PWRDN | DPLL_RESET));
+			temp = REG_READ(DPLL_CLK_ENABLE);
+			REG_WRITE(DPLL_CLK_ENABLE, temp | DPLL_EN_DISP | DPLL_SEL_HDMI | DPLL_EN_HDMI);
+			REG_READ(DPLL_CLK_ENABLE);
+		}
+		/* wait for dpll warm up */
+		udelay(150);
+
+		/* Enable pipe B */
+		temp = REG_READ(PIPEBCONF);
+		if ((temp & PIPEACONF_ENABLE) == 0) {
+			REG_WRITE(PIPEBCONF, temp | PIPEACONF_ENABLE);
+			REG_READ(PIPEBCONF);
+		}
+
+		/* Enable LNW Pipe B */
+		temp = REG_READ(PCH_PIPEBCONF);
+		if ((temp & PIPEACONF_ENABLE) == 0) {
+			REG_WRITE(PCH_PIPEBCONF, temp | PIPEACONF_ENABLE);
+			REG_READ(PCH_PIPEBCONF);
+		}
+		wait_for_vblank(dev);
+
+		/* Enable plane */
+		temp = REG_READ(DSPBCNTR);
+		if ((temp & DISPLAY_PLANE_ENABLE) == 0) {
+			REG_WRITE(DSPBCNTR, temp | DISPLAY_PLANE_ENABLE);
+			/* Flush the plane changes */
+			REG_WRITE(DSPBSURF, REG_READ(DSPBSURF));
+			REG_READ(DSPBSURF);
+		}
+		psb_intel_crtc_load_lut(crtc);
+	}
+	/* DSPARB */
+	REG_WRITE(DSPARB, 0x00003fbf);
+	/* FW1 */
+	REG_WRITE(0x70034, 0x3f880a0a);
+	/* FW2 */
+	REG_WRITE(0x70038, 0x0b060808);
+	/* FW4 */
+	REG_WRITE(0x70050, 0x08030404);
+	/* FW5 */
+	REG_WRITE(0x70054, 0x04040404);
+	/* LNC Chicken Bits */
+	REG_WRITE(0x70400, 0x4000);
+}
+
+
+static void mrst_hdmi_dpms(struct drm_encoder *encoder, int mode)
+{
+	static int dpms_mode = -1;
+
+	struct drm_device *dev = encoder->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mrst_hdmi_dev *hdmi_dev = dev_priv->hdmi_priv;
+	u32 temp;
+
+	if (dpms_mode == mode)
+		return;
+
+	if (mode != DRM_MODE_DPMS_ON)
+		temp = 0x0;
+	else
+		temp = 0x99;
+
+	dpms_mode = mode;
+	HDMI_WRITE(HDMI_VIDEO_REG, temp);
+}
+
+static unsigned int htotal_calculate(struct drm_display_mode *mode)
+{
+	u32 htotal, new_crtc_htotal;
+
+	htotal = (mode->crtc_hdisplay - 1) | ((mode->crtc_htotal - 1) << 16);
+
+	/*
+	 * 1024 x 768  new_crtc_htotal = 0x1024;
+	 * 1280 x 1024 new_crtc_htotal = 0x0c34;
+	 */
+	new_crtc_htotal = (mode->crtc_htotal - 1) * 200 * 1000 / mode->clock;
+
+	return (mode->crtc_hdisplay - 1) | (new_crtc_htotal << 16);
+}
+
+static void mrst_hdmi_find_dpll(struct drm_crtc *crtc, int target,
+				int refclk, struct mrst_hdmi_clock *best_clock)
+{
+	int np_min, np_max, nr_min, nr_max;
+	int np, nr, nf;
+
+	np_min = DIV_ROUND_UP(mrst_hdmi_limit.vco.min, target * 10);
+	np_max = mrst_hdmi_limit.vco.max / (target * 10);
+	if (np_min < mrst_hdmi_limit.np.min)
+		np_min = mrst_hdmi_limit.np.min;
+	if (np_max > mrst_hdmi_limit.np.max)
+		np_max = mrst_hdmi_limit.np.max;
+
+	nr_min = DIV_ROUND_UP((refclk * 1000), (target * 10 * np_max));
+	nr_max = DIV_ROUND_UP((refclk * 1000), (target * 10 * np_min));
+	if (nr_min < mrst_hdmi_limit.nr.min)
+		nr_min = mrst_hdmi_limit.nr.min;
+	if (nr_max > mrst_hdmi_limit.nr.max)
+		nr_max = mrst_hdmi_limit.nr.max;
+
+	np = DIV_ROUND_UP((refclk * 1000), (target * 10 * nr_max));
+	nr = DIV_ROUND_UP((refclk * 1000), (target * 10 * np));
+	nf = DIV_ROUND_CLOSEST((target * 10 * np * nr), refclk);
+	DRM_DEBUG_KMS("np, nr, nf %d %d %d\n", np, nr, nf);
+
+	/*
+	 * 1024 x 768  np = 1; nr = 0x26; nf = 0x0fd8000;
+	 * 1280 x 1024 np = 1; nr = 0x17; nf = 0x1034000;
+	 */
+	best_clock->np = np;
+	best_clock->nr = nr - 1;
+	best_clock->nf = (nf << 14);
+}
+
+int mrst_crtc_hdmi_mode_set(struct drm_crtc *crtc,
+			    struct drm_display_mode *mode,
+			    struct drm_display_mode *adjusted_mode,
+			    int x, int y,
+			    struct drm_framebuffer *old_fb)
+{
+	struct drm_device *dev = crtc->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mrst_hdmi_dev *hdmi_dev = dev_priv->hdmi_priv;
+	int pipe = 1;
+	int htot_reg = (pipe == 0) ? HTOTAL_A : HTOTAL_B;
+	int hblank_reg = (pipe == 0) ? HBLANK_A : HBLANK_B;
+	int hsync_reg = (pipe == 0) ? HSYNC_A : HSYNC_B;
+	int vtot_reg = (pipe == 0) ? VTOTAL_A : VTOTAL_B;
+	int vblank_reg = (pipe == 0) ? VBLANK_A : VBLANK_B;
+	int vsync_reg = (pipe == 0) ? VSYNC_A : VSYNC_B;
+	int dspsize_reg = (pipe == 0) ? DSPASIZE : DSPBSIZE;
+	int dsppos_reg = (pipe == 0) ? DSPAPOS : DSPBPOS;
+	int pipesrc_reg = (pipe == 0) ? PIPEASRC : PIPEBSRC;
+	int pipeconf_reg = (pipe == 0) ? PIPEACONF : PIPEBCONF;
+	int refclk;
+	struct mrst_hdmi_clock clock;
+	u32 dspcntr, pipeconf, dpll, temp;
+	int dspcntr_reg = DSPBCNTR;
+
+	/* Disable the VGA plane that we never use */
+	REG_WRITE(VGACNTRL, VGA_DISP_DISABLE);
+
+	/* XXX: Disable the panel fitter if it was on our pipe */
+
+	/* Disable dpll if necessary */
+	dpll = REG_READ(DPLL_CTRL);
+	if ((dpll & DPLL_PWRDN) == 0) {
+		REG_WRITE(DPLL_CTRL, dpll | (DPLL_PWRDN | DPLL_RESET));
+		REG_WRITE(DPLL_DIV_CTRL, 0x00000000);
+		REG_WRITE(DPLL_STATUS, 0x1);
+	}
+	udelay(150);
+
+	/* reset controller: FIXME - can we sort out the ioremap mess ? */
+	iounmap(hdmi_dev->regs);
+	mrst_hdmi_reset(dev);
+
+	/* program and enable dpll */
+	refclk = 25000;
+	mrst_hdmi_find_dpll(crtc, adjusted_mode->clock, refclk, &clock);
+
+	/* Setting DPLL */
+	dpll = REG_READ(DPLL_CTRL);
+	dpll &= ~DPLL_PDIV_MASK;
+	dpll &= ~(DPLL_PWRDN | DPLL_RESET);
+	REG_WRITE(DPLL_CTRL, 0x00000008);
+	REG_WRITE(DPLL_DIV_CTRL, ((clock.nf << 6) | clock.nr));
+	REG_WRITE(DPLL_ADJUST, ((clock.nf >> 14) - 1));
+	REG_WRITE(DPLL_CTRL, (dpll | (clock.np << DPLL_PDIV_SHIFT) | DPLL_ENSTAT | DPLL_DITHEN));
+	REG_WRITE(DPLL_UPDATE, 0x80000000);
+	REG_WRITE(DPLL_CLK_ENABLE, 0x80050102);
+	udelay(150);
+
+	hdmi_dev->regs = ioremap(hdmi_dev->mmio, hdmi_dev->mmio_len);
+	if (hdmi_dev->regs == NULL) {
+		DRM_ERROR("failed to do hdmi mmio mapping\n");
+		return -ENOMEM;
+	}
+
+	/* configure HDMI */
+	HDMI_WRITE(0x1004, 0x1fd);
+	HDMI_WRITE(0x2000, 0x1);
+	HDMI_WRITE(0x2008, 0x0);
+	HDMI_WRITE(0x3130, 0x8);
+	HDMI_WRITE(0x101c, 0x1800810);
+
+	temp = htotal_calculate(adjusted_mode);
+	REG_WRITE(htot_reg, temp);
+	REG_WRITE(hblank_reg, (adjusted_mode->crtc_hblank_start - 1) | ((adjusted_mode->crtc_hblank_end - 1) << 16));
+	REG_WRITE(hsync_reg, (adjusted_mode->crtc_hsync_start - 1) | ((adjusted_mode->crtc_hsync_end - 1) << 16));
+	REG_WRITE(vtot_reg, (adjusted_mode->crtc_vdisplay - 1) | ((adjusted_mode->crtc_vtotal - 1) << 16));
+	REG_WRITE(vblank_reg, (adjusted_mode->crtc_vblank_start - 1) | ((adjusted_mode->crtc_vblank_end - 1) << 16));
+	REG_WRITE(vsync_reg, (adjusted_mode->crtc_vsync_start - 1) | ((adjusted_mode->crtc_vsync_end - 1) << 16));
+	REG_WRITE(pipesrc_reg,
+		((mode->crtc_hdisplay - 1) << 16) |  (mode->crtc_vdisplay - 1));
+
+	REG_WRITE(PCH_HTOTAL_B, (adjusted_mode->crtc_hdisplay - 1) | ((adjusted_mode->crtc_htotal - 1) << 16));
+	REG_WRITE(PCH_HBLANK_B, (adjusted_mode->crtc_hblank_start - 1) | ((adjusted_mode->crtc_hblank_end - 1) << 16));
+	REG_WRITE(PCH_HSYNC_B, (adjusted_mode->crtc_hsync_start - 1) | ((adjusted_mode->crtc_hsync_end - 1) << 16));
+	REG_WRITE(PCH_VTOTAL_B, (adjusted_mode->crtc_vdisplay - 1) | ((adjusted_mode->crtc_vtotal - 1) << 16));
+	REG_WRITE(PCH_VBLANK_B, (adjusted_mode->crtc_vblank_start - 1) | ((adjusted_mode->crtc_vblank_end - 1) << 16));
+	REG_WRITE(PCH_VSYNC_B, (adjusted_mode->crtc_vsync_start - 1) | ((adjusted_mode->crtc_vsync_end - 1) << 16));
+	REG_WRITE(PCH_PIPEBSRC,
+		((mode->crtc_hdisplay - 1) << 16) |  (mode->crtc_vdisplay - 1));
+
+	temp = adjusted_mode->crtc_hblank_end - adjusted_mode->crtc_hblank_start;
+	HDMI_WRITE(HDMI_HBLANK_A, ((adjusted_mode->crtc_hdisplay - 1) << 16) |  temp);
+
+	REG_WRITE(dspsize_reg,
+			((mode->vdisplay - 1) << 16) | (mode->hdisplay - 1));
+	REG_WRITE(dsppos_reg, 0);
+
+	/* Flush the plane changes */
+	{
+		struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
+		crtc_funcs->mode_set_base(crtc, x, y, old_fb);
+	}
+
+	/* Set up the display plane register */
+	dspcntr = REG_READ(dspcntr_reg);
+	dspcntr |= DISPPLANE_GAMMA_ENABLE;
+	dspcntr |= DISPPLANE_SEL_PIPE_B;
+	dspcntr |= DISPLAY_PLANE_ENABLE;
+
+	/* setup pipeconf */
+	pipeconf = REG_READ(pipeconf_reg);
+	pipeconf |= PIPEACONF_ENABLE;
+
+	REG_WRITE(pipeconf_reg, pipeconf);
+	REG_READ(pipeconf_reg);
+
+	REG_WRITE(PCH_PIPEBCONF, pipeconf);
+	REG_READ(PCH_PIPEBCONF);
+	wait_for_vblank(dev);
+
+	REG_WRITE(dspcntr_reg, dspcntr);
+	wait_for_vblank(dev);
+
+	return 0;
+}
+
+static int mrst_hdmi_mode_valid(struct drm_connector *connector,
+				struct drm_display_mode *mode)
+{
+	if (mode->clock > 165000)
+		return MODE_CLOCK_HIGH;
+	if (mode->clock < 20000)
+		return MODE_CLOCK_LOW;
+
+	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
+		return MODE_NO_DBLESCAN;
+
+	return MODE_OK;
+}
+
+static bool mrst_hdmi_mode_fixup(struct drm_encoder *encoder,
+				 struct drm_display_mode *mode,
+				 struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
+
+static enum drm_connector_status
+mrst_hdmi_detect(struct drm_connector *connector, bool force)
+{
+	enum drm_connector_status status;
+	struct drm_device *dev = connector->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mrst_hdmi_dev *hdmi_dev = dev_priv->hdmi_priv;
+	u32 temp;
+
+	temp = HDMI_READ(HDMI_HSR);
+	DRM_DEBUG_KMS("HDMI_HSR %x\n", temp);
+
+	if ((temp & HDMI_DETECT_HDP) != 0)
+		status = connector_status_connected;
+	else
+		status = connector_status_disconnected;
+
+	return status;
+}
+
+static const unsigned char raw_edid[] = {
+	0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x10, 0xac, 0x2f, 0xa0,
+	0x53, 0x55, 0x33, 0x30, 0x16, 0x13, 0x01, 0x03, 0x0e, 0x3a, 0x24, 0x78,
+	0xea, 0xe9, 0xf5, 0xac, 0x51, 0x30, 0xb4, 0x25, 0x11, 0x50, 0x54, 0xa5,
+	0x4b, 0x00, 0x81, 0x80, 0xa9, 0x40, 0x71, 0x4f, 0xb3, 0x00, 0x01, 0x01,
+	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x28, 0x3c, 0x80, 0xa0, 0x70, 0xb0,
+	0x23, 0x40, 0x30, 0x20, 0x36, 0x00, 0x46, 0x6c, 0x21, 0x00, 0x00, 0x1a,
+	0x00, 0x00, 0x00, 0xff, 0x00, 0x47, 0x4e, 0x37, 0x32, 0x31, 0x39, 0x35,
+	0x52, 0x30, 0x33, 0x55, 0x53, 0x0a, 0x00, 0x00, 0x00, 0xfc, 0x00, 0x44,
+	0x45, 0x4c, 0x4c, 0x20, 0x32, 0x37, 0x30, 0x39, 0x57, 0x0a, 0x20, 0x20,
+	0x00, 0x00, 0x00, 0xfd, 0x00, 0x38, 0x4c, 0x1e, 0x53, 0x11, 0x00, 0x0a,
+	0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x00, 0x8d
+};
+
+static int mrst_hdmi_get_modes(struct drm_connector *connector)
+{
+	struct drm_device *dev = connector->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct i2c_adapter *i2c_adap;
+	struct edid *edid;
+	struct drm_display_mode *mode, *t;
+	int i = 0, ret = 0;
+
+	i2c_adap = i2c_get_adapter(3);
+	if (i2c_adap == NULL) {
+		DRM_ERROR("No ddc adapter available!\n");
+		edid = (struct edid *)raw_edid;
+	} else {
+		edid = (struct edid *)raw_edid;
+		/* FIXME ? edid = drm_get_edid(connector, i2c_adap); */
+	}
+
+	if (edid) {
+		drm_mode_connector_update_edid_property(connector, edid);
+		ret = drm_add_edid_modes(connector, edid);
+		connector->display_info.raw_edid = NULL;
+	}
+
+	/*
+	 * prune modes that require frame buffer bigger than stolen mem
+	 */
+	list_for_each_entry_safe(mode, t, &connector->probed_modes, head) {
+		if ((mode->hdisplay * mode->vdisplay * 4) >= dev_priv->vram_stolen_size) {
+			i++;
+			drm_mode_remove(connector, mode);
+		}
+	}
+	return ret - i;
+}
+
+static void mrst_hdmi_mode_set(struct drm_encoder *encoder,
+			       struct drm_display_mode *mode,
+			       struct drm_display_mode *adjusted_mode)
+{
+	struct drm_device *dev = encoder->dev;
+
+	mrst_hdmi_audio_enable(dev);
+	return;
+}
+
+static void mrst_hdmi_destroy(struct drm_connector *connector)
+{
+	return;
+}
+
+static const struct drm_encoder_helper_funcs mrst_hdmi_helper_funcs = {
+	.dpms = mrst_hdmi_dpms,
+	.mode_fixup = mrst_hdmi_mode_fixup,
+	.prepare = psb_intel_encoder_prepare,
+	.mode_set = mrst_hdmi_mode_set,
+	.commit = psb_intel_encoder_commit,
+};
+
+static const struct drm_connector_helper_funcs
+					mrst_hdmi_connector_helper_funcs = {
+	.get_modes = mrst_hdmi_get_modes,
+	.mode_valid = mrst_hdmi_mode_valid,
+	.best_encoder = psb_intel_best_encoder,
+};
+
+static const struct drm_connector_funcs mrst_hdmi_connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.detect = mrst_hdmi_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.destroy = mrst_hdmi_destroy,
+};
+
+static void mrst_hdmi_enc_destroy(struct drm_encoder *encoder)
+{
+	drm_encoder_cleanup(encoder);
+}
+
+static const struct drm_encoder_funcs mrst_hdmi_enc_funcs = {
+	.destroy = mrst_hdmi_enc_destroy,
+};
+
+void mrst_hdmi_init(struct drm_device *dev,
+					struct psb_intel_mode_device *mode_dev)
+{
+	struct psb_intel_output *psb_intel_output;
+	struct drm_connector *connector;
+	struct drm_encoder *encoder;
+
+	psb_intel_output = kzalloc(sizeof(struct psb_intel_output), GFP_KERNEL);
+	if (!psb_intel_output)
+		return;
+
+	psb_intel_output->mode_dev = mode_dev;
+	connector = &psb_intel_output->base;
+	encoder = &psb_intel_output->enc;
+	drm_connector_init(dev, &psb_intel_output->base,
+			   &mrst_hdmi_connector_funcs,
+			   DRM_MODE_CONNECTOR_DVID);
+
+	drm_encoder_init(dev, &psb_intel_output->enc,
+			 &mrst_hdmi_enc_funcs,
+			 DRM_MODE_ENCODER_TMDS);
+
+	drm_mode_connector_attach_encoder(&psb_intel_output->base,
+					  &psb_intel_output->enc);
+
+	psb_intel_output->type = INTEL_OUTPUT_HDMI;
+	drm_encoder_helper_add(encoder, &mrst_hdmi_helper_funcs);
+	drm_connector_helper_add(connector, &mrst_hdmi_connector_helper_funcs);
+
+	connector->display_info.subpixel_order = SubPixelHorizontalRGB;
+	connector->interlace_allowed = false;
+	connector->doublescan_allowed = false;
+	drm_sysfs_connector_add(connector);
+
+	return;
+}
+
+static DEFINE_PCI_DEVICE_TABLE(hdmi_ids) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080d) },
+	{}
+};
+
+void mrst_hdmi_setup(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct pci_dev *pdev;
+	struct mrst_hdmi_dev *hdmi_dev;
+	int ret;
+
+	pdev = pci_get_device(PCI_VENDOR_ID_INTEL, 0x080d, NULL);
+	if (!pdev)
+		return;
+
+	hdmi_dev = kzalloc(sizeof(struct mrst_hdmi_dev), GFP_KERNEL);
+	if (!hdmi_dev) {
+		dev_err(dev->dev, "failed to allocate memory\n");
+		goto out;
+	}
+
+
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(dev->dev, "failed to enable hdmi controller\n");
+		goto free;
+	}
+
+	hdmi_dev->mmio = pci_resource_start(pdev, 0);
+	hdmi_dev->mmio_len = pci_resource_len(pdev, 0);
+	hdmi_dev->regs = ioremap(hdmi_dev->mmio, hdmi_dev->mmio_len);
+	if (!hdmi_dev->regs) {
+		dev_err(dev->dev, "failed to map hdmi mmio\n");
+		goto free;
+	}
+
+	hdmi_dev->dev = pdev;
+	pci_set_drvdata(pdev, hdmi_dev);
+
+	/* Initialize i2c controller */
+	ret = mrst_hdmi_i2c_init(hdmi_dev->dev);
+	if (ret)
+		dev_err(dev->dev, "HDMI I2C initialization failed\n");
+
+	dev_priv->hdmi_priv = hdmi_dev;
+	mrst_hdmi_audio_disable(dev);
+	return;
+
+free:
+	kfree(hdmi_dev);
+out:
+	return;
+}
+
+void mrst_hdmi_teardown(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mrst_hdmi_dev *hdmi_dev = dev_priv->hdmi_priv;
+	struct pci_dev *pdev;
+
+	if (hdmi_dev) {
+		pdev = hdmi_dev->dev;
+		pci_set_drvdata(pdev, NULL);
+		mrst_hdmi_i2c_exit(pdev);
+		iounmap(hdmi_dev->regs);
+		kfree(hdmi_dev);
+		pci_dev_put(pdev);
+	}
+}
+
+/* save HDMI register state */
+void mrst_hdmi_save(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mrst_hdmi_dev *hdmi_dev = dev_priv->hdmi_priv;
+	int i;
+
+	/* dpll */
+	hdmi_dev->saveDPLL_CTRL = PSB_RVDC32(DPLL_CTRL);
+	hdmi_dev->saveDPLL_DIV_CTRL = PSB_RVDC32(DPLL_DIV_CTRL);
+	hdmi_dev->saveDPLL_ADJUST = PSB_RVDC32(DPLL_ADJUST);
+	hdmi_dev->saveDPLL_UPDATE = PSB_RVDC32(DPLL_UPDATE);
+	hdmi_dev->saveDPLL_CLK_ENABLE = PSB_RVDC32(DPLL_CLK_ENABLE);
+
+	/* pipe B */
+	dev_priv->savePIPEBCONF = PSB_RVDC32(PIPEBCONF);
+	dev_priv->savePIPEBSRC  = PSB_RVDC32(PIPEBSRC);
+	dev_priv->saveHTOTAL_B  = PSB_RVDC32(HTOTAL_B);
+	dev_priv->saveHBLANK_B  = PSB_RVDC32(HBLANK_B);
+	dev_priv->saveHSYNC_B   = PSB_RVDC32(HSYNC_B);
+	dev_priv->saveVTOTAL_B  = PSB_RVDC32(VTOTAL_B);
+	dev_priv->saveVBLANK_B  = PSB_RVDC32(VBLANK_B);
+	dev_priv->saveVSYNC_B   = PSB_RVDC32(VSYNC_B);
+
+	hdmi_dev->savePCH_PIPEBCONF = PSB_RVDC32(PCH_PIPEBCONF);
+	hdmi_dev->savePCH_PIPEBSRC = PSB_RVDC32(PCH_PIPEBSRC);
+	hdmi_dev->savePCH_HTOTAL_B = PSB_RVDC32(PCH_HTOTAL_B);
+	hdmi_dev->savePCH_HBLANK_B = PSB_RVDC32(PCH_HBLANK_B);
+	hdmi_dev->savePCH_HSYNC_B  = PSB_RVDC32(PCH_HSYNC_B);
+	hdmi_dev->savePCH_VTOTAL_B = PSB_RVDC32(PCH_VTOTAL_B);
+	hdmi_dev->savePCH_VBLANK_B = PSB_RVDC32(PCH_VBLANK_B);
+	hdmi_dev->savePCH_VSYNC_B  = PSB_RVDC32(PCH_VSYNC_B);
+
+	/* plane */
+	dev_priv->saveDSPBCNTR = PSB_RVDC32(DSPBCNTR);
+	dev_priv->saveDSPBSTRIDE = PSB_RVDC32(DSPBSTRIDE);
+	dev_priv->saveDSPBADDR = PSB_RVDC32(DSPBBASE);
+	dev_priv->saveDSPBSURF = PSB_RVDC32(DSPBSURF);
+	dev_priv->saveDSPBLINOFF = PSB_RVDC32(DSPBLINOFF);
+	dev_priv->saveDSPBTILEOFF = PSB_RVDC32(DSPBTILEOFF);
+
+	/* cursor B */
+	dev_priv->saveDSPBCURSOR_CTRL = PSB_RVDC32(CURBCNTR);
+	dev_priv->saveDSPBCURSOR_BASE = PSB_RVDC32(CURBBASE);
+	dev_priv->saveDSPBCURSOR_POS = PSB_RVDC32(CURBPOS);
+
+	/* save palette */
+	for (i = 0; i < 256; i++)
+		dev_priv->save_palette_b[i] = PSB_RVDC32(PALETTE_B + (i << 2));
+}
+
+/* restore HDMI register state */
+void mrst_hdmi_restore(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mrst_hdmi_dev *hdmi_dev = dev_priv->hdmi_priv;
+	int i;
+
+	/* dpll */
+	PSB_WVDC32(hdmi_dev->saveDPLL_CTRL, DPLL_CTRL);
+	PSB_WVDC32(hdmi_dev->saveDPLL_DIV_CTRL, DPLL_DIV_CTRL);
+	PSB_WVDC32(hdmi_dev->saveDPLL_ADJUST, DPLL_ADJUST);
+	PSB_WVDC32(hdmi_dev->saveDPLL_UPDATE, DPLL_UPDATE);
+	PSB_WVDC32(hdmi_dev->saveDPLL_CLK_ENABLE, DPLL_CLK_ENABLE);
+	DRM_UDELAY(150);
+
+	/* pipe */
+	PSB_WVDC32(dev_priv->savePIPEBSRC, PIPEBSRC);
+	PSB_WVDC32(dev_priv->saveHTOTAL_B, HTOTAL_B);
+	PSB_WVDC32(dev_priv->saveHBLANK_B, HBLANK_B);
+	PSB_WVDC32(dev_priv->saveHSYNC_B,  HSYNC_B);
+	PSB_WVDC32(dev_priv->saveVTOTAL_B, VTOTAL_B);
+	PSB_WVDC32(dev_priv->saveVBLANK_B, VBLANK_B);
+	PSB_WVDC32(dev_priv->saveVSYNC_B,  VSYNC_B);
+
+	PSB_WVDC32(hdmi_dev->savePCH_PIPEBSRC, PCH_PIPEBSRC);
+	PSB_WVDC32(hdmi_dev->savePCH_HTOTAL_B, PCH_HTOTAL_B);
+	PSB_WVDC32(hdmi_dev->savePCH_HBLANK_B, PCH_HBLANK_B);
+	PSB_WVDC32(hdmi_dev->savePCH_HSYNC_B,  PCH_HSYNC_B);
+	PSB_WVDC32(hdmi_dev->savePCH_VTOTAL_B, PCH_VTOTAL_B);
+	PSB_WVDC32(hdmi_dev->savePCH_VBLANK_B, PCH_VBLANK_B);
+	PSB_WVDC32(hdmi_dev->savePCH_VSYNC_B,  PCH_VSYNC_B);
+
+	PSB_WVDC32(dev_priv->savePIPEBCONF, PIPEBCONF);
+	PSB_WVDC32(hdmi_dev->savePCH_PIPEBCONF, PCH_PIPEBCONF);
+
+	/* plane */
+	PSB_WVDC32(dev_priv->saveDSPBLINOFF, DSPBLINOFF);
+	PSB_WVDC32(dev_priv->saveDSPBSTRIDE, DSPBSTRIDE);
+	PSB_WVDC32(dev_priv->saveDSPBTILEOFF, DSPBTILEOFF);
+	PSB_WVDC32(dev_priv->saveDSPBCNTR, DSPBCNTR);
+	PSB_WVDC32(dev_priv->saveDSPBSURF, DSPBSURF);
+
+	/* cursor B */
+	PSB_WVDC32(dev_priv->saveDSPBCURSOR_CTRL, CURBCNTR);
+	PSB_WVDC32(dev_priv->saveDSPBCURSOR_POS, CURBPOS);
+	PSB_WVDC32(dev_priv->saveDSPBCURSOR_BASE, CURBBASE);
+
+	/* restore palette */
+	for (i = 0; i < 256; i++)
+		PSB_WVDC32(dev_priv->save_palette_b[i], PALETTE_B + (i << 2));
+}
diff --git a/drivers/staging/gma500/mrst_hdmi_i2c.c b/drivers/staging/gma500/mrst_hdmi_i2c.c
new file mode 100644
index 0000000..351b9d8
--- /dev/null
+++ b/drivers/staging/gma500/mrst_hdmi_i2c.c
@@ -0,0 +1,327 @@
+/*
+ * Copyright © 2010 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ *	Li Peng <peng.li@intel.com>
+ */
+
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include "psb_drv.h"
+
+#define HDMI_READ(reg)		readl(hdmi_dev->regs + (reg))
+#define HDMI_WRITE(reg, val)	writel(val, hdmi_dev->regs + (reg))
+
+#define HDMI_HCR	0x1000
+#define HCR_DETECT_HDP		(1 << 6)
+#define HCR_ENABLE_HDCP		(1 << 5)
+#define HCR_ENABLE_AUDIO	(1 << 2)
+#define HCR_ENABLE_PIXEL	(1 << 1)
+#define HCR_ENABLE_TMDS		(1 << 0)
+#define HDMI_HICR	0x1004
+#define HDMI_INTR_I2C_ERROR	(1 << 4)
+#define HDMI_INTR_I2C_FULL	(1 << 3)
+#define HDMI_INTR_I2C_DONE	(1 << 2)
+#define HDMI_INTR_HPD		(1 << 0)
+#define HDMI_HSR	0x1008
+#define HDMI_HISR	0x100C
+#define HDMI_HI2CRDB0	0x1200
+#define HDMI_HI2CHCR	0x1240
+#define HI2C_HDCP_WRITE		(0 << 2)
+#define HI2C_HDCP_RI_READ	(1 << 2)
+#define HI2C_HDCP_READ		(2 << 2)
+#define HI2C_EDID_READ		(3 << 2)
+#define HI2C_READ_CONTINUE	(1 << 1)
+#define HI2C_ENABLE_TRANSACTION	(1 << 0)
+
+#define HDMI_ICRH	0x1100
+#define HDMI_HI2CTDR0	0x1244
+#define HDMI_HI2CTDR1	0x1248
+
+#define I2C_STAT_INIT		0
+#define I2C_READ_DONE		1
+#define I2C_TRANSACTION_DONE	2
+
+struct hdmi_i2c_dev {
+	struct i2c_adapter *adap;
+	struct mutex i2c_lock;
+	struct completion complete;
+	int status;
+	struct i2c_msg *msg;
+	int buf_offset;
+};
+
+static void hdmi_i2c_irq_enable(struct mrst_hdmi_dev *hdmi_dev)
+{
+	u32 temp;
+
+	temp = HDMI_READ(HDMI_HICR);
+	temp |= (HDMI_INTR_I2C_ERROR | HDMI_INTR_I2C_FULL | HDMI_INTR_I2C_DONE);
+	HDMI_WRITE(HDMI_HICR, temp);
+	HDMI_READ(HDMI_HICR);
+}
+
+static void hdmi_i2c_irq_disable(struct mrst_hdmi_dev *hdmi_dev)
+{
+	HDMI_WRITE(HDMI_HICR, 0x0);
+	HDMI_READ(HDMI_HICR);
+}
+
+static int xfer_read(struct i2c_adapter *adap, struct i2c_msg *pmsg)
+{
+	struct mrst_hdmi_dev *hdmi_dev = i2c_get_adapdata(adap);
+	struct hdmi_i2c_dev *i2c_dev = hdmi_dev->i2c_dev;
+	u32 temp;
+
+	i2c_dev->status = I2C_STAT_INIT;
+	i2c_dev->msg = pmsg;
+	i2c_dev->buf_offset = 0;
+	INIT_COMPLETION(i2c_dev->complete);
+
+	/* Enable I2C transaction */
+	temp = ((pmsg->len) << 20) | HI2C_EDID_READ | HI2C_ENABLE_TRANSACTION;
+	HDMI_WRITE(HDMI_HI2CHCR, temp);
+	HDMI_READ(HDMI_HI2CHCR);
+
+	while (i2c_dev->status != I2C_TRANSACTION_DONE)
+		wait_for_completion_interruptible_timeout(&i2c_dev->complete,
+								10 * HZ);
+
+	return 0;
+}
+
+static int xfer_write(struct i2c_adapter *adap, struct i2c_msg *pmsg)
+{
+	/*
+	 * XXX: i2c write seems isn't useful for EDID probe, don't do anything
+	 */
+	return 0;
+}
+
+static int mrst_hdmi_i2c_access(struct i2c_adapter *adap,
+				struct i2c_msg *pmsg,
+				int num)
+{
+	struct mrst_hdmi_dev *hdmi_dev = i2c_get_adapdata(adap);
+	struct hdmi_i2c_dev *i2c_dev = hdmi_dev->i2c_dev;
+	int i, err = 0;
+
+	mutex_lock(&i2c_dev->i2c_lock);
+
+	/* Enable i2c unit */
+	HDMI_WRITE(HDMI_ICRH, 0x00008760);
+
+	/* Enable irq */
+	hdmi_i2c_irq_enable(hdmi_dev);
+	for (i = 0; i < num; i++) {
+		if (pmsg->len && pmsg->buf) {
+			if (pmsg->flags & I2C_M_RD)
+				err = xfer_read(adap, pmsg);
+			else
+				err = xfer_write(adap, pmsg);
+		}
+		pmsg++;         /* next message */
+	}
+
+	/* Disable irq */
+	hdmi_i2c_irq_disable(hdmi_dev);
+
+	mutex_unlock(&i2c_dev->i2c_lock);
+
+	return i;
+}
+
+static u32 mrst_hdmi_i2c_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_10BIT_ADDR;
+}
+
+static const struct i2c_algorithm mrst_hdmi_i2c_algorithm = {
+	.master_xfer	= mrst_hdmi_i2c_access,
+	.functionality  = mrst_hdmi_i2c_func,
+};
+
+static struct i2c_adapter mrst_hdmi_i2c_adapter = {
+	.name		= "mrst_hdmi_i2c",
+	.nr		= 3,
+	.owner		= THIS_MODULE,
+	.class		= I2C_CLASS_DDC,
+	.algo		= &mrst_hdmi_i2c_algorithm,
+};
+
+static void hdmi_i2c_read(struct mrst_hdmi_dev *hdmi_dev)
+{
+	struct hdmi_i2c_dev *i2c_dev = hdmi_dev->i2c_dev;
+	struct i2c_msg *msg = i2c_dev->msg;
+	u8 *buf = msg->buf;
+	u32 temp;
+	int i, offset;
+
+	offset = i2c_dev->buf_offset;
+	for (i = 0; i < 0x10; i++) {
+		temp = HDMI_READ(HDMI_HI2CRDB0 + (i * 4));
+		memcpy(buf + (offset + i * 4), &temp, 4);
+	}
+	i2c_dev->buf_offset += (0x10 * 4);
+
+	/* clearing read buffer full intr */
+	temp = HDMI_READ(HDMI_HISR);
+	HDMI_WRITE(HDMI_HISR, temp | HDMI_INTR_I2C_FULL);
+	HDMI_READ(HDMI_HISR);
+
+	/* continue read transaction */
+	temp = HDMI_READ(HDMI_HI2CHCR);
+	HDMI_WRITE(HDMI_HI2CHCR, temp | HI2C_READ_CONTINUE);
+	HDMI_READ(HDMI_HI2CHCR);
+
+	i2c_dev->status = I2C_READ_DONE;
+	return;
+}
+
+static void hdmi_i2c_transaction_done(struct mrst_hdmi_dev *hdmi_dev)
+{
+	struct hdmi_i2c_dev *i2c_dev = hdmi_dev->i2c_dev;
+	u32 temp;
+
+	/* clear transaction done intr */
+	temp = HDMI_READ(HDMI_HISR);
+	HDMI_WRITE(HDMI_HISR, temp | HDMI_INTR_I2C_DONE);
+	HDMI_READ(HDMI_HISR);
+
+
+	temp = HDMI_READ(HDMI_HI2CHCR);
+	HDMI_WRITE(HDMI_HI2CHCR, temp & ~HI2C_ENABLE_TRANSACTION);
+	HDMI_READ(HDMI_HI2CHCR);
+
+	i2c_dev->status = I2C_TRANSACTION_DONE;
+	return;
+}
+
+static irqreturn_t mrst_hdmi_i2c_handler(int this_irq, void *dev)
+{
+	struct mrst_hdmi_dev *hdmi_dev = dev;
+	struct hdmi_i2c_dev *i2c_dev = hdmi_dev->i2c_dev;
+	u32 stat;
+
+	stat = HDMI_READ(HDMI_HISR);
+
+	if (stat & HDMI_INTR_HPD) {
+		HDMI_WRITE(HDMI_HISR, stat | HDMI_INTR_HPD);
+		HDMI_READ(HDMI_HISR);
+	}
+
+	if (stat & HDMI_INTR_I2C_FULL)
+		hdmi_i2c_read(hdmi_dev);
+
+	if (stat & HDMI_INTR_I2C_DONE)
+		hdmi_i2c_transaction_done(hdmi_dev);
+
+	complete(&i2c_dev->complete);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * choose alternate function 2 of GPIO pin 52, 53,
+ * which is used by HDMI I2C logic
+ */
+static void mrst_hdmi_i2c_gpio_fix(void)
+{
+	void *base;
+	unsigned int gpio_base = 0xff12c000;
+	int gpio_len = 0x1000;
+	u32 temp;
+
+	base = ioremap((resource_size_t)gpio_base, gpio_len);
+	if (base == NULL) {
+		DRM_ERROR("gpio ioremap fail\n");
+		return;
+	}
+
+	temp = readl(base + 0x44);
+	DRM_DEBUG_DRIVER("old gpio val %x\n", temp);
+	writel((temp | 0x00000a00), (base +  0x44));
+	temp = readl(base + 0x44);
+	DRM_DEBUG_DRIVER("new gpio val %x\n", temp);
+
+	iounmap(base);
+}
+
+int mrst_hdmi_i2c_init(struct pci_dev *dev)
+{
+	struct mrst_hdmi_dev *hdmi_dev;
+	struct hdmi_i2c_dev *i2c_dev;
+	int ret;
+
+	hdmi_dev = pci_get_drvdata(dev);
+
+	i2c_dev = kzalloc(sizeof(struct hdmi_i2c_dev), GFP_KERNEL);
+	if (i2c_dev == NULL) {
+		DRM_ERROR("Can't allocate interface\n");
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	i2c_dev->adap = &mrst_hdmi_i2c_adapter;
+	i2c_dev->status = I2C_STAT_INIT;
+	init_completion(&i2c_dev->complete);
+	mutex_init(&i2c_dev->i2c_lock);
+	i2c_set_adapdata(&mrst_hdmi_i2c_adapter, hdmi_dev);
+	hdmi_dev->i2c_dev = i2c_dev;
+
+	/* Enable HDMI I2C function on gpio */
+	mrst_hdmi_i2c_gpio_fix();
+
+	/* request irq */
+	ret = request_irq(dev->irq, mrst_hdmi_i2c_handler, IRQF_SHARED,
+			  mrst_hdmi_i2c_adapter.name, hdmi_dev);
+	if (ret) {
+		DRM_ERROR("Failed to request IRQ for I2C controller\n");
+		goto err;
+	}
+
+	/* Adapter registration */
+	ret = i2c_add_numbered_adapter(&mrst_hdmi_i2c_adapter);
+	return ret;
+
+err:
+	kfree(i2c_dev);
+exit:
+	return ret;
+}
+
+void mrst_hdmi_i2c_exit(struct pci_dev *dev)
+{
+	struct mrst_hdmi_dev *hdmi_dev;
+	struct hdmi_i2c_dev *i2c_dev;
+
+	hdmi_dev = pci_get_drvdata(dev);
+	if (i2c_del_adapter(&mrst_hdmi_i2c_adapter))
+		DRM_DEBUG_DRIVER("Failed to delete hdmi-i2c adapter\n");
+
+	i2c_dev = hdmi_dev->i2c_dev;
+	kfree(i2c_dev);
+	free_irq(dev->irq, hdmi_dev);
+}
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 6b03951ebd..4b740aa 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -261,6 +261,8 @@ static int psb_driver_unload(struct drm_device *dev)
 		psb_lid_timer_takedown(dev_priv);
 		gma_intel_opregion_exit(dev);
 
+		if (dev_priv->ops->chip_teardown)
+			dev_priv->ops->chip_teardown(dev);
 		psb_do_takedown(dev);
 
 
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 8184c23..25275f7 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -375,6 +375,9 @@ struct drm_psb_private {
 	bool dbi_panel_on2;	/* The DBI panel power is on */
 	u32 dsr_fb_update;	/* DSR FB update counter */
 
+	/* Moorestown HDMI state */
+	struct mrst_hdmi_dev *hdmi_priv;
+
 	/* Moorestown pipe config register value cache */
 	uint32_t pipeconf;
 	uint32_t pipeconf1;
@@ -631,6 +634,7 @@ struct psb_ops {
 
 	/* Setup hooks */
 	int (*chip_setup)(struct drm_device *dev);
+	void (*chip_teardown)(struct drm_device *dev);
 
 	/* Display management hooks */
 	int (*output_init)(struct drm_device *dev);

