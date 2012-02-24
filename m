Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab2BXTVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:21:18 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8913 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab2BXTVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:21:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 24 Feb 2012 11:20:52 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 24 Feb 2012 11:20:51 -0800
Subject: RE: [PATCH 1/3] pinctrl: Introduce PINCTRL_STATE_DEFAULT define,
 and use it
Thread-Topic: [PATCH 1/3] pinctrl: Introduce PINCTRL_STATE_DEFAULT define,
 and use it
Thread-Index: AczyutSjxyOQsAS/TpeELsM2b+BcwQAW2kXQAASrJFA=
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCD1D@HQMAIL01.nvidia.com>
References: <1330041880-12406-1-git-send-email-swarren@nvidia.com>
 <CACRpkdZWu_nYkWLxXBUv-VAQTMByDM37qACRf3im7R4GQgZc5A@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCC87@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCC87@HQMAIL01.nvidia.com>
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

Stephen Warren wrote at Friday, February 24, 2012 10:10 AM:
> Linus Walleij wrote at Thursday, February 23, 2012 11:09 PM:
> > On Fri, Feb 24, 2012 at 1:04 AM, Stephen Warren <swarren@nvidia.com> wrote:
> >
> > > This provides a single centralized name for the default state.
> > >
> > > Update PIN_MAP_* macros to use this state name, instead of requiring the
> > > user to pass a state name in.
> > >
> > > Update documentation and mapping tables to use this.
...
> > I like the direction this is taking for sure. This is however not
> > working because it break U300, no hogs nor device requests work
> > after this patch so I cannot apply it.
...
> I think the fix for this is to replace the body of pinctrl_hog_maps()
> with:
> 
> static int pinctrl_hog_maps(struct pinctrl_dev *pctldev)
> {
>         int ret;
> 
>         INIT_LIST_HEAD(&pctldev->pinctrl_hogs);
> 
>         mutex_lock(&pinctrl_maps_mutex);
>         ret = pinctrl_hog_map(pctldev, PINCTRL_STATE_DEFAULT);
>         mutex_unlock(&pinctrl_maps_mutex);
> 
>         return ret;
> }

Oh, that won't work; the second parameter to pinctrl_hog_map() is a
map entry, not a state name.

Fixing this requires removing pctldev->pinctrl_hogs, and removing the hog
debugfs files (since that all relies on storing a list of mapping entries
that were hogged) and just doing a single pinctrl_get()/pinctrl_enable(),
and storing the one resulting struct pinctrl. I already did that as part
of my later patch for the API rework. I can extract that part into this
patch, and couple it with introducing define PINCTRL_STATE_DEFAULT, and
repost.

-- 
nvpublic

