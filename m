Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab2DPNRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:17:14 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:29675 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753593Ab2DPNRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:17:12 -0400
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, arnd@arndb.de, stern@rowland.harvard.edu,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 3/3] USB: ohci-nxp: Use isp1301 driver
Date: Mon, 16 Apr 2012 15:16:06 +0200
Message-Id: <1334582166-5485-3-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1334582166-5485-1-git-send-email-stigge@antcom.de>
References: <1334582166-5485-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ohci-nxp duplicates the isp1301 driver. This patch removes this code and makes
ohci-nxp use the new separate isp1301 driver.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---

Applies to v3.4-rc3 + LPC32xx DT patches

You can also pull from:

    git://git.antcom.de/linux-2.6 lpc32xx/udc
    http://git.antcom.de/?p=linux-2.6.git;a=shortlog;h=refs/heads/lpc32xx/udc

Depends on the isp1301 driver, see PATCH 1/3

 drivers/usb/host/Kconfig    |    1 
 drivers/usb/host/ohci-nxp.c |  106 --------------------------------------------
 2 files changed, 3 insertions(+), 104 deletions(-)

--- linux-2.6.orig/drivers/usb/host/Kconfig
+++ linux-2.6/drivers/usb/host/Kconfig
@@ -291,6 +291,7 @@ config USB_OHCI_HCD
 	depends on USB && USB_ARCH_HAS_OHCI
 	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3
 	select USB_OTG_UTILS if ARCH_OMAP
+	select USB_ISP1301 if ARCH_LPC32XX || ARCH_PNX4008
 	---help---
 	  The Open Host Controller Interface (OHCI) is a standard for accessing
 	  USB 1.1 host controller hardware.  It does more in hardware than Intel's
--- linux-2.6.orig/drivers/usb/host/ohci-nxp.c
+++ linux-2.6/drivers/usb/host/ohci-nxp.c
@@ -23,6 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
 #include <linux/of.h>
+#include <linux/usb/isp1301.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
@@ -57,54 +58,6 @@
 #define TRANSPARENT_I2C_EN	(1 << 7)
 #define HOST_EN			(1 << 0)
 
-/* ISP1301 USB transceiver I2C registers */
-#define	ISP1301_MODE_CONTROL_1		0x04	/* u8 read, set, +1 clear */
-
-#define	MC1_SPEED_REG		(1 << 0)
-#define	MC1_SUSPEND_REG		(1 << 1)
-#define	MC1_DAT_SE0		(1 << 2)
-#define	MC1_TRANSPARENT		(1 << 3)
-#define	MC1_BDIS_ACON_EN	(1 << 4)
-#define	MC1_OE_INT_EN		(1 << 5)
-#define	MC1_UART_EN		(1 << 6)
-#define	MC1_MASK		0x7f
-
-#define	ISP1301_MODE_CONTROL_2		0x12	/* u8 read, set, +1 clear */
-
-#define	MC2_GLOBAL_PWR_DN	(1 << 0)
-#define	MC2_SPD_SUSP_CTRL	(1 << 1)
-#define	MC2_BI_DI		(1 << 2)
-#define	MC2_TRANSP_BDIR0	(1 << 3)
-#define	MC2_TRANSP_BDIR1	(1 << 4)
-#define	MC2_AUDIO_EN		(1 << 5)
-#define	MC2_PSW_EN		(1 << 6)
-#define	MC2_EN2V7		(1 << 7)
-
-#define	ISP1301_OTG_CONTROL_1		0x06	/* u8 read, set, +1 clear */
-#	define	OTG1_DP_PULLUP		(1 << 0)
-#	define	OTG1_DM_PULLUP		(1 << 1)
-#	define	OTG1_DP_PULLDOWN	(1 << 2)
-#	define	OTG1_DM_PULLDOWN	(1 << 3)
-#	define	OTG1_ID_PULLDOWN	(1 << 4)
-#	define	OTG1_VBUS_DRV		(1 << 5)
-#	define	OTG1_VBUS_DISCHRG	(1 << 6)
-#	define	OTG1_VBUS_CHRG		(1 << 7)
-#define	ISP1301_OTG_STATUS		0x10	/* u8 readonly */
-#	define	OTG_B_SESS_END		(1 << 6)
-#	define	OTG_B_SESS_VLD		(1 << 7)
-
-#define ISP1301_I2C_ADDR 0x2C
-
-#define ISP1301_I2C_MODE_CONTROL_1 0x4
-#define ISP1301_I2C_MODE_CONTROL_2 0x12
-#define ISP1301_I2C_OTG_CONTROL_1 0x6
-#define ISP1301_I2C_OTG_CONTROL_2 0x10
-#define ISP1301_I2C_INTERRUPT_SOURCE 0x8
-#define ISP1301_I2C_INTERRUPT_LATCH 0xA
-#define ISP1301_I2C_INTERRUPT_FALLING 0xC
-#define ISP1301_I2C_INTERRUPT_RISING 0xE
-#define ISP1301_I2C_REG_CLEAR_ADDR 1
-
 /* On LPC32xx, those are undefined */
 #ifndef start_int_set_falling_edge
 #define start_int_set_falling_edge(irq)
