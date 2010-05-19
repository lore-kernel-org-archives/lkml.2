Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0ESRYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:24:01 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:50846 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab0ESRX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:23:58 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       Daniel Mack <daniel@caiaq.de>, Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 3/4] input: switch to input_abs_*() access functions
Date: Wed, 19 May 2010 19:22:36 +0200
Message-Id: <1274289757-2723-4-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
References: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change all call sites in drivers/input to not access the ABS axis
information directly anymore. Make them use the access helpers instead.

Also use input_set_abs_params() when possible.
Did some code refactoring as I was on it.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/hid/hid-wacom.c             |   15 +++++++------
 drivers/input/evdev.c               |   26 +++++++++++-----------
 drivers/input/input.c               |    7 +++--
 drivers/input/joydev.c              |   24 +++++++++++---------
 drivers/input/joystick/a3d.c        |    2 +-
 drivers/input/joystick/adi.c        |    2 +-
 drivers/input/joystick/amijoy.c     |    4 +-
 drivers/input/joystick/gf2k.c       |   16 +++++++------
 drivers/input/joystick/interact.c   |    8 +++---
 drivers/input/joystick/sidewinder.c |   18 +++++++++++----
 drivers/input/keyboard/hil_kbd.c    |   21 ++++++++++-------
 drivers/input/misc/uinput.c         |   29 ++++++++++++++----------
 drivers/input/mouse/pc110pad.c      |    4 +-
 drivers/input/mouse/synaptics.c     |    4 +-
 drivers/input/mousedev.c            |   40 ++++++++++++++--------------------
 drivers/input/tablet/acecad.c       |   16 +++++++-------
 drivers/input/tablet/aiptek.c       |   18 +++++++-------
 17 files changed, 135 insertions(+), 119 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index f7700cf..ce766a3 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -85,7 +85,7 @@ static int wacom_raw_event(struct hid_device *hdev, struct hid_report *report,
 				input_report_key(input, BTN_RIGHT, 0);
 				input_report_key(input, BTN_MIDDLE, 0);
 				input_report_abs(input, ABS_DISTANCE,
-						input->absmax[ABS_DISTANCE]);
+					input_abs_max(input, ABS_DISTANCE));
 			} else {
 				input_report_key(input, BTN_TOUCH, 0);
 				input_report_key(input, BTN_STYLUS, 0);
@@ -235,13 +235,14 @@ static int wacom_probe(struct hid_device *hdev,
 	set_bit(BTN_TOOL_RUBBER, input->keybit);
 	set_bit(BTN_TOOL_MOUSE, input->keybit);
 
-	input->absmax[ABS_PRESSURE] = 511;
-	input->absmax[ABS_DISTANCE] = 32;
+	input_abs_set_max(input, ABS_PRESSURE, 511);
+	input_abs_set_max(input, ABS_DISTANCE, 32);
 
-	input->absmax[ABS_X] = 16704;
-	input->absmax[ABS_Y] = 12064;
-	input->absfuzz[ABS_X] = 4;
-	input->absfuzz[ABS_Y] = 4;
+	input_abs_set_max(input, ABS_X, 16704);
+	input_abs_set_max(input, ABS_Y, 12064);
+
+	input_abs_set_fuzz(input, ABS_X, 4);
+	input_abs_set_fuzz(input, ABS_Y, 4);
 
 	return 0;
 err_free:
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 2ee6c7a..ab19102 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -624,12 +624,12 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 
 				t = _IOC_NR(cmd) & ABS_MAX;
 
-				abs.value = dev->abs[t];
-				abs.minimum = dev->absmin[t];
-				abs.maximum = dev->absmax[t];
-				abs.fuzz = dev->absfuzz[t];
-				abs.flat = dev->absflat[t];
-				abs.resolution = dev->absres[t];
+				abs.value = input_abs(dev, t);
+				abs.minimum = input_abs_min(dev, t);
+				abs.maximum = input_abs_max(dev, t);
+				abs.fuzz = input_abs_fuzz(dev, t);
+				abs.flat = input_abs_flat(dev, t);
+				abs.resolution = input_abs_res(dev, t);
 
 				if (copy_to_user(p, &abs, min_t(size_t,
 								_IOC_SIZE(cmd),
@@ -672,13 +672,13 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 				 */
 				spin_lock_irq(&dev->event_lock);
 
-				dev->abs[t] = abs.value;
-				dev->absmin[t] = abs.minimum;
-				dev->absmax[t] = abs.maximum;
-				dev->absfuzz[t] = abs.fuzz;
-				dev->absflat[t] = abs.flat;
-				dev->absres[t] = _IOC_SIZE(cmd) < sizeof(struct input_absinfo) ?
-							0 : abs.resolution;
+				input_abs_set(dev, t, abs.value);
+				input_abs_set_min(dev, t, abs.minimum);
+				input_abs_set_max(dev, t, abs.maximum);
+				input_abs_set_fuzz(dev, t, abs.fuzz);
+				input_abs_set_flat(dev, t, abs.flat);
+				input_abs_set_res(dev, t, _IOC_SIZE(cmd) < sizeof(struct input_absinfo) ?
+								0 : abs.resolution);
 
 				spin_unlock_irq(&dev->event_lock);
 
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 9c79bd5..5bc92f6 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -241,10 +241,11 @@ static void input_handle_event(struct input_dev *dev,
 			}
 
 			value = input_defuzz_abs_event(value,
-					dev->abs[code], dev->absfuzz[code]);
+					input_abs(dev, code),
+					input_abs_fuzz(dev, code));
 
-			if (dev->abs[code] != value) {
-				dev->abs[code] = value;
+			if (input_abs(dev, code) != value) {
+				input_abs_set(dev, code, value);
 				disposition = INPUT_PASS_TO_HANDLERS;
 			}
 		}
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index d1902ac..f34fa8a 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -562,11 +562,11 @@ static int joydev_ioctl_common(struct joydev *joydev,
 	case JSIOCSCORR:
 		if (copy_from_user(joydev->corr, argp,
 			      sizeof(joydev->corr[0]) * joydev->nabs))
-		    return -EFAULT;
+			return -EFAULT;
 
 		for (i = 0; i < joydev->nabs; i++) {
 			j = joydev->abspam[i];
-			joydev->abs[i] = joydev_correct(dev->abs[j],
+			joydev->abs[i] = joydev_correct(input_abs(dev, j),
 							&joydev->corr[i]);
 		}
 		return 0;
@@ -849,24 +849,26 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
 
 	for (i = 0; i < joydev->nabs; i++) {
 		j = joydev->abspam[i];
-		if (dev->absmax[j] == dev->absmin[j]) {
+		if (input_abs_max(dev, j) == input_abs_min(dev, j)) {
 			joydev->corr[i].type = JS_CORR_NONE;
-			joydev->abs[i] = dev->abs[j];
+			joydev->abs[i] = input_abs(dev, j);
 			continue;
 		}
 		joydev->corr[i].type = JS_CORR_BROKEN;
-		joydev->corr[i].prec = dev->absfuzz[j];
-		joydev->corr[i].coef[0] =
-			(dev->absmax[j] + dev->absmin[j]) / 2 - dev->absflat[j];
-		joydev->corr[i].coef[1] =
-			(dev->absmax[j] + dev->absmin[j]) / 2 + dev->absflat[j];
+		joydev->corr[i].prec = input_abs_fuzz(dev, j);
+
+		t = (input_abs_max(dev, j) + input_abs_min(dev, j)) / 2
+			- input_abs_flat(dev, j);
+		joydev->corr[i].coef[0] = t;
+		joydev->corr[i].coef[1] = t;
 
-		t = (dev->absmax[j] - dev->absmin[j]) / 2 - 2 * dev->absflat[j];
+		t = (input_abs_max(dev, j) - input_abs_min(dev, j)) / 2
+			- 2 * input_abs_flat(dev, j);
 		if (t) {
 			joydev->corr[i].coef[2] = (1 << 29) / t;
 			joydev->corr[i].coef[3] = (1 << 29) / t;
 
-			joydev->abs[i] = joydev_correct(dev->abs[j],
+			joydev->abs[i] = joydev_correct(input_abs(dev, j),
 							joydev->corr + i);
 		}
 	}
diff --git a/drivers/input/joystick/a3d.c b/drivers/input/joystick/a3d.c
index 6489f40..6b84b72 100644
--- a/drivers/input/joystick/a3d.c
+++ b/drivers/input/joystick/a3d.c
@@ -342,7 +342,7 @@ static int a3d_connect(struct gameport *gameport, struct gameport_driver *drv)
 
 		for (i = 0; i < 4; i++) {
 			if (i < 2)
-				input_set_abs_params(input_dev, axes[i], 48, input_dev->abs[axes[i]] * 2 - 48, 0, 8);
+				input_set_abs_params(input_dev, axes[i], 48, input_abs(input_dev, axes[i]) * 2 - 48, 0, 8);
 			else
 				input_set_abs_params(input_dev, axes[i], 2, 253, 0, 0);
 			input_set_abs_params(input_dev, ABS_HAT0X + i, -1, 1, 0, 0);
diff --git a/drivers/input/joystick/adi.c b/drivers/input/joystick/adi.c
index 89c4c08..7cc9263 100644
--- a/drivers/input/joystick/adi.c
+++ b/drivers/input/joystick/adi.c
@@ -452,7 +452,7 @@ static void adi_init_center(struct adi *adi)
 	for (i = 0; i < adi->axes10 + adi->axes8 + (adi->hats + (adi->pad != -1)) * 2; i++) {
 
 		t = adi->abs[i];
-		x = adi->dev->abs[t];
+		x = input_abs(adi->dev, t);
 
 		if (t == ABS_THROTTLE || t == ABS_RUDDER || adi->id == ADI_ID_WGPE)
 			x = i < adi->axes10 ? 512 : 128;
diff --git a/drivers/input/joystick/amijoy.c b/drivers/input/joystick/amijoy.c
index 05022f0..03022f6 100644
--- a/drivers/input/joystick/amijoy.c
+++ b/drivers/input/joystick/amijoy.c
@@ -139,8 +139,8 @@ static int __init amijoy_init(void)
 		amijoy_dev[i]->keybit[BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) |
 			BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
 		for (j = 0; j < 2; j++) {
-			amijoy_dev[i]->absmin[ABS_X + j] = -1;
-			amijoy_dev[i]->absmax[ABS_X + j] = 1;
+			input_abs_set_min(amijoy_dev[i], ABS_X + j, -1);
+			input_abs_set_max(amijoy_dev[i], ABS_X + j, 1);
 		}
 
 		err = input_register_device(amijoy_dev[i]);
diff --git a/drivers/input/joystick/gf2k.c b/drivers/input/joystick/gf2k.c
index 45ac70e..b51ea20 100644
--- a/drivers/input/joystick/gf2k.c
+++ b/drivers/input/joystick/gf2k.c
@@ -320,8 +320,8 @@ static int gf2k_connect(struct gameport *gameport, struct gameport_driver *drv)
 
 	for (i = 0; i < gf2k_hats[gf2k->id]; i++) {
 		set_bit(ABS_HAT0X + i, input_dev->absbit);
-		input_dev->absmin[ABS_HAT0X + i] = -1;
-		input_dev->absmax[ABS_HAT0X + i] = 1;
+		input_abs_set_min(input_dev, ABS_HAT0X + i, -1);
+		input_abs_set_max(input_dev, ABS_HAT0X + i, 1);
 	}
 
 	for (i = 0; i < gf2k_joys[gf2k->id]; i++)
@@ -334,11 +334,13 @@ static int gf2k_connect(struct gameport *gameport, struct gameport_driver *drv)
 	gf2k_read(gf2k, data);
 
 	for (i = 0; i < gf2k_axes[gf2k->id]; i++) {
-		input_dev->absmax[gf2k_abs[i]] = (i < 2) ? input_dev->abs[gf2k_abs[i]] * 2 - 32 :
-			  input_dev->abs[gf2k_abs[0]] + input_dev->abs[gf2k_abs[1]] - 32;
-		input_dev->absmin[gf2k_abs[i]] = 32;
-		input_dev->absfuzz[gf2k_abs[i]] = 8;
-		input_dev->absflat[gf2k_abs[i]] = (i < 2) ? 24 : 0;
+		int max = (i < 2) ?
+			input_abs(input_dev, gf2k_abs[i]) * 2 - 32 :
+			input_abs(input_dev, gf2k_abs[0]) +
+				input_abs(input_dev, gf2k_abs[1]) - 32;
+		int flat = (i < 2) ? 24 : 0;
+
+		input_set_abs_params(input_dev, gf2k_abs[i], 32, max, 8, flat);
 	}
 
 	err = input_register_device(gf2k->dev);
diff --git a/drivers/input/joystick/interact.c b/drivers/input/joystick/interact.c
index 2478289..0d06cb9 100644
--- a/drivers/input/joystick/interact.c
+++ b/drivers/input/joystick/interact.c
@@ -272,11 +272,11 @@ static int interact_connect(struct gameport *gameport, struct gameport_driver *d
 	for (i = 0; (t = interact_type[interact->type].abs[i]) >= 0; i++) {
 		set_bit(t, input_dev->absbit);
 		if (i < interact_type[interact->type].b8) {
-			input_dev->absmin[t] = 0;
-			input_dev->absmax[t] = 255;
+			input_abs_set_min(input_dev, t, 0);
+			input_abs_set_max(input_dev, t, 255);
 		} else {
-			input_dev->absmin[t] = -1;
-			input_dev->absmax[t] = 1;
+			input_abs_set_min(input_dev, t, -1);
+			input_abs_set_max(input_dev, t, 1);
 		}
 	}
 
diff --git a/drivers/input/joystick/sidewinder.c b/drivers/input/joystick/sidewinder.c
index ca13a6b..76bdbc8 100644
--- a/drivers/input/joystick/sidewinder.c
+++ b/drivers/input/joystick/sidewinder.c
@@ -761,13 +761,21 @@ static int sw_connect(struct gameport *gameport, struct gameport_driver *drv)
 		input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
 		for (j = 0; (bits = sw_bit[sw->type][j]); j++) {
+			int min, max, fuzz, flat;
+
 			code = sw_abs[sw->type][j];
 			set_bit(code, input_dev->absbit);
-			input_dev->absmax[code] = (1 << bits) - 1;
-			input_dev->absmin[code] = (bits == 1) ? -1 : 0;
-			input_dev->absfuzz[code] = ((bits >> 1) >= 2) ? (1 << ((bits >> 1) - 2)) : 0;
-			if (code != ABS_THROTTLE)
-				input_dev->absflat[code] = (bits >= 5) ? (1 << (bits - 5)) : 0;
+
+			min = (bits == 1) ? -1 : 0;
+			max = (1 << bits) - 1;
+			fuzz = ((bits >> 1) >= 2) ? (1 << ((bits >> 1) - 2)) : 0;
+
+			if (code == ABS_THROTTLE)
+				flat = input_abs_flat(input_dev, code);
+			else
+				flat = (bits >= 5) ? (1 << (bits - 5)) : 0;
+
+			input_set_abs_params(input_dev, code, min, max, fuzz, flat);
 		}
 
 		for (j = 0; (code = sw_btn[sw->type][j]); j++)
diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
index c83f4b2..dcc86b9 100644
--- a/drivers/input/keyboard/hil_kbd.c
+++ b/drivers/input/keyboard/hil_kbd.c
@@ -232,15 +232,16 @@ static void hil_dev_handle_ptr_events(struct hil_dev *ptr)
 		if (absdev) {
 			val = lo + (hi << 8);
 #ifdef TABLET_AUTOADJUST
-			if (val < dev->absmin[ABS_X + i])
-				dev->absmin[ABS_X + i] = val;
-			if (val > dev->absmax[ABS_X + i])
-				dev->absmax[ABS_X + i] = val;
+			if (val < input_abs_min(dev, ABS_X + i))
+				input_abs_set_min(dev, ABS_X + i, val);
+			if (val > input_abs_max(dev, ABS_X + i))
+				input_abs_set_max(dev, ABS_X + i, val);
 #endif
-			if (i%3) val = dev->absmax[ABS_X + i] - val;
+			if (i % 3)
+				val = input_abs_max(dev, ABS_X + i) - val;
 			input_report_abs(dev, ABS_X + i, val);
 		} else {
-			val = (int) (((int8_t)lo) | ((int8_t)hi << 8));
+			val = (int) (((int8_t) lo) | ((int8_t) hi << 8));
 			if (i % 3)
 				val *= -1;
 			input_report_rel(dev, REL_X + i, val);
@@ -387,9 +388,11 @@ static void hil_dev_pointer_setup(struct hil_dev *ptr)
 
 #ifdef TABLET_AUTOADJUST
 		for (i = 0; i < ABS_MAX; i++) {
-			int diff = input_dev->absmax[ABS_X + i] / 10;
-			input_dev->absmin[ABS_X + i] += diff;
-			input_dev->absmax[ABS_X + i] -= diff;
+			int diff = input_abs_max(input_dev, ABS_X + i) / 10;
+			input_abs_set_min(input_dev, ABS_X + i,
+				input_abs_min(input_dev, ABS_X + i) + diff)
+			input_abs_set_max(input_dev, ABS_X + i,
+				input_abs_max(input_dev, ABS_X + i) - diff)
 		}
 #endif
 
diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index f3f03b7..988a855 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -304,21 +304,25 @@ static int uinput_validate_absbits(struct input_dev *dev)
 		if (!test_bit(cnt, dev->absbit))
 			continue;
 
-		if ((dev->absmax[cnt] <= dev->absmin[cnt])) {
+		if (input_abs_max(dev, cnt) <= input_abs_min(dev, cnt)) {
 			printk(KERN_DEBUG
 				"%s: invalid abs[%02x] min:%d max:%d\n",
 				UINPUT_NAME, cnt,
-				dev->absmin[cnt], dev->absmax[cnt]);
+				input_abs_min(dev, cnt),
+				input_abs_max(dev, cnt));
 			retval = -EINVAL;
 			break;
 		}
 
-		if (dev->absflat[cnt] > (dev->absmax[cnt] - dev->absmin[cnt])) {
+		if (input_abs_flat(dev, cnt) >
+		    input_abs_max(dev, cnt) - input_abs_min(dev, cnt)) {
 			printk(KERN_DEBUG
-				"%s: absflat[%02x] out of range: %d "
+				"%s: abs_flat #%02x out of range: %d "
 				"(min:%d/max:%d)\n",
-				UINPUT_NAME, cnt, dev->absflat[cnt],
-				dev->absmin[cnt], dev->absmax[cnt]);
+				UINPUT_NAME, cnt,
+				input_abs_flat(dev, cnt),
+				input_abs_min(dev, cnt),
+				input_abs_max(dev, cnt));
 			retval = -EINVAL;
 			break;
 		}
@@ -343,7 +347,7 @@ static int uinput_setup_device(struct uinput_device *udev, const char __user *bu
 	struct uinput_user_dev	*user_dev;
 	struct input_dev	*dev;
 	char			*name;
-	int			size;
+	int			i, size;
 	int			retval;
 
 	if (count != sizeof(struct uinput_user_dev))
@@ -387,11 +391,12 @@ static int uinput_setup_device(struct uinput_device *udev, const char __user *bu
 	dev->id.product	= user_dev->id.product;
 	dev->id.version	= user_dev->id.version;
 
-	size = sizeof(int) * (ABS_CNT);
-	memcpy(dev->absmax, user_dev->absmax, size);
-	memcpy(dev->absmin, user_dev->absmin, size);
-	memcpy(dev->absfuzz, user_dev->absfuzz, size);
-	memcpy(dev->absflat, user_dev->absflat, size);
+	for (i = 0; i < ABS_CNT; i++) {
+		input_abs_set_max(dev, i, user_dev->absmax[i]);
+		input_abs_set_min(dev, i, user_dev->absmin[i]);
+		input_abs_set_fuzz(dev, i, user_dev->absfuzz[i]);
+		input_abs_set_flat(dev, i, user_dev->absflat[i]);
+	}
 
 	/* check if absmin/absmax/absfuzz/absflat are filled as
 	 * told in Documentation/input/input-programming.txt */
diff --git a/drivers/input/mouse/pc110pad.c b/drivers/input/mouse/pc110pad.c
index 3941f97..7b02b65 100644
--- a/drivers/input/mouse/pc110pad.c
+++ b/drivers/input/mouse/pc110pad.c
@@ -145,8 +145,8 @@ static int __init pc110pad_init(void)
 	pc110pad_dev->absbit[0] = BIT_MASK(ABS_X) | BIT_MASK(ABS_Y);
 	pc110pad_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 
-	pc110pad_dev->absmax[ABS_X] = 0x1ff;
-	pc110pad_dev->absmax[ABS_Y] = 0x0ff;
+	input_abs_set_max(pc110pad_dev, ABS_X, 0x1ff);
+	input_abs_set_max(pc110pad_dev, ABS_Y, 0x0ff);
 
 	pc110pad_dev->open = pc110pad_open;
 	pc110pad_dev->close = pc110pad_close;
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 026df60..28c3aab 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -591,8 +591,8 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 	__clear_bit(REL_X, dev->relbit);
 	__clear_bit(REL_Y, dev->relbit);
 
-	dev->absres[ABS_X] = priv->x_res;
-	dev->absres[ABS_Y] = priv->y_res;
+	input_abs_set_res(dev, ABS_X, priv->x_res);
+	input_abs_set_res(dev, ABS_Y, priv->y_res);
 }
 
 static void synaptics_disconnect(struct psmouse *psmouse)
diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index f34b22b..3a965a4 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -22,6 +22,7 @@
 #include <linux/random.h>
 #include <linux/major.h>
 #include <linux/device.h>
+#include <linux/kernel.h>
 #ifdef CONFIG_INPUT_MOUSEDEV_PSAUX
 #include <linux/miscdevice.h>
 #endif
@@ -128,17 +129,20 @@ static void mousedev_touchpad_event(struct input_dev *dev,
 				    struct mousedev *mousedev,
 				    unsigned int code, int value)
 {
-	int size, tmp;
 	enum { FRACTION_DENOM = 128 };
+	int tmp;
+
+	/* use X size for ABS_Y to keep the same scale */
+	int size = input_abs_max(dev, ABS_X) - input_abs_min(dev, ABS_X);
+
+	if (size == 0)
+		size = 256 * 2;
 
 	switch (code) {
 
 	case ABS_X:
 		fx(0) = value;
 		if (mousedev->touch && mousedev->pkt_count >= 2) {
-			size = dev->absmax[ABS_X] - dev->absmin[ABS_X];
-			if (size == 0)
-				size = 256 * 2;
 			tmp = ((value - fx(2)) * 256 * FRACTION_DENOM) / size;
 			tmp += mousedev->frac_dx;
 			mousedev->packet.dx = tmp / FRACTION_DENOM;
@@ -150,10 +154,6 @@ static void mousedev_touchpad_event(struct input_dev *dev,
 	case ABS_Y:
 		fy(0) = value;
 		if (mousedev->touch && mousedev->pkt_count >= 2) {
-			/* use X size to keep the same scale */
-			size = dev->absmax[ABS_X] - dev->absmin[ABS_X];
-			if (size == 0)
-				size = 256 * 2;
 			tmp = -((value - fy(2)) * 256 * FRACTION_DENOM) / size;
 			tmp += mousedev->frac_dy;
 			mousedev->packet.dy = tmp / FRACTION_DENOM;
@@ -167,33 +167,27 @@ static void mousedev_touchpad_event(struct input_dev *dev,
 static void mousedev_abs_event(struct input_dev *dev, struct mousedev *mousedev,
 				unsigned int code, int value)
 {
-	int size;
+	int min = input_abs_min(dev, code);
+	int max = input_abs_max(dev, code);
+	int size = max - min;
+
+	clamp(value, min, max);
 
 	switch (code) {
 
 	case ABS_X:
-		size = dev->absmax[ABS_X] - dev->absmin[ABS_X];
 		if (size == 0)
 			size = xres ? : 1;
-		if (value > dev->absmax[ABS_X])
-			value = dev->absmax[ABS_X];
-		if (value < dev->absmin[ABS_X])
-			value = dev->absmin[ABS_X];
-		mousedev->packet.x =
-			((value - dev->absmin[ABS_X]) * xres) / size;
+
+		mousedev->packet.x = ((value - min) * xres) / size;
 		mousedev->packet.abs_event = 1;
 		break;
 
 	case ABS_Y:
-		size = dev->absmax[ABS_Y] - dev->absmin[ABS_Y];
 		if (size == 0)
 			size = yres ? : 1;
-		if (value > dev->absmax[ABS_Y])
-			value = dev->absmax[ABS_Y];
-		if (value < dev->absmin[ABS_Y])
-			value = dev->absmin[ABS_Y];
-		mousedev->packet.y = yres -
-			((value - dev->absmin[ABS_Y]) * yres) / size;
+
+		mousedev->packet.y = yres - ((value - min) * yres) / size;
 		mousedev->packet.abs_event = 1;
 		break;
 	}
diff --git a/drivers/input/tablet/acecad.c b/drivers/input/tablet/acecad.c
index 670c61c..c4bc2d9 100644
--- a/drivers/input/tablet/acecad.c
+++ b/drivers/input/tablet/acecad.c
@@ -203,9 +203,9 @@ static int usb_acecad_probe(struct usb_interface *intf, const struct usb_device_
 
 	switch (id->driver_info) {
 		case 0:
-			input_dev->absmax[ABS_X] = 5000;
-			input_dev->absmax[ABS_Y] = 3750;
-			input_dev->absmax[ABS_PRESSURE] = 512;
+			input_abs_set_max(input_dev, ABS_X, 5000);
+			input_abs_set_max(input_dev, ABS_Y, 3750);
+			input_abs_set_max(input_dev, ABS_PRESSURE, 512);
 			if (!strlen(acecad->name))
 				snprintf(acecad->name, sizeof(acecad->name),
 					"USB Acecad Flair Tablet %04x:%04x",
@@ -213,9 +213,9 @@ static int usb_acecad_probe(struct usb_interface *intf, const struct usb_device_
 					le16_to_cpu(dev->descriptor.idProduct));
 			break;
 		case 1:
-			input_dev->absmax[ABS_X] = 3000;
-			input_dev->absmax[ABS_Y] = 2250;
-			input_dev->absmax[ABS_PRESSURE] = 1024;
+			input_abs_set_max(input_dev, ABS_X, 3000);
+			input_abs_set_max(input_dev, ABS_Y, 2250);
+			input_abs_set_max(input_dev, ABS_PRESSURE, 1024);
 			if (!strlen(acecad->name))
 				snprintf(acecad->name, sizeof(acecad->name),
 					"USB Acecad 302 Tablet %04x:%04x",
@@ -224,8 +224,8 @@ static int usb_acecad_probe(struct usb_interface *intf, const struct usb_device_
 			break;
 	}
 
-	input_dev->absfuzz[ABS_X] = 4;
-	input_dev->absfuzz[ABS_Y] = 4;
+	input_abs_set_fuzz(input_dev, ABS_X, 4);
+	input_abs_set_fuzz(input_dev, ABS_Y, 4);
 
 	usb_fill_int_urb(acecad->irq, dev, pipe,
 			acecad->data, maxp > 8 ? 8 : maxp,
diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index 4be039d..61ea977 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -987,20 +987,20 @@ static int aiptek_program_tablet(struct aiptek *aiptek)
 	/* Query getXextension */
 	if ((ret = aiptek_query(aiptek, 0x01, 0x00)) < 0)
 		return ret;
-	aiptek->inputdev->absmin[ABS_X] = 0;
-	aiptek->inputdev->absmax[ABS_X] = ret - 1;
+	input_abs_set_min(aiptek->inputdev, ABS_X, 0);
+	input_abs_set_max(aiptek->inputdev, ABS_X, ret - 1);
 
 	/* Query getYextension */
 	if ((ret = aiptek_query(aiptek, 0x01, 0x01)) < 0)
 		return ret;
-	aiptek->inputdev->absmin[ABS_Y] = 0;
-	aiptek->inputdev->absmax[ABS_Y] = ret - 1;
+	input_abs_set_min(aiptek->inputdev, ABS_Y, 0);
+	input_abs_set_max(aiptek->inputdev, ABS_Y, ret - 1);
 
 	/* Query getPressureLevels */
 	if ((ret = aiptek_query(aiptek, 0x08, 0x00)) < 0)
 		return ret;
-	aiptek->inputdev->absmin[ABS_PRESSURE] = 0;
-	aiptek->inputdev->absmax[ABS_PRESSURE] = ret - 1;
+	input_abs_set_min(aiptek->inputdev, ABS_PRESSURE, 0);
+	input_abs_set_max(aiptek->inputdev, ABS_PRESSURE, ret - 1);
 
 	/* Depending on whether we are in absolute or relative mode, we will
 	 * do a switchToTablet(absolute) or switchToMouse(relative) command.
@@ -1054,8 +1054,8 @@ static ssize_t show_tabletSize(struct device *dev, struct device_attribute *attr
 	struct aiptek *aiptek = dev_get_drvdata(dev);
 
 	return snprintf(buf, PAGE_SIZE, "%dx%d\n",
-			aiptek->inputdev->absmax[ABS_X] + 1,
-			aiptek->inputdev->absmax[ABS_Y] + 1);
+			input_abs_max(aiptek->inputdev, ABS_X) + 1,
+			input_abs_max(aiptek->inputdev, ABS_Y) + 1);
 }
 
 /* These structs define the sysfs files, param #1 is the name of the
@@ -1843,7 +1843,7 @@ aiptek_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	for (i = 0; i < ARRAY_SIZE(speeds); ++i) {
 		aiptek->curSetting.programmableDelay = speeds[i];
 		(void)aiptek_program_tablet(aiptek);
-		if (aiptek->inputdev->absmax[ABS_X] > 0) {
+		if (input_abs_max(aiptek->inputdev, ABS_X) > 0) {
 			dev_info(&intf->dev,
 				 "Aiptek using %d ms programming speed\n",
 				 aiptek->curSetting.programmableDelay);
-- 
1.7.1

