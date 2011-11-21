Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab1KUT3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:29:08 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62740 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab1KUT3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:29:05 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740D74FD9@HQMAIL01.nvidia.com>
References: <1321000263-20000-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805B30@HQMAIL01.nvidia.com>
	<CACRpkdYh7+kL-9iy7+VDC82OAkb+-vLiJcv02pappaTeDUriTg@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740D74FD9@HQMAIL01.nvidia.com>
Date: Mon, 21 Nov 2011 20:29:04 +0100
Message-ID: <CACRpkdaDeK3A-o775LGR9qOSGKkiQtDBuLvadw1zL26E6BgOSQ@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: add a generic pin config interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 11:32 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Thursday, November 17, 2011 6:26 AM:

> The primary thing I want to understand is this:
>
> Assuming we did remove the "public" pin_config APIs, what's the problem
> that having a defined enum pin_config_param is solving?
>
> If drivers are deciding what config params and values to set, then I do
> see the need for standardized naming; drivers need to be generic across
> SoCs.
>
> However, if there is no driver-facing config API, then the data flow is:
>
> * (SoC-specific) board file (or device-tree) provides some data to the
> pinctrl core.
>
> * At some appropriate time, pinmux core passes that data to the pinctrl
> driver.
>
> I assert that:
>
> * The pinctrl core need not use, understand, or modify the provided data
> in any way.
>
> * The data only needs to make sense the SoC-specific pinctrl driver that's
> used on the board that originally passed the data to the pinctrl core.
>
> Assuming all that, I see no value in an abstraction; there's no problem
> to solve, since no part of the code that handles the values ever has to
> both interpret those values and be generic across multiple SoCs.

