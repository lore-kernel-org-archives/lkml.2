Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab1JAKP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 06:15:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59640 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab1JAKPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 06:15:43 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@linux.intel.com,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 4/8] staging: et131x: Add pci suspend & resume functions
Date: Sat,  1 Oct 2011 11:14:13 +0100
Message-Id: <1317464057-18231-4-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1317464057-18231-1-git-send-email-mark.einon@gmail.com>
References: <1317464057-18231-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added basic suspend & resume functionality.
Tested on an et1310 device, and putting Fedora15 host in and out of
hibernation successfully.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/README           |    1 -
 drivers/staging/et131x/et131x.h         |    2 +
 drivers/staging/et131x/et131x_initpci.c |   45 +++++++++++++++++++++++++++++-
 3 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/et131x/README b/drivers/staging/et131x/README
index d24ef84..42c388d 100644
--- a/drivers/staging/et131x/README
+++ b/drivers/staging/et131x/README
@@ -10,7 +10,6 @@ driver as they did not build properly at the time.
 
 TODO:
 	- add_timer call in et131x_netdev.c is correct?
-	- Add power saving functionality (suspend, sleep, resume)
 	- Implement a few more kernel Parameter (set mac )
 
 Please send patches to:
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index d967c5a1..15486d1 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -82,6 +82,8 @@ void et1310_setup_device_for_multicast(struct et131x_adapter *adapter);
 void et1310_setup_device_for_unicast(struct et131x_adapter *adapter);
 
 /* et131x_netdev.c */
+int et131x_open(struct net_device *netdev);
+int et131x_close(struct net_device *netdev);
 struct net_device *et131x_device_alloc(void);
 void et131x_enable_txrx(struct net_device *netdev);
 void et131x_disable_txrx(struct net_device *netdev);
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 10283a3..e166fde 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -869,6 +869,45 @@ static void __devexit et131x_pci_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+static int et131x_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+
+	if (!netif_running(netdev))
+		return 0;
+
+	et131x_close(netdev);
+	netif_device_detach(netdev);
+
+	pci_save_state(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
+	return 0;
+}
+
+static int et131x_pci_resume(struct pci_dev *pdev)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	int err = 0;
+
+	if (!netif_running(netdev))
+		return 0;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+
+	err = et131x_open(netdev);
+	if (err) {
+		dev_err(&pdev->dev, "Can't resume interface!\n");
+		goto out;
+	}
+
+	netif_device_attach(netdev);
+
+out:
+	return err;
+}
+
 static struct pci_device_id et131x_pci_table[] __devinitdata = {
 	{ET131X_PCI_VENDOR_ID, ET131X_PCI_DEVICE_ID_GIG, PCI_ANY_ID,
 	 PCI_ANY_ID, 0, 0, 0UL},
@@ -884,8 +923,10 @@ static struct pci_driver et131x_driver = {
 	.id_table	= et131x_pci_table,
 	.probe		= et131x_pci_setup,
 	.remove		= __devexit_p(et131x_pci_remove),
-	.suspend	= NULL,		/* et131x_pci_suspend */
-	.resume		= NULL,		/* et131x_pci_resume */
+#ifdef CONFIG_PM
+	.suspend	= et131x_pci_suspend,
+	.resume		= et131x_pci_resume,
+#endif
 };
 
 /**
-- 
1.7.6.4

