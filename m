Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab0LRSjN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 13:39:13 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50269 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab0LRSjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 13:39:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jUvJJ2cES75E0gdU3Fmn7ioIp5gYoTIuo7U+7xXVaqtMZNsuSKgkkSF8H+HGXNnHJJ
         lJU9m3zsRIXQTiz0eHRjem5FAF5gDNJu12vMa+ZzY447BawJA/nueGH4eN4jyEXh5qGD
         0xHjNXnfWvjnK2LgQWAq9eIzo6U4HYaTAkhlc=
From: Jean-Michel Hautbois <jhautbois@gmail.com>
To: davem@davemloft.net
Cc: richard.cochran@omicron.at, shemminger@vyatta.com, tj@kernel.org,
        randy.dunlap@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jean-Michel Hautbois <jhautbois@gmail.com>
Subject: [PATCH 1/2] net: phy: balance disable/enable irq on change
Date: Sat, 18 Dec 2010 19:38:59 +0100
Message-Id: <1292697540-2723-1-git-send-email-jhautbois@gmail.com>
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

