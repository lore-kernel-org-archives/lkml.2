Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab1HIIEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 04:04:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55541 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1HIIEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 04:04:10 -0400
X-AuditID: cbfee61a-b7cf0ae000006bc6-34-4e40e9f82289
Date: Tue, 09 Aug 2011 09:58:21 -0400
From: Padmavathi Venna <padma.v@samsung.com>
Subject: [RFC][PATCH 2/2] spi: s3c64xx: Use clkdev for bus clock lookup
To: kgene.kim@samsung.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, jassisinghbrar@gmail.com
Message-id: <1312898301-7229-1-git-send-email-padma.v@samsung.com>
X-Mailer: git-send-email 1.7.0.4
Content-transfer-encoding: 7BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPI driver is modified to lookup the bus clock using the
alias name instead of getting clock name and clock
number from platform data.

Driver is modified to get the best source clock among the
available source clocks for the required frequency.

Signed-off-by: Padmavathi Venna <padma.v@samsung.com>
---
 drivers/spi/spi_s3c64xx.c |  181 ++++++++++++++++++++++++++++++---------------
 1 files changed, 121 insertions(+), 60 deletions(-)

diff --git a/drivers/spi/spi_s3c64xx.c b/drivers/spi/spi_s3c64xx.c
index 8945e20..d7c979d 100644
--- a/drivers/spi/spi_s3c64xx.c
+++ b/drivers/spi/spi_s3c64xx.c
@@ -132,6 +132,9 @@
 #define RXBUSY    (1<<2)
 #define TXBUSY    (1<<3)
 
+#define MAX_SPI_BUS_CLK (4)
+#define MAX_PSR (256)
+
 /**
  * struct s3c64xx_spi_driver_data - Runtime info holder for SPI driver.
  * @clk: Pointer to the spi clock.
@@ -172,6 +175,9 @@ struct s3c64xx_spi_driver_data {
 	unsigned                        state;
 	unsigned                        cur_mode, cur_bpw;
 	unsigned                        cur_speed;
+	struct clk                      *bus_clk_list[MAX_SPI_BUS_CLK];
+	unsigned                        cur_clk;
+	unsigned                        old_spd;
 };
 
 static struct s3c2410_dma_client s3c64xx_spi_dma_client = {
@@ -411,6 +417,64 @@ static inline void disable_cs(struct s3c64xx_spi_driver_data *sdd,
 	cs->set_level(cs->line, spi->mode & SPI_CS_HIGH ? 0 : 1);
 }
 
+static int s3c64xx_spi_best_clk_src(struct spi_device *spi)
+{
+	struct s3c64xx_spi_driver_data *sdd;
+	struct clk *clksrc;
+	unsigned long rate;
+	unsigned int delta;
+	unsigned int best = UINT_MAX;
+	int psr, div, i, best_div, best_src;
+
+	sdd = spi_master_get_devdata(spi->master);
+
+	for (i = 0; i < MAX_SPI_BUS_CLK; i++) {
+		clksrc = sdd->bus_clk_list[i];
+		if (!clksrc)
+			delta = UINT_MAX;
+		else {
+			rate = clk_get_rate(clksrc);
+			for (psr = 0; psr < MAX_PSR; psr++) {
+				div = (2 * (psr + 1));
+				if ((rate / div) <= spi->max_speed_hz)
+					break;
+			}
+
+			if (psr == MAX_PSR &&
+				((rate / div) > spi->max_speed_hz)) {
+				dev_dbg(&spi->dev, "clock%d can't support"
+					" required frequency\n", i);
+				continue;
+			} else {
+				delta = spi->max_speed_hz - (rate / div);
+				dev_dbg(&spi->dev, "clk %d: rate %lu,"
+					" want %u, got %lu div:%d delta:%u\n",
+					i, rate, spi->max_speed_hz,
+					rate / div, div, delta);
+			}
+		}
+
+		if (delta < best) {
+			best = delta;
+			best_src = i;
+			best_div = div;
+		}
+	}
+
+	if (best == UINT_MAX) {
+		dev_err(&spi->dev, "no clock can support required "
+			"frequency\n");
+		return -EINVAL;
+	}
+
+	if (sdd->cur_clk != best_src) {
+		sdd->cur_clk = best_src;
+		sdd->src_clk = sdd->bus_clk_list[best_src];
+	}
+
+	return best_div;
+}
+
 static void s3c64xx_spi_config(struct s3c64xx_spi_driver_data *sdd)
 {
 	struct s3c64xx_spi_info *sci = sdd->cntrlr_info;
@@ -470,6 +534,9 @@ static void s3c64xx_spi_config(struct s3c64xx_spi_driver_data *sdd)
 		clk_enable(sdd->src_clk);
 	} else {
 		/* Configure Clock */
