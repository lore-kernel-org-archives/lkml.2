Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab2IYQNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:13:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598Ab2IYQNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:33 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 18/57] power: Add sysfs interfaces for capacity
Date: Tue, 25 Sep 2012 10:12:15 -0600
Message-Id: <1348589574-25655-19-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel WILLERUD <daniel.willerud@stericsson.com>

Switchable depending on whether capacity scaling is enabled

Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Daniel WILLERUD <daniel.willerud@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_fg.c |   57 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 8507254..46010ec 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -266,7 +266,6 @@ static enum power_supply_property ab8500_fg_props[] = {
 	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
 	POWER_SUPPLY_PROP_CHARGE_FULL,
 	POWER_SUPPLY_PROP_CHARGE_NOW,
-	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
 };
 
@@ -2543,6 +2542,54 @@ static int ab8500_fg_sysfs_init(struct ab8500_fg *di)
 
 	return ret;
 }
+
+static ssize_t ab8500_show_capacity(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct ab8500_fg *di;
+	int capacity;
+
+	di = to_ab8500_fg_device_info(psy);
+
+	if (di->bat->capacity_scaling)
+		capacity = di->bat_cap.cap_scale.scaled_cap;
+	else
+		capacity = DIV_ROUND_CLOSEST(di->bat_cap.permille, 10);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", capacity);
+}
+
+static struct device_attribute ab8500_fg_sysfs_psy_attrs[] = {
+	__ATTR(capacity, S_IRUGO, ab8500_show_capacity, NULL),
+};
+
+static int ab8500_fg_sysfs_psy_create_attrs(struct device *dev)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(ab8500_fg_sysfs_psy_attrs); i++)
+		if (device_create_file(dev, &ab8500_fg_sysfs_psy_attrs[i]))
+			goto sysfs_psy_create_attrs_failed;
+
+	return 0;
+
+sysfs_psy_create_attrs_failed:
+	dev_err(dev, "Failed creating sysfs psy attrs.\n");
+	while (i--)
+		device_remove_file(dev, &ab8500_fg_sysfs_psy_attrs[i]);
+
+	return -EIO;
+}
+
+static void ab8500_fg_sysfs_psy_remove_attrs(struct device *dev)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(ab8500_fg_sysfs_psy_attrs); i++)
+		(void)device_remove_file(dev, &ab8500_fg_sysfs_psy_attrs[i]);
+}
 /* Exposure to the sysfs interface <<END>> */
 
 #if defined(CONFIG_PM)
@@ -2599,6 +2646,7 @@ static int __devexit ab8500_fg_remove(struct platform_device *pdev)
 	ab8500_fg_sysfs_exit(di);
 
 	flush_scheduled_work();
+	ab8500_fg_sysfs_psy_remove_attrs(di->fg_psy.dev);
 	power_supply_unregister(&di->fg_psy);
 	platform_set_drvdata(pdev, NULL);
 	kfree(di);
@@ -2754,6 +2802,13 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 		goto free_irq;
 	}
 
+	ret = ab8500_fg_sysfs_psy_create_attrs(di->fg_psy.dev);
+	if (ret) {
+		dev_err(di->dev, "failed to create FG psy\n");
+		ab8500_fg_sysfs_exit(di);
+		goto free_irq;
+	}
+
 	/* Calibrate the fg first time */
 	di->flags.calibrate = true;
 	di->calib_state = AB8500_FG_CALIB_INIT;
-- 
1.7.5.4

