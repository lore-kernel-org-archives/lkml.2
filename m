Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab1GEOx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:53:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50604 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab1GEOxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:53:54 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 44/49] gma500: begin adding CDV specific code
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:44:06 +0100
Message-ID: <20110705144404.23872.33949.stgit@localhost.localdomain>
In-Reply-To: <20110705141038.23872.55303.stgit@localhost.localdomain>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

A lot of the intel_display stuff is duplicated, but we will add it first,
clean it up and then investigate the best way to merge stuff.

This first block integrates the various basic chunks of the CDV display setup.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Makefile            |    5 
 drivers/staging/gma500/cdv_device.c        |  195 ++--
 drivers/staging/gma500/cdv_intel_display.c | 1513 ++++++++++++++++++++++++++++
 drivers/staging/gma500/cdv_intel_lvds.c    |  718 +++++++++++++
 drivers/staging/gma500/framebuffer.c       |    9 
 drivers/staging/gma500/gtt.c               |   33 +
 drivers/staging/gma500/psb_intel_display.c |    3 
 drivers/staging/gma500/psb_intel_reg.h     |   91 ++
 8 files changed, 2459 insertions(+), 108 deletions(-)
 create mode 100644 drivers/staging/gma500/cdv_intel_display.c
 create mode 100644 drivers/staging/gma500/cdv_intel_lvds.c

diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index 961a60c..507aaaf 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -24,7 +24,10 @@ psb_gfx-y += gem_glue.o \
 	  psb_device.o \
 	  mid_bios.o
 
-psb_gfx-$(CONFIG_DRM_PSB_CDV) +=  cdv_device.o
+psb_gfx-$(CONFIG_DRM_PSB_CDV) +=  cdv_device.o \
+	  cdv_intel_display.o \
+	  cdv_intel_crt.o \
+	  cdv_intel_lvds.o
 
 psb_gfx-$(CONFIG_DRM_PSB_MRST) += mrst_device.o \
 	  mrst_crtc.o \
diff --git a/drivers/staging/gma500/cdv_device.c b/drivers/staging/gma500/cdv_device.c
index 530e8a2..622c955 100644
--- a/drivers/staging/gma500/cdv_device.c
+++ b/drivers/staging/gma500/cdv_device.c
@@ -25,13 +25,42 @@
 #include "psb_reg.h"
 #include "psb_intel_reg.h"
 #include "intel_bios.h"
+#include "cdv_device.h"
 
+#define VGA_SR_INDEX		0x3c4
+#define VGA_SR_DATA		0x3c5
+
+/* FIXME: should check if we are the active VGA device ?? */
+static void cdv_disable_vga(struct drm_device *dev)
+{
+	u8 sr1;
+	u32 vga_reg;
+
+	vga_reg = VGACNTRL;
+
+	outb(1, VGA_SR_INDEX);
+	sr1 = inb(VGA_SR_DATA);
+	outb(sr1 | 1<<5, VGA_SR_DATA);
+	udelay(300);
+
+	REG_WRITE(vga_reg, VGA_DISP_DISABLE);
+	REG_READ(vga_reg);
+}
 
 static int cdv_output_init(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	psb_intel_lvds_init(dev, &dev_priv->mode_dev);
-	psb_intel_sdvo_init(dev, SDVOB);
+	cdv_disable_vga(dev);
+
+	cdv_intel_crt_init(dev, &dev_priv->mode_dev);
+	cdv_intel_lvds_init(dev, &dev_priv->mode_dev);
+
+	/* These bits indicate HDMI not SDVO on CDV, but we don't yet support
+	   the HDMI interface */
+	if (REG_READ(SDVOB) & SDVO_DETECTED)
+		DRM_ERROR("HDMI not supported yet\n");
+	if (REG_READ(SDVOC) & SDVO_DETECTED)
+		DRM_ERROR("HDMI not supported yet\n");
 	return 0;
 }
 
@@ -148,19 +177,70 @@ static int cdv_backlight_init(struct drm_device *dev)
 #endif
 
 /*
- *	Provide the Poulsbo specific chip logic and low level methods
+ *	Provide the Cedarview specific chip logic and low level methods
  *	for power management
+ *
+ *	FIXME: we need to implement the apm/ospm base management bits
+ *	for this and the MID devices.
  */
 
+static inline u32 CDV_MSG_READ32(uint port, uint offset)
+{
+	int mcr = (0x10<<24) | (port << 16) | (offset << 8);
+	uint32_t ret_val = 0;
+	struct pci_dev *pci_root = pci_get_bus_and_slot (0, 0);
+	pci_write_config_dword (pci_root, 0xD0, mcr);
+	pci_read_config_dword (pci_root, 0xD4, &ret_val);
+	pci_dev_put(pci_root);
+	return ret_val;
+}
+
+static inline void CDV_MSG_WRITE32(uint port, uint offset, u32 value)
+{
+	int mcr = (0x11<<24) | (port << 16) | (offset << 8) | 0xF0;
+	struct pci_dev *pci_root = pci_get_bus_and_slot (0, 0);
+	pci_write_config_dword (pci_root, 0xD4, value);
+	pci_write_config_dword (pci_root, 0xD0, mcr);
+	pci_dev_put(pci_root);
+}
+
+#define PSB_APM_CMD			0x0
+#define PSB_APM_STS			0x04
+#define PSB_PM_SSC			0x20
+#define PSB_PM_SSS			0x30
+#define PSB_PWRGT_GFX_MASK		0x3
+#define CDV_PWRGT_DISPLAY_CNTR		0x000fc00c
+#define CDV_PWRGT_DISPLAY_STS		0x000fc00c
+
 static void cdv_init_pm(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
-
-	u32 gating = PSB_RSGX32(PSB_CR_CLKGATECTL);
-	gating &= ~3;	/* Disable 2D clock gating */
-	gating |= 1;
-	PSB_WSGX32(gating, PSB_CR_CLKGATECTL);
-	PSB_RSGX32(PSB_CR_CLKGATECTL);
+	u32 pwr_cnt;
+	int i;
+
+	dev_priv->apm_base = CDV_MSG_READ32(PSB_PUNIT_PORT, PSB_APMBA) & 0xFFFF;
+	dev_priv->ospm_base = CDV_MSG_READ32(PSB_PUNIT_PORT, PSB_OSPMBA) & 0xFFFF;
+
+	/* Force power on for now */
+	pwr_cnt = inl(dev_priv->apm_base + PSB_APM_CMD);
+	pwr_cnt &= ~PSB_PWRGT_GFX_MASK;
+
+	outl(pwr_cnt, dev_priv->apm_base + PSB_APM_CMD);
+	for (i = 0; i < 5; i++) {
+		u32 pwr_sts = inl(dev_priv->apm_base + PSB_APM_STS);
+		if ((pwr_sts & PSB_PWRGT_GFX_MASK) == 0)
+			break;
+		udelay(10);
+	}
+	pwr_cnt = inl(dev_priv->ospm_base + PSB_PM_SSC);
+	pwr_cnt &= ~CDV_PWRGT_DISPLAY_CNTR;
+	outl(pwr_cnt, dev_priv->ospm_base + PSB_PM_SSC);
+	for (i = 0; i < 5; i++) {
+		u32 pwr_sts = inl(dev_priv->ospm_base + PSB_PM_SSS);
+		if ((pwr_sts & CDV_PWRGT_DISPLAY_STS) == 0)
+			break;
+		udelay(10);
+	}
 }
 
 /**
@@ -169,34 +249,11 @@ static void cdv_init_pm(struct drm_device *dev)
  *
  *	Save the state we need in order to be able to restore the interface
  *	upon resume from suspend
+ *
+ *	FIXME: review
  */
 static int cdv_save_display_registers(struct drm_device *dev)
 {
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct drm_crtc *crtc;
-	struct drm_connector *connector;
-
-	/* Display arbitration control + watermarks */
-	dev_priv->saveDSPARB = PSB_RVDC32(DSPARB);
-	dev_priv->saveDSPFW1 = PSB_RVDC32(DSPFW1);
-	dev_priv->saveDSPFW2 = PSB_RVDC32(DSPFW2);
-	dev_priv->saveDSPFW3 = PSB_RVDC32(DSPFW3);
-	dev_priv->saveDSPFW4 = PSB_RVDC32(DSPFW4);
-	dev_priv->saveDSPFW5 = PSB_RVDC32(DSPFW5);
-	dev_priv->saveDSPFW6 = PSB_RVDC32(DSPFW6);
-	dev_priv->saveCHICKENBIT = PSB_RVDC32(DSPCHICKENBIT);
-
-	/* Save crtc and output state */
-	mutex_lock(&dev->mode_config.mutex);
-	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
-		if (drm_helper_crtc_in_use(crtc))
-			crtc->funcs->save(crtc);
-	}
-
-	list_for_each_entry(connector, &dev->mode_config.connector_list, head)
-		connector->funcs->save(connector);
-
-	mutex_unlock(&dev->mode_config.mutex);
 	return 0;
 }
 
@@ -205,67 +262,11 @@ static int cdv_save_display_registers(struct drm_device *dev)
  *	@dev: our DRM device
  *
  *	Restore register state that was lost during suspend and resume.
+ *
+ *	FIXME: review
  */
 static int cdv_restore_display_registers(struct drm_device *dev)
 {
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct drm_crtc *crtc;
-	struct drm_connector *connector;
-	int pp_stat;
-
-	/* Display arbitration + watermarks */
-	PSB_WVDC32(dev_priv->saveDSPARB, DSPARB);
-	PSB_WVDC32(dev_priv->saveDSPFW1, DSPFW1);
-	PSB_WVDC32(dev_priv->saveDSPFW2, DSPFW2);
-	PSB_WVDC32(dev_priv->saveDSPFW3, DSPFW3);
-	PSB_WVDC32(dev_priv->saveDSPFW4, DSPFW4);
-	PSB_WVDC32(dev_priv->saveDSPFW5, DSPFW5);
-	PSB_WVDC32(dev_priv->saveDSPFW6, DSPFW6);
-	PSB_WVDC32(dev_priv->saveCHICKENBIT, DSPCHICKENBIT);
-
-	/*make sure VGA plane is off. it initializes to on after reset!*/
-	PSB_WVDC32(0x80000000, VGACNTRL);
-
-	mutex_lock(&dev->mode_config.mutex);
-	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head)
-		if (drm_helper_crtc_in_use(crtc))
-			crtc->funcs->restore(crtc);
-
-	list_for_each_entry(connector, &dev->mode_config.connector_list, head)
-		connector->funcs->restore(connector);
-
-	mutex_unlock(&dev->mode_config.mutex);
-
-	if (dev_priv->iLVDS_enable) {
-		/*shutdown the panel*/
-		PSB_WVDC32(0, PP_CONTROL);
-		do {
-			pp_stat = PSB_RVDC32(PP_STATUS);
-		} while (pp_stat & 0x80000000);
-
-		/* Turn off the plane */
-		PSB_WVDC32(0x58000000, DSPACNTR);
-		PSB_WVDC32(0, DSPASURF);/*trigger the plane disable*/
-		/* Wait ~4 ticks */
-		msleep(4);
-		/* Turn off pipe */
-		PSB_WVDC32(0x0, PIPEACONF);
-		/* Wait ~8 ticks */
-		msleep(8);
-
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
-	}
 	return 0;
 }
 
@@ -286,9 +287,6 @@ static void cdv_get_core_freq(struct drm_device *dev)
 	struct pci_dev *pci_root = pci_get_bus_and_slot(0, 0);
 	struct drm_psb_private *dev_priv = dev->dev_private;
 
-	/*pci_write_config_dword(pci_root, 0xD4, 0x00C32004);*/
-	/*pci_write_config_dword(pci_root, 0xD0, 0xE0033000);*/
-
 	pci_write_config_dword(pci_root, 0xD0, 0xD0050300);
 	pci_read_config_dword(pci_root, 0xD4, &clock);
 	pci_dev_put(pci_root);
@@ -326,7 +324,7 @@ static int cdv_chip_setup(struct drm_device *dev)
 	return 0;
 }
 
