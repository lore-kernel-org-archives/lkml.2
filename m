Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab2B0MQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 07:16:41 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58520 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab2B0MPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 07:15:35 -0500
X-AuditID: cbfee61b-b7c62ae000000989-7c-4f4b73e5b216
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
Subject: [PATCH v6 5/5] Extcon: support mutually exclusive relation between
 cables.
Date: Mon, 27 Feb 2012 21:15:39 +0900
Message-id: <1330344939-18394-6-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
References: <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
 <1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There could be cables that t recannot be attaches simulatenously. Extcon
device drivers may express such information via mutually_exclusive in
struct extcon_dev.

For example, for an extcon device with 16 cables (bits 0 to 15 are
available), if mutually_exclusive = { 0x7, 0xC0, 0x81, 0 }, then, the
following attachments are prohibitted.
{0, 1}
{0, 2}
{1, 2}
{6, 7}
{0, 7}
and every attachment set that are superset of one of the above.
For the detail, please refer to linux/include/linux/extcon.h.

The concept is suggested by NeilBrown <neilb@suse.de>

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

--
Changes from V5:
- Updated sysfs format
---
 Documentation/ABI/testing/sysfs-class-extcon |   22 +++++
 drivers/extcon/extcon_class.c                |  123 ++++++++++++++++++++++++--
 include/linux/extcon.h                       |   28 +++++-
 3 files changed, 160 insertions(+), 13 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-extcon b/Documentation/ABI/testing/sysfs-class-extcon
index 19b18e9..20ab361 100644
--- a/Documentation/ABI/testing/sysfs-class-extcon
+++ b/Documentation/ABI/testing/sysfs-class-extcon
@@ -15,6 +15,10 @@ Description:
 		may have both HDMI and Charger attached, or analog audio,
 		video, and USB cables attached simulteneously.
 
+		If there are cables mutually exclusive with each other,
+		such binary relations may be expressed with extcon_dev's
+		mutually_exclusive array.
+
 What:		/sys/class/extcon/.../name
 Date:		February 2012
 Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
@@ -73,3 +77,21 @@ Description:
 		state of cable "x" (integer between 0 and 31) of an extcon
 		device. The state value is either 0 (detached) or 1
 		(attached).
+
+What:		/sys/class/extcon/.../mutually_exclusive/...
+Date:		December 2011
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		Shows the relations of mutually exclusiveness. For example,
+		if the mutually_exclusive array of extcon_dev is
+		{0x3, 0x5, 0xC, 0x0}, the, the output is:
+		# ls mutually_exclusive/
+		0x3
+		0x5
+		0xc
+		#
+
+		Note that mutually_exclusive is a sub-directory of the extcon
+		device and the file names under the mutually_exclusive
+		directory show the mutually-exclusive sets, not the contents
+		of the files.
diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
index 55f19c2..fb8d3a4 100644
--- a/drivers/extcon/extcon_class.c
+++ b/drivers/extcon/extcon_class.c
@@ -69,6 +69,39 @@ struct class *extcon_class;
 static LIST_HEAD(extcon_dev_list);
 static DEFINE_MUTEX(extcon_dev_list_lock);
 
+/**
+ * check_mutually_exclusive - Check if new_state violates mutually_exclusive
+ *			    condition.
+ * @edev:	the extcon device
+ * @new_state:	new cable attach status for @edev
+ *
+ * Returns 0 if nothing violates. Returns the index + 1 for the first
+ * violated condition.
+ */
+static int check_mutually_exclusive(struct extcon_dev *edev, u32 new_state)
+{
+	int i = 0;
+
+	if (!edev->mutually_exclusive)
+		return 0;
+
+	for (i = 0; edev->mutually_exclusive[i]; i++) {
+		int count = 0, j;
+		u32 correspondants = new_state & edev->mutually_exclusive[i];
+		u32 exp = 1;
+
+		for (j = 0; j < 32; j++) {
+			if (exp & correspondants)
+				count++;
+			if (count > 1)
+				return i + 1;
+			exp <<= 1;
+		}
+	}
+
+	return 0;
+}
+
 static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
@@ -97,7 +130,7 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
-void extcon_set_state(struct extcon_dev *edev, u32 state);
+int extcon_set_state(struct extcon_dev *edev, u32 state);
 static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
@@ -109,7 +142,7 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 	if (ret == 0)
 		ret = -EINVAL;
 	else
-		extcon_set_state(edev, state);
+		ret = extcon_set_state(edev, state);
 
 	if (ret < 0)
 		return ret;
