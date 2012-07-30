Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2G3Kom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 06:44:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45467 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab2G3Kol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 06:44:41 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Renata Sayakhova <renata@oktetlabs.ru>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH 2/2] ds2781_battery: replace call to kzalloc with devm_kzalloc
Date: Mon, 30 Jul 2012 16:29:33 +0545
Message-Id: <1343645073-15024-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with devm_kzalloc there is no need of freeing at the errorpath
and also at unregister it.

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/power/ds2781_battery.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/power/ds2781_battery.c b/drivers/power/ds2781_battery.c
index 8f84ab7..1b5e4a1 100644
--- a/drivers/power/ds2781_battery.c
+++ b/drivers/power/ds2781_battery.c
@@ -755,11 +755,9 @@ static int __devinit ds2781_battery_probe(struct platform_device *pdev)
 	int ret = 0;
 	struct ds2781_device_info *dev_info;
 
-	dev_info = kzalloc(sizeof(*dev_info), GFP_KERNEL);
-	if (!dev_info) {
-		ret = -ENOMEM;
-		goto fail;
-	}
+	dev_info = devm_kzalloc(&pdev->dev, sizeof(*dev_info), GFP_KERNEL);
+	if (!dev_info)
+		return -ENOMEM;
 
 	platform_set_drvdata(pdev, dev_info);
 
@@ -774,7 +772,7 @@ static int __devinit ds2781_battery_probe(struct platform_device *pdev)
 	ret = power_supply_register(&pdev->dev, &dev_info->bat);
 	if (ret) {
 		dev_err(dev_info->dev, "failed to register battery\n");
-		goto fail_free_info;
+		goto fail;
 	}
 
 	ret = sysfs_create_group(&dev_info->bat.dev->kobj, &ds2781_attr_group);
@@ -808,8 +806,6 @@ fail_remove_group:
 	sysfs_remove_group(&dev_info->bat.dev->kobj, &ds2781_attr_group);
 fail_unregister:
 	power_supply_unregister(&dev_info->bat);
-fail_free_info:
-	kfree(dev_info);
 fail:
 	return ret;
 }
@@ -823,7 +819,6 @@ static int __devexit ds2781_battery_remove(struct platform_device *pdev)
 
 	power_supply_unregister(&dev_info->bat);
 
-	kfree(dev_info);
 	return 0;
 }
 
-- 
1.7.9.5

