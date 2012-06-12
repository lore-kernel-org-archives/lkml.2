Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab2FLS1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:27:13 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:35017 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455Ab2FLS1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:27:11 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] mfd: ab3100-core: use devm allocation
Date: Tue, 12 Jun 2012 20:26:58 +0200
Message-ID: <1339525618-8318-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Allocate memory and irq for device state using devm_*
helpers to simplify memory accounting.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab3100-core.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 1efad20..4276aab 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -867,7 +867,7 @@ static int __devinit ab3100_probe(struct i2c_client *client,
 	int err;
 	int i;
 
-	ab3100 = kzalloc(sizeof(struct ab3100), GFP_KERNEL);
+	ab3100 = devm_kzalloc(&client->dev, sizeof(struct ab3100), GFP_KERNEL);
 	if (!ab3100) {
 		dev_err(&client->dev, "could not allocate AB3100 device\n");
 		return -ENOMEM;
@@ -921,7 +921,7 @@ static int __devinit ab3100_probe(struct i2c_client *client,
 
 	/* Attach a second dummy i2c_client to the test register address */
 	ab3100->testreg_client = i2c_new_dummy(client->adapter,
-						     client->addr + 1);
+					       client->addr + 1);
 	if (!ab3100->testreg_client) {
 		err = -ENOMEM;
 		goto exit_no_testreg_client;
@@ -931,13 +931,13 @@ static int __devinit ab3100_probe(struct i2c_client *client,
 	if (err)
 		goto exit_no_setup;
 
-	err = request_threaded_irq(client->irq, NULL, ab3100_irq_handler,
-				IRQF_ONESHOT, "ab3100-core", ab3100);
-	/* This real unpredictable IRQ is of course sampled for entropy */
-	rand_initialize_irq(client->irq);
-
+	err = devm_request_threaded_irq(&client->dev,
+					client->irq, NULL, ab3100_irq_handler,
+					IRQF_ONESHOT, "ab3100-core", ab3100);
 	if (err)
 		goto exit_no_irq;
+	/* This real unpredictable IRQ is of course sampled for entropy */
+	rand_initialize_irq(client->irq);
 
 	err = abx500_register_ops(&client->dev, &ab3100_ops);
 	if (err)
@@ -962,7 +962,6 @@ static int __devinit ab3100_probe(struct i2c_client *client,
 	i2c_unregister_device(ab3100->testreg_client);
  exit_no_testreg_client:
  exit_no_detect:
-	kfree(ab3100);
 	return err;
 }
 
@@ -972,16 +971,8 @@ static int __devexit ab3100_remove(struct i2c_client *client)
 
 	/* Unregister subdevices */
 	mfd_remove_devices(&client->dev);
-
 	ab3100_remove_debugfs();
 	i2c_unregister_device(ab3100->testreg_client);
-
-	/*
-	 * At this point, all subscribers should have unregistered
-	 * their notifiers so deactivate IRQ
-	 */
-	free_irq(client->irq, ab3100);
-	kfree(ab3100);
 	return 0;
 }
 
-- 
1.7.9.2

