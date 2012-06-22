Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab2FVKjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 06:39:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56618 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753208Ab2FVKju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 06:39:50 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Allow multiple requests of a single supply mapping
Date: Fri, 22 Jun 2012 11:39:44 +0100
Message-Id: <1340361584-12314-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it may be useful to allow a device to request a supply multiple
times, for example in order to allow framework management of some uses of
the supply with some additional driver specific management or in order to
allow multiple children of an MFD to work with the supply. Currently this
is not possible due to the creation of

Solve this by removing the requested_uA entry (we have no current users
of this feature anyway) and ignoring errors creating the symlink to the
consumer. We should do something nicer than this as this causes sysfs to
spew enormous warnings but it allows users to run for now.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   49 +++++-----------------------------------------
 1 file changed, 5 insertions(+), 44 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index bda74fd..531441a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -303,18 +303,6 @@ static int regulator_check_drms(struct regulator_dev *rdev)
 	return 0;
 }
 
-static ssize_t device_requested_uA_show(struct device *dev,
-			     struct device_attribute *attr, char *buf)
-{
-	struct regulator *regulator;
-
-	regulator = get_device_regulator(dev);
-	if (regulator == NULL)
-		return 0;
-
-	return sprintf(buf, "%d\n", regulator->uA_load);
-}
-
 static ssize_t regulator_uV_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -1105,48 +1093,27 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 	list_add(&regulator->list, &rdev->consumer_list);
 
 	if (dev) {
-		/* create a 'requested_microamps_name' sysfs entry */
-		size = scnprintf(buf, REG_STR_SIZE,
-				 "microamps_requested_%s-%s",
-				 dev_name(dev), supply_name);
-		if (size >= REG_STR_SIZE)
-			goto overflow_err;
-
-		regulator->dev = dev;
-		sysfs_attr_init(&regulator->dev_attr.attr);
-		regulator->dev_attr.attr.name = kstrdup(buf, GFP_KERNEL);
-		if (regulator->dev_attr.attr.name == NULL)
-			goto attr_name_err;
-
-		regulator->dev_attr.attr.mode = 0444;
-		regulator->dev_attr.show = device_requested_uA_show;
-		err = device_create_file(dev, &regulator->dev_attr);
-		if (err < 0) {
-			rdev_warn(rdev, "could not add regulator_dev requested microamps sysfs entry\n");
-			goto attr_name_err;
-		}
-
-		/* also add a link to the device sysfs entry */
+		/* Add a link to the device sysfs entry */
 		size = scnprintf(buf, REG_STR_SIZE, "%s-%s",
 				 dev->kobj.name, supply_name);
 		if (size >= REG_STR_SIZE)
-			goto attr_err;
+			goto overflow_err;
 
 		regulator->supply_name = kstrdup(buf, GFP_KERNEL);
 		if (regulator->supply_name == NULL)
-			goto attr_err;
+			goto overflow_err;
 
 		err = sysfs_create_link(&rdev->dev.kobj, &dev->kobj,
 					buf);
 		if (err) {
 			rdev_warn(rdev, "could not add device link %s err %d\n",
 				  dev->kobj.name, err);
-			goto link_name_err;
+			/* non-fatal */
 		}
 	} else {
 		regulator->supply_name = kstrdup(supply_name, GFP_KERNEL);
 		if (regulator->supply_name == NULL)
-			goto attr_err;
+			goto overflow_err;
 	}
 
 	regulator->debugfs = debugfs_create_dir(regulator->supply_name,
@@ -1173,12 +1140,6 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 
 	mutex_unlock(&rdev->mutex);
 	return regulator;
-link_name_err:
-	kfree(regulator->supply_name);
-attr_err:
-	device_remove_file(regulator->dev, &regulator->dev_attr);
-attr_name_err:
-	kfree(regulator->dev_attr.attr.name);
 overflow_err:
 	list_del(&regulator->list);
 	kfree(regulator);
-- 
1.7.10

