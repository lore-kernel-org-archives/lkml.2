Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab0CaHv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 03:51:56 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:36950 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435Ab0CaHvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 03:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kRYjWuv0HnCuKcNpMc75gih9GttgnEJbDOnelIPEMixB4qIuz4UiGD/cmpvZfsYD7C
         +mVoB6XrXk2XextL9lmQnhBr2bTafGZNg75x7CsHW3x4dIMSQr+TZTBxoTidsVZrIHqt
         NiaSoYzd48JF63unXG8jzLmZkqJg4woy1IdwY=
From: Anders Darander <anders.darander@gmail.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jpirko@redhat.com>,
       Erik Waling <erik.waling@konftel.com>,
       Patrick McHardy <kaber@trash.net>, Anders Darander <ad@datarespons.se>,
       Grant Likely <grant.likely@secretlab.ca>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] MACB: Set PHY address in kernel parameters
Date: Wed, 31 Mar 2010 09:51:42 +0200
Message-Id: <1270021902-6556-1-git-send-email-anders.darander@gmail.com>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anders Darander <ad@datarespons.se>

Add the possibility to set the phy address. This is needed if an integrated
switch is connected to the MAC, as it is often the case that the highest port
is the one connected to the MAC of the MCU.

E.g. in the case of the Micrel KSZ8873, port 3 is the one to connect to the
MCU, thus, the MAC needs to connect to phy address 0x03, instead of the first
phy found.

Signed-off-by: Anders Darander <ad@datarespons.se>
---
 drivers/net/macb.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/net/macb.c b/drivers/net/macb.c
index c8a18a6..9b4e301 100644
--- a/drivers/net/macb.c
+++ b/drivers/net/macb.c
@@ -53,6 +53,14 @@
 #define MACB_RX_INT_FLAGS	(MACB_BIT(RCOMP) | MACB_BIT(RXUBR)	\
 				 | MACB_BIT(ISR_ROVR))
 
+/*
+ * Setup PHY probeing
+ */
+
+static int phy_addr = PHY_MAX_ADDR;
+module_param(phy_addr, ushort, 0);
+MODULE_PARAM_DESC(phy_addr, "PHY address connected to the MACB");
+
 static void __macb_set_hwaddr(struct macb *bp)
 {
 	u32 bottom;
@@ -193,7 +201,11 @@ static int macb_mii_probe(struct net_device *dev)
 	struct eth_platform_data *pdata;
 	int ret;
 
-	phydev = phy_find_first(bp->mii_bus);
+	if (phy_addr >= PHY_MAX_ADDRESS)
+		phydev = phy_find_first(bp->mii_bus);
+	else
+		phydev = bp->mii_bus->phy_map[phy_addr];
+
 	if (!phydev) {
 		printk (KERN_ERR "%s: no PHY found\n", dev->name);
 		return -1;
-- 
1.7.0.3

