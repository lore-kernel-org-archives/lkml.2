Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab1HYTNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:13:50 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10036 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab1HYTNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:13:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 25 Aug 2011 12:13:40 -0700
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
Date: Thu, 25 Aug 2011 12:13:38 -0700
Subject: RE: [PATCH 1/4 v4] drivers: create a pin control subsystem
Thread-Topic: [PATCH 1/4 v4] drivers: create a pin control subsystem
Thread-Index: AcxjD5IWWSyyU0ITRGqAWEHex/S18QASDNQg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B24A3EDB@HQMAIL01.nvidia.com>
References: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B24A3BC0@HQMAIL01.nvidia.com>
 <CACRpkdaZfG4hiGf8vug3EGMRMc0c92xbj=L_HAQcS27DAXYc4Q@mail.gmail.com>
In-Reply-To: <CACRpkdaZfG4hiGf8vug3EGMRMc0c92xbj=L_HAQcS27DAXYc4Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Thursday, August 25, 2011 4:13 AM:
> On Wed, Aug 24, 2011 at 8:29 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Linus Walleij wrote at Friday, August 19, 2011 3:54 AM:
> >>
> >> This creates a subsystem for handling of pin control devices.
> >> These are devices that control different aspects of package
> >> pins.
> >
> > Sorry to keep harping on about this, but I'm still not convinced the data
> > model is correct.
> 
> Don't feel sorry! I'm getting very much done and much important
> research and thinking is happening thanks to you valuable feedback.
> Keep doing this!
> 
> What I notice is that the review comments have changed focus
> from the earlier contention point about having multiple functions
> per map entry to something else, which to me seems like it
> comes from device tree work, and is about describing how each
> and every pin is wired to its function. Does this correspond to
> your recent pinmux experience?

I think everything I wrote before still stands.

I was simply trying to write a shorter email more focused on a single
point, and a point that was more directly related to HW and driver
implementation.

Then, if/when we reach(ed) a consensus on that, I was going to start
talking about the client driver <-> pinmux driver mapping table.

> > Here are the two possible models:
> >
> > Model 1 (as implemented in the pin control subsystem):
> >
> > * Each pinmux chip defines a number of functions.
> > * Each function describes what functionality is mux'd onto the pins.
> > * Each function describes which pins are affected by the function.
> 
> This is correct.
> 
> > Result:
> >
> > If there are a couple of controllers that can each be mux'd out two
> > places, you get four functions:
> >
> > Function i2c0-0: Controller i2c0 is mux'd onto pins 0 and 1
> > Function i2c0-1: Controller i2c0 is mux'd onto pins 2 and 3
> > Function spi0-0: Controller spi0 is mux'd onto pins 0 and 1
> > Function spi0-1: Controller spi0 is mux'd onto pins 4 and 5
> 
> Yes, if and only if the pinmux driver find it useful to expose
> these two ports on the two sets of pins each.
> 
> For example: there really *is* a bus soldered to pin {0,1}
> and another bus soldered to pin {2,3}, and each has devices
> on it. But I have only one single i2c controller i2c0.
> 
> If pins {2,3} were not soldered or used for something else
> it doesn't make sense for the pin controller to expose
> two functions like this.
> 
> So this is dependent on platform/board data. We need
> to know how the chip has been deployed in this very
> machine to know what functions to expose.

So this is definitely an important point where I'm thinking differently.

I see the pinmux driver as *always* exposing *all* possible combinations
of pin/function/... The pinmux driver would be purely SoC-specific and
not have any knowledge at all of the board/machine/... Most likely, the
configuration the pinmux driver exposes would be hard-coded in tables in
the driver file, and never come from board-files or device-tree, since it
would not vary.

To me, this keeps the pinmux driver as simple as possible; it always works
in exactly the same way, all its data is hard-coded, so there's never a
need to parse it out of device-tree, etc. All (board) policy is implemented
by the pinmux core, and the pinmux driver doesn't know anything about it.

(although the initial board-specific setup of the HW may come from device-
tree, that would be a one-time setup, and wouldn't affect the data exposed
to the interface between the pinmux core and pinmux driver)

To make pinmux work in a board-/machine-specific fashion, the function-
mapping table (as processed by the pinmux core only) would be board-/
machine-specific, and come from board-files or device-tree. It would be
purely down to this mapping table which functions were legal to use on
which pins for a given board/machine.

