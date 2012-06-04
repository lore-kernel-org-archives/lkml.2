Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab2FDLsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:48:06 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:15682
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932105Ab2FDLsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:48:03 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: 18
X-BigFish: VS18(z1091vcb8kzzz1202hzz8275bhz2ei87h2a8h668h839hd24he5bhe96h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Chris Ball <cjb@laptop.org>, <linux-mmc@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>, Bob Liu <lliubbo@gmail.com>
Subject: [PATCH 3/5 v2] mmc: bfin_sdh: Port bf5xx SD host driver to support new RSI controller in bf60x.
Date: Mon, 4 Jun 2012 19:41:44 +0800
Message-ID: <1338810104-27853-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

In BF60x RSI controller:
1) MMR read/write width differs.
2) PWR and CTL MMRs are merged to together.
3) ROD and PD_DAT3 bit masks are obsolete.
4) New RSI block size MMR is defined.
5) The definition of DMA descriptor set size is changed.
6) set_ios should powers up controller in 2 steps.

In addition, this patch cleans up the spin locks.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 drivers/mmc/host/bfin_sdh.c |  180 ++++++++++++++++++++++++++++++------------
 1 files changed, 128 insertions(+), 52 deletions(-)

diff --git a/drivers/mmc/host/bfin_sdh.c b/drivers/mmc/host/bfin_sdh.c
index 56a1093..f47526f 100644
--- a/drivers/mmc/host/bfin_sdh.c
+++ b/drivers/mmc/host/bfin_sdh.c
@@ -24,9 +24,7 @@
 #include <asm/portmux.h>
 #include <asm/bfin_sdh.h>
 
-#if defined(CONFIG_BF51x)
-#define bfin_read_SDH_PWR_CTL		bfin_read_RSI_PWR_CTL
-#define bfin_write_SDH_PWR_CTL		bfin_write_RSI_PWR_CTL
+#if defined(CONFIG_BF51x) || defined(__ADSPBF60x__)
 #define bfin_read_SDH_CLK_CTL		bfin_read_RSI_CLK_CTL
 #define bfin_write_SDH_CLK_CTL		bfin_write_RSI_CLK_CTL
 #define bfin_write_SDH_ARGUMENT		bfin_write_RSI_ARGUMENT
@@ -45,8 +43,16 @@
 #define bfin_write_SDH_E_STATUS		bfin_write_RSI_E_STATUS
 #define bfin_read_SDH_STATUS		bfin_read_RSI_STATUS
 #define bfin_write_SDH_MASK0		bfin_write_RSI_MASK0
+#define bfin_write_SDH_E_MASK		bfin_write_RSI_E_MASK
 #define bfin_read_SDH_CFG		bfin_read_RSI_CFG
 #define bfin_write_SDH_CFG		bfin_write_RSI_CFG
