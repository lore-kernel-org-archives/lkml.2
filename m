Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab0LUK7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 05:59:21 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35040 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab0LUK7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 05:59:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nJIjTN2eLyaOz5YGiQU/7ENJpyIHfakQIuGVDmSLg/e70Ja7FPd0+p7mUIpjFN4o9W
         3z1exqhnhHFE1tXwu3IGlYe7wvJ7My7ZXoiOlosF+dzqZE6d/WqEy4LKh1EdWO2NJmfx
         F+TJMEZwuTQpQv0xI1YOVQpYByqDrDgCmyFBM=
From: Anoop P <anoop.pa@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, gregkh@suse.de,
        dbrownell@users.sourceforge.net, stern@rowland.harvard.edu,
        sarah.a.sharp@linux.intel.com, andiry.xu@amd.com, agust@denx.de,
        ddaney@caviumnetworks.com, gadiyar@ti.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: Anoop P A <anoop.pa@gmail.com>
Subject: [PATCH] EHCI support for on-chip PMC MSP USB controller.
Date: Tue, 21 Dec 2010 16:36:20 +0530
Message-Id: <1292929580-5829-1-git-send-email-anoop.pa@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anoop P A <anoop.pa@gmail.com>

This patch includes.

1. USB host driver for MSP71xx family SoC on-chip USB controller.
2. Platform support for USB controller.

Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
 .../mips/include/asm/pmc-sierra/msp71xx/msp_regs.h |   17 +-
 arch/mips/include/asm/pmc-sierra/msp71xx/msp_usb.h |  144 +++++
 arch/mips/pmc-sierra/Kconfig                       |    8 +
 arch/mips/pmc-sierra/msp71xx/Makefile              |    2 +-
 arch/mips/pmc-sierra/msp71xx/msp_usb.c             |  239 +++++++---
 drivers/usb/core/hub.c                             |   31 ++
 drivers/usb/host/Kconfig                           |   15 +-
 drivers/usb/host/ehci-hcd.c                        |   12 +
 drivers/usb/host/ehci-pmcmsp.c                     |  555 ++++++++++++++++++++
 9 files changed, 949 insertions(+), 74 deletions(-)
 create mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_usb.h
 create mode 100644 drivers/usb/host/ehci-pmcmsp.c

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
index 8d79849..a80ad25 100644
--- a/arch/mips/pmc-sierra/Kconfig
+++ b/arch/mips/pmc-sierra/Kconfig
@@ -23,6 +23,7 @@ config PMC_MSP7120_GW
 	select SYS_SUPPORTS_MULTITHREADING
 	select IRQ_MSP_CIC
 	select HW_HAS_PCI
+	select MSP_HAS_USB
 
 config PMC_MSP7120_FPGA
 	bool "PMC-Sierra MSP7120 FPGA"
@@ -35,3 +36,10 @@ endchoice
 config HYPERTRANSPORT
 	bool "Hypertransport Support for PMC-Sierra Yosemite"
 	depends on PMC_YOSEMITE
+
+
+config MSP_HAS_USB
+	boolean
+	depends on PMC_MSP
+	select USB_ARCH_HAS_EHCI
+	select USB_ARCH_HAS_HCD
diff --git a/arch/mips/pmc-sierra/msp71xx/Makefile b/arch/mips/pmc-sierra/msp71xx/Makefile
index 09627ae..380d39d 100644
--- a/arch/mips/pmc-sierra/msp71xx/Makefile
+++ b/arch/mips/pmc-sierra/msp71xx/Makefile
@@ -9,5 +9,5 @@ obj-$(CONFIG_IRQ_MSP_SLP) += msp_irq_slp.o
 obj-$(CONFIG_IRQ_MSP_CIC) += msp_irq_cic.o msp_irq_per.o
 obj-$(CONFIG_PCI) += msp_pci.o
 obj-$(CONFIG_MSPETH) += msp_eth.o
