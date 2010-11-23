Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab0KWIDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 03:03:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52996 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab0KWIC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 03:02:59 -0500
Date: Tue, 23 Nov 2010 09:02:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Berg, Johannes" <johannes.berg@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Arnd Hannemann <arnd@arndnet.de>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Message-ID: <20101123080242.GA29188@elte.hu>
References: <C5C86A19469DAE48AAAD0E5F3716E44501D41A7DC2@irsmsx504.ger.corp.intel.com>
 <20101118082454.GC15928@tiehlicka.suse.cz>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41ECB46@irsmsx504.ger.corp.intel.com>
 <4CEAA151.7050404@arndnet.de>
 <20101123063200.GA23907@elte.hu>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41ED756@irsmsx504.ger.corp.intel.com>
 <20101122233654.117eef93.akpm@linux-foundation.org>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41ED75C@irsmsx504.ger.corp.intel.com>
 <20101122234407.c710e578.akpm@linux-foundation.org>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41ED769@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5C86A19469DAE48AAAD0E5F3716E44501D41ED769@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Berg, Johannes <johannes.berg@intel.com> wrote:

> 
> > > Will do. I suspect it should, unless you took new LED drivers? But
> > then
> > > again you will now probably want a patch against -rc, not -mm?
> > >
> > 
> > It applied OK(ish) to current mainline.
> 
> It seems to need a "depends on LEDS_CLASS" to the new driver
> "config LEDS_NETXBIG" in drivers/leds/. Other than that, it
> still seems to be complete against current mainline (-rc3).
> 
> Do you just want to add the single line to it yourself?

Hm, when I applied your patch to rc3 it added that line to LEDS_NETXBIG. Fortunate 
side-effect of diff fuzz? Below is how it applied here.

Thanks,

	Ingo

----------------------->
>From ce47463f65a460832aec359ddc9ab3c5b9bfff8a Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Tue, 26 Oct 2010 12:14:41 +0200
Subject: [PATCH] leds: Fix build bug

It's not useful to build LED triggers when
there's no LEDs that can be triggered by
them. Therefore, fix up the dependencies
so that this cannot happen, and fix a few
users that select triggers to depend on
LEDS_CLASS as well (there is also one user
that also selects LEDS_CLASS, which is OK).

As a result, we can now make everything a
module again if desired (including the LED
triggers, which previously could only be
built in) -- and add back the warning in
rt2x00's Kconfig I previously removed.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: rpurdie@rpsys.net
LKML-Reference: <1288088081.3761.31.camel@jlt3.sipsolutions.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/leds/Kconfig                |   57 ++++++++++++++++++++++++++++-------
 drivers/macintosh/Kconfig           |    1 +
 drivers/net/wireless/rt2x00/Kconfig |    3 ++
 net/mac80211/Kconfig                |    2 +-
 4 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 115cc9f..6f2dd05 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -7,20 +7,20 @@ menuconfig NEW_LEDS
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
 
 config LEDS_88PM860X
 	tristate "LED Support for Marvell 88PM860x PMIC"
+	depends on LEDS_CLASS
 	depends on MFD_88PM860X
 	help
 	  This option enables support for on-chip LED drivers found on Marvell
@@ -28,6 +28,7 @@ config LEDS_88PM860X
 
 config LEDS_ATMEL_PWM
 	tristate "LED Support using Atmel PWM outputs"
+	depends on LEDS_CLASS
 	depends on ATMEL_PWM
 	help
 	  This option enables support for LEDs driven using outputs
@@ -35,6 +36,7 @@ config LEDS_ATMEL_PWM
 
 config LEDS_LOCOMO
 	tristate "LED Support for Locomo device"
+	depends on LEDS_CLASS
 	depends on SHARP_LOCOMO
 	help
 	  This option enables support for the LEDs on Sharp Locomo.
@@ -42,6 +44,7 @@ config LEDS_LOCOMO
 
 config LEDS_MIKROTIK_RB532
 	tristate "LED Support for Mikrotik Routerboard 532"
+	depends on LEDS_CLASS
 	depends on MIKROTIK_RB532
 	help
 	  This option enables support for the so called "User LED" of
@@ -49,6 +52,7 @@ config LEDS_MIKROTIK_RB532
 
 config LEDS_S3C24XX
 	tristate "LED Support for Samsung S3C24XX GPIO LEDs"
+	depends on LEDS_CLASS
 	depends on ARCH_S3C2410
 	help
 	  This option enables support for LEDs connected to GPIO lines
@@ -56,12 +60,14 @@ config LEDS_S3C24XX
 
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
@@ -79,18 +85,21 @@ config LEDS_NET5501
 
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
@@ -98,12 +107,14 @@ config LEDS_ALIX2
 
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
@@ -117,6 +128,7 @@ config LEDS_COBALT_RAQ
 
 config LEDS_SUNFIRE
 	tristate "LED support for SunFire servers."
