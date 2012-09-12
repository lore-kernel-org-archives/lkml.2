Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2ILVKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 17:10:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49172 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab2ILVKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 17:10:41 -0400
Message-ID: <5050FA4C.8040406@wwwdotorg.org>
Date: Wed, 12 Sep 2012 15:10:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Lior Amsalem <alior@marvell.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Linus Walleij <linus.walleij@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Rob Landley <rob@landley.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/9] pinctrl: mvebu: pinctrl driver core
References: <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com> <1347266386-16229-1-git-send-email-sebastian.hesselbarth@gmail.com> <1347266386-16229-2-git-send-email-sebastian.hesselbarth@gmail.com> <20120911164409.4c030bd8@skate> <504FB869.60201@wwwdotorg.org> <20120912085423.21af58d5@skate>
In-Reply-To: <20120912085423.21af58d5@skate>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 12:54 AM, Thomas Petazzoni wrote:
> Le Tue, 11 Sep 2012 16:17:13 -0600,
> Stephen Warren <swarren@wwwdotorg.org> a écrit :
> 
>>
>> +static struct mvebu_mpp_mode dove_mpp_modes[] = {
>> +	MPP_MODE(0,
>> +		MPP_FUNCTION(0x00, "gpio", NULL),
>> +		MPP_FUNCTION(0x02, "uart2", "rts"),
>> +		MPP_FUNCTION(0x03, "sdio0", "cd"),
>> +		MPP_FUNCTION(0x0f, "lcd0", "pwm"),
>> +		MPP_FUNCTION(0x10, "pmu", NULL)),
>>
>> it's defining the functions within the context of a particular group
>> ("mode" in the drivers terminology, I think...) rather than defining
>> functions and groups as separate top-level tables.
> 
> This data structure really reflects what the datasheet says. Typically,
> for SoCs where each pin is independently muxable (AT91, i.MX23/28,
> Marvell, and probably many more), the datasheet has a big array, with
> one line per pin, and then several columns which tell for a given pin,
> what is "function 0", "function 1", "function 2", "function 3", etc.
> 
> So the data structure that Sebastian has implemented in the mvebu
> driver immediately reflects this. In fact, the pinctrl table code for
> Armada 370 and Armada XP was semi-automatically generated from CSV data
> of the pinmux functions, directly coming from the datasheets.

OK, that seems like a reasonable explanation.

Still, doing data manipulation at run-time when it could easily be done
by the script that converts your CSV into the driver tables seem
inefficient at least. I agree with LinusW that it's not a big deal though.

> Having to
> create a global list of all possible functions seems useless and
> painful, since the functions only make sense in the context of one
> particular pin.

Surely some of your functions can be selected onto 1 of n pins? If
that's true, then the functions don't only exist within the context of a
single pin.

Note that some pinctrl driver authors have decided to create functions
based on just the mux register values (e.g. mux0, mux1, mux2, mux3 for a
2-bit field) rather than semantically (e.g. uart1, uart2, i2c1, i2c2),
in which case, all functions are global and available on any pin. I
actually somewhat wonder if I shouldn't have done that for Tegra.

> Could you be more specific as to what representation you're looking
> after? You're proposing to "define functions and groups as separate
> top-level tables", but then how to you map which functions are
> available for which group,

The definition of a function is a function name (struct
pinmux_ops.get_function_name) and a list of groups onto which it can be
selected (struct pinmux_ops.get_function_groups).

The pinctrl core leaves it up to individual drivers how to represent how
to actually program a given group with a given function. ...

> and what is the number of that function is
> this group (which we need to actually configure the mapping). I'd
> really like to see (with a short code example) what is your view of how
> pinmux should be handled for SoCs having independently muxable pins.

 As an example, see drivers/pinctrl/pinctrl-tegra20.c variable
tegra20_groups[] where each group definition contains additional
information beyond the basic information that the pinctrl core requires
(which is just struct pinctrl_ops get_group_name get_group_pins) - i.e.
the global function ID that is selected by each of the 4 values you can
write into that pin's/group's register.

Incidentally, I see that tegra20_groups[] is almost exactly equivalent
to the data-structure we're talking about here; the difference is that
the Tegra driver additionally has pre-generated arrays like xio_groups[]
(the list of groups where function xio can be selected) in order to
short-circuit the run-time calculations that your driver is doing.

(I don't believe any of this discussion is affected by whether the HW
muxes at a per-pin level or per-pin-group level; Tegra30 muxes per-pin
and the driver uses the exact same data-structures as Tegra20 which
muxes per-group).
