Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab2HLVkb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 17:40:31 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:44538 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2HLVjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 17:39:25 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap5OALghKFBV5qoUPGdsb2JhbABEhRiFI68/GQEBAQE3NIIhAQUnLxMBCgUQCEk5ChQGARKIEbY6FJEvA5s2jQY
X-IronPort-AV: E=Sophos;i="4.77,756,1336341600"; 
   d="scan'208";a="95328050"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 01/19] Input: Break out MT data
Date: Sun, 12 Aug 2012 23:42:19 +0200
Message-Id: <1344807757-2217-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all MT-related things to a separate place. This saves some
bytes for non-mt input devices, and prepares for new MT features.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/evdev.c    | 10 ++++++----
 drivers/input/input-mt.c | 47 +++++++++++++++++++++++++++--------------------
 drivers/input/input.c    |  9 ++++-----
 include/linux/input.h    |  9 ++-------
 include/linux/input/mt.h | 16 ++++++++++++++--
 5 files changed, 53 insertions(+), 38 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 6c58bff..a0692c5 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -653,20 +653,22 @@ static int evdev_handle_mt_request(struct input_dev *dev,
 				   unsigned int size,
 				   int __user *ip)
 {
-	const struct input_mt_slot *mt = dev->mt;
+	const struct input_mt *mt = dev->mt;
 	unsigned int code;
 	int max_slots;
 	int i;
 
 	if (get_user(code, &ip[0]))
 		return -EFAULT;
-	if (!input_is_mt_value(code))
+	if (!mt || !input_is_mt_value(code))
 		return -EINVAL;
 
 	max_slots = (size - sizeof(__u32)) / sizeof(__s32);
-	for (i = 0; i < dev->mtsize && i < max_slots; i++)
-		if (put_user(input_mt_get_value(&mt[i], code), &ip[1 + i]))
+	for (i = 0; i < mt->num_slots && i < max_slots; i++) {
+		int value = input_mt_get_value(&mt->slots[i], code);
+		if (put_user(value, &ip[1 + i]))
 			return -EFAULT;
+	}
 
 	return 0;
 }
diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index 70a16c7..c6df704 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -27,26 +27,28 @@
  */
 int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots)
 {
+	struct input_mt *mt = dev->mt;
 	int i;
 
 	if (!num_slots)
 		return 0;
-	if (dev->mt)
-		return dev->mtsize != num_slots ? -EINVAL : 0;
+	if (mt)
+		return mt->num_slots != num_slots ? -EINVAL : 0;
 
-	dev->mt = kcalloc(num_slots, sizeof(struct input_mt_slot), GFP_KERNEL);
-	if (!dev->mt)
+	mt = kzalloc(sizeof(*mt) + num_slots * sizeof(*mt->slots), GFP_KERNEL);
+	if (!mt)
 		return -ENOMEM;
 
-	dev->mtsize = num_slots;
+	mt->num_slots = num_slots;
 	input_set_abs_params(dev, ABS_MT_SLOT, 0, num_slots - 1, 0, 0);
 	input_set_abs_params(dev, ABS_MT_TRACKING_ID, 0, TRKID_MAX, 0, 0);
 	input_set_events_per_packet(dev, 6 * num_slots);
 
 	/* Mark slots as 'unused' */
 	for (i = 0; i < num_slots; i++)
-		input_mt_set_value(&dev->mt[i], ABS_MT_TRACKING_ID, -1);
+		input_mt_set_value(&mt->slots[i], ABS_MT_TRACKING_ID, -1);
 
+	dev->mt = mt;
 	return 0;
 }
 EXPORT_SYMBOL(input_mt_init_slots);
@@ -62,9 +64,7 @@ void input_mt_destroy_slots(struct input_dev *dev)
 {
 	kfree(dev->mt);
 	dev->mt = NULL;
-	dev->mtsize = 0;
 	dev->slot = 0;
-	dev->trkid = 0;
 }
 EXPORT_SYMBOL(input_mt_destroy_slots);
 