-/* CDV is much like Poulsbo but has MID like SGX offsets */
+/* CDV is much like Poulsbo but has MID like SGX offsets and PM */
 
 const struct psb_ops cdv_chip_ops = {
 	.name = "Cedartrail",
@@ -335,8 +333,8 @@ const struct psb_ops cdv_chip_ops = {
 	.sgx_offset = MRST_SGX_OFFSET,
 	.chip_setup = cdv_chip_setup,
 
-	.crtc_helper = &psb_intel_helper_funcs,
-	.crtc_funcs = &psb_intel_crtc_funcs,
+	.crtc_helper = &cdv_intel_helper_funcs,
+	.crtc_funcs = &cdv_intel_crtc_funcs,
 
 	.output_init = cdv_output_init,
 
@@ -350,4 +348,3 @@ const struct psb_ops cdv_chip_ops = {
 	.power_down = cdv_power_down,
 	.power_up = cdv_power_up,	
 };
-
diff --git a/drivers/staging/gma500/cdv_intel_display.c b/drivers/staging/gma500/cdv_intel_display.c
new file mode 100644
index 0000000..2042e98
--- /dev/null
+++ b/drivers/staging/gma500/cdv_intel_display.c
@@ -0,0 +1,1513 @@
+/*
+ * Copyright © 2006-2011 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors:
+ *	Eric Anholt <eric@anholt.net>
+ */
+
+#include <linux/i2c.h>
+#include <linux/pm_runtime.h>
+
+#include <drm/drmP.h>
+#include "framebuffer.h"
+#include "psb_drv.h"
+#include "psb_intel_drv.h"
+#include "psb_intel_reg.h"
+#include "psb_intel_display.h"
+#include "power.h"
+#include "cdv_device.h"
+
+
+struct cdv_intel_range_t {
+	int min, max;
+};
+
+struct cdv_intel_p2_t {
+	int dot_limit;
+	int p2_slow, p2_fast;
+};
+
+struct cdv_intel_clock_t
+{
+	/* given values */
+	int n;
+	int m1, m2;
+	int p1, p2;
+	/* derived values */
+	int dot;
+	int vco;
+	int m;
+	int p;
+};
+
+#define INTEL_P2_NUM		      2
+
+struct cdv_intel_limit_t {
+	struct cdv_intel_range_t dot, vco, n, m, m1, m2, p, p1;
+	struct cdv_intel_p2_t p2;
+};
+
+#define CDV_LIMIT_SINGLE_LVDS_96	0
+#define CDV_LIMIT_SINGLE_LVDS_100	1
+#define CDV_LIMIT_DAC_HDMI_27		2
+#define CDV_LIMIT_DAC_HDMI_96		3
+
+static const struct cdv_intel_limit_t cdv_intel_limits[] = {
+	{			/* CDV_SIGNLE_LVDS_96MHz */
+	 .dot = {.min = 20000, .max = 115500},
+	 .vco = {.min = 1800000, .max = 3600000},
+	 .n = {.min = 2, .max = 6},
+	 .m = {.min = 60, .max = 160},
+	 .m1 = {.min = 0, .max = 0},
+	 .m2 = {.min = 58, .max = 158},
+	 .p = {.min = 28, .max = 140},
+	 .p1 = {.min = 2, .max = 10},
+	 .p2 = {.dot_limit = 200000,
+		.p2_slow = 14, .p2_fast = 14},
+	 },
+	{			/* CDV_SINGLE_LVDS_100MHz */
+	 .dot = {.min = 20000, .max = 115500},
+	 .vco = {.min = 1800000, .max = 3600000},
+	 .n = {.min = 2, .max = 6},
+	 .m = {.min = 60, .max = 160},
+	 .m1 = {.min = 0, .max = 0},
+	 .m2 = {.min = 58, .max = 158},
+	 .p = {.min = 28, .max = 140},
+	 .p1 = {.min = 2, .max = 10},
+	 /* The single-channel range is 25-112Mhz, and dual-channel
+	  * is 80-224Mhz.  Prefer single channel as much as possible.
+	  */
+	 .p2 = {.dot_limit = 200000, .p2_slow = 14, .p2_fast = 14},
+	 },
+	{			/* CDV_DAC_HDMI_27MHz */
+	 .dot = {.min = 20000, .max = 400000},
+	 .vco = {.min = 1809000, .max = 3564000},
+	 .n = {.min = 1, .max = 1},
+	 .m = {.min = 67, .max = 132},
+	 .m1 = {.min = 0, .max = 0},
+	 .m2 = {.min = 65, .max = 130},
+	 .p = {.min = 5, .max = 90},
+	 .p1 = {.min = 1, .max = 9},
+	 .p2 = {.dot_limit = 225000, .p2_slow = 10, .p2_fast = 5},
+	 },
+	{			/* CDV_DAC_HDMI_96MHz */
+	 .dot = {.min = 20000, .max = 400000},
+	 .vco = {.min = 1800000, .max = 3600000},
+	 .n = {.min = 2, .max = 6},
+	 .m = {.min = 60, .max = 160},
+	 .m1 = {.min = 0, .max = 0},
+	 .m2 = {.min = 58, .max = 158},
+	 .p = {.min = 5, .max = 100},
+	 .p1 = {.min = 1, .max = 10},
+	 .p2 = {.dot_limit = 225000, .p2_slow = 10, .p2_fast = 5},
+	 },
+};
+
+#define _wait_for(COND, MS, W) ({ \
+        unsigned long timeout__ = jiffies + msecs_to_jiffies(MS);       \
+        int ret__ = 0;                                                  \
+        while (! (COND)) {                                              \
+                if (time_after(jiffies, timeout__)) {                   \
+                        ret__ = -ETIMEDOUT;                             \
+                        break;                                          \
+                }                                                       \
+                if (W && !in_dbg_master()) msleep(W);                   \
+        }                                                               \
+        ret__;                                                          \
+})      
+
+#define wait_for(COND, MS) _wait_for(COND, MS, 1)
+
+
+static int cdv_sb_read(struct drm_device *dev, u32 reg, u32 *val)
+{
+	int ret;
+
+	ret = wait_for((REG_READ(SB_PCKT) & SB_BUSY) == 0, 1000);
+	if (ret) {
+		DRM_ERROR("timeout waiting for SB to idle before read\n");
+		return ret;
+	}
+
+	REG_WRITE(SB_ADDR, reg);
+	REG_WRITE(SB_PCKT,
+		   SET_FIELD(SB_OPCODE_READ, SB_OPCODE) |
+		   SET_FIELD(SB_DEST_DPLL, SB_DEST) |
+		   SET_FIELD(0xf, SB_BYTE_ENABLE));
+
+	ret = wait_for((REG_READ(SB_PCKT) & SB_BUSY) == 0, 1000);
+	if (ret) {
+		DRM_ERROR("timeout waiting for SB to idle after read\n");
+		return ret;
+	}
+
+	*val = REG_READ(SB_DATA);
+
+	return 0;
+}
+
+static int cdv_sb_write(struct drm_device *dev, u32 reg, u32 val)
+{
+	int ret;
+	static bool dpio_debug = true;
+	u32 temp;
+
+	if (dpio_debug) {
+		if (cdv_sb_read(dev, reg, &temp) == 0)
+			DRM_DEBUG_KMS("0x%08x: 0x%08x (before)\n", reg, temp);
+		DRM_DEBUG_KMS("0x%08x: 0x%08x\n", reg, val);
+	}
+
+	ret = wait_for((REG_READ(SB_PCKT) & SB_BUSY) == 0, 1000);
+	if (ret) {
+		DRM_ERROR("timeout waiting for SB to idle before write\n");
+		return ret;
+	}
+
+	REG_WRITE(SB_ADDR, reg);
+	REG_WRITE(SB_DATA, val);
+	REG_WRITE(SB_PCKT,
+		   SET_FIELD(SB_OPCODE_WRITE, SB_OPCODE) |
+		   SET_FIELD(SB_DEST_DPLL, SB_DEST) |
+		   SET_FIELD(0xf, SB_BYTE_ENABLE));
+
+	ret = wait_for((REG_READ(SB_PCKT) & SB_BUSY) == 0, 1000);
+	if (ret) {
+		DRM_ERROR("timeout waiting for SB to idle after write\n");
+		return ret;
+	}
+
+	if (dpio_debug) {
+		if (cdv_sb_read(dev, reg, &temp) == 0)
+			DRM_DEBUG_KMS("0x%08x: 0x%08x (after)\n", reg, temp);
+	}
+
+	return 0;
+}
+
+/* Reset the DPIO configuration register.  The BIOS does this at every
+ * mode set.
+ */
+static void cdv_sb_reset(struct drm_device *dev)
+{
+
+	REG_WRITE(DPIO_CFG, 0);
+	REG_READ(DPIO_CFG);
+	REG_WRITE(DPIO_CFG, DPIO_MODE_SELECT_0 | DPIO_CMN_RESET_N);
+}
+
+/* Unlike most Intel display engines, on Cedarview the DPLL registers
+ * are behind this sideband bus.  They must be programmed while the
+ * DPLL reference clock is on in the DPLL control register, but before
+ * the DPLL is enabled in the DPLL control register.
+ */
+static int
+cdv_dpll_set_clock_cdv(struct drm_device *dev, struct drm_crtc *crtc,
+			       struct cdv_intel_clock_t *clock)
+{
+	struct psb_intel_crtc *psb_crtc =
+				to_psb_intel_crtc(crtc);
+	int pipe = psb_crtc->pipe;
+	u32 m, n_vco, p;
+	int ret = 0;
+	int dpll_reg = (pipe == 0) ? DPLL_A : DPLL_B;
+	u32 ref_value;
+
+	cdv_sb_reset(dev);
+
+	if ((REG_READ(dpll_reg) & DPLL_SYNCLOCK_ENABLE) == 0) {
+		DRM_ERROR("Attempting to set DPLL with refclk disabled\n");
+		return -EBUSY;
+	}
+
+	/* Follow the BIOS and write the REF/SFR Register. Hardcoded value */
+	ref_value = 0x68A701;
+
+	cdv_sb_write(dev, SB_REF_SFR(pipe), ref_value);
+	
+	/* We don't know what the other fields of these regs are, so
+	 * leave them in place.
+	 */
+	ret = cdv_sb_read(dev, SB_M(pipe), &m);
+	if (ret)
+		return ret;
+	m &= ~SB_M_DIVIDER_MASK;
+	m |= ((clock->m2) << SB_M_DIVIDER_SHIFT);
+	ret = cdv_sb_write(dev, SB_M(pipe), m);
+	if (ret)
+		return ret;
+
+	ret = cdv_sb_read(dev, SB_N_VCO(pipe), &n_vco);
+	if (ret)
+		return ret;
+
+	/* Follow the BIOS to program the N_DIVIDER REG */
+	n_vco &= 0xFFFF;
+	n_vco |= 0x107;
+	n_vco &= ~(SB_N_VCO_SEL_MASK |
+		   SB_N_DIVIDER_MASK |
+		   SB_N_CB_TUNE_MASK);
+
+	n_vco |= ((clock->n) << SB_N_DIVIDER_SHIFT);
+
+	if (clock->vco < 2250000) {
+		n_vco |= (2 << SB_N_CB_TUNE_SHIFT);
+		n_vco |= (0 << SB_N_VCO_SEL_SHIFT);
+	} else if (clock->vco < 2750000) {
+		n_vco |= (1 << SB_N_CB_TUNE_SHIFT);
+		n_vco |= (1 << SB_N_VCO_SEL_SHIFT);
+	} else if (clock->vco < 3300000) {
+		n_vco |= (0 << SB_N_CB_TUNE_SHIFT);
+		n_vco |= (2 << SB_N_VCO_SEL_SHIFT);
+	} else {
+		n_vco |= (0 << SB_N_CB_TUNE_SHIFT);
+		n_vco |= (3 << SB_N_VCO_SEL_SHIFT);
+	}
+
+	ret = cdv_sb_write(dev, SB_N_VCO(pipe), n_vco);
+	if (ret)
+		return ret;
+
+	ret = cdv_sb_read(dev, SB_P(pipe), &p);
+	if (ret)
+		return ret;
+	p &= ~(SB_P2_DIVIDER_MASK | SB_P1_DIVIDER_MASK);
+	p |= SET_FIELD(clock->p1, SB_P1_DIVIDER);
+	switch (clock->p2) {
+	case 5:
+		p |= SET_FIELD(SB_P2_5, SB_P2_DIVIDER);
+		break;
+	case 10:
+		p |= SET_FIELD(SB_P2_10, SB_P2_DIVIDER);
+		break;
+	case 14:
+		p |= SET_FIELD(SB_P2_14, SB_P2_DIVIDER);
+		break;
+	case 7:
+		p |= SET_FIELD(SB_P2_7, SB_P2_DIVIDER);
+		break;
+	default:
+		DRM_ERROR("Bad P2 clock: %d\n", clock->p2);
+		return -EINVAL;
+	}
+	ret = cdv_sb_write(dev, SB_P(pipe), p);
+	if (ret)
+		return ret;
+
+	/* always Program the Lane Register for the Pipe A*/
+	if (pipe == 0) {
+		/* Program the Lane0/1 for HDMI B */
+		u32 lane_reg, lane_value;
+
+		lane_reg = PSB_LANE0;
+		cdv_sb_read(dev, lane_reg, &lane_value);
+		lane_value &= ~(LANE_PLL_MASK);
+		lane_value |= LANE_PLL_ENABLE;
+		cdv_sb_write(dev, lane_reg, lane_value);
+
+		lane_reg = PSB_LANE1;
+		cdv_sb_read(dev, lane_reg, &lane_value);
+		lane_value &= ~(LANE_PLL_MASK);
+		lane_value |= LANE_PLL_ENABLE;
+		cdv_sb_write(dev, lane_reg, lane_value);
+
+		/* Program the Lane2/3 for HDMI C */	
+		lane_reg = PSB_LANE2;
+		cdv_sb_read(dev, lane_reg, &lane_value);
+		lane_value &= ~(LANE_PLL_MASK);
+		lane_value |= LANE_PLL_ENABLE;
+		cdv_sb_write(dev, lane_reg, lane_value);
+
+	
+		lane_reg = PSB_LANE3;
+		cdv_sb_read(dev, lane_reg, &lane_value);
+		lane_value &= ~(LANE_PLL_MASK);
+		lane_value |= LANE_PLL_ENABLE;
+		cdv_sb_write(dev, lane_reg, lane_value);
+	}
+
+	return 0;
+}
+
+/*
+ * Returns whether any output on the specified pipe is of the specified type
+ */
+bool cdv_intel_pipe_has_type(struct drm_crtc *crtc, int type)
+{
+	struct drm_device *dev = crtc->dev;
+	struct drm_mode_config *mode_config = &dev->mode_config;
+	struct drm_connector *l_entry;
+
+	list_for_each_entry(l_entry, &mode_config->connector_list, head) {
+		if (l_entry->encoder && l_entry->encoder->crtc == crtc) {
+			struct psb_intel_output *psb_intel_output =
+			    to_psb_intel_output(l_entry);
+			if (psb_intel_output->type == type)
+				return true;
+		}
+	}
+	return false;
+}
+
+static const struct cdv_intel_limit_t *cdv_intel_limit(struct drm_crtc *crtc, int refclk)
+{
+	const struct cdv_intel_limit_t *limit;
+	if (cdv_intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS)) {
+		/*
+ 		 * Now only single-channel LVDS is supported on CDV. If it is
+ 		 * incorrect, please add the dual-channel LVDS.
+ 		 */
+		if (refclk == 96000)
+			limit = &cdv_intel_limits[CDV_LIMIT_SINGLE_LVDS_96];
+		else 
+			limit = &cdv_intel_limits[CDV_LIMIT_SINGLE_LVDS_100];
+	} else {
+		if (refclk == 27000)
+			limit = &cdv_intel_limits[CDV_LIMIT_DAC_HDMI_27];
+		else
+			limit = &cdv_intel_limits[CDV_LIMIT_DAC_HDMI_96];
+	}
+	return limit;
+}
+
+/* m1 is reserved as 0 in CDV, n is a ring counter */
+static void cdv_intel_clock(struct drm_device *dev, 
+			int refclk, struct cdv_intel_clock_t *clock)
+{
+	clock->m = clock->m2 + 2;
+	clock->p = clock->p1 * clock->p2;
+	clock->vco = (refclk * clock->m) / clock->n;
+	clock->dot = clock->vco / clock->p;
+}
+
+
+#define INTELPllInvalid(s)   { /* ErrorF (s) */; return false; }
+static bool cdv_intel_PLL_is_valid(struct drm_crtc *crtc,
+				const struct cdv_intel_limit_t *limit,
+			       struct cdv_intel_clock_t *clock)
+{
+	if (clock->p1 < limit->p1.min || limit->p1.max < clock->p1)
+		INTELPllInvalid("p1 out of range\n");
+	if (clock->p < limit->p.min || limit->p.max < clock->p)
+		INTELPllInvalid("p out of range\n");
+	/* unnecessary to check the range of m(m1/M2)/n again */
+	if (clock->vco < limit->vco.min || limit->vco.max < clock->vco)
+		INTELPllInvalid("vco out of range\n");
+	/* XXX: We may need to be checking "Dot clock"
+	 * depending on the multiplier, connector, etc.,
+	 * rather than just a single range.
+	 */
+	if (clock->dot < limit->dot.min || limit->dot.max < clock->dot)
+		INTELPllInvalid("dot out of range\n");
+
+	return true;
+}
+
+static bool cdv_intel_find_best_PLL(struct drm_crtc *crtc, int target,
+				int refclk,
+				struct cdv_intel_clock_t *best_clock)
+{
+	struct drm_device *dev = crtc->dev;
+	struct cdv_intel_clock_t clock;
+	const struct cdv_intel_limit_t *limit = cdv_intel_limit(crtc, refclk);
+	int err = target;
+
+
+	if (cdv_intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS) &&
+	    (REG_READ(LVDS) & LVDS_PORT_EN) != 0) {
+		/*
+		 * For LVDS, if the panel is on, just rely on its current
+		 * settings for dual-channel.  We haven't figured out how to
+		 * reliably set up different single/dual channel state, if we
+		 * even can.
+		 */
+		if ((REG_READ(LVDS) & LVDS_CLKB_POWER_MASK) ==
+		    LVDS_CLKB_POWER_UP)
+			clock.p2 = limit->p2.p2_fast;
+		else
+			clock.p2 = limit->p2.p2_slow;
+	} else {
+		if (target < limit->p2.dot_limit)
+			clock.p2 = limit->p2.p2_slow;
+		else
+			clock.p2 = limit->p2.p2_fast;
+	}
+
+	memset(best_clock, 0, sizeof(*best_clock));
+	clock.m1 = 0;
+	/* m1 is reserved as 0 in CDV, n is a ring counter. So skip the m1 loop */
+	for (clock.n = limit->n.min; clock.n <= limit->n.max; clock.n++) {
+		for (clock.m2 = limit->m2.min; clock.m2 <= limit->m2.max;
+					     clock.m2++) {
+			for (clock.p1 = limit->p1.min; clock.p1 <= limit->p1.max;
+				     clock.p1++) {
+				int this_err;
+
+				cdv_intel_clock(dev, refclk, &clock);
+
+				if (!cdv_intel_PLL_is_valid(crtc, limit, &clock))
+						continue;
+				
+				this_err = abs(clock.dot - target);
+				if (this_err < err) {
+					*best_clock = clock;
+					err = this_err;
+				}
+			}
+		}
+	}
+
+	return err != target;
+}
+
+int cdv_intel_pipe_set_base(struct drm_crtc *crtc,
+			    int x, int y, struct drm_framebuffer *old_fb)
+{
+	struct drm_device *dev = crtc->dev;
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	struct psb_framebuffer *psbfb = to_psb_fb(crtc->fb);
+	int pipe = psb_intel_crtc->pipe;
+	unsigned long start, offset;
+	int dspbase = (pipe == 0 ? DSPABASE : DSPBBASE);
+	int dspsurf = (pipe == 0 ? DSPASURF : DSPBSURF);
+	int dspstride = (pipe == 0) ? DSPASTRIDE : DSPBSTRIDE;
+	int dspcntr_reg = (pipe == 0) ? DSPACNTR : DSPBCNTR;
+	u32 dspcntr;
+	int ret = 0;
+
+	if (!gma_power_begin(dev, true))
+		return 0;
+
+	/* no fb bound */
+	if (!crtc->fb) {
+		dev_err(dev->dev, "No FB bound\n");
+		goto psb_intel_pipe_cleaner;
+	}
+
+
+	/* We are displaying this buffer, make sure it is actually loaded
+	   into the GTT */
+	ret = psb_gtt_pin(psbfb->gtt);
+	if (ret < 0)
+		goto psb_intel_pipe_set_base_exit;
+	start = psbfb->gtt->offset;
+	offset = y * crtc->fb->pitch + x * (crtc->fb->bits_per_pixel / 8);
+
+	REG_WRITE(dspstride, crtc->fb->pitch);
+
+	dspcntr = REG_READ(dspcntr_reg);
+	dspcntr &= ~DISPPLANE_PIXFORMAT_MASK;
+
+	switch (crtc->fb->bits_per_pixel) {
+	case 8:
+		dspcntr |= DISPPLANE_8BPP;
+		break;
+	case 16:
+		if (crtc->fb->depth == 15)
+			dspcntr |= DISPPLANE_15_16BPP;
+		else
+			dspcntr |= DISPPLANE_16BPP;
+		break;
+	case 24:
+	case 32:
+		dspcntr |= DISPPLANE_32BPP_NO_ALPHA;
+		break;
+	default:
+		dev_err(dev->dev, "Unknown color depth\n");
+		ret = -EINVAL;
+		goto psb_intel_pipe_set_base_exit;
+	}
+	REG_WRITE(dspcntr_reg, dspcntr);
+
+	dev_dbg(dev->dev,
+	        "Writing base %08lX %08lX %d %d\n", start, offset, x, y);
+
+	REG_WRITE(dspbase, offset);
+	REG_READ(dspbase);
+	REG_WRITE(dspsurf, start);
+	REG_READ(dspsurf);
+
+psb_intel_pipe_cleaner:
+	/* If there was a previous display we can now unpin it */
+	if (old_fb)
+		psb_gtt_unpin(to_psb_fb(old_fb)->gtt);
+
+psb_intel_pipe_set_base_exit:
+	gma_power_end(dev);
+	return ret;
+}
+
+/**
+ * Sets the power management mode of the pipe and plane.
+ *
+ * This code should probably grow support for turning the cursor off and back
+ * on appropriately at the same time as we're turning the pipe off/on.
+ */
+static void cdv_intel_crtc_dpms(struct drm_crtc *crtc, int mode)
+{
+	struct drm_device *dev = crtc->dev;
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int pipe = psb_intel_crtc->pipe;
+	int dpll_reg = (pipe == 0) ? DPLL_A : DPLL_B;
+	int dspcntr_reg = (pipe == 0) ? DSPACNTR : DSPBCNTR;
+	int dspbase_reg = (pipe == 0) ? DSPABASE : DSPBBASE;
+	int pipeconf_reg = (pipe == 0) ? PIPEACONF : PIPEBCONF;
+	u32 temp;
+	bool enabled;
+
+	/* XXX: When our outputs are all unaware of DPMS modes other than off
+	 * and on, we should map those modes to DRM_MODE_DPMS_OFF in the CRTC.
+	 */
+	switch (mode) {
+	case DRM_MODE_DPMS_ON:
+	case DRM_MODE_DPMS_STANDBY:
+	case DRM_MODE_DPMS_SUSPEND:
+		/* Enable the DPLL */
+		temp = REG_READ(dpll_reg);
+		if ((temp & DPLL_VCO_ENABLE) == 0) {
+			REG_WRITE(dpll_reg, temp);
+			REG_READ(dpll_reg);
+			/* Wait for the clocks to stabilize. */
+			udelay(150);
+			REG_WRITE(dpll_reg, temp | DPLL_VCO_ENABLE);
+			REG_READ(dpll_reg);
+			/* Wait for the clocks to stabilize. */
+			udelay(150);
+			REG_WRITE(dpll_reg, temp | DPLL_VCO_ENABLE);
+			REG_READ(dpll_reg);
+			/* Wait for the clocks to stabilize. */
+			udelay(150);
+		}
+
+		/* Jim Bish - switch plan and pipe per scott */
+		/* Enable the plane */
+		temp = REG_READ(dspcntr_reg);
+		if ((temp & DISPLAY_PLANE_ENABLE) == 0) {
+			REG_WRITE(dspcntr_reg,
+				  temp | DISPLAY_PLANE_ENABLE);
+			/* Flush the plane changes */
+			REG_WRITE(dspbase_reg, REG_READ(dspbase_reg));
+		}
+
+		udelay(150);
+
+		/* Enable the pipe */
+		temp = REG_READ(pipeconf_reg);
+		if ((temp & PIPEACONF_ENABLE) == 0)
+			REG_WRITE(pipeconf_reg, temp | PIPEACONF_ENABLE);
+
+		psb_intel_crtc_load_lut(crtc);
+
+		/* Give the overlay scaler a chance to enable
+		 * if it's on this pipe */
+		/* psb_intel_crtc_dpms_video(crtc, true); TODO */
+		break;
+	case DRM_MODE_DPMS_OFF:
+		/* Give the overlay scaler a chance to disable
+		 * if it's on this pipe */
+		/* psb_intel_crtc_dpms_video(crtc, FALSE); TODO */
+
+		/* Disable the VGA plane that we never use */
+		REG_WRITE(VGACNTRL, VGA_DISP_DISABLE);
+
+		/* Jim Bish - changed pipe/plane here as well. */
+
+		/* Wait for vblank for the disable to take effect */
+		cdv_intel_wait_for_vblank(dev);
+
+		/* Next, disable display pipes */
+		temp = REG_READ(pipeconf_reg);
+		if ((temp & PIPEACONF_ENABLE) != 0) {
+			REG_WRITE(pipeconf_reg, temp & ~PIPEACONF_ENABLE);
+			REG_READ(pipeconf_reg);
+		}
+
+		/* Wait for vblank for the disable to take effect. */
+		cdv_intel_wait_for_vblank(dev);
+
+		udelay(150);
+
+		/* Disable display plane */
+		temp = REG_READ(dspcntr_reg);
+		if ((temp & DISPLAY_PLANE_ENABLE) != 0) {
+			REG_WRITE(dspcntr_reg,
+				  temp & ~DISPLAY_PLANE_ENABLE);
+			/* Flush the plane changes */
+			REG_WRITE(dspbase_reg, REG_READ(dspbase_reg));
+			REG_READ(dspbase_reg);
+		}
+
+		temp = REG_READ(dpll_reg);
+		if ((temp & DPLL_VCO_ENABLE) != 0) {
+			REG_WRITE(dpll_reg, temp & ~DPLL_VCO_ENABLE);
+			REG_READ(dpll_reg);
+		}
+
+		/* Wait for the clocks to turn off. */
+		udelay(150);
+		break;
+	}
+	enabled = crtc->enabled && mode != DRM_MODE_DPMS_OFF;
+	/*Set FIFO Watermarks*/
+	REG_WRITE(DSPARB, 0x3F3E);
+}
+
+static void cdv_intel_crtc_prepare(struct drm_crtc *crtc)
+{
+	struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
+	crtc_funcs->dpms(crtc, DRM_MODE_DPMS_OFF);
+}
+
+static void cdv_intel_crtc_commit(struct drm_crtc *crtc)
+{
+	struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
+	crtc_funcs->dpms(crtc, DRM_MODE_DPMS_ON);
+}
+
+void cdv_intel_encoder_prepare(struct drm_encoder *encoder)
+{
+	struct drm_encoder_helper_funcs *encoder_funcs =
+	    encoder->helper_private;
+	/* lvds has its own version of prepare see cdv_intel_lvds_prepare */
+	encoder_funcs->dpms(encoder, DRM_MODE_DPMS_OFF);
+}
+
+void cdv_intel_encoder_commit(struct drm_encoder *encoder)
+{
+	struct drm_encoder_helper_funcs *encoder_funcs =
+	    encoder->helper_private;
+	/* lvds has its own version of commit see cdv_intel_lvds_commit */
+	encoder_funcs->dpms(encoder, DRM_MODE_DPMS_ON);
+}
+
+static bool cdv_intel_crtc_mode_fixup(struct drm_crtc *crtc,
+				  struct drm_display_mode *mode,
+				  struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
+
+
+/**
+ * Return the pipe currently connected to the panel fitter,
+ * or -1 if the panel fitter is not present or not in use
+ */
+static int cdv_intel_panel_fitter_pipe(struct drm_device *dev)
+{
+	u32 pfit_control;
+
+	pfit_control = REG_READ(PFIT_CONTROL);
+
+	/* See if the panel fitter is in use */
+	if ((pfit_control & PFIT_ENABLE) == 0)
+		return -1;
+	return (pfit_control >> 29) & 0x3;
+}
+
+static int cdv_intel_crtc_mode_set(struct drm_crtc *crtc,
+			       struct drm_display_mode *mode,
+			       struct drm_display_mode *adjusted_mode,
+			       int x, int y,
+			       struct drm_framebuffer *old_fb)
+{
+	struct drm_device *dev = crtc->dev;
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int pipe = psb_intel_crtc->pipe;
+	int dpll_reg = (pipe == 0) ? DPLL_A : DPLL_B;
+	int dpll_md_reg = (psb_intel_crtc->pipe == 0) ? DPLL_A_MD : DPLL_B_MD;
+	int dspcntr_reg = (pipe == 0) ? DSPACNTR : DSPBCNTR;
+	int pipeconf_reg = (pipe == 0) ? PIPEACONF : PIPEBCONF;
+	int htot_reg = (pipe == 0) ? HTOTAL_A : HTOTAL_B;
+	int hblank_reg = (pipe == 0) ? HBLANK_A : HBLANK_B;
+	int hsync_reg = (pipe == 0) ? HSYNC_A : HSYNC_B;
+	int vtot_reg = (pipe == 0) ? VTOTAL_A : VTOTAL_B;
+	int vblank_reg = (pipe == 0) ? VBLANK_A : VBLANK_B;
+	int vsync_reg = (pipe == 0) ? VSYNC_A : VSYNC_B;
+	int dspsize_reg = (pipe == 0) ? DSPASIZE : DSPBSIZE;
+	int dsppos_reg = (pipe == 0) ? DSPAPOS : DSPBPOS;
+	int pipesrc_reg = (pipe == 0) ? PIPEASRC : PIPEBSRC;
+	int refclk;
+	struct cdv_intel_clock_t clock;
+	u32 dpll = 0, dspcntr, pipeconf;
+	bool ok, is_sdvo = false, is_dvo = false;
+	bool is_crt = false, is_lvds = false, is_tv = false;
+	bool is_hdmi = false;
+	struct drm_mode_config *mode_config = &dev->mode_config;
+	struct drm_connector *connector;
+
+	list_for_each_entry(connector, &mode_config->connector_list, head) {
+		struct psb_intel_output *psb_intel_output =
+		    to_psb_intel_output(connector);
+
+		if (!connector->encoder
+		    || connector->encoder->crtc != crtc)
+			continue;
+
+		switch (psb_intel_output->type) {
+		case INTEL_OUTPUT_LVDS:
+			is_lvds = true;
+			break;
+		case INTEL_OUTPUT_SDVO:
+			is_sdvo = true;
+			break;
+		case INTEL_OUTPUT_DVO:
+			is_dvo = true;
+			break;
+		case INTEL_OUTPUT_TVOUT:
+			is_tv = true;
+			break;
+		case INTEL_OUTPUT_ANALOG:
+			is_crt = true;
+			break;
+		case INTEL_OUTPUT_HDMI:
+			is_hdmi = true;
+			break;
+		}
+	}
+
+	refclk = 96000;
+
+	/* Hack selection about ref clk for CRT */
+	/* Select 27MHz as the reference clk for HDMI */
+	if (is_crt || is_hdmi)
+		refclk = 27000;
+
+	drm_mode_debug_printmodeline(adjusted_mode);
+
+	ok = cdv_intel_find_best_PLL(crtc, adjusted_mode->clock, refclk,
+				 &clock);
+	if (!ok) {
+		dev_err(dev->dev, "Couldn't find PLL settings for mode!\n");
+		return 0;
+	}
+
+	dpll = DPLL_VGA_MODE_DIS;
+	if (is_tv) {
+		/* XXX: just matching BIOS for now */
+/*	dpll |= PLL_REF_INPUT_TVCLKINBC; */
+		dpll |= 3;
+	}
+		dpll |= PLL_REF_INPUT_DREFCLK;
+
+	dpll |= DPLL_SYNCLOCK_ENABLE;
+	dpll |= DPLL_VGA_MODE_DIS;
+	if (is_lvds)
+		dpll |= DPLLB_MODE_LVDS;
+	else
+		dpll |= DPLLB_MODE_DAC_SERIAL;
+	//dpll |= (2 << 11);
+
+	/* setup pipeconf */
+	pipeconf = REG_READ(pipeconf_reg);
+
+	/* Set up the display plane register */
+	dspcntr = DISPPLANE_GAMMA_ENABLE;
+
+	if (pipe == 0)
+		dspcntr |= DISPPLANE_SEL_PIPE_A;
+	else
+		dspcntr |= DISPPLANE_SEL_PIPE_B;
+
+	dspcntr |= DISPLAY_PLANE_ENABLE;
+	pipeconf |= PIPEACONF_ENABLE;
+
+	REG_WRITE(dpll_reg,
+                   dpll | DPLL_VGA_MODE_DIS |
+                   DPLL_SYNCLOCK_ENABLE);
+        REG_READ(dpll_reg);
+
+	cdv_dpll_set_clock_cdv(dev, crtc, &clock);
+
+        udelay(150);
+
+
+	/* The LVDS pin pair needs to be on before the DPLLs are enabled.
+	 * This is an exception to the general rule that mode_set doesn't turn
+	 * things on.
+	 */
+	if (is_lvds) {
+		u32 lvds = REG_READ(LVDS);
+
+		lvds |=
+		    LVDS_PORT_EN | LVDS_A0A2_CLKA_POWER_UP |
+		    LVDS_PIPEB_SELECT;
+		/* Set the B0-B3 data pairs corresponding to
+		 * whether we're going to
+		 * set the DPLLs for dual-channel mode or not.
+		 */
+		if (clock.p2 == 7)
+			lvds |= LVDS_B0B3_POWER_UP | LVDS_CLKB_POWER_UP;
+		else
+			lvds &= ~(LVDS_B0B3_POWER_UP | LVDS_CLKB_POWER_UP);
+
+		/* It would be nice to set 24 vs 18-bit mode (LVDS_A3_POWER_UP)
+		 * appropriately here, but we need to look more
+		 * thoroughly into how panels behave in the two modes.
+		 */
+
+		REG_WRITE(LVDS, lvds);
+		REG_READ(LVDS);
+	}
+
+	dpll |= DPLL_VCO_ENABLE;
+
+		
+	/* Disable the panel fitter if it was on our pipe */
+	if (cdv_intel_panel_fitter_pipe(dev) == pipe)
+		REG_WRITE(PFIT_CONTROL, 0);
+
+	DRM_DEBUG_KMS("Mode for pipe %c:\n", pipe == 0 ? 'A' : 'B');
+	drm_mode_debug_printmodeline(mode);
+
+	REG_WRITE(dpll_reg,
+                   (REG_READ(dpll_reg) & ~DPLL_LOCK) |
+                   DPLL_VCO_ENABLE);
+        REG_READ(dpll_reg);
+	/* Wait for the clocks to stabilize. */
+        udelay(150); /* 42 usec w/o calibration, 110 with.  rounded up. */
+
+        if (!(REG_READ(dpll_reg) & DPLL_LOCK)) {
+                dev_err(dev->dev, "Failed to get DPLL lock\n");
+                return -EBUSY;
+        }
+
+        {
+        	int sdvo_pixel_multiply =
+		    adjusted_mode->clock / mode->clock;
+		REG_WRITE(dpll_md_reg,
+			  (0 << DPLL_MD_UDI_DIVIDER_SHIFT) |
+			  ((sdvo_pixel_multiply -
+			    1) << DPLL_MD_UDI_MULTIPLIER_SHIFT));
+	}
+
+	REG_WRITE(htot_reg, (adjusted_mode->crtc_hdisplay - 1) |
+		  ((adjusted_mode->crtc_htotal - 1) << 16));
+	REG_WRITE(hblank_reg, (adjusted_mode->crtc_hblank_start - 1) |
+		  ((adjusted_mode->crtc_hblank_end - 1) << 16));
+	REG_WRITE(hsync_reg, (adjusted_mode->crtc_hsync_start - 1) |
+		  ((adjusted_mode->crtc_hsync_end - 1) << 16));
+	REG_WRITE(vtot_reg, (adjusted_mode->crtc_vdisplay - 1) |
+		  ((adjusted_mode->crtc_vtotal - 1) << 16));
+	REG_WRITE(vblank_reg, (adjusted_mode->crtc_vblank_start - 1) |
+		  ((adjusted_mode->crtc_vblank_end - 1) << 16));
+	REG_WRITE(vsync_reg, (adjusted_mode->crtc_vsync_start - 1) |
+		  ((adjusted_mode->crtc_vsync_end - 1) << 16));
+	/* pipesrc and dspsize control the size that is scaled from,
+	 * which should always be the user's requested size.
+	 */
+	REG_WRITE(dspsize_reg,
+		  ((mode->vdisplay - 1) << 16) | (mode->hdisplay - 1));
+	REG_WRITE(dsppos_reg, 0);
+	REG_WRITE(pipesrc_reg,
+		  ((mode->hdisplay - 1) << 16) | (mode->vdisplay - 1));
+	REG_WRITE(pipeconf_reg, pipeconf);
+	REG_READ(pipeconf_reg);
+
+	cdv_intel_wait_for_vblank(dev);
+
+	REG_WRITE(dspcntr_reg, dspcntr);
+
+	/* Flush the plane changes */
+	{
+		struct drm_crtc_helper_funcs *crtc_funcs =
+		    crtc->helper_private;
+		crtc_funcs->mode_set_base(crtc, x, y, old_fb);
+	}
+
+	cdv_intel_wait_for_vblank(dev);
+
+	return 0;
+}
+
+/** Loads the palette/gamma unit for the CRTC with the prepared values */
+void cdv_intel_crtc_load_lut(struct drm_crtc *crtc)
+{
+	struct drm_device *dev = crtc->dev;
+	struct drm_psb_private *dev_priv =
+				(struct drm_psb_private *)dev->dev_private;
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int palreg = PALETTE_A;
+	int i;
+
+	/* The clocks have to be on to load the palette. */
+	if (!crtc->enabled)
+		return;
+
+	switch (psb_intel_crtc->pipe) {
+	case 0:
+		break;
+	case 1:
+		palreg = PALETTE_B;
+		break;
+	case 2:
+		palreg = PALETTE_C;
+		break;
+	default:
+		dev_err(dev->dev, "Illegal Pipe Number. \n");
+		return;
+	}
+	
+	if (gma_power_begin(dev, false)) {
+		for (i = 0; i < 256; i++) {
+			REG_WRITE(palreg + 4 * i,
+				  ((psb_intel_crtc->lut_r[i] +
+				  psb_intel_crtc->lut_adj[i]) << 16) |
+				  ((psb_intel_crtc->lut_g[i] +
+				  psb_intel_crtc->lut_adj[i]) << 8) |
+				  (psb_intel_crtc->lut_b[i] +
+				  psb_intel_crtc->lut_adj[i]));
+		}
+		gma_power_end(dev);
+	} else {
+		for (i = 0; i < 256; i++) {
+			dev_priv->save_palette_a[i] =
+				  ((psb_intel_crtc->lut_r[i] +
+				  psb_intel_crtc->lut_adj[i]) << 16) |
+				  ((psb_intel_crtc->lut_g[i] +
+				  psb_intel_crtc->lut_adj[i]) << 8) |
+				  (psb_intel_crtc->lut_b[i] +
+				  psb_intel_crtc->lut_adj[i]);
+		}
+
+	}
+}
+
+/**
+ * Save HW states of giving crtc
+ */
+static void cdv_intel_crtc_save(struct drm_crtc *crtc)
+{
+	struct drm_device *dev = crtc->dev;
+	/* struct drm_psb_private *dev_priv =
+			(struct drm_psb_private *)dev->dev_private; */
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	struct psb_intel_crtc_state *crtc_state = psb_intel_crtc->crtc_state;
+	int pipeA = (psb_intel_crtc->pipe == 0);
+	uint32_t paletteReg;
+	int i;
+
+	if (!crtc_state) {
+		dev_dbg(dev->dev, "No CRTC state found\n");
+		return;
+	}
+
+	crtc_state->saveDSPCNTR = REG_READ(pipeA ? DSPACNTR : DSPBCNTR);
+	crtc_state->savePIPECONF = REG_READ(pipeA ? PIPEACONF : PIPEBCONF);
+	crtc_state->savePIPESRC = REG_READ(pipeA ? PIPEASRC : PIPEBSRC);
+	crtc_state->saveFP0 = REG_READ(pipeA ? FPA0 : FPB0);
+	crtc_state->saveFP1 = REG_READ(pipeA ? FPA1 : FPB1);
+	crtc_state->saveDPLL = REG_READ(pipeA ? DPLL_A : DPLL_B);
+	crtc_state->saveHTOTAL = REG_READ(pipeA ? HTOTAL_A : HTOTAL_B);
+	crtc_state->saveHBLANK = REG_READ(pipeA ? HBLANK_A : HBLANK_B);
+	crtc_state->saveHSYNC = REG_READ(pipeA ? HSYNC_A : HSYNC_B);
+	crtc_state->saveVTOTAL = REG_READ(pipeA ? VTOTAL_A : VTOTAL_B);
+	crtc_state->saveVBLANK = REG_READ(pipeA ? VBLANK_A : VBLANK_B);
+	crtc_state->saveVSYNC = REG_READ(pipeA ? VSYNC_A : VSYNC_B);
+	crtc_state->saveDSPSTRIDE = REG_READ(pipeA ? DSPASTRIDE : DSPBSTRIDE);
+
+	/*NOTE: DSPSIZE DSPPOS only for psb*/
+	crtc_state->saveDSPSIZE = REG_READ(pipeA ? DSPASIZE : DSPBSIZE);
+	crtc_state->saveDSPPOS = REG_READ(pipeA ? DSPAPOS : DSPBPOS);
+
+	crtc_state->saveDSPBASE = REG_READ(pipeA ? DSPABASE : DSPBBASE);
+
+	DRM_DEBUG("(%x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x)\n",
+			crtc_state->saveDSPCNTR,
+			crtc_state->savePIPECONF,
+			crtc_state->savePIPESRC,
+			crtc_state->saveFP0,
+			crtc_state->saveFP1,
+			crtc_state->saveDPLL,
+			crtc_state->saveHTOTAL,
+			crtc_state->saveHBLANK,
+			crtc_state->saveHSYNC,
+			crtc_state->saveVTOTAL,
+			crtc_state->saveVBLANK,
+			crtc_state->saveVSYNC,
+			crtc_state->saveDSPSTRIDE,
+			crtc_state->saveDSPSIZE,
+			crtc_state->saveDSPPOS,
+			crtc_state->saveDSPBASE
+		);
+
+	paletteReg = pipeA ? PALETTE_A : PALETTE_B;
+	for (i = 0; i < 256; ++i)
+		crtc_state->savePalette[i] = REG_READ(paletteReg + (i << 2));
+}
+
+/**
+ * Restore HW states of giving crtc
+ */
+static void cdv_intel_crtc_restore(struct drm_crtc *crtc)
+{
+	struct drm_device *dev = crtc->dev;
+	/* struct drm_psb_private * dev_priv =
+				(struct drm_psb_private *)dev->dev_private; */
+	struct psb_intel_crtc *psb_intel_crtc =  to_psb_intel_crtc(crtc);
+	struct psb_intel_crtc_state *crtc_state = psb_intel_crtc->crtc_state;
+	/* struct drm_crtc_helper_funcs * crtc_funcs = crtc->helper_private; */
+	int pipeA = (psb_intel_crtc->pipe == 0);
+	uint32_t paletteReg;
+	int i;
+
+	if (!crtc_state) {
+		dev_dbg(dev->dev, "No crtc state\n");
+		return;
+	}
+
+	DRM_DEBUG(
+		"current:(%x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x)\n",
+		REG_READ(pipeA ? DSPACNTR : DSPBCNTR),
+		REG_READ(pipeA ? PIPEACONF : PIPEBCONF),
+		REG_READ(pipeA ? PIPEASRC : PIPEBSRC),
+		REG_READ(pipeA ? FPA0 : FPB0),
+		REG_READ(pipeA ? FPA1 : FPB1),
+		REG_READ(pipeA ? DPLL_A : DPLL_B),
+		REG_READ(pipeA ? HTOTAL_A : HTOTAL_B),
+		REG_READ(pipeA ? HBLANK_A : HBLANK_B),
+		REG_READ(pipeA ? HSYNC_A : HSYNC_B),
+		REG_READ(pipeA ? VTOTAL_A : VTOTAL_B),
+		REG_READ(pipeA ? VBLANK_A : VBLANK_B),
+		REG_READ(pipeA ? VSYNC_A : VSYNC_B),
+		REG_READ(pipeA ? DSPASTRIDE : DSPBSTRIDE),
+		REG_READ(pipeA ? DSPASIZE : DSPBSIZE),
+		REG_READ(pipeA ? DSPAPOS : DSPBPOS),
+		REG_READ(pipeA ? DSPABASE : DSPBBASE)
+		);
+
+	DRM_DEBUG(
+		"saved: (%x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x)\n",
+		crtc_state->saveDSPCNTR,
+		crtc_state->savePIPECONF,
+		crtc_state->savePIPESRC,
+		crtc_state->saveFP0,
+		crtc_state->saveFP1,
+		crtc_state->saveDPLL,
+		crtc_state->saveHTOTAL,
+		crtc_state->saveHBLANK,
+		crtc_state->saveHSYNC,
+		crtc_state->saveVTOTAL,
+		crtc_state->saveVBLANK,
+		crtc_state->saveVSYNC,
+		crtc_state->saveDSPSTRIDE,
+		crtc_state->saveDSPSIZE,
+		crtc_state->saveDSPPOS,
+		crtc_state->saveDSPBASE
+		);
+
+
+	if (crtc_state->saveDPLL & DPLL_VCO_ENABLE) {
+		REG_WRITE(pipeA ? DPLL_A : DPLL_B,
+			crtc_state->saveDPLL & ~DPLL_VCO_ENABLE);
+		REG_READ(pipeA ? DPLL_A : DPLL_B);
+		DRM_DEBUG("write dpll: %x\n",
+				REG_READ(pipeA ? DPLL_A : DPLL_B));
+		udelay(150);
+	}
+
+	REG_WRITE(pipeA ? FPA0 : FPB0, crtc_state->saveFP0);
+	REG_READ(pipeA ? FPA0 : FPB0);
+
+	REG_WRITE(pipeA ? FPA1 : FPB1, crtc_state->saveFP1);
+	REG_READ(pipeA ? FPA1 : FPB1);
+
+	REG_WRITE(pipeA ? DPLL_A : DPLL_B, crtc_state->saveDPLL);
+	REG_READ(pipeA ? DPLL_A : DPLL_B);
+	udelay(150);
+
+	REG_WRITE(pipeA ? HTOTAL_A : HTOTAL_B, crtc_state->saveHTOTAL);
+	REG_WRITE(pipeA ? HBLANK_A : HBLANK_B, crtc_state->saveHBLANK);
+	REG_WRITE(pipeA ? HSYNC_A : HSYNC_B, crtc_state->saveHSYNC);
+	REG_WRITE(pipeA ? VTOTAL_A : VTOTAL_B, crtc_state->saveVTOTAL);
+	REG_WRITE(pipeA ? VBLANK_A : VBLANK_B, crtc_state->saveVBLANK);
+	REG_WRITE(pipeA ? VSYNC_A : VSYNC_B, crtc_state->saveVSYNC);
+	REG_WRITE(pipeA ? DSPASTRIDE : DSPBSTRIDE, crtc_state->saveDSPSTRIDE);
+
+	REG_WRITE(pipeA ? DSPASIZE : DSPBSIZE, crtc_state->saveDSPSIZE);
+	REG_WRITE(pipeA ? DSPAPOS : DSPBPOS, crtc_state->saveDSPPOS);
+
+	REG_WRITE(pipeA ? PIPEASRC : PIPEBSRC, crtc_state->savePIPESRC);
+	REG_WRITE(pipeA ? DSPABASE : DSPBBASE, crtc_state->saveDSPBASE);
+	REG_WRITE(pipeA ? PIPEACONF : PIPEBCONF, crtc_state->savePIPECONF);
+
+	cdv_intel_wait_for_vblank(dev);
+
+	REG_WRITE(pipeA ? DSPACNTR : DSPBCNTR, crtc_state->saveDSPCNTR);
+	REG_WRITE(pipeA ? DSPABASE : DSPBBASE, crtc_state->saveDSPBASE);
+
+	cdv_intel_wait_for_vblank(dev);
+
+	paletteReg = pipeA ? PALETTE_A : PALETTE_B;
+	for (i = 0; i < 256; ++i)
+		REG_WRITE(paletteReg + (i << 2), crtc_state->savePalette[i]);
+}
+
+static int cdv_intel_crtc_cursor_set(struct drm_crtc *crtc,
+				 struct drm_file *file_priv,
+				 uint32_t handle,
+				 uint32_t width, uint32_t height)
+{
+	struct drm_device *dev = crtc->dev;
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int pipe = psb_intel_crtc->pipe;
+	uint32_t control = (pipe == 0) ? CURACNTR : CURBCNTR;
+	uint32_t base = (pipe == 0) ? CURABASE : CURBBASE;
+	uint32_t temp;
+	size_t addr = 0;
+	struct gtt_range *gt;
+	struct drm_gem_object *obj;
+	int ret;
+
+	/* if we want to turn of the cursor ignore width and height */
+	if (!handle) {
+		/* turn off the cursor */
+		temp = CURSOR_MODE_DISABLE;
+
+		if (gma_power_begin(dev, false)) {
+			REG_WRITE(control, temp);
+			REG_WRITE(base, 0);
+			gma_power_end(dev);
+		}
+
+		/* unpin the old GEM object */
+		if (psb_intel_crtc->cursor_obj) {
+			gt = container_of(psb_intel_crtc->cursor_obj,
+							struct gtt_range, gem);
+			psb_gtt_unpin(gt);
+			drm_gem_object_unreference(psb_intel_crtc->cursor_obj);
+			psb_intel_crtc->cursor_obj = NULL;
+		}
+
+		return 0;
+	}
+
+	/* Currently we only support 64x64 cursors */
+	if (width != 64 || height != 64) {
+		dev_dbg(dev->dev, "we currently only support 64x64 cursors\n");
+		return -EINVAL;
+	}
+
+	obj = drm_gem_object_lookup(dev, file_priv, handle);
+	if (!obj)
+		return -ENOENT;
+
+	if (obj->size < width * height * 4) {
+		dev_dbg(dev->dev, "buffer is to small\n");
+		return -ENOMEM;
+	}
+
+	gt = container_of(obj, struct gtt_range, gem);
+
+	/* Pin the memory into the GTT */
+	ret = psb_gtt_pin(gt);
+	if (ret) {
+		dev_err(dev->dev, "Can not pin down handle 0x%x\n", handle);
+		return ret;
+	}
+
+	addr = gt->offset;	/* Or resource.start ??? */
+
+	psb_intel_crtc->cursor_addr = addr;
+
+	temp = 0;
+	/* set the pipe for the cursor */
+	temp |= (pipe << 28);
+	temp |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
+
+	if (gma_power_begin(dev, false)) {
+		REG_WRITE(control, temp);
+		REG_WRITE(base, addr);
+		gma_power_end(dev);
+	}
+
+	/* unpin the old GEM object */
+	if (psb_intel_crtc->cursor_obj) {
+		gt = container_of(psb_intel_crtc->cursor_obj,
+							struct gtt_range, gem);
+		psb_gtt_unpin(gt);
+		drm_gem_object_unreference(psb_intel_crtc->cursor_obj);
+		psb_intel_crtc->cursor_obj = obj;
+	}
+	return 0;
+}
+
+static int cdv_intel_crtc_cursor_move(struct drm_crtc *crtc, int x, int y)
+{
+	struct drm_device *dev = crtc->dev;
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int pipe = psb_intel_crtc->pipe;
+	uint32_t temp = 0;
+	uint32_t adder;
+
+
+	if (x < 0) {
+		temp |= (CURSOR_POS_SIGN << CURSOR_X_SHIFT);
+		x = -x;
+	}
+	if (y < 0) {
+		temp |= (CURSOR_POS_SIGN << CURSOR_Y_SHIFT);
+		y = -y;
+	}
+
+	temp |= ((x & CURSOR_POS_MASK) << CURSOR_X_SHIFT);
+	temp |= ((y & CURSOR_POS_MASK) << CURSOR_Y_SHIFT);
+
+	adder = psb_intel_crtc->cursor_addr;
+
+	if (gma_power_begin(dev, false)) {
+		REG_WRITE((pipe == 0) ? CURAPOS : CURBPOS, temp);
+		REG_WRITE((pipe == 0) ? CURABASE : CURBBASE, adder);
+		gma_power_end(dev);
+	}
+	return 0;
+}
+
+static void cdv_intel_crtc_gamma_set(struct drm_crtc *crtc, u16 *red,
+				 u16 *green, u16 *blue, uint32_t start, uint32_t size)
+{
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int i;
+	int end = (start + size > 256) ? 256 : start + size;
+
+	for (i = start; i < end; i++) {
+		psb_intel_crtc->lut_r[i] = red[i] >> 8;
+		psb_intel_crtc->lut_g[i] = green[i] >> 8;
+		psb_intel_crtc->lut_b[i] = blue[i] >> 8;
+	}
+
+	cdv_intel_crtc_load_lut(crtc);
+}
+
+static int cdv_crtc_set_config(struct drm_mode_set *set)
+{
+	int ret = 0;
+	struct drm_device * dev = set->crtc->dev;
+	struct drm_psb_private * dev_priv = dev->dev_private;
+
+	if(!dev_priv->rpm_enabled)
+		return drm_crtc_helper_set_config(set);
+
+	pm_runtime_forbid(&dev->pdev->dev);
+
+	ret = drm_crtc_helper_set_config(set);
+
+	pm_runtime_allow(&dev->pdev->dev);
+
+	return ret;
+}
+
+/** Derive the pixel clock for the given refclk and divisors for 8xx chips. */
+
+/* FIXME: why are we using this, should it be cdv_ in this tree ? */
+
+static void i8xx_clock(int refclk, struct cdv_intel_clock_t *clock)
+{
+	clock->m = 5 * (clock->m1 + 2) + (clock->m2 + 2);
+	clock->p = clock->p1 * clock->p2;
+	clock->vco = refclk * clock->m / (clock->n + 2);
+	clock->dot = clock->vco / clock->p;
+}
+
+/* Returns the clock of the currently programmed mode of the given pipe. */
+static int cdv_intel_crtc_clock_get(struct drm_device *dev,
+				struct drm_crtc *crtc)
+{
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int pipe = psb_intel_crtc->pipe;
+	u32 dpll;
+	u32 fp;
+	struct cdv_intel_clock_t clock;
+	bool is_lvds;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	if (gma_power_begin(dev, false)) {
+		dpll = REG_READ((pipe == 0) ? DPLL_A : DPLL_B);
+		if ((dpll & DISPLAY_RATE_SELECT_FPA1) == 0)
+			fp = REG_READ((pipe == 0) ? FPA0 : FPB0);
+		else
+			fp = REG_READ((pipe == 0) ? FPA1 : FPB1);
+		is_lvds = (pipe == 1) && (REG_READ(LVDS) & LVDS_PORT_EN);
+		gma_power_end(dev);
+	} else {
+		dpll = (pipe == 0) ?
+			dev_priv->saveDPLL_A : dev_priv->saveDPLL_B;
+
+		if ((dpll & DISPLAY_RATE_SELECT_FPA1) == 0)
+			fp = (pipe == 0) ?
+				dev_priv->saveFPA0 :
+				dev_priv->saveFPB0;
+		else
+			fp = (pipe == 0) ?
+				dev_priv->saveFPA1 :
+				dev_priv->saveFPB1;
+
+		is_lvds = (pipe == 1) && (dev_priv->saveLVDS & LVDS_PORT_EN);
+	}
+
+	clock.m1 = (fp & FP_M1_DIV_MASK) >> FP_M1_DIV_SHIFT;
+	clock.m2 = (fp & FP_M2_DIV_MASK) >> FP_M2_DIV_SHIFT;
+	clock.n = (fp & FP_N_DIV_MASK) >> FP_N_DIV_SHIFT;
+
+	if (is_lvds) {
+		clock.p1 =
+		    ffs((dpll &
+			 DPLL_FPA01_P1_POST_DIV_MASK_I830_LVDS) >>
+			DPLL_FPA01_P1_POST_DIV_SHIFT);
+		if (clock.p1 == 0) {
+			clock.p1 = 4;
+			dev_err(dev->dev, "PLL %d\n", dpll);
+		}
+		clock.p2 = 14;
+
+		if ((dpll & PLL_REF_INPUT_MASK) ==
+		    PLLB_REF_INPUT_SPREADSPECTRUMIN) {
+			/* XXX: might not be 66MHz */
+			i8xx_clock(66000, &clock);
+		} else
+			i8xx_clock(48000, &clock);
+	} else {
+		if (dpll & PLL_P1_DIVIDE_BY_TWO)
+			clock.p1 = 2;
+		else {
+			clock.p1 =
+			    ((dpll &
+			      DPLL_FPA01_P1_POST_DIV_MASK_I830) >>
+			     DPLL_FPA01_P1_POST_DIV_SHIFT) + 2;
+		}
+		if (dpll & PLL_P2_DIVIDE_BY_4)
+			clock.p2 = 4;
+		else
+			clock.p2 = 2;
+
+		i8xx_clock(48000, &clock);
+	}
+
+	/* XXX: It would be nice to validate the clocks, but we can't reuse
+	 * i830PllIsValid() because it relies on the xf86_config connector
+	 * configuration being accurate, which it isn't necessarily.
+	 */
+
+	return clock.dot;
+}
+
+/** Returns the currently programmed mode of the given pipe. */
+struct drm_display_mode *cdv_intel_crtc_mode_get(struct drm_device *dev,
+					     struct drm_crtc *crtc)
+{
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int pipe = psb_intel_crtc->pipe;
+	struct drm_display_mode *mode;
+	int htot;
+	int hsync;
+	int vtot;
+	int vsync;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	if (gma_power_begin(dev, false)) {
+		htot = REG_READ((pipe == 0) ? HTOTAL_A : HTOTAL_B);
+		hsync = REG_READ((pipe == 0) ? HSYNC_A : HSYNC_B);
+		vtot = REG_READ((pipe == 0) ? VTOTAL_A : VTOTAL_B);
+		vsync = REG_READ((pipe == 0) ? VSYNC_A : VSYNC_B);
+		gma_power_end(dev);
+	} else {
+		htot = (pipe == 0) ?
+			dev_priv->saveHTOTAL_A : dev_priv->saveHTOTAL_B;
+		hsync = (pipe == 0) ?
+			dev_priv->saveHSYNC_A : dev_priv->saveHSYNC_B;
+		vtot = (pipe == 0) ?
+			dev_priv->saveVTOTAL_A : dev_priv->saveVTOTAL_B;
+		vsync = (pipe == 0) ?
+			dev_priv->saveVSYNC_A : dev_priv->saveVSYNC_B;
+	}
+
+	mode = kzalloc(sizeof(*mode), GFP_KERNEL);
+	if (!mode)
+		return NULL;
+
+	mode->clock = cdv_intel_crtc_clock_get(dev, crtc);
+	mode->hdisplay = (htot & 0xffff) + 1;
+	mode->htotal = ((htot & 0xffff0000) >> 16) + 1;
+	mode->hsync_start = (hsync & 0xffff) + 1;
+	mode->hsync_end = ((hsync & 0xffff0000) >> 16) + 1;
+	mode->vdisplay = (vtot & 0xffff) + 1;
+	mode->vtotal = ((vtot & 0xffff0000) >> 16) + 1;
+	mode->vsync_start = (vsync & 0xffff) + 1;
+	mode->vsync_end = ((vsync & 0xffff0000) >> 16) + 1;
+
+	drm_mode_set_name(mode);
+	drm_mode_set_crtcinfo(mode, 0);
+
+	return mode;
+}
+
+static void cdv_intel_crtc_destroy(struct drm_crtc *crtc)
+{
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+
+	kfree(psb_intel_crtc->crtc_state);
+	drm_crtc_cleanup(crtc);
+	kfree(psb_intel_crtc);
+}
+
+const struct drm_crtc_helper_funcs cdv_intel_helper_funcs = {
+	.dpms = cdv_intel_crtc_dpms,
+	.mode_fixup = cdv_intel_crtc_mode_fixup,
+	.mode_set = cdv_intel_crtc_mode_set,
+	.mode_set_base = cdv_intel_pipe_set_base,
+	.prepare = cdv_intel_crtc_prepare,
+	.commit = cdv_intel_crtc_commit,
+};
+
+const struct drm_crtc_funcs cdv_intel_crtc_funcs = {
+	.save = cdv_intel_crtc_save,
+	.restore = cdv_intel_crtc_restore,
+	.cursor_set = cdv_intel_crtc_cursor_set,
+	.cursor_move = cdv_intel_crtc_cursor_move,
+	.gamma_set = cdv_intel_crtc_gamma_set,
+	.set_config = cdv_crtc_set_config,
+	.destroy = cdv_intel_crtc_destroy,
+};
+
+/*
+ * Set the default value of cursor control and base register
+ * to zero. This is a workaround for h/w defect on oaktrail
+ */
+void cdv_intel_cursor_init(struct drm_device *dev, int pipe)
+{
+	uint32_t control;
+	uint32_t base;
+      
+	switch (pipe) {
+	case 0:
+		control = CURACNTR;
+		base = CURABASE;
+		break;
+	case 1:
+		control = CURBCNTR;
+		base = CURBBASE;
+		break;
+	case 2:
+		control = CURCCNTR;
+		base = CURCBASE;
+		break;
+	default:
+		return;
+	}
+
+	REG_WRITE(control, 0);
+	REG_WRITE(base, 0);
+}
+
diff --git a/drivers/staging/gma500/cdv_intel_lvds.c b/drivers/staging/gma500/cdv_intel_lvds.c
new file mode 100644
index 0000000..d9b2290
--- /dev/null
+++ b/drivers/staging/gma500/cdv_intel_lvds.c
@@ -0,0 +1,718 @@
+/*
+ * Copyright © 2006-2011 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors:
+ *	Eric Anholt <eric@anholt.net>
+ *	Dave Airlie <airlied@linux.ie>
+ *	Jesse Barnes <jesse.barnes@intel.com>
+ */
+
+#include <linux/i2c.h>
+#include <linux/dmi.h>
+#include <drm/drmP.h>
+
+#include "intel_bios.h"
+#include "psb_drv.h"
+#include "psb_intel_drv.h"
+#include "psb_intel_reg.h"
+#include "power.h"
+#include <linux/pm_runtime.h>
+#include "cdv_device.h"
+
+/**
+ * LVDS I2C backlight control macros
+ */
+#define BRIGHTNESS_MAX_LEVEL 100
+#define BRIGHTNESS_MASK 0xFF
+#define BLC_I2C_TYPE	0x01
+#define BLC_PWM_TYPT	0x02
+
+#define BLC_POLARITY_NORMAL 0
+#define BLC_POLARITY_INVERSE 1
+
+#define PSB_BLC_MAX_PWM_REG_FREQ       (0xFFFE)
+#define PSB_BLC_MIN_PWM_REG_FREQ	(0x2)
+#define PSB_BLC_PWM_PRECISION_FACTOR	(10)
+#define PSB_BACKLIGHT_PWM_CTL_SHIFT	(16)
+#define PSB_BACKLIGHT_PWM_POLARITY_BIT_CLEAR (0xFFFE)
+
+struct cdv_intel_lvds_priv {
+	/**
+	 * Saved LVDO output states
+	 */
+	uint32_t savePP_ON;
+	uint32_t savePP_OFF;
+	uint32_t saveLVDS;
+	uint32_t savePP_CONTROL;
+	uint32_t savePP_CYCLE;
+	uint32_t savePFIT_CONTROL;
+	uint32_t savePFIT_PGM_RATIOS;
+	uint32_t saveBLC_PWM_CTL;
+};
+
+/*
+ * Returns the maximum level of the backlight duty cycle field.
+ */
+static u32 cdv_intel_lvds_get_max_backlight(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	u32 retval;
+
+	if (gma_power_begin(dev, false)) {
+		retval = ((REG_READ(BLC_PWM_CTL) &
+			  BACKLIGHT_MODULATION_FREQ_MASK) >>
+			  BACKLIGHT_MODULATION_FREQ_SHIFT) * 2;
+
+		gma_power_end(dev);
+	} else
+		retval = ((dev_priv->saveBLC_PWM_CTL &
+			  BACKLIGHT_MODULATION_FREQ_MASK) >>
+			  BACKLIGHT_MODULATION_FREQ_SHIFT) * 2;
+
+	return retval;
+}
+
+/*
+ * Set LVDS backlight level by I2C command
+ */
+static int cdv_lvds_i2c_set_brightness(struct drm_device *dev,
+					unsigned int level)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_intel_i2c_chan *lvds_i2c_bus = dev_priv->lvds_i2c_bus;
+	u8 out_buf[2];
+	unsigned int blc_i2c_brightness;
+
+	struct i2c_msg msgs[] = {
+		{
+			.addr = lvds_i2c_bus->slave_addr,
+			.flags = 0,
+			.len = 2,
+			.buf = out_buf,
+		}
+	};
+
+	blc_i2c_brightness = BRIGHTNESS_MASK & ((unsigned int)level *
+			     BRIGHTNESS_MASK /
+			     BRIGHTNESS_MAX_LEVEL);
+
+	if (dev_priv->lvds_bl->pol == BLC_POLARITY_INVERSE)
+		blc_i2c_brightness = BRIGHTNESS_MASK - blc_i2c_brightness;
+
+	out_buf[0] = dev_priv->lvds_bl->brightnesscmd;
+	out_buf[1] = (u8)blc_i2c_brightness;
+
+	if (i2c_transfer(&lvds_i2c_bus->adapter, msgs, 1) == 1)
+		return 0;
+
+	DRM_ERROR("I2C transfer error\n");
+	return -1;
+}
+
+
+static int cdv_lvds_pwm_set_brightness(struct drm_device *dev, int level)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	u32 max_pwm_blc;
+	u32 blc_pwm_duty_cycle;
+
+	max_pwm_blc = cdv_intel_lvds_get_max_backlight(dev);
+
+	/*BLC_PWM_CTL Should be initiated while backlight device init*/
+	BUG_ON((max_pwm_blc & PSB_BLC_MAX_PWM_REG_FREQ) == 0);
+
+	blc_pwm_duty_cycle = level * max_pwm_blc / BRIGHTNESS_MAX_LEVEL;
+
+	if (dev_priv->lvds_bl->pol == BLC_POLARITY_INVERSE)
+		blc_pwm_duty_cycle = max_pwm_blc - blc_pwm_duty_cycle;
+
+	blc_pwm_duty_cycle &= PSB_BACKLIGHT_PWM_POLARITY_BIT_CLEAR;
+	REG_WRITE(BLC_PWM_CTL,
+		  (max_pwm_blc << PSB_BACKLIGHT_PWM_CTL_SHIFT) |
+		  (blc_pwm_duty_cycle));
+
+	return 0;
+}
+
+/*
+ * Set LVDS backlight level either by I2C or PWM
+ */
+void cdv_intel_lvds_set_brightness(struct drm_device *dev, int level)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	if (!dev_priv->lvds_bl) {
+		DRM_ERROR("NO LVDS Backlight Info\n");
+		return;
+	}
+
+	if (dev_priv->lvds_bl->type == BLC_I2C_TYPE)
+		cdv_lvds_i2c_set_brightness(dev, level);
+	else
+		cdv_lvds_pwm_set_brightness(dev, level);
+}
+
+/**
+ * Sets the backlight level.
+ *
+ * level backlight level, from 0 to cdv_intel_lvds_get_max_backlight().
+ */
+static void cdv_intel_lvds_set_backlight(struct drm_device *dev, int level)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	u32 blc_pwm_ctl;
+
+	if (gma_power_begin(dev, false)) {
+		blc_pwm_ctl =
+			REG_READ(BLC_PWM_CTL) & ~BACKLIGHT_DUTY_CYCLE_MASK;
+		REG_WRITE(BLC_PWM_CTL,
+				(blc_pwm_ctl |
+				(level << BACKLIGHT_DUTY_CYCLE_SHIFT)));
+		gma_power_end(dev);
+	} else {
+		blc_pwm_ctl = dev_priv->saveBLC_PWM_CTL &
+				~BACKLIGHT_DUTY_CYCLE_MASK;
+		dev_priv->saveBLC_PWM_CTL = (blc_pwm_ctl |
+					(level << BACKLIGHT_DUTY_CYCLE_SHIFT));
+	}
+}
+
+/**
+ * Sets the power state for the panel.
+ */
+static void cdv_intel_lvds_set_power(struct drm_device *dev,
+				 struct psb_intel_output *output, bool on)
+{
+	u32 pp_status;
+
+	if (!gma_power_begin(dev, true))
+	        return;
+
+	if (on) {
+		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) |
+			  POWER_TARGET_ON);
+		do {
+			pp_status = REG_READ(PP_STATUS);
+		} while ((pp_status & PP_ON) == 0);
+
+		cdv_intel_lvds_set_backlight(dev,
+					 output->
+					 mode_dev->backlight_duty_cycle);
+	} else {
+		cdv_intel_lvds_set_backlight(dev, 0);
+
+		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) &
+			  ~POWER_TARGET_ON);
+		do {
+			pp_status = REG_READ(PP_STATUS);
+		} while (pp_status & PP_ON);
+	}
+	gma_power_end(dev);
+}
+
+static void cdv_intel_lvds_encoder_dpms(struct drm_encoder *encoder, int mode)
+{
+	struct drm_device *dev = encoder->dev;
+	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
+	if (mode == DRM_MODE_DPMS_ON)
+		cdv_intel_lvds_set_power(dev, output, true);
+	else
+		cdv_intel_lvds_set_power(dev, output, false);
+	/* XXX: We never power down the LVDS pairs. */
+}
+
+static void cdv_intel_lvds_save(struct drm_connector *connector)
+{
+}
+
+static void cdv_intel_lvds_restore(struct drm_connector *connector)
+{
+}
+
+int cdv_intel_lvds_mode_valid(struct drm_connector *connector,
+				 struct drm_display_mode *mode)
+{
+	struct psb_intel_output *psb_intel_output =
+				to_psb_intel_output(connector);
+	struct drm_display_mode *fixed_mode =
+	    psb_intel_output->mode_dev->panel_fixed_mode;
+
+	/* just in case */
+	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
+		return MODE_NO_DBLESCAN;
+
+	/* just in case */
+	if (mode->flags & DRM_MODE_FLAG_INTERLACE)
+		return MODE_NO_INTERLACE;
+
+	if (fixed_mode) {
+		if (mode->hdisplay > fixed_mode->hdisplay)
+			return MODE_PANEL;
+		if (mode->vdisplay > fixed_mode->vdisplay)
+			return MODE_PANEL;
+	}
+	return MODE_OK;
+}
+
+bool cdv_intel_lvds_mode_fixup(struct drm_encoder *encoder,
+				  struct drm_display_mode *mode,
+				  struct drm_display_mode *adjusted_mode)
+{
+	struct psb_intel_mode_device *mode_dev =
+	    enc_to_psb_intel_output(encoder)->mode_dev;
+	struct drm_device *dev = encoder->dev;
+	struct drm_encoder *tmp_encoder;
+	struct drm_display_mode *panel_fixed_mode = mode_dev->panel_fixed_mode;
+
+	/* Should never happen!! */
+	list_for_each_entry(tmp_encoder, &dev->mode_config.encoder_list,
+			    head) {
+		if (tmp_encoder != encoder
+		    && tmp_encoder->crtc == encoder->crtc) {
+			printk(KERN_ERR "Can't enable LVDS and another "
+			       "encoder on the same pipe\n");
+			return false;
+		}
+	}
+
+	/*
+	 * If we have timings from the BIOS for the panel, put them in
+	 * to the adjusted mode.  The CRTC will be set up for this mode,
+	 * with the panel scaling set up to source from the H/VDisplay
+	 * of the original mode.
+	 */
+	if (panel_fixed_mode != NULL) {
+		adjusted_mode->hdisplay = panel_fixed_mode->hdisplay;
+		adjusted_mode->hsync_start = panel_fixed_mode->hsync_start;
+		adjusted_mode->hsync_end = panel_fixed_mode->hsync_end;
+		adjusted_mode->htotal = panel_fixed_mode->htotal;
+		adjusted_mode->vdisplay = panel_fixed_mode->vdisplay;
+		adjusted_mode->vsync_start = panel_fixed_mode->vsync_start;
+		adjusted_mode->vsync_end = panel_fixed_mode->vsync_end;
+		adjusted_mode->vtotal = panel_fixed_mode->vtotal;
+		adjusted_mode->clock = panel_fixed_mode->clock;
+		drm_mode_set_crtcinfo(adjusted_mode,
+				      CRTC_INTERLACE_HALVE_V);
+	}
+
+	/*
+	 * XXX: It would be nice to support lower refresh rates on the
+	 * panels to reduce power consumption, and perhaps match the
+	 * user's requested refresh rate.
+	 */
+
+	return true;
+}
+
+static void cdv_intel_lvds_prepare(struct drm_encoder *encoder)
+{
+	struct drm_device *dev = encoder->dev;
+	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
+	struct psb_intel_mode_device *mode_dev = output->mode_dev;
+
+	if (!gma_power_begin(dev, true))
+		return;
+
+	mode_dev->saveBLC_PWM_CTL = REG_READ(BLC_PWM_CTL);
+	mode_dev->backlight_duty_cycle = (mode_dev->saveBLC_PWM_CTL &
+					  BACKLIGHT_DUTY_CYCLE_MASK);
+
+	cdv_intel_lvds_set_power(dev, output, false);
+
+	gma_power_end(dev);
+}
+
+static void cdv_intel_lvds_commit(struct drm_encoder *encoder)
+{
+	struct drm_device *dev = encoder->dev;
+	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
+	struct psb_intel_mode_device *mode_dev = output->mode_dev;
+
+	if (mode_dev->backlight_duty_cycle == 0)
+		mode_dev->backlight_duty_cycle =
+		    cdv_intel_lvds_get_max_backlight(dev);
+
+	cdv_intel_lvds_set_power(dev, output, true);
+}
+
+static void cdv_intel_lvds_mode_set(struct drm_encoder *encoder,
+				struct drm_display_mode *mode,
+				struct drm_display_mode *adjusted_mode)
+{
+	struct psb_intel_mode_device *mode_dev =
+	    enc_to_psb_intel_output(encoder)->mode_dev;
+	struct drm_device *dev = encoder->dev;
+	u32 pfit_control;
+
+	/*
+	 * The LVDS pin pair will already have been turned on in the
+	 * cdv_intel_crtc_mode_set since it has a large impact on the DPLL
+	 * settings.
+	 */
+
+	/*
+	 * Enable automatic panel scaling so that non-native modes fill the
+	 * screen.  Should be enabled before the pipe is enabled, according to
+	 * register description and PRM.
+	 */
+	if (mode->hdisplay != adjusted_mode->hdisplay ||
+	    mode->vdisplay != adjusted_mode->vdisplay)
+		pfit_control = (PFIT_ENABLE | VERT_AUTO_SCALE |
+				HORIZ_AUTO_SCALE | VERT_INTERP_BILINEAR |
+				HORIZ_INTERP_BILINEAR);
+	else
+		pfit_control = 0;
+
+	if (mode_dev->panel_wants_dither)
+		pfit_control |= PANEL_8TO6_DITHER_ENABLE;
+
+	REG_WRITE(PFIT_CONTROL, pfit_control);
+}
+
+/**
+ * Detect the LVDS connection.
+ *
+ * This always returns CONNECTOR_STATUS_CONNECTED.
+ * This connector should only have
+ * been set up if the LVDS was actually connected anyway.
+ */
+static enum drm_connector_status cdv_intel_lvds_detect(struct drm_connector *connector, bool force)
+{
+	return connector_status_connected;
+}
+
+/**
+ * Return the list of DDC modes if available, or the BIOS fixed mode otherwise.
+ */
+static int cdv_intel_lvds_get_modes(struct drm_connector *connector)
+{
+	struct drm_device *dev = connector->dev;
+	struct psb_intel_output *psb_intel_output =
+					to_psb_intel_output(connector);
+	struct psb_intel_mode_device *mode_dev =
+					psb_intel_output->mode_dev;
+	int ret;
+
+	ret = psb_intel_ddc_get_modes(psb_intel_output);
+
+	if (ret)
+		return ret;
+
+	/* Didn't get an EDID, so
+	 * Set wide sync ranges so we get all modes
+	 * handed to valid_mode for checking
+	 */
+	connector->display_info.min_vfreq = 0;
+	connector->display_info.max_vfreq = 200;
+	connector->display_info.min_hfreq = 0;
+	connector->display_info.max_hfreq = 200;
+	if (mode_dev->panel_fixed_mode != NULL) {
+		struct drm_display_mode *mode =
+		    drm_mode_duplicate(dev, mode_dev->panel_fixed_mode);
+		drm_mode_probed_add(connector, mode);
+		return 1;
+	}
+
+	return 0;
+}
+
+/**
+ * cdv_intel_lvds_destroy - unregister and free LVDS structures
+ * @connector: connector to free
+ *
+ * Unregister the DDC bus for this connector then free the driver private
+ * structure.
+ */
+void cdv_intel_lvds_destroy(struct drm_connector *connector)
+{
+	struct psb_intel_output *psb_intel_output =
+					to_psb_intel_output(connector);
+
+	if (psb_intel_output->ddc_bus)
+		psb_intel_i2c_destroy(psb_intel_output->ddc_bus);
+	drm_sysfs_connector_remove(connector);
+	drm_connector_cleanup(connector);
+	kfree(connector);
+}
+
+int cdv_intel_lvds_set_property(struct drm_connector *connector,
+				       struct drm_property *property,
+				       uint64_t value)
+{
+	struct drm_encoder *encoder = connector->encoder;
+
+	if (!strcmp(property->name, "scaling mode") && encoder) {
+		struct psb_intel_crtc *crtc =
+					to_psb_intel_crtc(encoder->crtc);
+		uint64_t curValue;
+
+		if (!crtc)
+			return -1;
+
+		switch (value) {
+		case DRM_MODE_SCALE_FULLSCREEN:
+			break;
+		case DRM_MODE_SCALE_NO_SCALE:
+			break;
+		case DRM_MODE_SCALE_ASPECT:
+			break;
+		default:
+			return -1;
+		}
+
+		if (drm_connector_property_get_value(connector,
+						     property,
+						     &curValue))
+			return -1;
+
+		if (curValue == value)
+			return 0;
+
+		if (drm_connector_property_set_value(connector,
+							property,
+							value))
+			return -1;
+
+		if (crtc->saved_mode.hdisplay != 0 &&
+		    crtc->saved_mode.vdisplay != 0) {
+			if (!drm_crtc_helper_set_mode(encoder->crtc,
+						      &crtc->saved_mode,
+						      encoder->crtc->x,
+						      encoder->crtc->y,
+						      encoder->crtc->fb))
+				return -1;
+		}
+	} else if (!strcmp(property->name, "backlight") && encoder) {
+		if (drm_connector_property_set_value(connector,
+							property,
+							value))
+			return -1;
+		else {
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+                	struct drm_psb_private *dev_priv =
+						encoder->dev->dev_private;
+			struct backlight_device *bd = dev_priv->backlight_device;
+			bd->props.brightness = value;
+			backlight_update_status(bd);
+#endif
+		}
+	} else if (!strcmp(property->name, "DPMS") && encoder) {
+		struct drm_encoder_helper_funcs *helpers = encoder->helper_private;
+		helpers->dpms(encoder, value);
+	}
+	return 0;
+}
+
+static const struct drm_encoder_helper_funcs cdv_intel_lvds_helper_funcs = {
+	.dpms = cdv_intel_lvds_encoder_dpms,
+	.mode_fixup = cdv_intel_lvds_mode_fixup,
+	.prepare = cdv_intel_lvds_prepare,
+	.mode_set = cdv_intel_lvds_mode_set,
+	.commit = cdv_intel_lvds_commit,
+};
+
+static const struct drm_connector_helper_funcs
+    cdv_intel_lvds_connector_helper_funcs = {
+	.get_modes = cdv_intel_lvds_get_modes,
+	.mode_valid = cdv_intel_lvds_mode_valid,
+	.best_encoder = psb_intel_best_encoder,
+};
+
+static const struct drm_connector_funcs cdv_intel_lvds_connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.save = cdv_intel_lvds_save,
+	.restore = cdv_intel_lvds_restore,
+	.detect = cdv_intel_lvds_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.set_property = cdv_intel_lvds_set_property,
+	.destroy = cdv_intel_lvds_destroy,
+};
+
+
+static void cdv_intel_lvds_enc_destroy(struct drm_encoder *encoder)
+{
+	drm_encoder_cleanup(encoder);
+}
+
+const struct drm_encoder_funcs cdv_intel_lvds_enc_funcs = {
+	.destroy = cdv_intel_lvds_enc_destroy,
+};
+
+/**
+ * cdv_intel_lvds_init - setup LVDS connectors on this device
+ * @dev: drm device
+ *
+ * Create the connector, register the LVDS DDC bus, and try to figure out what
+ * modes we can display on the LVDS panel (if present).
+ */
+void cdv_intel_lvds_init(struct drm_device *dev,
+		     struct psb_intel_mode_device *mode_dev)
+{
+	struct psb_intel_output *psb_intel_output;
+	struct cdv_intel_lvds_priv *lvds_priv;
+	struct drm_connector *connector;
+	struct drm_encoder *encoder;
+	struct drm_display_mode *scan;
+	struct drm_crtc *crtc;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	u32 lvds;
+	int pipe;
+
+	psb_intel_output = kzalloc(sizeof(struct psb_intel_output) +
+			sizeof(struct cdv_intel_lvds_priv), GFP_KERNEL);
+	if (!psb_intel_output)
+		return;
+
+	lvds_priv = (struct cdv_intel_lvds_priv *)(psb_intel_output + 1);
+
+	psb_intel_output->dev_priv = lvds_priv;
+
+	psb_intel_output->mode_dev = mode_dev;
+	connector = &psb_intel_output->base;
+	encoder = &psb_intel_output->enc;
+
+
+	drm_connector_init(dev, &psb_intel_output->base,
+			   &cdv_intel_lvds_connector_funcs,
+			   DRM_MODE_CONNECTOR_LVDS);
+
+	drm_encoder_init(dev, &psb_intel_output->enc,
+			 &cdv_intel_lvds_enc_funcs,
+			 DRM_MODE_ENCODER_LVDS);
+
+
+	drm_mode_connector_attach_encoder(&psb_intel_output->base,
+					  &psb_intel_output->enc);
+	psb_intel_output->type = INTEL_OUTPUT_LVDS;
+
+	drm_encoder_helper_add(encoder, &cdv_intel_lvds_helper_funcs);
+	drm_connector_helper_add(connector,
+				 &cdv_intel_lvds_connector_helper_funcs);
+	connector->display_info.subpixel_order = SubPixelHorizontalRGB;
+	connector->interlace_allowed = false;
+	connector->doublescan_allowed = false;
+
+	/*Attach connector properties*/
+	drm_connector_attach_property(connector,
+				      dev->mode_config.scaling_mode_property,
+				      DRM_MODE_SCALE_FULLSCREEN);
+	drm_connector_attach_property(connector,
+				      dev_priv->backlight_property,
+				      BRIGHTNESS_MAX_LEVEL);
+
+	/**
+	 * Set up I2C bus
+	 * FIXME: distroy i2c_bus when exit
+	 */
+	psb_intel_output->i2c_bus = psb_intel_i2c_create(dev,
+							 GPIOB,
+							 "LVDSBLC_B");
+	if (!psb_intel_output->i2c_bus) {
+		dev_printk(KERN_ERR,
+			&dev->pdev->dev, "I2C bus registration failed.\n");
+		goto failed_blc_i2c;
+	}
+	psb_intel_output->i2c_bus->slave_addr = 0x2C;
+	dev_priv->lvds_i2c_bus =  psb_intel_output->i2c_bus;
+
+	/*
+	 * LVDS discovery:
+	 * 1) check for EDID on DDC
+	 * 2) check for VBT data
+	 * 3) check to see if LVDS is already on
+	 *    if none of the above, no panel
+	 * 4) make sure lid is open
+	 *    if closed, act like it's not there for now
+	 */
+
+	/* Set up the DDC bus. */
+	psb_intel_output->ddc_bus = psb_intel_i2c_create(dev,
+							 GPIOC,
+							 "LVDSDDC_C");
+	if (!psb_intel_output->ddc_bus) {
+		dev_printk(KERN_ERR, &dev->pdev->dev,
+			   "DDC bus registration " "failed.\n");
+		goto failed_ddc;
+	}
+
+	/*
+	 * Attempt to get the fixed panel mode from DDC.  Assume that the
+	 * preferred mode is the right one.
+	 */
+	psb_intel_ddc_get_modes(psb_intel_output);
+	list_for_each_entry(scan, &connector->probed_modes, head) {
+		if (scan->type & DRM_MODE_TYPE_PREFERRED) {
+			mode_dev->panel_fixed_mode =
+			    drm_mode_duplicate(dev, scan);
+			goto out;	/* FIXME: check for quirks */
+		}
+	}
+
+	/* Failed to get EDID, what about VBT? do we need this?*/
+	if (dev_priv->lfp_lvds_vbt_mode) {
+		mode_dev->panel_fixed_mode =
+			drm_mode_duplicate(dev, dev_priv->lfp_lvds_vbt_mode);
+		if (mode_dev->panel_fixed_mode) {
+			mode_dev->panel_fixed_mode->type |=
+				DRM_MODE_TYPE_PREFERRED;
+			goto out;	/* FIXME: check for quirks */
+		}
+	}
+	/*
+	 * If we didn't get EDID, try checking if the panel is already turned
+	 * on.	If so, assume that whatever is currently programmed is the
+	 * correct mode.
+	 */
+	lvds = REG_READ(LVDS);
+	pipe = (lvds & LVDS_PIPEB_SELECT) ? 1 : 0;
+	crtc = psb_intel_get_crtc_from_pipe(dev, pipe);
+
+	if (crtc && (lvds & LVDS_PORT_EN)) {
+		mode_dev->panel_fixed_mode =
+		    cdv_intel_crtc_mode_get(dev, crtc);
+		if (mode_dev->panel_fixed_mode) {
+			mode_dev->panel_fixed_mode->type |=
+			    DRM_MODE_TYPE_PREFERRED;
+			goto out;	/* FIXME: check for quirks */
+		}
+	}
+
+	/* If we still don't have a mode after all that, give up. */
+	if (!mode_dev->panel_fixed_mode) {
+		DRM_DEBUG
+			("Found no modes on the lvds, ignoring the LVDS\n");
+		goto failed_find;
+	}
+
+out:
+	drm_sysfs_connector_add(connector);
+	return;
+
+failed_find:
+	printk(KERN_ERR "Failed find\n");
+	if (psb_intel_output->ddc_bus)
+		psb_intel_i2c_destroy(psb_intel_output->ddc_bus);
+failed_ddc:
+	printk(KERN_ERR "Failed DDC\n");
+	if (psb_intel_output->i2c_bus)
+		psb_intel_i2c_destroy(psb_intel_output->i2c_bus);
+failed_blc_i2c:
+	printk(KERN_ERR "Failed BLC\n");
+	drm_encoder_cleanup(encoder);
+	drm_connector_cleanup(connector);
+	kfree(connector);
+}
diff --git a/drivers/staging/gma500/framebuffer.c b/drivers/staging/gma500/framebuffer.c
index 716a7b9..c6dd4d8 100644
--- a/drivers/staging/gma500/framebuffer.c
+++ b/drivers/staging/gma500/framebuffer.c
@@ -732,6 +732,10 @@ static void psb_setup_outputs(struct drm_device *dev)
 
 		/* valid crtcs */
 		switch (psb_intel_output->type) {
+		case INTEL_OUTPUT_ANALOG:
+			crtc_mask = (1 << 0);
+			clone_mask = (1 << INTEL_OUTPUT_ANALOG);
+			break;
 		case INTEL_OUTPUT_SDVO:
 			crtc_mask = ((1 << 0) | (1 << 1));
 			clone_mask = (1 << INTEL_OUTPUT_SDVO);
@@ -752,7 +756,10 @@ static void psb_setup_outputs(struct drm_device *dev)
 			clone_mask = (1 << INTEL_OUTPUT_MIPI2);
 			break;
 		case INTEL_OUTPUT_HDMI:
-			crtc_mask = (1 << 1);
+		        if (IS_MFLD(dev))
+        			crtc_mask = (1 << 1);
+                        else	/* FIXME: review Oaktrail */
+                                crtc_mask = (1 << 0);	/* Cedarview */
 			clone_mask = (1 << INTEL_OUTPUT_HDMI);
 			break;
 		}
