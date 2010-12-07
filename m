Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab0LGLqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 06:46:48 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:56635 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839Ab0LGLqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 06:46:46 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pingc@wacom.com>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH v3] input: mt: Move tracking and pointer emulation to input-mt
Date: Tue,  7 Dec 2010 12:45:57 +0100
Message-Id: <1291722357-22820-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PPw05-0005NK-Cn.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PPw05-0005NK-Cn db3dc8ca378e200774584f02e77590fe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers using the type B protocol all report tracking information
the same way. The contact id is semantically equivalent to
ABS_MT_SLOT, and the handling of ABS_MT_TRACKING_ID only complicates
the driver. The situation can be improved upon by providing a common
pointer emulation code, thereby removing the need for the tracking id
in the driver.  This patch moves all tracking event handling over to
the input core, simplifying both the existing drivers and the ones
currently in preparation.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
This is revision three of the patch, with changes to incorporate the
active use of ABS_MT_TOOL_TYPE. Example usages are found in pen and
touch tablets and simple dual touch devices. The report_slot_state()
function now takes the tool type as argument, since a change in either
tool type of touch state should trigger a new tracking id.

Thanks,
Henrik

 drivers/hid/hid-3m-pct.c                |   30 +---------
 drivers/input/input-mt.c                |   98 +++++++++++++++++++++++++++++--
 drivers/input/tablet/wacom_wac.c        |   24 ++------
 drivers/input/tablet/wacom_wac.h        |    4 -
 drivers/input/touchscreen/wacom_w8001.c |   21 ++-----
 include/linux/input-mt.h                |   12 ++++
 include/linux/input.h                   |    1 +
 7 files changed, 118 insertions(+), 72 deletions(-)

diff --git a/drivers/hid/hid-3m-pct.c b/drivers/hid/hid-3m-pct.c
index e3711c5..f984f0f 100644
--- a/drivers/hid/hid-3m-pct.c
+++ b/drivers/hid/hid-3m-pct.c
@@ -28,7 +28,6 @@ MODULE_LICENSE("GPL");
 #include "hid-ids.h"
 
 #define MAX_SLOTS		60
-#define MAX_TRKID		USHRT_MAX
 
 /* estimated signal-to-noise ratios */
 #define SN_MOVE			2048
@@ -36,14 +35,11 @@ MODULE_LICENSE("GPL");
 
 struct mmm_finger {
 	__s32 x, y, w, h;
-	__u16 id;
-	bool prev_touch;
 	bool touch, valid;
 };
 
 struct mmm_data {
 	struct mmm_finger f[MAX_SLOTS];
-	__u16 id;
 	__u8 curid;
 	__u8 nexp, nreal;
 	bool touch, valid;
@@ -117,11 +113,6 @@ static int mmm_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 					0, 1, 0, 0);
 			return 1;
 		case HID_DG_CONTACTID:
-			field->logical_maximum = MAX_TRKID;
-			hid_map_usage(hi, usage, bit, max,
-					EV_ABS, ABS_MT_TRACKING_ID);
-			input_set_abs_params(hi->input, ABS_MT_TRACKING_ID,
-					     0, MAX_TRKID, 0, 0);
 			input_mt_init_slots(hi->input, MAX_SLOTS);
 			return 1;
 		}
