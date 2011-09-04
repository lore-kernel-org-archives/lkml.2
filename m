Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab1IDK1I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 06:27:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53453 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab1IDK0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 06:26:17 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 03/12] staging: et131x: Remove redundant struct adapter members
Date: Sun,  4 Sep 2011 11:24:34 +0100
Message-Id: <1315131883-11068-4-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
References: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adapter->speed_duplex was never referenced.
adapter->registry_phy_coma was always set to zero, even in the vendor driver.

Removing all member references and associated dead code.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_phy.c     |    6 ------
 drivers/staging/et131x/et131x_adapter.h |    2 --
 drivers/staging/et131x/et131x_initpci.c |    4 +---
 3 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 41f0afa..0fccb86 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -496,12 +496,6 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 
 			/* Setup ET1310 as per the documentation */
 			et131x_adapter_setup(adapter);
-
-			/* Setup the PHY into coma mode until the cable is
-			 * plugged back in
-			 */
-			if (adapter->registry_phy_coma == 1)
-				et1310_enable_phy_coma(adapter);
 		}
 	}
 
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index a63f376..5656472 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -178,9 +178,7 @@ struct et131x_adapter {
 	struct address_map __iomem *regs;
 
 	/* Registry parameters */
-	u8 speed_duplex;	/* speed/duplex */
 	u8 wanted_flow;		/* Flow we want for 802.3x flow control */
-	u8 registry_phy_coma;	/* Phy Coma mode enable/disable */
 
 	u32 registry_rx_mem_end;	/* Size of internal rx memory */
 	u32 registry_jumbo_packet;	/* Max supported ethernet packet size */
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index eb08889..799aad6 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -250,14 +250,12 @@ void et131x_error_timer_handler(unsigned long data)
 		    "No interrupts, in PHY coma, pm_csr = 0x%x\n", pm_csr);
 
 	if (!(adapter->bmsr & BMSR_LSTATUS) &&
-	    adapter->registry_phy_coma &&
 	    adapter->boot_coma < 11) {
 		adapter->boot_coma++;
 	}
 
 	if (adapter->boot_coma == 10) {
-		if (!(adapter->bmsr & BMSR_LSTATUS)
-		    && adapter->registry_phy_coma) {
+		if (!(adapter->bmsr & BMSR_LSTATUS)) {
 			if ((pm_csr & ET_PM_PHY_SW_COMA) == 0) {
 				/* NOTE - This was originally a 'sync with
 				 *  interrupt'. How to do that under Linux?
-- 
1.7.6

