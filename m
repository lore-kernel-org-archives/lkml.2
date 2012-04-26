Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab2DZPFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:05:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45424 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2DZPFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:05:21 -0400
Message-ID: <4F99642E.1010305@wwwdotorg.org>
Date: Thu, 26 Apr 2012 09:05:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, Viresh Kumar <viresh.kumar@st.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Rakesh Iyer <riyer@nvidia.com>
Subject: Re: [PATCH 2/2] Input: matrix_keymap - wire up device tree support
References: <20120426081909.GA2726@core.coreip.homeip.net>
In-Reply-To: <20120426081909.GA2726@core.coreip.homeip.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 02:19 AM, Dmitry Torokhov wrote:
> When platform keymap is not supplied to matrix_keypad_build_keymap()
> and device tree support is enabled, try locating specified property
> and load keymap from it. If property name is not defined, try using
> "linux,keymap".
> 
> Based on earlier patch by Viresh Kumar <viresh.kumar@st.com>

I think this series looks mostly OK. A few comments below.

We don't actually have the KBC driver hooked up on any boards yet, so I
can't actually test this yet.

How will the linux,fn-keymap handling work? It looks like this code is
allocating a keymap data structure with one additional row to represent
fn-not-pressed vs. fn-pressed. I assume this will work without issue
even though the second half is not filled in. Won't this allow the
linux,keymap property entries to pass validation "if (row >= rows)" for
one more row than it should?

> diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c

> +static int __devinit tegra_kbd_setup_keymap(struct tegra_kbc *kbc)
> +{
> +	const struct tegra_kbc_platform_data *pdata = kbc->pdata;
> +	const struct matrix_keymap_data *keymap_data = pdata->keymap_data;
> +	unsigned int keymap_rows = KBC_MAX_KEY;
> +	int retval;
> +
> +	if (pdata->use_fn_map)
> +		keymap_rows *= 2;
> +
> +	retval = matrix_keypad_build_keymap(keymap_data, NULL,
> +					    keymap_rows, KBC_MAX_COL,
> +					    kbc->keycode, kbc->idev);
> +	if (retval == -ENOSYS || retval == -ENOENT) {

This is looking for ENOSYS or ENOENT, but ...

> diff --git a/drivers/input/matrix-keymap.c b/drivers/input/matrix-keymap.c

> +static int matrix_keypad_parse_of_keymap(const char *propname,

> +	if (!np)
> +		return -ENODEV;

Here and ...

> +	prop = of_get_property(np, propname, &proplen);
> +	if (!prop) {
> +		dev_err(dev, "OF: %s property not defined in %s\n",
> +			propname, np->full_name);
> +		return -ENODEV;

Here return ENODEV instead.

