Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0LJRCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:02:48 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42970 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab0LJRCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:02:46 -0500
Date: Sat, 11 Dec 2010 02:01:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Peter Huewe <peterhuewe@gmx.de>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd/wm831x-irq: Convert to new irq_chip functions and fix build failure
Message-ID: <20101210170131.GC21712@linux-sh.org>
References: <1291937687-20243-1-git-send-email-peterhuewe@gmx.de> <12ABA93B-6923-4AF7-BF34-E070BE72A8E2@opensource.wolfsonmicro.com> <alpine.LFD.2.00.1012100233510.2653@localhost6.localdomain6> <20101210050755.GA21712@linux-sh.org> <20101210121420.GC3200@rakim.wolfsonmicro.main> <20101210154332.GB21712@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210154332.GB21712@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 12:43:32AM +0900, Paul Mundt wrote:
> On Fri, Dec 10, 2010 at 12:14:21PM +0000, Mark Brown wrote:
> > It's not just this driver - I'd expect everything with an interrupt
> > controller in drivers/mfd to have an issue here, and I don't think
> > disabling them all on SH for this release is such a good approach.
> > 
> Again, none of this has anything to do with SH, so pretending like it an
> SH "issue" is disingenuous at best. All of the offending drivers already
> have a GENERIC_HARDIRQS dependency, adding a dependency that also depends
> on the deprecated support for each of these doesn't exactly strike me as
> being an undue burden. It is after all your driver and not my
> architecture that depends on deprecated support.
> 
So, I decided to gather some statistics..

Out of the current MFD drivers, the current users with dependency on
deprecated APIs and broken GENERIC_HARDIRQS dependencies are:

88pm860x-core.c
ab3550-core.c
ab8500-core.c
asic3.c
ezx-pcap.c
htc-egpio.c
htc-i2cpld.c
jz4740-adc.c
max8925-core.c
max8998-irq.c
stmpe.c
t7l66xb.c
tc35892.c
tc6393xb.c
tps6586x.c
twl4030-irq.c
twl6030-irq.c
wm831x-irq.c
wm8350-irq.c
wm8994-irq.c

Out of these, they fall in to two categories..

With no special platform dependencies, which are already broken for
platforms without GENERIC_HARDIRQS:

	htc-i2cpld.c

With platform dependencies that implicitly provide GENERIC_HARDIRQS:

	jz4740-adc.c, t7l66xb.c, and tc6393xb.c

That's a reasonable chunk of the MFD drivers that have the deprecated
dependency, but there are many that this isn't a problem for already, too.
(including all of the ones we use on SH). The rest are easily converted
over for .38.

The above 4 at least should have their dependencies tidied up. The rest
of them will break on an allmod/yesconfig for SH for .37, which the
following patch addresses. On the other hand, none of these are really
all that pressing, particularly as none of these are used by any of the
SH defconfigs.

I had considered adding a GENERIC_HARDIRQS_DEPRECATED, but that
unfortunately gets to be a bit tricky since almost no one sources
kernel/irq/Kconfig yet, and this isn't likely to be a problem for very
long anyways -- it's basically just the MFD drivers that play around with
the irq_chip anyways.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 drivers/mfd/Kconfig |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3a1493b..2d783a3 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -27,6 +27,7 @@ config MFD_CORE
 config MFD_88PM860X
 	bool "Support Marvell 88PM8606/88PM8607"
 	depends on I2C=y && GENERIC_HARDIRQS
+	depends on !GENERIC_HARDIRQS_NO_DEPRECATED
 	select MFD_CORE
 	help
 	  This supports for Marvell 88PM8606/88PM8607 Power Management IC.
@@ -55,6 +56,7 @@ config MFD_SM501_GPIO
 config MFD_ASIC3
 	bool "Support for Compaq ASIC3"
 	depends on GENERIC_HARDIRQS && GPIOLIB && ARM
+	depends on !GENERIC_HARDIRQS_NO_DEPRECATED
 	select MFD_CORE
 	 ---help---
 	  This driver supports the ASIC3 multifunction chip found on many
@@ -84,6 +86,7 @@ config MFD_DM355EVM_MSP
 config HTC_EGPIO
 	bool "HTC EGPIO support"
 	depends on GENERIC_HARDIRQS && GPIOLIB && ARM
+	depends on !GENERIC_HARDIRQS_NO_DEPRECATED
 	help
 	    This driver supports the CPLD egpio chip present on
 	    several HTC phones.  It provides basic support for input
@@ -101,6 +104,8 @@ config HTC_PASIC3
 config HTC_I2CPLD
 	bool "HTC I2C PLD chip support"
 	depends on I2C=y && GPIOLIB
+	depends on GENERIC_HARDIRQS
+	depends on !GENERIC_HARDIRQS_NO_DEPRECATED
 	help
 	  If you say yes here you get support for the supposed CPLD
 	  found on omap850 HTC devices like the HTC Wizard and HTC Herald.
@@ -156,6 +161,7 @@ config MENELAUS
 config TWL4030_CORE
 	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
 	depends on I2C=y && GENERIC_HARDIRQS
+	depends on !GENERIC_HARDIRQS_NO_DEPRECATED
 	help
 	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.
 	  This core driver provides register access and IRQ handling
