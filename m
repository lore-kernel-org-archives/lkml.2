Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab1LNK2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 05:28:25 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24647 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1LNK2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 05:28:21 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-01-4ee87a402f31
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Mike Lockwood <lockwood@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, MyungJoo Ham <myungjoo.ham@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, NeilBrown <neilb@suse.de>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH v2 2/3] Extcon: support notification based on the state changes.
Date: Wed, 14 Dec 2011 19:28:27 +0900
Message-id: <1323858508-27198-3-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1323858508-27198-1-git-send-email-myungjoo.ham@samsung.com>
References: <1323858508-27198-1-git-send-email-myungjoo.ham@samsung.com>
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Donggeun Kim <dg77.kim@samsung.com>

State changes of extcon devices have been notified via kobjet_uevent.
This patch adds notifier interfaces in order to allow device drivers to
get notified easily. Along with notifier interface,
extcon_get_extcon_dev() function is added so that device drivers may
discover a extcon_dev easily.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

--
Changes from RFC
- Renamed switch to extcon
- Bugfix: extcon_dev_unregister()
- Bugfix: "edev->dev" is "internal" data.
- Added kerneldoc comments.
- Reworded comments.
---
 drivers/extcon/extcon_class.c |   67 +++++++++++++++++++++++++++++++++++++++++
 include/linux/extcon.h        |   39 ++++++++++++++++++++++++
 2 files changed, 106 insertions(+), 0 deletions(-)

diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
index 39fbe9f..0223897 100644
--- a/drivers/extcon/extcon_class.c
+++ b/drivers/extcon/extcon_class.c
@@ -33,6 +33,9 @@
 struct class *extcon_class;
 static atomic_t device_count;
 
+static LIST_HEAD(extcon_dev_list);
+static DEFINE_MUTEX(extcon_dev_list_lock);
+
 static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
@@ -70,6 +73,9 @@ static DEVICE_ATTR(name, S_IRUGO, name_show, NULL);
  * extcon_set_state() - Set the cable attach states of the extcon device.
  * @edev:	the extcon device
  * @state:	new cable attach status for @edev
