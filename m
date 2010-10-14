Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab0JNLh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 07:37:56 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:44630 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab0JNLhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 07:37:55 -0400
Subject: Re: mmotm 2010-10-13-17-13 uploaded (leds)
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rpurdie@rpsys.net
In-Reply-To: <20101013212902.2fec6413.randy.dunlap@oracle.com>
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>
	 <20101013212902.2fec6413.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 13:38:32 +0200
Message-ID: <1287056312.4641.296.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 05:29 +0100, Randy Dunlap wrote:

> When # CONFIG_LEDS_CLASS is not set
> & CONFIG_LEDS_TRIGGERS=y:
> 
> drivers/built-in.o: In function `led_trigger_set':
> (.text+0x4737b): undefined reference to `led_brightness_set'

Curious. Why is that even possible?

config LEDS_CLASS
...
if LEDS_CLASS
...
config LEDS_TRIGGERS
...
endif # LEDS_TRIGGERS

endif # LEDS_CLASS   
...

Are there dependencies missing? I was under the impression that this
shouldn't be happening. And what's the point in having triggers, but
nothing to trigger...? How about the patch below?

johannes


Subject: leds: fix up dependencies
From: Johannes Berg <johannes.berg@intel.com>

It's not useful to build LED triggers when
there's no LEDs that can be triggered by
them. Therefore, fix up the dependencies
so that this cannot happen, and fix a few
users that select triggers to depend on
LEDS_CLASS as well (there is also one user
that also selects LEDS_CLASS, which is OK).

As a result, we can now make everything a
module again if desired (including the LED
triggers, that previously could only be
built in) -- and add back the warning in
rt2x00's Kconfig I previously removed.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/leds/Kconfig                |   55 ++++++++++++++++++++++++++++--------
 drivers/macintosh/Kconfig           |    1 
 drivers/net/wireless/rt2x00/Kconfig |    3 +
 net/mac80211/Kconfig                |    2 -
 4 files changed, 49 insertions(+), 12 deletions(-)

--- wireless-testing.orig/drivers/leds/Kconfig	2010-10-14 13:32:25.000000000 +0200
+++ wireless-testing/drivers/leds/Kconfig	2010-10-14 13:32:36.000000000 +0200
@@ -7,26 +7,27 @@ menuconfig NEW_LEDS
 	  This is not related to standard keyboard LEDs which are controlled
 	  via the input system.
 
-if NEW_LEDS
-
 config LEDS_CLASS
-	bool "LED Class Support"
+	tristate "LED Class Support"
+	depends on NEW_LEDS
 	help
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
 
-if LEDS_CLASS
+if NEW_LEDS
 
 comment "LED drivers"
 
 config LEDS_PRINTK
 	tristate "printk fake LED"
+	depends on LEDS_CLASS
 	help
 	  This adds an LED that just prints the brightness to
 	  the kernel messages.
 
 config LEDS_88PM860X
 	tristate "LED Support for Marvell 88PM860x PMIC"
+	depends on LEDS_CLASS
 	depends on MFD_88PM860X
 	help
 	  This option enables support for on-chip LED drivers found on Marvell
@@ -34,6 +35,7 @@ config LEDS_88PM860X
 
 config LEDS_ATMEL_PWM
 	tristate "LED Support using Atmel PWM outputs"
+	depends on LEDS_CLASS
 	depends on ATMEL_PWM
 	help
 	  This option enables support for LEDs driven using outputs
@@ -41,6 +43,7 @@ config LEDS_ATMEL_PWM
 
 config LEDS_LOCOMO
 	tristate "LED Support for Locomo device"
+	depends on LEDS_CLASS
 	depends on SHARP_LOCOMO
 	help
 	  This option enables support for the LEDs on Sharp Locomo.
@@ -48,6 +51,7 @@ config LEDS_LOCOMO
 
 config LEDS_MIKROTIK_RB532
 	tristate "LED Support for Mikrotik Routerboard 532"
+	depends on LEDS_CLASS
 	depends on MIKROTIK_RB532
 	help
 	  This option enables support for the so called "User LED" of
@@ -55,6 +59,7 @@ config LEDS_MIKROTIK_RB532
 
 config LEDS_S3C24XX
 	tristate "LED Support for Samsung S3C24XX GPIO LEDs"
