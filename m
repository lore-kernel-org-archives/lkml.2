Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab2I1DoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 23:44:07 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46626 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab2I1DoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 23:44:05 -0400
Date: Thu, 27 Sep 2012 20:41:21 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 01/57] power: ab8500_bm: Charger current step-up/down
Message-ID: <20120928034120.GP5040@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-2-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-2-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:11:58AM -0600, mathieu.poirier@linaro.org wrote:
> From: Johan Bjornstedt <johan.bjornstedt@stericsson.com>
> 
> There is no state machine in the AB to step up/down
> the charger current to avoid dips and spikes on VBUS
> and VBAT when charging is started.
> Instead this is implemented in SW

Some general comment: the commit messages use random line wrapping length.

It's usually a good idea to make lines no longer than 74 columns (since
'git log' adds some spaces before the message) , but too short or random
is also not pretty.

> Signed-off-by: Johan Bjornstedt <johan.bjornstedt@stericsson.com>
> Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
> ---
>  drivers/power/ab8500_charger.c |  172 +++++++++++++++++++++++++++++++---------
>  1 files changed, 133 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
> index d4f0c98..3ceb788 100644
> --- a/drivers/power/ab8500_charger.c
> +++ b/drivers/power/ab8500_charger.c
> @@ -77,6 +77,9 @@
>  /* Lowest charger voltage is 3.39V -> 0x4E */
>  #define LOW_VOLT_REG			0x4E
>  
> +/* Step up/down delay in us */
> +#define STEP_UDELAY			1000
> +
>  /* UsbLineStatus register - usb types */
>  enum ab8500_charger_link_status {
>  	USB_STAT_NOT_CONFIGURED,
> @@ -934,6 +937,88 @@ static int ab8500_charger_get_usb_cur(struct ab8500_charger *di)
>  }
>  
>  /**
> + * ab8500_charger_set_current() - set charger current
> + * @di:		pointer to the ab8500_charger structure
> + * @ich:	charger current, in mA
> + * @reg:	select what charger register to set
> + *
> + * Set charger current.
> + * There is no state machine in the AB to step up/down the charger
> + * current to avoid dips and spikes on MAIN, VBUS and VBAT when
> + * charging is started. Instead we need to implement
> + * this charger current step-up/down here.
> + * Returns error code in case of failure else 0(on success)

Random line wrapping...

Sophisticated editors (like vim :-), can format text for you. i.e. 'gqip'
command. I'm sure emacs can do this too.

> + */
> +static int ab8500_charger_set_current(struct ab8500_charger *di,
> +	int ich, int reg)
> +{
> +	int ret, i;
> +	int curr_index, prev_curr_index, shift_value;

One variable per line, please.

> +	u8 reg_value;
> +
> +	switch (reg) {
> +	case AB8500_MCH_IPT_CURLVL_REG:
> +		shift_value = MAIN_CH_INPUT_CURR_SHIFT;
> +		curr_index = ab8500_current_to_regval(ich);
> +		break;
> +	case AB8500_USBCH_IPT_CRNTLVL_REG:
> +		shift_value = VBUS_IN_CURR_LIM_SHIFT;
> +		curr_index = ab8500_vbus_in_curr_to_regval(ich);
> +		break;
> +	case AB8500_CH_OPT_CRNTLVL_REG:
> +		shift_value = 0;
> +		curr_index = ab8500_current_to_regval(ich);
> +		break;
> +	default:
> +		dev_err(di->dev, "%s current register not valid\n", __func__);
> +		return -ENXIO;
> +	}
> +
> +	if (curr_index < 0) {
> +		dev_err(di->dev, "requested current limit out-of-range\n");
> +		return -ENXIO;
> +	}
> +
> +	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
> +		reg, &reg_value);
> +	if (ret < 0) {
> +		dev_err(di->dev, "%s read failed\n", __func__);
> +		return ret;
> +	}
> +	prev_curr_index = (reg_value >> shift_value);

No need for parenthesis.

