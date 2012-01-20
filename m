Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab2ATBCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 20:02:46 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:37902 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab2ATBCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 20:02:11 -0500
X-AuditID: cbfee61a-b7cd2ae000004fa5-dd-4f18bd0aa533
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        myungjoo.ham@gmail.com
Subject: [PATCH v4 3/4] Extcon: support multiple states at a device.
Date: Fri, 20 Jan 2012 10:01:56 +0900
Message-id: <1327021317-10222-4-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
References: <1326275202-27401-1-git-send-email-myungjoo.ham@samsung.com>
 <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
X-Brightmail-Tracker: AAAAAA==
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

--
Changes from V3
- Bugfixes after more testing at Exynos4412 boards.

Changes from V2
- State can be stored by user
- Documentation updated

Changes from RFC
- Switch is renamed to extcon
- Added kerneldoc comments
- Added APIs to support "standard" cable names
- Added helper APIs to support notifier block registration with cable
  name.
- Regrouped function list in the header file.

Extcon: extcon framework bugfix

This patch fixes the following issues:
1. NULL pointer error due to device_attribute
2. The message of 'BUG: sleeping function called from invalid context ...'
   is shown when calling get_zeroed_page in spin locked
3. Handling old state had bug that not properly interpretting the
semantics of values.
4. Incorrect sysfs node format (state)

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 Documentation/ABI/testing/sysfs-class-extcon |   38 +++-
 drivers/extcon/extcon_class.c                |  310 ++++++++++++++++++++++++-
 include/linux/extcon.h                       |  149 ++++++++++++
 3 files changed, 480 insertions(+), 17 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-extcon b/Documentation/ABI/testing/sysfs-class-extcon
index 59a4b1c..31bb609 100644
--- a/Documentation/ABI/testing/sysfs-class-extcon
+++ b/Documentation/ABI/testing/sysfs-class-extcon
@@ -7,6 +7,14 @@ Description:
 		The name of extcon object denoted as ... is the name given
 		with extcon_dev_register.
 
+		One extcon device denotes a single external connector
+		port. An external connector may have multiple cables
+		attached simultaneously. Many of docks, cradles, and
+		accessory cables have such capability. For example,
+		the 30-pin port of Nuri board (/arch/arm/mach-exynos)
+		may have both HDMI and Charger attached, or analog audio,
+		video, and USB cables attached simulteneously.
+
 What:		/sys/class/extcon/.../name
 Date:		December 2011
 Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
@@ -20,7 +28,29 @@ What:		/sys/class/extcon/.../state
 Date:		December 2011
 Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
 Description:
-		The /sys/class/extcon/.../state shows the cable attach/detach
-		information of the corresponding extcon object. If the extcon
-		objecct has an optional callback "show_state" defined, the
-		callback will provide the name with this sysfs node.
+		The /sys/class/extcon/.../state shows and stores the cable
+		attach/detach information of the corresponding extcon object.
+		If the extcon objecct has an optional callback "show_state"
+		defined, the showing function is overriden with the optional
+		callback.
+
+		If the default callback for showing function is used, the
+		format is like this:
+		# cat state
+		USB_OTG=1
+		HDMI=0
+		TA=1
+		EAR_JACK=0
+		#
+		In this example, the extcon device have USB_OTG and TA
+		cables attached and HDMI and EAR_JACK cables detached.
+
+		There are two methods to update state of extcon.
+		Method 1.
+		  echo CABLE_NAME [0|1] > state
+		Method 2.
+		  echo 0xHEX > state
+
+		Method 1 updates the state (0 or 1) of the
+		corresponding cable (either the name or index of the cable).
+		Method 2 updates the whole state of the extcon dev.
diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
index 763cf4d..2803bd0 100644
--- a/drivers/extcon/extcon_class.c
+++ b/drivers/extcon/extcon_class.c
@@ -31,6 +31,25 @@
 #include <linux/extcon.h>
 #include <linux/slab.h>
 
