Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab0LHBBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:01:39 -0500
Received: from kroah.org ([198.145.64.141]:49038 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932220Ab0LHBBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:37 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:35 2010
Message-Id: <20101208005735.598416833@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Philipp Merkel <mail@philmerk.de>,
        =?ISO-8859-15?q?St=C3=A9phane=20Chatty?= <chatty@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [142/289] HID: Fix for problems with eGalax/DWAV multi-touch-screen
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Philipp Merkel <mail@philmerk.de>

commit f51661105c3c8a0afcd69f995a4f4a10e53da153 upstream.

This patch fixes three problems with the eGalax/DWAV multi-touch
screen found in the Eee PC T101MT:

1) While there is a dedicated multitouch driver for the screen
   (hid-egalax.c), the MULTI_INPUT quirk is also applied, preventing
   the hid-egalax driver from working. This patch removes the quirk
   so the hid-egalax driver can handle the device correctly.
2) The x and y coordinates sent by the screen in multi-touch mode are
   shifted by three bits from the events sent in single-touch mode, thus
   the coordinates are out of range, leading to the pointer being stuck
   in the bottom-right corner if no additional calibration is applied
   (e.g. in the X evdev driver). This patch shifts the coordinates back.
   This does not decrease accuracy as the last three bits of the "wrong"
   coordinates are always 0.
3) Only multi-touch pressure events are sent, single touch emulation is
   missing pressure information. This patch adds single-touch
   ABS_PRESSURE events.

Signed-off-by: Philipp Merkel <mail@philmerk.de>
Acked-by: Stéphane Chatty <chatty@enac.fr>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-egalax.c        |   16 +++++++++++-----
 drivers/hid/usbhid/hid-quirks.c |    1 -
 2 files changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/hid/hid-egalax.c
+++ b/drivers/hid/hid-egalax.c
@@ -31,7 +31,7 @@ struct egalax_data {
 	bool first;		/* is this the first finger in the frame? */
 	bool valid;		/* valid finger data, or just placeholder? */
 	bool activity;		/* at least one active finger previously? */
-	__u16 lastx, lasty;	/* latest valid (x, y) in the frame */
+	__u16 lastx, lasty, lastz;	/* latest valid (x, y, z) in the frame */
 };
 
 static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
@@ -79,6 +79,10 @@ static int egalax_input_mapping(struct h
 		case HID_DG_TIPPRESSURE:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_PRESSURE);
+			/* touchscreen emulation */
+			input_set_abs_params(hi->input, ABS_PRESSURE,
+						field->logical_minimum,
+						field->logical_maximum, 0, 0);
 			return 1;
 		}
 		return 0;
@@ -109,8 +113,8 @@ static void egalax_filter_event(struct e
 	if (td->valid) {
 		/* emit multitouch events */
 		input_event(input, EV_ABS, ABS_MT_TRACKING_ID, td->id);
-		input_event(input, EV_ABS, ABS_MT_POSITION_X, td->x);
-		input_event(input, EV_ABS, ABS_MT_POSITION_Y, td->y);
+		input_event(input, EV_ABS, ABS_MT_POSITION_X, td->x >> 3);
+		input_event(input, EV_ABS, ABS_MT_POSITION_Y, td->y >> 3);
 		input_event(input, EV_ABS, ABS_MT_PRESSURE, td->z);
 
 		input_mt_sync(input);
@@ -121,6 +125,7 @@ static void egalax_filter_event(struct e
 		 */
 		td->lastx = td->x;
 		td->lasty = td->y;
+		td->lastz = td->z;
 	}
 
 	/*
@@ -129,8 +134,9 @@ static void egalax_filter_event(struct e
 	 * the oldest on the panel, the one we want for single touch
 	 */
 	if (!td->first && td->activity) {
-		input_event(input, EV_ABS, ABS_X, td->lastx);
-		input_event(input, EV_ABS, ABS_Y, td->lasty);
+		input_event(input, EV_ABS, ABS_X, td->lastx >> 3);
+		input_event(input, EV_ABS, ABS_Y, td->lasty >> 3);
+ 		input_event(input, EV_ABS, ABS_PRESSURE, td->lastz);
 	}
 
 	if (!td->valid) {
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -34,7 +34,6 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_ALPS, USB_DEVICE_ID_IBM_GAMEPAD, HID_QUIRK_BADPAD },
 	{ USB_VENDOR_ID_CHIC, USB_DEVICE_ID_CHIC_GAMEPAD, HID_QUIRK_BADPAD },
 	{ USB_VENDOR_ID_DWAV, USB_DEVICE_ID_EGALAX_TOUCHCONTROLLER, HID_QUIRK_MULTI_INPUT | HID_QUIRK_NOGET },
-	{ USB_VENDOR_ID_DWAV, USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_MOJO, USB_DEVICE_ID_RETRO_ADAPTER, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_TURBOX, USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_DRIVING, HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },


