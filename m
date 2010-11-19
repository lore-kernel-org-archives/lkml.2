Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab0KSV7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:59:46 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13494 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757698Ab0KSV7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:59:11 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>, Cyril Chemparathy <cyril@ti.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 2/2] phylib: Add support for Marvell 88E1149R devices.
Date: Fri, 19 Nov 2010 13:58:53 -0800
Message-Id: <1290203933-28251-3-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290203933-28251-1-git-send-email-ddaney@caviumnetworks.com>
References: <1290203933-28251-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 19 Nov 2010 22:00:02.0127 (UTC) FILETIME=[1D96FDF0:01CB8835]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 88E1149R is 10/100/1000 quad-gigabit Ethernet PHY.  The
.config_aneg function can be shared with 88E1118, but it needs its own
.config_init.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Cyril Chemparathy <cyril@ti.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/net/phy/marvell.c   |   40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/marvell_phy.h |    1 +
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 3600b8b..def19d7 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -433,6 +433,32 @@ static int m88e1118_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int m88e1149_config_init(struct phy_device *phydev)
+{
+	int err;
+
+	/* Change address */
+	err = phy_write(phydev, MII_MARVELL_PHY_PAGE, 0x0002);
+	if (err < 0)
+		return err;
+
+	/* Enable 1000 Mbit */
+	err = phy_write(phydev, 0x15, 0x1048);
+	if (err < 0)
+		return err;
+
+	/* Reset address */
+	err = phy_write(phydev, MII_MARVELL_PHY_PAGE, 0x0);
+	if (err < 0)
+		return err;
+
+	err = phy_write(phydev, MII_BMCR, BMCR_RESET);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
 static int m88e1145_config_init(struct phy_device *phydev)
 {
 	int err;
@@ -686,6 +712,19 @@ static struct phy_driver marvell_drivers[] = {
 		.driver = { .owner = THIS_MODULE },
 	},
 	{
+		.phy_id = MARVELL_PHY_ID_88E1149R,
+		.phy_id_mask = MARVELL_PHY_ID_MASK,
+		.name = "Marvell 88E1149R",
+		.features = PHY_GBIT_FEATURES,
+		.flags = PHY_HAS_INTERRUPT,
+		.config_init = &m88e1149_config_init,
+		.config_aneg = &m88e1118_config_aneg,
+		.read_status = &genphy_read_status,
+		.ack_interrupt = &marvell_ack_interrupt,
+		.config_intr = &marvell_config_intr,
+		.driver = { .owner = THIS_MODULE },
+	},
+	{
 		.phy_id = MARVELL_PHY_ID_88E1240,
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
 		.name = "Marvell 88E1240",
@@ -736,6 +775,7 @@ static struct mdio_device_id __maybe_unused marvell_tbl[] = {
 	{ 0x01410e10, 0xfffffff0 },
 	{ 0x01410cb0, 0xfffffff0 },
 	{ 0x01410cd0, 0xfffffff0 },
+	{ 0x01410e50, 0xfffffff0 },
 	{ 0x01410e30, 0xfffffff0 },
 	{ 0x01410e90, 0xfffffff0 },
 	{ }
diff --git a/include/linux/marvell_phy.h b/include/linux/marvell_phy.h
index 1ff81b5..dd3c34e 100644
--- a/include/linux/marvell_phy.h
+++ b/include/linux/marvell_phy.h
@@ -11,6 +11,7 @@
 #define MARVELL_PHY_ID_88E1118		0x01410e10
 #define MARVELL_PHY_ID_88E1121R		0x01410cb0
 #define MARVELL_PHY_ID_88E1145		0x01410cd0
+#define MARVELL_PHY_ID_88E1149R		0x01410e50
 #define MARVELL_PHY_ID_88E1240		0x01410e30
 #define MARVELL_PHY_ID_88E1318S		0x01410e90
 
-- 
1.7.2.3

