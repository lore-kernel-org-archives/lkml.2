Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab0KVQdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:33:33 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55770 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab0KVQdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:33:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Tck6nsAp+O/3ztF85mYRnV49Enr7Hqrz25rH/zOUpDuDHdJiYDaheoXF63DtTjeWf8
         WQaJsoCDF9nao4wj/FvJqq0A734nfXmDGcbXeGqhUNwa1Umwt9DCz0dgZMp2e3C3Dh89
         jiNBIJNEGKh+fNif+nUsMa/K97VXMcUxyGAZM=
From: mkl0301@gmail.com
To: cbouatmailru@gmail.com, avorontsov@mvista.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org
Cc: Mac Lin <mkl0301@gmail.com>
Subject: [PATCH v2 2/3] ARM: cns3xxx: Add architecture definition for EHCI/OHCI controller
Date: Tue, 23 Nov 2010 00:32:44 +0800
Message-Id: <1290443565-20766-3-git-send-email-mkl0301@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1290443565-20766-1-git-send-email-mkl0301@gmail.com>
References: <1290443565-20766-1-git-send-email-mkl0301@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mac Lin <mkl0301@gmail.com>

This patch add plateform_device for EHCI and OHCI controller on CNS3XXX. Power
reference count (usb_pwr_ref) is used to control enabling and disabling the
single clock control for both EHCI and OHCI controller.

It also remove EHCI/OHCI unused virtual address definitions.

Signed-off-by: Mac Lin <mkl0301@gmail.com>
---
 arch/arm/mach-cns3xxx/cns3420vb.c            |   50 ++++++++++++++++++++++++++
 arch/arm/mach-cns3xxx/include/mach/cns3xxx.h |    2 -
 arch/arm/mach-cns3xxx/include/mach/pm.h      |    2 +
 arch/arm/mach-cns3xxx/pm.c                   |    4 ++
 4 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-cns3xxx/cns3420vb.c b/arch/arm/mach-cns3xxx/cns3420vb.c
index 90fe9ab..4824223 100644
--- a/arch/arm/mach-cns3xxx/cns3420vb.c
+++ b/arch/arm/mach-cns3xxx/cns3420vb.c
@@ -107,11 +107,61 @@ static void __init cns3420_early_serial_setup(void)
 #endif
 }
 
+static struct resource cns3xxx_usb_ehci_resource[] = {
+	[0] = {
+		.start = CNS3XXX_USB_BASE,
+		.end   = CNS3XXX_USB_BASE + SZ_16M - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_CNS3XXX_USB_EHCI,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static u64 cns3xxx_usb_dma_mask = 0xffffffffULL;
+
+static struct platform_device cns3xxx_usb_ehci_device = {
+	.name		= "cns3xxx-ehci",
+	.num_resources	= ARRAY_SIZE(cns3xxx_usb_ehci_resource),
+	.resource	= cns3xxx_usb_ehci_resource,
+	.dev		= {
+		.dma_mask		= &cns3xxx_usb_dma_mask,
+		.coherent_dma_mask	= 0xffffffffULL,
+	},
+};
+
+static struct resource cns3xxx_usb_ohci_resource[] = {
+	[0] = {
+		.start          = CNS3XXX_USB_OHCI_BASE,
+		.end            = CNS3XXX_USB_OHCI_BASE + SZ_16M - 1,
+		.flags          = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start          = IRQ_CNS3XXX_USB_OHCI,
+		.flags          = IORESOURCE_IRQ,
+	},
+};
+
+static u64 cns3xxx_usb_ohci_dma_mask = 0xffffffffULL;
+static struct platform_device cns3xxx_usb_ohci_device = {
+	.name = "cns3xxx-ohci",
+	.dev                = {
+		.dma_mask       = &cns3xxx_usb_ohci_dma_mask,
+		.coherent_dma_mask = 0xffffffffULL,
+	},
+	.num_resources = 2,
+	.resource = cns3xxx_usb_ohci_resource,
+};
+
+
 /*
  * Initialization
  */
 static struct platform_device *cns3420_pdevs[] __initdata = {
 	&cns3420_nor_pdev,
+	&cns3xxx_usb_ehci_device,
+	&cns3xxx_usb_ohci_device,
 };
 
 static void __init cns3420_init(void)
diff --git a/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h b/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h
index 6dbce13..191c8e5 100644
--- a/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h
+++ b/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h
@@ -165,7 +165,6 @@
 #define CNS3XXX_USBOTG_BASE_VIRT		0xFFF15000
 
 #define CNS3XXX_USB_BASE			0x82000000	/* USB Host Control */
-#define CNS3XXX_USB_BASE_VIRT			0xFFF16000
 
 #define CNS3XXX_SATA2_BASE			0x83000000	/* SATA */
 #define CNS3XXX_SATA2_SIZE			SZ_16M
@@ -184,7 +183,6 @@
 #define CNS3XXX_2DG_BASE_VIRT			0xFFF1B000
 
 #define CNS3XXX_USB_OHCI_BASE			0x88000000	/* USB OHCI */
-#define CNS3XXX_USB_OHCI_BASE_VIRT		0xFFF1C000
 
 #define CNS3XXX_L2C_BASE			0x92000000	/* L2 Cache Control */
 #define CNS3XXX_L2C_BASE_VIRT			0xFFF27000
diff --git a/arch/arm/mach-cns3xxx/include/mach/pm.h b/arch/arm/mach-cns3xxx/include/mach/pm.h
index 102617b..ddbe7d7 100644
--- a/arch/arm/mach-cns3xxx/include/mach/pm.h
+++ b/arch/arm/mach-cns3xxx/include/mach/pm.h
@@ -16,4 +16,6 @@ void cns3xxx_pwr_clk_dis(unsigned int block);
 void cns3xxx_pwr_power_up(unsigned int block);
 void cns3xxx_pwr_power_down(unsigned int block);
 
+extern atomic_t usb_pwr_ref;
+
 #endif /* __CNS3XXX_PM_H */
diff --git a/arch/arm/mach-cns3xxx/pm.c b/arch/arm/mach-cns3xxx/pm.c
index a4495e6..784af93 100644
--- a/arch/arm/mach-cns3xxx/pm.c
+++ b/arch/arm/mach-cns3xxx/pm.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/delay.h>
+#include <asm/atomic.h>
 #include <mach/system.h>
 #include <mach/cns3xxx.h>
 
@@ -116,3 +117,6 @@ int cns3xxx_cpu_clock(void)
 	return cpu;
 }
 EXPORT_SYMBOL(cns3xxx_cpu_clock);
+
+atomic_t usb_pwr_ref = ATOMIC_INIT(0);
+EXPORT_SYMBOL(usb_pwr_ref);
-- 
1.7.3