+ *
+ * Note that notifier provides the which bits are changes in the state
+ * variable with "val" to the callback.
  */
 void extcon_set_state(struct extcon_dev *edev, u32 state)
 {
@@ -79,10 +85,14 @@ void extcon_set_state(struct extcon_dev *edev, u32 state)
 	char *envp[3];
 	int env_offset = 0;
 	int length;
+	u32 old_state = edev->state;
 
 	if (edev->state != state) {
 		edev->state = state;
 
+		raw_notifier_call_chain(&edev->nh, old_state ^ edev->state,
+					edev);
+
 		prop_buf = (char *)get_zeroed_page(GFP_KERNEL);
 		if (prop_buf) {
 			length = name_show(edev->dev, NULL, prop_buf);
@@ -112,6 +122,51 @@ void extcon_set_state(struct extcon_dev *edev, u32 state)
 }
 EXPORT_SYMBOL_GPL(extcon_set_state);
 
+/**
+ * extcon_get_extcon_dev() - Get the extcon device instance from the name
+ * @extcon_name:	The extcon name provided with extcon_dev_register()
+ */
+struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name)
+{
+	struct extcon_dev *sd;
+
+	mutex_lock(&extcon_dev_list_lock);
+	list_for_each_entry(sd, &extcon_dev_list, entry) {
+		if (!strcmp(sd->name, extcon_name))
+			goto out;
+	}
+	sd = NULL;
+out:
+	mutex_unlock(&extcon_dev_list_lock);
+	return sd;
+}
+EXPORT_SYMBOL_GPL(extcon_get_extcon_dev);
+
+/**
+ * extcon_register_notifier() - Register a notifee to get notified by
+ *			      any attach status changes from the extcon.
+ * @edev:	the extcon device.
+ * @nb:		a notifier block to be registered.
+ */
+int extcon_register_notifier(struct extcon_dev *edev,
+			struct notifier_block *nb)
+{
+	return raw_notifier_chain_register(&edev->nh, nb);
+}
+EXPORT_SYMBOL_GPL(extcon_register_notifier);
+
+/**
+ * extcon_unregister_notifier() - Unregister a notifee from the extcon device.
+ * @edev:	the extcon device.
+ * @nb:		a registered notifier block to be unregistered.
+ */
+int extcon_unregister_notifier(struct extcon_dev *edev,
+			struct notifier_block *nb)
+{
+	return raw_notifier_chain_unregister(&edev->nh, nb);
+}
+EXPORT_SYMBOL_GPL(extcon_unregister_notifier);
+
 static int create_extcon_class(void)
 {
 	if (!extcon_class) {
@@ -156,8 +211,15 @@ int extcon_dev_register(struct extcon_dev *edev)
 	if (ret < 0)
 		goto err_create_file_2;
 
+	RAW_INIT_NOTIFIER_HEAD(&edev->nh);
+
 	dev_set_drvdata(edev->dev, edev);
 	edev->state = 0;
+
+	mutex_lock(&extcon_dev_list_lock);
+	list_add(&edev->entry, &extcon_dev_list);
+	mutex_unlock(&extcon_dev_list_lock);
+
 	return 0;
 
 err_create_file_2:
@@ -182,6 +244,11 @@ void extcon_dev_unregister(struct extcon_dev *edev)
 	device_remove_file(edev->dev, &dev_attr_name);
 	device_remove_file(edev->dev, &dev_attr_state);
 	device_destroy(extcon_class, MKDEV(0, edev->index));
+
+	mutex_lock(&extcon_dev_list_lock);
+	list_del(&edev->entry);
+	mutex_unlock(&extcon_dev_list_lock);
+
 	dev_set_drvdata(edev->dev, NULL);
 }
 EXPORT_SYMBOL_GPL(extcon_dev_unregister);
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 9c92bfb..64b57a2 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -23,6 +23,7 @@
 #ifndef __LINUX_EXTCON_H__
 #define __LINUX_EXTCON_H__
 
+#include <linux/notifier.h>
 /**
  * struct extcon_dev - An extcon device represents one external connector.
  * @name	The name of this extcon device. Please provide one when
@@ -35,6 +36,9 @@
  * @state	Attach/detach state of this extcon. Do not provide at
  *		register-time
  * @index	Device index. Do not provide at register-time.
+ * @nh	Notifier for the state change events from this extcon
+ * @entry	To support list of extcon devices so that uses can search
+ *		for extcon devices based on the extcon name.
  *
  * In most cases, users only need to provide "User initializing data" of
  * this struct when registering an extcon. In some exceptional cases,
@@ -53,6 +57,8 @@ struct extcon_dev {
 	struct device	*dev;
 	u32		state;
 	int		index;
+	struct raw_notifier_head nh;
+	struct list_head entry;
 };
 
 /**
@@ -74,8 +80,15 @@ struct gpio_extcon_platform_data {
 };
 
 #ifdef CONFIG_EXTCON
+
+/*
+ * Following APIs are for notifiers or configurations.
+ * Notifiers are the external port and connection devices.
+ */
+
 extern int extcon_dev_register(struct extcon_dev *edev);
 extern void extcon_dev_unregister(struct extcon_dev *edev);
+extern struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name);
 
 static inline u32 extcon_get_state(struct extcon_dev *edev)
 {
@@ -83,6 +96,15 @@ static inline u32 extcon_get_state(struct extcon_dev *edev)
 }
 
 extern void extcon_set_state(struct extcon_dev *edev, u32 state);
+
+/*
+ * Following APIs are to monitor every action of a notifier.
+ * Registerer gets notified for every external port of a connection device.
+ */
+extern int extcon_register_notifier(struct extcon_dev *edev,
+				    struct notifier_block *nb);
+extern int extcon_unregister_notifier(struct extcon_dev *edev,
+				      struct notifier_block *nb);
 #else /* CONFIG_EXTCON */
 static inline int extcon_dev_register(struct extcon_dev *edev)
 {
@@ -97,5 +119,22 @@ static inline u32 extcon_get_state(struct extcon_dev *edev)
 }
 
 static inline void extcon_set_state(struct extcon_dev *edev, u32 state) { }
+static inline struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name)
+{
+	return NULL;
+}
+
+static inline int extcon_register_notifier(struct extcon_dev *edev,
+					   struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline int extcon_unregister_notifier(struct extcon_dev *edev,
+					     struct notifier_block *nb)
+{
+	return 0;
+}
+
 #endif /* CONFIG_EXTCON */
 #endif /* __LINUX_EXTCON_H__ */
-- 
1.7.4.1

