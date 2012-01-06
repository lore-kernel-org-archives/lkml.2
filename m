Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab2AFXqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 18:46:09 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7847 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732Ab2AFXqH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 18:46:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 06 Jan 2012 15:46:00 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Date: Fri, 6 Jan 2012 15:45:24 -0800
Subject: RE: [PATCH v2] pinctrl: add support for group and pinmux states
Thread-Topic: [PATCH v2] pinctrl: add support for group and pinmux states
Thread-Index: AczJQrQW3PRafRNBT6GTnuUhTet3fADhjU6w
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF177EE3A01F@HQMAIL01.nvidia.com>
References: <1324249593-3051-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF176BE92C1B@HQMAIL01.nvidia.com>
 <CACRpkdaQriLV0uxTdX1juJZ7ERAa0tcMGC4UyfXASTo4txub5g@mail.gmail.com>
In-Reply-To: <CACRpkdaQriLV0uxTdX1juJZ7ERAa0tcMGC4UyfXASTo4txub5g@mail.gmail.com>
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

Linus Walleij wrote at Monday, January 02, 2012 4:36 AM:
> Hi Stephen,
> 
> many thanks for the comments as usual!
> 
> On Tue, Dec 20, 2011 at 1:24 AM, Stephen Warren <swarren@nvidia.com> wrote:
> > Linus Walleij wrote at Sunday, December 18, 2011 4:07 PM:
> >>
> >> +To simplify handling of specific group states, such as when a group of
> >> +pins need to be deactivated or put in a specific sleep state, the pin controller
> >> +may implement a .pin_group_set_state() callback. This will for example be
> >> +called automatically to set a certain pin group in active state when the groups
> >> +are selected for use in a certain pin multiplexing configuration (see below).
> >> +This is a good opportunity to set up any default pin configuration (see below)
> >> +for the pins in a group.
> >
> > I don't think it's possible for a pinctrl driver to implement such a
> > callback; the appropriate state for a pin may well be board-specific,
> > and the pinctrl driver itself can't possibly know what that state is.
> 
> I don't see the conflict. The driver knows this from its supplied
> platform data or device tree nodes. It is indeed board-specific,
> as is many things a pinctrl driver may be using.

The main issue I see is that:

* With the current pin mux API, the driver is simply defining what the
SoC can do, and the mapping table (outside the driver) is selecting which
of those things to do. There's zero knowledge (or need) of board-specific
data in the pin mux driver.

* With your proposal for pin configuration, the driver still of course
defines what the SoC can do since it must implement it, but also the
(e.g. platform) data that defines which of those things to do is now
Handled by the driver rather than the pinctrl/pinconfig core.

That seems like a needless semantic difference.

While I agree it's most likely perfectly possible for the driver to
parse platform data or DT to obtain this board-specific pin config
information, I think that'd be a lot of work that all drivers have to
implement identically, so it might be better moved into the pinctrl
core.

Thinking more about this and putting it another way: Having the pinctrl
driver rather than the pinctrl core know what "suspend" means for a pin/
group, there's still the table of pin config settings that I'm asking
for, it's just that each individual pin ctrl driver is implementing the
table; we may as well move that common code to a central place.

