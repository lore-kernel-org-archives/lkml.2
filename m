Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab2JRGFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 02:05:20 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:23324
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085Ab2JRGFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 02:05:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <vinod.koul@intel.com>
CC: <djbw@fb.com>, <khali@linux-fr.org>, <ben-linux@fluff.org>,
        <w.sang@pengutronix.de>, <cjb@laptop.org>, <dwmw2@infradead.org>,
        <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <shawn.guo@linaro.org>, <marex@denx.de>,
        <artem.bityutskiy@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <alsa-devel@alsa-project.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        Huang Shijie <shijie8@gmail.com>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH] dma: add new DMA control commands
Date: Thu, 18 Oct 2012 13:32:15 +0800
Message-ID: <1350538335-29026-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Shijie <shijie8@gmail.com>

[1] Why add these new DMA control commands?
    In mx6q, the gpmi-nand driver is the only user of the APBH-DMA. The dma clock
    is enabled when we have successfully requested a DMA channel. So even when
    the gpmi-nand driver does not work, the dma clock(apbh-dma) still runs
    in high speed (198MHz). To save some power, it is better to disable the dma
    clock when the dma device, such as gpmi-nand, is not working anymore.
    When the dma device becomes work again, enable the dma clock again.

[2] add new DMA control commands: DMA_START/DMA_END
    DMA_START: do some preprations to start the DMA engine, such as enable the
               necessary clocks.
    DMA_END: do some works to end the DMA engine, such as disable the
               necessary clocks.

[3] This patch does not change any logic in i2c-mxs driver and mxs-pcm driver.
    But for gpmi-nand driver, we will enable the the clock only when we select
    the nand chip, and want to do some real jobs with the nand chip.
    For mxs-mmc driver, disable the dma clock in the suspend; and enable the
    dma clock in the resume.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/dma/mxs-dma.c                  |   17 +++++++++++++++++
 drivers/i2c/busses/i2c-mxs.c           |   10 +++++++++-
 drivers/mmc/host/mxs-mmc.c             |   19 ++++++++++++++++---
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c  |   10 ++++++++++
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c |   10 ++++++----
 include/linux/dmaengine.h              |    6 ++++++
 sound/soc/mxs/mxs-pcm.c                |   12 ++++++++++++
 7 files changed, 76 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index 9f02e79..89286f4 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -384,6 +384,8 @@ static int mxs_dma_alloc_chan_resources(struct dma_chan *chan)
 	/* the descriptor is ready */
 	async_tx_ack(&mxs_chan->desc);
 
+	clk_disable_unprepare(mxs_dma->clk);
+
 	return 0;
 
 err_clk:
@@ -399,6 +401,14 @@ static void mxs_dma_free_chan_resources(struct dma_chan *chan)
 {
 	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
 	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
+	int ret;
+
+	ret = clk_prepare_enable(mxs_dma->clk);
+	if (ret) {
+		dev_err(mxs_dma->dma_device.dev,
+			"failed in enabling the dma clock\n");
+		return;
+	}
 
 	mxs_dma_disable_chan(mxs_chan);
 
@@ -597,9 +607,13 @@ static int mxs_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		unsigned long arg)
 {
 	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
+	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
 	int ret = 0;
 
 	switch (cmd) {
+	case DMA_START:
+		ret = clk_prepare_enable(mxs_dma->clk);
+		break;
 	case DMA_TERMINATE_ALL:
 		mxs_dma_reset_chan(mxs_chan);
 		mxs_dma_disable_chan(mxs_chan);
@@ -610,6 +624,9 @@ static int mxs_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	case DMA_RESUME:
 		mxs_dma_resume_chan(mxs_chan);
 		break;
+	case DMA_END:
+		clk_disable_unprepare(mxs_dma->clk);
+		break;
 	default:
 		ret = -ENOSYS;
 	}
diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index 1f58197..da1e881 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -643,6 +643,12 @@ static int __devinit mxs_i2c_probe(struct platform_device *pdev)
 			dev_err(dev, "Failed to request dma\n");
 			return -ENODEV;
 		}
