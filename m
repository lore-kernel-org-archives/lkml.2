Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab1IAI7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 04:59:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64306 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab1IAI7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 04:59:06 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B3279BD7@HQMAIL01.nvidia.com>
References: <1314609001-28052-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B3279BD7@HQMAIL01.nvidia.com>
Date: Thu, 1 Sep 2011 10:59:05 +0200
Message-ID: <CACRpkdaWbgiaJvvjDgBWFTpC6P=XcG6fm+L8rnjv9rxDxgs_YQ@mail.gmail.com>
Subject: Re: [PATCH 1/4 v5] drivers: create a pin control subsystem v5
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>, Barry Song <21cnbao@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 11:32 PM, Stephen Warren <swarren@nvidia.com> wrote:

> 1) There is still a 1:1 correspondence between what a function in the
> pinmux core<->driver interface, and the pinmux mapping table. I believe
> we need a 1:n correspondence.

Yes I know that, but the positions were never
about solving that issue.

What you are requesting (just like earlier) is
that one requlator_get() should be able to
retrieve multiple map entries and enable/disable
them.

I 've been working on that, it's just a bit tricky.

> i.e. rather than:
>
> driver function/position list:
> function@position pins
> ----------------- ----
> mmc0@0            0, 1, 2, 3
> mmc0@1            0, 1, 2, 3, 4, 5
> mmc0@2            0, 1, 2, 3, 4, 5, 6, 7, 8, 9
>
> core mapping table:
> driver  name  function@position
> ------  ----  -----------------
> mmc0    2-bit mmc0@0
> mmc0    4-bit mmc0@1
> mmc0    8-bit mmc0@2

There is no combined function@postion,
these are two were separate fields in the
struct pinmux_map.

What I wanted to express was the noted feature of the
hardware to have the same function in several positions
simply, believing it would be more intuitive.

But since the positions does not seem to be the
answer to the question I've just ripped them out
again. It is now (v6) replaced with a pin group
concept which I hope is closer to what you want.

> I'd far rather see:
>
> driver function list:
> function
> ---------
> mmc0

Can now be found in
<debugfs>/pinctrl/pinctrl.0/pinmux-functions

It will now show the list of different groups that the
function can use.

So a function has 1..* groups associated with it.

Example from U300:

root@ME:/debug/pinctrl/pinctrl.0 cat pinmux-functions
function: power, groups = [ powergrp ]
function: uart0, groups = [ uart0grp ]
function: mmc0, groups = [ mmc0grp ]
function: spi0, groups = [ spi0grp ]

Just one group per function here but can be many.

> driver pin/pingrup list: (names of pins or pingroups):
> pingroup
> --------
> A
> B
> C

Can now be found in
<debugfs>/pinctrl/pinctrl.0/pingroups

Example from U300:

root@ME:/debug/pinctrl/pinctrl.0 cat pingroups
registered pin groups:
group: powergrp, pins = [ 0 1 3 31 46 47 49 50 61 62 63 64 78 79 80 81
92 93 94 95 101 102 103 104 115 116 117 118 130 131 132 133 145 146
147 148 159 160 172 173 174 175 187 188 189 190 201 202 211 212 213
214 215 218 223 224 225 226 231 232 237 238 239 240 245 246 251 252
256 257 258 259 264 265 270 271 276 277 278 279 284 285 290 291 295
296 299 300 301 302 303 309 310 311 312 319 320 321 322 329 330 331
332 341 342 343 344 358 359 360 361 372 373 374 375 388 389 390 391
402 403 404 405 413 414 415 416 427 428 429 430 443 444 455 456 457
458 ]
group: uart0grp, pins = [ 134 135 136 137 ]
group: mmc0grp, pins = [ 166 167 168 169 170 171 176 177 ]
group: spi0grp, pins = [ 420 421 422 423 424 425 ]

Notice that it's not prefixed with the string
"pinmux-", it's just a number of groups of pins,
which can be used for anything, one usecase is
muxing. So I now have an abstract pin group
concept and the pinmux function has atleast
one such group associated.

> core mapping table:
> driver  name  position  function
> ------  ----  --------  ---------
> mmc0    2-bit A         mmc0
> mmc0    4-bit A         mmc0
> mmc0    4-bit B         mmc0
> mmc0    8-bit A         mmc0
> mmc0    8-bit B         mmc0
> mmc0    8-bit C         mmc0

Now the struct pinmux_map entries look
like this:

struct pinmux_map {
        const char *name;
        struct device *ctrl_dev;
        const char *ctrl_dev_name;
        const char *function;
        const char *group;
        struct device *dev;
        const char *dev_name;
};

Correspondance per above would be:

dev_name, name, group, function

function and group names shall match what is
presented from the pin controller driver.

You can thing of this as SQL:

SELECT ctrl_dev_name,
TOP 1
  FROM MAPS
  WHERE dev_name = device_name
  AND ctrl_dev_name = ctrl_dev_name
  AND function = function
  AND group = group

(the struct device * entries are for the shiny world
where we can access all struct device * at boot or
so)

Then it's the first point about multiple maps
per mux again I guess, when you write like this:

> mmc0    8-bit A         mmc0
> mmc0    8-bit B         mmc0
> mmc0    8-bit C         mmc0

I assume you mean that semantically this shall
be a 1..* relation, so that if I say:

pmx = pinmux_get(&dev, "8-bit");

Then all pins in the union {A, B, C} shall be
allocated and enabled/disabled simultaneously.

so it'd be like the database equivalent:

