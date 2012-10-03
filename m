Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab2JCPQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:16:25 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36964 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609Ab2JCPN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:58 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Thomas Meyer <thomas@m3y3r.de>,
        "David S. Miller" <davem@davemloft.net>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/25] MIPS: Alchemy: use the ehci platform driver
Date: Wed,  3 Oct 2012 17:03:02 +0200
Message-Id: <1349276601-8371-8-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276601-8371-1-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the ehci platform driver power_{on,suspend,off} callbacks to perform the
USB block gate enabling/disabling as what the ehci-au1xxx.c driver does.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 arch/mips/alchemy/common/platform.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/mips/alchemy/common/platform.c b/arch/mips/alchemy/common/platform.c
index c0f3ce6..57335a2 100644
--- a/arch/mips/alchemy/common/platform.c
+++ b/arch/mips/alchemy/common/platform.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/serial_8250.h>
 #include <linux/slab.h>
+#include <linux/usb/ehci_pdriver.h>
 
 #include <asm/mach-au1x00/au1000.h>
 #include <asm/mach-au1x00/au1xxx_dbdma.h>
@@ -122,6 +123,25 @@ static void __init alchemy_setup_uarts(int ctype)
 static u64 alchemy_ohci_dmamask = DMA_BIT_MASK(32);
 static u64 __maybe_unused alchemy_ehci_dmamask = DMA_BIT_MASK(32);
 
+/* Power on callback for the ehci platform driver */
+static int alchemy_ehci_power_on(struct platform_device *pdev)
+{
+	return alchemy_usb_control(ALCHEMY_USB_EHCI0, 1);
+}
+
+/* Power off/suspend callback for the ehci platform driver */
+static void alchemy_ehci_power_off(struct platform_device *pdev)
+{
+	alchemy_usb_control(ALCHEMY_USB_EHCI0, 0);
+}
+
+static struct usb_ehci_pdata alchemy_ehci_pdata = {
+	.need_io_watchdog	= 0,
+	.power_on		= alchemy_ehci_power_on,
+	.power_off		= alchemy_ehci_power_off,
+	.power_suspend		= alchemy_ehci_power_off,
+};
+
 static unsigned long alchemy_ohci_data[][2] __initdata = {
 	[ALCHEMY_CPU_AU1000] = { AU1000_USB_OHCI_PHYS_ADDR, AU1000_USB_HOST_INT },
 	[ALCHEMY_CPU_AU1500] = { AU1000_USB_OHCI_PHYS_ADDR, AU1500_USB_HOST_INT },
@@ -188,9 +208,10 @@ static void __init alchemy_setup_usb(int ctype)
 		res[1].start = alchemy_ehci_data[ctype][1];
 		res[1].end = res[1].start;
 		res[1].flags = IORESOURCE_IRQ;
-		pdev->name = "au1xxx-ehci";
+		pdev->name = "ehci-platform";
 		pdev->id = 0;
 		pdev->dev.dma_mask = &alchemy_ehci_dmamask;
+		pdev->dev.platform_data = &alchemy_ehci_pdata;
 
 		if (platform_device_register(pdev))
 			printk(KERN_INFO "Alchemy USB: cannot add EHCI0\n");
-- 
1.7.9.5