-obj-$(CONFIG_USB_MSP71XX) += msp_usb.o
+obj-$(CONFIG_MSP_HAS_USB) += msp_usb.o
 obj-$(CONFIG_MIPS_MT_SMP) += msp_smp.o
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
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 27115b4..f2a45ba 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3377,12 +3377,43 @@ static void hub_events(void)
 			}
 			
 			if (portchange & USB_PORT_STAT_C_OVERCURRENT) {
+#ifdef CONFIG_USB_EHCI_HCD_PMC_MSP
+#define OVER_CURR_DELAY 100
+				/* clear OCC bit */
+				clear_port_feature(hdev, i,
+					USB_PORT_FEAT_C_OVER_CURRENT);
+
+				/* This step is required to toggle the PP bit
+				 * to 0 and 1 (by hub_power_on) in order the
+				 * CSC bit to be transitioned
+				 * properly for device hotplug
+				 */
+				/* clear PP bit */
+				clear_port_feature(hdev, i,
+				USB_PORT_FEAT_POWER);
+
+				/* resume power */
+				hub_power_on(hub, true);
+
+				/* delay 100 usec */
+				udelay(OVER_CURR_DELAY);
+
+				/* read OCA bit */
+				if (portstatus &
+					(1<<USB_PORT_FEAT_OVER_CURRENT)) {
+					/* declare overcurrent */
+					dev_err(hub_dev,
+						"over-current change on port %d\n",
+						i);
+				}
+#else
 				dev_err (hub_dev,
 					"over-current change on port %d\n",
 					i);
 				clear_port_feature(hdev, i,
 					USB_PORT_FEAT_C_OVER_CURRENT);
 				hub_power_on(hub, true);
+#endif
 			}
 
 			if (portchange & USB_PORT_STAT_C_RESET) {
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 2391c39..bc955d0 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -91,17 +91,28 @@ config USB_EHCI_TT_NEWSCHED
 
 	  If unsure, say Y.
 
+config USB_EHCI_HCD_PMC_MSP
+	tristate "EHCI support for on-chip PMC MSP USB controller"
+	depends on USB_EHCI_HCD && MSP_HAS_USB
+	default y
+	select USB_EHCI_BIG_ENDIAN_DESC
+	select USB_EHCI_BIG_ENDIAN_MMIO
+	---help---
+		Enables support for the onchip USB controller on the PMC_MSP7100 Family SoC's.
+		If unsure, say N.
+
 config USB_EHCI_BIG_ENDIAN_MMIO
 	bool
 	depends on USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || \
 				    ARCH_IXP4XX || XPS_USB_HCD_XILINX || \
-				    PPC_MPC512x || CPU_CAVIUM_OCTEON)
+				    PPC_MPC512x || CPU_CAVIUM_OCTEON || \
+				    MSP_HAS_USB)
 	default y
 
 config USB_EHCI_BIG_ENDIAN_DESC
 	bool
 	depends on USB_EHCI_HCD && (440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX || \
-				    PPC_MPC512x)
+				    PPC_MPC512x || MSP_HAS_USB)
 	default y
 
 config XPS_USB_HCD_XILINX
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 502a7e6..833d96a 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -120,6 +120,9 @@ MODULE_PARM_DESC(hird, "host initiated resume duration, +1 for each 75us\n");
 #include "ehci-dbg.c"
 
 /*-------------------------------------------------------------------------*/
+#ifdef CONFIG_USB_EHCI_HCD_PMC_MSP
+extern void usb_hcd_tdi_set_mode(struct ehci_hcd *ehci);
+#endif
 
 static void
 timer_action(struct ehci_hcd *ehci, enum ehci_timer_action action)
@@ -259,6 +262,10 @@ static void tdi_reset (struct ehci_hcd *ehci)
 	if (ehci_big_endian_mmio(ehci))
 		tmp |= USBMODE_BE;
 	ehci_writel(ehci, tmp, reg_ptr);
