Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab1ITWPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 18:15:11 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13376 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab1ITWPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 18:15:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 20 Sep 2011 15:15:06 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>
CC: Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 20 Sep 2011 15:15:05 -0700
Subject: RE: [PATCH 2/2 v7] pinmux: add a driver for the U300 pinmux
Thread-Topic: [PATCH 2/2 v7] pinmux: add a driver for the U300 pinmux
Thread-Index: Acx0ajVEMwDWtoPtTEy1te2PtKRE1QDd31EQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B7321777@HQMAIL01.nvidia.com>
References: <1316175249-10780-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1316175249-10780-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Friday, September 16, 2011 6:14 AM:
> This adds a driver for the U300 pinmux portions of the system
> controller "SYSCON". It also serves as an example of how to use
> the pinmux subsystem. This driver also houses the platform data
> for the only supported platform.
...
> diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
...
> +/* Pinmux settings */
> +static struct pinmux_map u300_pinmux_map[] = {
> +	/* anonymous maps for chip power and EMIFs */
> +	PINMUX_MAP_PRIMARY_SYS_HOG("POWER", "power"),
> +	PINMUX_MAP_PRIMARY_SYS_HOG("EMIF0", "emif0"),
> +	PINMUX_MAP_PRIMARY_SYS_HOG("EMIF1", "emif1"),
> +	/* per-device maps for MMC/SD, SPI and UART */
> +	PINMUX_MAP_PRIMARY("MMCSD", "mmc0", "mmci"),
> +	PINMUX_MAP_PRIMARY("SPI", "spi0", "pl022"),
> +	PINMUX_MAP_PRIMARY("UART0", "uart0", "uart0"),
> +};
> +
> +struct u300_mux_hog {
> +	const char *name;
> +	struct device *dev;
> +	struct pinmux *pmx;
> +};
> +
> +static struct u300_mux_hog u300_mux_hogs[] = {
> +	{
> +		.name = "uart0",
> +		.dev = &uart0_device.dev,
> +	},
> +	{
> +		.name = "spi0",
> +		.dev = &pl022_device.dev,
> +	},
> +	{
> +		.name = "mmc0",
> +		.dev = &mmcsd_device.dev,
> +	},
> +};
> +
> +static int __init u300_pinmux_fetch(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(u300_mux_hogs); i++) {
> +		struct pinmux *pmx;
> +		int ret;
> +
> +		pmx = pinmux_get(u300_mux_hogs[i].dev, NULL);
> +		if (IS_ERR(pmx)) {
> +			pr_err("u300: could not get pinmux hog %s\n",
> +			       u300_mux_hogs[i].name);
> +			continue;
> +		}
> +		ret = pinmux_enable(pmx);
> +		if (ret) {
> +			pr_err("u300: could enable pinmux hog %s\n",
> +			       u300_mux_hogs[i].name);
> +			continue;
> +		}
> +		u300_mux_hogs[i].pmx = pmx;
> +	}
> +	return 0;
> +}
> +subsys_initcall(u300_pinmux_fetch);

Why not just have the pinmux core support hogging on non-"system" mapping
entries; then everything I quoted above except u300_pinmux_map[] could
be deleted, and the "hog" flag set on the last 3 u300_pinmux_map[] entries.

-- 
nvpublic

