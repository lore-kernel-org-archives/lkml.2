Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab1LTAZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 19:25:54 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17293 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab1LTAZw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 19:25:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 19 Dec 2011 16:25:48 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 19 Dec 2011 16:24:50 -0800
Subject: RE: [PATCH v2] pinctrl: add support for group and pinmux states
Thread-Topic: [PATCH v2] pinctrl: add support for group and pinmux states
Thread-Index: Acy92b6ae+1LrDDhSy6g0g0+kfN0twA0aaCQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF176BE92C1B@HQMAIL01.nvidia.com>
References: <1324249593-3051-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1324249593-3051-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Sunday, December 18, 2011 4:07 PM:
> This makes it possible for pin groups and pin muxes to go into
> different states, which is especially useful for power management,
> both runtime and across suspend/resume.

> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt

> +Pin group states
> +================
> +
> +To simplify handling of specific group states, such as when a group of
> +pins need to be deactivated or put in a specific sleep state, the pin controller
> +may implement a .pin_group_set_state() callback. This will for example be
> +called automatically to set a certain pin group in active state when the groups
> +are selected for use in a certain pin multiplexing configuration (see below).
> +This is a good opportunity to set up any default pin configuration (see below)
> +for the pins in a group.

I don't think it's possible for a pinctrl driver to implement such a
callback; the appropriate state for a pin may well be board-specific,
and the pinctrl driver itself can't possibly know what that state is.

For example, for some random pin that a board happens to be using as a
GPIO - how does the pinctrl driver know whether that GPIO actually does
something while in suspend; if the GPIO isn't used, the SoC can probably
just turn off all drivers and pull-up/downs on the pin, but if the GPIO
is used to control some aspect of a PMIC, it probably needs to be in a
specific state during suspend. This kind of thing is entirely board-
specific.

Similarly, the sequencing of reprogramming of the various pins when
entering/leaving suspend is most likely board specific, e.g. there may
be a need to assert a "speaker mute" GPIO before de-asserting a GPIO
that enables power to speaker amplifiers etc.

> diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h

> +enum pin_group_state {
> +	PIN_GROUP_STATE_DISABLED,
> +	PIN_GROUP_STATE_ACTIVE,
> +	PIN_GROUP_STATE_IDLE,
> +	PIN_GROUP_STATE_SLEEP,
> +};

I'm unsure that having the pinctrl core explicitly define the set of
legal states is the right approach. This prevents domain-specific states
(e.g. PCIe power states say) from being defined without revising the
core. That said, I'm less adamant about this than about my first point
above.

I'd like to suggest an alternative:

a) The mapping table should be enhanced to cover all configuration that
   pinctrl can program:
   * Mux function selection
   * Whether a pin a used as a GPIO, if gpiolib doesn't interact with
     pinctrl to set this up.
   * Any pin config parameters that should be set.
   * Define all the above for each state that a driver can be in.
   * Name legal states as strings in the mapping table, so they're just
     data and any given driver can define the names of states it expects
     to have available.
   * The table can have a defined execution ordering this allowing board-
     specific sequencing requirements to be defined. Perhaps the mapping
     table can define the set of parameters to program for each legal
     to/from state transition combination, rather than target
     configuration for each state, so all sequencing is fully under
     control of the mapping table.
b) Add a pinctrl API that transitions a given pmx (from pinmux_get())
   between states as defined in the mapping table.

That should allow this to be fully generic.

For standard states (e.g. fully active, system suspend) we could define
(de-facto?) standardized names that drivers can use if appropriate.
That'd prevent too many custom state strings, yet allow extensibility
when needed.

IIRC, some of my previous emails have touched on this idea, and included
example mapping tables with multiple states per device.

-- 
nvpublic

