Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab0LCPhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:37:25 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:42731 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289Ab0LCPhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:37:13 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <dmitry.torokhov@gmail.com>,
        <sameo@linux.intel.com>, <ben-linux@fluff.org>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sundar Iyer <sundar.iyer@stericsson.com>
Subject: [PATCH 13/20] mfd/tc3589x: add suspend/resume support
Date: Fri, 3 Dec 2010 20:35:46 +0530
Message-ID: <1291388753-14662-14-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 drivers/mfd/tc3589x.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index fd206fd..a7dd2b6 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -14,6 +14,9 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/tc3589x.h>
 
+#define TC3589x_CLKMODE_MODCTL_SLEEP		0x0
+#define TC3589x_CLKMODE_MODCTL_OPERATION	(1 << 0)
+
 /**
  * tc3589x_reg_read() - read a single TC3589x register
  * @tc3589x:	Device to read from
@@ -365,6 +368,42 @@ static int __devexit tc3589x_remove(struct i2c_client *client)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int tc3589x_suspend(struct device *dev)
+{
+	struct tc3589x *tc35892 = dev_get_drvdata(dev);
+	struct i2c_client *client = tc3589x->i2c;
+	int ret = 0;
+
+	/* put the system to sleep mode */
+	if (!device_may_wakeup(&client->dev))
+		ret = tc3589x_reg_write(tc3589x, TC3589x_CLKMODE,
+				TC3589x_CLKMODE_MODCTL_SLEEP);
+
+	return ret;
+}
+
+static int tc3589x_resume(struct device *dev)
+{
+	struct tc3589x *tc3589x = dev_get_drvdata(dev);
+	struct i2c_client *client = tc3589x->i2c;
+	int ret = 0;
+
+	/* enable the system into operation */
+	if (!device_may_wakeup(&client->dev))
+		ret = tc3589x_reg_write(tc3589x, TC3589x_CLKMODE,
+				TC3589x_CLKMODE_MODCTL_OPERATION);
+
+	return ret;
+}
+
+
+static const struct dev_pm_ops tc3589x_dev_pm_ops = {
+	.suspend = tc3589x_suspend,
+	.resume  = tc3589x_resume,
+};
+#endif
+
 static const struct i2c_device_id tc3589x_id[] = {
 	{ "tc3589x", 24 },
 	{ }
@@ -374,6 +413,9 @@ MODULE_DEVICE_TABLE(i2c, tc3589x_id);
 static struct i2c_driver tc3589x_driver = {
 	.driver.name	= "tc3589x",
 	.driver.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+	.driver.pm	= &tc3589x_dev_pm_ops,
+#endif
 	.probe		= tc3589x_probe,
 	.remove		= __devexit_p(tc3589x_remove),
 	.id_table	= tc3589x_id,
-- 
1.7.2.dirty

