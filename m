Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1AYIF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 03:05:59 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58678 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab1AYIF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 03:05:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=baCTHAB34hHTlQxOW6TBI+cIuK7KJoPzPZhHdUaOyDFGP8yoKU3BORRVfagnPLKhLk
         7lbcZBwuKwzq8RRFTpCjr26/h50NktqYDrMhp8eKrm8vL6wBSwjO2GO9d/OXVtWyxIde
         2jTBIknVRMfBPhENmBdyqB5lkAVgEuyowumzQ=
From: "Anoop P.A" <anoop.pa@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Anoop P A <anoop.pa@gmail.com>
Subject: [PATCH 4/6] Platform support MSP onchip USB controller.
Date: Tue, 25 Jan 2011 13:52:05 +0530
Message-Id: <1295943725-20308-1-git-send-email-anoop.pa@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anoop P A <anoop.pa@gmail.com>

Following patch add platform support for onchip USB controller.

Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
 .../mips/include/asm/pmc-sierra/msp71xx/msp_regs.h |   17 +-
 arch/mips/include/asm/pmc-sierra/msp71xx/msp_usb.h |  144 ++++++++++++
 arch/mips/pmc-sierra/Kconfig                       |    5 +
 arch/mips/pmc-sierra/msp71xx/Makefile              |    2 +-
 arch/mips/pmc-sierra/msp71xx/msp_usb.c             |  239 ++++++++++++++-----
 5 files changed, 335 insertions(+), 72 deletions(-)
 create mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_usb.h

diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_regs.h b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_regs.h
index 603eb73..692c1b6 100644
--- a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_regs.h
+++ b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_regs.h
@@ -91,12 +91,10 @@
 					/* MAC C device registers       */
 #define MSP_ADSL2_BASE		(MSP_MSB_BASE + 0xA80000)
 					/* ADSL2 device registers       */
-#define MSP_USB_BASE		(MSP_MSB_BASE + 0xB40000)
-					/* USB device registers         */
-#define MSP_USB_BASE_START	(MSP_MSB_BASE + 0xB40100)
-					/* USB device registers         */
-#define MSP_USB_BASE_END	(MSP_MSB_BASE + 0xB401FF)
-					/* USB device registers         */
+#define MSP_USB0_BASE		(MSP_MSB_BASE + 0xB00000)
+					/* USB0 device registers        */
+#define MSP_USB1_BASE		(MSP_MSB_BASE + 0x300000)
+					/* USB1 device registers	*/
 #define MSP_CPUIF_BASE		(MSP_MSB_BASE + 0xC00000)
 					/* CPU interface registers      */
 
@@ -319,8 +317,11 @@
 #define CPU_ERR2_REG		regptr(MSP_SLP_BASE + 0x184)
 					/* CPU/SLP Error status 1       */
 