+#ifdef CONFIG_USB_EHCI_HCD_PMC_MSP
+	/* set controller in host mode */
+	usb_hcd_tdi_set_mode(ehci);
+#endif
 }
 
 /* reset a non-running (STS_HALT == 1) controller */
@@ -1216,6 +1223,11 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ehci_octeon_driver
 #endif
 
+#ifdef CONFIG_USB_EHCI_HCD_PMC_MSP
+#include "ehci-pmcmsp.c"
+#define	PLATFORM_DRIVER		ehci_hcd_msp_driver
+#endif
+
 #if !defined(PCI_DRIVER) && !defined(PLATFORM_DRIVER) && \
     !defined(PS3_SYSTEM_BUS_DRIVER) && !defined(OF_PLATFORM_DRIVER) && \
     !defined(XILINX_OF_PLATFORM_DRIVER)
diff --git a/drivers/usb/host/ehci-pmcmsp.c b/drivers/usb/host/ehci-pmcmsp.c
new file mode 100644
index 0000000..b1b4f21
--- /dev/null
+++ b/drivers/usb/host/ehci-pmcmsp.c
@@ -0,0 +1,555 @@
+/*
+ * PMC MSP EHCI (Host Controller Driver) for USB.
+ *
+ * (C) Copyright 2006 PMC-Sierra Inc
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ * WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ * NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ * USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You should have received a copy of the  GNU General Public License along
+ * with this program; if not, write  to the Free Software Foundation, Inc.,
+ * 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <msp_usb.h>
+
+/* includes */
+#define USB_CTRL_MODE_HOST		0x3
+					/* host mode */
+#define USB_CTRL_MODE_BIG_ENDIAN	0x4
+					/* big endian */
+#define USB_CTRL_MODE_STREAM_DISABLE	0x10
+					/* stream disable*/
+#define USB_CTRL_FIFO_THRESH		0x00300000
+					/* thresh hold */
+#define USB_EHCI_REG_USB_MODE		0x68
+					/* register offset for usb_mode */
+#define USB_EHCI_REG_USB_FIFO		0x24
+					/* register offset for usb fifo */
+#define USB_EHCI_REG_USB_STATUS		0x44
+					/* register offset for usb status */
+#define USB_EHCI_REG_BIT_STAT_STS	(1<<29)
+					/* serial/parallel transceiver */
+#define MSP_PIN_USB0_HOST_DEV		49
+					/* TWI USB0 host device pin */
+#define MSP_PIN_USB1_HOST_DEV		50
+					/* TWI USB1 host device pin */
+
+extern int usb_disabled(void);
+
+void usb_hcd_tdi_set_mode(struct ehci_hcd *ehci)
+{
+	u8 *base;
+	u8 *statreg;
+	u8 *fiforeg;
+	u32 val;
+	struct ehci_regs *reg_base = ehci->regs;
+
+	/* get register base */
+	base = (u8 *)reg_base + USB_EHCI_REG_USB_MODE;
+	statreg = (u8 *)reg_base + USB_EHCI_REG_USB_STATUS;
+	fiforeg = (u8 *)reg_base + USB_EHCI_REG_USB_FIFO;
+
+	/* set the controller to host mode and BIG ENDIAN */
+	ehci_writel(ehci, (USB_CTRL_MODE_HOST | USB_CTRL_MODE_BIG_ENDIAN
+		| USB_CTRL_MODE_STREAM_DISABLE), (u32 *)base);
+
+	/* clear STS to select parallel transceiver interface */
+	val = ehci_readl(ehci, (u32 *)statreg);
+	val = val & ~USB_EHCI_REG_BIT_STAT_STS;
+	ehci_writel(ehci, val, (u32 *)statreg);
+
+	/* write to set the proper fifo threshold */
+	ehci_writel(ehci, USB_CTRL_FIFO_THRESH, (u32 *)fiforeg);
+
+	/* set TWI GPIO USB_HOST_DEV pin high */
+	gpio_direction_output(MSP_PIN_USB0_HOST_DEV, 1);
+#ifdef CONFIG_MSP_HAS_DUAL_USB
+	gpio_direction_output(MSP_PIN_USB1_HOST_DEV, 1);
+#endif
+}
+
+/* called after powerup, by probe or system-pm "wakeup" */
+static int ehci_msp_reinit(struct ehci_hcd *ehci)
+{
+	ehci_port_power(ehci, 0);
+
+	return 0;
+}
+
+/* called during probe() after chip reset completes */
+static int ehci_msp_setup(struct usb_hcd *hcd)
+{
+	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
+	u32			temp;
+	int			retval;
+#if 1
+	ehci->big_endian_mmio = 1;
+	ehci->big_endian_desc = 1;
+
+	ehci->caps = hcd->regs;
+	ehci->regs = hcd->regs +
+			HC_LENGTH(ehci_readl(ehci, &ehci->caps->hc_capbase));
+	dbg_hcs_params(ehci, "reset");
+	dbg_hcc_params(ehci, "reset");
+
+	/* cache this readonly data; minimize chip reads */
+	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
+#endif
+	hcd->has_tt = 1;
+	tdi_reset(ehci);
+
+	retval = ehci_halt(ehci);
+	if (retval)
+		return retval;
+
+	ehci_reset(ehci);
+
+	/* data structure init */
+	retval = ehci_init(hcd);
+	if (retval)
+		return retval;
+
+	temp = HCS_N_CC(ehci->hcs_params) * HCS_N_PCC(ehci->hcs_params);
+	temp &= 0x0f;
+	if (temp && HCS_N_PORTS(ehci->hcs_params) > temp) {
+		ehci_dbg(ehci, "bogus port configuration: "
+			"cc=%d x pcc=%d < ports=%d\n",
+			HCS_N_CC(ehci->hcs_params),
+			HCS_N_PCC(ehci->hcs_params),
+			HCS_N_PORTS(ehci->hcs_params));
+	}
+
+	retval = ehci_msp_reinit(ehci);
+
+	return retval;
+}
+
+/*-------------------------------------------------------------------------*/
+
+#ifdef	CONFIG_PM
+
+/* suspend/resume, section 4.3 */
+
+/* These routines rely on the bus glue
+ * to handle powerdown and wakeup, and currently also on
+ * transceivers that don't need any software attention to set up
+ * the right sort of wakeup.
+ * Also they depend on separate root hub suspend/resume.
+ */
+
+static int ehci_msp_suspend(struct usb_hcd *hcd, pm_message_t message)
+{
+	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
+	unsigned long		flags;
+	int			rc = 0;
+
+	if (time_before(jiffies, ehci->next_statechange))
+		msleep(10);
+
+	/* Root hub was already suspended. Disable irq emission and
+	 * mark HW unaccessible, bail out if RH has been resumed. Use
+	 * the spinlock to properly synchronize with possible pending
+	 * RH suspend or resume activity.
+	 *
+	 * This is still racy as hcd->state is manipulated outside of
+	 * any locks =P But that will be a different fix.
+	 */
+	spin_lock_irqsave(&ehci->lock, flags);
+	if (hcd->state != HC_STATE_SUSPENDED) {
+		rc = -EINVAL;
+		goto bail;
+	}
+	ehci_writel(ehci, 0, &ehci->regs->intr_enable);
+	(void)ehci_readl(ehci, &ehci->regs->intr_enable);
+
+	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
+ bail:
+	spin_unlock_irqrestore(&ehci->lock, flags);
+
+	/* could save FLADJ in case of Vaux power loss
+	... we'd only use it to handle clock skew */
+
+	return rc;
+}
+
+static int ehci_msp_resume(struct usb_hcd *hcd)
+{
+	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
+	unsigned		port;
+	struct usb_device	*root = hcd->self.root_hub;
+	int			retval = -EINVAL;
+
+	/* maybe restore FLADJ */
+
+	if (time_before(jiffies, ehci->next_statechange))
+		msleep(100);
+
+	/* Mark hardware accessible again as we are out of D3 state by now */
+	set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
+
+	/* If CF is clear, we lost PCI Vaux power and need to restart.  */
+	if (ehci_readl(ehci, &ehci->regs->configured_flag) != FLAG_CF)
+		goto restart;
+
+	/* If any port is suspended (or owned by the companion),
+	 * we know we can/must resume the HC (and mustn't reset it).
+	 * We just defer that to the root hub code.
+	 */
+	for (port = HCS_N_PORTS(ehci->hcs_params); port > 0; ) {
+		u32	status;
+		port--;
+		status = ehci_readl(ehci, &ehci->regs->port_status[port]);
+		if (!(status & PORT_POWER))
+			continue;
+		if (status & (PORT_SUSPEND | PORT_RESUME | PORT_OWNER)) {
+			usb_hcd_resume_root_hub(hcd);
+			return 0;
+		}
+	}
+
+restart:
+	ehci_dbg(ehci, "lost power, restarting\n");
+	for (port = HCS_N_PORTS(ehci->hcs_params); port > 0; ) {
+		port--;
+		if (!root->children[port])
+			continue;
+		usb_set_device_state(root->children[port],
+					USB_STATE_NOTATTACHED);
+	}
+
+	/* Else reset, to cope with power loss or flush-to-storage
+	 * style "resume" having let BIOS kick in during reboot.
+	 */
+	(void) ehci_halt(ehci);
+	(void) ehci_reset(ehci);
+	(void) ehci_msp_reinit(ehci, pdev);
+
+	/* emptying the schedule aborts any urbs */
+	spin_lock_irq(&ehci->lock);
+	if (ehci->reclaim)
+		ehci->reclaim_ready = 1;
+	ehci_work(ehci, NULL);
+	spin_unlock_irq(&ehci->lock);
+
+	/* restart; khubd will disconnect devices */
+	retval = ehci_run(hcd);
+
+	/* here we "know" root ports should always stay powered */
+	ehci_port_power(ehci, 1);
+
+	return retval;
+}
+#endif
+
+/*-------------------------------------------------------------------------*/
+
+static void msp_start_hc(struct platform_device *dev)
+{
+	printk(KERN_DEBUG __FILE__
+		   ": starting PMC MSP EHCI USB Controller\n");
+
+	/*
+	 * Now, carefully enable the USB clock, and take
+	 * the USB host controller out of reset.
+	 */
+	printk(KERN_DEBUG __FILE__
+			": Clock to USB host has been enabled\n");
+}
+
+static void msp_stop_hc(struct platform_device *dev)
+{
+	printk(KERN_DEBUG __FILE__
+		   ": stopping PMC MSP EHCI USB Controller\n");
+}
+
+
+/*-------------------------------------------------------------------------*/
+
+/* configure so an HC device and id are always provided */
+/* always called with process context; sleeping is OK */
+
+static int usb_hcd_msp_map_regs(struct mspusb_device *dev)
+{
+	struct resource *res;
+	struct platform_device *pdev = &dev->dev;
+	u32 res_len;
+	int retval;
+
+	/* MAB register space */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (res == NULL)
+		return -ENOMEM;
+	res_len = res->end - res->start + 1;
+	if (!request_mem_region(res->start, res_len, "mab regs"))
+		return -EBUSY;
+
+	dev->mab_regs = ioremap_nocache(res->start, res_len);
+	if (dev->mab_regs == NULL) {
+		retval = -ENOMEM;
+		goto err1;
+	}
+
+	/* MSP USB register space */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+	if (res == NULL) {
+		retval = -ENOMEM;
+		goto err2;
+	}
+	res_len = res->end - res->start + 1;
+	if (!request_mem_region(res->start, res_len, "usbid regs")) {
+		retval = -EBUSY;
+		goto err2;
+	}
+	dev->usbid_regs = ioremap_nocache(res->start, res_len);
+	if (dev->usbid_regs == NULL) {
+		retval = -ENOMEM;
+		goto err3;
+	}
+
+	return 0;
+err3:
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+	res_len = res->end - res->start + 1;
+	release_mem_region(res->start, res_len);
+err2:
+	iounmap(dev->mab_regs);
+err1:
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	res_len = res->end - res->start + 1;
+	release_mem_region(res->start, res_len);
+	dev_err(&pdev->dev, "Failed to map non-EHCI regs.\n");
+	return retval;
+}
+
+/**
+ * usb_hcd_msp_probe - initialize PMC MSP-based HCDs
+ * Context: !in_interrupt()
+ *
+ * Allocates basic resources for this USB host controller, and
+ * then invokes the start() method for the HCD associated with it
+ * through the hotplug entry's driver_data.
+ *
+ */
+int usb_hcd_msp_probe(const struct hc_driver *driver,
+			  struct platform_device *dev)
+{
+	int retval;
+	struct usb_hcd *hcd;
+	struct resource *res;
+	struct ehci_hcd		*ehci ;
+
+	hcd = usb_create_hcd(driver, &dev->dev, "pmcmsp");
+	if (!hcd)
+		return -ENOMEM;
+
+	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		pr_debug("No IOMEM resource info for %s.\n", dev->name);
+		retval = -ENOMEM;
+		goto err1;
+	}
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = res->end - res->start + 1;
+	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, dev->name)) {
+		retval = -EBUSY;
+		goto err1;
+	}
+	hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
+	if (!hcd->regs) {
+		pr_debug("ioremap failed");
+		retval = -ENOMEM;
+		goto err2;
+	}
+	msp_start_hc(dev);
+
+	res = platform_get_resource(dev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		dev_err(&dev->dev, "No IRQ resource info for %s.\n", dev->name);
+		retval = -ENOMEM;
+		goto err3;
+	}
+
+	/* Map non-EHCI register spaces */
+	retval = usb_hcd_msp_map_regs(to_mspusb_device(dev));
+	if (retval != 0)
+		goto err3;
+
+	ehci = hcd_to_ehci(hcd);
+	ehci->big_endian_mmio = 1;
+	ehci->big_endian_desc = 1;
+
+
+	retval = usb_add_hcd(hcd, res->start, IRQF_SHARED);
+	if (retval == 0)
+		return 0;
+
+	usb_remove_hcd(hcd);
+err3:
+	msp_stop_hc(dev);
+	iounmap(hcd->regs);
+err2:
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
+err1:
+	usb_put_hcd(hcd);
+
+	return retval;
+}
+
+
+/* may be called without controller electrically present */
+/* may be called with controller, bus, and devices active */
+
+/**
+ * usb_hcd_msp_remove - shutdown processing for PMC MSP-based HCDs
+ * @dev: USB Host Controller being removed
+ * Context: !in_interrupt()
+ *
+ * Reverses the effect of usb_hcd_msp_probe(), first invoking
+ * the HCD's stop() method.  It is always called from a thread
+ * context, normally "rmmod", "apmd", or something similar.
+ *
+ */
+void usb_hcd_msp_remove(struct usb_hcd *hcd, struct platform_device *dev)
+{
+	usb_remove_hcd(hcd);
+	msp_stop_hc(dev);
+	iounmap(hcd->regs);
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
+	usb_put_hcd(hcd);
+}
+
+#ifdef CONFIG_MSP_HAS_DUAL_USB
+/*-------------------------------------------------------------------------*/
+/*
+ * Wrapper around the main ehci_irq.  Since both USB host controllers are
+ * sharing the same IRQ, need to first determine whether we're the intended
+ * recipient of this interrupt.
+ */
+static irqreturn_t ehci_msp_irq(struct usb_hcd *hcd)
+{
+	u32 int_src;
+	struct device *dev = hcd->self.controller;
+	struct platform_device *pdev;
+	struct mspusb_device *mdev;
+	struct ehci_hcd	*ehci = hcd_to_ehci(hcd);
+
+	/* need to reverse-map a couple of containers to get our device */
+	pdev = to_platform_device(dev);
+	mdev = to_mspusb_device(pdev);
+
+	/* Check to see if this interrupt is for this host controller */
+	int_src = ehci_readl(ehci, &mdev->mab_regs->int_stat);
+	if (int_src & (1 << pdev->id))
+		return ehci_irq(hcd);
+
+	/* Not for this device */
+	return IRQ_NONE;
+}
+/*-------------------------------------------------------------------------*/
+#endif /* DUAL_USB */
+
+static const struct hc_driver ehci_msp_hc_driver = {
+	.description =		hcd_name,
+	.product_desc =		"PMC MSP EHCI",
+	.hcd_priv_size =	sizeof(struct ehci_hcd),
+
+	/*
+	 * generic hardware linkage
+	 */
+#ifdef CONFIG_MSP_HAS_DUAL_USB
+	.irq =			ehci_msp_irq,
+#else
+	.irq =			ehci_irq,
+#endif
+	.flags =		HCD_MEMORY | HCD_USB2,
+
+	/*
+	 * basic lifecycle operations
+	 */
+	.reset =		ehci_msp_setup,
+	.start =		ehci_run,
+#ifdef	CONFIG_PM
+	.suspend =		ehci_msp_suspend,
+	.resume =		ehci_msp_resume,
+#endif /*CONFIG_PM*/
+	.stop =			ehci_stop,
+
+	/*
+	 * managing i/o requests and associated device resources
+	 */
+	.urb_enqueue =		ehci_urb_enqueue,
+	.urb_dequeue =		ehci_urb_dequeue,
+	.endpoint_disable =	ehci_endpoint_disable,
+
+	/*
+	 * scheduling support
+	 */
+	.get_frame_number =	ehci_get_frame,
+
+	/*
+	 * root hub support
+	 */
+	.hub_status_data =	ehci_hub_status_data,
+	.hub_control =		ehci_hub_control,
+};
+
+/*-------------------------------------------------------------------------*/
+
+static int ehci_hcd_msp_drv_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	pr_debug("In ehci_hcd_msp_drv_probe");
+
+	if (usb_disabled())
+		return -ENODEV;
+
+	gpio_request(MSP_PIN_USB0_HOST_DEV, "USB0_HOST_DEV_GPIO");
+#ifdef CONFIG_MSP_HAS_DUAL_USB
+	gpio_request(MSP_PIN_USB1_HOST_DEV, "USB1_HOST_DEV_GPIO");
+#endif
+
+	ret = usb_hcd_msp_probe(&ehci_msp_hc_driver, pdev);
+
+	return ret;
+}
+
+static int ehci_hcd_msp_drv_remove(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+
+	usb_hcd_msp_remove(hcd, pdev);
+
+	/* free TWI GPIO USB_HOST_DEV pin */
+	gpio_free(MSP_PIN_USB0_HOST_DEV);
+#ifdef CONFIG_MSP_HAS_DUAL_USB
+	gpio_free(MSP_PIN_USB1_HOST_DEV);
+#endif
+
+	return 0;
+}
+
+MODULE_ALIAS("pmcmsp-ehci");
+static struct platform_driver ehci_hcd_msp_driver = {
+	.probe		= ehci_hcd_msp_drv_probe,
+	.remove		= ehci_hcd_msp_drv_remove,
+	.driver		= {
+		.name	= "pmcmsp-ehci",
+	},
+};
-- 
1.7.0.4

