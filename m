Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab1EMHMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 03:12:39 -0400
Received: from mx4.wp.pl ([212.77.101.8]:52039 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756590Ab1EMHMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 03:12:38 -0400
Date: Fri, 13 May 2011 09:13:00 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Igor Plyatov <plyatov@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_at91: SMC settings calculation bugfixes, support
 for t6z and IORDY
Message-ID: <20110513071300.GA2584@localhost.localdomain>
References: <1305224151-11557-1-git-send-email-plyatov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305224151-11557-1-git-send-email-plyatov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [MRPU]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

On Thu, May 12, 2011 at 10:15:51PM +0400, Igor Plyatov wrote:
> * New code correctly calculates SMC registers values, adjusts calculated
>   to admissible ranges, enlarges cycles when required and converts values
>   into SMC's format.
> * Support for TDF cycles (ATA t6z) and IORDY line added.
> * Eliminate need in the initial_timing structure.
> * Code cleanup.

Generally looks good for me, some remarks below.

> +		int *setup, int *pulse, int *cycle, int *cs_pulse)
> +{
> +	int ret_val;
> +	int err = 0;
> +	struct smc_range range_setup[] = {	/* SMC_SETUP valid values */
> +		{.min = 0,	.max = 31},	/* first  range */
> +		{.min = 128,	.max = 159}	/* second range */
> +	};
> +	struct smc_range range_pulse[] = {	/* SMC_PULSE valid values */
> +		{.min = 0,	.max = 63},	/* first  range */
> +		{.min = 256,	.max = 319}	/* second range */
> +	};
> +	struct smc_range range_cycle[] = {	/* SMC_CYCLE valid values */
> +		{.min = 0,	.max = 127},	/* first  range */
> +		{.min = 256,	.max = 383},	/* second range */
> +		{.min = 512,	.max = 639},	/* third  range */
> +		{.min = 768,	.max = 895}	/* fourth range */
> +	};

These /* ... rage */ comments are useless.

> +	*cs_pulse = *cycle;
> +	if (*cs_pulse > CS_PULSE_MAXIMUM) {
> +		dev_err(dev, "unable to calculate valid SMC settings\n");
> +		return -ER_SMC_CALC;
> +	}
> +
> +	ret_val = adjust_smc_value(cs_pulse, range_pulse,
> +					ARRAY_SIZE(range_pulse));
> +	if (ret_val < 0) {
> +		dev_warn(dev, "maximal SMC CS Pulse value\n");
> +	} else if (ret_val != 0) {
> +		*cycle = *cs_pulse;

cs_pulse and cycle will always have the same value here, so perhaps only
one variable can be used instead of two.

> + * to_smc_format - convert values into SMC format
> + * @setup: SETUP value of SMC Setup Register
> + * @pulse: PULSE value of SMC Pulse Register
> + * @cycle: CYCLE value of SMC Cycle Register
> + * @cs_pulse: NCS_PULSE value of SMC Pulse Register
> + */
> +static void to_smc_format(int *setup, int *pulse, int *cycle, int *cs_pulse)
> +{
> +	*setup = (*setup & 0x1f) | ((*setup & 0x80) >> 2);
> +	*pulse = (*pulse & 0x3f) | ((*pulse & 0x100) >> 2);
> +	*cycle = (*cycle & 0x7f) | ((*cycle & 0x300) >> 1);
> +	*cs_pulse = (*cs_pulse & 0x3f) | ((*cs_pulse & 0x100) >> 2);

Ok, here is the difference, but in previous functions cs_pulse seems
to be unneeded.

> +	do {
> +		ret = calc_smc_vals(dev, &setup, &pulse, &cycle, &cs_pulse);
> +	} while (ret == -ER_SMC_RECALC);

I do not quite understand why we have to recalculate, could you
add a short comment or explain?

Thanks
Stanislaw
