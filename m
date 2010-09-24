Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab0IXTHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:07:35 -0400
Received: from relais.videotron.ca ([24.201.245.36]:11995 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab0IXTHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:07:34 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 24 Sep 2010 15:07:15 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Ash Hughes <ashley.hughes@blueyonder.co.uk>
Cc: kernel@wantstofly.org, Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] ARM Orion: added Buffalo LS-CHL support
In-reply-to: <000001cb5c13$41f1f0e0$c5d5d2a0$@blueyonder.co.uk>
Message-id: <alpine.LFD.2.00.1009241426120.13233@xanadu.home>
References: <000001cb5c13$41f1f0e0$c5d5d2a0$@blueyonder.co.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010, Ash Hughes wrote:

> From: Ash Hughes <ashley.hughes@blueyonder.co.uk>
> Adds support for Buffalo Linkstation Live v3 (LS-CHL) NAS drives.
> Signed-off-by: Ash Hughes <ashley.hughes@blueyonder.co.uk>

Comments below.

> ---
> 
> Code has been in use for several months:
> http://forum.buffalo.nas-central.org/viewtopic.php?f=18&t=13566
> 
> diff -urBN linux-2.6.34-vanilla/arch/arm/mach-orion5x/Kconfig linux-2.6.34/arch/arm/mach-orion5x/Kconfig
> --- linux-2.6.34-vanilla/arch/arm/mach-orion5x/Kconfig	2010-05-16 22:17:36.000000000 +0100
> +++ linux-2.6.34/arch/arm/mach-orion5x/Kconfig	2010-06-11 13:46:45.665614309 +0100
> @@ -50,6 +50,13 @@
>  	  Buffalo Linkstation Pro/Live platform. Both v1 and
>  	  v2 devices are supported.
>  
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
> diff -urBN linux-2.6.34-vanilla/arch/arm/mach-orion5x/ls-chl-setup.c
> linux-2.6.34/arch/arm/mach-orion5x/ls-chl-setup.c
> --- linux-2.6.34-vanilla/arch/arm/mach-orion5x/ls-chl-setup.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.34/arch/arm/mach-orion5x/ls-chl-setup.c	2010-09-24 03:56:24.432077623 +0100
> @@ -0,0 +1,449 @@
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
> +#include <linux/proc_fs.h>

More on proc_fs below.

> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/pci.h>

Why do you need this include?

> +#include <linux/irq.h>
> +#include <linux/delay.h>

And this one?

> +#include <linux/mtd/physmap.h>
> +#include <linux/mv643xx_eth.h>
> +#include <linux/leds.h>
> +#include <linux/gpio_keys.h>
> +#include <linux/input.h>
> +#include <linux/i2c.h>
> +#include <linux/serial_reg.h>

And this one?

> +#include <linux/ata_platform.h>
> +#include <asm/mach-types.h>
> +#include <asm/gpio.h>

Please use linux/gpio.h instead.

> +#include <asm/mach/arch.h>
> +#include <asm/mach/pci.h>

Why this one?

> +#include "common.h"
> +#include "mpp.h"
> +#include "include/mach/system.h"

Please use <> for global includes.

> +#include <asm/uaccess.h>

We prefer to list global includes before local ones.

> +/*****************************************************************************
> + * Linkstation LS-CHL Info
> + ****************************************************************************/
> +
> +/*
> + * 256K NOR flash Device bus boot chip select
> + */
> +
> +#define LSCHL_NOR_BOOT_BASE	0xf4000000
> +#define LSCHL_NOR_BOOT_SIZE	SZ_256K
> +
> +/*****************************************************************************
> + * 256KB NOR Flash on BOOT Device
> + ****************************************************************************/
> +
> +static struct physmap_flash_data lschl_nor_flash_data = {
> +	.width		= 1,
> +};
> +
> +static struct resource lschl_nor_flash_resource = {
> +	.flags	= IORESOURCE_MEM,
> +	.start	= LSCHL_NOR_BOOT_BASE,
> +	.end	= LSCHL_NOR_BOOT_BASE + LSCHL_NOR_BOOT_SIZE - 1,
> +};
> +
> +static struct platform_device lschl_nor_flash = {
> +	.name			= "physmap-flash",
> +	.id			= 0,
> +	.dev		= {
> +		.platform_data	= &lschl_nor_flash_data,
> +	},
> +	.num_resources		= 1,
> +	.resource		= &lschl_nor_flash_resource,
> +};
> +
> +/*****************************************************************************
> + * Ethernet
> + ****************************************************************************/
> +
> +static struct mv643xx_eth_platform_data lschl_eth_data = {
> +	.phy_addr	= 8,
> +};

You should use the MV643XX_ETH_PHY_ADDR() macro.

[...]