-#define EXTENDED_GPIO_REG	regptr(MSP_SLP_BASE + 0x188)
-					/* Extended GPIO register       */
+/* Extended GPIO registers       */
+#define EXTENDED_GPIO1_REG	regptr(MSP_SLP_BASE + 0x188)
+#define EXTENDED_GPIO2_REG	regptr(MSP_SLP_BASE + 0x18c)
+#define EXTENDED_GPIO_REG	EXTENDED_GPIO1_REG
+					/* Backward-compatibility	*/
 
 /* System Error registers */
 #define SLP_ERR_STS_REG		regptr(MSP_SLP_BASE + 0x190)
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_usb.h b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_usb.h
new file mode 100644
index 0000000..4c9348d
--- /dev/null
+++ b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_usb.h
@@ -0,0 +1,144 @@
+/******************************************************************
+ * Copyright (c) 2000-2007 PMC-Sierra INC.
+ *
+ *     This program is free software; you can redistribute it
+ *     and/or modify it under the terms of the GNU General
+ *     Public License as published by the Free Software
+ *     Foundation; either version 2 of the License, or (at your
+ *     option) any later version.
+ *
+ *     This program is distributed in the hope that it will be
+ *     useful, but WITHOUT ANY WARRANTY; without even the implied
+ *     warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
+ *     PURPOSE.  See the GNU General Public License for more
+ *     details.
+ *
+ *     You should have received a copy of the GNU General Public
+ *     License along with this program; if not, write to the Free
+ *     Software Foundation, Inc., 675 Mass Ave, Cambridge, MA
+ *     02139, USA.
+ *
+ * PMC-SIERRA INC. DISCLAIMS ANY LIABILITY OF ANY KIND
+ * FOR ANY DAMAGES WHATSOEVER RESULTING FROM THE USE OF THIS
+ * SOFTWARE.
+ */
+#ifndef MSP_USB_H_
+#define MSP_USB_H_
+
+#ifdef CONFIG_MSP_HAS_DUAL_USB
+#define NUM_USB_DEVS   2
+#else
+#define NUM_USB_DEVS   1
+#endif
+
+/* Register spaces for USB host 0 */
+#define MSP_USB0_MAB_START	(MSP_USB0_BASE + 0x0)
+#define MSP_USB0_MAB_END	(MSP_USB0_BASE + 0x17)
+#define MSP_USB0_ID_START	(MSP_USB0_BASE + 0x40000)
+#define MSP_USB0_ID_END		(MSP_USB0_BASE + 0x4008f)
+#define MSP_USB0_HS_START	(MSP_USB0_BASE + 0x40100)
+#define MSP_USB0_HS_END		(MSP_USB0_BASE + 0x401FF)
+
+/* Register spaces for USB host 1 */
+#define	MSP_USB1_MAB_START	(MSP_USB1_BASE + 0x0)
+#define MSP_USB1_MAB_END	(MSP_USB1_BASE + 0x17)
+#define MSP_USB1_ID_START	(MSP_USB1_BASE + 0x40000)
+#define MSP_USB1_ID_END		(MSP_USB1_BASE + 0x4008f)
+#define MSP_USB1_HS_START	(MSP_USB1_BASE + 0x40100)
+#define MSP_USB1_HS_END		(MSP_USB1_BASE + 0x401ff)
+
+/* USB Identification registers */
+struct msp_usbid_regs {
+	u32 id;		/* 0x0: Identification register */
+	u32 hwgen;	/* 0x4: General HW params */
+	u32 hwhost;	/* 0x8: Host HW params */
+	u32 hwdev;	/* 0xc: Device HW params */
+	u32 hwtxbuf;	/* 0x10: Tx buffer HW params */
+	u32 hwrxbuf;	/* 0x14: Rx buffer HW params */
+	u32 reserved[26];
+	u32 timer0_load; /* 0x80: General-purpose timer 0 load*/
+	u32 timer0_ctrl; /* 0x84: General-purpose timer 0 control */
+	u32 timer1_load; /* 0x88: General-purpose timer 1 load*/
+	u32 timer1_ctrl; /* 0x8c: General-purpose timer 1 control */
+};
+
+/* MSBus to AMBA registers */
+struct msp_mab_regs {
+	u32 isr;	/* 0x0: Interrupt status */
+	u32 imr;	/* 0x4: Interrupt mask */
+	u32 thcr0;	/* 0x8: Transaction header capture 0 */
+	u32 thcr1;	/* 0xc: Transaction header capture 1 */
+	u32 int_stat;	/* 0x10: Interrupt status summary */
+	u32 phy_cfg;	/* 0x14: USB phy config */
+};
+
+/* EHCI registers */
+struct msp_usbhs_regs {
+	u32 hciver;	/* 0x0: Version and offset to operational regs */
+	u32 hcsparams;	/* 0x4: Host control structural parameters */
+	u32 hccparams;	/* 0x8: Host control capability parameters */
+	u32 reserved0[5];
+	u32 dciver;	/* 0x20: Device interface version */
+	u32 dccparams;	/* 0x24: Device control capability parameters */
+	u32 reserved1[6];
+	u32 cmd;	/* 0x40: USB command */
+	u32 sts;	/* 0x44: USB status */
+	u32 int_ena;	/* 0x48: USB interrupt enable */
+	u32 frindex;	/* 0x4c: Frame index */
+	u32 reserved3;
+	union {
+		struct {
+			u32 flb_addr; /* 0x54: Frame list base address */
+			u32 next_async_addr; /* 0x58: next asynchronous addr */
+			u32 ttctrl; /* 0x5c: embedded transaction translator
+							async buffer status */
+			u32 burst_size; /* 0x60: Controller burst size */
+			u32 tx_fifo_ctrl; /* 0x64: Tx latency FIFO tuning */
+			u32 reserved0[4];
+			u32 endpt_nak; /* 0x78: Endpoint NAK */
+			u32 endpt_nak_ena; /* 0x7c: Endpoint NAK enable */
+			u32 cfg_flag; /* 0x80: Config flag */
+			u32 port_sc1; /* 0x84: Port status & control 1 */
+			u32 reserved1[7];
+			u32 otgsc;	/* 0xa4: OTG status & control */
+			u32 mode;	/* 0xa8: USB controller mode */
+		} host;
+
+		struct {
+			u32 dev_addr; /* 0x54: Device address */
+			u32 endpt_list_addr; /* 0x58: Endpoint list address */
+			u32 reserved0[7];
+			u32 endpt_nak;	/* 0x74 */
+			u32 endpt_nak_ctrl; /* 0x78 */
+			u32 cfg_flag; /* 0x80 */
+			u32 port_sc1; /* 0x84: Port status & control 1 */
+			u32 reserved[7];
+			u32 otgsc;	/* 0xa4: OTG status & control */
+			u32 mode;	/* 0xa8: USB controller mode */
+			u32 endpt_setup_stat; /* 0xac */
+			u32 endpt_prime; /* 0xb0 */
+			u32 endpt_flush; /* 0xb4 */
+			u32 endpt_stat; /* 0xb8 */
+			u32 endpt_complete; /* 0xbc */
+			u32 endpt_ctrl0; /* 0xc0 */
+			u32 endpt_ctrl1; /* 0xc4 */
+			u32 endpt_ctrl2; /* 0xc8 */
+			u32 endpt_ctrl3; /* 0xcc */
+		} device;
+	} u;
+};
+/*
+ * Container for the more-generic platform_device.
+ * This exists mainly as a way to map the non-standard register
+ * spaces and make them accessible to the USB ISR.
+ */
+struct mspusb_device {
+	struct msp_mab_regs   __iomem *mab_regs;
+	struct msp_usbid_regs __iomem *usbid_regs;
+	struct msp_usbhs_regs __iomem *usbhs_regs;
+	struct platform_device dev;
+};
+
+#define to_mspusb_device(x) container_of((x), struct mspusb_device, dev)
+#define TO_HOST_ID(x) ((x) & 0x3)
+#endif /*MSP_USB_H_*/
diff --git a/arch/mips/pmc-sierra/Kconfig b/arch/mips/pmc-sierra/Kconfig
index c139988..af41cda 100644
--- a/arch/mips/pmc-sierra/Kconfig
+++ b/arch/mips/pmc-sierra/Kconfig
@@ -27,6 +27,7 @@ config PMC_MSP7120_GW
 	select SYS_SUPPORTS_MULTITHREADING
 	select IRQ_MSP_CIC
 	select HW_HAS_PCI
