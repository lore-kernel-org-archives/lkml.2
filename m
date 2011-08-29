Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1H2SmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:42:16 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:53690 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754323Ab1H2SmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:42:11 -0400
From: Luciano Coelho <coelho@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: matti.j.aaltonen@nokia.com, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Jean Delvare <khali@linux-fr.org>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] mfd: Combine MFD_SUPPORT and MFD_CORE
Date: Mon, 29 Aug 2011 21:41:47 +0300
Message-Id: <1314643307-17780-1-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20110829102732.03f0f05d.rdunlap@xenotime.net>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Combine MFD_SUPPORT (which only enabled the remainder of the MFD
menu) and MFD_CORE.  This allows other drivers to select MFD_CORE
without needing to also select MFD_SUPPORT, which fixes some
kconfig unmet dependency warnings.  Modeled after I2C kconfig.

[Forward-ported to 3.1-rc4.  This fixes a warning when some drivers,
such as RADIO_WL1273, are selected, but MFD_SUPPORT is not. -- Luca]

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---

I guess this should fix the problem.  I've simple forward-ported
Randy's patch to the latest mainline kernel.  I don't know via which
tree this should go in, though.

NOTE: I have *not* tested this very thoroughly.  But at least
omap2plus stuff seems to work okay with this change.  MFD_SUPPORT is
also selected by a couple of "tile" platforms defconfigs, but I guess
the Kconfig system should take care of it.

 arch/arm/mach-omap2/Kconfig |    2 +-
 drivers/gpio/Kconfig        |    3 +-
 drivers/mfd/Kconfig         |   54 +++---------------------------------------
 3 files changed, 6 insertions(+), 53 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 57b66d5..1046923 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -14,7 +14,7 @@ config ARCH_OMAP2PLUS_TYPICAL
 	select SERIAL_OMAP_CONSOLE
 	select I2C
 	select I2C_OMAP
-	select MFD_SUPPORT
+	select MFD_CORE
 	select MENELAUS if ARCH_OMAP2
 	select TWL4030_CORE if ARCH_OMAP3 || ARCH_OMAP4
 	select TWL4030_POWER if ARCH_OMAP3 || ARCH_OMAP4
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d539efd..fbc5fd4 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -180,7 +180,7 @@ config GPIO_SCH
 
 config GPIO_VX855
 	tristate "VIA VX855/VX875 GPIO"
-	depends on MFD_SUPPORT && PCI
+	depends on PCI
 	select MFD_CORE
 	select MFD_VX855
 	help
@@ -417,7 +417,6 @@ config GPIO_TIMBERDALE
 config GPIO_RDC321X
 	tristate "RDC R-321x GPIO support"
 	depends on PCI
-	select MFD_SUPPORT
 	select MFD_CORE
 	select MFD_RDC321X
 	help
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 21574bd..1836cdf 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -2,10 +2,9 @@
 # Multifunction miscellaneous devices
 #
 
-menuconfig MFD_SUPPORT
-	bool "Multifunction device drivers"
+menuconfig MFD_CORE
+	tristate "Multifunction device drivers"
 	depends on HAS_IOMEM
