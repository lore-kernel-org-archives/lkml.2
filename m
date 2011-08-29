Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab1H2R1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:27:43 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:60273 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754397Ab1H2R1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:27:41 -0400
Date: Mon, 29 Aug 2011 10:27:32 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Luciano Coelho <coelho@ti.com>
Cc: matti.j.aaltonen@nokia.com, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: Kconfig unmet dependency with RADIO_WL1273
Message-Id: <20110829102732.03f0f05d.rdunlap@xenotime.net>
In-Reply-To: <1314637358.2296.395.camel@cumari>
References: <1314637358.2296.395.camel@cumari>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011 20:02:38 +0300 Luciano Coelho wrote:

> Hi Matti,
> 
> Johannes has just reported a problem in the Kconfig of radio-wl1273.  It
> seems to select MFD_CORE, but if the platform doesn't support MFD, then
> MFD_SUPPORT won't be selected and this kind of warning will come out:
> 
> warning: (OLPC_XO1_PM && OLPC_XO1_SCI && I2C_ISCH && GPIO_SCH && GPIO_RDC321X && RADIO_WL1273) 
>                 selects MFD_CORE which has unmet direct dependencies (MFD_SUPPORT)
> 
> I guess it must depend on MFD_SUPPORT, right? If that's the correct
> solution, the following patch should fix the problem:
> 
> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> index 52798a1..e87f544 100644
> --- a/drivers/media/radio/Kconfig
> +++ b/drivers/media/radio/Kconfig
> @@ -425,7 +425,7 @@ config RADIO_TIMBERDALE
>  
>  config RADIO_WL1273
>         tristate "Texas Instruments WL1273 I2C FM Radio"
> -       depends on I2C && VIDEO_V4L2
> +       depends on I2C && VIDEO_V4L2 && MFD_SUPPORT
>         select MFD_CORE
>         select MFD_WL1273_CORE
>         select FW_LOADER
> 
> The same problem is happening with other drivers too, so maybe there is
> a better solution to fix all problems at once. ;)
> 
> Reported-by: Johannes Berg <johannes@sipsolutions.net>

Yes, it can depend on MFD_SUPPORT or it can select both
MFD_SUPPORT and MFD_CORE or we could do what Jean Delvare
suggested last December and combine the MFD_SUPPORT and MFD_CORE
symbols, like I2c does.  I did a patch for that but never
posted it.  It's below, but probably needs a good bit of
updating since this patch was made in January.

---
From: Randy Dunlap <rdunlap@xenotime.net>

Combine MFD_SUPPORT (which only enabled the remainder of the MFD
menu) and MFD_CORE.  This allows other drivers to select MFD_CORE
without needing to also select MFD_SUPPORT, which fixes some
kconfig unmet dependency warnings.  Modeled after I2C kconfig.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/mfd/Kconfig |   42 ++++--------------------------------------
 1 file changed, 4 insertions(+), 38 deletions(-)

--- lnx-2637-rc5.orig/drivers/mfd/Kconfig
+++ lnx-2637-rc5/drivers/mfd/Kconfig
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
@@ -55,7 +49,6 @@ config MFD_SM501_GPIO
 config MFD_ASIC3
 	bool "Support for Compaq ASIC3"
 	depends on GENERIC_HARDIRQS && GPIOLIB && ARM
-	select MFD_CORE
 	 ---help---
 	  This driver supports the ASIC3 multifunction chip found on many
 	  PDAs (mainly iPAQ and HTC based ones)
@@ -63,7 +56,6 @@ config MFD_ASIC3
 config MFD_SH_MOBILE_SDHI
 	bool "Support for SuperH Mobile SDHI"
 	depends on SUPERH || ARCH_SHMOBILE
-	select MFD_CORE
 	select TMIO_MMC_DMA
 	 ---help---
 	  This driver supports the SDHI hardware block found in many
@@ -71,7 +63,6 @@ config MFD_SH_MOBILE_SDHI
 
 config MFD_DAVINCI_VOICECODEC
 	tristate
-	select MFD_CORE
 
 config MFD_DM355EVM_MSP
 	bool "DaVinci DM355 EVM microcontroller"
