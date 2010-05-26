Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab0EZN5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:57:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33852 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab0EZN5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:57:10 -0400
From: Luotao Fu <l.fu@pengutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Marek Vasut <marek.vasut@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH] matrix_keypad: add support for clustered irq
Date: Wed, 26 May 2010 15:57:06 +0200
Message-Id: <1274882226-19778-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.7.0
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one adds support of a combined irq source for the whole matrix keypad.
This can be useful all rows and columns of the keypad is e.g. connected to
a GPIO expander, which only has one interrupt line for all events on every
single GPIO.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 drivers/input/keyboard/matrix_keypad.c |   80 ++++++++++++++++++++++++++------
 include/linux/input/matrix_keypad.h    |    5 ++
 2 files changed, 70 insertions(+), 15 deletions(-)

diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index b443e08..260dcb0 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -87,8 +87,12 @@ static void enable_row_irqs(struct matrix_keypad *keypad)
 	const struct matrix_keypad_platform_data *pdata = keypad->pdata;
 	int i;
 
-	for (i = 0; i < pdata->num_row_gpios; i++)
-		enable_irq(gpio_to_irq(pdata->row_gpios[i]));
+	if (pdata->clustered_irq > 0)
+		enable_irq(pdata->clustered_irq);
+	else {
+		for (i = 0; i < pdata->num_row_gpios; i++)
+			enable_irq(gpio_to_irq(pdata->row_gpios[i]));
+	}
 }
 
 static void disable_row_irqs(struct matrix_keypad *keypad)
@@ -96,8 +100,12 @@ static void disable_row_irqs(struct matrix_keypad *keypad)
 	const struct matrix_keypad_platform_data *pdata = keypad->pdata;
 	int i;
 
-	for (i = 0; i < pdata->num_row_gpios; i++)
-		disable_irq_nosync(gpio_to_irq(pdata->row_gpios[i]));
+	if (pdata->clustered_irq > 0)
+		disable_irq_nosync(pdata->clustered_irq);
+	else {
+		for (i = 0; i < pdata->num_row_gpios; i++)
+			disable_irq_nosync(gpio_to_irq(pdata->row_gpios[i]));
+	}
 }
 
 /*
@@ -226,6 +234,17 @@ static int matrix_keypad_suspend(struct device *dev)
 	matrix_keypad_stop(keypad->input_dev);
 
 	if (device_may_wakeup(&pdev->dev)) {
+		if (pdata->clustered_irq > 0) {
+			unsigned int cirq = pdata->clustered_irq;
+
+			if (enable_irq_wake(cirq) == 0) {
+				for (i = 0; i < pdata->num_row_gpios; i++)
+					__set_bit(i, keypad->disabled_gpios);
+			}
+
+			goto out;
+		}
+
 		for (i = 0; i < pdata->num_row_gpios; i++) {
 			if (!test_bit(i, keypad->disabled_gpios)) {
 				unsigned int gpio = pdata->row_gpios[i];
@@ -235,7 +254,7 @@ static int matrix_keypad_suspend(struct device *dev)
 			}
 		}
 	}
-
+out:
 	return 0;
 }
 
@@ -247,6 +266,17 @@ static int matrix_keypad_resume(struct device *dev)
 	int i;
 
 	if (device_may_wakeup(&pdev->dev)) {
+		if (pdata->clustered_irq > 0) {
+			unsigned int cirq = pdata->clustered_irq;
+
+			if (disable_irq_wake(cirq) == 0) {
+				for (i = 0; i < pdata->num_row_gpios; i++)
+					clear_bit(i, keypad->disabled_gpios);
+			}
+
+			goto out;
+		}
+
 		for (i = 0; i < pdata->num_row_gpios; i++) {
 			if (test_and_clear_bit(i, keypad->disabled_gpios)) {
 				unsigned int gpio = pdata->row_gpios[i];
@@ -256,6 +286,7 @@ static int matrix_keypad_resume(struct device *dev)
 		}
 	}
 
+out:
 	matrix_keypad_start(keypad->input_dev);
 
 	return 0;
@@ -296,17 +327,31 @@ static int __devinit init_matrix_gpio(struct platform_device *pdev,
 		gpio_direction_input(pdata->row_gpios[i]);
 	}
 
-	for (i = 0; i < pdata->num_row_gpios; i++) {
-		err = request_irq(gpio_to_irq(pdata->row_gpios[i]),
+	if (pdata->clustered_irq > 0) {
+		err = request_irq(pdata->clustered_irq,
 				matrix_keypad_interrupt,
-				IRQF_DISABLED |
-				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+				pdata->clustered_irq_flags,
 				"matrix-keypad", keypad);
 		if (err) {
 			dev_err(&pdev->dev,
-				"Unable to acquire interrupt for GPIO line %i\n",
-				pdata->row_gpios[i]);
-			goto err_free_irqs;
+				"Unable to acquire clustered interrupt\n");
+			goto err_free_rows;
+		}
+	} else {
+		for (i = 0; i < pdata->num_row_gpios; i++) {
+			err = request_irq(gpio_to_irq(pdata->row_gpios[i]),
+					matrix_keypad_interrupt,
+					IRQF_DISABLED |
+					IRQF_TRIGGER_RISING |
+					IRQF_TRIGGER_FALLING,
+					"matrix-keypad", keypad);
+			if (err) {
+				dev_err(&pdev->dev,
+					"Unable to acquire interrupt "
+					"for GPIO line %i\n",
+					pdata->row_gpios[i]);
+				goto err_free_irqs;
+			}
 		}
 	}
 
@@ -418,11 +463,16 @@ static int __devexit matrix_keypad_remove(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 0);
 
-	for (i = 0; i < pdata->num_row_gpios; i++) {
-		free_irq(gpio_to_irq(pdata->row_gpios[i]), keypad);
-		gpio_free(pdata->row_gpios[i]);
+	if (pdata->clustered_irq > 0) {
+		free_irq(pdata->clustered_irq, keypad);
+	} else {
+		for (i = 0; i < pdata->num_row_gpios; i++)
+			free_irq(gpio_to_irq(pdata->row_gpios[i]), keypad);
 	}
 
+	for (i = 0; i < pdata->num_row_gpios; i++)
+		gpio_free(pdata->row_gpios[i]);
+
 	for (i = 0; i < pdata->num_col_gpios; i++)
 		gpio_free(pdata->col_gpios[i]);
 
diff --git a/include/linux/input/matrix_keypad.h b/include/linux/input/matrix_keypad.h
index c964cd7..8e8dc2e 100644
--- a/include/linux/input/matrix_keypad.h
+++ b/include/linux/input/matrix_keypad.h
@@ -63,6 +63,11 @@ struct matrix_keypad_platform_data {
 	/* key debounce interval in milli-second */
 	unsigned int	debounce_ms;
 
+	/* used if interrupts of all row/column GPIOs are bundled to one single
+	 * irq */
+	unsigned int	clustered_irq;
+	unsigned int	clustered_irq_flags;
+
 	bool		active_low;
 	bool		wakeup;
 	bool		no_autorepeat;
-- 
1.7.0

