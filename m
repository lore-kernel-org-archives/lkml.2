Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab1JGVyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 17:54:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50458 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab1JGVyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 17:54:13 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: romieu@fr.zoreil.com, rjw@sisk.pl, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/4] staging: et131x: Remove error path from suspend/resume code
Date: Fri,  7 Oct 2011 22:52:50 +0100
Message-Id: <1318024371-10294-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing an error path from et131x suspend/resume functions.

Also added a call to phy_stop() to complement the phy_start() call
during device start/stop routine.

Thanks to Francois Romieu <romieu@fr.zoreil.com> for pointing this out.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.h         |    2 +
 drivers/staging/et131x/et131x_initpci.c |   35 +++++++++-----------------
 drivers/staging/et131x/et131x_netdev.c  |   40 ++++++++++++++++++++++++-------
 3 files changed, 45 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index c8f5ab1..e832234 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -85,6 +85,8 @@ void et1310_setup_device_for_unicast(struct et131x_adapter *adapter);
 /* et131x_netdev.c */
 int et131x_open(struct net_device *netdev);
 int et131x_close(struct net_device *netdev);
+void et131x_up(struct net_device *netdev);
+void et131x_down(struct net_device *netdev);
 struct net_device *et131x_device_alloc(void);
 void et131x_enable_txrx(struct net_device *netdev);
 void et131x_disable_txrx(struct net_device *netdev);
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 9795310..95a1aff 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -874,14 +874,12 @@ static int et131x_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 
-	if (!netif_running(netdev))
-		return 0;
-
-	et131x_close(netdev);
-	netif_device_detach(netdev);
-
-	pci_save_state(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	if (netif_running(netdev)) {
+		netif_device_detach(netdev);
+		et131x_down(netdev);
+		pci_save_state(pdev);
+		pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	}
 
 	return 0;
 }
@@ -889,24 +887,15 @@ static int et131x_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 static int et131x_pci_resume(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
-	int err = 0;
 
-	if (!netif_running(netdev))
-		return 0;
-
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
-	err = et131x_open(netdev);
-	if (err) {
-		dev_err(&pdev->dev, "Can't resume interface!\n");
-		goto out;
+	if (netif_running(netdev)) {
+		pci_set_power_state(pdev, PCI_D0);
+		pci_restore_state(pdev);
+		et131x_up(netdev);
+		netif_device_attach(netdev);
 	}
 
-	netif_device_attach(netdev);
-
-out:
-	return err;
+	return 0;
 }
 
 static struct pci_device_id et131x_pci_table[] __devinitdata = {
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 79127de..16373bb 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -178,6 +178,18 @@ void et131x_disable_txrx(struct net_device *netdev)
 }
 
 /**
+ * et131x_up - Bring up a device for use.
+ * @netdev: device to be opened
+ */
+void et131x_up(struct net_device *netdev)
+{
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+
+	et131x_enable_txrx(netdev);
+	phy_start(adapter->phydev);
+}
+
+/**
  * et131x_open - Open the device for use.
  * @netdev: device to be opened
  *
@@ -205,13 +217,28 @@ int et131x_open(struct net_device *netdev)
 	}
 
 	adapter->flags |= fMP_ADAPTER_INTERRUPT_IN_USE;
-	et131x_enable_txrx(netdev);
-	phy_start(adapter->phydev);
+
+	et131x_up(netdev);
 
 	return result;
 }
 
 /**
+ * et131x_down - Bring down the device
+ * @netdev: device to be broght down
+ */
+void et131x_down(struct net_device *netdev)
+{
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+
+	/* Save the timestamp for the TX watchdog, prevent a timeout */
+	netdev->trans_start = jiffies;
+
+	phy_stop(adapter->phydev);
+	et131x_disable_txrx(netdev);
+}
+
+/**
  * et131x_close - Close the device
  * @netdev: device to be closed
  *
@@ -221,18 +248,13 @@ int et131x_close(struct net_device *netdev)
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
-	/* Save the timestamp for the TX watchdog, prevent a timeout */
-	netdev->trans_start = jiffies;
-
-	et131x_disable_txrx(netdev);
+	et131x_down(netdev);
 
-	/* Deregistering ISR */
 	adapter->flags &= ~fMP_ADAPTER_INTERRUPT_IN_USE;
 	free_irq(netdev->irq, netdev);
 
 	/* Stop the error timer */
-	del_timer_sync(&adapter->error_timer);
-	return 0;
+	return del_timer_sync(&adapter->error_timer);
 }
 
 /**
-- 
1.7.6.4

