Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362Ab2JaRcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:32:08 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:51773 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932968Ab2JaRb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:31:58 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, "Patil, Rachna" <rachna@ti.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: [PATCH 3/3] ti_tscadc: Deal with non activation of all the devices.
Date: Thu,  1 Nov 2012 17:24:56 +0200
Message-Id: <1351783496-11557-3-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1351783496-11557-1-git-send-email-panto@antoniou-consulting.com>
References: <1351783496-11557-1-git-send-email-panto@antoniou-consulting.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's common not for both the touchscreen & adc to be activated
at the same time. Deal with this case.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/mfd/ti_am335x_tscadc.c       | 34 +++++++++++++++++++++++-----------
 include/linux/mfd/ti_am335x_tscadc.h |  8 +++-----
 2 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index e947dd8..97eb4f7 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -68,7 +68,7 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
 	int			irq;
 	int			err, ctrl;
 	int			clk_value, clock_rate;
-	int			tsc_wires, adc_channels = 0, total_channels;
+	int			tsc_wires = 0, adc_channels = 0, total_channels;
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "Could not find platform data\n");
@@ -78,7 +78,9 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
 	if (pdata->adc_init)
 		adc_channels = pdata->adc_init->adc_channels;
 
-	tsc_wires = pdata->tsc_init->wires;
+	if (pdata->tsc_init)
+		tsc_wires = pdata->tsc_init->wires;
+
 	total_channels = tsc_wires + adc_channels;
 
 	if (total_channels > 8) {
@@ -176,20 +178,30 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
 	ctrl |= CNTRLREG_TSCSSENB;
 	tscadc_writel(tscadc, REG_CTRL, ctrl);
 
+	tscadc->used_cells = 0;
+	tscadc->tsc_cell = -1;
+	tscadc->adc_cell = -1;
+
 	/* TSC Cell */
-	cell = &tscadc->cells[TSC_CELL];
-	cell->name = "tsc";
-	cell->platform_data = tscadc;
-	cell->pdata_size = sizeof(*tscadc);
+	if (tsc_wires > 0) {
+		tscadc->tsc_cell = tscadc->used_cells;
+		cell = &tscadc->cells[tscadc->used_cells++];
+		cell->name = "tsc";
+		cell->platform_data = tscadc;
+		cell->pdata_size = sizeof(*tscadc);
+	}
 
 	/* ADC Cell */
-	cell = &tscadc->cells[ADC_CELL];
-	cell->name = "tiadc";
-	cell->platform_data = tscadc;
-	cell->pdata_size = sizeof(*tscadc);
+	if (adc_channels > 0) {
+		tscadc->adc_cell = tscadc->used_cells;
+		cell = &tscadc->cells[tscadc->used_cells++];
+		cell->name = "tiadc";
+		cell->platform_data = tscadc;
+		cell->pdata_size = sizeof(*tscadc);
+	}
 
 	err = mfd_add_devices(&pdev->dev, pdev->id, tscadc->cells,
-			TSCADC_CELLS, NULL, 0, NULL);
+			tscadc->used_cells, NULL, 0, NULL);
 	if (err < 0)
 		goto err_disable_clk;
 
diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index 9624fea..50a245f 100644
--- a/include/linux/mfd/ti_am335x_tscadc.h
+++ b/include/linux/mfd/ti_am335x_tscadc.h
@@ -128,11 +128,6 @@
 
 #define TSCADC_CELLS		2
 
-enum tscadc_cells {
-	TSC_CELL,
-	ADC_CELL,
-};
-
 struct mfd_tscadc_board {
 	struct tsc_data *tsc_init;
 	struct adc_data *adc_init;
@@ -143,6 +138,9 @@ struct ti_tscadc_dev {
 	struct regmap *regmap_tscadc;
 	void __iomem *tscadc_base;
 	int irq;
+	int used_cells;	/* 0-2 */
+	int tsc_cell;	/* -1 if not used */
+	int adc_cell;	/* -1 if not used */
 	struct mfd_cell cells[TSCADC_CELLS];
 
 	/* tsc device */
-- 
1.7.12

