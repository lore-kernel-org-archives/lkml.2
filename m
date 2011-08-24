Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1HXOfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 10:35:42 -0400
Received: from 64-198-47-7.ip.mcleodusa.net ([64.198.47.7]:51768 "EHLO
	mail02.indesign-llc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab1HXOfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 10:35:40 -0400
Message-ID: <4E550C35.4080700@indesign-llc.com>
Date: Wed, 24 Aug 2011 10:35:33 -0400
From: Clifton Barnes <cabarnes@indesign-llc.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: <akpm@linux-foundation.org>
CC: <ryan@bluewatersys.com>, <haojian.zhuang@marvell.com>,
        <johnpol@2ka.mipt.ru>, <simon.inizan@goobie.fr>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/3] w1: ds2780, fix deadlock upon insertion and removal
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the deadlock when inserting and removing the ds2780.

Signed-off-by: Clifton Barnes <cabarnes@indesign-llc.com>
---
 drivers/power/ds2780_battery.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/power/ds2780_battery.c b/drivers/power/ds2780_battery.c
index 2571b41..91a783d 100644
--- a/drivers/power/ds2780_battery.c
+++ b/drivers/power/ds2780_battery.c
@@ -39,6 +39,7 @@ struct ds2780_device_info {
 	struct device *dev;
 	struct power_supply bat;
 	struct device *w1_dev;
+	struct task_struct *mutex_holder;
 };
 
 enum current_types {
@@ -63,6 +64,9 @@ static inline struct power_supply *to_power_supply(struct device *dev)
 static inline int ds2780_battery_io(struct ds2780_device_info *dev_info,
 	char *buf, int addr, size_t count, int io)
 {
+	if (dev_info->mutex_holder == current)
+		return w1_ds2780_io_nolock(dev_info->w1_dev, buf, addr, count, io);
+	else
 		return w1_ds2780_io(dev_info->w1_dev, buf, addr, count, io);
 }
 
@@ -775,6 +779,7 @@ static int __devinit ds2780_battery_probe(struct platform_device *pdev)
 	dev_info->bat.properties	= ds2780_battery_props;
 	dev_info->bat.num_properties	= ARRAY_SIZE(ds2780_battery_props);
 	dev_info->bat.get_property	= ds2780_battery_get_property;
+	dev_info->mutex_holder		= current;
 
 	ret = power_supply_register(&pdev->dev, &dev_info->bat);
 	if (ret) {
@@ -804,6 +809,8 @@ static int __devinit ds2780_battery_probe(struct platform_device *pdev)
 		goto fail_remove_bin_file;
 	}
 
+	dev_info->mutex_holder = NULL;
+
 	return 0;
 
 fail_remove_bin_file:
@@ -823,6 +830,8 @@ static int __devexit ds2780_battery_remove(struct platform_device *pdev)
 {
 	struct ds2780_device_info *dev_info = platform_get_drvdata(pdev);
 
+	dev_info->mutex_holder = current;
+
 	/* remove attributes */
 	sysfs_remove_group(&dev_info->bat.dev->kobj, &ds2780_attr_group);
 
-- 
1.7.6

