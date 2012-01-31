Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab2AaS70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 13:59:26 -0500
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:35291 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab2AaS7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 13:59:24 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjJNAAA5KE9V5qrvPGdsb2JhbABDiVKlDRkBAQEBHhkNJYIgLxMBDxiBAgoaE4d/uQkTiykGAQQBAQkEFAcED4MtB4EFg0sEmwaMbw
X-IronPort-AV: E=Sophos;i="4.71,597,1320620400"; 
   d="scan'208";a="259522895"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH v3] Input: Add EVIOC mechanism for MT slots
Date: Tue, 31 Jan 2012 20:00:03 +0100
Message-Id: <1328036403-2827-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to extract MT slot data via a new ioctl,
EVIOCGMTSLOTS. The function returns an array of slot values for the
specified ABS_MT event type.

Example of user space usage:

struct INPUT_MT_REQUEST(64) req;
req.code = ABS_MT_POSITION_X;
if (ioctl(fd, EVIOCGMTSLOTS(sizeof(req)), &req) < 0)
	return -1;
for (i = 0; i < 64; i++)
	printf("slot %d: %d\n", i, req.values[i]);

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Dmitry,

Here is v3 of the EVIOC patch for MT slots. The number of slots if
gone, the struct is simplified, targeting userland, and calling the
ioctl with a smaller struct will return the first set of slots.

Cheers,
Henrik


 drivers/input/evdev.c |   27 ++++++++++++++++++++++++++-
 include/linux/input.h |   23 +++++++++++++++++++++++
 2 files changed, 49 insertions(+), 1 deletions(-)

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
index 3862e32..1e7e2e5 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -99,6 +99,28 @@ struct input_keymap_entry {
 	__u8  scancode[32];
 };
 
+/**
+ * struct INPUT_MT_REQUEST(num_slots) - used by EVIOCGMTSLOTS ioctl
+ * @code: ABS_MT code to read
+ * @values: value array, one value per slot
+ *
+ * The struct definition is used to create an appropriate MT slot message
+ * buffer in userland. Before the call, code is set to the wanted ABS_MT
+ * event type. On return, the value array is filled with the slot values
+ * for the specified ABS_MT code.
+ *
+ * The call argument (len) is the size of the return buffer, which should
+ * satisfy len >= sizeof(struct INPUT_MT_REQUEST(num_slots)).  If len is
+ * too small to fit all available slots, the first num_slots are returned.
+ *
+ * If the request code is not an ABS_MT value, -EINVAL is returned.
+ */
+#define INPUT_MT_REQUEST(num_slots)					\
+	{								\
+		__u32 code;						\
+		__s32 values[num_slots];				\
+	}
+
 #define EVIOCGVERSION		_IOR('E', 0x01, int)			/* get driver version */
 #define EVIOCGID		_IOR('E', 0x02, struct input_id)	/* get device ID */
 #define EVIOCGREP		_IOR('E', 0x03, unsigned int[2])	/* get repeat settings */
@@ -113,6 +135,7 @@ struct input_keymap_entry {
 #define EVIOCGPHYS(len)		_IOC(_IOC_READ, 'E', 0x07, len)		/* get physical location */
 #define EVIOCGUNIQ(len)		_IOC(_IOC_READ, 'E', 0x08, len)		/* get unique identifier */
 #define EVIOCGPROP(len)		_IOC(_IOC_READ, 'E', 0x09, len)		/* get device properties */
+#define EVIOCGMTSLOTS(len)	_IOC(_IOC_READ, 'E', 0x0a, len)		/* get MT slot values */
 
 #define EVIOCGKEY(len)		_IOC(_IOC_READ, 'E', 0x18, len)		/* get global key state */
 #define EVIOCGLED(len)		_IOC(_IOC_READ, 'E', 0x19, len)		/* get all LEDs */
-- 
1.7.9

