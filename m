Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab2BBOBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 09:01:39 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:33054 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab2BBOA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 09:00:56 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, Julia Lawall <julia@diku.dk>
Subject: [PATCH 2/3] drivers/net/ethernet/ti/davinci_xxx.c: Move call to PTR_ERR after reassignment
Date: Thu,  2 Feb 2012 15:00:46 +0100
Message-Id: <1328191247-23792-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1328191247-23792-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1328191247-23792-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Delete successive assignments to the same location.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,e1;
constant c;
@@

*e = c
... when != e = e1
    when != &e
    when != true IS_ERR(e)
*PTR_ERR(e)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Reported-by: Josh Triplett <josh@joshtriplett.org>

---
 drivers/net/ethernet/ti/davinci_emac.c |    3 ++-
 drivers/net/ethernet/ti/davinci_mdio.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index efd4f3e..922a937 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1600,8 +1600,9 @@ static int emac_dev_open(struct net_device *ndev)
 		if (IS_ERR(priv->phydev)) {
 			dev_err(emac_dev, "could not connect to phy %s\n",
 				priv->phy_id);
+			ret = PTR_ERR(priv->phydev);
 			priv->phydev = NULL;
-			return PTR_ERR(priv->phydev);
+			return ret;
 		}
 
 		priv->link = 0;
diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
index ef7c9c1..af8b8fc 100644
--- a/drivers/net/ethernet/ti/davinci_mdio.c
+++ b/drivers/net/ethernet/ti/davinci_mdio.c
@@ -318,9 +318,9 @@ static int __devinit davinci_mdio_probe(struct platform_device *pdev)
 
 	data->clk = clk_get(dev, NULL);
 	if (IS_ERR(data->clk)) {
-		data->clk = NULL;
 		dev_err(dev, "failed to get device clock\n");
 		ret = PTR_ERR(data->clk);
+		data->clk = NULL;
 		goto bail_out;
 	}
 

