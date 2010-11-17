Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab0KQKGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 05:06:18 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61190 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab0KQKGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 05:06:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=i6x2bGUhm4CVEVuQWFWQbF68o97/uVPkM+LrleGnpqWJN42rRZvpBO8mfIRoLjN8x7
         Yhrm4UEaNi8UxQDybnlHfTIn+sWxsIn5YCGCAybJ7xNU9ZrLcBuFD3725ghaEtNvbRnv
         FJuk4BUljT22ov0CXHWDCAL2+6WXpu5aAEeHE=
MIME-Version: 1.0
In-Reply-To: <20101117093046.GC11447@linux-sh.org>
References: <20101117064405.18139.57035.sendpatchset@t400s>
	<20101117064415.18139.28996.sendpatchset@t400s>
	<20101117072553.GB10671@linux-sh.org>
	<AANLkTi=coMHw+SZ_2DebQ29GVdAuoxRYPgbMYYkYZAXE@mail.gmail.com>
	<20101117093046.GC11447@linux-sh.org>
Date: Wed, 17 Nov 2010 19:06:13 +0900
Message-ID: <AANLkTimEx0n5KbgfUORQDNo1_ngsAaE_uu3jRmau2qeE@mail.gmail.com>
Subject: Re: [PATCH 01/05] fbdev: sh_mipi_dsi: Remove request/release mem region
From: Magnus Damm <magnus.damm@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de,
        linux-sh@vger.kernel.org, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 6:30 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Wed, Nov 17, 2010 at 05:51:41PM +0900, Magnus Damm wrote:
>> On Wed, Nov 17, 2010 at 4:25 PM, Paul Mundt <lethal@linux-sh.org> wrote:
>> > No. This comes up time and time again for some reason, I'm not sure why
>> > this misconception keeps being propagated (and it's definitely a mistake
>> > I've made myself too!)
>>
>> Perhaps the confusing part is the -EBUSY error case for
>> insert_resource() in platform_device_add() located in
>> drivers/base/platform. Judging by that code it sure looks like there
>> is some kind of conflict management, but probably not enough as you
>> mention below.
>>
> This is conflict management on a different level, and has nothing to do
> with the in-use region case which is separately accounted. It will handle
> duplicate insertion of the same resource, but that doesn't prevent
> multiple users from getting a handle on the same memory within the
> region. request_mem_region() and friends provide this explicitly.

Sure, I'm with you on that.

>> > The current logic is quite correct in what it is doing.
>>
>> It may be correct, but I don't like the smell of it.
>>
>> Sound like begging for trouble to me - to require the majority of the
>> drivers (the simple ones) to call request/release_mem_region() even
>> though by context it's quite obvious that the driver will use
>> resource. It doesn't make sense to pass resources that are not going
>> to be used, does it?
>>
> Begging for trouble is deleting the resource management and hoping for
> the best. Plenty of drivers pass in a large resource and then carve it up
> internally, it's only a detail the driver can work out for itself, and
> this is not knowledge that can be asserted generically.

I'm not saying that you shouldn't do resource management, my point is
that asking each driver to do request_mem_region() is error prone and
it is (or should be) such a common operation that it may make sense to
have some helper code in place.

> You seem to have selectively ignored the MFD example that I cited, but
> there are plenty of non-MFD cases that do this as well. Some drivers do
> follow the one resource per logical abstraction approach that you seem to
> favour, mostly using named resources and groveling with
> platform_get_resource_byname(), but this is hardly the only way to go
> about it, and is by far the exception rather than the rule.

Uhm, for platform drivers only 6 out of 155 were located in
drivers/mfd, so I wouldn't call that very common. But of course, MFD
drivers need to be handled as well.

>> Also, there are quite a few levels of resource handling / conflict
>> checking / device access:
>>
>> 1) board/cpu code - contains struct resource for devices
>> 2) platform_device_add() - insert_resource() does basic checks
>> 3) driver probe() request_mem_region() does more checks, reserves
>> 4) driver probe() ioremap() gets a virtual address range
>> 5) driver uses ioreadN()/iowriteN() on virtual address range
>>
> And each one of these steps is completely orthogonal to the other, so
> what exactly is your point? As it is, these all layer quite cleanly.

Yes, it layers cleanly, but I suspect that a majority of all device
drivers never need this kind of flexibility.

>> The physical range provided by struct resource and the virtual address
>> range from ioremap() are of course different things, but i think there
>> is a bit of overlap there. The driver isn't supposed to be using
>> ioremap() on an I/O memory region that hasn't been locked down with
>> request_mem_region() for instance.

I believe that this overlap means that more optimal interfaces could
be used for a wide range of device drivers.

>> I'd like to see a simplified interface that handles
>> request_mem_region() and ioremap() in the driver code, perhaps
>> together with automatic handling of request_irq(). Perhaps that's
>> difficult in real life, but if possible then that would cut away quite
>> a bit of code.
>>
> The IRQ thing is obviously wholly unrelated and so doesn't factor in, but
> for the memory case you cite it sounds like you're after some devres and
> general helpers akin to what the PCI code has going with things like
> pci_request_regions() and the managed iomap helpers.

The IRQ thing may be unrelated, but I would prefer a higher level of
interrupt request function that operates on platform device or similar
which just goes though all (or some) of the IRQ resources and hooks
them up to interrupt handlers. The mangling of data between struct
resource and interrupt numbers or base address and size are extremely
common - passing some higher level data structure to do a batch
operation of ioremap() or request_irq() would be nice to have IMO.

> Things work reasonably well in PCI land since you have at least a fairly
> logical and consistent abstraction in terms of how the BARs are arranged,
> but even then the request/remap helpers take a BAR mask to work out which
> ones to deal with in what way (your ioremap()'ed window will want to be
> requested, but not all requested windows will want to be remapped). You
> could probably do this for platform devices too if you really wanted to,
> but you're not likely to be able to generalize much beyond that.

I'm mainly interested in platform devices here, so that may be
something to look in to.

> The end result however is that you're still required to deal with
> flagging the region (or the parts of the region your driver is
> immediately concerned with) as busy, so dropping it as you are doing here
> is unacceptable regardless of whether you are using a helper to make life
> easier or not.

I'm not arguing saying that the patch is correct. It's obviously not.
I just happen to dislike the "correct" code.

Please drop this patch from the series and use the recently posted V2
patch that makes use of request_mem_region.:

[PATCH] fbdev: sh_mipi_dsi: Require two I/O resources V2

Thanks,

/ magnus
