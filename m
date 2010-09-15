Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab0IOFB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 01:01:27 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:40895 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500Ab0IOFBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 01:01:25 -0400
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>, Sundar Iyer <sundar.iyer@stericsson.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: [PATCH] mfd-stmpe: Add PM support to STMPE devices
Date: Wed, 15 Sep 2010 10:30:54 +0530
Message-ID: <1284526854-32298-1-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PM helpers to STMPE and add support to enable wakeup from low power
states

Acked-by: Rabin VINCENT <rabin.vincent@stericsson.com>
Acked-by: Linus WALLEIJ <linus.walleij@stericsson.com>
Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 drivers/mfd/stmpe.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 0754c5e9..b11487f 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -873,6 +873,28 @@ static int __devinit stmpe_devices_init(struct stmpe *stmpe)
 	return ret;
 }
 
+#ifdef CONFIG_PM
+static int stmpe_suspend(struct device *dev)
+{
+	struct i2c_client *i2c = to_i2c_client(dev);
+
+	if (device_may_wakeup(&i2c->dev))
+		enable_irq_wake(i2c->irq);
+
+	return 0;
+}
+
+static int stmpe_resume(struct device *dev)
+{
+	struct i2c_client *i2c = to_i2c_client(dev);
+
+	if (device_may_wakeup(&i2c->dev))
+		disable_irq_wake(i2c->irq);
+
+	return 0;
+}
+#endif
+
 static int __devinit stmpe_probe(struct i2c_client *i2c,
 				 const struct i2c_device_id *id)
 {
@@ -960,9 +982,19 @@ static const struct i2c_device_id stmpe_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, stmpe_id);
 
+#ifdef CONFIG_PM
+static const struct dev_pm_ops stmpe_dev_pm_ops = {
+	.suspend	= stmpe_suspend,
+	.resume		= stmpe_resume,
+};
+#endif
+
 static struct i2c_driver stmpe_driver = {
 	.driver.name	= "stmpe",
 	.driver.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+	.driver.pm	= &stmpe_dev_pm_ops,
+#endif
 	.probe		= stmpe_probe,
 	.remove		= __devexit_p(stmpe_remove),
 	.id_table	= stmpe_id,
-- 
1.7.2.dirty

