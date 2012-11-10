Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2KJRPM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 12:15:12 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:53209 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab2KJRPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 12:15:09 -0500
MIME-Version: 1.0
In-Reply-To: <24155036.h7GFQbIk2D@vostro.rjw.lan>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <CACxGe6vgYKv92x8qk5dbdA8UJNJPVxT_1p5Mn58NfBfVF3x+iQ@mail.gmail.com>
 <CAErSpo6z26RFZKaO4PuT9L+c3pz9By0UjundbKR7R+0X3dQ5MQ@mail.gmail.com> <24155036.h7GFQbIk2D@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 10 Nov 2012 10:14:47 -0700
Message-ID: <CAErSpo71xh0F=8Q93d+yuxBsd6nxNuRJMwOmeVyN2Y-tnXgo9Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2012 at 4:10 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, November 09, 2012 09:53:26 AM Bjorn Helgaas wrote:
>> On Fri, Nov 9, 2012 at 9:43 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> > On Fri, Nov 9, 2012 at 4:35 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> >> On Fri, Nov 9, 2012 at 8:45 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> >>> On Fri, Nov 9, 2012 at 3:11 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> >>>> [+cc Greg, Peter, Tony since they acked the original patch [1]]
>> >>>>
>> >>>> On Thu, Nov 8, 2012 at 1:04 PM, Mika Westerberg
>> >>>> <mika.westerberg@linux.intel.com> wrote:
>> >>>>> On Thu, Nov 08, 2012 at 12:32:25PM -0700, Bjorn Helgaas wrote:
>> >>>>>> Struct device_driver is a generic structure, so it seems strange to
>> >>>>>> have to include non-generic things like of_device_id and now
>> >>>>>> acpi_match_table there.
>> >>>>>
>> >>>>> Yes, but in a sense the DT and ACPI are "generic". So that they are used to
>> >>>>> describe the configuration of a machine.
>> >>>>
>> >>>> What I meant by "generic" was "useful across all architectures."  The
>> >>>> new acpi_match_table and acpi_handle fields [1] are not generic in
>> >>>> that sense because they're present on all architectures but used only
>> >>>> on x86 and ia64.  The existing of_match_table and of_node are
>> >>>> similarly unused on many architectures.  This doesn't seem like a
>> >>>> scalable strategy to me.  Are we going to add a pnpbios_node for x86
>> >>>> PNPBIOS machines without ACPI, a pdc_hpa for parisc machines with PDC,
>> >>>> etc.?
>> >>>>
>> >>>> [1] https://patchwork.kernel.org/patch/1677221/
>> >>>
>> >>> Ultimately yes, I think that is what we want to do,
>> >>
>> >> Just to be clear, you think we *should* add things like pnpbios_node,
>> >> pdc_hpa, etc., to struct device, one field for every scheme of telling
>> >> the OS about non-enumerable devices, where only one of the N fields is
>> >> used on any given machine?  That seems surprising to me, but maybe I
>> >> just need to be educated :)
>> >
>> > Ah, I see what you're asking.
>> >
>> > In the short term, yes but only because we don't have any other
>> > alternative. What I'd really rather have is a safe way to attach datum
>> > (ie. acpi_device or device_node) to a struct device and get it back
>> > later in a type safe way.
>>
>> Yep, *that* makes perfect sense to me.  Something along these lines, maybe:
>>
>>     #define dev_is_acpi(d)    ((d)->bus == &acpi_bus_type)
>
> No, that's not right.  It won't work for things like SPI and I2C with a
> "backing" ACPI device node anyway (and for PCI too, by the way :-)).
>
>>     #define dev_acpi_handle(d)    (dev_is_acpi(d) ? (acpi_handle)
>> d->datum : NULL)
>
> The problem basically is how we can tell that the given struct device has
> a "backing" object containing device information (e.g. resources) and what
> that "backing" object is.  For device trees that would be a struct device_node
> and for ACPI that would be an acpi_handle or a struct acpi_device etc.  And by
> the way, they _can_ be used simultaneously, in principle.
>
> So we need something like of_node(dev) or acpi_node(dev), but that can't be
> something following two pointers or calling a function just in order to check
> if the pointer _is_ _there_ in either case.
>
> And since we added of_node to struct device at one point, it is only logical to
> treat ACPI in the same way.  If we come up with a better idea _later_, then we
> can convert _all_ things to this new idea, whatever it is.
>
> Are you seriously expecting us to come up with such an idea on the fly just so
> that we can use ACPI support, which already is there in the form of
> archdata.acpi_handle anyway, on equal footing with Device Trees?

Of course not.  I'm just trying to understand where we're headed.
That was not obvious from the patches I've seen so far.
