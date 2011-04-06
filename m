Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab1DFXze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 19:55:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33880 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab1DFXzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 19:55:33 -0400
From: Benson Leung <bleung@chromium.org>
To: lars@metafoo.de, cbouatmailru@gmail.com
Cc: rklein@nvidia.com, linux-kernel@vger.kernel.org,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH v3] gpio-charger: Add gpio_charger_resume
Date: Wed,  6 Apr 2011 16:55:20 -0700
Message-Id: <1302134120-29589-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301796792-28806-1-git-send-email-bleung@chromium.org>
References: <1301796792-28806-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gpio charger should notify if the gpio state had changed
during suspend. This will send a CHANGED event each time
the system resumes, ensuring a plug/unplug of the charger
is not missed.

Signed-off-by: Benson Leung <bleung@chromium.org>

--
Version history :
v3 : Use SIMPLE_DEV_PM_OPS
v2 : Changed to use dev_ms_ops
v1 : Initial
---
 drivers/power/gpio-charger.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index 25b88ac..718f2c5 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -161,12 +161,27 @@ static int __devexit gpio_charger_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int gpio_charger_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct gpio_charger *gpio_charger = platform_get_drvdata(pdev);
+
+	power_supply_changed(&gpio_charger->charger);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(gpio_charger_pm_ops, NULL, gpio_charger_resume);
+
 static struct platform_driver gpio_charger_driver = {
 	.probe = gpio_charger_probe,
 	.remove = __devexit_p(gpio_charger_remove),
 	.driver = {
 		.name = "gpio-charger",
 		.owner = THIS_MODULE,
+		.pm = &gpio_charger_pm_ops,
 	},
 };
 
-- 
1.7.1