@@ -91,7 +82,6 @@ config HTC_EGPIO
 
 config HTC_PASIC3
 	tristate "HTC PASIC3 LED/DS1WM chip support"
-	select MFD_CORE
 	help
 	  This core driver provides register access for the LED/DS1WM
 	  chips labeled "AIC2" and "AIC3", found on HTC Blueangel and
@@ -133,7 +123,6 @@ config TPS65010
 
 config TPS6507X
 	tristate "TPS6507x Power Management / Touch Screen chips"
-	select MFD_CORE
 	depends on I2C
 	help
 	  If you say yes here you get support for the TPS6507x series of
@@ -183,7 +172,6 @@ config TWL4030_POWER
 config TWL4030_CODEC
 	bool
 	depends on TWL4030_CORE
-	select MFD_CORE
 	default n
 
 config TWL6030_PWM
@@ -198,7 +186,6 @@ config TWL6030_PWM
 config MFD_STMPE
 	bool "Support STMicroelectronics STMPE"
 	depends on I2C=y && GENERIC_HARDIRQS
-	select MFD_CORE
 	help
 	  Support for the STMPE family of I/O Expanders from
 	  STMicroelectronics.
@@ -221,7 +208,6 @@ config MFD_STMPE
 config MFD_TC35892
 	bool "Support Toshiba TC35892"
 	depends on I2C=y && GENERIC_HARDIRQS
-	select MFD_CORE
 	help
 	  Support for the Toshiba TC35892 I/O Expander.
 
@@ -241,7 +227,6 @@ config TMIO_MMC_DMA
 config MFD_T7L66XB
 	bool "Support Toshiba T7L66XB"
 	depends on ARM && HAVE_CLK
-	select MFD_CORE
 	select MFD_TMIO
 	help
 	  Support for Toshiba Mobile IO Controller T7L66XB
@@ -249,7 +234,6 @@ config MFD_T7L66XB
 config MFD_TC6387XB
 	bool "Support Toshiba TC6387XB"
 	depends on ARM && HAVE_CLK
-	select MFD_CORE
 	select MFD_TMIO
 	help
 	  Support for Toshiba Mobile IO Controller TC6387XB
@@ -257,7 +241,6 @@ config MFD_TC6387XB
 config MFD_TC6393XB
 	bool "Support Toshiba TC6393XB"
 	depends on GPIOLIB && ARM
-	select MFD_CORE
 	select MFD_TMIO
 	help
 	  Support for Toshiba Mobile IO Controller TC6393XB
@@ -286,7 +269,6 @@ config PMIC_ADP5520
 config MFD_MAX8925
 	bool "Maxim Semiconductor MAX8925 PMIC Support"
 	depends on I2C=y && GENERIC_HARDIRQS
-	select MFD_CORE
 	help
 	  Say yes here to support for Maxim Semiconductor MAX8925. This is
 	  a Power Management IC. This driver provies common support for
@@ -296,7 +278,6 @@ config MFD_MAX8925
 config MFD_MAX8998
 	bool "Maxim Semiconductor MAX8998/National LP3974 PMIC Support"
 	depends on I2C=y && GENERIC_HARDIRQS
-	select MFD_CORE
 	help
 	  Say yes here to support for Maxim Semiconductor MAX8998 and
 	  National Semiconductor LP3974. This is a Power Management IC.
@@ -306,7 +287,6 @@ config MFD_MAX8998
 
 config MFD_WM8400
 	tristate "Support Wolfson Microelectronics WM8400"
-	select MFD_CORE
 	depends on I2C
 	help
 	  Support for the Wolfson Microelecronics WM8400 PMIC and audio
@@ -320,7 +300,6 @@ config MFD_WM831X
 
 config MFD_WM831X_I2C
 	bool "Support Wolfson Microelectronics WM831x/2x PMICs with I2C"
-	select MFD_CORE
 	select MFD_WM831X
 	depends on I2C=y && GENERIC_HARDIRQS
 	help
@@ -331,7 +310,6 @@ config MFD_WM831X_I2C
 
 config MFD_WM831X_SPI
 	bool "Support Wolfson Microelectronics WM831x/2x PMICs with SPI"
