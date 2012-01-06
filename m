Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030350Ab2AFO7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 09:59:52 -0500
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:48132 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758734Ab2AFO7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 09:59:49 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjdfACULB09V5qrvPGdsb2JhbABDiVaicRkBAQEBNzKCIC8TAQ8YgQIKGhOHfLZRE4t+BI0yjTOMWA
X-IronPort-AV: E=Sophos;i="4.71,468,1320620400"; 
   d="scan'208";a="247745103"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chase.douglas@canonical.com>
Subject: [PATCH v2] Input: evdev - Add EVIOC mechanism to extract the MT slot state
Date: Fri,  6 Jan 2012 16:16:59 +0100
Message-Id: <1325863019-2242-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to extract the MT slot state sequentially
via EVIOCGABS. The slot parameter is first selected by calling
EVIOCSABS with ABS_MT_SLOT as argument, followed by a set of EVIOCGABS
calls. The slot selection is local to the evdev client handler, and
does not affect the actual input state.

Cc: Chase Douglas <chase.douglas@canonical.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Dmitry,

the first version of this patch was sent a long time ago (May 2010),
but was put on hold due to a lack of usecases. Now, it seems such a
case has arrived, in the X server (evdev). Some MT events may be much
less frequent than others (ABS_MT_ORIENTATION, for example), resulting
in wrong touch values being assumed after, say, an X restart.

I am not 100% in favor of this patch myself. Perhaps there should be a
more explicit mechanism for selecting slots, for instance.

The patch has been tested against both 3.2 and 3.1 stable.

Cheers,
Henrik

 drivers/input/evdev.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 4cf2534..4878e63 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -20,7 +20,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/input.h>
+#include <linux/input/mt.h>
 #include <linux/major.h>
 #include <linux/device.h>
 #include "input-compat.h"
@@ -46,6 +46,7 @@ struct evdev_client {
 	struct fasync_struct *fasync;
 	struct evdev *evdev;
 	struct list_head node;
+	int mt_slot;		/* used to extract MT events via EVIOC */
 	unsigned int bufsize;
 	struct input_event buffer[];
 };
@@ -621,6 +622,16 @@ static int evdev_handle_set_keycode_v2(struct input_dev *dev, void __user *p)
 	return input_set_keycode(dev, &ke);
 }
 
+static int evdev_get_abs_value(const struct evdev_client *client,
+			       const struct input_dev *dev, unsigned int code)
+{
+	if (code == ABS_MT_SLOT)
+		return client->mt_slot;
+	if (dev->mt && input_is_mt_axis(code))
+		return input_mt_get_value(&dev->mt[client->mt_slot], code);
+	return dev->absinfo[code].value;
+}
+
 static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 			   void __user *p, int compat_mode)
 {
@@ -757,6 +768,7 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 
 			t = _IOC_NR(cmd) & ABS_MAX;
 			abs = dev->absinfo[t];
+			abs.value = evdev_get_abs_value(client, dev, t);
 
 			if (copy_to_user(p, &abs, min_t(size_t,
 					size, sizeof(struct input_absinfo))))
@@ -782,9 +794,12 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 			if (size < sizeof(struct input_absinfo))
 				abs.resolution = 0;
 
-			/* We can't change number of reserved MT slots */
-			if (t == ABS_MT_SLOT)
-				return -EINVAL;
+			/* Set the MT slot to return through EVIOCGABS */
+			if (t == ABS_MT_SLOT) {
+				if (abs.value >= 0 && abs.value < dev->mtsize)
+					client->mt_slot = abs.value;
+				return 0;
+			}
 
 			/*
 			 * Take event lock to ensure that we are not
-- 
1.7.8.1

