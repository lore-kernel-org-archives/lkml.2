Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab2JaSi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:38:59 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:40697 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab2JaSi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:38:56 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjXBAHJvkVBV5h1yPGdsb2JhbABEilG4AgICgQEZAQEBAR8ZDSeCHgEBBAEnExwjBQsIAxEDAQIvFCUKDA4TiAAKu2kUi2QaIIENhBNhA5V1hXmDT4lrgWM
X-IronPort-AV: E=Sophos;i="4.80,688,1344204000"; 
   d="scan'208";a="436894542"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 31 Oct 2012 19:43:47 +0100
To: Alexandra Chin <alexandra.chin@tw.synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: Re: [PATCH] staging: ste_rmi4: Convert to Type-B support
Message-ID: <20121031184347.GA1530@polaris.bitmath.org>
References: <CC51EC7B5B7F984AA566DC102237848896F590C0@hkdcw-mail1.synaptics-inc.local>
 <20121003180121.GA4198@polaris.bitmath.org>
 <CC51EC7B5B7F984AA566DC102237848896F5F20B@hkdcw-mail1.synaptics-inc.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CC51EC7B5B7F984AA566DC102237848896F5F20B@hkdcw-mail1.synaptics-inc.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandra,

> From: Alexandra Chin <alexandra.chin@tw.synaptics.com>
> Date: Wed, 31 Oct 2012 16:21:12 +0800
> Subject: [PATCH] staging: ste_rmi4: Convert to Type-B support
> 
> This patch:
> - Convert to MT-B because Synaptics touch devices are capable of
>   tracking identifiable fingers
> - Modify maximum supported fingers up to 10
> - Set INPUT_PROP_POINTER for direct input devices

Thanks for the patch, looks good overall. Please find some comments
below. Also, the patch looks word-damaged, possibly mail client
problems.

> diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> index 11728a0..e69ca5ee1 100644
> --- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> +++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> @@ -31,6 +31,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/module.h>
> +#include <linux/input/mt.h>
>  #include "synaptics_i2c_rmi4.h"
>  
>  /* TODO: for multiple device support will need a per-device mutex */
> @@ -67,7 +68,7 @@
>  #define PDT_START_SCAN_LOCATION (0x00E9)
>  #define PDT_END_SCAN_LOCATION	(0x000A)
>  #define PDT_ENTRY_SIZE		(0x0006)
> -#define RMI4_NUMBER_OF_MAX_FINGERS		(8)
> +#define RMI4_NUMBER_OF_MAX_FINGERS		(10)

It seems this define can be dropped altogether.