@@ -198,6 +204,7 @@ config TWL6030_PWM
 config MFD_STMPE
 	bool "Support STMicroelectronics STMPE"
 	depends on I2C=y && GENERIC_HARDIRQS
+	depends on !GENERIC_HARDIRQS_NO_DEPRECATED
 	select MFD_CORE
 	help
 	  Support for the STMPE family of I/O Expanders from
@@ -221,6 +228,7 @@ config MFD_STMPE
 config MFD_TC35892
 	bool "Support Toshiba TC35892"
 	depends on I2C=y && GENERIC_HARDIRQS
+	depends on !GENERIC_HARDIRQS_NO_DEPRECATED
 	select MFD_CORE
 	help
 	  Support for the Toshiba TC35892 I/O Expander.
@@ -286,6 +294,7 @@ config PMIC_ADP5520
 config MFD_MAX8925
 	bool "Maxim Semiconductor MAX8925 PMIC Support"
 	depends on I2C=y && GENERIC_HARDIRQS
+	depends on !GENERIC_HARDIRQS_NO_DEPRECATED
 	select MFD_CORE
 	help
 	  Say yes here to support for Maxim Semiconductor MAX8925. This is
@@ -296,6 +305,7 @@ config MFD_MAX8925
 config MFD_MAX8998
 	bool "Maxim Semiconductor MAX8998/National LP3974 PMIC Support"
 	depends on I2C=y && GENERIC_HARDIRQS
+	depends on !GENERIC_HARDIRQS_NO_DEPRECATED
 	select MFD_CORE
 	help
 	  Say yes here to support for Maxim Semiconductor MAX8998 and
@@ -316,13 +326,13 @@ config MFD_WM8400
 
 config MFD_WM831X
 	bool
-	depends on GENERIC_HARDIRQS
+	depends on GENERIC_HARDIRQS && !GENERIC_HARDIRQS_NO_DEPRECATED
 
 config MFD_WM831X_I2C
 	bool "Support Wolfson Microelectronics WM831x/2x PMICs with I2C"
 	select MFD_CORE
 	select MFD_WM831X
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y && GENERIC_HARDIRQS && !GENERIC_HARDIRQS_NO_DEPRECATED
 	help
 	  Support for the Wolfson Microelecronics WM831x and WM832x PMICs
 	  when controlled using I2C.  This driver provides common support
@@ -334,6 +344,7 @@ config MFD_WM831X_SPI
 	select MFD_CORE
 	select MFD_WM831X
 	depends on SPI_MASTER && GENERIC_HARDIRQS
+	depends on !GENERIC_HARDIRQS_NO_DEPRECATED
 	help
 	  Support for the Wolfson Microelecronics WM831x and WM832x PMICs
 	  when controlled using SPI.  This driver provides common support
@@ -342,7 +353,7 @@ config MFD_WM831X_SPI
 
 config MFD_WM8350
 	bool
-	depends on GENERIC_HARDIRQS
+	depends on GENERIC_HARDIRQS && !GENERIC_HARDIRQS_NO_DEPRECATED
 
 config MFD_WM8350_CONFIG_MODE_0
 	bool
@@ -396,6 +407,7 @@ config MFD_WM8350_I2C
 	bool "Support Wolfson Microelectronics WM8350 with I2C"
 	select MFD_WM8350
 	depends on I2C=y && GENERIC_HARDIRQS
+	depends on !GENERIC_HARDIRQS_NO_DEPRECATED
 	help
 	  The WM8350 is an integrated audio and power management
 	  subsystem with watchdog and RTC functionality for embedded
@@ -407,6 +419,7 @@ config MFD_WM8994
 	bool "Support Wolfson Microelectronics WM8994"
 	select MFD_CORE
 	depends on I2C=y && GENERIC_HARDIRQS
+	depends on !GENERIC_HARDIRQS_NO_DEPRECATED
 	help
 	  The WM8994 is a highly integrated hi-fi CODEC designed for
 	  smartphone applicatiosn.  As well as audio functionality it
@@ -490,6 +503,7 @@ config AB3100_OTP
 config EZX_PCAP
 	bool "PCAP Support"
 	depends on GENERIC_HARDIRQS && SPI_MASTER
+	depends on !GENERIC_HARDIRQS_NO_DEPRECATED
 	help
 	  This enables the PCAP ASIC present on EZX Phones. This is
 	  needed for MMC, TouchScreen, Sound, USB, etc..
@@ -527,6 +541,7 @@ config AB3550_CORE
         bool "ST-Ericsson AB3550 Mixed Signal Circuit core functions"
 	select MFD_CORE
 	depends on I2C=y && GENERIC_HARDIRQS && ABX500_CORE
+	depends on !GENERIC_HARDIRQS_NO_DEPRECATED
 	help
 	  Select this to enable the AB3550 Mixed Signal IC core
 	  functionality. This connects to a AB3550 on the I2C bus
@@ -586,6 +601,7 @@ config MFD_JZ4740_ADC
 config MFD_TPS6586X
 	bool "TPS6586x Power Management chips"
 	depends on I2C=y && GPIOLIB && GENERIC_HARDIRQS
+	depends on !GENERIC_HARDIRQS_NO_DEPRECATED
 	select MFD_CORE
 	help
 	  If you say yes here you get support for the TPS6586X series of
