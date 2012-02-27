Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2B0MQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 07:16:05 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47239 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab2B0MPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 07:15:38 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-31-4f4b73e508e9
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
Subject: [PATCH v6 4/5] Extcon: support multiple states at a device.
Date: Mon, 27 Feb 2012 21:15:38 +0900
Message-id: <1330344939-18394-5-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
References: <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
 <1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
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
Changes from V5
- Sysfs style reformed: subdirectory per cable.
- Updated standard cable names
- Removed unnecessary printf
- Bugfixes after testing

Changes from V4
- Bugfixes after more testing at Exynos4412 boards with userspace
  processses.

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
---
 Documentation/ABI/testing/sysfs-class-extcon |   63 ++++-
 drivers/extcon/extcon_class.c                |  439 +++++++++++++++++++++++++-
 include/linux/extcon.h                       |  184 +++++++++++
 3 files changed, 666 insertions(+), 20 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-extcon b/Documentation/ABI/testing/sysfs-class-extcon
index 59a4b1c..19b18e9 100644
--- a/Documentation/ABI/testing/sysfs-class-extcon
+++ b/Documentation/ABI/testing/sysfs-class-extcon
@@ -1,5 +1,5 @@
 What:		/sys/class/extcon/.../
-Date:		December 2011
+Date:		February 2012
 Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
 Description:
 		Provide a place in sysfs for the extcon objects.
@@ -7,8 +7,16 @@ Description:
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
-Date:		December 2011
+Date:		February 2012
 Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
 Description:
 		The /sys/class/extcon/.../name shows the name of the extcon
@@ -17,10 +25,51 @@ Description:
 		this sysfs node.
 
 What:		/sys/class/extcon/.../state
-Date:		December 2011
+Date:		February 2012
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		The /sys/class/extcon/.../state shows and stores the cable
+		attach/detach information of the corresponding extcon object.
+		If the extcon object has an optional callback "show_state"
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
+		In order to update the state of an extcon device, enter a hex
+		state number starting with 0x.
+		 echo 0xHEX > state
+
+		This updates the whole state of the extcon dev.
+		Inputs of all the methods are required to meet the
+		mutually_exclusive contidions if they exist.
+
+		It is recommended to use this "global" state interface if
+		you need to enter the value atomically. The later state
+		interface associated with each cable cannot update
+		multiple cable states of an extcon device simultaneously.
+
+What:		/sys/class/extcon/.../cable.x/name
+Date:		February 2012
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		The /sys/class/extcon/.../cable.x/name shows the name of cable
+		"x" (integer between 0 and 31) of an extcon device.
+
+What:		/sys/class/extcon/.../cable.x/state
+Date:		February 2012
 Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
 Description:
-		The /sys/class/extcon/.../state shows the cable attach/detach
-		information of the corresponding extcon object. If the extcon
-		objecct has an optional callback "show_state" defined, the
-		callback will provide the name with this sysfs node.
+		The /sys/class/extcon/.../cable.x/name shows and stores the
+		state of cable "x" (integer between 0 and 31) of an extcon
+		device. The state value is either 0 (detached) or 1
+		(attached).
diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
index 51b14bd..55f19c2 100644
--- a/drivers/extcon/extcon_class.c
+++ b/drivers/extcon/extcon_class.c
@@ -31,6 +31,39 @@
 #include <linux/extcon.h>
 #include <linux/slab.h>
 
+/*
+ * extcon_cable_name suggests the standard cable names for commonly used
+ * cable types.
+ *
+ * However, please do not use extcon_cable_name directly for extcon_dev
+ * struct's supported_cable pointer unless your device really supports
+ * every single port-type of the following cable names. Please choose cable
+ * names that are actually used in your extcon device.
+ */
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
+	[EXTCON_LINE_IN]	= "Line-in",
+	[EXTCON_LINE_OUT]	= "Line-out",
+	[EXTCON_MIC_IN]		= "Microphone",
+	[EXTCON_HEADPHONE_OUT]	= "Headphone",
+	[EXTCON_SPDIF_IN]	= "SPDIF-in",
+	[EXTCON_SPDIF_OUT]	= "SPDIF-out",
+	[EXTCON_VIDEO_IN]	= "Video-in",
+	[EXTCON_VIDEO_OUT]	= "Video-out",
+
+	NULL,
+};
+
 struct class *extcon_class;
 
 static LIST_HEAD(extcon_dev_list);
