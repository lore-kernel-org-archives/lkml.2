Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab1JTJdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:33:00 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48472 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab1JTJc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:32:59 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173CA2CBE1@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A166@HQMAIL01.nvidia.com>
	<CACRpkdYR=Dgd=Ohp=jOh-VpxGFFb4dYniN6N-Zaj9y6uuGDftg@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF173CA2CBE1@HQMAIL01.nvidia.com>
Date: Thu, 20 Oct 2011 11:32:58 +0200
Message-ID: <CACRpkdaecf-3OhSFUa4NPGgHqa13wwMwWdd3gDhqop=T_JfL9w@mail.gmail.com>
Subject: Re: pinctrl_config APIs, and other pinmux questions
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 8:02 PM, Stephen Warren <swarren@nvidia.com> wrote:
> [Me]
>> 1) The need to configure per-pin "stuff" like biasing, driving,
>>   load capacitance ... whatever

I sent of a proposal for this so we get somewhere...

>> 2) The need to handle state transitions of pinmux settings.

Still uncertain about this.

>> Do you mean
>> int (*group_config)(const char *group, u32 param, u32 data);
>>
>> On the latter one? We identify groups by name mainly.
>> The selectors is an internal thing between pinctrl core and
>> drivers.
>
> That was a proposal for the core->driver API, so I think using an int
> instead of a string makes sense?

Yes, sorry, I was wrong.

>> I'd rather opt to just remove
>> the TEGRA_ prefix from all the above, and that we try to create some
>> common sematics to these calls.
>
> Hmm. Keys seem to have a bit more uniform behavior than the various
> pin configuration data. Still, I guess I'm fine defining some unified
> numbering space for all the parameters, so long as we can add Soc-specific
> entries to the list when they don't match anything from other SoCs.

There is such an option but after looking it over I think we can actually
unify the stuff quite a bit. For example I notice terminology like
setting a pin "floating", "tristate", "high-z" etc, basically mean the
same thing: high impedance, i.e. disconnect it.

Check the patch I just sent out for reference.

>> So I prefer we say:
>> int (*pin_config)(unsigned pin, u32 param, unsigned long data);
>> int (*group_config)(const char *group, u32 param, unsigned long data);
>
> For the data function parameter, that's the same as my proposal, except
> for "unsigned long" rather than "u32".

Yep!

>> So I think we should have pin group states in a similar
>> manner:
>>
>> enum pinmux_state {
>>     PINMUX_STATE_DEFAULT, /* == active */
>>     PINMUX_STATE_LOWPOWER,
>> };
>>
>> And associated calls:
>>
>> pinmux_set_state(const char *group, enum pingroup_state state);
>
> I don't think the pinctrl SoC driver could define what the param values
> are for such a set of states; the set of parameters to vary, and the
> values to set them to, is most likely board-specific.

Controller-specific and board specific. I do not intend to enumerate
all the possible states of the *system* just of the pins of the
pin controller.

> Now, a board probably could define such a set of "states". Perhaps we'd
> end up with the board supplying both a mapping table, and a "config
> states" table.

Pinmux config states rather than pingroup states I think. For setting
individual pins and groups of pins we need something else.

> I suppose if the APIs to change pin config params between
> states is separate from the API to acquire ownership of the pins and set
> pin mux, as you proposed later in your email, then having two tables does
> make some sense.

Well yes, now I am worried that we're confusing generic pin or
pin group configuration (say biasing and such) with pinmux
states.

pinmux settings likely have power states too - like often you want
to decouple the pins from some SDIO bus, turn them into regular
GPIO and ground them when you go to sleep. (Reverse on the way
up to running.) This could be done with pinmux states, possibly
implemented by using pin groups etc in the pin controller driver.

One abstraction is to create pin group states,
then also have pinmux states that reuse those group states on
it's assigned group(s).

> However, what if you want to change between mux settings without going
> via any intermediate "safe" mux settings?
>
> That was the main reason I suggested putting both the mux and config
> values into the same mapping table, so either or both could be switched
> using the same state-switching API.
>
>> If this has to follow some specific order like first go
>> from group A -> B -> C should probably be handled in
>> the driver since that's definately HW-specific, else we start
>> embedding some scripting engine in the pinctrl core
>> and that would be most unfortunate (IMO).
>
> I'm not sure if the driver is the place to make the decision; I think it
> would be board-specific; (...)

I am aware of the problem, but for the moment I feel strongly
that state transitions is a problem for the individual drivers,
albeit in their way of handling a particular board.

(We have a similar problem in Nomadik-gpio actually.)

If the drivers need help with state transition it should be in the
form of some pincontrol helper, and platform data passed directly
into the pin controller driver, not to the core.

But I have not formulated some final opinion on this or something
like that, so let's keep the subject open.

> I did wonder while writing my original email if the mapping table should
> become a sequence of instructions rather than an unordered list of settings.
> I don't see a need for conditionals, loops, functions, or anything more
> than just an ordered sequence of mux or config settings though.

I think the term used for this kind of things is "jam table
interpreter".

Ref: Hacking the Xbox: an introduction to reverse engineering
by Andrew Huang:

"A jam table is industry vernacular for a table of values that
 contains opcodes for reads, writes and simple decision
 operations, used in the context of hardware initializations".

Something like that, or close. But it's a complex thing and I'd
prefer to keep it as close to the actual hardware as possible,
since I currently have not clue on how generic this problem will
be.

Yours,
Linus Walleij
