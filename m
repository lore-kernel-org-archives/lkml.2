Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760783Ab0J0JKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:10:40 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47959 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab0J0JKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:10:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ffhA6X5d3Gt3Nrh4LDqmqlm65jS0b1rRqJYp4DIEEcSWSSNU/VZioDsvDVi1it4XQO
         Let3Wt9Ngox3PSFVenxYm72KGT/bS8x/JrKi56FRe84LgnXkWpBxSGv80B5jzSEOX50O
         vdxaohX5/q+sf8AJ4abauptZF7ZyZkKnB+P+A=
Date: Wed, 27 Oct 2010 02:10:29 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tom Vier <tom@triadsys.com>
Cc: Samuel Thibault <sthibault@debian.org>, 594089@bugs.debian.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: Bug#594089: keyboard-configuration: caps lock keycode problem
Message-ID: <20101027091029.GB28895@core.coreip.homeip.net>
References: <20100903235540.GA9149@const>
 <4C866913.3030201@triadsys.com>
 <4C8E6861.1070502@triadsys.com>
 <20101024144150.GV24091@const.famille.thibault.fr>
 <20101025045003.GA1438@core.coreip.homeip.net>
 <4CC58816.3090301@triadsys.com>
 <20101025180320.GA4725@const.famille.thibault.fr>
 <4CC6E9D8.8010201@triadsys.com>
 <20101026161820.GE13097@core.coreip.homeip.net>
 <4CC7426C.8040502@triadsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC7426C.8040502@triadsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 05:04:44PM -0400, Tom Vier wrote:
> On 10/26/2010 12:18 PM, Dmitry Torokhov wrote:
> >Hmm, it looks like it uses the same usages (MSC_SCAN) for
> >CapsLock/Favorites and RightShift/Previous... What does lsusb say about
> >the keyboard (VID/PID)?
> 
> The scroll wheel on the keyboard is a separate device:
> 
> Bus 005 Device 003: ID 046d:c30a Logitech, Inc. iTouch Composite
> Bus 005 Device 002: ID 046d:c016 Logitech, Inc. Optical Wheel Mouse
> 

Thanks Tom. This device is handled by drivers/hid/hid-lg.c sub-driver
and there seem to be a few issues there, still I do not see how they can
produce the results you are seeing.

First of all, the device appears to use duplicate usages for
CapsLock/Favorites and RightShift/Previous so we better set up the
duplicate usages quirk. I wonder how the other OS copes with diferent
keys using the same usages. Jiri, any ideas?

Also, based on evtest data I only see presses/releases for one key (Caps
Lock, Right Shift, etc.) I do not see the presses for the additional
keys in the evtest stream so I am baffled as to where the additional
scancode is coming from... Do you have some funky keymap loaded?
Anything interesting in dumpkeys?

-- 
Dmitry

Input: hid-lgff - mark Logitech Elite as having duplicate reports

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Also make sure we clear bits when mapping keys to ensure that
hid-input will not try to "add" more keycodes.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/hid/hid-lg.c |   59 ++++++++++++++++++++++++++++++++++----------------
 1 files changed, 40 insertions(+), 19 deletions(-)


diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index b629fba..2979b68 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -78,8 +78,8 @@ static __u8 *lg_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	return rdesc;
 }
 
-#define lg_map_key_clear(c)	hid_map_usage_clear(hi, usage, bit, max, \
-		EV_KEY, (c))
+#define lg_map_key_clear(c) \
+	hid_map_usage_clear(hi, usage, bit, max, EV_KEY, (c))
 
 static int lg_ultrax_remote_mapping(struct hid_input *hi,
 		struct hid_usage *usage, unsigned long **bit, int *max)
