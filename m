Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab2KIP2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:28:12 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44457 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab2KIP2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:28:07 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/3] input: stmpe-ts: Use devm_*() routines
Date: Fri,  9 Nov 2012 20:57:49 +0530
Message-Id: <52b9fe53a8bd8dff7105209c5b1fab9da7a1510d.1352474824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <3d6f34ca5960203a5efb761f4d56b4e10ee24827.1352474824.git.viresh.kumar@linaro.org>
References: <3d6f34ca5960203a5efb761f4d56b4e10ee24827.1352474824.git.viresh.kumar@linaro.org>
In-Reply-To: <3d6f34ca5960203a5efb761f4d56b4e10ee24827.1352474824.git.viresh.kumar@linaro.org>
References: <3d6f34ca5960203a5efb761f4d56b4e10ee24827.1352474824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch frees stmpe-ts driver from tension of freeing resources :)
devm_* derivatives of multiple routines are used while allocating resources,
which would be freed automatically by kernel.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/input/touchscreen/stmpe-ts.c | 45 +++++++++---------------------------
 1 file changed, 11 insertions(+), 34 deletions(-)

diff --git a/drivers/input/touchscreen/stmpe-ts.c b/drivers/input/touchscreen/stmpe-ts.c
index 692b685..66b932e 100644
--- a/drivers/input/touchscreen/stmpe-ts.c
+++ b/drivers/input/touchscreen/stmpe-ts.c
@@ -275,17 +275,13 @@ static int __devinit stmpe_input_probe(struct platform_device *pdev)
 	if (ts_irq < 0)
 		return ts_irq;
 
-	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
-	if (!ts) {
-		ret = -ENOMEM;
-		goto err_out;
-	}
+	ts = devm_kzalloc(&pdev->dev, sizeof(*ts), GFP_KERNEL);
+	if (!ts)
+		return -ENOMEM;
 
-	idev = input_allocate_device();
-	if (!idev) {
-		ret = -ENOMEM;
-		goto err_free_ts;
-	}
+	idev = devm_input_allocate_device(&pdev->dev);
+	if (!idev)
+		return -ENOMEM;
 
 	platform_set_drvdata(pdev, ts);
 	ts->stmpe = stmpe;
@@ -309,16 +305,16 @@ static int __devinit stmpe_input_probe(struct platform_device *pdev)
 
 	INIT_DELAYED_WORK(&ts->work, stmpe_work);
 
-	ret = request_threaded_irq(ts_irq, NULL, stmpe_ts_handler,
-			IRQF_ONESHOT, STMPE_TS_NAME, ts);
+	ret = devm_request_threaded_irq(&pdev->dev, ts_irq, NULL,
+			stmpe_ts_handler, IRQF_ONESHOT, STMPE_TS_NAME, ts);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request IRQ %d\n", ts_irq);
-		goto err_free_input;
+		return ret;
 	}
 
 	ret = stmpe_init_hw(ts);
 	if (ret)
-		goto err_free_irq;
+		return ret;
 
 	idev->name = STMPE_TS_NAME;
 	idev->id.bustype = BUS_I2C;
@@ -335,39 +331,20 @@ static int __devinit stmpe_input_probe(struct platform_device *pdev)
 	input_set_abs_params(idev, ABS_PRESSURE, 0x0, 0xff, 0, 0);
 
 	ret = input_register_device(idev);
-	if (ret) {
+	if (ret)
 		dev_err(&pdev->dev, "Could not register input device\n");
-		goto err_free_irq;
-	}
-
-	return ret;
 
-err_free_irq:
-	free_irq(ts_irq, ts);
-err_free_input:
-	input_free_device(idev);
-	platform_set_drvdata(pdev, NULL);
-err_free_ts:
-	kfree(ts);
-err_out:
 	return ret;
 }
 
 static int __devexit stmpe_ts_remove(struct platform_device *pdev)
 {
 	struct stmpe_touch *ts = platform_get_drvdata(pdev);
-	unsigned int ts_irq = platform_get_irq_byname(pdev, "FIFO_TH");
 
 	stmpe_disable(ts->stmpe, STMPE_BLOCK_TOUCHSCREEN);
 
-	free_irq(ts_irq, ts);
-
-	platform_set_drvdata(pdev, NULL);
-
 	input_unregister_device(ts->idev);
 
-	kfree(ts);
-
 	return 0;
 }
 
-- 
1.7.12.rc2.18.g61b472e

