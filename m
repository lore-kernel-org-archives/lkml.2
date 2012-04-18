Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab2DRJBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 05:01:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48175 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202Ab2DRJBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 05:01:37 -0400
Date: Wed, 18 Apr 2012 10:01:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Liam Girdwood <lrg@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 3/4] mfd: tps65910: Add device-tree support
Message-ID: <20120418090133.GC3021@opensource.wolfsonmicro.com>
References: <1334710829-22777-1-git-send-email-rklein@nvidia.com>
 <1334710829-22777-4-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WfZ7S8PLGjBY9Voh"
Content-Disposition: inline
In-Reply-To: <1334710829-22777-4-git-send-email-rklein@nvidia.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WfZ7S8PLGjBY9Voh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 17, 2012 at 06:00:28PM -0700, Rhyland Klein wrote:
> Add device tree based initialization support for TI's tps65910 pmic.

Actually, now I look at the larger patch this probably wants to be split
up by driver and possibly split further within that.

> +	board_data = tps65910->board_data;
> +	if (board_data->use_dt_for_init_data && tps65910->dev->of_node)
> +		ret = tps65910_gpio_parse_dt(tps65910->dev, board_data);
> +

This is a really odd idiom - normally the pattern for device tree
support is to just go and try to use the device tree data if it's there
and there's no need for any flag to say if it should be used.

> +	if (pdata->irq_base <= 0)
> +		pdata->irq_base = irq_alloc_descs(-1, 0, tps65910->irq_num, -1);
> +
> +	if (pdata->irq_base <= 0) {
> +		dev_err(tps65910->dev, "Failed to allocate irq descs: %d\n",
> +			pdata->irq_base);
> +		return pdata->irq_base;
> +	}
> +
> +	tps65910->irq_mask = 0xFFFFFF;
> +
> +	mutex_init(&tps65910->irq_lock);
> +	tps65910->chip_irq = irq;
> +	tps65910->irq_base = pdata->irq_base;

While this is needed for DT support it can be done separately and would
probably be better split out into a separate patch.

> +	/* Pass of data to child devices */
> +	for (idx = 0; idx < ARRAY_SIZE(tps65910s); idx++) {
> +		tps65910s[idx].platform_data = pmic_plat_data;
> +		tps65910s[idx].pdata_size = sizeof(*pmic_plat_data);
> +	}

Why is this needed - can't the DT parsing just be moved where it's used?

> +	for_each_child_of_node(regulators, child) {
> +		struct regulator_init_data *init_data;
> +
> +		init_data = of_get_regulator_init_data(&pdev->dev, child);
> +		if (!init_data) {
> +			dev_err(&pdev->dev,
> +				"failed to parse DT for regulator %s\n",
> +				child->name);
> +			return -EINVAL;
> +		}
> +
> +		for (idx = 0; idx < pmic->num_regulators; idx++) {

Hrm, this iteration over a group of regulators to find the relevant
node by name is going to be a fairly common pattern (there's already
at least one driver doing this IIRC) - we should really factor it out
into common code.  Please consider doing this when you resubmit.

> +			if (!strcasecmp(info[idx].name, child->name)) {
> +				if (all_data[idx]) {
> +					dev_err(&pdev->dev,
> +						"Duplicate Regulator Node %s\n",

Please fix the capitalisation in the error message.

> +		/* Check to see if we iterated without finding its name */
> +		if (idx == pmic->num_regulators) {
> +			dev_err(&pdev->dev,
> +				"Unknown regulator node found [%s]\n",
> +				child->name);
> +			return -EINVAL;
> +		}

It'd seem more robust to only print the warning and not return the
error, that way we don't completely fail the device initialisation if
there's data we don't understand.

I'm also not seeing a change here that passes the DT node to
regulator_register() - you should be doing that, it's needed so
consumers can bind to the regulator.

--WfZ7S8PLGjBY9Voh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjoLaAAoJEBus8iNuMP3dKJwP/2/3Rsl5H276Ulh+Fh1rTeJO
P50u5X9tcpCVvFpgfY/lexnbt4QE5UX/j3fq62yBL49nxSWgFIRecT2yevSrHzbl
lZS0A4+a1qitMao6l1zmLP8SaGFGGmJ1SgDGehThVzKZbT8KjLGcfJ5WOxJDHU+9
ToT/kYVqpdz2hmUu8xr5s2G4igbgGqrIJAkosqp9yoTe3UFpnJ9LPKHI1CQ+7VGZ
vt4VXAe+4Ec/LRMyNfGKnLClh3Daj71ENJqjU/x/o0Gc0EhJEvcPPDpYB4GQLdf5
PPXxnN2EtTtREd1cHlVazMODw8b1fKOM/YvgSdDYi1EH5nQr0h9rGE1FckBz2aOF
MrWO+9EKzFOEex1mFrzS9bumGH3nC8Y9oTxbDQokvARWom/aoq1NfkTNgShONbwR
kjlRfcbO9irw65yHCavmDEqAPzMzuJ6RNrq9DieKkYK70ZFGlCDeXtL7LX9lIe8K
LT2chf+h4DzZxq+MhyfnGW7Fx4ZecggOxC0OCH5SRSHBwP3EmoHgAO1hbTEvKEwi
h0inSW014fw7CUM8xlFp/yAE5IZXyvrqeFFnMNHpah6dzFlIkZNgd8C+dTt4RGzf
8CpCswQ9vRTu2zuaJCrxB2dTaya6/iIQB57wmMtCIg3FlDqJ7cQque1dsbBzd6GH
ZU7jfEzVyuCziWw02iYA
=Oqi2
-----END PGP SIGNATURE-----

--WfZ7S8PLGjBY9Voh--
