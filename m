Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab2LMONP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:13:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44979 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933116Ab2LMONK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:13:10 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Senna Tschudin <peter.senna@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 200/241] drivers/net/ethernet/nxp/lpc_eth.c: Call mdiobus_unregister before mdiobus_free
Date: Thu, 13 Dec 2012 11:59:25 -0200
Message-Id: <1355407206-17100-201-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Senna Tschudin <peter.senna@gmail.com>

commit 57c10b61c84bfed68b1b317d6f507a392724b9c4 upstream.

Based on commit b27393aecf66199f5ddad37c302d3e0cfadbe6c0

Calling mdiobus_free without calling mdiobus_unregister causes
BUG_ON(). This patch fixes the issue.

The semantic patch that found this issue(http://coccinelle.lip6.fr/):
// <smpl>
@@
expression E;
@@
  ... when != mdiobus_unregister(E);

+ mdiobus_unregister(E);
  mdiobus_free(E);
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Tested-by: Roland Stigge <stigge@antcom.de>
Tested-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/nxp/lpc_eth.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 083d671..6793190 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1543,6 +1543,7 @@ static int lpc_eth_drv_remove(struct platform_device *pdev)
 				  pldat->dma_buff_base_p);
 	free_irq(ndev->irq, ndev);
 	iounmap(pldat->net_base);
+	mdiobus_unregister(pldat->mii_bus);
 	mdiobus_free(pldat->mii_bus);
 	clk_disable(pldat->clk);
 	clk_put(pldat->clk);
-- 
1.7.9.5

