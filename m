Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab0J1BEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 21:04:00 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:4408 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790Ab0J1BD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 21:03:59 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dan Carpenter <error27@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] of: of_mdio: Fix some endianness problems.
Date: Wed, 27 Oct 2010 18:03:47 -0700
Message-Id: <1288227827-5447-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 28 Oct 2010 01:04:27.0075 (UTC) FILETIME=[114FD130:01CB763C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In of_mdiobus_register(), the __be32 *addr variable is dereferenced.
This will not work on little-endian targets.  Also since it is
unsigned, checking for less than zero is redundant.

Fix these two issues.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/of/of_mdio.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index 1fce00e..b370306 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -52,27 +52,32 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 
 	/* Loop over the child nodes and register a phy_device for each one */
 	for_each_child_of_node(np, child) {
-		const __be32 *addr;
+		const __be32 *paddr;
+		u32 addr;
 		int len;
 
 		/* A PHY must have a reg property in the range [0-31] */
-		addr = of_get_property(child, "reg", &len);
-		if (!addr || len < sizeof(*addr) || *addr >= 32 || *addr < 0) {
+		paddr = of_get_property(child, "reg", &len);
+		if (!paddr || len < sizeof(*paddr)) {
+addr_err:
 			dev_err(&mdio->dev, "%s has invalid PHY address\n",
 				child->full_name);
 			continue;
 		}
+		addr = be32_to_cpup(paddr);
+		if (addr >= 32)
+			goto addr_err;
 
 		if (mdio->irq) {
-			mdio->irq[*addr] = irq_of_parse_and_map(child, 0);
-			if (!mdio->irq[*addr])
-				mdio->irq[*addr] = PHY_POLL;
+			mdio->irq[addr] = irq_of_parse_and_map(child, 0);
+			if (!mdio->irq[addr])
+				mdio->irq[addr] = PHY_POLL;
 		}
 
-		phy = get_phy_device(mdio, be32_to_cpup(addr));
+		phy = get_phy_device(mdio, addr);
 		if (!phy || IS_ERR(phy)) {
 			dev_err(&mdio->dev, "error probing PHY at address %i\n",
-				*addr);
+				addr);
 			continue;
 		}
 		phy_scan_fixups(phy);
@@ -91,7 +96,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 		}
 
 		dev_dbg(&mdio->dev, "registered phy %s at address %i\n",
-			child->name, *addr);
+			child->name, addr);
 	}
 
 	return 0;
-- 
1.7.2.3

