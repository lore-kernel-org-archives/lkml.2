Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab0EUP4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 11:56:33 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:33623 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774Ab0EUP4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 11:56:31 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/2] input: mt: Introduce MT event slots (rev 4)
Date: Fri, 21 May 2010 17:55:53 +0200
Message-Id: <1274457354-5570-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OFUa5-00047L-3k.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OFUa5-00047L-3k d435603490b24ea8f4771670b868706b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the rapidly increasing number of intelligent multi-contact and
multi-user devices, the need to send digested, filtered information
from a set of different sources within the same device is imminent.
This patch adds the concept of slots to the MT protocol. The slots
enumerate a set of identified sources, such that all MT events
can be passed independently and selectively per identified source.

The protocol works like this: Instead of sending a SYN_MT_REPORT
event immediately after the contact data, one sends an ABS_SLOT
event immediately before the contact data. The input core will only
emit events for slots with modified MT events. It is assumed that
the same slot is used for the duration of an initiated contact.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Revision 4 incorporates the following changes:
	 - Change SYN_MT_SLOT to ABS_SLOT
	 - Set up the ABS_SLOT abs parameters in input_mt_create_slots()
	 - The last_slot variable is removed, using abs[ABS_SLOT] instead.

The earlier suggestion was to change SYN_MT_SLOT to ABS_MT_SLOT, but
it creates an unfortunate name clash, since the slot selection is not
an MT event in itself. Using the name ABS_SLOT seems approriate, even if
it is treated specially in the input core.

 drivers/input/input.c |   91 ++++++++++++++++++++++++++++++++++++++++++------
 include/linux/input.h |   26 ++++++++++++++
 2 files changed, 105 insertions(+), 12 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 9c79bd5..4d2050f 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -34,9 +34,9 @@ MODULE_LICENSE("GPL");
 #define INPUT_DEVICES	256
 
 /*
- * EV_ABS events which should not be cached are listed here.
+ * EV_ABS events which should be filtered on a per-slot basis are listed here.
  */
