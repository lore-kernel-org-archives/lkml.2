Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab2JJMdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:33:37 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:42997 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750953Ab2JJMdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:33:35 -0400
From: Constantine Shulyupin <const@MakeLinux.com>
To: nsekhar@ti.com, gregkh@linuxfoundation.org
Cc: Constantine Shulyupin <const@MakeLinux.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6] Enable USB peripheral mode on dm365 EVM
Date: Wed, 10 Oct 2012 14:33:32 +0200
Message-Id: <1349872412-22040-1-git-send-email-const@MakeLinux.com>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {1470:box668.bluehost.com:makelinu:makelinux.net} {sentby:smtp auth 84.229.113.105 authed with poster@makelinux.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Constantine Shulyupin <const@MakeLinux.com>

Sets USB PHY clock source to 24 MHz clock and call USB configuration from board initialization.

Tested with OTG configuration, usb gadget g_zero on DM365 EVM connected to PC.

References:

Definition of USB_PHY_CTRL and PHYCLKFREQ:
- http://www.makelinux.com/lib/ti/DM36x_ARM/doc-141

Original patch by miguel.aguilar@ridgerun.com three years ago:
- http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg14741.html

Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
---

Note:

Changelog

Changes since v5 http://www.spinics.net/lists/kernel/msg1413120.html
accordingy feedback of nsekhar@ti.com http://www.spinics.net/lists/kernel/msg1414914.html
- phy configuration moved to drivers/usb/musb/davinci.c
- USB_OTG configuration is submitted in separated patch: http://www.spinics.net/lists/kernel/msg1414964.html
- Setting current limit to 1000 mA. Any way the current is limited to 510 mA in davinci_setup_usb.

Changes since v4 http://www.spinics.net/lists/kernel/msg1412995.html
- removed fix of dev_info in musb_init_controller

Changes since v3 http://www.spinics.net/lists/kernel/msg1412544.html:
- removed optional altering of pr_info

Changes since v1  http://marc.info/?l=linux-kernel&m=130894150803661&w=2:
- removed optional code and reordered
- removed alternation of GPIO33, which is multiplexed with DRVVBUS, because is not need for peripheral USB

This patch is based on code from projects Arago, Angstom and RidgeRun.

---
 arch/arm/mach-davinci/board-dm365-evm.c |    2 ++
 drivers/usb/musb/davinci.c              |    3 +++
 drivers/usb/musb/davinci.h              |    1 +
 3 files changed, 6 insertions(+)

diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 688a9c5..ba5ffc1 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -38,6 +38,7 @@
 #include <mach/mmc.h>
 #include <mach/nand.h>
 #include <mach/keyscan.h>
+#include <mach/usb.h>
 
 #include <media/tvp514x.h>
 
@@ -610,6 +611,7 @@ static __init void dm365_evm_init(void)
 
 	dm365_init_spi0(BIT(0), dm365_evm_spi_info,
 			ARRAY_SIZE(dm365_evm_spi_info));
+	davinci_setup_usb(1000, 8);
 }
 
 MACHINE_START(DAVINCI_DM365_EVM, "DaVinci DM365 EVM")
diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
index 472c8b4..af09ebf 100644
--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -428,6 +428,9 @@ static int davinci_musb_init(struct musb *musb)
 		__raw_writel(deepsleep, DM355_DEEPSLEEP);
 	}
 
+	if (machine_is_davinci_dm365_evm())
+		writel(readl(USB_PHY_CTRL) | USBPHY_CLKFREQ_24MHZ, USB_PHY_CTRL);
+
 	/* reset the controller */
 	musb_writel(tibase, DAVINCI_USB_CTRL_REG, 0x1);
 
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

