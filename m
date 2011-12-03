Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1LCLq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 06:46:26 -0500
Received: from oceanic.CalvaEDI.COM ([89.202.194.168]:50491 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab1LCLqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 06:46:24 -0500
Message-ID: <4EDA0C4B.7030905@calvaedi.com>
Date: Sat, 03 Dec 2011 12:47:23 +0100
From: John Hughes <john@calvaedi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Mattia Dongili <malattia@linux.it>
CC: John Hughes <john@Calva.COM>, platform-driver-x86@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fix scancodes emitted by sony-laptop driver (Version 2 with
 warnings fixed)
References: <20111130125545.GA5815@elgon.mountain>
In-Reply-To: <20111130125545.GA5815@elgon.mountain>
Content-Type: multipart/mixed;
 boundary="------------000904090907080502070005"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000904090907080502070005
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/11/11 13:55, Dan Carpenter wrote:
> Hi John,
>
> Commit 04840b50f395 "drivers/platform/x86/sony-laptop.c: fix scancodes"
> introduces a gcc warning:
>
> drivers/platform/x86/sony-laptop.c:395:14: warning:
> 	‘scancode’ may be used uninitialized in this function [-Wuninitialized]
>    

Ok, I've fixed my stupid mistake and also the two bugs in the jogdial 
driver (It wasn't setting it's parent and it was emitting scancode 
events even though it's not a keyboard device).



--------------000904090907080502070005
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
index c006dee..4babb79 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -347,6 +347,7 @@ static void sony_laptop_report_input_event(u8 event)
 	struct input_dev *jog_dev = sony_laptop_input.jog_dev;
 	struct input_dev *key_dev = sony_laptop_input.key_dev;
 	struct sony_laptop_keypress kp = { NULL };
+	int scancode = -1;
 
 	if (event == SONYPI_EVENT_FNKEY_RELEASED ||
 			event == SONYPI_EVENT_ANYBUTTON_RELEASED) {
@@ -380,8 +381,8 @@ static void sony_laptop_report_input_event(u8 event)
 			dprintk("sony_laptop_report_input_event, event not known: %d\n", event);
 			break;
 		}
-		if (sony_laptop_input_index[event] != -1) {
-			kp.key = sony_laptop_input_keycode_map[sony_laptop_input_index[event]];
+		if ((scancode = sony_laptop_input_index[event]) != -1) {
+			kp.key = sony_laptop_input_keycode_map[scancode];
 			if (kp.key != KEY_UNKNOWN)
 				kp.dev = key_dev;
 		}
@@ -389,9 +390,11 @@ static void sony_laptop_report_input_event(u8 event)
 	}
 
 	if (kp.dev) {
+		/* if we have a scancode we emit it so we can always
+                   remap the key */
+		if (scancode != -1)
+			input_event(kp.dev, EV_MSC, MSC_SCAN, scancode);
 		input_report_key(kp.dev, kp.key, 1);
-		/* we emit the scancode so we can always remap the key */
-		input_event(kp.dev, EV_MSC, MSC_SCAN, event);
 		input_sync(kp.dev);
 
 		/* schedule key release */
@@ -466,7 +469,7 @@ static int sony_laptop_setup_input(struct acpi_device *acpi_device)
 	jog_dev->name = "Sony Vaio Jogdial";
 	jog_dev->id.bustype = BUS_ISA;
 	jog_dev->id.vendor = PCI_VENDOR_ID_SONY;
-	key_dev->dev.parent = &acpi_device->dev;
+	jog_dev->dev.parent = &acpi_device->dev;
 
 	input_set_capability(jog_dev, EV_KEY, BTN_MIDDLE);
 	input_set_capability(jog_dev, EV_REL, REL_WHEEL);

--------------000904090907080502070005--
