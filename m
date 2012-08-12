Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab2HLVk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 17:40:56 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:52515 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab2HLVj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 17:39:56 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap5OADciKFBV5qoUPGdsb2JhbABEhRiFI68/GQEBAQE3NIIhAQUnLxMBDxAISTkKFAYBCQmIEbY6FJEvA5s2jQY
X-IronPort-AV: E=Sophos;i="4.77,756,1336341600"; 
   d="scan'208";a="389105739"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 14/19] Input: bcm5974 - Drop the logical dimensions
Date: Sun, 12 Aug 2012 23:42:32 +0200
Message-Id: <1344807757-2217-15-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logical scale was previously used to produce special width values
to userspace, and its only present use is to put "pressure" hysteresis
on a common scale. However, bcm5974 trackpads are very accurate and
work well without hysteresis.

This patch simplifies the driver and device data by removing the logical
scale altogether. While at it, the fake pressure range is replaced by the
orientation range, which will be used in a subsequent patch.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/bcm5974.c | 193 ++++++++++++++++--------------------------
 1 file changed, 75 insertions(+), 118 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 8443872..fb8ec52 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -200,10 +200,9 @@ struct tp_finger {
 
 /* device-specific parameters */
 struct bcm5974_param {
-	int dim;		/* logical dimension */
-	int fuzz;		/* logical noise value */
-	int devmin;		/* device minimum reading */
-	int devmax;		/* device maximum reading */
+	int snratio;		/* signal-to-noise ratio */
+	int min;		/* device minimum reading */
+	int max;		/* device maximum reading */
 };
 
 /* device-specific configuration */
@@ -216,7 +215,7 @@ struct bcm5974_config {
 	enum tp_type tp_type;	/* type of trackpad interface */
 	int tp_offset;		/* offset to trackpad finger data */
 	int tp_datalen;		/* data length of the trackpad interface */
-	struct bcm5974_param p;	/* finger pressure limits */
+	struct bcm5974_param o;	/* orientation limits */
 	struct bcm5974_param w;	/* finger width limits */
 	struct bcm5974_param x;	/* horizontal limits */
 	struct bcm5974_param y;	/* vertical limits */
@@ -235,24 +234,13 @@ struct bcm5974 {
 	struct bt_data *bt_data;	/* button transferred data */
 	struct urb *tp_urb;		/* trackpad usb request block */
 	u8 *tp_data;			/* trackpad transferred data */
-	int fingers;			/* number of fingers on trackpad */
 };
 
-/* logical dimensions */
-#define DIM_PRESSURE	256		/* maximum finger pressure */
-#define DIM_WIDTH	16		/* maximum finger width */
-#define DIM_X		1280		/* maximum trackpad x value */
-#define DIM_Y		800		/* maximum trackpad y value */
-
 /* logical signal quality */
-#define SN_PRESSURE	45		/* pressure signal-to-noise ratio */
+#define SN_ORIENT	10		/* orientation signal-to-noise ratio */
 #define SN_WIDTH	100		/* width signal-to-noise ratio */
 #define SN_COORD	250		/* coordinate signal-to-noise ratio */
 
-/* pressure thresholds */
-#define PRESSURE_LOW	(2 * DIM_PRESSURE / SN_PRESSURE)
-#define PRESSURE_HIGH	(3 * PRESSURE_LOW)
-
 /* device constants */
 static const struct bcm5974_config bcm5974_config_table[] = {
 	{
@@ -262,10 +250,10 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		0,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE1, FINGER_TYPE1, FINGER_TYPE1 + SIZEOF_ALL_FINGERS,
-		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 256 },
-		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
-		{ DIM_X, DIM_X / SN_COORD, -4824, 5342 },
-		{ DIM_Y, DIM_Y / SN_COORD, -172, 5820 }
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_WIDTH, 0, 2048 },
+		{ SN_COORD, -4824, 5342 },
+		{ SN_COORD, -172, 5820 }
 	},
 	{
 		USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI,
@@ -274,10 +262,10 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		0,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE1, FINGER_TYPE1, FINGER_TYPE1 + SIZEOF_ALL_FINGERS,
-		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 256 },
-		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
-		{ DIM_X, DIM_X / SN_COORD, -4824, 4824 },
-		{ DIM_Y, DIM_Y / SN_COORD, -172, 4290 }
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_WIDTH, 0, 2048 },
+		{ SN_COORD, -4824, 4824 },
+		{ SN_COORD, -172, 4290 }
 	},
 	{
 		USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI,
@@ -286,10 +274,10 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
-		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
-		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
-		{ DIM_X, DIM_X / SN_COORD, -4460, 5166 },
-		{ DIM_Y, DIM_Y / SN_COORD, -75, 6700 }
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_WIDTH, 0, 2048 },
+		{ SN_COORD, -4460, 5166 },
+		{ SN_COORD, -75, 6700 }
 	},
 	{
 		USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI,
@@ -298,10 +286,10 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
-		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
-		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
-		{ DIM_X, DIM_X / SN_COORD, -4620, 5140 },
-		{ DIM_Y, DIM_Y / SN_COORD, -150, 6600 }
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_WIDTH, 0, 2048 },
+		{ SN_COORD, -4620, 5140 },
+		{ SN_COORD, -150, 6600 }
 	},
 	{
 		USB_DEVICE_ID_APPLE_WELLSPRING4A_ANSI,
@@ -310,10 +298,10 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
-		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
-		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
-		{ DIM_X, DIM_X / SN_COORD, -4616, 5112 },
-		{ DIM_Y, DIM_Y / SN_COORD, -142, 5234 }
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_WIDTH, 0, 2048 },
+		{ SN_COORD, -4616, 5112 },
+		{ SN_COORD, -142, 5234 }
 	},
 	{
 		USB_DEVICE_ID_APPLE_WELLSPRING5_ANSI,
@@ -322,10 +310,10 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
-		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
-		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
-		{ DIM_X, DIM_X / SN_COORD, -4415, 5050 },
-		{ DIM_Y, DIM_Y / SN_COORD, -55, 6680 }
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_WIDTH, 0, 2048 },
+		{ SN_COORD, -4415, 5050 },
+		{ SN_COORD, -55, 6680 }
 	},
 	{
 		USB_DEVICE_ID_APPLE_WELLSPRING6_ANSI,
@@ -334,10 +322,10 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
-		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
-		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
-		{ DIM_X, DIM_X / SN_COORD, -4620, 5140 },
-		{ DIM_Y, DIM_Y / SN_COORD, -150, 6600 }
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_WIDTH, 0, 2048 },
+		{ SN_COORD, -4620, 5140 },
+		{ SN_COORD, -150, 6600 }
 	},
 	{
 		USB_DEVICE_ID_APPLE_WELLSPRING5A_ANSI,
@@ -346,10 +334,10 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
-		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
-		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
-		{ DIM_X, DIM_X / SN_COORD, -4750, 5280 },
-		{ DIM_Y, DIM_Y / SN_COORD, -150, 6730 }
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_WIDTH, 0, 2048 },
+		{ SN_COORD, -4750, 5280 },
+		{ SN_COORD, -150, 6730 }
 	},
 	{
 		USB_DEVICE_ID_APPLE_WELLSPRING6A_ANSI,
@@ -358,10 +346,10 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
-		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
-		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
-		{ DIM_X, DIM_X / SN_COORD, -4620, 5140 },
-		{ DIM_Y, DIM_Y / SN_COORD, -150, 6600 }
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_WIDTH, 0, 2048 },
+		{ SN_COORD, -4620, 5140 },
+		{ SN_COORD, -150, 6600 }
 	},
 	{
 		USB_DEVICE_ID_APPLE_WELLSPRING7_ANSI,
@@ -370,10 +358,10 @@ static const struct bcm5974_config bcm5974_config_table[] = {
 		HAS_INTEGRATED_BUTTON,
 		0x84, sizeof(struct bt_data),
 		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
-		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
-		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
-		{ DIM_X, DIM_X / SN_COORD, -4750, 5280 },
-		{ DIM_Y, DIM_Y / SN_COORD, -150, 6730 }
+		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION },
+		{ SN_WIDTH, 0, 2048 },
+		{ SN_COORD, -4750, 5280 },
+		{ SN_COORD, -150, 6730 }
 	},
 	{}
 };