Yes that is true if the problem space is only to pass driver-specific
information to specific drivers. I.e. if the subsystem shall be
only some mediator and mechanics with no deeper knowledge
about what't going on. But I don't see things that way, this is not
an extended drivers/base/* for me, but a subsystem that should
know what it is doing.

Thinking about it I think the reason I feel so strongly for this is
more about understanding the abstractions from the outside.
Say I am a pinmux author for TI and I learned a set of pin config
options and how to use them, then I need to go over and fix up
some stuff in the S3C driver as part of some refactoring or so.

If we have a common well-defined terminology, you will
understand the code in the other driver quickly, say you
know what PIN_CONFIG_BIAS_HIGH_IMPEDANCE means.
If one driver calls the same thing TI_OMAP_HIGHZ_CONF
and the other calls it S3C_TRISTATE_SETUP that
becomes a burden to understand all differences. And as
a subsystem maintainer I *have* to understand and be
able to patch around in all drivers. Without common
terminology I will easily find myself not understanding the
different implementations. I will only know that "it's doing
some magic on pin X".

So basically it has a value for code maintenance. I also
want to encode some specific electronic attributes to each
state to achieve some correspondance with the thing that
would appear in textbooks about this kind of stuff.

So it in some way is a construction of a common language
for this subsystem and then the reason is the same as
for why I don't write all code comments in Swedish - I
need others to understand it.

I made a similar comment on the devicetree list some days
ago - I am not aware of the ambitions or ideas behind
DT, but if the things inside some specific dts file is
supposed to be generally understood we cannot just have
a bunch of custom values for everything. The DTS file
may also need to see outside maintenance, all custom
content won't work IMO. Defining pin configs in the DTS
file using these enumerators make them more
understandable to any developer as I see it.

As I read some of the paragraphs below I see the push to
route around all-custom configuration values as stemming
partly from lacking documentation, and I do not think it is
proper to design an entire subsystem as per the principle
"we don't really know what we're doing here", as if I am
randomly poking in some values in some register because
some other guy told me they should have that value. I don't
see other subsystems designed very much like that.

For the U300 and Nomadik controllers I think I pretty much
know what the supported values are, so these enumerators
will be useful across these two machines at least.

> Logically, pull-up is one thing you can control, and pull-down is another.
> As such, they should have different PIN_CONFIG values, and each have their
> own Boolean value.

Yes and they will be controllable each, what I'm after here is
whether the core should allow both to be set at the same
time, since it knows this is generally a bad idea. So I mean
the core should understand what it is doing, not just respond
to configuration requests and leave all understanding to the
individual drivers.

I would compare to how the regulator subsystem infers the
allowed voltage range for a certain regulator from the
regulator, rail and list of consumer supply limits. It has
understanding of the voltages it tries to set.

> HIGH_IMPEDANCE isn't really a bias option, it's a lack of a drive option.

Hm, do you mean that PIN_CONFIG_BIAS_DISABLE
and PIN_CONFIG_BIAS_HIGH_IMPEDANCE should be merged
into one option?

>> OK the day someone needs to do this it can be refactored,
>> I don't think this needs to be part of the upfront design.
>> At that point drivers/staging/iio/adc will probably be available
>> in drivers/* and it can be modelled using the proper abstraction
>> for these registers anyway.
>
> One potential issue here; this will make it more difficult to create a
> device-tree binding, since the binding needs to be a fixed ABI, whereas
> if we were just talking about an in-kernel structure, we could modify it
> all we want without as much backwards compatibility.

But that must apply to *any* subsystem which wants to change the
way configuration in which data is to be passed in, not unique to
pin control really? Is DT only for things that have fixed ABI?
Since this is a kernel-internal API I smell a violation of
Documentation/stable_api_nonsense.txt ...

So in that case maybe pincontrol is not mature for DT bindings
yet. Maybe that is something for mature subsystems like
I2C, memory-mapped IO, IRQ numbers, even GPIO ... etc
for the time being.

In the powerpc world it is a common custom to update the device
tree(s) in arch/powerpc/boot/dts/* and drivers or platform code
in the same patch even. (C.f. commit
0b5cf10691eb2c95a9126bf25f5e084d83d5d743) I take it that
this needs to be allowed also on ARM.

I think at one point in a conference in Prague it was agreed that
DTS files will be kept inside the kernel for the initial submissions,
and at the same time it was said that this was precisely because
bindings will likely be changing quite a bit.

If ARM DTS files are indeed broken out of the kernel git,
well they will just have to be kept in sync I believe?

>> As discussed in the other thread with Thomas the way this is done
>> for most systems is in drive stage multiples vs nominal load
>> impedance (usually capacitive, but we don't need to specify that) for one drive
>> stage as described in this forum thread:
>> http://www.edaboard.com/thread74140.html
>>
>> Which means the argument should be number of drive stages.
>
> That thread is just one person's assertions. I have no way to judge
> if they're really globally true or not. I'd be hesitant to based any
> decisions on one random unauthenticated thread on some random forum.

Well I'm trying to check in text books. But how many ways of
designing push/pull can there be (practical, not theoretical)?

> I wonder why Tegra's driver strengths are 1, 1/2, 1/4, 1/8 if they're
> Implemented like that forum thread says. While I suppose it's entirely
> possibly there are an extra 1, 1, 2, 4 transistors for each level, it
> seems more likely that there would be 1 extra transistor per level
> giving drive strengths of 1, 3/4, 1/2, 1/4. However, I'm just randomly
> conjecturing here...

Hm. Since the terminology seems related I would *guess* something
like 1 = 8 transistors (4 up 4 down), 3/4 = 6 transistors (3 up 3 down),
1/2 = 4 transistors (2 up 2 down), 1/4 = 2 transistors (1 up 1 down).

So the number would be "number of driving stages as related
to the maximum available" and the maximum is 4 driving stages.

So then it would indeed make sense to define the parameter
argument as "number of active driving stages" so it becomes:

# driving stages     S3C       Tegra
1                          1x          1/4
2                          2x          1/2
3                          N/A        3/4
4                          4x          1
8                          8x          N/A

Atleast it makes logical sense.

I'm a bit worried if we're writing drivers for hardware where the
documentation is so sparse that we don't really know what
we're doing... How do you know how to select between say the
1/2 and 1/4 setting today? The subsystem will have a hard time
to compensate for lack of engineering documentation whatever
it comes to :-(

>> > Shouldn't that be just PIN_CONFIG_INPUT_SCHMITT with a boolean parameter
>> > to indicate whether it's enabled?
>>
>> To match the PIN_CONFIG_DRIVE_OFF this is more logical I think,
>> there is no shortage of enums.
>
> Sure, but given Schmitt is a single logical thing that can be turned on
> and off, and the API is a param/value style API, surely the param should
> be "is Schmitt enabled" and the value "on/off" or "yes/no".

OK I'll change it.

I also defined low power mode 0 to mean normal power mode
(low power mode off) and changed
PIN_CONFIG_WAKEUP_ENABLE/DISABLE to just
PIN_CONFIG_WAKEUP with arguments 1 for enable
and 0 for disable.

Should we also join PIN_CONFIG_BIAS_DISABLE and
PIN_CONFIG_BIAS_HIGH_IMPEDANCE (as was hinted above)
and possibly CONFIG_DRIVE_OFF could be rewritten as
"any of PIN_CONFIG_DRIVE_* with an argument of zero".

>> > In order to specify rates, you'd also need to define what load capacitance
>> > was being driven; rate isn't an independent value. I wonder if a standard
>> > load inductance would also need to be specified.
>> >
>> > Tegra's slew rates are not specified in nanoSeconds. Now it may be that
>> > for a given load capacitance, each rate does indeed map to a specific
>> > rise time. However, the documentation isn't written that way. Getting the
>> > documentation changed to specify times simply isn't going to happen; it's
>> > hard enough to just get the documentation in the first place for some of
>> > the pinmux stuff. In fact, even calculating what those times are probably
>> > isn't possible right now (for me at least, and the low-level pad designers
>> > probably have better things to do).
>>
>> OK so how is the slew rate specified in the specs you have?
>> Is it just some magic number? If it turns out all platforms only have
>> unspecified magic numbers for slew rate settings we'd better
>> just leave this argument as custom then.
>
> Yes. The exact text is e.g.:
>
> DRVDN_SLWR - Driver Output Rising Edge Slew 2-bit control code. Code 11
> is least slewing of signal, code 00 is highest slewing of the signal.

So when you attach some electronics to this SoC, how do you
choose which value to poke in there? Trial-and-error?
Again I think we need to understand the things we're trying
to program. That documentation is lacking is bad, but do we
really want to design the subsystem around lacking documentation
instead of deeper understanding?

The Nomadik GPIO is described like this in the manual for
AP9500 used in the Snowball (page 775)
http://www.stericsson.com/developers/DM00030004_AP9500_reference_manual_rev1.pdf

"The GPIO1B_LOWEMI register is used to control the IO pad
  current slew rate. When LOWEMI= ‘1’, the normal slew rate is
  slashed to half of its normal value, us enabling Low EMI mode. In
  normal case, LOWEMI=’0’."

So I wouldn't know much about rise and fall times either. But
"slashed in half" is pretty clear, so I guess the argument might
be formulated as "fractions of maximum slew rate", so if the slew
rate can be contolled in 8 steps the argument 7 gives 7/8
slew rate, argument 2 gives 2/8 = 1/4 slew rate compared to
nominal etc. This is similar to the proportional number of
driving stages suggested for PIN_CONFIG_DRIVE_*

>> >> + * @PIN_CONFIG_LOAD_CAPACITANCE: some pins have inductive characteristics and
>> >
>> > That should say "capacitive"; inductance is something else AIUI.
>>
>> No actually not. See below:
>>
>> >> + *   will deform waveforms when signals are transmitted on them, by
>> >> + *   applying a load capacitance, the waveform can be rectified. The
>> >> + *   argument gives the load capacitance in picofarad (pF)
>>
>> So the pin (or the wire connected to it) has inductive properties,
>> and you compensate by adding load capacitance.
>
> I don't think that's correct.
>
> Any electrical device has both some intrinsic capacitance and inductance.
> These are orthogonal fundamental properties.

Yes I think I have understood so far atleast :-)

> Now, it's entirely possible that if your device's inductance is high (or
> perhaps for other reasons too), you explicitly add some capacitors to
> absorb spikes that occur when switching the device on or off, but that
> doesn't make inductance part of the definition of capacitance.

I think I have misunderstood this thing, or don't understand it
properly, so I'll remove it as it's not needed for now. I though it
was there to compensate for ringing, but it may be that the
datasheet is just expressing drive strengths 1x and 2x in some
odd way.

The same datasheet had another interesting pin property too:
debounce time :-) OMAP also seems to have that,
and an associate debounce time.

>> > so having two PIN_CONFIG values doesn't make
>> > sense; we'd have to use the value for e.g. LOW_POWER_MODE to represent the
>> > desired HW value, and ignore NORMAL_POWER_MODE, I think.
>>
>> NORMAL_POWER_MODE is intended to return the pin from any low-power
>> mode in analogy with say BIAS_DISABLE or DRIVE_OFF, SCHMITT_OFF
>> so it's to make the code symmetric and readable, not to make the minimal
>> number of enumerators. I think this is better syntax than say, specifying that a
>> zero argument to LOW_POWER_MODE means "low power mode off"
>
> Maybe this is representing something different than what Tegra's LPMD
> bits are then.
>
> On Tegra, this isn't a kind of "turn off and consume less power" toggle,
> but rather a way of configuring the pin while it's active; it's a value
> 0..3 (on Tegra20 at least) that interacts with the other drive strength
> and slew rate properties and affects overall active pin performance.

Hm, I don't follow this quite... what is it then? How do you select
the apropriate value in your code?

>> > There was some discussion about having to call pin_config_group many
>> > Times to set up e.g. 5 different parameters on a single group. Should
>> > pin_config_group accept a list of param/data pairs, or a struct pin_config
>> > instead? The latter would also need some NA/don't-change indication for
>> > each field.
>>
>> struct pin_config was mainly thought of as a state container, bolting
>> a lot of "changed" fields on it seems kludgy.
>>
>> So both pin_config() and pin_config_group() should rather take a list
>> of config params + data.
>
> A list sounds good.

I'm going back and forth on this.

But I'll code up something with tuple-lists to the config functions and
see what it looks like, just as good to try it out.

Thanks,
Linus Walleij
