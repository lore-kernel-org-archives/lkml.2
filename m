Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab2IOP0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 11:26:00 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:56914 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab2IOPZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 11:25:57 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmRPAIydVFBV5h1yPGdsb2JhbABFhR6FI7FJGQEBAQE3NIIhAQUnExweBRAISRQlChqIJLplFJEVYAOVYIEVhFuNGg
X-IronPort-AV: E=Sophos;i="4.80,428,1344204000"; 
   d="scan'208";a="193583233"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 15 Sep 2012 17:33:23 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Input and HID updates for 3.7, version 4
Message-ID: <20120915153323.GA1391@polaris.bitmath.org>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
 <20120910190226.GA877@polaris.bitmath.org>
 <alpine.LNX.2.00.1209102248250.22683@pobox.suse.cz>
 <5556929.93aC5q4087@dtor-d630.eng.vmware.com>
 <20120914192554.GA6498@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914192554.GA6498@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, here is version 4 of the patchset. Rather than sending out all the
patches again, the diff to linux-next is given below, and the
refreshed tree can be pulled from

  git://github.com/rydberg/linux.git maybe

All Dmitry's comments are addressed. Changes in short:

* Also move 'slot' to input_mt
* Oops fix amended
* New patch to allow driver pressure handling
* Keep the synaptics specials in bcm5974

Needless to say, I want to move this tree to linux-next soonish, so if
there are more comments coming, I would appreciate a heads-up.

Thanks,
Henrik

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index 4c0e531..c0ec7d4 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -107,7 +107,6 @@ void input_mt_destroy_slots(struct input_dev *dev)
 		kfree(dev->mt);
 	}
 	dev->mt = NULL;
-	dev->slot = 0;
 }
 EXPORT_SYMBOL(input_mt_destroy_slots);
 