> > Model 2 (what I'd like to see)
> >
> > * Each pinmux chip defines a number of functions.
> > * Each function describes the functionality that can be mux'd out.
> > * Each pinmux chip defines a number of pins.
> > * Each pinmux chip defines which functions are legal on which pins.
> >
> > Result:
> >
> > With the same controllers and pins above, you get:
> >
> > Function i2c0
> > Function spi0
> > Pins 0, 1, 2, 3, 4, 5
> > Pins 0, 1 accept functions i2c0, spi0
> > Pins 2, 3 accept functions i2c0
> > Pins 4, 5 accept functions spi0
> >
> > We'd still have a single controller-wide namespace for functions, it's
> > just that functions are something you mux onto pins, not the combination
> > of mux'd functionality and the pins it's been mux'd onto.
> 
> I think I understand this. Maybe.
> 
> I read it like this:
> Legend:
>   1..* = one to many
>   1..1 = one to one
> 
> - Pins has a 1..* relation to functions
> - Functions in general have a 1..* relation to pins,
> - Device drivers in general have a 1..* relation to
>   functions
> - Functions with 1..1 relation to pins and device drives
>   with a 1..1 relation to functions is not the norm
> 
> So this is radically different in that it requires the pin control
> system to assume basically that any one pin can be used for
> any one function.

I think that's the wrong conclusion; 1:many isn't the same as 1:all/any.
The data model might be structured to allow that, but in practice most
HW allows 1:some_subset, not 1:all/any. I think this was well-covered in
some other recent responses in this thread.

...
> > * I believe this model is much more directly maps to the way most HW
> > works; there's a register for each pin where you write a value to select
> > which functionality to mux onto that pin. Assuming that's true, using
> > this data model might lead to simpler pinmux chip implementations; they'd
> > require fewer mapping tables.
> 
> I understand this statement as you assume al pinmuxes
> are phone-exachange-type, where any pin can be tied to
> any function at runtime. So for example the CLK pin of spi0
> can be muxed onto any pin basically, not a predetermined
> set of pins.
> 
> I think that data model does not take into account the fact
> that all or most pinmuxes are inherently restricted and not at
> all that open-ended. That model would impose a
> phone-exchange type of data model on hardware that is
> much more limited.
>
> So the data model I'm assuming is:
> 
> - Pins has a 1..* relation to functions
> - Functions in general have a 1..1 relation to pins,
> - Device drivers in general have a 1..1 relation to
>   functions
> - Functions with 1..* relation to pins is uncommon
>   as is 1..* realtions between device drivers and
>   functions.
> 
> The latter is the crucial point where I think we have
> different assumptions.

As a few other replies pointed out, a number of chips do allow the at
least some logical functions to be mux'd onto different pins. Tegra
certainly isn't unique in this. 

> If it holds, it leads to the fact that a pinmux driver
> will present a few functions for say i2s0 usually only
> one, maybe two, three, never hundreds.

Certainly I'd assume the number of pins/groups that a given function
could be mux'd out onto is small, say 1-3. But, certainly not limited
to just 1 in many cases.

...
> More than anything else I think that it's up to the pin
> control/mux driver to present the useful functions for a system,
> what would change my mind is if one system would present
> - in practice, on a real board - a voluminous amount of
> functions for the same IP block say.

Just a note: There are Tegra-based boards in wide use (in fact, boards
for which some support is in mainline) that make active use of switching
the routing of a HW function between different pins at run-time.
Specifically, switching 1 I2C controller between 2 busses on the board.

In fact, soon after the pinmux system is upstream, I hope we (NVIDIA) will
be writing and submitting an I2C bus mux driver based on that. In our
downstream kernels, we do this as custom code in the I2C host driver, but
I want to move it out into a separate driver that anyone can use.

> > * Given that's the way Tegra HW works at least, the patches I recently
> > posted to initialize the Tegra pinmux from device-tree define bindings
> > that use this model. I think it's important that such bindings use the
> > same data model as the pinmux chip data model. This keeps consistency
> > between boot-time initialization and the pinmux chip portion of any
> > run-time pinmux modifications.
>
> Isn't it better if that data model is kept as a Tegra thing as I
> guess it is right now?
>
> Atleast until we find if this model really suits other machines...
>
> My concern is that it may force all pin control drivers to conform to
> something pretty complex that is only useful for Tegra. And in that
> case that part of it (the 1..* relation between functions and pins)
> should reside in the tegra pinmux driver, not across the entire
> subsystem.
>
> The intention of the pinmux part of the pin control subsystem is to
> model the subset of what is common functionality across all pin
> controllers, not the superset of everything that is possible to do
> with every pin controller, atleast not if it makes the API hard to use
> for others. So let's figure out if this is the case.

Keeping the Tegra-specific stuff hidden is a good goal. However, if we do
that too much, the pinmux API might not be usable on Tegra, so we'll fail
to unify everything within it.

> > As an aside, I see your patches use the pinmux API at driver probe time
> > to set up the pinmux, whereas my init-pinmux-driver-from-dt patches do
> > a pinmux-controller-wide initialization at probe time. There was some
> > discussion in response to earlier patches re: which way was better, and
> > I got the impression that the pinmux API was mainly for runtime changes,
> > rather than boot-time initial configuration. If that's not the case, then
> > I guess we should drop my proposed init-pinmux-driver-from-dt patches and
> > put all that code into your pinmux subsystem...
> 
> I think the individual pinmux driver should deal with
> initializing the system, by using its supplied platform data
> or device tree, then it can present the relevant available
> functions on that specific machine to the pinmux subsystem.

Sounds good.

-- 
nvpublic

