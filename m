Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab2LLJki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:40:38 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64594 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab2LLJiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:38:20 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Per Forlin <per.forlin@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 3/7] dmaengine: ste_dma40: set dma max seg size
Date: Wed, 12 Dec 2012 10:37:17 +0100
Message-Id: <1355305041-2338-4-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1355305041-2338-1-git-send-email-fabio.baltieri@linaro.org>
References: <1355305041-2338-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Per Forlin <per.forlin@stericsson.com>

Maximum DMA seg size is (0xffff x data_width).  If max seg
size is not set it deafults to 64k.  This results in failure
if transferring 64k in byte mode.
Large seg sizes may be supported by splitting large transfer.

Signed-off-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/dma/ste_dma40.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index ae55091..16c96f5 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -345,6 +345,7 @@ struct d40_base {
 	int				  irq;
 	int				  num_phy_chans;
 	int				  num_log_chans;
+	struct device_dma_parameters	  dma_parms;
 	struct dma_device		  dma_both;
 	struct dma_device		  dma_slave;
 	struct dma_device		  dma_memcpy;
@@ -3363,6 +3364,13 @@ static int __init d40_probe(struct platform_device *pdev)
 	if (err)
 		goto failure;
 
+	base->dev->dma_parms = &base->dma_parms;
+	err = dma_set_max_seg_size(base->dev, STEDMA40_MAX_SEG_SIZE);
+	if (err) {
+		d40_err(&pdev->dev, "Failed to set dma max seg size\n");
+		goto failure;
+	}
+
 	d40_hw_init(base);
 
 	dev_info(base->dev, "initialized\n");
-- 
1.7.12.1

