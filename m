Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab1HLVIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 17:08:15 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:40147 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1HLVIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 17:08:13 -0400
X-SENDER-IP: [85.230.168.63]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmpnAJKVRU5V5qg/PGdsb2JhbABBiQ+eaQsBAQEBNzKBQAEBBScTHCMQCAMOOBQlChqIBLtADoVaXwSYKotZ
X-IronPort-AV: E=Sophos;i="4.67,364,1309730400"; 
   d="scan'208";a="1752965761"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 12 Aug 2011 23:09:12 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: chase.douglas@canonical.com, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com
Subject: Re: [PATCH 4/8 v3] Input: synaptics - add image sensor support
Message-ID: <20110812210911.GA9124@polaris.bitmath.org>
References: <1313169407-4358-1-git-send-email-djkurtz@chromium.org>
 <1313169407-4358-5-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313169407-4358-5-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

looks good, some details below.

> +static void synaptics_report_slot_empty(struct input_dev *dev, int slot)
> +{
> +	input_mt_slot(dev, slot);
> +	input_mt_report_slot_state(dev, MT_TOOL_FINGER, false);
> +}
> +
> +static void synaptics_report_slot_sgm(struct input_dev *dev, int slot,
> +				      const struct synaptics_hw_state *sgm)
> +{
> +	input_mt_slot(dev, slot);
> +	input_mt_report_slot_state(dev, MT_TOOL_FINGER, true);
> +	input_report_abs(dev, ABS_MT_POSITION_X, sgm->x);
> +	input_report_abs(dev, ABS_MT_POSITION_Y, invert_y(sgm->y));
> +	input_report_abs(dev, ABS_MT_PRESSURE, sgm->z);
> +	/* SGM can sometimes contain valid width */
> +	if (sgm->w >= 4)
> +		input_report_abs(dev, ABS_MT_TOUCH_MAJOR, sgm->w);
> +}

The ABS_MT_TOUCH_MAJOR is supposed to have zero intercept, to remain
compatible with user space handling of type A devices. Also, the scale
should match the screen/pad size, such that the actual size of the
touch area can be deduced. In addition, based on the current sensor
technologies, ABS_MT_PRESSURE and ABS_MT_TOUCH_MAJOR are normally
mutually exclusive.

All in all, I would prefer to only report width via (the single-finger
axis) ABS_TOOL_WIDTH, and only for compatibility reasons.

> +
> +static void synaptics_report_slot_agm(struct input_dev *dev, int slot,
> +				      const struct synaptics_hw_state *agm)
> +{
> +	input_mt_slot(dev, slot);
> +	input_mt_report_slot_state(dev, MT_TOOL_FINGER, true);
> +	input_report_abs(dev, ABS_MT_POSITION_X, agm->x);
> +	input_report_abs(dev, ABS_MT_POSITION_Y, invert_y(agm->y));
> +	input_report_abs(dev, ABS_MT_PRESSURE, agm->z);
> +}

With ABS_MT_TOUCH_MAJOR dropped, sgm and agm seems to coincide...

> +
> +static void synaptics_report_mt(struct psmouse *psmouse,
> +				int count,
> +				const struct synaptics_hw_state *sgm)
> +{
> +	struct input_dev *dev = psmouse->dev;
> +	struct synaptics_data *priv = psmouse->private;
> +	struct synaptics_hw_state *agm = &priv->agm;
> +
> +	switch (count) {
> +	case 0:
> +		synaptics_report_slot_empty(dev, 0);
> +		synaptics_report_slot_empty(dev, 1);
> +		break;
> +	case 1:
> +		synaptics_report_slot_sgm(dev, 0, sgm);
> +		synaptics_report_slot_empty(dev, 1);
> +		break;
> +	case 2:
> +	case 3: /* Fall-through case */
> +		synaptics_report_slot_sgm(dev, 0, sgm);
> +		synaptics_report_slot_agm(dev, 1, agm);
> +		break;
> +	}
> +
> +	/* Don't use active slot count to generate BTN_TOOL events. */
> +	input_mt_report_pointer_emulation(dev, false);
> +
> +	/* Send the number of fingers reported by touchpad itself. */
> +	input_mt_report_finger_count(dev, count);
> +
> +	input_report_key(dev, BTN_LEFT, sgm->left);
> +	input_sync(dev);
> +}
> +
> +static void synaptics_image_sensor_process(struct psmouse *psmouse,
> +					   struct synaptics_hw_state *sgm)
> +{
> +	int count;
> +
> +	if (sgm->z == 0)
> +		count = 0;
> +	else if (sgm->w >= 4)
> +		count = 1;
> +	else if (sgm->w == 0)
> +		count = 2;
> +	else
> +		count = 3;
> +
> +	/* Send resulting input events to user space */
> +	synaptics_report_mt(psmouse, count, sgm);
> +}
> +
>  /*
>   *  called for each full received packet from the touchpad
>   */
> @@ -558,6 +642,11 @@ static void synaptics_process_packet(struct psmouse *psmouse)
>  	if (synaptics_parse_hw_state(psmouse->packet, priv, &hw))
>  		return;
>  
> +	if (SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) {
> +		synaptics_image_sensor_process(psmouse, &hw);
> +		return;
> +	}
> +
>  	if (hw.scroll) {
>  		priv->scroll += hw.scroll;
>  
> @@ -739,7 +828,16 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
>  	set_abs_position_params(dev, priv, ABS_X, ABS_Y);
>  	input_set_abs_params(dev, ABS_PRESSURE, 0, 255, 0, 0);
>  
> -	if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)) {
> +	if (SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) {
> +		input_mt_init_slots(dev, 2);
> +		set_abs_position_params(dev, priv, ABS_MT_POSITION_X,
> +					ABS_MT_POSITION_Y);
> +		/* Image sensors can report per-contact pressure */
> +		input_set_abs_params(dev, ABS_MT_PRESSURE, 0, 255, 0, 0);
> +		/* Image sensors can sometimes report per-contact width */
> +		input_set_abs_params(dev, ABS_MT_TOUCH_MAJOR, 4, 15, 0, 0);
> +	} else if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c)) {
> +		/* Non-image sensors with AGM use semi-mt */
>  		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
>  		input_mt_init_slots(dev, 2);
>  		set_abs_position_params(dev, priv, ABS_MT_POSITION_X,
> diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
> index a9efbf3..0ea7616 100644
> --- a/drivers/input/mouse/synaptics.h
> +++ b/drivers/input/mouse/synaptics.h
> @@ -74,6 +74,8 @@
>   * 2	0x04	reduced filtering	firmware does less filtering on
>   *					position data, driver should watch
>   *					for noise.
> + * 2	0x08	image sensor		image sensor tracks 5 fingers, but only
> + *					reports 2.
>   * 2	0x20	report min		query 0x0f gives min coord reported
>   */
>  #define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100000) /* 1-button ClickPad */
> @@ -82,6 +84,7 @@
>  #define SYN_CAP_MIN_DIMENSIONS(ex0c)	((ex0c) & 0x002000)
>  #define SYN_CAP_ADV_GESTURE(ex0c)	((ex0c) & 0x080000)
>  #define SYN_CAP_REDUCED_FILTERING(ex0c)	((ex0c) & 0x000400)
> +#define SYN_CAP_IMAGE_SENSOR(ex0c)	((ex0c) & 0x000800)
>  
>  /* synaptics modes query bits */
>  #define SYN_MODE_ABSOLUTE(m)		((m) & (1 << 7))
> -- 
> 1.7.3.1
> 

Looks good otherwise.

Thanks,
Henrik