-static unsigned int input_abs_bypass_init_data[] __initdata = {
+static unsigned int input_mt_abs_map_init_data[] __initdata = {
 	ABS_MT_TOUCH_MAJOR,
 	ABS_MT_TOUCH_MINOR,
 	ABS_MT_WIDTH_MAJOR,
@@ -48,9 +48,8 @@ static unsigned int input_abs_bypass_init_data[] __initdata = {
 	ABS_MT_BLOB_ID,
 	ABS_MT_TRACKING_ID,
 	ABS_MT_PRESSURE,
-	0
 };
-static unsigned long input_abs_bypass[BITS_TO_LONGS(ABS_CNT)];
+static unsigned char input_mt_abs_map[ABS_CNT];
 
 static LIST_HEAD(input_dev_list);
 static LIST_HEAD(input_handler_list);
@@ -181,6 +180,26 @@ static void input_stop_autorepeat(struct input_dev *dev)
 #define INPUT_PASS_TO_DEVICE	2
 #define INPUT_PASS_TO_ALL	(INPUT_PASS_TO_HANDLERS | INPUT_PASS_TO_DEVICE)
 
+static void input_mt_handle_abs_event(struct input_dev *dev,
+				      unsigned int code, int value)
+{
+	if (dev->mt) {
+		struct input_mt_slot *mtslot = &dev->mt[dev->slot];
+		unsigned int mtcode = input_mt_abs_map[code] - 1;
+		int old = mtslot->abs[mtcode];
+		value = input_defuzz_abs_event(value, old, dev->absfuzz[code]);
+		if (value == old)
+			return;
+		mtslot->abs[mtcode] = value;
+	}
+	dev->sync = 0;
+	if (dev->slot != dev->abs[ABS_SLOT]) {
+		dev->abs[ABS_SLOT] = dev->slot;
+		input_pass_event(dev, EV_ABS, ABS_SLOT, dev->slot);
+	}
+	input_pass_event(dev, EV_ABS, code, value);
+}
+
 static void input_handle_event(struct input_dev *dev,
 			       unsigned int type, unsigned int code, int value)
 {
@@ -235,11 +254,17 @@ static void input_handle_event(struct input_dev *dev,
 	case EV_ABS:
 		if (is_event_supported(code, dev->absbit, ABS_MAX)) {
 
-			if (test_bit(code, input_abs_bypass)) {
-				disposition = INPUT_PASS_TO_HANDLERS;
+			if (code == ABS_SLOT) {
+				if (value >= 0 && value < dev->mtsize)
+					dev->slot = value;
 				break;
 			}
 
+			if (input_mt_abs_map[code]) {
+				input_mt_handle_abs_event(dev, code, value);
+				return;
+			}
+
 			value = input_defuzz_abs_event(value,
 					dev->abs[code], dev->absfuzz[code]);
 
@@ -1278,6 +1303,7 @@ static void input_dev_release(struct device *device)
 	struct input_dev *dev = to_input_dev(device);
 
 	input_ff_destroy(dev);
+	input_mt_destroy_slots(dev);
 	kfree(dev);
 
 	module_put(THIS_MODULE);
@@ -1518,6 +1544,46 @@ void input_free_device(struct input_dev *dev)
 EXPORT_SYMBOL(input_free_device);
 
 /**
+ * input_mt_create_slots() - create MT input slots
+ * @dev: input device supporting MT events and finger tracking
+ * @max_slots: maximum number of slots supported by the device
+ *
+ * This function allocates all necessary memory for MT slot handling
+ * in the input device, and adds ABS_SLOT to the device capabilities.
+ */
+int input_mt_create_slots(struct input_dev *dev, int max_slots)
+{
+	struct input_mt_slot *mt;
+
+	if (max_slots <= 0)
+		return 0;
+	mt = kzalloc(max_slots * sizeof(struct input_mt_slot), GFP_KERNEL);
+	if (!mt)
+		return -ENOMEM;
+
+	dev->mt = mt;
+	dev->mtsize = max_slots;
+	input_set_abs_params(dev, ABS_SLOT, 0, max_slots - 1, 0, 0);
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
+
+/**
  * input_set_capability - mark device as capable of a certain event
  * @dev: device that is capable of emitting or accepting event
  * @type: type of the event (EV_KEY, EV_REL, etc...)
@@ -1926,19 +1992,20 @@ static const struct file_operations input_fops = {
 	.open = input_open_file,
 };
 
-static void __init input_init_abs_bypass(void)
+static void __init input_mt_init_maps(void)
 {
-	const unsigned int *p;
-
-	for (p = input_abs_bypass_init_data; *p; p++)
-		input_abs_bypass[BIT_WORD(*p)] |= BIT_MASK(*p);
+	int i;
+	BUILD_BUG_ON(MT_ABS_SIZE != (typeof(input_mt_abs_map[0]))MT_ABS_SIZE);
+	BUILD_BUG_ON(ARRAY_SIZE(input_mt_abs_map_init_data) > MT_ABS_SIZE);
+	for (i = 0; i < ARRAY_SIZE(input_mt_abs_map_init_data); i++)
+		input_mt_abs_map[input_mt_abs_map_init_data[i]] = i + 1;
 }
 
 static int __init input_init(void)
 {
 	int err;
 
-	input_init_abs_bypass();
+	input_mt_init_maps();
 
 	err = class_register(&input_class);
 	if (err) {
diff --git a/include/linux/input.h b/include/linux/input.h
index 7ed2251..064e0af 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -693,6 +693,7 @@ struct input_absinfo {
 #define ABS_TOOL_WIDTH		0x1c
 #define ABS_VOLUME		0x20
 #define ABS_MISC		0x28
+#define ABS_SLOT		0x29
 
 #define ABS_MT_TOUCH_MAJOR	0x30	/* Major axis of touching ellipse */
 #define ABS_MT_TOUCH_MINOR	0x31	/* Minor axis (omit if circular) */
@@ -1080,6 +1081,9 @@ struct ff_effect {
  * @sync: set to 1 when there were no new events since last EV_SYNC
  * @abs: current values for reports from absolute axes
  * @rep: current values for autorepeat parameters (delay, rate)
+ * @mt: array of MT slots
+ * @mtsize: number of allocated MT slots
+ * @slot: current MT slot
  * @key: reflects current state of device's keys/buttons
  * @led: reflects current state of device's LEDs
  * @snd: reflects current state of sound effects
@@ -1157,6 +1161,10 @@ struct input_dev {
 	int abs[ABS_MAX + 1];
 	int rep[REP_MAX + 1];
 
+	struct input_mt_slot *mt;
+	int mtsize;
+	int slot;
+
 	unsigned long key[BITS_TO_LONGS(KEY_CNT)];
 	unsigned long led[BITS_TO_LONGS(LED_CNT)];
 	unsigned long snd[BITS_TO_LONGS(SND_CNT)];
@@ -1405,6 +1413,11 @@ static inline void input_mt_sync(struct input_dev *dev)
 	input_event(dev, EV_SYN, SYN_MT_REPORT, 0);
 }
 
+static inline void input_mt_slot(struct input_dev *dev, int slot)
+{
+	input_event(dev, EV_ABS, ABS_SLOT, slot);
+}
+
 void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int code);
 
 static inline void input_set_abs_params(struct input_dev *dev, int axis, int min, int max, int fuzz, int flat)
@@ -1484,5 +1497,18 @@ int input_ff_erase(struct input_dev *dev, int effect_id, struct file *file);
 int input_ff_create_memless(struct input_dev *dev, void *data,
 		int (*play_effect)(struct input_dev *, void *, struct ff_effect *));
 
+#define MT_ABS_SIZE 11
+
+/**
+ * struct input_mt_slot - represents the state of an input MT slot
+ * @abs: current values of ABS_MT axes for this slot
+ */
+struct input_mt_slot {
+	int abs[MT_ABS_SIZE];
+};
+
+int input_mt_create_slots(struct input_dev *dev, int max_slots);
+void input_mt_destroy_slots(struct input_dev *dev);
+
 #endif
 #endif
-- 
1.6.3.3