@@ -152,7 +143,6 @@ static int mmm_input_mapped(struct hid_device *hdev, struct hid_input *hi,
  */
 static void mmm_filter_event(struct mmm_data *md, struct input_dev *input)
 {
-	struct mmm_finger *oldest = 0;
 	int i;
 	for (i = 0; i < MAX_SLOTS; ++i) {
 		struct mmm_finger *f = &md->f[i];
@@ -161,6 +151,7 @@ static void mmm_filter_event(struct mmm_data *md, struct input_dev *input)
 			continue;
 		}
 		input_mt_slot(input, i);
+		input_mt_report_slot_state(input, MT_TOOL_FINGER, f->touch);
 		if (f->touch) {
 			/* this finger is on the screen */
 			int wide = (f->w > f->h);
@@ -168,33 +159,16 @@ static void mmm_filter_event(struct mmm_data *md, struct input_dev *input)
 			int major = max(f->w, f->h) >> 1;
 			int minor = min(f->w, f->h) >> 1;
 
-			if (!f->prev_touch)
-				f->id = md->id++;
-			input_event(input, EV_ABS, ABS_MT_TRACKING_ID, f->id);
 			input_event(input, EV_ABS, ABS_MT_POSITION_X, f->x);
 			input_event(input, EV_ABS, ABS_MT_POSITION_Y, f->y);
 			input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
 			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
 			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
-			/* touchscreen emulation: pick the oldest contact */
-			if (!oldest || ((f->id - oldest->id) & (SHRT_MAX + 1)))
-				oldest = f;
-		} else {
-			/* this finger took off the screen */
-			input_event(input, EV_ABS, ABS_MT_TRACKING_ID, -1);
 		}
-		f->prev_touch = f->touch;
 		f->valid = 0;
 	}
 
-	/* touchscreen emulation */
-	if (oldest) {
-		input_event(input, EV_KEY, BTN_TOUCH, 1);
-		input_event(input, EV_ABS, ABS_X, oldest->x);
-		input_event(input, EV_ABS, ABS_Y, oldest->y);
-	} else {
-		input_event(input, EV_KEY, BTN_TOUCH, 0);
-	}
+	input_mt_report_pointer_emulation(input);
 	input_sync(input);
 }
 
diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index c4a9784..c33d3ee 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -11,17 +11,18 @@
 #include <linux/input-mt.h>
 #include <linux/slab.h>
 
+#define TRKID_SGN	((TRKID_MAX + 1) >> 1)
+
 /**
  * input_mt_init_slots() - initialize MT input slots
  * @dev: input device supporting MT events and finger tracking
  * @num_slots: number of slots used by the device
  *
  * This function allocates all necessary memory for MT slot handling
- * in the input device, adds ABS_MT_SLOT to the device capabilities
- * and sets up appropriate event buffers. All slots are initially
- * marked as unused by setting ABS_MT_TRACKING_ID to -1. May be called
- * repeatedly. Returns -EINVAL if attempting to reinitialize with a
- * different number of slots.
+ * in the input device, prepares the ABS_MT_SLOT and
+ * ABS_MT_TRACKING_ID events for use and sets up appropriate buffers.
+ * May be called repeatedly. Returns -EINVAL if attempting to
+ * reinitialize with a different number of slots.
  */
 int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots)
 {
@@ -38,6 +39,7 @@ int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots)
 
 	dev->mtsize = num_slots;
 	input_set_abs_params(dev, ABS_MT_SLOT, 0, num_slots - 1, 0, 0);
+	input_set_abs_params(dev, ABS_MT_TRACKING_ID, 0, TRKID_MAX, 0, 0);
 	input_set_events_per_packet(dev, 6 * num_slots);
 
 	/* Mark slots as 'unused' */
@@ -61,5 +63,91 @@ void input_mt_destroy_slots(struct input_dev *dev)
 	dev->mt = NULL;
 	dev->mtsize = 0;
 	dev->slot = 0;
+	dev->trkid = 0;
 }
 EXPORT_SYMBOL(input_mt_destroy_slots);
