Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab1H2VdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:33:14 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3725 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1H2VdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:33:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 29 Aug 2011 14:33:08 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>, Barry Song <21cnbao@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 29 Aug 2011 14:32:57 -0700
Subject: RE: [PATCH 1/4 v5] drivers: create a pin control subsystem v5
Thread-Topic: [PATCH 1/4 v5] drivers: create a pin control subsystem v5
Thread-Index: AcxmK5CXCmM0FbemTX66NHdsnQI7JAAXQVHg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B3279BD7@HQMAIL01.nvidia.com>
References: <1314609001-28052-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1314609001-28052-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Monday, August 29, 2011 3:10 AM:
> This creates a subsystem for handling of pin control devices.
> These are devices that control different aspects of package
> pins.
...
> - Defined a "position" for each function, so the pin controller now
>   tracks a function in a certain position, and the pinmux maps define
>   what position you want the function in. (Feedback from Stephen
>   Warren and Sascha Hauer).

My thoughts:

I guess "positions" can be used to represent the muxing capabilities of
Tegra. However, I still don't think this is the right model.

1) There is still a 1:1 correspondence between what a function in the
pinmux core<->driver interface, and the pinmux mapping table. I believe
we need a 1:n correspondence.

HW typically has a set of pins (or pingroups on Tegra), and there's a
register field for each of these that indicates which signal (or set of
signals in the pin group case) are mux'd to it/them. At this level,
setting a pin/pingroup to a particular function isn't all that's required
to use a particular IO controller; you typically need to apply the same
function to many pins/pingroups.

However, the pinmux API defines a function as everything needed to use
a an entire driver/controller.

Now, I do see that the concept of "position" can encompass this, but I
don't think it's entirely right for it to do so:

* "Positions" don't map very well to the HW programming model I assert
above.

* With the current "position" usage, the data structures are not in
"normal form" (normalized), taking a leaf from database technology.

* Normalizing would help the "combinatorial explosion" problem mentioned
before.

i.e. rather than:

driver function/position list:
function@position pins
----------------- ----
mmc0@0            0, 1, 2, 3
mmc0@1            0, 1, 2, 3, 4, 5
mmc0@2            0, 1, 2, 3, 4, 5, 6, 7, 8, 9

core mapping table:
driver  name  function@position
------  ----  -----------------
mmc0    2-bit mmc0@0
mmc0    4-bit mmc0@1
mmc0    8-bit mmc0@2

I'd far rather see:

driver function list:
function
---------
mmc0

driver pin/pingrup list: (names of pins or pingroups):
pingroup
--------
A
B
C

core mapping table:
driver  name  position  function
------  ----  --------  ---------
mmc0    2-bit A         mmc0
mmc0    4-bit A         mmc0
mmc0    4-bit B         mmc0
mmc0    8-bit A         mmc0
mmc0    8-bit B         mmc0
mmc0    8-bit C         mmc0

Note again that I'm assuming above that the driver-supplied function and
pingroup list included all possible options the SoC HW supports, whereas
the mapping table would include just those configurations ever actually
used by the particular board the code is executed upon; from board files
or devicetree data. Hence, a given board would only need rows 0, 1+2, or
3+4+5 from the mapping table shown above, assuming the width of the MMC
port didn't vary at run-time.

2) "Positions" are defined per "function", rather than as a global concept.

This leads to positions having meaningless integer names. As such,
constructing the mapping table will be error-prone; who could remember
that position 0 is a 2-bit bus using a certain set of pins, yet position
1 is an 8-bit bus using a different set of pins? I suppose textual names
might help here. However, by replacing the concept of positions with
multiple explicit entries in the mapping table (as in my example above),
that problem is solved; we name the pins (or pingroups) to which we apply
the driver-level function in each entry, thus it's more self-documenting.

3) It's unclear how well pinmux_config() can be applied.

Some pin parameters might be defined per:

* Pin (probably most systems other than Tegra)
* Pin group (for pull-up/down, tristate on Tegra)
* Drive group (another set of groups of pins on Tegra that arbitrarily
overlap/intersect with the mux pin groups (for drive-strength settings
on Tegra).

For pinmux_config() to work, we'd need some API-level concept in order
to name what pin/group to apply various settings to. Currently, that
naming is an entry from the core mapping table, since pinmux_config()
works on functions returned by pinmux_get(). That doesn't seem right,
since it prevents the API being used for individual pins/pingroups. Even
where say 5 different pins/pingroups are used by the same mapping table
function, there's no reason to believe that their tristate or drive
strength attributes would all be identical; at least input and output
pins or control and data might be programmed differently.


So in summary, I really think the data model should be as below.

Now, I know you've referred to this as a "telephone exchange" model, and
argued that we don't need full telephone exchange support, but even if
that's true (and I'm not convinced), I really don't see the problem in
using it; it seems as simple for everything, simpler for some things,
and allows the API to implement any possible new SoC that might appear
in the future.

Driver-supplied data 1)

Table of functions, each entry containing:
* Name of function

Driver-supplied data 2)

Table of pins, each entry containing:
* Name of pin

Driver-supplied data 3)

Optional table of pingroups, each entry containing:
* Name of pingroup
* List of pins in the pingroup

Or, in more normalized fashion, with multiple rows per pingroup, each
entry containing:
* Name of pingroup
* One pin with in the pingroup

Driver-supplied data 4)

Table of legal functions per pin/pingroup; each entry containing:
* Name of pin or pingroup
* List of functions that can be legally mux'd to the pin or pingroup

Or, in more normalized fashion, with multiple rows per pingroup, each
entry containing:
* Name of pin or pingroup
* One legal function that can be legally mux'd to the pin or pingroup

Board-supplied data 1)

Mapping table, each entry containing:
* Driver name/pointer
* Name of function seen by driver
* Pin/pingroup name to configure
* Name of driver function to apply to pin/pingroup

Note that I assume there may be multiple rows for any combination of the
first two fields in this table, and that all will be operated on by a
single pinmux_get()/pinmux_enable() call.

Some enhancements in the above list of tables over previous times that I've
talked about this:

* Created a separate optional table for a list of pingroups, thus not
burdening SoCs other than Tegra with the pingroup concept.

* Allow either a pin or pingroup name in the driver's "table of legal
functions per pin" and the "mapping table"; core can simply look through
the pingroup table if present, then fall back to looking in pin table,
when determining what a pin/pingroup name means.

* I assume that entries in the "table of pins" or "table of pingroups"
might have no corresponding entries in " Table of legal functions per
pin"; in this case, those pin/pingroup names would only be useful for
pinmux_config() to operate on.


P.S. I'll be on vacation 9/2-9/17. I'm not sure if I'll have any form of
network access during this time or not. You may not see many more pinmux
comments from me during that time.

-- 
nvpublic

