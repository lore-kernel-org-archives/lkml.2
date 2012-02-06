Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab2BFSkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:40:08 -0500
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:39703 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab2BFSkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:40:05 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Cc: "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Eugenia Emantayev <eugenia@mellanox.co.il>,
        Alexander Guller <alexg@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH 1/2] mlx4: allow device removal by fixing dma unmap size
Date: Mon,  6 Feb 2012 16:39:49 -0200
Message-Id: <1328553590-27677-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.4
x-cbid: 12020618-1524-0000-0000-0000015C0853
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After opening the network interface, Mellanox ConnectX device cannot be
removed by hotplug because it has not properly unmapped all DMA memory.

It happens that mlx4_en_activate_rx_rings overrides the variable that
keeps the size of the memory mapped.

This is fixed by passing to mlx4_en_destroy_rx_ring the same size that is
given to mlx4_en_create_rx_ring.

After applying this patch, hot unplugging the device works after opening
the interface.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    3 ++-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c     |    4 ++--
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   |    3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 467ae58..149e60d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -892,7 +892,8 @@ void mlx4_en_free_resources(struct mlx4_en_priv *priv)
 
 	for (i = 0; i < priv->rx_ring_num; i++) {
 		if (priv->rx_ring[i].rx_info)
-			mlx4_en_destroy_rx_ring(priv, &priv->rx_ring[i]);
+			mlx4_en_destroy_rx_ring(priv, &priv->rx_ring[i],
+				priv->prof->rx_ring_size, priv->stride);
 		if (priv->rx_cq[i].buf)
 			mlx4_en_destroy_cq(priv, &priv->rx_cq[i]);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 971d4b6..d1c631e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -380,12 +380,12 @@ err_allocator:
 }
 
 void mlx4_en_destroy_rx_ring(struct mlx4_en_priv *priv,
-			     struct mlx4_en_rx_ring *ring)
+			     struct mlx4_en_rx_ring *ring, u32 size, u16 stride)
 {
 	struct mlx4_en_dev *mdev = priv->mdev;
 
 	mlx4_en_unmap_buffer(&ring->wqres.buf);
-	mlx4_free_hwq_res(mdev->dev, &ring->wqres, ring->buf_size + TXBB_SIZE);
+	mlx4_free_hwq_res(mdev->dev, &ring->wqres, size * stride + TXBB_SIZE);
 	vfree(ring->rx_info);
 	ring->rx_info = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index 35f0884..d60335f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -528,7 +528,8 @@ int mlx4_en_create_rx_ring(struct mlx4_en_priv *priv,
 			   struct mlx4_en_rx_ring *ring,
 			   u32 size, u16 stride);
 void mlx4_en_destroy_rx_ring(struct mlx4_en_priv *priv,
-			     struct mlx4_en_rx_ring *ring);
+			     struct mlx4_en_rx_ring *ring,
+			     u32 size, u16 stride);
 int mlx4_en_activate_rx_rings(struct mlx4_en_priv *priv);
 void mlx4_en_deactivate_rx_ring(struct mlx4_en_priv *priv,
 				struct mlx4_en_rx_ring *ring);
-- 
1.7.4.4

