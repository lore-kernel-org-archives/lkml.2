Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab0LRPzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:55:48 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61881 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab0LRPzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:55:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sjzlMLmCnT2/4tNlCJsWCISmVa48QDrbt+Eghgeq0cw8IdwWaXPFPjdsI+O8zUtlw/
         oP1ZLiU/ea5N25M5iU482F9GxnYgIJLTT2jvYKtAAinJTCM9VFbkoSzf6x9EVCkTL215
         sktozlAu6JxQPtkjCwUf7RpXwo7c7pC8fXNgg=
From: Jean-Michel Hautbois <jhautbois@gmail.com>
To: davem@davemloft.net
Cc: richard.cochran@omicron.at, shemminger@vyatta.com, tj@kernel.org,
        randy.dunlap@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jean-Michel Hautbois <jhautbois@gmail.com>
Subject: [PATCH 1/2] net: phy: balance disable/enable irq on change
Date: Sat, 18 Dec 2010 16:55:22 +0100
Message-Id: <1292687723-31981-1-git-send-email-jhautbois@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When phy interface changes its status, it calls phy_change() function.
This function calls the interrupt disabling functions for the driver registered, but if this driver doesn't implement it, there is no IRQ disabling. After doing the work, we call enable_irq and not the respective driver function. This fixes it, as it could lead to an unbalanced IRQ.

Signed-off-by: Jean-Michel Hautbois <jhautbois@gmail.com>
---
 drivers/net/phy/phy.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 7670aac..b28f2ac 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -89,7 +89,8 @@ static int phy_config_interrupt(struct phy_device *phydev, u32 interrupts)
 	phydev->interrupts = interrupts;
 	if (phydev->drv->config_intr)
 		err = phydev->drv->config_intr(phydev);
-
+	else
+		err = -ENOSYS;
 	return err;
 }
 
@@ -541,6 +542,10 @@ static int phy_enable_interrupts(struct phy_device *phydev)
 		return err;
 
 	err = phy_config_interrupt(phydev, PHY_INTERRUPT_ENABLED);
+	if (err == -ENOSYS) {
+		err = 0;
+		enable_irq(phydev->irq);
+	}
 
 	return err;
 }
@@ -556,7 +561,10 @@ static int phy_disable_interrupts(struct phy_device *phydev)
 	/* Disable PHY interrupts */
 	err = phy_config_interrupt(phydev, PHY_INTERRUPT_DISABLED);
 
-	if (err)
+	if (err == -ENOSYS) {
+		err = 0;
+		disable_irq(phydev->irq);
+	} else if (err != 0)
 		goto phy_err;
 
 	/* Clear the interrupt */
-- 
1.7.0.4

