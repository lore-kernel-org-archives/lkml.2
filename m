Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab1HFW21 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 18:28:27 -0400
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:44456 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756808Ab1HFW2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 18:28:24 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Anssi Hannula <anssi.hannula@iki.fi>
To: dmitry.torokhov@gmail.com
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=206/7=5D=20=5Bmedia=5D=20ati=5Fremote=3A=20add=20support=20for=20SnapStream=20Firefly=20remote?=
Date: Sun,  7 Aug 2011 01:18:12 +0300
Message-Id: <1312669093-23771-7-git-send-email-anssi.hannula@iki.fi>
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

Add support for SnapStream Firefly remote control.

The protocol differs by having two toggle bits in the scancode. Since
one of the bits is otherwise unused, we can safely handle the bits
unconditionally.

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
---
 drivers/media/rc/ati_remote.c                    |   15 +++-
 drivers/media/rc/keymaps/Makefile                |    1 +
 drivers/media/rc/keymaps/rc-snapstream-firefly.c |  106 ++++++++++++++++++++++
 include/media/rc-map.h                           |    1 +
 4 files changed, 121 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/rc/keymaps/rc-snapstream-firefly.c

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 4576462..9e03efa 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -107,6 +107,7 @@
 #define ATI_REMOTE_PRODUCT_ID		0x0004
 #define NVIDIA_REMOTE_PRODUCT_ID	0x0005
 #define MEDION_REMOTE_PRODUCT_ID	0x0006
+#define FIREFLY_REMOTE_PRODUCT_ID	0x0008
 
 #define DRIVER_VERSION	        "2.2.1"
 #define DRIVER_AUTHOR           "Torrey Hoffman <thoffman@arnor.net>"
@@ -156,6 +157,7 @@ static struct usb_device_id ati_remote_table[] = {
 	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, ATI_REMOTE_PRODUCT_ID),	.driver_info = (unsigned long)RC_MAP_ATI_X10 },
 	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, NVIDIA_REMOTE_PRODUCT_ID),	.driver_info = (unsigned long)RC_MAP_ATI_X10 },
 	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, MEDION_REMOTE_PRODUCT_ID),	.driver_info = (unsigned long)RC_MAP_MEDION_X10 },
+	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, FIREFLY_REMOTE_PRODUCT_ID),	.driver_info = (unsigned long)RC_MAP_SNAPSTREAM_FIREFLY },
 	{}	/* Terminating entry */
 };
 
@@ -482,7 +484,15 @@ static void ati_remote_input_report(struct urb *urb)
 
 	scancode[0] = (((data[1] - ((remote_num + 1) << 4)) & 0xf0) | (data[1] & 0x0f));
 
-	scancode[1] = data[2];
+	/*
+	 * Some devices (e.g. SnapStream Firefly) use 8080 as toggle code,
+	 * so we have to clear them. The first bit is a bit tricky as the
+	 * "non-toggled" state depends on remote_num, so we xor it with the
+	 * second bit which is only used for toggle.
+	 */
+	scancode[0] ^= (data[2] & 0x80);
+
+	scancode[1] = data[2] & ~0x80;
 
 	/* Look up event code index in mouse translation table. */
 	index = ati_remote_event_lookup(remote_num, scancode[0], scancode[1]);
@@ -546,7 +556,8 @@ static void ati_remote_input_report(struct urb *urb)
 			 * it would cause ghost repeats which would be a
 			 * regression for this driver.
 			 */
-			rc_keydown_notimeout(ati_remote->rdev, rc_code, 0);
+			rc_keydown_notimeout(ati_remote->rdev, rc_code,
+					     data[2]);
 			rc_keyup(ati_remote->rdev);
 			return;
 		}
diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index c3d0f34..5ff4d10 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -72,6 +72,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-hauppauge.o \
 			rc-rc6-mce.o \
 			rc-real-audio-220-32-keys.o \
+			rc-snapstream-firefly.o \
 			rc-streamzap.o \
 			rc-tbs-nec.o \
 			rc-technisat-usb2.o \
