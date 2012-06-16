Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab2FPDzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 23:55:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53798 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab2FPDzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 23:55:24 -0400
Message-ID: <1339818918.10000.5.camel@phoenix>
Subject: [PATCH 1/2] extcon: Set platform drvdata in gpio_extcon_probe() and
 fix irq leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Lockwood <lockwood@android.com>
Date: Sat, 16 Jun 2012 11:55:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing platform_set_drvdata() in gpio_extcon_probe(), otherwise calling
platform_get_drvdata in gpio_extcon_remove() returns NULL.

Also add missing free_irq call in gpio_extcon_remove().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/extcon/extcon_gpio.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/extcon/extcon_gpio.c b/drivers/extcon/extcon_gpio.c
index fe7a07b..8a0dcc1 100644
--- a/drivers/extcon/extcon_gpio.c
+++ b/drivers/extcon/extcon_gpio.c
@@ -125,6 +125,7 @@ static int __devinit gpio_extcon_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_request_irq;
 
+	platform_set_drvdata(pdev, extcon_data);
 	/* Perform initial detection */
 	gpio_extcon_work(&extcon_data->work.work);
 
@@ -146,6 +147,7 @@ static int __devexit gpio_extcon_remove(struct platform_device *pdev)
 	struct gpio_extcon_data *extcon_data = platform_get_drvdata(pdev);
 
 	cancel_delayed_work_sync(&extcon_data->work);
+	free_irq(extcon_data->irq, extcon_data);
 	gpio_free(extcon_data->gpio);
 	extcon_dev_unregister(&extcon_data->edev);
 	devm_kfree(&pdev->dev, extcon_data);
-- 
1.7.9.5



