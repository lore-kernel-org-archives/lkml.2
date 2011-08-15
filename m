Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab1HOQlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 12:41:42 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2058 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab1HOQlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 12:41:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 15 Aug 2011 09:41:22 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Olof Johansson <olof@lixom.net>
CC: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 15 Aug 2011 09:41:20 -0700
Subject: RE: [RFC PATCH 06/12] arm/dt: Tegra: Add pinmux node
Thread-Topic: [RFC PATCH 06/12] arm/dt: Tegra: Add pinmux node
Thread-Index: AcxaUzp88XTtMc7TQBKJdiCd1M0e8ABFMbfg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04AEA2507E@HQMAIL01.nvidia.com>
References: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
	<1313189697-21287-7-git-send-email-swarren@nvidia.com>
 <CAOesGMheuUfSe1uUA6LxZ71V0-DR3XX7bEJqhVxJ-ZqrWWa1bA@mail.gmail.com>
In-Reply-To: <CAOesGMheuUfSe1uUA6LxZ71V0-DR3XX7bEJqhVxJ-ZqrWWa1bA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote at Sunday, August 14, 2011 1:25 AM:
> On Fri, Aug 12, 2011 at 3:54 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Add a pinmux node to tegra20.dtsi in order to instantiate the future
> > pinmux device. Add pinmux nodes to Harmony and Seaboard, which detail
> > the entire default pinmux configuration. This configuration is identical
> > to that in board-harmony/seaboard-pinmux.c.
> 
> Again, documentation for the binding is needed.

Yes. It should have been there, but I screwed up.

> Seeing the table coded up now though, I wonder if it could make sense
> to flip it around? The number of functions multiplexed out are fewer
> than the pin groups (and this would be even more true on platforms
> that have per-pin configurations and/or smaller groups).

There are 116 pin groups and 61 functions, so this certainly would reduce
the size of the tree.

> I.e. something like:
> 
>     sdio4 {
>             nvidia,pingroups = < DTA DTD >; // Not sure how to
> reference this though -- integers would be hard to read. DTA/DTD
> aren't valid values in the syntax.
>             nvidia,pull-up
>     },
> 
> And any pingroups not covered by a function would be left alone

I'm personally inclined not to do this.

a) The HW registers are laid out such that each pingroup has various
properties, so the current binding represents that directly. That said,
inverting the table would contain exactly the same data, so this argument
is slightly tenuous/arbitrary, except that:

b) I think we'd still need tristate and pull properties per pin-group
either way; within a given special function, I see no reason for every
pingroup to need the same pull/tristate values (otherwise, I imagine the
Tegra HW designers would have lumped all the pins into a single pingroup
already). For example, an interface with data and control signals might
need pullups on control signals, but none on data.

c) Similar to that, a RSVD/NONE (or otherwise unused) function might be
used for a bunch of pingroups that are in fact used by GPIOs, and hence
only the pull/tristate values are relevant, since the GPIO controller
will actually control the data on the line. In this case, there's no 
reason to assume that different pingroups that have the same function are
related in any way, and hence should have the same pull/tristate.

Given, b/c, we'd need an array of pull/tristate values per pingroup within
a given function, and I think the syntax for that would be sufficiently
complex that the binding in the current patchset makes more sense.

Do you agree?

> (one
> could easily define a few no-op functions to set pull up/down and
> tristate values on the unused groups).

The binding (and original pinmux code) does define RSVD1/2/3/4 functions
for the case where a pingroup should be programmed to an unused/quiescent
state. There's also a NONE function for the pingroups that don't support
muxing, but just pullup/down and tristate.

> [...]
> 
> > +       pinmux: pinmux@70000000 {
> > +               ATA {
> 
> I would prefer seeing these in lower case (since device tree tends to
> be no-caps). Should be easy to switch to strcasecmp in the code.

Sure.

> [...]
> > +               CDEV2 {
> > +                       nvidia,function = "PLLP_OUT4";
> 
> The string here is a bit unfortunate. It's really just used to map
> from the string to an integer anyway, with the reverse mapping being
> produced by the debugfs output. But especially if the function is
> flipped above, the different pingroups referenced might not use the
> same value for each function, so some sort of lookup will still be
> needed. Not much to do about, it seems. :(

I originally considered syntax like:

    nvidia,function = <33>; // PLLP_OUT4

However, I figured this was problematic because:

a) Calculating the integers would be problematic; pinmux.h doesn't
currently list the integer for each value in enum tegra_mux_func, although
I suppose it and the binding documentation could easily be modified to do
so.

b) With just an integer, it's much harder to know what the value means.

c) With both the integer and comment, they can get out of sync if
incorrectly edited.

I'd be much more included to use integers if the *.dts files wer run
though the pre-processor, and hence defines could be used. I do observe
that Documentation/devicetree/booting-without-of.txt says:

    It is also suggested that you pipe your source file through cpp (gcc
    preprocessor) so you can use #include's, #define for constants, etc...

> > +                       nvidia,pull = "down";
> 
> This should be done by discrete properties instead: nvidia,pull-up,
> nvidia-pull-down (and omitted means normal), without values.

OK.

-- 
nvpublic

