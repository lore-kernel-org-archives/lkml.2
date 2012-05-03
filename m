Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2ECM3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:29:12 -0400
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:44357 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753243Ab2ECM3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:29:09 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 May 2012 08:29:09 EDT
Date: Thu, 3 May 2012 17:58:58 +0530
From: Rupjyoti Sarmah <rsarmah@amcc.com>
Message-Id: <201205031228.q43CSw6k024808@amcc.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v16 03/10]USB/ppc4xx: Add Synopsys DWC OTG Core Interface Layer (CIL)
Cc: rsarmah@apm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Core Interface Layer Common provides common functions for both host
controller and peripheral controller.  CIL manages the memory map
for the core. It also handles basic tasks like reading/writing the
registers and data FIFOs in the controller. CIL performs basic
services that are not specific to either the host or device modes
of operation. These services include management of the OTG Host
Negotiation Protocol (HNP) and Session Request Protocol (SRP).

Signed-off-by: Rupjyoti Sarmah <rsarmah@apm.com>
Signed-off-by: Tirumala R Marri <tmarri@apm.com>
Signed-off-by: Fushen Chen <fchen@apm.com>
Signed-off-by: Mark Miesfeld <mmiesfeld@apm.com>
---
 drivers/usb/dwc/cil.c      |  849 ++++++++++++++++++++++++++++++++
 drivers/usb/dwc/cil.h      | 1161 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/usb/dwc/cil_intr.c |  584 ++++++++++++++++++++++
 3 files changed, 2594 insertions(+), 0 deletions(-)
 create mode 100644 drivers/usb/dwc/cil.c
 create mode 100644 drivers/usb/dwc/cil.h
 create mode 100644 drivers/usb/dwc/cil_intr.c