@@ -397,18 +385,11 @@ static inline int raw2int(__le16 x)
 	return (signed short)le16_to_cpu(x);
 }
 
-/* scale device data to logical dimensions (asserts devmin < devmax) */
-static inline int int2scale(const struct bcm5974_param *p, int x)
-{
-	return x * p->dim / (p->devmax - p->devmin);
-}
-
-/* all logical value ranges are [0,dim). */
-static inline int int2bound(const struct bcm5974_param *p, int x)
+static void set_abs(struct input_dev *input, unsigned int code,
+		    const struct bcm5974_param *p)
 {
-	int s = int2scale(p, x);
-
-	return clamp_val(s, 0, p->dim - 1);
+	int fuzz = p->snratio ? (p->max - p->min) / p->snratio : 0;
+	input_set_abs_params(input, code, p->min, p->max, fuzz, 0);
 }
 
 /* setup which logical events to report */
@@ -417,30 +398,21 @@ static void setup_events_to_report(struct input_dev *input_dev,
 {
 	__set_bit(EV_ABS, input_dev->evbit);
 
-	input_set_abs_params(input_dev, ABS_X,
-				0, cfg->x.dim, cfg->x.fuzz, 0);
-	input_set_abs_params(input_dev, ABS_Y,
-				0, cfg->y.dim, cfg->y.fuzz, 0);
+	/* pointer emulation */
+	set_abs(input_dev, ABS_X, &cfg->w);
+	set_abs(input_dev, ABS_Y, &cfg->w);
 
 	/* finger touch area */
-	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
-			     cfg->w.devmin, cfg->w.devmax, 0, 0);
-	input_set_abs_params(input_dev, ABS_MT_TOUCH_MINOR,
-			     cfg->w.devmin, cfg->w.devmax, 0, 0);
+	set_abs(input_dev, ABS_MT_TOUCH_MAJOR, &cfg->w);
+	set_abs(input_dev, ABS_MT_TOUCH_MINOR, &cfg->w);
 	/* finger approach area */
-	input_set_abs_params(input_dev, ABS_MT_WIDTH_MAJOR,
-			     cfg->w.devmin, cfg->w.devmax, 0, 0);
-	input_set_abs_params(input_dev, ABS_MT_WIDTH_MINOR,
-			     cfg->w.devmin, cfg->w.devmax, 0, 0);
+	set_abs(input_dev, ABS_MT_WIDTH_MAJOR, &cfg->w);
+	set_abs(input_dev, ABS_MT_WIDTH_MINOR, &cfg->w);
 	/* finger orientation */
-	input_set_abs_params(input_dev, ABS_MT_ORIENTATION,
-			     -MAX_FINGER_ORIENTATION,
-			     MAX_FINGER_ORIENTATION, 0, 0);
+	set_abs(input_dev, ABS_MT_ORIENTATION, &cfg->o);
 	/* finger position */
-	input_set_abs_params(input_dev, ABS_MT_POSITION_X,
-			     cfg->x.devmin, cfg->x.devmax, 0, 0);
-	input_set_abs_params(input_dev, ABS_MT_POSITION_Y,
-			     cfg->y.devmin, cfg->y.devmax, 0, 0);
+	set_abs(input_dev, ABS_MT_POSITION_X, &cfg->x);
+	set_abs(input_dev, ABS_MT_POSITION_Y, &cfg->y);
 
 	__set_bit(EV_KEY, input_dev->evbit);
 	__set_bit(BTN_TOUCH, input_dev->keybit);
@@ -488,7 +460,7 @@ static void report_finger_data(struct input_dev *input,
 			 MAX_FINGER_ORIENTATION - raw2int(f->orientation));
 	input_report_abs(input, ABS_MT_POSITION_X, raw2int(f->abs_x));
 	input_report_abs(input, ABS_MT_POSITION_Y,
-			 cfg->y.devmin + cfg->y.devmax - raw2int(f->abs_y));
+			 cfg->y.min + cfg->y.max - raw2int(f->abs_y));
 	input_mt_sync(input);
 }
 