diff --git a/drivers/staging/gma500/gtt.c b/drivers/staging/gma500/gtt.c
index 6cfa59b..28f2261 100644
--- a/drivers/staging/gma500/gtt.c
+++ b/drivers/staging/gma500/gtt.c
@@ -395,12 +395,10 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 	(void) PSB_RVDC32(PSB_PGETBL_CTL);
 
 	/* The root resource we allocate address space from */
-	dev_priv->gtt_mem = &dev->pdev->resource[PSB_GATT_RESOURCE];
 	dev_priv->gtt_initialized = 1;
 
-	pg->gtt_phys_start = dev_priv->pge_ctl & PAGE_MASK;
-
-	pg->gatt_start = pci_resource_start(dev->pdev, PSB_GATT_RESOURCE);
+	pg->gtt_phys_start = dev_priv->pge_ctl;
+	
 	/*
 	 *	FIXME: video mmu has hw bug to access 0x0D0000000,
 	 *	then make gatt start at 0x0e000,0000
@@ -410,8 +408,33 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 	pg->gtt_start = pci_resource_start(dev->pdev, PSB_GTT_RESOURCE);
 	gtt_pages = pci_resource_len(dev->pdev, PSB_GTT_RESOURCE)
 								>> PAGE_SHIFT;
+	/* CDV workaround */
+	if (pg->gtt_start == 0 || gtt_pages == 0) {
+		dev_err(dev->dev, "GTT PCI BAR not initialized.\n");
+		gtt_pages = 64;
+		pg->gtt_start = dev_priv->pge_ctl;
+	}
+
+	pg->gatt_start = pci_resource_start(dev->pdev, PSB_GATT_RESOURCE);
 	pg->gatt_pages = pci_resource_len(dev->pdev, PSB_GATT_RESOURCE)
 								>> PAGE_SHIFT;