+# if defined(__ADSPBF60x__)
+#  define bfin_read_SDH_BLK_SIZE	bfin_read_RSI_BLKSZ
+#  define bfin_write_SDH_BLK_SIZE	bfin_write_RSI_BLKSZ
+# else
+#  define bfin_read_SDH_PWR_CTL		bfin_read_RSI_PWR_CTL
+#  define bfin_write_SDH_PWR_CTL	bfin_write_RSI_PWR_CTL
+# endif
 #endif
 
 struct sdh_host {
@@ -62,6 +68,7 @@ struct sdh_host {
 	dma_addr_t		sg_dma;
 	int			dma_len;
 
+	unsigned long		sclk;
 	unsigned int		imask;
 	unsigned int		power_mode;
 	unsigned int		clk_div;
@@ -127,11 +134,15 @@ static int sdh_setup_data(struct sdh_host *host, struct mmc_data *data)
 	/* Only supports power-of-2 block size */
 	if (data->blksz & (data->blksz - 1))
 		return -EINVAL;
+#ifndef RSI_BLKSZ
 	data_ctl |= ((ffs(data->blksz) - 1) << 4);
+#else
+        bfin_write_SDH_BLK_SIZE(data->blksz);
+#endif
 
 	bfin_write_SDH_DATA_CTL(data_ctl);
 	/* the time of a host clock period in ns */
-	cycle_ns = 1000000000 / (get_sclk() / (2 * (host->clk_div + 1)));
+	cycle_ns = 1000000000 / (host->sclk / (2 * (host->clk_div + 1)));
 	timeout = data->timeout_ns / cycle_ns;
 	timeout += data->timeout_clks;
 	bfin_write_SDH_DATA_TIMER(timeout);
@@ -145,8 +156,13 @@ static int sdh_setup_data(struct sdh_host *host, struct mmc_data *data)
 
 	sdh_enable_stat_irq(host, (DAT_CRC_FAIL | DAT_TIME_OUT | DAT_END));
 	host->dma_len = dma_map_sg(mmc_dev(host->mmc), data->sg, data->sg_len, host->dma_dir);
-#if defined(CONFIG_BF54x)
-	dma_cfg |= DMAFLOW_ARRAY | NDSIZE_5 | RESTART | WDSIZE_32 | DMAEN;
+#if defined(CONFIG_BF54x) || defined(CONFIG_BF60x)
+	dma_cfg |= DMAFLOW_ARRAY | RESTART | WDSIZE_32 | DMAEN;
+# ifdef RSI_BLKSZ
+	dma_cfg |= PSIZE_32 | NDSIZE_3;
+# else
+	dma_cfg |= NDSIZE_5;
+# endif
 	{
 		struct scatterlist *sg;
 		int i;
@@ -156,7 +172,7 @@ static int sdh_setup_data(struct sdh_host *host, struct mmc_data *data)
 			host->sg_cpu[i].x_count = sg_dma_len(sg) / 4;
 			host->sg_cpu[i].x_modify = 4;
 			dev_dbg(mmc_dev(host->mmc), "%d: start_addr:0x%lx, "
-				"cfg:0x%x, x_count:0x%x, x_modify:0x%x\n",
+				"cfg:0x%lx, x_count:0x%lx, x_modify:0x%lx\n",
 				i, host->sg_cpu[i].start_addr,
 				host->sg_cpu[i].cfg, host->sg_cpu[i].x_count,
 				host->sg_cpu[i].x_modify);
@@ -172,6 +188,7 @@ static int sdh_setup_data(struct sdh_host *host, struct mmc_data *data)
 	set_dma_curr_desc_addr(host->dma_ch, (unsigned long *)host->sg_dma);
 	set_dma_x_count(host->dma_ch, 0);
 	set_dma_x_modify(host->dma_ch, 0);
+	SSYNC();
 	set_dma_config(host->dma_ch, dma_cfg);
 #elif defined(CONFIG_BF51x)
 	/* RSI DMA doesn't work in array mode */
@@ -179,6 +196,7 @@ static int sdh_setup_data(struct sdh_host *host, struct mmc_data *data)
 	set_dma_start_addr(host->dma_ch, sg_dma_address(&data->sg[0]));
 	set_dma_x_count(host->dma_ch, length / 4);
 	set_dma_x_modify(host->dma_ch, 4);
+	SSYNC();
 	set_dma_config(host->dma_ch, dma_cfg);
 #endif
 	bfin_write_SDH_DATA_CTL(bfin_read_SDH_DATA_CTL() | DTX_DMA_E | DTX_E);
@@ -296,7 +314,6 @@ static int sdh_data_done(struct sdh_host *host, unsigned int stat)
 	else
 		data->bytes_xfered = 0;
 
-	sdh_disable_stat_irq(host, DAT_END | DAT_TIME_OUT | DAT_CRC_FAIL | RX_OVERRUN | TX_UNDERRUN);
 	bfin_write_SDH_STATUS_CLR(DAT_END_STAT | DAT_TIMEOUT_STAT | \
 			DAT_CRC_FAIL_STAT | DAT_BLK_END_STAT | RX_OVERRUN | TX_UNDERRUN);
 	bfin_write_SDH_DATA_CTL(0);
@@ -321,74 +338,115 @@ static void sdh_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	dev_dbg(mmc_dev(host->mmc), "%s enter, mrp:%p, cmd:%p\n", __func__, mrq, mrq->cmd);
 	WARN_ON(host->mrq != NULL);
 
+	spin_lock(&host->lock);
 	host->mrq = mrq;
 	host->data = mrq->data;
 
 	if (mrq->data && mrq->data->flags & MMC_DATA_READ) {
 		ret = sdh_setup_data(host, mrq->data);
 		if (ret)
-			return;
+			goto data_err;
 	}
 
 	sdh_start_cmd(host, mrq->cmd);
+data_err:
+	spin_unlock(&host->lock);
 }
 
 static void sdh_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct sdh_host *host;
-	unsigned long flags;
 	u16 clk_ctl = 0;
+#ifndef RSI_BLKSZ
 	u16 pwr_ctl = 0;
+#endif
 	u16 cfg;
 	host = mmc_priv(mmc);
 
-	spin_lock_irqsave(&host->lock, flags);
-	if (ios->clock) {
-		unsigned long  sys_clk, ios_clk;
-		unsigned char clk_div;
-		ios_clk = 2 * ios->clock;
-		sys_clk = get_sclk();
-		clk_div = sys_clk / ios_clk;
-		if (sys_clk % ios_clk == 0)
-			clk_div -= 1;
-		clk_div = min_t(unsigned char, clk_div, 0xFF);
-		clk_ctl |= clk_div;
-		clk_ctl |= CLK_E;
-		host->clk_div = clk_div;
-	} else
-		sdh_stop_clock(host);
-
-	if (ios->bus_mode == MMC_BUSMODE_OPENDRAIN)
-#ifdef CONFIG_SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
-		pwr_ctl |= ROD_CTL;
-#else
-		pwr_ctl |= SD_CMD_OD | ROD_CTL;
-#endif
+	spin_lock(&host->lock);
 
-	if (ios->bus_width == MMC_BUS_WIDTH_4) {
-		cfg = bfin_read_SDH_CFG();
+	cfg = bfin_read_SDH_CFG();
+	cfg |= MWE;
+	switch (ios->bus_width) {
+	case MMC_BUS_WIDTH_4:
+#ifndef RSI_BLKSZ
 		cfg &= ~PD_SDDAT3;
+#endif
 		cfg |= PUP_SDDAT3;
 		/* Enable 4 bit SDIO */
-		cfg |= (SD4E | MWE);
-		bfin_write_SDH_CFG(cfg);
-		clk_ctl |= WIDE_BUS;
-	} else {
-		cfg = bfin_read_SDH_CFG();
-		cfg |= MWE;
-		bfin_write_SDH_CFG(cfg);
+		cfg |= SD4E;
+		clk_ctl |= WIDE_BUS_4;
+		break;
+	case MMC_BUS_WIDTH_8:
+#ifndef RSI_BLKSZ
+		cfg &= ~PD_SDDAT3;
+#endif
+		cfg |= PUP_SDDAT3;
+		/* Disable 4 bit SDIO */
+		cfg &= ~SD4E;
+		clk_ctl |= BYTE_BUS_8;
+		break;
+	default:
+		cfg &= ~PUP_SDDAT3;
+		/* Disable 4 bit SDIO */
+		cfg &= ~SD4E;
 	}
 
-	bfin_write_SDH_CLK_CTL(clk_ctl);
-
 	host->power_mode = ios->power_mode;
-	if (ios->power_mode == MMC_POWER_ON)
+#ifndef RSI_BLKSZ
+	if (ios->bus_mode == MMC_BUSMODE_OPENDRAIN) {
+		pwr_ctl |= ROD_CTL;
+# ifndef CONFIG_SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
+		pwr_ctl |= SD_CMD_OD;
+# endif
+	}
+
+	if (ios->power_mode != MMC_POWER_OFF)
 		pwr_ctl |= PWR_ON;
+	else
+		pwr_ctl &= ~PWR_ON;
 
 	bfin_write_SDH_PWR_CTL(pwr_ctl);
+#else
+# ifndef CONFIG_SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
+	if (ios->bus_mode == MMC_BUSMODE_OPENDRAIN)
+		cfg |= SD_CMD_OD;
+	else
+		cfg &= ~SD_CMD_OD;
+# endif
+
+
+	if (ios->power_mode != MMC_POWER_OFF)
+		cfg |= PWR_ON;
+	else
+		cfg &= ~PWR_ON;
+
+	bfin_write_SDH_CFG(cfg);
+#endif
 	SSYNC();
 
-	spin_unlock_irqrestore(&host->lock, flags);
+	if (ios->power_mode == MMC_POWER_ON && ios->clock) {
+		unsigned char clk_div;
+		clk_div = (get_sclk() / ios->clock - 1) / 2;
+		clk_div = min_t(unsigned char, clk_div, 0xFF);
+		clk_ctl |= clk_div;
+		clk_ctl |= CLK_E;
+		host->clk_div = clk_div;
+		bfin_write_SDH_CLK_CTL(clk_ctl);
+
+	} else
+		sdh_stop_clock(host);
+
+	/* set up sdh interrupt mask*/
+	if (ios->power_mode == MMC_POWER_ON)
+		bfin_write_SDH_MASK0(DAT_END | DAT_TIME_OUT | DAT_CRC_FAIL |
+			RX_OVERRUN | TX_UNDERRUN | CMD_SENT | CMD_RESP_END |
+			CMD_TIME_OUT | CMD_CRC_FAIL);
+	else
+		bfin_write_SDH_MASK0(0);
+	SSYNC();
+
+	spin_unlock(&host->lock);
 
 	dev_dbg(mmc_dev(host->mmc), "SDH: clk_div = 0x%x actual clock:%ld expected clock:%d\n",
 		host->clk_div,
@@ -405,7 +463,7 @@ static irqreturn_t sdh_dma_irq(int irq, void *devid)
 {
 	struct sdh_host *host = devid;
 
-	dev_dbg(mmc_dev(host->mmc), "%s enter, irq_stat: 0x%04x\n", __func__,
+	dev_dbg(mmc_dev(host->mmc), "%s enter, irq_stat: 0x%04lx\n", __func__,
 		get_dma_curr_irqstat(host->dma_ch));
 	clear_dma_irqstat(host->dma_ch);
 	SSYNC();
@@ -420,6 +478,9 @@ static irqreturn_t sdh_stat_irq(int irq, void *devid)
 	int handled = 0;
 
 	dev_dbg(mmc_dev(host->mmc), "%s enter\n", __func__);
+
+	spin_lock(&host->lock);
+
 	status = bfin_read_SDH_E_STATUS();
 	if (status & SD_CARD_DET) {
 		mmc_detect_change(host->mmc, 0);
@@ -437,6 +498,8 @@ static irqreturn_t sdh_stat_irq(int irq, void *devid)
 	if (status & (DAT_END | DAT_TIME_OUT | DAT_CRC_FAIL | RX_OVERRUN | TX_UNDERRUN))
 		handled |= sdh_data_done(host, status);
 
+	spin_unlock(&host->lock);
+
 	dev_dbg(mmc_dev(host->mmc), "%s exit\n\n", __func__);
 
 	return IRQ_RETVAL(handled);
@@ -462,12 +525,16 @@ static int __devinit sdh_probe(struct platform_device *pdev)
 	}
 
 	mmc->ops = &sdh_ops;
-#if defined(CONFIG_BF54x)
-	mmc->max_segs = 32;
-#elif defined(CONFIG_BF51x)
+#if defined(CONFIG_BF51x)
 	mmc->max_segs = 1;
+#else
+	mmc->max_segs = PAGE_SIZE / sizeof(struct dma_desc_array);
 #endif
+#ifdef RSI_BLKSZ
+	mmc->max_seg_size = -1;
+#else
 	mmc->max_seg_size = 1 << 16;
+#endif
 	mmc->max_blk_size = 1 << 11;
 	mmc->max_blk_count = 1 << 11;
 	mmc->max_req_size = PAGE_SIZE;
@@ -477,6 +544,7 @@ static int __devinit sdh_probe(struct platform_device *pdev)
 	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_NEEDS_POLL;
 	host = mmc_priv(mmc);
 	host->mmc = mmc;
+	host->sclk = get_sclk();
 
 	spin_lock_init(&host->lock);
 	host->irq = drv_data->irq_int0;
@@ -501,7 +569,6 @@ static int __devinit sdh_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, mmc);
-	mmc_add_host(mmc);
 
 	ret = request_irq(host->irq, sdh_stat_irq, 0, "SDH Status IRQ", host);
 	if (ret) {
@@ -522,12 +589,13 @@ static int __devinit sdh_probe(struct platform_device *pdev)
 	bfin_write_SDH_CFG(bfin_read_SDH_CFG() | CLKS_EN);
 	SSYNC();
 
-	/* Disable card inserting detection pin. set MMC_CAP_NEES_POLL, and
+	/* Disable card inserting detection pin. set MMC_CAP_NEEDS_POLL, and
 	 * mmc stack will do the detection.
 	 */
 	bfin_write_SDH_CFG((bfin_read_SDH_CFG() & 0x1F) | (PUP_SDDAT | PUP_SDDAT3));
 	SSYNC();
 
+	mmc_add_host(mmc);
 	return 0;
 
 out4:
@@ -575,7 +643,11 @@ static int sdh_suspend(struct platform_device *dev, pm_message_t state)
 	if (mmc)
 		ret = mmc_suspend_host(mmc);
 
+#ifndef RSI_BLKSZ
 	bfin_write_SDH_PWR_CTL(bfin_read_SDH_PWR_CTL() & ~PWR_ON);
+#else
+	bfin_write_SDH_CFG(bfin_read_SDH_CFG() & ~PWR_ON);
+#endif
 	peripheral_free_list(drv_data->pin_req);
 
 	return ret;
@@ -593,12 +665,16 @@ static int sdh_resume(struct platform_device *dev)
 		return ret;
 	}
 
-	bfin_write_SDH_PWR_CTL(bfin_read_SDH_PWR_CTL() | PWR_ON);
 #if defined(CONFIG_BF54x)
 	/* Secure Digital Host shares DMA with Nand controller */
 	bfin_write_DMAC1_PERIMUX(bfin_read_DMAC1_PERIMUX() | 0x1);
 #endif
+#ifndef RSI_BLKSZ
+	bfin_write_SDH_PWR_CTL(bfin_read_SDH_PWR_CTL() | PWR_ON);
 	bfin_write_SDH_CFG(bfin_read_SDH_CFG() | CLKS_EN);
+#else
+	bfin_write_SDH_CFG(bfin_read_SDH_CFG() | CLKS_EN | PWR_ON);
+#endif
 	SSYNC();
 
 	bfin_write_SDH_CFG((bfin_read_SDH_CFG() & 0x1F) | (PUP_SDDAT | PUP_SDDAT3));
-- 
1.7.0.4


