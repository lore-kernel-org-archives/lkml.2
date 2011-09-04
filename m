Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1IDK0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 06:26:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39503 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab1IDK0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 06:26:15 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 02/12] staging: et131x: Remove private adapter->duplex_mode and use phydev->duplex instead
Date: Sun,  4 Sep 2011 11:24:33 +0100
Message-Id: <1315131883-11068-3-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
References: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The phy device keeps a note of the duplex mode, so use that value instead of duplex mode.

Also use the phydev defines for duplex modes, and remove the driver private ones.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_mac.c     |    8 +++++---
 drivers/staging/et131x/et1310_phy.c     |    4 ----
 drivers/staging/et131x/et1310_phy.h     |    4 ----
 drivers/staging/et131x/et131x_adapter.h |    1 -
 4 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index efabc03..08d7691 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -205,11 +205,11 @@ void et1310_config_mac_regs2(struct et131x_adapter *adapter)
 	cfg2 &= ~0x0021;
 
 	/* Turn on duplex if needed */
-	if (adapter->duplex_mode)
+	if (phydev && phydev->duplex == DUPLEX_FULL)
 		cfg2 |= 0x01;
 
 	ifctrl &= ~(1 << 26);
-	if (!adapter->duplex_mode)
+	if (phydev && phydev->duplex == DUPLEX_HALF)
 		ifctrl |= (1<<26);	/* Enable ghd */
 
 	writel(ifctrl, &mac->if_ctrl);
@@ -450,7 +450,9 @@ void et1310_config_macstat_regs(struct et131x_adapter *adapter)
 
 void et1310_config_flow_control(struct et131x_adapter *adapter)
 {
-	if (adapter->duplex_mode == 0) {
+	struct phy_device *phydev = adapter->phydev;
+
+	if (phydev->duplex == DUPLEX_HALF) {
 		adapter->flowcontrol = FLOW_NONE;
 	} else {
 		char remote_pause, remote_async_pause;
diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index c5d0d02..41f0afa 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -477,8 +477,6 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 
 			netif_carrier_off(adapter->netdev);
 
-			adapter->duplex_mode = 0;
-
 			/* Free the packets being actively sent & stopped */
 			et131x_free_busy_send_packets(adapter);
 
@@ -516,8 +514,6 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 					     &speed, &duplex, &mdi_mdix,
 					     &masterslave, &polarity);
 
-			adapter->duplex_mode = duplex;
-
 			adapter->boot_coma = 20;
 
 			if (phydev && phydev->speed == SPEED_10) {
diff --git a/drivers/staging/et131x/et1310_phy.h b/drivers/staging/et131x/et1310_phy.h
index 3e95c66..d996e8e 100644
--- a/drivers/staging/et131x/et1310_phy.h
+++ b/drivers/staging/et131x/et1310_phy.h
@@ -242,10 +242,6 @@ struct mi_regs {
 #define TRUEPHY_MASK                    2
 #endif
 
-/* Define duplex modes */
-#define TRUEPHY_DUPLEX_HALF             0
-#define TRUEPHY_DUPLEX_FULL             1
-
 /* Define master/slave configuration values */
 #define TRUEPHY_CFG_SLAVE               0
 #define TRUEPHY_CFG_MASTER              1
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index 1e65e79..a63f376 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -169,7 +169,6 @@ struct et131x_adapter {
 
 	/* Packet Filter and look ahead size */
 	u32 packet_filter;
-	u32 duplex_mode;
 
 	/* multicast list */
 	u32 multicast_addr_count;
-- 
1.7.6

