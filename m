Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab2KYIcf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 03:32:35 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:58659 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab2KYIcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 03:32:33 -0500
Date: Sun, 25 Nov 2012 00:32:29 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>, linux-input@vger.kernel.org,
        Philippe Langlais <philippe.langlais@linaro.org>
Subject: Re: [PATCH 1/2] input: gpio-keys: Disable hardware on suspend
Message-ID: <20121125083229.GB21091@core.coreip.homeip.net>
References: <1353590617-11466-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353590617-11466-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 01:23:36PM +0000, Lee Jones wrote:
> From: Jonas Aaberg <jonas.aberg@stericsson.com>
> 
> Disable hardware if active when suspending if the hw can not
> wake the system from suspend.

How about below instead (needs the other patch I have just sent out)?

Thanks.

-- 
Dmitry

Input: gpio-keys - disable hardware on suspend

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Disable hardware if active when suspending if the hw can not
wake the system from suspend.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
Reviewed-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/keyboard/gpio_keys.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index c7764ca..79435de 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -803,6 +803,7 @@ static int gpio_keys_remove(struct platform_device *pdev)
 static int gpio_keys_suspend(struct device *dev)
 {
 	struct gpio_keys_drvdata *ddata = dev_get_drvdata(dev);
+	struct input_dev *input = ddata->input;
 	int i;
 
 	if (device_may_wakeup(dev)) {
@@ -811,6 +812,11 @@ static int gpio_keys_suspend(struct device *dev)
 			if (bdata->button->wakeup)
 				enable_irq_wake(bdata->irq);
 		}
+	} else {
+		mutex_lock(&input->mutex);
+		if (input->users)
+			gpio_keys_close(input);
+		mutex_unlock(&input->mutex);
 	}
 
 	return 0;
@@ -819,16 +825,27 @@ static int gpio_keys_suspend(struct device *dev)
 static int gpio_keys_resume(struct device *dev)
 {
 	struct gpio_keys_drvdata *ddata = dev_get_drvdata(dev);
+	struct input_dev *input = ddata->input;
+	int error = 0;
 	int i;
 
-	for (i = 0; i < ddata->pdata->nbuttons; i++) {
-		struct gpio_button_data *bdata = &ddata->data[i];
-		if (bdata->button->wakeup && device_may_wakeup(dev))
-			disable_irq_wake(bdata->irq);
+	if (device_may_wakeup(dev)) {
+		for (i = 0; i < ddata->pdata->nbuttons; i++) {
+			struct gpio_button_data *bdata = &ddata->data[i];
+			if (bdata->button->wakeup)
+				disable_irq_wake(bdata->irq);
+		}
+	} else {
+		mutex_lock(&input->mutex);
+		if (input->users)
+			error = gpio_keys_open(input);
+		mutex_unlock(&input->mutex);
 	}
 
-	gpio_keys_report_state(ddata);
+	if (error)
+		return error;
 
+	gpio_keys_report_state(ddata);
 	return 0;
 }
 #endif
