Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab2JDS4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:56:41 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:45110 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751594Ab2JDS4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:56:40 -0400
From: Constantine Shulyupin <const@MakeLinux.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Constantine Shulyupin <const@MakeLinux.com>
Subject: [PATCH v5] Enable USB peripheral mode on dm365 EVM
Date: Thu,  4 Oct 2012 20:56:32 +0200
Message-Id: <1349376992-7810-1-git-send-email-const@MakeLinux.com>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {1470:box668.bluehost.com:makelinu:makelinux.net} {sentby:smtp auth 84.228.125.26 authed with poster@makelinux.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Constantine Shulyupin <const@MakeLinux.com>

Defines OTG as default USB mode because defines CONFIG_USB_MUSB_HOST, CONFIG_USB_MUSB_PERIPHERAL, CONFIG_USB_MUSB_OTG are not used in kernel configuration.
Sets USB PHY clock source to 24 MHz clock and call USB configuration from board initialization.

Tested with usb gadget g_zero on DM365 EVM connected to PC.

References: 

Definition of USB_PHY_CTRL and PHYCLKFREQ: 
- http://www.makelinux.com/lib/ti/DM36x_ARM/doc-141

Original patch by miguel.aguilar@ridgerun.com is three years ago:
- http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg14741.html

Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
---

Note:

USBPHY_CTL_PADDR and USBPHY_CLKFREQ_24MHZ are defined in board-dm365-evm.c because davinci.h can't be included from drivers/usb/musb/. May be davinci.h should be merged with arch/arm/mach-davinci/include/mach/usb.h

Changelog 

Changes since v4 http://www.spinics.net/lists/kernel/msg1412995.html
- removed fix of dev_info in musb_init_controller

Changes since v3 http://www.spinics.net/lists/kernel/msg1412544.html:
- removed optional altering of pr_info

Changes since v1  http://marc.info/?l=linux-kernel&m=130894150803661&w=2:
- removed optional code and reordered
- removed alternation of GPIO33, which is multiplexed with DRVVBUS, because is not need for peripheral USB

This patch is based on code from projects Arago, Angstom and RidgeRun.

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
-- 
1.7.9.5

