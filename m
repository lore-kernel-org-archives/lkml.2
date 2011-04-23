Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab1DWJg3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 05:36:29 -0400
Received: from mx4.wp.pl ([212.77.101.8]:23307 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab1DWJg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 05:36:27 -0400
Date: Sat, 23 Apr 2011 11:36:23 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Igor Plyatov <plyatov@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ATA: pata_at91.c bugfixes
Message-ID: <20110423093623.GA3410@localhost.localdomain>
References: <1303299877-12088-1-git-send-email-plyatov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303299877-12088-1-git-send-email-plyatov@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [oXPE]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Igor

On Wed, Apr 20, 2011 at 03:44:37PM +0400, Igor Plyatov wrote:
> * Fix "initial_timing" structure initialisation. The "struct ata_timing" must
>   contain 10 members, but ".dmack_hold" member was not initialised.
> * The AT91SAM9 microcontrollers use special coding scheme for SMC_SETUP,
>   SMC_PULSE, SMC_CYCLE registers.
>   Old driver operates correctly only with low master clock values, but
>   with high master clock it incorrectly calculates SMC values and stops
>   to operate, because SMC can be setup only to admissible ranges in special
>   format.
>   New code correctly calculates SMC registers values, adjusts calculated
>   to admissible ranges, enlarges cycles if required and converts values
>   into SMC's format.
> * Old driver calculates CS_SETUP and CS_PULSE cycles incorrectly
>   because of wrong assumptions.
>   New code calculates:
>       CS_SETUP = SETUP/2

If you to this, then {RD,WR}_SETUP have to be equal SETUP + SETUP/2
to generate proper setup (t0) time on IDE bus. I think the best way is
set CS_SETUP and CS_HOLD to 0 (what your code do if SETUP and HOLD <=1),
but to do this you need to take care of data float (t6z) 

> +static const struct ata_timing initial_timing = {
> +	.mode		= XFER_PIO_0,
> +	.setup		= 70,
> +	.act8b		= 290,
> +	.rec8b		= 240,
> +	.cyc8b		= 600,
> +	.active		= 165,
> +	.recover	= 150,
> +	.dmack_hold	= 0,
> +	.cycle		= 600,
> +	.udma		= 0
> +};

Is this really needed, why not use ata_timing_find_mode(XFER_PIO_0)?

> +static int adjust_smc_value(unsigned int *value, int *prange,
> +				unsigned int size)
> +{
> +	unsigned char i;
> +	int remainder;
> +
> +	for (i = 0; i < size; i = i + 2) {
> +		if (*value < prange[i]) {
> +			remainder = prange[i] - *value;
> +			*value = prange[i]; /* nearest valid value */
> +			return remainder;
> +		}
> +		else if ((prange[i] <= *value) && (*value <= prange[i+1])) {
> +			return 0;
> +		}
> +	}
> +	*value = prange[size - 1]; /* assign maximal possible value */
> +
> +	return -1; /* invalid value */
> +}
[snip]
> +static void calc_smc_vals(struct device *dev,
> +				unsigned int *setup, unsigned int *cs_setup,
> +				unsigned int *pulse, unsigned int *cs_pulse,
> +				unsigned int *cycle)
> +{
> +	int ret_val;
> +	int cs_hold;
> +	int range_setup[] = {	/* SMC_SETUP valid ranges */
> +		0, 31,		/* first  range */
> +		128, 159,	/* second range */
> +	};
> +	int range_pulse[] = {	/* SMC_PULSE valid ranges */
> +		0, 63,		/* first  range */
> +		256, 319,	/* second range */
> +	};
> +	int range_cycle[] = {	/* SMC_CYCLE valid ranges */
> +		0, 127,		/* first  range */
> +		256, 383,	/* second range */
> +		512, 639,	/* third  range */
> +		768, 895,	/* fourth range */
> +	};

Introducing helper structure like

struct smc_range {
	u16 min, max;
};

would be a bit cleaner way of coding that (hint: ARRAY_SIZE could be used
instead of sizeof then)

> -	dev_dbg(dev, "ATA timings: nrd_setup = %lu nrd_pulse = %lu nrd_cycle = %lu\n",
> -			nrd_setup, nrd_pulse, read_cycle);
> -	dev_dbg(dev, "ATA timings: nwe_setup = %lu nwe_pulse = %lu nwe_cycle = %lu\n",
> -			nwe_setup, nwe_pulse, write_cycle);
> -	dev_dbg(dev, "ATA timings: ncs_read_setup = %lu ncs_read_pulse = %lu\n",
> -			ncs_read_setup, ncs_read_pulse);
> -	dev_dbg(dev, "ATA timings: ncs_write_setup = %lu ncs_write_pulse = %lu\n",
> -			ncs_write_setup, ncs_write_pulse);

It's worth to have some debugging prints to check if values are calculated
properly.

Thanks
Stanislaw
