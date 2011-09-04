Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab1IDK04 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 06:26:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36791 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab1IDK0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 06:26:19 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 04/12] staging: et131x: Remove PHY interrupt handling code from driver isr handler
Date: Sun,  4 Sep 2011 11:24:35 +0100
Message-Id: <1315131883-11068-5-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
References: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PHY interrupt is now handled by the phy_device, and the equivalent code is present in et131x_adjust_link, called from the phy_device when needed.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x_isr.c |   38 -----------------------------------
 1 files changed, 0 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index 94565c1..b3290e9 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -364,44 +364,6 @@ void et131x_isr_handler(struct work_struct *work)
 			dev_err(&adapter->pdev->dev, "WAKE_ON_LAN interrupt\n");
 		}
 
-		/* Handle the PHY interrupt */
-		if (status & ET_INTR_PHY) {
-			u32 pm_csr;
-			u16 bmsr_ints;
-			u16 bmsr_data;
-			u16 myisr;
-
-			/* If we are in coma mode when we get this interrupt,
-			 * we need to disable it.
-			 */
-			pm_csr = readl(&iomem->global.pm_csr);
-			if (pm_csr & ET_PM_PHY_SW_COMA) {
-				/*
-				 * Check to see if we are in coma mode and if
-				 * so, disable it because we will not be able
-				 * to read PHY values until we are out.
-				 */
-				et1310_disable_phy_coma(adapter);
-			}
-
-			/* Read the PHY ISR to clear the reason for the
-			 * interrupt.
-			 */
-			et131x_mii_read(adapter,
-					(uint8_t) offsetof(struct mi_regs, isr),
-					&myisr);
-
-			et131x_mii_read(adapter,
-			       (uint8_t) offsetof(struct mi_regs, bmsr),
-			       &bmsr_data);
-
-			bmsr_ints = adapter->bmsr ^ bmsr_data;
-			adapter->bmsr = bmsr_data;
-
-			/* Do all the cable in / cable out stuff */
-			et131x_mii_check(adapter, bmsr_data, bmsr_ints);
-		}
-
 		/* Let's move on to the TxMac */
 		if (status & ET_INTR_TXMAC) {
 			u32 err = readl(&iomem->txmac.err);
-- 
1.7.6

