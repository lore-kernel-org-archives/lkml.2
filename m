Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab2DZKbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 06:31:08 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:29912 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507Ab2DZKau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 06:30:50 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <avictor.za@gmail.com>,
        <plagnioj@jcrosoft.com>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/2] net/at91_ether: use gpio_to_irq for phy IRQ line
Date: Thu, 26 Apr 2012 12:30:43 +0200
Message-ID: <cfc991548b5b73c8038f41877da1cd0104945cf5.1335435759.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <3ad9b1273c4f30d42dcc3bdf6d03470111246f14.1335435759.git.nicolas.ferre@atmel.com>
References: <3ad9b1273c4f30d42dcc3bdf6d03470111246f14.1335435759.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.159.245.203]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the gpio_to_irq() function to retrieve the phy IRQ line
from the GPIO pin specification.
This fix is needed now that we have moved to irqdomains on AT91.

Reported-by: Jamie Iles <jamie@jamieiles.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/cadence/at91_ether.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/at91_ether.c b/drivers/net/ethernet/cadence/at91_ether.c
index 62761e1..7788419 100644
--- a/drivers/net/ethernet/cadence/at91_ether.c
+++ b/drivers/net/ethernet/cadence/at91_ether.c
@@ -263,7 +263,7 @@ static void enable_phyirq(struct net_device *dev)
 		return;
 	}
 
-	irq_number = lp->board_data.phy_irq_pin;
+	irq_number = gpio_to_irq(lp->board_data.phy_irq_pin);
 	status = request_irq(irq_number, at91ether_phy_interrupt, 0, dev->name, dev);
 	if (status) {
 		printk(KERN_ERR "at91_ether: PHY IRQ %d request failed - status %d!\n", irq_number, status);
@@ -363,7 +363,7 @@ static void disable_phyirq(struct net_device *dev)
 	disable_mdi(lp);
 	spin_unlock_irq(&lp->lock);
 
-	irq_number = lp->board_data.phy_irq_pin;
+	irq_number = gpio_to_irq(lp->board_data.phy_irq_pin);
 	free_irq(irq_number, dev);			/* Free interrupt handler */
 }
 
@@ -1234,7 +1234,7 @@ static int at91ether_suspend(struct platform_device *pdev, pm_message_t mesg)
 
 	if (netif_running(net_dev)) {
 		if (gpio_is_valid(lp->board_data.phy_irq_pin)) {
-			int phy_irq = lp->board_data.phy_irq_pin;
+			int phy_irq = gpio_to_irq(lp->board_data.phy_irq_pin);
 			disable_irq(phy_irq);
 		}
 
@@ -1258,7 +1258,7 @@ static int at91ether_resume(struct platform_device *pdev)
 		netif_start_queue(net_dev);
 
 		if (gpio_is_valid(lp->board_data.phy_irq_pin)) {
-			int phy_irq = lp->board_data.phy_irq_pin;
+			int phy_irq = gpio_to_irq(lp->board_data.phy_irq_pin);
 			enable_irq(phy_irq);
 		}
 	}
-- 
1.7.10