+	depends on LEDS_CLASS
 	depends on ARCH_S3C2410
 	help
 	  This option enables support for LEDs connected to GPIO lines
@@ -62,12 +67,14 @@ config LEDS_S3C24XX
 
 config LEDS_AMS_DELTA
 	tristate "LED Support for the Amstrad Delta (E3)"
+	depends on LEDS_CLASS
 	depends on MACH_AMS_DELTA
 	help
 	  This option enables support for the LEDs on Amstrad Delta (E3).
 
 config LEDS_NET48XX
 	tristate "LED Support for Soekris net48xx series Error LED"
+	depends on LEDS_CLASS
 	depends on SCx200_GPIO
 	help
 	  This option enables support for the Soekris net4801 and net4826 error
@@ -85,18 +92,21 @@ config LEDS_NET5501
 
 config LEDS_FSG
 	tristate "LED Support for the Freecom FSG-3"
+	depends on LEDS_CLASS
 	depends on MACH_FSG
 	help
 	  This option enables support for the LEDs on the Freecom FSG-3.
 
 config LEDS_WRAP
 	tristate "LED Support for the WRAP series LEDs"
+	depends on LEDS_CLASS
 	depends on SCx200_GPIO
 	help
 	  This option enables support for the PCEngines WRAP programmable LEDs.
 
 config LEDS_ALIX2
 	tristate "LED Support for ALIX.2 and ALIX.3 series"
+	depends on LEDS_CLASS
 	depends on X86 && !GPIO_CS5535 && !CS5535_GPIO
 	help
 	  This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
@@ -104,12 +114,14 @@ config LEDS_ALIX2
 
 config LEDS_H1940
 	tristate "LED Support for iPAQ H1940 device"
+	depends on LEDS_CLASS
 	depends on ARCH_H1940
 	help
 	  This option enables support for the LEDs on the h1940.
 
 config LEDS_COBALT_QUBE
 	tristate "LED Support for the Cobalt Qube series front LED"
+	depends on LEDS_CLASS
 	depends on MIPS_COBALT
 	help
 	  This option enables support for the front LED on Cobalt Qube series
@@ -123,6 +135,7 @@ config LEDS_COBALT_RAQ
 
 config LEDS_SUNFIRE
 	tristate "LED support for SunFire servers."
+	depends on LEDS_CLASS
 	depends on SPARC64
 	select LEDS_TRIGGERS
 	help
@@ -131,6 +144,7 @@ config LEDS_SUNFIRE
 
 config LEDS_HP6XX
 	tristate "LED Support for the HP Jornada 6xx"
+	depends on LEDS_CLASS
 	depends on SH_HP6XX
 	help
 	  This option enables LED support for the handheld
@@ -138,6 +152,7 @@ config LEDS_HP6XX
 
 config LEDS_PCA9532
 	tristate "LED driver for PCA9532 dimmer"
+	depends on LEDS_CLASS
 	depends on I2C && INPUT && EXPERIMENTAL
 	help
 	  This option enables support for NXP pca9532
@@ -146,6 +161,7 @@ config LEDS_PCA9532
 
 config LEDS_GPIO
 	tristate "LED Support for GPIO connected LEDs"
+	depends on LEDS_CLASS
 	depends on GENERIC_GPIO
 	help
 	  This option enables support for the LEDs connected to GPIO
@@ -173,6 +189,7 @@ config LEDS_GPIO_OF
 
 config LEDS_LP3944
 	tristate "LED Support for N.S. LP3944 (Fun Light) I2C chip"
+	depends on LEDS_CLASS
 	depends on I2C
 	help
 	  This option enables support for LEDs connected to the National
@@ -184,6 +201,7 @@ config LEDS_LP3944
 
 config LEDS_CLEVO_MAIL
 	tristate "Mail LED on Clevo notebook"
+	depends on LEDS_CLASS
 	depends on X86 && SERIO_I8042 && DMI
 	help
 	  This driver makes the mail LED accessible from userspace
@@ -214,6 +232,7 @@ config LEDS_CLEVO_MAIL
 
 config LEDS_PCA955X
 	tristate "LED Support for PCA955x I2C chips"
