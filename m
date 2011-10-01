Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab1JAKQI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 06:16:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44948 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab1JAKPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 06:15:41 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@linux.intel.com,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 3/8] staging: et131x: Remove adapter->bmsr, replace with phydev equivalents
Date: Sat,  1 Oct 2011 11:14:12 +0100
Message-Id: <1317464057-18231-3-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317464057-18231-1-git-send-email-mark.einon@gmail.com>
References: <1317464057-18231-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adapter->bmsr is no longer being updated, but is also used to check the link state in places.

Remove bmsr from adapter, and replace link state checks with phydev->link check.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_phy.c     |    3 ---
 drivers/staging/et131x/et131x_adapter.h |    3 ---
 drivers/staging/et131x/et131x_initpci.c |    7 +++----
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index fc37b18..a72046b 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -337,9 +337,6 @@ void et131x_xcvr_init(struct et131x_adapter *adapter)
 	u16 isr;
 	u16 lcr2;
 
-	/* Zero out the adapter structure variable representing BMSR */
-	adapter->bmsr = 0;
-
 	et131x_mii_read(adapter, PHY_INTERRUPT_STATUS, &isr);
 	et131x_mii_read(adapter, PHY_INTERRUPT_MASK, &imr);
 
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index fabc2c5..b5195ef 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -201,9 +201,6 @@ struct et131x_adapter {
 	u16 pdown_speed;
 	u8 pdown_duplex;
 
-	/* Xcvr status at last poll */
-	u16 bmsr;
-
 	/* Tx Memory Variables */
 	struct tx_ring tx_ring;
 
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 667ab80..10283a3 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -239,19 +239,18 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
 void et131x_error_timer_handler(unsigned long data)
 {
 	struct et131x_adapter *adapter = (struct et131x_adapter *) data;
+	struct phy_device *phydev = adapter->phydev;
 
 	if (!et1310_in_phy_coma(adapter))
 		et1310_update_macstat_host_counters(adapter);
 	else
 		dev_err(&adapter->pdev->dev, "No interrupts, in PHY coma\n");
 
-	if (!(adapter->bmsr & BMSR_LSTATUS) &&
-	    adapter->boot_coma < 11) {
+	if (!phydev->link && adapter->boot_coma < 11)
 		adapter->boot_coma++;
-	}
 
 	if (adapter->boot_coma == 10) {
-		if (!(adapter->bmsr & BMSR_LSTATUS)) {
+		if (!phydev->link) {
 			if (!et1310_in_phy_coma(adapter)) {
 				/* NOTE - This was originally a 'sync with
 				 *  interrupt'. How to do that under Linux?
-- 
1.7.6.4

