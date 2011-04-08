Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1DHN0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 09:26:12 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:56430 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1DHN0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 09:26:11 -0400
Date: Fri, 8 Apr 2011 15:25:34 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Joshua Kinard <kumba@gentoo.org>
Cc: Linux MIPS List <linux-mips@linux-mips.org>, rtc-linux@googlegroups.com,
        LKML <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 2/2]: MIPS: sgi-ip32: Add support for rtc-ds1685 to SGI
 O2 (IP32)
Message-ID: <20110408132533.GA15416@linux-mips.org>
References: <4D9DB95F.8040100@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9DB95F.8040100@gentoo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 09:17:19AM -0400, Joshua Kinard wrote:
> Date:   Thu, 07 Apr 2011 09:17:19 -0400
> From: Joshua Kinard <kumba@gentoo.org>
> To: Linux MIPS List <linux-mips@linux-mips.org>, Ralf Baechle
>  <ralf@linux-mips.org>
> CC: rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
>  Alessandro Zummo <a.zummo@towertech.it>
> Subject: [PATCH 2/2]: MIPS: sgi-ip32: Add support for rtc-ds1685 to SGI O2
>  (IP32)
> Content-Type: text/plain; charset=ISO-8859-1
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1

Please don't PGP sign patches.  Nobody care about your PGP signature as
long there's a valid Signed-off-by.


> These are the modifications needed to the SGI O2 (IP32) codebase to switch off
> of rtc-cmos to rtc-ds1685.  It needs to be applied after the main rtc-ds1685 patch.
> 
> Key changes here eliminate the custom power-off code and call upon the version
> built into the main driver via platform_data, as well as defining the required
> register step-size of 256 bytes (0x100).
> 
> Signed-off-by: Joshua Kinard <kumba@gentoo.org>
> - ---

And this is a --- tearoff line corrupted by PGP.  Just like every other line
starting with a -.

>  include/asm/mach-ip32/mc146818rtc.h |   36 ----------
>  sgi-ip32/ip32-platform.c            |   49 ++++++++++++--
>  sgi-ip32/ip32-reset.c               |  118 ++++++++----------------------------
>  3 files changed, 67 insertions(+), 136 deletions(-)
> 
> diff -Naurp mipslinux.orig/arch/mips/include/asm/mach-ip32/mc146818rtc.h
> mipslinux.ip32-rtc/arch/mips/include/asm/mach-ip32/mc146818rtc.h
> - --- mipslinux.orig/arch/mips/include/asm/mach-ip32/mc146818rtc.h	2009-04-28
> 20:29:27.000000000 -0400
> +++ mipslinux.ip32-rtc/arch/mips/include/asm/mach-ip32/mc146818rtc.h	1969-12-31
> 19:00:00.000000000 -0500

Two linewrapped lines rot in pieces here.

Only recent patch versions are happy with this but git takes a harder look
at patch headers and will reject it.

> @@ -1,36 +0,0 @@
> - -/*

Another GPG mangled line.

> - - * This file is subject to the terms and conditions of the GNU General Public
> - - * License.  See the file "COPYING" in the main directory of this archive
> - - * for more details.
> - - *
> - - * Copyright (C) 1998, 2001, 03 by Ralf Baechle
> - - * Copyright (C) 2000 Harald Koerfgen
> - - *
> - - * RTC routines for IP32 style attached Dallas chip.
> - - */
> - -#ifndef __ASM_MACH_IP32_MC146818RTC_H
> - -#define __ASM_MACH_IP32_MC146818RTC_H
> - -
> - -#include <asm/ip32/mace.h>
> - -
> - -#define RTC_PORT(x)	(0x70 + (x))
> - -
> - -static unsigned char CMOS_READ(unsigned long addr)
> - -{
> - -	return mace->isa.rtc[addr << 8];
> - -}
> - -
> - -static inline void CMOS_WRITE(unsigned char data, unsigned long addr)
> - -{
> - -	mace->isa.rtc[addr << 8] = data;
> - -}
> - -
> - -/*
> - - * FIXME: Do it right. For now just assume that noone lives in 20th century
> - - * and no O2 user in 22th century ;-)
> - - */
> - -#define mc146818_decode_year(year) ((year) + 2000)
> - -
> - -#define RTC_ALWAYS_BCD	0
> - -
> - -#endif /* __ASM_MACH_IP32_MC146818RTC_H */
> diff -Naurp mipslinux.orig/arch/mips/sgi-ip32/ip32-platform.c
> mipslinux.ip32-rtc/arch/mips/sgi-ip32/ip32-platform.c
> - --- mipslinux.orig/arch/mips/sgi-ip32/ip32-platform.c	2009-04-28
> 20:29:28.000000000 -0400
> +++ mipslinux.ip32-rtc/arch/mips/sgi-ip32/ip32-platform.c	2011-04-07
> 08:02:00.063871001 -0400
> @@ -9,10 +9,13 @@
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
>  #include <linux/serial_8250.h>
> +#include <linux/rtc/ds1685.h>
> 
>  #include <asm/ip32/mace.h>
>  #include <asm/ip32/ip32_ints.h>
> 
> +extern void inline ip32_prepare_poweroff(void);

