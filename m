Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab1LDKf5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 05:35:57 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51109 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1LDKf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 05:35:56 -0500
X-Originating-IP: 217.70.178.138
X-Originating-IP: 83.160.107.163
Date: Sun, 4 Dec 2011 11:34:14 +0100
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Heiko Schocher <hs@denx.de>
Cc: Wolfgang Denk <wd@denx.de>, Vitaly Bordug <vbordug@ru.mvista.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers, char: add U-Boot bootcount driver
Message-ID: <20111204103414.GI30533@darwin>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Heiko Schocher <hs@denx.de>, Wolfgang Denk <wd@denx.de>,
	Vitaly Bordug <vbordug@ru.mvista.com>,
	devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <1322991921-21096-1-git-send-email-hs@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322991921-21096-1-git-send-email-hs@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

some comments inline

El Sun, Dec 04, 2011 at 10:45:21AM +0100 Heiko Schocher ha dit:

> This driver implements the Linux kernel half of the boot count feature -
> the boot counter can only be reset after it is clear that the
> application has been started and is running correctly, which usually
> can only be determined by the application code itself. Thus the reset
> of the boot counter must be done by application code, which thus needs
> an appropriate driver.
> 
> Required feature by the Carrier Grade Linux Requirements Definition;
> see for example document "Carrier Grade Linux Requirements Definition
> Overview V3.0" at
> 
> http://www.linuxfoundation.org/collaborate/workgroups/cgl/requirements#SMM.6.0_Boot_Cycle_Detection
> 
>         Description: OSDL CGL specifies that carrier grade Linux
>         shall provide support for detecting a repeating reboot cycle
> 	due to recurring failures. This detection should happen in
> 	user space before system services are started.
> 
> This driver provides read/write access to the U-Boot bootcounter
> through PROC FS and/or sysFS file.
> 
> The bootcountregister gets configured via DTS.
> for example on the enbw_cmc board:
> 
> bootcount@0x23060 {
>                   compatible = "uboot,bootcount";
>                   reg = <0x23060 0x20>;
>                  };
> 
> original post from:
> http://old.nabble.com/-POWERPC--add-U-Boot-bootcount-driver.-td26804029.html
> 
> Signed-off-by: Heiko Schocher <hs@denx.de>
> Cc: Wolfgang Denk <wd@denx.de>
> Cc: Vitaly Bordug <vbordug@ru.mvista.com>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  .../devicetree/bindings/char/bootcount.txt         |   13 ++
>  drivers/char/Kconfig                               |    7 +
>  drivers/char/Makefile                              |    1 +
>  drivers/char/bootcount.c                           |  210 ++++++++++++++++++++
>  4 files changed, 231 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/char/bootcount.txt
>  create mode 100644 drivers/char/bootcount.c
> 
> diff --git a/Documentation/devicetree/bindings/char/bootcount.txt b/Documentation/devicetree/bindings/char/bootcount.txt
> new file mode 100644
> index 0000000..079a7da
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/char/bootcount.txt
> @@ -0,0 +1,13 @@
> +Bootcount driver
> +
> +Required properties:
> +
> +  - compatible : should be "uboot,bootcount"
> +  - reg: the address of the bootcounter
> +
> +Example:
> +
> +bootcount@1c23000 {
> +	compatible = "uboot,bootcount";
> +	reg = <0x23060 0x20>;
> +};
> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index 4364303..9c5ccab 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -577,6 +577,13 @@ config UV_MMTIMER
>  	  The uv_mmtimer device allows direct userspace access to the
>  	  UV system timer.
>  
> +config BOOTCOUNT
> +	tristate "U-Boot Bootcount driver"
> +	depends on OF
> +	help
> +	  The U-Boot Bootcount driver allows to access the
> +	  bootcounter through procFS or sysFS files.
> +
>  source "drivers/char/tpm/Kconfig"
>  
>  config TELCLOCK
> diff --git a/drivers/char/Makefile b/drivers/char/Makefile
> index 32762ba..a91e18e 100644
> --- a/drivers/char/Makefile
> +++ b/drivers/char/Makefile
> @@ -49,6 +49,7 @@ obj-$(CONFIG_PC8736x_GPIO)	+= pc8736x_gpio.o
>  obj-$(CONFIG_NSC_GPIO)		+= nsc_gpio.o
>  obj-$(CONFIG_GPIO_TB0219)	+= tb0219.o
>  obj-$(CONFIG_TELCLOCK)		+= tlclk.o
> +obj-$(CONFIG_BOOTCOUNT)		+= bootcount.o
>  
>  obj-$(CONFIG_MWAVE)		+= mwave/
>  obj-$(CONFIG_AGP)		+= agp/
> diff --git a/drivers/char/bootcount.c b/drivers/char/bootcount.c
> new file mode 100644
> index 0000000..0ee457f
> --- /dev/null
> +++ b/drivers/char/bootcount.c
> @@ -0,0 +1,210 @@
> +/*
> + * This driver gives access(read/write) to the bootcounter used by u-boot.
> + * Access is supported via procFS and sysFS.
> + *
> + * Copyright 2008 DENX Software Engineering GmbH
> + * Author: Heiko Schocher <hs@denx.de>
> + * Based on work from: Steffen Rumler  (Steffen.Rumler@siemens.com)
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/capability.h>
> +#include <linux/device.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/mm.h>
> +#include <linux/mman.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_device.h>
> +#include <linux/of_platform.h>
> +#include <linux/ptrace.h>
> +#include <linux/uaccess.h>
> +
> +#ifndef CONFIG_PROC_FS
> +#error "PROC FS support must be switched-on"
> +#endif
> +#include <linux/proc_fs.h>
> +
> +#define	UBOOT_BOOTCOUNT_MAGIC_OFFSET	0x04	/* offset of magic number */
> +#define	UBOOT_BOOTCOUNT_MAGIC		0xB001C041 /* magic number value */
> +
> +#define	UBOOT_BOOTCOUNT_PROC_ENTRY	"driver/bootcount"
> +
> +/*
> + * This macro frees the machine specific function from bounds checking and
> + * this like that...
> + */
> +#define PRINT_PROC(fmt, args...) \
> +	do { \
> +		*len += sprintf(buffer + *len, fmt, ##args); \
> +		if (*begin + *len > offset + size) \
> +			return 0; \
> +		if (*begin + *len < offset) { \
> +			*begin += *len; \
> +			*len = 0; \
> +		} \
> +	} while (0)
> +
> +void __iomem *mem;

+static void __iomem *mem;

> +/*
> + * read U-Boot bootcounter
> + */
> +static int
> +read_bootcounter_info(char *buffer, int *len, off_t * begin, off_t offset,
> +		       int size)
> +{
> +	unsigned long magic;
> +	unsigned long counter;
> +
> +

remove second empty line

> +	magic = be32_to_cpu(readl(mem + UBOOT_BOOTCOUNT_MAGIC_OFFSET));
> +	counter = be32_to_cpu(readl(mem));
> +
> +	if (magic == UBOOT_BOOTCOUNT_MAGIC) {
> +		PRINT_PROC("%lu\n", counter);
> +	} else {
> +		PRINT_PROC("bad magic: 0x%lu != 0x%lu\n", magic,
> +			    (unsigned long)UBOOT_BOOTCOUNT_MAGIC);
> +	}

no need for curly braces

> +
> +	return 1;
> +}
> +
> +/*
> + * read U-Boot bootcounter (wrapper)
> + */
> +static int
> +read_bootcounter(char *buffer, char **start, off_t offset, int size,
> +		  int *eof, void *arg)
> +{
> +	int len = 0;
> +	off_t begin = 0;
> +
> +

remove second empty line

> +	*eof = read_bootcounter_info(buffer, &len, &begin, offset, size);
> +
> +	if (offset >= begin + len)
> +		return 0;
> +
> +	*start = buffer + (offset - begin);
> +	return size < begin + len - offset ? size : begin + len - offset;
> +}
> +
> +/*
> + * write new value to U-Boot bootcounter
> + */
> +static int
> +write_bootcounter(struct file *file, const char *buffer, unsigned long count,
> +		   void *data)
> +{
> +	unsigned long magic;
> +
> +	magic = be32_to_cpu(readl(mem + UBOOT_BOOTCOUNT_MAGIC_OFFSET));
> +	if (magic == UBOOT_BOOTCOUNT_MAGIC)
> +		writel(cpu_to_be32(simple_strtol(buffer, NULL, 10)), mem);
> +	else
> +		return -EINVAL;
> +
> +	return count;
> +}
> +
> +/* helper for the sysFS */
> +static int show_str_bootcount(struct device *device,
> +				struct device_attribute *attr,
> +				char *buf)
> +{
> +	int ret = 0;
> +	off_t begin = 0;
> +
> +	read_bootcounter_info(buf, &ret, &begin, 0, 20);
> +	return ret;
> +}
> +static int store_str_bootcount(struct device *dev,
> +			struct device_attribute *attr,
> +			const char *buf,
> +			size_t count)
> +{
> +	write_bootcounter(NULL, buf, count, NULL);
> +	return count;
> +}
> +static DEVICE_ATTR(bootcount, S_IWUSR | S_IRUGO, show_str_bootcount,
> +		store_str_bootcount);
> +
> +static int __devinit bootcount_probe(struct platform_device *ofdev)
> +{
> +	struct device_node *np = of_node_get(ofdev->dev.of_node);
> +	struct proc_dir_entry *bootcount;
> +
> +	mem = of_iomap(np, 0);
> +	if (mem == NULL)
> +		dev_err(&ofdev->dev, "%s couldnt map register.\n", __func__);

return -1; ?

also applies to other error paths in this function. carrying on
without the register mapped or without access to the bootcounter
doesn't seem to make much sense

> +
> +	/* init ProcFS */
> +	bootcount = create_proc_entry(UBOOT_BOOTCOUNT_PROC_ENTRY, 0600, NULL);
> +	if (bootcount == NULL) {
> +		dev_err(&ofdev->dev, "\n%s (%d): cannot create /proc/%s\n",
> +			__FILE__, __LINE__, UBOOT_BOOTCOUNT_PROC_ENTRY);
> +	} else {
> +
> +		bootcount->read_proc = read_bootcounter;
> +		bootcount->write_proc = write_bootcounter;
> +		dev_info(&ofdev->dev, "created \"/proc/%s\"\n",
> +			UBOOT_BOOTCOUNT_PROC_ENTRY);
> +	}
> +
> +	if (device_create_file(&ofdev->dev, &dev_attr_bootcount))
> +		dev_warn(&ofdev->dev, "%s couldnt register sysFS entry.\n",
> +			__func__);
> +
> +	return 0;
> +}
> +
> +static int __devexit bootcount_remove(struct platform_device *ofdev)
> +{
> +	BUG();
> +	return 0;
> +}
> +
> +static const struct of_device_id __devinitconst bootcount_match[] = {
> +	{
> +		.compatible = "uboot,bootcount",
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, bootcount_match);
> +
> +static struct platform_driver bootcount_driver = {
> +	.driver = {
> +		.name = "bootcount",
> +		.of_match_table = bootcount_match,
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = bootcount_probe,
> +	.remove = bootcount_remove,
> +};
> +
> +
> +static int __init uboot_bootcount_init(void)
> +{
> +	return platform_driver_register(&bootcount_driver);
> +}
> +
> +static void __exit uboot_bootcount_cleanup(void)
> +{
> +	if (mem != NULL)
> +		iounmap(mem);
> +	remove_proc_entry(UBOOT_BOOTCOUNT_PROC_ENTRY, NULL);
> +}
> +
> +module_init(uboot_bootcount_init);
> +module_exit(uboot_bootcount_cleanup);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Steffen Rumler <steffen.rumler@siemens.com>");
> +MODULE_DESCRIPTION("Provide (read/write) access to the U-Boot bootcounter via PROC FS");

-- 
Matthias Kaehlcke
Embedded Linux Developer
Amsterdam

          The opposite of love is not hate, it's indifference
                            (Elie Wiesel)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