+
+/**
+ * input_mt_report_slot_state() - report contact state
+ * @dev: input device with allocated MT slots
+ * @tool_type: the tool type to use in this slot
+ * @active: true if contact is active, false otherwise
+ *
+ * Reports a contact via ABS_MT_TRACKING_ID, and optionally
+ * ABS_MT_TOOL_TYPE. If active is true and the slot is currently
+ * inactive, or if the tool type is changed, a new tracking id is
+ * assigned to the slot. The tool type is only reported if the
+ * corresponding absbit field is set.
+ */
+void input_mt_report_slot_state(struct input_dev *dev,
+				unsigned int tool_type, bool active)
+{
+	struct input_mt_slot *mt;
+	int id;
+
+	if (!dev->mt || !active) {
+		input_event(dev, EV_ABS, ABS_MT_TRACKING_ID, -1);
+		return;
+	}
+
+	mt = &dev->mt[dev->slot];
+	id = input_mt_get_value(mt, ABS_MT_TRACKING_ID);
+	if (id < 0 || input_mt_get_value(mt, ABS_MT_TOOL_TYPE) != tool_type)
+		id = input_mt_new_trkid(dev);
+
+	input_event(dev, EV_ABS, ABS_MT_TRACKING_ID, id);
+	input_event(dev, EV_ABS, ABS_MT_TOOL_TYPE, tool_type);
+}
+EXPORT_SYMBOL(input_mt_report_slot_state);
+
+/**
+ * input_mt_report_pointer_emulation() - common pointer emulation
+ * @dev: input device with allocated MT slots
+ *
+ * Performs legacy pointer emulation via BTN_TOUCH, ABS_X, ABS_Y and
+ * ABS_PRESSURE. Touchpad finger count is emulated using
+ * BTN_TOOL_FINGER, BTN_TOOL_DOUBLETAP, BTN_TOOL_TRIPLETAP and
+ * BTN_TOOL_QUADTAP.
+ *
+ * The input core ensures only the KEY and ABS axes already setup for
+ * this device will produce output.
+ */
+void input_mt_report_pointer_emulation(struct input_dev *dev)
+{
+	struct input_mt_slot *oldest = 0;
+	int oldid = dev->trkid;
+	int count = 0;
+	int i;
+
+	for (i = 0; i < dev->mtsize; ++i) {
+		struct input_mt_slot *ps = &dev->mt[i];
+		int id = input_mt_get_value(ps, ABS_MT_TRACKING_ID);
+
+		if (id < 0)
+			continue;
+		if ((id - oldid) & TRKID_SGN) {
+			oldest = ps;
+			oldid = id;
+		}
+		count++;
+	}
+
+	input_event(dev, EV_KEY, BTN_TOUCH, count > 0);
+	input_event(dev, EV_KEY, BTN_TOOL_FINGER, count == 1);
+	input_event(dev, EV_KEY, BTN_TOOL_DOUBLETAP, count == 2);
+	input_event(dev, EV_KEY, BTN_TOOL_TRIPLETAP, count == 3);
+	input_event(dev, EV_KEY, BTN_TOOL_QUADTAP, count == 4);
+
+	if (oldest) {
+		int x = input_mt_get_value(oldest, ABS_MT_POSITION_X);
+		int y = input_mt_get_value(oldest, ABS_MT_POSITION_Y);
+		int p = input_mt_get_value(oldest, ABS_MT_PRESSURE);
+
+		input_event(dev, EV_ABS, ABS_X, x);
+		input_event(dev, EV_ABS, ABS_Y, y);
+		input_event(dev, EV_ABS, ABS_PRESSURE, p);
+	} else {
+		input_event(dev, EV_ABS, ABS_PRESSURE, 0);
+	}
+}
+EXPORT_SYMBOL(input_mt_report_pointer_emulation);
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 3f9e280..4e59b93 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -863,19 +863,20 @@ static int wacom_bpt_touch(struct wacom_wac *wacom)
 	struct wacom_features *features = &wacom->features;
 	struct input_dev *input = wacom->input;
 	unsigned char *data = wacom->data;
