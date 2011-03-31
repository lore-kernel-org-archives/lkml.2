Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab1CaNze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:55:34 -0400
Received: from smtp.nokia.com ([147.243.1.47]:64090 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757729Ab1CaNzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:55:33 -0400
From: Ameya Palande <ameya.palande@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, samu.p.onkalo@nokia.com, rdunlap@xenotime.net
Subject: [PATCH] Documentation: Gather led information in one place
Date: Thu, 31 Mar 2011 16:55:24 +0300
Message-Id: <1301579724-29893-1-git-send-email-ameya.palande@nokia.com>
X-Mailer: git-send-email 1.7.1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ameya Palande <ameya.palande@nokia.com>
---
 Documentation/leds-class.txt       |   98 ------------------------------------
 Documentation/leds-lp3944.txt      |   50 ------------------
 Documentation/leds/leds-class.txt  |   98 ++++++++++++++++++++++++++++++++++++
 Documentation/leds/leds-lp3944.txt |   50 ++++++++++++++++++
 4 files changed, 148 insertions(+), 148 deletions(-)
 delete mode 100644 Documentation/leds-class.txt
 delete mode 100644 Documentation/leds-lp3944.txt
 create mode 100644 Documentation/leds/leds-class.txt
 create mode 100644 Documentation/leds/leds-lp3944.txt

diff --git a/Documentation/leds-class.txt b/Documentation/leds-class.txt
deleted file mode 100644
index 58b266b..0000000
--- a/Documentation/leds-class.txt
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
diff --git a/Documentation/leds-lp3944.txt b/Documentation/leds-lp3944.txt
deleted file mode 100644
index c6eda18..0000000
--- a/Documentation/leds-lp3944.txt
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
diff --git a/Documentation/leds/leds-class.txt b/Documentation/leds/leds-class.txt
new file mode 100644
index 0000000..58b266b
--- /dev/null
+++ b/Documentation/leds/leds-class.txt
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
diff --git a/Documentation/leds/leds-lp3944.txt b/Documentation/leds/leds-lp3944.txt
new file mode 100644
index 0000000..c6eda18
--- /dev/null
+++ b/Documentation/leds/leds-lp3944.txt
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
-- 
1.7.1

