Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674Ab0GUIcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 04:32:25 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:49267 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762850Ab0GUIcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 04:32:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GDjdYu0l/brIwg0dYmMi/BSAaeI6FnAwmyKrBzmjscG5skMSp2I5P2NSszjrh0s/B2
         aZPL8HwC3rBugpEhR93WpPE0eBCmb3UwWq7OBLZliEMWxRrghORrx16Z0o0NBrhbEH1Q
         ZVvo0SRvdA5Qp6FYjxWmAvvDF2Yun/eSYRA3Q=
Date: Wed, 21 Jul 2010 01:32:17 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 4/4] input: dynamically allocate ABS information
Message-ID: <20100721083216.GC21558@core.coreip.homeip.net>
References: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
 <1274289757-2723-5-git-send-email-daniel@caiaq.de>
 <20100524160805.GO30801@buzzloop.caiaq.de>
 <20100524161527.GC3182@core.coreip.homeip.net>
 <20100616083903.GU17833@buzzloop.caiaq.de>
 <20100721083048.GA21558@core.coreip.homeip.net>
 <20100721083150.GB21558@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100721083150.GB21558@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Input: dynamically allocate ABS information

From: Daniel Mack <daniel@caiaq.de>

As all callers are now changed to only use the input_abs_*() access
helpers, switching over to dynamically allocated ABS information is
easy.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/evdev.c |   13 +++--------
 drivers/input/input.c |   42 ++++++++++++++++++++++++++++++++++--
 include/linux/input.h |   57 +++++++++++++++----------------------------------
 3 files changed, 62 insertions(+), 50 deletions(-)


diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 9807c8f..251f142 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -691,6 +691,9 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 								  sizeof(struct input_absinfo))))
 					return -EFAULT;
 
+				if (_IOC_SIZE(cmd) < sizeof(struct input_absinfo))
+					abs.resolution = 0;
+
 				/* We can't change number of reserved MT slots */
 				if (t == ABS_MT_SLOT)
 					return -EINVAL;
@@ -701,15 +704,7 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 				 * of event.
 				 */
 				spin_lock_irq(&dev->event_lock);