>  #define SYNAPTICS_RMI4_TOUCHPAD_FUNC_NUM	(0x11)
>  #define SYNAPTICS_RMI4_DEVICE_CONTROL_FUNC_NUM	(0x01)
>  
> @@ -164,6 +165,8 @@ struct synaptics_rmi4_device_info {
>   * @regulator: pointer to the regulator structure
>   * @wait: wait queue structure variable
>   * @touch_stopped: flag to stop the thread function
> + * @finger_state: previous state of fingers
> + * @fingers_supported: maximum supported fingers
>   *
>   * This structure gives the device data information.
>   */
> @@ -184,6 +187,8 @@ struct synaptics_rmi4_data {
>  	struct regulator	*regulator;
>  	wait_queue_head_t	wait;
>  	bool			touch_stopped;
> +	unsigned char finger_state[RMI4_NUMBER_OF_MAX_FINGERS];

The finger state is not needed with MT-B.

> +	unsigned char fingers_supported;
>  };
>  
>  /**
> @@ -303,7 +308,6 @@ static int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
>  	/* number of touch points - fingers down in this case */
>  	int	touch_count = 0;
>  	int	finger;
> -	int	fingers_supported;
>  	int	finger_registers;
>  	int	reg;
>  	int	finger_shift;
> @@ -314,10 +318,8 @@ static int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
>  	unsigned char	data_reg_blk_size;
>  	unsigned char	values[2];
>  	unsigned char	data[DATA_LEN];
> -	int	x[RMI4_NUMBER_OF_MAX_FINGERS];
> -	int	y[RMI4_NUMBER_OF_MAX_FINGERS];
> -	int	wx[RMI4_NUMBER_OF_MAX_FINGERS];
> -	int	wy[RMI4_NUMBER_OF_MAX_FINGERS];
> +	int x, y;
> +	int wx, wy;
>  	struct	i2c_client *client = pdata->i2c_client;
>  
>  	/* get 2D sensor finger data */
> @@ -333,8 +335,7 @@ static int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
>  	 *	10 = finger present but data may not be accurate,
>  	 *	11 = reserved for product use.
>  	 */
> -	fingers_supported	= rfi->num_of_data_points;
> -	finger_registers	= (fingers_supported + 3)/4;
> +	finger_registers	= (pdata->fingers_supported + 3)/4;
>  	data_base_addr		= rfi->fn_desc.data_base_addr;
>  	retval = synaptics_rmi4_i2c_block_read(pdata, data_base_addr, values,
>  							finger_registers);
> @@ -348,17 +349,26 @@ static int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
>  	 * to get absolute data.
>  	 */
>  	data_reg_blk_size = rfi->size_of_data_register_block;
> -	for (finger = 0; finger < fingers_supported; finger++) {
> +	for (finger = 0; finger < pdata->fingers_supported; finger++) {
>  		/* determine which data byte the finger status is in */
>  		reg = finger/4;
>  		/* bit shift to get finger's status */
>  		finger_shift	= (finger % 4) * 2;
> -		finger_status	= (values[reg] >> finger_shift) & 3;
> +		finger_status	= (values[reg] >> finger_shift) & MASK_2BIT;
>  		/*
>  		 * if finger status indicates a finger is present then
>  		 * read the finger data and report it
>  		 */
> -		if (finger_status == 1 || finger_status == 2) {
> +		if (!finger_status && !pdata->finger_state[finger])
> +			continue;

This can be dropped - the input core will only emit changes anyways.

> +
> +		input_mt_slot(pdata->input_dev, finger);
> +		input_mt_report_slot_state(pdata->input_dev,
> +						MT_TOOL_FINGER, finger_status);
> +
> +		if (!finger_status && pdata->finger_state[finger]) {
> +			/* release event */
> +		} else {

A "if (finger_status) {" will do here.

>  			/* Read the finger data */
>  			data_offset = data_base_addr +
>  					((finger * data_reg_blk_size) +
> @@ -371,44 +381,30 @@ static int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
>  								__func__);
>  				return 0;
>  			} else {
> -				x[touch_count]	=
> -					(data[0] << 4) | (data[2] & MASK_4BIT);
> -				y[touch_count]	=
> -					(data[1] << 4) |
> -					((data[2] >> 4) & MASK_4BIT);
> -				wy[touch_count]	=
> -						(data[3] >> 4) & MASK_4BIT;
> -				wx[touch_count]	=
> -						(data[3] & MASK_4BIT);
> +				x = (data[0] << 4) | (data[2] & MASK_4BIT);
> +				y = (data[1] << 4)
> +						| ((data[2] >> 4) & MASK_4BIT);
> +				wy = (data[3] >> 4) & MASK_4BIT;
> +				wx = (data[3] & MASK_4BIT);
>  
>  				if (pdata->board->x_flip)
> -					x[touch_count] =
> -						pdata->sensor_max_x -
> -								x[touch_count];
> +					x = pdata->sensor_max_x - x;
>  				if (pdata->board->y_flip)
> -					y[touch_count] =
> -						pdata->sensor_max_y -
> -								y[touch_count];
> +					y = pdata->sensor_max_y - y;
>  			}
> +			input_report_abs(pdata->input_dev, ABS_MT_TOUCH_MAJOR,
> +								max(wx, wy));
> +			input_report_abs(pdata->input_dev,
> +							ABS_MT_POSITION_X, x);
> +			input_report_abs(pdata->input_dev,
> +							ABS_MT_POSITION_Y, y);
> +

A local variable for pdata->input_dev might clean up the wrapping here.

>  			/* number of active touch points */
>  			touch_count++;
>  		}
> +		pdata->finger_state[finger] = finger_status;

Not necessary.

>  	}
>  
> -	/* report to input subsystem */
> -	if (touch_count) {
> -		for (finger = 0; finger < touch_count; finger++) {
> -			input_report_abs(pdata->input_dev, ABS_MT_TOUCH_MAJOR,
> -						max(wx[finger] , wy[finger]));
> -			input_report_abs(pdata->input_dev, ABS_MT_POSITION_X,
> -								x[finger]);
> -			input_report_abs(pdata->input_dev, ABS_MT_POSITION_Y,
> -								y[finger]);
> -			input_mt_sync(pdata->input_dev);
> -		}
> -	} else
> -		input_mt_sync(pdata->input_dev);
> -
>  	/* sync after groups of events */
>  	input_sync(pdata->input_dev);
>  	/* return the number of touch points */
> @@ -575,6 +571,7 @@ static int synpatics_rmi4_touchpad_detect(struct synaptics_rmi4_data *pdata,
>  		if ((queries[1] & MASK_3BIT) == 5)
>  			rfi->num_of_data_points = 10;
>  	}
> +	pdata->fingers_supported = rfi->num_of_data_points;
>  	/* Need to get interrupt info for handling interrupts */
>  	rfi->index_to_intr_reg = (interruptcount + 7)/8;
>  	if (rfi->index_to_intr_reg != 0)
> @@ -981,13 +978,16 @@ static int __devinit synaptics_rmi4_probe
>  	set_bit(EV_SYN, rmi4_data->input_dev->evbit);
>  	set_bit(EV_KEY, rmi4_data->input_dev->evbit);
>  	set_bit(EV_ABS, rmi4_data->input_dev->evbit);
> -
> +#ifdef INPUT_PROP_DIRECT
> +	set_bit(INPUT_PROP_DIRECT, rmi4_data->input_dev->propbit);
> +#endif
>  	input_set_abs_params(rmi4_data->input_dev, ABS_MT_POSITION_X, 0,
>  					rmi4_data->sensor_max_x, 0, 0);
>  	input_set_abs_params(rmi4_data->input_dev, ABS_MT_POSITION_Y, 0,
>  					rmi4_data->sensor_max_y, 0, 0);
>  	input_set_abs_params(rmi4_data->input_dev, ABS_MT_TOUCH_MAJOR, 0,
>  						MAX_TOUCH_MAJOR, 0, 0);
> +	input_mt_init_slots(rmi4_data->input_dev, rmi4_data->fingers_supported);

Looks like your patch is against a slightly old kernel version;
Please send patches against 3.7-rcX.

>  
>  	/* Clear interrupts */
>  	synaptics_rmi4_i2c_block_read(rmi4_data,
> -- 
> 1.7.5.4
> 

Thanks!
Henrik