+	depends on LEDS_CLASS
 	depends on I2C
 	help
 	  This option enables support for LEDs connected to PCA955x
@@ -222,6 +241,7 @@ config LEDS_PCA955X
 
 config LEDS_WM831X_STATUS
 	tristate "LED support for status LEDs on WM831x PMICs"
+	depends on LEDS_CLASS
 	depends on MFD_WM831X
 	help
 	  This option enables support for the status LEDs of the WM831x
@@ -229,6 +249,7 @@ config LEDS_WM831X_STATUS
 
 config LEDS_WM8350
 	tristate "LED Support for WM8350 AudioPlus PMIC"
+	depends on LEDS_CLASS
 	depends on MFD_WM8350
 	help
 	  This option enables support for LEDs driven by the Wolfson
@@ -236,6 +257,7 @@ config LEDS_WM8350
 
 config LEDS_DA903X
 	tristate "LED Support for DA9030/DA9034 PMIC"
+	depends on LEDS_CLASS
 	depends on PMIC_DA903X
 	help
 	  This option enables support for on-chip LED drivers found
@@ -243,6 +265,7 @@ config LEDS_DA903X
 
 config LEDS_DAC124S085
 	tristate "LED Support for DAC124S085 SPI DAC"
+	depends on LEDS_CLASS
 	depends on SPI
 	help
 	  This option enables support for DAC124S085 SPI DAC from NatSemi,
@@ -250,18 +273,21 @@ config LEDS_DAC124S085
 
 config LEDS_PWM
 	tristate "PWM driven LED Support"
+	depends on LEDS_CLASS
 	depends on HAVE_PWM
 	help
 	  This option enables support for pwm driven LEDs
 
 config LEDS_REGULATOR
 	tristate "REGULATOR driven LED support"
+	depends on LEDS_CLASS
 	depends on REGULATOR
 	help
 	  This option enables support for regulator driven LEDs.
 
 config LEDS_BD2802
 	tristate "LED driver for BD2802 RGB LED"
+	depends on LEDS_CLASS
 	depends on I2C
 	help
 	  This option enables support for BD2802GU RGB LED driver chips
@@ -269,6 +295,7 @@ config LEDS_BD2802
 
 config LEDS_INTEL_SS4200
 	tristate "LED driver for Intel NAS SS4200 series"
+	depends on LEDS_CLASS
 	depends on PCI && DMI
 	help
 	  This option enables support for the Intel SS4200 series of
@@ -278,6 +305,7 @@ config LEDS_INTEL_SS4200
 
 config LEDS_LT3593
 	tristate "LED driver for LT3593 controllers"
+	depends on LEDS_CLASS
 	depends on GENERIC_GPIO
 	help
 	  This option enables support for LEDs driven by a Linear Technology
@@ -286,6 +314,7 @@ config LEDS_LT3593
 
 config LEDS_ADP5520
 	tristate "LED Support for ADP5520/ADP5501 PMIC"
+	depends on LEDS_CLASS
 	depends on PMIC_ADP5520
 	help
 	  This option enables support for on-chip LED drivers found
@@ -296,6 +325,7 @@ config LEDS_ADP5520
 
 config LEDS_DELL_NETBOOKS
 	tristate "External LED on Dell Business Netbooks"
+	depends on LEDS_CLASS
 	depends on X86 && ACPI_WMI
 	help
 	  This adds support for the Latitude 2100 and similar
@@ -303,6 +333,7 @@ config LEDS_DELL_NETBOOKS
 
 config LEDS_MC13783
 	tristate "LED Support for MC13783 PMIC"
+	depends on LEDS_CLASS
 	depends on MFD_MC13783
 	help
 	  This option enable support for on-chip LED drivers found
@@ -310,6 +341,7 @@ config LEDS_MC13783
 
 config LEDS_NS2
 	tristate "LED support for Network Space v2 GPIO LEDs"
+	depends on LEDS_CLASS
 	depends on MACH_NETSPACE_V2 || MACH_INETSPACE_V2 || MACH_NETSPACE_MAX_V2
 	default y
 	help
@@ -318,18 +350,18 @@ config LEDS_NS2
 	  Network Space (Max) v2 and d2 Network v2 boards.
 
 config LEDS_TRIGGERS
