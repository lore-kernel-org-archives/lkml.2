Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107Ab2EVSBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:01:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44463 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759243Ab2EVR75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:59:57 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        Andy Fleming <afleming@freescale.com>,
        David Daney <david.daney@cavium.com>
Subject: [PATCH 3/5] netdev/phy/of: Add more methods for binding PHY devices to drivers.
Date: Tue, 22 May 2012 10:59:50 -0700
Message-Id: <1337709592-23347-4-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1337709592-23347-1-git-send-email-ddaney.cavm@gmail.com>
References: <1337709592-23347-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Allow PHY drivers to supply their own device matching function
(match_phy_device()), or to be matched OF compatible properties.

PHYs following IEEE802.3 clause 45 have more than one device
identifier constants, which breaks the default device matching code.
Other 10G PHYs don't follow the standard manufacturer/device
identifier register layout standards, but they do use the standard
MDIO bus protocols for register access.  Both of these require
adjustments to the PHY driver to device matching code.

If the there is an of_node associated with such a PHY, we can match it
to its driver using the "compatible" properties, just as we do with
certain platform devices.  If the "compatible" property match fails,
first check if there is a driver supplied matching function, and if
not fall back to the existing identifier matching rules.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/net/phy/mdio_bus.c |    7 +++++++
 include/linux/phy.h        |    7 +++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 83d5c9f..11c415d 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/of_device.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
@@ -305,6 +306,12 @@ static int mdio_bus_match(struct device *dev, struct device_driver *drv)
 	struct phy_device *phydev = to_phy_device(dev);
 	struct phy_driver *phydrv = to_phy_driver(drv);
 
+	if (of_driver_match_device(dev, drv))
+		return 1;
+
+	if (phydrv->match_phy_device)
+		return phydrv->match_phy_device(phydev);
+
 	return ((phydrv->phy_id & phydrv->phy_id_mask) ==
 		(phydev->phy_id & phydrv->phy_id_mask));
 }
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 283a318..09dc4c3 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -431,6 +431,13 @@ struct phy_driver {
 	/* Clears up any memory if needed */
 	void (*remove)(struct phy_device *phydev);
 
+	/*
+	 * Returns true if this is a suitable driver for the given
+	 * phydev.  If NULL, matching is based on phy_id and
+	 * phy_id_mask.
+	 */
+	int (*match_phy_device)(struct phy_device *phydev);
+
 	/* Handles SIOCSHWTSTAMP ioctl for hardware time stamping. */
 	int  (*hwtstamp)(struct phy_device *phydev, struct ifreq *ifr);
 
-- 
1.7.2.3