+	select MSP_HAS_USB
 
 config PMC_MSP7120_FPGA
 	bool "PMC-Sierra MSP7120 FPGA"
@@ -39,3 +40,7 @@ endchoice
 config HYPERTRANSPORT
 	bool "Hypertransport Support for PMC-Sierra Yosemite"
 	depends on PMC_YOSEMITE
+
+config MSP_HAS_USB
+	boolean
+	depends on PMC_MSP
diff --git a/arch/mips/pmc-sierra/msp71xx/Makefile b/arch/mips/pmc-sierra/msp71xx/Makefile
index a002fa2..f26cab3 100644
--- a/arch/mips/pmc-sierra/msp71xx/Makefile
+++ b/arch/mips/pmc-sierra/msp71xx/Makefile
@@ -9,6 +9,6 @@ obj-$(CONFIG_IRQ_MSP_SLP) += msp_irq_slp.o
 obj-$(CONFIG_IRQ_MSP_CIC) += msp_irq_cic.o msp_irq_per.o
 obj-$(CONFIG_PCI) += msp_pci.o
 obj-$(CONFIG_MSPETH) += msp_eth.o
-obj-$(CONFIG_USB_MSP71XX) += msp_usb.o
+obj-$(CONFIG_MSP_HAS_USB) += msp_usb.o
 obj-$(CONFIG_MIPS_MT_SMP) += msp_smp.o
 obj-$(CONFIG_MIPS_MT_SMTC) += msp_smtc.o
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_usb.c b/arch/mips/pmc-sierra/msp71xx/msp_usb.c
index 0ee01e3..9a1aef8 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_usb.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_usb.c
@@ -1,7 +1,7 @@
 /*
  * The setup file for USB related hardware on PMC-Sierra MSP processors.
  *
- * Copyright 2006-2007 PMC-Sierra, Inc.
+ * Copyright 2006 PMC-Sierra, Inc.
  *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
@@ -23,8 +23,8 @@
  *  with this program; if not, write  to the Free Software Foundation, Inc.,
  *  675 Mass Ave, Cambridge, MA 02139, USA.
  */