-	int sp = 0, sx = 0, sy = 0, count = 0;
 	int i;
 
 	for (i = 0; i < 2; i++) {
-		int p = data[9 * i + 2];
+		int p = data[9 * i + 2] && !wacom->shared->stylus_in_proximity;
+
 		input_mt_slot(input, i);
+		input_mt_report_slot_state(input, MT_TOOL_FINGER, p);
 		/*
 		 * Touch events need to be disabled while stylus is
 		 * in proximity because user's hand is resting on touchpad
 		 * and sending unwanted events.  User expects tablet buttons
 		 * to continue working though.
 		 */
-		if (p && !wacom->shared->stylus_in_proximity) {
+		if (p) {
 			int x = get_unaligned_be16(&data[9 * i + 3]) & 0x7ff;
 			int y = get_unaligned_be16(&data[9 * i + 5]) & 0x7ff;
 			if (features->quirks & WACOM_QUIRK_BBTOUCH_LOWRES) {
@@ -885,23 +886,10 @@ static int wacom_bpt_touch(struct wacom_wac *wacom)
 			input_report_abs(input, ABS_MT_PRESSURE, p);
 			input_report_abs(input, ABS_MT_POSITION_X, x);
 			input_report_abs(input, ABS_MT_POSITION_Y, y);
-			if (wacom->id[i] < 0)
-				wacom->id[i] = wacom->trk_id++ & MAX_TRACKING_ID;
-			if (!count++)
-				sp = p, sx = x, sy = y;
-		} else {
-			wacom->id[i] = -1;
 		}
-		input_report_abs(input, ABS_MT_TRACKING_ID, wacom->id[i]);
 	}
 
-	input_report_key(input, BTN_TOUCH, count > 0);
-	input_report_key(input, BTN_TOOL_FINGER, count == 1);
-	input_report_key(input, BTN_TOOL_DOUBLETAP, count == 2);
-
-	input_report_abs(input, ABS_PRESSURE, sp);
-	input_report_abs(input, ABS_X, sx);
-	input_report_abs(input, ABS_Y, sy);
+	input_mt_report_pointer_emulation(input);
 
 	input_report_key(input, BTN_LEFT, (data[1] & 0x08) != 0);
 	input_report_key(input, BTN_FORWARD, (data[1] & 0x04) != 0);
@@ -1283,8 +1271,6 @@ void wacom_setup_input_capabilities(struct input_dev *input_dev,
 			input_set_abs_params(input_dev, ABS_MT_PRESSURE,
 					     0, features->pressure_max,
 					     features->pressure_fuzz, 0);
-			input_set_abs_params(input_dev, ABS_MT_TRACKING_ID, 0,
-					     MAX_TRACKING_ID, 0, 0);
 		} else if (features->device_type == BTN_TOOL_PEN) {
 			__set_bit(BTN_TOOL_RUBBER, input_dev->keybit);
 			__set_bit(BTN_TOOL_PEN, input_dev->keybit);
diff --git a/drivers/input/tablet/wacom_wac.h b/drivers/input/tablet/wacom_wac.h
index 00ca015..b1310ec 100644
--- a/drivers/input/tablet/wacom_wac.h
+++ b/drivers/input/tablet/wacom_wac.h
@@ -42,9 +42,6 @@
 #define WACOM_QUIRK_MULTI_INPUT		0x0001
 #define WACOM_QUIRK_BBTOUCH_LOWRES	0x0002
 
-/* largest reported tracking id */
-#define MAX_TRACKING_ID			0xfff
-
 enum {
 	PENPARTNER = 0,
 	GRAPHIRE,
@@ -100,7 +97,6 @@ struct wacom_wac {
 	int id[3];
 	__u32 serial[2];
 	int last_finger;
-	int trk_id;
 	struct wacom_features features;
 	struct wacom_shared *shared;
 	struct input_dev *input;
diff --git a/drivers/input/touchscreen/wacom_w8001.c b/drivers/input/touchscreen/wacom_w8001.c
index b706cd5..361d00a 100644
--- a/drivers/input/touchscreen/wacom_w8001.c
+++ b/drivers/input/touchscreen/wacom_w8001.c
@@ -48,8 +48,6 @@ MODULE_LICENSE("GPL");
 #define W8001_PKTLEN_TPCCTL	11	/* control packet */
 #define W8001_PKTLEN_TOUCH2FG	13
 
-#define MAX_TRACKING_ID		0xFF	/* arbitrarily chosen */
-
 struct w8001_coord {
 	u8 rdy;
 	u8 tsw;
@@ -87,7 +85,6 @@ struct w8001 {
 	char phys[32];
 	int type;
 	unsigned int pktlen;
-	int trkid[2];
 };
 
 static void parse_data(u8 *data, struct w8001_coord *coord)
@@ -116,28 +113,23 @@ static void parse_data(u8 *data, struct w8001_coord *coord)
 
 static void parse_touch(struct w8001 *w8001)
 {
-	static int trkid;
 	struct input_dev *dev = w8001->dev;
 	unsigned char *data = w8001->data;
 	int i;
 
 	for (i = 0; i < 2; i++) {
-		input_mt_slot(dev, i);
+		bool touch = data[0] & (1 << i);
 
-		if (data[0] & (1 << i)) {
+		input_mt_slot(dev, i);
+		input_mt_report_slot_state(dev, MT_TOOL_FINGER, touch);
+		if (touch) {
 			int x = (data[6 * i + 1] << 7) | (data[6 * i + 2]);
 			int y = (data[6 * i + 3] << 7) | (data[6 * i + 4]);
 			/* data[5,6] and [11,12] is finger capacity */
 
 			input_report_abs(dev, ABS_MT_POSITION_X, x);
 			input_report_abs(dev, ABS_MT_POSITION_Y, y);
-			input_report_abs(dev, ABS_MT_TOOL_TYPE, MT_TOOL_FINGER);
-			if (w8001->trkid[i] < 0)
-				w8001->trkid[i] = trkid++ & MAX_TRACKING_ID;
-		} else {
-			w8001->trkid[i] = -1;
 		}
-		input_report_abs(dev, ABS_MT_TRACKING_ID, w8001->trkid[i]);
 	}
 
 	input_sync(dev);
@@ -319,14 +311,12 @@ static int w8001_setup(struct w8001 *w8001)
 			w8001->pktlen = W8001_PKTLEN_TOUCH2FG;
 
 			input_mt_init_slots(dev, 2);
-			input_set_abs_params(dev, ABS_MT_TRACKING_ID,
-						0, MAX_TRACKING_ID, 0, 0);
 			input_set_abs_params(dev, ABS_MT_POSITION_X,
 						0, touch.x, 0, 0);
 			input_set_abs_params(dev, ABS_MT_POSITION_Y,
 						0, touch.y, 0, 0);
 			input_set_abs_params(dev, ABS_MT_TOOL_TYPE,
-						0, 0, 0, 0);
+						0, MT_TOOL_MAX, 0, 0);
 			break;
 		}
 	}
@@ -372,7 +362,6 @@ static int w8001_connect(struct serio *serio, struct serio_driver *drv)
 	w8001->serio = serio;
 	w8001->id = serio->id.id;
 	w8001->dev = input_dev;
-	w8001->trkid[0] = w8001->trkid[1] = -1;
 	init_completion(&w8001->cmd_done);
 	snprintf(w8001->phys, sizeof(w8001->phys), "%s/input0", serio->phys);
 
diff --git a/include/linux/input-mt.h b/include/linux/input-mt.h
index d7f6518..b4f0950 100644
--- a/include/linux/input-mt.h
+++ b/include/linux/input-mt.h
@@ -13,6 +13,8 @@
 
 #include <linux/input.h>
 
+#define TRKID_MAX	0xffff
+
 /**
  * struct input_mt_slot - represents the state of an input MT slot
  * @abs: holds current values of ABS_MT axes for this slot
@@ -36,9 +38,19 @@ static inline int input_mt_get_value(const struct input_mt_slot *slot,
 int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots);
 void input_mt_destroy_slots(struct input_dev *dev);
 
+static inline int input_mt_new_trkid(struct input_dev *dev)
+{
+	return dev->trkid++ & TRKID_MAX;
+}
+
 static inline void input_mt_slot(struct input_dev *dev, int slot)
 {
 	input_event(dev, EV_ABS, ABS_MT_SLOT, slot);
 }
 
+void input_mt_report_slot_state(struct input_dev *dev,
+				unsigned int tool_type, bool active);
+
+void input_mt_report_pointer_emulation(struct input_dev *dev);
+
 #endif
diff --git a/include/linux/input.h b/include/linux/input.h
index 329dc0e..f4df82a 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1208,6 +1208,7 @@ struct input_dev {
 	struct input_mt_slot *mt;
 	int mtsize;
 	int slot;
+	int trkid;
 
 	struct input_absinfo *absinfo;
 
-- 
1.7.1

