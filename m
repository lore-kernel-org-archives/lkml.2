Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030191Ab2EKQ61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:58:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:53492 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760776Ab2EKQ6Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:58:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99033893"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] Xen physical cpus interface (V2)
Thread-Topic: [PATCH 3/3] Xen physical cpus interface (V2)
Thread-Index: AQHNL38KJV8RtIigTTax7Uicx2M6K5bEzH6w
Date: Fri, 11 May 2012 16:58:08 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351BA0B2@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923351B58A3@SHSMSX101.ccr.corp.intel.com>
 <20120511140454.GA13735@phenom.dumpdata.com>
In-Reply-To: <20120511140454.GA13735@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> On Thu, May 10, 2012 at 03:06:14PM +0000, Liu, Jinsong wrote:
>>> From 7aa4cf7c1172e24611dc76163397b8708acacc59 Mon Sep 17 00:00:00
>>> 2001 
>> From: Liu, Jinsong <jinsong.liu@intel.com>
>> Date: Fri, 11 May 2012 06:55:35 +0800
>> Subject: [PATCH 3/3] Xen physical cpus interface
>> 
>> Manage physical cpus in dom0, get physical cpus info and provide sys
>> interface. 
>> 
>> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
>> Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com> ---
>>  .../ABI/testing/sysfs-devices-system-xen_cpu       |   20 +
>>  drivers/xen/Makefile                               |    1 +
>>  drivers/xen/pcpu.c                                 |  374
>>  ++++++++++++++++++++ include/xen/interface/platform.h              
>>  |    8 + include/xen/interface/xen.h                        |    1 +
>>  5 files changed, 404 insertions(+), 0 deletions(-)
>>  create mode 100644
>>  Documentation/ABI/testing/sysfs-devices-system-xen_cpu create mode
>> 100644 drivers/xen/pcpu.c 
>> 
>> diff --git a/Documentation/ABI/testing/sysfs-devices-system-xen_cpu
>> b/Documentation/ABI/testing/sysfs-devices-system-xen_cpu new file
>> mode 100644 index 0000000..9ca02fb --- /dev/null
>> +++ b/Documentation/ABI/testing/sysfs-devices-system-xen_cpu @@ -0,0
>> +1,20 @@ +What:		/sys/devices/system/xen_cpu/
>> +Date:		May 2012
>> +Contact:	Liu, Jinsong <jinsong.liu@intel.com>
>> +Description:
>> +		A collection of global/individual Xen physical cpu attributes +
>> +		Individual physical cpu attributes are contained in
>> +		subdirectories named by the Xen's logical cpu number, e.g.:
>> +		/sys/devices/system/xen_cpu/xen_cpu#/
>> +
>> +
>> +What:		/sys/devices/system/xen_cpu/xen_cpu#/online +Date:		May 2012
>> +Contact:	Liu, Jinsong <jinsong.liu@intel.com>
>> +Description:
>> +		Interface to online/offline Xen physical cpus
>> +
>> +		When running under Xen platform, it provide user interface
>> +		to online/offline physical cpus, except cpu0 due to several
>> +		logic restrictions and assumptions.
>> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
>> index 1d3e763..d12d14d 100644
>> --- a/drivers/xen/Makefile
>> +++ b/drivers/xen/Makefile
>> @@ -19,6 +19,7 @@ obj-$(CONFIG_XEN_PVHVM)			+= platform-pci.o
>>  obj-$(CONFIG_XEN_TMEM)			+= tmem.o
>>  obj-$(CONFIG_SWIOTLB_XEN)		+= swiotlb-xen.o
>>  obj-$(CONFIG_XEN_DOM0)			+= pci.o
>> +obj-$(CONFIG_XEN_DOM0)			+= pcpu.o
>>  obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
>>  obj-$(CONFIG_XEN_PRIVCMD)		+= xen-privcmd.o
>>  obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+= xen-acpi-processor.o
>> diff --git a/drivers/xen/pcpu.c b/drivers/xen/pcpu.c
>> new file mode 100644
>> index 0000000..9014ff1
>> --- /dev/null
>> +++ b/drivers/xen/pcpu.c
>> @@ -0,0 +1,374 @@
>> +/******************************************************************************
>> + * pcpu.c + * Management physical cpu in dom0, get pcpu info and
>> provide sys interface + * + * Copyright (c) 2012 Intel Corporation
>> + * Author: Liu, Jinsong <jinsong.liu@intel.com>
>> + * Author: Jiang, Yunhong <yunhong.jiang@intel.com> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> version 2 + * as published by the Free Software Foundation; or, when
>> distributed + * separately from the Linux kernel or incorporated
>> into other + * software packages, subject to the following license:
>> + * + * Permission is hereby granted, free of charge, to any person
>> obtaining a copy + * of this source file (the "Software"), to deal
>> in the Software without + * restriction, including without
>> limitation the rights to use, copy, modify, + * merge, publish,
>> distribute, sublicense, and/or sell copies of the Software, + * and
>> to permit persons to whom the Software is furnished to do so,
>> subject to + * the following conditions: + * + * The above copyright
>> notice and this permission notice shall be included in + * all
>> copies or substantial portions of the Software. + * + * THE SOFTWARE
>> IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR + *
>> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
>> MERCHANTABILITY, + * FITNESS FOR A PARTICULAR PURPOSE AND
>> NONINFRINGEMENT. IN NO EVENT SHALL THE + * AUTHORS OR COPYRIGHT
>> HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER + * LIABILITY,
>> WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING + *
>> FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
>> DEALINGS + * IN THE SOFTWARE. + */ + +#include <linux/interrupt.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/cpu.h>
>> +#include <linux/stat.h>
>> +#include <linux/capability.h>
>> +
>> +#include <xen/xen.h>
>> +#include <xen/xenbus.h>
>> +#include <xen/events.h>
>> +#include <xen/interface/platform.h>
>> +#include <asm/xen/hypervisor.h>
>> +#include <asm/xen/hypercall.h>
>> +
>> +#define XEN_PCPU "xen_cpu: "
>> +
>> +/*
>> + * @cpu_id: Xen physical cpu logic number
>> + * @flags: Xen physical cpu status flag
>> + * - XEN_PCPU_FLAGS_ONLINE: cpu is online
>> + * - XEN_PCPU_FLAGS_INVALID: cpu is not present
>> + */
>> +struct pcpu {
>> +	struct list_head list;
>> +	struct device dev;
>> +	uint32_t cpu_id;
>> +	uint32_t flags;
>> +};
>> +
>> +static struct bus_type xen_pcpu_subsys = {
>> +	.name = "xen_cpu",
>> +	.dev_name = "xen_cpu",
>> +};
>> +
>> +static DEFINE_MUTEX(xen_pcpu_lock);
>> +
>> +static LIST_HEAD(xen_pcpus);
> 
> So what about the recommendation to get rid of that and
> instead do
> 
> struct pcpu *xen_cpu;

I'm not quite clear your meaning here, do you mean 'LIST_HEAD(xen_pcpus)' instead of 'struct pcpu *xen_cpu'?


> 
> and use that as a list? Meaning
> .. snip..
>> +{
>> +	struct list_head *cur;
>> +	struct pcpu *pcpu;
>> +
>> +	list_for_each(cur, &xen_pcpus) {
>> +		pcpu = list_entry(cur, struct pcpu, list);
>> +		if (pcpu->cpu_id == cpu_id)
>> +			return pcpu;
>> +	}
> 
> do:
> struct pcpu *pcpu;
> 
> list_for_each_entry(pcpu, xen_pcpus, list)
> 	if (pcpu->cpu_id == cpu_id)
> 		return pcpu;
> ?
> 
> and such.

OK for me to update.

Thanks,
Jinsong

