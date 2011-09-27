Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab1I0PF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 11:05:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57324 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab1I0PF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 11:05:56 -0400
Date: Tue, 27 Sep 2011 09:05:55 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Daniel Drake <dsd@laptop.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Subject: Re: [PATCH 1/3] mfd: allow mfd_cell association with device tree node
Message-ID: <20110927150555.GF20588@ponder.secretlab.ca>
References: <20110921120148.4A81E9D401D@zog.reactivated.net>
 <20110921124936.GA25620@sirena.org.uk>
 <CAMLZHHQZnajC4e12MjaK3W8WcAB2ZB+6L=5kS5BBFZF=+YWicQ@mail.gmail.com>
 <20110921131637.GF4374@opensource.wolfsonmicro.com>
 <CAMLZHHTJaOddSj00g0-WpFQu6pUTqizKjKaQF9hLrhceEMhY1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMLZHHTJaOddSj00g0-WpFQu6pUTqizKjKaQF9hLrhceEMhY1Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 03:44:56PM +0100, Daniel Drake wrote:
> On Wed, Sep 21, 2011 at 2:16 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> >> Not sure how the MFD cells could get at the OF node by using the
> >> parent device - if the parent device had a OF node, wouldn't this
> >> correspond to the parent instead of the child? Also, as far as I can
> >
> > Well, obviously.  But then with a lot of MFDs (including this one, the
> > GPIO driver is entirely specific to the parent) it's not clear that we
> > should be splitting the device up in the device tree in the first place
> > - our use of MFDs is a Linux implementation detail.  If the child is
> > specific to the parent it can cooperate with the parent device happily.
> >
> > My suspicion is that for device tree in cases where the MFD really is
> > totally independent of the parent we shouldn't need explicit MFD code to
> > instantiate the child at all any more in the same way that we should be
> > avoiding this for the SoCs.

Right. MFD seems to be most useful when IP blocks are used in multiple
places and can be instantiated by multiple parents.  Sometimes a
driver really should just register the interfaces that the device
provides without the MFD framework.

> The VX855 is somewhat a SoC if you ignore the fact that the processor
> is separate.
> The software-visible architecture is somewhat messy and may hide this however.
> 
> The fact that it exposes some things as individual PCI devices and
> some as behind the ISA bridge (which the mfd driver latches onto) is
> probably just there for legacy reasons. Once you get behind that
> cover, you see that the VX855 register space is really quite
> disorganised with individual bits within the same byte of
> configuration space used for vastly different system components (e.g.
> gpio bits mixed with acpi and audio stuff in the same byte) and you
> get the feeling that this really is a lot of hardware combined. So the
> discussion of "independence" is particularly tricky in this case.
> 
> Anyway, I think I have come up with an approach on these lines. The
> mfd driver latches onto the ISA bridge, and the documented
> architecture suggests that a whole bunch of stuff comes off this:
> 8042, interrupt controller, dma controller, rtc, serial, timer, gpio,
> spi, ...
> 
> We already have this accurately laid out in the device tree hierarchy:
> /pci/isa/ has a child node for each of the above mentioned things
> (e.g. /pci/isa/timer , /pci/isa/rtc and so on)
> 
> So, the /pci/isa node nicely matches the vx855-mfd driver, so we can
> assign its of_node to that. Then, the vx855-gpio driver can consult
> the parent and then look at its children in order to find the of_node
> for the gpio controller. I think this nicely crosses with Mark's
> request that the ability to have constant mfd definitions isn't broken
> any more than it is already, and with Grant's preference that the
> parent resource has some contribution in helping the child gpio
> controller driver find its of_node. How does the attached patch look?
> 
> Grant, what do you think of this, and the rest of the discussion so far?

MFD bindings really need to be designed on a device-by-device basis.
Sometimes it will make more sense to have a single node, sometimes it
needs to be split up.  There is no hard rule here.

What is a hard rule is that the code creating the children needs to
know what the binding is and populate the child's of_node
appropriately.  Similarly, the child driver needs to know something
about the kinds of nodes it will be passed (can be tested by the
compatible property).

One warning however, the current platform_bus_type DT code won't deal
well with multiple platform_devices pointing to the same of_node.  It
may result in the wrong driver getting bound since the probe code
first looks at .compatible to decide which driver to probe.  If 3
separate devices are intended to bind to 3 different drivers, you'll
probably end up with all three matching against the first one unless
the drivers have some additional explicit test.

g.