+const char *extcon_cable_name[] = {
+	[EXTCON_USB]		= "USB",
+	[EXTCON_USB_HOST]	= "USB-Host",
+	[EXTCON_TA]		= "TA",
+	[EXTCON_FAST_CHARGER]	= "Fast-charger",
+	[EXTCON_SLOW_CHARGER]	= "Slow-charger",
+	[EXTCON_CHARGE_DOWNSTREAM]	= "Charge-downstream",
+	[EXTCON_HDMI]		= "HDMI",
+	[EXTCON_MHL]		= "MHL",
+	[EXTCON_DVI]		= "DVI",
+	[EXTCON_VGA]		= "VGA",
+	[EXTCON_DOCK]		= "Dock",
+	[EXTCON_AUDIO_IN]	= "Audio-in",
+	[EXTCON_AUDIO_OUT]	= "Audio-out",
+	[EXTCON_VIDEO_IN]	= "Video-in",
+	[EXTCON_VIDEO_OUT]	= "Video-out",
+
+	NULL,
+};
 struct class *extcon_class;
 struct class *extcon_class_for_android;
 
@@ -40,6 +59,7 @@ static DEFINE_MUTEX(extcon_dev_list_lock);
 static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
+	int i, count = 0;
 	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
 
 	if (edev->print_state) {
@@ -49,7 +69,55 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 			return ret;
 		/* Use default if failed */
 	}
