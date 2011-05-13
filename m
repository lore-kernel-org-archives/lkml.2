Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872Ab1EMV3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 17:29:35 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1871 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979Ab1EMV3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 17:29:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 13 May 2011 14:29:30 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>
Date: Fri, 13 May 2011 14:29:24 -0700
Subject: RE: [PATCH] drivers: create a pinmux subsystem v2
Thread-Topic: [PATCH] drivers: create a pinmux subsystem v2
Thread-Index: AcwPa5pjsFbKtgdiQf+cS5JvZLh2pQCRDkog
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04986AA6A2@HQMAIL01.nvidia.com>
References: <1305070783-23193-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1305070783-23193-1-git-send-email-linus.walleij@linaro.org>
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

I'd like to step back and take a look at the data model.

As I understand it, the data model is that the SoC's pinmux driver defines
every possible set of pins that could be used for all groups of signals
(SSP, I2C, ...) that's affected by the pinmux. Each combination of pins
is a FUNCTION in the documentation in the patch. The set of FUNCTIONS must
include all options for: muxing a given controller's signals out of
different sets of pins, different bit-widths of ports, etc. The SoC pinmux
 driver must expose every single possible option so that boards can pick
whichever one they want. This is particular important e.g. if devicetree
comes into play, where people will expect to pick the correct FUNCTION in
their devicetree file without having to add a definition of that FUNCTION
to the kernel. Even with new boards, it'd be best if the SoC pinmux driver
already contained the definitions that arbitrary boards might use.

It's then up to the board to define which particular SoC-defined FUNCTION
is used by each driver on the given board. For each driver, a single
FUNCTION can be selected at a time (although there is the option to
associate multiple FUNCTIONs to a single driver, those are alternatives
rather than aggregateable options).

Consider Tegra's keyboard controller: For rows, the controller can use
KB_ROW[2:0], perhaps also KB_ROW[6:3], and perhaps also KB_ROW[15:7]. For
columns, the controller can use KB_COL[1:0], perhaps also KB_COL[6:2],
perhaps also KB_COL[7]. Thus, the pinmux driver must expose FUNCTIONs for
all combinations of rows (3) cross-product all combinations of columns
(3) so 3*3==9.

That's all assuming that for each of those sets of pins, there's only one
set of physical pads they can be routed out to. While Tegra's pinmux
doesn't support this for the keyboard controller signals, let's assume
for flexibility that KB_ROW[2:0] could be routed out pins X0/X1/X2 or
Y0/Y1/Y2, and similarly for KB_COL[1:0] to two other sets of pins. That
then means the SoC pinmux driver would have to define 9 * 2 * 2 == 36
different FUNCTIONs.

That's just catering for a pretty simple keyboard controller. I believe
this quickly grows unmanageable.

Instead, what if the SoC pinmux driver just defined groups of pins. For
each group, there would be a list of the physical pins that was part of
the group, and a list of functions (SD1, SD2, I2S1, I2S2, ...) that could
be assigned to that group. For many SoCs, there would be a single pin per
group. At least Tegra would have many groups containing more than one pin.

Now, the SoC's pinmux driver's list of configurations would be just roughly
number_of_groups * average_number_of_functions_supported_per_group. I think
this would be much lower than the number of FUNCTIONs in the existing
proposed model.

Of course, this approach would mean the SoC pinmux driver would define a
little less information about the SoC. We'd have to shift more data into
the board/machine definition.

Specifically, the current pinmux API defines that for each driver, there
is a single FUNCTION active at a time. To make my proposed data model
work, we'd have to expand that from a 1:1 to a 1:n mapping, such that for
each driver, we define a set of possible configurations, and for each
configuration, we define a set of (group, function) used, rather than just
a single FUNCTION.

This would shift all the burden of defining whether e.g. "the keyboard
controller uses 1, 2, or 3 of the column groups of pins" into the board/
machine driver, and eventually perhaps into devicetree. Arguably, that's
where all the complexity should be.

The core pinmux driver still would have enough information to know for
each group whether any (and which) function was assigned, and so could
still implement all the exclusion/sharing logic. Equally, the mapping
from the data exported by the SoC pinmux driver (list of groups, and
supported functions for each) would probably map much better to actual
register writes; For Tegra, there'd probably be a 1:1 mapping for each
group rather than a 1:N mapping for each FUNCTION. Other SoC pinmux
drivers would probably be roughly unchanged, i.e. have a 1:1 mapping
between group and pin configuration register.

So, what are people's thoughts on this?

Thanks for reading so far!

 (I'll have to go away and read up on some of the issues Colin Cross
mentioned, namely that the auxiliary configuration such as drive strength,
pullup, etc. was also configured in groups, but the pins associated with
those groups are not aligned with the groupings used for the pinmux)

-- 
nvpublic

