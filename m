Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab0LGLHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 06:07:54 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:34250 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814Ab0LGLHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 06:07:53 -0500
Message-ID: <4CFE162E.9080002@dsn.okisemi.com>
Date: Tue, 07 Dec 2010 20:10:38 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>, socketcan-core@lists.berlios.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
CC: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: [PATCH net-next-2.6 v8 16/20] CAN : Move MSI processing to probe/remove
 processing.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, in case this driver is integrated as module, and when this
module is re-installed, no interrupts is to be occurred.
For the above issue, move MSI processing to open/release processing.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index a1fd3be..ace1fe7 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -845,15 +845,6 @@ static int pch_can_open(struct net_device *ndev)
 	struct pch_can_priv *priv = netdev_priv(ndev);
 	int retval;
 
-	retval = pci_enable_msi(priv->dev);
-	if (retval) {
-		netdev_err(ndev, "PCH CAN opened without MSI\n");
-		priv->use_msi = 0;
-	} else {
-		netdev_err(ndev, "PCH CAN opened with MSI\n");
-		priv->use_msi = 1;
-	}
-
 	/* Regstering the interrupt. */
 	retval = request_irq(priv->dev->irq, pch_can_interrupt, IRQF_SHARED,
 			     ndev->name, ndev);
@@ -879,9 +870,6 @@ static int pch_can_open(struct net_device *ndev)
 err_open_candev:
 	free_irq(priv->dev->irq, ndev);
 req_irq_err:
-	if (priv->use_msi)
-		pci_disable_msi(priv->dev);
-
 	pch_can_release(priv);
 
 	return retval;
@@ -895,8 +883,6 @@ static int pch_close(struct net_device *ndev)
 	napi_disable(&priv->napi);
 	pch_can_release(priv);
 	free_irq(priv->dev->irq, ndev);
-	if (priv->use_msi)
-		pci_disable_msi(priv->dev);
 	close_candev(ndev);
 	priv->can.state = CAN_STATE_STOPPED;
 	return 0;
@@ -975,12 +961,14 @@ static void __devexit pch_can_remove(struct pci_dev *pdev)
 	struct pch_can_priv *priv = netdev_priv(ndev);
 
 	unregister_candev(priv->ndev);
-	free_candev(priv->ndev);
 	pci_iounmap(pdev, priv->regs);
+	if (priv->use_msi)
+		pci_disable_msi(priv->dev);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 	pch_can_reset(priv);
+	free_candev(priv->ndev);
 }
 
 #ifdef CONFIG_PM
@@ -1244,6 +1232,15 @@ static int __devinit pch_can_probe(struct pci_dev *pdev,
 
 	netif_napi_add(ndev, &priv->napi, pch_can_poll, PCH_RX_OBJ_END);
 
+	rc = pci_enable_msi(priv->dev);
+	if (rc) {
+		netdev_err(ndev, "PCH CAN opened without MSI\n");
+		priv->use_msi = 0;
+	} else {
+		netdev_err(ndev, "PCH CAN opened with MSI\n");
+		priv->use_msi = 1;
+	}
+
 	rc = register_candev(ndev);
 	if (rc) {
 		dev_err(&pdev->dev, "Failed register_candev %d\n", rc);
@@ -1253,6 +1250,8 @@ static int __devinit pch_can_probe(struct pci_dev *pdev,
 	return 0;
 
 probe_exit_reg_candev:
+	if (priv->use_msi)
+		pci_disable_msi(priv->dev);
 	free_candev(ndev);
 probe_exit_alloc_candev:
 	pci_iounmap(pdev, addr);
-- 
1.6.0.6
