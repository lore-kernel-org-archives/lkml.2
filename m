Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732Ab0JFIVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 04:21:09 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:59329 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758706Ab0JFIVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 04:21:05 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 4/4] DMAENGINE: ste_dma40: fix resource leaks in error paths.
Date: Wed, 6 Oct 2010 10:20:38 +0200
Message-ID: <1286353238-13742-5-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1286353238-13742-4-git-send-email-linus.walleij@stericsson.com>
References: <1286353238-13742-1-git-send-email-linus.walleij@stericsson.com>
 <1286353238-13742-2-git-send-email-linus.walleij@stericsson.com>
 <1286353238-13742-3-git-send-email-linus.walleij@stericsson.com>
 <1286353238-13742-4-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Fix some leaks of allocated descriptors in error paths.

Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 554e294..c07d989 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1728,6 +1728,8 @@ struct dma_async_tx_descriptor *stedma40_memcpy_sg(struct dma_chan *chan,
 
 	return &d40d->txd;
 err:
+	if (d40d)
+		d40_desc_free(d40c, d40d);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return NULL;
 }
@@ -1939,8 +1941,9 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 err_fill_lli:
 	dev_err(&d40c->chan.dev->device,
 		"[%s] Failed filling in PHY LLI\n", __func__);
-	d40_pool_lli_free(d40d);
 err:
+	if (d40d)
+		d40_desc_free(d40c, d40d);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return NULL;
 }
@@ -2079,10 +2082,9 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 
 	spin_lock_irqsave(&d40c->lock, flags);
 	d40d = d40_desc_get(d40c);
-	spin_unlock_irqrestore(&d40c->lock, flags);
 
 	if (d40d == NULL)
-		return NULL;
+		goto err;
 
 	if (d40c->log_num != D40_PHY_CHAN)
 		err = d40_prep_slave_sg_log(d40d, d40c, sgl, sg_len,
@@ -2095,7 +2097,7 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 			"[%s] Failed to prepare %s slave sg job: %d\n",
 			__func__,
 			d40c->log_num != D40_PHY_CHAN ? "log" : "phy", err);
-		return NULL;
+		goto err;
 	}
 
 	d40d->txd.flags = dma_flags;
@@ -2104,7 +2106,14 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 
 	d40d->txd.tx_submit = d40_tx_submit;
 
+	spin_unlock_irqrestore(&d40c->lock, flags);
 	return &d40d->txd;
+
+err:
+	if (d40d)
+		d40_desc_free(d40c, d40d);
+	spin_unlock_irqrestore(&d40c->lock, flags);
+	return NULL;
 }
 
 static enum dma_status d40_tx_status(struct dma_chan *chan,
-- 
1.6.3.3

