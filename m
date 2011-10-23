Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1JWRP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 13:15:29 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:60839 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1JWRPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 13:15:25 -0400
Date: Sun, 23 Oct 2011 19:12:01 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH staging 5/6] et131x: kiss netdev.{base_addr, irq} goodbye.
Message-ID: <20111023171201.GE28657@electric-eye.fr.zoreil.com>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com> <20111023093651.GA22285@kroah.com> <20111023094231.GA3409@msilap.einon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111023094231.GA3409@msilap.einon>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
---
 drivers/staging/et131x/et131x.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 46de73b..79ca1d3 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -4366,10 +4366,6 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 	adapter->pdev = pci_dev_get(pdev);
 	adapter->netdev = netdev;
 
-	/* Do the same for the netdev struct */
-	netdev->irq = pdev->irq;
-	netdev->base_addr = pci_resource_start(pdev, 0);
-
 	/* Initialize spinlocks here */
 	spin_lock_init(&adapter->lock);
 	spin_lock_init(&adapter->tcb_send_qlock);
@@ -4828,8 +4824,10 @@ static struct net_device_stats *et131x_stats(struct net_device *netdev)
  */
 static int et131x_open(struct net_device *netdev)
 {
-	int result = 0;
 	struct et131x_adapter *adapter = netdev_priv(netdev);
+	struct pci_dev *pdev = adapter->pdev;
+	unsigned int irq = pdev->irq;
+	int result;
 
 	/* Start the timer to track NIC errors */
 	init_timer(&adapter->error_timer);
@@ -4838,12 +4836,9 @@ static int et131x_open(struct net_device *netdev)
 	adapter->error_timer.data = (unsigned long)adapter;
 	add_timer(&adapter->error_timer);
 
-	/* Register our IRQ */
-	result = request_irq(netdev->irq, et131x_isr, IRQF_SHARED,
-					netdev->name, netdev);
+	result = request_irq(irq, et131x_isr, IRQF_SHARED, netdev->name, netdev);
 	if (result) {
-		dev_err(&adapter->pdev->dev, "could not register IRQ %d\n",
-			netdev->irq);
+		dev_err(&pdev->dev, "could not register IRQ %d\n", irq);
 		return result;
 	}
 
@@ -4867,7 +4862,7 @@ static int et131x_close(struct net_device *netdev)
 	et131x_down(netdev);
 
 	adapter->flags &= ~fMP_ADAPTER_INTERRUPT_IN_USE;
-	free_irq(netdev->irq, netdev);
+	free_irq(adapter->pdev->irq, netdev);
 
 	/* Stop the error timer */
 	return del_timer_sync(&adapter->error_timer);
-- 
1.7.6.4

