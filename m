Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab1LERvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:51:31 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4609 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1LERva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:51:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 05 Dec 2011 09:51:25 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 5 Dec 2011 09:51:22 -0800
Subject: RE: [PATCH 2/2 v4] pinctrl: introduce generic pin config
Thread-Topic: [PATCH 2/2 v4] pinctrl: introduce generic pin config
Thread-Index: AcyzUrVp8sZiQtUNSDqUnsam8z72PAAItNZA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1750B77046@HQMAIL01.nvidia.com>
References: <1322160380-27711-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174FDAFF30@HQMAIL01.nvidia.com>
	<CACRpkdZueyZkOq20qq_jDn27cfkChM58cR+TvPKfifSwFwiQ5w@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174FDB01F2@HQMAIL01.nvidia.com>
 <CACRpkdYJkLHtn9_Evw4m3rUCtzRoR9quinpHA3YEF2kt=cEd5g@mail.gmail.com>
In-Reply-To: <CACRpkdYJkLHtn9_Evw4m3rUCtzRoR9quinpHA3YEF2kt=cEd5g@mail.gmail.com>
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

Linus Walleij wrote at Monday, December 05, 2011 6:35 AM:
> On Thu, Dec 1, 2011 at 6:16 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Linus Walleij wrote at Thursday, December 01, 2011 3:12 AM:
> 
> >> That will get messy when if I refactor this stuff, add new enums
> >> and whatever.
> >
> > I don't understand what'd be difficult about that.
> >
> > New standardized enums could be added with values without the top bit
> > set. No existing driver would need modification, since their switch(param)
> > would not have a case for that new value, and would just return an error.
> 
> That would be mixing binary #defines and enums in an unholy
> manner, that sounds bad to me.

I don't undertand that; what defines and enums would be mixed together?

> If you want to do things like that I should replace the current
> 
> enum pin_config_param {
>         PIN_CONFIG_BIAS_DISABLE,
>         PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
>        ...
> }
> 
> With
> 
> #define PIN_CONFIG_BIAS_DISABLE 0x00000001
> #define PIN_CONFIG_BIAS_HIGH_IMPEDANCE 0x00000002
> ...
> 
> Else it seems like a bit wicked mix-up. So is this what we
> should do?

That seems fine to me.

> I am reluctant since it mirrors the problem in the GPIO
> numberspace where you have no clue what, say GPIO
> 164 is on a multi-platform binary. It depends on which
> platform it booted on. The same will be true for such
> enums/defines above the predefined range, totally
> depending on the system at hand.

Custom params always mean something driver-specific, irrespective of
whether you can expose both standard and custom params in the same driver
or whether you're in a multi-SoC binary or not.

If we did something like use the top bit (0x8000000) to indicate standard-
vs-custom, it should be pretty obvious whether you're dealing with a
standard property or not, and when you have to go look at the driver.

In fact, this seems better than having a flag in the pinctrl driver
registration for this, since in that case, you /always/ have to go look
at the driver to interpret /any/ param, whereas with an explicit range
of standard params, you can at least know it's safe to least interpret
standard params without consulting the driver code.

> >> Like in the generic debugfs dump function:
> >>
> >>       if (!ops->is_generic)
> >>               return;
> >>
> >> If I take this out, the generic debugfs code will be used for
> >> everything.
> >
> > I think that'd be fine; the generic code would do all the debug prints
> > for the standardized enums, then the core would call into the pinctrl
> > driver to perform any additional debug prints for any driver-defined
> > custom parameters.
> 
> I think Marks point earlier was that he wanted the possibility
> to cut out *all* the generic stuff and have only custom config
> enumerators for a certain pin controller.

You can still have that. Drivers which use standard params can select
support for them, and drivers which only use custom params don't have to.
Irrespective, having a driver expose standard params doesn't mean that
the core need to include the debugfs code to dump those params anyway;
as far as param get/set, it should simply be passing the values to the
driver without munging them anyway.

-- 
nvpublic