@@ -88,6 +88,7 @@ static int lg_ultrax_remote_mapping(struct hid_input *hi,
 		return 0;
 
 	set_bit(EV_REP, hi->input->evbit);
+
 	switch (usage->hid & HID_USAGE) {
 	/* Reported on Logitech Ultra X Media Remote */
 	case 0x004: lg_map_key_clear(KEY_AGAIN);	break;
@@ -168,8 +169,10 @@ static int lg_wireless_mapping(struct hid_input *hi, struct hid_usage *usage,
 	case 0x102a: lg_map_key_clear(KEY_BACK);		break;
 	case 0x102b: lg_map_key_clear(KEY_CYCLEWINDOWS);	break;
 	case 0x102d: lg_map_key_clear(KEY_WWW);			break;
-	/* The following two are 'Start/answer call' and 'End/reject call'
-	   on the MX3200 */
+	/*
+	 * The following two are 'Start/answer call' and 'End/reject call'
+	 * on the MX3200
+	 */
 	case 0x1031: lg_map_key_clear(KEY_OK);			break;
 	case 0x1032: lg_map_key_clear(KEY_CANCEL);		break;
 	case 0x1041: lg_map_key_clear(KEY_BATTERY);		break;
@@ -195,17 +198,35 @@ static int lg_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
-	/* extended mapping for certain Logitech hardware (Logitech cordless
-	   desktop LX500) */
+	/*
+	 * Extended mapping for certain Logitech hardware (such as
+	 * Logitech cordless desktop LX500)
+	 */
 	static const u8 e_keymap[] = {
-		  0,216,  0,213,175,156,  0,  0,  0,  0,
-		144,  0,  0,  0,  0,  0,  0,  0,  0,212,
-		174,167,152,161,112,  0,  0,  0,154,  0,
-		  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
-		  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
-		  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
-		  0,  0,  0,  0,  0,183,184,185,186,187,
-		188,189,190,191,192,193,194,  0,  0,  0
+		[ 1] = KEY_CHAT,
+		[ 3] = KEY_SOUND,
+		[ 4] = KEY_MOVE,
+		[ 5] = KEY_BOOKMARKS,
+		[10] = KEY_FILE,
+		[19] = KEY_CAMERA,
+		[20] = KEY_EXIT,
+		[21] = KEY_RECORD,
+		[22] = KEY_SCREENLOCK,
+		[23] = KEY_EJECTCD,
+		[24] = KEY_MACRO,
+		[28] = KEY_CYCLEWINDOWS,
+		[65] = KEY_F13,
+		[66] = KEY_F14,
+		[67] = KEY_F15,
+		[68] = KEY_F16,
+		[69] = KEY_F17,
+		[70] = KEY_F18,
+		[71] = KEY_F19,
+		[72] = KEY_F20,
+		[73] = KEY_F21,
+		[74] = KEY_F22,
+		[75] = KEY_F23,
+		[76] = KEY_F24,
 	};
 	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
 	unsigned int hid = usage->hid;
@@ -233,10 +254,9 @@ static int lg_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			return -1;
 	} else {
 		if ((quirks & LG_EXPANDED_KEYMAP) &&
-				hid < ARRAY_SIZE(e_keymap) &&
-				e_keymap[hid] != 0) {
-			hid_map_usage(hi, usage, bit, max, EV_KEY,
-					e_keymap[hid]);
+		    hid < ARRAY_SIZE(e_keymap) &&
+		    e_keymap[hid] != KEY_RESERVED) {
+			lg_map_key_clear(e_keymap[hid]);
 			return 1;
 		}
 	}
@@ -353,7 +373,8 @@ static const struct hid_device_id lg_devices[] = {
 		.driver_data = LG_DUPLICATE_USAGES },
 
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_ELITE_KBD),
-		.driver_data = LG_IGNORE_DOUBLED_WHEEL | LG_EXPANDED_KEYMAP },
+		.driver_data = LG_IGNORE_DOUBLED_WHEEL | LG_EXPANDED_KEYMAP |
+				LG_DUPLICATE_USAGES },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_CORDLESS_DESKTOP_LX500),
 		.driver_data = LG_IGNORE_DOUBLED_WHEEL | LG_EXPANDED_KEYMAP },
 