+		writel(sdd->cur_clk << S3C64XX_SPI_CLKSEL_SRCSHFT,
+			regs + S3C64XX_SPI_CLK_CFG);
+
 		val = readl(regs + S3C64XX_SPI_CLK_CFG);
 		val &= ~S3C64XX_SPI_PSR_MASK;
 		val |= ((clk_get_rate(sdd->src_clk) / sdd->cur_speed / 2 - 1)
@@ -845,6 +912,7 @@ static int s3c64xx_spi_setup(struct spi_device *spi)
 	struct spi_message *msg;
 	unsigned long flags;
 	int err = 0;
+	int div;
 
 	if (cs == NULL || cs->set_level == NULL) {
 		dev_err(&spi->dev, "No CS for SPI(%d)\n", spi->chip_select);
@@ -884,38 +952,18 @@ static int s3c64xx_spi_setup(struct spi_device *spi)
 		goto setup_exit;
 	}
 
-	/* Check if we can provide the requested rate */
+	/* Get the best clock source for the requested rate */
 	if (!sci->clk_from_cmu) {
-		u32 psr, speed;
-
-		/* Max possible */
-		speed = clk_get_rate(sdd->src_clk) / 2 / (0 + 1);
-
-		if (spi->max_speed_hz > speed)
-			spi->max_speed_hz = speed;
-
-		psr = clk_get_rate(sdd->src_clk) / 2 / spi->max_speed_hz - 1;
-		psr &= S3C64XX_SPI_PSR_MASK;
-		if (psr == S3C64XX_SPI_PSR_MASK)
-			psr--;
-
-		speed = clk_get_rate(sdd->src_clk) / 2 / (psr + 1);
-		if (spi->max_speed_hz < speed) {
-			if (psr+1 < S3C64XX_SPI_PSR_MASK) {
-				psr++;
-			} else {
-				err = -EINVAL;
+		if (sdd->old_spd != spi->max_speed_hz) {
+			div = s3c64xx_spi_best_clk_src(spi);
+			if (div <= 0) {
+				err = div;
 				goto setup_exit;
 			}
+			spi->max_speed_hz = clk_get_rate(sdd->src_clk) / div;
+			sdd->old_spd = spi->max_speed_hz;
 		}
-
-		speed = clk_get_rate(sdd->src_clk) / 2 / (psr + 1);
-		if (spi->max_speed_hz >= speed)
-			spi->max_speed_hz = speed;
-		else
-			err = -EINVAL;
 	}
-
 setup_exit:
 
 	/* setup() returns with device de-selected */
@@ -926,7 +974,6 @@ setup_exit:
 
 static void s3c64xx_spi_hwinit(struct s3c64xx_spi_driver_data *sdd, int channel)
 {
-	struct s3c64xx_spi_info *sci = sdd->cntrlr_info;
 	void __iomem *regs = sdd->regs;
 	unsigned int val;
 
@@ -936,10 +983,6 @@ static void s3c64xx_spi_hwinit(struct s3c64xx_spi_driver_data *sdd, int channel)
 
 	/* Disable Interrupts - we use Polling if not DMA mode */
 	writel(0, regs + S3C64XX_SPI_INT_EN);
-
-	if (!sci->clk_from_cmu)
-		writel(sci->src_clk_nr << S3C64XX_SPI_CLKSEL_SRCSHFT,
-				regs + S3C64XX_SPI_CLK_CFG);
 	writel(0, regs + S3C64XX_SPI_MODE_CFG);
 	writel(0, regs + S3C64XX_SPI_PACKET_CNT);
 
@@ -964,7 +1007,10 @@ static int __init s3c64xx_spi_probe(struct platform_device *pdev)
 	struct s3c64xx_spi_driver_data *sdd;
 	struct s3c64xx_spi_info *sci;
 	struct spi_master *master;
-	int ret;
+	char clk_alias_name[16];
+	int ret, i;
+	int clk_found = 0;
+
 
 	if (pdev->id < 0) {
 		dev_err(&pdev->dev,
@@ -978,11 +1024,6 @@ static int __init s3c64xx_spi_probe(struct platform_device *pdev)
 	}
 
 	sci = pdev->dev.platform_data;
-	if (!sci->src_clk_name) {
-		dev_err(&pdev->dev,
-			"Board init must call s3c64xx_spi_set_info()\n");
-		return -EINVAL;
-	}
 
 	/* Check for availability of necessary resource */
 
@@ -1065,19 +1106,27 @@ static int __init s3c64xx_spi_probe(struct platform_device *pdev)
 		goto err4;
 	}
 
-	sdd->src_clk = clk_get(&pdev->dev, sci->src_clk_name);
-	if (IS_ERR(sdd->src_clk)) {
-		dev_err(&pdev->dev,
-			"Unable to acquire clock '%s'\n", sci->src_clk_name);
-		ret = PTR_ERR(sdd->src_clk);
-		goto err5;
-	}
+	for (i = 0; i < MAX_SPI_BUS_CLK; i++) {
+		struct clk *clk;
+		sprintf(clk_alias_name, "clk_spi_bus%d", i);
 
-	if (clk_enable(sdd->src_clk)) {
-		dev_err(&pdev->dev, "Couldn't enable clock '%s'\n",
-							sci->src_clk_name);
-		ret = -EBUSY;
-		goto err6;
+		clk = clk_get(&pdev->dev, clk_alias_name);
+		if (IS_ERR(clk)) {
+			sdd->bus_clk_list[i] = NULL;
+			continue;
+		}
+		sdd->bus_clk_list[i] = clk;
+		sdd->src_clk = clk;
+		sdd->cur_clk = i;
+		clk_found++;
+
+		if (clk_enable(clk))
+			dev_err(&pdev->dev, "Couldn't enable clock:%s\n",
+				clk_alias_name);
+	}
+	if (!clk_found) {
+		dev_err(&pdev->dev, "Unable to acquire SPI bus clocks\n");
+		goto err5;
 	}
 
 	sdd->workqueue = create_singlethread_workqueue(
@@ -1085,7 +1134,7 @@ static int __init s3c64xx_spi_probe(struct platform_device *pdev)
 	if (sdd->workqueue == NULL) {
 		dev_err(&pdev->dev, "Unable to create workqueue\n");
 		ret = -ENOMEM;
-		goto err7;
+		goto err6;
 	}
 
 	/* Setup Deufult Mode */
@@ -1099,7 +1148,7 @@ static int __init s3c64xx_spi_probe(struct platform_device *pdev)
 	if (spi_register_master(master)) {
 		dev_err(&pdev->dev, "cannot register SPI master\n");
 		ret = -EBUSY;
-		goto err8;
+		goto err7;
 	}
 
 	dev_dbg(&pdev->dev, "Samsung SoC SPI Driver loaded for Bus SPI-%d "
@@ -1111,12 +1160,14 @@ static int __init s3c64xx_spi_probe(struct platform_device *pdev)
 
 	return 0;
 
-err8:
-	destroy_workqueue(sdd->workqueue);
 err7:
-	clk_disable(sdd->src_clk);
+	destroy_workqueue(sdd->workqueue);
 err6:
-	clk_put(sdd->src_clk);
+	for (i = 0; i < MAX_SPI_BUS_CLK; i++)
+		if (sdd->bus_clk_list[i]) {
+			clk_disable(sdd->bus_clk_list[i]);
+			clk_put(sdd->bus_clk_list[i]);
+		}
 err5:
 	clk_disable(sdd->clk);
 err4:
@@ -1139,6 +1190,7 @@ static int s3c64xx_spi_remove(struct platform_device *pdev)
 	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(master);
 	struct resource	*mem_res;
 	unsigned long flags;
+	int i;
 
 	spin_lock_irqsave(&sdd->lock, flags);
 	sdd->state |= SUSPND;
@@ -1151,8 +1203,11 @@ static int s3c64xx_spi_remove(struct platform_device *pdev)
 
 	destroy_workqueue(sdd->workqueue);
 
-	clk_disable(sdd->src_clk);
-	clk_put(sdd->src_clk);
+	for (i = 0; i < MAX_SPI_BUS_CLK; i++)
+		if (sdd->bus_clk_list[i]) {
+			clk_disable(sdd->bus_clk_list[i]);
+			clk_put(sdd->bus_clk_list[i]);
+		}
 
 	clk_disable(sdd->clk);
 	clk_put(sdd->clk);
@@ -1175,6 +1230,7 @@ static int s3c64xx_spi_suspend(struct platform_device *pdev, pm_message_t state)
 	struct spi_master *master = spi_master_get(platform_get_drvdata(pdev));
 	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(master);
 	unsigned long flags;
+	int i;
 
 	spin_lock_irqsave(&sdd->lock, flags);
 	sdd->state |= SUSPND;
@@ -1184,7 +1240,9 @@ static int s3c64xx_spi_suspend(struct platform_device *pdev, pm_message_t state)
 		msleep(10);
 
 	/* Disable the clock */
-	clk_disable(sdd->src_clk);
+	for (i = 0; i < MAX_SPI_BUS_CLK; i++)
+		if (sdd->bus_clk_list[i])
+			clk_disable(sdd->bus_clk_list[i]);
 	clk_disable(sdd->clk);
 
 	sdd->cur_speed = 0; /* Output Clock is stopped */
@@ -1198,11 +1256,14 @@ static int s3c64xx_spi_resume(struct platform_device *pdev)
 	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(master);
 	struct s3c64xx_spi_info *sci = sdd->cntrlr_info;
 	unsigned long flags;
+	int i;
 
 	sci->cfg_gpio(pdev);
 
 	/* Enable the clock */
-	clk_enable(sdd->src_clk);
+	for (i = 0; i < MAX_SPI_BUS_CLK; i++)
+		if (sdd->bus_clk_list[i])
+			clk_enable(sdd->bus_clk_list[i]);
 	clk_enable(sdd->clk);
 
 	s3c64xx_spi_hwinit(sdd, pdev->id);
-- 
1.7.0.4