-	default y
 	help
 	  Multifunction devices embed several functions (e.g. GPIOs,
 	  touchscreens, keyboards, current regulators, power management chips,
@@ -18,16 +17,11 @@ menuconfig MFD_SUPPORT
 
 	  This option alone does not add any kernel code.
 
-if MFD_SUPPORT
-
-config MFD_CORE
-	tristate
-	default n
+if MFD_CORE
 
 config MFD_88PM860X
 	bool "Support Marvell 88PM8606/88PM8607"
 	depends on I2C=y && GENERIC_HARDIRQS
-	select MFD_CORE
 	help
 	  This supports for Marvell 88PM8606/88PM8607 Power Management IC.
 	  This includes the I2C driver and the core APIs _only_, you have to
@@ -55,14 +49,12 @@ config MFD_SM501_GPIO
 config MFD_ASIC3
 	bool "Support for Compaq ASIC3"
 	depends on GENERIC_HARDIRQS && GPIOLIB && ARM
-	select MFD_CORE
 	 ---help---
 	  This driver supports the ASIC3 multifunction chip found on many
 	  PDAs (mainly iPAQ and HTC based ones)
 
 config MFD_DAVINCI_VOICECODEC
 	tristate
-	select MFD_CORE
 
 config MFD_DM355EVM_MSP
 	bool "DaVinci DM355 EVM microcontroller"
@@ -75,7 +67,6 @@ config MFD_DM355EVM_MSP
 config MFD_TI_SSP
 	tristate "TI Sequencer Serial Port support"
 	depends on ARCH_DAVINCI_TNETV107X
-	select MFD_CORE
 	---help---
 	  Say Y here if you want support for the Sequencer Serial Port
 	  in a Texas Instruments TNETV107X SoC.
@@ -93,7 +84,6 @@ config HTC_EGPIO
 
 config HTC_PASIC3
 	tristate "HTC PASIC3 LED/DS1WM chip support"
-	select MFD_CORE
 	help
 	  This core driver provides register access for the LED/DS1WM
 	  chips labeled "AIC2" and "AIC3", found on HTC Blueangel and
@@ -124,7 +114,6 @@ config TPS6105X
 	tristate "TPS61050/61052 Boost Converters"
 	depends on I2C
 	select REGULATOR
-	select MFD_CORE
 	select REGULATOR_FIXED_VOLTAGE
 	help
 	  This option enables a driver for the TP61050/TPS61052
@@ -147,7 +136,6 @@ config TPS65010
 
 config TPS6507X
 	tristate "TPS6507x Power Management / Touch Screen chips"
-	select MFD_CORE
 	depends on I2C
 	help
 	  If you say yes here you get support for the TPS6507x series of
@@ -160,7 +148,6 @@ config TPS6507X
 config MFD_TPS6586X
 	bool "TPS6586x Power Management chips"
 	depends on I2C=y && GPIOLIB && GENERIC_HARDIRQS
-	select MFD_CORE
 	help
 	  If you say yes here you get support for the TPS6586X series of
 	  Power Management chips.
@@ -174,7 +161,6 @@ config MFD_TPS6586X
 config MFD_TPS65910
 	bool "TPS65910 Power Management chip"
 	depends on I2C=y && GPIOLIB
-	select MFD_CORE
 	select GPIO_TPS65910
 	help
 	  if you say yes here you get support for the TPS65910 series of
@@ -186,7 +172,6 @@ config MFD_TPS65912
 
 config MFD_TPS65912_I2C
 	bool "TPS95612 Power Management chip with I2C"
-	select MFD_CORE
 	select MFD_TPS65912
 	depends on I2C=y && GPIOLIB
 	help
@@ -195,7 +180,6 @@ config MFD_TPS65912_I2C
 
 config MFD_TPS65912_SPI
 	bool "TPS65912 Power Management chip with SPI"
-	select MFD_CORE
 	select MFD_TPS65912
 	depends on SPI_MASTER && GPIOLIB
 	help
@@ -252,7 +236,6 @@ config TWL4030_POWER
 config MFD_TWL4030_AUDIO
 	bool
 	depends on TWL4030_CORE
-	select MFD_CORE
 	default n
 
 config TWL6030_PWM
@@ -267,13 +250,11 @@ config TWL6030_PWM
 config TWL6040_CORE
 	bool
 	depends on TWL4030_CORE && GENERIC_HARDIRQS
-	select MFD_CORE
 	default n
 
 config MFD_STMPE
 	bool "Support STMicroelectronics STMPE"
 	depends on I2C=y && GENERIC_HARDIRQS
-	select MFD_CORE
 	help
 	  Support for the STMPE family of I/O Expanders from
 	  STMicroelectronics.
@@ -296,7 +277,6 @@ config MFD_STMPE
 config MFD_TC3589X
 	bool "Support Toshiba TC35892 and variants"
 	depends on I2C=y && GENERIC_HARDIRQS
-	select MFD_CORE
 	help
 	  Support for the Toshiba TC35892 and variants I/O Expander.
 
@@ -311,7 +291,6 @@ config MFD_TMIO
 config MFD_T7L66XB
 	bool "Support Toshiba T7L66XB"
 	depends on ARM && HAVE_CLK
-	select MFD_CORE
 	select MFD_TMIO
 	help
 	  Support for Toshiba Mobile IO Controller T7L66XB
@@ -319,7 +298,6 @@ config MFD_T7L66XB
 config MFD_TC6387XB
 	bool "Support Toshiba TC6387XB"
 	depends on ARM && HAVE_CLK
-	select MFD_CORE
 	select MFD_TMIO
 	help
 	  Support for Toshiba Mobile IO Controller TC6387XB
@@ -327,7 +305,6 @@ config MFD_TC6387XB
 config MFD_TC6393XB
 	bool "Support Toshiba TC6393XB"
 	depends on GPIOLIB && ARM
-	select MFD_CORE
 	select MFD_TMIO
 	help
 	  Support for Toshiba Mobile IO Controller TC6393XB
@@ -356,7 +333,6 @@ config PMIC_ADP5520
 config MFD_MAX8925
 	bool "Maxim Semiconductor MAX8925 PMIC Support"
 	depends on I2C=y && GENERIC_HARDIRQS
-	select MFD_CORE
 	help
 	  Say yes here to support for Maxim Semiconductor MAX8925. This is
 	  a Power Management IC. This driver provies common support for
@@ -366,7 +342,6 @@ config MFD_MAX8925
 config MFD_MAX8997
 	bool "Maxim Semiconductor MAX8997/8966 PMIC Support"
 	depends on I2C=y && GENERIC_HARDIRQS
-	select MFD_CORE
 	help
 	  Say yes here to support for Maxim Semiconductor MAX8998/8966.
 	  This is a Power Management IC with RTC, Flash, Fuel Gauge, Haptic,
@@ -378,7 +353,6 @@ config MFD_MAX8997
 config MFD_MAX8998
 	bool "Maxim Semiconductor MAX8998/National LP3974 PMIC Support"
 	depends on I2C=y && GENERIC_HARDIRQS
-	select MFD_CORE
 	help
 	  Say yes here to support for Maxim Semiconductor MAX8998 and
 	  National Semiconductor LP3974. This is a Power Management IC.
@@ -388,7 +362,6 @@ config MFD_MAX8998
 
 config MFD_WM8400
 	tristate "Support Wolfson Microelectronics WM8400"
-	select MFD_CORE
 	depends on I2C
 	help
 	  Support for the Wolfson Microelecronics WM8400 PMIC and audio
@@ -402,7 +375,6 @@ config MFD_WM831X
 
 config MFD_WM831X_I2C
 	bool "Support Wolfson Microelectronics WM831x/2x PMICs with I2C"
-	select MFD_CORE
 	select MFD_WM831X
 	depends on I2C=y && GENERIC_HARDIRQS
 	help
@@ -413,7 +385,6 @@ config MFD_WM831X_I2C
 
 config MFD_WM831X_SPI
 	bool "Support Wolfson Microelectronics WM831x/2x PMICs with SPI"
-	select MFD_CORE
 	select MFD_WM831X
 	depends on SPI_MASTER && GENERIC_HARDIRQS
 	help
@@ -487,7 +458,6 @@ config MFD_WM8350_I2C
 
 config MFD_WM8994
 	bool "Support Wolfson Microelectronics WM8994"
-	select MFD_CORE
 	depends on I2C=y && GENERIC_HARDIRQS
 	help
 	  The WM8994 is a highly integrated hi-fi CODEC designed for
@@ -526,7 +496,6 @@ config MFD_MC13783
 config MFD_MC13XXX
 	tristate "Support Freescale MC13783 and MC13892"
 	depends on SPI_MASTER
-	select MFD_CORE
 	select MFD_MC13783
 	help
 	  Support for the Freescale (Atlas) PMIC and audio CODECs
@@ -548,7 +517,6 @@ config ABX500_CORE
 config AB3100_CORE
 	bool "ST-Ericsson AB3100 Mixed Signal Circuit core functions"
 	depends on I2C=y && ABX500_CORE
-	select MFD_CORE
 	default y if ARCH_U300
 	help
 	  Select this to enable the AB3100 Mixed Signal IC core
@@ -579,7 +547,6 @@ config EZX_PCAP
 config AB8500_CORE
 	bool "ST-Ericsson AB8500 Mixed Signal Power Management chip"
 	depends on GENERIC_HARDIRQS && ABX500_CORE
-	select MFD_CORE
 	help
 	  Select this option to enable access to AB8500 power management
 	  chip. This connects to U8500 either on the SSP/SPI bus (deprecated
@@ -614,7 +581,6 @@ config AB8500_GPADC
 
 config AB3550_CORE
         bool "ST-Ericsson AB3550 Mixed Signal Circuit core functions"
-	select MFD_CORE
 	depends on I2C=y && GENERIC_HARDIRQS && ABX500_CORE
 	help
 	  Select this to enable the AB3550 Mixed Signal IC core
@@ -629,7 +595,6 @@ config AB3550_CORE
 config MFD_DB8500_PRCMU
 	bool "ST-Ericsson DB8500 Power Reset Control Management Unit"
 	depends on UX500_SOC_DB8500
-	select MFD_CORE
 	help
 	  Select this option to enable support for the DB8500 Power Reset
 	  and Control Management Unit. This is basically an autonomous
@@ -639,7 +604,6 @@ config MFD_DB8500_PRCMU
 config MFD_DB5500_PRCMU
 	bool "ST-Ericsson DB5500 Power Reset Control Management Unit"
 	depends on UX500_SOC_DB5500
-	select MFD_CORE
 	help
 	  Select this option to enable support for the DB5500 Power Reset
 	  and Control Management Unit. This is basically an autonomous
@@ -648,7 +612,6 @@ config MFD_DB5500_PRCMU
 
 config MFD_CS5535
 	tristate "Support for CS5535 and CS5536 southbridge core functions"
-	select MFD_CORE
 	depends on PCI && X86
 	---help---
 	  This is the core driver for CS5535/CS5536 MFD functions.  This is
@@ -656,7 +619,6 @@ config MFD_CS5535
 
 config MFD_TIMBERDALE
 	tristate "Support for the Timberdale FPGA"
-	select MFD_CORE
 	depends on PCI && GPIOLIB
 	---help---
 	This is the core driver for the timberdale FPGA. This device is a
@@ -668,14 +630,12 @@ config MFD_TIMBERDALE
 config LPC_SCH
 	tristate "Intel SCH LPC"
 	depends on PCI
-	select MFD_CORE
 	help
 	  LPC bridge function of the Intel SCH provides support for
 	  System Management Bus and General Purpose I/O.
 
 config MFD_RDC321X
 	tristate "Support for RDC-R321x southbridge"
-	select MFD_CORE
 	depends on PCI
 	help
 	  Say yes here if you want to have support for the RDC R-321x SoC
@@ -684,7 +644,6 @@ config MFD_RDC321X
 
 config MFD_JANZ_CMODIO
 	tristate "Support for Janz CMOD-IO PCI MODULbus Carrier Board"
-	select MFD_CORE
 	depends on PCI
 	help
 	  This is the core driver for the Janz CMOD-IO PCI MODULbus
@@ -694,7 +653,6 @@ config MFD_JANZ_CMODIO
 
 config MFD_JZ4740_ADC
 	bool "Support for the JZ4740 SoC ADC core"
-	select MFD_CORE
 	select GENERIC_IRQ_CHIP
 	depends on MACH_JZ4740
 	help
@@ -704,7 +662,6 @@ config MFD_JZ4740_ADC
 config MFD_VX855
 	tristate "Support for VIA VX855/VX875 integrated south bridge"
 	depends on PCI
-	select MFD_CORE
 	help
 	  Say yes here to enable support for various functions of the
 	  VIA VX855/VX875 south bridge. You will need to enable the vx855_spi
@@ -713,7 +670,6 @@ config MFD_VX855
 config MFD_WL1273_CORE
 	tristate "Support for TI WL1273 FM radio."
 	depends on I2C
-	select MFD_CORE
 	default n
 	help
 	  This is the core driver for the TI WL1273 FM radio. This MFD
@@ -735,7 +691,6 @@ config MFD_PM8XXX
 config MFD_PM8921_CORE
 	tristate "Qualcomm PM8921 PMIC chip"
 	depends on MSM_SSBI
-	select MFD_CORE
 	select MFD_PM8XXX
 	help
 	  If you say yes to this option, support will be included for the
@@ -762,7 +717,6 @@ config TPS65911_COMPARATOR
 
 config MFD_AAT2870_CORE
 	bool "Support for the AnalogicTech AAT2870"
-	select MFD_CORE
 	depends on I2C=y && GPIOLIB
 	help
 	  If you say yes here you get support for the AAT2870.
@@ -770,7 +724,7 @@ config MFD_AAT2870_CORE
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
 
-endif # MFD_SUPPORT
+endif # MFD_CORE
 
 menu "Multimedia Capabilities Port drivers"
 	depends on ARCH_SA1100
-- 
1.7.1

