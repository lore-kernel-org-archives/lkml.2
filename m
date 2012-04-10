Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab2DJITK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:19:10 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:36562 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195Ab2DJITG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:19:06 -0400
Date: Tue, 10 Apr 2012 01:19:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: matrix-keypad - undo GPIO setup if
 input_register_device fails
Message-ID: <20120410081902.GA19467@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/keyboard/matrix_keypad.c |   53 ++++++++++++++++++--------------
 1 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index a4ff08c..98ae281 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -299,11 +299,11 @@ static int matrix_keypad_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(matrix_keypad_pm_ops,
 			 matrix_keypad_suspend, matrix_keypad_resume);
 
-static int __devinit init_matrix_gpio(struct platform_device *pdev,
-					struct matrix_keypad *keypad)
+static int __devinit matrix_keypad_init_gpio(struct platform_device *pdev,
+					     struct matrix_keypad *keypad)
 {
 	const struct matrix_keypad_platform_data *pdata = keypad->pdata;
-	int i, err = -EINVAL;
+	int i, err;
 
 	/* initialized strobe lines as outputs, activated */
 	for (i = 0; i < pdata->num_col_gpios; i++) {
@@ -349,8 +349,7 @@ static int __devinit init_matrix_gpio(struct platform_device *pdev,
 					"matrix-keypad", keypad);
 			if (err) {
 				dev_err(&pdev->dev,
-					"Unable to acquire interrupt "
-					"for GPIO line %i\n",
+					"Unable to acquire interrupt for GPIO line %i\n",
 					pdata->row_gpios[i]);
 				goto err_free_irqs;
 			}
@@ -376,6 +375,25 @@ err_free_cols:
 	return err;
 }
 
+static void matrix_keypad_free_gpio(struct matrix_keypad *keypad)
+{
+	const struct matrix_keypad_platform_data *pdata = keypad->pdata;
+	int i;
+
+	if (pdata->clustered_irq > 0) {
+		free_irq(pdata->clustered_irq, keypad);
+	} else {
+		for (i = 0; i < pdata->num_row_gpios; i++)
+			free_irq(gpio_to_irq(pdata->row_gpios[i]), keypad);
+	}
+
+	for (i = 0; i < pdata->num_row_gpios; i++)
+		gpio_free(pdata->row_gpios[i]);
+
+	for (i = 0; i < pdata->num_col_gpios; i++)
+		gpio_free(pdata->col_gpios[i]);
+}
+
 static int __devinit matrix_keypad_probe(struct platform_device *pdev)
 {
 	const struct matrix_keypad_platform_data *pdata;
@@ -435,19 +453,21 @@ static int __devinit matrix_keypad_probe(struct platform_device *pdev)
 	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
 	input_set_drvdata(input_dev, keypad);
 
-	err = init_matrix_gpio(pdev, keypad);
+	err = matrix_keypad_init_gpio(pdev, keypad);
 	if (err)
 		goto err_free_mem;
 
 	err = input_register_device(keypad->input_dev);
 	if (err)
-		goto err_free_mem;
+		goto err_free_gpio;
 
 	device_init_wakeup(&pdev->dev, pdata->wakeup);
 	platform_set_drvdata(pdev, keypad);
 
 	return 0;
 
+err_free_gpio:
+	matrix_keypad_free_gpio(keypad);
 err_free_mem:
 	input_free_device(input_dev);
 	kfree(keypad);
@@ -457,28 +477,15 @@ err_free_mem:
 static int __devexit matrix_keypad_remove(struct platform_device *pdev)
 {
 	struct matrix_keypad *keypad = platform_get_drvdata(pdev);
-	const struct matrix_keypad_platform_data *pdata = keypad->pdata;
-	int i;
 
 	device_init_wakeup(&pdev->dev, 0);
 
-	if (pdata->clustered_irq > 0) {
-		free_irq(pdata->clustered_irq, keypad);
-	} else {
-		for (i = 0; i < pdata->num_row_gpios; i++)
-			free_irq(gpio_to_irq(pdata->row_gpios[i]), keypad);
-	}
-
-	for (i = 0; i < pdata->num_row_gpios; i++)
-		gpio_free(pdata->row_gpios[i]);
-
-	for (i = 0; i < pdata->num_col_gpios; i++)
-		gpio_free(pdata->col_gpios[i]);
-
+	matrix_keypad_free_gpio(keypad);
 	input_unregister_device(keypad->input_dev);
-	platform_set_drvdata(pdev, NULL);
 	kfree(keypad);
 
+	platform_set_drvdata(pdev, NULL);
+
 	return 0;
 }
 
-- 
1.7.7.6


-- 
Dmitry
