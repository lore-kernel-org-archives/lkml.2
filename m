Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1LFLPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:15:04 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52783 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab1LFLPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:15:03 -0500
Date: Tue, 6 Dec 2011 11:14:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: aliaksei.katovich@nokia.com
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: bq2415x charger driver
Message-ID: <20111206111458.GA17194@sirena.org.uk>
References: <cover.1299679848.git.aliaksei.katovich@nokia.com>
 <af9ea8649257cedcdcc531ce918fa4fba5b4e4a7.1299679848.git.aliaksei.katovich@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af9ea8649257cedcdcc531ce918fa4fba5b4e4a7.1299679848.git.aliaksei.katovich@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 04:48:03PM +0200, aliaksei.katovich@nokia.com wrote:

> +	file = debugfs_create_file("regdump", 0444, root, cli, &bq2415x_ops);
> +	if (IS_ERR(file))
> +		return;

Rather than create a custom register dump interface I'd suggest
converting to the regmap API which provides standard code to do this.

> +
> +/**
> + * bq2415x_exec - execute charger specific command
> + *
> + * Returns result of command execution upon success or negative otherwise
> + */
> +int bq2415x_exec(enum bq2415x_cmd cmd)
> +{
> +	int res;

> +	if (!bq2415x_cli)
> +		return -ENODEV;

> +	switch (cmd) {
> +	case BQ2415X_ENABLE_CHARGER:
> +		res = bq2415x_enable_charger(true);
> +		break;

...

> +EXPORT_SYMBOL(bq2415x_exec);

This should clearly be going through kernel frameworks and even if
defining a custom in kernel API for this device there's no reason to
emulate ioctl().

> +static int bq2415x_list_voltage(struct regulator_dev *rdev, unsigned i)
> +{
> +	struct bq2415x_regulator *r = rdev_get_drvdata(rdev);
> +
> +	if (i >= r->desc.n_voltages)
> +		return 0;
> +
> +	return bq2415x_vmap_calc(i, r->val_summ, r->init.constraints.min_uV);
> +}

MFDs should put their subfunction drivers within the appropriate
subsystem.

> +static int
> +bq2415x_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
> +{

This won't compile against current kernels, always submit against the
latest development versions (though in this case it won't compile with
3.0...)


> +	/* populate my consumers table */
> +	for (i = 0, j = 0; i < init->num_consumer_supplies && j < n; i++) {

No, this is all wrong - just pass the init data (including consumers)
straight through from the machine driver like all the other regulator
drivers.
