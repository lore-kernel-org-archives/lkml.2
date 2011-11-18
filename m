Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab1KRWcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 17:32:16 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4689 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab1KRWcO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 17:32:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 18 Nov 2011 14:32:10 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
Date: Fri, 18 Nov 2011 14:32:09 -0800
Subject: RE: [PATCH v2] pinctrl: add a generic pin config interface
Thread-Topic: [PATCH v2] pinctrl: add a generic pin config interface
Thread-Index: AcylLIVwafNOWl86QcGK/RdHShC6IgBEUwEw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740D74FD9@HQMAIL01.nvidia.com>
References: <1321000263-20000-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805B30@HQMAIL01.nvidia.com>
 <CACRpkdYh7+kL-9iy7+VDC82OAkb+-vLiJcv02pappaTeDUriTg@mail.gmail.com>
In-Reply-To: <CACRpkdYh7+kL-9iy7+VDC82OAkb+-vLiJcv02pappaTeDUriTg@mail.gmail.com>
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

Linus Walleij wrote at Thursday, November 17, 2011 6:26 AM:
> Hi Stephen,
> 
> as usual the most thought-provoking review comments come from nVidia,
> many thanks for your time!

Thanks for listening:-)

> On Mon, Nov 14, 2011 at 8:44 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Linus Walleij wrote at Friday, November 11, 2011 1:31 AM:
> >> + * enum pin_config_param - possible pin configuration parameters
> >
> > I'm still not entirely convinced that abstracting all these minutiae is
> > productive.
> 
> We'll see where we end up ... I have similar fears about *not* doing
> it and ending up with some message passing core of too loose or
> none semantics. So bear with me for some patch iterations...
> 
> > I assert that drivers should not be directly manipulating configuration
> > parameters. Instead, they should be requesting some generic named state,
> > and some board-provided data should be mapping that named state to the set
> > of configuration values to apply. Assuming that's true, then there doesn't
> > need to be any generic way of naming/describing what those configuration
> > values are, since only the SoC-specific pinctrl driver and board-specific
> > mapping table will ever deal with the individual values.
> 
> But that is not about this enum.
> 
> This enum is a way to describe states for the pins, which is also
> the interface between the pinconf core and the individual drivers,
> i.e. even with what you say above these enums are useful for
> parameters passed in the functions in struct pinconf_ops.

Yes, whether to expose a pin config API and whether to define a
standardized config enum (possibly only for a pinctrl core <-> pinctrl
driver interface) are indeed two separate things.

> If I rephrased the above to say that these two functions:
> 
> extern int pin_config(struct pinctrl_dev *pctldev, int pin,
>                       enum pin_config_param param, unsigned long data);
> extern int pin_config_group(struct pinctrl_dev *pctldev, const char *pin_group,
>                             enum pin_config_param param, unsigned long data);
> 
> Should not be part of the public API available to the drivers and
> platforms, then I'm game. That's a very valid point. Fixing that
> will require some upfront code (again ... hehe)
> 
> I'll post some V3 with this current scheme though, and think about
> how to proceed with abstracting the group states and getting
> rid of the above for V4.

OK.

The primary thing I want to understand is this:

Assuming we did remove the "public" pin_config APIs, what's the problem
that having a defined enum pin_config_param is solving?

If drivers are deciding what config params and values to set, then I do
see the need for standardized naming; drivers need to be generic across
SoCs.

However, if there is no driver-facing config API, then the data flow is:

* (SoC-specific) board file (or device-tree) provides some data to the
pinctrl core.

* At some appropriate time, pinmux core passes that data to the pinctrl
driver.

I assert that:

* The pinctrl core need not use, understand, or modify the provided data
in any way.

* The data only needs to make sense the SoC-specific pinctrl driver that's
used on the board that originally passed the data to the pinctrl core.

Assuming all that, I see no value in an abstraction; there's no problem
to solve, since no part of the code that handles the values ever has to
both interpret those values and be generic across multiple SoCs.

