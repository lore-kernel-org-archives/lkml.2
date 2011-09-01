Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab1IATnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 15:43:52 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5661 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883Ab1IATnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 15:43:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 01 Sep 2011 12:43:43 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>, Barry Song <21cnbao@gmail.com>
Date: Thu, 1 Sep 2011 12:43:34 -0700
Subject: RE: [PATCH 1/4 v5] drivers: create a pin control subsystem v5
Thread-Topic: [PATCH 1/4 v5] drivers: create a pin control subsystem v5
Thread-Index: Acxoh3rMv1tX8B5uT++2ahRgQFcsKgAVl0LA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B327A3A0@HQMAIL01.nvidia.com>
References: <1314609001-28052-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B3279BD7@HQMAIL01.nvidia.com>
	<CACRpkdaWbgiaJvvjDgBWFTpC6P=XcG6fm+L8rnjv9rxDxgs_YQ@mail.gmail.com>
 <CACRpkda4PRd_WUPrnEBVADbHnmSOgVB=WCXvVR4dFMektyQ2tQ@mail.gmail.com>
In-Reply-To: <CACRpkda4PRd_WUPrnEBVADbHnmSOgVB=WCXvVR4dFMektyQ2tQ@mail.gmail.com>
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

Linus Walleij wrote at Thursday, September 01, 2011 3:13 AM:
...
> I will need Arnds or similars advice on it so we don't
> grow a lib/mysql into the kernel with this kind of
> schemes and get slammed for overcomplicating
> things when trying to merge the beast.

I /think/ the whole multi-row thing is just doing this:

for each row of table:
    if it matches search terms:
        Activate the specified function on the group

Whereas handling just one entry is almost the same:

for each row of table:
    if it matches search terms:
        Activate the specified function on the group
        break

Of course, in the former case, the error-handling also has to iterate
over all the already-processed rows and unreserved/unprogram the HW too,
but that should be a pretty simple loop too.

And replying to your immediately earlier email:

...
> > Hence, a given board would only need rows 0, 1+2, or
> > 3+4+5 from the mapping table shown above, assuming the width of the MMC
> > port didn't vary at run-time.
> 
> OK we're on the same page I think. If I fix this, then
> you're happy?

I haven't read patchset 6 yet, but from the descriptions in your email
and the patch 0 changelog, it certainly sounds like we're on very
similar pages now.

> > Some pin parameters might be defined per:
> >
> > * Pin (probably most systems other than Tegra)
> > * Pin group (for pull-up/down, tristate on Tegra)
> > * Drive group (another set of groups of pins on Tegra that arbitrarily
> > overlap/intersect with the mux pin groups (for drive-strength settings
> > on Tegra).
> 
> Since these things are unrelated to muxing I prefer that
> we add that as a separate set of ops in struct pinctrl_device.
> 
> The driver can very well reuse the same groups internally,
> nothing prevents that.
> 
> I am not intending to address the issue of pin bias,
> driver strength, load capacitance, schmitt-trigger input
> etc etc etc in this first iteration of the pin control subsystem,
> what I want is to get the infrastructure and pin muxing
> into the kernel then extend it with other pin control.
> 
> I'm trying to avoid excess upfront design.
> 
> Do you think these features are needed from day 1
> to be of any use for Tegra?

I think having just muxing support would work fine for a first pass.

Looking forward a little, I expect that different SoCs have such a
different set of biasing/driver-strength/... options that actually having
some formalized semantic representation of what those options are doesn't
make sense; all we need is a standard API to set the values for a given
pin or pingroup; just like the config API you already had, but applied
to pingroups rather than explicitly GPIOs, and where the driver supplies
the names for the settings and interprets what the values mean for a
given setting. I imagine having the config API in the first pass wouldn't
be contentious, provided it applied to pingroups.

Just possibly, I could imagine needing config entries in the mapping table,
so when switching between mapping entries at run-time you could both program
muxing and other configuration. However, that's definitely not a first-pass
thing, as you say. And I'm just guessing if it'll be needed anyway.

> > Or, in more normalized fashion, with multiple rows per pingroup, each
> > entry containing:
> > * Name of pingroup
> > * One pin with in the pingroup
> 
> I don't get this "one pin within the the pingroup"
> what if the same pin is part of multiple groups?

It was just a data-representation thing. You could either have:

struct {
    char * pingroup;
    int npins;
    int * pins;
};

Where one row represents everything about a pingroup, or:

struct {
    char * pingroup;
    int pin;
};

Where you'd need a row for each pin in a pingroup.

Go with whatever you find is easiest; I was just thinking databases for
a while!

-- 
nvpublic

