Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab2HWLfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 07:35:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56256 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab2HWLf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 07:35:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] [RFC] ARM: treewide: manually change more mach-*/*.h includes
Date: Thu, 23 Aug 2012 11:35:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org
References: <201208221253.07278.arnd@arndb.de> <201208221301.19439.arnd@arndb.de> <20120822214323.GA12255@n2100.arm.linux.org.uk>
In-Reply-To: <20120822214323.GA12255@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208231135.11688.arnd@arndb.de>
X-Provags-ID: V02:K0:Dk01C/EDXMccnxjchAP7wD+GzzFPA83Nzd+IkF//oxx
 yw6ooyKQUBSVIB5K0d13JVsvPed5hNj6MKeG6Ila73p3PyYRCQ
 H1zDMaAZexdy5nFMz5HxCqyAWt/YbdRLOc0WFRG/86s0+RgU39
 j0tnKnidjfp6uc1MuCeWPWxzUenBAinif0FWbmYv/KzsB28lgc
 ibq9h5y4OfRu5sRklC8Bnsl8Tspl0+yhmCJAPzHnibq85bwAGS
 ob5MRpi4wX/Sh7WWolfuL2GU2sx7mJjb9/R+vQIsUZgi7bu3BD
 T/pbv0uU84zZxk1SnGvPai+g+2OKA6V0qtyZe5b+eR7suVQSat
 lywoIWJk/VomoHqJqvXA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 August 2012, Russell King - ARM Linux wrote:
> 
> On Wed, Aug 22, 2012 at 01:01:19PM +0000, Arnd Bergmann wrote:
> > These are lots of device drivers that include machine
> > specific header files from ARM platforms and that are
> > not easily scriptable. The changes have been found through
> > manual inspection and should cause no visible changes
> > because of the build script that maps the old names to the
> > new ones.
> 
> And you end up missing a bunch of drivers in the process, such as the
> sa1100 RTC driver which is shared between sa11x0 and PXA.  I wonder
> how many of the Samsung platforms get broken by this as well...

I'm well aware of the files that are not converted in this series,
but I'm also reasonably sure that I'm not breaking them in the process,
as long as we don't revert the first patch before the conversion is
done. I have added a list of the remaining ones at the end of this
email for reference. Most of them are for the Samsung platforms, and
they are already working on cleaning that up.

> In any case, what we should be doing here as well is moving the headers
> included by drivers for platform data out of the arch/arm/mach/ subtrees
> and into include/linux/platform_data.  That will substantially reduce the
> amount of mach/ headers to deal with.

I've just looked at the {mach,plat}/*.h files that get included in ARM
specific drivers. Out of the 342 header files that get used in this way,
I found 93 that are practically just platform data, and a few that
are platform_data mixed with something else.

How about I move all the pure platform data definition files now and
rebase the other patches on top of that. Here is a list of suggested
file names in include/linux/platform_data/:

mach-at91/at_hdmac.h		-> dma-atmel.h
mach-davinci/aemif.h		-> mtd-davinci-aemif.h
mach-davinci/asp.h		-> asoc-davinci-evm.h
mach-davinci/i2c.h		-> i2c-davinci.h
mach-davinci/keyscan.h		-> keyscan-davinci.h
mach-davinci/mmc.h		-> mmc-davinci.h
mach-davinci/nand.h		-> mtd-davinci.h
mach-davinci/spi.h		-> spi-davinci.h
mach-davinci/usb.h		-> usb-davinci.h
mach-ep93xx/dma.h		-> dma-ep93xx.h
mach-ep93xx/ep93xx_keypad.h	-> keypad-ep93xx.h
mach-ep93xx/ep93xx_spi.h	-> spi-ep93xx.h
mach-ep93xx/fb.h		-> video-ep93xx.h
mach-exynos/ohci.h		-> usb-exynos.h
mach-imx/dma.h			-> dma-imx.h
mach-imx/esdhc.h		-> mmc-esdhc-imx.h
mach-imx/i2c.h			-> i2c-imx.h
mach-imx/imx-uart.h		-> serial-imx.h
mach-imx/imxfb.h		-> video-imxfb.h
mach-imx/mmc.h			-> mmc-mxcmmc.h
mach-imx/mx1_camera.h		-> camera-mx1.h
mach-imx/mx21-usbhost.h		-> usb-mx2.h
mach-imx/mx2_cam.h		-> camera-mx2.h
mach-imx/mx3_camera.h		-> camera-mx3.h
mach-imx/mx3fb.h		-> video-mx3fb.h
mach-imx/mxc_ehci.h		-> usb-ehci-mxc.h
mach-imx/mxc_nand.h		-> mtd-mxc_nand.h
mach-imx/sdma.h			-> dma-imx-sdma.h
mach-imx/spi.h			-> spi-imx.h
mach-imx/ssi.h			-> asoc-imx-ssi.h
mach-imx/usb.h			-> usb-imx_udc.h
mach-kirkwood/leds-netxbig.h	-> leds-kirkwood-netxbig.h
mach-kirkwood/leds-ns2.h	-> leds-kirkwood-ns2.h
mach-mmp/sram.h			-> dma-mmp_tdma.h
mach-msm/mmc.h			-> mmc-msm_sdcc.h
mach-msm/msm_fb.h		-> video-msm_fb.h
mach-netx/eth.h			-> eth-netx.h
mach-nomadik/nand.h		-> mtd-nomadik-nand.h
mach-pxa/arcom-pcmcia.h		-> pcmcia-pxa2xx_viper.h
mach-pxa/camera.h		-> camera-pxa.h
mach-pxa/irda.h			-> irda-pxaficp.h
mach-pxa/mmc.h			-> mmc-pxamci.h
mach-pxa/ohci.h			-> usb-ohci-pxa27x.h
mach-pxa/palmasoc.h		-> asoc-palm27x.h
mach-pxa/pata_pxa.h		-> ata-pxa.h
mach-pxa/pxa3xx-u2d.h		-> usb-ohci-pxa27x.h
mach-pxa/pxa930_rotary.h	-> keyboard-pxa930_rotary.h
mach-pxa/pxa930_trkball.h	-> mouse-pxa930_trkball.h
mach-pxa/pxafb.h		-> video-pxafb.h
mach-s3c24xx/leds-gpio.h	-> leds-s3c24xx.h
mach-sa1100/mcp.h		-> mfd-mcp-sa11x0.h
mach-tegra/kbc.h		-> keyboard-tegra-kbc.h
mach-tegra/sdhci.h		-> mmc-sdhci-tegra.h
mach-tegra/tegra_wm8903_pdata.h	-> asoc-tegra_wm8903.h
mach-u300/gpio-u300.h		-> pinctrl-coh901.h
mach-ux500/crypto-ux500.h	-> crypto-ux500.h
mach-ux500/usb.h		-> usb-musb-ux500.h
mach-ux500/msp.h		-> asoc-ux500-msp.h
mach-vt8500/vt8500fb.h		-> video-vt8500lcdfb.h
mach-w90x900/fb.h		-> video-nuc900fb.h
mach-w90x900/i2c.h		-> i2c-nuc900.h
mach-w90x900/nuc900_spi.h	-> spi-nuc900.h
mach-w90x900/w90p910_keypad.h	-> keypad-w90p910.h
plat-nomadik/ske.h		-> keypad-nomadik-ske.h
plat-omap/dsp.h			-> dsp-omap.h
plat-omap/keypad.h		-> keypad-omap.h
plat-omap/lcd_mipid.h		-> lcd-mipid.h
plat-omap/mcbsp.h		-> dsp-mcbsp.h
plat-omap/mcspi.h		-> spi-omap2-mcspi.h
plat-omap/nand.h		-> mtd-nand-omap2.h
plat-omap/onenand.h		-> mtd-onenand-omap2.h
plat-omap/remoteproc.h		-> remoteproc-omap.h
plat-omap/voltage.h		-> smartreflex-omap.h
plat-orion/audio.h		-> asoc-kirkwood.h
plat-orion/ehci-orion.h		-> usb-ehci-orion.h
plat-orion/mv_xor.h		-> dma-mv_xor.h
plat-orion/mvsdio.h		-> mmc-mvsdio.h
plat-orion/orion_nand.h		-> mtd-orion_nand.h
plat-pxa/pxa27x_keypad.h	-> keypad-pxa27x.h
plat-pxa/pxa3xx_nand.h		-> mtd-nand-pxa3xx.h
plat-samsung/ata.h		-> ata-samsung_cf.h
plat-samsung/audio-simtec.h	-> asoc-s3c24xx_simtec.h
plat-samsung/audio.h		-> asoc-s3c.h
plat-samsung/ehci.h		-> usb-ehci-s5p.h
plat-samsung/hwmon.h		-> hwmon-s3c.h
plat-samsung/iic.h		-> i2c-s3c2410.h
plat-samsung/mci.h		-> mmc-s3cmci.h
plat-samsung/mipi_csis.h	-> mipi-csis.h
plat-samsung/nand.h		-> mtd-nand-s3c2410.h
plat-samsung/s3c64xx-spi.h	-> spi-s3c64xx.h
plat-samsung/ts.h		-> touchscreen-s3c2410.h
plat-samsung/udc.h		-> usb-s3c2410_udc.h
plat-samsung/usb-control.h	-> usb-ohci-s3c2410.h
plat-spear/keyboard.h		-> keyboard-spear.h

> Where I want this to get to is not a persistence of the existing crappy
> situation where platforms stuff platform data definitions into arch/arm,
> but instead put them in the right place.

Agreed.

> That means providing them with a good reason why the existing solution
> won't work, and not allowing mach/ includes in drivers is a very good
> way to achieve that.

About two third of the platform header files included in device drivers
are not related to platform_data according to what I found. Most of them
are also wrong (hardcoding interrupt numbers or addresses, headers
included by accident but not actually used, driver specific definitions
that don't belong in the platform, platform specific abstraction layers,
...), but they tend to be harder to clean up.

I hope we can get there eventually, but I think the intermediate step
of enforcing a mach-${MACH}/foo.h is a step in the right direction on
that way. While my immediate goal of course is to get the multiplatform
kernel running and not to clean up the mess with mach headers, I think
it's good if the dependency on a specific platform is highlighted in the
source code so it can be picked on better in reviews.

	Arnd

** list of mach/* inclusions that I could not match with
** exactly one ARM platform:

$ git grep ^#include.*\<mach/  drivers/ sound/ include/ arch/arm/
arch/arm/boot/compressed/head.S:#include <mach/debug-macro.S>
arch/arm/boot/compressed/misc.c:#include <mach/uncompress.h>
arch/arm/boot/compressed/mmcif-sh7372.c:#include <mach/mmc.h>
arch/arm/boot/compressed/sdhi-sh7372.c:#include <mach/mmc.h>
arch/arm/common/locomo.c:#include <mach/hardware.h>
arch/arm/common/sa1111.c:#include <mach/hardware.h>
arch/arm/include/asm/barrier.h:#include <mach/barriers.h>
arch/arm/include/asm/clkdev.h:#include <mach/clkdev.h>
arch/arm/include/asm/dma.h:#include <mach/isa-dma.h>
arch/arm/include/asm/floppy.h:#include <mach/floppy.h>
arch/arm/include/asm/gpio.h:#include <mach/gpio.h>
arch/arm/include/asm/hardware/dec21285.h:#include <mach/hardware.h>
arch/arm/include/asm/hardware/iop3xx-adma.h:#include <mach/hardware.h>
arch/arm/include/asm/hardware/iop3xx-gpio.h:#include <mach/hardware.h>
arch/arm/include/asm/hardware/it8152.h:#include <mach/irqs.h>
arch/arm/include/asm/hardware/sa1111.h:#include <mach/bitfield.h>
arch/arm/include/asm/io.h:#include <mach/io.h>
arch/arm/include/asm/irq.h:#include <mach/irqs.h>
arch/arm/include/asm/memory.h:#include <mach/memory.h>
arch/arm/include/asm/mtd-xip.h:#include <mach/mtd-xip.h>
arch/arm/include/asm/timex.h:#include <mach/timex.h>
arch/arm/kernel/debug.S:#include <mach/debug-macro.S>
arch/arm/kernel/entry-armv.S:#include <mach/entry-macro.S>
arch/arm/kernel/entry-common.S:#include <mach/entry-macro.S>
arch/arm/kernel/head.S:#include <mach/debug-macro.S>
arch/arm/mm/proc-sa110.S:#include <mach/hardware.h>
arch/arm/mm/proc-sa1100.S:#include <mach/hardware.h>
arch/arm/plat-iop/adma.c:#include <mach/adma.h>
arch/arm/plat-iop/i2c.c:#include <mach/hardware.h>
arch/arm/plat-iop/pci.c:#include <mach/hardware.h>
arch/arm/plat-iop/pmu.c:#include <mach/irqs.h>
arch/arm/plat-iop/restart.c:#include <mach/hardware.h>
arch/arm/plat-iop/time.c:#include <mach/hardware.h>
arch/arm/plat-iop/time.c:#include <mach/time.h>
arch/arm/plat-omap/debug-devices.c:#include <mach/hardware.h>
arch/arm/plat-omap/debug-leds.c:#include <mach/hardware.h>
arch/arm/plat-omap/devices.c:#include <mach/hardware.h>
arch/arm/plat-omap/dma.c:#include <mach/hardware.h>
arch/arm/plat-omap/dmtimer.c:#include <mach/hardware.h>
arch/arm/plat-omap/fb.c:#include <mach/hardware.h>
arch/arm/plat-omap/i2c.c:#include <mach/irqs.h>
arch/arm/plat-omap/include/plat-omap/gpio.h:#include <mach/irqs.h>
arch/arm/plat-omap/include/plat-omap/irqs.h:#include <mach/hardware.h>
arch/arm/plat-orion/common.c:#include <mach/bridge-regs.h>
arch/arm/plat-orion/mpp.c:#include <mach/hardware.h>
arch/arm/plat-pxa/dma.c:#include <mach/hardware.h>
arch/arm/plat-pxa/dma.c:#include <mach/dma.h>
arch/arm/plat-pxa/ssp.c:#include <mach/hardware.h>
arch/arm/plat-samsung/clock.c:#include <mach/hardware.h>
arch/arm/plat-samsung/cpu.c:#include <mach/map.h>
arch/arm/plat-samsung/devs.c:#include <mach/hardware.h>
arch/arm/plat-samsung/devs.c:#include <mach/dma.h>
arch/arm/plat-samsung/devs.c:#include <mach/irqs.h>
arch/arm/plat-samsung/devs.c:#include <mach/map.h>
arch/arm/plat-samsung/dma-ops.c:#include <mach/dma.h>
arch/arm/plat-samsung/dma.c:#include <mach/dma.h>
arch/arm/plat-samsung/dma.c:#include <mach/irqs.h>
arch/arm/plat-samsung/include/plat-samsung/dma-ops.h:#include <mach/dma.h>
arch/arm/plat-samsung/include/plat-samsung/irq.h:#include <mach/hardware.h>
arch/arm/plat-samsung/include/plat-samsung/irq.h:#include <mach/regs-irq.h>
arch/arm/plat-samsung/include/plat-samsung/irq.h:#include <mach/regs-gpio.h>
arch/arm/plat-samsung/include/plat-samsung/regs-onenand.h:#include <mach/hardware.h>
arch/arm/plat-samsung/include/plat-samsung/regs-srom.h:#include <mach/map.h>
arch/arm/plat-samsung/include/plat-samsung/watchdog-reset.h:#include <mach/map.h>
arch/arm/plat-samsung/init.c:#include <mach/hardware.h>
arch/arm/plat-samsung/irq-vic-timer.c:#include <mach/map.h>
arch/arm/plat-samsung/pm.c:#include <mach/hardware.h>
arch/arm/plat-samsung/pm.c:#include <mach/map.h>
arch/arm/plat-samsung/pm.c:#include <mach/regs-clock.h>
arch/arm/plat-samsung/pm.c:#include <mach/regs-irq.h>
arch/arm/plat-samsung/pm.c:#include <mach/pm-core.h>
arch/arm/plat-samsung/pwm-clock.c:#include <mach/hardware.h>
arch/arm/plat-samsung/pwm-clock.c:#include <mach/map.h>
arch/arm/plat-samsung/s3c-dma-ops.c:#include <mach/dma.h>
arch/arm/plat-samsung/s5p-clock.c:#include <mach/regs-clock.h>
arch/arm/plat-samsung/s5p-dev-mfc.c:#include <mach/map.h>
arch/arm/plat-samsung/s5p-dev-uart.c:#include <mach/hardware.h>
arch/arm/plat-samsung/s5p-dev-uart.c:#include <mach/map.h>
arch/arm/plat-samsung/s5p-irq-eint.c:#include <mach/map.h>
arch/arm/plat-samsung/s5p-irq-eint.c:#include <mach/regs-gpio.h>
arch/arm/plat-samsung/s5p-irq-gpioint.c:#include <mach/map.h>
arch/arm/plat-samsung/s5p-irq-pm.c:#include <mach/map.h>
arch/arm/plat-samsung/s5p-irq-pm.c:#include <mach/regs-gpio.h>
arch/arm/plat-samsung/s5p-irq-pm.c:#include <mach/regs-irq.h>
arch/arm/plat-samsung/s5p-irq.c:#include <mach/map.h>
arch/arm/plat-samsung/s5p-time.c:#include <mach/map.h>
arch/arm/plat-samsung/setup-mipiphy.c:#include <mach/regs-clock.h>
arch/arm/plat-samsung/time.c:#include <mach/map.h>
arch/arm/plat-samsung/time.c:#include <mach/regs-irq.h>
arch/arm/plat-samsung/time.c:#include <mach/tick.h>
arch/arm/plat-spear/include/plat-spear/debug-macro.S:#include <mach/spear.h>
arch/arm/plat-spear/include/plat-spear/uncompress.h:#include <mach/spear.h>
arch/arm/plat-spear/pl080.c:#include <mach/spear.h>
arch/arm/plat-spear/pl080.c:#include <mach/misc_regs.h>
arch/arm/plat-spear/restart.c:#include <mach/spear.h>
arch/arm/plat-spear/restart.c:#include <mach/generic.h>
arch/arm/plat-spear/time.c:#include <mach/generic.h>
arch/arm/plat-versatile/clock.c:#include <mach/clkdev.h>
arch/arm/plat-versatile/leds.c:#include <mach/hardware.h>
arch/arm/plat-versatile/leds.c:#include <mach/platform.h>
drivers/ata/pata_at32.c:#include <mach/board.h>
drivers/ata/pata_at32.c:#include <mach/smc.h>
drivers/ata/pata_ep93xx.c:#include <mach/dma.h>
drivers/ata/pata_ep93xx.c:#include <mach/platform.h>
drivers/cdrom/gdrom.c:#include <mach/dma.h>
drivers/cdrom/gdrom.c:#include <mach/sysasic.h>
drivers/clk/spear/spear1310_clock.c:#include <mach/spear.h>
drivers/clk/spear/spear1340_clock.c:#include <mach/spear.h>
drivers/clk/spear/spear3xx_clock.c:#include <mach/misc_regs.h>
drivers/clk/spear/spear6xx_clock.c:#include <mach/misc_regs.h>
drivers/clk/versatile/clk-integrator.c:#include <mach/hardware.h>
drivers/clk/versatile/clk-integrator.c:#include <mach/platform.h>
drivers/cpufreq/s5pv210-cpufreq.c:#include <mach/regs-clock.h>
drivers/crypto/ux500/cryp/cryp.c:#include <mach/hardware.h>
drivers/dma/iop-adma.c:#include <mach/adma.h>
drivers/dma/tegra20-apb-dma.c:#include <mach/clk.h>
drivers/gpio/gpio-sa1100.c:#include <mach/hardware.h>
drivers/gpio/gpio-sa1100.c:#include <mach/irqs.h>
drivers/gpio/gpio-samsung.c:#include <mach/hardware.h>
drivers/gpio/gpio-samsung.c:#include <mach/map.h>
drivers/gpio/gpio-samsung.c:#include <mach/regs-clock.h>
drivers/gpio/gpio-samsung.c:#include <mach/regs-gpio.h>
drivers/i2c/busses/i2c-puv3.c:#include <mach/hardware.h>
drivers/input/keyboard/bf54x-keys.c:#include <mach/bf54x_keys.h>
drivers/input/keyboard/omap-keypad.c:#include <mach/hardware.h>
drivers/input/keyboard/pxa27x_keypad.c:#include <mach/hardware.h>
drivers/input/serio/i8042-unicore32io.h:#include <mach/hardware.h>
drivers/input/touchscreen/hp680_ts_input.c:#include <mach/hp6xx.h>
drivers/leds/leds-hp6xx.c:#include <mach/hp6xx.h>
drivers/leds/leds-locomo.c:#include <mach/hardware.h>
drivers/media/video/s5p-tv/sii9234_drv.c:#include <mach/gpio.h>
drivers/mmc/host/atmel-mci.c:#include <mach/atmel-mci.h>
drivers/mmc/host/atmel-mci.c:#include <mach/cpu.h>
drivers/mmc/host/atmel-mci.c:#include <mach/board.h>
drivers/mtd/maps/ixp2000.c:#include <mach/hardware.h>
drivers/mtd/nand/atmel_nand.c:#include <mach/cpu.h>
drivers/mtd/nand/h1910.c:#include <mach/hardware.h>
drivers/mtd/nand/h1910.c:#include <mach/h1900-gpio.h>
drivers/mtd/nand/h1910.c:#include <mach/ipaq.h>
drivers/mtd/nand/orion_nand.c:#include <mach/hardware.h>
drivers/mtd/nand/pxa3xx_nand.c:#include <mach/dma.h>
drivers/net/caif/caif_shm_u5500.c:#include <mach/mbox-db5500.h>
drivers/net/ethernet/adi/bfin_mac.c:#include <mach/pll.h>
drivers/pcmcia/pxa2xx_sharpsl.c:#include <mach/hardware.h>
drivers/pcmcia/sa1111_generic.c:#include <mach/hardware.h>
drivers/pcmcia/soc_common.c:#include <mach/hardware.h>
drivers/pwm/pwm-samsung.c:#include <mach/map.h>
drivers/rtc/rtc-ds1302.c:#include <mach/secureedge5410.h>
drivers/rtc/rtc-puv3.c:#include <mach/hardware.h>
drivers/rtc/rtc-s3c.c:#include <mach/hardware.h>
drivers/rtc/rtc-sa1100.c:#include <mach/hardware.h>
drivers/rtc/rtc-sa1100.c:#include <mach/irqs.h>
drivers/rtc/rtc-sa1100.c:#include <mach/regs-rtc.h>
drivers/sh/maple/maple.c:#include <mach/dma.h>
drivers/sh/maple/maple.c:#include <mach/sysasic.h>
drivers/spi/spi-atmel.c:#include <mach/board.h>
drivers/spi/spi-atmel.c:#include <mach/cpu.h>
drivers/spi/spi-s3c64xx.c:#include <mach/dma.h>
drivers/spi/spi-stmp.c:#include <mach/platform.h>
drivers/spi/spi-stmp.c:#include <mach/stmp3xxx.h>
drivers/spi/spi-stmp.c:#include <mach/dma.h>
drivers/spi/spi-stmp.c:#include <mach/regs-ssp.h>
drivers/spi/spi-stmp.c:#include <mach/regs-apbh.h>
drivers/tty/serial/atmel_serial.c:#include <mach/board.h>
drivers/tty/serial/samsung.c:#include <mach/hardware.h>
drivers/tty/serial/samsung.c:#include <mach/map.h>
drivers/usb/gadget/lpc32xx_udc.c:#include <mach/hardware.h>
drivers/usb/gadget/lpc32xx_udc.c:#include <mach/platform.h>
drivers/usb/gadget/lpc32xx_udc.c:#include <mach/irqs.h>
drivers/usb/gadget/lpc32xx_udc.c:#include <mach/board.h>
drivers/usb/gadget/omap_udc.c:#include <mach/usb.h>
drivers/usb/gadget/s3c-hsotg.c:#include <mach/map.h>
drivers/usb/gadget/s3c2410_udc.c:#include <mach/irqs.h>
drivers/usb/gadget/s3c2410_udc.c:#include <mach/hardware.h>
drivers/usb/gadget/s3c2410_udc.c:#include <mach/regs-irq.h>
drivers/usb/host/ohci-nxp.c:#include <mach/hardware.h>
drivers/usb/host/ohci-nxp.c:#include <mach/platform.h>
drivers/usb/host/ohci-nxp.c:#include <mach/irqs.h>
drivers/usb/host/ohci-omap.c:#include <mach/hardware.h>
drivers/usb/host/ohci-omap.c:#include <mach/irqs.h>
drivers/usb/host/ohci-omap.c:#include <mach/usb.h>
drivers/usb/otg/isp1301_omap.c:#include <mach/usb.h>
drivers/video/atmel_lcdfb.c:#include <mach/board.h>
drivers/video/atmel_lcdfb.c:#include <mach/cpu.h>
drivers/video/backlight/hp680_bl.c:#include <mach/hp6xx.h>
drivers/video/bf54x-lq043fb.c:#include <mach/bf54x-lq043.h>
drivers/video/fb-puv3.c:#include <mach/hardware.h>
drivers/video/pvr2fb.c:#include <mach/dma.h>
drivers/video/s3c-fb.c:#include <mach/map.h>
drivers/video/s3c2410fb.c:#include <mach/regs-lcd.h>
drivers/video/s3c2410fb.c:#include <mach/regs-gpio.h>
drivers/video/s3c2410fb.c:#include <mach/fb.h>
drivers/watchdog/iop_wdt.c:#include <mach/hardware.h>
drivers/watchdog/omap_wdt.c:#include <mach/hardware.h>
drivers/watchdog/orion_wdt.c:#include <mach/bridge-regs.h>
drivers/watchdog/pnx4008_wdt.c:#include <mach/hardware.h>
drivers/watchdog/s3c2410_wdt.c:#include <mach/map.h>
drivers/watchdog/sa1100_wdt.c:#include <mach/regs-ost.h>
drivers/watchdog/sa1100_wdt.c:#include <mach/reset.h>
drivers/watchdog/sa1100_wdt.c:#include <mach/hardware.h>
drivers/watchdog/stmp3xxx_wdt.c:#include <mach/platform.h>
drivers/watchdog/stmp3xxx_wdt.c:#include <mach/regs-rtc.h>
include/linux/maple.h:#include <mach/maple.h>
sound/sh/aica.c:#include <mach/sysasic.h>
sound/sh/sh_dac_audio.c:#include <mach/hp6xx.h>
sound/soc/fsl/imx-pcm-dma.c:#include <mach/dma.h>
sound/soc/fsl/imx-ssi.h:#include <mach/dma.h>
sound/soc/samsung/ac97.c:#include <mach/dma.h>
sound/soc/samsung/dma.c:#include <mach/hardware.h>
sound/soc/samsung/dma.c:#include <mach/dma.h>
sound/soc/samsung/goni_wm8994.c:#include <mach/gpio.h>
sound/soc/samsung/s3c-i2s-v2.c:#include <mach/dma.h>
sound/soc/samsung/s3c2412-i2s.c:#include <mach/dma.h>
sound/soc/samsung/s3c24xx-i2s.c:#include <mach/dma.h>
sound/soc/samsung/spdif.c:#include <mach/dma.h>
