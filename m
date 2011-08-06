Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab1HFWY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 18:24:58 -0400
Received: from saarni.dnainternet.net ([83.102.40.136]:59169 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab1HFWYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 18:24:42 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Anssi Hannula <anssi.hannula@iki.fi>
To: dmitry.torokhov@gmail.com
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=202/7=5D=20=5Bmedia=5D=20ati=5Fremote=3A=20migrate=20to=20the=20rc=20subsystem?=
Date: Sun,  7 Aug 2011 01:18:08 +0300
Message-Id: <1312669093-23771-3-git-send-email-anssi.hannula@iki.fi>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1312669093-23771-1-git-send-email-anssi.hannula@iki.fi>
References: <4E3DB2C2.7040104@iki.fi>
 <1312669093-23771-1-git-send-email-anssi.hannula@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Migrate the ATI/X10 RF remote driver to the rc subsystem, allowing the
use of its keymap handling capabilities.

The mouse handling is kept in-driver and now appears as a separate input
device which can be disabled with a new module option (autodetection
would be possible based on receiver, but it wouldn't account for cases
where a remote with mouse is used with a receiver that came with a
remote without mouse).

The remotes have 4-bit programmable IDs, so it would be possible to
support simultaneous use of multiple remotes with different keymaps with
each remote appearing as a separate input device; however,
implementation of that is left for a later date.

The driver previously transmitted all events as keydown/keyup
combinations. That behavior is kept (at least for now) to avoid the
current issue with rc-core where repeat events continue after a button
is released, since that would be a clear regression for this driver.

The keycode mangling algorithm is kept the same, so the new external
keymap has the same values as the old static table.

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
---
 drivers/media/rc/Kconfig              |    1 +
 drivers/media/rc/ati_remote.c         |  262 ++++++++++++++++++++-------------
 drivers/media/rc/keymaps/Makefile     |    1 +
 drivers/media/rc/keymaps/rc-ati-x10.c |  103 +++++++++++++
 include/media/rc-map.h                |    1 +
 5 files changed, 269 insertions(+), 99 deletions(-)
 create mode 100644 drivers/media/rc/keymaps/rc-ati-x10.c

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 4a5b4a6..26937b2 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -100,6 +100,7 @@ config IR_LIRC_CODEC
 config RC_ATI_REMOTE
 	tristate "ATI / X10 USB RF remote control"
 	depends on USB_ARCH_HAS_HCD
+	depends on RC_CORE
 	select USB
 	help
 	   Say Y here if you want to use an ATI or X10 "Lola" USB remote control.
diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index bce5712..a1df21f 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -1,6 +1,7 @@
 /*
  *  USB ATI Remote support
  *
+ *                Copyright (c) 2011 Anssi Hannula <anssi.hannula@iki.fi>
  *  Version 2.2.0 Copyright (c) 2004 Torrey Hoffman <thoffman@arnor.net>
  *  Version 2.1.1 Copyright (c) 2002 Vladimir Dergachev
  *
@@ -90,9 +91,11 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/usb/input.h>
 #include <linux/wait.h>
 #include <linux/jiffies.h>
+#include <media/rc-core.h>
 
 /*
  * Module and Version Information, Module Parameters
@@ -139,6 +142,10 @@ static int repeat_delay = REPEAT_DELAY;
 module_param(repeat_delay, int, 0644);
 MODULE_PARM_DESC(repeat_delay, "Delay before sending repeats, default = 500 msec");
 
+static bool mouse = true;
+module_param(mouse, bool, 0444);
+MODULE_PARM_DESC(mouse, "Enable mouse device, default = yes");
+
 #define dbginfo(dev, format, arg...) do { if (debug) dev_info(dev , format , ## arg); } while (0)
 #undef err
 #define err(format, arg...) printk(KERN_ERR format , ## arg)
@@ -167,6 +174,7 @@ static char init2[] = { 0x01, 0x00, 0x20, 0x14, 0x20, 0x20, 0x20 };
 
 struct ati_remote {
 	struct input_dev *idev;
+	struct rc_dev *rdev;
 	struct usb_device *udev;
 	struct usb_interface *interface;
 
@@ -186,11 +194,16 @@ struct ati_remote {
 
 	unsigned int repeat_count;
 
-	char name[NAME_BUFSIZE];
-	char phys[NAME_BUFSIZE];
+	char rc_name[NAME_BUFSIZE];
+	char rc_phys[NAME_BUFSIZE];
+	char mouse_name[NAME_BUFSIZE];
+	char mouse_phys[NAME_BUFSIZE];
 
 	wait_queue_head_t wait;
 	int send_flags;
+
+	int users; /* 0-2, users are rc and input */
+	struct mutex open_mutex;
 };
 
 /* "Kinds" of messages sent from the hardware to the driver. */