+	dev_priv->gtt_mem = &dev->pdev->resource[PSB_GATT_RESOURCE];
+
+	if (pg->gatt_pages == 0 || pg->gatt_start == 0) {
+		static struct resource fudge;	/* Preferably peppermint */
+
+		/* This can occur on CDV SDV systems. Fudge it in this case.
+		   We really don't care what imaginary space is being allocated
+		   at this point */
+		dev_err(dev->dev, "GATT PCI BAR not initialized.\n");
+		pg->gatt_start = 0x40000000;
+		pg->gatt_pages = (128 * 1024 * 1024) >> PAGE_SHIFT;
+		fudge.start = 0x40000000;
+		fudge.end = 0x40000000 + 128 * 1024 * 1024 - 1;
+		fudge.name = "fudge";
+		fudge.flags = IORESOURCE_MEM;
+		dev_priv->gtt_mem = &fudge;
+	}
 
 	pci_read_config_dword(dev->pdev, PSB_BSM, &dev_priv->stolen_base);
 	vram_stolen_size = pg->gtt_phys_start - dev_priv->stolen_base
@@ -463,7 +486,7 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 	pfn_base = dev_priv->stolen_base >> PAGE_SHIFT;
 	vram_pages = num_pages = vram_stolen_size >> PAGE_SHIFT;
 	printk(KERN_INFO"Set up %d stolen pages starting at 0x%08x, GTT offset %dK\n",
-		num_pages, pfn_base, 0);
+		num_pages, pfn_base << PAGE_SHIFT, 0);
 	for (i = 0; i < num_pages; ++i) {
 		pte = psb_gtt_mask_pte(pfn_base + i, 0);
 		iowrite32(pte, dev_priv->gtt_map + i);
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index 8f503d9..bd0a4bc 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -1039,14 +1039,13 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 	}
 
 	/* unpin the old bo */
