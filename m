Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab0EAN4f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 09:56:35 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:43812 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861Ab0EAN4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 09:56:32 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 2/3] input: mt: Introduce MT event slots (rev 2)
Date: Sat,  1 May 2010 15:55:53 +0200
Message-Id: <1272722154-2245-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1O8DAu-0008AE-6r.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1O8DAu-0008AE-6r e58e0626b7422852f26f781d34031e28
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
event immediately after the contact data, one sends a SYN_MT_SLOT
event immediately before the contact data. The input core will only
emit events for the slots corresponding to the contacts that have
changed. It is assumed that the same slot is used for the duration
of an initiated contact.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/input.h |   26 ++++++++++++++++++++
 2 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 187dd8b..6c3fa02 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -162,6 +162,23 @@ static void input_stop_autorepeat(struct input_dev *dev)
 #define INPUT_PASS_TO_DEVICE	2
 #define INPUT_PASS_TO_ALL	(INPUT_PASS_TO_HANDLERS | INPUT_PASS_TO_DEVICE)
 
+static void input_handle_mt_event(struct input_dev *dev,
+				  unsigned int code, int value)
+{
+	struct input_mt_slot *mtslot = &dev->mt[dev->slot];
+	int oldval = mtslot->absmt[code - ABS_MT_MIN];
+	value = input_defuzz_abs_event(value, oldval, dev->absfuzz[code]);
+	if (value == oldval)
+		return;
+	mtslot->absmt[code - ABS_MT_MIN] = value;
+	dev->sync = 0;
+	if (dev->slot != dev->last_slot) {
+		dev->last_slot = dev->slot;
+		input_pass_event(dev, EV_SYN, SYN_MT_SLOT, dev->slot);
+	}
+	input_pass_event(dev, EV_ABS, code, value);
+}
+
 static void input_handle_event(struct input_dev *dev,
 			       unsigned int type, unsigned int code, int value)
 {
@@ -185,6 +202,10 @@ static void input_handle_event(struct input_dev *dev,
 			dev->sync = 0;
 			disposition = INPUT_PASS_TO_HANDLERS;
 			break;
+		case SYN_MT_SLOT:
+			if (value >= 0 && value < dev->mtsize)
+				dev->slot = value;
+			break;
 		}
 		break;
 
@@ -217,6 +238,10 @@ static void input_handle_event(struct input_dev *dev,
 		if (is_event_supported(code, dev->absbit, ABS_MAX)) {
 
 			if (code >= ABS_MT_MIN && code <= ABS_MT_MAX) {
+				if (dev->mt) {
+					input_handle_mt_event(dev, code, value);
+					return;
+				}
 				disposition = INPUT_PASS_TO_HANDLERS;
 				break;
 			}
@@ -1259,6 +1284,7 @@ static void input_dev_release(struct device *device)
 	struct input_dev *dev = to_input_dev(device);
 
 	input_ff_destroy(dev);
+	input_destroy_mt_slots(dev);
 	kfree(dev);
 
 	module_put(THIS_MODULE);
@@ -1499,6 +1525,43 @@ void input_free_device(struct input_dev *dev)
 EXPORT_SYMBOL(input_free_device);
 
 /**
+ * input_mt_create_slots() - create MT input slots
+ * @dev: input device supporting MT events and finger tracking
+ * @max_slots: maximum number of slots supported by the device
+ *
+ * This function allocates all necessary memory for MT slot handling
+ * in the input device.
+ */
+int input_create_mt_slots(struct input_dev *dev, int max_slots)
+{
+	struct input_mt_slot *mt;
+
+	mt = kzalloc(max_slots * sizeof(struct input_mt_slot), GFP_KERNEL);
+	if (!mt)
+		return -ENOMEM;
+
+	dev->mt = mt;
+	dev->mtsize = max_slots;
+	return 0;
+}
+EXPORT_SYMBOL(input_create_mt_slots);
+
+/**
+ * input_destroy_mt_slots() - frees the MT slots of the input device
+ * @dev: input device with allocated MT slots
+ *
+ * This function is only needed in error path as the input core will
+ * automatically free the MT slots when the device is destroyed.
+ */
+void input_destroy_mt_slots(struct input_dev *dev)
+{
+	kfree(dev->mt);
+	dev->mt = NULL;
+	dev->mtsize = 0;
+}
+EXPORT_SYMBOL(input_destroy_mt_slots);
+
+/**
  * input_set_capability - mark device as capable of a certain event
  * @dev: device that is capable of emitting or accepting event
  * @type: type of the event (EV_KEY, EV_REL, etc...)
diff --git a/include/linux/input.h b/include/linux/input.h
index d4ad53f..0cf1d95 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -108,6 +108,7 @@ struct input_absinfo {
 #define SYN_REPORT		0
 #define SYN_CONFIG		1
 #define SYN_MT_REPORT		2
+#define SYN_MT_SLOT		3
 
 /*
  * Keys and buttons
@@ -1083,6 +1084,10 @@ struct ff_effect {
  * @sync: set to 1 when there were no new events since last EV_SYNC
  * @abs: current values for reports from absolute axes
  * @rep: current values for autorepeat parameters (delay, rate)
+ * @mt: array of MT slots
+ * @mtsize: number of allocated MT slots
+ * @slot: current MT slot
+ * @last_slot: last MT slot reported
  * @key: reflects current state of device's keys/buttons
  * @led: reflects current state of device's LEDs
  * @snd: reflects current state of sound effects
@@ -1160,6 +1165,11 @@ struct input_dev {
 	int abs[ABS_MAX + 1];
 	int rep[REP_MAX + 1];
 
+	struct input_mt_slot *mt;
+	int mtsize;
+	int slot;
+	int last_slot;
+
 	unsigned long key[BITS_TO_LONGS(KEY_CNT)];
 	unsigned long led[BITS_TO_LONGS(LED_CNT)];
 	unsigned long snd[BITS_TO_LONGS(SND_CNT)];
@@ -1408,6 +1418,11 @@ static inline void input_mt_sync(struct input_dev *dev)
 	input_event(dev, EV_SYN, SYN_MT_REPORT, 0);
 }
 
+static inline void input_mt_slot(struct input_dev *dev, int slot)
+{
+	input_event(dev, EV_SYN, SYN_MT_SLOT, slot);
+}
+
 void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int code);
 
 static inline void input_set_abs_params(struct input_dev *dev, int axis, int min, int max, int fuzz, int flat)
@@ -1487,5 +1502,16 @@ int input_ff_erase(struct input_dev *dev, int effect_id, struct file *file);
 int input_ff_create_memless(struct input_dev *dev, void *data,
 		int (*play_effect)(struct input_dev *, void *, struct ff_effect *));
 
+/**
+ * struct input_mt_slot - represents the state of an MT input slot
+ * @abs: current values from absolute axes for this slot
+ */
+struct input_mt_slot {
+	int absmt[ABS_MT_MAX - ABS_MT_MIN + 1];
+};
+
+int input_create_mt_slots(struct input_dev *dev, int max_slots);
+void input_destroy_mt_slots(struct input_dev *dev);
+
 #endif
 #endif
-- 
1.6.3.3

