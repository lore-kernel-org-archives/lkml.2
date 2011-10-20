Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab1JTVRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:17:31 -0400
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:35675
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753161Ab1JTVNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:13:22 -0400
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Decotigny <decot@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [RFC PATCH 15/17] phy_device: Add "port" and "transciever" fields
Date: Thu, 20 Oct 2011 17:00:22 -0400
Message-Id: <1319144425-15547-16-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1319144425-15547-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1319144425-15547-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some PHYs have multiple software-selectable inputs and outputs,
including RGMII, SGMII, SerDes, etc.  New fields are added to the
"struct phy_device" for "port" and "transciever" to allow "ethtool" to
switch outputs at runtime.  The defaults for the new fields are
identical to the hardcoded values used previously.

This should make no functional changes to the PHY layer behavior, but
it will allow later PHY/ethernet drivers to override those fields.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 drivers/net/phy/phy.c        |    4 ++--
 drivers/net/phy/phy_device.c |    2 ++
 include/linux/phy.h          |    4 ++++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index c378f91..5f72055 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -290,9 +290,9 @@ int phy_ethtool_gset(struct phy_device *phydev, struct ethtool_cmd *cmd)
 
 	ethtool_cmd_speed_set(cmd, phydev->speed);
 	cmd->duplex = phydev->duplex;
-	cmd->port = PORT_MII;
+	cmd->port = phydev->port;
 	cmd->phy_address = phydev->addr;
-	cmd->transceiver = XCVR_EXTERNAL;
+	cmd->transceiver = phydev->transciever;
 	cmd->autoneg = phydev->autoneg;
 
 	return 0;
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index fc0f315..d01b272 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -141,6 +141,8 @@ static struct phy_device* phy_device_create(struct mii_bus *bus,
 
 	dev->speed = 0;
 	dev->duplex = -1;
+	dev->port = PORT_MII;
+	dev->transceiver = XCVR_EXTERNAL;
 	dev->pause = dev->asym_pause = 0;
 	dev->link = 1;
 	dev->interface = PHY_INTERFACE_MODE_GMII;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index f07fc1c..0cb300d 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -308,6 +308,10 @@ struct phy_device {
 	u32 supported;
 	u32 advertising;
 
+	/* The current port/xcvr info (Copper, Fibre, MII, Direct-Attach) */
+	u8 port;
+	u8 transceiver;
+
 	int autoneg;
 
 	int link_timeout;
-- 
1.7.2.5

