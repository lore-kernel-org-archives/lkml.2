Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278Ab0FRSYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 14:24:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:8375 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab0FRSYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 14:24:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,440,1272870000"; 
   d="scan'208";a="528196069"
Date: Fri, 18 Jun 2010 20:24:32 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dan Carpenter <error27@gmail.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] mfd/88pm860x: fix uninitialized variable and clean up
Message-ID: <20100618182432.GE3582@sortiz.org>
References: <20100526225409.GQ22515@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100526225409.GQ22515@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Thu, May 27, 2010 at 12:54:09AM +0200, Dan Carpenter wrote:
> The original code had a compile warning:
> drivers/mfd/88pm860x-core.c:431: warning: ‘ret’ may be used
> 	uninitialized in this function
> It seems like the warning is valid if either pdata or pdata->touch is
> NULL.
> 
> This patch checks pdata and pdata->touch at the beginning of the 
> function.  That means everything can be pulled in one indent level.
> Now all the statements fit within the 80 character limit.
> 
> Also at that point the "use_gpadc" variable isn't needed and removing
> it simplifies the logic.
Thanks, patch applied to my for-next branch.

Cheers,
Samuel.


> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
> index 405d2d5..f9ada69 100644
> --- a/drivers/mfd/88pm860x-core.c
> +++ b/drivers/mfd/88pm860x-core.c
> @@ -428,52 +428,44 @@ static int __devinit device_gpadc_init(struct pm860x_chip *chip,
>  {
>  	struct i2c_client *i2c = (chip->id == CHIP_PM8607) ? chip->client \
>  				: chip->companion;
> -	int use_gpadc = 0, data, ret;
> +	int data;
> +	int ret;
>  
>  	/* initialize GPADC without activating it */
>  
> -	if (pdata && pdata->touch) {
> -		/* set GPADC MISC1 register */
> -		data = 0;
> -		data |= (pdata->touch->gpadc_prebias << 1)
> -			& PM8607_GPADC_PREBIAS_MASK;
> -		data |= (pdata->touch->slot_cycle << 3)
> -			& PM8607_GPADC_SLOT_CYCLE_MASK;
> -		data |= (pdata->touch->off_scale << 5)
> -			& PM8607_GPADC_OFF_SCALE_MASK;
> -		data |= (pdata->touch->sw_cal << 7)
> -			& PM8607_GPADC_SW_CAL_MASK;
> -		if (data) {
> -			ret = pm860x_reg_write(i2c, PM8607_GPADC_MISC1, data);
> -			if (ret < 0)
> -				goto out;
> -		}
> -		/* set tsi prebias time */
> -		if (pdata->touch->tsi_prebias) {
> -			data = pdata->touch->tsi_prebias;
> -			ret = pm860x_reg_write(i2c, PM8607_TSI_PREBIAS, data);
> -			if (ret < 0)
> -				goto out;
> -		}
> -		/* set prebias & prechg time of pen detect */
> -		data = 0;
> -		data |= pdata->touch->pen_prebias & PM8607_PD_PREBIAS_MASK;
> -		data |= (pdata->touch->pen_prechg << 5)
> -			& PM8607_PD_PRECHG_MASK;
> -		if (data) {
> -			ret = pm860x_reg_write(i2c, PM8607_PD_PREBIAS, data);
> -			if (ret < 0)
> -				goto out;
> -		}
> +	if (!pdata || !pdata->touch)
> +		return -EINVAL;
>  
> -		use_gpadc = 1;
> +	/* set GPADC MISC1 register */
> +	data = 0;
> +	data |= (pdata->touch->gpadc_prebias << 1) & PM8607_GPADC_PREBIAS_MASK;
> +	data |= (pdata->touch->slot_cycle << 3) & PM8607_GPADC_SLOT_CYCLE_MASK;
> +	data |= (pdata->touch->off_scale << 5) & PM8607_GPADC_OFF_SCALE_MASK;
> +	data |= (pdata->touch->sw_cal << 7) & PM8607_GPADC_SW_CAL_MASK;
> +	if (data) {
> +		ret = pm860x_reg_write(i2c, PM8607_GPADC_MISC1, data);
> +		if (ret < 0)
> +			goto out;
>  	}
> -
> -	/* turn on GPADC */
> -	if (use_gpadc) {
> -		ret = pm860x_set_bits(i2c, PM8607_GPADC_MISC1,
> -				      PM8607_GPADC_EN, PM8607_GPADC_EN);
> +	/* set tsi prebias time */
> +	if (pdata->touch->tsi_prebias) {
> +		data = pdata->touch->tsi_prebias;
> +		ret = pm860x_reg_write(i2c, PM8607_TSI_PREBIAS, data);
> +		if (ret < 0)
> +			goto out;
>  	}
> +	/* set prebias & prechg time of pen detect */
> +	data = 0;
> +	data |= pdata->touch->pen_prebias & PM8607_PD_PREBIAS_MASK;
> +	data |= (pdata->touch->pen_prechg << 5) & PM8607_PD_PRECHG_MASK;
> +	if (data) {
> +		ret = pm860x_reg_write(i2c, PM8607_PD_PREBIAS, data);
> +		if (ret < 0)
> +			goto out;
> +	}
> +
> +	ret = pm860x_set_bits(i2c, PM8607_GPADC_MISC1,
> +			      PM8607_GPADC_EN, PM8607_GPADC_EN);
>  out:
>  	return ret;
>  }

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