@@ -233,64 +246,11 @@ static const struct {
 	{KIND_FILTERED, 0x3f, 0x7a, EV_KEY, BTN_SIDE, 1}, /* left dblclick */
 	{KIND_FILTERED, 0x43, 0x7e, EV_KEY, BTN_EXTRA, 1},/* right dblclick */
 
-	/* keyboard. */
-	{KIND_FILTERED, 0xd2, 0x0d, EV_KEY, KEY_1, 1},
-	{KIND_FILTERED, 0xd3, 0x0e, EV_KEY, KEY_2, 1},
-	{KIND_FILTERED, 0xd4, 0x0f, EV_KEY, KEY_3, 1},
-	{KIND_FILTERED, 0xd5, 0x10, EV_KEY, KEY_4, 1},
-	{KIND_FILTERED, 0xd6, 0x11, EV_KEY, KEY_5, 1},
-	{KIND_FILTERED, 0xd7, 0x12, EV_KEY, KEY_6, 1},
-	{KIND_FILTERED, 0xd8, 0x13, EV_KEY, KEY_7, 1},
-	{KIND_FILTERED, 0xd9, 0x14, EV_KEY, KEY_8, 1},
-	{KIND_FILTERED, 0xda, 0x15, EV_KEY, KEY_9, 1},
-	{KIND_FILTERED, 0xdc, 0x17, EV_KEY, KEY_0, 1},
-	{KIND_FILTERED, 0xc5, 0x00, EV_KEY, KEY_A, 1},
-	{KIND_FILTERED, 0xc6, 0x01, EV_KEY, KEY_B, 1},
-	{KIND_FILTERED, 0xde, 0x19, EV_KEY, KEY_C, 1},
-	{KIND_FILTERED, 0xe0, 0x1b, EV_KEY, KEY_D, 1},
-	{KIND_FILTERED, 0xe6, 0x21, EV_KEY, KEY_E, 1},
-	{KIND_FILTERED, 0xe8, 0x23, EV_KEY, KEY_F, 1},
-
-	/* "special" keys */
-	{KIND_FILTERED, 0xdd, 0x18, EV_KEY, KEY_KPENTER, 1},    /* "check" */
-	{KIND_FILTERED, 0xdb, 0x16, EV_KEY, KEY_MENU, 1},       /* "menu" */
-	{KIND_FILTERED, 0xc7, 0x02, EV_KEY, KEY_POWER, 1},      /* Power */
-	{KIND_FILTERED, 0xc8, 0x03, EV_KEY, KEY_TV, 1},         /* TV */
-	{KIND_FILTERED, 0xc9, 0x04, EV_KEY, KEY_DVD, 1},        /* DVD */
-	{KIND_FILTERED, 0xca, 0x05, EV_KEY, KEY_WWW, 1},        /* WEB */
-	{KIND_FILTERED, 0xcb, 0x06, EV_KEY, KEY_BOOKMARKS, 1},  /* "book" */
-	{KIND_FILTERED, 0xcc, 0x07, EV_KEY, KEY_EDIT, 1},       /* "hand" */
-	{KIND_FILTERED, 0xe1, 0x1c, EV_KEY, KEY_COFFEE, 1},     /* "timer" */
-	{KIND_FILTERED, 0xe5, 0x20, EV_KEY, KEY_FRONT, 1},      /* "max" */
-	{KIND_FILTERED, 0xe2, 0x1d, EV_KEY, KEY_LEFT, 1},       /* left */
-	{KIND_FILTERED, 0xe4, 0x1f, EV_KEY, KEY_RIGHT, 1},      /* right */
-	{KIND_FILTERED, 0xe7, 0x22, EV_KEY, KEY_DOWN, 1},       /* down */
-	{KIND_FILTERED, 0xdf, 0x1a, EV_KEY, KEY_UP, 1},         /* up */
-	{KIND_FILTERED, 0xe3, 0x1e, EV_KEY, KEY_OK, 1},         /* "OK" */
-	{KIND_FILTERED, 0xce, 0x09, EV_KEY, KEY_VOLUMEDOWN, 1}, /* VOL + */
-	{KIND_FILTERED, 0xcd, 0x08, EV_KEY, KEY_VOLUMEUP, 1},   /* VOL - */
-	{KIND_FILTERED, 0xcf, 0x0a, EV_KEY, KEY_MUTE, 1},       /* MUTE  */
-	{KIND_FILTERED, 0xd0, 0x0b, EV_KEY, KEY_CHANNELUP, 1},  /* CH + */
-	{KIND_FILTERED, 0xd1, 0x0c, EV_KEY, KEY_CHANNELDOWN, 1},/* CH - */
-	{KIND_FILTERED, 0xec, 0x27, EV_KEY, KEY_RECORD, 1},     /* ( o) red */
-	{KIND_FILTERED, 0xea, 0x25, EV_KEY, KEY_PLAY, 1},       /* ( >) */
-	{KIND_FILTERED, 0xe9, 0x24, EV_KEY, KEY_REWIND, 1},     /* (<<) */
-	{KIND_FILTERED, 0xeb, 0x26, EV_KEY, KEY_FORWARD, 1},    /* (>>) */
-	{KIND_FILTERED, 0xed, 0x28, EV_KEY, KEY_STOP, 1},       /* ([]) */
-	{KIND_FILTERED, 0xee, 0x29, EV_KEY, KEY_PAUSE, 1},      /* ('') */
-	{KIND_FILTERED, 0xf0, 0x2b, EV_KEY, KEY_PREVIOUS, 1},   /* (<-) */
-	{KIND_FILTERED, 0xef, 0x2a, EV_KEY, KEY_NEXT, 1},       /* (>+) */
-	{KIND_FILTERED, 0xf2, 0x2D, EV_KEY, KEY_INFO, 1},       /* PLAYING */
-	{KIND_FILTERED, 0xf3, 0x2E, EV_KEY, KEY_HOME, 1},       /* TOP */
-	{KIND_FILTERED, 0xf4, 0x2F, EV_KEY, KEY_END, 1},        /* END */
-	{KIND_FILTERED, 0xf5, 0x30, EV_KEY, KEY_SELECT, 1},     /* SELECT */
-
+	/* Non-mouse events are handled by rc-core */
 	{KIND_END, 0x00, 0x00, EV_MAX + 1, 0, 0}
 };
 
 /* Local function prototypes */
