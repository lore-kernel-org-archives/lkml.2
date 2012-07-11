Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab2GKJOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 05:14:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45440 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391Ab2GKJOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 05:14:08 -0400
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        Kevin Hilman <khilman@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 2/2] gpio/omap: add *remove* callback in platform_driver
Date: Wed, 11 Jul 2012 14:43:15 +0530
Message-ID: <1341997995-14020-3-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1341997995-14020-1-git-send-email-tarun.kanti@ti.com>
References: <1341997995-14020-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add *remove* callback so that necessary cleanup operations are
performed when device is unregistered. The device is deleted
from the list and associated clock handle is released by
calling clk_put() and irq descriptor is released using the
irq_free_desc() api.

Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Reported-by: Paul Walmsley <paul@pwsan.com>
Reviewed-by: Jon Hunter <jon-hunter@ti.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Cousson, Benoit <b-cousson@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
---
 drivers/gpio/gpio-omap.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index afecdcc..08929d5 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1140,6 +1140,35 @@ static int __devinit omap_gpio_probe(struct platform_device *pdev)
 	return ret;
 }
 
+/**
+ * omap_gpio_remove - cleanup a registered gpio device
+ * @pdev:       pointer to current gpio platform device
+ *
+ * Called by driver framework whenever a gpio device is unregistered.
+ * GPIO is deleted from the list and associated clock handle freed.
+ */
+static int __devexit omap_gpio_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct gpio_bank *bank;
+	unsigned long flags;
+	int ret = -EINVAL;
+
+	list_for_each_entry(bank, &omap_gpio_list, node) {
+		spin_lock_irqsave(&bank->lock, flags);
+		if (bank->dev == dev) {
+			list_del(&bank->node);
+			clk_put(bank->dbck);
+			irq_free_desc(bank->irq_base);
+			ret = 0;
+			spin_unlock_irqrestore(&bank->lock, flags);
+			break;
+		}
+		spin_unlock_irqrestore(&bank->lock, flags);
+	}
+	return ret;
+}
+
 #ifdef CONFIG_ARCH_OMAP2PLUS
 
 #if defined(CONFIG_PM_RUNTIME)
@@ -1466,6 +1495,7 @@ MODULE_DEVICE_TABLE(of, omap_gpio_match);
 
 static struct platform_driver omap_gpio_driver = {
 	.probe		= omap_gpio_probe,
+	.remove = __devexit_p(omap_gpio_remove),
 	.driver		= {
 		.name	= "omap_gpio",
 		.pm	= &gpio_pm_ops,
-- 
1.7.0.4

