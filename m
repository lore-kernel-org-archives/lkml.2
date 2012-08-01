Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab2HAT7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 15:59:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32950 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753460Ab2HAT7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 15:59:50 -0400
Date: Wed, 1 Aug 2012 20:59:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Yong Shen <yong.shen@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: mc13783: Make mc13783_powermisc_rmw()
 lock protected
Message-ID: <20120801195947.GJ4483@opensource.wolfsonmicro.com>
References: <1342667766.6294.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342667766.6294.2.camel@phoenix>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 11:16:06AM +0800, Axel Lin wrote:
> Then we can remove lock/unlock around the caller.

Applied both, thanks.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/mc13783-regulator.c |   22 ++++++++--------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
> index 4932e34..2587ea1 100644
> --- a/drivers/regulator/mc13783-regulator.c
> +++ b/drivers/regulator/mc13783-regulator.c
> @@ -238,9 +238,10 @@ static int mc13783_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
>  
>  	BUG_ON(val & ~mask);
>  
> +	mc13xxx_lock(priv->mc13xxx);
>  	ret = mc13xxx_reg_read(mc13783, MC13783_REG_POWERMISC, &valread);
>  	if (ret)
> -		return ret;
> +		goto out;
>  
>  	/* Update the stored state for Power Gates. */
>  	priv->powermisc_pwgt_state =
> @@ -253,7 +254,10 @@ static int mc13783_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
>  	valread = (valread & ~MC13783_REG_POWERMISC_PWGTSPI_M) |
>  						priv->powermisc_pwgt_state;
>  
> -	return mc13xxx_reg_write(mc13783, MC13783_REG_POWERMISC, valread);
> +	ret = mc13xxx_reg_write(mc13783, MC13783_REG_POWERMISC, valread);
> +out:
> +	mc13xxx_unlock(priv->mc13xxx);
> +	return ret;
>  }
>  
>  static int mc13783_gpo_regulator_enable(struct regulator_dev *rdev)
> @@ -261,7 +265,6 @@ static int mc13783_gpo_regulator_enable(struct regulator_dev *rdev)
>  	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
>  	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
>  	int id = rdev_get_id(rdev);
> -	int ret;
>  	u32 en_val = mc13xxx_regulators[id].enable_bit;
>  
>  	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
> @@ -271,12 +274,8 @@ static int mc13783_gpo_regulator_enable(struct regulator_dev *rdev)
>  	    id == MC13783_REG_PWGT2SPI)
>  		en_val = 0;
>  
> -	mc13xxx_lock(priv->mc13xxx);
> -	ret = mc13783_powermisc_rmw(priv, mc13xxx_regulators[id].enable_bit,
> +	return mc13783_powermisc_rmw(priv, mc13xxx_regulators[id].enable_bit,
>  					en_val);
