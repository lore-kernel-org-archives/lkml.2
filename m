Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab2ATBCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 20:02:35 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:24624 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab2ATBCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 20:02:05 -0500
X-AuditID: cbfee61b-b7be3ae0000039aa-c0-4f18bd0af6c6
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
Subject: [PATCH v4 4/4] Extcon: support mutually exclusive relation between
 cables.
Date: Fri, 20 Jan 2012 10:01:57 +0900
Message-id: <1327021317-10222-5-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
References: <1326275202-27401-1-git-send-email-myungjoo.ham@samsung.com>
 <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There could be cables that cannot be attaches simulatenously. Extcon
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
---
 Documentation/ABI/testing/sysfs-class-extcon |   19 +++++++
 drivers/extcon/extcon_class.c                |   70 +++++++++++++++++++++++---
 include/linux/extcon.h                       |   24 +++++++--
 3 files changed, 101 insertions(+), 12 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-extcon b/Documentation/ABI/testing/sysfs-class-extcon
index 31bb609..5e5f9a9 100644
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
 Date:		December 2011
 Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
@@ -54,3 +58,18 @@ Description:
 		Method 1 updates the state (0 or 1) of the
 		corresponding cable (either the name or index of the cable).
 		Method 2 updates the whole state of the extcon dev.
+		Inputs of all the methods are required to meet the
+		mutually_exclusive contidions if they exist.
+
+What:		/sys/class/extcon/.../mutually_exclusive
+Date:		December 2011
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		Shows the relations of mutually exclusiveness. For example,
+		if the mutually_exclusive array of extcon_dev is
+		{0x3, 0x5, 0xC, 0x0}, the, the output is:
+		# cat mutually_exclusive
+		0x3
+		0x5
+		0xC
+		#
diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
index 2803bd0..768b70a 100644
--- a/drivers/extcon/extcon_class.c
+++ b/drivers/extcon/extcon_class.c
@@ -56,6 +56,39 @@ struct class *extcon_class_for_android;
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
@@ -84,7 +117,7 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
-void extcon_set_state(struct extcon_dev *edev, u32 state);
+int extcon_set_state(struct extcon_dev *edev, u32 state);
 static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
@@ -111,7 +144,7 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 		if (ret == 0)
 			ret = -EINVAL;
 		else
-			extcon_set_state(edev, state);
+			ret = extcon_set_state(edev, state);
 	} else {
 		ret = -EINVAL;
 	}
@@ -135,6 +168,23 @@ static ssize_t name_show(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "%s\n", dev_name(edev->dev));
 }
 
+static ssize_t mutually_exclusive_show(struct device *dev,
+				       struct device_attribute *attr, char *buf)
+{
+	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
+	int i;
+	int count = 0;
+
+	if (!edev->mutually_exclusive || !edev->mutually_exclusive[0])
+		return sprintf(buf, "No cables are mutually exclusive.\n");
+
+	for (i = 0; edev->mutually_exclusive[i]; i++)
+		count += sprintf(buf + count, "0x%x\n",
+				 edev->mutually_exclusive[i]);
+
+	return count;
+}
+
 /**
  * extcon_update_state() - Update the cable attach states of the extcon device
  *			only for the masked bits.
@@ -150,7 +200,7 @@ static ssize_t name_show(struct device *dev, struct device_attribute *attr,
  * Note that the notifier provides which bits are changed in the state
  * variable with the val parameter (second) to the callback.
  */
-void extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
+int extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
 {
 	char name_buf[120];
 	char state_buf[120];
@@ -165,6 +215,10 @@ void extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
 	if (edev->state != ((edev->state & ~mask) | (state & mask))) {
 		u32 old_state = edev->state;
 
+		if (check_mutually_exclusive(edev, (edev->state & ~mask) |
+						   (state & mask)))
+			return -EPERM;
+
 		edev->state &= ~mask;
 		edev->state |= state & mask;
 
@@ -206,6 +260,8 @@ void extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
 		/* No changes */
 		spin_unlock_irqrestore(&edev->lock, flags);
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(extcon_update_state);
 
@@ -217,9 +273,9 @@ EXPORT_SYMBOL_GPL(extcon_update_state);
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
 
@@ -293,8 +349,7 @@ int extcon_set_cable_state_(struct extcon_dev *edev,
 		return -EINVAL;
 
 	state = cable_state ? (1 << index) : 0;
-	extcon_update_state(edev, 1 << index, state);
-	return 0;
+	return extcon_update_state(edev, 1 << index, state);
 }
 EXPORT_SYMBOL_GPL(extcon_set_cable_state_);
 
@@ -440,6 +495,7 @@ EXPORT_SYMBOL_GPL(extcon_unregister_notifier);
 static struct device_attribute extcon_attrs[] = {
 	__ATTR(state, S_IRUGO | S_IWUSR, state_show, state_store),
 	__ATTR_RO(name),
+	__ATTR_RO(mutually_exclusive),
 	__ATTR_NULL,
 };
 
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 898a39c..d9a434b 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -75,6 +75,14 @@ extern const char *extcon_cable_name[];
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
@@ -98,6 +106,7 @@ struct extcon_dev {
 	const char	*name;
 	bool		use_class_name_switch;
 	const char **supported_cable;
+	const u32	*mutually_exclusive;
 
 	/* --- Optional callbacks to override class functions --- */
 	ssize_t	(*print_name)(struct extcon_dev *edev, char *buf);
@@ -166,8 +175,8 @@ static inline u32 extcon_get_state(struct extcon_dev *edev)
 	return edev->state;
 }
 
-extern void extcon_set_state(struct extcon_dev *edev, u32 state);
-extern void extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state);
+extern int extcon_set_state(struct extcon_dev *edev, u32 state);
+extern int extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state);
 
 /*
  * get/set_cable_state access each bit of the 32b encoded state value.
@@ -222,11 +231,16 @@ static inline u32 extcon_get_state(struct extcon_dev *edev)
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