> +	/* only update current if it's been changed */
> +	if (prev_curr_index == curr_index)
> +		return 0;
> +
> +	dev_dbg(di->dev, "%s set charger current: %d mA for reg: 0x%02x\n",
> +		__func__, ich, reg);
> +
> +	if (prev_curr_index > curr_index) {
> +		for (i = prev_curr_index - 1; i >= curr_index; i--) {
> +			ret = abx500_set_register_interruptible(di->dev,
> +				AB8500_CHARGER, reg, (u8) i << shift_value);
> +			if (ret) {
> +				dev_err(di->dev, "%s write failed\n", __func__);
> +				return ret;
> +			}
> +			usleep_range(STEP_UDELAY, STEP_UDELAY * 2);
> +		}
> +	} else {
> +		for (i = prev_curr_index + 1; i <= curr_index; i++) {
> +			ret = abx500_set_register_interruptible(di->dev,
> +				AB8500_CHARGER, reg, (u8) i << shift_value);
> +			if (ret) {
> +				dev_err(di->dev, "%s write failed\n", __func__);
> +				return ret;
> +			}
> +			usleep_range(STEP_UDELAY, STEP_UDELAY * 2);
> +		}
> +	}

Too much duplication.

Assuming that you need to preserve the order of the writes, i.e. if it
matters to the hw, I guess this (or something alike) will work:

write_current()
{
	uint start = prev_curr_index + 1;
	uint stop = curr_index + 1;
	int direction = 1;

	if (prev_curr_index > curr_index) {
		start = prev_curr_index - 1;
		stop = curr_index - 1;
		direction = -1;
	}

	for (i = start; i != stop; i += direction) {
		ret = abx500_set_register_interruptible(di->dev,
			AB8500_CHARGER, reg, (u8)i << shift_value);
		if (ret) {
			dev_err(di->dev, "%s write failed\n", __func__);
			return ret;
		}
		usleep_range(STEP_UDELAY, STEP_UDELAY * 2);
	}
}

If the order doesn't matter, it could be even simpler.

> +	return ret;
> +}
> +
> +/**
>   * ab8500_charger_set_vbus_in_curr() - set VBUS input current limit
>   * @di:		pointer to the ab8500_charger structure
>   * @ich_in:	charger input current limit
> @@ -944,8 +1029,6 @@ static int ab8500_charger_get_usb_cur(struct ab8500_charger *di)
>  static int ab8500_charger_set_vbus_in_curr(struct ab8500_charger *di,
>  		int ich_in)
>  {
> -	int ret;
> -	int input_curr_index;
>  	int min_value;
>  
>  	/* We should always use to lowest current limit */
> @@ -964,19 +1047,38 @@ static int ab8500_charger_set_vbus_in_curr(struct ab8500_charger *di,
>  		break;
>  	}
>  
> -	input_curr_index = ab8500_vbus_in_curr_to_regval(min_value);
> -	if (input_curr_index < 0) {
> -		dev_err(di->dev, "VBUS input current limit too high\n");
> -		return -ENXIO;
> -	}
> +	return ab8500_charger_set_current(di, min_value,
> +		AB8500_USBCH_IPT_CRNTLVL_REG);
> +}
>  
> -	ret = abx500_set_register_interruptible(di->dev, AB8500_CHARGER,
> -		AB8500_USBCH_IPT_CRNTLVL_REG,
> -		input_curr_index << VBUS_IN_CURR_LIM_SHIFT);
> -	if (ret)
> -		dev_err(di->dev, "%s write failed\n", __func__);
> +/**
> + * ab8500_charger_set_main_in_curr() - set main charger input current
> + * @di:		pointer to the ab8500_charger structure
> + * @ich_in:	input charger current, in mA
> + *
> + * Set main charger input current.
> + * Returns error code in case of failure else 0(on success)
> + */
> +static int ab8500_charger_set_main_in_curr(struct ab8500_charger *di,
> +	int ich_in)
> +{
> +	return ab8500_charger_set_current(di, ich_in,
> +		AB8500_MCH_IPT_CURLVL_REG);
> +}
>  
> -	return ret;
> +/**
> + * ab8500_charger_set_output_curr() - set charger output current
> + * @di:		pointer to the ab8500_charger structure
> + * @ich_out:	output charger current, in mA
> + *
> + * Set charger output current.
> + * Returns error code in case of failure else 0(on success)
> + */
> +static int ab8500_charger_set_output_curr(struct ab8500_charger *di,
> +	int ich_out)

Wrong indentation.

