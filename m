Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab1KHEOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 23:14:24 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:42503 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764Ab1KHEOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 23:14:23 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <rabin.vincent@stericsson.com>, <linus.walleij@stericsson.com>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>
Cc: <armando.visconti@st.com>, <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>,
        <srinidhi.kasagar@stericsson.com>
Subject: [PATCH V2] mfd/stmpe: Add support for irq over gpio pin
Date: Tue, 8 Nov 2011 09:44:06 +0530
Message-ID: <3f04cea36ee4180f65da8f766c06d5fd0b0e61d8.1320725434.git.viresh.kumar@st.com>
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

Changes since V1:
- Kernel Doc style comments updated in header file
- gpio freed after checking if irq_over_gpio is requested, in failure case of
  probe

 drivers/mfd/stmpe.c       |   36 +++++++++++++++++++++++++++++-------
 include/linux/mfd/stmpe.h |    7 +++++++
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 2963689..39efa62 100644
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
@@ -951,9 +967,12 @@ static int __devinit stmpe_probe(struct i2c_client *i2c,
 
 out_removedevs:
 	mfd_remove_devices(stmpe->dev);
-	free_irq(stmpe->i2c->irq, stmpe);
+	free_irq(stmpe->irq, stmpe);
 out_removeirq:
 	stmpe_irq_remove(stmpe);
+free_gpio:
+	if (pdata->irq_over_gpio)
+		gpio_free(pdata->irq_gpio);
 out_free:
 	kfree(stmpe);
 	return ret;
@@ -965,9 +984,12 @@ static int __devexit stmpe_remove(struct i2c_client *client)
 
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
index be1af7c..270d661 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -61,6 +61,7 @@ struct stmpe_variant_info;
  * @variant: the detected STMPE model number
  * @regs: list of addresses of registers which are at different addresses on
  *	  different variants.  Indexed by one of STMPE_IDX_*.
+ * @irq: irq number for stmpe
  * @irq_base: starting IRQ number for internal IRQs
  * @num_gpios: number of gpios, differs for variants
  * @ier: cache of IER registers for bus_lock
@@ -76,6 +77,7 @@ struct stmpe {
 	struct stmpe_variant_info *variant;
 	const u8 *regs;
 
+	int irq;
 	int irq_base;
 	int num_gpios;
 	u8 ier[2];
@@ -183,6 +185,9 @@ struct stmpe_ts_platform_data {
  * @autosleep_timeout: inactivity timeout in milliseconds for autosleep
  * @irq_base: base IRQ number.  %STMPE_NR_IRQS irqs will be used, or
  *	      %STMPE_NR_INTERNAL_IRQS if the GPIO driver is not used.
+ * @irq_over_gpio: true if gpio is used to get irq
+ * @irq_gpio: gpio number over which irq will be requested (significant only if
+ *	      irq_over_gpio is true)
  * @gpio: GPIO-specific platform data
  * @keypad: keypad-specific platform data
  * @ts: touchscreen-specific platform data
@@ -194,6 +199,8 @@ struct stmpe_platform_data {
 	unsigned int irq_trigger;
 	bool irq_invert_polarity;
 	bool autosleep;
+	bool irq_over_gpio;
+	int irq_gpio;
 	int autosleep_timeout;
 
 	struct stmpe_gpio_platform_data *gpio;
-- 
1.7.2.2

