Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab2HUMTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:19:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55588 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163Ab2HUMTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:19:12 -0400
From: Stany MARCEL <stany.marcel@novasys-ingenierie.com>
To: linux-m68k@vger.kernel.org
Cc: geert@linux-m68k.org, linux-kernel@vger.kernel.org,
        Stany MARCEL <stany.marcel@novasys-ingenierie.com>
Subject: [PATCH 1/3] Add support to broadcom 5222 PHY
Date: Tue, 21 Aug 2012 14:18:49 +0200
Message-Id: <1345551531-15348-1-git-send-email-stany.marcel@novasys-ingenierie.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stany MARCEL <stany.marcel@novasys-ingenierie.com>
---

 This driver is an adaption of the one given by freescale for kernel 2.6.25.

 Tested with kernel 3.4.8 with arch/m68k backported from linux-m68k head
 2 FEC configured with shared phy

 drivers/net/phy/Kconfig        |    7 +-
 drivers/net/phy/Makefile       |    1 +
 drivers/net/phy/broadcom522x.c |  171 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 178 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/phy/broadcom522x.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 3090dc6..2f97824 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -24,7 +24,7 @@ config MARVELL_PHY
 	tristate "Drivers for Marvell PHYs"
 	---help---
 	  Currently has a driver for the 88E1011S
-
+
 config DAVICOM_PHY
 	tristate "Drivers for Davicom PHYs"
 	---help---
@@ -72,6 +72,11 @@ config BCM87XX_PHY
 	help
 	  Currently supports the BCM8706 and BCM8727 10G Ethernet PHYs.

+config BROADCOM5222_PHY
+	tristate "Drivers for Broadcom5222 PHY"
+	---help---
+	  Currently supports the BCM5222 PHYs.
+
 config ICPLUS_PHY
 	tristate "Drivers for ICPlus PHYs"
 	---help---
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 6d2dc6c..52723e6 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_VITESSE_PHY)	+= vitesse.o
 obj-$(CONFIG_BROADCOM_PHY)	+= broadcom.o
 obj-$(CONFIG_BCM63XX_PHY)	+= bcm63xx.o
 obj-$(CONFIG_BCM87XX_PHY)	+= bcm87xx.o
+obj-$(CONFIG_BROADCOM5222_PHY)	+= broadcom522x.o
 obj-$(CONFIG_ICPLUS_PHY)	+= icplus.o
 obj-$(CONFIG_REALTEK_PHY)	+= realtek.o
 obj-$(CONFIG_LSI_ET1011C_PHY)	+= et1011c.o
