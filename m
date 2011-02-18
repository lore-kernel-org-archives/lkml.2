Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1BRDN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:13:27 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51811 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab1BRDH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:07:58 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Chris Ball <cjb@laptop.org>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
        linux-mmc@vger.kernel.org
Subject: [PATCH 06/29] asic3: mfd_cell is now implicitly available to drivers
Date: Thu, 17 Feb 2011 19:07:13 -0800
Message-Id: <1297998456-7615-7-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to explicitly set the cell's platform_data/data_size.

Modify clients to use mfd_get_cell helper function instead of
accessing platform_data directly.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/asic3.c         |    6 ------
 drivers/mmc/host/tmio_mmc.c |   24 ++++++++++++------------
 drivers/w1/masters/ds1wm.c  |    2 +-
 3 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 6a1f940..71d2901 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -810,9 +810,6 @@ static int __init asic3_mfd_probe(struct platform_device *pdev,
 	ds1wm_resources[0].start >>= asic->bus_shift;
 	ds1wm_resources[0].end   >>= asic->bus_shift;
 
-	asic3_cell_ds1wm.platform_data = &asic3_cell_ds1wm;
-	asic3_cell_ds1wm.data_size = sizeof(asic3_cell_ds1wm);
-
 	/* MMC */
 	asic->tmio_cnf = ioremap((ASIC3_SD_CONFIG_BASE >> asic->bus_shift) +
 				 mem_sdio->start, 0x400 >> asic->bus_shift);
@@ -824,9 +821,6 @@ static int __init asic3_mfd_probe(struct platform_device *pdev,
 	asic3_mmc_resources[0].start >>= asic->bus_shift;
 	asic3_mmc_resources[0].end   >>= asic->bus_shift;
 
-	asic3_cell_mmc.platform_data = &asic3_cell_mmc;
-	asic3_cell_mmc.data_size = sizeof(asic3_cell_mmc);
-
 	ret = mfd_add_devices(&pdev->dev, pdev->id,
 			&asic3_cell_ds1wm, 1, mem, asic->irq_base);
 	if (ret < 0)
diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index e3c6ef2..816fb74 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -300,7 +300,7 @@ static void tmio_mmc_set_clock(struct tmio_mmc_host *host, int new_clock)
 
 static void tmio_mmc_clk_stop(struct tmio_mmc_host *host)
 {
-	struct mfd_cell *cell = host->pdev->dev.platform_data;
+	struct mfd_cell *cell = mfd_get_cell(host->pdev);
 	struct tmio_mmc_data *pdata = cell->driver_data;
 
 	/*
@@ -324,7 +324,7 @@ static void tmio_mmc_clk_stop(struct tmio_mmc_host *host)
 
 static void tmio_mmc_clk_start(struct tmio_mmc_host *host)
 {
-	struct mfd_cell *cell = host->pdev->dev.platform_data;
+	struct mfd_cell *cell = mfd_get_cell(host->pdev);
 	struct tmio_mmc_data *pdata = cell->driver_data;
 
 	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, 0x0100 |
@@ -666,7 +666,7 @@ out:
 static irqreturn_t tmio_mmc_irq(int irq, void *devid)
 {
 	struct tmio_mmc_host *host = devid;
-	struct mfd_cell	*cell = host->pdev->dev.platform_data;
+	struct mfd_cell	*cell = mfd_get_cell(host->pdev);
 	struct tmio_mmc_data *pdata = cell->driver_data;
 	unsigned int ireg, irq_mask, status;
 	unsigned int sdio_ireg, sdio_irq_mask, sdio_status;
@@ -796,7 +796,7 @@ static void tmio_mmc_start_dma_rx(struct tmio_mmc_host *host)
 	struct scatterlist *sg = host->sg_ptr, *sg_tmp;
 	struct dma_async_tx_descriptor *desc = NULL;
 	struct dma_chan *chan = host->chan_rx;
-	struct mfd_cell	*cell = host->pdev->dev.platform_data;
+	struct mfd_cell	*cell = mfd_get_cell(host->pdev);
 	struct tmio_mmc_data *pdata = cell->driver_data;
 	dma_cookie_t cookie;
 	int ret, i;
@@ -873,7 +873,7 @@ static void tmio_mmc_start_dma_tx(struct tmio_mmc_host *host)
 	struct scatterlist *sg = host->sg_ptr, *sg_tmp;
 	struct dma_async_tx_descriptor *desc = NULL;
 	struct dma_chan *chan = host->chan_tx;
-	struct mfd_cell	*cell = host->pdev->dev.platform_data;
+	struct mfd_cell	*cell = mfd_get_cell(host->pdev);
 	struct tmio_mmc_data *pdata = cell->driver_data;
 	dma_cookie_t cookie;
 	int ret, i;
@@ -1071,7 +1071,7 @@ static void tmio_mmc_release_dma(struct tmio_mmc_host *host)
 static int tmio_mmc_start_data(struct tmio_mmc_host *host,
 	struct mmc_data *data)
 {
-	struct mfd_cell *cell = host->pdev->dev.platform_data;
+	struct mfd_cell *cell = mfd_get_cell(host->pdev);
 	struct tmio_mmc_data *pdata = cell->driver_data;
 
 	pr_debug("setup data transfer: blocksize %08x  nr_blocks %d\n",
@@ -1177,7 +1177,7 @@ static void tmio_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 static int tmio_mmc_get_ro(struct mmc_host *mmc)
 {
 	struct tmio_mmc_host *host = mmc_priv(mmc);
-	struct mfd_cell	*cell = host->pdev->dev.platform_data;
+	struct mfd_cell	*cell = mfd_get_cell(host->pdev);
 	struct tmio_mmc_data *pdata = cell->driver_data;
 
 	return ((pdata->flags & TMIO_MMC_WRPROTECT_DISABLE) ||
@@ -1187,7 +1187,7 @@ static int tmio_mmc_get_ro(struct mmc_host *mmc)
 static int tmio_mmc_get_cd(struct mmc_host *mmc)
 {
 	struct tmio_mmc_host *host = mmc_priv(mmc);
-	struct mfd_cell	*cell = host->pdev->dev.platform_data;
+	struct mfd_cell	*cell = mfd_get_cell(host->pdev);
 	struct tmio_mmc_data *pdata = cell->driver_data;
 
 	if (!pdata->get_cd)
@@ -1207,7 +1207,7 @@ static const struct mmc_host_ops tmio_mmc_ops = {
 #ifdef CONFIG_PM
 static int tmio_mmc_suspend(struct platform_device *dev, pm_message_t state)
 {
-	struct mfd_cell	*cell = (struct mfd_cell *)dev->dev.platform_data;
+	struct mfd_cell	*cell = mfd_get_cell(dev);
 	struct mmc_host *mmc = platform_get_drvdata(dev);
 	int ret;
 
@@ -1222,7 +1222,7 @@ static int tmio_mmc_suspend(struct platform_device *dev, pm_message_t state)
 
 static int tmio_mmc_resume(struct platform_device *dev)
 {
-	struct mfd_cell	*cell = (struct mfd_cell *)dev->dev.platform_data;
+	struct mfd_cell	*cell = mfd_get_cell(dev);
 	struct mmc_host *mmc = platform_get_drvdata(dev);
 	int ret = 0;
 
@@ -1245,7 +1245,7 @@ out:
 
 static int __devinit tmio_mmc_probe(struct platform_device *dev)
 {
-	struct mfd_cell	*cell = (struct mfd_cell *)dev->dev.platform_data;
+	struct mfd_cell	*cell = mfd_get_cell(dev);
 	struct tmio_mmc_data *pdata;
 	struct resource *res_ctl;
 	struct tmio_mmc_host *host;
@@ -1360,7 +1360,7 @@ out:
 
 static int __devexit tmio_mmc_remove(struct platform_device *dev)
 {
-	struct mfd_cell	*cell = (struct mfd_cell *)dev->dev.platform_data;
+	struct mfd_cell	*cell = mfd_get_cell(dev);
 	struct mmc_host *mmc = platform_get_drvdata(dev);
 
 	platform_set_drvdata(dev, NULL);
diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index 6b85e7f..94f55d8 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -336,7 +336,7 @@ static int ds1wm_probe(struct platform_device *pdev)
 	if (!pdev)
 		return -ENODEV;
 
-	cell = pdev->dev.platform_data;
+	cell = mfd_get_cell(pdev);
 	if (!cell)
 		return -ENODEV;
 
-- 
1.7.2.3