> +#define LSCHL_GPIO_FAN_LOW	16
> +#define LSCHL_GPIO_FAN_HIGH	14
> +#define LSCHL_GPIO_FAN_LOCK	6
> +
> +#define BUFFALO_GPIO_FAN_STOP	0
> +#define BUFFALO_GPIO_FAN_SLOW	1
> +#define BUFFALO_GPIO_FAN_FAST	2
> +#define BUFFALO_GPIO_FAN_FULL	3
> +
> +#define BuffaloGpio_FanStop()	FanControlWrite(BUFFALO_GPIO_FAN_STOP)
> +#define BuffaloGpio_FanSlow()	FanControlWrite(BUFFALO_GPIO_FAN_SLOW)
> +#define BuffaloGpio_FanFast()	FanControlWrite(BUFFALO_GPIO_FAN_FAST)
> +#define BuffaloGpio_FanFull()	FanControlWrite(BUFFALO_GPIO_FAN_FULL)

The WindowsCamelCaseIdentifierStyle is usually frowned upon for 
Linux code.

> +void
> +FanControlWrite(unsigned int value)

Make this static.

> +{
> +	switch (value) {
> +	case BUFFALO_GPIO_FAN_STOP:
> +		gpio_set_value(LSCHL_GPIO_FAN_LOW, 1);
> +		gpio_set_value(LSCHL_GPIO_FAN_HIGH, 1);
> +		break;
> +	case BUFFALO_GPIO_FAN_SLOW:
> +		gpio_set_value(LSCHL_GPIO_FAN_LOW, 1);
> +		gpio_set_value(LSCHL_GPIO_FAN_HIGH, 0);
> +		break;
> +	case BUFFALO_GPIO_FAN_FAST:
> +		gpio_set_value(LSCHL_GPIO_FAN_LOW, 0);
> +		gpio_set_value(LSCHL_GPIO_FAN_HIGH, 1);
> +		break;
> +	case BUFFALO_GPIO_FAN_FULL:
> +		gpio_set_value(LSCHL_GPIO_FAN_LOW, 0);
> +		gpio_set_value(LSCHL_GPIO_FAN_HIGH, 0);
> +		break;
> +	default:
> +		break;
> +	} /* end of switch */
> +}
> +
> +unsigned int
> +BuffaloGpio_FanControlRead(void)

Ditto here (CamelCase and static).

> +{
> +
> +	int fan_low = gpio_get_value(LSCHL_GPIO_FAN_LOW);
> +	int fan_high = gpio_get_value(LSCHL_GPIO_FAN_HIGH);
> +
> +	if (!fan_low && !fan_high)
> +		return BUFFALO_GPIO_FAN_FULL;
> +	else if (!fan_low && fan_high)
> +		return BUFFALO_GPIO_FAN_FAST;
> +	else if (fan_low && !fan_high)
> +		return BUFFALO_GPIO_FAN_SLOW;
> +	else if (fan_low && fan_high)
> +		return BUFFALO_GPIO_FAN_STOP;
> +	return 0;
> +}

Now... both of those functions could be much simpler, similar to this:

static void fan_ctrl_write(unsigned int value)
{
	int fan_low = !(value & 1);
	int fan_high = !(value & 2);
	gpio_set_value(LSCHL_GPIO_FAN_LOW, fan_low);
	gpio_set_value(LSCHL_GPIO_FAN_HIGH, fan_high);
}

static unsigned int fan_ctrl_read(void)
{
	int fan_low = gpio_get_value(LSCHL_GPIO_FAN_LOW);
	int fan_high = gpio_get_value(LSCHL_GPIO_FAN_HIGH);
	return !fan_low | ((!fan_high) << 1);
}