-static int ati_remote_open		(struct input_dev *inputdev);
-static void ati_remote_close		(struct input_dev *inputdev);
 static int ati_remote_sendpacket	(struct ati_remote *ati_remote, u16 cmd, unsigned char *data);
 static void ati_remote_irq_out		(struct urb *urb);
 static void ati_remote_irq_in		(struct urb *urb);
@@ -326,29 +286,60 @@ static void ati_remote_dump(struct device *dev, unsigned char *data,
 /*
  *	ati_remote_open
  */
-static int ati_remote_open(struct input_dev *inputdev)
+static int ati_remote_open(struct ati_remote *ati_remote)
 {
-	struct ati_remote *ati_remote = input_get_drvdata(inputdev);
+	int err = 0;
+
+	mutex_lock(&ati_remote->open_mutex);
+
+	if (ati_remote->users++ != 0)
+		goto out; /* one was already active */
 
 	/* On first open, submit the read urb which was set up previously. */
 	ati_remote->irq_urb->dev = ati_remote->udev;
 	if (usb_submit_urb(ati_remote->irq_urb, GFP_KERNEL)) {
 		dev_err(&ati_remote->interface->dev,
 			"%s: usb_submit_urb failed!\n", __func__);
-		return -EIO;
+		err = -EIO;
 	}
 
-	return 0;
+out:	mutex_unlock(&ati_remote->open_mutex);
+	return err;
 }
 
 /*
  *	ati_remote_close
  */
-static void ati_remote_close(struct input_dev *inputdev)
+static void ati_remote_close(struct ati_remote *ati_remote)
+{
+	mutex_lock(&ati_remote->open_mutex);
+	if (--ati_remote->users == 0)
+		usb_kill_urb(ati_remote->irq_urb);
+	mutex_unlock(&ati_remote->open_mutex);
+}
+
+static int ati_remote_input_open(struct input_dev *inputdev)
 {
 	struct ati_remote *ati_remote = input_get_drvdata(inputdev);
+	return ati_remote_open(ati_remote);
+}
 
-	usb_kill_urb(ati_remote->irq_urb);
+static void ati_remote_input_close(struct input_dev *inputdev)
+{
+	struct ati_remote *ati_remote = input_get_drvdata(inputdev);
+	ati_remote_close(ati_remote);
+}
+
+static int ati_remote_rc_open(struct rc_dev *rdev)
+{
+	struct ati_remote *ati_remote = rdev->priv;
+	return ati_remote_open(ati_remote);
+}
+
+static void ati_remote_rc_close(struct rc_dev *rdev)
+{
+	struct ati_remote *ati_remote = rdev->priv;
+	ati_remote_close(ati_remote);
 }
 
 /*
@@ -413,10 +404,8 @@ static int ati_remote_event_lookup(int rem, unsigned char d1, unsigned char d2)
 		/*
 		 * Decide if the table entry matches the remote input.
 		 */
-		if ((((ati_remote_tbl[i].data1 & 0x0f) == (d1 & 0x0f))) &&
-		    ((((ati_remote_tbl[i].data1 >> 4) -
-		       (d1 >> 4) + rem) & 0x0f) == 0x0f) &&
-		    (ati_remote_tbl[i].data2 == d2))
+		if (ati_remote_tbl[i].data1 == d1 &&
+		    ati_remote_tbl[i].data2 == d2)
 			return i;
 
 	}
