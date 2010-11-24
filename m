Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab0KXBEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 20:04:52 -0500
Received: from ns39351.ovh.net ([91.121.21.191]:56867 "EHLO ns39351.ovh.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024Ab0KXBEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 20:04:51 -0500
Date: Wed, 24 Nov 2010 01:04:42 +0000
From: Simon Guinot <simon@sequanux.org>
To: Ash Hughes <ashley.hughes@blueyonder.co.uk>
Cc: nico@fluxnic.net, kernel@wantstofly.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ARM Orion: added Buffalo LS-CHL support
Message-ID: <20101124010442.GA1377@kw.sim.vm.gnt>
References: <000401cb89d0$8d1927b0$a74b7710$@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <000401cb89d0$8d1927b0$a74b7710$@blueyonder.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ashley,

On Sun, Nov 21, 2010 at 11:05:10PM -0000, Ash Hughes wrote:
> Adds support for Buffalo Linkstation Live v3 (LS-CHL) NAS drives.
> Signed-off-by: Ash Hughes <ashley.hughes@blueyonder.co.uk>
>=20
> ---
>=20
>=20
> diff -uprN linux-2.6-vanilla//arch/arm/mach-orion5x/Kconfig linux-2.6/arc=
h/arm/mach-orion5x/Kconfig
> --- linux-2.6-vanilla//arch/arm/mach-orion5x/Kconfig	2010-11-14 10:58:39.=
000000000 +0000
> +++ linux-2.6/arch/arm/mach-orion5x/Kconfig	2010-11-14 11:02:42.874582000=
 +0000
> @@ -51,6 +51,13 @@ config MACH_LINKSTATION_PRO
>  	  Buffalo Linkstation Pro/Live platform. Both v1 and
>  	  v2 devices are supported.
> =20
> +config MACH_LINKSTATION_LSCHL
> +	bool "Buffalo Linkstation Live v3 (LS-CHL)"
> +	select I2C_BOARDINFO
> +	help
> +	  Say 'Y' here if you want your kernel to support the
> +	  Buffalo Linkstation Live v3 (LS-CHL) platform.
> +
>  config MACH_LINKSTATION_MINI
>  	bool "Buffalo Linkstation Mini"
>  	select I2C_BOARDINFO
> diff -uprN linux-2.6-vanilla//arch/arm/mach-orion5x/ls-chl-setup.c linux-=
2.6/arch/arm/mach-orion5x/ls-chl-setup.c
> --- linux-2.6-vanilla//arch/arm/mach-orion5x/ls-chl-setup.c	1970-01-01 01=
:00:00.000000000 +0100
> +++ linux-2.6/arch/arm/mach-orion5x/ls-chl-setup.c	2010-11-21 15:33:43.91=
0827481 +0000
> @@ -0,0 +1,329 @@
> +/*
> + * arch/arm/mach-orion5x/ls-chl-setup.c
> + *
> + * Maintainer: Ash Hughes <ashley.hughes@blueyonder.co.uk>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/mtd/physmap.h>
> +#include <linux/mv643xx_eth.h>
> +#include <linux/leds.h>
> +#include <linux/gpio_keys.h>
> +#include <linux/gpio-fan.h>
> +#include <linux/input.h>
> +#include <linux/i2c.h>
> +#include <linux/ata_platform.h>
> +#include <linux/gpio.h>
> +#include <asm/mach-types.h>
> +#include <asm/mach/arch.h>
> +#include <asm/system.h>
> +#include <mach/orion5x.h>
> +#include "common.h"
> +#include "mpp.h"
> +
> +/***********************************************************************=
******
> + * Linkstation LS-CHL Info
> + ***********************************************************************=
*****/
> +
> +/*
> + * 256K NOR flash Device bus boot chip select
> + */
> +
> +#define LSCHL_NOR_BOOT_BASE	0xf4000000
> +#define LSCHL_NOR_BOOT_SIZE	SZ_256K
> +
> +/***********************************************************************=
******
> + * 256KB NOR Flash on BOOT Device
> + ***********************************************************************=
*****/
> +
> +static struct physmap_flash_data lschl_nor_flash_data =3D {
> +	.width		=3D 1,
> +};
> +
> +static struct resource lschl_nor_flash_resource =3D {
> +	.flags	=3D IORESOURCE_MEM,
> +	.start	=3D LSCHL_NOR_BOOT_BASE,
> +	.end	=3D LSCHL_NOR_BOOT_BASE + LSCHL_NOR_BOOT_SIZE - 1,
> +};
> +
> +static struct platform_device lschl_nor_flash =3D {
> +	.name			=3D "physmap-flash",
> +	.id			=3D 0,
> +	.dev		=3D {
> +		.platform_data	=3D &lschl_nor_flash_data,
> +	},
> +	.num_resources		=3D 1,
> +	.resource		=3D &lschl_nor_flash_resource,
> +};
> +
> +/***********************************************************************=
******
> + * Ethernet
> + ***********************************************************************=
*****/
> +
> +static struct mv643xx_eth_platform_data lschl_eth_data =3D {
> +	.phy_addr	=3D MV643XX_ETH_PHY_ADDR(8),
> +};
> +
> +/***********************************************************************=
******
> + * RTC 5C372a on I2C bus
> + ***********************************************************************=
*****/
> +
> +static struct i2c_board_info __initdata lschl_i2c_rtc =3D {
> +	I2C_BOARD_INFO("rs5c372a", 0x32),
> +};
> +
> +/***********************************************************************=
******
> + * LEDs attached to GPIO
> + ***********************************************************************=
*****/
> +
> +#define LSCHL_GPIO_LED_ALARM	2
> +#define LSCHL_GPIO_LED_INFO	3
> +#define LSCHL_GPIO_LED_FUNC	17
> +#define LSCHL_GPIO_LED_PWR	0
> +
> +static struct gpio_led lschl_led_pins[] =3D {
> +	{
> +		.name	   =3D "alarm:red",
> +		.gpio	   =3D LSCHL_GPIO_LED_ALARM,
> +		.active_low     =3D 1,
> +	}, {
> +		.name	   =3D "info:amber",
> +		.gpio	   =3D LSCHL_GPIO_LED_INFO,
> +		.active_low     =3D 1,
> +	}, {
> +		.name	   =3D "func:blue:top",
> +		.gpio	   =3D LSCHL_GPIO_LED_FUNC,
> +		.active_low     =3D 1,
> +	}, {
> +		.name	   =3D "power:blue:bottom",
> +		.gpio	   =3D LSCHL_GPIO_LED_PWR,
> +	},
> +};

You should use tabs instead of spaces for indentation.
The same comment apply to some other places in this file.

> +
> +static struct gpio_led_platform_data lschl_led_data =3D {
> +	.leds	   =3D lschl_led_pins,
> +	.num_leds       =3D ARRAY_SIZE(lschl_led_pins),
> +};
> +
> +static struct platform_device lschl_leds =3D {
> +	.name   =3D "leds-gpio",
> +	.id     =3D -1,
> +	.dev    =3D {
> +		.platform_data  =3D &lschl_led_data,
> +	},
> +};
> +
> +/***********************************************************************=
******
> + * SATA
> + ***********************************************************************=
*****/
> +static struct mv_sata_platform_data lschl_sata_data =3D {
> +	.n_ports	=3D 2,
> +};
> +
> +/***********************************************************************=
******
> + * LS-CHL specific power off method: reboot
> + ***********************************************************************=
*****/
> +/*
> + * On the LS-CHL, the shutdown process is following:
> + * - Userland monitors key events until the power switch goes to off pos=
ition
> + * - The board reboots
> + * - U-boot starts and goes into an idle mode waiting for the user
> + *   to move the switch to ON position
> + *
> + */
> +
> +static void lschl_power_off(void)
> +{
> +	arm_machine_restart('h', NULL);
> +}

Maybe that userland could just call "reboot" when a switch "power-off"
event happen ?
Is it possible to power-off the Linkstation device ?

> +
> +/***********************************************************************=
******
> + * General Setup
> + ***********************************************************************=
*****/
> +#define LSCHL_GPIO_USB_POWER	9
> +#define LSCHL_GPIO_AUTO_POWER	17
> +#define LSCHL_GPIO_POWER	18
> +
> +/***********************************************************************=
*****
> + * GPIO Attached Keys
> + ***********************************************************************=
*****/
> +#define LSCHL_GPIO_KEY_FUNC		15
> +#define LSCHL_GPIO_KEY_POWER		8
> +#define LSCHL_GPIO_KEY_AUTOPOWER	10
> +#define LSCHL_SW_POWER		0x00
> +#define LSCHL_SW_AUTOPOWER	0x01
> +#define LSCHL_SW_FUNC		0x02
> +
> +static struct gpio_keys_button lschl_buttons[] =3D {
> +	{
> +		.type		=3D EV_SW,
> +		.code	   =3D LSCHL_SW_POWER,
> +		.gpio	   =3D LSCHL_GPIO_KEY_POWER,
> +		.desc	   =3D "Power-on Switch",
> +		.active_low     =3D 1,
> +	}, {
> +		.type		=3D EV_SW,
> +		.code	   =3D LSCHL_SW_AUTOPOWER,
> +		.gpio	   =3D LSCHL_GPIO_KEY_AUTOPOWER,
> +		.desc	   =3D "Power-auto Switch",
> +		.active_low     =3D 1,
> +	}, {
> +		.type		=3D EV_SW,
> +		.code	   =3D LSCHL_SW_FUNC,
> +		.gpio	   =3D LSCHL_GPIO_KEY_FUNC,
> +		.desc	   =3D "Function Switch",
> +		.active_low     =3D 1,
> +	},
> +};
> +
> +static struct gpio_keys_platform_data lschl_button_data =3D {
> +	.buttons	=3D lschl_buttons,
> +	.nbuttons       =3D ARRAY_SIZE(lschl_buttons),
> +};
> +
> +static struct platform_device lschl_button_device =3D {
> +	.name		=3D "gpio-keys",
> +	.id		=3D -1,
> +	.num_resources	=3D 0,
> +	.dev		=3D {
> +		.platform_data  =3D &lschl_button_data,
> +	},
> +};
> +
> +#define LSCHL_GPIO_HDD_POWER	1
> +
> +/***********************************************************************=
*****
> + * GPIO Fan
> + ***********************************************************************=
*****/
> +
> +#define LSCHL_GPIO_FAN_LOW	16
> +#define LSCHL_GPIO_FAN_HIGH	14
> +#define LSCHL_GPIO_FAN_LOCK	6
> +
> +static struct gpio_fan_alarm lschl_alarm =3D {
> +	.gpio =3D LSCHL_GPIO_FAN_LOCK,
> +	.active_low =3D 0,

You don't need to set active_low to 0.

> +};
> +
> +static struct gpio_fan_speed lschl_speeds[] =3D {
> +	{
> +		.rpm =3D 0,
> +		.ctrl_val =3D 3,
> +	}, {
> +		.rpm =3D 1,
> +		.ctrl_val =3D 2,
> +	}, {
> +		.rpm =3D 2,
> +		.ctrl_val =3D 1,
> +	}, {
> +		.rpm =3D 3,
> +		.ctrl_val =3D 0,
> +	},
> +};

The rpm values are rather surprising. Can you either measure or estimate
the fan speed ?

> +
> +static int lschl_gpio_list[] =3D {
> +	LSCHL_GPIO_FAN_HIGH, LSCHL_GPIO_FAN_LOW,
> +};
> +
> +static struct gpio_fan_platform_data lschl_fan_data =3D {
> +	.num_ctrl =3D 2,
> +	.ctrl =3D lschl_gpio_list,
> +	.alarm =3D &lschl_alarm,
> +	.num_speed =3D 4,
> +	.speed =3D lschl_speeds,
> +};
> +
> +static struct platform_device lschl_fan_device =3D {
> +	.name		=3D "gpio-fan",
> +	.id		=3D -1,
> +	.num_resources	=3D 0,
> +	.dev		=3D {
> +		.platform_data  =3D &lschl_fan_data,
> +	},
> +};
> +
> +/***********************************************************************=
*****
> + * GPIO Data
> + ***********************************************************************=
*****/
> +
> +static struct orion5x_mpp_mode lschl_mpp_modes[] __initdata =3D {
> +	{  0, MPP_GPIO }, /* LED POWER */
> +	{  1, MPP_GPIO }, /* HDD POWER */
> +	{  2, MPP_GPIO }, /* LED ALARM */
> +	{  3, MPP_GPIO }, /* LED INFO */
> +	{  4, MPP_UNUSED },
> +	{  5, MPP_UNUSED },
> +	{  6, MPP_GPIO }, /* FAN LOCK */
> +	{  7, MPP_GPIO }, /* SW INIT */
> +	{  8, MPP_GPIO }, /* SW POWER */
> +	{  9, MPP_GPIO }, /* USB POWER */
> +	{ 10, MPP_GPIO }, /* SW AUTO POWER */
> +	{ 11, MPP_UNUSED },
> +	{ 12, MPP_UNUSED },
> +	{ 13, MPP_UNUSED },
> +	{ 14, MPP_GPIO }, /* FAN HIGH */
> +	{ 15, MPP_GPIO }, /* SW FUNC */
> +	{ 16, MPP_GPIO }, /* FAN LOW */
> +	{ 17, MPP_GPIO }, /* LED FUNC */
> +	{ 18, MPP_UNUSED },
> +	{ 19, MPP_UNUSED },
> +	{ -1 },
> +};
> +
> +static void __init lschl_init(void)
> +{
> +	/*
> +	 * Setup basic Orion functions. Needs to be called early.
> +	 */
> +	orion5x_init();
> +
> +	orion5x_mpp_conf(lschl_mpp_modes);
> +
> +	/*
> +	 * Configure peripherals.
> +	 */
> +	orion5x_ehci0_init();
> +	orion5x_ehci1_init();
> +	orion5x_eth_init(&lschl_eth_data);
> +	orion5x_i2c_init();
> +	orion5x_sata_init(&lschl_sata_data);
> +	orion5x_uart0_init();
> +	orion5x_xor_init();
> +
> +	orion5x_setup_dev_boot_win(LSCHL_NOR_BOOT_BASE,
> +				   LSCHL_NOR_BOOT_SIZE);
> +	platform_device_register(&lschl_nor_flash);
> +
> +	platform_device_register(&lschl_leds);
> +
> +	platform_device_register(&lschl_button_device);
> +
> +	platform_device_register(&lschl_fan_device);
> +
> +	i2c_register_board_info(0, &lschl_i2c_rtc, 1);
> +
> +	/* usb power on */
> +	gpio_set_value(LSCHL_GPIO_USB_POWER, 1);
> +
> +	/* register power-off method */
> +	pm_power_off =3D lschl_power_off;
> +
> +	pr_info("%s: finished\n", __func__);
> +}
> +
> +MACHINE_START(LINKSTATION_LSCHL, "Buffalo Linkstation LiveV3 (LS-CHL)")
> +	/* Maintainer: Ash Hughes <ashley.hughes@blueyonder.co.uk> */
> +	.boot_params	=3D 0x00000100,
> +	.init_machine	=3D lschl_init,
> +	.map_io		=3D orion5x_map_io,
> +	.init_irq	=3D orion5x_init_irq,
> +	.timer		=3D &orion5x_timer,
> +	.fixup		=3D tag_fixup_mem32,
> +MACHINE_END
> +
> diff -uprN linux-2.6-vanilla//arch/arm/mach-orion5x/Makefile linux-2.6/ar=
ch/arm/mach-orion5x/Makefile
> --- linux-2.6-vanilla//arch/arm/mach-orion5x/Makefile	2010-11-14 10:58:39=
=2E000000000 +0000
> +++ linux-2.6/arch/arm/mach-orion5x/Makefile	2010-11-14 11:03:34.44458200=
1 +0000
> @@ -21,3 +21,4 @@ obj-$(CONFIG_MACH_WNR854T)	+=3D wnr854t-se
>  obj-$(CONFIG_MACH_RD88F5181L_GE)	+=3D rd88f5181l-ge-setup.o
>  obj-$(CONFIG_MACH_RD88F5181L_FXO)	+=3D rd88f5181l-fxo-setup.o
>  obj-$(CONFIG_MACH_RD88F6183AP_GE)	+=3D rd88f6183ap-ge-setup.o
> +obj-$(CONFIG_MACH_LINKSTATION_LSCHL)   +=3D ls-chl-setup.o

You should replace spaces with tab here too.

Simon

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkzsZKoACgkQgtp0PDeOcDrc6QCdGSDoV6uckgURAYOQLi9ANiHA
juMAn3SlGvaEC5kDyif6iCfFa7SuFQL6
=D47g
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
