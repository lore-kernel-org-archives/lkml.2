Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965094Ab2B2Qkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 11:40:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41371 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab2B2Qkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 11:40:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.43.51.135 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1330386909-17723-1-git-send-email-swarren@nvidia.com>
References: <1330386909-17723-1-git-send-email-swarren@nvidia.com>
Date: Wed, 29 Feb 2012 17:40:40 +0100
Message-ID: <CACRpkdaaYF8UqweNm6sQ3dke9J76J2oY62BPBSisPo9myf7W4g@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] pinctrl: Introduce PINCTRL_STATE_DEFAULT, define
 hogs as that state
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aha now I see the problem here...

On Tue, Feb 28, 2012 at 12:55 AM, Stephen Warren <swarren@nvidia.com> wrote:

> This provides a single centralized name for the default state.
(...)
> -/* Hog a single map entry and add to the hoglist */
> -static int pinctrl_hog_map(struct pinctrl_dev *pctldev,
(...)
> -static int pinctrl_hog_maps(struct pinctrl_dev *pctldev)
(...)
> -       pinctrl_hog_maps(pctldev);
> +       pctldev->p = pinctrl_get(pctldev->dev, PINCTRL_STATE_DEFAULT);
> +       if (!IS_ERR(pctldev->p))
> +               pinctrl_enable(pctldev->p);

So what happens here is that my hogs will try to activate three different
functions in the same struct pinctrl *p.

This fails the sanity check in pinmux.c:

	/*
	 * If the function selector is already set, it needs to be identical,
	 * we support several groups with one function but not several
	 * functions with one or several groups in the same pinmux.
	 */
	if (p->func_selector != UINT_MAX &&
	    p->func_selector != func_selector) {
		dev_err(pctldev->dev,
			"dual function defines in the map for device %s\n",
		       devname);
		return -EINVAL;
	}
	p->func_selector = func_selector;

Since it is assumed that we can only activate one function at a time
for a given device handle (struct pinmux).

Which was sound, since we said that one single function can activate
several groups.

So you still need one struct pinmux *p for each hog or it won't work.

Allowing the struct pinmux to activate several functions at once is
another solution, but would defy the idea of having several groups
mapped to one function, then you could just as well use that instead,
and it would be a tad bit too many "many to many" relations in my
opinion.

So I would revert back to using one handle per hog.

(Sorry if I misunderstood the problem though we're getting pretty
complex here...)

Yours,
Linus Walleij
