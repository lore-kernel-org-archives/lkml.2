Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab1DFUZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:25:50 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3639 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab1DFUZs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:25:48 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        =?utf-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        "Larry Finger" <Larry.Finger@lwfinger.net>,
        "George Kashperko" <george@znau.edu.ua>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Russell King" <rmk@arm.linux.org.uk>, "Arnd Bergmann" <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
 <op.vtisojsk3ri7v4@arend-laptop>
 <BANLkTinubrmryu=Bco5_AVcj_arn7SWZxw@mail.gmail.com>
Date: Wed, 6 Apr 2011 22:25:33 +0200
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vti9ote53ri7v4@arend-laptop>
In-Reply-To: <BANLkTinubrmryu=Bco5_AVcj_arn7SWZxw@mail.gmail.com>
User-Agent: Opera Mail/11.01 (Linux)
X-WSS-ID: 618213663I87187204-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Apr 2011 20:02:20 +0200, Rafał Miłecki <zajec5@gmail.com> wrote:

> 2011/4/6 Arend van Spriel <arend@broadcom.com>:
>> 1. Term Broadcom AI
>>
>
> I'm still little confused with that, let me read old mails, google a
> little, etc. I though AMBA AXI is AI on ARM host, give me some time
> for this.

It is the interconnect or backplane which the cores in the chip are hooked  
up to. See the ARM website for some more info:  
http://www.arm.com/products/system-ip/interconnect/axi/index.php

>
>> 2. Bus registration
>>
>
> You should drop initialization (to do not perform it twice), but
> ChipCommon ops are still allowed. See: bcmai_cc_read32,
> bcmai_cc_write32, bcmai_cc_mask32, bcmai_cc_set32, bcmai_cc_maskset32.
>
> You can simply call:
> bcmai_cc_read32(mydev->bus.drv_cc, CC_REGISTER);
>
> There is nothing stopping you from registering one driver for few
> cores. We do this in b43 for old SSBs with 2 wireless cores. Of course
> this is not possible to use 2 drivers for 1 core at the same time.

So in theory 2 drivers for 2 separate cores can both call  
bcmai_cc_read32(). 2 drivers for 1 core indeed seems a 'little awkward' ;-)

>
>> 3. Device identification
>>
>> The cores are identified by manufacturer, core id and revision in your
>> patch. I would not use the revision because 4 out of 5 times a revision
>> change does indicate a hardware change but no change in programming
>> interface. The enumeration data does contain a more selective field
>> indicating the core class (4 bits following the core identifier). I  
>> suggest
>> to replace the revision field by this class field.
>
> Please tell me sth more about "core class (4 bits following the core
> identifier)". BCMAI_CC_ID_ID is 0x0000FFFF, did you really mean
> 0x000F0000 which is revision? I guess you meant 0x00F00000 which is
> package? Thank you for pointing this, it may be very important. For
> the same reasons I want to have revision, I do not want to miss
> something else that is important. I think we should add package as one
> another core attribute.
>

You found my comment in the code on this. So given your argument above  
that this is an ABI set in stone I propose to add the component class  
instead of having it replace the revision.

>
>> 4. PCI Host interface
>>
>
> No, it is not for b43 only. You are right of course, I'll rename this.
> It's pretty simple (dumb) driver which is just here just to auto-load
> bcmai module for given PCI IDs. You could just register driver for
> 802.11 core and work fine with b43_pci_ai_bridge aside, but it is not
> correct name for this anyway.
>

ack.

>
>> Now for the code comments, see inline remarks below.
>
>> Probably a different name would be better. bcm suggests this is broadcom
>> specific, but it is hardware functionality provided by ARM. Suggestions:
>> axi, axidmp,amba_axi.
>
> Let me read more abouth this.
>
>
>>> +static u32 bcmai_host_pci_aread32(struct bcmai_device *core, u16  
>>> offset)
>>> +{
>>> +       if (unlikely(core->bus->mapped_core != core))
>>> +               bcmai_host_pci_switch_core(core);
>>> +       return ioread32(core->bus->mmio + 0x1000 + offset);
>>> +}
>>
>> Maybe you can replace the 0x1000 with BCMAI_CORE_SIZE (if that was the
>> correct define).
>
> I agree. Probably something like (1 * BCMAI_CORE_SIZE) would be even
> more self-explaining for new developers.
>

great.

>
>
>>> +       bcmai_scan_switch_core(bus, BCMAI_ADDR_BASE);
>>
>> Is BCMAI_ADDR_BASE used in other source file in this module? Otherwise,  
>> it
>> could be defined in this source file only instead of in a header file.
>
> I though we prefer to keep defines in .h in Linux, let me check (Google)  
> for it.
>
>>
>> Probably this list includes some cores that were in old chips, but will
>> never show up in bcmai chips.
>
> Can you point which cores we should keep/drop?

I have that question pending over here.

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

