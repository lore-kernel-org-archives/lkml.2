Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab1DBXSI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 19:18:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62374 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab1DBXSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 19:18:07 -0400
From: Benson Leung <bleung@chromium.org>
To: lars@metafoo.de, cbouatmailru@gmail.com
Cc: rklein@nvidia.com, linux-kernel@vger.kernel.org,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH] gpio-charger: Add gpio_charger_resume
Date: Sat,  2 Apr 2011 16:16:24 -0700
Message-Id: <1301786184-19603-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gpio charger should notify if the gpio state had changed
during suspend. This will send a CHANGED event each time
the system resumes, ensuring a plug/unplug of the charger
is not missed.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/power/gpio-charger.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index 25b88ac..e83c892 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -161,9 +161,26 @@ static int __devexit gpio_charger_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#if defined CONFIG_PM
+static int gpio_charger_resume(struct platform_device *pdev)
+{
+	struct gpio_charger *gpio_charger = platform_get_drvdata(pdev);
+
+	power_supply_changed(&gpio_charger->charger);
+
+	return 0;
+}
+#else
+#define gpio_charger_resume	NULL
+#endif
+#define gpio_charger_suspend	NULL
+
+
 static struct platform_driver gpio_charger_driver = {
 	.probe = gpio_charger_probe,
 	.remove = __devexit_p(gpio_charger_remove),
+	.suspend = gpio_charger_suspend,
+	.resume = gpio_charger_resume,
 	.driver = {
 		.name = "gpio-charger",
 		.owner = THIS_MODULE,
-- 
1.7.1

