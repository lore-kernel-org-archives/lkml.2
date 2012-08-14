Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab2HNK3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 06:29:36 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:54155 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956Ab2HNK3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 06:29:16 -0400
From: Ilya Shchepetkov <shchepetkov@ispras.ru>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Ilya Shchepetkov <shchepetkov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH 2/5] de2104x: Call netif_carrier_off() after register_netdev()
Date: Tue, 14 Aug 2012 14:28:52 +0400
Message-Id: <1344940135-17079-3-git-send-email-shchepetkov@ispras.ru>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1344940135-17079-1-git-send-email-shchepetkov@ispras.ru>
References: <1344940135-17079-1-git-send-email-shchepetkov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For carrier detection to work properly when binding the driver with a
cable unplugged, netif_carrier_off() should be called after
register_netdev(), not before.

Calling netif_carrier_off() before register_netdev() was causing the
network interface to miss a linkwatch pending event leading to an
inconsistent state if the link is not up when interface is initialized.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Ilya Shchepetkov <shchepetkov@ispras.ru>
---
 drivers/net/ethernet/dec/tulip/de2104x.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index 61cc093..237f254 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -2005,8 +2005,6 @@ static int __devinit de_init_one (struct pci_dev *pdev,
 		de->media_timer.function = de21041_media_timer;
 	de->media_timer.data = (unsigned long) de;
 
-	netif_carrier_off(dev);
-
 	/* wake up device, assign resources */
 	rc = pci_enable_device(pdev);
 	if (rc)
@@ -2074,6 +2072,9 @@ static int __devinit de_init_one (struct pci_dev *pdev,
 	rc = register_netdev(dev);
 	if (rc)
 		goto err_out_iomap;
+
+	/* turn off carrier */
+	netif_carrier_off(dev);
 
 	/* print info about board and interface just registered */
 	netdev_info(dev, "%s at %p, %pM, IRQ %d\n",
-- 
1.7.7

