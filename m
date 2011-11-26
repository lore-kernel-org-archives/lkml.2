Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab1KZKAp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 05:00:45 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:42207 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab1KZKAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 05:00:43 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: platform-driver-x86@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matthew Garrett <mjg@redhat.com>,
        Corentin Chary <corentincj@iksaif.net>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/16] samsung-laptop: use a sysfs group
Date: Sat, 26 Nov 2011 11:00:01 +0100
Message-Id: <1322301613-8801-5-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322301613-8801-1-git-send-email-corentincj@iksaif.net>
References: <1322301613-8801-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will be usefull later when we will have more platform sysfs files
like battery_life_extender or usb_charge.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/platform/x86/samsung-laptop.c |   34 +++++++++++++++++++++++++++++---
 1 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index 49933d2..a21e0c3 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -555,6 +555,10 @@ static ssize_t set_performance_level(struct device *dev,
 static DEVICE_ATTR(performance_level, S_IWUSR | S_IRUGO,
 		   get_performance_level, set_performance_level);
 
+static struct attribute *platform_attributes[] = {
+	&dev_attr_performance_level.attr,
+	NULL
+};
 
 static int find_signature(void __iomem *memcheck, const char *testStr)
 {
@@ -641,16 +645,38 @@ static int __init samsung_backlight_init(struct samsung_laptop *samsung)
 	return 0;
 }
 
+static mode_t samsung_sysfs_is_visible(struct kobject *kobj,
+				       struct attribute *attr, int idx)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct samsung_laptop *samsung = platform_get_drvdata(pdev);
+	bool ok = true;
+
+	if (attr == &dev_attr_performance_level.attr)
+		ok = !!samsung->config->performance_levels[0].name;
+
+	return ok ? attr->mode : 0;
+}
+
+static struct attribute_group platform_attribute_group = {
+	.is_visible = samsung_sysfs_is_visible,
+	.attrs = platform_attributes
+};
+
 static void samsung_sysfs_exit(struct samsung_laptop *samsung)
 {
-	device_remove_file(&samsung->platform_device->dev,
-			   &dev_attr_performance_level);
+	struct platform_device *device = samsung->platform_device;
+
+	sysfs_remove_group(&device->dev.kobj, &platform_attribute_group);
 }
 
 static int __init samsung_sysfs_init(struct samsung_laptop *samsung)
 {
-	return device_create_file(&samsung->platform_device->dev,
-				  &dev_attr_performance_level);
+	struct platform_device *device = samsung->platform_device;
+
+	return sysfs_create_group(&device->dev.kobj, &platform_attribute_group);
+
 }
 
 static void samsung_sabi_exit(struct samsung_laptop *samsung)
-- 
1.7.5.4

