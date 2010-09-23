Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0IWViy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:38:54 -0400
Received: from xenotime.net ([72.52.115.56]:55540 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754133Ab0IWVix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:38:53 -0400
Date: Thu, 23 Sep 2010 14:38:49 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Vernon Mauery <vernux@us.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode driver -v3
Message-Id: <20100923143849.ad29d0ad.rdunlap@xenotime.net>
In-Reply-To: <20100921224610.GO13162@lucy>
References: <20100921224610.GO13162@lucy>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010 15:46:10 -0700 Vernon Mauery wrote:

> IBM Real-Time "SMI Free" mode driver
> 
> Signed-off-by: Vernon Mauery <vernux@us.ibm.com>
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index cff7cc2..16ba6e6 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -590,4 +590,20 @@ config INTEL_IPS
>   	  functionality.  If in doubt, say Y here; it will only load on
>   	  supported platforms.
>   
> +config IBM_RTL
> +	tristate "Device driver to enable PRTL support"
> +	depends on X86 && PCI
> +	---help---
> +	  Enable support for IBM Preimium Real Time Mode (PRTM).

	What is Preimium?

> +	  This module will allow you the enter and exit PRTM in the BIOS via
> +	  sysfs on platforms that support this feature.  System in PRTM will
> +	  not recive cpu generated SMIs for recoverable errors.  Use of this

	      receive CPU-generated

> +	  feature without proper support may void your hardware warrenty.

	                                                        warranty.

> +
> +	  If the proper bios support is found the driver will load and create

	                BIOS

> +	  /sys/devices/system/ibm_rtl/.  The "state" varable will indicate

	                                             variable

> +	  weather or not the BIOS is in PRTM.

	  whether

> +	  state = 0 (BIOS SMI's on)
> +	  state = 1 (BIOS SMI's off)
> +
>   endif # X86_PLATFORM_DEVICES

> diff --git a/drivers/platform/x86/ibm_rtl.c b/drivers/platform/x86/ibm_rtl.c
> new file mode 100644
> index 0000000..37bf610
> --- /dev/null
> +++ b/drivers/platform/x86/ibm_rtl.c
> @@ -0,0 +1,352 @@
> +/*
> + * IBM Real-Time Linux driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright (C) IBM Corporation, 2010
> + *
> + * Author: Keith Mannthey <kmannth@us.ibm.com>
> + *         Vernon Mauery <vernux@us.ibm.com>
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/delay.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/sysdev.h>
> +#include <linux/dmi.h>
> +#include <asm/bios_ebda.h>
> +#include <linux/mutex.h>

<asm> after all <linux> headers, please.

> +
> +static int force;
> +module_param(force, bool, 0);
> +MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
> +
> +static int debug;
> +module_param(debug, bool, 0644);
> +MODULE_PARM_DESC(debug, "Show debug output");
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Keith Mannthey <kmmanth@us.ibm.com>");
> +MODULE_AUTHOR("Vernon Mauery <vernux@us.ibm.com>");
> +
> +enum rtl_addr_type {
> +	RTL_ADDR_TYPE_IO = 1,
> +	RTL_ADDR_TYPE_MMIO,
> +} __attribute__((packed));
> +
> +enum rtl_cmd_type {
> +	RTL_CMD_NOP = 0,
> +	RTL_CMD_ENTER_PRTM,
> +	RTL_CMD_EXIT_PRTM,
> +} __attribute__((packed));

What does packed do to an enum list?

> +
> +/* The RTL table looks something like: */

Unsure of this?

> +struct ibm_rtl_table {
> +	char signature[5];
> +	u8 version;
> +	u8 rt_status;
> +	enum rtl_cmd_type command;
> +	u8 command_status;
> +	enum rtl_addr_type cmd_address_type;
> +	u8 cmd_granularity;
> +	u8 cmd_offset;
> +	u16 reserve1;
> +	u8 cmd_port_address[4]; /* platform dependent address */
> +	u8 cmd_port_value[4];   /* platform dependent value */
> +};
> +
> +#define RTL_SIGNATURE (('L'<<24)|('T'<<16)|('R'<<8)|'_')
> +
> +#define ERROR(A, B...) printk(KERN_ERR "ibm-rtl: " A, ##B )
> +#define WARNING(A, B...) printk(KERN_WARNING "ibm-rtl: " A, ##B )
> +#define DEBUG(A, B...) do { \
> +	if (debug) \
> +		printk(KERN_INFO "ibm-rtl: " A, ##B ); \
> +} while (0)
> +
> +DEFINE_MUTEX(rtl_lock);

static DEFINE_MUTEX(rtl_lock);

> +static struct ibm_rtl_table __iomem *rtl_table = NULL;
> +static void __iomem *ebda_map;
> +static void __iomem *rtl_cmd_iomem_addr = NULL;
> +static u32 rtl_cmd_port_addr;
> +static enum rtl_addr_type rtl_cmd_type;
> +static u8 rtl_cmd_width;


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
