Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab0EQREj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 13:04:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51173 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754966Ab0EQREi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 13:04:38 -0400
Subject: Re: [linux-pm] Power Domain Framework
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: sundar.iyer@stericsson.com
Cc: Deepak Sikri <deepak.sikri79@gmail.com>,
       Viresh KUMAR <viresh.kumar@st.com>,
       Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
       Armando VISCONTI <armando.visconti@st.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
In-Reply-To: <1274114107.20589.64.camel@bnru01> (sfid-20100517_173524_963855_B42F2966)
References: <AANLkTinZU1D1rMOBQDi47tRhXrOXwduQIdni7bCXdce0@mail.gmail.com>
	 <20100510140527.GG5199@sirena.org.uk>
	 <AANLkTikyqnKDNz7FIUvLDAvBReHskHvRCrEz2qBBqseH@mail.gmail.com>
	 <20100517031613.GA3130@opensource.wolfsonmicro.com>
	 <AANLkTimDdBCnRFMDiUkuNKanOzuPNwCpfRv9Gsi03Lsy@mail.gmail.com>
	 <AANLkTinZRhUpFTOOUCdH5dEl3QaXn10USL_hPPQX8cie@mail.gmail.com>
	 <20100517143319.GC5257@opensource.wolfsonmicro.com>
	 <AANLkTiniwUDg8rQzwgm_X7EbkQJ9tHzBfVtaJRiNE9az@mail.gmail.com>
	 <1274114107.20589.64.camel@bnru01> (sfid-20100517_173524_963855_B42F2966)
Content-Type: text/plain; charset="UTF-8"
Organization: Wolfson Microelectronics
Date: Mon, 17 May 2010 10:04:46 -0700
Message-ID: <1274115886.2698.22.camel@finisterre.wolfsonmicro.main>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 22:05 +0530, Sundar R Iyer wrote:

> +/* locks held by regulator_set_operating_point() */
> +static int _regulator_set_operating_point(struct regulator_dev *rdev,
> +		unsigned int opp)
> +{
> +	int ret, regulator_curr_opp = 0;
> +
> +	if (!(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_OPP)) {
> +		printk(KERN_ERR "%s: operation not allowed for %s\n",
> +				__func__, rdev->desc->name);
> +		return -EPERM;
> +	}
> +
> +	/* sanity checks */
> +	if (!rdev->desc->ops->set_operating_point) {
> +		return -EINVAL;
> +	}
> +
> +	if (rdev->desc->ops->get_operating_point)
> +		regulator_curr_opp = rdev->desc->ops->get_operating_point(rdev);
> +
> +	/* we have no issues with upgrading the opp */
> +	if (opp == REGULATOR_OPERATINGPOINT_FULL) {
> +		if (rdev->constraints->opp_constraint_count < 1) {
> +			if (rdev->supply)
> +				ret = _regulator_set_operating_point(rdev->supply, opp);
> +			ret = rdev->desc->ops->set_operating_point(rdev, opp);
> +		}
> +		rdev->constraints->opp_constraint_count++;
> +	}

This implementation is assuming that the implementation in hardware only
has two levels, and that the decision to go to the higher level is done
by a simple or of requests for the full level from the consumers. I'm
not convinced that this will be true in general, or that it's always
going to be true that the different power domains are all isolated from
each other. There doesn't seem to be any immediate reason why hardware
won't ever implement more than two modes, and I'm not convinced that the
straight or of requests will always be sufficient to determine the
operating mode for the entire power domain. For example, I can see
hardware requiring that if more than a given number of blocks are
enabled at any level a higher operating point is selected.

Are you sure that this interface is sufficiently general to work with
all hardware, not just your own? How does this map on to the OMAP or SH
hardware, for example?

