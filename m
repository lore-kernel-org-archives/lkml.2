Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab2B2TWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:22:15 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11446 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758284Ab2B2TWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:22:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 29 Feb 2012 11:21:54 -0800
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
Date: Wed, 29 Feb 2012 11:21:53 -0800
Subject: RE: [PATCH V2 1/2] pinctrl: Introduce PINCTRL_STATE_DEFAULT, define
 hogs as that state
Thread-Topic: [PATCH V2 1/2] pinctrl: Introduce PINCTRL_STATE_DEFAULT,
 define hogs as that state
Thread-Index: Acz3AOCp5y5xKkqgSxOjNxZWh1Gf3wAB+cagAAOUMVA=
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BDDF2125@HQMAIL01.nvidia.com>
References: <1330386909-17723-1-git-send-email-swarren@nvidia.com>
 <CACRpkdaaYF8UqweNm6sQ3dke9J76J2oY62BPBSisPo9myf7W4g@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17BDDF209D@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BDDF209D@HQMAIL01.nvidia.com>
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

Stephen Warren wrote at Wednesday, February 29, 2012 10:42 AM:
> Linus Walleij wrote at Wednesday, February 29, 2012 9:41 AM:
> > Aha now I see the problem here...
> >
> > On Tue, Feb 28, 2012 at 12:55 AM, Stephen Warren <swarren@nvidia.com> wrote:
> >
> > > This provides a single centralized name for the default state.
> > (...)
> > > -/* Hog a single map entry and add to the hoglist */
> > > -static int pinctrl_hog_map(struct pinctrl_dev *pctldev,
> > (...)
> > > -static int pinctrl_hog_maps(struct pinctrl_dev *pctldev)
> > (...)
> > > -       pinctrl_hog_maps(pctldev);
> > > +       pctldev->p = pinctrl_get(pctldev->dev, PINCTRL_STATE_DEFAULT);
> > > +       if (!IS_ERR(pctldev->p))
> > > +               pinctrl_enable(pctldev->p);
> >
> > So what happens here is that my hogs will try to activate three different
> > functions in the same struct pinctrl *p.
> >
> > This fails the sanity check in pinmux.c:
> >
> > 	/*
> > 	 * If the function selector is already set, it needs to be identical,
> > 	 * we support several groups with one function but not several
> > 	 * functions with one or several groups in the same pinmux.
> > 	 */
> > 	if (p->func_selector != UINT_MAX &&
> > 	    p->func_selector != func_selector) {
> > 		dev_err(pctldev->dev,
> > 			"dual function defines in the map for device %s\n",
> > 		       devname);
> > 		return -EINVAL;
> > 	}
> > 	p->func_selector = func_selector;
> 
> Oh right, I'd forgotten about that check at this stage in the patch
> series.
> 
> Later in the series, this restriction is removed; each setting in a state
> is completely independent, and could easily program a different function
> onto each group, or the same function. At this stage in the series, a
> struct pinctrl can't represent everything that a set of mapping table
> entries can, but later struct pinctrl is fully capable.
> 
> I guess the solution here is to just make this patch introduce the
> PINCTRL_STATE_DEFAULT define, but defer most usage of it until later
> in the series when this restriction is removed.

Actually, it looks very easy to move the func_selector field out of
struct pinctrl into struct pinmux_group, which would solve this problem
in what I consider the correct way. I'll code up a patch to do that and
stack it before this current patch.

-- 
nvpublic

