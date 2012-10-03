Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964815Ab2JCPQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:16:28 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36935 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932575Ab2JCPN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:56 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/25] MIPS: PNX8550: use OHCI platform driver
Date: Wed,  3 Oct 2012 17:03:09 +0200
Message-Id: <1349276601-8371-15-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276601-8371-1-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 arch/mips/pnx8550/common/platform.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/mips/pnx8550/common/platform.c b/arch/mips/pnx8550/common/platform.c
index 5264cc0..0a8faea 100644
--- a/arch/mips/pnx8550/common/platform.c
+++ b/arch/mips/pnx8550/common/platform.c
@@ -20,6 +20,7 @@
 #include <linux/serial.h>
 #include <linux/serial_pnx8xxx.h>
 #include <linux/platform_device.h>
+#include <linux/usb/ohci_pdriver.h>
 
 #include <int.h>
 #include <usb.h>
@@ -96,12 +97,40 @@ static u64 ohci_dmamask = DMA_BIT_MASK(32);
 
 static u64 uart_dmamask = DMA_BIT_MASK(32);
 
+static int pnx8550_usb_ohci_power_on(struct platform_device *pdev)
+{
+	/*
+	 * Set register CLK48CTL to enable and 48MHz
+	 */
+	outl(0x00000003, PCI_BASE | 0x0004770c);
+
+	/*
+	 * Set register CLK12CTL to enable and 48MHz
+	 */
+	outl(0x00000003, PCI_BASE | 0x00047710);
+
+	udelay(100);
+
+	return 0;
+}
+
+static void pnx8550_usb_ohci_power_off(struct platform_device *pdev)
+{
+	udelay(10);
+}
+
+static struct usb_ohci_pdata pnx8550_usb_ohci_pdata = {
+	.power_on	= pnx8550_usb_ohci_power_on,
+	.power_off	= pnx8550_usb_ohci_power_off,
+};
+
 static struct platform_device pnx8550_usb_ohci_device = {
-	.name		= "pnx8550-ohci",
+	.name		= "ohci-platform",
 	.id		= -1,
 	.dev = {
 		.dma_mask		= &ohci_dmamask,
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
+		.platform_data		= &pnx8550_usb_ohci_pdata,
 	},
 	.num_resources	= ARRAY_SIZE(pnx8550_usb_ohci_resources),
 	.resource	= pnx8550_usb_ohci_resources,
-- 
1.7.9.5

