Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab0DMQMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 12:12:07 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:61551 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab0DMQLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 12:11:53 -0400
From: Dinh.Nguyen@freescale.com
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       bryan.wu@canonical.com, amit.kucheria@canonical.com,
       Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCH 2.6.34-rc4 5/8] mx5: Add USB Host1 port registration
Date: Tue, 13 Apr 2010 11:10:28 -0500
Message-Id: <1271175030-3635-5-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1271175030-3635-4-git-send-email-Dinh.Nguyen@freescale.com>
References: <1271175030-3635-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1271175030-3635-2-git-send-email-Dinh.Nguyen@freescale.com>
 <1271175030-3635-3-git-send-email-Dinh.Nguyen@freescale.com>
 <1271175030-3635-4-git-send-email-Dinh.Nguyen@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

This patch adds the device platform registration for enabling USB
host functionality on the Host1 port on Freescale MX51 Babbage HW.
This file makes platform specific calls to initialize the USB HW.

This patch applies to 2.6.34-rc4.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/mach-mx5/Makefile             |    2 +-
 arch/arm/mach-mx5/board-mx51_babbage.c |    2 +
 arch/arm/mach-mx5/usb_h1.c             |   90 ++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-mx5/usb_h1.c

diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
index 3fca1f1..e49be0b 100644
--- a/arch/arm/mach-mx5/Makefile
+++ b/arch/arm/mach-mx5/Makefile
@@ -3,7 +3,7 @@
 #
 
 # Object file lists.
-obj-y   := cpu.o mm.o clock-mx51.o devices.o usb_dr.o
+obj-y   := cpu.o mm.o clock-mx51.o devices.o usb_dr.o usb_h1.o
 
 obj-$(CONFIG_MACH_MX51_BABBAGE) += board-mx51_babbage.o
 
diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c
index 4e196d7..1338d6a 100644
--- a/arch/arm/mach-mx5/board-mx51_babbage.c
+++ b/arch/arm/mach-mx5/board-mx51_babbage.c
@@ -28,6 +28,7 @@
 #include "devices.h"
 
 extern void __init mx5_usb_dr_init(void);
+extern void __init mx5_usbh1_init(void);
 
 static struct platform_device *devices[] __initdata = {
 	&mxc_fec_device,
@@ -82,6 +83,7 @@ static void __init mxc_board_init(void)
 	mxc_register_gpios();
 
 	mx5_usb_dr_init();
+	mx5_usbh1_init();
 }
 
 static void __init mx51_babbage_timer_init(void)
diff --git a/arch/arm/mach-mx5/usb_h1.c b/arch/arm/mach-mx5/usb_h1.c
new file mode 100644
index 0000000..23ae336
--- /dev/null
+++ b/arch/arm/mach-mx5/usb_h1.c
@@ -0,0 +1,90 @@
+/*
+ * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA 02110-1301, USA.
+ */
+
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/platform_device.h>
+#include <mach/iomux-mx51.h>
+#include <mach/mxc_ehci.h>
+#include <mach/common.h>
+#include "devices.h"
+
+#define	GPIO1_27	(0*32 +27)
+
+extern int fsl_usb_host_init(struct platform_device *pdev);
+extern int fsl_usb_host_uninit(struct fsl_usb2_platform_data *pdata);
+
+static int fsl_usb_host_init_ext(struct platform_device *pdev);
+static int fsl_usb_host_uninit_ext(struct platform_device *pdev);
+
+static struct mxc_usbh_platform_data usbh1_config = {
+	.init	= fsl_usb_host_init_ext,
+	.exit	= fsl_usb_host_uninit_ext,
+	.portsc	= MXC_EHCI_MODE_ULPI,
+	.flags	= MXC_EHCI_POWER_PINS_ENABLED,
+};
+
+/*
+ * USB Host1 HS port
+ */
+static int gpio_usbh1_active(void)
+{
+	struct pad_desc usbh1stp_gpio = MX51_PAD_GPIO_1_27__USBH1_STP_ERR;
+	int ret;
+
+	/* Set USBH1_STP to GPIO and toggle it */
+	mxc_iomux_v3_setup_pad(&usbh1stp_gpio);
+	ret = gpio_request(GPIO1_27, "usbh1_stp");
+
+	if (ret) {
+		pr_debug("failed to get USBH1_STP_GPIO1_27: %d\n", ret);
+		return ret;
+	}
+	gpio_direction_output(GPIO1_27, 0);
+	gpio_set_value(GPIO1_27, 1);
+
+	msleep(100);
+	gpio_free(GPIO1_27);
+	return 0;
+}
+
+static int fsl_usb_host_init_ext(struct platform_device *pdev)
+{
+	int ret;
+	struct pad_desc usbh1stp = MX51_PAD_GPIO_1_27__USBH1_STP;
+
+	gpio_usbh1_active();
+	ret = fsl_usb_host_init(pdev);
+	if (ret)
+		return ret;
+
+	/* setback USBH1_STP to be function */
+	mxc_iomux_v3_setup_pad(&usbh1stp);
+	return 0;
+}
+
+static int fsl_usb_host_uninit_ext(struct platform_device *pdev)
+{
+	return fsl_usb_host_uninit(pdev);
+}
+void __init mx5_usbh1_init(void)
+{
+	mxc_register_device(&mxc_usbh1_device, &usbh1_config);
+}
+
-- 
1.6.0.4