+		err = dmaengine_device_control(i2c->dmach, DMA_START, 0);
+		if (err) {
+			dma_release_channel(i2c->dmach);
+			dev_err(dev, "Failed to start dma\n");
+			return err;
+		}
 	}
 
 	platform_set_drvdata(pdev, i2c);
@@ -680,8 +686,10 @@ static int __devexit mxs_i2c_remove(struct platform_device *pdev)
 	if (ret)
 		return -EBUSY;
 
-	if (i2c->dmach)
+	if (i2c->dmach) {
+		dmaengine_device_control(i2c->dmach, DMA_END, 0);
 		dma_release_channel(i2c->dmach);
+	}
 
 	writel(MXS_I2C_CTRL0_SFTRST, i2c->regs + MXS_I2C_CTRL0_SET);
 
diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 80d1e6d..aa91830 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -676,6 +676,9 @@ static int mxs_mmc_probe(struct platform_device *pdev)
 			"%s: failed to request dma\n", __func__);
 		goto out_clk_put;
 	}
+	ret = dmaengine_device_control(ssp->dmach, DMA_START, 0);
+	if (ret)
+		goto out_free_dma;
 
 	/* set mmc core parameters */
 	mmc->ops = &mxs_mmc_ops;
@@ -717,18 +720,20 @@ static int mxs_mmc_probe(struct platform_device *pdev)
 	ret = devm_request_irq(&pdev->dev, irq_err, mxs_mmc_irq_handler, 0,
 			       DRIVER_NAME, host);
 	if (ret)
-		goto out_free_dma;
+		goto out_end_free_dma;
 
 	spin_lock_init(&host->lock);
 
 	ret = mmc_add_host(mmc);
 	if (ret)
-		goto out_free_dma;
+		goto out_end_free_dma;
 
 	dev_info(mmc_dev(host->mmc), "initialized\n");
 
 	return 0;
 
+out_end_free_dma:
+	dmaengine_device_control(ssp->dmach, DMA_END, 0);
 out_free_dma:
 	if (ssp->dmach)
 		dma_release_channel(ssp->dmach);
@@ -750,8 +755,10 @@ static int mxs_mmc_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
-	if (ssp->dmach)
+	if (ssp->dmach) {
+		dmaengine_device_control(ssp->dmach, DMA_END, 0);
 		dma_release_channel(ssp->dmach);
+	}
 
 	clk_disable_unprepare(ssp->clk);
 	clk_put(ssp->clk);
@@ -772,6 +779,7 @@ static int mxs_mmc_suspend(struct device *dev)
 	ret = mmc_suspend_host(mmc);
 
 	clk_disable_unprepare(ssp->clk);
+	dmaengine_device_control(ssp->dmach, DMA_END, 0);
 
 	return ret;
 }
@@ -784,8 +792,13 @@ static int mxs_mmc_resume(struct device *dev)
 	int ret = 0;
 
 	clk_prepare_enable(ssp->clk);
+	ret = dmaengine_device_control(ssp->dmach, DMA_START, 0);
+	if (ret)
+		return ret;
 
 	ret = mmc_resume_host(mmc);
+	if (ret)
+		dmaengine_device_control(ssp->dmach, DMA_END, 0);
 
 	return ret;
 }
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
index 3502acc..20ed3f3 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
@@ -958,6 +958,7 @@ void gpmi_begin(struct gpmi_nand_data *this)
 	uint32_t       reg;
 	unsigned int   dll_wait_time_in_us;
 	struct gpmi_nfc_hardware_timing  hw;
+	struct dma_chan *channel = get_dma_chan(this);
 	int ret;
 
 	/* Enable the clock. */
@@ -967,6 +968,12 @@ void gpmi_begin(struct gpmi_nand_data *this)
 		goto err_out;
 	}
 
+	ret = dmaengine_device_control(channel, DMA_START, 0);
+	if (ret) {
+		gpmi_disable_clk(this);
+		goto err_out;
+	}
+
 	/* Only initialize the timing once */
 	if (this->flags & GPMI_TIMING_INIT_OK)
 		return;
