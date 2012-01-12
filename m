Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab2ALTYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 14:24:44 -0500
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:44036 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab2ALTYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 14:24:43 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvRQAO8yD09V5qrvPGdsb2JhbABDiVWjNhkBAQEBNzKCIC8TAQ8YgQIKGhOHfLdCE4wKBJpujF0
X-IronPort-AV: E=Sophos;i="4.71,499,1320620400"; 
   d="scan'208";a="26298450"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chase.douglas@canonical.com>
Subject: [PATCH 2/2] Input: Add EVIOC mechanism for MT slots
Date: Thu, 12 Jan 2012 20:24:35 +0100
Message-Id: <1326396275-2492-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to extract MT slot data via a new ioctl,
EVIOCGMTSLOTS. The function returns an array of slot values for the
specified ABS_MT event type.

Example of user space usage:

struct { struct input_mt_request req; int values[64]; } data;
data.req.code = ABS_MT_POSITION_X;
if (ioctl(fd, EVIOCGMTSLOTS(sizeof(data)), &data) < 0)
	return -1;
for (i = 0; i < data.req.num_values; i++)
	printf("slot %d: %d\n", i, data.values[i]);

Cc: Chase Douglas <chase.douglas@canonical.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Dmitry,

This is a new take on the MT slot ioctl patch. A new ioctl is added,
which takes a request structure and returns a (variable) array of slot
values. The patch seems to work, but testing has not been extensive (yet).

Cheers,
Henrik

 drivers/input/evdev.c |   30 +++++++++++++++++++++++++++++-
 include/linux/input.h |   25 +++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 4cf2534..8bf45d4 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -20,7 +20,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/input.h>
+#include <linux/input/mt.h>
 #include <linux/major.h>
 #include <linux/device.h>
 #include "input-compat.h"
@@ -621,6 +621,31 @@ static int evdev_handle_set_keycode_v2(struct input_dev *dev, void __user *p)
 	return input_set_keycode(dev, &ke);
 }
 
+static int evdev_handle_mt_request(struct input_dev *dev,
+				   unsigned int size,
+				   int __user *ip)
+{
+	const struct input_mt_slot *mt = dev->mt;
+	unsigned int code;
+	int i;
+
+	if (get_user(code, &ip[0]))
+		return -EFAULT;
+	if (!input_is_mt_value(code))
+		return -EINVAL;
+
+	if (size < sizeof(struct input_mt_request) + dev->mtsize * sizeof(int))
+		return -EINVAL;
+
+	if (put_user(dev->mtsize, &ip[1]))
+		return -EFAULT;
+	for (i = 0; i < dev->mtsize; i++)
+		if (put_user(input_mt_get_value(&mt[i], code), &ip[2 + i]))
+			return -EFAULT;
+
+	return 0;
+}
+
 static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 			   void __user *p, int compat_mode)
 {
@@ -706,6 +731,9 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 		return bits_to_user(dev->propbit, INPUT_PROP_MAX,
 				    size, p, compat_mode);
 
+	case EVIOCGMTSLOTS(0):
+		return evdev_handle_mt_request(dev, size, ip);
+
 	case EVIOCGKEY(0):
 		return bits_to_user(dev->key, KEY_MAX, size, p, compat_mode);
 
diff --git a/include/linux/input.h b/include/linux/input.h
index a637e78..9a73f18 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -99,6 +99,30 @@ struct input_keymap_entry {
 	__u8  scancode[32];
 };
 
+/**
+ * struct input_mt_request - used by EVIOCGMTSLOTS ioctl
+ * @code: ABS_MT code to read
+ * @num_values: number of values written to the value array
+ * @values: value array, one value per slot
+ *
+ * The structure is used to retrieve MT slot data. Before the call,
+ * code is set to the wanted ABS_MT event type. On return, the value
+ * array is filled with the slot values for the specified ABS_MT code,
+ * and num_values is set to the actual number of slots.
+ *
+ * The call argument (len) is the size of the return buffer, satisfying
+ *
+ * len >= sizeof(input_mt_request) + sizeof(__s32) * number_of_slots
+ *
+ * If the request code is not an ABS_MT value, or if len is too small,
+ * -EINVAL is returned.
+ */
+struct input_mt_request {
+	__u32 code;
+	__u32 num_values;
+	__s32 values[];
+};
+
 #define EVIOCGVERSION		_IOR('E', 0x01, int)			/* get driver version */
 #define EVIOCGID		_IOR('E', 0x02, struct input_id)	/* get device ID */
 #define EVIOCGREP		_IOR('E', 0x03, unsigned int[2])	/* get repeat settings */
@@ -113,6 +137,7 @@ struct input_keymap_entry {
 #define EVIOCGPHYS(len)		_IOC(_IOC_READ, 'E', 0x07, len)		/* get physical location */
 #define EVIOCGUNIQ(len)		_IOC(_IOC_READ, 'E', 0x08, len)		/* get unique identifier */
 #define EVIOCGPROP(len)		_IOC(_IOC_READ, 'E', 0x09, len)		/* get device properties */
+#define EVIOCGMTSLOTS(len)	_IOC(_IOC_READ, 'E', 0x0a, len)		/* get MT slot values */
 
 #define EVIOCGKEY(len)		_IOC(_IOC_READ, 'E', 0x18, len)		/* get global key state */
 #define EVIOCGLED(len)		_IOC(_IOC_READ, 'E', 0x19, len)		/* get all LEDs */
-- 
1.7.8.1