An extern inline declaration is not online pointless; "extern inline"
definitions also have a different meaning than what you probably want.
Just get rid of the inline keyword here.  Anyway, modern gccs have decent
heuristics when to inline functions so the inline keyword is losing its
importance.

> +
>  #define MACEISA_SERIAL1_OFFS   offsetof(struct sgi_mace, isa.serial1)
>  #define MACEISA_SERIAL2_OFFS   offsetof(struct sgi_mace, isa.serial2)
> 
> @@ -90,22 +93,50 @@ static __init int sgio2btns_devinit(void
> 
>  device_initcall(sgio2btns_devinit);
> 
> - -static struct resource sgio2_cmos_rsrc[] = {
> +#define MACE_RTC_RES_START (MACE_BASE + offsetof(struct sgi_mace, isa.rtc))
> +#define MACE_RTC_RES_END (MACE_RTC_RES_START + 32767)
> +
> +static struct resource ip32_rtc_resources[] = {
>  	{
> - -		.start = 0x70,
> - -		.end   = 0x71,
> - -		.flags = IORESOURCE_IO
> +		.start	= MACEISA_RTC_IRQ,
> +		.end	= MACEISA_RTC_IRQ,
> +		.flags	= IORESOURCE_IRQ
> +	}, {
> +		.start	= MACE_RTC_RES_START,
> +		.end	= MACE_RTC_RES_END,
> +		.flags	= IORESOURCE_MEM,
>  	}
>  };
> 
> - -static __init int sgio2_cmos_devinit(void)
> +
> +/* RTC registers on IP32 are each padded by 256 bytes (0x100). */
> +static struct ds1685_rtc_platform_data
> +ip32_rtc_platform_data[] = {
> +	{
> +		.regstep = 0x100,
> +		.plat_prepare_poweroff = ip32_prepare_poweroff,
> +	},
> +};
> +
> +struct platform_device ip32_rtc_device = {
> +	.name			= "rtc-ds1685",
> +	.id			= -1,
> +	.dev			= {
> +		.platform_data	= ip32_rtc_platform_data,
> +	},
> +	.num_resources		= ARRAY_SIZE(ip32_rtc_resources),
> +	.resource		= ip32_rtc_resources,
> +};
> +EXPORT_SYMBOL(ip32_rtc_device);

This export is unnecessary; remove it.

> +static int __init sgio2_rtc_devinit(void)
>  {
> - -	return IS_ERR(platform_device_register_simple("rtc_cmos", -1,
> - -						      sgio2_cmos_rsrc, 1));
> +	return platform_device_register(&ip32_rtc_device);
> +
>  }
> 
> - -device_initcall(sgio2_cmos_devinit);
> +device_initcall(sgio2_rtc_devinit);
> 
>  MODULE_AUTHOR("Ralf Baechle <ralf@linux-mips.org>");
>  MODULE_LICENSE("GPL");
> - -MODULE_DESCRIPTION("8250 UART probe driver for SGI IP32 aka O2");
> +MODULE_DESCRIPTION("IP32 platform setup for SGI IP32 aka O2");
> diff -Naurp mipslinux.orig/arch/mips/sgi-ip32/ip32-reset.c
> mipslinux.ip32-rtc/arch/mips/sgi-ip32/ip32-reset.c
> - --- mipslinux.orig/arch/mips/sgi-ip32/ip32-reset.c	2009-05-23 12:01:03.025842703
> - -0400
> +++ mipslinux.ip32-rtc/arch/mips/sgi-ip32/ip32-reset.c	2011-04-07
> 08:02:00.063871001 -0400
> @@ -13,7 +13,7 @@
>  #include <linux/sched.h>
>  #include <linux/notifier.h>
>  #include <linux/delay.h>
> - -#include <linux/ds17287rtc.h>
> +#include <linux/rtc/ds1685.h>
>  #include <linux/interrupt.h>
>  #include <linux/pm.h>
> 
> @@ -33,55 +33,31 @@
>  #define POWERDOWN_FREQ		(HZ / 4)
>  #define PANIC_FREQ		(HZ / 8)
> 
> - -static struct timer_list power_timer, blink_timer, debounce_timer;
> - -static int has_panicked, shuting_down;
> +extern struct ds1685_rtc_platform_data ip32_rtc_platform_data[];

This declaration seems unnecessary.

> +extern struct platform_device ip32_rtc_device;
> 
> - -static void ip32_machine_restart(char *command) __attribute__((noreturn));
> - -static void ip32_machine_halt(void) __attribute__((noreturn));
> - -static void ip32_machine_power_off(void) __attribute__((noreturn));
> +static struct timer_list power_timer, blink_timer;
> +static int has_panicked, shutting_down;
> 
> - -static void ip32_machine_restart(char *cmd)
> +static void ip32_poweroff(void *data)
>  {
> - -	crime->control = CRIME_CONTROL_HARD_RESET;
> +#if defined(CONFIG_RTC_DRV_DS1685_FAMILY) && \
> +    (defined(CONFIG_RTC_DRV_DS1685) || defined(CONFIG_RTC_DRV_DS17285))
> +	ds1685_rtc_poweroff((struct platform_device *)data);
> +#else
>  	while (1);
> +#endif

That's the sort of #ifdefery is rather ugly.  Switch the driver to a
module and magically the poweroff code ceases to work ...

>  }
> 
> - -static inline void ip32_machine_halt(void)
> - -{
> - -	ip32_machine_power_off();
> - -}
> 
> - -static void ip32_machine_power_off(void)
> +static void ip32_machine_restart(char *cmd) __attribute__((noreturn));
> +static void ip32_machine_restart(char *cmd)
>  {
> - -	unsigned char reg_a, xctrl_a, xctrl_b;
> - -
> - -	disable_irq(MACEISA_RTC_IRQ);
> - -	reg_a = CMOS_READ(RTC_REG_A);
> - -
> - -	/* setup for kickstart & wake-up (DS12287 Ref. Man. p. 19) */
> - -	reg_a &= ~DS_REGA_DV2;
> - -	reg_a |= DS_REGA_DV1;
> - -
> - -	CMOS_WRITE(reg_a | DS_REGA_DV0, RTC_REG_A);
> - -	wbflush();
> - -	xctrl_b = CMOS_READ(DS_B1_XCTRL4B)
> - -		   | DS_XCTRL4B_ABE | DS_XCTRL4B_KFE;
> - -	CMOS_WRITE(xctrl_b, DS_B1_XCTRL4B);
> - -	xctrl_a = CMOS_READ(DS_B1_XCTRL4A) & ~DS_XCTRL4A_IFS;
> - -	CMOS_WRITE(xctrl_a, DS_B1_XCTRL4A);
> - -	wbflush();
> - -	/* adios amigos... */
> - -	CMOS_WRITE(xctrl_a | DS_XCTRL4A_PAB, DS_B1_XCTRL4A);
> - -	CMOS_WRITE(reg_a, RTC_REG_A);
> - -	wbflush();
> +	msleep(10);
> +	crime->control = CRIME_CONTROL_HARD_RESET;
>  	while (1);
>  }
> 
> - -static void power_timeout(unsigned long data)
> - -{
> - -	ip32_machine_power_off();
> - -}
> - -
>  static void blink_timeout(unsigned long data)
>  {
>  	unsigned long led = mace->perif.ctrl.misc ^ MACEISA_LED_RED;
> @@ -89,44 +65,27 @@ static void blink_timeout(unsigned long
>  	mod_timer(&blink_timer, jiffies + data);
>  }
> 
> - -static void debounce(unsigned long data)
> +static void ip32_machine_halt(void)
>  {
> - -	unsigned char reg_a, reg_c, xctrl_a;
> - -
> - -	reg_c = CMOS_READ(RTC_INTR_FLAGS);
> - -	reg_a = CMOS_READ(RTC_REG_A);
> - -	CMOS_WRITE(reg_a | DS_REGA_DV0, RTC_REG_A);
> - -	wbflush();
> - -	xctrl_a = CMOS_READ(DS_B1_XCTRL4A);
> - -	if ((xctrl_a & DS_XCTRL4A_IFS) || (reg_c & RTC_IRQF )) {
> - -		/* Interrupt still being sent. */
> - -		debounce_timer.expires = jiffies + 50;
> - -		add_timer(&debounce_timer);
> - -
> - -		/* clear interrupt source */
> - -		CMOS_WRITE(xctrl_a & ~DS_XCTRL4A_IFS, DS_B1_XCTRL4A);
> - -		CMOS_WRITE(reg_a & ~DS_REGA_DV0, RTC_REG_A);
> - -		return;
> - -	}
> - -	CMOS_WRITE(reg_a & ~DS_REGA_DV0, RTC_REG_A);
> - -
> - -	if (has_panicked)
> - -		ip32_machine_restart(NULL);
> +	ip32_poweroff(&ip32_rtc_device);
> +}
> 
> - -	enable_irq(MACEISA_RTC_IRQ);
> +static void power_timeout(unsigned long data)
> +{
> +	ip32_poweroff(&ip32_rtc_device);
>  }
> 
> - -static inline void ip32_power_button(void)
> +void ip32_prepare_poweroff(void)
>  {
>  	if (has_panicked)
>  		return;
> 
> - -	if (shuting_down || kill_cad_pid(SIGINT, 1)) {
> +	if (shutting_down || kill_cad_pid(SIGINT, 1)) {
>  		/* No init process or button pressed twice.  */
> - -		ip32_machine_power_off();
> +		ip32_poweroff(&ip32_rtc_device);
>  	}
> 
> - -	shuting_down = 1;
> +	shutting_down = 1;
>  	blink_timer.data = POWERDOWN_FREQ;
>  	blink_timeout(POWERDOWN_FREQ);
> 
> @@ -135,27 +94,7 @@ static inline void ip32_power_button(voi
>  	power_timer.expires = jiffies + POWERDOWN_TIMEOUT * HZ;
>  	add_timer(&power_timer);
>  }
> - -
> - -static irqreturn_t ip32_rtc_int(int irq, void *dev_id)
> - -{
> - -	unsigned char reg_c;
> - -
> - -	reg_c = CMOS_READ(RTC_INTR_FLAGS);
> - -	if (!(reg_c & RTC_IRQF)) {
> - -		printk(KERN_WARNING
> - -			"%s: RTC IRQ without RTC_IRQF\n", __func__);
> - -	}
> - -	/* Wait until interrupt goes away */
> - -	disable_irq_nosync(MACEISA_RTC_IRQ);
> - -	init_timer(&debounce_timer);
> - -	debounce_timer.function = debounce;
> - -	debounce_timer.expires = jiffies + 50;
> - -	add_timer(&debounce_timer);
> - -
> - -	printk(KERN_DEBUG "Power button pressed\n");
> - -	ip32_power_button();
> - -	return IRQ_HANDLED;
> - -}
> +EXPORT_SYMBOL(ip32_prepare_poweroff);

Unnecessary export; remove it.

>  static int panic_event(struct notifier_block *this, unsigned long event,
>  		       void *ptr)
> @@ -190,15 +129,12 @@ static __init int ip32_reboot_setup(void
> 
>  	_machine_restart = ip32_machine_restart;
>  	_machine_halt = ip32_machine_halt;
> - -	pm_power_off = ip32_machine_power_off;
> +	pm_power_off = ip32_machine_halt;
> 
>  	init_timer(&blink_timer);
>  	blink_timer.function = blink_timeout;
>  	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
> 
> - -	if (request_irq(MACEISA_RTC_IRQ, ip32_rtc_int, 0, "rtc", NULL))
> - -		panic("Can't allocate MACEISA RTC IRQ");
> - -
>  	return 0;
>  }