@@ -468,8 +457,10 @@ static void ati_remote_input_report(struct urb *urb)
 	struct ati_remote *ati_remote = urb->context;
 	unsigned char *data= ati_remote->inbuf;
 	struct input_dev *dev = ati_remote->idev;
-	int index, acc;
+	int index = -1;
+	int acc;
 	int remote_num;
+	unsigned char scancode[2];
 
 	/* Deal with strange looking inputs */
 	if ( (urb->actual_length != 4) || (data[0] != 0x14) ||
@@ -488,19 +479,26 @@ static void ati_remote_input_report(struct urb *urb)
 		return;
 	}
 
-	/* Look up event code index in translation table */
-	index = ati_remote_event_lookup(remote_num, data[1], data[2]);
-	if (index < 0) {
-		dev_warn(&ati_remote->interface->dev,
-			 "Unknown input from channel 0x%02x: data %02x,%02x\n",
-			 remote_num, data[1], data[2]);
-		return;
-	}
-	dbginfo(&ati_remote->interface->dev,
-		"channel 0x%02x; data %02x,%02x; index %d; keycode %d\n",
-		remote_num, data[1], data[2], index, ati_remote_tbl[index].code);
+	scancode[0] = (((data[1] - ((remote_num + 1) << 4)) & 0xf0) | (data[1] & 0x0f));
 
-	if (ati_remote_tbl[index].kind == KIND_LITERAL) {
+	scancode[1] = data[2];
+
+	/* Look up event code index in mouse translation table. */
+	index = ati_remote_event_lookup(remote_num, scancode[0], scancode[1]);
+
+	if (index >= 0) {
+		dbginfo(&ati_remote->interface->dev,
+			"channel 0x%02x; mouse data %02x,%02x; index %d; keycode %d\n",
+			remote_num, data[1], data[2], index, ati_remote_tbl[index].code);
+		if (!dev)
+			return; /* no mouse device */
+	} else
+		dbginfo(&ati_remote->interface->dev,
+			"channel 0x%02x; key data %02x,%02x, scancode %02x,%02x\n",
+			remote_num, data[1], data[2], scancode[0], scancode[1]);
+
+
+	if (index >= 0 && ati_remote_tbl[index].kind == KIND_LITERAL) {
 		input_event(dev, ati_remote_tbl[index].type,
 			ati_remote_tbl[index].code,
 			ati_remote_tbl[index].value);
@@ -510,7 +508,7 @@ static void ati_remote_input_report(struct urb *urb)
 		return;
 	}
 
-	if (ati_remote_tbl[index].kind == KIND_FILTERED) {
+	if (index < 0 || ati_remote_tbl[index].kind == KIND_FILTERED) {
 		unsigned long now = jiffies;
 
 		/* Filter duplicate events which happen "too close" together. */
@@ -538,6 +536,19 @@ static void ati_remote_input_report(struct urb *urb)
 				      msecs_to_jiffies(repeat_delay))))
 			return;
 
