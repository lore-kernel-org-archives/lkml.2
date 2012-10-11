Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab2JKL4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 07:56:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60779 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758606Ab2JKLzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 07:55:43 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <peter.ujfalusi@ti.com>
Subject: [PATCH 4/6] MFD: twl6040: Correct Ready and Thermal interrupt handling
Date: Thu, 11 Oct 2012 13:55:31 +0200
Message-ID: <1349956533-6374-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1349956533-6374-1-git-send-email-peter.ujfalusi@ti.com>
References: <1349956533-6374-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create new irq handler for thermal events in order to be able to handle the
event and clean up the code regarding to interrupt handling:
Use proper function names for the irq handlers
No need to read the INTD register anymore.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c | 52 +++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 6d9db27..5817bc6 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -193,27 +193,27 @@ static void twl6040_power_down_manual(struct twl6040 *twl6040)
 	twl6040_reg_write(twl6040, TWL6040_REG_LDOCTL, ldoctl);
 }
 
-static irqreturn_t twl6040_naudint_handler(int irq, void *data)
+static irqreturn_t twl6040_readyint_handler(int irq, void *data)
 {
 	struct twl6040 *twl6040 = data;
-	u8 intid, status;
 
-	intid = twl6040_reg_read(twl6040, TWL6040_REG_INTID);
+	complete(&twl6040->ready);
 
-	if (intid & TWL6040_READYINT)
-		complete(&twl6040->ready);
+	return IRQ_HANDLED;
+}
 
-	if (intid & TWL6040_THINT) {
-		status = twl6040_reg_read(twl6040, TWL6040_REG_STATUS);
-		if (status & TWL6040_TSHUTDET) {
-			dev_warn(twl6040->dev,
-				 "Thermal shutdown, powering-off");
-			twl6040_power(twl6040, 0);
-		} else {
-			dev_warn(twl6040->dev,
-				 "Leaving thermal shutdown, powering-on");
-			twl6040_power(twl6040, 1);
-		}
+static irqreturn_t twl6040_thint_handler(int irq, void *data)
+{
+	struct twl6040 *twl6040 = data;
+	u8 status;
+
+	status = twl6040_reg_read(twl6040, TWL6040_REG_STATUS);
+	if (status & TWL6040_TSHUTDET) {
+		dev_warn(twl6040->dev, "Thermal shutdown, powering-off");
+		twl6040_power(twl6040, 0);
+	} else {
+		dev_warn(twl6040->dev, "Leaving thermal shutdown, powering-on");
+		twl6040_power(twl6040, 1);
 	}
 
 	return IRQ_HANDLED;
@@ -580,12 +580,19 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 		goto irq_init_err;
 
 	ret = request_threaded_irq(twl6040->irq_base + TWL6040_IRQ_READY,
-				   NULL, twl6040_naudint_handler, IRQF_ONESHOT,
+				   NULL, twl6040_readyint_handler, IRQF_ONESHOT,
 				   "twl6040_irq_ready", twl6040);
 	if (ret) {
-		dev_err(twl6040->dev, "READY IRQ request failed: %d\n",
-			ret);
-		goto irq_err;
+		dev_err(twl6040->dev, "READY IRQ request failed: %d\n", ret);
+		goto readyirq_err;
+	}
+
+	ret = request_threaded_irq(twl6040->irq_base + TWL6040_IRQ_TH,
+				   NULL, twl6040_thint_handler, IRQF_ONESHOT,
+				   "twl6040_irq_th", twl6040);
+	if (ret) {
+		dev_err(twl6040->dev, "Thermal IRQ request failed: %d\n", ret);
+		goto thirq_err;
 	}
 
 	/* dual-access registers controlled by I2C only */
@@ -650,8 +657,10 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 	return 0;
 
 mfd_err:
+	free_irq(twl6040->irq_base + TWL6040_IRQ_TH, twl6040);
+thirq_err:
 	free_irq(twl6040->irq_base + TWL6040_IRQ_READY, twl6040);
-irq_err:
+readyirq_err:
 	twl6040_irq_exit(twl6040);
 irq_init_err:
 	if (gpio_is_valid(twl6040->audpwron))
@@ -677,6 +686,7 @@ static int __devexit twl6040_remove(struct i2c_client *client)
 		gpio_free(twl6040->audpwron);
 
 	free_irq(twl6040->irq_base + TWL6040_IRQ_READY, twl6040);
+	free_irq(twl6040->irq_base + TWL6040_IRQ_TH, twl6040);
 	twl6040_irq_exit(twl6040);
 
 	mfd_remove_devices(&client->dev);
-- 
1.7.12

