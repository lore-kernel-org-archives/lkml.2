Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762847Ab0GUIcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 04:32:15 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:49267 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762814Ab0GUIcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 04:32:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XF3IfGSsXdMctlI1N/9RSj1ZxXoNhwT7PajX79ojI167BUrFpfkYs6Ilvtfr8cmDeh
         VAQqzNESMhFvcIxYqWDyw21/uMrLra/WS9JUjP6kh5KMC+9JIo49eMHXr+onvtGtGK2i
         sQYVMkFe7e60mlNMawW48VMpe7ICY7WUfa7h4=
Date: Wed, 21 Jul 2010 01:31:50 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 4/4] input: dynamically allocate ABS information
Message-ID: <20100721083150.GB21558@core.coreip.homeip.net>
References: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
 <1274289757-2723-5-git-send-email-daniel@caiaq.de>
 <20100524160805.GO30801@buzzloop.caiaq.de>
 <20100524161527.GC3182@core.coreip.homeip.net>
 <20100616083903.GU17833@buzzloop.caiaq.de>
 <20100721083048.GA21558@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100721083048.GA21558@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Input: switch to input_abs_*() access functions

From: Daniel Mack <daniel@caiaq.de>

Change all call sites in drivers/input to not access the ABS axis
information directly anymore. Make them use the access helpers instead.

Also use input_set_abs_params() when possible.
Did some code refactoring as I was on it.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/hid/hid-wacom.c             |   49 +++++++++++++++++------------------
 drivers/input/evdev.c               |   26 +++++++++----------
 drivers/input/input.c               |    4 +--
 drivers/input/joydev.c              |   31 +++++++++++-----------
 drivers/input/joystick/a3d.c        |    3 +-
 drivers/input/joystick/adi.c        |    2 +
 drivers/input/joystick/amijoy.c     |    4 +--
 drivers/input/joystick/gf2k.c       |   20 +++++++-------
 drivers/input/joystick/interact.c   |   14 ++++------
 drivers/input/joystick/sidewinder.c |   18 ++++++++-----
 drivers/input/keyboard/hil_kbd.c    |   21 +++++++++------
 drivers/input/misc/uinput.c         |   29 ++++++++++++---------
 drivers/input/mouse/pc110pad.c      |    4 +--
 drivers/input/mouse/synaptics.c     |    4 +--
 drivers/input/mousedev.c            |   44 +++++++++++++++++++------------
 drivers/input/tablet/aiptek.c       |   15 ++++-------
 drivers/input/tablet/wacom_wac.c    |    4 +--
 17 files changed, 153 insertions(+), 139 deletions(-)


diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 1e051f1..1c4b4ca 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -230,7 +230,7 @@ static int wacom_raw_event(struct hid_device *hdev, struct hid_report *report,
 				input_report_key(input, BTN_RIGHT, 0);
 				input_report_key(input, BTN_MIDDLE, 0);
 				input_report_abs(input, ABS_DISTANCE,
-						input->absmax[ABS_DISTANCE]);
+					input_abs_get_max(input, ABS_DISTANCE));
 			} else {
 				input_report_key(input, BTN_TOUCH, 0);
 				input_report_key(input, BTN_STYLUS, 0);
@@ -383,38 +383,37 @@ move_on:
 
 	/* Basics */
 	input->evbit[0] |= BIT(EV_KEY) | BIT(EV_ABS) | BIT(EV_REL);
-	input->absbit[0] |= BIT(ABS_X) | BIT(ABS_Y) |
-		BIT(ABS_PRESSURE) | BIT(ABS_DISTANCE);
-	input->relbit[0] |= BIT(REL_WHEEL);
-	set_bit(BTN_TOOL_PEN, input->keybit);
-	set_bit(BTN_TOUCH, input->keybit);
-	set_bit(BTN_STYLUS, input->keybit);
-	set_bit(BTN_STYLUS2, input->keybit);
-	set_bit(BTN_LEFT, input->keybit);
-	set_bit(BTN_RIGHT, input->keybit);
-	set_bit(BTN_MIDDLE, input->keybit);
+
+	__set_bit(REL_WHEEL, input->relbit);
+
+	__set_bit(BTN_TOOL_PEN, input->keybit);
+	__set_bit(BTN_TOUCH, input->keybit);
+	__set_bit(BTN_STYLUS, input->keybit);
+	__set_bit(BTN_STYLUS2, input->keybit);
+	__set_bit(BTN_LEFT, input->keybit);
+	__set_bit(BTN_RIGHT, input->keybit);
+	__set_bit(BTN_MIDDLE, input->keybit);
 
 	/* Pad */
 	input->evbit[0] |= BIT(EV_MSC);
-	input->mscbit[0] |= BIT(MSC_SERIAL);
-	set_bit(BTN_0, input->keybit);
-	set_bit(BTN_1, input->keybit);
-	set_bit(BTN_TOOL_FINGER, input->keybit);
 
-	/* Distance, rubber and mouse */
-	input->absbit[0] |= BIT(ABS_DISTANCE);
-	set_bit(BTN_TOOL_RUBBER, input->keybit);
-	set_bit(BTN_TOOL_MOUSE, input->keybit);
+	__set_bit(MSC_SERIAL, input->mscbit);
 
-	input->absmax[ABS_PRESSURE] = 511;
-	input->absmax[ABS_DISTANCE] = 32;
+	__set_bit(BTN_0, input->keybit);
+	__set_bit(BTN_1, input->keybit);
+	__set_bit(BTN_TOOL_FINGER, input->keybit);
 
-	input->absmax[ABS_X] = 16704;
-	input->absmax[ABS_Y] = 12064;
-	input->absfuzz[ABS_X] = 4;
-	input->absfuzz[ABS_Y] = 4;
+	/* Distance, rubber and mouse */
+	__set_bit(BTN_TOOL_RUBBER, input->keybit);
+	__set_bit(BTN_TOOL_MOUSE, input->keybit);
+
+	input_set_abs_params(input, ABS_X, 0, 16704, 4, 0);
+	input_set_abs_params(input, ABS_Y, 0, 12064, 4, 0);
+	input_set_abs_params(input, ABS_PRESSURE, 0, 511, 0, 0);
+	input_set_abs_params(input, ABS_DISTANCE, 0, 32, 0, 0);
 
 	return 0;
+
 err_free:
 	kfree(wdata);
 	return ret;
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 054edf3..9807c8f 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -650,12 +650,12 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 
 				t = _IOC_NR(cmd) & ABS_MAX;
 
-				abs.value = dev->abs[t];
-				abs.minimum = dev->absmin[t];
-				abs.maximum = dev->absmax[t];
-				abs.fuzz = dev->absfuzz[t];
-				abs.flat = dev->absflat[t];
-				abs.resolution = dev->absres[t];
+				abs.value = input_abs_get_val(dev, t);
+				abs.minimum = input_abs_get_min(dev, t);
+				abs.maximum = input_abs_get_max(dev, t);
+				abs.fuzz = input_abs_get_fuzz(dev, t);
+				abs.flat = input_abs_get_flat(dev, t);
+				abs.resolution = input_abs_get_res(dev, t);
 
 				if (copy_to_user(p, &abs, min_t(size_t,
 								_IOC_SIZE(cmd),
@@ -702,13 +702,13 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 				 */
 				spin_lock_irq(&dev->event_lock);
 
-				dev->abs[t] = abs.value;
-				dev->absmin[t] = abs.minimum;
-				dev->absmax[t] = abs.maximum;
-				dev->absfuzz[t] = abs.fuzz;
-				dev->absflat[t] = abs.flat;
-				dev->absres[t] = _IOC_SIZE(cmd) < sizeof(struct input_absinfo) ?
-							0 : abs.resolution;
+				input_abs_set_val(dev, t, abs.value);
+				input_abs_set_min(dev, t, abs.minimum);
+				input_abs_set_max(dev, t, abs.maximum);
+				input_abs_set_fuzz(dev, t, abs.fuzz);
+				input_abs_set_flat(dev, t, abs.flat);
+				input_abs_set_res(dev, t, _IOC_SIZE(cmd) < sizeof(struct input_absinfo) ?
+								0 : abs.resolution);
 
 				spin_unlock_irq(&dev->event_lock);
 
diff --git a/drivers/input/input.c b/drivers/input/input.c
index e1243b4..7259adb 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -204,8 +204,8 @@ static int input_handle_abs_event(struct input_dev *dev,
 	}
 
 	/* Flush pending "slot" event */
-	if (is_mt_event && dev->slot != dev->abs[ABS_MT_SLOT]) {
-		dev->abs[ABS_MT_SLOT] = dev->slot;
+	if (is_mt_event && dev->slot != input_abs_get_val(dev, ABS_MT_SLOT)) {
+		input_abs_set_val(dev, ABS_MT_SLOT, dev->slot);
 		input_pass_event(dev, EV_ABS, ABS_MT_SLOT, dev->slot);
 	}
 
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index 6383458..d85bd8a 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -530,7 +530,7 @@ static int joydev_ioctl_common(struct joydev *joydev,
 {
 	struct input_dev *dev = joydev->handle.dev;
 	size_t len;
-	int i, j;
+	int i;
 	const char *name;
 
 	/* Process fixed-sized commands. */
@@ -562,12 +562,11 @@ static int joydev_ioctl_common(struct joydev *joydev,
 	case JSIOCSCORR:
 		if (copy_from_user(joydev->corr, argp,
 			      sizeof(joydev->corr[0]) * joydev->nabs))
-		    return -EFAULT;
+			return -EFAULT;
 
 		for (i = 0; i < joydev->nabs; i++) {
-			j = joydev->abspam[i];
-			joydev->abs[i] = joydev_correct(dev->abs[j],
-							&joydev->corr[i]);
+			int val = input_abs_get_val(dev, joydev->abspam[i]);
+			joydev->abs[i] = joydev_correct(val, &joydev->corr[i]);
 		}
 		return 0;
 
@@ -848,25 +847,27 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
 
 	for (i = 0; i < joydev->nabs; i++) {
 		j = joydev->abspam[i];
-		if (dev->absmax[j] == dev->absmin[j]) {
+		if (input_abs_get_max(dev, j) == input_abs_get_min(dev, j)) {
 			joydev->corr[i].type = JS_CORR_NONE;
-			joydev->abs[i] = dev->abs[j];
+			joydev->abs[i] = input_abs_get_val(dev, j);
 			continue;
 		}
 		joydev->corr[i].type = JS_CORR_BROKEN;
-		joydev->corr[i].prec = dev->absfuzz[j];
-		joydev->corr[i].coef[0] =
-			(dev->absmax[j] + dev->absmin[j]) / 2 - dev->absflat[j];
-		joydev->corr[i].coef[1] =
-			(dev->absmax[j] + dev->absmin[j]) / 2 + dev->absflat[j];
+		joydev->corr[i].prec = input_abs_get_fuzz(dev, j);
+
+		t = (input_abs_get_max(dev, j) + input_abs_get_min(dev, j)) / 2;
+		joydev->corr[i].coef[0] = t - input_abs_get_flat(dev, j);
+		joydev->corr[i].coef[1] = t + input_abs_get_flat(dev, j);
 
-		t = (dev->absmax[j] - dev->absmin[j]) / 2 - 2 * dev->absflat[j];
+		t = (input_abs_get_max(dev, j) - input_abs_get_min(dev, j)) / 2
+			- 2 * input_abs_get_flat(dev, j);
 		if (t) {
 			joydev->corr[i].coef[2] = (1 << 29) / t;
 			joydev->corr[i].coef[3] = (1 << 29) / t;
 
-			joydev->abs[i] = joydev_correct(dev->abs[j],
-							joydev->corr + i);
+			joydev->abs[i] =
+				joydev_correct(input_abs_get_val(dev, j),
+					       joydev->corr + i);
 		}
 	}
 
diff --git a/drivers/input/joystick/a3d.c b/drivers/input/joystick/a3d.c
index 6489f40..d259b41 100644
--- a/drivers/input/joystick/a3d.c
+++ b/drivers/input/joystick/a3d.c
@@ -342,7 +342,8 @@ static int a3d_connect(struct gameport *gameport, struct gameport_driver *drv)
 
 		for (i = 0; i < 4; i++) {
 			if (i < 2)
-				input_set_abs_params(input_dev, axes[i], 48, input_dev->abs[axes[i]] * 2 - 48, 0, 8);
+				input_set_abs_params(input_dev, axes[i],
+					48, input_abs_get_val(input_dev, axes[i]) * 2 - 48, 0, 8);
 			else
 				input_set_abs_params(input_dev, axes[i], 2, 253, 0, 0);
 			input_set_abs_params(input_dev, ABS_HAT0X + i, -1, 1, 0, 0);
diff --git a/drivers/input/joystick/adi.c b/drivers/input/joystick/adi.c
index 89c4c08..b992fbf 100644
--- a/drivers/input/joystick/adi.c
+++ b/drivers/input/joystick/adi.c
@@ -452,7 +452,7 @@ static void adi_init_center(struct adi *adi)
 	for (i = 0; i < adi->axes10 + adi->axes8 + (adi->hats + (adi->pad != -1)) * 2; i++) {
 
 		t = adi->abs[i];
-		x = adi->dev->abs[t];
+		x = input_abs_get_val(adi->dev, t);
 
 		if (t == ABS_THROTTLE || t == ABS_RUDDER || adi->id == ADI_ID_WGPE)
 			x = i < adi->axes10 ? 512 : 128;
diff --git a/drivers/input/joystick/amijoy.c b/drivers/input/joystick/amijoy.c
index 05022f0..e90694f 100644
--- a/drivers/input/joystick/amijoy.c
+++ b/drivers/input/joystick/amijoy.c
@@ -139,8 +139,8 @@ static int __init amijoy_init(void)
 		amijoy_dev[i]->keybit[BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) |
 			BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
 		for (j = 0; j < 2; j++) {
-			amijoy_dev[i]->absmin[ABS_X + j] = -1;
-			amijoy_dev[i]->absmax[ABS_X + j] = 1;
+			XXinput_set_abs_params(amijoy_dev[i], ABS_X + j,
+					     -1, 1, 0, 0);
 		}
 
 		err = input_register_device(amijoy_dev[i]);
diff --git a/drivers/input/joystick/gf2k.c b/drivers/input/joystick/gf2k.c
index 45ac70e..0536b1b 100644
--- a/drivers/input/joystick/gf2k.c
+++ b/drivers/input/joystick/gf2k.c
@@ -318,11 +318,8 @@ static int gf2k_connect(struct gameport *gameport, struct gameport_driver *drv)
 	for (i = 0; i < gf2k_axes[gf2k->id]; i++)
 		set_bit(gf2k_abs[i], input_dev->absbit);
 
-	for (i = 0; i < gf2k_hats[gf2k->id]; i++) {
-		set_bit(ABS_HAT0X + i, input_dev->absbit);
-		input_dev->absmin[ABS_HAT0X + i] = -1;
-		input_dev->absmax[ABS_HAT0X + i] = 1;
-	}
+	for (i = 0; i < gf2k_hats[gf2k->id]; i++)
+		input_set_abs_params(input_dev, ABS_HAT0X + i, -1, 1, 0, 0);
 
 	for (i = 0; i < gf2k_joys[gf2k->id]; i++)
 		set_bit(gf2k_btn_joy[i], input_dev->keybit);
@@ -334,11 +331,14 @@ static int gf2k_connect(struct gameport *gameport, struct gameport_driver *drv)
 	gf2k_read(gf2k, data);
 
 	for (i = 0; i < gf2k_axes[gf2k->id]; i++) {
-		input_dev->absmax[gf2k_abs[i]] = (i < 2) ? input_dev->abs[gf2k_abs[i]] * 2 - 32 :
-			  input_dev->abs[gf2k_abs[0]] + input_dev->abs[gf2k_abs[1]] - 32;
-		input_dev->absmin[gf2k_abs[i]] = 32;
-		input_dev->absfuzz[gf2k_abs[i]] = 8;
-		input_dev->absflat[gf2k_abs[i]] = (i < 2) ? 24 : 0;
+		int max = i < 2 ?
+			input_abs_get_val(input_dev, gf2k_abs[i]) * 2 :
+			input_abs_get_val(input_dev, gf2k_abs[0]) +
+				input_abs_get_val(input_dev, gf2k_abs[1]);
+		int flat = i < 2 ? 24 : 0;
+
+		input_set_abs_params(input_dev, gf2k_abs[i],
+				     32, max - 32, 8, flat);
 	}
 
 	err = input_register_device(gf2k->dev);
diff --git a/drivers/input/joystick/interact.c b/drivers/input/joystick/interact.c
index 2478289..16fb19d 100644
--- a/drivers/input/joystick/interact.c
+++ b/drivers/input/joystick/interact.c
@@ -270,18 +270,14 @@ static int interact_connect(struct gameport *gameport, struct gameport_driver *d
 	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
 	for (i = 0; (t = interact_type[interact->type].abs[i]) >= 0; i++) {
-		set_bit(t, input_dev->absbit);
-		if (i < interact_type[interact->type].b8) {
-			input_dev->absmin[t] = 0;
-			input_dev->absmax[t] = 255;
-		} else {
-			input_dev->absmin[t] = -1;
-			input_dev->absmax[t] = 1;
-		}
+		if (i < interact_type[interact->type].b8)
+			input_set_abs_params(input_dev, t, 0, 255, 0, 0);
+		else
+			input_set_abs_params(input_dev, t, -1, 1, 0, 0);
 	}
 
 	for (i = 0; (t = interact_type[interact->type].btn[i]) >= 0; i++)
-		set_bit(t, input_dev->keybit);
+		__set_bit(t, input_dev->keybit);
 
 	err = input_register_device(interact->dev);
 	if (err)
diff --git a/drivers/input/joystick/sidewinder.c b/drivers/input/joystick/sidewinder.c
index ca13a6b..b8d8611 100644
--- a/drivers/input/joystick/sidewinder.c
+++ b/drivers/input/joystick/sidewinder.c
@@ -761,17 +761,21 @@ static int sw_connect(struct gameport *gameport, struct gameport_driver *drv)
 		input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
 		for (j = 0; (bits = sw_bit[sw->type][j]); j++) {
+			int min, max, fuzz, flat;
+
 			code = sw_abs[sw->type][j];
-			set_bit(code, input_dev->absbit);
-			input_dev->absmax[code] = (1 << bits) - 1;
-			input_dev->absmin[code] = (bits == 1) ? -1 : 0;
-			input_dev->absfuzz[code] = ((bits >> 1) >= 2) ? (1 << ((bits >> 1) - 2)) : 0;
-			if (code != ABS_THROTTLE)
-				input_dev->absflat[code] = (bits >= 5) ? (1 << (bits - 5)) : 0;
+			min = bits == 1 ? -1 : 0;
+			max = (1 << bits) - 1;
+			fuzz = (bits >> 1) >= 2 ? 1 << ((bits >> 1) - 2) : 0;
+			flat = code == ABS_THROTTLE || bits < 5 ?
+				0 : 1 << (bits - 5);
+
+			input_set_abs_params(input_dev, code,
+					     min, max, fuzz, flat);
 		}
 
 		for (j = 0; (code = sw_btn[sw->type][j]); j++)
-			set_bit(code, input_dev->keybit);
+			__set_bit(code, input_dev->keybit);
 
 		dbg("%s%s [%d-bit id %d data %d]\n", sw->name, comment, m, l, k);
 
diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
index c83f4b2..ddd5afd 100644
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
+				XXinput_abs_set_max(dev, ABS_X + i, val);
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
+			XXinput_abs_set_max(input_dev, ABS_X + i,
+				input_abs_max(input_dev, ABS_X + i) - diff)
 		}
 #endif
 
diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index b71eb55..bb53fd3 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -304,21 +304,25 @@ static int uinput_validate_absbits(struct input_dev *dev)
 		if (!test_bit(cnt, dev->absbit))
 			continue;
 
-		if ((dev->absmax[cnt] <= dev->absmin[cnt])) {
+		if (input_abs_get_max(dev, cnt) <= input_abs_get_min(dev, cnt)) {
 			printk(KERN_DEBUG
 				"%s: invalid abs[%02x] min:%d max:%d\n",
 				UINPUT_NAME, cnt,
-				dev->absmin[cnt], dev->absmax[cnt]);
+				input_abs_get_min(dev, cnt),
+				input_abs_get_max(dev, cnt));
 			retval = -EINVAL;
 			break;
 		}
 
-		if (dev->absflat[cnt] > (dev->absmax[cnt] - dev->absmin[cnt])) {
+		if (input_abs_get_flat(dev, cnt) >
+		    input_abs_get_max(dev, cnt) - input_abs_get_min(dev, cnt)) {
 			printk(KERN_DEBUG
-				"%s: absflat[%02x] out of range: %d "
+				"%s: abs_flat #%02x out of range: %d "
 				"(min:%d/max:%d)\n",
-				UINPUT_NAME, cnt, dev->absflat[cnt],
-				dev->absmin[cnt], dev->absmax[cnt]);
+				UINPUT_NAME, cnt,
+				input_abs_get_flat(dev, cnt),
+				input_abs_get_min(dev, cnt),
+				input_abs_get_max(dev, cnt));
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
 
-	size = sizeof(int) * ABS_CNT;
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
index b980d8b..9ce607e 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -630,8 +630,8 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 	__clear_bit(REL_X, dev->relbit);
 	__clear_bit(REL_Y, dev->relbit);
 
-	dev->absres[ABS_X] = priv->x_res;
-	dev->absres[ABS_Y] = priv->y_res;
+	input_abs_set_res(dev, ABS_X, priv->x_res);
+	input_abs_set_res(dev, ABS_Y, priv->y_res);
 
 	if (SYN_CAP_CLICKPAD(priv->ext_cap_0c)) {
 		/* Clickpads report only left button */
diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index d8f68f7..83c24cc 100644
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
@@ -134,11 +135,14 @@ static void mousedev_touchpad_event(struct input_dev *dev,
 	switch (code) {
 
 	case ABS_X:
+
 		fx(0) = value;
 		if (mousedev->touch && mousedev->pkt_count >= 2) {
-			size = dev->absmax[ABS_X] - dev->absmin[ABS_X];
+			size = input_abs_get_min(dev, ABS_X) -
+					input_abs_get_max(dev, ABS_X);
 			if (size == 0)
 				size = 256 * 2;
+
 			tmp = ((value - fx(2)) * 256 * FRACTION_DENOM) / size;
 			tmp += mousedev->frac_dx;
 			mousedev->packet.dx = tmp / FRACTION_DENOM;
@@ -150,10 +154,12 @@ static void mousedev_touchpad_event(struct input_dev *dev,
 	case ABS_Y:
 		fy(0) = value;
 		if (mousedev->touch && mousedev->pkt_count >= 2) {
-			/* use X size to keep the same scale */
-			size = dev->absmax[ABS_X] - dev->absmin[ABS_X];
+			/* use X size for ABS_Y to keep the same scale */
+			size = input_abs_get_min(dev, ABS_X) -
+					input_abs_get_max(dev, ABS_X);
 			if (size == 0)
 				size = 256 * 2;
+
 			tmp = -((value - fy(2)) * 256 * FRACTION_DENOM) / size;
 			tmp += mousedev->frac_dy;
 			mousedev->packet.dy = tmp / FRACTION_DENOM;
@@ -167,33 +173,35 @@ static void mousedev_touchpad_event(struct input_dev *dev,
 static void mousedev_abs_event(struct input_dev *dev, struct mousedev *mousedev,
 				unsigned int code, int value)
 {
-	int size;
+	int min, max, size;
 
 	switch (code) {
 
 	case ABS_X:
-		size = dev->absmax[ABS_X] - dev->absmin[ABS_X];
+		min = input_abs_get_min(dev, ABS_X);
+		max = input_abs_get_max(dev, ABS_X);
+
+		size = max - min;
 		if (size == 0)
 			size = xres ? : 1;
-		if (value > dev->absmax[ABS_X])
-			value = dev->absmax[ABS_X];
-		if (value < dev->absmin[ABS_X])
-			value = dev->absmin[ABS_X];
-		mousedev->packet.x =
-			((value - dev->absmin[ABS_X]) * xres) / size;
+
+		clamp(value, min, max);
+
+		mousedev->packet.x = ((value - min) * xres) / size;
 		mousedev->packet.abs_event = 1;
 		break;
 
 	case ABS_Y:
-		size = dev->absmax[ABS_Y] - dev->absmin[ABS_Y];
+		min = input_abs_get_min(dev, ABS_Y);
+		max = input_abs_get_max(dev, ABS_Y);
+
+		size = max - min;
 		if (size == 0)
 			size = yres ? : 1;
-		if (value > dev->absmax[ABS_Y])
-			value = dev->absmax[ABS_Y];
-		if (value < dev->absmin[ABS_Y])
-			value = dev->absmin[ABS_Y];
-		mousedev->packet.y = yres -
-			((value - dev->absmin[ABS_Y]) * yres) / size;
+
+		clamp(value, min, max);
+
+		mousedev->packet.y = yres - ((value - min) * yres) / size;
 		mousedev->packet.abs_event = 1;
 		break;
 	}
diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index 51b80b0..57b25b8 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -987,20 +987,17 @@ static int aiptek_program_tablet(struct aiptek *aiptek)
 	/* Query getXextension */
 	if ((ret = aiptek_query(aiptek, 0x01, 0x00)) < 0)
 		return ret;
-	aiptek->inputdev->absmin[ABS_X] = 0;
-	aiptek->inputdev->absmax[ABS_X] = ret - 1;
+	input_set_abs_params(aiptek->inputdev, ABS_X, 0, ret - 1, 0, 0);
 
 	/* Query getYextension */
 	if ((ret = aiptek_query(aiptek, 0x01, 0x01)) < 0)
 		return ret;
-	aiptek->inputdev->absmin[ABS_Y] = 0;
-	aiptek->inputdev->absmax[ABS_Y] = ret - 1;
+	input_set_abs_params(aiptek->inputdev, ABS_Y, 0, ret - 1, 0, 0);
 
 	/* Query getPressureLevels */
 	if ((ret = aiptek_query(aiptek, 0x08, 0x00)) < 0)
 		return ret;
-	aiptek->inputdev->absmin[ABS_PRESSURE] = 0;
-	aiptek->inputdev->absmax[ABS_PRESSURE] = ret - 1;
+	input_set_abs_params(aiptek->inputdev, ABS_PRESSURE, 0, ret - 1, 0, 0);
 
 	/* Depending on whether we are in absolute or relative mode, we will
 	 * do a switchToTablet(absolute) or switchToMouse(relative) command.
@@ -1054,8 +1051,8 @@ static ssize_t show_tabletSize(struct device *dev, struct device_attribute *attr
 	struct aiptek *aiptek = dev_get_drvdata(dev);
 
 	return snprintf(buf, PAGE_SIZE, "%dx%d\n",
-			aiptek->inputdev->absmax[ABS_X] + 1,
-			aiptek->inputdev->absmax[ABS_Y] + 1);
+			input_abs_get_max(aiptek->inputdev, ABS_X) + 1,
+			input_abs_get_max(aiptek->inputdev, ABS_Y) + 1);
 }
 
 /* These structs define the sysfs files, param #1 is the name of the
@@ -1843,7 +1840,7 @@ aiptek_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	for (i = 0; i < ARRAY_SIZE(speeds); ++i) {
 		aiptek->curSetting.programmableDelay = speeds[i];
 		(void)aiptek_program_tablet(aiptek);
-		if (aiptek->inputdev->absmax[ABS_X] > 0) {
+		if (input_abs_get_max(aiptek->inputdev, ABS_X) > 0) {
 			dev_info(&intf->dev,
 				 "Aiptek using %d ms programming speed\n",
 				 aiptek->curSetting.programmableDelay);
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index ce0b460..40d77ba 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -687,10 +687,10 @@ static void wacom_tpc_finger_in(struct wacom_wac *wacom, char *data, int idx)
 	 * protocol.
 	 */
 	if (wacom->last_finger != finger) {
-		if (x == input->abs[ABS_X])
+		if (x == input_abs_get_val(input, ABS_X))
 			x++;
 
-		if (y == input->abs[ABS_Y])
+		if (y == input_abs_get_val(input, ABS_Y))
 			y++;
 	}
 
