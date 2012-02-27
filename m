Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2B0MPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 07:15:39 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47239 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab2B0MPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 07:15:37 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-2b-4f4b73e4626e
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: NeilBrown <neilb@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, gregkh@linuxfoundation.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com
Subject: [PATCH v6 3/5] Extcon: support notification based on the state changes.
Date: Mon, 27 Feb 2012 21:15:37 +0900
Message-id: <1330344939-18394-4-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
References: <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
 <1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
X-Brightmail-Tracker: AAAAAA==
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
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--
Changes from RFC
- Renamed switch to extcon
- Bugfix: extcon_dev_unregister()
- Bugfix: "edev->dev" is "internal" data.
- Added kerneldoc comments.
- Reworded comments.
---
 drivers/extcon/extcon_class.c |   66 +++++++++++++++++++++++++++++++++++++++++
 include/linux/extcon.h        |   38 +++++++++++++++++++++++
 2 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
index 9bc062b..51b14bd 100644
--- a/drivers/extcon/extcon_class.c
+++ b/drivers/extcon/extcon_class.c
@@ -33,6 +33,9 @@
 
 struct class *extcon_class;
 
+static LIST_HEAD(extcon_dev_list);
+static DEFINE_MUTEX(extcon_dev_list_lock);
+
 static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
@@ -72,6 +75,9 @@ static ssize_t name_show(struct device *dev, struct device_attribute *attr,
  * the name of extcon device (envp[0]) and the state output (envp[1]).
  * Tizen uses this format for extcon device to get events from ports.
  * Android uses this format as well.
+ *
+ * Note that notifier provides the which bits are changes in the state
+ * variable with "val" to the callback.
  */
 void extcon_set_state(struct extcon_dev *edev, u32 state)
 {
@@ -81,10 +87,14 @@ void extcon_set_state(struct extcon_dev *edev, u32 state)
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
@@ -114,6 +124,51 @@ void extcon_set_state(struct extcon_dev *edev, u32 state)
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
 static struct device_attribute extcon_attrs[] = {
 	__ATTR_RO(state),
 	__ATTR_RO(name),
@@ -137,6 +192,10 @@ static int create_extcon_class(void)
 
 static void extcon_cleanup(struct extcon_dev *edev, bool skip)
 {
+	mutex_lock(&extcon_dev_list_lock);
+	list_del(&edev->entry);
+	mutex_unlock(&extcon_dev_list_lock);
+
 	if (!skip && get_device(edev->dev)) {
 		device_unregister(edev->dev);
 		put_device(edev->dev);
@@ -184,8 +243,15 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 		goto err_dev;
 	}
 
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
 
 err_dev:
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index cd732ab..50be845 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -23,6 +23,7 @@
 #ifndef __LINUX_EXTCON_H__
 #define __LINUX_EXTCON_H__
 
+#include <linux/notifier.h>
 /**
  * struct extcon_dev - An extcon device represents one external connector.
  * @name	The name of this extcon device. Parent device name is used
@@ -34,6 +35,9 @@
  * @dev		Device of this extcon. Do not provide at register-time.
  * @state	Attach/detach state of this extcon. Do not provide at
  *		register-time
+ * @nh	Notifier for the state change events from this extcon
+ * @entry	To support list of extcon devices so that uses can search
+ *		for extcon devices based on the extcon name.
  *
  * In most cases, users only need to provide "User initializing data" of
  * this struct when registering an extcon. In some exceptional cases,
@@ -51,11 +55,19 @@ struct extcon_dev {
 	/* --- Internal data. Please do not set. --- */
 	struct device	*dev;
 	u32		state;
+	struct raw_notifier_head nh;
+	struct list_head entry;
 };
 
 #ifdef CONFIG_EXTCON
+
+/*
+ * Following APIs are for notifiers or configurations.
+ * Notifiers are the external port and connection devices.
+ */
 extern int extcon_dev_register(struct extcon_dev *edev, struct device *dev);
 extern void extcon_dev_unregister(struct extcon_dev *edev);
+extern struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name);
 
 static inline u32 extcon_get_state(struct extcon_dev *edev)
 {
@@ -63,6 +75,15 @@ static inline u32 extcon_get_state(struct extcon_dev *edev)
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
 static inline int extcon_dev_register(struct extcon_dev *edev,
 				      struct device *dev)
@@ -78,5 +99,22 @@ static inline u32 extcon_get_state(struct extcon_dev *edev)
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