-	return sprintf(buf, "%u\n", edev->state);
+
+	if (edev->max_supported == 0)
+		return sprintf(buf, "%u\n", edev->state);
+
+	for (i = 0; i < SUPPORTED_CABLE_MAX; i++) {
+		if (!edev->supported_cable[i])
+			break;
+		count += sprintf(buf + count, "%s=%d\n",
+				 edev->supported_cable[i],
+				 !!(edev->state & (1 << i)));
+	}
+
+	return count;
+}
+
+void extcon_set_state(struct extcon_dev *edev, u32 state);
+static ssize_t state_store(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	u32 state;
+	ssize_t ret = 0;
+	int enabled;
+	char *buffer = kzalloc(count + 1, GFP_KERNEL);
+	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
+
+	/* Format: /Documentation/ABI/testing/sysfs-class-extcon */
+	ret = sscanf(buf, "%s %d", buffer, &enabled);
+
+	/* TODO: remove before submit */
+	pr_info("[%s][%d]\n", buffer, enabled);
+
+	if (ret == 2) {
+		/* Method 1 */
+		ret = extcon_set_cable_state(edev, buffer, enabled);
+		pr_info("Method 1\n");
+	} else if (ret == 1) {
+		/* Method 2 */
+		ret = sscanf(buf, "0x%x", &state);
+		pr_info("Method 2 with 0x%x\n", state);
+		if (ret == 0)
+			ret = -EINVAL;
+		else
+			extcon_set_state(edev, state);
+	} else {
+		ret = -EINVAL;
+	}
+
+	kfree(buffer);
+	return ret;
 }
 
 static ssize_t name_show(struct device *dev, struct device_attribute *attr,
@@ -68,8 +136,10 @@ static ssize_t name_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * extcon_set_state() - Set the cable attach states of the extcon device.
+ * extcon_update_state() - Update the cable attach states of the extcon device
+ *			only for the masked bits.
  * @edev:	the extcon device
+ * @mask:	the bit mask to designate updated bits.
  * @state:	new cable attach status for @edev
  *
  * Changing the state sends uevent with environment variable containing
@@ -77,10 +147,10 @@ static ssize_t name_show(struct device *dev, struct device_attribute *attr,
  * Tizen uses this format for extcon device to get events from ports.
  * Android uses this format as well.
  *
- * Note that notifier provides the which bits are changes in the state
- * variable with "val" to the callback.
+ * Note that the notifier provides which bits are changed in the state
+ * variable with the val parameter (second) to the callback.
  */
-void extcon_set_state(struct extcon_dev *edev, u32 state)
+void extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
 {
 	char name_buf[120];
 	char state_buf[120];
@@ -88,15 +158,20 @@ void extcon_set_state(struct extcon_dev *edev, u32 state)
 	char *envp[3];
 	int env_offset = 0;
 	int length;
-	u32 old_state = edev->state;
+	unsigned long flags;
 
-	if (edev->state != state) {
-		edev->state = state;
+	spin_lock_irqsave(&edev->lock, flags);
 
-		raw_notifier_call_chain(&edev->nh, old_state ^ edev->state,
-					edev);
+	if (edev->state != ((edev->state & ~mask) | (state & mask))) {
+		u32 old_state = edev->state;
 
-		prop_buf = (char *)get_zeroed_page(GFP_KERNEL);
+		edev->state &= ~mask;
+		edev->state |= state & mask;
+
+		raw_notifier_call_chain(&edev->nh, old_state, edev);
+
+		/* This could be in interrupt handler */
+		prop_buf = (char *)get_zeroed_page(GFP_ATOMIC);
 		if (prop_buf) {
 			length = name_show(edev->dev, NULL, prop_buf);
 			if (length > 0) {
@@ -115,17 +190,132 @@ void extcon_set_state(struct extcon_dev *edev, u32 state)
 				envp[env_offset++] = state_buf;
 			}
 			envp[env_offset] = NULL;
+			/* Unlock early before uevent */
+			spin_unlock_irqrestore(&edev->lock, flags);
+
 			kobject_uevent_env(&edev->dev->kobj, KOBJ_CHANGE, envp);
 			free_page((unsigned long)prop_buf);
 		} else {
+			/* Unlock early before uevent */
+			spin_unlock_irqrestore(&edev->lock, flags);
+
 			dev_err(edev->dev, "out of memory in extcon_set_state\n");
 			kobject_uevent(&edev->dev->kobj, KOBJ_CHANGE);
 		}
+	} else {
+		/* No changes */
+		spin_unlock_irqrestore(&edev->lock, flags);
 	}
 }
+EXPORT_SYMBOL_GPL(extcon_update_state);
+
+/**
+ * extcon_set_state() - Set the cable attach states of the extcon device.
+ * @edev:	the extcon device
+ * @state:	new cable attach status for @edev
+ *
+ * Note that notifier provides which bits are changed in the state
+ * variable with the val parameter (second) to the callback.
+ */
+void extcon_set_state(struct extcon_dev *edev, u32 state)
+{
+	extcon_update_state(edev, 0xffffffff, state);
+}
 EXPORT_SYMBOL_GPL(extcon_set_state);
 
 /**
+ * extcon_find_cable_index() - Get the cable index based on the cable name.
+ * @edev:	the extcon device that has the cable.
+ * @cable_name:	cable name to be searched.
+ *
+ * Note that accessing a cable state based on cable_index is faster than
+ * cable_name because using cable_name induces a loop with strncmp().
+ * Thus, when get/set_cable_state is repeatedly used, using cable_index
+ * is recommended.
+ */
+int extcon_find_cable_index(struct extcon_dev *edev, const char *cable_name)
+{
+	int i;
+
+	if (edev->supported_cable) {
+		for (i = 0; edev->supported_cable[i]; i++) {
+			if (!strncmp(edev->supported_cable[i],
+				cable_name, CABLE_NAME_MAX))
+				return i;
+		}
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(extcon_find_cable_index);
+
+/**
+ * extcon_get_cable_state_() - Get the status of a specific cable.
+ * @edev:	the extcon device that has the cable.
+ * @index:	cable index that can be retrieved by extcon_find_cable_index().
+ */
+int extcon_get_cable_state_(struct extcon_dev *edev, int index)
+{
+	if (index < 0 || (edev->max_supported && edev->max_supported <= index))
+		return -EINVAL;
+
+	return !!(edev->state & (1 << index));
+}
+EXPORT_SYMBOL_GPL(extcon_get_cable_state_);
+
+/**
+ * extcon_get_cable_state() - Get the status of a specific cable.
+ * @edev:	the extcon device that has the cable.
+ * @cable_name:	cable name.
+ *
+ * Note that this is slower than extcon_get_cable_state_.
+ */
+int extcon_get_cable_state(struct extcon_dev *edev, const char *cable_name)
+{
+	return extcon_get_cable_state_(edev, extcon_find_cable_index
+						(edev, cable_name));
+}
+EXPORT_SYMBOL_GPL(extcon_get_cable_state);
+
+/**
+ * extcon_get_cable_state_() - Set the status of a specific cable.
+ * @edev:	the extcon device that has the cable.
+ * @index:	cable index that can be retrieved by extcon_find_cable_index().
+ * @cable_state:	the new cable status. The default semantics is
+ *			true: attached / false: detached.
+ */
+int extcon_set_cable_state_(struct extcon_dev *edev,
+			int index, bool cable_state)
+{
+	u32 state;
+
+	if (index < 0 || (edev->max_supported && edev->max_supported <= index))
+		return -EINVAL;
+
+	state = cable_state ? (1 << index) : 0;
+	extcon_update_state(edev, 1 << index, state);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(extcon_set_cable_state_);
+
+/**
+ * extcon_get_cable_state() - Set the status of a specific cable.
+ * @edev:	the extcon device that has the cable.
+ * @cable_name:	cable name.
+ * @cable_state:	the new cable status. The default semantics is
+ *			true: attached / false: detached.
+ *
+ * Note that this is slower than extcon_set_cable_state_.
+ */
+int extcon_set_cable_state(struct extcon_dev *edev,
+			const char *cable_name, bool cable_state)
+{
+	return extcon_set_cable_state_(edev, extcon_find_cable_index
+					(edev, cable_name), cable_state);
+}
+EXPORT_SYMBOL_GPL(extcon_set_cable_state);
+
+/**
  * extcon_get_extcon_dev() - Get the extcon device instance from the name
  * @extcon_name:	The extcon name provided with extcon_dev_register()
  */
@@ -145,11 +335,88 @@ out:
 }
 EXPORT_SYMBOL_GPL(extcon_get_extcon_dev);
 
+static int _call_per_cable(struct notifier_block *nb, unsigned long val,
+			   void *ptr)
+{
+	struct extcon_specific_cable_nb *obj = container_of(nb,
+			struct extcon_specific_cable_nb, internal_nb);
+	struct extcon_dev *edev = ptr;
+
+	if ((val & (1 << obj->cable_index)) !=
+	    (edev->state & (1 << obj->cable_index))) {
+		obj->previous_value = val;
+		return obj->user_nb->notifier_call(nb, val, ptr);
+	}
+
+	return NOTIFY_OK;
+}
+
+/**
+ * extcon_register_interest() - Register a notifier for a state change of a
+ *			      specific cable, not a entier set of cables of a
+ *			      extcon device.
+ * @obj:	an empty extcon_specific_cable_nb object to be returned.
+ * @extcon_name:	the name of extcon device.
+ * @cable_name:		the target cable name.
+ * @nb:		the notifier block to get notified.
+ *
+ * Provide an empty extcon_specific_cable_nb. extcon_register_interest() sets
+ * the struct for you.
+ *
+ * extcon_register_interest is a helper function for those who want to get
+ * notification for a single specific cable's status change. If a user wants
+ * to get notification for any changes of all cables of a extcon device,
+ * he/she should use the general extcon_register_notifier().
+ *
+ * Note that the second parameter given to the callback of nb (val) is
+ * "old_state", not the current state. The current state can be retrieved
+ * by looking at the third pameter (edev pointer)'s state value.
+ */
+int extcon_register_interest(struct extcon_specific_cable_nb *obj,
+			     const char *extcon_name, const char *cable_name,
+			     struct notifier_block *nb)
+{
+	if (!obj || !extcon_name || !cable_name || !nb)
+		return -EINVAL;
+
+	obj->edev = extcon_get_extcon_dev(extcon_name);
+	if (!obj->edev)
+		return -ENODEV;
+
+	obj->cable_index = extcon_find_cable_index(obj->edev, cable_name);
+	if (obj->cable_index < 0)
+		return -ENODEV;
+
+	obj->user_nb = nb;
+
+	obj->internal_nb.notifier_call = _call_per_cable;
+
+	return raw_notifier_chain_register(&obj->edev->nh, &obj->internal_nb);
+}
+
+/**
+ * extcon_unregister_interest() - Unregister the notifier registered by
+ *				extcon_register_interest().
+ * @obj:	the extcon_specific_cable_nb object returned by
+ *		extcon_register_interest().
+ */
+int extcon_unregister_interest(struct extcon_specific_cable_nb *obj)
+{
+	if (!obj)
+		return -EINVAL;
+
+	return raw_notifier_chain_unregister(&obj->edev->nh, &obj->internal_nb);
+}
+
 /**
  * extcon_register_notifier() - Register a notifee to get notified by
  *			      any attach status changes from the extcon.
  * @edev:	the extcon device.
  * @nb:		a notifier block to be registered.
+ *
+ * Note that the second parameter given to the callback of nb (val) is
+ * "old_state", not the current state. The current state can be retrieved
+ * by looking at the third pameter (edev pointer)'s state value.
  */
 int extcon_register_notifier(struct extcon_dev *edev,
 			struct notifier_block *nb)
@@ -171,8 +438,9 @@ int extcon_unregister_notifier(struct extcon_dev *edev,
 EXPORT_SYMBOL_GPL(extcon_unregister_notifier);
 
 static struct device_attribute extcon_attrs[] = {
-	__ATTR_RO(state),
+	__ATTR(state, S_IRUGO | S_IWUSR, state_show, state_store),
 	__ATTR_RO(name),
+	__ATTR_NULL,
 };
 
 static int create_extcon_class(void)
@@ -231,7 +499,7 @@ static void extcon_dev_release(struct device *dev)
  */
 int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 {
-	int ret;
+	int ret, index = 0;
 
 	if (!extcon_class && !edev->use_class_name_switch) {
 		ret = create_extcon_class();
@@ -244,6 +512,20 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 			return ret;
 	}
 
+	if (edev->supported_cable) {
+		/* Get size of array */
+		for (index = 0; edev->supported_cable[index]; index++)
+			;
+		edev->max_supported = index;
+	} else {
+		edev->max_supported = 0;
+	}
+
+	if (index > SUPPORTED_CABLE_MAX) {
+		dev_err(edev->dev, "extcon: maximum number of supported cables exceeded.\n");
+		return -EINVAL;
+	}
+
 	edev->dev = kzalloc(sizeof(struct device), GFP_KERNEL);
 	edev->dev->parent = dev;
 	if (edev->use_class_name_switch)
@@ -259,6 +541,8 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 		goto err_dev;
 	}
 
+	spin_lock_init(&edev->lock);
+
 	RAW_INIT_NOTIFIER_HEAD(&edev->nh);
 
 	dev_set_drvdata(edev->dev, edev);
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 1e47e3b..898a39c 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -24,6 +24,47 @@
 #define __LINUX_EXTCON_H__
 
 #include <linux/notifier.h>
+
+#define SUPPORTED_CABLE_MAX	32
+#define CABLE_NAME_MAX		30
+
+/*
+ * The standard cable name is to help support general notifier
+ * and notifee device drivers to share the common names.
+ * Please use standard cable names unless your notifier device has
+ * a very unique and abnormal cable or
+ * the cable type is supposed to be used with only one unique
+ * pair of notifier/notifee devices.
+ *
+ * Please add any other "standard" cables used with extcon dev.
+ *
+ * You may add a dot and number to specify version or specification
+ * of the specific cable if it is required. (e.g., "Fast-charger.18"
+ * and "Fast-charger.10" for 1.8A and 1.0A chargers)
+ * However, the notifee and notifier should be able to handle such
+ * string and if the notifee can negotiate the protocol or idenify,
+ * you don't need such convention. This convention is helpful when
+ * notifier can distinguish but notifiee cannot.
+ */
+enum extcon_cable_name {
+	EXTCON_USB = 0,
+	EXTCON_USB_HOST,
+	EXTCON_TA, /* Travel Adaptor */
+	EXTCON_FAST_CHARGER,
+	EXTCON_SLOW_CHARGER,
+	EXTCON_CHARGE_DOWNSTREAM, /* Charging an external device */
+	EXTCON_HDMI,
+	EXTCON_MHL,
+	EXTCON_DVI,
+	EXTCON_VGA,
+	EXTCON_DOCK,
+	EXTCON_AUDIO_IN,
+	EXTCON_AUDIO_OUT,
+	EXTCON_VIDEO_IN,
+	EXTCON_VIDEO_OUT,
+};
+extern const char *extcon_cable_name[];
+
 /**
  * struct extcon_dev - An extcon device represents one external connector.
  * @name	The name of this extcon device. Parent device name is used
@@ -31,6 +72,9 @@
  * @use_class_name_switch	set true in order to be compatible with
  *				Android platform, which uses "switch"
  *				for the class name.
+ * @supported_cable	Array of supported cable name ending with NULL.
+ *			If supported_cable is NULL, cable name related APIs
+ *			are disabled.
  * @print_name	An optional callback to override the method to print the
  *		name of the extcon device.
  * @print_state	An optional callback to override the method to print the
@@ -41,6 +85,8 @@
  * @nh	Notifier for the state change events from this extcon
  * @entry	To support list of extcon devices so that uses can search
  *		for extcon devices based on the extcon name.
+ * @lock
+ * @max_supported	Internal value to store the number of cables.
  *
  * In most cases, users only need to provide "User initializing data" of
  * this struct when registering an extcon. In some exceptional cases,
@@ -51,6 +97,7 @@ struct extcon_dev {
 	/* --- Optional user initializing data --- */
 	const char	*name;
 	bool		use_class_name_switch;
+	const char **supported_cable;
 
 	/* --- Optional callbacks to override class functions --- */
 	ssize_t	(*print_name)(struct extcon_dev *edev, char *buf);
@@ -61,6 +108,8 @@ struct extcon_dev {
 	u32		state;
 	struct raw_notifier_head nh;
 	struct list_head entry;
+	spinlock_t lock; /* could be called by irq handler */
+	int max_supported;
 };
 
 /**
@@ -81,6 +130,21 @@ struct gpio_extcon_platform_data {
 	const char *state_off;
 };
 
+/**
+ * struct extcon_specific_cable_nb - An internal data for
+ *				extcon_register_interest().
+ * @internal_nb	a notifier block bridging extcon notifier and cable notifier.
+ * @user_nb	user provided notifier block for events from a specific cable.
+ * @cable_index	the target cable.
+ * @edev	the target extcon device.
+ */
+struct extcon_specific_cable_nb {
+	struct notifier_block internal_nb;
+	struct notifier_block *user_nb;
+	int cable_index;
+	struct extcon_dev *edev;
+};
+
 #ifdef CONFIG_EXTCON
 
 /*
@@ -91,16 +155,54 @@ extern int extcon_dev_register(struct extcon_dev *edev, struct device *dev);
 extern void extcon_dev_unregister(struct extcon_dev *edev);
 extern struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name);
 
+/*
+ * get/set/update_state access the 32b encoded state value, which represents
+ * states of all possible cables of the multistate port. For example, if one
+ * calls extcon_set_state(edev, 0x7), it may mean that all the three cables
+ * are attached to the port.
+ */
 static inline u32 extcon_get_state(struct extcon_dev *edev)
 {
 	return edev->state;
 }
 
 extern void extcon_set_state(struct extcon_dev *edev, u32 state);
+extern void extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state);
+
+/*
+ * get/set_cable_state access each bit of the 32b encoded state value.
+ * They are used to access the status of each cable based on the cable_name
+ * or cable_index, which is retrived by extcon_find_cable_index
+ */
+extern int extcon_find_cable_index(struct extcon_dev *sdev,
+				   const char *cable_name);
+extern int extcon_get_cable_state_(struct extcon_dev *edev, int cable_index);
+extern int extcon_set_cable_state_(struct extcon_dev *edev, int cable_index,
+				   bool cable_state);
+
+extern int extcon_get_cable_state(struct extcon_dev *edev,
+				  const char *cable_name);
+extern int extcon_set_cable_state(struct extcon_dev *edev,
+				  const char *cable_name, bool cable_state);
+
+/*
+ * Following APIs are for notifiees (those who want to be notified)
+ * to register a callback for events from a specific cable of the extcon.
+ * Notifiees are the connected device drivers wanting to get notified by
+ * a specific external port of a connection device.
+ */
+extern int extcon_register_interest(struct extcon_specific_cable_nb *obj,
+				    const char *extcon_name,
+				    const char *cable_name,
+				    struct notifier_block *nb);
+extern int extcon_unregister_interest(struct extcon_specific_cable_nb *nb);
 
 /*
  * Following APIs are to monitor every action of a notifier.
  * Registerer gets notified for every external port of a connection device.
+ * Probably this could be used to debug an action of notifier; however,
+ * we do not recommend to use this at normal 'notifiee' device drivers who
+ * want to be notified by a specific external port of the notifier.
  */
 extern int extcon_register_notifier(struct extcon_dev *edev,
 				    struct notifier_block *nb);
@@ -121,6 +223,41 @@ static inline u32 extcon_get_state(struct extcon_dev *edev)
 }
 
 static inline void extcon_set_state(struct extcon_dev *edev, u32 state) { }
+
+static inline void extcon_update_state(struct extcon_dev *edev, u32 mask,
+				       u32 state)
+{ }
+
+static inline int extcon_find_cable_index(struct extcon_dev *edev,
+					  const char *cable_name)
+{
+	return 0;
+}
+
+static inline int extcon_get_cable_state_(struct extcon_dev *edev,
+					  int cable_index)
+{
+	return 0;
+}
+
+static inline int extcon_set_cable_state_(struct extcon_dev *edev,
+					  int cable_index, bool cable_state)
+{
+	return 0;
+}
+
+static inline int extcon_get_cable_state(struct extcon_dev *edev,
+			const char *cable_name)
+{
+	return 0;
+}
+
+static inline int extcon_set_cable_state(struct extcon_dev *edev,
+			const char *cable_name, int state)
+{
+	return 0;
+}
+
 static inline struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name)
 {
 	return NULL;
@@ -138,5 +275,17 @@ static inline int extcon_unregister_notifier(struct extcon_dev *edev,
 	return 0;
 }
 
+static inline int extcon_register_interest(struct extcon_specific_cable_nb *obj,
+					   const char *extcon_name,
+					   const char *cable_name,
+					   struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline int extcon_unregister_interest(struct extcon_specific_cable_nb *)
+{
+	return 0;
+}
 #endif /* CONFIG_EXTCON */
 #endif /* __LINUX_EXTCON_H__ */
-- 
1.7.4.1