> >> + * @PIN_CONFIG_BIAS_DISABLE: disable any pin bias on the pin, a
> >> + *   transition from say pull-up to pull-down implies that you disable
> >> + *   pull-up in the process, this setting disables all biasing
> >> + * @PIN_CONFIG_BIAS_HIGH_IMPEDANCE: the pin will be set to a high impedance
> >> + *   mode, also know as "third-state" (tristate) or "high-Z" or "floating".
> >> + *   On output pins this effectively disconnects the pin, which is useful
> >> + *   if for example some other pin is going to drive the signal connected
> >> + *   to it for a while. Pins used for input are usually always high
> >> + *   impedance.
> >> + * @PIN_CONFIG_BIAS_PULL_UP: the pin will be pulled up (usually with high
> >> + *   impedance to VDD), if the controller supports specifying a certain
> >> + *   pull-up resistance, this is given as an argument (in Ohms) when
> >> + *   setting this parameter
> >> + * @PIN_CONFIG_BIAS_PULL_DOWN: the pin will be pulled down (usually with high
> >> + *   impedance to GROUND), if the controller supports specifying a certain
> >> + *   pull-down resistance, this is given as an argument (in Ohms) when
> >> + *   setting this parameter
> >
> > I agree that its unlikely to be common to enable both pull-up and pull-
> > down at the same time, but why should the PIN_CONFIG_ abstraction actively
> > prohibit it?
> 
> I've read the above and fail to see why that would be prohibited
> from the enum alone.
> 
> In practice it does not work however since I track the state like this:
> 
> struct pin_config {
>         enum pin_config_param bias_param;
>         unsigned long bias_data;
>         (...)
> };

Right, that was exactly my point.

Logically, pull-up is one thing you can control, and pull-down is another.
As such, they should have different PIN_CONFIG values, and each have their
own Boolean value.

HIGH_IMPEDANCE isn't really a bias option, it's a lack of a drive option.

