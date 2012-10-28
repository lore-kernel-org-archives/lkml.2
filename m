Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab2J1QMQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 12:12:16 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55631 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab2J1QMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 12:12:14 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: davem@davemloft.net
Cc: stigge@antcom.de, edumazet@google.com, djduanjiong@gmail.com,
        aletes.xgr@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 1/2] drivers/net/ethernet/nxp/lpc_eth.c: Call mdiobus_unregister before mdiobus_free
Date: Sun, 28 Oct 2012 17:12:00 +0100
Message-Id: <1351440721-9121-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
This problem is somewhat mystifying. If the patch is correct, there were
probably many OOPSese caused by not calling mdiobus_unregister...
Reporting anyway...

 drivers/net/ethernet/nxp/lpc_eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 53743f7..af8b414 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1524,6 +1524,7 @@ static int lpc_eth_drv_remove(struct platform_device *pdev)
 				  pldat->dma_buff_base_p);
 	free_irq(ndev->irq, ndev);
 	iounmap(pldat->net_base);
+	mdiobus_unregister(pldat->mii_bus);
 	mdiobus_free(pldat->mii_bus);
 	clk_disable(pldat->clk);
 	clk_put(pldat->clk);
-- 
1.7.11.7

