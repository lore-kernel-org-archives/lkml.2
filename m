Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab1F3DXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 23:23:38 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:50391 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab1F3DXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 23:23:33 -0400
From: Seungwon Jeon <tgih.jun@samsung.com>
To: linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH] mmc: dw_mmc: Supply clocks for both host and card.
Date: Thu, 30 Jun 2011 11:54:57 +0900
Message-Id: <1309402497-29191-1-git-send-email-tgih.jun@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add enabling clocks for both host controller and card.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/mmc/host/dw_mmc.c  |   33 ++++++++++++++++++++++++++++++++-
 include/linux/mmc/dw_mmc.h |    7 +++++++
 2 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 10b6979..a524416 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1797,6 +1797,24 @@ static int dw_mci_probe(struct platform_device *pdev)
 		goto err_freehost;
 	}

+	host->hclk = clk_get(&pdev->dev, pdata->hclk_name);
+	if (IS_ERR(host->hclk)) {
+		dev_err(&pdev->dev,
+			"Failed to get hclk\n");
+		ret = PTR_ERR(host->hclk);
+		goto err_freehost;
+	}
+	clk_enable(host->hclk);
+
+	host->cclk = clk_get(&pdev->dev, pdata->cclk_name);
+	if (IS_ERR(host->cclk)) {
+		dev_err(&pdev->dev,
+			"Failed to get cclk\n");
+		ret = PTR_ERR(host->cclk);
+		goto err_free_hclk;
+	}
+	clk_enable(host->cclk);
+
 	host->bus_hz = pdata->bus_hz;
 	host->quirks = pdata->quirks;

@@ -1806,7 +1824,7 @@ static int dw_mci_probe(struct platform_device *pdev)
 	ret = -ENOMEM;
 	host->regs = ioremap(regs->start, regs->end - regs->start + 1);
 	if (!host->regs)
-		goto err_freehost;
+		goto err_free_cclk;

 	host->dma_ops = pdata->dma_ops;
 	dw_mci_init_dma(host);
@@ -1945,6 +1963,13 @@ err_dmaunmap:
 		regulator_put(host->vmmc);
 	}

+err_free_cclk:
+	clk_disable(host->cclk);
+	clk_put(host->cclk);
+
+err_free_hclk:
+	clk_disable(host->hclk);
+	clk_put(host->hclk);

 err_freehost:
 	kfree(host);
@@ -1983,6 +2008,12 @@ static int __exit dw_mci_remove(struct platform_device *pdev)
 		regulator_put(host->vmmc);
 	}

+	clk_disable(host->cclk);
+	clk_put(host->cclk);
+
+	clk_disable(host->hclk);
+	clk_put(host->hclk);
+
 	iounmap(host->regs);

 	kfree(host);
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
index f3f68ee..56b3f27 100644
--- a/include/linux/mmc/dw_mmc.h
+++ b/include/linux/mmc/dw_mmc.h
@@ -47,6 +47,8 @@ struct mmc_data;
  * @cmd: The command currently being sent to the card, or NULL.
  * @data: The data currently being transferred, or NULL if no data
  *	transfer is in progress.
+ * @hclk: Clock for host.
+ * @cclk: Clock for card.
  * @use_dma: Whether DMA channel is initialized or not.
  * @sg_dma: Bus address of DMA buffer.
  * @sg_cpu: Virtual address of DMA buffer.
@@ -118,6 +120,8 @@ struct dw_mci {
 	struct mmc_request	*mrq;
 	struct mmc_command	*cmd;
 	struct mmc_data		*data;
+	struct clk		*hclk;
+	struct clk		*cclk;

 	/* DMA interface members*/
 	int			use_dma;
@@ -218,6 +222,9 @@ struct dw_mci_board {
 	/* delay in mS before detecting cards after interrupt */
 	u32 detect_delay_ms;

+	char *hclk_name;
+	char *cclk_name;
+
 	int (*init)(u32 slot_id, irq_handler_t , void *);
 	int (*get_ro)(u32 slot_id);
 	int (*get_cd)(u32 slot_id);
--
1.7.0.4

