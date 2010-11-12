Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0KLIrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 03:47:09 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:38593 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab0KLIrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 03:47:07 -0500
Date: Fri, 12 Nov 2010 00:47:01 -0800
From: Andres Salomon <dilinger@queued.net>
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-geode@lists.infradead.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        cjb@laptop.org, dsd@laptop.org
Subject: Re: [PATCH 1/4] MFD: add cs5535-mfd driver for CS5535/CS5536
 support
Message-ID: <20101112004701.4dd43d63@queued.net>
In-Reply-To: <20101023004102.674cdc45@queued.net>
References: <20101023004102.674cdc45@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Has anyone had the chance to take a look at this set of patches?



On Sat,
23 Oct 2010 00:41:02 -0700 Andres Salomon <dilinger@queued.net> wrote:

> 
> Add an MFD driver to handle the ISA device on CS5535 and CS5536
> southbridges. This ISA bridge is actually multiple devices; GPIOs,
> MFGPTs, etc.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  drivers/mfd/Kconfig      |    8 +++
>  drivers/mfd/Makefile     |    1 +
>  drivers/mfd/cs5535-mfd.c |  151
> ++++++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 160
> insertions(+), 0 deletions(-) create mode 100644
> drivers/mfd/cs5535-mfd.c
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index db51ea1..b72627b 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -495,6 +495,14 @@ config AB3550_CORE
>  	  LEDs, vibrator, system power and temperature, power
> management and ALSA sound.
>  
> +config MFD_CS5535
> +	tristate "Support for CS5535 and CS5536 southbridge core
> functions"
> +	select MFD_CORE
> +	depends on PCI
> +	---help---
> +	  This is the core driver for CS5535/CS5536 MFD functions.
> This is
> +          necessary for using the board's GPIO and MFGPT
> functionality. +
>  config MFD_TIMBERDALE
>  	tristate "Support for the Timberdale FPGA"
>  	select MFD_CORE
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index feaeeae..3d1b41a 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -69,6 +69,7 @@ obj-$(CONFIG_AB3100_CORE)	+= ab3100-core.o
>  obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
>  obj-$(CONFIG_AB3550_CORE)	+= ab3550-core.o
>  obj-$(CONFIG_AB8500_CORE)	+= ab8500-core.o ab8500-spi.o
> +obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
>  obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
>  obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
>  obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
> diff --git a/drivers/mfd/cs5535-mfd.c b/drivers/mfd/cs5535-mfd.c
> new file mode 100644
> index 0000000..b141ca7
> --- /dev/null
> +++ b/drivers/mfd/cs5535-mfd.c
> @@ -0,0 +1,151 @@
> +/*
> + * cs5535-mfd.c - core MFD driver for CS5535/CS5536 southbridges
> + *
> + * The CS5535 and CS5536 has an ISA bridge on the PCI bus that is
> + * used for accessing GPIOs, MFGPTs, ACPI, etc.  Each subdevice has
> + * an IO range that's specified in a single BAR.  The BAR order is
> + * hardcoded in the CS553x specifications.
> + *
> + * Copyright (c) 2010  Andres Salomon <dilinger@queued.net>
> + *
> + * This program is free software; you can redistribute it and/or
> modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/mfd/core.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +
> +#define DRV_NAME "cs5535-mfd"
> +
> +enum cs5535_mfd_bars {
> +	SMB_BAR = 0,
> +	GPIO_BAR = 1,
> +	MFGPT_BAR = 2,
> +	PMS_BAR = 4,
> +	ACPI_BAR = 5,
> +	NR_BARS,
> +};
> +
> +static __devinitdata struct resource cs5535_mfd_resources[NR_BARS];
> +
> +static __devinitdata struct mfd_cell cs5535_mfd_cells[] = {
> +	{
> +		.id = SMB_BAR,
> +		.name = "cs5535-smb",
> +		.num_resources = 1,
> +		.resources = &cs5535_mfd_resources[SMB_BAR],
> +	},
> +	{
> +		.id = GPIO_BAR,
> +		.name = "cs5535-gpio",
> +		.num_resources = 1,
> +		.resources = &cs5535_mfd_resources[GPIO_BAR],
> +	},
> +	{
> +		.id = MFGPT_BAR,
> +		.name = "cs5535-mfgpt",
> +		.num_resources = 1,
> +		.resources = &cs5535_mfd_resources[MFGPT_BAR],
> +	},
> +	{
> +		.id = PMS_BAR,
> +		.name = "cs5535-pms",
> +		.num_resources = 1,
> +		.resources = &cs5535_mfd_resources[PMS_BAR],
> +	},
> +	{
> +		.id = ACPI_BAR,
> +		.name = "cs5535-acpi",
> +		.num_resources = 1,
> +		.resources = &cs5535_mfd_resources[ACPI_BAR],
> +	},
> +};
> +
> +static int __devinit cs5535_mfd_probe(struct pci_dev *pdev,
> +		const struct pci_device_id *id)
> +{
> +	int err, i;
> +
> +	err = pci_enable_device(pdev);
> +	if (err)
> +		return err;
> +
> +	/* fill in IO range for each cell; subdrivers handle the
> region */
> +	for (i = 0; i < ARRAY_SIZE(cs5535_mfd_cells); i++) {
> +		int bar = cs5535_mfd_cells[i].id;
> +		struct resource *r = &cs5535_mfd_resources[bar];
> +
> +		r->flags = IORESOURCE_IO;
> +		r->start = pci_resource_start(pdev, bar);
> +		r->end = pci_resource_end(pdev, bar);
> +
> +		/* id is used for temporarily storing BAR; unset it
> now */
> +		cs5535_mfd_cells[i].id = 0;
> +	}
> +
> +	err = mfd_add_devices(&pdev->dev, -1, cs5535_mfd_cells,
> +			ARRAY_SIZE(cs5535_mfd_cells), NULL, 0);
> +	if (err) {
> +		dev_err(&pdev->dev, "MFD add devices failed: %d\n",
> err);
> +		goto err_disable;
> +	}
> +
> +	dev_info(&pdev->dev, "%d devices registered.\n",
> +			ARRAY_SIZE(cs5535_mfd_cells));
> +
> +	return 0;
> +
> +err_disable:
> +	pci_disable_device(pdev);
> +	return err;
> +}
> +
> +static void __devexit cs5535_mfd_remove(struct pci_dev *pdev)
> +{
> +	mfd_remove_devices(&pdev->dev);
> +	pci_disable_device(pdev);
> +}
> +
> +static struct pci_device_id cs5535_mfd_pci_tbl[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_NS,
> PCI_DEVICE_ID_NS_CS5535_ISA) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_AMD,
> PCI_DEVICE_ID_AMD_CS5536_ISA) },
> +	{ 0, }
> +};
> +MODULE_DEVICE_TABLE(pci, cs5535_mfd_pci_tbl);
> +
> +static struct pci_driver cs5535_mfd_drv = {
> +	.name = DRV_NAME,
> +	.id_table = cs5535_mfd_pci_tbl,
> +	.probe = cs5535_mfd_probe,
> +	.remove = __devexit_p(cs5535_mfd_remove),
> +};
> +
> +static int __init cs5535_mfd_init(void)
> +{
> +	return pci_register_driver(&cs5535_mfd_drv);
> +}
> +
> +static void __exit cs5535_mfd_exit(void)
> +{
> +	pci_unregister_driver(&cs5535_mfd_drv);
> +}
> +
> +module_init(cs5535_mfd_init);
> +module_exit(cs5535_mfd_exit);
> +
> +MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
> +MODULE_DESCRIPTION("MFD driver for CS5535/CS5536 southbridge's ISA
> PCI device"); +MODULE_LICENSE("GPL");
