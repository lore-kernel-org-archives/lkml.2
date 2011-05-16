Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab1EPAga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 20:36:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45688 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1EPAg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 20:36:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=m71uv0Ac1qNG7zi3T1Vz4qSaAGZYgowBKtqws2ACmnNm2GYAu2gOOLeLvM5Ct2/ySP
         jrKGLO5lmJJyEZO8MPBp9Ix2ZDfJiUUhWqDknl07UkDzWvcuzckjIpj9csh3r0hDkYU6
         wFxzX306BWzK30v3r5B0QFHWXdQ1NHmCJOxDI=
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04986AA6A2@HQMAIL01.nvidia.com>
References: <1305070783-23193-1-git-send-email-linus.walleij@linaro.org>
	<74CDBE0F657A3D45AFBB94109FB122FF04986AA6A2@HQMAIL01.nvidia.com>
Date: Mon, 16 May 2011 02:36:28 +0200
X-Google-Sender-Auth: 3gBqDEDRdqhPQ93oGLeoUr-NxvU
Message-ID: <BANLkTi=wTB6R8vjHVAWM3T0e5HjOq77tdA@mail.gmail.com>
Subject: Re: [PATCH] drivers: create a pinmux subsystem v2
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Joe Perches <joe@perches.com>, Lee Jones <lee.jones@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/13 Stephen Warren <swarren@nvidia.com>:

> As I understand it, the data model is that the SoC's pinmux driver defines
> every possible set of pins that could be used for all groups of signals
> (SSP, I2C, ...) that's affected by the pinmux. Each combination of pins
> is a FUNCTION in the documentation in the patch. The set of FUNCTIONS must
> include all options for: muxing a given controller's signals out of
> different sets of pins, different bit-widths of ports, etc. The SoC pinmux
>  driver must expose every single possible option so that boards can pick
> whichever one they want. This is particular important e.g. if devicetree
> comes into play, where people will expect to pick the correct FUNCTION in
> their devicetree file without having to add a definition of that FUNCTION
> to the kernel. Even with new boards, it'd be best if the SoC pinmux driver
> already contained the definitions that arbitrary boards might use.

No not at all.

As with any other platform driver, the platform data can be structured
any way you like, and passed in from the board or taken directly
from the device tree.

/* Take this struct from say include/linux/pinmux/tegra.h */
struct tegra_pinmux_plf_data plfdata = {
     /* Describe all your needed pins and pinmux functions */
};

struct platform_device tegra_pmxdev = {
        .name = "pinmux-tegra",
        .dev = {
                .platform_data = plfdata,
        },
};

Maybe the pinmux subsystem could be helpful in structuring this
platform data, as well as the form it would take in the device
tree. Indeed. But I cannot drink the entire ocean at once,
this is the first step.

I would argue that some years from now you have package
mux definitions in device tree files that you just include into
your board file, where you map the functions you want to the
right devices and be done with it.

> It's then up to the board to define which particular SoC-defined FUNCTION
> is used by each driver on the given board. For each driver, a single
> FUNCTION can be selected at a time

A driver can take as many functions as it likes. If it wants more
than one, it has to ask for a specific name of the function apart
from providing it's struct driver * pointer.

This is no different from how drivers can request multiple clocks
or multiple regulators.

> (although there is the option to
> associate multiple FUNCTIONs to a single driver, those are alternatives
> rather than aggregateable options).

You can take all of them, as long as the pins in the functions
do not collide with each other.

If you want to enable several functions in a single go, that's
something we could add, as described in my response to
Sascha.

> Consider Tegra's keyboard controller: For rows, the controller can use
> KB_ROW[2:0], perhaps also KB_ROW[6:3], and perhaps also KB_ROW[15:7]. For
> columns, the controller can use KB_COL[1:0], perhaps also KB_COL[6:2],
> perhaps also KB_COL[7]. Thus, the pinmux driver must expose FUNCTIONs for
> all combinations of rows (3) cross-product all combinations of columns
> (3) so 3*3==9.

No thanks :-)

Pass the ones you need from board/package/platform/system data
with a struct to your driver.

The point I'm trying to make is that it should probably be in
mach-xxxx/foo-chip.c rather than mach-xxxx/foo-board.c
since many boards will likely use the same chip/package.

(Then we push it to the device tree.)

> Instead, what if the SoC pinmux driver just defined groups of pins. For
> each group, there would be a list of the physical pins that was part of
> the group, and a list of functions (SD1, SD2, I2S1, I2S2, ...) that could
> be assigned to that group. For many SoCs, there would be a single pin per
> group. At least Tegra would have many groups containing more than one pin.

It sounds like you're describing what the pinmux API already does.
Substitute the word "function" for "group" above.

> Now, the SoC's pinmux driver's list of configurations would be just roughly
> number_of_groups * average_number_of_functions_supported_per_group. I think
> this would be much lower than the number of FUNCTIONs in the existing
> proposed model.

Again the pinmux subsystem does not deal with how you define
this. Currently. Passing all of it from the platform seems like a good
option, whereas for a dead-simple chip we might want it directly in
the driver.

> Of course, this approach would mean the SoC pinmux driver would define a
> little less information about the SoC. We'd have to shift more data into
> the board/machine definition.

So the pinmux subsystem does not currently bother with where you
put your data. Maybe in the future we can improve that by
helping out, or do you think this is required for the initial version?

> Specifically, the current pinmux API defines that for each driver, there
> is a single FUNCTION active at a time.

No, like with clocks or regulators there can be many pinmux functions
active (claimed by pinmux_get()) for one driver at the same time, as
long as their pins don't collide.

> To make my proposed data model
> work, we'd have to expand that from a 1:1 to a 1:n mapping, such that for
> each driver, we define a set of possible configurations, and for each
> configuration, we define a set of (group, function) used, rather than just
> a single FUNCTION.

This is already supported, sorry I don't know if I get this
right.

> The core pinmux driver still would have enough information to know for
> each group whether any (and which) function was assigned, and so could
> still implement all the exclusion/sharing logic.

The exclusion/sharing logic is handled by the pinmux core.
This is currently the main thing that it helps the driver with.

>  (I'll have to go away and read up on some of the issues Colin Cross
> mentioned, namely that the auxiliary configuration such as drive strength,
> pullup, etc. was also configured in groups, but the pins associated with
> those groups are not aligned with the groupings used for the pinmux)

Yes I am positive that the biasing and drive strength etc that I first
tried to push into the GPIOlib should rather be in pinmux.

However there are GPIO controllers that can do such things that
do not provide pinmuxing, too, and then the pinmux layer cannot
be used for abstracting it.

I suspect that gpio's and pinmux'es may need to share the same
biasing and drive mode flags to make this match so a GPIO driver
can call out to the pinmux layer.

Yours,
Linus Walleij