@@ -39,6 +72,7 @@ static DEFINE_MUTEX(extcon_dev_list_lock);
 static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
+	int i, count = 0;
 	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
 
 	if (edev->print_state) {
@@ -48,7 +82,39 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
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
+	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
+
+	ret = sscanf(buf, "0x%x", &state);
+	if (ret == 0)
+		ret = -EINVAL;
+	else
+		extcon_set_state(edev, state);
+
+	if (ret < 0)
+		return ret;
+
+	return count;
 }
 
 static ssize_t name_show(struct device *dev, struct device_attribute *attr,
@@ -66,9 +132,52 @@ static ssize_t name_show(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "%s\n", dev_name(edev->dev));
 }
 
+static ssize_t cable_name_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct extcon_cable *cable = container_of(attr, struct extcon_cable,
+						  attr_name);
+
+	return sprintf(buf, "%s\n",
+		       cable->edev->supported_cable[cable->cable_index]);
+}
+
+static ssize_t cable_state_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct extcon_cable *cable = container_of(attr, struct extcon_cable,
+						  attr_state);
+
+	return sprintf(buf, "%d\n",
+		       extcon_get_cable_state_(cable->edev,
+					       cable->cable_index));
+}
+
+static ssize_t cable_state_store(struct device *dev,
+				 struct device_attribute *attr, const char *buf,
+				 size_t count)
+{
+	struct extcon_cable *cable = container_of(attr, struct extcon_cable,
+						  attr_state);
+	int ret, state;
+
+	ret = sscanf(buf, "%d", &state);
+	if (ret == 0)
+		ret = -EINVAL;
+	else
+		ret = extcon_set_cable_state_(cable->edev, cable->cable_index,
+					      state);
+
+	if (ret < 0)
+		return ret;
+	return count;
+}
+
 /**
- * extcon_set_state() - Set the cable attach states of the extcon device.
+ * extcon_update_state() - Update the cable attach states of the extcon device
+ *			only for the masked bits.
  * @edev:	the extcon device
+ * @mask:	the bit mask to designate updated bits.
  * @state:	new cable attach status for @edev
  *
  * Changing the state sends uevent with environment variable containing
@@ -76,10 +185,10 @@ static ssize_t name_show(struct device *dev, struct device_attribute *attr,
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
@@ -87,15 +196,20 @@ void extcon_set_state(struct extcon_dev *edev, u32 state)
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
@@ -114,17 +228,132 @@ void extcon_set_state(struct extcon_dev *edev, u32 state)
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
@@ -144,11 +373,88 @@ out:
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
@@ -170,8 +476,9 @@ int extcon_unregister_notifier(struct extcon_dev *edev,
 EXPORT_SYMBOL_GPL(extcon_unregister_notifier);
 
 static struct device_attribute extcon_attrs[] = {
-	__ATTR_RO(state),
+	__ATTR(state, S_IRUGO | S_IWUSR, state_show, state_store),
 	__ATTR_RO(name),
+	__ATTR_NULL,
 };
 
 static int create_extcon_class(void)
@@ -197,6 +504,16 @@ static void extcon_cleanup(struct extcon_dev *edev, bool skip)
 	mutex_unlock(&extcon_dev_list_lock);
 
 	if (!skip && get_device(edev->dev)) {
+		int index;
+
+		for (index = 0; index < edev->max_supported; index++)
+			kfree(edev->cables[index].attr_g.name);
+
+		if (edev->max_supported) {
+			kfree(edev->extcon_dev_type.groups);
+			kfree(edev->cables);
+		}
+
 		device_unregister(edev->dev);
 		put_device(edev->dev);
 	}
@@ -211,6 +528,10 @@ static void extcon_dev_release(struct device *dev)
 	extcon_cleanup(edev, true);
 }
 
+static void dummy_sysfs_dev_release(struct device *dev)
+{
+}
+
 /**
  * extcon_dev_register() - Register a new extcon device
  * @edev	: the new extcon device (should be allocated before calling)
@@ -223,7 +544,7 @@ static void extcon_dev_release(struct device *dev)
  */
 int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 {
-	int ret;
+	int ret, index = 0;
 
 	if (!extcon_class) {
 		ret = create_extcon_class();
@@ -231,18 +552,101 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
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
 	edev->dev->class = extcon_class;
 	edev->dev->release = extcon_dev_release;
 
 	dev_set_name(edev->dev, edev->name ? edev->name : dev_name(dev));
+
+	if (edev->max_supported) {
+		char buf[10];
+		char *str;
+		struct extcon_cable *cable;
+
+		edev->cables = kzalloc(sizeof(struct extcon_cable) *
+				       edev->max_supported, GFP_KERNEL);
+		if (!edev->cables) {
+			ret = -ENOMEM;
+			goto err_sysfs_alloc;
+		}
+		for (index = 0; index < edev->max_supported; index++) {
+			cable = &edev->cables[index];
+
+			snprintf(buf, 10, "cable.%d", index);
+			str = kzalloc(sizeof(char) * (strlen(buf) + 1),
+				      GFP_KERNEL);
+			if (!str) {
+				for (index--; index >= 0; index--) {
+					cable = &edev->cables[index];
+					kfree(cable->attr_g.name);
+				}
+				ret = -ENOMEM;
+
+				goto err_alloc_cables;
+			}
+			strcpy(str, buf);
+
+			cable->edev = edev;
+			cable->cable_index = index;
+			cable->attrs[0] = &cable->attr_name.attr;
+			cable->attrs[1] = &cable->attr_state.attr;
+			cable->attrs[2] = NULL;
+			cable->attr_g.name = str;
+			cable->attr_g.attrs = cable->attrs;
+
+			cable->attr_name.attr.name = "name";
+			cable->attr_name.attr.mode = 0444;
+			cable->attr_name.show = cable_name_show;
+
+			cable->attr_state.attr.name = "state";
+			cable->attr_state.attr.mode = 0644;
+			cable->attr_state.show = cable_state_show;
+			cable->attr_state.store = cable_state_store;
+		}
+	}
+
+	if (edev->max_supported) {
+		edev->extcon_dev_type.groups =
+			kzalloc(sizeof(struct attribute_group *) *
+				(edev->max_supported + 1), GFP_KERNEL);
+		if (!edev->extcon_dev_type.groups) {
+			ret = -ENOMEM;
+			goto err_alloc_groups;
+		}
+
+		edev->extcon_dev_type.name = dev_name(edev->dev);
+		edev->extcon_dev_type.release = dummy_sysfs_dev_release;
+
+		for (index = 0; index < edev->max_supported; index++)
+			edev->extcon_dev_type.groups[index] =
+				&edev->cables[index].attr_g;
+
+		edev->dev->type = &edev->extcon_dev_type;
+	}
+
 	ret = device_register(edev->dev);
 	if (ret) {
 		put_device(edev->dev);
 		goto err_dev;
 	}
 
+	spin_lock_init(&edev->lock);
+
 	RAW_INIT_NOTIFIER_HEAD(&edev->nh);
 
 	dev_set_drvdata(edev->dev, edev);
@@ -255,6 +659,15 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 	return 0;
 
 err_dev:
+	if (edev->max_supported)
+		kfree(edev->extcon_dev_type.groups);
+err_alloc_groups:
+	for (index = 0; index < edev->max_supported; index++)
+		kfree(edev->cables[index].attr_g.name);
+err_alloc_cables:
+	if (edev->max_supported)
+		kfree(edev->cables);
+err_sysfs_alloc:
 	kfree(edev->dev);
 	return ret;
 }
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 50be845..99ff60e 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -24,10 +24,60 @@
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
+	EXTCON_LINE_IN,
+	EXTCON_LINE_OUT,
+	EXTCON_MIC_IN,
+	EXTCON_HEADPHONE_OUT,
+	EXTCON_SPDIF_IN,
+	EXTCON_SPDIF_OUT,
+	EXTCON_VIDEO_IN,
+	EXTCON_VIDEO_OUT,
+};
+extern const char *extcon_cable_name[];
+
+struct extcon_cable;
+
 /**
  * struct extcon_dev - An extcon device represents one external connector.
  * @name	The name of this extcon device. Parent device name is used
  *		if NULL.
+ * @supported_cable	Array of supported cable name ending with NULL.
+ *			If supported_cable is NULL, cable name related APIs
+ *			are disabled.
  * @print_name	An optional callback to override the method to print the
  *		name of the extcon device.
  * @print_state	An optional callback to override the method to print the
@@ -38,6 +88,11 @@
  * @nh	Notifier for the state change events from this extcon
  * @entry	To support list of extcon devices so that uses can search
  *		for extcon devices based on the extcon name.
+ * @lock
+ * @max_supported	Internal value to store the number of cables.
+ * @extcon_dev_type	Device_type struct to provide attribute_groups
+ *			customized for each extcon device.
+ * @cables	Sysfs subdirectories. Each represents one cable.
  *
  * In most cases, users only need to provide "User initializing data" of
  * this struct when registering an extcon. In some exceptional cases,
@@ -47,6 +102,7 @@
 struct extcon_dev {
 	/* --- Optional user initializing data --- */
 	const char	*name;
