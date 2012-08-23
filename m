Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229Ab2HWV0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:26:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43935 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045Ab2HWV0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:26:12 -0400
Message-ID: <50369FEE.8000003@wwwdotorg.org>
Date: Thu, 23 Aug 2012 15:26:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/9] pinctrl: mvebu: pinctrl driver core
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com> <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com> <1345623750-10645-2-git-send-email-sebastian.hesselbarth@gmail.com> <5035445B.6000500@wwwdotorg.org> <CABJ1b_Tdr80DGqb-FRzwDbF3m7g6fBguk5GtRAfRUYx5Sqy_cA@mail.gmail.com> <50366E44.4030606@wwwdotorg.org> <50369305.6050304@gmail.com>
In-Reply-To: <50369305.6050304@gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 02:31 PM, Sebastian Hesselbarth wrote:
> On 08/23/2012 07:54 PM, Stephen Warren wrote:
>>> dt_parse() and dt_parse_function() build up structs that get used
>>> later on
>>> in mvebu_pinmux_ops that require indexed functions. I can join them with
>>> dt_node_to_map() but that would require incremental kzalloc for the
>>> corresponding array. Or I could (functionally) leave dt_parse() to
>>> allocate
>>> the array and only join dt_parse_function() with dt_node_to_map().
>>
>> So everything you said makes sense, in that the core driver is
>> parameterizable and receives data from a SoC-variant-specific driver
>> indicating which pins/groups/functions are available. I'm still not sure
>> though why the translation of the pin/group/function structures passed
>> to probe into other data structures requires accessing the DT at all;
>> the set of available pins/groups/functions isn't configured through DT,
>> and doesn't need to be limited to only those options actually used in
>> DT, so can't you just process all the data that's passed to probe
>> without interaction with the DT?
> 
> Hmm, maybe I still don't quite understand the terminology of pinctrl/pinmux
> core completely. What exactly should mvebu_pinmux_get_funcs_count return
> if not the number of DT node children?

In HW, you have:

* A number of pins

* In some cases, multiple pins are controlled by a single register
field, so there are groups of pins, whose pins all get mux'd at once.

* In some cases, SW chooses to control multiple pins at once even if the
HW allows otherwise, and these are also represented as groups.

* A (mux) function represents what options (signals, modules, ...) are
available to be mux'd onto any given pin or group of pins.

If all of your pins/groups can support 4 different mux choices 0..3
(even though the interpretation of values 0..3 may differ per pin/group)
you may simply have functions 0, 1, 2, 3 exposed by your driver.

Alternatively, you may define a function for each logical HW module
(e.g. UART1, UART2, SPI1, SPI2, MMC1...) that exists in your SoC, or
even per each separate subset of signals (e.g. UART1 RX/TX, UART 1
RTS/CTS, UART 2 RX/TX/RTS/CTS, ...).

In a driver where the set of pins, groups, and functions known to the
driver is defined as static data in the driver itself (which I believe
covers your driver; IIRC I saw all those tables in the patch), then
you'd simply count up all the defined function names/IDs available, and
return that from pinmux_ops.get_functions_count(). In this case, the
number of functions is entirely static, being defined by the SoC HW
design, and hence DT content has absolutely no impact on it. For
reference, this is how the Tegra pinctrl drivers work.

In a driver where the set of pins, groups, and functions known to the
driver is not hard-coded into the driver itself, but instead derived
from DT content (which is useful for a driver that works for say 10
different similar SoCs, each with slightly different sets of actual
pins/groups/functions, but where you don't want to hard-code all the
tables into the driver), then you may need to parse DT to extract the
definitions of those pins/groups/functions. Then, there's the question
of how to represent the set of known pins/groups/function in DT; do you
have explicit tables for this, or reverse engineer the tables based on
whichever pins/groups/function just happen to be used by the board
you're running on, in which cases the reverse-engineered lists will
probably not include all options the HW could support, given one
particular DT file. Anyway, as I said, I don't think this approach
applies to your driver anyway since IIRC I did see all the data tables
in the patch.

As you may have guessed, I strongly prefer the hard-coded static table
based approach, or at least separating the definition of known
pins/groups/functions from the configuration nodes that define which
particular mux settings to actually use.

Puting this all a little more simply, the pinctrl core wants to generate
a list of all known functions. It is a single global/unified list. It
first calls pinmux_ops.get_functions_count() to find out how many
functions there are in the list, then pinmux_ops.get_function_name() for
each one to find its name, then pinmux_ops.get_function_groups() to find
out which groups allow that function to be mux'd onto them.