+	depends on LEDS_CLASS
 	depends on SPARC64
 	select LEDS_TRIGGERS
 	help
@@ -125,6 +137,7 @@ config LEDS_SUNFIRE
 
 config LEDS_HP6XX
 	tristate "LED Support for the HP Jornada 6xx"
+	depends on LEDS_CLASS
 	depends on SH_HP6XX
 	help
 	  This option enables LED support for the handheld
@@ -132,6 +145,7 @@ config LEDS_HP6XX
 
 config LEDS_PCA9532
 	tristate "LED driver for PCA9532 dimmer"
+	depends on LEDS_CLASS
 	depends on I2C && INPUT && EXPERIMENTAL
 	help
 	  This option enables support for NXP pca9532
@@ -140,6 +154,7 @@ config LEDS_PCA9532
 
 config LEDS_GPIO
 	tristate "LED Support for GPIO connected LEDs"
+	depends on LEDS_CLASS
 	depends on GENERIC_GPIO
 	help
 	  This option enables support for the LEDs connected to GPIO
@@ -150,6 +165,7 @@ config LEDS_GPIO
 
 config LEDS_GPIO_PLATFORM
 	bool "Platform device bindings for GPIO LEDs"
+	depends on LEDS_CLASS
 	depends on LEDS_GPIO
 	default y
 	help
@@ -158,6 +174,7 @@ config LEDS_GPIO_PLATFORM
 
 config LEDS_GPIO_OF
 	bool "OpenFirmware platform device bindings for GPIO LEDs"
+	depends on LEDS_CLASS
 	depends on LEDS_GPIO && OF_DEVICE
 	default y
 	help
@@ -167,6 +184,7 @@ config LEDS_GPIO_OF
 
 config LEDS_LP3944
 	tristate "LED Support for N.S. LP3944 (Fun Light) I2C chip"
+	depends on LEDS_CLASS
 	depends on I2C
 	help
 	  This option enables support for LEDs connected to the National
@@ -196,6 +214,7 @@ config LEDS_LP5523
 
 config LEDS_CLEVO_MAIL
 	tristate "Mail LED on Clevo notebook"
+	depends on LEDS_CLASS
 	depends on X86 && SERIO_I8042 && DMI
 	help
 	  This driver makes the mail LED accessible from userspace
@@ -226,6 +245,7 @@ config LEDS_CLEVO_MAIL
 
 config LEDS_PCA955X
 	tristate "LED Support for PCA955x I2C chips"
+	depends on LEDS_CLASS
 	depends on I2C
 	help
 	  This option enables support for LEDs connected to PCA955x
@@ -234,6 +254,7 @@ config LEDS_PCA955X
 
 config LEDS_WM831X_STATUS
 	tristate "LED support for status LEDs on WM831x PMICs"
+	depends on LEDS_CLASS
 	depends on MFD_WM831X
 	help
 	  This option enables support for the status LEDs of the WM831x
@@ -241,6 +262,7 @@ config LEDS_WM831X_STATUS
 
 config LEDS_WM8350
 	tristate "LED Support for WM8350 AudioPlus PMIC"
+	depends on LEDS_CLASS
 	depends on MFD_WM8350
 	help
 	  This option enables support for LEDs driven by the Wolfson
@@ -248,6 +270,7 @@ config LEDS_WM8350
 
 config LEDS_DA903X
 	tristate "LED Support for DA9030/DA9034 PMIC"
+	depends on LEDS_CLASS
 	depends on PMIC_DA903X
 	help
 	  This option enables support for on-chip LED drivers found
@@ -255,6 +278,7 @@ config LEDS_DA903X
 
 config LEDS_DAC124S085
 	tristate "LED Support for DAC124S085 SPI DAC"
+	depends on LEDS_CLASS
 	depends on SPI
 	help
 	  This option enables support for DAC124S085 SPI DAC from NatSemi,
@@ -262,18 +286,21 @@ config LEDS_DAC124S085
 
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
@@ -281,6 +308,7 @@ config LEDS_BD2802
 
 config LEDS_INTEL_SS4200
 	tristate "LED driver for Intel NAS SS4200 series"
+	depends on LEDS_CLASS
 	depends on PCI && DMI
 	depends on 0
 	help
@@ -291,6 +319,7 @@ config LEDS_INTEL_SS4200
 
 config LEDS_LT3593
 	tristate "LED driver for LT3593 controllers"
+	depends on LEDS_CLASS
 	depends on GENERIC_GPIO
 	help
 	  This option enables support for LEDs driven by a Linear Technology