@@ -133,7 +132,7 @@ void input_mt_report_slot_state(struct input_dev *dev,
 	if (!mt)
 		return;
 
-	slot = &mt->slots[dev->slot];
+	slot = &mt->slots[mt->slot];
 	slot->frame = mt->frame;
 
 	if (!active) {
@@ -215,13 +214,17 @@ void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count)
 	if (oldest) {
 		int x = input_mt_get_value(oldest, ABS_MT_POSITION_X);
 		int y = input_mt_get_value(oldest, ABS_MT_POSITION_Y);
-		int p = input_mt_get_value(oldest, ABS_MT_PRESSURE);
 
 		input_event(dev, EV_ABS, ABS_X, x);
 		input_event(dev, EV_ABS, ABS_Y, y);
-		input_event(dev, EV_ABS, ABS_PRESSURE, p);
+
+		if (test_bit(ABS_MT_PRESSURE, dev->absbit)) {
+			int p = input_mt_get_value(oldest, ABS_MT_PRESSURE);
+			input_event(dev, EV_ABS, ABS_PRESSURE, p);
+		}
 	} else {
-		input_event(dev, EV_ABS, ABS_PRESSURE, 0);
+		if (test_bit(ABS_MT_PRESSURE, dev->absbit))
+			input_event(dev, EV_ABS, ABS_PRESSURE, 0);
 	}
 }
 EXPORT_SYMBOL(input_mt_report_pointer_emulation);
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 2dff71b..5244f3d 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -208,6 +208,7 @@ static void input_repeat_key(unsigned long data)
 static int input_handle_abs_event(struct input_dev *dev,
 				  unsigned int code, int *pval)
 {
+	struct input_mt *mt = dev->mt;
 	bool is_mt_event;
 	int *pold;
 
@@ -216,8 +217,8 @@ static int input_handle_abs_event(struct input_dev *dev,
 		 * "Stage" the event; we'll flush it later, when we
 		 * get actual touch data.
 		 */
-		if (dev->mt && *pval >= 0 && *pval < dev->mt->num_slots)
-			dev->slot = *pval;
+		if (mt && *pval >= 0 && *pval < mt->num_slots)
+			mt->slot = *pval;
 
 		return INPUT_IGNORE_EVENT;
 	}
@@ -226,8 +227,8 @@ static int input_handle_abs_event(struct input_dev *dev,
 
 	if (!is_mt_event) {
 		pold = &dev->absinfo[code].value;
-	} else if (dev->mt) {
-		pold = &dev->mt->slots[dev->slot].abs[code - ABS_MT_FIRST];
+	} else if (mt) {
+		pold = &mt->slots[mt->slot].abs[code - ABS_MT_FIRST];
 	} else {
 		/*
 		 * Bypass filtering for multi-touch events when
@@ -246,8 +247,8 @@ static int input_handle_abs_event(struct input_dev *dev,
 	}
 
 	/* Flush pending "slot" event */
-	if (is_mt_event && dev->slot != input_abs_get_val(dev, ABS_MT_SLOT)) {
-		input_abs_set_val(dev, ABS_MT_SLOT, dev->slot);
+	if (is_mt_event && mt && mt->slot != input_abs_get_val(dev, ABS_MT_SLOT)) {
+		input_abs_set_val(dev, ABS_MT_SLOT, mt->slot);
 		return INPUT_PASS_TO_HANDLERS | INPUT_SLOT;
 	}
 
@@ -378,7 +379,7 @@ static void input_handle_event(struct input_dev *dev,
 			v = &dev->vals[dev->num_vals++];
 			v->type = EV_ABS;
 			v->code = ABS_MT_SLOT;
-			v->value = dev->slot;
+			v->value = dev->mt->slot;
 		}
 
 		v = &dev->vals[dev->num_vals++];
diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 9555aa5..3a78f23 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -216,10 +216,11 @@ struct bcm5974_config {
 	enum tp_type tp_type;	/* type of trackpad interface */
 	int tp_offset;		/* offset to trackpad finger data */
 	int tp_datalen;		/* data length of the trackpad interface */
-	struct bcm5974_param o;	/* orientation limits */
+	struct bcm5974_param p;	/* finger pressure limits */
 	struct bcm5974_param w;	/* finger width limits */
 	struct bcm5974_param x;	/* horizontal limits */
 	struct bcm5974_param y;	/* vertical limits */
+	struct bcm5974_param o;	/* orientation limits */
 };
 
 /* logical device structure */
@@ -241,9 +242,10 @@ struct bcm5974 {
 };
 
 /* logical signal quality */
-#define SN_ORIENT	10		/* orientation signal-to-noise ratio */
-#define SN_WIDTH	100		/* width signal-to-noise ratio */
+#define SN_PRESSURE	45		/* pressure signal-to-noise ratio */
+#define SN_WIDTH	25		/* width signal-to-noise ratio */
 #define SN_COORD	250		/* coordinate signal-to-noise ratio */
+#define SN_ORIENT	10		/* orientation signal-to-noise ratio */
 
 /* device constants */
 static const struct bcm5974_config bcm5974_config_table[] = {
@@ -254,10 +256,11 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		0,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE1, FINGER_TYPE1, FINGER_TYPE1 + SIZEOF_ALL_FINGERS,
-		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_PRESSURE, 0, 256 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4824, 5342 },
-		{ SN_COORD, -172, 5820 }
+		{ SN_COORD, -172, 5820 },
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION }
 	},
 	{
 		USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI,
@@ -266,10 +269,11 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		0,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE1, FINGER_TYPE1, FINGER_TYPE1 + SIZEOF_ALL_FINGERS,
-		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_PRESSURE, 0, 256 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4824, 4824 },
-		{ SN_COORD, -172, 4290 }
+		{ SN_COORD, -172, 4290 },
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION }
 	},
 	{
 		USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI,
@@ -278,10 +282,11 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
-		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_PRESSURE, 0, 300 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4460, 5166 },
-		{ SN_COORD, -75, 6700 }
+		{ SN_COORD, -75, 6700 },
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION }
 	},
 	{
 		USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI,
@@ -290,10 +295,11 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
-		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_PRESSURE, 0, 300 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4620, 5140 },
-		{ SN_COORD, -150, 6600 }
+		{ SN_COORD, -150, 6600 },
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION }
 	},
 	{
 		USB_DEVICE_ID_APPLE_WELLSPRING4A_ANSI,
@@ -302,10 +308,11 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
-		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_PRESSURE, 0, 300 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4616, 5112 },
-		{ SN_COORD, -142, 5234 }
+		{ SN_COORD, -142, 5234 },
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION }
 	},
 	{
 		USB_DEVICE_ID_APPLE_WELLSPRING5_ANSI,
@@ -314,10 +321,11 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
-		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_PRESSURE, 0, 300 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4415, 5050 },
-		{ SN_COORD, -55, 6680 }
+		{ SN_COORD, -55, 6680 },
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION }
 	},
 	{
 		USB_DEVICE_ID_APPLE_WELLSPRING6_ANSI,
@@ -326,10 +334,11 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
-		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_PRESSURE, 0, 300 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4620, 5140 },
-		{ SN_COORD, -150, 6600 }
+		{ SN_COORD, -150, 6600 },
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION }
 	},
 	{
 		USB_DEVICE_ID_APPLE_WELLSPRING5A_ANSI,
@@ -338,10 +347,11 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
-		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_PRESSURE, 0, 300 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4750, 5280 },
-		{ SN_COORD, -150, 6730 }
+		{ SN_COORD, -150, 6730 },
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION }
 	},
 	{
 		USB_DEVICE_ID_APPLE_WELLSPRING6A_ANSI,
@@ -350,10 +360,11 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
-		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_PRESSURE, 0, 300 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4620, 5140 },
-		{ SN_COORD, -150, 6600 }
+		{ SN_COORD, -150, 6600 },
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION }
 	},
 	{
 		USB_DEVICE_ID_APPLE_WELLSPRING7_ANSI,
@@ -362,10 +373,11 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
-		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_PRESSURE, 0, 300 },
 		{ SN_WIDTH, 0, 2048 },
 		{ SN_COORD, -4750, 5280 },
