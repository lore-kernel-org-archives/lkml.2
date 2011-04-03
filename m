Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab1DCCNj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 22:13:39 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54913 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab1DCCNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 22:13:38 -0400
From: Benson Leung <bleung@chromium.org>
To: lars@metafoo.de, cbouatmailru@gmail.com
Cc: rklein@nvidia.com, linux-kernel@vger.kernel.org,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH v2] gpio-charger: Add gpio_charger_resume
Date: Sat,  2 Apr 2011 19:13:12 -0700
Message-Id: <1301796792-28806-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.7.1
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
v2 : Changed to use dev_pm_ops
v1 : Initial
---
 drivers/power/gpio-charger.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index 25b88ac..df29059 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -161,12 +161,32 @@ static int __devexit gpio_charger_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#if defined(CONFIG_PM)
+static int gpio_charger_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct gpio_charger *gpio_charger = platform_get_drvdata(pdev);
+
+	power_supply_changed(&gpio_charger->charger);
+
+	return 0;
+}
+
+static const struct dev_pm_ops gpio_charger_pm_ops = {
+	.resume		= gpio_charger_resume,
+};
+#endif
+
+
 static struct platform_driver gpio_charger_driver = {
 	.probe = gpio_charger_probe,
 	.remove = __devexit_p(gpio_charger_remove),
 	.driver = {
 		.name = "gpio-charger",
 		.owner = THIS_MODULE,
+#if defined(CONFIG_PM)
+		.pm = &gpio_charger_pm_ops,
+#endif
 	},
 };
 
-- 
1.7.1

