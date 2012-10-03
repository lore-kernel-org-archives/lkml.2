Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab2JCPRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:17:52 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36947 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932573Ab2JCPN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:56 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Thomas Meyer <thomas@m3y3r.de>,
        "David S. Miller" <davem@davemloft.net>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 24/25] MIPS: Alchemy: use the OHCI platform driver
Date: Wed,  3 Oct 2012 17:03:20 +0200
Message-Id: <1349276601-8371-26-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276601-8371-1-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This also greatly simplifies the power_{on,off} callbacks and make them
work on platform device id instead of checking the OHCI controller base
address like what was done in ohci-au1xxx.c.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 arch/mips/alchemy/common/platform.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/mips/alchemy/common/platform.c b/arch/mips/alchemy/common/platform.c
index 57335a2..cd12458 100644
--- a/arch/mips/alchemy/common/platform.c
+++ b/arch/mips/alchemy/common/platform.c
@@ -18,6 +18,7 @@
 #include <linux/serial_8250.h>
 #include <linux/slab.h>
 #include <linux/usb/ehci_pdriver.h>
+#include <linux/usb/ohci_pdriver.h>
 
 #include <asm/mach-au1x00/au1000.h>
 #include <asm/mach-au1x00/au1xxx_dbdma.h>
@@ -142,6 +143,34 @@ static struct usb_ehci_pdata alchemy_ehci_pdata = {
 	.power_suspend		= alchemy_ehci_power_off,
 };
 
+/* Power on callback for the ohci platform driver */
+static int alchemy_ohci_power_on(struct platform_device *pdev)
+{
+	int unit;
+
+	unit = (pdev->id == 1) ?
+		ALCHEMY_USB_OHCI1 : ALCHEMY_USB_OHCI0;
+
+	return alchemy_usb_control(unit, 1);
+}
+
+/* Power off/suspend callback for the ohci platform driver */
+static void alchemy_ohci_power_off(struct platform_device *pdev)
+{
+	int unit;
+
+	unit = (pdev->id == 1) ?
+		ALCHEMY_USB_OHCI1 : ALCHEMY_USB_OHCI0;
+
+	alchemy_usb_control(unit, 0);
+}
+
+static struct usb_ohci_pdata alchemy_ohci_pdata = {
+	.power_on		= alchemy_ohci_power_on,
+	.power_off		= alchemy_ohci_power_off,
+	.power_suspend		= alchemy_ohci_power_off,
+};
+
 static unsigned long alchemy_ohci_data[][2] __initdata = {
 	[ALCHEMY_CPU_AU1000] = { AU1000_USB_OHCI_PHYS_ADDR, AU1000_USB_HOST_INT },
 	[ALCHEMY_CPU_AU1500] = { AU1000_USB_OHCI_PHYS_ADDR, AU1500_USB_HOST_INT },
@@ -192,6 +221,7 @@ static void __init alchemy_setup_usb(int ctype)
 	pdev->name = "au1xxx-ohci";
 	pdev->id = 0;
 	pdev->dev.dma_mask = &alchemy_ohci_dmamask;
+	pdev->dev.platform_data = &alchemy_ohci_pdata;
 
 	if (platform_device_register(pdev))
 		printk(KERN_INFO "Alchemy USB: cannot add OHCI0\n");
@@ -231,6 +261,7 @@ static void __init alchemy_setup_usb(int ctype)
 		pdev->name = "au1xxx-ohci";
 		pdev->id = 1;
 		pdev->dev.dma_mask = &alchemy_ohci_dmamask;
+		pdev->dev.platform_data = &alchemy_ohci_pdata;
 
 		if (platform_device_register(pdev))
 			printk(KERN_INFO "Alchemy USB: cannot add OHCI1\n");
-- 
1.7.9.5

