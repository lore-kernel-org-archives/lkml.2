Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab1KUXXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:23:11 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18603 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab1KUXXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:23:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 21 Nov 2011 15:23:02 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 21 Nov 2011 15:22:59 -0800
Subject: RE: [PATCH v2] pinctrl: add a generic pin config interface
Thread-Topic: [PATCH v2] pinctrl: add a generic pin config interface
Thread-Index: Acyog9WTGFHZozUmRNG8/SzavDXykAAGAalQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174F08C2A5@HQMAIL01.nvidia.com>
References: <1321000263-20000-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805B30@HQMAIL01.nvidia.com>
	<CACRpkdYh7+kL-9iy7+VDC82OAkb+-vLiJcv02pappaTeDUriTg@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740D74FD9@HQMAIL01.nvidia.com>
 <CACRpkdaDeK3A-o775LGR9qOSGKkiQtDBuLvadw1zL26E6BgOSQ@mail.gmail.com>
In-Reply-To: <CACRpkdaDeK3A-o775LGR9qOSGKkiQtDBuLvadw1zL26E6BgOSQ@mail.gmail.com>
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

Linus Walleij wrote at Monday, November 21, 2011 12:29 PM:
> On Fri, Nov 18, 2011 at 11:32 PM, Stephen Warren <swarren@nvidia.com> wrote:
...
> > The primary thing I want to understand is this:
> >
> > Assuming we did remove the "public" pin_config APIs, what's the problem
> > that having a defined enum pin_config_param is solving?
> >
> > If drivers are deciding what config params and values to set, then I do
> > see the need for standardized naming; drivers need to be generic across
> > SoCs.
> >
> > However, if there is no driver-facing config API, then the data flow is:
> >
> > * (SoC-specific) board file (or device-tree) provides some data to the
> > pinctrl core.
> >
> > * At some appropriate time, pinmux core passes that data to the pinctrl
> > driver.
> >
> > I assert that:
> >
> > * The pinctrl core need not use, understand, or modify the provided data
> > in any way.
> >
> > * The data only needs to make sense the SoC-specific pinctrl driver that's
> > used on the board that originally passed the data to the pinctrl core.
> >
> > Assuming all that, I see no value in an abstraction; there's no problem
> > to solve, since no part of the code that handles the values ever has to
> > both interpret those values and be generic across multiple SoCs.
>
> Yes that is true if the problem space is only to pass driver-specific
> information to specific drivers. I.e. if the subsystem shall be
> only some mediator and mechanics with no deeper knowledge
> about what't going on. But I don't see things that way, this is not
> an extended drivers/base/* for me, but a subsystem that should
> know what it is doing.
>
> Thinking about it I think the reason I feel so strongly for this is
> more about understanding the abstractions from the outside.
> Say I am a pinmux author for TI and I learned a set of pin config
> options and how to use them, then I need to go over and fix up
> some stuff in the S3C driver as part of some refactoring or so.

For basic config params, that might work out.

But the differences between the more esoteric config params are such that
nobody will ever be able to casually understand another SoC's complete
set of config options with or without a subsystem-defined config param
abstraction; a thorough reading of the SoC manual would be required.

Equally, I'm not sure the case you mention is what we should be optimizing
for. The people who deal with these options most will be FAEs (Field
Application Engineers), PCB designers, ... who intimately understand
the details of the SoC they're working with. They'll be well-versed in
the SoC-specific naming of all these properties. Forcing them to map all
that knowledge into an all-encompassing abstraction is only going to make
their life harder, and lead to mistakes.

Perhaps the more basic stuff like tri-state vss drive vs. open-drain or
pull-up enabled or pull-down enable can be standardized, but a region of
the config param namespace reserved for vendor extensions? That way, stuff
that really is likely to be common can be, but the other stuff which
honestly I don't think matters that much from a standardization perspective
can be kept SoC-specific.

> I also
> want to encode some specific electronic attributes to each
> state to achieve some correspondance with the thing that
> would appear in textbooks about this kind of stuff.

Why does that benefit anyone? Surely most people will take a SoC manual,
work out the settings they need using the terminology of that manual,
and attempt to set them. I don't think it's the domain of the subsystem
to teach people about electronics.

> So it in some way is a construction of a common language
> for this subsystem and then the reason is the same as
> for why I don't write all code comments in Swedish - I
> need others to understand it.

Why would an engineer working on SoC A need to converse with an engineer
working on SoC B about the detailed settings of SoC B?

Well, admittedly we're doing exactly that here, because you want to define
an abstraction that works across many SoCs, and hence are trying to
understand them all to do this. However, if you don't aim to create such
an abstraction, you won't need to understand them all, and there won't be
any language issue.

> I made a similar comment on the devicetree list some days
> ago - I am not aware of the ambitions or ideas behind
> DT, but if the things inside some specific dts file is
> supposed to be generally understood we cannot just have
> a bunch of custom values for everything. The DTS file
> may also need to see outside maintenance, all custom
> content won't work IMO.

> Defining pin configs in the DTS
> file using these enumerators make them more
> understandable to any developer as I see it.

I don't think so; I'm going to fill in the DTS file based on reading the
SoC manual and board schematic. That's all vendor-specific terminology.
Having to map that to an abstraction only makes it harder.

I want to point out again that simply having an abstraction isn't going
to stop anyone having to learn the intimate details of what all those
abstract values really do in the hardware. That's still a must. And as
such, I don't think the common language helps with understanding.

> As I read some of the paragraphs below I see the push to
> route around all-custom configuration values as stemming
> partly from lacking documentation, and I do not think it is
> proper to design an entire subsystem as per the principle
> "we don't really know what we're doing here", as if I am
> randomly poking in some values in some register because
> some other guy told me they should have that value. I don't
> see other subsystems designed very much like that.

All the fields are documented to the extent that I think anyone working
on Tegra would care about. The documentation issue is more that you'd
like the abstraction to define each config param to have a specific
unit, and hence each SoC's description has to include details of what
units each parameter has in order to convert the values to whatever units
the abstraction is defined to be in.

Put another way: Documentation has nothing to do with whether I want an
abstraction, just to do with whether I think the values of config params
can be in a specific unit defined by the abstraction.

(At least, I think... I've probably contra-dicted myself somewhere I've
written so much:-)

> > Logically, pull-up is one thing you can control, and pull-down is another.
> > As such, they should have different PIN_CONFIG values, and each have their
> > own Boolean value.
>
> Yes and they will be controllable each, what I'm after here is
> whether the core should allow both to be set at the same
> time, since it knows this is generally a bad idea. So I mean
> the core should understand what it is doing, not just respond
> to configuration requests and leave all understanding to the
> individual drivers.

Why should the core enforce policy (though shalln't not both pull up
and down)? I think a general rule in the kernel is to not implement
policy, and let user-space dictate that (well, in this case, board files
or device-tree files, but still at least not the core of the subsystem)

> I would compare to how the regulator subsystem infers the
> allowed voltage range for a certain regulator from the
> regulator, rail and list of consumer supply limits. It has
> understanding of the voltages it tries to set.

That's true, but I think that a regulator outputs a voltage is a much
better defined and consistent concept than some of the pin config values.

> > HIGH_IMPEDANCE isn't really a bias option, it's a lack of a drive option.
>
> Hm, do you mean that PIN_CONFIG_BIAS_DISABLE
> and PIN_CONFIG_BIAS_HIGH_IMPEDANCE should be merged
> into one option?

They're probably the same thing yes, and the same as PIN_CONFIG_DRIVE_OFF
with none of the following four options (which are each presumably
independent Booleans) enabled:

PIN_CONFIG_BIAS_PULL_UP
PIN_CONFIG_BIAS_PULL_DOWN
PIN_CONFIG_BIAS_HIGH
PIN_CONFIG_BIAS_GROUND

> >> OK the day someone needs to do this it can be refactored,
> >> I don't think this needs to be part of the upfront design.
> >> At that point drivers/staging/iio/adc will probably be available
> >> in drivers/* and it can be modelled using the proper abstraction
> >> for these registers anyway.
> >
> > One potential issue here; this will make it more difficult to create a
> > device-tree binding, since the binding needs to be a fixed ABI, whereas
> > if we were just talking about an in-kernel structure, we could modify it
> > all we want without as much backwards compatibility.
>
> But that must apply to *any* subsystem which wants to change the
> way configuration in which data is to be passed in, not unique to
> pin control really? Is DT only for things that have fixed ABI?
> Since this is a kernel-internal API I smell a violation of
> Documentation/stable_api_nonsense.txt ...

The kernel has a stable API (ABI) to user-space. That document applies
to intra-kernel APIs only. DT is the equivalent of an API to user-space
in this context, since once I've created a DT and installed it on a
device, I must be able to run an arbitrary (future) kernel using the
data from that DT.

So, the DT ABI doesn't have to be fixed in stone (it can be extensible),
but any enhancements to it must be backwards compatible.

So, you can add new fields to the DT schema, and if they're missing, just
assume a value that makes everything work like it did before you modified
the schema.

Or, you could make a significant change and somehow version the content
of the DT, and have the kernel be able to parse both versions, just like
you can introduce new IOCTLs and keep the old one around). Still, doing
this is pretty heavy-handed.

As a specific example, if we start off with param PIN_CONFIG_BIAS_PULL
that has enumerated values UP, DOWN, NONE, then the DT binding might be:

{ pin-pull = "up";   ... }
{ pin-pull = "down"; ... }
{                    ... } // missing property means none

In kernel, we can very easily change this to two properties
PIN_CONFIG_BIAS_PULL_UP and PIN_CONFIG_BIAS_PULL_UP, each a Boolean.
However adjusting the DT binding to represent the new combination would
be a little challenging; we could easily parse the first two options
into setting the new Boolean value to true, but how to represent the
new legal option of having both; perhaps:

{ pin-pull = "updown";   ... }

Yuck!

It would have been far better to have defined the binding using
independent Boolean properties in the first place:

{ pin-pull-up; } // property without value is "true"
{ pin-pull-down; }
{ pin-pull-up; pin-pull-down; }

So that's my reasoning for *if* we have an abstraction, we want to get
what's in that abstraction correct up-front.

> So in that case maybe pincontrol is not mature for DT bindings
> yet. Maybe that is something for mature subsystems like
> I2C, memory-mapped IO, IRQ numbers, even GPIO ... etc
> for the time being.

Hmm, well I need a binding pretty soon in order to allow Tegra-booting-
with-DT to not rely on the now legacy board file pinmux setup code...

> In the powerpc world it is a common custom to update the device
> tree(s) in arch/powerpc/boot/dts/* and drivers or platform code
> in the same patch even. (C.f. commit
> 0b5cf10691eb2c95a9126bf25f5e084d83d5d743) I take it that
> this needs to be allowed also on ARM.

Yes, both could be updated at once. However, we still need backwards
compatibility. Just because *.dts is in the kernel, doesn't mean we can
break compatibility.

> I think at one point in a conference in Prague it was agreed that
> DTS files will be kept inside the kernel for the initial submissions,
> and at the same time it was said that this was precisely because
> bindings will likely be changing quite a bit.
>
> If ARM DTS files are indeed broken out of the kernel git,
> well they will just have to be kept in sync I believe?

I /think/ that was the documentation of the bindings; the schema for
the .dts files, not the files themselves, but I may be wrong.

But either way, there's nothing incorrect about somebody using an out-
of-tree .dts file to boot their system, and we can't assume we'll be
able to keep that .dts file in sync with the kernel.

> >> As discussed in the other thread with Thomas the way this is done
> >> for most systems is in drive stage multiples vs nominal load
> >> impedance (usually capacitive, but we don't need to specify that) for one drive
> >> stage as described in this forum thread:
> >> http://www.edaboard.com/thread74140.html
> >>
> >> Which means the argument should be number of drive stages.
> >
> > That thread is just one person's assertions. I have no way to judge
> > if they're really globally true or not. I'd be hesitant to based any
> > decisions on one random unauthenticated thread on some random forum.
>
> Well I'm trying to check in text books. But how many ways of
> designing push/pull can there be (practical, not theoretical)?

I have no idea at that level of ASIC design. Given neither of us do,
I'd suggest we don't rely on obtaining such knowledge.

> > I wonder why Tegra's driver strengths are 1, 1/2, 1/4, 1/8 if they're
> > Implemented like that forum thread says. While I suppose it's entirely
> > possibly there are an extra 1, 1, 2, 4 transistors for each level, it
> > seems more likely that there would be 1 extra transistor per level
> > giving drive strengths of 1, 3/4, 1/2, 1/4. However, I'm just randomly
> > conjecturing here...
>
> Hm. Since the terminology seems related I would *guess* something
> like 1 = 8 transistors (4 up 4 down), 3/4 = 6 transistors (3 up 3 down),
> 1/2 = 4 transistors (2 up 2 down), 1/4 = 2 transistors (1 up 1 down).
>
> So the number would be "number of driving stages as related
> to the maximum available" and the maximum is 4 driving stages.
>
> So then it would indeed make sense to define the parameter
> argument as "number of active driving stages" so it becomes:
>
> # driving stages     S3C       Tegra
> 1                          1x          1/4
> 2                          2x          1/2
> 3                          N/A        3/4
> 4                          4x          1
> 8                          8x          N/A
>
> Atleast it makes logical sense.

That's entirely possible. My point is that while the numbers may work
out that way, that's only correlation not causation. I have no idea how
many transistors Tegra has per pad, and I don't and shouldn't have to
care; what I care about is that a board designer or FAE wants to pick
"drive strength option 3", because that's what they validated.

> I'm a bit worried if we're writing drivers for hardware where the
> documentation is so sparse that we don't really know what
> we're doing... How do you know how to select between say the
> 1/2 and 1/4 setting today? The subsystem will have a hard time
> to compensate for lack of engineering documentation whatever
> it comes to :-(

I believe either simulations or practical measurement are used to
determine which option to select (e.g. based on minimal ringing, timing
spec conformance, etc.), and the SW engineers simply make sure they
program the value they're told to. While I certainly do like to understand
everything fully, there are some things that I just let go, and let
someone decide for me. Almost all of the esoteric settings are the domain
of HW engineers, and it's their responsibility to fix things if there is
system instability; kernel engineers shouldn't be too overly concerned I
think.

> >> > Shouldn't that be just PIN_CONFIG_INPUT_SCHMITT with a boolean parameter
> >> > to indicate whether it's enabled?
> >>
> >> To match the PIN_CONFIG_DRIVE_OFF this is more logical I think,
> >> there is no shortage of enums.
> >
> > Sure, but given Schmitt is a single logical thing that can be turned on
> > and off, and the API is a param/value style API, surely the param should
> > be "is Schmitt enabled" and the value "on/off" or "yes/no".
>
> OK I'll change it.
>
> I also defined low power mode 0 to mean normal power mode
> (low power mode off) and changed
> PIN_CONFIG_WAKEUP_ENABLE/DISABLE to just
> PIN_CONFIG_WAKEUP with arguments 1 for enable
> and 0 for disable.
>
> Should we also join PIN_CONFIG_BIAS_DISABLE and
> PIN_CONFIG_BIAS_HIGH_IMPEDANCE (as was hinted above)
> and possibly CONFIG_DRIVE_OFF could be rewritten as
> "any of PIN_CONFIG_DRIVE_* with an argument of zero".

s/any/all/ I think. But again I think DRIVE_OFF is what the other two mean,
more than the other way around.

> >> > In order to specify rates, you'd also need to define what load capacitance
> >> > was being driven; rate isn't an independent value. I wonder if a standard
> >> > load inductance would also need to be specified.
> >> >
> >> > Tegra's slew rates are not specified in nanoSeconds. Now it may be that
> >> > for a given load capacitance, each rate does indeed map to a specific
> >> > rise time. However, the documentation isn't written that way. Getting the
> >> > documentation changed to specify times simply isn't going to happen; it's
> >> > hard enough to just get the documentation in the first place for some of
> >> > the pinmux stuff. In fact, even calculating what those times are probably
> >> > isn't possible right now (for me at least, and the low-level pad designers
> >> > probably have better things to do).
> >>
> >> OK so how is the slew rate specified in the specs you have?
> >> Is it just some magic number? If it turns out all platforms only have
> >> unspecified magic numbers for slew rate settings we'd better
> >> just leave this argument as custom then.
> >
> > Yes. The exact text is e.g.:
> >
> > DRVDN_SLWR - Driver Output Rising Edge Slew 2-bit control code. Code 11
> > is least slewing of signal, code 00 is highest slewing of the signal.
>
> So when you attach some electronics to this SoC, how do you
> choose which value to poke in there? Trial-and-error?
> Again I think we need to understand the things we're trying
> to program. That documentation is lacking is bad, but do we
> really want to design the subsystem around lacking documentation
> instead of deeper understanding?

I addressed this above, but just to repeat: I wouldn't chose any of the
values; it's a HW engineer's responsibility because it's their knob to
tweak. Yes, I imagine sometimes it is trial-and-error.

> The Nomadik GPIO is described like this in the manual for
> AP9500 used in the Snowball (page 775)
> http://www.stericsson.com/developers/DM00030004_AP9500_reference_manual_rev1.pdf
>
> "The GPIO1B_LOWEMI register is used to control the IO pad
>   current slew rate. When LOWEMI= '1', the normal slew rate is
>   slashed to half of its normal value, us enabling Low EMI mode. In
>   normal case, LOWEMI='0'."
>
> So I wouldn't know much about rise and fall times either. But
> "slashed in half" is pretty clear, so I guess the argument might
> be formulated as "fractions of maximum slew rate", so if the slew
> rate can be contolled in 8 steps the argument 7 gives 7/8
> slew rate, argument 2 gives 2/8 = 1/4 slew rate compared to
> nominal etc. This is similar to the proportional number of
> driving stages suggested for PIN_CONFIG_DRIVE_*

Expressing this as a fraction/percentage of max rate might work. But
Then what do you do when the documentation just says low/mid/high? You
could measure it yourself (a hassle), or obtain more documentation (a
hassle), or ...? But again, why do you really care; this isn't a knob
that you're expected to just arbitrarily tweak from software.

> >> > so having two PIN_CONFIG values doesn't make
> >> > sense; we'd have to use the value for e.g. LOW_POWER_MODE to represent the
> >> > desired HW value, and ignore NORMAL_POWER_MODE, I think.
> >>
> >> NORMAL_POWER_MODE is intended to return the pin from any low-power
> >> mode in analogy with say BIAS_DISABLE or DRIVE_OFF, SCHMITT_OFF
> >> so it's to make the code symmetric and readable, not to make the minimal
> >> number of enumerators. I think this is better syntax than say, specifying that a
> >> zero argument to LOW_POWER_MODE means "low power mode off"
> >
> > Maybe this is representing something different than what Tegra's LPMD
> > bits are then.
> >
> > On Tegra, this isn't a kind of "turn off and consume less power" toggle,
> > but rather a way of configuring the pin while it's active; it's a value
> > 0..3 (on Tegra20 at least) that interacts with the other drive strength
> > and slew rate properties and affects overall active pin performance.
>
> Hm, I don't follow this quite... what is it then? How do you select
> the apropriate value in your code?

I don't; a HW engineer would tell me how to configure it (or I leave it at
default).

--
nvpublic