> > For example, for some random pin that a board happens to be using as a
> > GPIO - how does the pinctrl driver know whether that GPIO actually does
> > something while in suspend; if the GPIO isn't used, the SoC can probably
> > just turn off all drivers and pull-up/downs on the pin, but if the GPIO
> > is used to control some aspect of a PMIC, it probably needs to be in a
> > specific state during suspend. This kind of thing is entirely board-
> > specific.
> 
> This is exactly the stuff it is supposed to handle. And the driver
> does so by inspecting its platform data/DT.
> 
> > Similarly, the sequencing of reprogramming of the various pins when
> > entering/leaving suspend is most likely board specific, e.g. there may
> > be a need to assert a "speaker mute" GPIO before de-asserting a GPIO
> > that enables power to speaker amplifiers etc.
> 
> I don't see how that affects pinctrl, you can assert your GPIO
> from somewhere in arch/arm/mach-foo/* and following that
> you can issue pinmux_set_state() for some other pins.

What if you need to do something like:

Put pin A into "suspend" state.

Reprogram GPIO X

Put pin B into "suspend" state.

It's possible to open-code that in a driver, but the sequence and even
need to do it is most likely board-specific. I feel it'd be best to
drive all this by data rather than code, and just loop over a list of
N pin config settings to apply. Handling that data and iterating over
the n settings seems like the domain of pinctrl?

> >> +enum pin_group_state {
> >> +     PIN_GROUP_STATE_DISABLED,
> >> +     PIN_GROUP_STATE_ACTIVE,
> >> +     PIN_GROUP_STATE_IDLE,
> >> +     PIN_GROUP_STATE_SLEEP,
> >> +};
> >
> > I'm unsure that having the pinctrl core explicitly define the set of
> > legal states is the right approach.
> 
> But later you say:
> 
> > For standard states (e.g. fully active, system suspend) we could define
> > (de-facto?) standardized names that drivers can use if appropriate.
> >
> > That'd prevent too many custom state strings, yet allow extensibility
> > when needed.
> 
> So I don't get this to match up... There is a clear advantage in
> defining a few standard states.

IIRC, I was talking about two different kinds of states.

The PIN_GROUP_STATE_* you quoted above are individual pin group states.

The "standard states" in the second chunk I wrote above was regarding
states of an entire device (a pmx entry I think)

A totally made up example might be the need to wake from sleep due to
SD card insertion, detected by the SD devices' CD (Change Detect) GPIO.
Here, the SD device's board-specific suspend state would perhaps include
the SD pins (clk, data) being in some suspend-oriented pin state, but
the GPIO pin would be in a full-power state to detect the plug-in.

> > This prevents domain-specific states
> > (e.g. PCIe power states say) from being defined without revising the
> > core.
> 
> I don't know much about PCIe, but I've heard about C-states and
> such things so I buy this argument.
> 
> > I'd like to suggest an alternative:
> >
> > a) The mapping table should be enhanced to cover all configuration that
> >   pinctrl can program:
> >   * Mux function selection
> >   * Whether a pin a used as a GPIO, if gpiolib doesn't interact with
> >     pinctrl to set this up.
> >   * Any pin config parameters that should be set.
> >   * Define all the above for each state that a driver can be in.
> >   * Name legal states as strings in the mapping table, so they're just
> >     data and any given driver can define the names of states it expects
> >     to have available.
> >   * The table can have a defined execution ordering this allowing board-
> >     specific sequencing requirements to be defined. Perhaps the mapping
> >     table can define the set of parameters to program for each legal
> >     to/from state transition combination, rather than target
> >     configuration for each state, so all sequencing is fully under
> >     control of the mapping table.
> 
> As mentioned before I prefer that pin configuration tables be
> kept separate from say pinmux tables.

Separate tables to store the data is one thing, and potentially
reasonable; I'm more concerned whether the table for pin mux and pin
config are similar and both handled the same way by pinctrl core, or
whether the pin config table/... has to be open-coded in a pinctrl
driver.

> And the last bullet is again a script engine...

A very simple one. I think all that's needed is blindly iterating over
each entry in an ordered list in a defined order. To me, "scripting
engine" implies state/variables, conditionals, loops, etc.

> While these may be good ideas and very useful I fear that
> coding it all up into one big table of states and settings
> is going to look complex and become hard to maintain.

Could you expand upon that? I'm not sure I agree.

If the individual pinctrl driver needs to know what "suspend" means for
a pin/group, I'd imagine the platform data or DT for it would just be a
table of settings for each pin anyway. I don't think moving the
responsibility between pinctrl core and driver is going to affect whether
there is this "one big table of states" or not.

> I would prefer a divide-and-conquer approach here, so
> that tables for mux settings and configs are two things
> whereas a optional transition script engine is a third thing
> utilizing the first two.
> 
> Neither has any implications for group states anyway -
> how you realize the (optional) group states, i.e. whether
> say a certain scriptlet is engaged, a certain table entry
> is activated or not, etc, should be up to the driver IMO.
> I.e. if implemented by a script engine you *can* do it
> that way but you don't *have to*. In our case and for many
> simple systems with a few states it would just add
> overhead.
>
> > b) Add a pinctrl API that transitions a given pmx (from pinmux_get())
> >   between states as defined in the mapping table.
> 
> From the external API point of view, the only difference from the
> outlined approach in this patch would be that instead of defining:
> 
> enum pin_group_state {
>     PIN_GROUP_STATE_DISABLED,
>     PIN_GROUP_STATE_ACTIVE,
>     (...)
> }
> 
> states would instead come from the platform data or so.
> 
> So if I just replace this enum with a string or so:
> pinmux_set_state(pmx, PIN_GROUP_STATE_ACTIVE);
> turns into:
> pinmux_set_state(pmx, "my-active-state-name");

I think the issue isn't so much about int/enum vs. string, but rather
about whether the core set of values defined by the pinctrl core can
be expanded to include more options for certain devices or classes of
device.

> > That should allow this to be fully generic.
> >
> > For standard states (e.g. fully active, system suspend) we could define
> > (de-facto?) standardized names that drivers can use if appropriate.
> >
> > That'd prevent too many custom state strings, yet allow extensibility
> > when needed.
> 
> That means if I refine the API from:
> 
> enum pin_group_state {
>     PIN_GROUP_STATE_DISABLED,
>     PIN_GROUP_STATE_ACTIVE,
>     PIN_GROUP_STATE_IDLE,
>     PIN_GROUP_STATE_SLEEP,
> };
> 
> To:
> 
> #define PIN_GROUP_STATE_DISABLED "disable"
> #define PIN_GROUP_STATE_ACTICE "active"
> #define PIN_GROUP_STATE_IDLE "idle"
> #define PIN_GROUP_STATE_SLEEP "sleep"
> 
> I have achieved the same thing but with string names for
> states, opening up for custom named states.
> 
> I can live with that I think, I'll hack something.
> 
> > IIRC, some of my previous emails have touched on this idea, and included
> > example mapping tables with multiple states per device.
> 
> Yes, but I do not (yet) embrace this idea :-)

-- 
nvpublic

