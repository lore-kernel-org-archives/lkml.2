Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1LBLZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 06:25:19 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60335 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab1LBLZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 06:25:18 -0500
Message-ID: <1322825107.16787.1.camel@phoenix>
Subject: [PATCH] ARM: pxa: fix error handling in pxa2xx_drv_pcmcia_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-pcmcia@lists.infradead.org
Date: Fri, 02 Dec 2011 19:25:07 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pxa2xx_drv_pcmcia_add_one fails, it will go to err1 error path.
Add a missing clk_put in the error path.

Checking the ret value after the for loop is redundant, it is always false.
Thus remove the redundant checking.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/pcmcia/pxa2xx_base.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/pcmcia/pxa2xx_base.c b/drivers/pcmcia/pxa2xx_base.c
index a87e272..64d433e 100644
--- a/drivers/pcmcia/pxa2xx_base.c
+++ b/drivers/pcmcia/pxa2xx_base.c
@@ -328,21 +328,15 @@ static int pxa2xx_drv_pcmcia_probe(struct platform_device *dev)
 			goto err1;
 	}
 
-	if (ret) {
-		while (--i >= 0)
-			soc_pcmcia_remove_one(&sinfo->skt[i]);
-		kfree(sinfo);
-		clk_put(clk);
-	} else {
-		pxa2xx_configure_sockets(&dev->dev);
-		dev_set_drvdata(&dev->dev, sinfo);
-	}
+	pxa2xx_configure_sockets(&dev->dev);
+	dev_set_drvdata(&dev->dev, sinfo);
 
 	return 0;
 
 err1:
 	while (--i >= 0)
 		soc_pcmcia_remove_one(&sinfo->skt[i]);
+	clk_put(clk);
 	kfree(sinfo);
 err0:
 	return ret;
-- 
1.7.5.4