> I'd opt for leaving it like this and have the first driver that wants
> to set multiple bias configs simultaneously refactor it to make
> that possible, in the process proving me wrong on the account
> that this is not a useful feature.
>
> > An Soc could easily be designed with a bit to enable each,
> > and hence allow enabling both at once. Perhaps with configurable pull
> > strengths, this could even be used to create a poor-man's A-D converter,
> > or perhaps it could be used to create a reference voltage for something.
> 
> OK the day someone needs to do this it can be refactored,
> I don't think this needs to be part of the upfront design.
> At that point drivers/staging/iio/adc will probably be available
> in drivers/* and it can be modelled using the proper abstraction
> for these registers anyway.

One potential issue here; this will make it more difficult to create a
device-tree binding, since the binding needs to be a fixed ABI, whereas
if we were just talking about an in-kernel structure, we could modify it
all we want without as much backwards compatibility.

> >> + * @PIN_CONFIG_BIAS_HIGH: the pin will be wired high, connected to VDD
> >> + * @PIN_CONFIG_BIAS_GROUND: the pin will be grounded, connected to GROUND
> >> + * @PIN_CONFIG_DRIVE_PUSH_PULL: the pin will be driven actively high and
> >> + *   low, this is the most typical case and is typically achieved with two
> >> + *   active transistors on the output. If the pin can support different
> >> + *   drive strengths for push/pull, the strength is given on a custom format
> >> + *   as argument when setting pins to this mode
> >
> > If the drive-strength argument is custom, this vastly reduces the
> > usefulness of creating this single abstraction; sure a driver could
> > specify PUSH_PULL, but if it then wanted to configure the strength, but
> > couldn't because there was no standardized way of representing that, it
> > seems pointless to create the common abstraction for PUSH_PULL in the
> > first place; what is it achieving? In fact, if a driver just wants to
> > toggle between PUSH_PULL/OPEN_DRAIN, what value should it provide for
> > the value if there's no standardization?
> 
> As discussed in the other thread with Thomas the way this is done
> for most systems is in drive stage multiples vs nominal load
> impedance (usually capacitive, but we don't need to specify that) for one drive
> stage as described in this forum thread:
> http://www.edaboard.com/thread74140.html
> 
> Which means the argument should be number of drive stages.

That thread is just one person's assertions. I have no way to judge
if they're really globally true or not. I'd be hesitant to based any
decisions on one random unauthenticated thread on some random forum.

I wonder why Tegra's driver strengths are 1, 1/2, 1/4, 1/8 if they're
Implemented like that forum thread says. While I suppose it's entirely
possibly there are an extra 1, 1, 2, 4 transistors for each level, it
seems more likely that there would be 1 extra transistor per level
giving drive strengths of 1, 3/4, 1/2, 1/4. However, I'm just randomly
conjecturing here...

> >> + * @PIN_CONFIG_INPUT_SCHMITT: this will configure an input pin to run in
> >> + *   schmitt-trigger mode. If the schmitt-trigger has adjustable hysteresis,
> >> + *   the threshold value is given on a custom format as argument when
> >> + *   setting pins to this mode
> >> + * @PIN_CONFIG_INPUT_SCHMITT_OFF: disables schmitt-trigger mode
> >
> > Shouldn't that be just PIN_CONFIG_INPUT_SCHMITT with a boolean parameter
> > to indicate whether it's enabled?
> 
> To match the PIN_CONFIG_DRIVE_OFF this is more logical I think,
> there is no shortage of enums.

Sure, but given Schmitt is a single logical thing that can be turned on
and off, and the API is a param/value style API, surely the param should
be "is Schmitt enabled" and the value "on/off" or "yes/no".

> 
> >> + * @PIN_CONFIG_SLEW_RATE_RISING: this will configure the slew rate for rising
> >> + *   signals on the pin. The argument gives the rise time in nanoseconds.
> >> + *   You may want to adjust slew rates so that signal edges don't get too
> >> + *   steep, causing disturbances in surrounding electronics for example.
> >> + * @PIN_CONFIG_SLEW_RATE_FALLING: this will configure the slew rate for falling
> >> + *   signals on the pin. The argument gives the fall time in nanoseconds
> >
> > In order to specify rates, you'd also need to define what load capacitance
> > was being driven; rate isn't an independent value. I wonder if a standard
> > load inductance would also need to be specified.
> >
> > Tegra's slew rates are not specified in nanoSeconds. Now it may be that
> > for a given load capacitance, each rate does indeed map to a specific
> > rise time. However, the documentation isn't written that way. Getting the
> > documentation changed to specify times simply isn't going to happen; it's
> > hard enough to just get the documentation in the first place for some of
> > the pinmux stuff. In fact, even calculating what those times are probably
> > isn't possible right now (for me at least, and the low-level pad designers
> > probably have better things to do).
> 
> OK so how is the slew rate specified in the specs you have?
> Is it just some magic number? If it turns out all platforms only have
> unspecified magic numbers for slew rate settings we'd better
> just leave this argument as custom then.

Yes. The exact text is e.g.:

DRVDN_SLWR - Driver Output Rising Edge Slew 2-bit control code. Code 11
is least slewing of signal, code 00 is highest slewing of the signal.

> >> + * @PIN_CONFIG_LOAD_CAPACITANCE: some pins have inductive characteristics and
> >
> > That should say "capacitive"; inductance is something else AIUI.
> 
> No actually not. See below:
> 
> >> + *   will deform waveforms when signals are transmitted on them, by
> >> + *   applying a load capacitance, the waveform can be rectified. The
> >> + *   argument gives the load capacitance in picofarad (pF)
> 
> So the pin (or the wire connected to it) has inductive properties,
> and you compensate by adding load capacitance.

I don't think that's correct.

Any electrical device has both some intrinsic capacitance and inductance.
These are orthogonal fundamental properties.

Now, it's entirely possible that if your device's inductance is high (or
perhaps for other reasons too), you explicitly add some capacitors to
absorb spikes that occur when switching the device on or off, but that
doesn't make inductance part of the definition of capacitance.

> >> + * @PIN_CONFIG_LOW_POWER_MODE: this will configure the pin for low power
> >> + *   operation
> >> + * @PIN_CONFIG_NORMAL_POWER_MODE: returns pin from low power mode
> >
> > Is this meant to represent Tegra's "low power mode" configuration? That's
> > a four-level value on Tegra,
> 
> OK I added that the argument to low power mode can contain a custom power
> state enumerator.
> 
> > so having two PIN_CONFIG values doesn't make
> > sense; we'd have to use the value for e.g. LOW_POWER_MODE to represent the
> > desired HW value, and ignore NORMAL_POWER_MODE, I think.
> 
> NORMAL_POWER_MODE is intended to return the pin from any low-power
> mode in analogy with say BIAS_DISABLE or DRIVE_OFF, SCHMITT_OFF
> so it's to make the code symmetric and readable, not to make the minimal
> number of enumerators. I think this is better syntax than say, specifying that a
> zero argument to LOW_POWER_MODE means "low power mode off"

Maybe this is representing something different than what Tegra's LPMD
bits are then.

On Tegra, this isn't a kind of "turn off and consume less power" toggle,
but rather a way of configuring the pin while it's active; it's a value
0..3 (on Tegra20 at least) that interacts with the other drive strength
and slew rate properties and affects overall active pin performance.

> > There was some discussion about having to call pin_config_group many
> > Times to set up e.g. 5 different parameters on a single group. Should
> > pin_config_group accept a list of param/data pairs, or a struct pin_config
> > instead? The latter would also need some NA/don't-change indication for
> > each field.
> 
> struct pin_config was mainly thought of as a state container, bolting
> a lot of "changed" fields on it seems kludgy.
> 
> So both pin_config() and pin_config_group() should rather take a list
> of config params + data.

A list sounds good.

-- 
nvpublic