+		if (index < 0) {
+			/* Not a mouse event, hand it to rc-core. */
+			u32 rc_code = (scancode[0] << 8) | scancode[1];
+
+			/*
+			 * We don't use the rc-core repeat handling yet as
+			 * it would cause ghost repeats which would be a
+			 * regression for this driver.
+			 */
+			rc_keydown_notimeout(ati_remote->rdev, rc_code, 0);
+			rc_keyup(ati_remote->rdev);
+			return;
+		}
 
 		input_event(dev, ati_remote_tbl[index].type,
 			ati_remote_tbl[index].code, 1);
@@ -675,16 +686,37 @@ static void ati_remote_input_init(struct ati_remote *ati_remote)
 
 	input_set_drvdata(idev, ati_remote);
 
-	idev->open = ati_remote_open;
-	idev->close = ati_remote_close;
+	idev->open = ati_remote_input_open;
+	idev->close = ati_remote_input_close;
 
-	idev->name = ati_remote->name;
-	idev->phys = ati_remote->phys;
+	idev->name = ati_remote->mouse_name;
+	idev->phys = ati_remote->mouse_phys;
 
 	usb_to_input_id(ati_remote->udev, &idev->id);
 	idev->dev.parent = &ati_remote->udev->dev;
 }
 
+static void ati_remote_rc_init(struct ati_remote *ati_remote)
+{
+	struct rc_dev *rdev = ati_remote->rdev;
+
+	rdev->priv = ati_remote;
+	rdev->driver_type = RC_DRIVER_SCANCODE;
+	rdev->allowed_protos = RC_TYPE_OTHER;
+	rdev->driver_name = "ati_remote";
+
+	rdev->open = ati_remote_rc_open;
+	rdev->close = ati_remote_rc_close;
+
+	rdev->input_name = ati_remote->rc_name;
+	rdev->input_phys = ati_remote->rc_phys;
+
+	usb_to_input_id(ati_remote->udev, &rdev->input_id);
+	rdev->dev.parent = &ati_remote->udev->dev;
+
+	rdev->map_name = RC_MAP_ATI_X10;
+}
+
 static int ati_remote_initialize(struct ati_remote *ati_remote)
 {
 	struct usb_device *udev = ati_remote->udev;
@@ -735,6 +767,7 @@ static int ati_remote_probe(struct usb_interface *interface, const struct usb_de
 	struct usb_endpoint_descriptor *endpoint_in, *endpoint_out;
 	struct ati_remote *ati_remote;
 	struct input_dev *input_dev;
+	struct rc_dev *rc_dev;
 	int err = -ENOMEM;
 
 	if (iface_host->desc.bNumEndpoints != 2) {
@@ -755,8 +788,8 @@ static int ati_remote_probe(struct usb_interface *interface, const struct usb_de
 	}
 
 	ati_remote = kzalloc(sizeof (struct ati_remote), GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!ati_remote || !input_dev)
+	rc_dev = rc_allocate_device();
+	if (!ati_remote || !rc_dev)
 		goto fail1;
 
 	/* Allocate URB buffers, URBs */
@@ -766,44 +799,73 @@ static int ati_remote_probe(struct usb_interface *interface, const struct usb_de
 	ati_remote->endpoint_in = endpoint_in;
 	ati_remote->endpoint_out = endpoint_out;
 	ati_remote->udev = udev;
-	ati_remote->idev = input_dev;
+	ati_remote->rdev = rc_dev;
 	ati_remote->interface = interface;
 
-	usb_make_path(udev, ati_remote->phys, sizeof(ati_remote->phys));
-	strlcat(ati_remote->phys, "/input0", sizeof(ati_remote->phys));
+	usb_make_path(udev, ati_remote->rc_phys, sizeof(ati_remote->rc_phys));
+	strlcpy(ati_remote->mouse_phys, ati_remote->rc_phys,
+		sizeof(ati_remote->mouse_phys));
+
+	strlcat(ati_remote->rc_phys, "/input0", sizeof(ati_remote->rc_phys));
+	strlcat(ati_remote->mouse_phys, "/input1", sizeof(ati_remote->mouse_phys));
 
 	if (udev->manufacturer)
-		strlcpy(ati_remote->name, udev->manufacturer, sizeof(ati_remote->name));
+		strlcpy(ati_remote->rc_name, udev->manufacturer,
+			sizeof(ati_remote->rc_name));
 
 	if (udev->product)
-		snprintf(ati_remote->name, sizeof(ati_remote->name),
-			 "%s %s", ati_remote->name, udev->product);
+		snprintf(ati_remote->rc_name, sizeof(ati_remote->rc_name),
+			 "%s %s", ati_remote->rc_name, udev->product);
 
-	if (!strlen(ati_remote->name))
-		snprintf(ati_remote->name, sizeof(ati_remote->name),
+	if (!strlen(ati_remote->rc_name))
+		snprintf(ati_remote->rc_name, sizeof(ati_remote->rc_name),
 			DRIVER_DESC "(%04x,%04x)",
 			le16_to_cpu(ati_remote->udev->descriptor.idVendor),
 			le16_to_cpu(ati_remote->udev->descriptor.idProduct));
 
-	ati_remote_input_init(ati_remote);
+	snprintf(ati_remote->mouse_name, sizeof(ati_remote->mouse_name),
+		 "%s mouse", ati_remote->rc_name);
 
+	ati_remote_rc_init(ati_remote);
+	mutex_init(&ati_remote->open_mutex);
+	
 	/* Device Hardware Initialization - fills in ati_remote->idev from udev. */
 	err = ati_remote_initialize(ati_remote);
 	if (err)
 		goto fail3;
 
-	/* Set up and register input device */
-	err = input_register_device(ati_remote->idev);
+	/* Set up and register rc device */
+	err = rc_register_device(ati_remote->rdev);
 	if (err)
 		goto fail3;
 
+	/* use our delay for rc_dev */
+	ati_remote->rdev->input_dev->rep[REP_DELAY] = repeat_delay;
+	
+	/* Set up and register mouse input device */
+	if (mouse) {
+		input_dev = input_allocate_device();
+		if (!input_dev)
+			goto fail4;
+
+		ati_remote->idev = input_dev;
+		ati_remote_input_init(ati_remote);
+		err = input_register_device(input_dev);
+
+		if (err)
+			goto fail5;
+	}
+
 	usb_set_intfdata(interface, ati_remote);
 	return 0;
 
+ fail5:	input_free_device(input_dev);
+ fail4:	rc_unregister_device(rc_dev);
+	rc_dev = NULL;
  fail3:	usb_kill_urb(ati_remote->irq_urb);
 	usb_kill_urb(ati_remote->out_urb);
  fail2:	ati_remote_free_buffers(ati_remote);
- fail1:	input_free_device(input_dev);
+ fail1:	rc_free_device(rc_dev);
 	kfree(ati_remote);
 	return err;
 }
@@ -824,7 +886,9 @@ static void ati_remote_disconnect(struct usb_interface *interface)
 
 	usb_kill_urb(ati_remote->irq_urb);
 	usb_kill_urb(ati_remote->out_urb);
-	input_unregister_device(ati_remote->idev);
+	if (ati_remote->idev)
+		input_unregister_device(ati_remote->idev);
+	rc_unregister_device(ati_remote->rdev);
 	ati_remote_free_buffers(ati_remote);
 	kfree(ati_remote);
 }
diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 85cac7d..3ca9265b7 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-apac-viewcomp.o \
 			rc-asus-pc39.o \
 			rc-ati-tv-wonder-hd-600.o \
+			rc-ati-x10.o \
 			rc-avermedia-a16d.o \
 			rc-avermedia.o \
 			rc-avermedia-cardbus.o \
diff --git a/drivers/media/rc/keymaps/rc-ati-x10.c b/drivers/media/rc/keymaps/rc-ati-x10.c
new file mode 100644
index 0000000..c1a055e
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-ati-x10.c
@@ -0,0 +1,103 @@
+/*
+ * ATI X10 RF remote keytable
+ *
+ * Copyright (C) 2011 Anssi Hannula <anssi.hannula@ıki.fi>
+ *
+ * This file is based on the static generic keytable previously found in
+ * ati_remote.c, which is
+ * Copyright (c) 2004 Torrey Hoffman <thoffman@arnor.net>
+ * Copyright (c) 2002 Vladimir Dergachev
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <media/rc-map.h>
+
+static struct rc_map_table ati_x10[] = {
+	{ 0xd20d, KEY_1 },
+	{ 0xd30e, KEY_2 },
+	{ 0xd40f, KEY_3 },
+	{ 0xd510, KEY_4 },
+	{ 0xd611, KEY_5 },
+	{ 0xd712, KEY_6 },
+	{ 0xd813, KEY_7 },
+	{ 0xd914, KEY_8 },
+	{ 0xda15, KEY_9 },
+	{ 0xdc17, KEY_0 },
+	{ 0xc500, KEY_A },
+	{ 0xc601, KEY_B },
+	{ 0xde19, KEY_C },
+	{ 0xe01b, KEY_D },
+	{ 0xe621, KEY_E },
+	{ 0xe823, KEY_F },
+
+	{ 0xdd18, KEY_KPENTER },    /* "check" */
+	{ 0xdb16, KEY_MENU },       /* "menu" */
+	{ 0xc702, KEY_POWER },      /* Power */
+	{ 0xc803, KEY_TV },         /* TV */
+	{ 0xc904, KEY_DVD },        /* DVD */
+	{ 0xca05, KEY_WWW },        /* WEB */
+	{ 0xcb06, KEY_BOOKMARKS },  /* "book" */
+	{ 0xcc07, KEY_EDIT },       /* "hand" */
+	{ 0xe11c, KEY_COFFEE },     /* "timer" */
+	{ 0xe520, KEY_FRONT },      /* "max" */
+	{ 0xe21d, KEY_LEFT },       /* left */
+	{ 0xe41f, KEY_RIGHT },      /* right */
+	{ 0xe722, KEY_DOWN },       /* down */
+	{ 0xdf1a, KEY_UP },         /* up */
+	{ 0xe31e, KEY_OK },         /* "OK" */
+	{ 0xce09, KEY_VOLUMEDOWN }, /* VOL + */
+	{ 0xcd08, KEY_VOLUMEUP },   /* VOL - */
+	{ 0xcf0a, KEY_MUTE },       /* MUTE  */
+	{ 0xd00b, KEY_CHANNELUP },  /* CH + */
+	{ 0xd10c, KEY_CHANNELDOWN },/* CH - */
+	{ 0xec27, KEY_RECORD },     /* ( o) red */
+	{ 0xea25, KEY_PLAY },       /* ( >) */
+	{ 0xe924, KEY_REWIND },     /* (<<) */
+	{ 0xeb26, KEY_FORWARD },    /* (>>) */
+	{ 0xed28, KEY_STOP },       /* ([]) */
+	{ 0xee29, KEY_PAUSE },      /* ('') */
+	{ 0xf02b, KEY_PREVIOUS },   /* (<-) */
+	{ 0xef2a, KEY_NEXT },       /* (>+) */
+	{ 0xf22d, KEY_INFO },       /* PLAYING */
+	{ 0xf32e, KEY_HOME },       /* TOP */
+	{ 0xf42f, KEY_END },        /* END */
+	{ 0xf530, KEY_SELECT },     /* SELECT */
+};
+
+static struct rc_map_list ati_x10_map = {
+	.map = {
+		.scan    = ati_x10,
+		.size    = ARRAY_SIZE(ati_x10),
+		.rc_type = RC_TYPE_OTHER,
+		.name    = RC_MAP_ATI_X10,
+	}
+};
+
+static int __init init_rc_map_ati_x10(void)
+{
+	return rc_map_register(&ati_x10_map);
+}
+
+static void __exit exit_rc_map_ati_x10(void)
+{
+	rc_map_unregister(&ati_x10_map);
+}
+
+module_init(init_rc_map_ati_x10)
+module_exit(exit_rc_map_ati_x10)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Anssi Hannula <anssi.hannula@iki.fi>");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 9184751..09e4451 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -60,6 +60,7 @@ void rc_map_init(void);
 #define RC_MAP_APAC_VIEWCOMP             "rc-apac-viewcomp"
 #define RC_MAP_ASUS_PC39                 "rc-asus-pc39"
 #define RC_MAP_ATI_TV_WONDER_HD_600      "rc-ati-tv-wonder-hd-600"
+#define RC_MAP_ATI_X10                   "rc-ati-x10"
 #define RC_MAP_AVERMEDIA_A16D            "rc-avermedia-a16d"
 #define RC_MAP_AVERMEDIA_CARDBUS         "rc-avermedia-cardbus"
 #define RC_MAP_AVERMEDIA_DVBT            "rc-avermedia-dvbt"
-- 
1.7.4.4

