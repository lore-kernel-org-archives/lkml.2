Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab0ESRYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:24:47 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:50856 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab0ESRYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:24:24 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       Daniel Mack <daniel@caiaq.de>, Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 4/4] input: dynamically allocate ABS information
Date: Wed, 19 May 2010 19:22:37 +0200
Message-Id: <1274289757-2723-5-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
References: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As all callers are now changed to only use the input_abs_*() access
helpers, switching over to dynamically allocated ABS information is
easy.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/input.c |   26 ++++++++++++++++++++
 include/linux/input.h |   63 +++++++++++++++++++++++++++++++-----------------
 2 files changed, 67 insertions(+), 22 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 5bc92f6..ced6b39 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -373,6 +373,25 @@ void input_inject_event(struct input_handle *handle,
 EXPORT_SYMBOL(input_inject_event);
 
 /**
+ * input_alloc_absinfo - allocates an input_absinfo struct
+ * @dev: the input device
+ * @axis: the ABS axis
+ *
+ * If the absinfo struct the caller asked for is already allocated, this
+ * functions will not do anything but return it.
+ */
+struct input_absinfo *input_alloc_absinfo(struct input_dev *dev, int axis)
+{
+	if (!dev->absinfo[axis])
+		dev->absinfo[axis] =
+			kzalloc(sizeof(struct input_absinfo), GFP_KERNEL);
+
+	WARN(!dev->absinfo[axis], "%s(): kzalloc() failed?\n", __func__);
+	return dev->absinfo[axis];
+}
+EXPORT_SYMBOL(input_alloc_absinfo);
+
+/**
  * input_grab_device - grabs device for exclusive use
  * @handle: input handle that wants to own the device
  *
@@ -1276,9 +1295,16 @@ static const struct attribute_group *input_dev_attr_groups[] = {
 
 static void input_dev_release(struct device *device)
 {
+	int i;
 	struct input_dev *dev = to_input_dev(device);
 
 	input_ff_destroy(dev);
+
+	for (i = 0; i < ABS_CNT; i++) {
+		kfree(dev->absinfo[i]);
+		dev->absinfo[i] = NULL;
+	}
+
 	kfree(dev);
 
 	module_put(THIS_MODULE);
diff --git a/include/linux/input.h b/include/linux/input.h
index ff1ee6d..67650ab 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1154,7 +1154,6 @@ struct input_dev {
 
 	int sync;
 
-	int abs[ABS_CNT];
 	int rep[REP_MAX + 1];
 
 	unsigned long key[BITS_TO_LONGS(KEY_CNT)];
@@ -1162,11 +1161,7 @@ struct input_dev {
 	unsigned long snd[BITS_TO_LONGS(SND_CNT)];
 	unsigned long sw[BITS_TO_LONGS(SW_CNT)];
 
-	int absmax[ABS_CNT];
-	int absmin[ABS_CNT];
-	int absfuzz[ABS_CNT];
-	int absflat[ABS_CNT];
-	int absres[ABS_CNT];
+	struct input_absinfo *absinfo[ABS_CNT];
 
 	int (*open)(struct input_dev *dev);
 	void (*close)(struct input_dev *dev);
@@ -1190,62 +1185,82 @@ struct input_dev {
 
 static inline int input_abs(struct input_dev *dev, int axis)
 {
-	return dev->abs[axis];
+	struct input_absinfo *absinfo = dev->absinfo[axis];
+	return absinfo ? absinfo->value : 0;
 }
 
 static inline int input_abs_max(struct input_dev *dev, int axis)
 {
-	return dev->absmax[axis];
+	struct input_absinfo *absinfo = dev->absinfo[axis];
+	return absinfo ? absinfo->maximum : 0;
 }
 
 static inline int input_abs_min(struct input_dev *dev, int axis)
 {
-	return dev->absmin[axis];
+	struct input_absinfo *absinfo = dev->absinfo[axis];
+	return absinfo ? absinfo->minimum : 0;
 }
 
 static inline int input_abs_fuzz(struct input_dev *dev, int axis)
 {
-	return dev->absfuzz[axis];
+	struct input_absinfo *absinfo = dev->absinfo[axis];
+	return absinfo ? absinfo->fuzz : 0;
 }
 
 static inline int input_abs_flat(struct input_dev *dev, int axis)
 {
-	return dev->absflat[axis];
+	struct input_absinfo *absinfo = dev->absinfo[axis];
+	return absinfo ? absinfo->flat : 0;
 }
 
 static inline int input_abs_res(struct input_dev *dev, int axis)
 {
-	return dev->absres[axis];
+	struct input_absinfo *absinfo = dev->absinfo[axis];
+	return absinfo ? absinfo->resolution: 0;
 }
 
+struct input_absinfo *input_alloc_absinfo(struct input_dev *dev, int axis);
+
 static inline void input_abs_set(struct input_dev *dev, int axis, int val)
 {
-	dev->abs[axis] = val;
+	struct input_absinfo *absinfo = input_alloc_absinfo(dev, axis);
+	if (absinfo)
+		absinfo->value = val;
 }
 
 static inline void input_abs_set_max(struct input_dev *dev, int axis, int val)
 {
-	dev->absmax[axis] = val;
+	struct input_absinfo *absinfo = input_alloc_absinfo(dev, axis);
+	if (absinfo)
+		absinfo->maximum = val;
 }
 
 static inline void input_abs_set_min(struct input_dev *dev, int axis, int val)
 {
-	dev->absmin[axis] = val;
+	struct input_absinfo *absinfo = input_alloc_absinfo(dev, axis);
+	if (absinfo)
+		absinfo->minimum = val;
 }
 
 static inline void input_abs_set_fuzz(struct input_dev *dev, int axis, int val)
 {
-	dev->absfuzz[axis] = val;
+	struct input_absinfo *absinfo = input_alloc_absinfo(dev, axis);
+	if (absinfo)
+		absinfo->fuzz = val;
 }
 
 static inline void input_abs_set_flat(struct input_dev *dev, int axis, int val)
 {
-	dev->absflat[axis] = val;
+	struct input_absinfo *absinfo = input_alloc_absinfo(dev, axis);
+	if (absinfo)
+		absinfo->flat = val;
 }
 
 static inline void input_abs_set_res(struct input_dev *dev, int axis, int val)
 {
-	dev->absres[axis] = val;
+	struct input_absinfo *absinfo = input_alloc_absinfo(dev, axis);
+	if (absinfo)
+		absinfo->resolution = val;
 }
 
 /*
@@ -1469,10 +1484,14 @@ void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int
 
 static inline void input_set_abs_params(struct input_dev *dev, int axis, int min, int max, int fuzz, int flat)
 {
-	dev->absmin[axis] = min;
-	dev->absmax[axis] = max;
-	dev->absfuzz[axis] = fuzz;
-	dev->absflat[axis] = flat;
+	struct input_absinfo *absinfo = input_alloc_absinfo(dev, axis);
+	if (!absinfo)
+		return;
+
+	absinfo->minimum = min;
+	absinfo->maximum = max;
+	absinfo->fuzz = fuzz;
+	absinfo->flat = flat;
 
 	dev->absbit[BIT_WORD(axis)] |= BIT_MASK(axis);
 }
-- 
1.7.1