> +{
> +	return ab8500_charger_set_current(di, ich_out,
> +		AB8500_CH_OPT_CRNTLVL_REG);
>  }
>  
>  /**
> @@ -1088,18 +1190,18 @@ static int ab8500_charger_ac_en(struct ux500_charger *charger,
>  			return ret;
>  		}
>  		/* MainChInputCurr: current that can be drawn from the charger*/
> -		ret = abx500_set_register_interruptible(di->dev, AB8500_CHARGER,
> -			AB8500_MCH_IPT_CURLVL_REG,
> -			input_curr_index << MAIN_CH_INPUT_CURR_SHIFT);
> +		ret = ab8500_charger_set_main_in_curr(di,
> +			di->bat->chg_params->ac_curr_max);
>  		if (ret) {
> -			dev_err(di->dev, "%s write failed\n", __func__);
> +			dev_err(di->dev, "%s Failed to set MainChInputCurr\n",
> +				__func__);
>  			return ret;
>  		}
>  		/* ChOutputCurentLevel: protected output current */
> -		ret = abx500_set_register_interruptible(di->dev, AB8500_CHARGER,
> -			AB8500_CH_OPT_CRNTLVL_REG, (u8) curr_index);
> +		ret = ab8500_charger_set_output_curr(di, iset);
>  		if (ret) {
> -			dev_err(di->dev, "%s write failed\n", __func__);
> +			dev_err(di->dev,
> +			 "%s Failed to set ChOutputCurentLevel\n", __func__);
>  			return ret;
>  		}
>  
> @@ -1156,12 +1258,11 @@ static int ab8500_charger_ac_en(struct ux500_charger *charger,
>  				return ret;
>  			}
>  
> -			ret = abx500_set_register_interruptible(di->dev,
> -				AB8500_CHARGER,
> -				AB8500_CH_OPT_CRNTLVL_REG, CH_OP_CUR_LVL_0P1);
> +			ret = ab8500_charger_set_output_curr(di, 0);
>  			if (ret) {
>  				dev_err(di->dev,
> -					"%s write failed\n", __func__);
> +				 "%s Failed to set ChOutputCurentLevel\n",
> +				 __func__);

Weird, inconsistent indentation.

>  				return ret;
>  			}
>  		} else {
> @@ -1264,10 +1365,11 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
>  			return ret;
>  		}
>  		/* ChOutputCurentLevel: protected output current */
> -		ret = abx500_set_register_interruptible(di->dev, AB8500_CHARGER,
> -			AB8500_CH_OPT_CRNTLVL_REG, (u8) curr_index);
> +		ret = ab8500_charger_set_output_curr(di, ich_out);
>  		if (ret) {
> -			dev_err(di->dev, "%s write failed\n", __func__);
> +			dev_err(di->dev,
> +			 "%s Failed to set ChOutputCurentLevel\n",
> +			 __func__);

Weird indentation.

>  			return ret;
>  		}
>  		/* Check if VBAT overshoot control should be enabled */
> @@ -1364,7 +1466,6 @@ static int ab8500_charger_update_charger_current(struct ux500_charger *charger,
>  		int ich_out)
>  {
>  	int ret;
> -	int curr_index;
>  	struct ab8500_charger *di;
>  
>  	if (charger->psy.type == POWER_SUPPLY_TYPE_MAINS)
> @@ -1374,18 +1475,11 @@ static int ab8500_charger_update_charger_current(struct ux500_charger *charger,
>  	else
>  		return -ENXIO;
>  
> -	curr_index = ab8500_current_to_regval(ich_out);
> -	if (curr_index < 0) {
> -		dev_err(di->dev,
> -			"Charger current too high, "
> -			"charging not started\n");
> -		return -ENXIO;
> -	}
> -
> -	ret = abx500_set_register_interruptible(di->dev, AB8500_CHARGER,
> -		AB8500_CH_OPT_CRNTLVL_REG, (u8) curr_index);
> +	ret = ab8500_charger_set_output_curr(di, ich_out);
>  	if (ret) {
> -		dev_err(di->dev, "%s write failed\n", __func__);
> +		dev_err(di->dev,
> +		 "%s Failed to set ChOutputCurentLevel\n",
> +		 __func__);

Weird indentation. No need for the first line wrap.

>  		return ret;
>  	}
>  
> -- 
> 1.7.5.4
