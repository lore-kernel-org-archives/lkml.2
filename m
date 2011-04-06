Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab1DFSCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 14:02:24 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33316 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab1DFSCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 14:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wG3rCs02Ea1rETsuKUqM7LzxsDkgn5kkeUaC9+54d/PCl5optgaFKqhZWnvuuxA/NZ
         OPOYJgv3XLUOpjyNDd4dmYHBEQN1lAlp4k2Fv51cmPqHrTC6E5+zshuL5R3tlJJHtVcX
         MoJ1GGLuNqvZ7PvihyNf2w5W6M7FCqrJTN/xM=
MIME-Version: 1.0
In-Reply-To: <op.vtisojsk3ri7v4@arend-laptop>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	<op.vtisojsk3ri7v4@arend-laptop>
Date: Wed, 6 Apr 2011 20:02:20 +0200
Message-ID: <BANLkTinubrmryu=Bco5_AVcj_arn7SWZxw@mail.gmail.com>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/6 Arend van Spriel <arend@broadcom.com>:
> 1. Term Broadcom AI
>
> You are referring to this as Broadcom AI. However, there is nothing Broadcom
> specific about this. Basically, this functionality (core enumeration and
> generic core functions) is provided by ARM with the AMBA AXI and named
> Device Management Plugin (abbrev. DMP).

I'm still little confused with that, let me read old mails, google a
little, etc. I though AMBA AXI is AI on ARM host, give me some time
for this.


> 2. Bus registration
>
> The bus registration mandates the use of chipcommon driver if a chipcommon
> core is detected (same for pcie). In brcm80211 driver we access the d11core
> and chipcommon. Is this still possible or should we remove all register
> access to chipcommon from our driver if we were to use bcmai. Also as each
> core is registered as a linux device does that imply a one-on-one relation?
> So one core equals one driver?

You should drop initialization (to do not perform it twice), but
ChipCommon ops are still allowed. See: bcmai_cc_read32,
bcmai_cc_write32, bcmai_cc_mask32, bcmai_cc_set32, bcmai_cc_maskset32.

You can simply call:
bcmai_cc_read32(mydev->bus.drv_cc, CC_REGISTER);

There is nothing stopping you from registering one driver for few
cores. We do this in b43 for old SSBs with 2 wireless cores. Of course
this is not possible to use 2 drivers for 1 core at the same time.


> 3. Device identification
>
> The cores are identified by manufacturer, core id and revision in your
> patch. I would not use the revision because 4 out of 5 times a revision
> change does indicate a hardware change but no change in programming
> interface. The enumeration data does contain a more selective field
> indicating the core class (4 bits following the core identifier). I suggest
> to replace the revision field by this class field.

Well, maybe we don't use core revision all the time, but we do.
1) In the past, we decided if core is supported by b43 or b43legacy
exactly by using core revision
2) For N PHY on SSB we check core revision in b43_nphy_classifier
3) In main.c we check for id.revision a few times
You can say it's all SSB, OK, so:
4) On AI ChipCommon has capabilities_ext on rev >= 35 only
5) PMU init requires "Fix for 4329b0 bad LPOM state", 4329b0 check is
core rev based

So there are few places where we need core revision. If you want to
register driver for every core, you can always use BCMAI_ANY_REV.
Michael mentioned recently that mod_devicetable.h is ABI, so I really
prefer to have one more u8 than end with workarounds.

Please tell me sth more about "core class (4 bits following the core
identifier)". BCMAI_CC_ID_ID is 0x0000FFFF, did you really mean
0x000F0000 which is revision? I guess you meant 0x00F00000 which is
package? Thank you for pointing this, it may be very important. For
the same reasons I want to have revision, I do not want to miss
something else that is important. I think we should add package as one
another core attribute.


> 4. PCI Host interface
>
> When building the PCI host interface variant of the bcmai it compiles in the
> source file b43_pci_ai_bridge.c. This name suggests that this module can
> only be used with b43 driver. Is that a correct observation? I see this as a
> major restriction to using the new module or could another driver (like
> ours) use the bcmai_host_pci_register() function.

No, it is not for b43 only. You are right of course, I'll rename this.
It's pretty simple (dumb) driver which is just here just to auto-load
bcmai module for given PCI IDs. You could just register driver for
802.11 core and work fine with b43_pci_ai_bridge aside, but it is not
correct name for this anyway.


