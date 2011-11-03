Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab1KCJ0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 05:26:38 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:59201 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561Ab1KCJ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 05:26:37 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <rabin.vincent@stericsson.com>, <linux-kernel@vger.kernel.org>,
        <sameo@linux.intel.com>
Cc: <armando.visconti@st.com>, <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>,
        <srinidhi.kasagar@stericsson.com>, <linus.walleij@stericsson.com>
Subject: [PATCH] mfd/stmpe: Add support for irq over gpio pin
Date: Thu, 3 Nov 2011 14:56:07 +0530
Message-ID: <5366f62b74861af357a0aecdb4e27aa69ffd703b.1320312035.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On many boards, stmpe is present as an separate device (not as part of SoC).
Here gpio lines are mostly used for getting interrupts. This patch adds in
support to handle irq over gpio pin.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/mfd/stmpe.c       |   35 ++++++++++++++++++++++++++++-------
 include/linux/mfd/stmpe.h |    3 +++
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 2963689..239e46f 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -5,6 +5,7 @@
  * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
  */
 
+#include <linux/gpio.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
@@ -877,9 +878,10 @@ static int __devinit stmpe_devices_init(struct stmpe *stmpe)
 static int stmpe_suspend(struct device *dev)
 {
 	struct i2c_client *i2c = to_i2c_client(dev);
+	struct stmpe *stmpe = i2c_get_clientdata(i2c);
 
 	if (device_may_wakeup(&i2c->dev))
-		enable_irq_wake(i2c->irq);
+		enable_irq_wake(stmpe->irq);
 
 	return 0;
 }
@@ -887,9 +889,10 @@ static int stmpe_suspend(struct device *dev)
 static int stmpe_resume(struct device *dev)
 {
 	struct i2c_client *i2c = to_i2c_client(dev);
+	struct stmpe *stmpe = i2c_get_clientdata(i2c);
 
 	if (device_may_wakeup(&i2c->dev))
-		disable_irq_wake(i2c->irq);
+		disable_irq_wake(stmpe->irq);
 
 	return 0;
 }
@@ -925,15 +928,28 @@ static int __devinit stmpe_probe(struct i2c_client *i2c,
 
 	i2c_set_clientdata(i2c, stmpe);
 
+	if (pdata->irq_over_gpio) {
+		ret = gpio_request_one(pdata->irq_gpio, GPIOF_DIR_IN, "stmpe");
+		if (ret) {
+			dev_err(stmpe->dev, "failed to request IRQ GPIO: %d\n",
+					ret);
+			goto out_free;
+		}
+
+		stmpe->irq = gpio_to_irq(pdata->irq_gpio);
+	} else {
+		stmpe->irq = i2c->irq;
+	}
+
 	ret = stmpe_chip_init(stmpe);
 	if (ret)
-		goto out_free;
+		goto free_gpio;
 
 	ret = stmpe_irq_init(stmpe);
 	if (ret)
-		goto out_free;
+		goto free_gpio;
 
-	ret = request_threaded_irq(stmpe->i2c->irq, NULL, stmpe_irq,
+	ret = request_threaded_irq(stmpe->irq, NULL, stmpe_irq,
 				   pdata->irq_trigger | IRQF_ONESHOT,
 				   "stmpe", stmpe);
 	if (ret) {
@@ -951,9 +967,11 @@ static int __devinit stmpe_probe(struct i2c_client *i2c,
 
 out_removedevs:
 	mfd_remove_devices(stmpe->dev);
-	free_irq(stmpe->i2c->irq, stmpe);
+	free_irq(stmpe->irq, stmpe);
 out_removeirq:
 	stmpe_irq_remove(stmpe);
+free_gpio:
+	gpio_free(pdata->irq_gpio);
 out_free:
 	kfree(stmpe);
 	return ret;
@@ -965,9 +983,12 @@ static int __devexit stmpe_remove(struct i2c_client *client)
 
 	mfd_remove_devices(stmpe->dev);
 
-	free_irq(stmpe->i2c->irq, stmpe);
+	free_irq(stmpe->irq, stmpe);
 	stmpe_irq_remove(stmpe);
 
+	if (stmpe->pdata->irq_over_gpio)
+		gpio_free(stmpe->pdata->irq_gpio);
+
 	kfree(stmpe);
 
 	return 0;
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index be1af7c..7901351 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -76,6 +76,7 @@ struct stmpe {
 	struct stmpe_variant_info *variant;
 	const u8 *regs;
 
+	int irq;
 	int irq_base;
 	int num_gpios;
 	u8 ier[2];
@@ -194,6 +195,8 @@ struct stmpe_platform_data {
 	unsigned int irq_trigger;
 	bool irq_invert_polarity;
 	bool autosleep;
+	bool irq_over_gpio;
+	int irq_gpio;
 	int autosleep_timeout;
 
 	struct stmpe_gpio_platform_data *gpio;
-- 
1.7.2.2

