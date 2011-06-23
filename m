Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938Ab1FWCDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:03:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60829 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758829Ab1FWCAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:00:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mBEKQnwGACsK5qkMj27Wp8zOZdc4tjZSRI8YUpN6ggg5ZfYPTBLdh/wg95NBmp5zs8
         dLMLMCpQukSDU4L3pJvWKyFg/PBUtJk0a9Tn1vQRYUgb36qs8ec/HapT/ZmxGEiIjhK8
         Sid15IXN/qHUevodz34hmvGRjeR51F6K3adwE=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 05/11] spi-dw: split spi_dw_enable_chip() into spi_dw_enable()/spi_dw_disable()
Date: Wed, 22 Jun 2011 19:00:07 -0700
Message-Id: <1308794413-11069-6-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Split spi_dw_enable_chip() into two inline functions for readabilty.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/spi/spi-dw-mid.c |    4 ++--
 drivers/spi/spi-dw.c     |   16 ++++++++--------
 drivers/spi/spi-dw.h     |    9 +++++++--
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
index 7659cef..78e64d3 100644
--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -115,7 +115,7 @@ static int mid_spi_dma_transfer(struct spi_dw *dws, int cs_change)
 
 	/* 1. setup DMA related registers */
 	if (cs_change) {
-		spi_dw_enable_chip(dws, 0);
+		spi_dw_disable(dws);
 		dw_writew(dws, dmardlr, 0xf);
 		dw_writew(dws, dmatdlr, 0x10);
 		if (dws->tx_dma)
@@ -123,7 +123,7 @@ static int mid_spi_dma_transfer(struct spi_dw *dws, int cs_change)
 		if (dws->rx_dma)
 			dma_ctrl |= 0x1;
 		dw_writew(dws, dmacr, dma_ctrl);
-		spi_dw_enable_chip(dws, 1);
+		spi_dw_enable(dws);
 	}
 
 	dws->dma_chan_done = 0;
diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 3d98e4c..ad92826 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -293,7 +293,7 @@ static void spi_dw_giveback(struct spi_dw *dws)
 static void spi_dw_int_error_stop(struct spi_dw *dws, const char *msg)
 {
 	/* Stop the hw */
-	spi_dw_enable_chip(dws, 0);
+	spi_dw_disable(dws);
 
 	dev_err(&dws->master->dev, "%s\n", msg);
 	dws->cur_msg->state = ERROR_STATE;
@@ -518,7 +518,7 @@ static void spi_dw_pump_transfers(unsigned long data)
 	 *	3. control value changes
 	 */
 	if (dw_readw(dws, ctrl0) != cr0 || cs_change || clk_div || imask) {
-		spi_dw_enable_chip(dws, 0);
+		spi_dw_disable(dws);
 
 		if (dw_readw(dws, ctrl0) != cr0)
 			dw_writew(dws, ctrl0, cr0);
@@ -533,7 +533,7 @@ static void spi_dw_pump_transfers(unsigned long data)
 		if (txint_level)
 			dw_writew(dws, txfltr, txint_level);
 
-		spi_dw_enable_chip(dws, 1);
+		spi_dw_enable(dws);
 		if (cs_change)
 			dws->prev_chip = chip;
 	}
@@ -776,9 +776,9 @@ static int destroy_queue(struct spi_dw *dws)
 /* Restart the controller, disable all interrupts, clean rx fifo */
 static void spi_dw_hw_init(struct spi_dw *dws)
 {
-	spi_dw_enable_chip(dws, 0);
+	spi_dw_disable(dws);
 	spi_dw_mask_intr(dws, 0xff);
-	spi_dw_enable_chip(dws, 1);
+	spi_dw_enable(dws);
 
 	/*
 	 * Try to detect the FIFO depth if not set by interface driver,
@@ -868,7 +868,7 @@ err_queue_alloc:
 	if (dws->dma_ops && dws->dma_ops->dma_exit)
 		dws->dma_ops->dma_exit(dws);
 err_diable_hw:
-	spi_dw_enable_chip(dws, 0);
+	spi_dw_disable(dws);
 	free_irq(dws->irq, dws);
 err_free_master:
 	spi_master_put(master);
@@ -893,7 +893,7 @@ void __devexit spi_dw_remove_host(struct spi_dw *dws)
 
 	if (dws->dma_ops && dws->dma_ops->dma_exit)
 		dws->dma_ops->dma_exit(dws);
-	spi_dw_enable_chip(dws, 0);
+	spi_dw_disable(dws);
 	/* Disable clk */
 	spi_dw_set_clk(dws, 0);
 	free_irq(dws->irq, dws);
@@ -910,7 +910,7 @@ int spi_dw_suspend_host(struct spi_dw *dws)
 	ret = spi_dw_stop_queue(dws);
 	if (ret)
 		return ret;
-	spi_dw_enable_chip(dws, 0);
+	spi_dw_disable(dws);
 	spi_dw_set_clk(dws, 0);
 	return ret;
 }
diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
index 6a1ee63..860bc34 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -161,9 +161,14 @@ struct spi_dw {
 #define dw_writew(dw, name, val) \
 	__raw_writew((val), &(((struct spi_dw_reg *)dw->regs)->name))
 
-static inline void spi_dw_enable_chip(struct spi_dw *dws, int enable)
+static inline void spi_dw_enable(struct spi_dw *dws)
 {
-	dw_writel(dws, ssienr, (enable ? 1 : 0));
+	dw_writel(dws, ssienr, 1);
+}
+
+static inline void spi_dw_disable(struct spi_dw *dws)
+{
+	dw_writel(dws, ssienr, 0);
 }
 
 static inline void spi_dw_set_clk(struct spi_dw *dws, u16 div)
-- 
1.7.3.4

