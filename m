Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2I1AzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 20:55:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60958 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab2I1AzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 20:55:23 -0400
Date: Thu, 27 Sep 2012 17:52:23 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 39/57] power: ab8500_charger: Prevent auto drop of VBUS
Message-ID: <20120928005223.GA5040@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-40-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-40-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:36AM -0600, mathieu.poirier@linaro.org wrote:
> From: Martin Sjoblom <martin.w.sjoblom@stericsson.com>
> 
> Do not set higher current in stepping functionality if VBUS is dropping.
> After VBUS has dropped try to set current once again. If dropping again
> then we have found the maximum capability of the charger.
> 
> Signed-off-by: Martin Sjoblom <martin.w.sjoblom@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Per FORLIN <per.forlin@stericsson.com>
> ---
>  drivers/power/ab8500_charger.c |  166 ++++++++++++++++++++++++++++------------
>  1 files changed, 117 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
> index ebeb068..18931e4 100644
> --- a/drivers/power/ab8500_charger.c
> +++ b/drivers/power/ab8500_charger.c
> @@ -55,6 +55,7 @@
>  #define MAIN_CH_INPUT_CURR_SHIFT	4
>  #define VBUS_IN_CURR_LIM_SHIFT		4
>  #define AUTO_VBUS_IN_CURR_LIM_SHIFT	4
> +#define VBUS_IN_CURR_LIM_RETRY_SET_TIME	30 /* seconds */
>  
>  #define LED_INDICATOR_PWM_ENA		0x01
>  #define LED_INDICATOR_PWM_DIS		0x00
> @@ -199,10 +200,15 @@ struct ab8500_charger_usb_state {
>  	spinlock_t usb_lock;
>  };
>  
> +struct ab8500_charger_max_usb_in_curr {
> +	int usb_type_max;
> +	int set_max;
> +	int calculated_max;
> +};
[...]
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
> -		di->is_usb_host = true;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P5;

It seems that you introduced struct max_usb_in_curr for no obvious
reason.

Because of this, there are a lot of churn, and much much longer lines all
over, which hurts readability.

Why not just introduce a usb_curr_set_max and usb_curr_calc_max in di->?
Or something alike, or make things shorter in general, somehow. E.g., why
do you have to repeat usb_? And why repeat max?

struct ab8500_chg_max_usb_in_curr {
	int type;
	int set;
	int calc;
};

This would be at least shorter and still understandable in a context. But
again, I guess we don't need this new struct -- you don't pass it anywhere
anyway.

