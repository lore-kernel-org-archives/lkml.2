Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab1DDWNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:13:15 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:58859 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755755Ab1DDWMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:12:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=un5aQ+UG7iMSLhl/IJhh3WS5YDr8NW63jdo30xp59SnhxKC1vW2WaqcjIX59qiHQyXZo0KApfMiiDxCwm6ID1U8PQtaxzaMprtaAVQU2pUv5p1K5qdFwhF/ad/SZhlF3;
Date: Mon, 4 Apr 2011 15:08:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>,
        Antonio Ospite <ospite@studenti.unina.it>,
        akpm <akpm@linux-foundation.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: [PATCH 7/8] Documentation: consolidate leds files to leds/ subdir
Message-Id: <20110404150846.54034f1b.rdunlap@xenotime.net>
In-Reply-To: <20110404145803.8663081d.rdunlap@xenotime.net>
References: <20110404145803.8663081d.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antonio Ospite <ospite@studenti.unina.it>

leds: move leds-class documentation under the leds/ subdir.
Add also a leds/00-INDEX file describing the files under leds/

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Acked-by: Richard Purdie <richard.purdie@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---

Changes since v2:
 - list leds/ dir in Documentation/00-INDEX, not leds/leds-class.txt
 - add a leds/00-INDEX file describing the files under leds/

Changes since v1:
  - don't use git renames
  - Cc Andrew Morton

Thanks,
   Antonio Ospite
   http://ao2.it

 Documentation/00-INDEX             |    4 -
 Documentation/leds-class.txt       |   98 ---------------------------
 Documentation/leds-lp3944.txt      |   50 -------------
 Documentation/leds/00-INDEX        |    8 ++
 Documentation/leds/leds-class.txt  |   98 +++++++++++++++++++++++++++
 Documentation/leds/leds-lp3944.txt |   50 +++++++++++++
 6 files changed, 158 insertions(+), 150 deletions(-)
 create mode 100644 Documentation/leds/00-INDEX
 delete mode 100644 Documentation/leds-class.txt
 delete mode 100644 Documentation/leds-lp3944.txt
 create mode 100644 Documentation/leds/leds-class.txt
 create mode 100644 Documentation/leds/leds-lp3944.txt

--- linux-2.6.38-git18.orig/Documentation/00-INDEX
+++ linux-2.6.38-git18/Documentation/00-INDEX
@@ -206,8 +206,8 @@ laptops/
 	- directory with laptop related info and laptop driver documentation.
 ldm.txt
 	- a brief description of LDM (Windows Dynamic Disks).
-leds-class.txt
-	- documents LED handling under Linux.
+leds/
+	- directory with info about LED handling under Linux.
 local_ops.txt
 	- semantics and behavior of local atomic operations.
 lockdep-design.txt
