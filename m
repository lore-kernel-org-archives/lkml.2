Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab1ECTPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:15:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35983 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab1ECTPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:15:30 -0400
Date: Tue, 3 May 2011 21:15:25 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC][PATCH] mfd: mc13xxx-core: put mutex lock down to
 mc13xxx_reg_rmw function
Message-ID: <20110503191525.GE11574@pengutronix.de>
References: <1304440079.16287.7.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1304440079.16287.7.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Axel,

On Wed, May 04, 2011 at 12:27:59AM +0800, Axel Lin wrote:
> The mc13xxx_reg_rmw function is doing read/modify/write bitmask operations,
> thus add the lock to protect it.
> Then we can remove the lock/unlock from the caller.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Note I don't have the hardware handy for testing.
> I appreciate if someone who has the device can test this patch.
> Regards,
> Axel
> 
>  drivers/mfd/mc13xxx-core.c                 |    8 ++++++--
>  drivers/regulator/mc13892-regulator.c      |   16 +++++++---------
>  drivers/regulator/mc13xxx-regulator-core.c |    6 ------
>  3 files changed, 13 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
> index 7e4d44b..5fb0fcc 100644
[snip]
> diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
> index 1b8f739..679b315 100644
> --- a/drivers/regulator/mc13892-regulator.c
> +++ b/drivers/regulator/mc13892-regulator.c
> @@ -449,7 +449,8 @@ static int mc13892_sw_regulator_set_voltage(struct regulator_dev *rdev,
>  	ret = mc13xxx_reg_read(priv->mc13xxx,
>  		mc13892_regulators[id].vsel_reg, &val);
>  	if (ret)
> -		goto err;
> +		mc13xxx_unlock(priv->mc13xxx);
> +		return ret;
>  
>  	hi  = val & MC13892_SWITCHERS0_SWxHI;
>  	if (value > 1375)
> @@ -464,11 +465,10 @@ static int mc13892_sw_regulator_set_voltage(struct regulator_dev *rdev,
>  		value = (value - 600000) / 25000;
>  
>  	mask = mc13892_regulators[id].vsel_mask | MC13892_SWITCHERS0_SWxHI;
> -	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13892_regulators[id].vsel_reg,
> -			mask, value << mc13892_regulators[id].vsel_shift);
> -err:
>  	mc13xxx_unlock(priv->mc13xxx);
>  
> +	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13892_regulators[id].vsel_reg,
> +			mask, value << mc13892_regulators[id].vsel_shift);
I havn't looked deeply, but I guess this can have unwanted side effects
here. Before you had:

	lock()
	do(something)
	do(something, else, that, needs, rmw)
	unlock()

and you introduced an unlock()/lock() between these two do()s.

I'm not convinced this change is good, though I agree that

	lock()
	rmw(...)
	unlock()

looks ugly, but imho this can better be fixed by adding a wrapper for
that sequence if you really want.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