-	if (psb_intel_crtc->cursor_obj && psb_intel_crtc->cursor_obj != obj) {
+	if (psb_intel_crtc->cursor_obj) {
 		gt = container_of(psb_intel_crtc->cursor_obj,
 							struct gtt_range, gem);
 		psb_gtt_unpin(gt);
 		drm_gem_object_unreference(psb_intel_crtc->cursor_obj);
 		psb_intel_crtc->cursor_obj = obj;
 	}
-
 	return 0;
 }
 
diff --git a/drivers/staging/gma500/psb_intel_reg.h b/drivers/staging/gma500/psb_intel_reg.h
index c9630a2..1ac16aa 100644
--- a/drivers/staging/gma500/psb_intel_reg.h
+++ b/drivers/staging/gma500/psb_intel_reg.h
@@ -142,6 +142,8 @@
 #define DPLLB_LVDS_P2_CLOCK_DIV_7	(1 << 24)	/* i915 */
 #define DPLL_P2_CLOCK_DIV_MASK		0x03000000	/* i915 */
 #define DPLL_FPA01_P1_POST_DIV_MASK	0x00ff0000	/* i915 */
+#define DPLL_LOCK			(1 << 15)	/* CDV */
+
 /*
  *  The i830 generation, in DAC/serial mode, defines p1 as two plus this
  * bitfield, or just 2 if PLL_P1_DIVIDE_BY_TWO is set.
@@ -271,6 +273,20 @@
 #define TV_HOTPLUG_INT_EN		(1 << 18)
 #define CRT_HOTPLUG_INT_EN		(1 << 9)
 #define CRT_HOTPLUG_FORCE_DETECT	(1 << 3)
+/* CDV.. */
+#define CRT_HOTPLUG_ACTIVATION_PERIOD_64	(1 << 8)
+#define CRT_HOTPLUG_DAC_ON_TIME_2M		(0 << 7)
+#define CRT_HOTPLUG_DAC_ON_TIME_4M		(1 << 7)
+#define CRT_HOTPLUG_VOLTAGE_COMPARE_40		(0 << 5)
+#define CRT_HOTPLUG_VOLTAGE_COMPARE_50		(1 << 5)
+#define CRT_HOTPLUG_VOLTAGE_COMPARE_60		(2 << 5)
+#define CRT_HOTPLUG_VOLTAGE_COMPARE_70		(3 << 5)
+#define CRT_HOTPLUG_VOLTAGE_COMPARE_MASK	(3 << 5)
+#define CRT_HOTPLUG_DETECT_DELAY_1G		(0 << 4)
+#define CRT_HOTPLUG_DETECT_DELAY_2G		(1 << 4)
+#define CRT_HOTPLUG_DETECT_VOLTAGE_325MV	(0 << 2)
+#define CRT_HOTPLUG_DETECT_VOLTAGE_475MV	(1 << 2)
+#define CRT_HOTPLUG_DETECT_MASK			0x000000F8
 
 #define PORT_HOTPLUG_STAT	0x61114
 #define CRT_HOTPLUG_INT_STATUS		(1 << 11)
