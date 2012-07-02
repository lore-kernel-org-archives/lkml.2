Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab2GBJUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 05:20:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35743 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab2GBJUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 05:20:03 -0400
Message-ID: <1341220792.10295.1.camel@phoenix>
Subject: [PATCH] mfd: tc3589x: Guard PM methods with CONFIG_PM_SLEEP
From: Axel Lin <axel.lin@gmail.com>
To: SamuelOrtiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Sundar Iyer <sundar.iyer@stericsson.com>, linux-kernel@vger.kernel.org
Date: Mon, 02 Jul 2012 17:19:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guard PM methods with CONFIG_PM_SLEEP and get rid of some unneeded #ifdefs.
This fixes below build warnings:

  CC      drivers/mfd/tc3589x.o
drivers/mfd/tc3589x.c:361:12: warning: 'tc3589x_suspend' defined but not used [-Wunused-function]
drivers/mfd/tc3589x.c:375:12: warning: 'tc3589x_resume' defined but not used [-Wunused-function]

SIMPLE_DEV_PM_OPS already defines constant dev_pm_ops, thus also fix
'duplicate const' sparse warning.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/tc3589x.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index de97974..048bf05 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -357,7 +357,7 @@ static int __devexit tc3589x_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int tc3589x_suspend(struct device *dev)
 {
 	struct tc3589x *tc3589x = dev_get_drvdata(dev);
@@ -385,11 +385,10 @@ static int tc3589x_resume(struct device *dev)
 
 	return ret;
 }
-
-static const SIMPLE_DEV_PM_OPS(tc3589x_dev_pm_ops, tc3589x_suspend,
-						tc3589x_resume);
 #endif
 
+static SIMPLE_DEV_PM_OPS(tc3589x_dev_pm_ops, tc3589x_suspend, tc3589x_resume);
+
 static const struct i2c_device_id tc3589x_id[] = {
 	{ "tc3589x", 24 },
 	{ }
@@ -399,9 +398,7 @@ MODULE_DEVICE_TABLE(i2c, tc3589x_id);
 static struct i2c_driver tc3589x_driver = {
 	.driver.name	= "tc3589x",
 	.driver.owner	= THIS_MODULE,
-#ifdef CONFIG_PM
 	.driver.pm	= &tc3589x_dev_pm_ops,
-#endif
 	.probe		= tc3589x_probe,
 	.remove		= __devexit_p(tc3589x_remove),
 	.id_table	= tc3589x_id,
-- 
1.7.9.5



