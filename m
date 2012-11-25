Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab2KYIb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 03:31:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39128 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab2KYIb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 03:31:26 -0500
Date: Sun, 25 Nov 2012 00:31:22 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Input: gpio_keys - report initial state when opening the
 device
Message-ID: <20121125083121.GA29530@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of reporting the initial stage when the device is registered we
should do it when the device is opened (so there are users).

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/keyboard/gpio_keys.c | 39 +++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 1a5cb6f..c7764ca 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -526,12 +526,35 @@ fail:
 	return error;
 }
 
+static void gpio_keys_report_state(struct gpio_keys_drvdata *ddata)
+{
+	struct input_dev *input = ddata->input;
+	int i;
+
+	for (i = 0; i < ddata->pdata->nbuttons; i++) {
+		struct gpio_button_data *bdata = &ddata->data[i];
+		if (gpio_is_valid(bdata->button->gpio))
+			gpio_keys_gpio_report_event(bdata);
+	}
+	input_sync(input);
+}
+
 static int gpio_keys_open(struct input_dev *input)
 {
 	struct gpio_keys_drvdata *ddata = input_get_drvdata(input);
 	const struct gpio_keys_platform_data *pdata = ddata->pdata;
+	int error;
+
+	if (pdata->enable) {
+		error = pdata->enable(input->dev.parent);
+		if (error)
+			return error;
+	}
 
-	return pdata->enable ? pdata->enable(input->dev.parent) : 0;
+	/* Report current state of buttons that are connected to GPIOs */
+	gpio_keys_report_state(ddata);
+
+	return 0;
 }
 
 static void gpio_keys_close(struct input_dev *input)
@@ -731,14 +754,6 @@ static int gpio_keys_probe(struct platform_device *pdev)
 		goto fail3;
 	}
 
-	/* get current state of buttons that are connected to GPIOs */
-	for (i = 0; i < pdata->nbuttons; i++) {
-		struct gpio_button_data *bdata = &ddata->data[i];
-		if (gpio_is_valid(bdata->button->gpio))
-			gpio_keys_gpio_report_event(bdata);
-	}
-	input_sync(input);
-
 	device_init_wakeup(&pdev->dev, wakeup);
 
 	return 0;
@@ -810,11 +825,9 @@ static int gpio_keys_resume(struct device *dev)
 		struct gpio_button_data *bdata = &ddata->data[i];
 		if (bdata->button->wakeup && device_may_wakeup(dev))
 			disable_irq_wake(bdata->irq);
-
-		if (gpio_is_valid(bdata->button->gpio))
-			gpio_keys_gpio_report_event(bdata);
 	}
-	input_sync(ddata->input);
+
+	gpio_keys_report_state(ddata);
 
 	return 0;
 }
-- 
1.7.11.7


-- 
Dmitry
