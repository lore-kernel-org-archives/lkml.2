Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0FTV2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 17:28:47 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:46785 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873Ab0FTVZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 17:25:26 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 05/19] DMAENGINE: ste_dma40: improve allocation error handling
Date: Sun, 20 Jun 2010 23:25:15 +0200
Message-ID: <1277069115-30838-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Better error handling when channel allocation fails.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index b60a6db..8ed1547 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1239,7 +1239,7 @@ static int d40_free_dma(struct d40_chan *d40c)
 
 	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
 	if (res) {
-		dev_err(&d40c->chan.dev->device, "[%s] suspend\n",
+		dev_err(&d40c->chan.dev->device, "[%s] suspend failed\n",
 			__func__);
 		return res;
 	}
@@ -1657,8 +1657,12 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	 */
 	if (d40c->dma_cfg.channel_type == 0) {
 		err = d40_config_memcpy(d40c);
-		if (err)
-			goto err_alloc;
+		if (err) {
+			dev_err(&d40c->chan.dev->device,
+				"[%s] Failed to configure memcpy channel\n",
+				__func__);
+			goto fail;
+		}
 	}
 	is_free_phy = (d40c->phy_chan == NULL);
 
@@ -1666,7 +1670,7 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	if (err) {
 		dev_err(&d40c->chan.dev->device,
 			"[%s] Failed to allocate channel\n", __func__);
-		goto err_alloc;
+		goto fail;
 	}
 
 	/* Fill in basic CFG register values */
@@ -1699,17 +1703,9 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 				__func__);
 		}
 	}
-
+fail:
 	spin_unlock_irqrestore(&d40c->lock, flags);
-	return 0;
-
- err_config:
-	(void) d40_free_dma(d40c);
- err_alloc:
-	spin_unlock_irqrestore(&d40c->lock, flags);
-	dev_err(&d40c->chan.dev->device,
-		"[%s] Channel allocation failed\n", __func__);
-	return -EINVAL;
+	return err;
 }
 
 static void d40_free_chan_resources(struct dma_chan *chan)
-- 
1.6.3.3

