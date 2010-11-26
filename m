Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab0KZMFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 07:05:41 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:52637 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060Ab0KZMFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 07:05:40 -0500
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Ludovic Barre <ludovic.barre@stericsson.com>
Subject: [PATCH] MFD: ab8500 chip id exported to sysfs
Date: Fri, 26 Nov 2010 13:05:25 +0100
Message-ID: <1290773125-9031-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a file into sysfs for reading out chip id.
It have been requested for modem silent reboot.

Change-Id: I8e2c10e740a90ab210e023df4214b422c01f2efb
Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Ludovic Barre <ludovic.barre@stericsson.com>
---
 drivers/mfd/ab8500-core.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index e64569e..c59e832 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -98,7 +98,7 @@ static int ab8500_get_chip_id(struct device *dev)
 	if (!dev)
 		return -EINVAL;
 	ab8500 = dev_get_drvdata(dev->parent);
-	return (int)ab8500->chip_id;
+	return ab8500 ? (int)ab8500->chip_id : -EINVAL;
 }
 
 static int set_register_interruptible(struct ab8500 *ab8500, u8 bank,
@@ -654,6 +654,26 @@ static struct mfd_cell ab8500_devs[] = {
 	},
 };
 
+static ssize_t show_chip_id(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ab8500 *ab8500;
+
+	ab8500 = dev_get_drvdata(dev);
+	return sprintf(buf, "%#x\n", ab8500 ? ab8500->chip_id : -EINVAL);
+}
+
+static DEVICE_ATTR(chip_id, S_IRUGO, show_chip_id, NULL);
+
+static struct attribute *ab8500_sysfs_entries[] = {
+	&dev_attr_chip_id.attr,
+	NULL,
+};
+
+static struct attribute_group ab8500_attr_group = {
+	.attrs	= ab8500_sysfs_entries,
+};
+
 int __devinit ab8500_init(struct ab8500 *ab8500)
 {
 	struct ab8500_platform_data *plat = dev_get_platdata(ab8500->dev);
@@ -734,6 +754,10 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 	if (ret)
 		goto out_freeirq;
 
+	ret = sysfs_create_group(&ab8500->dev->kobj, &ab8500_attr_group);
+	if (ret)
+		dev_err(ab8500->dev, "error creating sysfs entries\n");
+
 	return ret;
 
 out_freeirq:
@@ -747,6 +771,7 @@ out_removeirq:
 
 int __devexit ab8500_exit(struct ab8500 *ab8500)
 {
+	sysfs_remove_group(&ab8500->dev->kobj, &ab8500_attr_group);
 	mfd_remove_devices(ab8500->dev);
 	if (ab8500->irq_base) {
 		free_irq(ab8500->irq, ab8500);
-- 
1.7.2.2

