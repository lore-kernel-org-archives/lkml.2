Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156Ab1FARLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:11:35 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:38642 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759036Ab1FARKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:10:23 -0400
From: Julia Lawall <julia@diku.dk>
To: "David S. Miller" <davem@davemloft.net>
Cc: kernel-janitors@vger.kernel.org, Cyril Chemparathy <cyril@ti.com>,
        Sriramakrishnan A G <srk@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Stefan Weil <weil@mail.berlios.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/10] drivers/net/davinci_emac.c: add missing clk_put
Date: Wed,  1 Jun 2011 19:10:10 +0200
Message-Id: <1306948213-20767-7-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Go to existing error handling code at the end of the function that calls
clk_put.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression e1,e2;
statement S;
@@

e1 = clk_get@p1(...);
... when != e1 = e2
    when != clk_put(e1)
    when any
if (...) { ... when != clk_put(e1)
               when != if (...) { ... clk_put(e1) ... }
* return@p3 ...;
 } else S
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/davinci_emac.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/davinci_emac.c b/drivers/net/davinci_emac.c
index 29a4f06..dcc4a17 100644
--- a/drivers/net/davinci_emac.c
+++ b/drivers/net/davinci_emac.c
@@ -1781,8 +1781,8 @@ static int __devinit davinci_emac_probe(struct platform_device *pdev)
 	ndev = alloc_etherdev(sizeof(struct emac_priv));
 	if (!ndev) {
 		dev_err(&pdev->dev, "error allocating net_device\n");
-		clk_put(emac_clk);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto free_clk;
 	}
 
 	platform_set_drvdata(pdev, ndev);
@@ -1796,7 +1796,8 @@ static int __devinit davinci_emac_probe(struct platform_device *pdev)
 	pdata = pdev->dev.platform_data;
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform data\n");
-		return -ENODEV;
+		rc = -ENODEV;
+		goto probe_quit;
 	}
 
 	/* MAC addr and PHY mask , RMII enable info from platform_data */
@@ -1929,8 +1930,9 @@ no_dma:
 	iounmap(priv->remap_addr);
 
 probe_quit:
-	clk_put(emac_clk);
 	free_netdev(ndev);
+free_clk:
+	clk_put(emac_clk);
 	return rc;
 }
 
