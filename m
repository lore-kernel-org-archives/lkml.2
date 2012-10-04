Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422867Ab2JDQWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 12:22:45 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:56936 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1422779Ab2JDQWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 12:22:43 -0400
From: Constantine Shulyupin <const@MakeLinux.com>
To: gregkh@linuxfoundation.org
Cc: nsekhar@ti.com, davinci-linux-open-source@linux.davincidsp.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, khilman@ti.com, balbi@ti.com,
        miguel.aguilar@ridgerun.com, kernel-mentors@selenic.com,
        Constantine Shulyupin <const@MakeLinux.com>
Subject: [PATCH v4] Enable USB peripheral on dm365 EVM
Date: Thu,  4 Oct 2012 18:22:33 +0200
Message-Id: <1349367753-6725-1-git-send-email-const@MakeLinux.com>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {1470:box668.bluehost.com:makelinu:makelinux.net} {sentby:smtp auth 84.228.125.26 authed with poster@makelinux.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Constantine Shulyupin <const@MakeLinux.com>

Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
---

Note:

USBPHY_CTL_PADDR and USBPHY_CLKFREQ_24MHZ are defined in board-dm365-evm.c because davinci.h can't be included from drivers/usb/musb/. May be davinci.h should be renamed and moved to arch/arm/mach-davinci/include/mach/usb.h like arch/arm/plat-omap/include/plat/usb.h

Tested with usb gadget g_zero.

Changelog 

Changes since v3 http://www.spinics.net/lists/kernel/msg1412544.html:
- removed optional altering of pr_info

Changes since v2 http://article.gmane.org/gmane.linux.kernel/1159868/
- reordered code
- removed alternation of GPIO33, which is multiplexed with DRVVBUS, because is not need for peripheral USB

Changes since v1 http://marc.info/?l=linux-kernel&m=130894150803661&w=2:
- removed optional code and reordered

This patch is based on code from Arago, Angstom, and RidgeRun projects.
Original patch by miguel.aguilar@ridgerun.com is three years ago:
- http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg14741.html

---
 arch/arm/mach-davinci/board-dm365-evm.c |    8 ++++++++
 arch/arm/mach-davinci/usb.c             |    2 ++
 drivers/usb/musb/davinci.h              |    1 +
 drivers/usb/musb/musb_core.c            |   20 ++++++++++++--------
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 3a4743b..dfcb67f 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -38,6 +38,8 @@
 #include <mach/mmc.h>
 #include <mach/nand.h>
 #include <mach/keyscan.h>
+#include <mach/usb.h>
+#include <mach/hardware.h>
 
 #include <media/tvp514x.h>
 
@@ -92,6 +94,9 @@ static inline int have_tvp7002(void)
 #define CPLD_CCD_DIR3	CPLD_OFFSET(0x3f,0)
 #define CPLD_CCD_IO3	CPLD_OFFSET(0x3f,1)
 
+#define USBPHY_CTL_PADDR	0x01c40034
+#define USBPHY_CLKFREQ_24MHZ	BIT(13)
+
 static void __iomem *cpld;
 
 
@@ -613,6 +618,9 @@ static __init void dm365_evm_init(void)
 
 	dm365_init_spi0(BIT(0), dm365_evm_spi_info,
 			ARRAY_SIZE(dm365_evm_spi_info));
+	writel(readl(IO_ADDRESS(USBPHY_CTL_PADDR)) | USBPHY_CLKFREQ_24MHZ,
+			IO_ADDRESS(USBPHY_CTL_PADDR));
+	davinci_setup_usb(500, 8);
 }
 
 MACHINE_START(DAVINCI_DM365_EVM, "DaVinci DM365 EVM")
diff --git a/arch/arm/mach-davinci/usb.c b/arch/arm/mach-davinci/usb.c
index 23d2b6d..664c689 100644
--- a/arch/arm/mach-davinci/usb.c
+++ b/arch/arm/mach-davinci/usb.c
@@ -49,6 +49,8 @@ static struct musb_hdrc_platform_data usb_data = {
 	.mode           = MUSB_PERIPHERAL,
 #elif defined(CONFIG_USB_MUSB_HOST)
 	.mode           = MUSB_HOST,
+#else
+	.mode           = MUSB_OTG,
 #endif
 	.clock		= "usb",
 	.config		= &musb_config,
diff --git a/drivers/usb/musb/davinci.h b/drivers/usb/musb/davinci.h
index 371baa0..e737d97 100644
--- a/drivers/usb/musb/davinci.h
+++ b/drivers/usb/musb/davinci.h
@@ -16,6 +16,7 @@
 
 /* Integrated highspeed/otg PHY */
 #define USBPHY_CTL_PADDR	0x01c40034
+#define USBPHY_CLKFREQ_24MHZ	BIT(13)
 #define USBPHY_DATAPOL		BIT(11)	/* (dm355) switch D+/D- */
 #define USBPHY_PHYCLKGD		BIT(8)
 #define USBPHY_SESNDEN		BIT(7)	/* v(sess_end) comparator */
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 26f1bef..277fe65 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2051,9 +2051,17 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 	dev_info(dev, "USB %s mode controller at %p using %s, IRQ %d\n",
 			({char *s;
 			 switch (musb->board_mode) {
-			 case MUSB_HOST:		s = "Host"; break;
-			 case MUSB_PERIPHERAL:	s = "Peripheral"; break;
-			 default:		s = "OTG"; break;
+			 case MUSB_HOST:
+				s = "Host";
+			 break;
+			 case MUSB_PERIPHERAL:
+				s = "Peripheral";
+			 break;
+			 case MUSB_OTG:
+				s = "OTG";
+			 break;
+			 default:
+				s = "Undefined";
 			 }; s; }),
 			ctrl,
 			(is_dma_capable() && musb->dma_controller)
-- 
1.7.9.5