I am working on that...

> Note again that I'm assuming above that the driver-supplied function and
> pingroup list included all possible options the SoC HW supports, whereas
> the mapping table would include just those configurations ever actually
> used by the particular board the code is executed upon; from board files
> or devicetree data.

This is my current working assumption also.

The pinmux driver should nominally expose all functions in all
possible positions.

Then the pinmux_map maps usually one but sometimes
more of these {function, position} tuples to the device.

And, you also request the currently not implemented
extenstion that a mux can match multiple map entries.

I'll fix.

> Hence, a given board would only need rows 0, 1+2, or
> 3+4+5 from the mapping table shown above, assuming the width of the MMC
> port didn't vary at run-time.

OK we're on the same page I think. If I fix this, then
you're happy?

> 2) "Positions" are defined per "function", rather than as a global concept.
>
> This leads to positions having meaningless integer names. As such,
> constructing the mapping table will be error-prone; who could remember
> that position 0 is a 2-bit bus using a certain set of pins, yet position
> 1 is an 8-bit bus using a different set of pins? I suppose textual names
> might help here. However, by replacing the concept of positions with
> multiple explicit entries in the mapping table (as in my example above),
> that problem is solved; we name the pins (or pingroups) to which we apply
> the driver-level function in each entry, thus it's more self-documenting.

Again I can replace position integers with strings if that is what
you want?

> 3) It's unclear how well pinmux_config() can be applied.

Agee. I will delete this function from pinmux_ops since
it seems it will only be abused for things that are
unrelated to muxing. No shoehorning...

> Some pin parameters might be defined per:
>
> * Pin (probably most systems other than Tegra)
> * Pin group (for pull-up/down, tristate on Tegra)
> * Drive group (another set of groups of pins on Tegra that arbitrarily
> overlap/intersect with the mux pin groups (for drive-strength settings
> on Tegra).

Since these things are unrelated to muxing I prefer that
we add that as a separate set of ops in struct pinctrl_device.

The driver can very well reuse the same groups internally,
nothing prevents that.

I am not intending to address the issue of pin bias,
driver strength, load capacitance, schmitt-trigger input
etc etc etc in this first iteration of the pin control subsystem,
what I want is to get the infrastructure and pin muxing
into the kernel then extend it with other pin control.

I'm trying to avoid excess upfront design.

Do you think these features are needed from day 1
to be of any use for Tegra?

> For pinmux_config() to work, we'd need some API-level concept in order
> to name what pin/group to apply various settings to.
>
> Currently, that
> naming is an entry from the core mapping table, since pinmux_config()
> works on functions returned by pinmux_get(). That doesn't seem right,
> since it prevents the API being used for individual pins/pingroups. Even
> where say 5 different pins/pingroups are used by the same mapping table
> function, there's no reason to believe that their tristate or drive
> strength attributes would all be identical; at least input and output
> pins or control and data might be programmed differently.

Let's avoid trying to solve the things that are not really pinmuxing
with any concept from <linux/pinmux.h>, and let's have separation
of concerns.

I'll kill the (*config) callback for now.

> So in summary, I really think the data model should be as below.
>
> Driver-supplied data 1)
>
> Table of functions, each entry containing:
> * Name of function

This we have I think.

> Driver-supplied data 2)
>
> Table of pins, each entry containing:
> * Name of pin

This we have too I think.

> Driver-supplied data 3)
>
> Optional table of pingroups, each entry containing:
> * Name of pingroup
> * List of pins in the pingroup

OK introduced this as a generic concept in the
v6 patch set.

> Or, in more normalized fashion, with multiple rows per pingroup, each
> entry containing:
> * Name of pingroup
> * One pin with in the pingroup

I don't get this "one pin within the the pingroup"
what if the same pin is part of multiple groups?

The first suggestion seems more solid to me.

> Driver-supplied data 4)
>
> Table of legal functions per pin/pingroup; each entry containing:
> * Name of pin or pingroup

OK I have this now, e.g. inspect the file
<debugfs>/pinctrl.0/groups

> * List of functions that can be legally mux'd to the pin or pingroup
>
> Or, in more normalized fashion, with multiple rows per pingroup, each
> entry containing:
> * Name of pin or pingroup
> * One legal function that can be legally mux'd to the pin or pingroup
>
> Board-supplied data 1)
>
> Mapping table, each entry containing:
> * Driver name/pointer
> * Name of function seen by driver
> * Pin/pingroup name to configure
> * Name of driver function to apply to pin/pingroup
>
> Note that I assume there may be multiple rows for any combination of the
> first two fields in this table, and that all will be operated on by a
> single pinmux_get()/pinmux_enable() call.
>
> Some enhancements in the above list of tables over previous times that I've
> talked about this:
>
> * Created a separate optional table for a list of pingroups, thus not
> burdening SoCs other than Tegra with the pingroup concept.
>
> * Allow either a pin or pingroup name in the driver's "table of legal
> functions per pin" and the "mapping table"; core can simply look through
> the pingroup table if present, then fall back to looking in pin table,
> when determining what a pin/pingroup name means.
>
> * I assume that entries in the "table of pins" or "table of pingroups"
> might have no corresponding entries in " Table of legal functions per
> pin"; in this case, those pin/pingroup names would only be useful for
> pinmux_config() to operate on.
>
>
> P.S. I'll be on vacation 9/2-9/17. I'm not sure if I'll have any form of
> network access during this time or not. You may not see many more pinmux
> comments from me during that time.
>
> --
> nvpublic
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