@@ -499,8 +471,7 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 	const struct tp_finger *f;
 	struct input_dev *input = dev->input;
 	int raw_p, raw_x, raw_y, raw_n, i;
-	int ptest, origin, ibt = 0, nmin = 0, nmax = 0;
-	int abs_x = 0, abs_y = 0;
+	int abs_x = 0, abs_y = 0, n = 0;
 
 	if (size < c->tp_offset || (size - c->tp_offset) % SIZEOF_FINGER != 0)
 		return -EIO;
@@ -525,48 +496,34 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 			"raw: p: %+05d x: %+05d y: %+05d n: %d\n",
 			raw_p, raw_x, raw_y, raw_n);
 
-		ptest = int2bound(&c->p, raw_p);
-		origin = raw2int(f->origin);
-
 		/* while tracking finger still valid, count all fingers */
-		if (ptest > PRESSURE_LOW && origin) {
-			abs_x = int2bound(&c->x, raw_x - c->x.devmin);
-			abs_y = int2bound(&c->y, c->y.devmax - raw_y);
+		if (raw_p > 0 && raw2int(f->origin)) {
+			abs_x = raw_x;
+			abs_y = c->y.min + c->y.max - raw_y;
 			while (raw_n--) {
-				ptest = int2bound(&c->p,
-						  raw2int(f->touch_major));
-				if (ptest > PRESSURE_LOW)
-					nmax++;
-				if (ptest > PRESSURE_HIGH)
-					nmin++;
+				if (raw2int(f->touch_major) > 0)
+					n++;
 				f++;
 			}
 		}
 	}
 
