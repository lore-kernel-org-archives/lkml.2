Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab2AYJxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 04:53:30 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:42383 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754925Ab2AYJx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 04:53:28 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Viresh Kumar <viresh.kumar@st.com>,
        Chris Blair <chris.blair@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2] gpio/stmpe: support no-irq mode
Date: Wed, 25 Jan 2012 10:53:09 +0100
Message-ID: <1327485189-15522-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Blair <chris.blair@stericsson.com>

Adds support for boards which have an STMPE GPIO device without the
interrupt pin connected. This means that no interrupt can be received
but the GPIO pins can still be driven and read.

Cc: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Viresh Kumar <viresh.kumar@st.com>
Tested-by: Michel Jaouen <michel.jaouen@stericsson.com>
Signed-off-by: Chris Blair <chris.blair@stericsson.com>
---
This depends on the previous patch to the MFD code so should
better be merged into the MFD tree with the previous patch.
---
 drivers/gpio/gpio-stmpe.c |   40 ++++++++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
index 87a68a8..c747929 100644
--- a/drivers/gpio/gpio-stmpe.c
+++ b/drivers/gpio/gpio-stmpe.c
@@ -307,13 +307,15 @@ static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
 	struct stmpe_gpio_platform_data *pdata;
 	struct stmpe_gpio *stmpe_gpio;
 	int ret;
-	int irq;
+	int irq = 0;
 
 	pdata = stmpe->pdata->gpio;
 
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
+	if (!stmpe->pdata->no_irq) {
+		irq = platform_get_irq(pdev, 0);
+		if (irq < 0)
+			return irq;
+	}
 
 	stmpe_gpio = kzalloc(sizeof(struct stmpe_gpio), GFP_KERNEL);
 	if (!stmpe_gpio)
@@ -336,15 +338,17 @@ static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_free;
 
-	ret = stmpe_gpio_irq_init(stmpe_gpio);
-	if (ret)
-		goto out_disable;
+	if (!stmpe->pdata->no_irq) {
+		ret = stmpe_gpio_irq_init(stmpe_gpio);
+		if (ret)
+			goto out_disable;
 
-	ret = request_threaded_irq(irq, NULL, stmpe_gpio_irq, IRQF_ONESHOT,
-				   "stmpe-gpio", stmpe_gpio);
-	if (ret) {
-		dev_err(&pdev->dev, "unable to get irq: %d\n", ret);
-		goto out_removeirq;
+		ret = request_threaded_irq(irq, NULL, stmpe_gpio_irq,
+				IRQF_ONESHOT, "stmpe-gpio", stmpe_gpio);
+		if (ret) {
+			dev_err(&pdev->dev, "unable to get irq: %d\n", ret);
+			goto out_removeirq;
+		}
 	}
 
 	ret = gpiochip_add(&stmpe_gpio->chip);
@@ -361,9 +365,11 @@ static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
 	return 0;
 
 out_freeirq:
-	free_irq(irq, stmpe_gpio);
+	if (!stmpe->pdata->no_irq)
+		free_irq(irq, stmpe_gpio);
 out_removeirq:
-	stmpe_gpio_irq_remove(stmpe_gpio);
+	if (!stmpe->pdata->no_irq)
+		stmpe_gpio_irq_remove(stmpe_gpio);
 out_disable:
 	stmpe_disable(stmpe, STMPE_BLOCK_GPIO);
 out_free:
@@ -391,8 +397,10 @@ static int __devexit stmpe_gpio_remove(struct platform_device *pdev)
 
 	stmpe_disable(stmpe, STMPE_BLOCK_GPIO);
 
-	free_irq(irq, stmpe_gpio);
-	stmpe_gpio_irq_remove(stmpe_gpio);
+	if (!stmpe->pdata->no_irq) {
+		free_irq(irq, stmpe_gpio);
+		stmpe_gpio_irq_remove(stmpe_gpio);
+	}
 	platform_set_drvdata(pdev, NULL);
 	kfree(stmpe_gpio);
 
-- 
1.7.8

