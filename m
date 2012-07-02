Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab2GBKPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:15:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59712 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929Ab2GBKPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:15:52 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] leds-88pm860x: use devm_kzalloc function
Date: Mon,  2 Jul 2012 15:45:43 +0530
Message-Id: <1341224143-27894-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using devm_kzalloc will remove all the error checks and the frees are automatically done at the driver unload side.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---

Thanks Bryan for advising me.. ;-)

 drivers/leds/leds-88pm860x.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/leds/leds-88pm860x.c b/drivers/leds/leds-88pm860x.c
index 5b61aaf..61897cf 100644
--- a/drivers/leds/leds-88pm860x.c
+++ b/drivers/leds/leds-88pm860x.c
@@ -209,7 +209,7 @@ static int pm860x_led_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	data = kzalloc(sizeof(struct pm860x_led), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(struct pm860x_led), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 	strncpy(data->name, res->name, MFD_NAME_SIZE - 1);
@@ -220,7 +220,6 @@ static int pm860x_led_probe(struct platform_device *pdev)
 	data->port = pdata->flags;
 	if (data->port < 0) {
 		dev_err(&pdev->dev, "check device failed\n");
-		kfree(data);
 		return -EINVAL;
 	}
 
@@ -233,13 +232,10 @@ static int pm860x_led_probe(struct platform_device *pdev)
 	ret = led_classdev_register(chip->dev, &data->cdev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register LED: %d\n", ret);
-		goto out;
+		return ret;
 	}
 	pm860x_led_set(&data->cdev, 0);
 	return 0;
-out:
-	kfree(data);
-	return ret;
 }
 
 static int pm860x_led_remove(struct platform_device *pdev)
@@ -247,7 +243,6 @@ static int pm860x_led_remove(struct platform_device *pdev)
 	struct pm860x_led *data = platform_get_drvdata(pdev);
 
 	led_classdev_unregister(&data->cdev);
-	kfree(data);
 
 	return 0;
 }
-- 
1.7.9.5