-	/* set the integrated button if applicable */
-	if (c->tp_type == TYPE2)
-		ibt = raw2int(dev->tp_data[BUTTON_TYPE2]);
-
-	if (dev->fingers < nmin)
-		dev->fingers = nmin;
-	if (dev->fingers > nmax)
-		dev->fingers = nmax;
+	input_report_key(input, BTN_TOUCH, n > 0);
+	input_report_key(input, BTN_TOOL_FINGER, n == 1);
+	input_report_key(input, BTN_TOOL_DOUBLETAP, n == 2);
+	input_report_key(input, BTN_TOOL_TRIPLETAP, n == 3);
+	input_report_key(input, BTN_TOOL_QUADTAP, n > 3);
 
-	input_report_key(input, BTN_TOUCH, dev->fingers > 0);
-	input_report_key(input, BTN_TOOL_FINGER, dev->fingers == 1);
-	input_report_key(input, BTN_TOOL_DOUBLETAP, dev->fingers == 2);
-	input_report_key(input, BTN_TOOL_TRIPLETAP, dev->fingers == 3);
-	input_report_key(input, BTN_TOOL_QUADTAP, dev->fingers > 3);
-
-	if (dev->fingers > 0) {
+	if (n > 0) {
 		input_report_abs(input, ABS_X, abs_x);
 		input_report_abs(input, ABS_Y, abs_y);
 	}
 
 	/* type 2 reports button events via ibt only */
-	if (c->tp_type == TYPE2)
+	if (c->tp_type == TYPE2) {
+		int ibt = raw2int(dev->tp_data[BUTTON_TYPE2]);
 		input_report_key(input, BTN_LEFT, ibt);
+	}
 
 	input_sync(input);
 
-- 
1.7.11.4