@@ -114,41 +67,12 @@
 #define start_int_umask(irq)
 #endif
 
-static struct i2c_driver isp1301_driver;
 static struct i2c_client *isp1301_i2c_client;
 
 extern int usb_disabled(void);
 
 static struct clk *usb_clk;
 
-static const unsigned short normal_i2c[] =
-    { ISP1301_I2C_ADDR, ISP1301_I2C_ADDR + 1, I2C_CLIENT_END };
-
-static int isp1301_probe(struct i2c_client *client,
-			 const struct i2c_device_id *id)
-{
-	return 0;
-}
-
-static int isp1301_remove(struct i2c_client *client)
-{
-	return 0;
-}
-
-static const struct i2c_device_id isp1301_id[] = {
-	{ "isp1301_nxp", 0 },
-	{ }
-};
-
-static struct i2c_driver isp1301_driver = {
-	.driver = {
-		.name = "isp1301_nxp",
-	},
-	.probe = isp1301_probe,
-	.remove = isp1301_remove,
-	.id_table = isp1301_id,
-};
-
 static void isp1301_configure_pnx4008(void)
 {
 	/* PNX4008 only supports DAT_SE0 USB mode */
@@ -372,8 +296,6 @@ static int usb_hcd_nxp_probe(struct plat
 	struct usb_hcd *hcd = 0;
 	struct ohci_hcd *ohci;
 	const struct hc_driver *driver = &ohci_nxp_hc_driver;
-	struct i2c_adapter *i2c_adap;
-	struct i2c_board_info i2c_info;
 	struct resource *res;
 
 	int ret = 0, irq;
@@ -393,27 +315,7 @@ static int usb_hcd_nxp_probe(struct plat
 	__raw_writel(__raw_readl(USB_CTRL) & ~(1 << 20), USB_CTRL);
 	__raw_writel(__raw_readl(USB_CTRL) | (1 << 19), USB_CTRL);
 
-	ret = i2c_add_driver(&isp1301_driver);
-	if (ret < 0) {
-		err("failed to add ISP1301 driver");
-		goto out;
-	}
-	i2c_adap = i2c_get_adapter(2);
-	if (!i2c_adap) {
-		err("failed on i2c_get_adapter");
-		goto out_i2c_driver;
-	}
-
-	memset(&i2c_info, 0, sizeof(struct i2c_board_info));
-	strlcpy(i2c_info.type, "isp1301_nxp", I2C_NAME_SIZE);
-	isp1301_i2c_client = i2c_new_probed_device(i2c_adap, &i2c_info,
-						   normal_i2c, NULL);
-	i2c_put_adapter(i2c_adap);
-	if (!isp1301_i2c_client) {
-		err("failed to connect I2C to ISP1301 USB Transceiver");
-		ret = -ENODEV;
-		goto out_i2c_driver;
-	}
+	isp1301_i2c_client = isp1301_get_client();
 
 	isp1301_configure();
 
@@ -505,10 +407,7 @@ out3:
 out2:
 	clk_put(usb_clk);
 out1:
-	i2c_unregister_device(isp1301_i2c_client);
 	isp1301_i2c_client = NULL;
-out_i2c_driver:
-	i2c_del_driver(&isp1301_driver);
 out:
 	return ret;
 }
@@ -526,7 +425,6 @@ static int usb_hcd_nxp_remove(struct pla
 	clk_put(usb_clk);
 	i2c_unregister_device(isp1301_i2c_client);
 	isp1301_i2c_client = NULL;
-	i2c_del_driver(&isp1301_driver);
 
 	platform_set_drvdata(pdev, NULL);
 
