Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab2JCPQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:16:23 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36962 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932606Ab2JCPN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:58 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gabor Juhos <juhosg@openwrt.org>, Hauke Mehrtens <hauke@hauke-m.de>,
        Kelvin Cheung <keguang.zhang@gmail.com>,
        Jayachandran C <jayachandranc@netlogicmicro.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/25] USB: ehci: allow need_io_watchdog to be passed to ehci-platform driver
Date: Wed,  3 Oct 2012 17:03:01 +0200
Message-Id: <1349276601-8371-7-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349276601-8371-1-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And convert all the existing users of ehci-platform to specify a correct
need_io_watchdog value.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 arch/mips/ath79/dev-usb.c             |    2 ++
 arch/mips/loongson1/common/platform.c |    1 +
 arch/mips/netlogic/xlr/platform.c     |    1 +
 drivers/usb/host/bcma-hcd.c           |    1 +
 drivers/usb/host/ehci-platform.c      |    1 +
 drivers/usb/host/ssb-hcd.c            |    1 +
 include/linux/usb/ehci_pdriver.h      |    3 +++
 7 files changed, 10 insertions(+)

diff --git a/arch/mips/ath79/dev-usb.c b/arch/mips/ath79/dev-usb.c
index b2a2311..42b259b 100644
--- a/arch/mips/ath79/dev-usb.c
+++ b/arch/mips/ath79/dev-usb.c
@@ -71,12 +71,14 @@ static u64 ath79_ehci_dmamask = DMA_BIT_MASK(32);
 static struct usb_ehci_pdata ath79_ehci_pdata_v1 = {
 	.has_synopsys_hc_bug	= 1,
 	.port_power_off		= 1,
+	.need_io_watchdog	= 1,
 };
 
 static struct usb_ehci_pdata ath79_ehci_pdata_v2 = {
 	.caps_offset		= 0x100,
 	.has_tt			= 1,
 	.port_power_off		= 1,
+	.need_io_watchdog	= 1,
 };
 
 static struct platform_device ath79_ehci_device = {
diff --git a/arch/mips/loongson1/common/platform.c b/arch/mips/loongson1/common/platform.c
index 2874bf2..fa6b5d6 100644
--- a/arch/mips/loongson1/common/platform.c
+++ b/arch/mips/loongson1/common/platform.c
@@ -110,6 +110,7 @@ static struct resource ls1x_ehci_resources[] = {
 
 static struct usb_ehci_pdata ls1x_ehci_pdata = {
 	.port_power_off	= 1,
+	.need_io_watchdog = 1,
 };
 
 struct platform_device ls1x_ehci_device = {
diff --git a/arch/mips/netlogic/xlr/platform.c b/arch/mips/netlogic/xlr/platform.c
index 1731dfd..320b7ef 100644
--- a/arch/mips/netlogic/xlr/platform.c
+++ b/arch/mips/netlogic/xlr/platform.c
@@ -126,6 +126,7 @@ static u64 xls_usb_dmamask = ~(u32)0;
 
 static struct usb_ehci_pdata xls_usb_ehci_pdata = {
 	.caps_offset	= 0,
+	.need_io_watchdog = 1,
 };
 
 static struct platform_device xls_usb_ehci_device =
diff --git a/drivers/usb/host/bcma-hcd.c b/drivers/usb/host/bcma-hcd.c
index 443da21..e404f5c 100644
--- a/drivers/usb/host/bcma-hcd.c
+++ b/drivers/usb/host/bcma-hcd.c
@@ -160,6 +160,7 @@ static void __devinit bcma_hcd_init_chip(struct bcma_device *dev)
 }
 
 static const struct usb_ehci_pdata ehci_pdata = {
+	.need_io_watchdog	= 1,
 };
 
 static const struct usb_ohci_pdata ohci_pdata = {
diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index 764e010..08d5dec 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -32,6 +32,7 @@ static int ehci_platform_reset(struct usb_hcd *hcd)
 	ehci->has_synopsys_hc_bug = pdata->has_synopsys_hc_bug;
 	ehci->big_endian_desc = pdata->big_endian_desc;
 	ehci->big_endian_mmio = pdata->big_endian_mmio;
+	ehci->need_io_watchdog = pdata->need_io_watchdog;
 
 	ehci->caps = hcd->regs + pdata->caps_offset;
 	retval = ehci_setup(hcd);
diff --git a/drivers/usb/host/ssb-hcd.c b/drivers/usb/host/ssb-hcd.c
index c2a29fa..77e2851 100644
--- a/drivers/usb/host/ssb-hcd.c
+++ b/drivers/usb/host/ssb-hcd.c
@@ -96,6 +96,7 @@ static u32 __devinit ssb_hcd_init_chip(struct ssb_device *dev)
 }
 
 static const struct usb_ehci_pdata ehci_pdata = {
+	.need_io_watchdog	 = 1,
 };
 
 static const struct usb_ohci_pdata ohci_pdata = {
diff --git a/include/linux/usb/ehci_pdriver.h b/include/linux/usb/ehci_pdriver.h
index c9d09f8..988504d 100644
--- a/include/linux/usb/ehci_pdriver.h
+++ b/include/linux/usb/ehci_pdriver.h
@@ -29,6 +29,8 @@
  *			initialization.
  * @port_power_off:	set to 1 if the controller needs to be powered down
  *			after initialization.
+ * @need_io_watchdog:	set to 1 if the controller needs the I/O watchdog to
+ *			run.
  *
  * These are general configuration options for the EHCI controller. All of
  * these options are activating more or less workarounds for some hardware.
@@ -41,6 +43,7 @@ struct usb_ehci_pdata {
 	unsigned	big_endian_mmio:1;
 	unsigned	port_power_on:1;
 	unsigned	port_power_off:1;
+	unsigned	need_io_watchdog:1;
 
 	/* Turn on all power and clocks */
 	int (*power_on)(struct platform_device *pdev);
-- 
1.7.9.5

