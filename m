Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab2HWLHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 07:07:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54752 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933998Ab2HWLG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 07:06:58 -0400
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH 5/5] MFD: ti_tscadc: Add check on number of i/p channels
Date: Thu, 23 Aug 2012 16:20:35 +0530
Message-ID: <1345719035-22871-1-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The controller provides a total of 8 analog input
lines, which can be used as:
1. 8 general purpose ADC channels
2. 4 wire TS, with 4 general purpose ADC channels
3. 5 wire TS, with 3 general purpose ADC channels

Signed-off-by: Patil, Rachna <rachna@ti.com>
---
 drivers/iio/adc/ti_adc.c           |   51 +++++-----
 drivers/input/touchscreen/ti_tsc.c |   79 ++++++++-------
 drivers/mfd/ti_tscadc.c            |  202 +++++++++++++++++++-----------------
 3 files changed, 177 insertions(+), 155 deletions(-)

diff --git a/drivers/iio/adc/ti_adc.c b/drivers/iio/adc/ti_adc.c
index a476859..48c5d63 100644
--- a/drivers/iio/adc/ti_adc.c
+++ b/drivers/iio/adc/ti_adc.c
@@ -142,37 +142,38 @@ static int __devinit tiadc_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	idev = iio_device_alloc(sizeof(struct adc_device));
-	if (idev == NULL) {
-		dev_err(&pdev->dev, "failed to allocate iio device.\n");
-		err = -ENOMEM;
-		goto err_ret;
-	}
-	adc_dev = iio_priv(idev);
-
-	tscadc_dev->adc = adc_dev;
-	adc_dev->mfd_tscadc = tscadc_dev;
-	adc_dev->idev = idev;
-	adc_dev->adc_channels = board_data->adc_init->adc_channels;
+	if (board_data->adc_init->adc_channels != 0) {
+		idev = iio_device_alloc(sizeof(struct adc_device));
+		if (idev == NULL) {
+			dev_err(&pdev->dev, "failed to allocate iio device.\n");
+			err = -ENOMEM;
+			goto err_ret;
+		}
+		adc_dev = iio_priv(idev);
 
-	idev->dev.parent = &pdev->dev;
-	idev->name = dev_name(&pdev->dev);
-	idev->modes = INDIO_DIRECT_MODE;
-	idev->info = &tiadc_info;
+		tscadc_dev->adc = adc_dev;
+		adc_dev->mfd_tscadc = tscadc_dev;
+		adc_dev->idev = idev;
+		adc_dev->adc_channels = board_data->adc_init->adc_channels;
 
-	adc_step_config(adc_dev);
+		idev->dev.parent = &pdev->dev;
+		idev->name = dev_name(&pdev->dev);
+		idev->modes = INDIO_DIRECT_MODE;
+		idev->info = &tiadc_info;
 
-	err = tiadc_channel_init(idev, adc_dev);
-	if (err < 0)
-		goto err_fail;
+		adc_step_config(adc_dev);
 
-	err = iio_device_register(idev);
-	if (err)
-		goto err_free_channels;
+		err = tiadc_channel_init(idev, adc_dev);
+		if (err < 0)
+			goto err_fail;
 
-	dev_info(&pdev->dev, "attached adc driver\n");
-	platform_set_drvdata(pdev, idev);
+		err = iio_device_register(idev);
+		if (err)
+			goto err_free_channels;
 
+		dev_info(&pdev->dev, "attached adc driver\n");
+		platform_set_drvdata(pdev, idev);
+	}
 	return 0;
 
 err_free_channels:
