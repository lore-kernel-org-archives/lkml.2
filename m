Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab0LOTU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 14:20:59 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:51441 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754998Ab0LOTU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 14:20:57 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pingc@wacom.com>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [RFC v2] input: Introduce device information ioctl
Date: Wed, 15 Dec 2010 20:20:07 +0100
Message-Id: <1292440807-18502-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.2.3
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PSwtX-0004As-4g.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PSwtX-0004As-4g 4a85cd8c737ef249a26d3916dc126a31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today, userspace sets up an input device based on the data it emits.
This is not always enough; a tablet and a touchscreen may emit exactly
the same data, for instance, but the former should be set up with a
pointer whereas the latter does not need to. Recently, a new type of
touchpad has emerged where the buttons are under the pad, which
changes handling logic without changing the emitted data. This patch
introduces a new ioctl, EVIOCGPROP, which enables user access to a set
of device properties useful during setup. The properties are given as
a bitmap in the same fashion as the event types.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi all,

Here is version two of the device information proposal. In addition to
implementing the feedback, this version only defines a single combined
type/capabilities field. Since we want to support a device being of
multiple types, it suggests that we are really after the properties
that make up a type, rather than the types themselves. And since
quirks are also properties, we end up with a single bitmap of
properties instead.

As an example of how this would work for the
touchpad/tablet/touchscreen triplet, there are two properties defined,
INPUT_PROP_POINTER and INPUT_PROP_DIRECT. A touchpad is an indirect
pointer device, a tablet is a direct pointer device, and the
touchscreen is simply a direct device.

What do you think?

Thanks,
Henrik

PS. As before, the patch compiles, but is not further tested.

 drivers/input/evdev.c |    4 ++++
 drivers/input/input.c |    2 ++
 include/linux/input.h |   16 ++++++++++++++++
 3 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index e3f7fc6..0cd97e8 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -677,6 +677,10 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 #define EVIOC_MASK_SIZE(nr)	((nr) & ~(_IOC_SIZEMASK << _IOC_SIZESHIFT))
 	switch (EVIOC_MASK_SIZE(cmd)) {
 
+	case EVIOCGPROP(0):
+		return bits_to_user(dev->propbit, INPUT_PROP_MAX,
+				    size, p, compat_mode);
+
 	case EVIOCGKEY(0):
 		return bits_to_user(dev->key, KEY_MAX, size, p, compat_mode);
 
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 37708d1..ac751ce 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1409,6 +1409,7 @@ INPUT_DEV_CAP_ATTR(LED, led);
 INPUT_DEV_CAP_ATTR(SND, snd);
 INPUT_DEV_CAP_ATTR(FF, ff);
 INPUT_DEV_CAP_ATTR(SW, sw);
+INPUT_DEV_CAP_ATTR(INPUT_PROP, prop);
 
 static struct attribute *input_dev_caps_attrs[] = {
 	&dev_attr_ev.attr,
@@ -1420,6 +1421,7 @@ static struct attribute *input_dev_caps_attrs[] = {
 	&dev_attr_snd.attr,
 	&dev_attr_ff.attr,
 	&dev_attr_sw.attr,
+	&dev_attr_prop.attr,
 	NULL
 };
 
diff --git a/include/linux/input.h b/include/linux/input.h
index b3a1e02..53d6364 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -91,6 +91,7 @@ struct input_keymap_entry {
 #define EVIOCGNAME(len)		_IOC(_IOC_READ, 'E', 0x06, len)		/* get device name */
 #define EVIOCGPHYS(len)		_IOC(_IOC_READ, 'E', 0x07, len)		/* get physical location */
 #define EVIOCGUNIQ(len)		_IOC(_IOC_READ, 'E', 0x08, len)		/* get unique identifier */
+#define EVIOCGPROP(len)		_IOC(_IOC_READ, 'E', 0x09, len)		/* get device properties */
 
 #define EVIOCGKEY(len)		_IOC(_IOC_READ, 'E', 0x18, len)		/* get global key state */
 #define EVIOCGLED(len)		_IOC(_IOC_READ, 'E', 0x19, len)		/* get all LEDs */
@@ -108,6 +109,18 @@ struct input_keymap_entry {
 #define EVIOCGRAB		_IOW('E', 0x90, int)			/* Grab/Release device */
 
 /*
+ * Device properties and quirks
+ */
+
+#define INPUT_PROP_POINTER		0x00	/* needs a pointer */
+#define INPUT_PROP_DIRECT		0x01	/* direct object manipulation */
+#define INPUT_PROP_BUTTONPAD		0x02	/* has button(s) under pad */
+#define INPUT_PROP_SEMI_MT		0x03	/* touch rectangle only */
+
+#define INPUT_PROP_MAX			0x1f
+#define INPUT_PROP_CNT			(INPUT_PROP_MAX + 1)
+
+/*
  * Event types
  */
 
@@ -1090,6 +1103,7 @@ struct ff_effect {
  * @phys: physical path to the device in the system hierarchy
  * @uniq: unique identification code for the device (if device has it)
  * @id: id of the device (struct input_id)
+ * @propbit: bitmap of device properties and quirks
  * @evbit: bitmap of types of events supported by the device (EV_KEY,
  *	EV_REL, etc.)
  * @keybit: bitmap of keys/buttons this device has
@@ -1173,6 +1187,8 @@ struct input_dev {
 	const char *uniq;
 	struct input_id id;
 
+	unsigned long propbit[BITS_TO_LONGS(INPUT_PROP_CNT)];
+
 	unsigned long evbit[BITS_TO_LONGS(EV_CNT)];
 	unsigned long keybit[BITS_TO_LONGS(KEY_CNT)];
 	unsigned long relbit[BITS_TO_LONGS(REL_CNT)];
-- 
1.7.2.3