-	bool "LED Trigger support"
+	tristate "LED Trigger support"
+	depends on LEDS_CLASS
 	help
 	  This option enables trigger support for the leds class.
 	  These triggers allow kernel events to drive the LEDs and can
 	  be configured via sysfs. If unsure, say Y.
 
-if LEDS_TRIGGERS
-
 comment "LED Triggers"
 
 config LEDS_TRIGGER_TIMER
 	tristate "LED Timer Trigger"
+	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be controlled by a programmable timer
 	  via sysfs. Some LED hardware can be programmed to start
@@ -341,12 +373,14 @@ config LEDS_TRIGGER_TIMER
 config LEDS_TRIGGER_IDE_DISK
 	bool "LED IDE Disk Trigger"
 	depends on IDE_GD_ATA
+	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be controlled by IDE disk activity.
 	  If unsure, say Y.
 
 config LEDS_TRIGGER_HEARTBEAT
 	tristate "LED Heartbeat Trigger"
+	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be controlled by a CPU load average.
 	  The flash frequency is a hyperbolic function of the 1-minute
@@ -355,6 +389,7 @@ config LEDS_TRIGGER_HEARTBEAT
 
 config LEDS_TRIGGER_BACKLIGHT
 	tristate "LED backlight Trigger"
+	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be controlled as a backlight device: they
 	  turn off and on when the display is blanked and unblanked.
@@ -363,6 +398,7 @@ config LEDS_TRIGGER_BACKLIGHT
 
 config LEDS_TRIGGER_GPIO
 	tristate "LED GPIO Trigger"
+	depends on LEDS_TRIGGERS
 	depends on GPIOLIB
 	help
 	  This allows LEDs to be controlled by gpio events. It's good
@@ -375,6 +411,7 @@ config LEDS_TRIGGER_GPIO
 
 config LEDS_TRIGGER_DEFAULT_ON
 	tristate "LED Default ON Trigger"
+	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be initialised in the ON state.
 	  If unsure, say Y.
@@ -382,8 +419,4 @@ config LEDS_TRIGGER_DEFAULT_ON
 comment "iptables trigger is under Netfilter config (LED target)"
 	depends on LEDS_TRIGGERS
 
-endif # LEDS_TRIGGERS
-
-endif # LEDS_CLASS
-
 endif # NEW_LEDS
--- wireless-testing.orig/drivers/macintosh/Kconfig	2010-10-14 13:32:26.000000000 +0200
+++ wireless-testing/drivers/macintosh/Kconfig	2010-10-14 13:32:36.000000000 +0200
@@ -102,6 +102,7 @@ config ADB_PMU_LED
 config ADB_PMU_LED_IDE
 	bool "Use front LED as IDE LED by default"
 	depends on ADB_PMU_LED
+	depends on LEDS_CLASS=y
 	select LEDS_TRIGGERS
 	select LEDS_TRIGGER_IDE_DISK
 	help
--- wireless-testing.orig/net/mac80211/Kconfig	2010-10-14 13:32:25.000000000 +0200
+++ wireless-testing/net/mac80211/Kconfig	2010-10-14 13:32:36.000000000 +0200
@@ -92,7 +92,7 @@ config MAC80211_MESH
 config MAC80211_LEDS
 	bool "Enable LED triggers"
 	depends on MAC80211
-	select NEW_LEDS
+	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
 	select LEDS_TRIGGERS
 	---help---
 	  This option enables a few LED triggers for different
--- wireless-testing.orig/drivers/net/wireless/rt2x00/Kconfig	2010-10-14 13:32:39.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rt2x00/Kconfig	2010-10-14 13:32:43.000000000 +0200
@@ -221,6 +221,9 @@ config RT2X00_LIB_LEDS
 	boolean
 	default y if (RT2X00_LIB=y && LEDS_CLASS=y) || (RT2X00_LIB=m && LEDS_CLASS!=n)
 
+comment "rt2x00 leds support disabled due to modularized LEDS_CLASS and built-in rt2x00"
+	depends on RT2X00_LIB=y && LEDS_CLASS=m
+
 config RT2X00_LIB_DEBUGFS
 	bool "Ralink debugfs support"
 	depends on RT2X00_LIB && MAC80211_DEBUGFS