diff --git a/drivers/input/touchscreen/ti_tsc.c b/drivers/input/touchscreen/ti_tsc.c
index cda3b79..26b2a15 100644
--- a/drivers/input/touchscreen/ti_tsc.c
+++ b/drivers/input/touchscreen/ti_tsc.c
@@ -271,50 +271,55 @@ static int __devinit tscadc_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	/* Allocate memory for device */
-	ts_dev = kzalloc(sizeof(struct tscadc), GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!ts_dev || !input_dev) {
-		dev_err(&pdev->dev, "failed to allocate memory.\n");
-		err = -ENOMEM;
-		goto err_free_mem;
-	}
+	if (board_data->tsc_init->wires != 0) {
+		/* Allocate memory for device */
+		ts_dev = kzalloc(sizeof(struct tscadc), GFP_KERNEL);
+		input_dev = input_allocate_device();
+		if (!ts_dev || !input_dev) {
+			dev_err(&pdev->dev, "failed to allocate memory.\n");
+			err = -ENOMEM;
+			goto err_free_mem;
+		}
 
-	tscadc_dev->tsc = ts_dev;
-	ts_dev->mfd_tscadc = tscadc_dev;
-	ts_dev->input = input_dev;
-	ts_dev->irq = tscadc_dev->irq;
-	ts_dev->wires = board_data->tsc_init->wires;
-	ts_dev->x_plate_resistance = board_data->tsc_init->x_plate_resistance;
-	ts_dev->steps_to_configure = board_data->tsc_init->steps_to_configure;
-
-	err = request_irq(ts_dev->irq, tscadc_irq,
-			  0, pdev->dev.driver->name, ts_dev);
-	if (err) {
-		dev_err(&pdev->dev, "failed to allocate irq.\n");
-		goto err_free_mem;
-	}
+		tscadc_dev->tsc = ts_dev;
+		ts_dev->mfd_tscadc = tscadc_dev;
+		ts_dev->input = input_dev;
+			ts_dev->irq = tscadc_dev->irq;
+		ts_dev->wires = board_data->tsc_init->wires;
+		ts_dev->x_plate_resistance =
+			board_data->tsc_init->x_plate_resistance;
+		ts_dev->steps_to_configure =
+			board_data->tsc_init->steps_to_configure;
+
+		err = request_irq(ts_dev->irq, tscadc_irq,
+				  0, pdev->dev.driver->name, ts_dev);
+		if (err) {
+			dev_err(&pdev->dev, "failed to allocate irq.\n");
+			goto err_free_mem;
+		}
 
-	tscadc_writel(ts_dev, REG_IRQENABLE, IRQENB_FIFO0THRES);
-	tscadc_step_config(ts_dev);
-	tscadc_writel(ts_dev, REG_FIFO0THR, ts_dev->steps_to_configure);
+		tscadc_writel(ts_dev, REG_IRQENABLE, IRQENB_FIFO0THRES);
+		tscadc_step_config(ts_dev);
+		tscadc_writel(ts_dev, REG_FIFO0THR, ts_dev->steps_to_configure);
 
-	input_dev->name = "ti-tsc";
-	input_dev->dev.parent = &pdev->dev;
+		input_dev->name = "ti-tsc";
+		input_dev->dev.parent = &pdev->dev;
 
-	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
-	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
+		input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+		input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 
-	input_set_abs_params(input_dev, ABS_X, 0, MAX_12BIT, 0, 0);
-	input_set_abs_params(input_dev, ABS_Y, 0, MAX_12BIT, 0, 0);
-	input_set_abs_params(input_dev, ABS_PRESSURE, 0, MAX_12BIT, 0, 0);
+		input_set_abs_params(input_dev, ABS_X, 0, MAX_12BIT, 0, 0);
+		input_set_abs_params(input_dev, ABS_Y, 0, MAX_12BIT, 0, 0);
+		input_set_abs_params(input_dev, ABS_PRESSURE, 0, MAX_12BIT,
+				0, 0);
 
-	/* register to the input system */
-	err = input_register_device(input_dev);
-	if (err)
-		goto err_free_irq;
+		/* register to the input system */
+		err = input_register_device(input_dev);
+		if (err)
+			goto err_free_irq;
 
-	platform_set_drvdata(pdev, ts_dev);
+		platform_set_drvdata(pdev, ts_dev);
+	}
 	return 0;
 
 err_free_irq:
diff --git a/drivers/mfd/ti_tscadc.c b/drivers/mfd/ti_tscadc.c
index bf2d488..bac502b 100644
--- a/drivers/mfd/ti_tscadc.c
+++ b/drivers/mfd/ti_tscadc.c
@@ -22,6 +22,8 @@
 #include <linux/mfd/core.h>
 #include <linux/pm_runtime.h>
 #include <linux/mfd/ti_tscadc.h>
