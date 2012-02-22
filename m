Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab2BVGBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 01:01:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64209 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2BVGBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 01:01:11 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC3A1@HQMAIL01.nvidia.com>
References: <1329719263-18971-1-git-send-email-swarren@nvidia.com>
	<20120220073941.GC22562@n2100.arm.linux.org.uk>
	<CACRpkdbMFN3=XTSg1oE310eTHecrs6XaMz+DCNYJzwOg8JEEiQ@mail.gmail.com>
	<20120221110618.GJ22562@n2100.arm.linux.org.uk>
	<CACRpkdYzRu4VPKPgxuttuvSDCpfHjvBGGq1rFEDExv1PsoLG=w@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17BD8BC3A1@HQMAIL01.nvidia.com>
Date: Wed, 22 Feb 2012 07:01:11 +0100
Message-ID: <CACRpkdb+Vtyhsxi7L0ttDk_8Ra2-Kfh8H9esD7P_FC_=c4-=Mw@mail.gmail.com>
Subject: Re: [PATCH 1/2] Documentation/gpio.txt: Explain expected pinctrl interaction
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 8:14 PM, Stephen Warren <swarren@nvidia.com> wrote:

> Ignoring WARs like we're discussing, it's typically true that a given pin
> should either be a special function or a GPIO for any given board. If
> we do allow a pin to be owned/used by both, then how do we indicate, on
> a per-board rather than per-SoC basis, which pins we should allow both
> gpio_request() and pinmux usage?

I was thinking about making this a property of the physical pin i.e.
struct pin_desc and not of the board data.

It seems to me like this arbitration has to be very close to the driver,
since not all or even many controllers will support it (AFAICT).

> The following considerations exist:
> a) On Tegra, a pin group might include 10 pins that are mux'd as a group,
> hence all owned e.g. by a NAND driver. If a few of those aren't used on a
> particular board due to the way the NAND is hooked up and the driver
> configured, do we only allow gpio_request() only on those pins we know the
> NAND driver isn't actually using, to prevent someone using unexpected
> pins as GPIO? We'd need a per-GPIO per-board way to represent this if
> we care about this level of error-checking.

In this case I would strive not to present unused pins to the functions
in the first place. But maybe this collides with the new paradigm to
assign aquire all possible pins on pinctrl_get() time?

> b) In Linus's snooping example, how do we know the SoC can physically
> implement enabling a pin as both a GPIO and a special function, such
> that the gpio_request() for the snooping won't interfere with the mux'd
> function?

I think on U300 and SA1100 we can flag that in the pin descriptor
as described above.

> 2) Extend the pinctrl mapping table to explicitly represent GPIO usage.

Seems like it could get complicated. Since the only hardwares we have
that can do this would be fine with having it in their pin descriptor we
can do it there?

> This is required anyway for HW where there isn't a 1:1 mapping between
> GPIO ID and pin ID, e.g. 1 pin could be used for two different GPIO
> signals, e.g. 1 from each of 2 different GPIO HW modules, with different
> capabilities, or where 1 GPIO could be routed to one of 2 or more pins.
>
> In other words, make "gpio" an explicit mux function, thus allowing
> pinctrl_select_state() to directly transition between special function
> and GPIO usage, rather than having separate pinctrl and GPIO APIs for
> this. This way would entail dropping my Documentation/gpio.txt patch
> completely, I think.
>
> If we do this though, I think we'd want to extend pinctrl to allow muxing
> on pins too, so that we don't need to create a pin group for every pin to
> support per-pin GPIO ownership. This would also help out all the HW that
> already muxes everything per-pin, since they need to create these single-
> pin groups right now... I somewhat anticpated this in my naming of the
> mapping table convenience macros in the most recent pinctrl patch I posted
> to add pin config mapping table entries.

Hm I think Tony also mentioned that he wanted to allow muxing of
single pins from the mapping sometime so I sort of like the idea.

Linus Walleij
