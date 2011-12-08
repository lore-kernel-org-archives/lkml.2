Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141Ab1LHUCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 15:02:21 -0500
Received: from oceanic.CalvaEDI.COM ([89.202.194.168]:36992 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab1LHUCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 15:02:19 -0500
Message-ID: <4EE11801.6000709@calvaedi.com>
Date: Thu, 08 Dec 2011 21:03:13 +0100
From: John Hughes <john@calvaedi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: platform-driver-x86 <platform-driver-x86@vger.kernel.org>
CC: Mattia Dongili <malattia@linux.it>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fix scancodes emitted by sony-laptop driver (Version 3 with
 spaces fixed)
Content-Type: multipart/mixed;
 boundary="------------090809050906050102060600"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090809050906050102060600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Drat.  Here we go again.  This time with whitespace as tabs.

Passes checkpatch.pl  Even took out assignment in condition to keep the 
quiche eaters happy.  :-(


--------------090809050906050102060600
Content-Type: text/x-patch;
 name="sony-scancode.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sony-scancode.patch"

The scancodes returned by the sony-laptop driver for function keys did not
match the scancodes used to remap keys.  Also, since the scancode was sent
to the input subsystem after the mapped keysym the /lib/udev/keymap
utility was confused about which scancode to report for which keysym.

This patch fixes the driver so the correct scancode is shown for each
key.  It also adds to the documentation a description of where to find
the scancodes.

Signed-off-by: John Hughes <john@calva.com>

diff --git a/Documentation/laptops/sony-laptop.txt b/Documentation/laptops/sony-laptop.txt
index 2bd4e82..0d5ac7f 100644
--- a/Documentation/laptops/sony-laptop.txt
+++ b/Documentation/laptops/sony-laptop.txt
@@ -17,6 +17,11 @@ subsystem. See the logs of acpid or /proc/acpi/event and
 devices are created by the driver. Additionally, loading the driver with the
 debug option will report all events in the kernel log.
 
+The "scancodes" passed to the input system (that can be remapped with udev)
+are indexes to the table "sony_laptop_input_keycode_map" in the sony-laptop.c
+module.  For example the "FN/E" key combination (EJECTCD on some models)
+generates the scancode 20 (0x14).
+
 Backlight control:
 ------------------
 If your laptop model supports it, you will find sysfs files in the
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index c006dee..35768cd 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -347,6 +347,7 @@ static void sony_laptop_report_input_event(u8 event)
 	struct input_dev *jog_dev = sony_laptop_input.jog_dev;
 	struct input_dev *key_dev = sony_laptop_input.key_dev;
 	struct sony_laptop_keypress kp = { NULL };
+	int scancode = -1;
 
 	if (event == SONYPI_EVENT_FNKEY_RELEASED ||
 			event == SONYPI_EVENT_ANYBUTTON_RELEASED) {
@@ -380,8 +381,9 @@ static void sony_laptop_report_input_event(u8 event)
 			dprintk("sony_laptop_report_input_event, event not known: %d\n", event);
 			break;
 		}
-		if (sony_laptop_input_index[event] != -1) {
-			kp.key = sony_laptop_input_keycode_map[sony_laptop_input_index[event]];
+		scancode = sony_laptop_input_index[event];
+		if (scancode != -1) {
+			kp.key = sony_laptop_input_keycode_map[scancode];
 			if (kp.key != KEY_UNKNOWN)
 				kp.dev = key_dev;
 		}
@@ -389,9 +391,11 @@ static void sony_laptop_report_input_event(u8 event)
 	}
 
 	if (kp.dev) {
+		/* if we have a scancode we emit it so we can always
+		   remap the key */
+		if (scancode != -1)
+			input_event(kp.dev, EV_MSC, MSC_SCAN, scancode);
 		input_report_key(kp.dev, kp.key, 1);
-		/* we emit the scancode so we can always remap the key */
-		input_event(kp.dev, EV_MSC, MSC_SCAN, event);
 		input_sync(kp.dev);
 
 		/* schedule key release */
@@ -466,7 +470,7 @@ static int sony_laptop_setup_input(struct acpi_device *acpi_device)
 	jog_dev->name = "Sony Vaio Jogdial";
 	jog_dev->id.bustype = BUS_ISA;
 	jog_dev->id.vendor = PCI_VENDOR_ID_SONY;
-	key_dev->dev.parent = &acpi_device->dev;
+	jog_dev->dev.parent = &acpi_device->dev;
 
 	input_set_capability(jog_dev, EV_KEY, BTN_MIDDLE);
 	input_set_capability(jog_dev, EV_REL, REL_WHEEL);


--------------090809050906050102060600--
