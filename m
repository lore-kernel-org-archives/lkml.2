Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab1A0KgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:36:03 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:33440 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab1A0KgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:36:01 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Ping Cheng <pingc@wacom.com>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Chris Bagwell <chris@cnpbagwell.com>,
        Rafi Rubin <rafi@seas.upenn.edu>, Stephane Chatty <chatty@lii-enac.fr>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 2/2] input: evdev: Add EVIOC mechanism to extract the MT slot state
Date: Thu, 27 Jan 2011 11:35:47 +0100
Message-Id: <1296124547-3323-3-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296124547-3323-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1296124547-3323-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to extract the MT slot state sequentially
via EVIOCGABS. The slot parameter is first selected by calling
EVIOCSABS with ABS_MT_SLOT as argument, followed by a set of EVIOCGABS
calls. The slot selection is local to the evdev client handler, and
does not affect the actual input state.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/input/evdev.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index c8471a2..a689079 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -23,6 +23,7 @@
 #include <linux/input.h>
 #include <linux/major.h>
 #include <linux/device.h>
+#include <linux/input/mt.h>
 #include "input-compat.h"
 
 struct evdev {
@@ -45,6 +46,7 @@ struct evdev_client {
 	struct fasync_struct *fasync;
 	struct evdev *evdev;
 	struct list_head node;
+	int slot; /* used to extract MT events via EVIOC */
 	int bufsize;
 	struct input_event buffer[];
 };
@@ -741,7 +743,7 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 				return -EINVAL;
 
 			t = _IOC_NR(cmd) & ABS_MAX;
-			abs = dev->absinfo[t];
+			abs = input_mt_get_absinfo(dev, t, client->slot);
 
 			if (copy_to_user(p, &abs, min_t(size_t,
 					size, sizeof(struct input_absinfo))))
@@ -767,9 +769,10 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 			if (size < sizeof(struct input_absinfo))
 				abs.resolution = 0;
 
-			/* We can't change number of reserved MT slots */
-			if (t == ABS_MT_SLOT)
-				return -EINVAL;
+			if (t == ABS_MT_SLOT) {
+				client->slot = abs.value;
+				return 0;
+			}
 
 			/*
 			 * Take event lock to ensure that we are not
-- 
1.7.3.4

