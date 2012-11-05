Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab2KEGCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 01:02:07 -0500
Received: from tw-mx2.synaptics.com.tw ([203.163.83.68]:49042 "EHLO
	tw-mx2.synaptics.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab2KEGCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 01:02:04 -0500
From: Alexandra Chin <alexandra.chin@tw.synaptics.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: RE: [PATCH v3] staging: ste_rmi4: Convert to Type-B support
Thread-Topic: [PATCH v3] staging: ste_rmi4: Convert to Type-B support
Thread-Index: AQHNutYcuwEJvMgSyU2cH1aXlQU3sZfaubHw
Date: Mon, 5 Nov 2012 06:01:50 +0000
Message-ID: <CC51EC7B5B7F984AA566DC102237848896F5FA62@hkdcw-mail1.synaptics-inc.local>
References: <20121103013623.0f3a1b28168a9a42881b0b00@tw.synaptics.com>
 <20121104215335.GA1060@polaris.bitmath.org>
In-Reply-To: <20121104215335.GA1060@polaris.bitmath.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-HK
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.51.94]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

> > This patch converts to MT-B because Synaptics touch devices are
> > capable of tracking identifiable fingers
> >
> > This patch was tested on pandaboard, except input_mt_sync_frame(),
> > which is a quite new function.
> 
> I am not sure how to interpret this. Is the patch untested, or tested
> on something different from a pandaboard?

My validation platform is pandaboard. However kernel running on pandaboard
Have not been updated to 3.7, therefore kernel does not contain function
input_mt_sync_frame(). When I tested my patch on pandaboard, I modified
the patch to call function input_mt_report_pointer_emulation(), instead of
calling function input_mt_sync_frame(). I think calling 
input_mt_report_pointer_emulation() or input_mt_sync_frame()
should have the same results.
Please let me know if my understanding is incorrect.

> > I changed to use sylpheed as my mail client. Please let me know
> > if there is any problem.
> > Greatly appreciate your time.
> 
> As mentioned, the commit message of the patch should not contain mail
> conversation.

Oh, I see! I should move conversation message to the outside of the patch 
content. Thanks for your reminder.

