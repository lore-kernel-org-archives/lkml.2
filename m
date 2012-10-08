Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab2JHNNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:13:40 -0400
Received: from zmc.proxad.net ([212.27.53.206]:32905 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab2JHNNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:13:36 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Thomas Meyer <thomas@m3y3r.de>,
        "David S. Miller" <davem@davemloft.net>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/32 v4] MIPS: Alchemy: use the ehci platform driver
Date: Mon,  8 Oct 2012 15:11:22 +0200
Message-Id: <1349701906-16481-9-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349701906-16481-1-git-send-email-florian@openwrt.org>
References: <1349701906-16481-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the ehci platform driver power_{on,suspend,off} callbacks to perform the
USB block gate enabling/disabling as what the ehci-au1xxx.c driver does.
Update the db1200 and db1300 defconfigs to now select the EHCI platform
driver.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
Changes in v4:
- rebased against greg's latest usb-next

No changes in v3

Changes in v2:
- update impacted alchemy defconfigs accordingly

 arch/mips/alchemy/common/platform.c |   23 ++++++++++++++++++++++-
 arch/mips/configs/db1200_defconfig  |    1 +
 arch/mips/configs/db1300_defconfig  |    1 +
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/mips/alchemy/common/platform.c b/arch/mips/alchemy/common/platform.c
index c0f3ce6..b9a5f6d 100644
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
+	.no_io_watchdog	= 1,
+	.power_on	= alchemy_ehci_power_on,
+	.power_off	= alchemy_ehci_power_off,
+	.power_suspend	= alchemy_ehci_power_off,
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
diff --git a/arch/mips/configs/db1200_defconfig b/arch/mips/configs/db1200_defconfig
index 1f69249..d31ac85 100644
--- a/arch/mips/configs/db1200_defconfig
+++ b/arch/mips/configs/db1200_defconfig
@@ -117,6 +117,7 @@ CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
 # CONFIG_USB_DEVICE_CLASS is not set
 CONFIG_USB_DYNAMIC_MINORS=y
 CONFIG_USB_EHCI_HCD=y
+CONFIG_USB_EHCI_HCD_PLATFORM=y
 CONFIG_USB_EHCI_ROOT_HUB_TT=y
 CONFIG_USB_OHCI_HCD=y
 CONFIG_MMC=y
diff --git a/arch/mips/configs/db1300_defconfig b/arch/mips/configs/db1300_defconfig
index 3590ab5..717e7b2 100644
--- a/arch/mips/configs/db1300_defconfig
+++ b/arch/mips/configs/db1300_defconfig
@@ -288,6 +288,7 @@ CONFIG_USB_ARCH_HAS_EHCI=y
 CONFIG_USB=y
 CONFIG_USB_DYNAMIC_MINORS=y
 CONFIG_USB_EHCI_HCD=y
+CONFIG_USB_EHCI_HCD_PLATFORM=y
 CONFIG_USB_EHCI_ROOT_HUB_TT=y
 CONFIG_USB_EHCI_TT_NEWSCHED=y
 CONFIG_USB_OHCI_HCD=y
-- 
1.7.9.5