@@ -1141,4 +1157,79 @@ No status bits are changed.
 #define SKU_100L			0x04
 #define SKU_BYPASS			0x08
 
+/* Some handy macros for playing with bitfields. */
+#define PSB_MASK(high, low) (((1<<((high)-(low)+1))-1)<<(low))
+#define SET_FIELD(value, field) (((value) << field ## _SHIFT) & field ## _MASK)
+#define GET_FIELD(word, field) (((word)  & field ## _MASK) >> field ## _SHIFT)
+
+#define _PIPE(pipe, a, b) ((a) + (pipe)*((b)-(a)))
+
+/* PCI config space */
+
+#define SB_PCKT         0x02100 /* cedarview */
+# define SB_OPCODE_MASK                         PSB_MASK(31, 16)
+# define SB_OPCODE_SHIFT                        16
+# define SB_OPCODE_READ                         0
+# define SB_OPCODE_WRITE                        1
+# define SB_DEST_MASK                           PSB_MASK(15, 8)
+# define SB_DEST_SHIFT                          8
+# define SB_DEST_DPLL                           0x88
+# define SB_BYTE_ENABLE_MASK                    PSB_MASK(7, 4)
+# define SB_BYTE_ENABLE_SHIFT                   4
+# define SB_BUSY                                (1 << 0)
+
+
+/* 32-bit value read/written from the DPIO reg. */
+#define SB_DATA		0x02104 /* cedarview */
+/* 32-bit address of the DPIO reg to be read/written. */
+#define SB_ADDR		0x02108 /* cedarview */
+#define DPIO_CFG	0x02110 /* cedarview */
+# define DPIO_MODE_SELECT_1			(1 << 3)
+# define DPIO_MODE_SELECT_0			(1 << 2)
+# define DPIO_SFR_BYPASS			(1 << 1)
+/* reset is active low */
+# define DPIO_CMN_RESET_N			(1 << 0)
+
+/* Cedarview sideband registers */
+#define _SB_M_A			0x8008
+#define _SB_M_B			0x8028
+#define SB_M(pipe) _PIPE(pipe, _SB_M_A, _SB_M_B)
+# define SB_M_DIVIDER_MASK			(0xFF << 24)
+# define SB_M_DIVIDER_SHIFT			24
+
+#define _SB_N_VCO_A		0x8014
+#define _SB_N_VCO_B		0x8034
+#define SB_N_VCO(pipe) _PIPE(pipe, _SB_N_VCO_A, _SB_N_VCO_B)
+#define SB_N_VCO_SEL_MASK			PSB_MASK(31, 30)
+#define SB_N_VCO_SEL_SHIFT			30
+#define SB_N_DIVIDER_MASK			PSB_MASK(29, 26)
+#define SB_N_DIVIDER_SHIFT			26
+#define SB_N_CB_TUNE_MASK			PSB_MASK(25, 24)
+#define SB_N_CB_TUNE_SHIFT			24
+
+#define _SB_REF_A		0x8018
+#define _SB_REF_B		0x8038
+#define SB_REF_SFR(pipe)	_PIPE(pipe, _SB_REF_A, _SB_REF_B)
+
+#define _SB_P_A			0x801c
+#define _SB_P_B			0x803c
+#define SB_P(pipe) _PIPE(pipe, _SB_P_A, _SB_P_B)
+#define SB_P2_DIVIDER_MASK			PSB_MASK(31, 30)
+#define SB_P2_DIVIDER_SHIFT			30
+#define SB_P2_10				0 /* HDMI, DP, DAC */
+#define SB_P2_5				1 /* DAC */
+#define SB_P2_14				2 /* LVDS single */
+#define SB_P2_7				3 /* LVDS double */
+#define SB_P1_DIVIDER_MASK			PSB_MASK(15, 12)
+#define SB_P1_DIVIDER_SHIFT			12
+
+#define PSB_LANE0		0x120
+#define PSB_LANE1		0x220
+#define PSB_LANE2		0x2320
+#define PSB_LANE3		0x2420
+
+#define LANE_PLL_MASK		(0x7 << 20)
+#define LANE_PLL_ENABLE		(0x3 << 20)
+
+
 #endif

