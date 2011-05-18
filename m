Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab1ERNR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 09:17:56 -0400
Received: from adelie.canonical.com ([91.189.90.139]:58889 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328Ab1ERNRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 09:17:55 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: devel@driverdev.osuosl.org
Cc: Olaf Hartmann <o.hartmann@telovital.com>, linux-kernel@vger.kernel.org
Subject: [RFC/RFT PATCH] Staging: et131x: add suspend/resume support
Date: Wed, 18 May 2011 10:17:47 -0300
Message-Id: <1305724667-2980-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/et131x/README           |    2 +-
 drivers/staging/et131x/et131x.h         |    2 +
 drivers/staging/et131x/et131x_initpci.c |   61 ++++++++++++++++++++++++++++---
 drivers/staging/et131x/et131x_netdev.c  |    2 -
 4 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/et131x/README b/drivers/staging/et131x/README
index 28752a5..4dca010 100644
--- a/drivers/staging/et131x/README
+++ b/drivers/staging/et131x/README
@@ -14,7 +14,7 @@ TODO:
 	- kill useless typecasts (e.g. in et1310_phy.c)
 	- alloc_etherdev is initializing memory with zero?!?
 	- add_timer call in et131x_netdev.c is correct?
-	- Add power saving functionality (suspend, sleep, resume)
+	- Add power saving functionality (sleep)
 	- Implement a few more kernel Parameter (set mac )
 
 Please send patches to:
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index 8aa3365..1daf53c 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -84,6 +84,8 @@ void SetupDeviceForUnicast(struct et131x_adapter *adapter);
 
 /* et131x_netdev.c */
 struct net_device *et131x_device_alloc(void);
+int et131x_open(struct net_device *netdev);
+int et131x_close(struct net_device *netdev);
 
 /* et131x_pm.c */
 void EnablePhyComa(struct et131x_adapter *adapter);
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 50237ac..1b39141 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -806,13 +806,62 @@ static struct pci_device_id et131x_pci_table[] __devinitdata = {
 
 MODULE_DEVICE_TABLE(pci, et131x_pci_table);
 
+static int et131x_stop(struct device *dev)
+{
+	struct pci_dev *pcidev = to_pci_dev(dev);
+	struct net_device *netdev = pci_get_drvdata(pcidev);
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+
+	if (netif_running(netdev))
+		et131x_close(netdev);
+
+	et131x_adapter_memory_free(adapter);
+
+	return 0;
+}
+
+static int et131x_start(struct device *dev)
+{
+	int result;
+	struct pci_dev *pcidev = to_pci_dev(dev);
+	struct net_device *netdev = pci_get_drvdata(pcidev);
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+
+	/* If Phy COMA mode was enabled when we went down, disable it here. */
+	writel(ET_PMCSR_INIT,  &adapter->regs->global.pm_csr);
+
+	et131x_soft_reset(adapter);
+
+	result = et131x_adapter_memory_alloc(adapter);
+	if (result != 0) {
+		dev_warn(&adapter->pdev->dev,
+			 "Resume failed; couldn't re-alloc DMA memory\n");
+		return result;
+	}
+
+	et131x_init_send(adapter);
+	et131x_adapter_setup(adapter);
+
+	if (netif_running(netdev))
+		result = et131x_open(netdev);
+	return result;
+}
+
+static const struct dev_pm_ops et131x_pm = {
+	.freeze = et131x_stop,
+	.poweroff = et131x_stop,
+	.suspend = et131x_stop,
+	.restore = et131x_start,
+	.resume = et131x_start,
+	.thaw = et131x_start,
+};
+
 static struct pci_driver et131x_driver = {
-      .name	= DRIVER_NAME,
-      .id_table	= et131x_pci_table,
-      .probe	= et131x_pci_setup,
-      .remove	= __devexit_p(et131x_pci_remove),
-      .suspend	= NULL,		/* et131x_pci_suspend */
-      .resume	= NULL,		/* et131x_pci_resume */
+	.name		= DRIVER_NAME,
+	.id_table	= et131x_pci_table,
+	.probe		= et131x_pci_setup,
+	.remove		= __devexit_p(et131x_pci_remove),
+	.driver.pm	= &et131x_pm,
 };
 
 
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index b25bae2..8643cd6 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -89,8 +89,6 @@
 #include "et131x.h"
 
 struct net_device_stats *et131x_stats(struct net_device *netdev);
-int et131x_open(struct net_device *netdev);
-int et131x_close(struct net_device *netdev);
 int et131x_ioctl(struct net_device *netdev, struct ifreq *reqbuf, int cmd);
 void et131x_multicast(struct net_device *netdev);
 int et131x_tx(struct sk_buff *skb, struct net_device *netdev);
-- 
1.7.4.1

