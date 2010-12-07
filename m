Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab0LGH0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 02:26:14 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:55166 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198Ab0LGH0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 02:26:12 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>
Subject: [RFC][PATCH] input: Introduce device information ioctl
Date: Tue,  7 Dec 2010 08:25:26 +0100
Message-Id: <1291706726-8835-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PPrvk-0005lb-CV.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PPrvk-0005lb-CV 5d19685c8120a9261a9e00c2d98a2bb8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today, userspace sets up an input device based on the data it emits.
This is not always enough; a tablet and a touchscreen may emit exactly
the same data, for instance, but the former should be set up with a
pointer whereas the latter does not need to. Recently, a new type of
touchpad has emerged where the buttons are under the pad, which changes
handling logic without changing the emitted data. This patch introduces
a new ioctl, EVIOCGDEVINFO, which allows userspace to extract information
about the device resulting in proper setup.

Suggested-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Ping Cheng <pingc@wacom.com>
Cc: Chris Bagwell <chris@cnpbagwell.com>
---
Hi all,

Here is a patch attempting to formulate Dmitry's device type idea. It
compiles, but further testing awaits a general consesus on the device
types and capabilities to start out with. Are the ones listed here apt
for the job?

Cheers,
Henrik

 drivers/input/evdev.c |    6 ++++++
 include/linux/input.h |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index e3f7fc6..db78592 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -632,6 +632,12 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 			return -EFAULT;
 		return 0;
 
+	case EVIOCGDEVINFO:
+		if (copy_to_user(p, &dev->devinfo,
+				 sizeof(struct input_devinfo)))
+			return -EFAULT;
+		return 0;
+
 	case EVIOCGREP:
 		if (!test_bit(EV_REP, dev->evbit))
 			return -ENOSYS;
diff --git a/include/linux/input.h b/include/linux/input.h
index 6ef4446..8c58d2a 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -57,6 +57,21 @@ struct input_absinfo {
 };
 
 /**
+ * struct input_devinfo - device information via EVIOCGDEVINFO ioctl
+ * @types: bitmask of types (DEVTYPE_*) matching this device
+ * @capabilities: bitmask of capabilities (DEVCAPS_*) of this device
+ *
+ * This struct provides information about the device needed for
+ * automatic setup in userspace, such as if the device is direct
+ * (touchscreen) or indirect (touchpad), and if there are other
+ * special considerations, such as the touchpad also being a button.
+ */
+struct input_devinfo {
+	__u32 types;
+	__u32 capabilities;
+};
+
+/**
  * struct input_keymap_entry - used by EVIOCGKEYCODE/EVIOCSKEYCODE ioctls
  * @scancode: scancode represented in machine-endian form.
  * @len: length of the scancode that resides in @scancode buffer.
@@ -91,6 +106,7 @@ struct input_keymap_entry {
 #define EVIOCGNAME(len)		_IOC(_IOC_READ, 'E', 0x06, len)		/* get device name */
 #define EVIOCGPHYS(len)		_IOC(_IOC_READ, 'E', 0x07, len)		/* get physical location */
 #define EVIOCGUNIQ(len)		_IOC(_IOC_READ, 'E', 0x08, len)		/* get unique identifier */
+#define EVIOCGDEVINFO		_IOR('E', 0x09, struct input_devinfo)	/* get device information */
 
 #define EVIOCGKEY(len)		_IOC(_IOC_READ, 'E', 0x18, len)		/* get global key state */
 #define EVIOCGLED(len)		_IOC(_IOC_READ, 'E', 0x19, len)		/* get all LEDs */
@@ -108,6 +124,23 @@ struct input_keymap_entry {
 #define EVIOCGRAB		_IOW('E', 0x90, int)			/* Grab/Release device */
 
 /*
+ * Device types
+ */
+
+#define DEVTYPE_KEYBOARD	0
+#define DEVTYPE_MOUSE		1
+#define DEVTYPE_JOYSTICK	2
+#define DEVTYPE_TOUCHPAD	3
+#define DEVTYPE_TABLET		4
+#define DEVTYPE_TOUCHSCREEN	5
+
+/*
+ * Device capabilities
+ */
+
+#define DEVCAPS_PAD_IS_BUTTON	1
+
+/*
  * Event types
  */
 
@@ -1177,6 +1210,7 @@ struct input_dev {
 	const char *phys;
 	const char *uniq;
 	struct input_id id;
+	struct input_devinfo devinfo;
 
 	unsigned long evbit[BITS_TO_LONGS(EV_CNT)];
 	unsigned long keybit[BITS_TO_LONGS(KEY_CNT)];
-- 
1.7.1

