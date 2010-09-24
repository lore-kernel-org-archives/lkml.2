Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899Ab0IXVaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 17:30:14 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49181 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab0IXVaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 17:30:12 -0400
Date: Fri, 24 Sep 2010 14:30:09 -0700
From: Vernon Mauery <vernux@us.ibm.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode driver -v5
Message-ID: <20100924213009.GF10777@lucy>
References: <20100921224610.GO13162@lucy>
 <20100923221253.GA4960@lucy>
 <20100923225346.GB4960@lucy>
 <201009241512.39311.arnd@arndb.de>
 <AANLkTimMWAk22gSn2cXA25VNJ1o3OX-mazJfFFd_+MH2@mail.gmail.com>
 <20100924095625.5beedf5a.rdunlap@xenotime.net>
 <20100924210642.GE10777@lucy>
 <20100924142006.a79833ab.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20100924142006.a79833ab.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24-Sep-2010 02:20 PM, Randy Dunlap wrote:
>On Fri, 24 Sep 2010 14:06:42 -0700 Vernon Mauery wrote:
>
>> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
>> index cff7cc2..5fba368 100644
>> --- a/drivers/platform/x86/Kconfig
>> +++ b/drivers/platform/x86/Kconfig
>> @@ -590,4 +590,20 @@ config INTEL_IPS
>>  	  functionality.  If in doubt, say Y here; it will only load on
>>  	  supported platforms.
>>
>> +config IBM_RTL
>> +	tristate "Device driver to enable PRTL support"
>> +	depends on X86 && PCI
>> +	---help---
>> +	  Enable support for IBM Premium Real Time Mode (PRTM).
>> +	  This module will allow you the enter and exit PRTM in the BIOS via
>> +	  sysfs on platforms that support this feature.  System in PRTM will
>> +	  not recive CPU-generated SMIs for recoverable errors.  Use of this
>
>	      receive (again/still)

Ack. Again.

>> +	  feature without proper support may void your hardware warranty.
>> +
>> +	  If the proper BIOS support is found the driver will load and create
>> +	  /sys/devices/system/ibm_rtl/.  The "state" variable will indicate
>> +	  whether or not the BIOS is in PRTM.
[snip]
>> +#include <linux/delay.h>
>> +#include <linux/module.h>
>> +#include <linux/io.h>
>> +#include <linux/sysdev.h>
>> +#include <linux/dmi.h>
>> +#include <linux/mutex.h>
>> +#include <asm/bios_ebda.h>
>> +
>> +static int force;
>
>s/int/bool/
>
>> +module_param(force, bool, 0);
>> +MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
>> +
>> +static int debug;
>
>s/int/bool/

Ack.

>> +module_param(debug, bool, 0644);
>> +MODULE_PARM_DESC(debug, "Show debug output");
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Keith Mannthey <kmmanth@us.ibm.com>");
>> +MODULE_AUTHOR("Vernon Mauery <vernux@us.ibm.com>");
>> +
>> +#define RTL_ADDR_TYPE_IO    1
>> +#define RTL_ADDR_TYPE_MMIO  2
>> +
>> +#define RTL_CMD_ENTER_PRTM  1
>> +#define RTL_CMD_EXIT_PRTM   2
>> +
>> +/* The RTL table as presented by the EBDA: */
>> +struct ibm_rtl_table {
>> +	char signature[5];
>
>Question:  are all 5 bytes of signature[] used?  It looks like the search code
>only checks for 32 bits of signature (and the last byte can be garbage?).

Technically, the 5 bytes are supposed to be "_RTL_", but it is a lot 
easier to just check _RTL since we can do that with a single read.  I 
suppose I could do a 64-bit read and mask the bits that matter.  Do you 
have an opinion on the matter?

>> +	u8 version;
>> +	u8 rt_status;
>> +	u8 command;
>> +	u8 command_status;
>> +	u8 cmd_address_type;
>> +	u8 cmd_granularity;
>> +	u8 cmd_offset;
>> +	u16 reserve1;
>> +	u32 cmd_port_address; /* platform dependent address */
>> +	u32 cmd_port_value;   /* platform dependent value */
>> +} __attribute__((packed));
>> +
>> +#define RTL_SIGNATURE (('L'<<24)|('T'<<16)|('R'<<8)|'_')
>> +
>> +#define RTL_DEBUG(A, ...) do { \
>> +	if (debug) \
>> +		pr_info("ibm-rtl: " A, ##__VA_ARGS__ ); \
>> +} while (0)
>> +
>> +static DEFINE_MUTEX(rtl_lock);
>> +static struct ibm_rtl_table __iomem *rtl_table;
>> +static void __iomem *ebda_map;
>> +static void __iomem *rtl_cmd_addr;
>> +static u8 rtl_cmd_type;
>> +static u8 rtl_cmd_width;
>
>...
>
>> +static int __init ibm_rtl_init(void) {
>> +	unsigned long ebda_addr, ebda_size;
>> +	unsigned int ebda_kb;
>> +	int ret = -ENODEV, i;
>> +
>> +	if (force)
>> +		pr_warning("ibm-rtl: module loaded by force!\n");
>
>Please drop the '!'.

Ack.

--Vernon
