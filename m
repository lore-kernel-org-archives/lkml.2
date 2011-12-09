Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab1LIR2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:28:06 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5513 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1LIR2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:28:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 09 Dec 2011 09:28:02 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        ext Tony Lindgren <tony@atomide.com>
Date: Fri, 9 Dec 2011 09:28:02 -0800
Subject: RE: [RFC 1/3] pinctrl: add a driver for NVIDIA Tegra
Thread-Topic: [RFC 1/3] pinctrl: add a driver for NVIDIA Tegra
Thread-Index: Acy2ev5kzFm44qXaRIyTF0kfp8rlugAG1emw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17518604D7@HQMAIL01.nvidia.com>
References: <1323382390-14892-1-git-send-email-swarren@nvidia.com>
	<1323382390-14892-2-git-send-email-swarren@nvidia.com>
 <CACRpkdYDn0V7SeQuFiFDMxGkybvg6PGf7jxid8ECGB7Azkj3zw@mail.gmail.com>
In-Reply-To: <CACRpkdYDn0V7SeQuFiFDMxGkybvg6PGf7jxid8ECGB7Azkj3zw@mail.gmail.com>
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

Linus Walleij wrote at Friday, December 09, 2011 7:01 AM:
> On Thu, Dec 8, 2011 at 11:13 PM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > This adds a driver for the Tegra pinmux, and required parameterization
> > data for Tegra20 and Tegra30.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> This is looking good from a framework point of view (obviously,
> since you've designed the framework with me you sure know what
> you're doing).
> 
> What we could worry about is the amount of hard-coded chip data
> which sort of correlates with the discussion with Tony on how to
> provide DT info for pin control drivers.

My thinking here is that irrespective of whether the data in future chips
is the same or different to the current chips, it's better in the driver.

For a given SoC, the data is static; it can never ever change.

Hence, there's no point parsing it from device tree; we end up with exactly
the same data in the driver, yet have spent a bunch of time parsing it out
from device tree instead of just embedding it into the kernel binary.

If parts of Tegra X and Tegra Y are similar, it should be possible to have
them co-ordinate together and share the common data, and do whatever it
takes to create the appropriate completed view before passing it back from
tegraX_pinctrl_init() to the core. You could perhaps do it using /include/
in the .dtsi file too, but I think allowing the SoC init code to unify the
tables gives more flexibility; in your example below of the same data with
different pin names, that'd be implementable with code without too much
difficulty, but probably impossible with dtc since it has no macro/define
support at present.

Also, the representation of the data in a .c file will likely be far
smaller than in the .dtsi file, so this way saves space. Admittedly with
a multi-SoC binary, you end up with all the large per-SoC data in the
binary initially, so the space-savings aren't exactly seen, but it's
all init data, so does get dumped soon after boot.

Another point here: I don't have to maintain a DT binding for the Tegra
pinctrl driver this way, so if the next Tegra's pinmux HW is different,
all I need to do is edit the driver, not be shackled by a need to keep
the DT binding for it backwards-compatible. Although that said, I
/think/ even an obvious DT binding derived from struct
tegra_pinctrl_soc_data would be flexible enough for most things, perhaps
with the addition of allowing config param field definitions for pins
as well as groups.

> If say this same controller appear in Tegra 4 with no changes but
> different pin names, it makes sense to try to push this into the
> DT as soon as possible, so as to avoid the situation Tony is
> having with the OMAP muxes. If Tegra 4 will be all-new and not even
> related, it doesn't.
> 
> So, just think a bit about it.

Sorry if my replying quickly seems like I haven't thought about it; it's
just that I already thought about this a while ago, and came to the
conclusions above.

> It will fit way better here than any place under
> arch/arm/* in any case, so it's a great achievement!

-- 
nvpublic

