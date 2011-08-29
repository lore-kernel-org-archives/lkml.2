Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab1H2RoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:44:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48500 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab1H2RoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:44:09 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=204/6=5D=20staging=3A=20et131x=3A=20Remove=20redundant=20replica=20loopback=20code?=
Date: Mon, 29 Aug 2011 18:42:39 +0100
Message-Id: <1314639761-4947-4-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314639761-4947-1-git-send-email-mark.einon@gmail.com>
References: <1314639761-4947-1-git-send-email-mark.einon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A mechanism used to set the phy in loopback mode is not present in the driver, making associated checks and variables redundant. Removing them.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_address_map.h |    6 +++---
 drivers/staging/et131x/et1310_rx.c          |   11 -----------
 drivers/staging/et131x/et131x_adapter.h     |    4 ----
 drivers/staging/et131x/et131x_isr.c         |   16 +++++++---------
 4 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/et131x/et1310_address_map.h b/drivers/staging/et131x/et1310_address_map.h
index 410677e..38ec56c 100644
--- a/drivers/staging/et131x/et1310_address_map.h
+++ b/drivers/staging/et131x/et1310_address_map.h
@@ -1,6 +1,6 @@
 /*
  * Agere Systems Inc.
- * 10/100/1000 Base-T Ethernet Driver for the ET1301 and ET131x series MACs
+ * 10/100/1000 Base-T Ethernet Driver for the ET1310 and ET131x series MACs
  *
  * Copyright © 2005 Agere Systems Inc.
  * All rights reserved.
@@ -149,7 +149,7 @@
  * GLOBAL Module of JAGCore Address Mapping
  * Located at address 0x0000
  */
-struct global_regs {			/* Location: */
+struct global_regs {				/* Location: */
 	u32 txq_start_addr;			/*  0x0000 */
 	u32 txq_end_addr;			/*  0x0004 */
 	u32 rxq_start_addr;			/*  0x0008 */
@@ -163,7 +163,7 @@ struct global_regs {			/* Location: */
 	u32 sw_reset;				/*  0x0028 */
 	u32 slv_timer;				/*  0x002C */
 	u32 msi_config;				/*  0x0030 */
-	u32 loopback;			/*  0x0034 */
+	u32 loopback;				/*  0x0034 */
 	u32 watchdog_timer;			/*  0x0038 */
 };
 
diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index e6458db..f50420c 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -988,17 +988,6 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 	}
 
 	if (len) {
-		if (adapter->replica_phy_loopbk == 1) {
-			buf = rx_local->fbr[ring_index]->virt[buff_index];
-
-			if (memcmp(&buf[6], adapter->addr, ETH_ALEN) == 0) {
-				if (memcmp(&buf[42], "Replica packet",
-					   ETH_HLEN)) {
-					adapter->replica_phy_loopbk_passfail = 1;
-				}
-			}
-		}
-
 		/* Determine if this is a multicast packet coming in */
 		if ((word0 & ALCATEL_MULTICAST_PKT) &&
 		    !(word0 & ALCATEL_BROADCAST_PKT)) {
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index b03460b..508cc63 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -222,10 +222,6 @@ struct et131x_adapter {
 	/* Rx Memory Variables */
 	struct rx_ring rx_ring;
 
-	/* Loopback specifics */
-	u8 replica_phy_loopbk;		/* Replica Enable */
-	u8 replica_phy_loopbk_passfail;	/* Replica Enable Pass/Fail */
-
 	/* Stats */
 	struct ce_stats stats;
 
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index 7cfd213..4d75690 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -389,17 +389,15 @@ void et131x_isr_handler(struct work_struct *work)
 					(uint8_t) offsetof(struct mi_regs, isr),
 					&myisr);
 
-			if (!adapter->replica_phy_loopbk) {
-				et131x_mii_read(adapter,
-				       (uint8_t) offsetof(struct mi_regs, bmsr),
-				       &bmsr_data);
+			et131x_mii_read(adapter,
+			       (uint8_t) offsetof(struct mi_regs, bmsr),
+			       &bmsr_data);
 
-				bmsr_ints = adapter->bmsr ^ bmsr_data;
-				adapter->bmsr = bmsr_data;
+			bmsr_ints = adapter->bmsr ^ bmsr_data;
+			adapter->bmsr = bmsr_data;
 
-				/* Do all the cable in / cable out stuff */
-				et131x_mii_check(adapter, bmsr_data, bmsr_ints);
-			}
+			/* Do all the cable in / cable out stuff */
+			et131x_mii_check(adapter, bmsr_data, bmsr_ints);
 		}
 
 		/* Let's move on to the TxMac */
-- 
1.7.6

