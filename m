Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab2FKPao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:30:44 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34353 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab2FKPZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:25:23 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: [PATCH 02/14] rtc: Ensure correct probing of the AB8500 RTC when Device Tree is enabled
Date: Mon, 11 Jun 2012 16:24:55 +0100
Message-Id: <1339428307-3850-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch, if Device Tree is enabled the AB8500 RTC wouldn't
get probed at all, as there is no reference to it from platform code.
This patch ensures the driver is probed during normal DT start-up.

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/rtc/rtc-ab8500.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
index b11a2ec..116c23d 100644
--- a/drivers/rtc/rtc-ab8500.c
+++ b/drivers/rtc/rtc-ab8500.c
@@ -17,6 +17,7 @@
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/delay.h>
+#include <linux/of.h>
 
 #define AB8500_RTC_SOFF_STAT_REG	0x00
 #define AB8500_RTC_CC_CONF_REG		0x01
@@ -430,7 +431,6 @@ static int __devinit ab8500_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rtc);
 
-
 	err = ab8500_sysfs_rtc_register(&pdev->dev);
 	if (err) {
 		dev_err(&pdev->dev, "sysfs RTC failed to register\n");
@@ -454,10 +454,16 @@ static int __devexit ab8500_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id ab8500_rtc_match[] = {
+        { .compatible = "stericsson,ab8500-rtc", },
+        {}
+};
+
 static struct platform_driver ab8500_rtc_driver = {
 	.driver = {
 		.name = "ab8500-rtc",
 		.owner = THIS_MODULE,
+		.of_match_table = ab8500_rtc_match,
 	},
 	.probe	= ab8500_rtc_probe,
 	.remove = __devexit_p(ab8500_rtc_remove),
-- 
1.7.9.5

