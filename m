Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab1KXCGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 21:06:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43173 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab1KXCGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 21:06:49 -0500
MIME-Version: 1.0
Date: Thu, 24 Nov 2011 11:06:47 +0900
Message-ID: <CAJ0PZbTXLGXF-MRYBnvzKVL=V-3=87HbBOGz6td+LrFTkH5WZg@mail.gmail.com>
Subject: [RFC PATCH 3/3] Multistate Switch Class: support multiple states at a device
From: MyungJoo Ham <myungjoo.ham@gmail.com>
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

One switch device (e.g., MUIC(MAX8997, MAX77686, ...), and some 30-pin
devices) may have multiple cables attached. For example, one
30-pin port may inhabit a USB cable, an HDMI cable, and a mic.
Thus, one switch device requires multiple state bits each representing
a type of cable.

For such purpose, we use the 32bit state variable; thus, up to 32
different type of cables may be defined for a switch device. The list of
possible cables is defined by the array of cable names in the switch_dev
struct given to the class.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/misc/switch_class.c |  112 +++++++++++++++++++++++++++++++++++++++++--
 include/linux/switch.h      |   63 ++++++++++++++++++++++++
 2 files changed, 170 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/switch_class.c b/drivers/misc/switch_class.c
index ab574a3..2b40356 100644
--- a/drivers/misc/switch_class.c
+++ b/drivers/misc/switch_class.c
@@ -39,6 +39,7 @@ static DEFINE_MUTEX(switch_dev_list_lock);
 static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
+	int i, count = 0;
 	struct switch_dev *sdev = (struct switch_dev *)
 		dev_get_drvdata(dev);

@@ -47,7 +48,22 @@ static ssize_t state_show(struct device *dev,
struct device_attribute *attr,
 		if (ret >= 0)
 			return ret;
 	}
-	return sprintf(buf, "%u\n", sdev->state);
+
+	if (sdev->max_supported == 0)
+		return sprintf(buf, "%u\n", sdev->state);
+
+	for (i = 0; i < SUPPORTED_CABLE_MAX; i++) {
+		if (!sdev->supported_cable[i])
+			break;
+		if (i > 0)
+			count += sprintf(buf + count, ", ");
+		count += sprintf(buf + count, "%s %d",
+				 sdev->supported_cable[i],
+				 !!(sdev->state & (1 << i)));
+	}
+	count += sprintf(buf + count, "\n");
+
+	return count;
 }

 static ssize_t name_show(struct device *dev, struct device_attribute *attr,
@@ -67,7 +83,7 @@ static ssize_t name_show(struct device *dev, struct
device_attribute *attr,
 static DEVICE_ATTR(state, S_IRUGO, state_show, NULL);
 static DEVICE_ATTR(name, S_IRUGO, name_show, NULL);

-void switch_set_state(struct switch_dev *sdev, u32 state)
+void switch_update_state(struct switch_dev *sdev, u32 mask, u32 state)
 {
 	char name_buf[120];
 	char state_buf[120];
@@ -75,9 +91,13 @@ void switch_set_state(struct switch_dev *sdev, u32 state)
 	char *envp[3];
 	int env_offset = 0;
 	int length;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdev->lock, flags);

-	if (sdev->state != state) {
-		sdev->state = state;
+	if (sdev->state != ((sdev->state & ~mask) | (state & mask))) {
+		sdev->state &= ~mask;
+		sdev->state |= state & mask;

 		raw_notifier_call_chain(&sdev->nh, sdev->state, NULL);

@@ -100,16 +120,83 @@ void switch_set_state(struct switch_dev *sdev, u32 state)
 				envp[env_offset++] = state_buf;
 			}
 			envp[env_offset] = NULL;
+			/* Unlock early before uevent */
+			spin_unlock_irqrestore(&sdev->lock, flags);
+
 			kobject_uevent_env(&sdev->dev->kobj, KOBJ_CHANGE, envp);
 			free_page((unsigned long)prop_buf);
 		} else {
+			/* Unlock early before uevent */
+			spin_unlock_irqrestore(&sdev->lock, flags);
+
 			printk(KERN_ERR "out of memory in switch_set_state\n");
 			kobject_uevent(&sdev->dev->kobj, KOBJ_CHANGE);
 		}
+	} else {
+		/* No changes */
+		spin_unlock_irqrestore(&sdev->lock, flags);
 	}
 }
+EXPORT_SYMBOL_GPL(switch_update_state);
+
+void switch_set_state(struct switch_dev *sdev, u32 state)
+{
+	switch_update_state(sdev, 0xffffffff, state);
+}
 EXPORT_SYMBOL_GPL(switch_set_state);

