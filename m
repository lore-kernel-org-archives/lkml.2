Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1JSWBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:01:05 -0400
Received: from oceanic.CalvaEDI.COM ([89.202.194.168]:33787 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab1JSWBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:01:03 -0400
Message-ID: <4E9F48A8.3020507@calvaedi.com>
Date: Thu, 20 Oct 2011 00:01:12 +0200
From: John Hughes <john@calvaedi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: John Hughes <john@Calva.COM>
CC: Mattia Dongili <malattia@linux.it>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, Stelian Pop <stelian@popies.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
Subject: Re: sony-laptop driver: Volume keys on Sony Vaio TX3 don't work
References: <4E9ABBF6.3000504@calvaedi.com> <4E9ADBD3.4070404@calvaedi.com> <4E9B182A.3020101@calvaedi.com> <74494.1318789218@turing-police.cc.vt.edu> <20111016213800.GA12703@kamineko.org> <81436.1318801813@turing-police.cc.vt.edu> <20111017214543.GB1311@kamineko.org> <4E9D41C5.70902@Calva.COM>
In-Reply-To: <4E9D41C5.70902@Calva.COM>
Content-Type: multipart/mixed;
 boundary="------------010006070404090304080400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010006070404090304080400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/18/2011 11:07 AM, John Hughes wrote:
> udev does have some per-model stuff for the Vaio's.
>
> Doesn't work right because the scancodes reported the sony-laptop 
> driver are not the right ones.
>
> (sony-laptop sends its "event" code as the scancode, but to change the 
> keymap you have to use the index in the sony_laptop_input_keycode_map 
> table.  I have posted one patch for this which makes the scancodes at 
> least consistent but I think I'll do another that makes them be the 
> same as what current udev thinks they should be.  I'll have that ready 
> this evening I thing - have to work now :-( )
>
Ok, here is a patch that makes the scancodes reported by sony-laptop be 
the same as the SONY_EVENT defines.

Unfortunately this doesn't work terribly well because the scancodes used 
by udev seem to be chosen randomly:

$ cat /lib/udev/keymaps/module-sony
0x06 mute # Fn+F2
0x07 volumedown # Fn+F3
0x08 volumeup # Fn+F4
0x09 brightnessdown # Fn+F5
0x0A brightnessup # Fn+F6
0x0B switchvideomode # Fn+F7
0x0E zoom # Fn+F10
0x10 suspend # Fn+F12

and

$ cat /lib/udev/keymaps/module-sony-vgn
0x00 brightnessdown # Fn+F5
0x10 brightnessup # Fn+F6
0x11 switchvideomode # Fn+F7
0x12 zoomout
0x14 zoomin
0x15 suspend # Fn+F12
0x17 prog1


So the different ideas are:

key      module-sony  module-sony-vgn   orig code(*)   event(*)
fn_f1                                   0x05           0x0c
fn_f2    0x06                           0x06           0x0d
fn_f3    0x07                           0x07           0x0e
fn_f4    0x08                           0x08           0x0f
fn_f5    0x09          0x00 (!)         0x09           0x10
fn_f6    0x0a          0x10             0x0a           0x11
fn_f7    0x0b          0x11             0x0b           0x12
fn_f8                                   0x0c           0x13
fn_f9                                   0x0d           0x14
fn_f10   0x0e                           0x0e           0x15
fn_f11                                  0x0f           0x16
fn_f12   0x10          0x15             0x10           0x17


(*) Orig code - the scancodes that map for the original code, and the 
scancodes returned by my first patch
(*) event - the scancodes from the patch included here.

So, it seems to me that:

1. my original patch is the smaller change, and works with the udev 
"module-sony" keymap file

2. this patch is prettier but doesn't work with existing userspace.

3. the poor sod who wrote the module-sony-vgn file was terribly confused 
by the scancodes returned by the original code.

My recommendation would be to use my first patch - it makes the driver 
return  scancodes that correspond to the scancodes that you need to map.

OK?

Want me to do the whole formal "blablabla-by" stuff now?


--------------010006070404090304080400
Content-Type: text/x-patch;
 name="sony-scancode-event.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sony-scancode-event.patch"

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index bbd182e..e2acfd5 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -177,146 +177,83 @@ struct sony_laptop_keypress {
 };
 
 /* Correspondance table between sonypi events
- * and input layer indexes in the keymap
+ * and keycodes
  */
-static int sony_laptop_input_index[] = {
-	-1,	/*  0 no event */
-	-1,	/*  1 SONYPI_EVENT_JOGDIAL_DOWN */
-	-1,	/*  2 SONYPI_EVENT_JOGDIAL_UP */
-	-1,	/*  3 SONYPI_EVENT_JOGDIAL_DOWN_PRESSED */
-	-1,	/*  4 SONYPI_EVENT_JOGDIAL_UP_PRESSED */
-	-1,	/*  5 SONYPI_EVENT_JOGDIAL_PRESSED */
-	-1,	/*  6 SONYPI_EVENT_JOGDIAL_RELEASED */
-	 0,	/*  7 SONYPI_EVENT_CAPTURE_PRESSED */
-	 1,	/*  8 SONYPI_EVENT_CAPTURE_RELEASED */
-	 2,	/*  9 SONYPI_EVENT_CAPTURE_PARTIALPRESSED */
-	 3,	/* 10 SONYPI_EVENT_CAPTURE_PARTIALRELEASED */
-	 4,	/* 11 SONYPI_EVENT_FNKEY_ESC */
-	 5,	/* 12 SONYPI_EVENT_FNKEY_F1 */
-	 6,	/* 13 SONYPI_EVENT_FNKEY_F2 */
-	 7,	/* 14 SONYPI_EVENT_FNKEY_F3 */
-	 8,	/* 15 SONYPI_EVENT_FNKEY_F4 */
-	 9,	/* 16 SONYPI_EVENT_FNKEY_F5 */
-	10,	/* 17 SONYPI_EVENT_FNKEY_F6 */
-	11,	/* 18 SONYPI_EVENT_FNKEY_F7 */
-	12,	/* 19 SONYPI_EVENT_FNKEY_F8 */
-	13,	/* 20 SONYPI_EVENT_FNKEY_F9 */
-	14,	/* 21 SONYPI_EVENT_FNKEY_F10 */
-	15,	/* 22 SONYPI_EVENT_FNKEY_F11 */
-	16,	/* 23 SONYPI_EVENT_FNKEY_F12 */
-	17,	/* 24 SONYPI_EVENT_FNKEY_1 */
-	18,	/* 25 SONYPI_EVENT_FNKEY_2 */
-	19,	/* 26 SONYPI_EVENT_FNKEY_D */
-	20,	/* 27 SONYPI_EVENT_FNKEY_E */
-	21,	/* 28 SONYPI_EVENT_FNKEY_F */
-	22,	/* 29 SONYPI_EVENT_FNKEY_S */
-	23,	/* 30 SONYPI_EVENT_FNKEY_B */
-	24,	/* 31 SONYPI_EVENT_BLUETOOTH_PRESSED */
-	25,	/* 32 SONYPI_EVENT_PKEY_P1 */
-	26,	/* 33 SONYPI_EVENT_PKEY_P2 */
-	27,	/* 34 SONYPI_EVENT_PKEY_P3 */
-	28,	/* 35 SONYPI_EVENT_BACK_PRESSED */
-	-1,	/* 36 SONYPI_EVENT_LID_CLOSED */
-	-1,	/* 37 SONYPI_EVENT_LID_OPENED */
-	29,	/* 38 SONYPI_EVENT_BLUETOOTH_ON */
-	30,	/* 39 SONYPI_EVENT_BLUETOOTH_OFF */
-	31,	/* 40 SONYPI_EVENT_HELP_PRESSED */
-	32,	/* 41 SONYPI_EVENT_FNKEY_ONLY */
-	33,	/* 42 SONYPI_EVENT_JOGDIAL_FAST_DOWN */
-	34,	/* 43 SONYPI_EVENT_JOGDIAL_FAST_UP */
-	35,	/* 44 SONYPI_EVENT_JOGDIAL_FAST_DOWN_PRESSED */
-	36,	/* 45 SONYPI_EVENT_JOGDIAL_FAST_UP_PRESSED */
-	37,	/* 46 SONYPI_EVENT_JOGDIAL_VFAST_DOWN */
-	38,	/* 47 SONYPI_EVENT_JOGDIAL_VFAST_UP */
-	39,	/* 48 SONYPI_EVENT_JOGDIAL_VFAST_DOWN_PRESSED */
-	40,	/* 49 SONYPI_EVENT_JOGDIAL_VFAST_UP_PRESSED */
-	41,	/* 50 SONYPI_EVENT_ZOOM_PRESSED */
-	42,	/* 51 SONYPI_EVENT_THUMBPHRASE_PRESSED */
-	43,	/* 52 SONYPI_EVENT_MEYE_FACE */
-	44,	/* 53 SONYPI_EVENT_MEYE_OPPOSITE */
-	45,	/* 54 SONYPI_EVENT_MEMORYSTICK_INSERT */
-	46,	/* 55 SONYPI_EVENT_MEMORYSTICK_EJECT */
-	-1,	/* 56 SONYPI_EVENT_ANYBUTTON_RELEASED */
-	-1,	/* 57 SONYPI_EVENT_BATTERY_INSERT */
-	-1,	/* 58 SONYPI_EVENT_BATTERY_REMOVE */
-	-1,	/* 59 SONYPI_EVENT_FNKEY_RELEASED */
-	47,	/* 60 SONYPI_EVENT_WIRELESS_ON */
-	48,	/* 61 SONYPI_EVENT_WIRELESS_OFF */
-	49,	/* 62 SONYPI_EVENT_ZOOM_IN_PRESSED */
-	50,	/* 63 SONYPI_EVENT_ZOOM_OUT_PRESSED */
-	51,	/* 64 SONYPI_EVENT_CD_EJECT_PRESSED */
-	52,	/* 65 SONYPI_EVENT_MODEKEY_PRESSED */
-	53,	/* 66 SONYPI_EVENT_PKEY_P4 */
-	54,	/* 67 SONYPI_EVENT_PKEY_P5 */
-	55,	/* 68 SONYPI_EVENT_SETTINGKEY_PRESSED */
-	56,	/* 69 SONYPI_EVENT_VOLUME_INC_PRESSED */
-	57,	/* 70 SONYPI_EVENT_VOLUME_DEC_PRESSED */
-	-1,	/* 71 SONYPI_EVENT_BRIGHTNESS_PRESSED */
-	58,	/* 72 SONYPI_EVENT_MEDIA_PRESSED */
-	59,	/* 72 SONYPI_EVENT_VENDOR_PRESSED */
-};
-
 static int sony_laptop_input_keycode_map[] = {
-	KEY_CAMERA,	/*  0 SONYPI_EVENT_CAPTURE_PRESSED */
-	KEY_RESERVED,	/*  1 SONYPI_EVENT_CAPTURE_RELEASED */
-	KEY_RESERVED,	/*  2 SONYPI_EVENT_CAPTURE_PARTIALPRESSED */
-	KEY_RESERVED,	/*  3 SONYPI_EVENT_CAPTURE_PARTIALRELEASED */
-	KEY_FN_ESC,	/*  4 SONYPI_EVENT_FNKEY_ESC */
-	KEY_FN_F1,	/*  5 SONYPI_EVENT_FNKEY_F1 */
-	KEY_FN_F2,	/*  6 SONYPI_EVENT_FNKEY_F2 */
-	KEY_FN_F3,	/*  7 SONYPI_EVENT_FNKEY_F3 */
-	KEY_FN_F4,	/*  8 SONYPI_EVENT_FNKEY_F4 */
-	KEY_FN_F5,	/*  9 SONYPI_EVENT_FNKEY_F5 */
-	KEY_FN_F6,	/* 10 SONYPI_EVENT_FNKEY_F6 */
-	KEY_FN_F7,	/* 11 SONYPI_EVENT_FNKEY_F7 */
-	KEY_FN_F8,	/* 12 SONYPI_EVENT_FNKEY_F8 */
-	KEY_FN_F9,	/* 13 SONYPI_EVENT_FNKEY_F9 */
-	KEY_FN_F10,	/* 14 SONYPI_EVENT_FNKEY_F10 */
-	KEY_FN_F11,	/* 15 SONYPI_EVENT_FNKEY_F11 */
-	KEY_FN_F12,	/* 16 SONYPI_EVENT_FNKEY_F12 */
-	KEY_FN_F1,	/* 17 SONYPI_EVENT_FNKEY_1 */
-	KEY_FN_F2,	/* 18 SONYPI_EVENT_FNKEY_2 */
-	KEY_FN_D,	/* 19 SONYPI_EVENT_FNKEY_D */
-	KEY_FN_E,	/* 20 SONYPI_EVENT_FNKEY_E */
-	KEY_FN_F,	/* 21 SONYPI_EVENT_FNKEY_F */
-	KEY_FN_S,	/* 22 SONYPI_EVENT_FNKEY_S */
-	KEY_FN_B,	/* 23 SONYPI_EVENT_FNKEY_B */
-	KEY_BLUETOOTH,	/* 24 SONYPI_EVENT_BLUETOOTH_PRESSED */
-	KEY_PROG1,	/* 25 SONYPI_EVENT_PKEY_P1 */
-	KEY_PROG2,	/* 26 SONYPI_EVENT_PKEY_P2 */
-	KEY_PROG3,	/* 27 SONYPI_EVENT_PKEY_P3 */
-	KEY_BACK,	/* 28 SONYPI_EVENT_BACK_PRESSED */
-	KEY_BLUETOOTH,	/* 29 SONYPI_EVENT_BLUETOOTH_ON */
-	KEY_BLUETOOTH,	/* 30 SONYPI_EVENT_BLUETOOTH_OFF */
-	KEY_HELP,	/* 31 SONYPI_EVENT_HELP_PRESSED */
-	KEY_FN,		/* 32 SONYPI_EVENT_FNKEY_ONLY */
-	KEY_RESERVED,	/* 33 SONYPI_EVENT_JOGDIAL_FAST_DOWN */
-	KEY_RESERVED,	/* 34 SONYPI_EVENT_JOGDIAL_FAST_UP */
-	KEY_RESERVED,	/* 35 SONYPI_EVENT_JOGDIAL_FAST_DOWN_PRESSED */
-	KEY_RESERVED,	/* 36 SONYPI_EVENT_JOGDIAL_FAST_UP_PRESSED */
-	KEY_RESERVED,	/* 37 SONYPI_EVENT_JOGDIAL_VFAST_DOWN */
-	KEY_RESERVED,	/* 38 SONYPI_EVENT_JOGDIAL_VFAST_UP */
-	KEY_RESERVED,	/* 39 SONYPI_EVENT_JOGDIAL_VFAST_DOWN_PRESSED */
-	KEY_RESERVED,	/* 40 SONYPI_EVENT_JOGDIAL_VFAST_UP_PRESSED */
-	KEY_ZOOM,	/* 41 SONYPI_EVENT_ZOOM_PRESSED */
-	BTN_THUMB,	/* 42 SONYPI_EVENT_THUMBPHRASE_PRESSED */
-	KEY_RESERVED,	/* 43 SONYPI_EVENT_MEYE_FACE */
-	KEY_RESERVED,	/* 44 SONYPI_EVENT_MEYE_OPPOSITE */
-	KEY_RESERVED,	/* 45 SONYPI_EVENT_MEMORYSTICK_INSERT */
-	KEY_RESERVED,	/* 46 SONYPI_EVENT_MEMORYSTICK_EJECT */
-	KEY_WLAN,	/* 47 SONYPI_EVENT_WIRELESS_ON */
-	KEY_WLAN,	/* 48 SONYPI_EVENT_WIRELESS_OFF */
-	KEY_ZOOMIN,	/* 49 SONYPI_EVENT_ZOOM_IN_PRESSED */
-	KEY_ZOOMOUT,	/* 50 SONYPI_EVENT_ZOOM_OUT_PRESSED */
-	KEY_EJECTCD,	/* 51 SONYPI_EVENT_CD_EJECT_PRESSED */
-	KEY_F13,	/* 52 SONYPI_EVENT_MODEKEY_PRESSED */
-	KEY_PROG4,	/* 53 SONYPI_EVENT_PKEY_P4 */
-	KEY_F14,	/* 54 SONYPI_EVENT_PKEY_P5 */
-	KEY_F15,	/* 55 SONYPI_EVENT_SETTINGKEY_PRESSED */
-	KEY_VOLUMEUP,	/* 56 SONYPI_EVENT_VOLUME_INC_PRESSED */
-	KEY_VOLUMEDOWN,	/* 57 SONYPI_EVENT_VOLUME_DEC_PRESSED */
-	KEY_MEDIA,	/* 58 SONYPI_EVENT_MEDIA_PRESSED */
-	KEY_VENDOR,	/* 59 SONYPI_EVENT_VENDOR_PRESSED */
+	KEY_UNKNOWN,	/*  0 no event */
+	KEY_UNKNOWN,	/*  1 SONYPI_EVENT_JOGDIAL_DOWN */
+	KEY_UNKNOWN,	/*  2 SONYPI_EVENT_JOGDIAL_UP */
+	KEY_UNKNOWN,	/*  3 SONYPI_EVENT_JOGDIAL_DOWN_PRESSED */
+	KEY_UNKNOWN,	/*  4 SONYPI_EVENT_JOGDIAL_UP_PRESSED */
+	KEY_UNKNOWN,	/*  5 SONYPI_EVENT_JOGDIAL_PRESSED */
+	KEY_UNKNOWN,	/*  6 SONYPI_EVENT_JOGDIAL_RELEASED */
+	KEY_CAMERA,	/*  7 SONYPI_EVENT_CAPTURE_PRESSED */
+	KEY_RESERVED,	/*  8 SONYPI_EVENT_CAPTURE_RELEASED */
+	KEY_RESERVED,	/*  9 SONYPI_EVENT_CAPTURE_PARTIALPRESSED */
+	KEY_RESERVED,	/* 10 SONYPI_EVENT_CAPTURE_PARTIALRELEASED */
+	KEY_FN_ESC,	/* 11 SONYPI_EVENT_FNKEY_ESC */
+	KEY_FN_F1,	/* 12 SONYPI_EVENT_FNKEY_F1 */
+	KEY_FN_F2,	/* 13 SONYPI_EVENT_FNKEY_F2 */
+	KEY_FN_F3,	/* 14 SONYPI_EVENT_FNKEY_F3 */
+	KEY_FN_F4,	/* 15 SONYPI_EVENT_FNKEY_F4 */
+	KEY_FN_F5,	/* 16 SONYPI_EVENT_FNKEY_F5 */
+	KEY_FN_F6,	/* 17 SONYPI_EVENT_FNKEY_F6 */
+	KEY_FN_F7,	/* 18 SONYPI_EVENT_FNKEY_F7 */
+	KEY_FN_F8,	/* 19 SONYPI_EVENT_FNKEY_F8 */
+	KEY_FN_F9,	/* 20 SONYPI_EVENT_FNKEY_F9 */
+	KEY_FN_F10,	/* 21 SONYPI_EVENT_FNKEY_F10 */
+	KEY_FN_F11,	/* 22 SONYPI_EVENT_FNKEY_F11 */
+	KEY_FN_F12,	/* 23 SONYPI_EVENT_FNKEY_F12 */
+	KEY_FN_F1,	/* 24 SONYPI_EVENT_FNKEY_1 */
+	KEY_FN_F2,	/* 25 SONYPI_EVENT_FNKEY_2 */
+	KEY_FN_D,	/* 26 SONYPI_EVENT_FNKEY_D */
+	KEY_FN_E,	/* 27 SONYPI_EVENT_FNKEY_E */
+	KEY_FN_F,	/* 28 SONYPI_EVENT_FNKEY_F */
+	KEY_FN_S,	/* 29 SONYPI_EVENT_FNKEY_S */
+	KEY_FN_B,	/* 30 SONYPI_EVENT_FNKEY_B */
+	KEY_BLUETOOTH,	/* 31 SONYPI_EVENT_BLUETOOTH_PRESSED */
+	KEY_PROG1,	/* 32 SONYPI_EVENT_PKEY_P1 */
+	KEY_PROG2,	/* 33 SONYPI_EVENT_PKEY_P2 */
+	KEY_PROG3,	/* 34 SONYPI_EVENT_PKEY_P3 */
+	KEY_BACK,	/* 35 SONYPI_EVENT_BACK_PRESSED */
+	KEY_UNKNOWN,	/* 36 SONYPI_EVENT_LID_CLOSED */
+	KEY_UNKNOWN,	/* 37 SONYPI_EVENT_LID_OPENED */
+	KEY_BLUETOOTH,	/* 38 SONYPI_EVENT_BLUETOOTH_ON */
+	KEY_BLUETOOTH,	/* 39 SONYPI_EVENT_BLUETOOTH_OFF */
+	KEY_HELP,	/* 40 SONYPI_EVENT_HELP_PRESSED */
+	KEY_FN,		/* 41 SONYPI_EVENT_FNKEY_ONLY */
+	KEY_RESERVED,	/* 42 SONYPI_EVENT_JOGDIAL_FAST_DOWN */
+	KEY_RESERVED,	/* 43 SONYPI_EVENT_JOGDIAL_FAST_UP */
+	KEY_RESERVED,	/* 44 SONYPI_EVENT_JOGDIAL_FAST_DOWN_PRESSED */
+	KEY_RESERVED,	/* 45 SONYPI_EVENT_JOGDIAL_FAST_UP_PRESSED */
+	KEY_RESERVED,	/* 46 SONYPI_EVENT_JOGDIAL_VFAST_DOWN */
+	KEY_RESERVED,	/* 47 SONYPI_EVENT_JOGDIAL_VFAST_UP */
+	KEY_RESERVED,	/* 48 SONYPI_EVENT_JOGDIAL_VFAST_DOWN_PRESSED */
+	KEY_RESERVED,	/* 49 SONYPI_EVENT_JOGDIAL_VFAST_UP_PRESSED */
+	KEY_ZOOM,	/* 50 SONYPI_EVENT_ZOOM_PRESSED */
+	BTN_THUMB,	/* 51 SONYPI_EVENT_THUMBPHRASE_PRESSED */
+	KEY_RESERVED,	/* 52 SONYPI_EVENT_MEYE_FACE */
+	KEY_RESERVED,	/* 53 SONYPI_EVENT_MEYE_OPPOSITE */
+	KEY_RESERVED,	/* 54 SONYPI_EVENT_MEMORYSTICK_INSERT */
+	KEY_RESERVED,	/* 55 SONYPI_EVENT_MEMORYSTICK_EJECT */
+	KEY_UNKNOWN,	/* 56 SONYPI_EVENT_ANYBUTTON_RELEASED */
+	KEY_UNKNOWN,	/* 57 SONYPI_EVENT_BATTERY_INSERT */
+	KEY_UNKNOWN,	/* 58 SONYPI_EVENT_BATTERY_REMOVE */
+	KEY_UNKNOWN,	/* 59 SONYPI_EVENT_FNKEY_RELEASED */
+	KEY_WLAN,	/* 60 SONYPI_EVENT_WIRELESS_ON */
+	KEY_WLAN,	/* 61 SONYPI_EVENT_WIRELESS_OFF */
+	KEY_ZOOMIN,	/* 62 SONYPI_EVENT_ZOOM_IN_PRESSED */
+	KEY_ZOOMOUT,	/* 63 SONYPI_EVENT_ZOOM_OUT_PRESSED */
+	KEY_EJECTCD,	/* 64 SONYPI_EVENT_CD_EJECT_PRESSED */
+	KEY_F13,	/* 65 SONYPI_EVENT_MODEKEY_PRESSED */
+	KEY_PROG4,	/* 66 SONYPI_EVENT_PKEY_P4 */
+	KEY_F14,	/* 67 SONYPI_EVENT_PKEY_P5 */
+	KEY_F15,	/* 68 SONYPI_EVENT_SETTINGKEY_PRESSED */
+	KEY_VOLUMEUP,	/* 69 SONYPI_EVENT_VOLUME_INC_PRESSED */
+	KEY_VOLUMEDOWN,	/* 70 SONYPI_EVENT_VOLUME_DEC_PRESSED */
+	KEY_UNKNOWN,	/* 71 SONYPI_EVENT_BRIGHTNESS_PRESSED */
+	KEY_MEDIA,	/* 72 SONYPI_EVENT_MEDIA_PRESSED */
+	KEY_VENDOR,	/* 72 SONYPI_EVENT_VENDOR_PRESSED */
 };
 
 /* release buttons after a short delay if pressed */
@@ -376,22 +313,20 @@ static void sony_laptop_report_input_event(u8 event)
 		break;
 
 	default:
-		if (event >= ARRAY_SIZE(sony_laptop_input_index)) {
+		if (event >= ARRAY_SIZE(sony_laptop_input_keycode_map)) {
 			dprintk("sony_laptop_report_input_event, event not known: %d\n", event);
 			break;
 		}
-		if (sony_laptop_input_index[event] != -1) {
-			kp.key = sony_laptop_input_keycode_map[sony_laptop_input_index[event]];
-			if (kp.key != KEY_UNKNOWN)
-				kp.dev = key_dev;
-		}
+		kp.key = sony_laptop_input_keycode_map[event];
+		if (kp.key != KEY_UNKNOWN && kp.key != KEY_RESERVED)
+			kp.dev = key_dev;
 		break;
 	}
 
 	if (kp.dev) {
-		input_report_key(kp.dev, kp.key, 1);
 		/* we emit the scancode so we can always remap the key */
 		input_event(kp.dev, EV_MSC, MSC_SCAN, event);
+		input_report_key(kp.dev, kp.key, 1);
 		input_sync(kp.dev);
 
 		/* schedule key release */

--------------010006070404090304080400--
