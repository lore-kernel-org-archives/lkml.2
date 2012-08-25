Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab2HYOOr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 10:14:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44429 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab2HYOOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 10:14:37 -0400
From: anish kumar <anish198519851985@gmail.com>
To: cw00.choi@samsung.com, myungjoo.ham@samsung.com
Cc: linux-kernel@vger.kernel.org, anish kumar <anish198519851985@gmail.com>
Subject: [PATCH] [RFC]Extcon: Change to add standard cable names in individual drivers.
Date: Sat, 25 Aug 2012 19:44:09 +0530
Message-Id: <1345904049-26568-1-git-send-email-anish198519851985@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

Right now we are forced to define our own cable names instead of what
is exported by extcon framework.We should use the standard cable
names.With this change, individual drivers can define cable names
as below:

edev.list_of_cable = EXTCON_MIC_IN_SUPPORT |
                     EXTCON_HEADPHONE_OUT_SUPPORT |
                     EXTCON_MECHANICAL_SUPPORT;
Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 drivers/extcon/extcon-arizona.c |   11 +++--------
 drivers/extcon/extcon-class.c   |   35 +++++++++++++++++++++++++----------
 include/linux/extcon.h          |   29 ++++++++++++++++++++++++++++-
 3 files changed, 56 insertions(+), 19 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index fa2114f..7a690f2 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -74,13 +74,6 @@ static struct {
 #define ARIZONA_CABLE_MICROPHONE 1
 #define ARIZONA_CABLE_HEADPHONE  2
 
-static const char *arizona_cable[] = {
-	"Mechanical",
-	"Microphone",
-	"Headphone",
-	NULL,
-};
-
 static void arizona_extcon_set_mode(struct arizona_extcon_info *info, int mode)
 {
 	struct arizona *arizona = info->arizona;
@@ -381,7 +374,9 @@ static int __devinit arizona_extcon_probe(struct platform_device *pdev)
 	}
 
 	info->edev.name = "Headset Jack";
-	info->edev.supported_cable = arizona_cable;
+	info->edev.list_of_cable = EXTCON_MIC_IN_SUPPORT |
+					EXTCON_HEADPHONE_OUT_SUPPORT |
+						EXTCON_MECHANICAL_SUPPORT;
 
 	ret = extcon_dev_register(&info->edev, arizona->dev);
 	if (ret < 0) {
diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 481cfa0..22aa4b8 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -95,7 +95,7 @@ static int check_mutually_exclusive(struct extcon_dev *edev, u32 new_state)
 		u32 correspondants = new_state & edev->mutually_exclusive[i];
 		u32 exp = 1;
 
-		for (j = 0; j < 32; j++) {
+		for (j = 0; j < SUPPORTED_CABLE_MAX; j++) {
 			if (exp & correspondants)
 				count++;
 			if (count > 1)
@@ -580,6 +580,7 @@ static void extcon_cleanup(struct extcon_dev *edev, bool skip)
 		put_device(edev->dev);
 	}
 
+	kfree(edev->supported_cable);
 	kfree(edev->dev);
 }
 
@@ -607,7 +608,7 @@ static void dummy_sysfs_dev_release(struct device *dev)
  */
 int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 {
-	int ret, index = 0;
+	int ret, index = 0, i = 0;
 
 	if (!extcon_class) {
 		ret = create_extcon_class();
@@ -615,23 +616,36 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 			return ret;
 	}
 
-	if (edev->supported_cable) {
-		/* Get size of array */
-		for (index = 0; edev->supported_cable[index]; index++)
-			;
-		edev->max_supported = index;
-	} else {
-		edev->max_supported = 0;
+	edev->max_supported = 0;
+
+	/* get the total number of cables */
+	for_each_set_bit(i, &edev->list_of_cable, BITS_PER_LONG) {
+		index++;
 	}
+	edev->max_supported = index;
 
 	if (index > SUPPORTED_CABLE_MAX) {
 		dev_err(edev->dev, "extcon: maximum number of supported cables exceeded.\n");
 		return -EINVAL;
 	}
 
+	edev->supported_cable = kzalloc(sizeof(char *) * index, GFP_KERNEL);
+	if (!edev->supported_cable) {
+		pr_err("extcon supported cable allocation failed\n");
+		return -ENOMEM;
+	}
+
+	index = 0;
+	for_each_set_bit(i, &edev->list_of_cable, BITS_PER_LONG) {
+		edev->supported_cable[index++] = extcon_cable_name[i];
+	}
+
 	edev->dev = kzalloc(sizeof(struct device), GFP_KERNEL);
-	if (!edev->dev)
+	if (!edev->dev) {
+		pr_err("extcon device allocation failed\n");
 		return -ENOMEM;
+	}
+
 	edev->dev->parent = dev;
 	edev->dev->class = extcon_class;
 	edev->dev->release = extcon_dev_release;
@@ -799,6 +813,7 @@ err_alloc_cables:
 	if (edev->max_supported)
 		kfree(edev->cables);
 err_sysfs_alloc:
+	kfree(edev->supported_cable);
 	kfree(edev->dev);
 	return ret;
 }
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index cdd4014..65cc23a 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -70,6 +70,32 @@ enum extcon_cable_name {
 };
 extern const char *extcon_cable_name[];
 
+/* Please use this enum's to add support for cables in your drivers
+ * Please add any other "standard" cables used with extcon dev.
+ */
+enum extcon_cable_name_support {
+	EXTCON_USB_SUPPORT		= 1 << EXTCON_USB,
+	EXTCON_USB_HOST_SUPPORT		= 1 << EXTCON_USB_HOST,
+	EXTCON_TA_SUPPORT		= 1 << EXTCON_TA,
+	EXTCON_FAST_CHARGER_SUPPORT	= 1 << EXTCON_FAST_CHARGER,
+	EXTCON_SLOW_CHARGER_SUPPORT	= 1 << EXTCON_SLOW_CHARGER,
+	EXTCON_CHARGE_DOWNSTREAM_SUPPORT = 1 << EXTCON_CHARGE_DOWNSTREAM,
+	EXTCON_HDMI_SUPPORT		= 1 << EXTCON_HDMI,
+	EXTCON_MHL_SUPPORT		= 1 << EXTCON_MHL,
+	EXTCON_DVI_SUPPORT		= 1 << EXTCON_DVI,
+	EXTCON_VGA_SUPPORT		= 1 << EXTCON_VGA,
+	EXTCON_DOCK_SUPPORT		= 1 << EXTCON_DOCK,
+	EXTCON_LINE_IN_SUPPORT		= 1 << EXTCON_LINE_IN,
+	EXTCON_LINE_OUT_SUPPORT		= 1 << EXTCON_LINE_OUT,
+	EXTCON_MIC_IN_SUPPORT		= 1 << EXTCON_MIC_IN,
+	EXTCON_HEADPHONE_OUT_SUPPORT	= 1 << EXTCON_HEADPHONE_OUT,
+	EXTCON_SPDIF_IN_SUPPORT		= 1 << EXTCON_SPDIF_IN,
+	EXTCON_SPDIF_OUT_SUPPORT	= 1 << EXTCON_SPDIF_OUT,
+	EXTCON_VIDEO_IN_SUPPORT		= 1 << EXTCON_VIDEO_IN,
+	EXTCON_VIDEO_OUT_SUPPORT	= 1 << EXTCON_VIDEO_OUT,
+	EXTCON_MECHANICAL_SUPPORT	= 1 << EXTCON_MECHANICAL,
+};
+
 struct extcon_cable;
 
 /**
@@ -111,7 +137,7 @@ struct extcon_cable;
 struct extcon_dev {
 	/* --- Optional user initializing data --- */
 	const char	*name;
-	const char **supported_cable;
+	unsigned long	list_of_cable;
 	const u32	*mutually_exclusive;
 
 	/* --- Optional callbacks to override class functions --- */
@@ -120,6 +146,7 @@ struct extcon_dev {
 
 	/* --- Internal data. Please do not set. --- */
 	struct device	*dev;
+	const char **supported_cable;
 	u32		state;
 	struct raw_notifier_head nh;
 	struct list_head entry;
-- 
1.7.1

