Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab1BUUUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 15:20:47 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:52243 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab1BUUUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 15:20:45 -0500
X-Auth-Info: 18p4hOMhLxYUN3zTIPMz/4OI76BYfoP6/KgV4uR9h5g=
From: Ilya Yanok <yanok@emcraft.com>
To: sfr@canb.auug.org.au, greg@kroah.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de, davem@davemloft.net,
        netdev@vger.kernel.org
Cc: Ilya Yanok <yanok@emcraft.com>
Subject: [PATCH] dnet: fix wrong use of platform_set_drvdata()
Date: Mon, 21 Feb 2011 21:20:30 +0100
Message-Id: <1298319630-18159-1-git-send-email-yanok@emcraft.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <4D62C897.5020707@emcraft.com>
References: <4D62C897.5020707@emcraft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platform_set_drvdata() was used with argument of incorrect type and
could cause memory corruption. Moreover, because of not setting drvdata
in the correct place not all resources were freed upon module unload.

Signed-off-by: Ilya Yanok <yanok@emcraft.com>
---
 drivers/net/dnet.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dnet.c b/drivers/net/dnet.c
index 9d8a20b..8318ea0 100644
--- a/drivers/net/dnet.c
+++ b/drivers/net/dnet.c
@@ -337,8 +337,6 @@ static int dnet_mii_init(struct dnet *bp)
 	for (i = 0; i < PHY_MAX_ADDR; i++)
 		bp->mii_bus->irq[i] = PHY_POLL;
 
-	platform_set_drvdata(bp->dev, bp->mii_bus);
-
 	if (mdiobus_register(bp->mii_bus)) {
 		err = -ENXIO;
 		goto err_out_free_mdio_irq;
@@ -863,6 +861,7 @@ static int __devinit dnet_probe(struct platform_device *pdev)
 	bp = netdev_priv(dev);
 	bp->dev = dev;
 
+	platform_set_drvdata(pdev, dev);
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	spin_lock_init(&bp->lock);
-- 
1.7.4

