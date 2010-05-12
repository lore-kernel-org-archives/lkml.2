Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab0ELPoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:44:06 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:60441 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756092Ab0ELPoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:44:02 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-07.arcor-online.net 2FC5A107DFE
Subject: [PATCH 2/5] HID: Added further information for Roccat Kone
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, wylda@volny.cz,
       Stefan Achatz <erazor_de@users.sourceforge.net>,
       Jerome Vidal <jerom3@free.fr>, Tejun Heo <tj@kernel.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 17:43:59 +0200
Message-ID: <1273679039.2927.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 0875b1fdc784c60d28d3c5bc02ffcf0f30ccea2c Mon Sep 17 00:00:00 2001
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Date: Sat, 8 May 2010 16:53:31 +0200
Subject: [PATCH 2/5] HID: Added further information for Roccat Kone

Added new data and changed workaround for abnormal button behaviour
according to new gained knowledge about Roccat Kone device.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-kone.c |   11 ++++++-----
 drivers/hid/hid-roccat-kone.h |   19 ++++++++++++++++---
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.c
b/drivers/hid/hid-roccat-kone.c
index d23d309..9d68442 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -928,14 +928,15 @@ static int kone_raw_event(struct hid_device *hdev,
struct hid_report *report,
 		return 0;
 
 	/*
-	 * Firmware 1.38 introduced new behaviour for tilt buttons.
-	 * Pressed tilt button is reported in each movement event.
+	 * Firmware 1.38 introduced new behaviour for tilt and special
buttons.
+	 * Pressed button is reported in each movement event.
 	 * Workaround sends only one event per press.
 	 */
-	if (kone->last_tilt_state == event->tilt)
-		event->tilt = 0;
+	if (memcmp(&kone->last_mouse_event.tilt, &event->tilt, 5))
+		memcpy(&kone->last_mouse_event, event,
+				sizeof(struct kone_mouse_event));
 	else
-		kone->last_tilt_state = event->tilt;
+		memset(&event->tilt, 0, 5);
 
 	/*
 	 * handle special events and keep actual profile and dpi values
diff --git a/drivers/hid/hid-roccat-kone.h
b/drivers/hid/hid-roccat-kone.h
index 99290ad..b413b10 100644
--- a/drivers/hid/hid-roccat-kone.h
+++ b/drivers/hid/hid-roccat-kone.h
@@ -80,6 +80,17 @@ enum kone_button_info_types {
 	kone_button_info_type_multimedia_volume_down = 0x27
 };
 
+enum kone_button_info_numbers {
+	kone_button_top = 1,
+	kone_button_wheel_tilt_left = 2,
+	kone_button_wheel_tilt_right = 3,
+	kone_button_forward = 4,
+	kone_button_backward = 5,
+	kone_button_middle = 6,
+	kone_button_plus = 7,
+	kone_button_minus = 8,
+};
+
 struct kone_light_info {
 	uint8_t number; /* number of light 1-5 */
 	uint8_t mod;   /* 1 = on, 2 = off */
@@ -117,6 +128,7 @@ struct kone_profile {
 	uint8_t light_effect_speed; /* range 0-255 */
 
 	struct kone_light_info light_infos[5];
+	/* offset is kone_button_info_numbers - 1 */
 	struct kone_button_info button_infos[8];
 
 	uint16_t checksum; /* \brief holds checksum of struct */
@@ -162,7 +174,7 @@ enum kone_mouse_events {
 	/* TODO clarify meaning and occurence of kone_mouse_event_calibration
*/
 	kone_mouse_event_calibration = 0xc0,
 	kone_mouse_event_call_overlong_macro = 0xe0,
-	/* switch events notify if user changed values wiht mousebutton click
*/
+	/* switch events notify if user changed values with mousebutton click
*/
 	kone_mouse_event_switch_dpi = 0xf0,
 	kone_mouse_event_switch_profile = 0xf1
 };
@@ -185,8 +197,9 @@ struct kone_device {
 	 * is no way of getting this information from the device on demand
 	 */
 	int actual_profile, actual_dpi;
-	/* Used for neutralizing abnormal tilt button behaviour */
-	int last_tilt_state;
+	/* Used for neutralizing abnormal button behaviour */
+	struct kone_mouse_event last_mouse_event;
+
 	/*
 	 * It's unlikely that multiple sysfs attributes are accessed at a
time,
 	 * so only one mutex is used to secure hardware access and profiles
and
-- 
1.6.6.1