-
-				input_abs_set_val(dev, t, abs.value);
-				input_abs_set_min(dev, t, abs.minimum);
-				input_abs_set_max(dev, t, abs.maximum);
-				input_abs_set_fuzz(dev, t, abs.fuzz);
-				input_abs_set_flat(dev, t, abs.flat);
-				input_abs_set_res(dev, t, _IOC_SIZE(cmd) < sizeof(struct input_absinfo) ?
-								0 : abs.resolution);
-
+				dev->absinfo[t] = abs;
 				spin_unlock_irq(&dev->event_lock);
 
 				return 0;
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 7259adb..d7fd077 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -182,7 +182,7 @@ static int input_handle_abs_event(struct input_dev *dev,
 	is_mt_event = code >= ABS_MT_FIRST && code <= ABS_MT_LAST;
 
 	if (!is_mt_event) {
-		pold = &dev->abs[code];
+		pold = &dev->absinfo[code].value;
 	} else if (dev->mt) {
 		struct input_mt_slot *mtslot = &dev->mt[dev->slot];
 		pold = &mtslot->abs[code - ABS_MT_FIRST];
@@ -196,7 +196,7 @@ static int input_handle_abs_event(struct input_dev *dev,
 
 	if (pold) {
 		*pval = input_defuzz_abs_event(*pval, *pold,
-						dev->absfuzz[code]);
+						dev->absinfo[code].fuzz);
 		if (*pold == *pval)
 			return INPUT_IGNORE_EVENT;
 
@@ -391,6 +391,43 @@ void input_inject_event(struct input_handle *handle,
 EXPORT_SYMBOL(input_inject_event);
 
 /**
+ * input_alloc_absinfo - allocates array of input_absinfo structs
+ * @dev: the input device emitting absolute events
+ *
+ * If the absinfo struct the caller asked for is already allocated, this
+ * functions will not do anything.
+ */
+void input_alloc_absinfo(struct input_dev *dev)
+{
+	if (!dev->absinfo)
+		dev->absinfo = kcalloc(ABS_CNT, sizeof(struct input_absinfo),
+					GFP_KERNEL);
+
+	WARN(!dev->absinfo, "%s(): kzalloc() failed?\n", __func__);
+}
+EXPORT_SYMBOL(input_alloc_absinfo);
+
+void input_set_abs_params(struct input_dev *dev, unsigned int axis,
+			  int min, int max, int fuzz, int flat)
+{
+	struct input_absinfo *absinfo;
+
+	input_alloc_absinfo(dev);
+	if (!dev->absinfo)
+		return;
+
+	absinfo = &dev->absinfo[axis];
+	absinfo->minimum = min;
+	absinfo->maximum = max;
+	absinfo->fuzz = fuzz;
+	absinfo->flat = flat;
+
+	dev->absbit[BIT_WORD(axis)] |= BIT_MASK(axis);
+}
+EXPORT_SYMBOL(input_set_abs_params);
+
+
+/**
  * input_grab_device - grabs device for exclusive use
  * @handle: input handle that wants to own the device
  *
@@ -1308,6 +1345,7 @@ static void input_dev_release(struct device *device)
 
 	input_ff_destroy(dev);
 	input_mt_destroy_slots(dev);
+	kfree(dev->absinfo);
 	kfree(dev);
 
 	module_put(THIS_MODULE);
diff --git a/include/linux/input.h b/include/linux/input.h
index 4a55311..b5bcde6 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -776,6 +776,7 @@ struct input_absinfo {
 #define REP_DELAY		0x00
 #define REP_PERIOD		0x01
 #define REP_MAX			0x01
+#define REP_CNT			(REP_MAX+1)
 
 /*
  * Sounds
@@ -1099,21 +1100,18 @@ struct input_mt_slot {
  * @repeat_key: stores key code of the last key pressed; used to implement
  *	software autorepeat
  * @timer: timer for software autorepeat
- * @abs: current values for reports from absolute axes
  * @rep: current values for autorepeat parameters (delay, rate)
  * @mt: pointer to array of struct input_mt_slot holding current values
  *	of tracked contacts
  * @mtsize: number of MT slots the device uses
  * @slot: MT slot currently being transmitted
+ * @absinfo: array of struct absinfo elements holding information
+ *	about absolute axes (current value, min, max, flat, fuzz,
+ *	resolution)
  * @key: reflects current state of device's keys/buttons
  * @led: reflects current state of device's LEDs
  * @snd: reflects current state of sound effects
  * @sw: reflects current state of device's switches
- * @absmax: maximum values for events coming from absolute axes
- * @absmin: minimum values for events coming from absolute axes
- * @absfuzz: describes noisiness for axes
- * @absflat: size of the center flat position (used by joydev)
- * @absres: resolution used for events coming form absolute axes
  * @open: this method is called when the very first user calls
  *	input_open_device(). The driver must prepare the device
  *	to start generating events (start polling thread,
@@ -1180,24 +1178,19 @@ struct input_dev {
 	unsigned int repeat_key;
 	struct timer_list timer;
 
-	int abs[ABS_CNT];
-	int rep[REP_MAX + 1];
+	int rep[REP_CNT];
 
 	struct input_mt_slot *mt;
 	int mtsize;
 	int slot;
 
+	struct input_absinfo *absinfo;
+
 	unsigned long key[BITS_TO_LONGS(KEY_CNT)];
 	unsigned long led[BITS_TO_LONGS(LED_CNT)];
 	unsigned long snd[BITS_TO_LONGS(SND_CNT)];
 	unsigned long sw[BITS_TO_LONGS(SW_CNT)];
 
-	int absmax[ABS_CNT];
-	int absmin[ABS_CNT];
-	int absfuzz[ABS_CNT];
-	int absflat[ABS_CNT];
-	int absres[ABS_CNT];
-
 	int (*open)(struct input_dev *dev);
 	void (*close)(struct input_dev *dev);
 	int (*flush)(struct input_dev *dev, struct file *file);
@@ -1459,45 +1452,31 @@ static inline void input_set_events_per_packet(struct input_dev *dev, int n_even
 	dev->hint_events_per_packet = n_events;
 }
 
-static inline void input_set_abs_params(struct input_dev *dev, int axis, int min, int max, int fuzz, int flat)
-{
-	dev->absmin[axis] = min;
-	dev->absmax[axis] = max;
-	dev->absfuzz[axis] = fuzz;
-	dev->absflat[axis] = flat;
-
-	dev->absbit[BIT_WORD(axis)] |= BIT_MASK(axis);
-}
+void input_alloc_absinfo(struct input_dev *dev);
+void input_set_abs_params(struct input_dev *dev, unsigned int axis,
+			  int min, int max, int fuzz, int flat);
 
 #define INPUT_GENERATE_ABS_ACCESSORS(_suffix, _item)			\
 static inline int input_abs_get_##_suffix(struct input_dev *dev,	\
 					  unsigned int axis)		\
 {									\
-	return dev->abs##_item[axis];					\
+	return dev->absinfo ? dev->absinfo[axis]._item : 0;		\
 }									\
 									\
 static inline void input_abs_set_##_suffix(struct input_dev *dev,	\
 					   unsigned int axis, int val)	\
 {									\
-	dev->abs##_item[axis] = val;					\
+	input_alloc_absinfo(dev);					\
+	if (dev->absinfo)						\
+		dev->absinfo[axis]._item = val;				\
 }
 
-INPUT_GENERATE_ABS_ACCESSORS(min, min)
-INPUT_GENERATE_ABS_ACCESSORS(max, max)
+INPUT_GENERATE_ABS_ACCESSORS(val, value)
+INPUT_GENERATE_ABS_ACCESSORS(min, minimum)
+INPUT_GENERATE_ABS_ACCESSORS(max, maximum)
 INPUT_GENERATE_ABS_ACCESSORS(fuzz, fuzz)
 INPUT_GENERATE_ABS_ACCESSORS(flat, flat)
-INPUT_GENERATE_ABS_ACCESSORS(res, res)
-
-static inline int input_abs_get_val(struct input_dev *dev, unsigned int axis)
-{
-	return dev->abs[axis];
-}
-
-static inline void input_abs_set_val(struct input_dev *dev,
-				     unsigned int axis, int val)
-{
-	dev->abs[axis] = val;
-}
+INPUT_GENERATE_ABS_ACCESSORS(res, resolution)
 
 int input_get_keycode(struct input_dev *dev,
 		      unsigned int scancode, unsigned int *keycode);
