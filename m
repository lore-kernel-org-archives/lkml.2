Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab2JDDQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 23:16:03 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44594 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab2JDDP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 23:15:56 -0400
From: Fabio Estevam <festevam@gmail.com>
To: sameo@linux.intel.com
Cc: broonie@opensource.wolfsonmicro.com, ashish.jangam@kpitcummins.com,
        dchen@diasemi.com, arnd@arndb.de, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-input@vger.kernel.org>
Subject: [PATCH 4/6] Input: da9052_onkey.c: Convert to the new da9052 interrupt functions.
Date: Thu,  4 Oct 2012 00:15:07 -0300
Message-Id: <1349320509-26930-4-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349320509-26930-1-git-send-email-festevam@gmail.com>
References: <1349320509-26930-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Use the new da9052 irq functions and allow the driver to probe successfully.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: <linux-input@vger.kernel.org>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/input/misc/da9052_onkey.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/input/misc/da9052_onkey.c b/drivers/input/misc/da9052_onkey.c
index 3c843cd..3be3acc 100644
--- a/drivers/input/misc/da9052_onkey.c
+++ b/drivers/input/misc/da9052_onkey.c
@@ -24,7 +24,6 @@ struct da9052_onkey {
 	struct da9052 *da9052;
 	struct input_dev *input;
 	struct delayed_work work;
-	unsigned int irq;
 };
 
 static void da9052_onkey_query(struct da9052_onkey *onkey)
@@ -76,7 +75,6 @@ static int __devinit da9052_onkey_probe(struct platform_device *pdev)
 	struct da9052 *da9052 = dev_get_drvdata(pdev->dev.parent);
 	struct da9052_onkey *onkey;
 	struct input_dev *input_dev;
-	int irq;
 	int error;
 
 	if (!da9052) {
@@ -84,13 +82,6 @@ static int __devinit da9052_onkey_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	irq = platform_get_irq_byname(pdev, "ONKEY");
-	if (irq < 0) {
-		dev_err(&pdev->dev,
-			"Failed to get an IRQ for input device, %d\n", irq);
-		return -EINVAL;
-	}
-
 	onkey = kzalloc(sizeof(*onkey), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!onkey || !input_dev) {
@@ -101,7 +92,6 @@ static int __devinit da9052_onkey_probe(struct platform_device *pdev)
 
 	onkey->input = input_dev;
 	onkey->da9052 = da9052;
-	onkey->irq = irq;
 	INIT_DELAYED_WORK(&onkey->work, da9052_onkey_work);
 
 	input_dev->name = "da9052-onkey";
@@ -111,13 +101,11 @@ static int __devinit da9052_onkey_probe(struct platform_device *pdev)
 	input_dev->evbit[0] = BIT_MASK(EV_KEY);
 	__set_bit(KEY_POWER, input_dev->keybit);
 
-	error = request_threaded_irq(onkey->irq, NULL, da9052_onkey_irq,
-				     IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				     "ONKEY", onkey);
+	error = da9052_request_irq(onkey->da9052, DA9052_IRQ_NONKEY, "ONKEY",
+			    da9052_onkey_irq, onkey);
 	if (error < 0) {
 		dev_err(onkey->da9052->dev,
-			"Failed to register ONKEY IRQ %d, error = %d\n",
-			onkey->irq, error);
+			"Failed to register ONKEY IRQ: %d\n", error);
 		goto err_free_mem;
 	}
 
@@ -132,7 +120,7 @@ static int __devinit da9052_onkey_probe(struct platform_device *pdev)
 	return 0;
 
 err_free_irq:
-	free_irq(onkey->irq, onkey);
+	da9052_free_irq(onkey->da9052, DA9052_IRQ_NONKEY, onkey);
 	cancel_delayed_work_sync(&onkey->work);
 err_free_mem:
 	input_free_device(input_dev);
@@ -145,7 +133,7 @@ static int __devexit da9052_onkey_remove(struct platform_device *pdev)
 {
 	struct da9052_onkey *onkey = platform_get_drvdata(pdev);
 
-	free_irq(onkey->irq, onkey);
+	da9052_free_irq(onkey->da9052, DA9052_IRQ_NONKEY, onkey);
 	cancel_delayed_work_sync(&onkey->work);
 
 	input_unregister_device(onkey->input);
-- 
1.7.9.5