+int switch_find_cable_index(struct switch_dev *sdev, const char *cable_name)
+{
+	int i;
+
+	if (sdev->supported_cable) {
+		for (i = 0; sdev->supported_cable[i]; i++) {
+			if (!strncmp(sdev->supported_cable[i],
+				cable_name, CABLE_NAME_MAX))
+				return i;
+		}
+	}
+
+	return -1;
+}
+EXPORT_SYMBOL_GPL(switch_find_cable_index);
+
+int switch_get_cable_state_(struct switch_dev *sdev, int index)
+{
+	if (index < 0 || (sdev->max_supported && sdev->max_supported <= index))
+		return -EINVAL;
+
+	return !!(sdev->state & (1 << index));
+}
+EXPORT_SYMBOL_GPL(switch_get_cable_state_);
+
+int switch_get_cable_state(struct switch_dev *sdev, const char *cable_name)
+{
+	return switch_get_cable_state_(sdev, switch_find_cable_index
+						(sdev, cable_name));
+}
+EXPORT_SYMBOL_GPL(switch_get_cable_state);
+
+int switch_set_cable_state_(struct switch_dev *sdev,
+			int index, bool cable_state)
+{
+	if (index < 0 || (sdev->max_supported && sdev->max_supported <= index))
+		return -EINVAL;
+
+	state = cable_state ? (1 << index) : 0;
+	switch_update_state(sdev, 1 << index, state);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(switch_set_cable_state_);
+
+int switch_set_cable_state(struct switch_dev *sdev,
+			const char *cable_name, bool cable_state)
+{
+	return switch_set_cable_state_(sdev, switch_find_cable_index
+					(sdev, cable_name), cable_state);
+}
+EXPORT_SYMBOL_GPL(switch_set_cable_state);
+
 struct switch_dev *switch_get_switch_dev(const char *switch_name)
 {
 	struct switch_dev *sd;
@@ -154,7 +241,7 @@ static int create_switch_class(void)

 int switch_dev_register(struct switch_dev *sdev)
 {
-	int ret;
+	int ret, index = 0;

 	if (!switch_class) {
 		ret = create_switch_class();
@@ -162,6 +249,21 @@ int switch_dev_register(struct switch_dev *sdev)
 			return ret;
 	}

+	if (sdev->supported_cable) {
+		/* Get size of array */
+		for (index = 0; sdev->supported_cable[index]; index++)
+			;
+		sdev->max_supported = index;
+	} else {
+		sdev->max_supported = 0;
+	}
+
+	if (index > SUPPORTED_CABLE_MAX) {
+		dev_err(sdev->dev, "switch: Exceed maximum number of supported cable\n");
+		return -EINVAL;
+	}
+
+	spin_lock_init(&sdev->lock);
 	sdev->index = atomic_inc_return(&device_count);
 	sdev->dev = device_create(switch_class, NULL,
 		MKDEV(0, sdev->index), NULL, sdev->name);
diff --git a/include/linux/switch.h b/include/linux/switch.h
index 0e43901..f5c3471 100644
--- a/include/linux/switch.h
+++ b/include/linux/switch.h
@@ -25,10 +25,18 @@

 #include <linux/notifier.h>

+#define SUPPORTED_CABLE_MAX	32
+#define CABLE_NAME_MAX		30
+
 struct switch_dev {
 	/* --- User initializing data --- */
 	const char	*name;
 	struct device	*dev;
+	/*
+	 * Array of cable names ending with NULL.
+	 * If supported_cable is NULL, cable name related APIs are disabled
+	 */
+	const char **supported_cable;

 	/* --- Optional callbacks to override class functions --- */
 	ssize_t	(*print_name)(struct switch_dev *sdev, char *buf);
@@ -39,6 +47,8 @@ struct switch_dev {
 	int		index;
 	struct raw_notifier_head nh;
 	struct list_head entry;
+	spinlock_t lock; /* could be called by irq handler */
+	int max_supported;
 };

 struct gpio_switch_platform_data {
@@ -57,12 +67,30 @@ struct gpio_switch_platform_data {
 extern int switch_dev_register(struct switch_dev *sdev);
 extern void switch_dev_unregister(struct switch_dev *sdev);

+/*
+ * get/set/update_state access the 32b encoded state value, which represents
+ * states of all possible cables of the multistate port. For example, if one
+ * calls switch_set_states(sdev, 0x7), it may mean that all the three cables
+ * are attached to the port.
+ */
 static inline u32 switch_get_state(struct switch_dev *sdev)
 {
 	return sdev->state;
 }

 extern void switch_set_state(struct switch_dev *sdev, u32 state);
+extern void switch_update_state(struct switch_dev *sdev, u32 mask, u32 state);
+
+extern int switch_find_cable_index(struct switch_dev *sdev,
+				   const char *cable_name);
+extern int switch_get_cable_state_(struct switch_dev *sdev, int cable_index);
+extern int switch_set_cable_state_(struct switch_dev *sdev, int cable_index,
+				   bool cable_state);
+
+extern int switch_get_cable_state(struct switch_dev *sdev,
+				  const char *cable_name);
+extern int switch_set_cable_state(struct switch_dev *sdev,
+				  const char *cable_name, bool cable_state);

 extern struct switch_dev *switch_get_switch_dev(const char *switch_name);
 extern int switch_register_notifier(struct switch_dev *sdev,
@@ -83,6 +111,41 @@ static inline u32 switch_get_state(struct switch_dev *sdev)
 }

 static inline void switch_set_state(struct switch_dev *sdev, u32 state) { }
+
+static inline void switch_update_state(struct switch_dev *sdev, u32 mask,
+				       u32 state)
+{ }
+
+static inline int switch_find_cable_index(struct switch_dev *sdev,
+					  const char *cable_name)
+{
+	return 0;
+}
+
+static inline int switch_get_cable_state_(struct switch_dev *sdev,
+					  int cable_index)
+{
+	return 0;
+}
+
+static inline int switch_set_cable_state_(struct switch_dev *sdev,
+					  int cable_index, bool cable_state)
+{
+	return 0;
+}
+
+static inline int switch_get_cable_state(struct switch_dev *sdev,
+			const char *cable_name)
+{
+	return 0;
+}
+
+static inline int switch_set_cable_state(struct switch_dev *sdev,
+			const char *cable_name, int state)
+{
+	return 0;
+}
+
 static inline struct switch_dev *switch_get_switch_dev(const char *switch_name)
 {
 	return NULL;
-- 
1.7.4.1