@@ -188,7 +221,7 @@ static ssize_t cable_state_store(struct device *dev,
  * Note that the notifier provides which bits are changed in the state
  * variable with the val parameter (second) to the callback.
  */
-void extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
+int extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
 {
 	char name_buf[120];
 	char state_buf[120];
@@ -203,6 +236,12 @@ void extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
 	if (edev->state != ((edev->state & ~mask) | (state & mask))) {
 		u32 old_state = edev->state;
 
+		if (check_mutually_exclusive(edev, (edev->state & ~mask) |
+						   (state & mask))) {
+			spin_unlock_irqrestore(&edev->lock, flags);
+			return -EPERM;
+		}
+
 		edev->state &= ~mask;
 		edev->state |= state & mask;
 
@@ -244,6 +283,8 @@ void extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
 		/* No changes */
 		spin_unlock_irqrestore(&edev->lock, flags);
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(extcon_update_state);
 
@@ -255,9 +296,9 @@ EXPORT_SYMBOL_GPL(extcon_update_state);
  * Note that notifier provides which bits are changed in the state
  * variable with the val parameter (second) to the callback.
  */
-void extcon_set_state(struct extcon_dev *edev, u32 state)
+int extcon_set_state(struct extcon_dev *edev, u32 state)
 {
-	extcon_update_state(edev, 0xffffffff, state);
+	return extcon_update_state(edev, 0xffffffff, state);
 }
 EXPORT_SYMBOL_GPL(extcon_set_state);
 
@@ -331,8 +372,7 @@ int extcon_set_cable_state_(struct extcon_dev *edev,
 		return -EINVAL;
 
 	state = cable_state ? (1 << index) : 0;
-	extcon_update_state(edev, 1 << index, state);
-	return 0;
+	return extcon_update_state(edev, 1 << index, state);
 }
 EXPORT_SYMBOL_GPL(extcon_set_cable_state_);
 
@@ -506,6 +546,14 @@ static void extcon_cleanup(struct extcon_dev *edev, bool skip)
 	if (!skip && get_device(edev->dev)) {
 		int index;
 
+		if (edev->mutually_exclusive && edev->max_supported) {
+			for (index = 0; edev->mutually_exclusive[index];
+			     index++)
+				kfree(edev->d_attrs_muex[index].attr.name);
+			kfree(edev->d_attrs_muex);
+			kfree(edev->attrs_muex);
+		}
+
 		for (index = 0; index < edev->max_supported; index++)
 			kfree(edev->cables[index].attr_g.name);
 
@@ -528,6 +576,7 @@ static void extcon_dev_release(struct device *dev)
 	extcon_cleanup(edev, true);
 }
 
+static const char *muex_name = "mutually_exclusive";
 static void dummy_sysfs_dev_release(struct device *dev)
 {
 }
@@ -620,10 +669,58 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 		}
 	}
 
+	if (edev->max_supported && edev->mutually_exclusive) {
+		char buf[80];
+		char *name;
+
+		/* Count the size of mutually_exclusive array */
+		for (index = 0; edev->mutually_exclusive[index]; index++)
+			;
+
+		edev->attrs_muex = kzalloc(sizeof(struct attribute *) *
+					   (index + 1), GFP_KERNEL);
+		if (!edev->attrs_muex) {
+			ret = -ENOMEM;
+			goto err_muex;
+		}
+
+		edev->d_attrs_muex = kzalloc(sizeof(struct device_attribute) *
+					     index, GFP_KERNEL);
+		if (!edev->d_attrs_muex) {
+			ret = -ENOMEM;
+			kfree(edev->attrs_muex);
+			goto err_muex;
+		}
+
+		for (index = 0; edev->mutually_exclusive[index]; index++) {
+			sprintf(buf, "0x%x", edev->mutually_exclusive[index]);
+			name = kzalloc(sizeof(char) * (strlen(buf) + 1),
+				       GFP_KERNEL);
+			if (!name) {
+				for (index--; index >= 0; index--) {
+					kfree(edev->d_attrs_muex[index].attr.
+					      name);
+				}
+				kfree(edev->d_attrs_muex);
+				kfree(edev->attrs_muex);
+				ret = -ENOMEM;
+				goto err_muex;
+			}
+			strcpy(name, buf);
+			edev->d_attrs_muex[index].attr.name = name;
+			edev->d_attrs_muex[index].attr.mode = 0000;
+			edev->attrs_muex[index] = &edev->d_attrs_muex[index]
+							.attr;
+		}
+		edev->attr_g_muex.name = muex_name;
+		edev->attr_g_muex.attrs = edev->attrs_muex;
+
+	}
+
 	if (edev->max_supported) {
 		edev->extcon_dev_type.groups =
 			kzalloc(sizeof(struct attribute_group *) *
-				(edev->max_supported + 1), GFP_KERNEL);
+				(edev->max_supported + 2), GFP_KERNEL);
 		if (!edev->extcon_dev_type.groups) {
 			ret = -ENOMEM;
 			goto err_alloc_groups;
@@ -635,6 +732,9 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 		for (index = 0; index < edev->max_supported; index++)
 			edev->extcon_dev_type.groups[index] =
 				&edev->cables[index].attr_g;
+		if (edev->mutually_exclusive)
+			edev->extcon_dev_type.groups[index] =
+				&edev->attr_g_muex;
 
 		edev->dev->type = &edev->extcon_dev_type;
 	}
@@ -662,6 +762,13 @@ err_dev:
 	if (edev->max_supported)
 		kfree(edev->extcon_dev_type.groups);
 err_alloc_groups:
+	if (edev->max_supported && edev->mutually_exclusive) {
+		for (index = 0; edev->mutually_exclusive[index]; index++)
+			kfree(edev->d_attrs_muex[index].attr.name);
+		kfree(edev->d_attrs_muex);
+		kfree(edev->attrs_muex);
+	}
+err_muex:
 	for (index = 0; index < edev->max_supported; index++)
 		kfree(edev->cables[index].attr_g.name);
 err_alloc_cables:
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 99ff60e..c9e2de8 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -78,6 +78,14 @@ struct extcon_cable;
  * @supported_cable	Array of supported cable name ending with NULL.
  *			If supported_cable is NULL, cable name related APIs
  *			are disabled.
+ * @mutually_exclusive	Array of mutually exclusive set of cables that cannot
+ *			be attached simultaneously. The array should be
+ *			ending with NULL or be NULL (no mutually exclusive
+ *			cables). For example, if it is { 0x7, 0x30, 0}, then,
+ *			{0, 1}, {0, 1, 2}, {0, 2}, {1, 2}, or {4, 5} cannot
+ *			be attached simulataneously. {0x7, 0} is equivalent to
+ *			{0x3, 0x6, 0x5, 0}. If it is {0xFFFFFFFF, 0}, there
+ *			can be no simultaneous connections.
  * @print_name	An optional callback to override the method to print the
  *		name of the extcon device.
  * @print_state	An optional callback to override the method to print the
@@ -103,6 +111,7 @@ struct extcon_dev {
 	/* --- Optional user initializing data --- */
 	const char	*name;
 	const char **supported_cable;
+	const u32	*mutually_exclusive;
 
 	/* --- Optional callbacks to override class functions --- */
 	ssize_t	(*print_name)(struct extcon_dev *edev, char *buf);
@@ -119,6 +128,10 @@ struct extcon_dev {
 	/* /sys/class/extcon/.../cable.n/... */
 	struct device_type extcon_dev_type;
 	struct extcon_cable *cables;
+	/* /sys/class/extcon/.../mutually_exclusive/... */
+	struct attribute_group attr_g_muex;
+	struct attribute **attrs_muex;
+	struct device_attribute *d_attrs_muex;
 };
 
 /**
@@ -179,8 +192,8 @@ static inline u32 extcon_get_state(struct extcon_dev *edev)
 	return edev->state;
 }
 
-extern void extcon_set_state(struct extcon_dev *edev, u32 state);
-extern void extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state);
+extern int extcon_set_state(struct extcon_dev *edev, u32 state);
+extern int extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state);
 
 /*
  * get/set_cable_state access each bit of the 32b encoded state value.
@@ -235,11 +248,16 @@ static inline u32 extcon_get_state(struct extcon_dev *edev)
 	return 0;
 }
 
-static inline void extcon_set_state(struct extcon_dev *edev, u32 state) { }
+static inline int extcon_set_state(struct extcon_dev *edev, u32 state)
+{
+	return 0;
+}
 
-static inline void extcon_update_state(struct extcon_dev *edev, u32 mask,
+static inline int extcon_update_state(struct extcon_dev *edev, u32 mask,
 				       u32 state)
-{ }
+{
+	return 0;
+}
 
 static inline int extcon_find_cable_index(struct extcon_dev *edev,
 					  const char *cable_name)
-- 
1.7.4.1