diff --git a/drivers/usb/dwc/cil.c b/drivers/usb/dwc/cil.c
new file mode 100644
index 0000000..1df8852
--- /dev/null
+++ b/drivers/usb/dwc/cil.c
@@ -0,0 +1,849 @@
+/*
+ * DesignWare HS OTG controller driver
+ * Copyright (C) 2006 Synopsys, Inc.
+ * Portions Copyright (C) 2010 Applied Micro Circuits Corporation.
+ *
+ * This program is free software: you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License version 2 for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see http://www.gnu.org/licenses
+ * or write to the Free Software Foundation, Inc., 51 Franklin Street,
+ * Suite 500, Boston, MA 02110-1335 USA.
+ *
+ * Based on Synopsys driver version 2.60a
+ * Modified by Mark Miesfeld <mmiesfeld@apm.com>
+ * Modified by Stefan Roese <sr@denx.de>, DENX Software Engineering
+ * Modified by Rupjyoti Sarmah <rsarmah@apm.com>
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING BUT NOT LIMITED TO THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL SYNOPSYS, INC. BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#include <linux/delay.h>
+
+#include "cil.h"
+
+void dwc_otg_enable_global_interrupts(struct core_if *core_if)
+{
+	u32 ahbcfg = 0;
+
+	ahbcfg |= DWC_AHBCFG_GLBL_INT_MASK;
+	dwc_reg_modify(core_if->core_global_regs, DWC_GAHBCFG, 0,
+		     ahbcfg);
+}
+
+void dwc_otg_disable_global_interrupts(struct core_if *core_if)
+{
+	u32 ahbcfg = 0;
+
+	ahbcfg |= DWC_AHBCFG_GLBL_INT_MASK;
+	dwc_reg_modify(core_if->core_global_regs, DWC_GAHBCFG,
+		     ahbcfg, 0);
+}
+
+/**
+ * Tests if the current hardware is using a full speed phy.
+ */
+static inline int full_speed_phy(struct core_if *core_if)
+{
+	if ((DWC_HWCFG2_FS_PHY_TYPE_RD(core_if->hwcfg2) == 2 &&
+	     DWC_HWCFG2_FS_PHY_TYPE_RD(core_if->hwcfg2) == 1 &&
+	     core_if->core_params->ulpi_fs_ls) ||
+	    core_if->core_params->phy_type == DWC_PHY_TYPE_PARAM_FS)
+		return 1;
+	return 0;
+}
+
+/**
+ * Initializes the FSLSPClkSel field of the HCFG register depending on the PHY
+ * type.
+ */
+void init_fslspclksel(struct core_if *core_if)
+{
+	u32 val;
+	u32 hcfg;
+
+	if (full_speed_phy(core_if))
+		val = DWC_HCFG_48_MHZ;
+	else
+		/* High speed PHY running at full speed or high speed */
+		val = DWC_HCFG_30_60_MHZ;
+
+	hcfg = dwc_reg_read(core_if->host_if->host_global_regs, DWC_HCFG);
+	hcfg = DWC_HCFG_FSLSP_CLK_RW(hcfg, val);
+	dwc_reg_write(core_if->host_if->host_global_regs, DWC_HCFG, hcfg);
+}
+
+/**
+ * Initializes the DevSpd field of the DCFG register depending on the PHY type
+ * and the enumeration speed of the device.
+ */
+static void init_devspd(struct core_if *core_if)
+{
+	u32 val;
+	u32 dcfg;
+
+	if (full_speed_phy(core_if))
+		val = 0x3;
+	else if (core_if->core_params->speed == DWC_SPEED_PARAM_FULL)
+		/* High speed PHY running at full speed */
+		val = 0x1;
+	else
+		/* High speed PHY running at high speed */
+		val = 0x0;
+
+	dcfg = dwc_reg_read(core_if->dev_if->dev_global_regs, DWC_DCFG);
+	dcfg = DWC_DCFG_DEV_SPEED_WR(dcfg, val);
+	dwc_reg_write(core_if->dev_if->dev_global_regs, DWC_DCFG, dcfg);
+}
+
+/**
+ * Do core a soft reset of the core.  Be careful with this because it
+ * resets all the internal state machines of the core.
+ */
+static void dwc_otg_core_reset(struct core_if *core_if)
+{
+	ulong global_regs = core_if->core_global_regs;
+	u32 greset;
+	int count = 0;
+
+	/* Wait for AHB master IDLE state. */
+	do {
+		udelay(10);
+		greset = dwc_reg_read(global_regs, DWC_GRSTCTL);
+		if (++count > 100000) {
+			pr_warning("%s() HANG! AHB Idle GRSTCTL=%0x\n",
+				   __func__, greset);
+			return;
+		}
+	} while (!(greset & DWC_RSTCTL_AHB_IDLE));
+
+	/* Core Soft Reset */
+	count = 0;
+	greset |= DWC_RSTCTL_SFT_RST;
+	dwc_reg_write(global_regs, DWC_GRSTCTL, greset);
+
+	do {
+		greset = dwc_reg_read(global_regs, DWC_GRSTCTL);
+		if (++count > 10000) {
+			pr_warning("%s() HANG! Soft Reset "
+				   "GRSTCTL=%0x\n", __func__, greset);
+			break;
+		}
+		udelay(1);
+	} while (greset & DWC_RSTCTL_SFT_RST);
+
+	/* Wait for 3 PHY Clocks */
+	msleep(100);
+}
+
+/**
+ * This function initializes the commmon interrupts, used in both
+ * device and host modes.
+ */
+void dwc_otg_enable_common_interrupts(struct core_if *core_if)
+{
+	ulong global_regs = core_if->core_global_regs;
+	u32 intr_mask = 0;
+
+	/* Clear any pending OTG Interrupts */
+	dwc_reg_write(global_regs, DWC_GOTGINT, 0xFFFFFFFF);
+
+	/* Clear any pending interrupts */
+	dwc_reg_write(global_regs, DWC_GINTSTS, 0xFFFFFFFF);
+
+	/* Enable the interrupts in the GINTMSK. */
+	intr_mask = DWC_INTMSK_MODE_MISMTC|\
+		    DWC_INTMSK_OTG|\
+		    DWC_INTMSK_CON_ID_STS_CHG|\
+		    DWC_INTMSK_WKP|\
+		    DWC_INTMSK_SES_DISCON_DET|\
+		    DWC_INTMSK_USB_SUSP|\
+		    DWC_INTMSK_NEW_SES_DET;
+	if (!core_if->dma_enable)
+		intr_mask |= DWC_INTMSK_RXFIFO_NOT_EMPT;
+	dwc_reg_write(global_regs, DWC_GINTMSK, intr_mask);
+}
+
+/**
+ * This function initializes the DWC_otg controller registers and prepares the
+ * core for device mode or host mode operation.
+ */
+void dwc_otg_core_init(struct core_if *core_if)
+{
+	u32 i;
+	ulong global_reg = core_if->core_global_regs;
+	struct device_if *dev_if = core_if->dev_if;
+	u32 ahbcfg = 0;
+	u32 i2cctl = 0;
+	u32 gusbcfg;
+
+	/* Common Initialization */
+	gusbcfg = dwc_reg_read(global_reg, DWC_GUSBCFG);
+
+	/* Program the ULPI External VBUS bit if needed */
+	gusbcfg |= DWC_USBCFG_ULPI_EXT_VBUS_DRV;
+
+	/* Set external TS Dline pulsing */
+	if (core_if->core_params->ts_dline == 1)
+		gusbcfg |= DWC_USBCFG_TERM_SEL_DL_PULSE;
+	else
+		gusbcfg = gusbcfg & (~((u32) DWC_USBCFG_TERM_SEL_DL_PULSE));
+
+	dwc_reg_write(global_reg, DWC_GUSBCFG, gusbcfg);
+
+	/* Reset the Controller */
+	dwc_otg_core_reset(core_if);
+
+	for (i = 0; i < DWC_HWCFG4_NUM_DEV_PERIO_IN_EP_RD(core_if->hwcfg4);
+			i++) {
+		dev_if->perio_tx_fifo_size[i] =
+		    dwc_reg_read(global_reg, DWC_DPTX_FSIZ_DIPTXF(i)) >> 16;
+	}
+	for (i = 0; i < DWC_HWCFG4_NUM_IN_EPS_RD(core_if->hwcfg4); i++) {
+		dev_if->tx_fifo_size[i] =
+		    dwc_reg_read(global_reg, DWC_DPTX_FSIZ_DIPTXF(i)) >> 16;
+	}
+
+	core_if->total_fifo_size = DWC_HWCFG3_DFIFO_DEPTH_RD(core_if->hwcfg3);
+	core_if->rx_fifo_size = dwc_reg_read(global_reg, DWC_GRXFSIZ);
+	core_if->nperio_tx_fifo_size =
+	    dwc_reg_read(global_reg, DWC_GRXFSIZ) >> 16;
+	/*
+	 * This programming sequence needs to happen in FS mode before any
+	 * other programming occurs
+	 */
+	if (core_if->core_params->speed == DWC_SPEED_PARAM_FULL &&
+	    core_if->core_params->phy_type == DWC_PHY_TYPE_PARAM_FS) {
+		/*
+		 * core_init() is now called on every switch so only call the
+		 * following for the first time through.
+		 */
+		if (!core_if->phy_init_done) {
+			core_if->phy_init_done = 1;
+			gusbcfg = dwc_reg_read(global_reg, DWC_GUSBCFG);
+			gusbcfg |= DWC_USBCFG_ULPI_UTMI_SEL;
+			dwc_reg_write(global_reg, DWC_GUSBCFG, gusbcfg);
+
+			/* Reset after a PHY select */
+			dwc_otg_core_reset(core_if);
+		}
+
+		/*
+		 * Program DCFG.DevSpd or HCFG.FSLSPclkSel to 48Mhz in FS.
+		 * Also do this on HNP Dev/Host mode switches (done in dev_init
+		 * and host_init).
+		 */
+		if (dwc_otg_is_host_mode(core_if))
+			init_fslspclksel(core_if);
+		else
+			init_devspd(core_if);
+
+		if (core_if->core_params->i2c_enable) {
+			/* Program GUSBCFG.OtgUtmifsSel to I2C */
+			gusbcfg = dwc_reg_read(global_reg, DWC_GUSBCFG);
+			gusbcfg |= DWC_USBCFG_OTGUTMIFSSEL;
+			dwc_reg_write(global_reg, DWC_GUSBCFG, gusbcfg);
+
+			/* Program GI2CCTL.I2CEn */
+			i2cctl = dwc_reg_read(global_reg, DWC_GI2CCTL);
+			i2cctl |= DWC_I2CCTL_I2CDEVADDR(1);
+			i2cctl &= ~DWC_I2CCTL_I2CEN;
+			dwc_reg_write(global_reg, DWC_GI2CCTL, i2cctl);
+			i2cctl |= DWC_I2CCTL_I2CEN;
+			dwc_reg_write(global_reg, DWC_GI2CCTL, i2cctl);
+		}
+	} else if (!core_if->phy_init_done) {
+		gusbcfg = dwc_reg_read(global_reg, DWC_GUSBCFG);
+		core_if->phy_init_done = 1;
+		if (core_if->core_params->phy_type)
+			gusbcfg |= DWC_USBCFG_ULPI_UTMI_SEL;
+		else
+			gusbcfg &= ~((u32) DWC_USBCFG_ULPI_UTMI_SEL);
+
+		if (gusbcfg & DWC_USBCFG_ULPI_UTMI_SEL) {
+			/* ULPI interface */
+			gusbcfg |= DWC_USBCFG_PHYIF;
+			if (core_if->core_params->phy_ulpi_ddr)
+				gusbcfg |= DWC_USBCFG_DDRSEL;
+			else
+				gusbcfg &= ~((u32) DWC_USBCFG_DDRSEL);
+		} else {
+			/* UTMI+ interface */
+			if (core_if->core_params->phy_utmi_width == 16)
+				gusbcfg |= DWC_USBCFG_PHYIF;
+			else
+				gusbcfg &= ~((u32) DWC_USBCFG_PHYIF);
+		}
+		dwc_reg_write(global_reg, DWC_GUSBCFG, gusbcfg);
+
+		/* Reset after setting the PHY parameters */
+		dwc_otg_core_reset(core_if);
+	}
+
+	if (DWC_HWCFG2_HS_PHY_TYPE_RD(core_if->hwcfg2) == 2 &&
+	    DWC_HWCFG2_FS_PHY_TYPE_RD(core_if->hwcfg2) == 1 &&
+	    core_if->core_params->ulpi_fs_ls) {
+		gusbcfg = dwc_reg_read(global_reg, DWC_GUSBCFG);
+		gusbcfg |= DWC_USBCFG_ULPI_FSLS;
+		gusbcfg |= DWC_USBCFG_ULPI_CLK_SUS_M;
+		dwc_reg_write(global_reg, DWC_GUSBCFG, gusbcfg);
+	} else {
+		gusbcfg = dwc_reg_read(global_reg, DWC_GUSBCFG);
+		gusbcfg &= ~((u32) DWC_USBCFG_ULPI_FSLS);
+		gusbcfg &= ~((u32) DWC_USBCFG_ULPI_CLK_SUS_M);
+		dwc_reg_write(global_reg, DWC_GUSBCFG, gusbcfg);
+	}
+
+	/* Program the GAHBCFG Register. */
+	switch (DWC_HWCFG2_ARCH_RD(core_if->hwcfg2)) {
+	case DWC_SLAVE_ONLY_ARCH:
+		ahbcfg &= ~DWC_AHBCFG_NPFIFO_EMPTY;	/* HALF empty */
+		ahbcfg &= ~DWC_AHBCFG_FIFO_EMPTY;	/* HALF empty */
+		core_if->dma_enable = 0;
+		break;
+	case DWC_EXT_DMA_ARCH:
+		ahbcfg = (ahbcfg & ~DWC_AHBCFG_BURST_LEN(0xf)) |
+		    DWC_AHBCFG_BURST_LEN(core_if->core_params->dma_burst_size);
+		core_if->dma_enable = (core_if->core_params->dma_enable != 0);
+		break;
+	case DWC_INT_DMA_ARCH:
+		ahbcfg = (ahbcfg & ~DWC_AHBCFG_BURST_LEN(0xf)) |
+		    DWC_AHBCFG_BURST_LEN(DWC_GAHBCFG_INT_DMA_BURST_INCR);
+		core_if->dma_enable = (core_if->core_params->dma_enable != 0);
+		break;
+	}
+
+	if (core_if->dma_enable)
+		ahbcfg |= DWC_AHBCFG_DMA_ENA;
+	else
+		ahbcfg &= ~DWC_AHBCFG_DMA_ENA;
+	dwc_reg_write(global_reg, DWC_GAHBCFG, ahbcfg);
+	core_if->en_multiple_tx_fifo =
+	    DWC_HWCFG4_DED_FIFO_ENA_RD(core_if->hwcfg4);
+
+	/* Program the GUSBCFG register. */
+	gusbcfg = dwc_reg_read(global_reg, DWC_GUSBCFG);
+	switch (DWC_HWCFG2_OP_MODE_RD(core_if->hwcfg2)) {
+	case DWC_MODE_HNP_SRP_CAPABLE:
+		if (core_if->core_params->otg_cap ==
+		    DWC_OTG_CAP_PARAM_HNP_SRP_CAPABLE)
+			gusbcfg |= DWC_USBCFG_HNP_CAP;
+		else
+			gusbcfg &= ~((u32) DWC_USBCFG_HNP_CAP);
+		if (core_if->core_params->otg_cap !=
+		    DWC_OTG_CAP_PARAM_NO_HNP_SRP_CAPABLE)
+			gusbcfg |= DWC_USBCFG_SRP_CAP;
+		else
+			gusbcfg &= ~((u32) DWC_USBCFG_SRP_CAP);
+		break;
+	case DWC_MODE_SRP_ONLY_CAPABLE:
+		gusbcfg &= ~((u32) DWC_USBCFG_HNP_CAP);
+		if (core_if->core_params->otg_cap !=
+		    DWC_OTG_CAP_PARAM_NO_HNP_SRP_CAPABLE)
+			gusbcfg |= DWC_USBCFG_SRP_CAP;
+		else
+			gusbcfg &= ~((u32) DWC_USBCFG_SRP_CAP);
+		break;
+	case DWC_MODE_NO_HNP_SRP_CAPABLE:
+		gusbcfg &= ~((u32) DWC_USBCFG_HNP_CAP);
+		gusbcfg &= ~((u32) DWC_USBCFG_SRP_CAP);
+		break;
+	case DWC_MODE_SRP_CAPABLE_DEVICE:
+		gusbcfg &= ~((u32) DWC_USBCFG_HNP_CAP);
+		if (core_if->core_params->otg_cap !=
+		    DWC_OTG_CAP_PARAM_NO_HNP_SRP_CAPABLE)
+			gusbcfg |= DWC_USBCFG_SRP_CAP;
+		else
+			gusbcfg &= ~((u32) DWC_USBCFG_SRP_CAP);
+		break;
+	case DWC_MODE_NO_SRP_CAPABLE_DEVICE:
+		gusbcfg &= ~((u32) DWC_USBCFG_HNP_CAP);
+		gusbcfg &= ~((u32) DWC_USBCFG_SRP_CAP);
+		break;
+	case DWC_MODE_SRP_CAPABLE_HOST:
+		gusbcfg &= ~((u32) DWC_USBCFG_HNP_CAP);
+		if (core_if->core_params->otg_cap !=
+		    DWC_OTG_CAP_PARAM_NO_HNP_SRP_CAPABLE)
+			gusbcfg |= DWC_USBCFG_SRP_CAP;
+		else
+			gusbcfg &= ~((u32) DWC_USBCFG_SRP_CAP);
+		break;
+	case DWC_MODE_NO_SRP_CAPABLE_HOST:
+		gusbcfg &= ~((u32) DWC_USBCFG_HNP_CAP);
+		gusbcfg &= ~((u32) DWC_USBCFG_SRP_CAP);
+		break;
+	}
+	dwc_reg_write(global_reg, DWC_GUSBCFG, gusbcfg);
+
+	/* Enable common interrupts */
+	dwc_otg_enable_common_interrupts(core_if);
+
+	/*
+	 * Do device or host intialization based on mode during PCD
+	 * and HCD initialization
+	 */
+	if (dwc_otg_is_host_mode(core_if)) {
+		core_if->xceiv->state = OTG_STATE_A_HOST;
+	} else {
+		core_if->xceiv->state = OTG_STATE_B_PERIPHERAL;
+		if (dwc_has_feature(core_if, DWC_DEVICE_ONLY))
+			dwc_otg_core_dev_init(core_if);
+	}
+}
+
+/**
+ * This function enables the Device mode interrupts.
+ *
+ * Note that the bits in the Device IN endpoint mask register are laid out
+ * exactly the same as the Device IN endpoint interrupt register.
+ */
+static void dwc_otg_enable_device_interrupts(struct core_if *core_if)
+{
+	u32 intr_mask = 0;
+	u32 msk = 0;
+	ulong global_regs = core_if->core_global_regs;
+
+	/* Disable all interrupts. */
+	dwc_reg_write(global_regs, DWC_GINTMSK, 0);
+
+	/* Clear any pending interrupts */
+	dwc_reg_write(global_regs, DWC_GINTSTS, 0xFFFFFFFF);
+
+	/* Enable the common interrupts */
+	dwc_otg_enable_common_interrupts(core_if);
+
+	/* Enable interrupts */
+	intr_mask |= DWC_INTMSK_USB_RST|\
+		     DWC_INTMSK_ENUM_DONE|\
+		     DWC_INTMSK_IN_ENDP|\
+		     DWC_INTMSK_OUT_ENDP|\
+		     DWC_INTMSK_EARLY_SUSP;
+	if (!core_if->en_multiple_tx_fifo)
+		intr_mask |= DWC_INTMSK_ENDP_MIS_MTCH;
+
+	/* Periodic EP */
+	intr_mask |= DWC_INTMSK_ISYNC_OUTPKT_DRP|\
+		     DWC_INTMSK_END_OF_PFRM|\
+		     DWC_INTMSK_INCMP_IN_ATX|\
+		     DWC_INTMSK_INCMP_OUT_PTX;
+
+	dwc_reg_modify(global_regs, DWC_GINTMSK, intr_mask, intr_mask);
+
+	msk = DWC_DIEPMSK_TXFIFO_UNDERN_RW(msk, 1);
+	dwc_reg_modify(core_if->dev_if->dev_global_regs, DWC_DIEPMSK,
+		     msk, msk);
+}
+
+/**
+ *  Configures the device data fifo sizes when dynamic sizing is enabled.
+ */
+static void config_dev_dynamic_fifos(struct core_if *core_if)
+{
+	u32 i;
+	ulong regs = core_if->core_global_regs;
+	struct core_params *params = core_if->core_params;
+	u32 txsize = 0;
+	u32 nptxsize = 0;
+	u32 ptxsize = 0;
+
+	/* Rx FIFO */
+	dwc_reg_write(regs, DWC_GRXFSIZ, params->dev_rx_fifo_size);
+
+	/* Set Periodic and Non-periodic Tx FIFO Mask bits to all 0 */
+	core_if->p_tx_msk = 0;
+	core_if->tx_msk = 0;
+
+	if (core_if->en_multiple_tx_fifo == 0) {
+		/* Non-periodic Tx FIFO */
+		nptxsize = DWC_TX_FIFO_DEPTH_WR(nptxsize,
+						params->
+						dev_nperio_tx_fifo_size);
+		nptxsize =
+		    DWC_TX_FIFO_START_ADDR_WR(nptxsize,
+					      params->dev_rx_fifo_size);
+		dwc_reg_write(regs, DWC_GNPTXFSIZ, nptxsize);
+
+		ptxsize = DWC_TX_FIFO_START_ADDR_WR(ptxsize,
+						    (DWC_TX_FIFO_START_ADDR_RD
+						     (nptxsize) +
+						     DWC_TX_FIFO_DEPTH_RD
+						     (nptxsize)));
+		for (i = 0;
+		     i < DWC_HWCFG4_NUM_DEV_PERIO_IN_EP_RD(core_if->hwcfg4);
+		     i++) {
+			ptxsize =
+			    DWC_TX_FIFO_DEPTH_WR(ptxsize,
+						 params->
+						 dev_perio_tx_fifo_size[i]);
+			dwc_reg_write(regs, DWC_DPTX_FSIZ_DIPTXF(i), ptxsize);
+			ptxsize = DWC_TX_FIFO_START_ADDR_WR(ptxsize,
+						   (DWC_TX_FIFO_START_ADDR_RD
+						    (ptxsize) +
+						    DWC_TX_FIFO_DEPTH_RD
+						    (ptxsize)));
+		}
+	} else {
+		nptxsize = DWC_TX_FIFO_DEPTH_WR(nptxsize,
+						params->
+						dev_nperio_tx_fifo_size);
+		nptxsize =
+		    DWC_TX_FIFO_START_ADDR_WR(nptxsize,
+					      params->dev_rx_fifo_size);
+		dwc_reg_write(regs, DWC_GNPTXFSIZ, nptxsize);
+
+		txsize = DWC_TX_FIFO_START_ADDR_WR(txsize,
+						   (DWC_TX_FIFO_START_ADDR_RD
+						    (nptxsize) +
+						    DWC_TX_FIFO_DEPTH_RD
+						    (nptxsize)));
+		for (i = 1;
+		     i < DWC_HWCFG4_NUM_DEV_PERIO_IN_EP_RD(core_if->hwcfg4);
+		     i++) {
+			txsize =
+			    DWC_TX_FIFO_DEPTH_WR(txsize,
+						 params->dev_tx_fifo_size[i]);
+			dwc_reg_write(regs, DWC_DPTX_FSIZ_DIPTXF(i - 1),
+					txsize);
+			txsize = DWC_TX_FIFO_START_ADDR_WR(txsize,
+						   (DWC_TX_FIFO_START_ADDR_RD
+						    (txsize) +
+						    DWC_TX_FIFO_DEPTH_RD
+						    (txsize)));
+		}
+	}
+}
+
+/**
+ * This function initializes the DWC_otg controller registers for
+ * device mode.
+ */
+void dwc_otg_core_dev_init(struct core_if *c_if)
+{
+	u32 i;
+	struct device_if *d_if = c_if->dev_if;
+	struct core_params *params = c_if->core_params;
+	u32 dcfg;
+	u32 resetctl = 0;
+	u32 dthrctl = 0;
+
+	/* Restart the Phy Clock */
+	dwc_reg_write(c_if->pcgcctl, 0, 0);
+
+	/* Device configuration register */
+	init_devspd(c_if);
+	dcfg = dwc_reg_read(d_if->dev_global_regs, DWC_DCFG);
+	dcfg = DWC_DCFG_P_FRM_INTRVL_WR(dcfg, DWC_DCFG_FRAME_INTERVAL_80);
+	dwc_reg_write(d_if->dev_global_regs, DWC_DCFG, dcfg);
+
+	/* If needed configure data FIFO sizes */
+	if (DWC_HWCFG2_DYN_FIFO_RD(c_if->hwcfg2) && params->enable_dynamic_fifo)
+		config_dev_dynamic_fifos(c_if);
+
+	/* Flush the FIFOs */
+	dwc_otg_flush_tx_fifo(c_if, DWC_GRSTCTL_TXFNUM_ALL);
+	dwc_otg_flush_rx_fifo(c_if);
+
+	/* Flush the Learning Queue. */
+	resetctl |= DWC_RSTCTL_TKN_QUE_FLUSH;
+	dwc_reg_write(c_if->core_global_regs, DWC_GRSTCTL, resetctl);
+
+	/* Clear all pending Device Interrupts */
+	dwc_reg_write(d_if->dev_global_regs, DWC_DIEPMSK, 0);
+	dwc_reg_write(d_if->dev_global_regs, DWC_DOEPMSK, 0);
+	dwc_reg_write(d_if->dev_global_regs, DWC_DAINT, 0xFFFFFFFF);
+	dwc_reg_write(d_if->dev_global_regs, DWC_DAINTMSK, 0);
+
+	for (i = 0; i <= d_if->num_in_eps; i++) {
+		u32 depctl = 0;
+
+		depctl = dwc_reg_read(d_if->in_ep_regs[i], DWC_DIEPCTL);
+		if (DWC_DEPCTL_EPENA_RD(depctl)) {
+			depctl = 0;
+			depctl = DWC_DEPCTL_EPDIS_RW(depctl, 1);
+			depctl = DWC_DEPCTL_SET_NAK_RW(depctl, 1);
+		} else {
+			depctl = 0;
+		}
+
+		dwc_reg_write(d_if->in_ep_regs[i], DWC_DIEPCTL, depctl);
+		dwc_reg_write(d_if->in_ep_regs[i], DWC_DIEPTSIZ, 0);
+		dwc_reg_write(d_if->in_ep_regs[i], DWC_DIEPDMA, 0);
+		dwc_reg_write(d_if->in_ep_regs[i], DWC_DIEPINT, 0xFF);
+	}
+
+	for (i = 0; i <= d_if->num_out_eps; i++) {
+		u32 depctl = 0;
+		depctl = dwc_reg_read(d_if->out_ep_regs[i], DWC_DOEPCTL);
+		if (DWC_DEPCTL_EPENA_RD(depctl)) {
+			depctl = 0;
+			depctl = DWC_DEPCTL_EPDIS_RW(depctl, 1);
+			depctl = DWC_DEPCTL_SET_NAK_RW(depctl, 1);
+		} else {
+			depctl = 0;
+		}
+		dwc_reg_write(d_if->out_ep_regs[i], DWC_DOEPCTL, depctl);
+		dwc_reg_write(d_if->out_ep_regs[i], DWC_DOEPTSIZ, 0);
+		dwc_reg_write(d_if->out_ep_regs[i], DWC_DOEPDMA, 0);
+		dwc_reg_write(d_if->out_ep_regs[i], DWC_DOEPINT, 0xFF);
+	}
+
+	if (c_if->en_multiple_tx_fifo && c_if->dma_enable) {
+		d_if->non_iso_tx_thr_en = c_if->core_params->thr_ctl & 0x1;
+		d_if->iso_tx_thr_en = (c_if->core_params->thr_ctl >> 1) & 0x1;
+		d_if->rx_thr_en = (c_if->core_params->thr_ctl >> 2) & 0x1;
+		d_if->rx_thr_length = c_if->core_params->rx_thr_length;
+		d_if->tx_thr_length = c_if->core_params->tx_thr_length;
+
+		dthrctl = 0;
+		dthrctl = DWC_DTHCTRL_NON_ISO_THR_ENA_RW\
+		    (dthrctl, d_if->non_iso_tx_thr_en);
+		dthrctl = DWC_DTHCTRL_ISO_THR_EN_RW\
+		    (dthrctl, d_if->iso_tx_thr_en);
+		dthrctl = DWC_DTHCTRL_TX_THR_LEN_RW\
+		    (dthrctl, d_if->tx_thr_length);
+		dthrctl = DWC_DTHCTRL_RX_THR_EN_RW(dthrctl, d_if->rx_thr_en);
+		dthrctl = DWC_DTHCTRL_RX_THR_LEN_RW\
+		    (dthrctl, d_if->rx_thr_length);
+		dwc_reg_write(d_if->dev_global_regs,
+			    DWC_DTKNQR3_DTHRCTL, dthrctl);
+
+	}
+
+	dwc_otg_enable_device_interrupts(c_if);
+}
+
+/**
+ * This function reads a packet from the Rx FIFO into the destination buffer.
+ * To read SETUP data use dwc_otg_read_setup_packet.
+ */
+
+void dwc_otg_read_packet(struct core_if *core_if, u8 * dest, u16 _bytes)
+{
+	u32 i;
+	int word_count = (_bytes + 3) / 4;
+	u32 fifo = core_if->data_fifo[0];
+	u32 *data_buff = (u32 *) dest;
+
+	/*
+	 * This requires reading data from the FIFO into a u32 temp buffer,
+	 * then moving it into the data buffer.
+	 */
+	for (i = 0; i < word_count; i++, data_buff++)
+		*data_buff = dwc_read_fifo32(fifo);
+}
+
+/**
+ * Flush a Tx FIFO.
+ */
+void dwc_otg_flush_tx_fifo(struct core_if *core_if, const int num)
+{
+	ulong global_regs = core_if->core_global_regs;
+	u32 greset = 0;
+	int count = 0;
+
+	greset |= DWC_RSTCTL_TX_FIFO_FLUSH;
+	greset = DWC_RSTCTL_TX_FIFO_NUM(greset, num);
+	dwc_reg_write(global_regs, DWC_GRSTCTL, greset);
+
+	do {
+		greset = dwc_reg_read(global_regs, DWC_GRSTCTL);
+		if (++count > 10000) {
+			pr_warning("%s() HANG! GRSTCTL=%0x "
+				   "GNPTXSTS=0x%08x\n", __func__, greset,
+				   dwc_reg_read(global_regs, DWC_GNPTXSTS));
+			break;
+		}
+		udelay(1);
+	} while (greset & DWC_RSTCTL_TX_FIFO_FLUSH);
+
+	/* Wait for 3 PHY Clocks */
+	udelay(1);
+}
+
+/**
+ * Flush Rx FIFO.
+ */
+void dwc_otg_flush_rx_fifo(struct core_if *core_if)
+{
+	ulong global_regs = core_if->core_global_regs;
+	u32 greset = 0;
+	int count = 0;
+
+	greset |= DWC_RSTCTL_RX_FIFO_FLUSH;
+	dwc_reg_write(global_regs, DWC_GRSTCTL, greset);
+
+	do {
+		greset = dwc_reg_read(global_regs, DWC_GRSTCTL);
+		if (++count > 10000) {
+			pr_warning("%s() HANG! GRSTCTL=%0x\n",
+				   __func__, greset);
+			break;
+		}
+		udelay(1);
+	} while (greset & DWC_RSTCTL_RX_FIFO_FLUSH);
+
+	/* Wait for 3 PHY Clocks */
+	udelay(1);
+}
+
+/**
+ * Register HCD callbacks.
+ * The callbacks are used to start and stop the HCD for interrupt processing.
+ */
+void __devinit dwc_otg_cil_register_hcd_callbacks(struct core_if *c_if,
+						  struct cil_callbacks *cb,
+						  void *p)
+{
+	c_if->hcd_cb = cb;
+	cb->p = p;
+}
+
+/**
+ * Register PCD callbacks.
+ * The callbacks are used to start and stop the PCD for interrupt processing.
+ */
+void __devinit dwc_otg_cil_register_pcd_callbacks(struct core_if *c_if,
+						  struct cil_callbacks *cb,
+						  void *p)
+{
+	c_if->pcd_cb = cb;
+	cb->p = p;
+}
+
+/**
+ * This function is called to initialize the DWC_otg CSR data structures.
+ *
+ * The register addresses in the device and host structures are initialized from
+ * the base address supplied by the caller. The calling function must make the
+ * OS calls to get the base address of the DWC_otg controller registers.
+ *
+ * The params argument holds the parameters that specify how the core should be
+ * configured.
+ */
+struct core_if __devinit *dwc_otg_cil_init(const __iomem u32 * base,
+					   struct core_params *params)
+{
+	struct core_if *core_if;
+	struct device_if *dev_if;
+	struct dwc_host_if *host_if;
+	u8 *reg_base = (__force u8 *)base;
+	u32 offset;
+	u32 i;
+
+	core_if = kzalloc(sizeof(*core_if), GFP_KERNEL);
+	if (!core_if)
+		goto exit;
+
+	core_if->core_params = params;
+	core_if->core_global_regs = (ulong)reg_base;
+
+	/* Allocate the Device Mode structures. */
+	dev_if = kmalloc(sizeof(*dev_if), GFP_KERNEL);
+	if (!dev_if) {
+		kfree(core_if);
+		goto exit;
+	}
+
+	dev_if->dev_global_regs = (ulong)(reg_base + DWC_DEV_GLOBAL_REG_OFFSET);
+
+	for (i = 0; i < MAX_EPS_CHANNELS; i++) {
+		offset = i * DWC_EP_REG_OFFSET;
+
+		dev_if->in_ep_regs[i] = (ulong)(reg_base +
+					       DWC_DEV_IN_EP_REG_OFFSET +
+					       offset);
+
+		dev_if->out_ep_regs[i] = (ulong)(reg_base +
+						DWC_DEV_OUT_EP_REG_OFFSET +
+						offset);
+	}
+
+	dev_if->speed = 0;	/* unknown */
+	core_if->dev_if = dev_if;
+
+	/* Allocate the Host Mode structures. */
+	host_if = kmalloc(sizeof(*host_if), GFP_KERNEL);
+	if (!host_if) {
+		kfree(dev_if);
+		kfree(core_if);
+		goto exit;
+	}
+
+	host_if->host_global_regs = (ulong)(reg_base +
+					   DWC_OTG_HOST_GLOBAL_REG_OFFSET);
+
+	host_if->hprt0 = (ulong)(reg_base + DWC_OTG_HOST_PORT_REGS_OFFSET);
+
+	for (i = 0; i < MAX_EPS_CHANNELS; i++) {
+		offset = i * DWC_OTG_CHAN_REGS_OFFSET;
+
+		host_if->hc_regs[i] = (ulong)(reg_base +
+					     DWC_OTG_HOST_CHAN_REGS_OFFSET +
+					     offset);
+	}
+
+	host_if->num_host_channels = MAX_EPS_CHANNELS;
+	core_if->host_if = host_if;
+	for (i = 0; i < MAX_EPS_CHANNELS; i++) {
+		core_if->data_fifo[i] =
+		    (ulong)(reg_base + DWC_OTG_DATA_FIFO_OFFSET +
+			     (i * DWC_OTG_DATA_FIFO_SIZE));
+	}
+	core_if->pcgcctl = (ulong)(reg_base + DWC_OTG_PCGCCTL_OFFSET);
+
+	/*
+	 * Store the contents of the hardware configuration registers here for
+	 * easy access later.
+	 */
+	core_if->hwcfg1 =
+	    dwc_reg_read(core_if->core_global_regs, DWC_GHWCFG1);
+	core_if->hwcfg2 =
+	    dwc_reg_read(core_if->core_global_regs, DWC_GHWCFG2);
+	core_if->hwcfg3 =
+	    dwc_reg_read(core_if->core_global_regs, DWC_GHWCFG3);
+	core_if->hwcfg4 =
+	    dwc_reg_read(core_if->core_global_regs, DWC_GHWCFG4);
+
+	/* Set the SRP sucess bit for FS-I2c */
+	core_if->srp_success = 0;
+	core_if->srp_timer_started = 0;
+	return core_if;
+exit:
+	return core_if;
+
+
+}
+
+/**
+ * This function frees the structures allocated by dwc_otg_cil_init().
+ */
+
+void dwc_otg_cil_remove(struct core_if *core_if)
+{
+	/* Disable all interrupts */
+	dwc_reg_modify(core_if->core_global_regs, DWC_GAHBCFG, 1, 0);
+	dwc_reg_write(core_if->core_global_regs, DWC_GINTMSK, 0);
+
+	if (core_if) {
+		kfree(core_if->dev_if);
+		kfree(core_if->host_if);
+	}
+	kfree(core_if);
+}
+
diff --git a/drivers/usb/dwc/cil.h b/drivers/usb/dwc/cil.h
new file mode 100644
index 0000000..ff01eac
--- /dev/null
+++ b/drivers/usb/dwc/cil.h
@@ -0,0 +1,1161 @@
+/*
+ * DesignWare HS OTG controller driver
+ * Copyright (C) 2006 Synopsys, Inc.
+ * Portions Copyright (C) 2010 Applied Micro Circuits Corporation.
+ *
+ * This program is free software: you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License version 2 for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see http://www.gnu.org/licenses
+ * or write to the Free Software Foundation, Inc., 51 Franklin Street,
+ * Suite 500, Boston, MA 02110-1335 USA.
+ *
+ * Based on Synopsys driver version 2.60a
+ * Modified by Mark Miesfeld <mmiesfeld@apm.com>
+ * Modified by Stefan Roese <sr@denx.de>, DENX Software Engineering
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING BUT NOT LIMITED TO THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL SYNOPSYS, INC. BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#if !defined(__DWC_CIL_H__)
+#define __DWC_CIL_H__
+#include <linux/io.h>
+#include <linux/usb/ch9.h>
+#include <linux/usb/gadget.h>
+#include <linux/interrupt.h>
+#include <linux/dmapool.h>
+#include <linux/spinlock.h>
+#include <linux/usb/otg.h>
+
+#include "regs.h"
+
+#ifdef CONFIG_DWC_DEBUG
+#define DEBUG
+#endif
+
+/**
+ * Reads the content of a register.
+ */
+static inline u32 dwc_reg_read(ulong reg , u32 offset)
+{
+
+#ifdef CONFIG_DWC_OTG_REG_LE
+	return in_le32((void __iomem *)(reg + offset));
+#else
+	return in_be32((void __iomem *)(reg + offset));
+#endif
+}
+
+static inline void dwc_reg_write(ulong reg, u32 offset, const u32 value)
+{
+#ifdef CONFIG_DWC_OTG_REG_LE
+	out_le32((void __iomem *)(reg + offset), value);
+#else
+	out_be32((void __iomem *)(reg + offset), value);
+#endif
+};
+/**
+ * This function modifies bit values in a register.  Using the
+ * algorithm: (reg_contents & ~clear_mask) | set_mask.
+ */
+static inline void dwc_reg_modify(ulong reg, u32 offset, const u32 _clear_mask,
+		const u32 _set_mask)
+{
+#ifdef CONFIG_DWC_OTG_REG_LE
+	out_le32((void __iomem *)(reg + offset),
+			(in_le32((void __iomem *)(reg + offset))
+			& ~_clear_mask) | _set_mask);
+#else
+	out_be32((void __iomem *)(reg + offset),
+			(in_be32(((void __iomem *))(reg + offset))
+			& ~_clear_mask) | _set_mask);
+#endif
+};
+
+static inline void dwc_write_fifo32(ulong reg, const u32 _value)
+{
+#ifdef CONFIG_DWC_OTG_FIFO_LE
+	out_le32((void __iomem *)reg, _value);
+#else
+	out_be32((void __iomem *)reg, _value);
+#endif
+};
+
+static inline u32 dwc_read_fifo32(ulong _reg)
+{
+#ifdef CONFIG_DWC_OTG_FIFO_LE
+	return in_le32((void __iomem *) _reg);
+#else
+	return in_be32((void __iomem *) _reg);
+#endif
+};
+
+/*
+ * Debugging support vanishes in non-debug builds.
+ */
+/* Display CIL Debug messages */
+#define dwc_dbg_cil		(0x2)
+
+/* Display CIL Verbose debug messages */
+#define dwc_dbg_cilv		(0x20)
+
+/* Display PCD (Device) debug messages */
+#define dwc_dbg_pcd		(0x4)
+
+/* Display PCD (Device) Verbose debug  messages */
+#define dwc_dbg_pcdv		(0x40)
+
+/* Display Host debug messages */
+#define dwc_dbg_hcd		(0x8)
+
+/* Display Verbose Host debug messages */
+#define dwc_dbg_hcdv		(0x80)
+
+/* Display enqueued URBs in host mode. */
+#define dwc_dbg_hcd_urb		(0x800)
+
+/* Display "special purpose" debug messages */
+#define dwc_dbg_sp		(0x400)
+
+/* Display all debug messages */
+#define dwc_dbg_any		(0xFF)
+
+/* All debug messages off */
+#define dwc_dbg_off		0
+
+/* Prefix string for DWC_DEBUG print macros. */
+#define usb_dwc "dwc_otg: "
+
+/*
+ * This file contains the interface to the Core Interface Layer.
+ */
+
+/*
+ * Added-sr: 2007-07-26
+ *
+ * Since the 405EZ (Ultra) only support 2047 bytes as
+ * max transfer size, we have to split up bigger transfers
+ * into multiple transfers of 1024 bytes sized messages.
+ * I happens often, that transfers of 4096 bytes are
+ * required (zero-gadget, file_storage-gadget).
+ *
+ * MAX_XFER_LEN is set to 1024 right now, but could be 2047,
+ * since the xfer-size field in the 405EZ USB device controller
+ * implementation has 11 bits. Using 1024 seems to work for now.
+ */
+#define MAX_XFER_LEN	1024
+
+/*
+ * The dwc_ep structure represents the state of a single endpoint when acting in
+ * device mode. It contains the data items needed for an endpoint to be
+ * activated and transfer packets.
+ */
+struct dwc_ep {
+	/* EP number used for register address lookup */
+	u8 num;
+	/* EP direction 0 = OUT */
+	unsigned is_in:1;
+	/* EP active. */
+	unsigned active:1;
+
+	/*
+	 * Periodic Tx FIFO # for IN EPs For INTR EP set to 0 to use
+	 * non-periodic Tx FIFO If dedicated Tx FIFOs are enabled for all
+	 * IN Eps - Tx FIFO # FOR IN EPs
+	 */
+	unsigned tx_fifo_num:4;
+	/* EP type: 0 - Control, 1 - ISOC,       2 - BULK,      3 - INTR */
+	unsigned type:2;
+#define DWC_OTG_EP_TYPE_CONTROL		0
+#define DWC_OTG_EP_TYPE_ISOC		1
+#define DWC_OTG_EP_TYPE_BULK		2
+#define DWC_OTG_EP_TYPE_INTR		3
+
+	/* DATA start PID for INTR and BULK EP */
+	unsigned data_pid_start:1;
+	/* Frame (even/odd) for ISOC EP */
+	unsigned even_odd_frame:1;
+	/* Max Packet bytes */
+	unsigned maxpacket:11;
+
+	ulong dma_addr;
+
+	/*
+	 * Pointer to the beginning of the transfer buffer -- do not modify
+	 * during transfer.
+	 */
+	u8 *start_xfer_buff;
+	/* pointer to the transfer buffer */
+	u8 *xfer_buff;
+	/* Number of bytes to transfer */
+	unsigned xfer_len:19;
+	/* Number of bytes transferred. */
+	unsigned xfer_count:19;
+	/* Sent ZLP */
+	unsigned sent_zlp:1;
+	/* Total len for control transfer */
+	unsigned total_len:19;
+
+	/* stall clear flag */
+	unsigned stall_clear_flag:1;
+
+	/*
+	 * Added-sr: 2007-07-26
+	 *
+	 * Since the 405EZ (Ultra) only support 2047 bytes as
+	 * max transfer size, we have to split up bigger transfers
+	 * into multiple transfers of 1024 bytes sized messages.
+	 * I happens often, that transfers of 4096 bytes are
+	 * required (zero-gadget, file_storage-gadget).
+	 *
+	 * "bytes_pending" will hold the amount of bytes that are
+	 * still pending to be send in further messages to complete
+	 * the bigger transfer.
+	 */
+	u32 bytes_pending;
+};
+
+/*
+ * States of EP0.
+ */
+enum ep0_state {
+	EP0_DISCONNECT = 0,	/* no host */
+	EP0_IDLE = 1,
+	EP0_IN_DATA_PHASE = 2,
+	EP0_OUT_DATA_PHASE = 3,
+	EP0_STATUS = 4,
+	EP0_STALL = 5,
+};
+
+/* Fordward declaration.*/
+struct dwc_pcd;
+
+/*
+ * This structure describes an EP, there is an array of EPs in the PCD
+ * structure.
+ */
+struct pcd_ep {
+	/* USB EP data */
+	struct usb_ep ep;
+	/* USB EP Descriptor */
+	const struct usb_endpoint_descriptor *desc;
+
+	/* queue of dwc_otg_pcd_requests. */
+	struct list_head queue;
+	unsigned stopped:1;
+	unsigned disabling:1;
+	unsigned dma:1;
+	unsigned queue_sof:1;
+	unsigned wedged:1;
+
+	/* DWC_otg ep data. */
+	struct dwc_ep dwc_ep;
+
+	/* Pointer to PCD */
+	struct dwc_pcd *pcd;
+};
+
+/*
+ * DWC_otg PCD Structure.
+ * This structure encapsulates the data for the dwc_otg PCD.
+ */
+struct dwc_pcd {
+	/* USB gadget */
+	struct usb_gadget gadget;
+	/* USB gadget driver pointer */
+	struct usb_gadget_driver *driver;
+	/* The DWC otg device pointer. */
+	struct dwc_otg_device *otg_dev;
+
+	/* State of EP0 */
+	enum ep0_state ep0state;
+	/* EP0 Request is pending */
+	unsigned ep0_pending:1;
+	/* Indicates when SET CONFIGURATION Request is in process */
+	unsigned request_config:1;
+	/* The state of the Remote Wakeup Enable. */
+	unsigned remote_wakeup_enable:1;
+	/* The state of the B-Device HNP Enable. */
+	unsigned b_hnp_enable:1;
+	/* The state of A-Device HNP Support. */
+	unsigned a_hnp_support:1;
+	/* The state of the A-Device Alt HNP support. */
+	unsigned a_alt_hnp_support:1;
+	/* Count of pending Requests */
+	unsigned request_pending;
+
+	/*
+	 * SETUP packet for EP0.  This structure is allocated as a DMA buffer on
+	 * PCD initialization with enough space for up to 3 setup packets.
+	 */
+	union {
+		struct usb_ctrlrequest req;
+		u32 d32[2];
+	} *setup_pkt;
+
+	struct dma_pool *dwc_pool;
+	dma_addr_t setup_pkt_dma_handle;
+
+	/* 2-byte dma buffer used to return status from GET_STATUS */
+	u16 *status_buf;
+	dma_addr_t status_buf_dma_handle;
+
+	/* Array of EPs. */
+	struct pcd_ep ep0;
+	/* Array of IN EPs. */
+	struct pcd_ep in_ep[MAX_EPS_CHANNELS - 1];
+	/* Array of OUT EPs. */
+	struct pcd_ep out_ep[MAX_EPS_CHANNELS - 1];
+	spinlock_t lock;
+	/*
+	 *  Timer for SRP.  If it expires before SRP is successful clear the
+	 *  SRP.
+	 */
+	struct timer_list srp_timer;
+
+	/*
+	 * Tasklet to defer starting of TEST mode transmissions until Status
+	 * Phase has been completed.
+	 */
+	struct tasklet_struct test_mode_tasklet;
+
+	/*  Tasklet to delay starting of xfer in DMA mode */
+	struct tasklet_struct *start_xfer_tasklet;
+
+	/* The test mode to enter when the tasklet is executed. */
+	unsigned test_mode;
+};
+
+#define PRT_CONN_STS_CHNG(x) (x >> 31) & 0x1
+/*
+ * This structure holds the state of the HCD, including the non-periodic and
+ * periodic schedules.
+ */
+struct dwc_hcd {
+	spinlock_t lock;
+
+	/* DWC OTG Core Interface Layer */
+	struct core_if *core_if;
+
+	/*
+	 * Inactive items in the non-periodic schedule. This is a list of
+	 * Queue Heads. Transfers associated with these Queue Heads are not
+	 * currently assigned to a host channel.
+	 */
+	struct list_head non_periodic_sched_inactive;
+
+	/*
+	 * Deferred items in the non-periodic schedule. This is a list of
+	 * Queue Heads. Transfers associated with these Queue Heads are not
+	 * currently assigned to a host channel.
+	 * When we get an NAK, the QH goes here.
+	 */
+	struct list_head non_periodic_sched_deferred;
+
+	/*
+	 * Active items in the non-periodic schedule. This is a list of
+	 * Queue Heads. Transfers associated with these Queue Heads are
+	 * currently assigned to a host channel.
+	 */
+	struct list_head non_periodic_sched_active;
+
+	/*
+	 * Pointer to the next Queue Head to process in the active
+	 * non-periodic schedule.
+	 */
+	struct list_head *non_periodic_qh_ptr;
+
+	/*
+	 * Inactive items in the periodic schedule. This is a list of QHs for
+	 * periodic transfers that are _not_ scheduled for the next frame.
+	 * Each QH in the list has an interval counter that determines when it
+	 * needs to be scheduled for execution. This scheduling mechanism
+	 * allows only a simple calculation for periodic bandwidth used (i.e.
+	 * must assume that all periodic transfers may need to execute in the
+	 * same frame). However, it greatly simplifies scheduling and should
+	 * be sufficient for the vast majority of OTG hosts, which need to
+	 * connect to a small number of peripherals at one time.
+	 *
+	 * Items move from this list to periodic_sched_ready when the QH
+	 * interval counter is 0 at SOF.
+	 */
+	struct list_head periodic_sched_inactive;
+
+	/*
+	 * List of periodic QHs that are ready for execution in the next
+	 * frame, but have not yet been assigned to host channels.
+	 *
+	 * Items move from this list to periodic_sched_assigned as host
+	 * channels become available during the current frame.
+	 */
+	struct list_head periodic_sched_ready;
+
+	/*
+	 * List of periodic QHs to be executed in the next frame that are
+	 * assigned to host channels.
+	 *
+	 * Items move from this list to periodic_sched_queued as the
+	 * transactions for the QH are queued to the DWC_otg controller.
+	 */
+	struct list_head periodic_sched_assigned;
+
+	/*
+	 * List of periodic QHs that have been queued for execution.
+	 *
+	 * Items move from this list to either periodic_sched_inactive or
+	 * periodic_sched_ready when the channel associated with the transfer
+	 * is released. If the interval for the QH is 1, the item moves to
+	 * periodic_sched_ready because it must be rescheduled for the next
+	 * frame. Otherwise, the item moves to periodic_sched_inactive.
+	 */
+	struct list_head periodic_sched_queued;
+
+	/*
+	 * Total bandwidth claimed so far for periodic transfers. This value
+	 * is in microseconds per (micro)frame. The assumption is that all
+	 * periodic transfers may occur in the same (micro)frame.
+	 */
+	u16 periodic_usecs;
+
+	/*
+	 * Total bandwidth claimed so far for all periodic transfers
+	 * in a frame.
+	 * This will include a mixture of HS and FS transfers.
+	 * Units are microseconds per (micro)frame.
+	 * We have a budget per frame and have to schedule
+	 * transactions accordingly.
+	 * Watch out for the fact that things are actually scheduled for the
+	 * "next frame".
+	 */
+	u16 frame_usecs[8];
+
+	/*
+	 * Frame number read from the core at SOF. The value ranges from 0 to
+	 * DWC_HFNUM_MAX_FRNUM.
+	 */
+	u16 frame_number;
+
+	/*
+	 * Free host channels in the controller. This is a list of
+	 * struct dwc_hc items.
+	 */
+	struct list_head free_hc_list;
+
+	/*
+	 * Number of available host channels.
+	 */
+	u32 available_host_channels;
+
+	/*
+	 * Array of pointers to the host channel descriptors. Allows accessing
+	 * a host channel descriptor given the host channel number. This is
+	 * useful in interrupt handlers.
+	 */
+	struct dwc_hc *hc_ptr_array[MAX_EPS_CHANNELS];
+
+	/*
+	 * Buffer to use for any data received during the status phase of a
+	 * control transfer. Normally no data is transferred during the status
+	 * phase. This buffer is used as a bit bucket.
+	 */
+	u8 *status_buf;
+
+	/*
+	 * DMA address for status_buf.
+	 */
+	dma_addr_t status_buf_dma;
+#define DWC_OTG_HCD_STATUS_BUF_SIZE		64
+
+	/*
+	 * Structure to allow starting the HCD in a non-interrupt context
+	 * during an OTG role change.
+	 */
+	struct work_struct start_work;
+	struct usb_hcd *_p;
+
+	/*
+	 * Connection timer. An OTG host must display a message if the device
+	 * does not connect. Started when the VBus power is turned on via
+	 * sysfs attribute "buspower".
+	 */
+	struct timer_list conn_timer;
+
+	/* workqueue for port wakeup */
+	struct work_struct usb_port_reset;
+
+	/* Addition HCD interrupt */
+	int cp_irq;		/* charge pump interrupt */
+	int cp_irq_installed;
+};
+
+/*
+ * Reasons for halting a host channel.
+ */
+enum dwc_halt_status {
+	DWC_OTG_HC_XFER_NO_HALT_STATUS,
+	DWC_OTG_HC_XFER_COMPLETE,
+	DWC_OTG_HC_XFER_URB_COMPLETE,
+	DWC_OTG_HC_XFER_ACK,
+	DWC_OTG_HC_XFER_NAK,
+	DWC_OTG_HC_XFER_NYET,
+	DWC_OTG_HC_XFER_STALL,
+	DWC_OTG_HC_XFER_XACT_ERR,
+	DWC_OTG_HC_XFER_FRAME_OVERRUN,
+	DWC_OTG_HC_XFER_BABBLE_ERR,
+	DWC_OTG_HC_XFER_DATA_TOGGLE_ERR,
+	DWC_OTG_HC_XFER_AHB_ERR,
+	DWC_OTG_HC_XFER_PERIODIC_INCOMPLETE,
+	DWC_OTG_HC_XFER_URB_DEQUEUE
+};
+
+/*
+ * Host channel descriptor. This structure represents the state of a single
+ * host channel when acting in host mode. It contains the data items needed to
+ * transfer packets to an endpoint via a host channel.
+ */
+struct dwc_hc {
+	/* Host channel number used for register address lookup */
+	u8 hc_num;
+
+	/* Device to access */
+	unsigned dev_addr:7;
+
+	/* EP to access */
+	unsigned ep_num:4;
+
+	/* EP direction. 0: OUT, 1: IN */
+	unsigned ep_is_in:1;
+
+	/*
+	 * EP speed.
+	 * One of the following values:
+	 *      - DWC_OTG_EP_SPEED_LOW
+	 *      - DWC_OTG_EP_SPEED_FULL
+	 *      - DWC_OTG_EP_SPEED_HIGH
+	 */
+	unsigned speed:2;
+#define DWC_OTG_EP_SPEED_LOW		0
+#define DWC_OTG_EP_SPEED_FULL		1
+#define DWC_OTG_EP_SPEED_HIGH		2
+
+	/*
+	 * Endpoint type.
+	 * One of the following values:
+	 *      - DWC_OTG_EP_TYPE_CONTROL: 0
+	 *      - DWC_OTG_EP_TYPE_ISOC: 1
+	 *      - DWC_OTG_EP_TYPE_BULK: 2
+	 *      - DWC_OTG_EP_TYPE_INTR: 3
+	 */
+	unsigned ep_type:2;
+
+	/* Max packet size in bytes */
+	unsigned max_packet:11;
+
+	/*
+	 * PID for initial transaction.
+	 * 0: DATA0,
+	 * 1: DATA2,
+	 * 2: DATA1,
+	 * 3: MDATA (non-Control EP),
+	 *      SETUP (Control EP)
+	 */
+	unsigned data_pid_start:2;
+#define DWC_OTG_HC_PID_DATA0		0
+#define DWC_OTG_HC_PID_DATA2		1
+#define DWC_OTG_HC_PID_DATA1		2
+#define DWC_OTG_HC_PID_MDATA		3
+#define DWC_OTG_HC_PID_SETUP		3
+
+	/* Number of periodic transactions per (micro)frame */
+	unsigned multi_count:2;
+
+	/* Pointer to the current transfer buffer position. */
+	u8 *xfer_buff;
+	/* Total number of bytes to transfer. */
+	u32 xfer_len;
+	/* Number of bytes transferred so far. */
+	u32 xfer_count;
+	/* Packet count at start of transfer. */
+	u16 start_pkt_count;
+
+	/*
+	 * Flag to indicate whether the transfer has been started. Set to 1 if
+	 * it has been started, 0 otherwise.
+	 */
+	u8 xfer_started;
+
+	/*
+	 * Set to 1 to indicate that a PING request should be issued on this
+	 * channel. If 0, process normally.
+	 */
+	u8 do_ping;
+
+	/*
+	 * Set to 1 to indicate that the error count for this transaction is
+	 * non-zero. Set to 0 if the error count is 0.
+	 */
+	u8 error_state;
+
+	/*
+	 * Set to 1 to indicate that this channel should be halted the next
+	 * time a request is queued for the channel. This is necessary in
+	 * slave mode if no request queue space is available when an attempt
+	 * is made to halt the channel.
+	 */
+	u8 halt_on_queue;
+
+	/*
+	 * Set to 1 if the host channel has been halted, but the core is not
+	 * finished flushing queued requests. Otherwise 0.
+	 */
+	u8 halt_pending;
+
+	/* Reason for halting the host channel. */
+	enum dwc_halt_status halt_status;
+
+	/*  Split settings for the host channel */
+	u8 do_split;		/* Enable split for the channel */
+	u8 complete_split;	/* Enable complete split */
+	u8 hub_addr;		/* Address of high speed hub */
+	u8 port_addr;		/* Port of the low/full speed device */
+
+	/*
+	 * Split transaction position. One of the following values:
+	 *      - DWC_HCSPLIT_XACTPOS_MID
+	 *      - DWC_HCSPLIT_XACTPOS_BEGIN
+	 *      - DWC_HCSPLIT_XACTPOS_END
+	 *      - DWC_HCSPLIT_XACTPOS_ALL */
+	u8 xact_pos;
+
+	/* Set when the host channel does a short read. */
+	u8 short_read;
+
+	/*
+	 * Number of requests issued for this channel since it was assigned to
+	 * the current transfer (not counting PINGs).
+	 */
+	u8 requests;
+
+	/* Queue Head for the transfer being processed by this channel. */
+	struct dwc_qh *qh;
+
+	/* Entry in list of host channels. */
+	struct list_head hc_list_entry;
+};
+
+/*
+ * The following parameters may be specified when starting the module. These
+ * parameters define how the DWC_otg controller should be configured.  Parameter
+ * values are passed to the CIL initialization function dwc_otg_cil_init.
+ */
+struct core_params {
+	/*
+	 * Specifies the OTG capabilities. The driver will automatically
+	 * detect the value for this parameter if none is specified.
+	 * 0 - HNP and SRP capable (default)
+	 * 1 - SRP Only capable
+	 * 2 - No HNP/SRP capable
+	 */
+	int otg_cap;
+#define DWC_OTG_CAP_PARAM_HNP_SRP_CAPABLE		0
+#define DWC_OTG_CAP_PARAM_SRP_ONLY_CAPABLE		1
+#define DWC_OTG_CAP_PARAM_NO_HNP_SRP_CAPABLE		2
+
+#define dwc_param_otg_cap_default	DWC_OTG_CAP_PARAM_HNP_SRP_CAPABLE
+
+	/*
+	 * Specifies whether to use slave or DMA mode for accessing the data
+	 * FIFOs. The driver will automatically detect the value for this
+	 * parameter if none is specified.
+	 * 0 - Slave
+	 * 1 - DMA (default, if available)
+	 */
+	int dma_enable;
+#ifdef CONFIG_DWC_SLAVE
+#define dwc_param_dma_enable_default			0
+#else
+#define dwc_param_dma_enable_default			1
+#endif
+
+	/*
+	 * The DMA Burst size (applicable only for External DMA Mode).
+	 * 1, 4, 8 16, 32, 64, 128, 256 (default 32)
+	 */
+	int dma_burst_size;	/* Translate this to GAHBCFG values */
+#define dwc_param_dma_burst_size_default		32
+
+	/*
+	 * Specifies the maximum speed of operation in host and device mode.
+	 * The actual speed depends on the speed of the attached device and
+	 * the value of phy_type. The actual speed depends on the speed of the
+	 * attached device.
+	 *      0 - High Speed (default)
+	 *      1 - Full Speed
+	 */
+	int speed;
+#define dwc_param_speed_default				0
+#define DWC_SPEED_PARAM_HIGH				0
+#define DWC_SPEED_PARAM_FULL				1
+
+	/*
+	 * Specifies whether low power mode is supported when attached to a Full
+	 * Speed or Low Speed device in host mode.
+	 *      0 - Don't support low power mode (default)
+	 *      1 - Support low power mode
+	 */
+	int host_support_fs_ls_low_power;
+#define dwc_param_host_support_fs_ls_low_power_default	0
+
+	/*
+	 * Specifies the PHY clock rate in low power mode when connected to a
+	 * Low Speed device in host mode. This parameter is applicable only if
+	 * HOST_SUPPORT_FS_LS_LOW_POWER is enabled. If PHY_TYPE is set to FS
+	 * then defaults to 6 MHZ otherwise 48 MHZ.
+	 *
+	 *      0 - 48 MHz
+	 *      1 - 6 MHz
+	 */
+	int host_ls_low_power_phy_clk;
+#define dwc_param_host_ls_low_power_phy_clk_default	0
+#define DWC_HOST_LS_LOW_POWER_PHY_CLK_PARAM_48MHZ	0
+#define DWC_HOST_LS_LOW_POWER_PHY_CLK_PARAM_6MHZ	1
+
+	/*
+	 * 0 - Use cC FIFO size parameters
+	 * 1 - Allow dynamic FIFO sizing (default)
+	 */
+	int enable_dynamic_fifo;
+#define dwc_param_enable_dynamic_fifo_default		1
+
+	/*
+	 * Number of 4-byte words in the Rx FIFO in device mode when dynamic
+	 * FIFO sizing is enabled.  16 to 32768 (default 1064)
+	 */
+	int dev_rx_fifo_size;
+#define dwc_param_dev_rx_fifo_size_default		1064
+
+	/*
+	 * Number of 4-byte words in the non-periodic Tx FIFO in device mode
+	 * when dynamic FIFO sizing is enabled.  16 to 32768 (default 1024)
+	 */
+	int dev_nperio_tx_fifo_size;
+#define dwc_param_dev_nperio_tx_fifo_size_default	1024
+
+	/*
+	 * Number of 4-byte words in each of the periodic Tx FIFOs in device
+	 * mode when dynamic FIFO sizing is enabled.  4 to 768 (default 256)
+	 */
+	u32 dev_perio_tx_fifo_size[MAX_PERIO_FIFOS];
+#define dwc_param_dev_perio_tx_fifo_size_default	256
+
+	/*
+	 * Number of 4-byte words in the Rx FIFO in host mode when dynamic
+	 * FIFO sizing is enabled.  16 to 32768 (default 1024)
+	 */
+	int host_rx_fifo_size;
+#define dwc_param_host_rx_fifo_size_default		1024
+
+	/*
+	 * Number of 4-byte words in the non-periodic Tx FIFO in host mode
+	 * when Dynamic FIFO sizing is enabled in the core.  16 to 32768
+	 * (default 1024)
+	 */
+	int host_nperio_tx_fifo_size;
+#define dwc_param_host_nperio_tx_fifo_size_default	1024
+
+	/*
+	   Number of 4-byte words in the host periodic Tx FIFO when dynamic
+	   * FIFO sizing is enabled.  16 to 32768 (default 1024)
+	 */
+	int host_perio_tx_fifo_size;
+#define dwc_param_host_perio_tx_fifo_size_default	1024
+
+	/*
+	 * The maximum transfer size supported in bytes. 2047 to 65,535
+	 * (default 65,535)
+	 */
+	int max_transfer_size;
+#define dwc_param_max_transfer_size_default		65535
+
+	/*
+	 * The maximum number of packets in a transfer. 15 to 511  (default 511)
+	 */
+	int max_packet_count;
+#define dwc_param_max_packet_count_default		511
+
+	/*
+	 * The number of host channel registers to use.
+	 * 1 to 16 (default 12)
+	 * Note: The FPGA configuration supports a maximum of 12 host channels.
+	 */
+	int host_channels;
+#define dwc_param_host_channels_default			12
+
+	/*
+	 * The number of endpoints in addition to EP0 available for device
+	 * mode operations.
+	 * 1 to 15 (default 6 IN and OUT)
+	 * Note: The FPGA configuration supports a maximum of 6 IN and OUT
+	 * endpoints in addition to EP0.
+	 */
+	int dev_endpoints;
+#define dwc_param_dev_endpoints_default			6
+
+	/*
+	 * Specifies the type of PHY interface to use. By default, the driver
+	 * will automatically detect the phy_type.
+	 *
+	 *      0 - Full Speed PHY
+	 *      1 - UTMI+ (default)
+	 *      2 - ULPI
+	 */
+	int phy_type;
+#define DWC_PHY_TYPE_PARAM_FS			0
+#define DWC_PHY_TYPE_PARAM_UTMI			1
+#define DWC_PHY_TYPE_PARAM_ULPI			2
+#define dwc_param_phy_type_default		DWC_PHY_TYPE_PARAM_UTMI
+
+	/*
+	 * Specifies the UTMI+ Data Width.  This parameter is applicable for a
+	 * PHY_TYPE of UTMI+ or ULPI. (For a ULPI PHY_TYPE, this parameter
+	 * indicates the data width between the MAC and the ULPI Wrapper.) Also,
+	 * this parameter is applicable only if the OTG_HSPHY_WIDTH cC parameter
+	 * was set to "8 and 16 bits", meaning that the core has been configured
+	 * to work at either data path width.
+	 *
+	 * 8 or 16 bits (default 16)
+	 */
+	int phy_utmi_width;
+#define dwc_param_phy_utmi_width_default	16
+
+	/*
+	 * Specifies whether the ULPI operates at double or single
+	 * data rate. This parameter is only applicable if PHY_TYPE is
+	 * ULPI.
+	 *
+	 *      0 - single data rate ULPI interface with 8 bit wide data
+	 *              bus (default)
+	 *      1 - double data rate ULPI interface with 4 bit wide data
+	 *              bus
+	 */
+	int phy_ulpi_ddr;
+#define dwc_param_phy_ulpi_ddr_default		0
+
+	/*
+	 * Specifies whether to use the internal or external supply to
+	 * drive the vbus with a ULPI phy.
+	 */
+	int phy_ulpi_ext_vbus;
+#define DWC_PHY_ULPI_INTERNAL_VBUS		0
+#define DWC_PHY_ULPI_EXTERNAL_VBUS		1
+#define dwc_param_phy_ulpi_ext_vbus_default	DWC_PHY_ULPI_INTERNAL_VBUS
+
+	/*
+	 * Specifies whether to use the I2Cinterface for full speed PHY. This
+	 * parameter is only applicable if PHY_TYPE is FS.
+	 *      0 - No (default)
+	 *      1 - Yes
+	 */
+	int i2c_enable;
+#define dwc_param_i2c_enable_default		0
+
+	int ulpi_fs_ls;
+#define dwc_param_ulpi_fs_ls_default		0
+
+	int ts_dline;
+#define dwc_param_ts_dline_default		0
+
+	/*
+	 * Specifies whether dedicated transmit FIFOs are enabled for non
+	 * periodic IN endpoints in device mode
+	 *      0 - No
+	 *      1 - Yes
+	 */
+	int en_multiple_tx_fifo;
+#define dwc_param_en_multiple_tx_fifo_default	1
+
+	/*
+	 * Number of 4-byte words in each of the Tx FIFOs in device
+	 * mode when dynamic FIFO sizing is enabled. 4 to 768 (default 256)
+	 */
+	u32 dev_tx_fifo_size[MAX_TX_FIFOS];
+#define dwc_param_dev_tx_fifo_size_default	256
+
+	/*
+	 * Thresholding enable flag
+	 *      bit 0 - enable non-ISO Tx thresholding
+	 *      bit 1 - enable ISO Tx thresholding
+	 *      bit 2 - enable Rx thresholding
+	 */
+	u32 thr_ctl;
+#define dwc_param_thr_ctl_default		0
+
+	/* Thresholding length for Tx FIFOs in 32 bit DWORDs */
+	u32 tx_thr_length;
+#define dwc_param_tx_thr_length_default		64
+
+	/* Thresholding length for Rx FIFOs in 32 bit DWORDs */
+	u32 rx_thr_length;
+#define dwc_param_rx_thr_length_default		64
+
+};
+
+/*
+ * The core_if structure contains information needed to manage the
+ * DWC_otg controller acting in either host or device mode. It represents the
+ * programming view of the controller as a whole.
+ */
+struct core_if {
+	/* Parameters that define how the core should be configured. */
+	struct core_params *core_params;
+
+	/* Core Global registers starting at offset 000h. */
+	ulong core_global_regs;
+
+	/* Device-specific information */
+	struct device_if *dev_if;
+	/* Host-specific information */
+	struct dwc_host_if *host_if;
+
+	/*
+	 * Set to 1 if the core PHY interface bits in USBCFG have been
+	 * initialized.
+	 */
+	u8 phy_init_done;
+
+	/*
+	 * SRP Success flag, set by srp success interrupt in FS I2C mode
+	 */
+	u8 srp_success;
+	u8 srp_timer_started;
+
+	/* Common configuration information */
+	/* Power and Clock Gating Control Register */
+	ulong pcgcctl;
+#define DWC_OTG_PCGCCTL_OFFSET			0xE00
+
+	/* Push/pop addresses for endpoints or host channels. */
+	ulong data_fifo[MAX_EPS_CHANNELS];
+#define DWC_OTG_DATA_FIFO_OFFSET		0x1000
+#define DWC_OTG_DATA_FIFO_SIZE			0x1000
+
+	/* Total RAM for FIFOs (Bytes) */
+	u16 total_fifo_size;
+	/* Size of Rx FIFO (Bytes) */
+	u16 rx_fifo_size;
+	/* Size of Non-periodic Tx FIFO (Bytes) */
+	u16 nperio_tx_fifo_size;
+
+	/* 1 if DMA is enabled, 0 otherwise. */
+	u8 dma_enable;
+
+	/* 1 if dedicated Tx FIFOs are enabled, 0 otherwise. */
+	u8 en_multiple_tx_fifo;
+
+	/*
+	 *  Set to 1 if multiple packets of a high-bandwidth transfer is in
+	 * process of being queued
+	 */
+	u8 queuing_high_bandwidth;
+
+	/* Hardware Configuration -- stored here for convenience. */
+	ulong hwcfg1;
+	ulong hwcfg2;
+	ulong hwcfg3;
+	ulong hwcfg4;
+
+	/* HCD callbacks */
+	/* include/linux/usb/otg.h */
+
+	/* HCD callbacks */
+	struct cil_callbacks *hcd_cb;
+	/* PCD callbacks */
+	struct cil_callbacks *pcd_cb;
+
+	/* Device mode Periodic Tx FIFO Mask */
+	u32 p_tx_msk;
+	/* Device mode Periodic Tx FIFO Mask */
+	u32 tx_msk;
+
+	/* Features of various DWC implementation */
+	u32 features;
+
+	/* Added to support PLB DMA : phys-virt mapping */
+	resource_size_t phys_addr;
+
+	struct delayed_work usb_port_wakeup;
+	struct work_struct usb_port_otg;
+	struct otg_transceiver *xceiv;
+};
+
+/*
+ * The following functions support initialization of the CIL driver component
+ * and the DWC_otg controller.
+ */
+extern void dwc_otg_core_init(struct core_if *core_if);
+extern void init_fslspclksel(struct core_if *core_if);
+extern void dwc_otg_core_dev_init(struct core_if *core_if);
+extern void dwc_otg_enable_global_interrupts(struct core_if *core_if);
+extern void dwc_otg_disable_global_interrupts(struct core_if *core_if);
+extern void dwc_otg_enable_common_interrupts(struct core_if *core_if);
+
+/**
+ * This function Reads HPRT0 in preparation to modify.  It keeps the WC bits 0
+ * so that if they are read as 1, they won't clear when you write it back
+ */
+static inline u32 dwc_otg_read_hprt0(struct core_if *core_if)
+{
+	u32 hprt0 = 0;
+	hprt0 = dwc_reg_read(core_if->host_if->hprt0, 0);
+	hprt0 = DWC_HPRT0_PRT_ENA_RW(hprt0, 0);
+	hprt0 = DWC_HPRT0_PRT_CONN_DET_RW(hprt0, 0);
+	hprt0 = DWC_HPRT0_PRT_ENA_DIS_CHG_RW(hprt0, 0);
+	hprt0 = DWC_HPRT0_PRT_OVRCURR_ACT_RW(hprt0, 0);
+	return hprt0;
+}
+
+/*
+ * The following functions support managing the DWC_otg controller in either
+ * device or host mode.
+ */
+extern void dwc_otg_read_packet(struct core_if *core_if, u8 * dest, u16 bytes);
+extern void dwc_otg_flush_tx_fifo(struct core_if *core_if, const int _num);
+extern void dwc_otg_flush_rx_fifo(struct core_if *core_if);
+
+#define NP_TXFIFO_EMPTY			-1
+#define MAX_NP_TXREQUEST_Q_SLOTS	8
+
+/**
+ * This function returns the Core Interrupt register.
+ */
+static inline u32 dwc_otg_read_core_intr(struct core_if *core_if)
+{
+	u32 global_regs = (u32) core_if->core_global_regs;
+	return dwc_reg_read(global_regs, DWC_GINTSTS) &
+	    dwc_reg_read(global_regs, DWC_GINTMSK);
+}
+
+/**
+ * This function returns the mode of the operation, host or device.
+ */
+static inline u32 dwc_otg_mode(struct core_if *core_if)
+{
+	u32 global_regs = (u32) core_if->core_global_regs;
+	return dwc_reg_read(global_regs, DWC_GINTSTS) & 0x1;
+}
+
+static inline u8 dwc_otg_is_device_mode(struct core_if *core_if)
+{
+	return dwc_otg_mode(core_if) != DWC_HOST_MODE;
+}
+static inline u8 dwc_otg_is_host_mode(struct core_if *core_if)
+{
+	return dwc_otg_mode(core_if) == DWC_HOST_MODE;
+}
+
+extern int dwc_otg_handle_common_intr(struct core_if *core_if);
+
+/*
+ * DWC_otg CIL callback structure.  This structure allows the HCD and PCD to
+ * register functions used for starting and stopping the PCD and HCD for role
+ * change on for a DRD.
+ */
+struct cil_callbacks {
+	/* Start function for role change */
+	int (*start) (void *_p);
+	/* Stop Function for role change */
+	int (*stop) (void *_p);
+	/* Disconnect Function for role change */
+	int (*disconnect) (void *_p);
+	/* Resume/Remote wakeup Function */
+	int (*resume_wakeup) (void *_p);
+	/* Suspend function */
+	int (*suspend) (void *_p);
+	/* Session Start (SRP) */
+	int (*session_start) (void *_p);
+	/* Pointer passed to start() and stop() */
+	void *p;
+};
+
+extern void dwc_otg_cil_register_pcd_callbacks(struct core_if *core_if,
+					       struct cil_callbacks *cb,
+					       void *p);
+extern void dwc_otg_cil_register_hcd_callbacks(struct core_if *core_if,
+					       struct cil_callbacks *cb,
+					       void *p);
+
+#define DWC_LIMITED_XFER		0x00000000
+#define DWC_DEVICE_ONLY			0x00000000
+#define DWC_HOST_ONLY			0x00000000
+
+#ifdef DWC_LIMITED_XFER_SIZE
+#undef DWC_LIMITED_XFER
+#define DWC_LIMITED_XFER		0x00000001
+#endif
+
+#ifdef CONFIG_DWC_DEVICE_ONLY
+#undef DWC_DEVICE_ONLY
+#define DWC_DEVICE_ONLY			0x00000002
+static inline void dwc_otg_hcd_remove(struct device *dev)
+{
+}
+static inline int dwc_otg_hcd_init(struct device *_dev,
+				   struct dwc_otg_device *dwc_dev)
+{
+	return 0;
+}
+#else
+extern int __init dwc_otg_hcd_init(struct device *_dev,
+				   struct dwc_otg_device *dwc_dev);
+extern void dwc_otg_hcd_remove(struct device *_dev);
+#endif
+
+#ifdef CONFIG_DWC_HOST_ONLY
+#undef DWC_HOST_ONLY
+#define DWC_HOST_ONLY			0x00000004
+static inline void dwc_otg_pcd_remove(struct device *dev)
+{
+}
+static inline int dwc_otg_pcd_init(struct device *dev)
+{
+	return 0;
+}
+#else
+extern void dwc_otg_pcd_remove(struct device *dev);
+extern int __init dwc_otg_pcd_init(struct device *dev);
+#endif
+
+extern void dwc_otg_cil_remove(struct core_if *core_if);
+extern struct core_if __devinit *dwc_otg_cil_init(const __iomem u32 * base,
+						  struct core_params *params);
+
+static inline void dwc_set_feature(struct core_if *core_if)
+{
+	core_if->features = DWC_LIMITED_XFER | DWC_DEVICE_ONLY | DWC_HOST_ONLY;
+}
+
+static inline int dwc_has_feature(struct core_if *core_if,
+				  unsigned long feature)
+{
+	return core_if->features & feature;
+}
+extern struct core_params dwc_otg_module_params;
+extern int __devinit check_parameters(struct core_if *core_if);
+#endif
diff --git a/drivers/usb/dwc/cil_intr.c b/drivers/usb/dwc/cil_intr.c
new file mode 100644
index 0000000..32f7dc4
--- /dev/null
+++ b/drivers/usb/dwc/cil_intr.c
@@ -0,0 +1,584 @@
+/*
+ * DesignWare HS OTG controller driver
+ * Copyright (C) 2006 Synopsys, Inc.
+ * Portions Copyright (C) 2010 Applied Micro Circuits Corporation.
+ *
+ * This program is free software: you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License version 2 for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see http://www.gnu.org/licenses
+ * or write to the Free Software Foundation, Inc., 51 Franklin Street,
+ * Suite 500, Boston, MA 02110-1335 USA.
+ *
+ * Based on Synopsys driver version 2.60a
+ * Modified by Mark Miesfeld <mmiesfeld@apm.com>
+ * Modified by Stefan Roese <sr@denx.de>, DENX Software Engineering
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING BUT NOT LIMITED TO THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL SYNOPSYS, INC. BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+/*
+ * The Core Interface Layer provides basic services for accessing and
+ * managing the DWC_otg hardware. These services are used by both the
+ * Host Controller Driver and the Peripheral Controller Driver.
+ *
+ * This file contains the Common Interrupt handlers.
+ */
+#include <linux/delay.h>
+
+#include "cil.h"
+
+/**
+ *  This function will log a debug message
+ */
+static int dwc_otg_handle_mode_mismatch_intr(struct core_if *core_if)
+{
+	ulong global_regs = core_if->core_global_regs;
+
+	pr_warning("Mode Mismatch Interrupt: currently in %s mode\n",
+		   dwc_otg_mode(core_if) ? "Host" : "Device");
+
+	/* Clear interrupt */
+	dwc_reg_write(global_regs, DWC_GINTSTS, DWC_INTSTS_MODE_MISMTC);
+	return 1;
+}
+
+/**
+ *  Start the HCD.  Helper function for using the HCD callbacks.
+ */
+static inline void hcd_start(struct core_if *core_if)
+{
+	if (core_if->hcd_cb && core_if->hcd_cb->start)
+		core_if->hcd_cb->start(core_if->hcd_cb->p);
+}
+
+/**
+ *  Disconnect the HCD.  Helper function for using the HCD callbacks.
+ */
+static inline void hcd_disconnect(struct core_if *core_if)
+{
+	if (core_if->hcd_cb && core_if->hcd_cb->disconnect)
+		core_if->hcd_cb->disconnect(core_if->hcd_cb->p);
+}
+
+/**
+ *  Inform the HCD the a New Session has begun.  Helper function for using the
+ *  HCD callbacks.
+ */
+static inline void hcd_session_start(struct core_if *core_if)
+{
+	if (core_if->hcd_cb && core_if->hcd_cb->session_start)
+		core_if->hcd_cb->session_start(core_if->hcd_cb->p);
+}
+
+/**
+ *  Start the PCD.  Helper function for using the PCD callbacks.
+ */
+static inline void pcd_start(struct core_if *core_if)
+{
+	if (core_if->pcd_cb && core_if->pcd_cb->start) {
+		struct dwc_pcd *pcd;
+
+		pcd = (struct dwc_pcd *)core_if->pcd_cb->p;
+		spin_lock(&pcd->lock);
+		core_if->pcd_cb->start(core_if->pcd_cb->p);
+		spin_unlock(&pcd->lock);
+	}
+}
+
+/**
+ *  Stop the PCD.  Helper function for using the PCD callbacks.
+ */
+static inline void pcd_stop(struct core_if *core_if)
+{
+	if (core_if->pcd_cb && core_if->pcd_cb->stop) {
+		struct dwc_pcd *pcd;
+
+		pcd = (struct dwc_pcd *)core_if->pcd_cb->p;
+		spin_lock(&pcd->lock);
+		core_if->pcd_cb->stop(core_if->pcd_cb->p);
+		spin_unlock(&pcd->lock);
+	}
+}
+
+/**
+ *  Suspend the PCD.  Helper function for using the PCD callbacks.
+ */
+static inline void pcd_suspend(struct core_if *core_if)
+{
+	if (core_if->pcd_cb && core_if->pcd_cb->suspend) {
+		struct dwc_pcd *pcd;
+
+		pcd = (struct dwc_pcd *)core_if->pcd_cb->p;
+		spin_lock(&pcd->lock);
+		core_if->pcd_cb->suspend(core_if->pcd_cb->p);
+		spin_unlock(&pcd->lock);
+	}
+}
+
+/**
+ *  Resume the PCD.  Helper function for using the PCD callbacks.
+ */
+static inline void pcd_resume(struct core_if *core_if)
+{
+	if (core_if->pcd_cb && core_if->pcd_cb->resume_wakeup) {
+		struct dwc_pcd *pcd;
+
+		pcd = (struct dwc_pcd *)core_if->pcd_cb->p;
+		spin_lock(&pcd->lock);
+		core_if->pcd_cb->resume_wakeup(core_if->pcd_cb->p);
+		spin_unlock(&pcd->lock);
+	}
+}
+
+/**
+ * This function handles the OTG Interrupts. It reads the OTG
+ * Interrupt Register (GOTGINT) to determine what interrupt has
+ * occurred.
+ */
+static int dwc_otg_handle_otg_intr(struct core_if *core_if)
+{
+	ulong global_regs = core_if->core_global_regs;
+	u32 gotgint;
+	u32 gotgctl;
+
+	gotgint = dwc_reg_read(global_regs, DWC_GOTGINT);
+	if (gotgint & DWC_GINT_SES_ENDDET) {
+		gotgctl = dwc_reg_read(global_regs, DWC_GOTGCTL);
+		if (core_if->xceiv->state == OTG_STATE_B_HOST) {
+			pcd_start(core_if);
+			core_if->xceiv->state = OTG_STATE_B_PERIPHERAL;
+		} else {
+			/*
+			 * If not B_HOST and Device HNP still set. HNP did not
+			 * succeed
+			 */
+			if (gotgctl & DWC_GCTL_DEV_HNP_ENA)
+				pr_err("Device Not Connected / "
+				       "Responding\n");
+			/*
+			 * If Session End Detected the B-Cable has been
+			 * disconnected.  Reset PCD and Gadget driver to a
+			 * clean state.
+			 */
+			pcd_stop(core_if);
+		}
+		dwc_reg_modify(global_regs, DWC_GOTGCTL, DWC_GCTL_DEV_HNP_ENA,\
+				0);
+	}
+	if (gotgint & DWC_GINT_SES_REQSUC) {
+		gotgctl = dwc_reg_read(global_regs, DWC_GOTGCTL);
+		if (gotgctl & DWC_GCTL_SES_REQ_SUCCESS) {
+			if (core_if->core_params->phy_type ==
+			    DWC_PHY_TYPE_PARAM_FS &&
+			    core_if->core_params->i2c_enable) {
+				core_if->srp_success = 1;
+			} else {
+				pcd_resume(core_if);
+
+				/* Clear Session Request */
+				dwc_reg_modify(global_regs, DWC_GOTGCTL,
+					     DWC_GCTL_SES_REQ, 0);
+			}
+		}
+	}
+	if (gotgint & DWC_GINT_HST_NEGSUC) {
+		/*
+		 * Print statements during the HNP interrupt handling can cause
+		 * it to fail.
+		 */
+		gotgctl = dwc_reg_read(global_regs, DWC_GOTGCTL);
+		if (gotgctl & DWC_GCTL_HOST_NEG_SUCCES) {
+			if (dwc_otg_is_host_mode(core_if)) {
+				core_if->xceiv->state = OTG_STATE_B_HOST;
+				/*
+				 * Need to disable SOF interrupt immediately.
+				 * When switching from device to host, the PCD
+				 * interrupt handler won't handle the
+				 * interrupt if host mode is already set. The
+				 * HCD interrupt handler won't get called if
+				 * the HCD state is HALT. This means that the
+				 * interrupt does not get handled and Linux
+				 * complains loudly.
+				 */
+				dwc_reg_modify(global_regs, DWC_GINTMSK,
+					      DWC_INTMSK_STRT_OF_FRM, 0);
+				pcd_stop(core_if);
+				/* Initialize the Core for Host mode. */
+				hcd_start(core_if);
+				core_if->xceiv->state = OTG_STATE_B_HOST;
+			}
+		} else {
+			gotgctl = 0;
+			gotgctl = DWC_GCTL_HNP_REQ |\
+				  DWC_GCTL_DEV_HNP_ENA;
+			dwc_reg_modify(global_regs, DWC_GOTGCTL, gotgctl, 0);
+
+			pr_err("Device Not Connected / Responding\n");
+		}
+	}
+	if (gotgint & DWC_GINT_HST_NEGDET) {
+		/*
+		 * The disconnect interrupt is set at the same time as
+		 * Host Negotiation Detected.  During the mode
+		 * switch all interrupts are cleared so the disconnect
+		 * interrupt handler will not get executed.
+		 */
+		if (dwc_otg_is_device_mode(core_if)) {
+			hcd_disconnect(core_if);
+			pcd_start(core_if);
+			core_if->xceiv->state = OTG_STATE_A_PERIPHERAL;
+		} else {
+			/*
+			 * Need to disable SOF interrupt immediately. When
+			 * switching from device to host, the PCD interrupt
+			 * handler won't handle the interrupt if host mode is
+			 * already set. The HCD interrupt handler won't get
+			 * called if the HCD state is HALT. This means that
+			 * the interrupt does not get handled and Linux
+			 * complains loudly.
+			 */
+			dwc_reg_modify(global_regs, DWC_GINTMSK,\
+					DWC_INTMSK_STRT_OF_FRM, 0);
+			pcd_stop(core_if);
+			hcd_start(core_if);
+			core_if->xceiv->state = OTG_STATE_A_HOST;
+		}
+	}
+	if (gotgint & DWC_GINT_DEVTOUT)
+		pr_info(" ++OTG Interrupt: A-Device Timeout " "Change++\n");
+	if (gotgint & DWC_GINT_DEBDONE)
+		pr_info(" ++OTG Interrupt: Debounce Done++\n");
+
+	/* Clear GOTGINT */
+	dwc_reg_write(global_regs, DWC_GOTGINT, gotgint);
+	return 1;
+}
+
+/*
+ * Wakeup Workqueue implementation
+ */
+static void port_otg_wqfunc(struct work_struct *work)
+{
+	struct core_if *core_if = container_of(work, struct core_if,
+					       usb_port_otg);
+	ulong global_regs = core_if->core_global_regs;
+	u32 count = 0;
+	u32 gotgctl;
+
+	pr_info("%s\n", __func__);
+
+	gotgctl = dwc_reg_read(global_regs, DWC_GOTGCTL);
+	if (gotgctl & DWC_GCTL_CONN_ID_STATUS) {
+		/*
+		 * B-Device connector (device mode) wait for switch to device
+		 * mode.
+		 */
+		while (!dwc_otg_is_device_mode(core_if) && ++count <= 10000) {
+			pr_info("Waiting for Peripheral Mode, "
+				"Mode=%s\n", dwc_otg_is_host_mode(core_if) ?
+				"Host" : "Peripheral");
+			msleep(100);
+		}
+		BUG_ON(count > 10000);
+		core_if->xceiv->state = OTG_STATE_B_PERIPHERAL;
+		dwc_otg_core_init(core_if);
+		dwc_otg_enable_global_interrupts(core_if);
+		pcd_start(core_if);
+	} else {
+		/*
+		 * A-Device connector (host mode) wait for switch to host
+		 * mode.
+		 */
+		while (!dwc_otg_is_host_mode(core_if) && ++count <= 10000) {
+			pr_info("Waiting for Host Mode, Mode=%s\n",
+				dwc_otg_is_host_mode(core_if) ?
+				"Host" : "Peripheral");
+			msleep(100);
+		}
+		BUG_ON(count > 10000);
+		core_if->xceiv->state = OTG_STATE_A_HOST;
+		dwc_otg_core_init(core_if);
+		dwc_otg_enable_global_interrupts(core_if);
+		hcd_start(core_if);
+	}
+}
+
+/**
+ * This function handles the Connector ID Status Change Interrupt.  It
+ * reads the OTG Interrupt Register (GOTCTL) to determine whether this
+ * is a Device to Host Mode transition or a Host Mode to Device
+ * Transition.
+ *
+ * This only occurs when the cable is connected/removed from the PHY
+ * connector.
+ */
+static int dwc_otg_handle_conn_id_status_change_intr(struct core_if *core_if)
+{
+	ulong global_regs = core_if->core_global_regs;
+	/*
+	 * Need to disable SOF interrupt immediately. If switching from device
+	 * to host, the PCD interrupt handler won't handle the interrupt if
+	 * host mode is already set. The HCD interrupt handler won't get
+	 * called if the HCD state is HALT. This means that the interrupt does
+	 * not get handled and Linux complains loudly.
+	 */
+	dwc_reg_modify(global_regs, DWC_GINTMSK, DWC_INTSTS_STRT_OF_FRM, 0);
+
+	INIT_WORK(&core_if->usb_port_otg, port_otg_wqfunc);
+	schedule_work(&core_if->usb_port_otg);
+
+	/* Set flag and clear interrupt */
+	dwc_reg_write(global_regs, DWC_GINTSTS, DWC_INTSTS_CON_ID_STS_CHG);
+	return 1;
+}
+
+/**
+ * This interrupt indicates that a device is initiating the Session
+ * Request Protocol to request the host to turn on bus power so a new
+ * session can begin. The handler responds by turning on bus power. If
+ * the DWC_otg controller is in low power mode, the handler brings the
+ * controller out of low power mode before turning on bus power.
+ */
+static int dwc_otg_handle_session_req_intr(struct core_if *core_if)
+{
+	ulong global_regs = core_if->core_global_regs;
+
+	if (!dwc_has_feature(core_if, DWC_HOST_ONLY)) {
+		u32 hprt0;
+
+		if (dwc_otg_is_device_mode(core_if)) {
+			pr_info("SRP: Device mode\n");
+		} else {
+			pr_info("SRP: Host mode\n");
+
+			/* Turn on the port power bit. */
+			hprt0 = dwc_otg_read_hprt0(core_if);
+			hprt0 = DWC_HPRT0_PRT_PWR_RW(hprt0, 1);
+			dwc_reg_write(core_if->host_if->hprt0, 0, hprt0);
+
+			/*
+			 * Start the Connection timer.
+			 * A message can be displayed,
+			 * if connect does not occur within 10 seconds.
+			 */
+			hcd_session_start(core_if);
+		}
+	}
+	/* Clear interrupt */
+	dwc_reg_write(global_regs, DWC_GINTSTS, DWC_INTSTS_NEW_SES_DET);
+	return 1;
+}
+
+/**
+ * This interrupt indicates that the DWC_otg controller has detected a
+ * resume or remote wakeup sequence. If the DWC_otg controller is in
+ * low power mode, the handler must brings the controller out of low
+ * power mode. The controller automatically begins resume
+ * signaling. The handler schedules a time to stop resume signaling.
+ */
+static int dwc_otg_handle_wakeup_detected_intr(struct core_if *core_if)
+{
+	struct device_if *dev_if = core_if->dev_if;
+	ulong global_regs = core_if->core_global_regs;
+
+	if (dwc_otg_is_device_mode(core_if)) {
+		u32 dctl = 0;
+
+		/* Clear the Remote Wakeup Signalling */
+		dctl = DEC_DCTL_REMOTE_WAKEUP_SIG(dctl, 1);
+		dwc_reg_modify(dev_if->dev_global_regs, DWC_DCTL, dctl, 0);
+
+		if (core_if->pcd_cb && core_if->pcd_cb->resume_wakeup)
+			core_if->pcd_cb->resume_wakeup(core_if->pcd_cb->p);
+	} else {
+		u32 pcgcctl = 0;
+
+		/* Restart the Phy Clock */
+		pcgcctl = DWC_PCGCCTL_STOP_CLK_SET(pcgcctl);
+		dwc_reg_modify(core_if->pcgcctl, 0, pcgcctl, 0);
+		schedule_delayed_work(&core_if->usb_port_wakeup, 10);
+	}
+
+	/* Clear interrupt */
+	dwc_reg_write(global_regs, DWC_GINTSTS, DWC_INTSTS_WKP);
+	return 1;
+}
+
+/**
+ * This interrupt indicates that a device has been disconnected from
+ * the root port.
+ */
+static int dwc_otg_handle_disconnect_intr(struct core_if *core_if)
+{
+	ulong global_regs = core_if->core_global_regs;
+
+	if (!dwc_has_feature(core_if, DWC_HOST_ONLY)) {
+		if (core_if->xceiv->state == OTG_STATE_B_HOST) {
+			hcd_disconnect(core_if);
+			pcd_start(core_if);
+			core_if->xceiv->state = OTG_STATE_B_PERIPHERAL;
+		} else if (dwc_otg_is_device_mode(core_if)) {
+			u32 gotgctl;
+
+			gotgctl = dwc_reg_read(global_regs, DWC_GOTGCTL);
+
+			/*
+			 * If HNP is in process, do nothing.
+			 * The OTG "Host Negotiation Detected"
+			 * interrupt will do the mode switch.
+			 * Otherwise, since we are in device mode,
+			 * disconnect and stop the HCD,
+			 * then start the PCD.
+			 */
+			if ((gotgctl) & DWC_GCTL_DEV_HNP_ENA) {
+				hcd_disconnect(core_if);
+				pcd_start(core_if);
+				core_if->xceiv->state = OTG_STATE_B_PERIPHERAL;
+			}
+		} else if (core_if->xceiv->state == OTG_STATE_A_HOST) {
+			/* A-Cable still connected but device disconnected. */
+			hcd_disconnect(core_if);
+		}
+	}
+	dwc_reg_write(global_regs, DWC_GINTSTS, DWC_INTSTS_SES_DISCON_DET);
+	return 1;
+}
+
+/**
+ * This interrupt indicates that SUSPEND state has been detected on
+ * the USB.
+ *
+ * For HNP the USB Suspend interrupt signals the change from
+ * "a_peripheral" to "a_host".
+ *
+ * When power management is enabled the core will be put in low power
+ * mode.
+ */
+static int dwc_otg_handle_usb_suspend_intr(struct core_if *core_if)
+{
+	u32 dsts = 0;
+	ulong global_regs = core_if->core_global_regs;
+	struct device_if *dev_if = core_if->dev_if;
+
+	if (dwc_otg_is_device_mode(core_if)) {
+		/*
+		 * Check the Device status register to determine if the Suspend
+		 * state is active.
+		 */
+		dsts = dwc_reg_read(dev_if->dev_global_regs, DWC_DSTS);
+		/* PCD callback for suspend. */
+		pcd_suspend(core_if);
+	} else {
+		if (core_if->xceiv->state == OTG_STATE_A_PERIPHERAL) {
+			/* Clear the a_peripheral flag, back to a_host. */
+			pcd_stop(core_if);
+			hcd_start(core_if);
+			core_if->xceiv->state = OTG_STATE_A_HOST;
+		}
+	}
+
+	/* Clear interrupt */
+	dwc_reg_write(global_regs, DWC_GINTSTS, DWC_INTMSK_USB_SUSP);
+	return 1;
+}
+
+/**
+ * This function returns the Core Interrupt register.
+ *
+ * Although the Host Port interrupt (portintr) is documented as host mode
+ * only, it appears to occur in device mode when Port Enable / Disable Changed
+ * bit in HPRT0 is set. The code in dwc_otg_handle_common_intr checks if in
+ * device mode and just clears the interrupt.
+ */
+static inline u32 dwc_otg_read_common_intr(struct core_if *core_if)
+{
+	u32 gintsts;
+	u32 gintmsk;
+	u32 gintmsk_common = 0;
+	ulong global_regs = core_if->core_global_regs;
+
+	gintmsk_common = DWC_INTMSK_WKP |\
+			 DWC_INTMSK_NEW_SES_DET |\
+			 DWC_INTMSK_CON_ID_STS_CHG |\
+			 DWC_INTMSK_OTG |\
+			 DWC_INTMSK_MODE_MISMTC |\
+			 DWC_INTMSK_SES_DISCON_DET |\
+			 DWC_INTMSK_USB_SUSP |\
+			 DWC_INTMSK_HST_PORT;
+
+	gintsts = dwc_reg_read(global_regs, DWC_GINTSTS);
+	gintmsk = dwc_reg_read(global_regs, DWC_GINTMSK);
+
+	return (gintsts & gintmsk) & gintmsk_common;
+}
+
+/**
+ * Common interrupt handler.
+ *
+ * The common interrupts are those that occur in both Host and Device mode.
+ * This handler handles the following interrupts:
+ * - Mode Mismatch Interrupt
+ * - Disconnect Interrupt
+ * - OTG Interrupt
+ * - Connector ID Status Change Interrupt
+ * - Session Request Interrupt.
+ * - Resume / Remote Wakeup Detected Interrupt.
+ *
+ * - Host Port Interrupt.  Although this interrupt is documented as only
+ *   occurring in Host mode, it also occurs in Device mode when Port Enable /
+ *   Disable Changed bit in HPRT0 is set. If it is seen here, while in Device
+ *   mode, the interrupt is just cleared.
+ *
+ */
+int dwc_otg_handle_common_intr(struct core_if *core_if)
+{
+	int retval = 0;
+	u32 gintsts;
+	ulong global_regs = core_if->core_global_regs;
+
+	gintsts = dwc_otg_read_common_intr(core_if);
+
+	if (gintsts & DWC_INTSTS_MODE_MISMTC)
+		retval |= dwc_otg_handle_mode_mismatch_intr(core_if);
+	if (gintsts & DWC_INTSTS_OTG)
+		retval |= dwc_otg_handle_otg_intr(core_if);
+	if (gintsts & DWC_INTSTS_CON_ID_STS_CHG)
+		retval |= dwc_otg_handle_conn_id_status_change_intr(core_if);
+	if (gintsts & DWC_INTSTS_SES_DISCON_DET)
+		retval |= dwc_otg_handle_disconnect_intr(core_if);
+	if (gintsts & DWC_INTSTS_NEW_SES_DET)
+		retval |= dwc_otg_handle_session_req_intr(core_if);
+	if (gintsts & DWC_INTSTS_WKP)
+		retval |= dwc_otg_handle_wakeup_detected_intr(core_if);
+	if (gintsts & DWC_INTMSK_USB_SUSP)
+		retval |= dwc_otg_handle_usb_suspend_intr(core_if);
+
+	if ((gintsts & DWC_INTSTS_HST_PORT) &&
+			dwc_otg_is_device_mode(core_if)) {
+		gintsts = 0;
+		gintsts |= DWC_INTSTS_HST_PORT;
+		dwc_reg_write(global_regs, DWC_GINTSTS, gintsts);
+		retval |= 1;
+		pr_info("RECEIVED PORTINT while in Device mode\n");
+	}
+
+	return retval;
+}
-- 
1.7.0.4

