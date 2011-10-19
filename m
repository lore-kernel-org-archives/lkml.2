Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab1JSOAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:00:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37912 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab1JSOA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:00:29 -0400
Date: Wed, 19 Oct 2011 15:00:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kyle Manna <kyle.manna@fuel7.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@ti.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 6/6] mfd: TPS65910: Improve regulator init data
Message-ID: <20111019140027.GH18713@sirena.org.uk>
References: <1318962388-26151-1-git-send-email-kyle.manna@fuel7.com>
 <1318962388-26151-7-git-send-email-kyle.manna@fuel7.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318962388-26151-7-git-send-email-kyle.manna@fuel7.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 01:26:28PM -0500, Kyle Manna wrote:
> Improve the interface between platform code/board files to the TPS65910

Again, *always* CC maintainers on patches.

> regulators.  The TWL4030/6030 code was used as an example interface.

This isn't a good sign...

> This improved interface will allow use of the regulators without
> specifying all the constraints. Also gets rid of an assumption that
> the platform pass in an array of correct size and was unchecked.

You've not described the changes between the two interfaces.  Note that
empty constraints should be absolutely fine with the API.

> +	if (init_data->constraints.name)
> +		pmic->desc[i].name = init_data->constraints.name;
> +	else
> +		pmic->desc[i].name = info[i].name;

No, this is broken.  The name of the regulator is a fixed property of
the device and isn't something that ought to be overridden per system.

> +	/* TPS65910 and TPS65911 Regulators */
> +	rdev = add_regulator(pmic, info, TPS65910_REG_VRTC,
> +			pmic_plat_data->vrtc);
> +	if (IS_ERR(rdev))
> +		return PTR_ERR(rdev);
> +	rdev = add_regulator(pmic, info, TPS65910_REG_VIO,
> +			pmic_plat_data->vio);
> +
> +	if (IS_ERR(rdev))
> +		return PTR_ERR(rdev);
> +
> +	rdev = add_regulator(pmic, info, TPS65910_REG_VDD1,
> +			pmic_plat_data->vdd1);
> +	if (IS_ERR(rdev))
> +		return PTR_ERR(rdev);

This looks like a regression - we've gone from looping over an array
which is nice and simple to explicit code for each individual regulator
giving us lots of repetitive code...

> -err_unregister_regulator:
> -	while (--i >= 0)
> -		regulator_unregister(pmic->rdev[i]);
> -	kfree(pmic->rdev);

...and loosing all our cleanup if things go wrong which isn't great
either.
