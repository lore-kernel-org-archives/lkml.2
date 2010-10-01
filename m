Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab0JAQEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 12:04:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:17452 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab0JAQEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 12:04:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,267,1283756400"; 
   d="scan'208";a="663104624"
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/2] pca953x: pca953x driver update for x86 mrst
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Date: Fri, 01 Oct 2010 16:15:26 +0100
Message-ID: <20101001151523.6563.51230.stgit@localhost.localdomain>
In-Reply-To: <20101001151453.6563.84259.stgit@localhost.localdomain>
References: <20101001151453.6563.84259.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alek Du <alek.du@intel.com>

Our Moorestown platform has two max7315 chips which is covered by
pca953x i2c gpio driver.

Recently this driver got updated with nested irq thread support, and it
broke the compatibity of "request_irq". For example, the gpio_keys.c
driver can not work with this driver now. This patch fix the issue, and
also fix the irq_base issue: irq_base == 0 is valid, and a "-1" value
should present invalid.

Signed-off-by: Alek Du <alek.du@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/gpio/pca953x.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)


diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index 20bcc96..4b19727 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -354,7 +354,7 @@ static irqreturn_t pca953x_irq_handler(int irq, void *devid)
 
 	do {
 		level = __ffs(pending);
-		handle_nested_irq(level + chip->irq_base);
+		generic_handle_irq(level + chip->irq_base);
 
 		pending &= ~(1 << level);
 	} while (pending);
@@ -369,7 +369,8 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 	struct pca953x_platform_data *pdata = client->dev.platform_data;
 	int ret;
 
-	if (pdata->irq_base && (id->driver_data & PCA953X_INT)) {
+	if (pdata->irq_base != -1
+			&& (id->driver_data & PCA953X_INT)) {
 		int lvl;
 
 		ret = pca953x_read_reg(chip, PCA953X_INPUT,
@@ -392,7 +393,6 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 			set_irq_chip_data(irq, chip);
 			set_irq_chip_and_handler(irq, &pca953x_irq_chip,
 						 handle_edge_irq);
-			set_irq_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 			set_irq_flags(irq, IRQF_VALID);
 #else
@@ -403,6 +403,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 		ret = request_threaded_irq(client->irq,
 					   NULL,
 					   pca953x_irq_handler,
+					   IRQF_TRIGGER_RISING |
 					   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 					   dev_name(&client->dev), chip);
 		if (ret) {
@@ -417,13 +418,13 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 	return 0;
 
 out_failed:
-	chip->irq_base = 0;
+	chip->irq_base = -1;
 	return ret;
 }
 
 static void pca953x_irq_teardown(struct pca953x_chip *chip)
 {
-	if (chip->irq_base)
+	if (chip->irq_base != -1)
 		free_irq(chip->client->irq, chip);
 }
 #else /* CONFIG_GPIO_PCA953X_IRQ */
@@ -433,7 +434,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 	struct i2c_client *client = chip->client;
 	struct pca953x_platform_data *pdata = client->dev.platform_data;
 
-	if (pdata->irq_base && (id->driver_data & PCA953X_INT))
+	if (pdata->irq_base != -1 && (id->driver_data & PCA953X_INT))
 		dev_warn(&client->dev, "interrupt support not compiled in\n");
 
 	return 0;