+#include <linux/platform_data/ti_adc.h>
+#include <linux/input/ti_tscadc.h>
 
 static unsigned int tscadc_readl(struct ti_tscadc_dev *tsadc, unsigned int reg)
 {
@@ -51,105 +53,119 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
 	int				clk_value, clock_rate;
 	struct resource			*res;
 	struct clk			*clk;
+	int				tsc_wires, adc_channels, total_channels;
 	struct mfd_cell			*cell = NULL;
+	struct mfd_tscadc_board		*board_data = pdev->dev.platform_data;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "no memory resource defined.\n");
+	if (!board_data) {
+		dev_err(&pdev->dev, "Could not find platform data\n");
 		return -EINVAL;
 	}
 
-	/* Allocate memory for device */
-	tscadc = kzalloc(sizeof(struct ti_tscadc_dev), GFP_KERNEL);
-	if (!tscadc) {
-		dev_err(&pdev->dev, "failed to allocate memory.\n");
-		return -ENOMEM;
-	}
-
-	res = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (!res) {
-		dev_err(&pdev->dev, "failed to reserve registers.\n");
-		err = -EBUSY;
-		goto err_free_mem;
-	}
-
-	tscadc->tscadc_base = ioremap(res->start, resource_size(res));
-	if (!tscadc->tscadc_base) {
-		dev_err(&pdev->dev, "failed to map registers.\n");
-		err = -ENOMEM;
-		goto err_release_mem;
-	}
-
-	tscadc->irq = platform_get_irq(pdev, 0);
-	if (tscadc->irq < 0) {
-		dev_err(&pdev->dev, "no irq ID is specified.\n");
-		return -ENODEV;
-	}
-
-	tscadc->dev = &pdev->dev;
-
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_get_sync(&pdev->dev);
-
-	/*
-	 * The TSC_ADC_Subsystem has 2 clock domains
-	 * OCP_CLK and ADC_CLK.
-	 * The ADC clock is expected to run at target of 3MHz,
-	 * and expected to capture 12-bit data at a rate of 200 KSPS.
-	 * The TSC_ADC_SS controller design assumes the OCP clock is
-	 * at least 6x faster than the ADC clock.
-	 */
-	clk = clk_get(&pdev->dev, "adc_tsc_fck");
-	if (IS_ERR(clk)) {
-		dev_err(&pdev->dev, "failed to get TSC fck\n");
-		err = PTR_ERR(clk);
-		goto err_fail;
-	}
-	clock_rate = clk_get_rate(clk);
-	clk_put(clk);
-	clk_value = clock_rate / ADC_CLK;
-	if (clk_value < MAX_CLK_DIV) {
-		dev_err(&pdev->dev, "clock input less than min clock requirement\n");
-		err = -EINVAL;
-		goto err_fail;
+	tsc_wires = board_data->tsc_init->wires;
+	adc_channels = board_data->adc_init->adc_channels;
+	total_channels = tsc_wires + adc_channels;
+
+	if (total_channels <= 8) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		if (!res) {
+			dev_err(&pdev->dev, "no memory resource defined.\n");
+			return -EINVAL;
+		}
+
+		/* Allocate memory for device */
+		tscadc = kzalloc(sizeof(struct ti_tscadc_dev), GFP_KERNEL);
+		if (!tscadc) {
+			dev_err(&pdev->dev, "failed to allocate memory.\n");
+			return -ENOMEM;
+		}
+
+		res = request_mem_region(res->start, resource_size(res),
+					pdev->name);
+		if (!res) {
+			dev_err(&pdev->dev, "failed to reserve registers.\n");
+			err = -EBUSY;
+			goto err_free_mem;
+		}
+
+		tscadc->tscadc_base = ioremap(res->start, resource_size(res));
+		if (!tscadc->tscadc_base) {
+			dev_err(&pdev->dev, "failed to map registers.\n");
+			err = -ENOMEM;
+			goto err_release_mem;
+		}
+
+		tscadc->irq = platform_get_irq(pdev, 0);
+		if (tscadc->irq < 0) {
+			dev_err(&pdev->dev, "no irq ID is specified.\n");
+			return -ENODEV;
+		}
+
+		tscadc->dev = &pdev->dev;
+
+		pm_runtime_enable(&pdev->dev);
+		pm_runtime_get_sync(&pdev->dev);
+
+		/*
+		 * The TSC_ADC_Subsystem has 2 clock domains
+		 * OCP_CLK and ADC_CLK.
+		 * The ADC clock is expected to run at target of 3MHz,
+		 * and expected to capture 12-bit data at a rate of 200 KSPS.
+		 * The TSC_ADC_SS controller design assumes the OCP clock is
+		 * at least 6x faster than the ADC clock.
+		 */
+		clk = clk_get(&pdev->dev, "adc_tsc_fck");
+		if (IS_ERR(clk)) {
+			dev_err(&pdev->dev, "failed to get TSC fck\n");
+			err = PTR_ERR(clk);
+			goto err_fail;
+		}
+		clock_rate = clk_get_rate(clk);
+		clk_put(clk);
+		clk_value = clock_rate / ADC_CLK;
+		if (clk_value < MAX_CLK_DIV) {
+			dev_err(&pdev->dev, "clock input less than min clock requirement\n");
+			err = -EINVAL;
+			goto err_fail;
+		}
+		/* TSCADC_CLKDIV needs to be configured to the value minus 1 */
+		clk_value = clk_value - 1;
+		tscadc_writel(tscadc, REG_CLKDIV, clk_value);
+
+		/* Set the control register bits */
+		ctrl = CNTRLREG_STEPCONFIGWRT |
+				CNTRLREG_TSCENB |
+				CNTRLREG_STEPID |
+				CNTRLREG_4WIRE;
+		tscadc_writel(tscadc, REG_CTRL, ctrl);
+
+		/* Set register bits for Idle Config Mode */
+		tscadc_idle_config(tscadc);
+
+		/* Enable the TSC module enable bit */
+		ctrl = tscadc_readl(tscadc, REG_CTRL);
+		ctrl |= CNTRLREG_TSCSSENB;
+		tscadc_writel(tscadc, REG_CTRL, ctrl);
+
+		/* TSC Cell */
+		cell = &tscadc->cells[TSC_CELL];
+		cell->name = "tsc";
+		cell->platform_data = tscadc;
+		cell->pdata_size = sizeof(*tscadc);
+
+		/* ADC Cell */
+		cell = &tscadc->cells[ADC_CELL];
+		cell->name = "tiadc";
+		cell->platform_data = tscadc;
+		cell->pdata_size = sizeof(*tscadc);
+
+		err = mfd_add_devices(&pdev->dev, pdev->id, tscadc->cells,
+				TSCADC_CELLS, NULL, 0);
+		if (err < 0)
+			goto err_fail;
+
+		platform_set_drvdata(pdev, tscadc);
 	}