+	const char **supported_cable;
 
 	/* --- Optional callbacks to override class functions --- */
 	ssize_t	(*print_name)(struct extcon_dev *edev, char *buf);
@@ -57,6 +113,49 @@ struct extcon_dev {
 	u32		state;
 	struct raw_notifier_head nh;
 	struct list_head entry;
+	spinlock_t lock; /* could be called by irq handler */
+	int max_supported;
+
+	/* /sys/class/extcon/.../cable.n/... */
+	struct device_type extcon_dev_type;
+	struct extcon_cable *cables;
+};
+
+/**
+ * struct extcon_cable	- An internal data for each cable of extcon device.
+ * @edev	The extcon device
+ * @cable_index	Index of this cable in the edev
+ * @attr_g	Attribute group for the cable
+ * @attr_name	"name" sysfs entry
+ * @attr_state	"state" sysfs entry
+ * @attrs	Array pointing to attr_name and attr_state for attr_g
+ */
+struct extcon_cable {
+	struct extcon_dev *edev;
+	int cable_index;
+
+	struct attribute_group attr_g;
+	struct device_attribute attr_name;
+	struct device_attribute attr_state;
+
+	struct attribute *attrs[3]; /* to be fed to attr_g.attrs */
+};
+
+/**
+ * struct extcon_specific_cable_nb - An internal data for
+ *				extcon_register_interest().
+ * @internal_nb	a notifier block bridging extcon notifier and cable notifier.
+ * @user_nb	user provided notifier block for events from a specific cable.
+ * @cable_index	the target cable.
+ * @edev	the target extcon device.
+ * @previous_value	the saved previous event value.
+ */
+struct extcon_specific_cable_nb {
+	struct notifier_block internal_nb;
+	struct notifier_block *user_nb;
+	int cable_index;
+	struct extcon_dev *edev;
+	unsigned long previous_value;
 };
 
 #ifdef CONFIG_EXTCON
@@ -69,16 +168,54 @@ extern int extcon_dev_register(struct extcon_dev *edev, struct device *dev);
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
@@ -99,6 +236,41 @@ static inline u32 extcon_get_state(struct extcon_dev *edev)
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
@@ -116,5 +288,17 @@ static inline int extcon_unregister_notifier(struct extcon_dev *edev,
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

