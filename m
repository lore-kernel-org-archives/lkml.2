Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0K2HNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 02:13:49 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:48261 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752880Ab0K2HNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 02:13:48 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/4] input: mt: Break out slots handling
Date: Mon, 29 Nov 2010 08:13:19 +0100
Message-Id: <1291014802-17061-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291014802-17061-1-git-send-email-rydberg@euromail.se>
References: <1291014802-17061-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PMxva-00050A-9p.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PMxva-00050A-9p 423fa6ee012297e6a255cedba101c05e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for common code to handle a larger set of MT slots
devices, move the slots handling over to a separate file.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-3m-pct.c                |    1 +
 drivers/input/Makefile                  |    2 +-
 drivers/input/input-mt.c                |   58 +++++++++++++++++++++++++++++++
 drivers/input/input.c                   |   48 +-------------------------
 drivers/input/misc/uinput.c             |    1 +
 drivers/input/tablet/wacom_wac.c        |    1 +
 drivers/input/touchscreen/wacom_w8001.c |    2 +-
 include/linux/input-mt.h                |   44 +++++++++++++++++++++++
 include/linux/input.h                   |   16 --------
 9 files changed, 108 insertions(+), 65 deletions(-)
 create mode 100644 drivers/input/input-mt.c
 create mode 100644 include/linux/input-mt.h

diff --git a/drivers/hid/hid-3m-pct.c b/drivers/hid/hid-3m-pct.c
index 02d8cd3..cb507f4 100644
--- a/drivers/hid/hid-3m-pct.c
+++ b/drivers/hid/hid-3m-pct.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
+#include <linux/input-mt.h>
 
 MODULE_AUTHOR("Stephane Chatty <chatty@enac.fr>");
 MODULE_DESCRIPTION("3M PCT multitouch panels");
diff --git a/drivers/input/Makefile b/drivers/input/Makefile
index 7ad212d..569938b 100644
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -5,7 +5,7 @@
 # Each configuration option enables a list of files.
 
 obj-$(CONFIG_INPUT)		+= input-core.o
-input-core-objs := input.o input-compat.o ff-core.o
+input-core-objs := input.o input-compat.o ff-core.o input-mt.o
 
 obj-$(CONFIG_INPUT_FF_MEMLESS)	+= ff-memless.o
 obj-$(CONFIG_INPUT_POLLDEV)	+= input-polldev.o
diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
new file mode 100644
index 0000000..ee24d28
--- /dev/null
+++ b/drivers/input/input-mt.c
@@ -0,0 +1,58 @@
+/*
+ * Input Multitouch Library
+ *
+ * Copyright (c) 2008-2010 Henrik Rydberg
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/input-mt.h>
+#include <linux/slab.h>
+
+/**
+ * input_mt_create_slots() - create MT input slots
+ * @dev: input device supporting MT events and finger tracking
+ * @num_slots: number of slots used by the device
+ *
+ * This function allocates all necessary memory for MT slot handling in the
+ * input device, and adds ABS_MT_SLOT to the device capabilities. All slots
+ * are initially marked as unused by setting ABS_MT_TRACKING_ID to -1.
+ */
+int input_mt_create_slots(struct input_dev *dev, unsigned int num_slots)
+{
+	int i;
+
+	if (!num_slots)
+		return 0;
+
+	dev->mt = kcalloc(num_slots, sizeof(struct input_mt_slot), GFP_KERNEL);
+	if (!dev->mt)
+		return -ENOMEM;
+
+	dev->mtsize = num_slots;
+	input_set_abs_params(dev, ABS_MT_SLOT, 0, num_slots - 1, 0, 0);
+
+	/* Mark slots as 'unused' */
+	for (i = 0; i < num_slots; i++)
+		input_mt_set_value(&dev->mt[i], ABS_MT_TRACKING_ID, -1);
+
+	return 0;
+}
+EXPORT_SYMBOL(input_mt_create_slots);
+
+/**
+ * input_mt_destroy_slots() - frees the MT slots of the input device
+ * @dev: input device with allocated MT slots
+ *
+ * This function is only needed in error path as the input core will
+ * automatically free the MT slots when the device is destroyed.
+ */
+void input_mt_destroy_slots(struct input_dev *dev)
+{
+	kfree(dev->mt);
+	dev->mt = NULL;
+	dev->mtsize = 0;
+}
+EXPORT_SYMBOL(input_mt_destroy_slots);
diff --git a/drivers/input/input.c b/drivers/input/input.c
index db409d6..504cf63 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -12,7 +12,7 @@
 
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/input.h>
+#include <linux/input-mt.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/random.h>
@@ -1725,52 +1725,6 @@ void input_free_device(struct input_dev *dev)
 EXPORT_SYMBOL(input_free_device);
 
 /**
- * input_mt_create_slots() - create MT input slots
- * @dev: input device supporting MT events and finger tracking
- * @num_slots: number of slots used by the device
- *
- * This function allocates all necessary memory for MT slot handling in the
- * input device, and adds ABS_MT_SLOT to the device capabilities. All slots
- * are initially marked as unused by setting ABS_MT_TRACKING_ID to -1.
- */
-int input_mt_create_slots(struct input_dev *dev, unsigned int num_slots)
-{
-	int i;
-
-	if (!num_slots)
-		return 0;
-
-	dev->mt = kcalloc(num_slots, sizeof(struct input_mt_slot), GFP_KERNEL);
-	if (!dev->mt)
-		return -ENOMEM;
-
-	dev->mtsize = num_slots;
-	input_set_abs_params(dev, ABS_MT_SLOT, 0, num_slots - 1, 0, 0);
-
-	/* Mark slots as 'unused' */
-	for (i = 0; i < num_slots; i++)
-		dev->mt[i].abs[ABS_MT_TRACKING_ID - ABS_MT_FIRST] = -1;
-
-	return 0;
-}
-EXPORT_SYMBOL(input_mt_create_slots);
-
-/**
- * input_mt_destroy_slots() - frees the MT slots of the input device
- * @dev: input device with allocated MT slots
- *
- * This function is only needed in error path as the input core will
- * automatically free the MT slots when the device is destroyed.
- */
-void input_mt_destroy_slots(struct input_dev *dev)
-{
-	kfree(dev->mt);
-	dev->mt = NULL;
-	dev->mtsize = 0;
-}
-EXPORT_SYMBOL(input_mt_destroy_slots);
-
-/**
  * input_set_capability - mark device as capable of a certain event
  * @dev: device that is capable of emitting or accepting event
  * @type: type of the event (EV_KEY, EV_REL, etc...)
diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index b941078..e8962b1 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -37,6 +37,7 @@
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <linux/uinput.h>
+#include <linux/input-mt.h>
 #include "../input-compat.h"
 
 static int uinput_dev_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index b3252ef..107ee3a 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -14,6 +14,7 @@
 
 #include "wacom_wac.h"
 #include "wacom.h"
+#include <linux/input-mt.h>
 
 static int wacom_penpartner_irq(struct wacom_wac *wacom)
 {
diff --git a/drivers/input/touchscreen/wacom_w8001.c b/drivers/input/touchscreen/wacom_w8001.c
index 9ae4c7b..1fb0cbc 100644
--- a/drivers/input/touchscreen/wacom_w8001.c
+++ b/drivers/input/touchscreen/wacom_w8001.c
@@ -15,7 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/input.h>
+#include <linux/input-mt.h>
 #include <linux/serio.h>
 #include <linux/init.h>
 #include <linux/ctype.h>
diff --git a/include/linux/input-mt.h b/include/linux/input-mt.h
new file mode 100644
index 0000000..4f5e9d0
--- /dev/null
+++ b/include/linux/input-mt.h
@@ -0,0 +1,44 @@
+#ifndef _INPUT_MT_H
+#define _INPUT_MT_H
+
+/*
+ * Input Multitouch Library
+ *
+ * Copyright (c) 2010 Henrik Rydberg
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/input.h>
+
+/**
+ * struct input_mt_slot - represents the state of an input MT slot
+ * @abs: holds current values of ABS_MT axes for this slot
+ */
+struct input_mt_slot {
+	int abs[ABS_MT_LAST - ABS_MT_FIRST + 1];
+};
+
+static inline void input_mt_set_value(struct input_mt_slot *slot,
+				      unsigned code, int value)
+{
+	slot->abs[code - ABS_MT_FIRST] = value;
+}
+
+static inline int input_mt_get_value(const struct input_mt_slot *slot,
+				     unsigned code)
+{
+	return slot->abs[code - ABS_MT_FIRST];
+}
+
+int input_mt_create_slots(struct input_dev *dev, unsigned int num_slots);
+void input_mt_destroy_slots(struct input_dev *dev);
+
+static inline void input_mt_slot(struct input_dev *dev, int slot)
+{
+	input_event(dev, EV_ABS, ABS_MT_SLOT, slot);
+}
+
+#endif
diff --git a/include/linux/input.h b/include/linux/input.h
index 6ef4446..dd7c0fc 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1083,14 +1083,6 @@ struct ff_effect {
 #include <linux/mod_devicetable.h>
 
 /**
- * struct input_mt_slot - represents the state of an input MT slot
- * @abs: holds current values of ABS_MT axes for this slot
- */
-struct input_mt_slot {
-	int abs[ABS_MT_LAST - ABS_MT_FIRST + 1];
-};
-
-/**
  * struct input_dev - represents an input device
  * @name: name of the device
  * @phys: physical path to the device in the system hierarchy
@@ -1463,11 +1455,6 @@ static inline void input_mt_sync(struct input_dev *dev)
 	input_event(dev, EV_SYN, SYN_MT_REPORT, 0);
 }
 
-static inline void input_mt_slot(struct input_dev *dev, int slot)
-{
-	input_event(dev, EV_ABS, ABS_MT_SLOT, slot);
-}
-
 void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int code);
 
 /**
@@ -1580,8 +1567,5 @@ int input_ff_erase(struct input_dev *dev, int effect_id, struct file *file);
 int input_ff_create_memless(struct input_dev *dev, void *data,
 		int (*play_effect)(struct input_dev *, void *, struct ff_effect *));
 
-int input_mt_create_slots(struct input_dev *dev, unsigned int num_slots);
-void input_mt_destroy_slots(struct input_dev *dev);
-
 #endif
 #endif
-- 
1.7.1