diff --git a/drivers/media/rc/keymaps/rc-snapstream-firefly.c b/drivers/media/rc/keymaps/rc-snapstream-firefly.c
new file mode 100644
index 0000000..2df02e4
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-snapstream-firefly.c
@@ -0,0 +1,106 @@
+/*
+ * SnapStream Firefly X10 RF remote keytable
+ *
+ * Copyright (C) 2011 Anssi Hannula <anssi.hannula@ıki.fi>
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
+static struct rc_map_table snapstream_firefly[] = {
+	{ 0xf12c, KEY_ZOOM },       /* Maximize */
+	{ 0xc702, KEY_CLOSE },
+	
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
+	{ 0xdb16, KEY_BACK },
+	{ 0xdd18, KEY_KPENTER },    /* ent */
+
+	{ 0xce09, KEY_VOLUMEUP },
+	{ 0xcd08, KEY_VOLUMEDOWN },
+	{ 0xcf0a, KEY_MUTE },
+	{ 0xd00b, KEY_CHANNELUP },
+	{ 0xd10c, KEY_CHANNELDOWN },
+	{ 0xc500, KEY_VENDOR },     /* firefly */
+
+	{ 0xf32e, KEY_INFO },
+	{ 0xf42f, KEY_OPTION },
+
+	{ 0xe21d, KEY_LEFT },
+	{ 0xe41f, KEY_RIGHT },
+	{ 0xe722, KEY_DOWN },
+	{ 0xdf1a, KEY_UP },
+	{ 0xe31e, KEY_OK },
+	
+	{ 0xe11c, KEY_MENU },
+	{ 0xe520, KEY_EXIT },
+	
+	{ 0xec27, KEY_RECORD },
+	{ 0xea25, KEY_PLAY },
+	{ 0xed28, KEY_STOP },
+	{ 0xe924, KEY_REWIND },
+	{ 0xeb26, KEY_FORWARD },
+	{ 0xee29, KEY_PAUSE },
+	{ 0xf02b, KEY_PREVIOUS },
+	{ 0xef2a, KEY_NEXT },
+
+	{ 0xcb06, KEY_AUDIO },      /* Music */
+	{ 0xca05, KEY_IMAGES },     /* Photos */
+	{ 0xc904, KEY_DVD },
+	{ 0xc803, KEY_TV },
+	{ 0xcc07, KEY_VIDEO },
+
+	{ 0xc601, KEY_HELP },
+	{ 0xf22d, KEY_MODE },       /* Mouse */
+
+	{ 0xde19, KEY_A },
+	{ 0xe01b, KEY_B },
+	{ 0xe621, KEY_C },
+	{ 0xe823, KEY_D },
+};
+
+static struct rc_map_list snapstream_firefly_map = {
+	.map = {
+		.scan    = snapstream_firefly,
+		.size    = ARRAY_SIZE(snapstream_firefly),
+		.rc_type = RC_TYPE_OTHER,
+		.name    = RC_MAP_SNAPSTREAM_FIREFLY,
+	}
+};
+
+static int __init init_rc_map_snapstream_firefly(void)
+{
+	return rc_map_register(&snapstream_firefly_map);
+}
+
+static void __exit exit_rc_map_snapstream_firefly(void)
+{
+	rc_map_unregister(&snapstream_firefly_map);
+}
+
+module_init(init_rc_map_snapstream_firefly)
+module_exit(exit_rc_map_snapstream_firefly)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Anssi Hannula <anssi.hannula@iki.fi>");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 86e7e85..9bc16cf 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -131,6 +131,7 @@ void rc_map_init(void);
 #define RC_MAP_RC5_TV                    "rc-rc5-tv"
 #define RC_MAP_RC6_MCE                   "rc-rc6-mce"
 #define RC_MAP_REAL_AUDIO_220_32_KEYS    "rc-real-audio-220-32-keys"
+#define RC_MAP_SNAPSTREAM_FIREFLY        "rc-snapstream-firefly"
 #define RC_MAP_STREAMZAP                 "rc-streamzap"
 #define RC_MAP_TBS_NEC                   "rc-tbs-nec"
 #define RC_MAP_TECHNISAT_USB2            "rc-technisat-usb2"
-- 
1.7.4.4

