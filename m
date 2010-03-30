Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab0C3J6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 05:58:42 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:59791 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab0C3J6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 05:58:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SXDEZKqwuPBqlCb6CA7Sdr/9fVOwxe6q6LjKiYRN9N3WsV5YdNc1RxObndEIJhartv
         sNi2/SXAiEhgFO6jLhUjoAv0OE2JzztCNDZe9GnoDSE/TOzlJP6oTNP9mz+uDiVl8rPO
         qGwKq5LoXv9uauB+mTMq6l7PrtMCuPjejbufU=
From: Anders Darander <anders.darander@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Ralf Baechle <ralf@linux-mips.org>, Maxime Bizon <mbizon@freebox.fr>,
       Anders Darander <ad@datarespons.se>,
       David Daney <ddaney@caviumnetworks.com>, Sekhar Nori <nsekhar@ti.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andy Fleming <afleming@freescale.com>,
       Grant Likely <grant.likely@secretlab.ca>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Allow MACB to connect to a higher addresses PHY.
Date: Tue, 30 Mar 2010 11:58:32 +0200
Message-Id: <1269943112-6975-1-git-send-email-anders.darander@gmail.com>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anders Darander <ad@datarespons.se>

Using the Atmel MACB together with an integrated switch, can make only port 1
work. This is caused by macb_mii_probe trying to attach the MAC to the first
PHY, which often is on one of the external ports.

E.g. the Micrel KSZ8873 connects to the MAC on port 3, thus phy_addr should be
set to 3.

Signed-off-by: Anders Darander <ad@datarespons.se>
---
 drivers/net/phy/Kconfig      |   19 ++++++++++++++++++-
 drivers/net/phy/phy_device.c |    4 ++++
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index fc5938b..64aa003 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -15,11 +15,28 @@ if PHYLIB
 
 comment "MII PHY device drivers"
 
+config SWITCHING_PHY
+	bool "An Ethernet switch is connected to the MAC"
+	depends on MACB
+	help
+	  If an Ethernet switch is connected to the MAC, it
+	  is quite common to have the connection on a port
+	  higher than the first port. This option allows to
+	  select the desired port number
+
+config SWITCHING_PHY_ADDR
+	int "PHYA address"
+	depends on SWITCHING_PHY
+	default "3"
+	help
+	  On e.g. the Micrel KSZ8873MLL, port 3 (and thus phy_addr
+	  3) is the one connected to the MAC of the MCU.
+
 config MARVELL_PHY
 	tristate "Drivers for Marvell PHYs"
 	---help---
 	  Currently has a driver for the 88E1011S
-	
+
 config DAVICOM_PHY
 	tristate "Drivers for Davicom PHYs"
 	---help---
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index db17945..891bd0d 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -284,7 +284,11 @@ struct phy_device *phy_find_first(struct mii_bus *bus)
 {
 	int addr;
 
+#ifdef CONFIG_SWITCHING_PHY
+	for (addr = CONFIG_SWITCHING_PHY_ADDR; addr < PHY_MAX_ADDR; addr++) {
+#else
 	for (addr = 0; addr < PHY_MAX_ADDR; addr++) {
+#endif
 		if (bus->phy_map[addr])
 			return bus->phy_map[addr];
 	}
-- 
1.7.0.3

