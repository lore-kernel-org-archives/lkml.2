Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1HZRd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 13:33:27 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10384 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab1HZRd0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 13:33:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 26 Aug 2011 10:33:18 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        ext Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        Sascha Hauer <kernel@pengutronix.de>
Date: Fri, 26 Aug 2011 10:33:15 -0700
Subject: RE: [PATCH 1/4 v4] drivers: create a pin control subsystem
Thread-Topic: [PATCH 1/4 v4] drivers: create a pin control subsystem
Thread-Index: Acxjyw5NITfP9jU0Ts+hagvgCfW+YAASPiNQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B24A412A@HQMAIL01.nvidia.com>
References: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B24A3BC0@HQMAIL01.nvidia.com>
	<CACRpkdaZfG4hiGf8vug3EGMRMc0c92xbj=L_HAQcS27DAXYc4Q@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B24A3EDB@HQMAIL01.nvidia.com>
 <CACRpkdbBBaNFETLLcxeCFZoLbdMok7uRi_o-HcbpYdMtRiGFcw@mail.gmail.com>
In-Reply-To: <CACRpkdbBBaNFETLLcxeCFZoLbdMok7uRi_o-HcbpYdMtRiGFcw@mail.gmail.com>
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

Linus Walleij wrote at Friday, August 26, 2011 2:35 AM:
> On Thu, Aug 25, 2011 at 9:13 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Linus Walleij wrote at Thursday, August 25, 2011 4:13 AM:
> >
> >> So this is radically different in that it requires the pin control
> >> system to assume basically that any one pin can be used for
> >> any one function.
> >
> > I think that's the wrong conclusion; 1:many isn't the same as 1:all/any.
> > The data model might be structured to allow that, but in practice most
> > HW allows 1:some_subset, not 1:all/any. I think this was well-covered in
> > some other recent responses in this thread.
> 
> OK what I was mainly after was if the data model should
> be structured to accept phone-exchange type muxing. If it
> does and such a hardware appears - I mean a hardware where
> any pin can be muxed anywhere, and given the second point
> you make that the pinmux subsystem should expose all possible
> combinations, it will lead to a situation where the driver
> needs to expose all permutations i.e. (n over k) combinations
> per function where n is the number of available pins and k
> is the number of pins used by any one function. That would
> just explode...
> 
> So if we assume that such a hardware does not exist but
> the number of permutations of functions will always be limited,
> it makes much more sense.

I guess I don't quite understand the implications of what you wrote here;
I interpret the above as meaning you still prefer the data model that's
in your existing patches. However, this can't be true given your response
about the function mappings below. So, I'll mainly ignore the above and
focus on responding below:-)

> I'll encode this theoretical assumption in
> Documentation/pinctrl.txt as I go along.
> 
> >> So the data model I'm assuming is:
> >>
> >> - Pins has a 1..* relation to functions
> >> - Functions in general have a 1..1 relation to pins,
> >> - Device drivers in general have a 1..1 relation to
> >>   functions
> >> - Functions with 1..* relation to pins is uncommon
> >>   as is 1..* realtions between device drivers and
> >>   functions.
> >>
> >> The latter is the crucial point where I think we have
> >> different assumptions.
> >
> > As a few other replies pointed out, a number of chips do allow the at
> > least some logical functions to be mux'd onto different pins. Tegra
> > certainly isn't unique in this.
> 
> Yeah I get this now... and it's a handful of alternatives for a
> few functions, sorry for being such a slow learner.
> 
> >> If it holds, it leads to the fact that a pinmux driver
> >> will present a few functions for say i2s0 usually only
> >> one, maybe two, three, never hundreds.
> >
> > Certainly I'd assume the number of pins/groups that a given function
> > could be mux'd out onto is small, say 1-3. But, certainly not limited
> > to just 1 in many cases.
> 
> Sure, we're on the same page. So I now need to find a
> way to expose a few different localities per function from
> the system and all the way to the map, and drop the string
> naming system so instead of using spi0-0, spi0-1, spi0-2
> I use some tuple like {"spi0", 0}, {"spi0", 1}, {"spi0", 2}
> and I call the latter integer something like "locality" or
> "position".

OK. That sounds like exactly what I was asking for.

I'd argue that "locality" or "position" is in fact the pin name.

So, re-using my previous example of the data exposed by a pinmux driver:

> > Function i2c0
> > Function spi0
> > Pins 0, 1, 2, 3, 4, 5
> > Pins 0, 1 accept functions i2c0, spi0
> > Pins 2, 3 accept functions i2c0
> > Pins 4, 5 accept functions spi0

Then, I think that the mapping table processed by the pinmux core might
look like:

device    devices_function_name pin_to_configure driver_function_name_for_pin
--------- --------------------- ---------------- ----------------------------
foo-i2c.0 busa                  0                i2c0
foo-i2c.0 busa                  1                i2c0
foo-i2c.0 busb                  0                i2c0
foo-i2c.0 busb                  1                i2c0
(supplied by board files or device-tree)

So, when device foo-i2c.0 requests function "busa", the pinmux core would
make a couple calls to the actual pinmux driver:

configure pin 0 for function i2c0
configure pin 1 for function i2c0

This model does require that the pinmux core potentially process multiple
entries in the mapping table for each driver-requested function.

If we didn't use "pin name" as the "locality" or "position" value, we'd
end up with a simpler mapping table:

device    devices_function_name locality driver_function_name_for_locality
--------- --------------------- -------- ----------------------------
foo-i2c.0 busa                  0        i2c0
foo-i2c.0 busb                  1        i2c0
(supplied by board files or device-tree)

However, we'd then need a extra table defining what each locality meant:

function locality list_of_pins_in_function_at_locality
-------- -------- ------------------------------------
i2c0     0        0, 1
i2c0     1        2, 3
(hard-coded into pinmux driver implementation)

It seems slightly more complex to me to have these two separate tables,
rather than just iterating over n entries in a single mapping table.

Still, I suppose this an implementation detail. I guess I also need to
think a little more about how both those models would work with Tegra,
where special functions are selected at a granularity of pin groups,
yet GPIO is selected at a granularity of a single pin. Perhaps that
final table I wrote above (mapping locality to pin list) might also help
represent Tegra's pin-group- rather than pin-level muxing capabilities...

-- 
nvpublic

