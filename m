Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab2BFSkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:40:09 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:44545 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab2BFSkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:40:07 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Cc: "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Eugenia Emantayev <eugenia@mellanox.co.il>,
        Alexander Guller <alexg@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH 2/2] mlx4: fix DMA mapping leak when allocation fails
Date: Mon,  6 Feb 2012 16:39:50 -0200
Message-Id: <1328553590-27677-2-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1328553590-27677-1-git-send-email-cascardo@linux.vnet.ibm.com>
References: <1328553590-27677-1-git-send-email-cascardo@linux.vnet.ibm.com>
x-cbid: 12020618-8936-0000-0000-000005D50B4C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mlx4_en_prepare_rx_desc does not correctly clean up after it finds an
allocation failure. It should unmap a page before calling put_page, but
it only calls the later.

This bug would prevent a device removal using hotplug after setting the
device MTU to 9000 and opening the network interface. After the fix, we
still see the allocation failure with MTU 9000, but we are able to
remove the device.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index d1c631e..d4ad8c2 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -168,8 +168,12 @@ static int mlx4_en_prepare_rx_desc(struct mlx4_en_priv *priv,
 	return 0;
 
 err:
-	while (i--)
+	while (i--) {
+		dma_addr_t dma = be64_to_cpu(rx_desc->data[i].addr);
+		pci_unmap_single(priv->mdev->pdev, dma, skb_frags[i].size,
+				 PCI_DMA_FROMDEVICE);
 		put_page(skb_frags[i].page);
+	}
 	return -ENOMEM;
 }
 
-- 
1.7.4.4

