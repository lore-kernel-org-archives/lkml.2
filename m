Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab2KIQgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:36:13 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36633 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab2KIQgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:36:09 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6v6zHcq=99JVvhNBe8DuWhyaZ_ojFai9=J2Yuu2TZw1MQ@mail.gmail.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <3455360.Z6cZSC3BtR@vostro.rjw.lan> <CAErSpo5xEO4M_Fb0dJ6w7Qxck-0RcKKwQjKj1QZgFxhof7X5Rw@mail.gmail.com>
 <1523215.Pon1eKPQDb@vostro.rjw.lan> <20121107095608.GX24532@intel.com>
 <CAErSpo5My6+ypp9zsxR8vh8k1px0otOWfAcacWaLNs2xjsc7UA@mail.gmail.com>
 <20121108200445.GC16012@intel.com> <CAErSpo7WT21rZ10vx9A4d8VtVaJB7FLeJqVAxKmZrZDy01FPZQ@mail.gmail.com>
 <CACxGe6v6zHcq=99JVvhNBe8DuWhyaZ_ojFai9=J2Yuu2TZw1MQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 9 Nov 2012 09:35:46 -0700
Message-ID: <CAErSpo4V-0Tnaf__fKUHM_69tBvfLySWzaoCWha9gimx0va1-w@mail.gmail.com>
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 8:45 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, Nov 9, 2012 at 3:11 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> [+cc Greg, Peter, Tony since they acked the original patch [1]]
>>
>> On Thu, Nov 8, 2012 at 1:04 PM, Mika Westerberg
>> <mika.westerberg@linux.intel.com> wrote:
>>> On Thu, Nov 08, 2012 at 12:32:25PM -0700, Bjorn Helgaas wrote:
>>>> Struct device_driver is a generic structure, so it seems strange to
>>>> have to include non-generic things like of_device_id and now
>>>> acpi_match_table there.
>>>
>>> Yes, but in a sense the DT and ACPI are "generic". So that they are used to
>>> describe the configuration of a machine.
>>
>> What I meant by "generic" was "useful across all architectures."  The
>> new acpi_match_table and acpi_handle fields [1] are not generic in
>> that sense because they're present on all architectures but used only
>> on x86 and ia64.  The existing of_match_table and of_node are
>> similarly unused on many architectures.  This doesn't seem like a
>> scalable strategy to me.  Are we going to add a pnpbios_node for x86
>> PNPBIOS machines without ACPI, a pdc_hpa for parisc machines with PDC,
>> etc.?
>>
>> [1] https://patchwork.kernel.org/patch/1677221/
>
> Ultimately yes, I think that is what we want to do,

Just to be clear, you think we *should* add things like pnpbios_node,
pdc_hpa, etc., to struct device, one field for every scheme of telling
the OS about non-enumerable devices, where only one of the N fields is
used on any given machine?  That seems surprising to me, but maybe I
just need to be educated :)

> but there is first
> the non-trivial problem to solve of figuring out how ACPI/DT/whatever
> data maps into what the driver expects. For example, say a device uses
> two GPIOs (A & B) and we have a generic get_gpio(int index) function
> that works for both ACPI and DT. But what if the ACPI binding has the
> gpios in the order A,B and DT orders them B,A? I do want to coordinate
> between the DT and ACPI camps to avoid those situations as much as
> possible, but they will happen. When they do the driver will still
> need firmware specific data. It doesn't make any sense to put that
> stuff outside the driver because only that specific driver needs the
> extra information.

Sure.  This seems like just a special case of "drivers need a way to
access the underlying ACPI/DT/whatever-specific functionality," e.g.,

    gpio = get_gpio(dev, dev_is_acpi(dev) ? 1 : 0);