-	select MFD_CORE
 	select MFD_WM831X
 	depends on SPI_MASTER && GENERIC_HARDIRQS
 	help
@@ -405,7 +383,6 @@ config MFD_WM8350_I2C
 
 config MFD_WM8994
 	bool "Support Wolfson Microelectronics WM8994"
-	select MFD_CORE
 	depends on I2C=y && GENERIC_HARDIRQS
 	help
 	  The WM8994 is a highly integrated hi-fi CODEC designed for
@@ -430,7 +407,6 @@ config MFD_MC13783
 config MFD_MC13XXX
 	tristate "Support Freescale MC13783 and MC13892"
 	depends on SPI_MASTER
-	select MFD_CORE
 	select MFD_MC13783
 	help
 	  Support for the Freescale (Atlas) PMIC and audio CODECs
@@ -466,7 +442,6 @@ config ABX500_CORE
 config AB3100_CORE
 	bool "ST-Ericsson AB3100 Mixed Signal Circuit core functions"
 	depends on I2C=y && ABX500_CORE
-	select MFD_CORE
 	default y if ARCH_U300
 	help
 	  Select this to enable the AB3100 Mixed Signal IC core
@@ -497,7 +472,6 @@ config EZX_PCAP
 config AB8500_CORE
 	bool "ST-Ericsson AB8500 Mixed Signal Power Management chip"
 	depends on GENERIC_HARDIRQS && ABX500_CORE && SPI_MASTER && ARCH_U8500
-	select MFD_CORE
 	help
 	  Select this option to enable access to AB8500 power management
 	  chip. This connects to U8500 either on the SSP/SPI bus
@@ -525,7 +499,6 @@ config AB8500_DEBUG
 
 config AB3550_CORE
         bool "ST-Ericsson AB3550 Mixed Signal Circuit core functions"
-	select MFD_CORE
 	depends on I2C=y && GENERIC_HARDIRQS && ABX500_CORE
 	help
 	  Select this to enable the AB3550 Mixed Signal IC core
@@ -539,7 +512,6 @@ config AB3550_CORE
 
 config MFD_TIMBERDALE
 	tristate "Support for the Timberdale FPGA"
-	select MFD_CORE
 	depends on PCI && GPIOLIB
 	---help---
 	This is the core driver for the timberdale FPGA. This device is a
@@ -551,14 +523,12 @@ config MFD_TIMBERDALE
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
@@ -567,7 +537,6 @@ config MFD_RDC321X
 
 config MFD_JANZ_CMODIO
 	tristate "Support for Janz CMOD-IO PCI MODULbus Carrier Board"
-	select MFD_CORE
 	depends on PCI
 	help
 	  This is the core driver for the Janz CMOD-IO PCI MODULbus
@@ -577,7 +546,6 @@ config MFD_JANZ_CMODIO
 
 config MFD_JZ4740_ADC
 	tristate "Support for the JZ4740 SoC ADC core"
-	select MFD_CORE
 	depends on MACH_JZ4740
 	help
 	  Say yes here if you want support for the ADC unit in the JZ4740 SoC.
@@ -586,7 +554,6 @@ config MFD_JZ4740_ADC
 config MFD_TPS6586X
 	bool "TPS6586x Power Management chips"
 	depends on I2C=y && GPIOLIB && GENERIC_HARDIRQS
-	select MFD_CORE
 	help
 	  If you say yes here you get support for the TPS6586X series of
 	  Power Management chips.
@@ -600,13 +567,12 @@ config MFD_TPS6586X
 config MFD_VX855
 	tristate "Support for VIA VX855/VX875 integrated south bridge"
 	depends on PCI
-	select MFD_CORE
 	help
 	  Say yes here to enable support for various functions of the
 	  VIA VX855/VX875 south bridge. You will need to enable the vx855_spi
 	  and/or vx855_gpio drivers for this to do anything useful.
 
-endif # MFD_SUPPORT
+endif # MFD_CORE
 
 menu "Multimedia Capabilities Port drivers"
 	depends on ARCH_SA1100