> >  drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c |  122
> ++++++++++++-------------
> >  1 files changed, 57 insertions(+), 65 deletions(-)
> >
> > diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> > index 277491a..7876f6b 100644
> > --- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> > +++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> > @@ -1,7 +1,7 @@
> >  /**
> >   *
> > - * Synaptics Register Mapped Interface (RMI4) I2C Physical Layer Driver.
> > - * Copyright (c) 2007-2010, Synaptics Incorporated
> > + * Synaptics Register Mapped Interface (RMI4) I2C Touchscreen Driver.
> > + * Copyright (c) 2007-2012, Synaptics Incorporated
> >   *
> >   * Author: Js HA <js.ha@stericsson.com> for ST-Ericsson
> >   * Author: Naveen Kumar G <naveen.gaddipati@stericsson.com> for
> ST-Ericsson
> > @@ -31,6 +31,7 @@
> >  #include <linux/interrupt.h>
> >  #include <linux/regulator/consumer.h>
> >  #include <linux/module.h>
> > +#include <linux/input/mt.h>
> >  #include "synaptics_i2c_rmi4.h"
> >
> >  /* TODO: for multiple device support will need a per-device mutex */
> > @@ -63,12 +64,11 @@
> >  #define MASK_4BIT		0x0F
> >  #define MASK_3BIT		0x07
> >  #define MASK_2BIT		0x03
> > -#define TOUCHPAD_CTRL_INTR	0x8
> > +#define TOUCHSCREEN_CTRL_INTR	0x8
> >  #define PDT_START_SCAN_LOCATION (0x00E9)
> >  #define PDT_END_SCAN_LOCATION	(0x000A)
> >  #define PDT_ENTRY_SIZE		(0x0006)
> > -#define RMI4_NUMBER_OF_MAX_FINGERS		(8)
> > -#define SYNAPTICS_RMI4_TOUCHPAD_FUNC_NUM	(0x11)
> > +#define SYNAPTICS_RMI4_TOUCHSCREEN_FUNC_NUM	(0x11)
> >  #define SYNAPTICS_RMI4_DEVICE_CONTROL_FUNC_NUM	(0x01)
> >
> >  /**
> > @@ -164,6 +164,7 @@ struct synaptics_rmi4_device_info {
> >   * @regulator: pointer to the regulator structure
> >   * @wait: wait queue structure variable
> >   * @touch_stopped: flag to stop the thread function
> > + * @fingers_supported: maximum supported fingers
> >   *
> >   * This structure gives the device data information.
> >   */
> > @@ -184,6 +185,7 @@ struct synaptics_rmi4_data {
> >  	struct regulator	*regulator;
> >  	wait_queue_head_t	wait;
> >  	bool			touch_stopped;
> > +	unsigned char		fingers_supported;
> >  };
> >
> >  /**
> > @@ -291,34 +293,33 @@ exit:
> >  }
> >
> >  /**
> > - * synpatics_rmi4_touchpad_report() - reports for the rmi4 touchpad device
> > + * synpatics_rmi4_touchscreen_report() - reports for the rmi4 touchscreen
> device
> >   * @pdata: pointer to synaptics_rmi4_data structure
> >   * @rfi: pointer to synaptics_rmi4_fn structure
> >   *
> > - * This function calls to reports for the rmi4 touchpad device
> > + * This function calls to reports for the rmi4 touchscreen device
> >   */
> > -static int synpatics_rmi4_touchpad_report(struct synaptics_rmi4_data *pdata,
> > +static int synpatics_rmi4_touchscreen_report(struct synaptics_rmi4_data
> *pdata,
> >  						struct synaptics_rmi4_fn *rfi)
> >  {
> >  	/* number of touch points - fingers down in this case */
> >  	int	touch_count = 0;
> >  	int	finger;
> > -	int	fingers_supported;
> >  	int	finger_registers;
> >  	int	reg;
> >  	int	finger_shift;
> >  	int	finger_status;
> >  	int	retval;
> > +	int	x, y;
> > +	int	wx, wy;
> >  	unsigned short	data_base_addr;
> >  	unsigned short	data_offset;
> >  	unsigned char	data_reg_blk_size;
> >  	unsigned char	values[2];
> >  	unsigned char	data[DATA_LEN];
> > -	int	x[RMI4_NUMBER_OF_MAX_FINGERS];
> > -	int	y[RMI4_NUMBER_OF_MAX_FINGERS];
> > -	int	wx[RMI4_NUMBER_OF_MAX_FINGERS];
> > -	int	wy[RMI4_NUMBER_OF_MAX_FINGERS];
> > +	unsigned char	fingers_supported = pdata->fingers_supported;
> >  	struct	i2c_client *client = pdata->i2c_client;
> > +	struct	input_dev *input_dev = pdata->input_dev;
> 
> The patch is definitely an improvement over the existing code, but I
> would very much recommend a follow-up patch which splits this
> function.
> 

I agree.

> >
> >  	/* get 2D sensor finger data */
> >  	/*
> > @@ -333,7 +334,6 @@ static int synpatics_rmi4_touchpad_report(struct
> synaptics_rmi4_data *pdata,
> >  	 *	10 = finger present but data may not be accurate,
> >  	 *	11 = reserved for product use.
> >  	 */
> > -	fingers_supported	= rfi->num_of_data_points;
> >  	finger_registers	= (fingers_supported + 3)/4;
> >  	data_base_addr		= rfi->fn_desc.data_base_addr;
> >  	retval = synaptics_rmi4_i2c_block_read(pdata, data_base_addr, values,
> > @@ -353,12 +353,16 @@ static int synpatics_rmi4_touchpad_report(struct
> synaptics_rmi4_data *pdata,
> >  		reg = finger/4;
> >  		/* bit shift to get finger's status */
> >  		finger_shift	= (finger % 4) * 2;
> > -		finger_status	= (values[reg] >> finger_shift) & 3;
> > +		finger_status	= (values[reg] >> finger_shift) & MASK_2BIT;
> >  		/*
> >  		 * if finger status indicates a finger is present then
> >  		 * read the finger data and report it
> >  		 */
> > -		if (finger_status == 1 || finger_status == 2) {
> > +		input_mt_slot(input_dev, finger);
> > +		input_mt_report_slot_state(input_dev, MT_TOOL_FINGER,
> > +							finger_status != 0);
> > +
> > +		if (finger_status) {
> >  			/* Read the finger data */
> >  			data_offset = data_base_addr +
> >  					((finger * data_reg_blk_size) +
> > @@ -367,50 +371,33 @@ static int synpatics_rmi4_touchpad_report(struct
> synaptics_rmi4_data *pdata,
> >  						data_offset, data,
> >  						data_reg_blk_size);
> >  			if (retval != data_reg_blk_size) {
> > -				printk(KERN_ERR "%s:read data failed\n",
> > +				dev_err(&client->dev, "%s:read data failed\n",
> >  								__func__);
> >  				return 0;
> > -			} else {
> > -				x[touch_count]	=
> > -					(data[0] << 4) | (data[2] & MASK_4BIT);
> > -				y[touch_count]	=
> > -					(data[1] << 4) |
> > -					((data[2] >> 4) & MASK_4BIT);
> > -				wy[touch_count]	=
> > -						(data[3] >> 4) & MASK_4BIT;
> > -				wx[touch_count]	=
> > -						(data[3] & MASK_4BIT);
> > -
> > -				if (pdata->board->x_flip)
> > -					x[touch_count] =
> > -						pdata->sensor_max_x -
> > -								x[touch_count];
> > -				if (pdata->board->y_flip)
> > -					y[touch_count] =
> > -						pdata->sensor_max_y -
> > -								y[touch_count];
> >  			}
> > +			x = (data[0] << 4) | (data[2] & MASK_4BIT);
> > +			y = (data[1] << 4) | ((data[2] >> 4) & MASK_4BIT);
> > +			wy = (data[3] >> 4) & MASK_4BIT;
> > +			wx = (data[3] & MASK_4BIT);
> > +
> > +			if (pdata->board->x_flip)
> > +				x = pdata->sensor_max_x - x;
> > +			if (pdata->board->y_flip)
> > +				y = pdata->sensor_max_y - y;
> > +
> > +			input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR,
> > +								max(wx, wy));
> > +			input_report_abs(input_dev, ABS_MT_POSITION_X, x);
> > +			input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
> > +
> >  			/* number of active touch points */
> >  			touch_count++;
> >  		}
> >  	}
> >
> > -	/* report to input subsystem */
> > -	if (touch_count) {
> > -		for (finger = 0; finger < touch_count; finger++) {
> > -			input_report_abs(pdata->input_dev, ABS_MT_TOUCH_MAJOR,
> > -						max(wx[finger] , wy[finger]));
> > -			input_report_abs(pdata->input_dev, ABS_MT_POSITION_X,
> > -								x[finger]);
> > -			input_report_abs(pdata->input_dev, ABS_MT_POSITION_Y,
> > -								y[finger]);
> > -			input_mt_sync(pdata->input_dev);
> > -		}
> > -	} else
> > -		input_mt_sync(pdata->input_dev);
> > -
> >  	/* sync after groups of events */
> > -	input_sync(pdata->input_dev);
> > +	input_mt_sync_frame(input_dev);
> > +	input_sync(input_dev);
> >  	/* return the number of touch points */
> >  	return touch_count;
> >  }
> > @@ -428,13 +415,13 @@ static int synaptics_rmi4_report_device(struct
> synaptics_rmi4_data *pdata,
> >  	int touch = 0;
> >  	struct	i2c_client *client = pdata->i2c_client;
> >  	static int num_error_reports;
> > -	if (rfi->fn_number != SYNAPTICS_RMI4_TOUCHPAD_FUNC_NUM) {
> > +	if (rfi->fn_number != SYNAPTICS_RMI4_TOUCHSCREEN_FUNC_NUM) {
> >  		num_error_reports++;
> >  		if (num_error_reports < MAX_ERROR_REPORT)
> >  			dev_err(&client->dev, "%s:report not supported\n",
> >  								__func__);
> >  	} else
> > -		touch = synpatics_rmi4_touchpad_report(pdata, rfi);
> > +		touch = synpatics_rmi4_touchscreen_report(pdata, rfi);
> >  	return touch;
> >  }
> >  /**
> > @@ -510,15 +497,15 @@ static irqreturn_t synaptics_rmi4_irq(int irq, void
> *data)
> >  }
> >
> >  /**
> > - * synpatics_rmi4_touchpad_detect() - detects the rmi4 touchpad device
> > + * synpatics_rmi4_touchscreen_detect() - detects the rmi4 touchscreen device
> >   * @pdata: pointer to synaptics_rmi4_data structure
> >   * @rfi: pointer to synaptics_rmi4_fn structure
> >   * @fd: pointer to synaptics_rmi4_fn_desc structure
> >   * @interruptcount: count the number of interrupts
> >   *
> > - * This function calls to detects the rmi4 touchpad device
> > + * This function calls to detects the rmi4 touchscreen device
> >   */
> > -static int synpatics_rmi4_touchpad_detect(struct synaptics_rmi4_data *pdata,
> > +static int synpatics_rmi4_touchscreen_detect(struct synaptics_rmi4_data
> *pdata,
> >  					struct synaptics_rmi4_fn *rfi,
> >  					struct synaptics_rmi4_fn_desc *fd,
> >  					unsigned int interruptcount)
> > @@ -575,6 +562,7 @@ static int synpatics_rmi4_touchpad_detect(struct
> synaptics_rmi4_data *pdata,
> >  		if ((queries[1] & MASK_3BIT) == 5)
> >  			rfi->num_of_data_points = 10;
> >  	}
> > +	pdata->fingers_supported = rfi->num_of_data_points;
> >  	/* Need to get interrupt info for handling interrupts */
> >  	rfi->index_to_intr_reg = (interruptcount + 7)/8;
> >  	if (rfi->index_to_intr_reg != 0)
> > @@ -655,13 +643,13 @@ static int synpatics_rmi4_touchpad_detect(struct
> synaptics_rmi4_data *pdata,
> >  }
> >
> >  /**
> > - * synaptics_rmi4_touchpad_config() - configures the rmi4 touchpad device
> > + * synaptics_rmi4_touchscreen_config() - configures the rmi4 touchscreen
> device
> >   * @pdata: pointer to synaptics_rmi4_data structure
> >   * @rfi: pointer to synaptics_rmi4_fn structure
> >   *
> > - * This function calls to configures the rmi4 touchpad device
> > + * This function calls to configures the rmi4 touchscreen device
> >   */
> > -int synaptics_rmi4_touchpad_config(struct synaptics_rmi4_data *pdata,
> > +int synaptics_rmi4_touchscreen_config(struct synaptics_rmi4_data *pdata,
> >  						struct synaptics_rmi4_fn *rfi)
> >  {
> >  	/*
> > @@ -751,7 +739,7 @@ static int synaptics_rmi4_i2c_query_device(struct
> synaptics_rmi4_data *pdata)
> >  				pdata->fn01_data_base_addr =
> >  						rmi_fd.data_base_addr;
> >  				break;
> > -			case SYNAPTICS_RMI4_TOUCHPAD_FUNC_NUM:
> > +			case SYNAPTICS_RMI4_TOUCHSCREEN_FUNC_NUM:
> >  				if (rmi_fd.intr_src_count) {
> >  					rfi = kmalloc(sizeof(*rfi),
> >  								GFP_KERNEL);
> > @@ -761,7 +749,8 @@ static int synaptics_rmi4_i2c_query_device(struct
> synaptics_rmi4_data *pdata)
> >  								__func__);
> >  							return -ENOMEM;
> >  					}
> > -					retval = synpatics_rmi4_touchpad_detect
> > +					retval =
> > +					synpatics_rmi4_touchscreen_detect
> >  								(pdata,	rfi,
> >  								&rmi_fd,
> >  								intr_count);
> 
> Odd line break is a clear sign that something could be broken out into its own
> function.
> 

I totally agree with you.

> > @@ -854,8 +843,9 @@ static int synaptics_rmi4_i2c_query_device(struct
> synaptics_rmi4_data *pdata)
> >  		list_for_each_entry(rfi, &rmi->support_fn_list, link) {
> >  			if (rfi->num_of_data_sources) {
> >  				if (rfi->fn_number ==
> > -					SYNAPTICS_RMI4_TOUCHPAD_FUNC_NUM) {
> > -					retval = synaptics_rmi4_touchpad_config
> > +					SYNAPTICS_RMI4_TOUCHSCREEN_FUNC_NUM) {
> > +					retval =
> > +					synaptics_rmi4_touchscreen_config
> >  								(pdata, rfi);
> >  					if (retval < 0)
> >  						return retval;
> 
> Same here.
> 
> > @@ -988,6 +978,8 @@ static int __devinit synaptics_rmi4_probe
> >  					rmi4_data->sensor_max_y, 0, 0);
> >  	input_set_abs_params(rmi4_data->input_dev, ABS_MT_TOUCH_MAJOR, 0,
> >  						MAX_TOUCH_MAJOR, 0, 0);
> > +	input_mt_init_slots(rmi4_data->input_dev,
> > +				rmi4_data->fingers_supported, INPUT_MT_DIRECT);
> >
> >  	/* Clear interrupts */
> >  	synaptics_rmi4_i2c_block_read(rmi4_data,
> > @@ -1076,7 +1068,7 @@ static int synaptics_rmi4_suspend(struct device *dev)
> >
> >  	retval = synaptics_rmi4_i2c_byte_write(rmi4_data,
> >  					rmi4_data->fn01_ctrl_base_addr + 1,
> > -					(intr_status & ~TOUCHPAD_CTRL_INTR));
> > +					(intr_status & ~TOUCHSCREEN_CTRL_INTR));
> >  	if (retval < 0)
> >  		return retval;
> >
> > @@ -1112,7 +1104,7 @@ static int synaptics_rmi4_resume(struct device *dev)
> >
> >  	retval = synaptics_rmi4_i2c_byte_write(rmi4_data,
> >  					rmi4_data->fn01_ctrl_base_addr + 1,
> > -					(intr_status | TOUCHPAD_CTRL_INTR));
> > +					(intr_status | TOUCHSCREEN_CTRL_INTR));
> >  	if (retval < 0)
> >  		return retval;
> >
> > --
> > 1.7.5.4
> >
> 
> Ok, with a final polish and a proper commit message, this looks like it will work.
> 
> Thanks,
> Henrik

I will fix these issues and recommit a patch ASAP.
I really appreciate your recommendation.

Alexandra

