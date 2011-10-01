Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab1JAKQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 06:16:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44948 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab1JAKPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 06:15:50 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@linux.intel.com,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 8/8] staging: et131x: Fix indefinite low power sleep
Date: Sat,  1 Oct 2011 11:14:17 +0100
Message-Id: <1317464057-18231-8-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317464057-18231-1-git-send-email-mark.einon@gmail.com>
References: <1317464057-18231-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mechanism by which the device is put into low power sleep is broken
in that the device can never come back out of low power mode afterwards.
Temorary fix to bring the device back out of sleep almost immediately,
until a suitable wake trigger can be found.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_pm.c      |    5 +++--
 drivers/staging/et131x/et131x_initpci.c |   12 +++++++++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/et131x/et1310_pm.c b/drivers/staging/et131x/et1310_pm.c
index fd1eb6f..a1b72bf 100644
--- a/drivers/staging/et131x/et1310_pm.c
+++ b/drivers/staging/et131x/et1310_pm.c
@@ -147,6 +147,8 @@ void et1310_enable_phy_coma(struct et131x_adapter *adapter)
 
 	/* Wait for outstanding Receive packets */
 
+	et131x_disable_txrx(adapter->netdev);
+
 	/* Gate off JAGCore 3 clock domains */
 	pmcsr &= ~ET_PMCSR_INIT;
 	writel(pmcsr, &adapter->regs->global.pm_csr);
@@ -198,7 +200,6 @@ void et1310_disable_phy_coma(struct et131x_adapter *adapter)
 	/* Allow Tx to restart */
 	adapter->flags &= ~fMP_ADAPTER_LOWER_POWER;
 
-	/* Need to re-enable Rx. */
-	et131x_rx_dma_enable(adapter);
+	et131x_enable_txrx(adapter->netdev);
 }
 
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index ed22615..9795310 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -243,10 +243,15 @@ void et131x_error_timer_handler(unsigned long data)
 	struct et131x_adapter *adapter = (struct et131x_adapter *) data;
 	struct phy_device *phydev = adapter->phydev;
 
-	if (!et1310_in_phy_coma(adapter))
+	if (et1310_in_phy_coma(adapter)) {
+		/* Bring the device immediately out of coma, to
+		 * prevent it from sleeping indefinitely, this
+		 * mechanism could be improved! */
+		et1310_disable_phy_coma(adapter);
+		adapter->boot_coma = 20;
+	} else {
 		et1310_update_macstat_host_counters(adapter);
-	else
-		dev_err(&adapter->pdev->dev, "No interrupts, in PHY coma\n");
+	}
 
 	if (!phydev->link && adapter->boot_coma < 11)
 		adapter->boot_coma++;
@@ -495,6 +500,7 @@ static void et131x_adjust_link(struct net_device *netdev)
 		} else {
 			dev_warn(&adapter->pdev->dev,
 			    "Link down - cable problem ?\n");
+			adapter->boot_coma = 0;
 
 			if (phydev && phydev->speed == SPEED_10) {
 				/* NOTE - Is there a way to query this without
-- 
1.7.6.4

