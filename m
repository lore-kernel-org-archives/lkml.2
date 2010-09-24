Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab0IXVUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 17:20:12 -0400
Received: from xenotime.net ([72.52.115.56]:35852 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754778Ab0IXVUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 17:20:10 -0400
Date: Fri, 24 Sep 2010 14:20:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Vernon Mauery <vernux@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode driver -v5
Message-Id: <20100924142006.a79833ab.rdunlap@xenotime.net>
In-Reply-To: <20100924210642.GE10777@lucy>
References: <20100921224610.GO13162@lucy>
	<20100923221253.GA4960@lucy>
	<20100923225346.GB4960@lucy>
	<201009241512.39311.arnd@arndb.de>
	<AANLkTimMWAk22gSn2cXA25VNJ1o3OX-mazJfFFd_+MH2@mail.gmail.com>
	<20100924095625.5beedf5a.rdunlap@xenotime.net>
	<20100924210642.GE10777@lucy>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 14:06:42 -0700 Vernon Mauery wrote:

> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index cff7cc2..5fba368 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -590,4 +590,20 @@ config INTEL_IPS
>  	  functionality.  If in doubt, say Y here; it will only load on
>  	  supported platforms.
>  
> +config IBM_RTL
> +	tristate "Device driver to enable PRTL support"
> +	depends on X86 && PCI
> +	---help---
> +	  Enable support for IBM Premium Real Time Mode (PRTM).
> +	  This module will allow you the enter and exit PRTM in the BIOS via
> +	  sysfs on platforms that support this feature.  System in PRTM will
> +	  not recive CPU-generated SMIs for recoverable errors.  Use of this

	      receive (again/still)

> +	  feature without proper support may void your hardware warranty.
> +
> +	  If the proper BIOS support is found the driver will load and create
> +	  /sys/devices/system/ibm_rtl/.  The "state" variable will indicate
> +	  whether or not the BIOS is in PRTM.
> +	  state = 0 (BIOS SMIs on)
> +	  state = 1 (BIOS SMIs off)
> +
>  endif # X86_PLATFORM_DEVICES

> diff --git a/drivers/platform/x86/ibm_rtl.c b/drivers/platform/x86/ibm_rtl.c
> new file mode 100644
> index 0000000..2a0a390
> --- /dev/null
> +++ b/drivers/platform/x86/ibm_rtl.c
> @@ -0,0 +1,339 @@
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
> +#include <linux/mutex.h>
> +#include <asm/bios_ebda.h>
> +
> +static int force;

s/int/bool/

> +module_param(force, bool, 0);
> +MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
> +
> +static int debug;

s/int/bool/

> +module_param(debug, bool, 0644);
> +MODULE_PARM_DESC(debug, "Show debug output");
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Keith Mannthey <kmmanth@us.ibm.com>");
> +MODULE_AUTHOR("Vernon Mauery <vernux@us.ibm.com>");
> +
> +#define RTL_ADDR_TYPE_IO    1
> +#define RTL_ADDR_TYPE_MMIO  2
> +
> +#define RTL_CMD_ENTER_PRTM  1
> +#define RTL_CMD_EXIT_PRTM   2
> +
> +/* The RTL table as presented by the EBDA: */
> +struct ibm_rtl_table {
> +	char signature[5];

Question:  are all 5 bytes of signature[] used?  It looks like the search code
only checks for 32 bits of signature (and the last byte can be garbage?).

> +	u8 version;
> +	u8 rt_status;
> +	u8 command;
> +	u8 command_status;
> +	u8 cmd_address_type;
> +	u8 cmd_granularity;
> +	u8 cmd_offset;
> +	u16 reserve1;
> +	u32 cmd_port_address; /* platform dependent address */
> +	u32 cmd_port_value;   /* platform dependent value */
> +} __attribute__((packed));
> +
> +#define RTL_SIGNATURE (('L'<<24)|('T'<<16)|('R'<<8)|'_')
> +
> +#define RTL_DEBUG(A, ...) do { \
> +	if (debug) \
> +		pr_info("ibm-rtl: " A, ##__VA_ARGS__ ); \
> +} while (0)
> +
> +static DEFINE_MUTEX(rtl_lock);
> +static struct ibm_rtl_table __iomem *rtl_table;
> +static void __iomem *ebda_map;
> +static void __iomem *rtl_cmd_addr;
> +static u8 rtl_cmd_type;
> +static u8 rtl_cmd_width;

...

> +static int __init ibm_rtl_init(void) {
> +	unsigned long ebda_addr, ebda_size;
> +	unsigned int ebda_kb;
> +	int ret = -ENODEV, i;
> +
> +	if (force)
> +		pr_warning("ibm-rtl: module loaded by force!\n");

Please drop the '!'.

> +	/* first ensure that we are running on IBM HW */
> +	else if (!dmi_check_system(ibm_rtl_dmi_table))
> +		return -ENODEV;
> +
> +	/* Get the address for the Extended BIOS Data Area */
> +	ebda_addr = get_bios_ebda();
> +	if (!ebda_addr) {
> +		RTL_DEBUG("no BIOS EBDA found\n");
> +		return -ENODEV;
> +	}
> +
> +	ebda_map = ioremap(ebda_addr, 4);
> +	if (!ebda_map)
> +		return -ENOMEM;
> +
> +	/* First word in the EDBA is the Size in KB */
> +	ebda_kb = ioread16(ebda_map);
> +	RTL_DEBUG("EBDA is %d kB\n", ebda_kb);
> +
> +	if (ebda_kb == 0)
> +		goto out;
> +
> +	iounmap(ebda_map);
> +	ebda_size = ebda_kb*1024;
> +
> +	/* Remap the whole table */
> +	ebda_map = ioremap(ebda_addr, ebda_size);
> +	if (!ebda_map)
> +		return -ENOMEM;
> +
> +	/* search for the _RTL_ signature at the start of the table */
> +	for (i = 0 ; i < ebda_size/sizeof(unsigned int); i++) {
> +		struct ibm_rtl_table __iomem * tmp;
> +		tmp = (struct ibm_rtl_table __iomem *) (ebda_map+i);
> +		if (ioread32(&tmp->signature) == RTL_SIGNATURE) {
> +			phys_addr_t addr;
> +			unsigned int plen;
> +			RTL_DEBUG("found RTL_SIGNATURE at %#llx\n", (u64)tmp);
> +			rtl_table = tmp;
> +			/* The address, value, width and offset are platform
> +			 * dependent and found in the ibm_rtl_table */
> +			rtl_cmd_width = ioread8(&rtl_table->cmd_granularity);
> +			rtl_cmd_type = ioread8(&rtl_table->cmd_address_type);
> +			RTL_DEBUG("rtl_cmd_width = %u, rtl_cmd_type = %u\n",
> +			      rtl_cmd_width, rtl_cmd_type);
> +			addr = ioread32(&rtl_table->cmd_port_address);
> +			RTL_DEBUG("addr = %#llx\n", addr);
> +			plen = rtl_cmd_width/sizeof(char);
> +			rtl_cmd_addr = rtl_port_map(addr, plen);
> +			RTL_DEBUG("rtl_cmd_addr = %#llx\n", (u64)rtl_cmd_addr);
> +			if (!rtl_cmd_addr) {
> +				ret = -ENOMEM;
> +				break;
> +			}
> +			ret = rtl_setup_sysfs();
> +			break;
> +		}
> +	}
> +
> +out:
> +	if (ret) {
> +		iounmap(ebda_map);
> +		rtl_port_unmap(rtl_cmd_addr);
> +	}
> +
> +	return ret;
> +}


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
