Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab0EQPqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:46:52 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:37912 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab0EQPqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:46:51 -0400
From: Dinh.Nguyen@freescale.com
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, s.hauer@pengutronix.de,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCH 2.6.34] mx5: bring usb phy out of reset on freescale mx51 babbage hw
Date: Mon, 17 May 2010 10:46:01 -0500
Message-Id: <1274111161-12580-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

This patch de-asserts the reset line that is connected to the USB
ULPI PHY on USB Host1.

This patch should be included with the original USB host enablement
set of patches of mx51 babbage hw, but was accidentily left out.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/mach-mx5/board-mx51_babbage.c      |   12 ++++++++++++
 arch/arm/plat-mxc/include/mach/iomux-mx51.h |    1 +
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c
index dacf506..ed885f9 100644
--- a/arch/arm/mach-mx5/board-mx51_babbage.c
+++ b/arch/arm/mach-mx5/board-mx51_babbage.c
@@ -33,6 +33,7 @@
 
 #define BABBAGE_USB_HUB_RESET	(0*32 + 7)	/* GPIO_1_7 */
 #define BABBAGE_USBH1_STP	(0*32 + 27)	/* GPIO_1_27 */
+#define BABBAGE_PHY_RESET (1*32 +5)	/* GPIO_2_5 */
 
 /* USB_CTRL_1 */
 #define MX51_USB_CTRL_1_OFFSET			0x10
@@ -101,6 +102,7 @@ static inline void mxc_init_imx_uart(void)
 static int gpio_usbh1_active(void)
 {
 	struct pad_desc usbh1stp_gpio = MX51_PAD_USBH1_STP__GPIO_1_27;
+	struct pad_desc phyreset_gpio = MX51_PAD_EIM_D21__GPIO_2_5;
 	int ret;
 
 	/* Set USBH1_STP to GPIO and toggle it */
@@ -115,6 +117,16 @@ static int gpio_usbh1_active(void)
 	gpio_set_value(BABBAGE_USBH1_STP, 1);
 	msleep(100);
 	gpio_free(BABBAGE_USBH1_STP);
+
+	/* De-assert USB PHY RESETB */
+	mxc_iomux_v3_setup_pad(&phyreset_gpio);
+	ret = gpio_request(BABBAGE_PHY_RESET, "phy_reset");
+
+	if (ret) {
+		pr_debug("failed to get MX51_PAD_EIM_D21__GPIO_2_5: %d\n", ret);
+		return ret;
+	}
+	gpio_direction_output(BABBAGE_PHY_RESET, 1);
 	return 0;
 }
 
diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx51.h b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
index 80528cc..ab0f95d 100644
--- a/arch/arm/plat-mxc/include/mach/iomux-mx51.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
@@ -63,6 +63,7 @@ typedef enum iomux_config {
 #define MX51_PAD_GPIO_2_3__EIM_D19	IOMUX_PAD(0x3fc, 0x068, 1, 0x0,   0, NO_PAD_CTRL)
 #define MX51_PAD_GPIO_2_4__EIM_D20	IOMUX_PAD(0x400, 0x06c, 1, 0x0,   0, NO_PAD_CTRL)
 #define MX51_PAD_GPIO_2_5__EIM_D21	IOMUX_PAD(0x404, 0x070, 1, 0x0,   0, NO_PAD_CTRL)
+#define MX51_PAD_EIM_D21__GPIO_2_5	IOMUX_PAD(0x404, 0x070, IOMUX_CONFIG_ALT1, 0x0,   0, MX51_GPIO_PAD_CTRL)
 #define MX51_PAD_GPIO_2_6__EIM_D22	IOMUX_PAD(0x408, 0x074, 1, 0x0,   0, NO_PAD_CTRL)
 #define MX51_PAD_GPIO_2_7__EIM_D23	IOMUX_PAD(0x40c, 0x078, 1, 0x0,   0, NO_PAD_CTRL)
 
-- 
1.6.0.4

