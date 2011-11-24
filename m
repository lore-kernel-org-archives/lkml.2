Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab1KXCGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 21:06:13 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35421 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab1KXCGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 21:06:11 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
Date: Thu, 24 Nov 2011 11:06:10 +0900
X-Google-Sender-Auth: -F-TnwjoJYaQV1zg-gtBqCszF9k
Message-ID: <CAJ0PZbTX4NCketEE1-StC0He_zrqPK5s9=exSnz74PT-QxxxKg@mail.gmail.com>
Subject: [RFC PATCH 2/3] Multistate Switch Class: add notifier block
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, MyungJoo Ham <myungjoo.ham@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

State changes of switch devices have been notified via kobjet_uevent.
This patch adds notifier interfaces in order to allow device drivers to
get notified easily. Along with notifier interface,
switch_get_switch_dev() function is added so that device drivers may
discover a switch_dev easily.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/misc/switch_class.c |   47 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/switch.h      |   24 ++++++++++++++++++++++
 2 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/switch_class.c b/drivers/misc/switch_class.c
index b17a4be..ab574a3 100644
--- a/drivers/misc/switch_class.c
+++ b/drivers/misc/switch_class.c
@@ -33,6 +33,9 @@
 struct class *switch_class;
 static atomic_t device_count;

+static LIST_HEAD(switch_dev_list);
+static DEFINE_MUTEX(switch_dev_list_lock);
+
 static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
@@ -76,6 +79,8 @@ void switch_set_state(struct switch_dev *sdev, u32 state)
 	if (sdev->state != state) {
 		sdev->state = state;

+		raw_notifier_call_chain(&sdev->nh, sdev->state, NULL);
+
 		prop_buf = (char *)get_zeroed_page(GFP_KERNEL);
 		if (prop_buf) {
 			length = name_show(sdev->dev, NULL, prop_buf);
@@ -105,6 +110,36 @@ void switch_set_state(struct switch_dev *sdev, u32 state)
 }
 EXPORT_SYMBOL_GPL(switch_set_state);

+struct switch_dev *switch_get_switch_dev(const char *switch_name)
+{
+	struct switch_dev *sd;
+
+	mutex_lock(&switch_dev_list_lock);
+	list_for_each_entry(sd, &switch_dev_list, entry) {
+		if (!strcmp(sd->name, switch_name))
+			goto out;
+	}
+	sd = NULL;
+out:
+	mutex_unlock(&switch_dev_list_lock);
+	return sd;
+}
+EXPORT_SYMBOL_GPL(switch_get_switch_dev);
+
+int switch_register_notifier(struct switch_dev *sdev,
+			struct notifier_block *bh)
+{
+	return raw_notifier_chain_register(&sdev->nh, bh);
+}
+EXPORT_SYMBOL_GPL(switch_register_notifier);
+
+int switch_unregister_notifier(struct switch_dev *sdev,
+			struct notifier_block *bh)
+{
+	return raw_notifier_chain_register(&sdev->nh, bh);
+}
+EXPORT_SYMBOL_GPL(switch_unregister_notifier);
+
 static int create_switch_class(void)
 {
 	if (!switch_class) {
@@ -140,8 +175,15 @@ int switch_dev_register(struct switch_dev *sdev)
 	if (ret < 0)
 		goto err_create_file_2;

+	RAW_INIT_NOTIFIER_HEAD(&sdev->nh);
+
 	dev_set_drvdata(sdev->dev, sdev);
 	sdev->state = 0;
+
+	mutex_lock(&switch_dev_list_lock);
+	list_add(&sdev->entry, &switch_dev_list);
+	mutex_unlock(&switch_dev_list_lock);
+
 	return 0;

 err_create_file_2:
@@ -159,6 +201,11 @@ void switch_dev_unregister(struct switch_dev *sdev)
 	device_remove_file(sdev->dev, &dev_attr_name);
 	device_remove_file(sdev->dev, &dev_attr_state);
 	device_destroy(switch_class, MKDEV(0, sdev->index));
+
+	mutex_lock(&switch_dev_list_lock);
+	list_del(&sdev->entry);
+	mutex_unlock(&switch_dev_list_lock);
+
 	dev_set_drvdata(sdev->dev, NULL);
 }
 EXPORT_SYMBOL_GPL(switch_dev_unregister);
diff --git a/include/linux/switch.h b/include/linux/switch.h
index a4bddf7..0e43901 100644
--- a/include/linux/switch.h
+++ b/include/linux/switch.h
@@ -23,6 +23,8 @@
 #ifndef __LINUX_SWITCH_H__
 #define __LINUX_SWITCH_H__

+#include <linux/notifier.h>
+
 struct switch_dev {
 	/* --- User initializing data --- */
 	const char	*name;
@@ -35,6 +37,8 @@ struct switch_dev {
 	/* --- Internal data. Please do not set. --- */
 	u32		state;
 	int		index;
+	struct raw_notifier_head nh;
+	struct list_head entry;
 };

 struct gpio_switch_platform_data {
@@ -59,6 +63,12 @@ static inline u32 switch_get_state(struct switch_dev *sdev)
 }

 extern void switch_set_state(struct switch_dev *sdev, u32 state);
+
+extern struct switch_dev *switch_get_switch_dev(const char *switch_name);
+extern int switch_register_notifier(struct switch_dev *sdev,
+				    struct notifier_block *bh);
+extern int switch_unregister_notifier(struct switch_dev *sdev,
+				      struct notifier_block *bh);
 #else /* CONFIG_MULTISTATE_SWITCH */
 static inline int switch_dev_register(struct switch_dev *sdev)
 {
@@ -73,5 +83,19 @@ static inline u32 switch_get_state(struct switch_dev *sdev)
 }

 static inline void switch_set_state(struct switch_dev *sdev, u32 state) { }
+static inline struct switch_dev *switch_get_switch_dev(const char *switch_name)
+{
+	return NULL;
+}
+static inline int switch_register_notifier(struct switch_dev *sdev,
+					   struct notifier_block *bh)
+{
+	return 0;
+}
+static inline int switch_unregister_notifier(struct switch_dev *sdev,
+					     struct notifier_block *bh)
+{
+	return 0;
+}
 #endif /* CONFIG_MULTISTATE_SWITCH */
 #endif /* __LINUX_SWITCH_H__ */
-- 
1.7.4.1