diff --git a/drivers/net/phy/broadcom522x.c b/drivers/net/phy/broadcom522x.c
new file mode 100644
index 0000000..61aecef
--- /dev/null
+++ b/drivers/net/phy/broadcom522x.c
@@ -0,0 +1,171 @@
+/*
+ *Copyright (C) 2009 Freescale Semiconductor, Inc. All rights reserved.
+ *	Chenghu Wu <b16972@freescale.com>
+ *
+ * Driver for broadcom PHYs 522x
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mii.h>
+#include <linux/ethtool.h>
+#include <linux/phy.h>
+#include <linux/netdevice.h>
+
+/* DP83865 phy identifier values */
+#define BCM5222_PHY_ID	0x00406320
+
+/* PHY Register */
+#define BCM5222_TIMEOUT                 0x100
+
+/* MII Registers */
+#define BCM5222_CTRL                    0x00
+#define BCM5222_STATUS                  0x01
+#define BCM5222_ID_HIGH                 0x02
+#define BCM5222_ID_LOW                  0x03
+#define BCM5222_AN_ADV                  0x04
+#define BCM5222_AN_LP                   0x05
+#define BCM5222_AN_EXP                  0x06
+#define BCM5222_AN_NEXTPG               0x07
+#define BCM5222_AN_LP_NPTX              0x08
+#define BCM5222_AUX_CS                  0x18
+#define BCM5222_AUX_STATUS              0x19
+
+/* CONTROL Bits */
+#define BCM5222_CTRL_RESET              0x8000
+#define BCM5222_CTRL_LOOPBACK           0x4000
+#define BCM5222_CTRL_FORCE              0x2000
+#define BCM5222_CTRL_AUTOEN             0x1000
+#define BCM5222_CTRL_PWRDN              0x0800
+#define BCM5222_CTRL_ISOLATE            0x0400
+#define BCM5222_CTRL_RESTART            0x0200
+#define BCM5222_CTRL_DUPLEX             0x0100
+#define BCM5222_CTRL_COLLEN             0x0080
+
+/* STATUS Bits */
+#define BCM5222_STATUS_100T4            0x8000
+#define BCM5222_STATUS_100TXFDX         0x4000
+#define BCM5222_STATUS_100TX            0x2000
+#define BCM5222_STATUS_10FDX            0x1000
+#define BCM5222_STATUS_10               0x0800
+#define BCM5222_STATUS_MF_PREAMBLE      0x0040
+#define BCM5222_STATUS_AN_COMPLETE      0x0020
+#define BCM5222_STATUS_REMOTE_FAULT     0x0010
+#define BCM5222_STATUS_AN_CAPABLE       0x0008
+#define BCM5222_STATUS_LINK             0x0004
+#define BCM5222_STATUS_JABBER           0x0002
+#define BCM5222_STATUS_EXT_CAP          0x0001
+
+/* ID Values */
+#define BCM5222_ID_HIGH_VAL             0x0040
+#define BCM5222_ID_LOW_VAL              0x6320
+
+/* Advertise Bits */
+#define BCM5222_AN_ADV_NEXTPG           0x8000
+#define BCM5222_AN_ADV_REMOTE_FAULT     0x2000
+#define BCM5222_AN_ADV_PAUSE            0x0400
+#define BCM5222_AN_ADV_100T4            0x0200
+#define BCM5222_AN_ADV_100TXFDX         0x0100
+#define BCM5222_AN_ADV_100TX            0x0080
+#define BCM5222_AN_ADV_10FDX            0x0040
+#define BCM5222_AN_ADV_10               0x0020
+#define BCM5222_AN_ADV_8023             0x0001
+#define BCM5222_AN_ADV_ALL              \
+	(BCM5222_AN_ADV_100TXFDX | \
+	BCM5222_AN_ADV_100TXFDX | \
+	BCM5222_AN_ADV_100TX | \
+	BCM5222_AN_ADV_10FDX | \
+	BCM5222_AN_ADV_10 |    \
+	BCM5222_AN_ADV_8023)
+
+/* AUX CTRL/STATUS Bits */
+#define BCM5222_AUX_CS_JABBER_DIS       0x8000
+#define BCM5222_AUX_CS_FORCE_LINK       0x4000
+#define BCM5222_AUX_CS_10M_TX_PWR       0x0100
+#define BCM5222_AUX_CS_HSQ_LSQ_MASK     0x00c0
+#define BCM5222_AUX_CS_EDGE_RATE_MASK   0x0030
+#define BCM5222_AUX_CS_AN_IND           0x0008
+#define BCM5222_AUX_CS_SPEED_FORCE      0x0004
+#define BCM5222_AUX_CS_SPEED            0x0002
+#define BCM5222_AUX_CS_DUPLEX           0x0001
+
+/* AUX STATUS Bits */
+#define BCM5222_AUX_STATUS_AN_COMP      0x8000
+#define BCM5222_AUX_STATUS_AN_COMPACK   0x4000
+#define BCM5222_AUX_STATUS_AN_ACKDET    0x2000
+#define BCM5222_AUX_STATUS_AN_ABDET     0x1000
+#define BCM5222_AUX_STATUS_AN_PAUSE     0x0800
+#define BCM5222_AUX_STATUS_AN_HCDMASK   0x0700
+#define BCM5222_AUX_STATUS_AN_PDFAULT   0x0080
+#define BCM5222_AUX_STATUS_LP_RMTFAULT  0x0040
+#define BCM5222_AUX_STATUS_LP_PGRX      0x0020
+#define BCM5222_AUX_STATUS_LP_NEGABLE   0x0010
+#define BCM5222_AUX_STATUS_SPEED        0x0008
+#define BCM5222_AUX_STATUS_LINK         0x0004
+#define BCM5222_AUX_STATUS_AN_EN        0x0002
+#define BCM5222_AUX_STATUS_JABBER       0x0001
+
+static int bcm5222_config_intr(struct phy_device *phydev)
+{
+	int err = 0;
+	printk(KERN_INFO "%s PHY_INTERRUPT %x\n",
+			__func__, phydev->interrupts);
+
+	return err;
+}
+
+static int bcm5222_ack_interrupt(struct phy_device *phydev)
+{
+	return 0;
+}
+
+static int bcm5222_config_init(struct phy_device *phydev)
+{
+	return  bcm5222_ack_interrupt(phydev);
+}
+
+
+static struct phy_driver bcm5222_driver = {
+	.phy_id = BCM5222_PHY_ID,
+	.phy_id_mask = 0xfffffff0,
+	.name = "Broadcom BCM5222",
+	.features = PHY_BASIC_FEATURES,
+	.flags = PHY_HAS_INTERRUPT,
+	.config_init = bcm5222_config_init,
+	.config_aneg = genphy_config_aneg,
+	.read_status = genphy_read_status,
+	.ack_interrupt = bcm5222_ack_interrupt,
+	.config_intr = bcm5222_config_intr,
+	.driver = {.owner = THIS_MODULE,}
+};
+
+static int __init bcm5222_init(void)
+{
+	int ret;
+
+	ret = phy_driver_register(&bcm5222_driver);
+	if (ret)
+		goto err1;
+
+	return 0;
+err1:
+	printk(KERN_INFO "register bcm5222 PHY driver fail\n");
+	return ret;
+}
+
+static void __exit bcm5222_exit(void)
+{
+	phy_driver_unregister(&bcm5222_driver);
+}
+
+MODULE_DESCRIPTION("Broadcom PHY driver");
+MODULE_LICENSE("GPL v2");
+
+module_init(bcm5222_init);
+module_exit(bcm5222_exit);
--
1.7.9.5

