Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab2HNK3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 06:29:18 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:54158 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab2HNK3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 06:29:14 -0400
From: Ilya Shchepetkov <shchepetkov@ispras.ru>
To: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Cc: Ilya Shchepetkov <shchepetkov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Amir Vadai <amirv@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Alexander Guller <alexg@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH 3/5] net/mlx4_en: Call netif_carrier_off() after register_netdev()
Date: Tue, 14 Aug 2012 14:28:53 +0400
Message-Id: <1344940135-17079-4-git-send-email-shchepetkov@ispras.ru>
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
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index edd9cb8..7bf2923 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1676,13 +1676,13 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 
 	mdev->pndev[port] = dev;
 
-	netif_carrier_off(dev);
 	err = register_netdev(dev);
 	if (err) {
 		en_err(priv, "Netdev registration failed for port %d\n", port);
 		goto out;
 	}
 	priv->registered = 1;
+	netif_carrier_off(dev);
 
 	en_warn(priv, "Using %d TX rings\n", prof->tx_ring_num);
 	en_warn(priv, "Using %d RX rings\n", prof->rx_ring_num);
-- 
1.7.7

