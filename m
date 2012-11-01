Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986Ab2KAU5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:57:47 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:43550 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab2KAU5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:57:45 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkezAMfhklBV5h1yPGdsb2JhbABEhS6FI7ddAgKBBBkBAQEBHxkNJ4IeAQEEAScTHCMFCwgDEQMBAi8UJQoMDhOIAAq9FhSLZzqBDYQTYQOVd4V6g0+Jaw
X-IronPort-AV: E=Sophos;i="4.80,695,1344204000"; 
   d="scan'208";a="441533279"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 1 Nov 2012 22:02:44 +0100
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
Subject: Re: [PATCH v2] staging: ste_rmi4: Convert to Type-B support
Message-ID: <20121101210244.GA598@polaris.bitmath.org>
References: <CC51EC7B5B7F984AA566DC102237848896F5F3F7@hkdcw-mail1.synaptics-inc.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CC51EC7B5B7F984AA566DC102237848896F5F3F7@hkdcw-mail1.synaptics-inc.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandra,

> From 783c14e5978600cc78e11ea078cc413d77a9debd Mon Sep 17 00:00:00 2001
> From: Alexandra Chin <alexandra.chin@tw.synaptics.com>
> Date: Thu, 1 Nov 2012 17:02:14 +0800
> Subject: [PATCH v2] staging: ste_rmi4: Convert to Type-B support
> 
> This patch:
> - convert to MT-B because Synaptics touch devices are capable of
>   tracking identifiable fingers
>   -- driver straightly reports all fingers' status
> - call input_mt_init_slots with INPUT_MT_DIRECT flag
> - against v3.7-rc3 kernel
> 
> Any comments please let me know. Thank you.

Thanks for the updates. The patch is still corrupted, containing odd
formatting characters. Also, for all patches, please keep the original
commit message in this space, and add any comments and change listings
between the '---' and the actual diff below. That way, when applied,
only the intended commit message will appear in the log.

> diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> index 277491a..0338b1e 100644
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
> @@ -67,7 +68,6 @@
>  #define PDT_START_SCAN_LOCATION (0x00E9)
>  #define PDT_END_SCAN_LOCATION	(0x000A)
>  #define PDT_ENTRY_SIZE		(0x0006)
> -#define RMI4_NUMBER_OF_MAX_FINGERS		(8)
>  #define SYNAPTICS_RMI4_TOUCHPAD_FUNC_NUM	(0x11)
>  #define SYNAPTICS_RMI4_DEVICE_CONTROL_FUNC_NUM	(0x01)
>  
> @@ -164,6 +164,7 @@ struct synaptics_rmi4_device_info {
>   * @regulator: pointer to the regulator structure
>   * @wait: wait queue structure variable
>   * @touch_stopped: flag to stop the thread function
> + * @fingers_supported: maximum supported fingers
>   *
>   * This structure gives the device data information.
>   */
> @@ -184,6 +185,7 @@ struct synaptics_rmi4_data {
>  	struct regulator	*regulator;
>  	wait_queue_head_t	wait;
>  	bool			touch_stopped;
> +	unsigned char		fingers_supported;
>  };
>  
>  /**
> @@ -303,22 +305,21 @@ static int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
>  	/* number of touch points - fingers down in this case */
>  	int	touch_count = 0;
>  	int	finger;
> -	int	fingers_supported;
>  	int	finger_registers;
>  	int	reg;
>  	int	finger_shift;
>  	int	finger_status;
>  	int	retval;
> +	int	x, y;
> +	int	wx, wy;
>  	unsigned short	data_base_addr;
>  	unsigned short	data_offset;
>  	unsigned char	data_reg_blk_size;
>  	unsigned char	values[2];
>  	unsigned char	data[DATA_LEN];
> -	int	x[RMI4_NUMBER_OF_MAX_FINGERS];
> -	int	y[RMI4_NUMBER_OF_MAX_FINGERS];
> -	int	wx[RMI4_NUMBER_OF_MAX_FINGERS];
> -	int	wy[RMI4_NUMBER_OF_MAX_FINGERS];
> +	unsigned char	fingers_supported = pdata->fingers_supported;
>  	struct	i2c_client *client = pdata->i2c_client;
> +	struct	input_dev *input_dev = pdata->input_dev;
>  
>  	/* get 2D sensor finger data */
>  	/*
> @@ -333,7 +334,6 @@ static int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
>  	 *	10 = finger present but data may not be accurate,
>  	 *	11 = reserved for product use.
>  	 */
> -	fingers_supported	= rfi->num_of_data_points;
>  	finger_registers	= (fingers_supported + 3)/4;
>  	data_base_addr		= rfi->fn_desc.data_base_addr;
>  	retval = synaptics_rmi4_i2c_block_read(pdata, data_base_addr, values,
> @@ -353,12 +353,16 @@ static int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
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
> +		input_mt_slot(input_dev, finger);
> +		input_mt_report_slot_state(input_dev, MT_TOOL_FINGER,
> +							finger_status != 0);
> +
> +		if (finger_status) {
>  			/* Read the finger data */
>  			data_offset = data_base_addr +
>  					((finger * data_reg_blk_size) +
> @@ -371,46 +375,29 @@ static int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
>  								__func__);
>  				return 0;
>  			} else {

It is customary to not use 'else' after an error path return. Also
saves your one level of indentation.

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
> +			input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR,
> +								max(wx, wy));
> +			input_report_abs(input_dev, ABS_MT_POSITION_X, x);
> +			input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
> +
>  			/* number of active touch points */
>  			touch_count++;
>  		}
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

To get the "usual" BTN_TOUCH and other pointer emulation effects, you
probably want to add input_mt_sync_frame() here.

> -	input_sync(pdata->input_dev);
> +	input_sync(input_dev);
>  	/* return the number of touch points */
>  	return touch_count;
>  }
> @@ -575,6 +562,7 @@ static int synpatics_rmi4_touchpad_detect(struct synaptics_rmi4_data *pdata,
>  		if ((queries[1] & MASK_3BIT) == 5)
>  			rfi->num_of_data_points = 10;
>  	}
> +	pdata->fingers_supported = rfi->num_of_data_points;
>  	/* Need to get interrupt info for handling interrupts */
>  	rfi->index_to_intr_reg = (interruptcount + 7)/8;
>  	if (rfi->index_to_intr_reg != 0)
> @@ -988,6 +976,8 @@ static int __devinit synaptics_rmi4_probe
>  					rmi4_data->sensor_max_y, 0, 0);
>  	input_set_abs_params(rmi4_data->input_dev, ABS_MT_TOUCH_MAJOR, 0,
>  						MAX_TOUCH_MAJOR, 0, 0);
> +	input_mt_init_slots(rmi4_data->input_dev,
> +				rmi4_data->fingers_supported, INPUT_MT_DIRECT);

Is this for a touchpad (INPUT_MT_POINTER) or touchscreen (INPUT_MT_DIRECT)?

>  
>  	/* Clear interrupts */
>  	synaptics_rmi4_i2c_block_read(rmi4_data,
> -- 
> 1.7.5.4

Thanks,
Henrik