+#if defined(CONFIG_USB_EHCI_HCD) || defined(CONFIG_USB_GADGET)
 
-#include <linux/dma-mapping.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
@@ -34,40 +34,56 @@
 #include <msp_regs.h>
 #include <msp_int.h>
 #include <msp_prom.h>
+#include <msp_usb.h>
+
 
 #if defined(CONFIG_USB_EHCI_HCD)
-static struct resource msp_usbhost_resources [] = {
-	[0] = {
-		.start	= MSP_USB_BASE_START,
-		.end	= MSP_USB_BASE_END,
-		.flags 	= IORESOURCE_MEM,
+static struct resource msp_usbhost0_resources[] = {
+	[0] = { /* EHCI-HS operational and capabilities registers */
+		.start  = MSP_USB0_HS_START,
+		.end    = MSP_USB0_HS_END,
+		.flags  = IORESOURCE_MEM,
 	},
 	[1] = {
-		.start	= MSP_INT_USB,
-		.end	= MSP_INT_USB,
-		.flags	= IORESOURCE_IRQ,
+		.start  = MSP_INT_USB,
+		.end    = MSP_INT_USB,
+		.flags  = IORESOURCE_IRQ,
+	},
+	[2] = { /* MSBus-to-AMBA bridge register space */
+		.start	= MSP_USB0_MAB_START,
+		.end	= MSP_USB0_MAB_END,
+		.flags	= IORESOURCE_MEM,
+	},
+	[3] = { /* Identification and general hardware parameters */
+		.start	= MSP_USB0_ID_START,
+		.end	= MSP_USB0_ID_END,
+		.flags	= IORESOURCE_MEM,
 	},
 };
 
-static u64 msp_usbhost_dma_mask = DMA_BIT_MASK(32);
+static u64 msp_usbhost0_dma_mask = 0xffffffffUL;
 
-static struct platform_device msp_usbhost_device = {
-	.name	= "pmcmsp-ehci",
-	.id	= 0,
+static struct mspusb_device msp_usbhost0_device = {
 	.dev	= {
-		.dma_mask = &msp_usbhost_dma_mask,
-		.coherent_dma_mask = DMA_BIT_MASK(32),
+		.name	= "pmcmsp-ehci",
+		.id	= 0,
+		.dev	= {
+			.dma_mask = &msp_usbhost0_dma_mask,
+			.coherent_dma_mask = 0xffffffffUL,
+		},
+		.num_resources  = ARRAY_SIZE(msp_usbhost0_resources),
+		.resource       = msp_usbhost0_resources,
 	},
-	.num_resources 	= ARRAY_SIZE(msp_usbhost_resources),
-	.resource	= msp_usbhost_resources,
 };
-#endif /* CONFIG_USB_EHCI_HCD */
 
-#if defined(CONFIG_USB_GADGET)
-static struct resource msp_usbdev_resources [] = {
-	[0] = {
-		.start	= MSP_USB_BASE,
-		.end	= MSP_USB_BASE_END,
+/* MSP7140/MSP82XX has two USB2 hosts. */
+#ifdef CONFIG_MSP_HAS_DUAL_USB
+static u64 msp_usbhost1_dma_mask = 0xffffffffUL;
+
+static struct resource msp_usbhost1_resources[] = {
+	[0] = { /* EHCI-HS operational and capabilities registers */
+		.start	= MSP_USB1_HS_START,
+		.end	= MSP_USB1_HS_END,
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
@@ -75,76 +91,173 @@ static struct resource msp_usbdev_resources [] = {
 		.end	= MSP_INT_USB,
 		.flags	= IORESOURCE_IRQ,
 	},
+	[2] = { /* MSBus-to-AMBA bridge register space */
+		.start	= MSP_USB1_MAB_START,
+		.end	= MSP_USB1_MAB_END,
+		.flags	= IORESOURCE_MEM,
+	},
+	[3] = { /* Identification and general hardware parameters */
+		.start	= MSP_USB1_ID_START,
+		.end	= MSP_USB1_ID_END,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct mspusb_device msp_usbhost1_device = {
+	.dev	= {
+		.name	= "pmcmsp-ehci",
+		.id	= 1,
+		.dev	= {
+			.dma_mask = &msp_usbhost1_dma_mask,
+			.coherent_dma_mask = 0xffffffffUL,
+		},
+		.num_resources	= ARRAY_SIZE(msp_usbhost1_resources),
+		.resource	= msp_usbhost1_resources,
+	},
 };
+#endif /* CONFIG_MSP_HAS_DUAL_USB */
+#endif /* CONFIG_USB_EHCI_HCD */
 
-static u64 msp_usbdev_dma_mask = DMA_BIT_MASK(32);
+#if defined(CONFIG_USB_GADGET)
+static struct resource msp_usbdev0_resources[] = {
+	[0] = { /* EHCI-HS operational and capabilities registers */
+		.start  = MSP_USB0_HS_START,
+		.end    = MSP_USB0_HS_END,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = MSP_INT_USB,
+		.end    = MSP_INT_USB,
+		.flags  = IORESOURCE_IRQ,
+	},
+	[2] = { /* MSBus-to-AMBA bridge register space */
+		.start	= MSP_USB0_MAB_START,
+		.end	= MSP_USB0_MAB_END,
+		.flags	= IORESOURCE_MEM,
+	},
+	[3] = { /* Identification and general hardware parameters */
+		.start	= MSP_USB0_ID_START,
+		.end	= MSP_USB0_ID_END,
+		.flags	= IORESOURCE_MEM,
+	},
+};
 
-static struct platform_device msp_usbdev_device = {
-	.name	= "msp71xx_udc",
-	.id	= 0,
+static u64 msp_usbdev_dma_mask = 0xffffffffUL;
+
+/* This may need to be converted to a mspusb_device, too. */
+static struct mspusb_device msp_usbdev0_device = {
 	.dev	= {
-		.dma_mask = &msp_usbdev_dma_mask,
-		.coherent_dma_mask = DMA_BIT_MASK(32),
+		.name	= "msp71xx_udc",
+		.id	= 0,
+		.dev	= {
+			.dma_mask = &msp_usbdev_dma_mask,
+			.coherent_dma_mask = 0xffffffffUL,
+		},
+		.num_resources  = ARRAY_SIZE(msp_usbdev0_resources),
+		.resource       = msp_usbdev0_resources,
 	},
-	.num_resources	= ARRAY_SIZE(msp_usbdev_resources),
-	.resource	= msp_usbdev_resources,
 };
-#endif /* CONFIG_USB_GADGET */
 
-#if defined(CONFIG_USB_EHCI_HCD) || defined(CONFIG_USB_GADGET)
-static struct platform_device *msp_devs[1];
-#endif
+#ifdef CONFIG_MSP_HAS_DUAL_USB
+static struct resource msp_usbdev1_resources[] = {
+	[0] = { /* EHCI-HS operational and capabilities registers */
+		.start  = MSP_USB1_HS_START,
+		.end    = MSP_USB1_HS_END,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = MSP_INT_USB,
+		.end    = MSP_INT_USB,
+		.flags  = IORESOURCE_IRQ,
+	},
+	[2] = { /* MSBus-to-AMBA bridge register space */
+		.start	= MSP_USB1_MAB_START,
+		.end	= MSP_USB1_MAB_END,
+		.flags	= IORESOURCE_MEM,
+	},
+	[3] = { /* Identification and general hardware parameters */
+		.start	= MSP_USB1_ID_START,
+		.end	= MSP_USB1_ID_END,
+		.flags	= IORESOURCE_MEM,
+	},
+};
 
+/* This may need to be converted to a mspusb_device, too. */
+static struct mspusb_device msp_usbdev1_device = {
+	.dev	= {
+		.name	= "msp71xx_udc",
+		.id	= 0,
+		.dev	= {
+			.dma_mask = &msp_usbdev_dma_mask,
+			.coherent_dma_mask = 0xffffffffUL,
+		},
+		.num_resources  = ARRAY_SIZE(msp_usbdev1_resources),
+		.resource       = msp_usbdev1_resources,
+	},
+};
+
+#endif /* CONFIG_MSP_HAS_DUAL_USB */
+#endif /* CONFIG_USB_GADGET */
 
 static int __init msp_usb_setup(void)
 {
-#if defined(CONFIG_USB_EHCI_HCD) || defined(CONFIG_USB_GADGET)
-	char *strp;
-	char envstr[32];
-	unsigned int val = 0;
-	int result = 0;
+	char		*strp;
+	char		envstr[32];
+	struct platform_device *msp_devs[NUM_USB_DEVS];
+	unsigned int val;
 
+	/* construct environment name usbmode */
+	/* set usbmode <host/device> as pmon environment var */
 	/*
-	 * construct environment name usbmode
-	 * set usbmode <host/device> as pmon environment var
+	 * Could this perhaps be integrated into the "features" env var?
+	 * Use the features key "U", and follow with "H" for host-mode,
+	 * "D" for device-mode.  If it works for Ethernet, why not USB...
+	 *  -- hammtrev, 2007/03/22
 	 */
 	snprintf((char *)&envstr[0], sizeof(envstr), "usbmode");
 
-#if defined(CONFIG_USB_EHCI_HCD)
-	/* default to host mode */
+	/* set default host mode */
 	val = 1;
-#endif
 
 	/* get environment string */
 	strp = prom_getenv((char *)&envstr[0]);
 	if (strp) {
+		/* compare string */
 		if (!strcmp(strp, "device"))
 			val = 0;
 	}
 
 	if (val) {
 #if defined(CONFIG_USB_EHCI_HCD)
-		/* get host mode device */
-		msp_devs[0] = &msp_usbhost_device;
-		ppfinit("platform add USB HOST done %s.\n",
-			    msp_devs[0]->name);
-
-		result = platform_add_devices(msp_devs, ARRAY_SIZE(msp_devs));
-#endif /* CONFIG_USB_EHCI_HCD */
-	}
+		msp_devs[0] = &msp_usbhost0_device.dev;
+		ppfinit("platform add USB HOST done %s.\n", msp_devs[0]->name);
+#ifdef CONFIG_MSP_HAS_DUAL_USB
+		msp_devs[1] = &msp_usbhost1_device.dev;
+		ppfinit("platform add USB HOST done %s.\n", msp_devs[1]->name);
+#endif
+#else
+		ppfinit("%s: echi_hcd not supported\n", __FILE__);
+#endif  /* CONFIG_USB_EHCI_HCD */
+	} else {
 #if defined(CONFIG_USB_GADGET)
-	else {
 		/* get device mode structure */
-		msp_devs[0] = &msp_usbdev_device;
-		ppfinit("platform add USB DEVICE done %s.\n",
-			    msp_devs[0]->name);
-
-		result = platform_add_devices(msp_devs, ARRAY_SIZE(msp_devs));
+		msp_devs[0] = &msp_usbdev0_device.dev;
+		ppfinit("platform add USB DEVICE done %s.\n"
+					, msp_devs[0]->name);
+#ifdef CONFIG_MSP_HAS_DUAL_USB
+		msp_devs[1] = &msp_usbdev1_device.dev;
+		ppfinit("platform add USB DEVICE done %s.\n"
+					, msp_devs[1]->name);
+#endif
+#else
+		ppfinit("%s: usb_gadget not supported\n", __FILE__);
+#endif  /* CONFIG_USB_GADGET */
 	}
-#endif /* CONFIG_USB_GADGET */
-#endif /* CONFIG_USB_EHCI_HCD || CONFIG_USB_GADGET */
+	/* add device */
+	platform_add_devices(msp_devs, ARRAY_SIZE(msp_devs));
 
-	return result;
+	return 0;
 }
 
 subsys_initcall(msp_usb_setup);
+#endif /* CONFIG_USB_EHCI_HCD || CONFIG_USB_GADGET */
-- 
1.7.0.4

