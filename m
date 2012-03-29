Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2C2H2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 03:28:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:34285 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab2C2H2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 03:28:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="82951973"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "Brown, Len" <len.brown@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        Jan Beulich <jbeulich@suse.com>, "Li, Shaohua" <shaohua.li@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: RE: [Xen-devel] [PATCH 1/2] RFC: Prepare PAD for native and	xen
 platform
Thread-Topic: [Xen-devel] [PATCH 1/2] RFC: Prepare PAD for native and	xen
 platform
Thread-Index: AQHNDCf6qmcRrTC4dkmeB7vjruTwoZaA0n8AgAAPEvA=
Date: Thu, 29 Mar 2012 07:27:47 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233510F5C5@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923350AD088@SHSMSX101.ccr.corp.intel.com>
 <4F46530B020000780007F751@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923350AD9BB@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923350B2013@SHSMSX101.ccr.corp.intel.com>
 <20120226173458.GB18098@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923350B9496@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923350BAC09@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC8292335105EFA@SHSMSX101.ccr.corp.intel.com>
 <20120326164835.GE10236@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC829233510F52B@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233510F52B@SHSMSX101.ccr.corp.intel.com>
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

Liu, Jinsong wrote:
> Konrad Rzeszutek Wilk wrote:
>>>> Compare approaches:
>>>> 
>>>> 1. xen overwritten approach (patches V2, x86_init, osl approach)
>>>>         Pros: a little simpler code
>>>>     Cons:
>>>>         1). specific to xen, cannot extend to other virt platform;
>>>>         2). need to change natvie acpi_pad as modular;
>>>> 
>>>> 2. paravirt interface approach (original patches V1)     Pros:
>>>>         1). standard hypervisor-agnostic interface (USENIX
>>>>         conference 2006), can easily hook to Xen/lguest/... on
>>>>         demand; 2). arch independent; 3). no need to change native
>>>>         acpi_pad as     non-modular; Cons: a little complicated
>>>> code, and code patching is some
>>>> overkilled for this case (but no harm);
>>>> 
>>>> (BTW, in the future we need add more and more pv ops, like
>>>> pv_pm_ops, pv_cpu_hotplug_ops, pv_mem_hotplug_ops, etc. So how
>>>> about add a pv_misc_ops template to handle them all? seems it's a
>>>> common issue). 
>>>> 
>> 
>> I think (and you probabaly have a better idea) is that the maintainer
>> of drivers/acpi/* is not very open to adding in code that only
>> benefits Xen.
> 
> Take paravirt interface approach as example. We only change a little
> about native acpi_pad_init/acpi_pad_exit, intercept it and
> *implicitly* hook to native/paravirt platform (it didn't appear any
> 'xen' 'pv' word in native pad logic). This is what I can find out the
> least change to native pad logic, and it in fact benefits
> (extensiable) to all pv. If this is still not acceptable we have to
> find other way (but I'm not sure) :-)      
> 
>> 
>> If it benefits other architectures (say ARM) then adding in hooks
>> there (in osl for example) makes sense - but I am not sure if ARM
>> has a form of _PUR code/calls it needs to do.
>> 
>> So with that in mind, neither of those options seems proper - as all
>> of them depend on changing something in drivers/acpi/*.
>> 
>> I've one or two suggestions of what could be done to still make this
>> work, but I need you to first see what happens if the native acpi_pad
>> runs under Xen with the latest upstream code (along with three
>> patches that are in a BZ I pointed you too).
> 
> Do you mean test the patch
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blobdiff;f=arch/x86/xen/enlighten.c;h=b132ade26f778f2cfec7c2d5c7b6db48afe424d5;hp=4172af8ceeb363d06912af15bf89e8508752b794;hb=d4c6fa73fe984e504d52f3d6bba291fd76fe49f7;hpb=aab008db8063364dc3c8ccf4981c21124866b395
> ?  

Ah, you want to test https://bugzilla.redhat.com/show_bug.cgi?id=804347
Anyway, I didn't have proper h/w platform, but seems the bug (ioapic) is irrelated to pad thread we are talking?

Thanks,
Jinsong