>  		di->is_aca_rid = 0;
>  		break;
>  	case USB_STAT_HOST_CHG_HS_CHIRP:
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
> -		di->is_usb_host = true;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P5;
>  		di->is_aca_rid = 0;
>  		break;
>  	case USB_STAT_HOST_CHG_HS:
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
> -		di->is_usb_host = true;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P5;
>  		di->is_aca_rid = 0;
>  		break;
>  	case USB_STAT_ACA_RID_C_HS:
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P9;
> -		di->is_usb_host = false;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P9;
>  		di->is_aca_rid = 0;
>  		break;
>  	case USB_STAT_ACA_RID_A:
> @@ -690,8 +696,7 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
>  		 * can consume (900mA). Closest level is 500mA
>  		 */
>  		dev_dbg(di->dev, "USB_STAT_ACA_RID_A detected\n");
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
> -		di->is_usb_host = false;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P5;
>  		di->is_aca_rid = 1;
>  		break;
>  	case USB_STAT_ACA_RID_B:
> @@ -699,38 +704,35 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
>  		 * Dedicated charger level minus 120mA (20mA for ACA and
>  		 * 100mA for potential accessory). Closest level is 1300mA
>  		 */
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_1P3;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_1P3;
>  		dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d", link_status,
> -				di->max_usb_in_curr);
> -		di->is_usb_host = false;
> +				di->max_usb_in_curr.usb_type_max);
>  		di->is_aca_rid = 1;
>  		break;
>  	case USB_STAT_HOST_CHG_NM:
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
> -		di->is_usb_host = true;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P5;
>  		di->is_aca_rid = 0;
>  		break;
>  	case USB_STAT_DEDICATED_CHG:
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_1P5;
> -		di->is_usb_host = false;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_1P5;
>  		di->is_aca_rid = 0;
>  		break;
>  	case USB_STAT_ACA_RID_C_HS_CHIRP:
>  		case USB_STAT_ACA_RID_C_NM:
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_1P5;
> -		di->is_usb_host = false;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_1P5;
>  		di->is_aca_rid = 1;
>  		break;
>  	case USB_STAT_NOT_CONFIGURED:
>  		if (di->vbus_detected) {
>  			di->usb_device_is_unrecognised = true;
>  			dev_dbg(di->dev, "USB Type - Legacy charger.\n");
> -			di->max_usb_in_curr = USB_CH_IP_CUR_LVL_1P5;
> +			di->max_usb_in_curr.usb_type_max =
> +						USB_CH_IP_CUR_LVL_1P5;
>  			break;
>  		}
>  	case USB_STAT_HM_IDGND:
>  		dev_err(di->dev, "USB Type - Charging not allowed\n");
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P05;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P05;
>  		ret = -ENXIO;
>  		break;
>  	case USB_STAT_RESERVED:
> @@ -743,9 +745,11 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
>  		}
>  		if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
>  			dev_dbg(di->dev, "USB Type - Charging not allowed\n");
> -			di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P05;
> +			di->max_usb_in_curr.usb_type_max =
> +						USB_CH_IP_CUR_LVL_0P05;
>  			dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d",
> -					link_status, di->max_usb_in_curr);
> +				link_status,
> +				di->max_usb_in_curr.usb_type_max);
>  			ret = -ENXIO;
>  			break;
>  		}
> @@ -754,23 +758,24 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
>  	case USB_STAT_CARKIT_2:
>  	case USB_STAT_ACA_DOCK_CHARGER:
>  	case USB_STAT_CHARGER_LINE_1:
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P5;
>  		dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d", link_status,
> -				di->max_usb_in_curr);
> +				di->max_usb_in_curr.usb_type_max);
>  	case USB_STAT_NOT_VALID_LINK:
>  		dev_err(di->dev, "USB Type invalid - try charging anyway\n");
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P5;
>  		break;
>  
>  	default:
>  		dev_err(di->dev, "USB Type - Unknown\n");
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P05;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P05;
>  		ret = -ENXIO;
>  		break;
>  	};
>  
> +	di->max_usb_in_curr.set_max = di->max_usb_in_curr.usb_type_max;
>  	dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d",
> -		link_status, di->max_usb_in_curr);
> +		link_status, di->max_usb_in_curr.set_max);
>  
>  	return ret;
>  }
> @@ -1074,28 +1079,48 @@ static int ab8500_vbus_in_curr_to_regval(int curr)
>   */
>  static int ab8500_charger_get_usb_cur(struct ab8500_charger *di)
>  {
> +	int ret = 0;
>  	switch (di->usb_state.usb_current) {
>  	case 100:
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P09;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P09;
>  		break;
>  	case 200:
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P19;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P19;
>  		break;
>  	case 300:
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P29;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P29;
>  		break;
>  	case 400:
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P38;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P38;
>  		break;
>  	case 500:
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P5;
>  		break;
>  	default:
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P05;
> -		return -1;
> +		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_0P05;
> +		ret = -EPERM;
>  		break;
>  	};
> -	return 0;
> +	di->max_usb_in_curr.set_max = di->max_usb_in_curr.usb_type_max;
> +	return ret;
> +}
> +
> +/**
> + * ab8500_charger_check_continue_stepping() - Check to allow stepping
> + * @di:		pointer to the ab8500_charger structure
> + * @reg:	select what charger register to check
> + *
> + * Check if current stepping should be allowed to continue.
> + * Checks if charger source has not collapsed. If it has, further stepping
> + * is not allowed.
> + */
> +static bool ab8500_charger_check_continue_stepping(struct ab8500_charger *di,
> +						   int reg)
> +{
> +	if (reg == AB8500_USBCH_IPT_CRNTLVL_REG)
> +		return !di->flags.vbus_drop_end;
> +	else
> +		return true;

No need for else.

>  }
>  
>  /**
> @@ -1220,7 +1245,8 @@ static int ab8500_charger_set_current(struct ab8500_charger *di,
>  				usleep_range(step_udelay, step_udelay * 2);
>  		}
>  	} else {
> -		for (i = prev_curr_index + 1; i <= curr_index; i++) {
> +		bool allow = true;

Needs empty line here.

> +		for (i = prev_curr_index + 1; i <= curr_index && allow; i++) {
>  			dev_dbg(di->dev, "curr change_2 to: %x for 0x%02x\n",
>  				(u8) i << shift_value, reg);
>  			ret = abx500_set_register_interruptible(di->dev,
> @@ -1231,6 +1257,8 @@ static int ab8500_charger_set_current(struct ab8500_charger *di,
>  			}
>  			if (i != curr_index)
>  				usleep_range(step_udelay, step_udelay * 2);
> +
> +			allow = ab8500_charger_check_continue_stepping(di, reg);
>  		}
>  	}
>  
> @@ -1255,6 +1283,8 @@ static int ab8500_charger_set_vbus_in_curr(struct ab8500_charger *di,
>  
>  	/* We should always use to lowest current limit */
>  	min_value = min(di->bat->chg_params->usb_curr_max, ich_in);
> +	if (di->max_usb_in_curr.set_max > 0)
> +		min_value = min(di->max_usb_in_curr.set_max, min_value);
>  
>  	switch (min_value) {
>  	case 100:
> @@ -1609,7 +1639,7 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
>  
>  		/* USBChInputCurr: current that can be drawn from the usb */
>  		ret = ab8500_charger_set_vbus_in_curr(di,
> -					di->max_usb_in_curr);
> +					di->max_usb_in_curr.usb_type_max);
>  		if (ret) {
>  			dev_err(di->dev, "setting USBChInputCurr failed\n");
>  			return ret;
> @@ -1943,10 +1973,12 @@ static void ab8500_charger_check_vbat_work(struct work_struct *work)
>  		(di->old_vbat > VBAT_TRESH_IP_CUR_RED &&
>  		di->vbat > VBAT_TRESH_IP_CUR_RED))) {
>  
> -		dev_dbg(di->dev, "Vbat did cross threshold, curr: %d, new: %d,"
> -			" old: %d\n", di->max_usb_in_curr, di->vbat,
> -			di->old_vbat);
> -		ab8500_charger_set_vbus_in_curr(di, di->max_usb_in_curr);
> +		dev_dbg(di->dev, "Vbat did cross threshold, curr: %d,",
> +					di->max_usb_in_curr.usb_type_max);
> +		dev_dbg(di->dev, " new: %d, old: %d\n",
> +						di->vbat, di->old_vbat);
> +		ab8500_charger_set_vbus_in_curr(di,
> +					di->max_usb_in_curr.usb_type_max);
>  		power_supply_changed(&di->usb_chg.psy);
>  	}
>  
> @@ -2224,7 +2256,8 @@ static void ab8500_charger_usb_link_attach_work(struct work_struct *work)
>  
>  	/* Update maximum input current if USB enumeration is not detected */
>  	if (!di->usb.charger_online) {
> -		ret = ab8500_charger_set_vbus_in_curr(di, di->max_usb_in_curr);
> +		ret = ab8500_charger_set_vbus_in_curr(di,
> +					di->max_usb_in_curr.usb_type_max);
>  		if (ret)
>  			return;
>  	}
> @@ -2403,7 +2436,7 @@ static void ab8500_charger_usb_state_changed_work(struct work_struct *work)
>  		if (!ab8500_charger_get_usb_cur(di)) {
>  			/* Update maximum input current */
>  			ret = ab8500_charger_set_vbus_in_curr(di,
> -					di->max_usb_in_curr);
> +					di->max_usb_in_curr.usb_type_max);
>  			if (ret)
>  				return;
>  
> @@ -2617,15 +2650,45 @@ static void ab8500_charger_vbus_drop_end_work(struct work_struct *work)
>  {
>  	struct ab8500_charger *di = container_of(work,
>  		struct ab8500_charger, vbus_drop_end_work.work);
> +	int ret;
> +	u8 reg_value;
>  
>  	di->flags.vbus_drop_end = false;
>  
>  	/* Reset the drop counter */
>  	abx500_set_register_interruptible(di->dev,
>  				AB8500_CHARGER, AB8500_CHARGER_CTRL, 0x01);
> +	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
> +						AB8500_CH_USBCH_STAT2_REG,
> +						&reg_value);
> +	if (ret < 0) {
> +		dev_err(di->dev, "%s ab8500 read failed\n", __func__);
> +	} else {
> +		int curr = ab8500_charger_vbus_in_curr_map[
> +			reg_value >> AUTO_VBUS_IN_CURR_LIM_SHIFT];

empty line needed.

> +		if (di->max_usb_in_curr.calculated_max != curr) {
> +			/* USB source is collapsing */
> +			di->max_usb_in_curr.calculated_max = curr;
> +			dev_dbg(di->dev,
> +			"VBUS input current limiting to %d mA\n",
> +				di->max_usb_in_curr.calculated_max);
> +		} else {
> +			/*
> +			 * USB source can not give more than this amount.
> +			 * Taking more will collapse the source.
> +			 */
> +			di->max_usb_in_curr.set_max =
> +				di->max_usb_in_curr.calculated_max;
> +			dev_dbg(di->dev,
> +				"VBUS input current limited to %d mA\n",
> +				di->max_usb_in_curr.set_max);
> +			return;
> +		}
> +	}
>  
>  	if (di->usb.charger_connected)
> -		ab8500_charger_set_vbus_in_curr(di, di->max_usb_in_curr);
> +		ab8500_charger_set_vbus_in_curr(di,
> +			di->max_usb_in_curr.usb_type_max);
>  }
>  
>  /**
> @@ -2779,8 +2842,13 @@ static irqreturn_t ab8500_charger_vbuschdropend_handler(int irq, void *_di)
>  
>  	dev_dbg(di->dev, "VBUS charger drop ended\n");
>  	di->flags.vbus_drop_end = true;
> +
> +	/*
> +	 * VBUS might have dropped due to bad connection.
> +	 * Schedule a new input limit set to the value SW requests.
> +	 */
>  	queue_delayed_work(di->charger_wq, &di->vbus_drop_end_work,
> -						round_jiffies(30 * HZ));
> +			round_jiffies(VBUS_IN_CURR_LIM_RETRY_SET_TIME * HZ));
>  
>  	return IRQ_HANDLED;
>  }
> -- 
> 1.7.5.4
> 
> 
