Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab2BFIEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 03:04:30 -0500
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:43601 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab2BFIE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 03:04:29 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhhTAFuIL09V5qrvPGdsb2JhbABDiVKlZhkBAQEBNzKCIC8TAQ8YgQIKGhOHf7h7E4t8BgEEAQEJBBQHBA+DLQeBBYNLBJsPjHU
X-IronPort-AV: E=Sophos;i="4.73,369,1325458800"; 
   d="scan'208";a="39968738"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: chasedouglas@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH v4] Input: Add EVIOC mechanism for MT slots
Date: Mon,  6 Feb 2012 09:05:42 +0100
Message-Id: <1328515542-3779-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to extract MT slot data via a new ioctl,
EVIOCGMTSLOTS. The function returns an array of slot values for the
specified ABS_MT event type.

Example of user space usage:

struct { unsigned code; int values[64]; } req;
req.code = ABS_MT_POSITION_X;
if (ioctl(fd, EVIOCGMTSLOTS(sizeof(req)), &req) < 0)
	return -1;
for (i = 0; i < 64; i++)
	printf("slot %d: %d\n", i, req.values[i]);

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Here is the fourth version of the patch.

Rather than over-specifying the ioctl binary format by introducing a
struct object that does not fit everyone, this version simply leaves
all object definitions to userland.

Thanks,
Henrik

 drivers/input/evdev.c |   27 ++++++++++++++++++++++++++-
 include/linux/input.h |   25 +++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 76457d5..e4cad16 100644
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
@@ -623,6 +623,28 @@ static int evdev_handle_set_keycode_v2(struct input_dev *dev, void __user *p)
 	return input_set_keycode(dev, &ke);
 }
 
+static int evdev_handle_mt_request(struct input_dev *dev,
+				   unsigned int size,
+				   int __user *ip)
+{
+	const struct input_mt_slot *mt = dev->mt;
+	unsigned int code;
+	int max_slots;
+	int i;
+
+	if (get_user(code, &ip[0]))
+		return -EFAULT;
+	if (!input_is_mt_value(code))
+		return -EINVAL;
+
+	max_slots = (size - sizeof(__u32)) / sizeof(__s32);
+	for (i = 0; i < dev->mtsize && i < max_slots; i++)
+		if (put_user(input_mt_get_value(&mt[i], code), &ip[1 + i]))
+			return -EFAULT;
+
+	return 0;
+}
+
 static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 			   void __user *p, int compat_mode)
 {
@@ -708,6 +730,9 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 		return bits_to_user(dev->propbit, INPUT_PROP_MAX,
 				    size, p, compat_mode);
 
+	case EVIOCGMTSLOTS(0):
+		return evdev_handle_mt_request(dev, size, ip);
+
 	case EVIOCGKEY(0):
 		return bits_to_user(dev->key, KEY_MAX, size, p, compat_mode);
 
diff --git a/include/linux/input.h b/include/linux/input.h
index 3862e32..af26443 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -114,6 +114,31 @@ struct input_keymap_entry {
 #define EVIOCGUNIQ(len)		_IOC(_IOC_READ, 'E', 0x08, len)		/* get unique identifier */
 #define EVIOCGPROP(len)		_IOC(_IOC_READ, 'E', 0x09, len)		/* get device properties */
 
+/**
+ * EVIOCGMTSLOTS(len) - get MT slot values
+ *
+ * The ioctl buffer argument should be binary equivalent to
+ *
+ * struct input_mt_request_layout {
+ *	__u32 code;
+ *	__s32 values[num_slots];
+ * };
+ *
+ * where num_slots is the (arbitrary) number of MT slots to extract.
+ *
+ * The ioctl size argument (len) is the size of the buffer, which
+ * should satisfy len = (num_slots + 1) * sizeof(__s32).  If len is
+ * too small to fit all available slots, the first num_slots are
+ * returned.
+ *
+ * Before the call, code is set to the wanted ABS_MT event type. On
+ * return, values[] is filled with the slot values for the specified
+ * ABS_MT code.
+ *
+ * If the request code is not an ABS_MT value, -EINVAL is returned.
+ */
+#define EVIOCGMTSLOTS(len)	_IOC(_IOC_READ, 'E', 0x0a, len)
+
 #define EVIOCGKEY(len)		_IOC(_IOC_READ, 'E', 0x18, len)		/* get global key state */
 #define EVIOCGLED(len)		_IOC(_IOC_READ, 'E', 0x19, len)		/* get all LEDs */
 #define EVIOCGSND(len)		_IOC(_IOC_READ, 'E', 0x1a, len)		/* get all sounds status */
-- 
1.7.9

