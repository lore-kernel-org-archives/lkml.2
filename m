Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab2I0Hpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:45:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50996 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab2I0Hp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:45:27 -0400
Date: Thu, 27 Sep 2012 00:42:39 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 33/57] power: u8500_charger: Delay for USB enumeration
Message-ID: <20120927074238.GN8836@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-34-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-34-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:30AM -0600, mathieu.poirier@linaro.org wrote:
> From: Paer-Olof Haakansson <par-olof.hakansson@stericsson.com>
> 
> If charging is started before USB enumeration of an
> Accessory Charger Adapter has finished, the AB8500 will
> generate a VBUS_ERROR. This in turn results in timeouts
> and delays the enumeration with around 15 seconds.
> This patch delays the charging and then ramps currents
> slowly to avoid VBUS errors. The delay allows the enumeration
> to have finished before charging is turned on.
> 
> Signed-off-by: Martin Sjoblom <martin.w.sjoblom@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
> ---
[...]
> @@ -264,17 +275,19 @@ struct ab8500_charger {
>  	struct ab8500_charger_info usb;
>  	struct regulator *regu;
>  	struct workqueue_struct *charger_wq;
> +	struct mutex usb_ipt_crnt_lock;
>  	struct delayed_work check_vbat_work;
>  	struct delayed_work check_hw_failure_work;
>  	struct delayed_work check_usbchgnotok_work;
>  	struct delayed_work kick_wd_work;
> +	struct delayed_work usb_state_changed_work;
>  	struct delayed_work attach_work;
>  	struct delayed_work ac_charger_attached_work;
>  	struct delayed_work usb_charger_attached_work;
> +	struct delayed_work vbus_drop_end_work;
>  	struct work_struct ac_work;
>  	struct work_struct detect_usb_type_work;
>  	struct work_struct usb_link_status_work;
> -	struct work_struct usb_state_changed_work;

This just moves line around. Doesn't belong to this patch.

>  	struct work_struct check_main_thermal_prot_work;
>  	struct work_struct check_usb_thermal_prot_work;
>  	struct usb_phy *usb_phy;
> @@ -560,6 +573,7 @@ static int ab8500_charger_usb_cv(struct ab8500_charger *di)
>  /**
>   * ab8500_charger_detect_chargers() - Detect the connected chargers
>   * @di:		pointer to the ab8500_charger structure
> + * @probe:     if probe, don't delay and wait for HW
>   *
>   * Returns the type of charger connected.
>   * For USB it will not mean we can actually charge from it
> @@ -570,10 +584,10 @@ static int ab8500_charger_usb_cv(struct ab8500_charger *di)
>   * Returns an integer value, that means,
>   * NO_PW_CONN  no power supply is connected
>   * AC_PW_CONN  if the AC power supply is connected
> - * USB_PW_CONN  if the USB power supply is connected
> + * USB_PW_CONN	if the USB power supply is connected

Cosmetic change... doesn't belong to this patch, I guess.

>   * AC_PW_CONN + USB_PW_CONN if USB and AC power supplies are both connected
>   */
> -static int ab8500_charger_detect_chargers(struct ab8500_charger *di)
> +static int ab8500_charger_detect_chargers(struct ab8500_charger *di, bool probe)
>  {
>  	int result = NO_PW_CONN;
>  	int ret;
> @@ -591,6 +605,15 @@ static int ab8500_charger_detect_chargers(struct ab8500_charger *di)
>  		result = AC_PW_CONN;
>  
>  	/* Check for USB charger */
> +	if (!probe) {
> +		/*
> +		 * AB8500 says VBUS_DET_DBNC1 & VBUS_DET_DBNC100
> +		 * when disconnecting ACA even though no
> +		 * charger was connected. Try waiting a little
> +		 * longer than the 100 ms of VBUS_DET_DBNC100...
> +		 */
> +		msleep(110);
> +	}
>  	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
>  		AB8500_CH_USBCH_STAT1_REG, &val);
>  	if (ret < 0) {
> @@ -598,6 +621,9 @@ static int ab8500_charger_detect_chargers(struct ab8500_charger *di)
>  		return ret;
>  	}
>  
> +	dev_dbg(di->dev,
> +		"%s AB8500_CH_USBCH_STAT1_REG %x\n", __func__, val);
> +
>  	if ((val & VBUS_DET_DBNC1) && (val & VBUS_DET_DBNC100))
>  		result |= USB_PW_CONN;
>  
> @@ -620,33 +646,47 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
>  
>  	di->usb_device_is_unrecognised = false;
>  
> +	/*
> +	 * Platform only supports USB 2.0.
> +	 * This means that charging current from USB source
> +	 * is maximum 500 mA. Every occurence of USB_STAT_*_HOST_*
> +	 * should set USB_CH_IP_CUR_LVL_0P5.
> +	 */
> +
>  	switch (link_status) {
>  	case USB_STAT_STD_HOST_NC:
>  	case USB_STAT_STD_HOST_C_NS:
>  	case USB_STAT_STD_HOST_C_S:
>  		dev_dbg(di->dev, "USB Type - Standard host is ");
>  		dev_dbg(di->dev, "detected through USB driver\n");
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P09;
> +		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
> +		di->is_usb_host = true;
> +		di->is_aca_rid = 0;
>  		break;
>  	case USB_STAT_HOST_CHG_HS_CHIRP:
>  		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
> -		dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d", link_status,
> -				di->max_usb_in_curr);
> +		di->is_usb_host = true;
> +		di->is_aca_rid = 0;
>  		break;
>  	case USB_STAT_HOST_CHG_HS:
> +		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
> +		di->is_usb_host = true;
> +		di->is_aca_rid = 0;
> +		break;
>  	case USB_STAT_ACA_RID_C_HS:
>  		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P9;
> -		dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d", link_status,
> -				di->max_usb_in_curr);
> +		di->is_usb_host = false;
> +		di->is_aca_rid = 0;
>  		break;
>  	case USB_STAT_ACA_RID_A:
>  		/*
>  		 * Dedicated charger level minus maximum current accessory
> -		 * can consume (300mA). Closest level is 1100mA
> +		 * can consume (900mA). Closest level is 500mA
>  		 */
> -		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_1P1;
> -		dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d", link_status,
> -				di->max_usb_in_curr);
> +		dev_dbg(di->dev, "USB_STAT_ACA_RID_A detected\n");
> +		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
> +		di->is_usb_host = false;
> +		di->is_aca_rid = 1;
>  		break;
>  	case USB_STAT_ACA_RID_B:
>  		/*
> @@ -656,14 +696,24 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
>  		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_1P3;
>  		dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d", link_status,
>  				di->max_usb_in_curr);
> +		di->is_usb_host = false;
> +		di->is_aca_rid = 1;
>  		break;
>  	case USB_STAT_HOST_CHG_NM:
> +		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_0P5;
> +		di->is_usb_host = true;
> +		di->is_aca_rid = 0;
> +		break;
>  	case USB_STAT_DEDICATED_CHG:
> -	case USB_STAT_ACA_RID_C_NM:
> +		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_1P5;
> +		di->is_usb_host = false;
> +		di->is_aca_rid = 0;
> +		break;
>  	case USB_STAT_ACA_RID_C_HS_CHIRP:
> +		case USB_STAT_ACA_RID_C_NM:
>  		di->max_usb_in_curr = USB_CH_IP_CUR_LVL_1P5;
> -		dev_dbg(di->dev, "USB Type - 0x%02x MaxCurr: %d", link_status,
> -				di->max_usb_in_curr);
> +		di->is_usb_host = false;
> +		di->is_aca_rid = 1;
>  		break;
>  	case USB_STAT_NOT_CONFIGURED:
>  		if (di->vbus_detected) {
> @@ -780,6 +830,8 @@ static int ab8500_charger_detect_usb_type(struct ab8500_charger *di)
>  		ret = abx500_get_register_interruptible(di->dev,
>  			AB8500_INTERRUPT, AB8500_IT_SOURCE21_REG,
>  			&val);
> +		dev_dbg(di->dev, "%s AB8500_IT_SOURCE21_REG %x\n",
> +							 __func__, val);
>  		if (ret < 0) {
>  			dev_err(di->dev, "%s ab8500 read failed\n", __func__);
>  			return ret;
> @@ -795,6 +847,8 @@ static int ab8500_charger_detect_usb_type(struct ab8500_charger *di)
>  			dev_err(di->dev, "%s ab8500 read failed\n", __func__);
>  			return ret;
>  		}
> +		dev_dbg(di->dev, "%s AB8500_USB_LINE_STAT_REG %x\n",
> +							 __func__, val);
>  		/*
>  		 * Until the IT source register is read the UsbLineStatus
>  		 * register is not updated, hence doing the same
> @@ -1054,69 +1108,128 @@ static int ab8500_charger_get_usb_cur(struct ab8500_charger *di)
>  static int ab8500_charger_set_current(struct ab8500_charger *di,
>  	int ich, int reg)
>  {
> -	int ret, i;
> -	int curr_index, prev_curr_index, shift_value;
> +	int ret = 0;

= 0 initializer is not needed.

> +	int auto_curr_index, curr_index, prev_curr_index, shift_value, i;

Should be one variable definition per line.

>  	u8 reg_value;
> +	u32 step_udelay;
> +	bool no_stepping = false;
> +
> +	atomic_inc(&di->current_stepping_sessions);
> +
> +	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
> +		reg, &reg_value);
> +	if (ret < 0) {
> +		dev_err(di->dev, "%s read failed\n", __func__);
> +		goto exit_set_current;
> +	}
>  
>  	switch (reg) {
>  	case AB8500_MCH_IPT_CURLVL_REG:
>  		shift_value = MAIN_CH_INPUT_CURR_SHIFT;
> +		prev_curr_index = (reg_value >> shift_value);
>  		curr_index = ab8500_current_to_regval(ich);
> +		step_udelay = STEP_UDELAY;
> +		if (!di->ac.charger_connected)
> +			no_stepping = true;
>  		break;
>  	case AB8500_USBCH_IPT_CRNTLVL_REG:
>  		shift_value = VBUS_IN_CURR_LIM_SHIFT;
> +		prev_curr_index = (reg_value >> shift_value);
>  		curr_index = ab8500_vbus_in_curr_to_regval(ich);
> +		step_udelay = STEP_UDELAY * 100;
> +
> +		ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
> +					AB8500_CH_USBCH_STAT2_REG, &reg_value);
> +
> +		if (ret < 0) {
> +			dev_err(di->dev, "%s read failed\n", __func__);
> +			goto exit_set_current;
> +		}
> +		auto_curr_index =
> +			reg_value >> AUTO_VBUS_IN_CURR_LIM_SHIFT;

This fits into one line ,no need for line wrap.

> +
> +		dev_dbg(di->dev, "%s Auto VBUS curr is %d mA\n",
> +			__func__,

__func__ can go into previous line.

> +			ab8500_charger_vbus_in_curr_map[auto_curr_index]);
> +
> +		prev_curr_index = min(prev_curr_index, auto_curr_index);
> +
> +		if (!di->usb.charger_connected)
> +			no_stepping = true;
>  		break;
>  	case AB8500_CH_OPT_CRNTLVL_REG:
>  		shift_value = 0;
> +		prev_curr_index = (reg_value >> shift_value);
>  		curr_index = ab8500_current_to_regval(ich);
> +		if (curr_index == 0)
> +			step_udelay = STEP_UDELAY;
> +		else if ((curr_index - prev_curr_index) > 1)
> +			step_udelay = STEP_UDELAY * 100;
> +		else
> +			step_udelay = STEP_UDELAY;
		
Just

		step_udelay = STEP_UDELAY;
		if (curr_index && (curr_index - prev_curr_index) > 1)
			step_udelay *= 100;

> +
> +		if (!di->usb.charger_connected && !di->ac.charger_connected)
> +			no_stepping = true;
> +
>  		break;
>  	default:
>  		dev_err(di->dev, "%s current register not valid\n", __func__);
> -		return -ENXIO;
> +		ret = -ENXIO;
> +		goto exit_set_current;
>  	}
>  
>  	if (curr_index < 0) {
>  		dev_err(di->dev, "requested current limit out-of-range\n");
> -		return -ENXIO;
> -	}
> -
> -	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
> -		reg, &reg_value);
> -	if (ret < 0) {
> -		dev_err(di->dev, "%s read failed\n", __func__);
> -		return ret;
> +		ret = -ENXIO;
> +		goto exit_set_current;
>  	}
> -	prev_curr_index = (reg_value >> shift_value);
>  
>  	/* only update current if it's been changed */
> -	if (prev_curr_index == curr_index)
> -		return 0;
> +	if (prev_curr_index == curr_index) {
> +		dev_dbg(di->dev, "%s current not changed for reg: 0x%02x\n",
> +			__func__, reg);
> +		ret = 0;
> +		goto exit_set_current;
> +	}
>  
>  	dev_dbg(di->dev, "%s set charger current: %d mA for reg: 0x%02x\n",
>  		__func__, ich, reg);
>  
> -	if (prev_curr_index > curr_index) {
> +	if (no_stepping) {
> +		ret = abx500_set_register_interruptible(di->dev, AB8500_CHARGER,
> +					reg, (u8) curr_index << shift_value);

No space before curr_index.

> +		if (ret)
> +			dev_err(di->dev, "%s write failed\n", __func__);
> +	} else if (prev_curr_index > curr_index) {
>  		for (i = prev_curr_index - 1; i >= curr_index; i--) {
> +			dev_dbg(di->dev, "curr change_1 to: %x for 0x%02x\n",
> +				(u8) i << shift_value, reg);

ditto.

>  			ret = abx500_set_register_interruptible(di->dev,
>  				AB8500_CHARGER, reg, (u8) i << shift_value);
>  			if (ret) {
>  				dev_err(di->dev, "%s write failed\n", __func__);
> -				return ret;
> +				goto exit_set_current;
>  			}
> -			usleep_range(STEP_UDELAY, STEP_UDELAY * 2);
> +			if (i != curr_index)
> +				usleep_range(step_udelay, step_udelay * 2);
>  		}
>  	} else {
>  		for (i = prev_curr_index + 1; i <= curr_index; i++) {
> +			dev_dbg(di->dev, "curr change_2 to: %x for 0x%02x\n",
> +				(u8) i << shift_value, reg);

ditto.

>  			ret = abx500_set_register_interruptible(di->dev,
>  				AB8500_CHARGER, reg, (u8) i << shift_value);
>  			if (ret) {
>  				dev_err(di->dev, "%s write failed\n", __func__);
> -				return ret;
> +				goto exit_set_current;
>  			}
> -			usleep_range(STEP_UDELAY, STEP_UDELAY * 2);
> +			if (i != curr_index)
> +				usleep_range(step_udelay, step_udelay * 2);
>  		}
>  	}
> +
> +exit_set_current:
> +	atomic_dec(&di->current_stepping_sessions);
>  	return ret;
>  }
>  
> @@ -1132,6 +1245,7 @@ static int ab8500_charger_set_vbus_in_curr(struct ab8500_charger *di,
>  		int ich_in)
>  {
>  	int min_value;
> +	int ret;
>  
>  	/* We should always use to lowest current limit */
>  	min_value = min(di->bat->chg_params->usb_curr_max, ich_in);
> @@ -1149,8 +1263,14 @@ static int ab8500_charger_set_vbus_in_curr(struct ab8500_charger *di,
>  		break;
>  	}
>  
> -	return ab8500_charger_set_current(di, min_value,
> +	dev_info(di->dev, "VBUS input current limit set to %d mA\n", min_value);
> +
> +	mutex_lock(&di->usb_ipt_crnt_lock);
> +	ret = ab8500_charger_set_current(di, min_value,
>  		AB8500_USBCH_IPT_CRNTLVL_REG);
> +	mutex_unlock(&di->usb_ipt_crnt_lock);
> +
> +	return ret;
>  }
>  
>  /**
> @@ -1460,25 +1580,13 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
>  			dev_err(di->dev, "%s write failed\n", __func__);
>  			return ret;
>  		}
> -		/* USBChInputCurr: current that can be drawn from the usb */
> -		ret = ab8500_charger_set_vbus_in_curr(di, di->max_usb_in_curr);
> -		if (ret) {
> -			dev_err(di->dev, "setting USBChInputCurr failed\n");
> -			return ret;
> -		}
> -		/* ChOutputCurentLevel: protected output current */
> -		ret = ab8500_charger_set_output_curr(di, ich_out);
> -		if (ret) {
> -			dev_err(di->dev,
> -			 "%s Failed to set ChOutputCurentLevel\n",
> -			 __func__);
> -			return ret;
> -		}
>  		/* Check if VBAT overshoot control should be enabled */
>  		if (!di->bat->enable_overshoot)
>  			overshoot = USB_CHG_NO_OVERSHOOT_ENA_N;
>  
>  		/* Enable USB Charger */
> +		dev_dbg(di->dev,
> +			"Enabling USB with write to AB8500_USBCH_CTRL1_REG\n");
>  		ret = abx500_set_register_interruptible(di->dev, AB8500_CHARGER,
>  			AB8500_USBCH_CTRL1_REG, USB_CH_ENA | overshoot);
>  		if (ret) {
> @@ -1491,11 +1599,30 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
>  		if (ret < 0)
>  			dev_err(di->dev, "failed to enable LED\n");
>  
> +		di->usb.charger_online = 1;
> +
> +		/* USBChInputCurr: current that can be drawn from the usb */
> +		ret = ab8500_charger_set_vbus_in_curr(di,
> +					di->max_usb_in_curr);
> +		if (ret) {
> +			dev_err(di->dev, "setting USBChInputCurr failed\n");
> +			return ret;
> +		}
> +
> +		/* ChOutputCurentLevel: protected output current */
> +		ret = ab8500_charger_set_output_curr(di, ich_out);
> +		if (ret) {
> +			dev_err(di->dev,
> +				"%s Failed to set ChOutputCurentLevel\n",
> +				__func__);
> +			return ret;
> +		}
> +
>  		queue_delayed_work(di->charger_wq, &di->check_vbat_work, HZ);
>  
> -		di->usb.charger_online = 1;
>  	} else {
>  		/* Disable USB charging */
> +		dev_dbg(di->dev, "%s Disabled USB charging\n", __func__);
>  		ret = abx500_set_register_interruptible(di->dev,
>  			AB8500_CHARGER,
>  			AB8500_USBCH_CTRL1_REG, 0);
> @@ -1508,7 +1635,21 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
>  		ret = ab8500_charger_led_en(di, false);
>  		if (ret < 0)
>  			dev_err(di->dev, "failed to disable LED\n");
> +		/* USBChInputCurr: current that can be drawn from the usb */
> +		ret = ab8500_charger_set_vbus_in_curr(di, 0);
> +		if (ret) {
> +			dev_err(di->dev, "setting USBChInputCurr failed\n");
> +			return ret;
> +		}
>  
> +		/* ChOutputCurentLevel: protected output current */
> +		ret = ab8500_charger_set_output_curr(di, 0);
> +		if (ret) {
> +			dev_err(di->dev,
> +				"%s Failed to reset ChOutputCurentLevel\n",
> +				__func__);
> +			return ret;
> +		}
>  		di->usb.charger_online = 0;
>  		di->usb.wd_expired = false;
>  
> @@ -1791,7 +1932,7 @@ static void ab8500_charger_ac_work(struct work_struct *work)
>  	 * synchronously, we have the check if the main charger is
>  	 * connected by reading the status register
>  	 */
> -	ret = ab8500_charger_detect_chargers(di);
> +	ret = ab8500_charger_detect_chargers(di, false);
>  	if (ret < 0)
>  		return;
>  
> @@ -1899,16 +2040,18 @@ static void ab8500_charger_detect_usb_type_work(struct work_struct *work)
>  	 * synchronously, we have the check if is
>  	 * connected by reading the status register
>  	 */
> -	ret = ab8500_charger_detect_chargers(di);
> +	ret = ab8500_charger_detect_chargers(di, false);
>  	if (ret < 0)
>  		return;
>  
>  	if (!(ret & USB_PW_CONN)) {
> -		di->vbus_detected = 0;
> +		dev_dbg(di->dev, "%s di->vbus_detected = false\n", __func__);
> +		di->vbus_detected = false;
>  		ab8500_charger_set_usb_connected(di, false);
>  		ab8500_power_supply_changed(di, &di->usb_chg.psy);
>  	} else {
> -		di->vbus_detected = 1;
> +		dev_dbg(di->dev, "%s di->vbus_detected = true\n", __func__);
> +		di->vbus_detected = true;
>  
>  		if (is_ab8500_1p1_or_earlier(di->parent)) {
>  			ret = ab8500_charger_detect_usb_type(di);
> @@ -1918,7 +2061,8 @@ static void ab8500_charger_detect_usb_type_work(struct work_struct *work)
>  							    &di->usb_chg.psy);
>  			}
>  		} else {
> -			/* For ABB cut2.0 and onwards we have an IRQ,
> +			/*
> +			 * For ABB cut2.0 and onwards we have an IRQ,

This change is correct, but it doesn't belong to this patch.

>  			 * USB_LINK_STATUS that will be triggered when the USB
>  			 * link status changes. The exception is USB connected
>  			 * during startup. Then we don't get a
> @@ -1939,7 +2083,7 @@ static void ab8500_charger_detect_usb_type_work(struct work_struct *work)
>  }
>  
>  /**
> - * ab8500_charger_usb_link_attach_work() - delayd work to detect USB type
> + * ab8500_charger_usb_link_attach_work() - work to detect USB type
>   * @work:	pointer to the work_struct structure
>   *
>   * Detect the type of USB plugged
> @@ -1979,10 +2123,10 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
>  
>  	/*
>  	 * Since we can't be sure that the events are received
> -	 * synchronously, we have the check if  is
> +	 * synchronously, we have the check if	is

cosmetic change, it's OK, but in separate patch.

>  	 * connected by reading the status register
>  	 */
> -	detected_chargers = ab8500_charger_detect_chargers(di);
> +	detected_chargers = ab8500_charger_detect_chargers(di, false);
>  	if (detected_chargers < 0)
>  		return;
>  
> @@ -2009,7 +2153,7 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
>  			abx500_mask_and_set_register_interruptible(di->dev,
>  						AB8500_CHARGER,
>  						AB8500_USBCH_CTRL1_REG,
> -						0x01, 0x01)
> +						0x01, 0x01);

Ouch. Was it compilable before this change? It's not bisectable.

>  			/*Enable charger detection*/
>  			abx500_mask_and_set_register_interruptible(di->dev,
>  						AB8500_USB,
> @@ -2042,32 +2186,46 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
>  	}
>  
>  	if (!(detected_chargers & USB_PW_CONN)) {
> -		di->vbus_detected = 0;
> +		di->vbus_detected = false;

Nope. Firstly, 0 is OK for bool. Secondly, even if you want to use
false instead of 0, this is cosmetic change, and should go separately.

>  		ab8500_charger_set_usb_connected(di, false);
>  		ab8500_power_supply_changed(di, &di->usb_chg.psy);
> -	} else {
> -		di->vbus_detected = 1;
> -		ret = ab8500_charger_read_usb_type(di);
> -		if (!ret) {
> -			if (di->usb_device_is_unrecognised) {
> -				dev_dbg(di->dev,
> -					"Potential Legacy Charger device. "
> -					"Delay work for %d msec for USB enum "
> -					"to finish",
> -					WAIT_FOR_USB_ENUMERATION);
> -				queue_delayed_work(di->charger_wq,
> -					&di->attach_work,
> -					msecs_to_jiffies
> -						(WAIT_FOR_USB_ENUMERATION));
> -			} else {
> -				queue_delayed_work(di->charger_wq,
> -							&di->attach_work, 0);
> -			}
> -		} else if (ret == -ENXIO) {
> +		return;
> +	}
> +
> +	dev_dbg(di->dev, "%s di->vbus_detected = true\n", __func__);
> +	di->vbus_detected = true;
> +	ret = ab8500_charger_read_usb_type(di);
> +	if (ret) {
> +		if (ret == -ENXIO) {
>  			/* No valid charger type detected */
>  			ab8500_charger_set_usb_connected(di, false);
>  			ab8500_power_supply_changed(di, &di->usb_chg.psy);
>  		}
> +		return;
> +	}
> +
> +	if (di->usb_device_is_unrecognised) {
> +		dev_dbg(di->dev,
> +			"Potential Legacy Charger device. "
> +			"Delay work for %d msec for USB enum "
> +			"to finish",
> +			WAIT_ACA_RID_ENUMERATION);
> +		queue_delayed_work(di->charger_wq,
> +			&di->attach_work,
> +			msecs_to_jiffies(WAIT_ACA_RID_ENUMERATION));
> +	} else if (di->is_aca_rid == 1) {
> +		/* Only wait once */
> +		di->is_aca_rid++;
> +		dev_dbg(di->dev,
> +			"%s Wait %d msec for USB enum to finish",

This can go into previous line.

> +			__func__, WAIT_ACA_RID_ENUMERATION);
> +		queue_delayed_work(di->charger_wq,
> +			&di->attach_work,

These two lines can be merged.

> +			msecs_to_jiffies(WAIT_ACA_RID_ENUMERATION));
> +	} else {
> +		queue_delayed_work(di->charger_wq,
> +			&di->attach_work,
> +			0);

This fits into one line.

>  	}
>  }
>  
> @@ -2077,24 +2235,20 @@ static void ab8500_charger_usb_state_changed_work(struct work_struct *work)
>  	unsigned long flags;
>  
>  	struct ab8500_charger *di = container_of(work,
> -		struct ab8500_charger, usb_state_changed_work);
> +		struct ab8500_charger, usb_state_changed_work.work);
>  
> -	if (!di->vbus_detected)
> +	if (!di->vbus_detected) {
> +		dev_dbg(di->dev,
> +			"%s !di->vbus_detected\n",
> +			__func__);

No wrapping necessary.

>  		return;
> +	}
>  
>  	spin_lock_irqsave(&di->usb_state.usb_lock, flags);
> -	di->usb_state.usb_changed = false;
> +	di->usb_state.state = di->usb_state.state_tmp;
> +	di->usb_state.usb_current = di->usb_state.usb_current_tmp;
>  	spin_unlock_irqrestore(&di->usb_state.usb_lock, flags);
>  
> -	/*
> -	 * wait for some time until you get updates from the usb stack
> -	 * and negotiations are completed
> -	 */
> -	msleep(250);
> -
> -	if (di->usb_state.usb_changed)
> -		return;
> -
>  	dev_dbg(di->dev, "%s USB state: 0x%02x mA: %d\n",
>  		__func__, di->usb_state.state, di->usb_state.usb_current);
>  
> @@ -2332,6 +2486,21 @@ static irqreturn_t ab8500_charger_mainchthprotf_handler(int irq, void *_di)
>  	return IRQ_HANDLED;
>  }
>  
> +static void ab8500_charger_vbus_drop_end_work(struct work_struct *work)
> +{
> +	struct ab8500_charger *di = container_of(work,
> +		struct ab8500_charger, vbus_drop_end_work.work);
> +
> +	di->flags.vbus_drop_end = false;
> +
> +	/* Reset the drop counter */
> +	abx500_set_register_interruptible(di->dev,
> +				AB8500_CHARGER, AB8500_CHARGER_CTRL, 0x01);
> +
> +	if (di->usb.charger_connected)
> +		ab8500_charger_set_vbus_in_curr(di, di->max_usb_in_curr);
> +}
> +
>  /**
>   * ab8500_charger_vbusdetf_handler() - VBUS falling detected
>   * @irq:       interrupt number
> @@ -2343,6 +2512,7 @@ static irqreturn_t ab8500_charger_vbusdetf_handler(int irq, void *_di)
>  {
>  	struct ab8500_charger *di = _di;
>  
> +	di->vbus_detected = false;
>  	dev_dbg(di->dev, "VBUS falling detected\n");
>  	queue_work(di->charger_wq, &di->detect_usb_type_work);
>  
> @@ -2470,6 +2640,25 @@ static irqreturn_t ab8500_charger_chwdexp_handler(int irq, void *_di)
>  }
>  
>  /**
> + * ab8500_charger_vbuschdropend_handler() - VBUS drop removed
> + * @irq:       interrupt number
> + * @_di:       pointer to the ab8500_charger structure
> + *
> + * Returns IRQ status(IRQ_HANDLED)
> + */
> +static irqreturn_t ab8500_charger_vbuschdropend_handler(int irq, void *_di)
> +{
> +	struct ab8500_charger *di = _di;
> +
> +	dev_dbg(di->dev, "VBUS charger drop ended\n");
> +	di->flags.vbus_drop_end = true;
> +	queue_delayed_work(di->charger_wq, &di->vbus_drop_end_work,
> +						round_jiffies(30 * HZ));
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/**
>   * ab8500_charger_vbusovv_handler() - VBUS overvoltage detected
>   * @irq:       interrupt number
>   * @_di:       pointer to the ab8500_charger structure
> @@ -2559,9 +2748,9 @@ static int ab8500_charger_ac_get_property(struct power_supply *psy,
>  
>  /**
>   * ab8500_charger_usb_get_property() - get the usb properties
> - * @psy:        pointer to the power_supply structure
> - * @psp:        pointer to the power_supply_property structure
> - * @val:        pointer to the power_supply_propval union
> + * @psy:	pointer to the power_supply structure
> + * @psp:	pointer to the power_supply_property structure
> + * @val:	pointer to the power_supply_propval union

Stray cosmetic changes, should go via a separate patch.

>   * This function gets called when an application tries to get the usb
>   * properties by reading the sysfs files.
> @@ -2739,6 +2928,12 @@ static int ab8500_charger_init_hw_registers(struct ab8500_charger *di)
>  		goto out;
>  	}
>  
> +	ret = ab8500_charger_led_en(di, false);
> +	if (ret < 0) {
> +		dev_err(di->dev, "failed to disable LED\n");
> +		goto out;
> +	}
> +
>  	/* Backup battery voltage and current */
>  	ret = abx500_set_register_interruptible(di->dev,
>  		AB8500_RTC,
> @@ -2778,6 +2973,7 @@ static struct ab8500_charger_interrupts ab8500_charger_irq[] = {
>  	{"USB_CHARGER_NOT_OKR", ab8500_charger_usbchargernotokr_handler},
>  	{"VBUS_OVV", ab8500_charger_vbusovv_handler},
>  	{"CH_WD_EXP", ab8500_charger_chwdexp_handler},
> +	{"VBUS_CH_DROP_END", ab8500_charger_vbuschdropend_handler},
>  };
>  
>  static int ab8500_charger_usb_notifier_call(struct notifier_block *nb,
> @@ -2814,13 +3010,15 @@ static int ab8500_charger_usb_notifier_call(struct notifier_block *nb,
>  		__func__, bm_usb_state, mA);
>  
>  	spin_lock(&di->usb_state.usb_lock);
> -	di->usb_state.usb_changed = true;
> +	di->usb_state.state_tmp = bm_usb_state;
> +	di->usb_state.usb_current_tmp = mA;
>  	spin_unlock(&di->usb_state.usb_lock);
>  
> -	di->usb_state.state = bm_usb_state;
> -	di->usb_state.usb_current = mA;
> -
> -	queue_work(di->charger_wq, &di->usb_state_changed_work);
> +	/*
> +	 * wait for some time until you get updates from the usb stack
> +	 * and negotiations are completed
> +	 */
> +	queue_delayed_work(di->charger_wq, &di->usb_state_changed_work, HZ/2);
>  
>  	return NOTIFY_OK;
>  }
> @@ -2860,6 +3058,9 @@ static int ab8500_charger_resume(struct platform_device *pdev)
>  			&di->check_hw_failure_work, 0);
>  	}
>  
> +	if (di->flags.vbus_drop_end)
> +		queue_delayed_work(di->charger_wq, &di->vbus_drop_end_work, 0);
> +
>  	return 0;
>  }
>  
> @@ -2872,6 +3073,9 @@ static int ab8500_charger_suspend(struct platform_device *pdev,
>  	if (delayed_work_pending(&di->check_hw_failure_work))
>  		cancel_delayed_work(&di->check_hw_failure_work);
>  
> +	if (delayed_work_pending(&di->vbus_drop_end_work))
> +		cancel_delayed_work(&di->vbus_drop_end_work);
> +
>  	flush_delayed_work_sync(&di->attach_work);
>  	flush_delayed_work_sync(&di->usb_charger_attached_work);
>  	flush_delayed_work_sync(&di->ac_charger_attached_work);
> @@ -2883,11 +3087,14 @@ static int ab8500_charger_suspend(struct platform_device *pdev,
>  	flush_work_sync(&di->ac_work);
>  	flush_work_sync(&di->detect_usb_type_work);
>  
> +	if (atomic_read(&di->current_stepping_sessions))
> +		return -EAGAIN;
> +
>  	return 0;
>  }
>  #else
> -#define ab8500_charger_suspend      NULL
> -#define ab8500_charger_resume       NULL
> +#define ab8500_charger_suspend	    NULL
> +#define ab8500_charger_resume	    NULL

Cosmetic, doesn't belong to this patch.