> Now for the code comments, see inline remarks below.

> Probably a different name would be better. bcm suggests this is broadcom
> specific, but it is hardware functionality provided by ARM. Suggestions:
> axi, axidmp,amba_axi.

Let me read more abouth this.


>> +static u32 bcmai_host_pci_aread32(struct bcmai_device *core, u16 offset)
>> +{
>> +       if (unlikely(core->bus->mapped_core != core))
>> +               bcmai_host_pci_switch_core(core);
>> +       return ioread32(core->bus->mmio + 0x1000 + offset);
>> +}
>
> Maybe you can replace the 0x1000 with BCMAI_CORE_SIZE (if that was the
> correct define).

I agree. Probably something like (1 * BCMAI_CORE_SIZE) would be even
more self-explaining for new developers.


>> +       if (!pci_is_pcie(dev))
>> +               bcmai_err("PCI card detected, report problems.\n");
>
> Not that I know off with Broadcom chips. Can ask around here, but I don't
> know about other manufacturers. Not even sure if there are others using the
> AMBA AXI DMP functionality.

The purpose was to track existence of PCI cards to implement XTAL
manual powering up in case of problems. Maybe we could drop this but
on the other hand it's just a one small single check once-executed.
And it seems Broadcom didn't abound PCI cards long, long time ago as I
have mini PCI 14e4:4329 with BCM4321.


>> +               core->dev.release = bcmai_release_core_dev;
>> +               core->dev.bus = &bcmai_bus_type;
>> +               dev_set_name(&core->dev, "ssbX:%d", /*bus->busnumber,*/
>> dev_id);
>
> The device name should probably start with something other than 'ssb' ;-)

Whoops! ;)


>> +static u32 bcmai_scan_read32(struct bcmai_bus *bus, u8 current_coreidx,
>> +                      u16 offset)
>> +{
>> +       return readl(bus->mmio + offset);
>> +}
>
> I have seen both ioread32() and readl() in this patch. Are these doing the
> same thing?

This readl is used while scanning, when we don't use host native
functions as they are core-based. Not sure if we can use ioread32 for
embedded systems without host device.


>> +       bcmai_scan_switch_core(bus, BCMAI_ADDR_BASE);
>
> Is BCMAI_ADDR_BASE used in other source file in this module? Otherwise, it
> could be defined in this source file only instead of in a header file.

I though we prefer to keep defines in .h in Linux, let me check (Google) for it.


>> +               core.id.id = (cia & SCAN_CIA_ID) >> SCAN_CIA_ID_SHIFT;
>> +               core.id.manuf = (cia & SCAN_CIA_MANUF) >>
>> SCAN_CIA_MANUF_SHIFT;
>
> You can also get the component class here. Next 4 bits in cia.

Ahh, now I see your explanation here, thanks, I'll check this! Ignore
me previous question about class for now.


>> +#define bcmai_info(fmt, args...)       printk(KERN_INFO "bcmai: " fmt,
>> ##args)
>> +#ifdef CONFIG_BCMAI_DEBUG
>> +#define bcmai_dbg(fmt, args...)                printk(KERN_DEBUG "bcmai
>> debug: " fmt, ##args)
>> +#else
>> +#define bcmai_dbg(fmt, args...)                do { } while (0)
>> +#endif
>> +#define bcmai_err(fmt, args...)                printk(KERN_ERR "bcmai
>> error: " fmt, ##args)
>> +
>
> Would go for the pr_... functions. I used that in brcmaxi.

I got comments to that already, will fix.


>> +#define BCMAI_CORE_(...)
>> +#define BCMAI_CORE_SHIM                        0x837   /* SHIM component
>> in ubus/6362 */
>> +#define BCMAI_CORE_DEFAULT             0xFFF
>
> Probably this list includes some cores that were in old chips, but will
> never show up in bcmai chips.

Can you point which cores we should keep/drop?


>> +#define   SSB_PLLTYPE_5                        0x00018000      /* 25Mhz,
>> 4 dividers */
>> +#define   SSB_PLLTYPE_6                        0x00028000      /* 100/200
>> or 120/240 only */
>> +#define   SSB_PLLTYPE_7                        0x00038000      /* 25Mhz,
>> 4 dividers */
>
> Here and below there are quite some definitions still starting with SSB.

Right, I still have some defines to clean/drop in cc pmu.h

-- 
Rafał