-		{ SN_COORD, -150, 6730 }
+		{ SN_COORD, -150, 6730 },
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION }
 	},
 	{}
 };
@@ -402,6 +414,10 @@ static void setup_events_to_report(struct input_dev *input_dev,
 {
 	__set_bit(EV_ABS, input_dev->evbit);
 
+	/* for synaptics only */
+	input_set_abs_params(input_dev, ABS_PRESSURE, 0, 256, 5, 0);
+	input_set_abs_params(input_dev, ABS_TOOL_WIDTH, 0, 16, 0, 0);
+
 	/* finger touch area */
 	set_abs(input_dev, ABS_MT_TOUCH_MAJOR, &cfg->w);
 	set_abs(input_dev, ABS_MT_TOUCH_MINOR, &cfg->w);
@@ -462,6 +478,25 @@ static void report_finger_data(struct input_dev *input, int slot,
 	input_report_abs(input, ABS_MT_POSITION_Y, pos->y);
 }
 
+static void report_synaptics_data(struct input_dev *input,
+				  const struct bcm5974_config *cfg,
+				  const struct tp_finger *f, int raw_n)
+{
+	int abs_p = 0, abs_w = 0;
+
+	if (raw_n) {
+		int p = raw2int(f->touch_major);
+		int w = raw2int(f->tool_major);
+		if (p > 0 && raw2int(f->origin)) {
+			abs_p = clamp_val(256 * p / cfg->p.max, 0, 255);
+			abs_w = clamp_val(16 * w / cfg->w.max, 0, 15);
+		}
+	}
+
+	input_report_abs(input, ABS_PRESSURE, abs_p);
+	input_report_abs(input, ABS_TOOL_WIDTH, abs_w);
+}
+
 /* report trackpad data as logical trackpad state */
 static int report_tp_state(struct bcm5974 *dev, int size)
 {
@@ -493,6 +528,8 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 
 	input_mt_sync_frame(input);
 
+	report_synaptics_data(input, c, f, raw_n);
+
 	/* type 2 reports button events via ibt only */
 	if (c->tp_type == TYPE2) {
 		int ibt = raw2int(dev->tp_data[BUTTON_TYPE2]);
diff --git a/include/linux/input.h b/include/linux/input.h
index 797f335..ba48743 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1216,7 +1216,6 @@ struct input_value {
  * @timer: timer for software autorepeat
  * @rep: current values for autorepeat parameters (delay, rate)
  * @mt: pointer to multitouch state
- * @slot: MT slot currently being transmitted
  * @absinfo: array of &struct input_absinfo elements holding information
  *	about absolute axes (current value, min, max, flat, fuzz,
  *	resolution)
@@ -1296,7 +1295,6 @@ struct input_dev {
 	int rep[REP_CNT];
 
 	struct input_mt *mt;
-	int slot;
 
 	struct input_absinfo *absinfo;
 
diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
index bbdc694..cc5cca7 100644
--- a/include/linux/input/mt.h
+++ b/include/linux/input/mt.h
@@ -36,6 +36,7 @@ struct input_mt_slot {
  * struct input_mt - state of tracked contacts
  * @trkid: stores MT tracking ID for the next contact
  * @num_slots: number of MT slots the device uses
+ * @slot: MT slot currently being transmitted
  * @flags: input_mt operation flags
  * @frame: increases every time input_mt_sync_frame() is called
  * @red: reduced cost matrix for in-kernel tracking
@@ -44,6 +45,7 @@ struct input_mt_slot {
 struct input_mt {
 	int trkid;
 	int num_slots;
+	int slot;
 	unsigned int flags;
 	unsigned int frame;
 	int *red;
