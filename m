Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab2ADHHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 02:07:41 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:34972 "HELO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752026Ab2ADHHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 02:07:37 -0500
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, a.zummo@towertech.it, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Kevin Liu <kliu5@marvell.com>, Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: [PATCH 1/3] mfd: max8925: add function to work as wakeup source
Date: Wed,  4 Jan 2012 15:14:24 +0800
Message-Id: <1325661266-7982-1-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 04 Jan 2012 07:07:13.0428 (UTC) FILETIME=[7BEF7540:01CCCAAF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Liu <kliu5@marvell.com>

Signed-off-by: Kevin Liu <kliu5@marvell.com>
Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/mfd/max8925-i2c.c   |   27 +++++++++++++++++++++++++++
 include/linux/mfd/max8925.h |    2 ++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/max8925-i2c.c b/drivers/mfd/max8925-i2c.c
index 0219115..d9e4b36 100644
--- a/drivers/mfd/max8925-i2c.c
+++ b/drivers/mfd/max8925-i2c.c
@@ -161,6 +161,8 @@ static int __devinit max8925_probe(struct i2c_client *client,
 	chip->adc = i2c_new_dummy(chip->i2c->adapter, ADC_I2C_ADDR);
 	i2c_set_clientdata(chip->adc, chip);
 
+	device_init_wakeup(&client->dev, 1);
+
 	max8925_device_init(chip, pdata);
 
 	return 0;
@@ -177,10 +179,35 @@ static int __devexit max8925_remove(struct i2c_client *client)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int max8925_suspend(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct max8925_chip *chip = i2c_get_clientdata(client);
+
+	if (device_may_wakeup(dev) && chip->wakeup_flag)
+		enable_irq_wake(chip->core_irq);
+	return 0;
+}
+
+static int max8925_resume(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct max8925_chip *chip = i2c_get_clientdata(client);
+
+	if (device_may_wakeup(dev) && chip->wakeup_flag)
+		disable_irq_wake(chip->core_irq);
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(max8925_pm_ops, max8925_suspend, max8925_resume);
+
 static struct i2c_driver max8925_driver = {
 	.driver	= {
 		.name	= "max8925",
 		.owner	= THIS_MODULE,
+		.pm     = &max8925_pm_ops,
 	},
 	.probe		= max8925_probe,
 	.remove		= __devexit_p(max8925_remove),
diff --git a/include/linux/mfd/max8925.h b/include/linux/mfd/max8925.h
index 5259dfe..daaba00 100644
--- a/include/linux/mfd/max8925.h
+++ b/include/linux/mfd/max8925.h
@@ -206,6 +206,8 @@ struct max8925_chip {
 	int			irq_base;
 	int			core_irq;
 	int			tsc_irq;
+
+	unsigned int            wakeup_flag;
 };
 
 struct max8925_backlight_pdata {
-- 
1.7.0.4

