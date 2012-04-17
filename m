Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab2DQHak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 03:30:40 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:39933 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137Ab2DQHah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 03:30:37 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/6] mfd/ab8500: handle the irq for suspend/resume
Date: Tue, 17 Apr 2012 09:30:24 +0200
Message-ID: <1334647824-1663-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Ensure that the AB interrupt is only handled at a time when
all core drivers are resumed. Ensure that the AB interrupt
is marked as a wakeup interrupt.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Reviewed-by: Jonas Aberg <jonas.aberg@stericsson.com>
Reviewed-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-i2c.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/mfd/ab8500-i2c.c b/drivers/mfd/ab8500-i2c.c
index b83045f..89b31a3 100644
--- a/drivers/mfd/ab8500-i2c.c
+++ b/drivers/mfd/ab8500-i2c.c
@@ -101,10 +101,42 @@ static const struct platform_device_id ab8500_id[] = {
 	{ }
 };
 
+#ifdef CONFIG_PM
+static int ab8500_i2c_suspend(struct device *dev)
+{
+	struct ab8500 *ab = dev_get_drvdata(dev);
+
+	disable_irq(ab->irq);
+	enable_irq_wake(ab->irq);
+
+	return 0;
+}
+
+static int ab8500_i2c_resume(struct device *dev)
+{
+	struct ab8500 *ab = dev_get_drvdata(dev);
+
+	disable_irq_wake(ab->irq);
+	enable_irq(ab->irq);
+
+	return 0;
+}
+
+static const struct dev_pm_ops ab8500_i2c_pm_ops = {
+	.suspend	= ab8500_i2c_suspend,
+	.resume		= ab8500_i2c_resume,
+};
+
+#define AB8500_I2C_PM_OPS	(&ab8500_i2c_pm_ops)
+#else
+#define AB8500_I2C_PM_OPS	NULL
+#endif
+
 static struct platform_driver ab8500_i2c_driver = {
 	.driver = {
 		.name = "ab8500-i2c",
 		.owner = THIS_MODULE,
+		.pm	= AB8500_I2C_PM_OPS,
 	},
 	.probe	= ab8500_i2c_probe,
 	.remove	= __devexit_p(ab8500_i2c_remove),
-- 
1.7.9.2

