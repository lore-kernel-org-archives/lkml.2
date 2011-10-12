Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab1JLSGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 14:06:32 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:3679 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab1JLSG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 14:06:29 -0400
From: David Daney <david.daney@cavium.com>
To: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net
Cc: afleming@gmail.com, David Daney <david.daney@cavium.com>
Subject: [PATCH 2/3] netdev/phy/of: Handle IEEE802.3 clause 45 Ethernet PHYs in of_mdiobus_register()
Date: Wed, 12 Oct 2011 11:06:22 -0700
Message-Id: <1318442783-29058-3-git-send-email-david.daney@cavium.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1318442783-29058-1-git-send-email-david.daney@cavium.com>
References: <1318442783-29058-1-git-send-email-david.daney@cavium.com>
X-OriginalArrivalTime: 12 Oct 2011 18:06:29.0235 (UTC) FILETIME=[AA559C30:01CC8909]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define two new "compatible" values for Ethernet
PHYs. "ethernet-phy-ieee802.3-c22" and "ethernet-phy-ieee802.3-c45"
are used to indicate a PHY uses the corresponding protocol.

If a PHY is "compatible" with "ethernet-phy-ieee802.3-c45", we
indicate this so that get_phy_device() can properly probe the device.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 Documentation/devicetree/bindings/net/phy.txt |   12 +++++++++++-
 drivers/of/of_mdio.c                          |    4 ++++
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/phy.txt b/Documentation/devicetree/bindings/net/phy.txt
index bb8c742..de9cb32 100644
--- a/Documentation/devicetree/bindings/net/phy.txt
+++ b/Documentation/devicetree/bindings/net/phy.txt
@@ -16,8 +16,18 @@ Required properties:
 
 Example:
 
+Optional Properties:
+
+- compatible: Compatible list, may contain "ethernet-phy-ieee802.3-c22" or
+              "ethernet-phy-ieee802.3-c45" for PHYs that implement
+              IEEE802.3 clause 22 or IEEE802.3 clause 45
+              specifications.  If neither of these are specified, the
+              default is to assume clause 22.  The compatible list may
+              also contain other elements.
+
 ethernet-phy@0 {
-	linux,phandle = <2452000>
+	compatible = "ethernet-phy-ieee802.3-c22";
+	linux,phandle = <2452000>;
 	interrupt-parent = <40000>;
 	interrupts = <35 1>;
 	reg = <0>;
diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index 7c28e8c..f837a7f 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -79,6 +79,10 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 				mdio->irq[addr] = PHY_POLL;
 		}
 
+		if (of_device_is_compatible(child,
+					    "ethernet-phy-ieee802.3-c45"))
+			addr |= MII_ADDR_C45;
+
 		phy = get_phy_device(mdio, addr);
 		if (!phy || IS_ERR(phy)) {
 			dev_err(&mdio->dev, "error probing PHY at address %i\n",
-- 
1.7.2.3

