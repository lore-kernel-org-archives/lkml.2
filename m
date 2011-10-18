Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab1JRSCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 14:02:52 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2773 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1JRSCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 14:02:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 18 Oct 2011 11:02:20 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Stijn Devriendt <highguy@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>
Date: Tue, 18 Oct 2011 11:02:18 -0700
Subject: RE: pinctrl_config APIs, and other pinmux questions
Thread-Topic: pinctrl_config APIs, and other pinmux questions
Thread-Index: AcyM3es704B+zR9bRDeaaDXMJ0uk/wA3wIww
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173CA2CBE1@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A166@HQMAIL01.nvidia.com>
 <CACRpkdYR=Dgd=Ohp=jOh-VpxGFFb4dYniN6N-Zaj9y6uuGDftg@mail.gmail.com>
In-Reply-To: <CACRpkdYR=Dgd=Ohp=jOh-VpxGFFb4dYniN6N-Zaj9y6uuGDftg@mail.gmail.com>
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

Linus Walleij wrote at Monday, October 17, 2011 9:03 AM:
> Thanks for a long letter, took som time to read, but as usual it
> contains good stuff!
> 
> I think you're talking about two things here:
> 
> 1) The need to configure per-pin "stuff" like biasing, driving,
>   load capacitance ... whatever
> 
> 2) The need to handle state transitions of pinmux settings.

Yes, that's true.

> I prefer that we try to keep these two separate and not conflate
> them too much.
> 
> On Thu, Oct 13, 2011 at 10:59 PM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > 2) Enhance the pin controller subsystem to support configuring these
> > properties.
> 
> This is definately what we want to do. That is why the subsystem was
> renamed from pinmux to pinctrl in the first place, and also the rationale
> for introducing the abstract pin groups.
> 
> > int (*pin_config)(unsigned pin, u32 param, u32 data);
> > int (*group_config)(unsigned group, u32 param, u32 data);
> 
> Do you mean
> int (*group_config)(const char *group, u32 param, u32 data);
> 
> On the latter one? We identify groups by name mainly.
> The selectors is an internal thing between pinctrl core and
> drivers.

That was a proposal for the core->driver API, so I think using an int
instead of a string makes sense?

> > Where "param" is some driver-specific parameter, such as:
> >
> > #define TEGRA_PINCTRL_PARAM_TRISTATE_ENABLE    0
> (...)
> > I looked at a bunch of existing pinmux drivers in the mainline kernel.
> > There are certainly some common concepts between SoCs. However, the
> > details are often different enough that I don't think attempting to
> > unify the set of configuration options will be that successful; I
> > doubt we could create a generic enough abstraction of these settings
> > for a cross-SoC driver to be able to usefully name and select values
> > for all the different pin/group options.
> 
> I don't know, I could easily say the same thing about say input devices:
> all of them are essentially different, still they opted to create the file
> <linux/input.h> with this kind of stuff:
> 
> ...
> #define KEY_COMMA               51
> #define KEY_DOT                 52
> #define KEY_SLASH               53
> #define KEY_RIGHTSHIFT          54
> #define KEY_KPASTERISK          55
> ...
> 
> And it has proven to be very useful. I'd rather opt to just remove
> the TEGRA_ prefix from all the above, and that we try to create some
> common sematics to these calls.

Hmm. Keys seem to have a bit more uniform behavior than the various
pin configuration data. Still, I guess I'm fine defining some unified
numbering space for all the parameters, so long as we can add Soc-specific
entries to the list when they don't match anything from other SoCs.

> > Data being a plain u32 rather than a pointer as your v7 patchset had it:
> 
> Actually it looked like this:
> 
> static inline int pinmux_config(struct pinmux *pmx, u16 param,
>                                unsigned long *data)
> 
> That was supposed to be an unsigned long (not a *pointer), which
> is exchangeable to pointer, as per the example known from
> interrupt handlers. It can also be used to pass a plain argument.
> It was designed to be "ioctl()-like".
> 
> So I prefer we say:
> int (*pin_config)(unsigned pin, u32 param, unsigned long data);
> int (*group_config)(const char *group, u32 param, unsigned long data);

For the data function parameter, that's the same as my proposal, except
for "unsigned long" rather than "u32".

...
> > Now let's suppose that we've enhanced the mapping table to support pin/
> > group_config values, and that a driver is written to expect a pinmux
> > mapping table with the following mappings:
> >
> > "active"
> > "suspend"
> 
> I'm not following why this should be different mappings.
> 
> I would rather contrast it with the similar concept from the
> regulator framework, these have modes like these:
> 
> enum regulator_status {
>         REGULATOR_STATUS_OFF,
>         REGULATOR_STATUS_ON,
>         REGULATOR_STATUS_ERROR,
>         /* fast/normal/idle/standby are flavors of "on" */
>         REGULATOR_STATUS_FAST,
>         REGULATOR_STATUS_NORMAL,
>         REGULATOR_STATUS_IDLE,
>         REGULATOR_STATUS_STANDBY,
> };
> 
> So I think we should have pin group states in a similar
> manner:
> 
> enum pinmux_state {
>     PINMUX_STATE_DEFAULT, /* == active */
>     PINMUX_STATE_LOWPOWER,
> };
> 
> And associated calls:
> 
> pinmux_set_state(const char *group, enum pingroup_state state);

I don't think the pinctrl SoC driver could define what the param values
are for such a set of states; the set of parameters to vary, and the
values to set them to, is most likely board-specific.

Now, a board probably could define such a set of "states". Perhaps we'd
end up with the board supplying both a mapping table, and a "config
states" table. I suppose if the APIs to change pin config params between
states is separate from the API to acquire ownership of the pins and set
pin mux, as you proposed later in your email, then having two tables does
make some sense.

> > Where the only difference between those two mappings is some pin/
> > group_config value. When switching between those two settings, the "active"
> > mux values will be rolled back to some "safe" values, then the "suspend"
> > mux values will be re-programmed. This may cause spurious changes in output
> > signals, depending on what the "safe" function is exactly. It might even
> > temporarily change some pins from inputs to outputs.
> 
> A pinmux_set_state() function all the way down to the driver
> could handle this I think.

Such a function would handle changing config params just fine.

However, what if you want to change between mux settings without going
via any intermediate "safe" mux settings?

That was the main reason I suggested putting both the mux and config
values into the same mapping table, so either or both could be switched
using the same state-switching API.

> If this has to follow some specific order like first go
> from group A -> B -> C should probably be handled in
> the driver since that's definately HW-specific, else we start
> embedding some scripting engine in the pinctrl core
> and that would be most unfortunate (IMO).

I'm not sure if the driver is the place to make the decision; I think it
would be board-specific; any requirements for this are driven by what is
connected to the pins in question on a particular board, and hence which
functions conflict with the connected HW, and that's something only the
board-specific mapping table could know about. Oh, and the issue is more
that we'd want to go straight from A -> B and not A -> SAFE -> B, where
SAFE would be a requirement if we had to disable(A) enable(B) rather than
just having A selected, then calling switch_to(B).

I did wonder while writing my original email if the mapping table should
become a sequence of instructions rather than an unordered list of settings.
I don't see a need for conditionals, loops, functions, or anything more
than just an ordered sequence of mux or config settings though.

-- 
nvpublic