@@ -83,18 +83,19 @@ EXPORT_SYMBOL(input_mt_destroy_slots);
 void input_mt_report_slot_state(struct input_dev *dev,
 				unsigned int tool_type, bool active)
 {
-	struct input_mt_slot *mt;
+	struct input_mt *mt = dev->mt;
+	struct input_mt_slot *slot;
 	int id;
 
-	if (!dev->mt || !active) {
+	if (!mt || !active) {
 		input_event(dev, EV_ABS, ABS_MT_TRACKING_ID, -1);
 		return;
 	}
 
-	mt = &dev->mt[dev->slot];
-	id = input_mt_get_value(mt, ABS_MT_TRACKING_ID);
-	if (id < 0 || input_mt_get_value(mt, ABS_MT_TOOL_TYPE) != tool_type)
-		id = input_mt_new_trkid(dev);
+	slot = &mt->slots[dev->slot];
+	id = input_mt_get_value(slot, ABS_MT_TRACKING_ID);
+	if (id < 0 || input_mt_get_value(slot, ABS_MT_TOOL_TYPE) != tool_type)
+		id = input_mt_new_trkid(mt);
 
 	input_event(dev, EV_ABS, ABS_MT_TRACKING_ID, id);
 	input_event(dev, EV_ABS, ABS_MT_TOOL_TYPE, tool_type);
@@ -135,13 +136,19 @@ EXPORT_SYMBOL(input_mt_report_finger_count);
  */
 void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count)
 {
-	struct input_mt_slot *oldest = NULL;
-	int oldid = dev->trkid;
-	int count = 0;
-	int i;
+	struct input_mt *mt = dev->mt;
+	struct input_mt_slot *oldest;
+	int oldid, count, i;
+
+	if (!mt)
+		return;
+
+	oldest = 0;
+	oldid = mt->trkid;
+	count = 0;
 
-	for (i = 0; i < dev->mtsize; ++i) {
-		struct input_mt_slot *ps = &dev->mt[i];
+	for (i = 0; i < mt->num_slots; ++i) {
+		struct input_mt_slot *ps = &mt->slots[i];
 		int id = input_mt_get_value(ps, ABS_MT_TRACKING_ID);
 
 		if (id < 0)
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 8921c61..6e90705 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -174,7 +174,7 @@ static int input_handle_abs_event(struct input_dev *dev,
 		 * "Stage" the event; we'll flush it later, when we
 		 * get actual touch data.
 		 */
-		if (*pval >= 0 && *pval < dev->mtsize)
+		if (dev->mt && *pval >= 0 && *pval < dev->mt->num_slots)
 			dev->slot = *pval;
 
 		return INPUT_IGNORE_EVENT;
@@ -185,8 +185,7 @@ static int input_handle_abs_event(struct input_dev *dev,
 	if (!is_mt_event) {
 		pold = &dev->absinfo[code].value;
 	} else if (dev->mt) {
-		struct input_mt_slot *mtslot = &dev->mt[dev->slot];
-		pold = &mtslot->abs[code - ABS_MT_FIRST];
+		pold = &dev->mt->slots[dev->slot].abs[code - ABS_MT_FIRST];
 	} else {
 		/*
 		 * Bypass filtering for multi-touch events when
@@ -1751,8 +1750,8 @@ static unsigned int input_estimate_events_per_packet(struct input_dev *dev)
 	int i;
 	unsigned int events;
 
-	if (dev->mtsize) {
-		mt_slots = dev->mtsize;
+	if (dev->mt) {
+		mt_slots = dev->mt->num_slots;
 	} else if (test_bit(ABS_MT_TRACKING_ID, dev->absbit)) {
 		mt_slots = dev->absinfo[ABS_MT_TRACKING_ID].maximum -
 			   dev->absinfo[ABS_MT_TRACKING_ID].minimum + 1,
diff --git a/include/linux/input.h b/include/linux/input.h
index 725dcd0..76d6788 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1203,11 +1203,8 @@ struct ff_effect {
  *	software autorepeat
  * @timer: timer for software autorepeat
  * @rep: current values for autorepeat parameters (delay, rate)
- * @mt: pointer to array of struct input_mt_slot holding current values
- *	of tracked contacts
- * @mtsize: number of MT slots the device uses
+ * @mt: pointer to multitouch state
  * @slot: MT slot currently being transmitted
- * @trkid: stores MT tracking ID for the current contact
  * @absinfo: array of &struct input_absinfo elements holding information
  *	about absolute axes (current value, min, max, flat, fuzz,
  *	resolution)
@@ -1287,10 +1284,8 @@ struct input_dev {
 
 	int rep[REP_CNT];
 
-	struct input_mt_slot *mt;
-	int mtsize;
+	struct input_mt *mt;
 	int slot;
-	int trkid;
 
 	struct input_absinfo *absinfo;
 
diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
index f867375..4ae275c 100644
--- a/include/linux/input/mt.h
+++ b/include/linux/input/mt.h
@@ -23,6 +23,18 @@ struct input_mt_slot {
 	int abs[ABS_MT_LAST - ABS_MT_FIRST + 1];
 };
 
+/**
+ * struct input_mt - state of tracked contacts
+ * @trkid: stores MT tracking ID for the next contact
+ * @num_slots: number of MT slots the device uses
+ * @slots: array of slots holding current values of tracked contacts
+ */
+struct input_mt {
+	int trkid;
+	int num_slots;
+	struct input_mt_slot slots[];
+};
+
 static inline void input_mt_set_value(struct input_mt_slot *slot,
 				      unsigned code, int value)
 {
@@ -38,9 +50,9 @@ static inline int input_mt_get_value(const struct input_mt_slot *slot,
 int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots);
 void input_mt_destroy_slots(struct input_dev *dev);
 
-static inline int input_mt_new_trkid(struct input_dev *dev)
+static inline int input_mt_new_trkid(struct input_mt *mt)
 {
-	return dev->trkid++ & TRKID_MAX;
+	return mt->trkid++ & TRKID_MAX;
 }
 
 static inline void input_mt_slot(struct input_dev *dev, int slot)
-- 
1.7.11.4