-	/* TSCADC_CLKDIV needs to be configured to the value minus 1 */
-	clk_value = clk_value - 1;
-	tscadc_writel(tscadc, REG_CLKDIV, clk_value);
-
-	/* Set the control register bits */
-	ctrl = CNTRLREG_STEPCONFIGWRT |
-			CNTRLREG_TSCENB |
-			CNTRLREG_STEPID |
-			CNTRLREG_4WIRE;
-	tscadc_writel(tscadc, REG_CTRL, ctrl);
-
-	/* Set register bits for Idle Config Mode */
-	tscadc_idle_config(tscadc);
-
-	/* Enable the TSC module enable bit */
-	ctrl = tscadc_readl(tscadc, REG_CTRL);
-	ctrl |= CNTRLREG_TSCSSENB;
-	tscadc_writel(tscadc, REG_CTRL, ctrl);
-
-	/* TSC Cell */
-	cell = &tscadc->cells[TSC_CELL];
-	cell->name = "tsc";
-	cell->platform_data = tscadc;
-	cell->pdata_size = sizeof(*tscadc);
-
-	/* ADC Cell */
-	cell = &tscadc->cells[ADC_CELL];
-	cell->name = "tiadc";
-	cell->platform_data = tscadc;
-	cell->pdata_size = sizeof(*tscadc);
-
-	err = mfd_add_devices(&pdev->dev, pdev->id, tscadc->cells,
-			TSCADC_CELLS, NULL, 0);
-	if (err < 0)
-		goto err_fail;
-
-	platform_set_drvdata(pdev, tscadc);
 	return 0;
 
 err_fail:
-- 
1.7.1

