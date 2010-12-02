Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744Ab0LBOKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 09:10:15 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:46280 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757605Ab0LBOKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 09:10:14 -0500
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Ludovic Barre <ludovic.barre@stericsson.com>
Subject: [PATCH v2] MFD: ab8500 chip id exported to sysfs
Date: Thu, 2 Dec 2010 15:09:36 +0100
Message-ID: <1291298976-4623-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a file into sysfs for reading out chip id.
It have been requested for modem silent reboot.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Ludovic Barre <ludovic.barre@stericsson.com>
---
 drivers/mfd/ab8500-core.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index e91b5b7..2bd4437 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -436,6 +436,26 @@ static struct mfd_cell ab8500_devs[] = {
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
@@ -510,6 +530,10 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 	if (ret)
 		goto out_freeirq;
 
+	ret = sysfs_create_group(&ab8500->dev->kobj, &ab8500_attr_group);
+	if (ret)
+		dev_err(ab8500->dev, "error creating sysfs entries\n");
+
 	return ret;
 
 out_freeirq:
@@ -523,6 +547,7 @@ out_removeirq:
 
 int __devexit ab8500_exit(struct ab8500 *ab8500)
 {
+	sysfs_remove_group(&ab8500->dev->kobj, &ab8500_attr_group);
 	mfd_remove_devices(ab8500->dev);
 	if (ab8500->irq_base) {
 		free_irq(ab8500->irq, ab8500);
-- 
1.7.2.2

