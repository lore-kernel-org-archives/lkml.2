Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993109Ab2KOEMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:12:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:49474 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993074Ab2KOEMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Roland Stigge <stigge@antcom.de>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 51/66] drivers/net/ethernet/nxp/lpc_eth.c: Call mdiobus_unregister before mdiobus_free
Date: Wed, 14 Nov 2012 20:10:56 -0800
Message-Id: <20121115040942.815069685@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Peter Senna Tschudin <peter.senna@gmail.com>

[ Upstream commit 57c10b61c84bfed68b1b317d6f507a392724b9c4 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/nxp/lpc_eth.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1524,6 +1524,7 @@ static int lpc_eth_drv_remove(struct pla
 				  pldat->dma_buff_base_p);
 	free_irq(ndev->irq, ndev);
 	iounmap(pldat->net_base);
+	mdiobus_unregister(pldat->mii_bus);
 	mdiobus_free(pldat->mii_bus);
 	clk_disable(pldat->clk);
 	clk_put(pldat->clk);


