Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348Ab1JGVyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 17:54:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47165 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab1JGVyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 17:54:16 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: romieu@fr.zoreil.com, rjw@sisk.pl, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 3/4] staging: et131x: Move pm calls from pci device to driver device
Date: Fri,  7 Oct 2011 22:52:51 +0100
Message-Id: <1318024371-10294-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318024371-10294-1-git-send-email-mark.einon@gmail.com>
References: <1318024371-10294-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the pci driver suspend/resume calls up to the driver.pm ops
structure, as they are not pci device specific.

Thanks to Francois Romieu <romieu@fr.zoreil.com> for pointing this out.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x_initpci.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 95a1aff..2f03ba0 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -870,26 +870,27 @@ static void __devexit et131x_pci_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-static int et131x_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int et131x_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
 
 	if (netif_running(netdev)) {
 		netif_device_detach(netdev);
 		et131x_down(netdev);
 		pci_save_state(pdev);
-		pci_set_power_state(pdev, pci_choose_state(pdev, state));
 	}
 
 	return 0;
 }
 
-static int et131x_pci_resume(struct pci_dev *pdev)
+static int et131x_resume(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
 
 	if (netif_running(netdev)) {
-		pci_set_power_state(pdev, PCI_D0);
 		pci_restore_state(pdev);
 		et131x_up(netdev);
 		netif_device_attach(netdev);
@@ -898,6 +899,12 @@ static int et131x_pci_resume(struct pci_dev *pdev)
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(et131x_pm_ops, et131x_suspend, et131x_resume);
+#define ET131X_PM_OPS (&et131x_pm_ops)
+#else
+#define ET131X_PM_OPS NULL
+#endif
+
 static struct pci_device_id et131x_pci_table[] __devinitdata = {
 	{ET131X_PCI_VENDOR_ID, ET131X_PCI_DEVICE_ID_GIG, PCI_ANY_ID,
 	 PCI_ANY_ID, 0, 0, 0UL},
@@ -913,10 +920,7 @@ static struct pci_driver et131x_driver = {
 	.id_table	= et131x_pci_table,
 	.probe		= et131x_pci_setup,
 	.remove		= __devexit_p(et131x_pci_remove),
-#ifdef CONFIG_PM
-	.suspend	= et131x_pci_suspend,
-	.resume		= et131x_pci_resume,
-#endif
+	.driver.pm	= ET131X_PM_OPS,
 };
 
 /**
-- 
1.7.6.4