@@ -1035,7 +1042,10 @@ err_out:
 
 void gpmi_end(struct gpmi_nand_data *this)
 {
+	struct dma_chan *channel = get_dma_chan(this);
+
 	gpmi_disable_clk(this);
+	dmaengine_device_control(channel, DMA_END, 0);
 }
 
 /* Clears a BCH interrupt. */
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index e2c56fc..5694d03 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -815,12 +815,14 @@ static void gpmi_select_chip(struct mtd_info *mtd, int chipnr)
 	struct nand_chip *chip = mtd->priv;
 	struct gpmi_nand_data *this = chip->priv;
 
-	if ((this->current_chip < 0) && (chipnr >= 0))
+	if ((this->current_chip < 0) && (chipnr >= 0)) {
+		/* set the current_chip before we call gpmi_begin(). */
+		this->current_chip = chipnr;
 		gpmi_begin(this);
-	else if ((this->current_chip >= 0) && (chipnr < 0))
+	} else if ((this->current_chip >= 0) && (chipnr < 0)) {
 		gpmi_end(this);
-
-	this->current_chip = chipnr;
+		this->current_chip = chipnr;
+	}
 }
 
 static void gpmi_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index d3201e4..79f864a 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -199,6 +199,8 @@ enum dma_ctrl_flags {
 /**
  * enum dma_ctrl_cmd - DMA operations that can optionally be exercised
  * on a running channel.
+ * @DMA_START: do some preprations to start the DMA engine, such as enable the
+ * necessary clocks.
  * @DMA_TERMINATE_ALL: terminate all ongoing transfers
  * @DMA_PAUSE: pause ongoing transfers
  * @DMA_RESUME: resume paused transfer
@@ -209,13 +211,17 @@ enum dma_ctrl_flags {
  * command.
  * @FSLDMA_EXTERNAL_START: this command will put the Freescale DMA controller
  * into external start mode.
+ * @DMA_END: do some works to end the DMA engine, such as disable the
+ * necessary clocks.
  */
 enum dma_ctrl_cmd {
+	DMA_START,
 	DMA_TERMINATE_ALL,
 	DMA_PAUSE,
 	DMA_RESUME,
 	DMA_SLAVE_CONFIG,
 	FSLDMA_EXTERNAL_START,
+	DMA_END,
 };
 
 /**
diff --git a/sound/soc/mxs/mxs-pcm.c b/sound/soc/mxs/mxs-pcm.c
index f82d766..cfcc30f 100644
--- a/sound/soc/mxs/mxs-pcm.c
+++ b/sound/soc/mxs/mxs-pcm.c
@@ -92,6 +92,7 @@ static int snd_mxs_open(struct snd_pcm_substream *substream)
 {
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct mxs_pcm_dma_data *pcm_dma_data;
+	struct dma_chan *chan;
 	int ret;
 
 	pcm_dma_data = kzalloc(sizeof(*pcm_dma_data), GFP_KERNEL);
@@ -107,6 +108,14 @@ static int snd_mxs_open(struct snd_pcm_substream *substream)
 		return ret;
 	}
 
+	chan = snd_dmaengine_pcm_get_chan(substream);
+	ret = dmaengine_device_control(chan, DMA_START, (unsigned long)0);
+	if (ret) {
+		snd_dmaengine_pcm_close(substream);
+		kfree(pcm_dma_data);
+		return ret;
+	}
+
 	snd_soc_set_runtime_hwparams(substream, &snd_mxs_hardware);
 
 	snd_dmaengine_pcm_set_data(substream, pcm_dma_data);
@@ -117,7 +126,10 @@ static int snd_mxs_open(struct snd_pcm_substream *substream)
 static int snd_mxs_close(struct snd_pcm_substream *substream)
 {
 	struct mxs_pcm_dma_data *pcm_dma_data = snd_dmaengine_pcm_get_data(substream);
+	struct dma_chan *chan;
 
+	chan = snd_dmaengine_pcm_get_chan(substream);
+	dmaengine_device_control(chan, DMA_END, 0);
 	snd_dmaengine_pcm_close(substream);
 	kfree(pcm_dma_data);
 
-- 
1.7.0.4