--- /dev/null
+++ linux-2.6.38-git18/Documentation/leds/00-INDEX
@@ -0,0 +1,8 @@
+leds-class.txt
+	- documents LED handling under Linux.
+leds-lp3944.txt
+	- notes on how to use the leds-lp3944 driver.
+leds-lp5521.txt
+	- notes on how to use the leds-lp5521 driver.
+leds-lp5523.txt
+	- notes on how to use the leds-lp5523 driver.
--- linux-2.6.38-git18.orig/Documentation/leds-class.txt
+++ /dev/null
@@ -1,98 +0,0 @@
-
-LED handling under Linux
-========================
-
-If you're reading this and thinking about keyboard leds, these are
-handled by the input subsystem and the led class is *not* needed.
-
-In its simplest form, the LED class just allows control of LEDs from
-userspace. LEDs appear in /sys/class/leds/. The maximum brightness of the
-LED is defined in max_brightness file. The brightness file will set the brightness
-of the LED (taking a value 0-max_brightness). Most LEDs don't have hardware
-brightness support so will just be turned on for non-zero brightness settings.
-
-The class also introduces the optional concept of an LED trigger. A trigger
-is a kernel based source of led events. Triggers can either be simple or
-complex. A simple trigger isn't configurable and is designed to slot into
-existing subsystems with minimal additional code. Examples are the ide-disk,
-nand-disk and sharpsl-charge triggers. With led triggers disabled, the code
-optimises away.
-
-Complex triggers whilst available to all LEDs have LED specific
-parameters and work on a per LED basis. The timer trigger is an example.
-The timer trigger will periodically change the LED brightness between
-LED_OFF and the current brightness setting. The "on" and "off" time can
-be specified via /sys/class/leds/<device>/delay_{on,off} in milliseconds.
-You can change the brightness value of a LED independently of the timer
-trigger. However, if you set the brightness value to LED_OFF it will
-also disable the timer trigger.
-
-You can change triggers in a similar manner to the way an IO scheduler
-is chosen (via /sys/class/leds/<device>/trigger). Trigger specific
-parameters can appear in /sys/class/leds/<device> once a given trigger is
-selected.
-
-
-Design Philosophy
-=================
-
-The underlying design philosophy is simplicity. LEDs are simple devices
-and the aim is to keep a small amount of code giving as much functionality
-as possible.  Please keep this in mind when suggesting enhancements.
-
-
-LED Device Naming
-=================
-
-Is currently of the form:
-
-"devicename:colour:function"
-
-There have been calls for LED properties such as colour to be exported as
-individual led class attributes. As a solution which doesn't incur as much
-overhead, I suggest these become part of the device name. The naming scheme
-above leaves scope for further attributes should they be needed. If sections
-of the name don't apply, just leave that section blank.
-
-
-Hardware accelerated blink of LEDs
-==================================
-
-Some LEDs can be programmed to blink without any CPU interaction. To
-support this feature, a LED driver can optionally implement the
-blink_set() function (see <linux/leds.h>). To set an LED to blinking,
-however, it is better to use use the API function led_blink_set(),
-as it will check and implement software fallback if necessary.
-
-To turn off blinking again, use the API function led_brightness_set()
-as that will not just set the LED brightness but also stop any software
-timers that may have been required for blinking.
-
-The blink_set() function should choose a user friendly blinking value
-if it is called with *delay_on==0 && *delay_off==0 parameters. In this
-case the driver should give back the chosen value through delay_on and
-delay_off parameters to the leds subsystem.
-
-Setting the brightness to zero with brightness_set() callback function
-should completely turn off the LED and cancel the previously programmed
-hardware blinking function, if any.
-
-
-Known Issues
-============
-
-The LED Trigger core cannot be a module as the simple trigger functions
-would cause nightmare dependency issues. I see this as a minor issue
-compared to the benefits the simple trigger functionality brings. The
-rest of the LED subsystem can be modular.
-
-
-Future Development
-==================
-
-At the moment, a trigger can't be created specifically for a single LED.
-There are a number of cases where a trigger might only be mappable to a
-particular LED (ACPI?). The addition of triggers provided by the LED driver
-should cover this option and be possible to add without breaking the
-current interface.
-
--- linux-2.6.38-git18.orig/Documentation/leds-lp3944.txt
+++ /dev/null
@@ -1,50 +0,0 @@
-Kernel driver lp3944
-====================
-
-  * National Semiconductor LP3944 Fun-light Chip
-    Prefix: 'lp3944'
-    Addresses scanned: None (see the Notes section below)
-    Datasheet: Publicly available at the National Semiconductor website
-               http://www.national.com/pf/LP/LP3944.html
-
-Authors:
-        Antonio Ospite <ospite@studenti.unina.it>
-
-
-Description
------------
-The LP3944 is a helper chip that can drive up to 8 leds, with two programmable
-DIM modes; it could even be used as a gpio expander but this driver assumes it
-is used as a led controller.
-
-The DIM modes are used to set _blink_ patterns for leds, the pattern is
-specified supplying two parameters:
-  - period: from 0s to 1.6s
-  - duty cycle: percentage of the period the led is on, from 0 to 100
-
-Setting a led in DIM0 or DIM1 mode makes it blink according to the pattern.
-See the datasheet for details.
-
-LP3944 can be found on Motorola A910 smartphone, where it drives the rgb
-leds, the camera flash light and the lcds power.
-
-
-Notes
------
-The chip is used mainly in embedded contexts, so this driver expects it is
-registered using the i2c_board_info mechanism.
-
-To register the chip at address 0x60 on adapter 0, set the platform data
-according to include/linux/leds-lp3944.h, set the i2c board info:
-
-	static struct i2c_board_info __initdata a910_i2c_board_info[] = {
-		{
-			I2C_BOARD_INFO("lp3944", 0x60),
-			.platform_data = &a910_lp3944_leds,
-		},
-	};
-
-and register it in the platform init function
-
-	i2c_register_board_info(0, a910_i2c_board_info,
-			ARRAY_SIZE(a910_i2c_board_info));
--- /dev/null
+++ linux-2.6.38-git18/Documentation/leds/leds-class.txt
@@ -0,0 +1,98 @@
+
+LED handling under Linux
+========================
+
+If you're reading this and thinking about keyboard leds, these are
+handled by the input subsystem and the led class is *not* needed.
+
+In its simplest form, the LED class just allows control of LEDs from
+userspace. LEDs appear in /sys/class/leds/. The maximum brightness of the
+LED is defined in max_brightness file. The brightness file will set the brightness
+of the LED (taking a value 0-max_brightness). Most LEDs don't have hardware
+brightness support so will just be turned on for non-zero brightness settings.
+
+The class also introduces the optional concept of an LED trigger. A trigger
+is a kernel based source of led events. Triggers can either be simple or
+complex. A simple trigger isn't configurable and is designed to slot into
+existing subsystems with minimal additional code. Examples are the ide-disk,
+nand-disk and sharpsl-charge triggers. With led triggers disabled, the code
+optimises away.
+
+Complex triggers whilst available to all LEDs have LED specific
+parameters and work on a per LED basis. The timer trigger is an example.
+The timer trigger will periodically change the LED brightness between
+LED_OFF and the current brightness setting. The "on" and "off" time can
+be specified via /sys/class/leds/<device>/delay_{on,off} in milliseconds.
+You can change the brightness value of a LED independently of the timer
+trigger. However, if you set the brightness value to LED_OFF it will
+also disable the timer trigger.
+
+You can change triggers in a similar manner to the way an IO scheduler
+is chosen (via /sys/class/leds/<device>/trigger). Trigger specific
+parameters can appear in /sys/class/leds/<device> once a given trigger is
+selected.
+
+
+Design Philosophy
+=================
+
+The underlying design philosophy is simplicity. LEDs are simple devices
+and the aim is to keep a small amount of code giving as much functionality
+as possible.  Please keep this in mind when suggesting enhancements.
+
+
+LED Device Naming
+=================
+
+Is currently of the form:
+
+"devicename:colour:function"
+
+There have been calls for LED properties such as colour to be exported as
+individual led class attributes. As a solution which doesn't incur as much
+overhead, I suggest these become part of the device name. The naming scheme
+above leaves scope for further attributes should they be needed. If sections
+of the name don't apply, just leave that section blank.
+
+
+Hardware accelerated blink of LEDs
+==================================
+
+Some LEDs can be programmed to blink without any CPU interaction. To
+support this feature, a LED driver can optionally implement the
+blink_set() function (see <linux/leds.h>). To set an LED to blinking,
+however, it is better to use use the API function led_blink_set(),
+as it will check and implement software fallback if necessary.
+
+To turn off blinking again, use the API function led_brightness_set()
+as that will not just set the LED brightness but also stop any software
+timers that may have been required for blinking.
+
+The blink_set() function should choose a user friendly blinking value
+if it is called with *delay_on==0 && *delay_off==0 parameters. In this
+case the driver should give back the chosen value through delay_on and
+delay_off parameters to the leds subsystem.
+
+Setting the brightness to zero with brightness_set() callback function
+should completely turn off the LED and cancel the previously programmed
+hardware blinking function, if any.
+
+
+Known Issues
+============
+
+The LED Trigger core cannot be a module as the simple trigger functions
+would cause nightmare dependency issues. I see this as a minor issue
+compared to the benefits the simple trigger functionality brings. The
+rest of the LED subsystem can be modular.
+
+
+Future Development
+==================
+
+At the moment, a trigger can't be created specifically for a single LED.
+There are a number of cases where a trigger might only be mappable to a
+particular LED (ACPI?). The addition of triggers provided by the LED driver
+should cover this option and be possible to add without breaking the
+current interface.
+
--- /dev/null
+++ linux-2.6.38-git18/Documentation/leds/leds-lp3944.txt
@@ -0,0 +1,50 @@
+Kernel driver lp3944
+====================
+
+  * National Semiconductor LP3944 Fun-light Chip
+    Prefix: 'lp3944'
+    Addresses scanned: None (see the Notes section below)
+    Datasheet: Publicly available at the National Semiconductor website
+               http://www.national.com/pf/LP/LP3944.html
+
+Authors:
+        Antonio Ospite <ospite@studenti.unina.it>
+
+
+Description
+-----------
+The LP3944 is a helper chip that can drive up to 8 leds, with two programmable
+DIM modes; it could even be used as a gpio expander but this driver assumes it
+is used as a led controller.
+
+The DIM modes are used to set _blink_ patterns for leds, the pattern is
+specified supplying two parameters:
+  - period: from 0s to 1.6s
+  - duty cycle: percentage of the period the led is on, from 0 to 100
+
+Setting a led in DIM0 or DIM1 mode makes it blink according to the pattern.
+See the datasheet for details.
+
+LP3944 can be found on Motorola A910 smartphone, where it drives the rgb
+leds, the camera flash light and the lcds power.
+
+
+Notes
+-----
+The chip is used mainly in embedded contexts, so this driver expects it is
+registered using the i2c_board_info mechanism.
+
+To register the chip at address 0x60 on adapter 0, set the platform data
+according to include/linux/leds-lp3944.h, set the i2c board info:
+
+	static struct i2c_board_info __initdata a910_i2c_board_info[] = {
+		{
+			I2C_BOARD_INFO("lp3944", 0x60),
+			.platform_data = &a910_lp3944_leds,
+		},
+	};
+
+and register it in the platform init function
+
+	i2c_register_board_info(0, a910_i2c_board_info,
+			ARRAY_SIZE(a910_i2c_board_info));