@@ -299,6 +328,7 @@ config LEDS_LT3593
 
 config LEDS_ADP5520
 	tristate "LED Support for ADP5520/ADP5501 PMIC"
+	depends on LEDS_CLASS
 	depends on PMIC_ADP5520
 	help
 	  This option enables support for on-chip LED drivers found
@@ -309,6 +339,7 @@ config LEDS_ADP5520
 
 config LEDS_DELL_NETBOOKS
 	tristate "External LED on Dell Business Netbooks"
+	depends on LEDS_CLASS
 	depends on X86 && ACPI_WMI
 	help
 	  This adds support for the Latitude 2100 and similar
@@ -316,6 +347,7 @@ config LEDS_DELL_NETBOOKS
 
 config LEDS_MC13783
 	tristate "LED Support for MC13783 PMIC"
+	depends on LEDS_CLASS
 	depends on MFD_MC13783
 	help
 	  This option enable support for on-chip LED drivers found
@@ -323,6 +355,7 @@ config LEDS_MC13783
 
 config LEDS_NS2
 	tristate "LED support for Network Space v2 GPIO LEDs"
+	depends on LEDS_CLASS
 	depends on MACH_NETSPACE_V2 || MACH_INETSPACE_V2 || MACH_NETSPACE_MAX_V2 || D2NET_V2
 	default y
 	help
@@ -332,6 +365,7 @@ config LEDS_NS2
 
 config LEDS_NETXBIG
 	tristate "LED support for Big Network series LEDs"
+	depends on LEDS_CLASS
 	depends on MACH_NET2BIG_V2 || MACH_NET5BIG_V2
 	default y
 	help
@@ -340,18 +374,18 @@ config LEDS_NETXBIG
 	  controlled through a GPIO extension bus.
 
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
@@ -363,12 +397,14 @@ config LEDS_TRIGGER_TIMER
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
@@ -377,6 +413,7 @@ config LEDS_TRIGGER_HEARTBEAT
 
 config LEDS_TRIGGER_BACKLIGHT
 	tristate "LED backlight Trigger"
+	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be controlled as a backlight device: they
 	  turn off and on when the display is blanked and unblanked.
@@ -385,6 +422,7 @@ config LEDS_TRIGGER_BACKLIGHT
 
 config LEDS_TRIGGER_GPIO
 	tristate "LED GPIO Trigger"
+	depends on LEDS_TRIGGERS
 	depends on GPIOLIB
 	help
 	  This allows LEDs to be controlled by gpio events. It's good
@@ -397,6 +435,7 @@ config LEDS_TRIGGER_GPIO
 
 config LEDS_TRIGGER_DEFAULT_ON
 	tristate "LED Default ON Trigger"
+	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be initialised in the ON state.
 	  If unsure, say Y.
@@ -404,8 +443,4 @@ config LEDS_TRIGGER_DEFAULT_ON
 comment "iptables trigger is under Netfilter config (LED target)"
 	depends on LEDS_TRIGGERS
 
-endif # LEDS_TRIGGERS
-
-endif # LEDS_CLASS
-
 endif # NEW_LEDS
diff --git a/drivers/macintosh/Kconfig b/drivers/macintosh/Kconfig
index 3d7355f..646a3e8 100644
--- a/drivers/macintosh/Kconfig
+++ b/drivers/macintosh/Kconfig
@@ -102,6 +102,7 @@ config ADB_PMU_LED
 config ADB_PMU_LED_IDE
 	bool "Use front LED as IDE LED by default"
 	depends on ADB_PMU_LED
+	depends on LEDS_CLASS=y
 	select LEDS_TRIGGERS
 	select LEDS_TRIGGER_IDE_DISK
 	help
diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index c088be3..21a632b 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -222,6 +222,9 @@ config RT2X00_LIB_LEDS
 	boolean
 	default y if (RT2X00_LIB=y && LEDS_CLASS=y) || (RT2X00_LIB=m && LEDS_CLASS!=n)
 
+comment "rt2x00 leds support disabled due to modularized LEDS_CLASS and built-in rt2x00"
+	depends on RT2X00_LIB=y && LEDS_CLASS=m
+
 config RT2X00_LIB_DEBUGFS
 	bool "Ralink debugfs support"
 	depends on RT2X00_LIB && MAC80211_DEBUGFS
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 4d6f865..aca4f7f 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -92,7 +92,7 @@ config MAC80211_MESH
 config MAC80211_LEDS
 	bool "Enable LED triggers"
 	depends on MAC80211
-	select NEW_LEDS
+	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
 	select LEDS_TRIGGERS
 	---help---
 	  This option enables a few LED triggers for different
