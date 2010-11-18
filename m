Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757Ab0KRWJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:09:06 -0500
Received: from smtp-out-249.synserver.de ([212.40.180.249]:1053 "HELO
	smtp-out-247.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1754397Ab0KRWJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:09:05 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 23983
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] POWER: gpio-charger: Fix potential race between irq handler and probe/remove function
Date: Thu, 18 Nov 2010 23:08:38 +0100
Message-Id: <1290118119-16468-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1290118119-16468-1-git-send-email-lars@metafoo.de>
References: <1290118119-16468-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a potential race between the irq handler and the probe and
remove functions.
The irq should not be requested before the chargers power_supply has been
registered and has to be freed before the power_supply is unregistered,
otherwise it is possible that the irq fires while the power_supply is not
initialized yet or has already been freed.

While we are at it replace request_irq with request_any_context_irq.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/gpio-charger.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index 8458caf..016d5c0 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -98,7 +98,7 @@ static int __devinit gpio_charger_probe(struct platform_device *pdev)
 	charger->type = pdata->type;
 	charger->properties = gpio_charger_properties;
 	charger->num_properties = ARRAY_SIZE(gpio_charger_properties);
-	charger->get_property  = gpio_charger_get_property;
+	charger->get_property = gpio_charger_get_property;
 	charger->supplied_to = pdata->supplied_to;
 	charger->num_supplicants = pdata->num_supplicants;
 
@@ -113,9 +113,17 @@ static int __devinit gpio_charger_probe(struct platform_device *pdev)
 		goto err_gpio_free;
 	}
 
+	gpio_charger->pdata = pdata;
+
+	ret = power_supply_register(&pdev->dev, charger);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to register power supply: %d\n", ret);
+		goto err_gpio_free;
+	}
+
 	irq = gpio_to_irq(pdata->gpio);
 	if (irq > 0) {
-		ret = request_irq(irq, gpio_charger_irq,
+		ret = request_any_context_irq(irq, gpio_charger_irq,
 				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 				dev_name(&pdev->dev), charger);
 		if (ret)
@@ -124,21 +132,10 @@ static int __devinit gpio_charger_probe(struct platform_device *pdev)
 			gpio_charger->irq = irq;
 	}
 
-	gpio_charger->pdata = pdata;
-
-	ret = power_supply_register(&pdev->dev, charger);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "Failed to register power supply: %d\n", ret);
-		goto err_irq_free;
-	}
-
 	platform_set_drvdata(pdev, gpio_charger);
 
 	return 0;
 
-err_irq_free:
-	if (gpio_charger->irq)
-		free_irq(gpio_charger->irq, charger);
 err_gpio_free:
 	gpio_free(pdata->gpio);
 err_free:
@@ -150,10 +147,11 @@ static int __devexit gpio_charger_remove(struct platform_device *pdev)
 {
 	struct gpio_charger *gpio_charger = platform_get_drvdata(pdev);
 
-	power_supply_unregister(&gpio_charger->charger);
-
 	if (gpio_charger->irq)
 		free_irq(gpio_charger->irq, &gpio_charger->charger);
+
+	power_supply_unregister(&gpio_charger->charger);
+
 	gpio_free(gpio_charger->pdata->gpio);
 
 	platform_set_drvdata(pdev, NULL);
-- 
1.5.6.5

