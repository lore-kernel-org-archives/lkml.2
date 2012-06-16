Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926Ab2FPD4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 23:56:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63152 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2FPD43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 23:56:29 -0400
Message-ID: <1339818984.10000.6.camel@phoenix>
Subject: [PATCH 2/2] extcon: Convert extcon_gpio to devm_gpio_request_one
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Lockwood <lockwood@android.com>
Date: Sat, 16 Jun 2012 11:56:24 +0800
In-Reply-To: <1339818918.10000.5.camel@phoenix>
References: <1339818918.10000.5.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove unneeded devm_kfree calls.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/extcon/extcon_gpio.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/extcon/extcon_gpio.c b/drivers/extcon/extcon_gpio.c
index 8a0dcc1..fe3db45 100644
--- a/drivers/extcon/extcon_gpio.c
+++ b/drivers/extcon/extcon_gpio.c
@@ -105,25 +105,25 @@ static int __devinit gpio_extcon_probe(struct platform_device *pdev)
 
 	ret = extcon_dev_register(&extcon_data->edev, &pdev->dev);
 	if (ret < 0)
-		goto err_extcon_dev_register;
+		return ret;
 
 	ret = gpio_request_one(extcon_data->gpio, GPIOF_DIR_IN, pdev->name);
 	if (ret < 0)
-		goto err_request_gpio;
+		goto err;
 
 	INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
 
 	extcon_data->irq = gpio_to_irq(extcon_data->gpio);
 	if (extcon_data->irq < 0) {
 		ret = extcon_data->irq;
-		goto err_detect_irq_num_failed;
+		goto err;
 	}
 
 	ret = request_any_context_irq(extcon_data->irq, gpio_irq_handler,
 				      pdata->irq_flags, pdev->name,
 				      extcon_data);
 	if (ret < 0)
-		goto err_request_irq;
+		goto err;
 
 	platform_set_drvdata(pdev, extcon_data);
 	/* Perform initial detection */
@@ -131,13 +131,8 @@ static int __devinit gpio_extcon_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_request_irq:
-err_detect_irq_num_failed:
-	gpio_free(extcon_data->gpio);
-err_request_gpio:
+err:
 	extcon_dev_unregister(&extcon_data->edev);
-err_extcon_dev_register:
-	devm_kfree(&pdev->dev, extcon_data);
 
 	return ret;
 }
@@ -148,9 +143,7 @@ static int __devexit gpio_extcon_remove(struct platform_device *pdev)
 
 	cancel_delayed_work_sync(&extcon_data->work);
 	free_irq(extcon_data->irq, extcon_data);
-	gpio_free(extcon_data->gpio);
 	extcon_dev_unregister(&extcon_data->edev);
-	devm_kfree(&pdev->dev, extcon_data);
 
 	return 0;
 }
-- 
1.7.9.5