> +static int
> +FanStatusRead(char *pg, char **st, off_t off, int length, int *eof, void *data)
> +{
> +
> +	int len = 0;
> +	off_t begin = 0;
> +
> +	int PinStat = gpio_get_value(LSCHL_GPIO_FAN_LOCK);
> +
> +	if (!PinStat)
> +		len = sprintf(pg, "Fine\n");
> +	else
> +		len = sprintf(pg, "Stop\n");
> +	*st = pg + (off - begin);
> +	len -= (off - begin);
> +	if (len > length)
> +		len = length;
> +	return len;
> +}
> +
> +
> +
> +static int
> +FanStatusWrite(struct file *fp, const char *buf, unsigned long cnt, void *d) {
> +	return cnt;
> +}
> +
> +static int
> +FanCtlWrite(struct file *filep, const char *buf, unsigned long cnt, void *data)
> +{
> +	int len, ret;
> +	char *ptr, tState[8];
> +
> +	if (cnt > 8)
> +		len = 8;
> +	else
> +		len = cnt;
> +
> +	ret = copy_from_user(tState, buf, len);
> +	if (ret < 0) {
> +		printk(KERN_ERR "%s: Setting fan speed failed\n", "ls-chl");
> +		return -EFAULT;
> +	}
> +
> +	ptr = strrchr(tState, '\n');
> +	if (ptr)
> +		*ptr = '\0';
> +
> +	if (strncmp(tState, "stop", strlen("stop")) == 0)
> +		BuffaloGpio_FanStop();
> +	else if (strncmp(tState, "slow", strlen("slow")) == 0)
> +		BuffaloGpio_FanSlow();
> +	else if (strncmp(tState, "fast", strlen("fast")) == 0)
> +		BuffaloGpio_FanFast();
> +	else if (strncmp(tState, "full", strlen("full")) == 0)
> +		BuffaloGpio_FanFull();
> +	return cnt;
> +}
> +
> +static int
> +FanCtlRead(char *pg, char **start, off_t off, int length, int *eof, void *data)
> +{
> +	int len = 0;
> +	off_t begin = 0;
> +
> +	unsigned int fan_status = BuffaloGpio_FanControlRead();
> +
> +	switch (fan_status) {
> +	case BUFFALO_GPIO_FAN_STOP:
> +		len += sprintf(pg, "stop\n");
> +		break;
> +	case BUFFALO_GPIO_FAN_SLOW:
> +		len += sprintf(pg, "slow\n");
> +		break;
> +	case BUFFALO_GPIO_FAN_FAST:
> +		len += sprintf(pg, "fast\n");
> +		break;
> +	case BUFFALO_GPIO_FAN_FULL:
> +		len += sprintf(pg, "full\n");
> +		break;
> +	default:
> +		break;
> +	} /* end of switch */
> +
> +	*start = pg + (off - begin);
> +	len -= (off - begin);
> +	if (len > length)
> +		len = length;
> +	return len;
> +}

Here I'd strongly suggest investigating the hwmon API which is the 
standard interface for fan control/status on Linux instead of creating 
an adhoc one.

> +static void __init lschl_init(void)
> +{
> +	/*
> +	 * Setup basic Orion functions. Need to be called early.
> +	 */
> +	struct proc_dir_entry *pde;
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
> +	i2c_register_board_info(0, &lschl_i2c_rtc, 1);
> +
> +	pde = proc_mkdir("buffalo", 0);
> +	pde = proc_mkdir("buffalo/gpio", 0);
> +	pde = proc_mkdir("buffalo/gpio/fan", 0);
> +	pde = create_proc_entry("buffalo/gpio/fan/control", 0644, 0);
> +	pde->read_proc = FanCtlRead;
> +	pde->write_proc = FanCtlWrite;
> +	pde = create_proc_entry("buffalo/gpio/fan/lock", 0, 0);
> +	pde->read_proc = FanStatusRead;
> +	pde->write_proc = FanStatusWrite;

As I said, the hwmon interface would be a much better choice than a 
custom /proc interface.  But if you still prefer a lightweight 
interface, then a numeric sysfs entry would still be much better than 
/proc with that string parsing

> +	/* slow down fan */
> +	BuffaloGpio_FanSlow();
> +	/* usb power on */
> +	gpio_set_value(LSCHL_GPIO_USB_POWER, 1);
> +
> +	/* register power-off method */
> +	pm_power_off = lschl_power_off;
> +
> +	pr_info("%s: finished\n", __func__);
> +}
> +
> +#ifdef CONFIG_MACH_LINKSTATION_LSCHL

You don't need this #ifdef as this whole file is already conditionally 
compiled only when this config symbol is active.

> +MACHINE_START(LINKSTATION_LSCHL, "Buffalo Linkstation LiveV3 (LS-CHL)")
> +	/* Maintainer: Ash Hughes <ashley.hughes@blueyonder.co.uk> */
> +	.phys_io	= ORION5X_REGS_PHYS_BASE,
> +	.io_pg_offst	= ((ORION5X_REGS_VIRT_BASE) >> 18) & 0xFFFC,
> +	.boot_params	= 0x00000100,
> +	.init_machine	= lschl_init,
> +	.map_io		= orion5x_map_io,
> +	.init_irq	= orion5x_init_irq,
> +	.timer		= &orion5x_timer,
> +	.fixup		= tag_fixup_mem32,
> +MACHINE_END
> +#endif
> diff -urBN linux-2.6.34-vanilla/arch/arm/mach-orion5x/Makefile linux-2.6.34/arch/arm/mach-orion5x/Makefile
> --- linux-2.6.34-vanilla/arch/arm/mach-orion5x/Makefile	2010-05-16 22:17:36.000000000 +0100
> +++ linux-2.6.34/arch/arm/mach-orion5x/Makefile	2010-08-18 12:33:02.714982012 +0100
> @@ -21,3 +21,4 @@
>  obj-$(CONFIG_MACH_RD88F5181L_GE)	+= rd88f5181l-ge-setup.o
>  obj-$(CONFIG_MACH_RD88F5181L_FXO)	+= rd88f5181l-fxo-setup.o
>  obj-$(CONFIG_MACH_RD88F6183AP_GE)	+= rd88f6183ap-ge-setup.o
> +obj-$(CONFIG_MACH_LINKSTATION_LSCHL)   += ls-chl-setup.o
> 
> 


Nicolas
