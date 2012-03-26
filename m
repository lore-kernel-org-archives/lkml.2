Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab2CZGSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 02:18:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:27072 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab2CZGSk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 02:18:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="123199454"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "lenb@kernel.org" <lenb@kernel.org>, "Brown, Len" <len.brown@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        Jan Beulich <JBeulich@suse.com>, "Li, Shaohua" <shaohua.li@intel.com>
Subject: RE: [PATCH 2/2] RFC: Xen pad logic
Thread-Topic: [PATCH 2/2] RFC: Xen pad logic
Thread-Index: AQHNAXiUBtnyvxlNak+k12uiQDconZZ8I2aQ
Date: Mon, 26 Mar 2012 06:18:36 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335105DB9@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923350AD0A6@SHSMSX101.ccr.corp.intel.com>
 <20120314001833.GB20363@phenom.dumpdata.com>
In-Reply-To: <20120314001833.GB20363@phenom.dumpdata.com>
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
> On Thu, Feb 23, 2012 at 01:31:25PM +0000, Liu, Jinsong wrote:
>>> From ba9abf6ee7e5fe0515e2d51b14743c8d5416285c Mon Sep 17 00:00:00
>>> 2001 
>> From: Liu, Jinsong <jinsong.liu@intel.com>
>> Date: Fri, 24 Feb 2012 02:18:02 +0800
>> Subject: [PATCH 2/2] Xen pad logic
>> 
>> This patch implement Xen pad logic, and when getting pad device
>> notification, it hypercalls to Xen hypervisor for core parking.
> 
> Can you explain to me how and what pad device is? And how it functions
> right now in baremetal? And what kind of hardware do you need to use
> this? 
> And what happens if you do not use it? Can one ignore the "pad"
> support? 
> Please assume that I've a basic understanding of ACPI.
> 
> 
> Also, what happens now, if the this patch is not implemented? What
> will/is dom0 doing without these patches (so 3.2 for example on this
> machine)? 
> Is it just idling using mwait on idle CPUs and ending up trapping in
> the hypervisor? Or is not mwaiting since the cstate.c doesn't get
> executed since we have: 
> 
>        boot_option_idle_override = IDLE_HALT;
> 
> in arch/x86/xen/setup.c ?


Pad is an ACPI device used to direct os taking some action (depend on os itsef) for the sake of power consumption. 2 objs (PUR and OST) could be declared under PAD and as bios/os interface.

PAD itself is pointless, unless it co-work with some external power control s/w (like NPTM). For example currently in baremetal, NPTM engine trigger sci to ospm, then evaluate and call sci handler, through which bios notify os with PUR value by which os could take corresponding action and feedback bios through OST. I don't think it's a problem if user don't use PAD or ignore it, it only make some external power control s/w unuseable.

As for how os handle pad notify is os business. Native kernel use round robin and mwait, considering some app workload affinity (I was told so). For xen we don't need care it since it's a question of vcpu level. For xen acpi_pad, dom0 patches used to parse PUR and hypercall to hypervisor, which in turn idle pcpu by its own algorithm.

Thanks,
Jinsong