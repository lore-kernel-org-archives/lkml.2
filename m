Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab2KKMut (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:50:49 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56079 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab2KKMuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:50:46 -0500
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-mips@linux-mips.org
Cc: Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC] net: ethernet: bcm63xx_enet: use clk_{prepare_enable,disable_unprepare}
Date: Sun, 11 Nov 2012 13:50:41 +0100
Message-Id: <1352638249-29298-8-git-send-email-jonas.gorski@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proper clk_prepare/unprepare calls in preparation for switching to
the generic clock framework.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index c7ca7ec..9449e13 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -1677,7 +1677,7 @@ static int __devinit bcm_enet_probe(struct platform_device *pdev)
 		ret = PTR_ERR(priv->mac_clk);
 		goto out_unmap;
 	}
-	clk_enable(priv->mac_clk);
+	clk_prepare_enable(priv->mac_clk);
 
 	/* initialize default and fetch platform data */
 	priv->rx_ring_size = BCMENET_DEF_RX_DESC;
@@ -1706,7 +1706,7 @@ static int __devinit bcm_enet_probe(struct platform_device *pdev)
 			priv->phy_clk = NULL;
 			goto out_put_clk_mac;
 		}
-		clk_enable(priv->phy_clk);
+		clk_prepare_enable(priv->phy_clk);
 	}
 
 	/* do minimal hardware init to be able to probe mii bus */
@@ -1808,12 +1808,12 @@ out_uninit_hw:
 	/* turn off mdc clock */
 	enet_writel(priv, 0, ENET_MIISC_REG);
 	if (priv->phy_clk) {
-		clk_disable(priv->phy_clk);
+		clk_disable_unprepare(priv->phy_clk);
 		clk_put(priv->phy_clk);
 	}
 
 out_put_clk_mac:
-	clk_disable(priv->mac_clk);
+	clk_disable_unprepare(priv->mac_clk);
 	clk_put(priv->mac_clk);
 
 out_unmap:
@@ -1864,10 +1864,10 @@ static int __devexit bcm_enet_remove(struct platform_device *pdev)
 
 	/* disable hw block clocks */
 	if (priv->phy_clk) {
-		clk_disable(priv->phy_clk);
+		clk_disable_unprepare(priv->phy_clk);
 		clk_put(priv->phy_clk);
 	}
-	clk_disable(priv->mac_clk);
+	clk_disable_unprepare(priv->mac_clk);
 	clk_put(priv->mac_clk);
 
 	platform_set_drvdata(pdev, NULL);
-- 
1.7.2.5

