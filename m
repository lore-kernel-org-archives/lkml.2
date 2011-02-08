Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab1BHJ1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 04:27:40 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:30970 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752341Ab1BHJ1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 04:27:37 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: wg@grandegger.com, socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 2/3] pch_can: fix rmmod issue
Date: Tue,  8 Feb 2011 18:29:02 +0900
Message-Id: <1297157343-3213-2-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1297157343-3213-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1297157343-3213-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when rmmod pch_can, kernel failure occurs.
The cause is pci_iounmap executed before pch_can_reset.
Thus pci_iounmap moves after pch_can_reset.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index 9b171d1..342d514 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -959,13 +959,13 @@ static void __devexit pch_can_remove(struct pci_dev *pdev)
 	struct pch_can_priv *priv = netdev_priv(ndev);
 
 	unregister_candev(priv->ndev);
-	pci_iounmap(pdev, priv->regs);
 	if (priv->use_msi)
 		pci_disable_msi(priv->dev);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 	pch_can_reset(priv);
+	pci_iounmap(pdev, priv->regs);
 	free_candev(priv->ndev);
 }
 
-- 
1.7.3.4

