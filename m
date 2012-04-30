Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2D3EUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 00:20:03 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:42684 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2D3EUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 00:20:01 -0400
Date: Sun, 29 Apr 2012 21:19:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-input@vger.kernel.org, Viresh Kumar <viresh.kumar@st.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Rakesh Iyer <riyer@nvidia.com>
Subject: Re: [PATCH 2/2] Input: matrix_keymap - wire up device tree support
Message-ID: <20120430041955.GC1055@core.coreip.homeip.net>
References: <20120426081909.GA2726@core.coreip.homeip.net>
 <4F99642E.1010305@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F99642E.1010305@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 09:05:18AM -0600, Stephen Warren wrote:
> On 04/26/2012 02:19 AM, Dmitry Torokhov wrote:
> > When platform keymap is not supplied to matrix_keypad_build_keymap()
> > and device tree support is enabled, try locating specified property
> > and load keymap from it. If property name is not defined, try using
> > "linux,keymap".
> > 
> > Based on earlier patch by Viresh Kumar <viresh.kumar@st.com>
> 
> I think this series looks mostly OK. A few comments below.
> 
> We don't actually have the KBC driver hooked up on any boards yet, so I
> can't actually test this yet.
> 
> How will the linux,fn-keymap handling work? It looks like this code is
> allocating a keymap data structure with one additional row to represent
> fn-not-pressed vs. fn-pressed.

No, it loads 2x rows (therefore giving you twice original keymap size).

> I assume this will work without issue
> even though the second half is not filled in. Won't this allow the
> linux,keymap property entries to pass validation "if (row >= rows)" for
> one more row than it should?

Maybe... I think we should revisit this when you actually have
linux,fn-keymap. Probably will need to export matrix_keypad_parse_

> 
> > diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
> 
> > +static int __devinit tegra_kbd_setup_keymap(struct tegra_kbc *kbc)
> > +{
> > +	const struct tegra_kbc_platform_data *pdata = kbc->pdata;
> > +	const struct matrix_keymap_data *keymap_data = pdata->keymap_data;
> > +	unsigned int keymap_rows = KBC_MAX_KEY;
> > +	int retval;
> > +
> > +	if (pdata->use_fn_map)
> > +		keymap_rows *= 2;
> > +
> > +	retval = matrix_keypad_build_keymap(keymap_data, NULL,
> > +					    keymap_rows, KBC_MAX_COL,
> > +					    kbc->keycode, kbc->idev);
> > +	if (retval == -ENOSYS || retval == -ENOENT) {
> 
> This is looking for ENOSYS or ENOENT, but ...

Maybe just change it to retval && retval != -EINVAL...

> 
> > diff --git a/drivers/input/matrix-keymap.c b/drivers/input/matrix-keymap.c
> 
> > +static int matrix_keypad_parse_of_keymap(const char *propname,
> 
> > +	if (!np)
> > +		return -ENODEV;
> 
> Here and ...

Hmm, -ENODEV is probably not good. Not sure if this should be -ENOENT,
-ENOSYS or -EINVAL.

> 
> > +	prop = of_get_property(np, propname, &proplen);
> > +	if (!prop) {
> > +		dev_err(dev, "OF: %s property not defined in %s\n",
> > +			propname, np->full_name);
> > +		return -ENODEV;
> 
> Here return ENODEV instead.

This indeed should be -ENOENT.

-- 
Dmitry
