Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab2AFAFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 19:05:48 -0500
Received: from us-mx3.synaptics.com ([12.239.217.85]:8178 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758390Ab2AFAFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 19:05:46 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 05 Jan 2012 15:53:35 -0800
Message-ID: <4F063AD7.8010501@synaptics.com>
Date: Thu, 5 Jan 2012 16:05:43 -0800
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Vivian Ly <vly@synaptics.com>
Subject: Re: [RFC PATCH 10/11] input: RMI4 F19 - capacitive buttons
References: <1324519802-23894-1-git-send-email-cheiny@synaptics.com> <1324519802-23894-11-git-send-email-cheiny@synaptics.com> <20120105075339.GC31895@core.coreip.homeip.net>
In-Reply-To: <20120105075339.GC31895@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 11:53 PM, Dmitry Torokhov wrote:
> Hi Christopher,
>
> On Wed, Dec 21, 2011 at 06:10:01PM -0800, Christopher Heiny wrote:
>> Signed-off-by: Christopher Heiny<cheiny@synaptics.com>
>
> A bunch of comments generally applicable to all patches.
>
> I have not looked at the core thoroughly yet.

Thanks for the feedback.  I've included our responses below (along with 
snippage to remove areas out of context.


>> ---
>>
>>   drivers/input/rmi4/rmi_f19.c | 1571 ++++++++++++++++++++++++++++++++++++++++++
>>   1 files changed, 1571 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/input/rmi4/rmi_f19.c b/drivers/input/rmi4/rmi_f19.c
>> new file mode 100644
>> index 0000000..a678f30
>> --- /dev/null
>> +++ b/drivers/input/rmi4/rmi_f19.c
>> @@ -0,0 +1,1571 @@
>> +/*

[snip]

>> +
>> +struct f19_0d_control_0 {
>> +	union {
>> +		struct {
>> +			u8 button_usage:2;
>> +			u8 filter_mode:2;
>> +		};
>> +		u8 f19_0d_control0;
>> +	};
>
> Anonymous union in a struct is kind of pointless...

Agreed.


>> +};
>> +
>> +struct f19_0d_control_1 {
>> +	u8 int_enabled_button;
>> +};
>> +
>> +struct f19_0d_control_2 {
>> +	u8 single_button;
>> +};
>> +
>> +struct f19_0d_control_3_4 {
>> +	u8 sensor_map_button:7;
>> +	/*u8 sensitivity_button;*/
>> +};
>> +
>> +struct f19_0d_control_5 {
>> +	u8 sensitivity_adj;
>> +};
>> +struct f19_0d_control_6 {
>> +	u8 hysteresis_threshold;
>> +};
>> +
>> +struct f19_0d_control {
>> +	struct f19_0d_control_0 *general_control;
>
> Single instance, does not need to be allocated separately.
>
>> +	struct f19_0d_control_1 *button_int_enable;
>> +	struct f19_0d_control_2 *single_button_participation;
>> +	struct f19_0d_control_3_4 *sensor_map;
>
> This should probably be an array of
>
> struct f19_button_ctrl {
> 	struct f19_0d_control_1 int_enable;
> 	struct f19_0d_control_2 participation;
> 	struct f19_0d_control_3_4 sensor_map;
> };
>
> located at the end of f19_0d_control structure so it can be all
> allocated in one shot.

We organized it this way because of how the controls are organized in 
the register map: first the interrupt enables for all buttons, then the 
participation for all buttons, and then the sensor map for all buttons. 
  Typical client interactions are to adjust these in an "all at once" 
approach - that is, change as a single group all the interrupt enables, 
all the participation settings, or all the sensor map.  By organizing 
them the way we did, it makes it very easy to read/write the data to the 
RMI4 sensor's register map.  Using an array of structs would require a 
building buffers (on write) or tedious extraction from buffers (on read).

However, the first two of these are bitmasks, and don't really need 
their own structs - they can conveniently be u8 * instead.


>> +	struct f19_0d_control_5 *all_button_sensitivity_adj;
>
> Single instance, does not need to be allocated separately.

Agreed.

>
>> +	struct f19_0d_control_6 *all_button_hysteresis_threshold;
>
> Single instance, does not need to be allocated separately.
>
>> +};
>> +/* data specific to fn $19 that needs to be kept around */
>> +struct f19_data {
>> +	struct f19_0d_control *button_control;
>> +	struct f19_0d_query button_query;
>> +	u8 button_rezero;
>> +	bool *button_down;
>
> Just let input core track this for you.

That would work.  We were trying to be efficient by only generating 
events of interest, but I'm quite happy to let another subsystem do the 
heavy lifting for us. We'll follow your later recommendation and just 
pass button state info along.


>> +	unsigned char button_count;
>> +	unsigned char button_data_buffer_size;
>
> Your fingers must be hurting by the time you finished writing this
> driver...

I'm a little obsessive about descriptive variable names.  As a result, I 
have digits the size of Arnold Schwarzenegger's biceps. :-)

>
>> +	unsigned char *button_data_buffer;
>> +	unsigned char *button_map;
>
> Linux keycodes are wider than 8 bits, should be unsigned short.

Agreed.


>> +	char input_name[MAX_LEN];
>> +	char input_phys[MAX_LEN];
>> +	struct input_dev *input;
>> +};
>> +
>> +static ssize_t rmi_f19_button_count_show(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 char *buf);
>> +
>> +static ssize_t rmi_f19_button_map_show(struct device *dev,
>> +				      struct device_attribute *attr, char *buf);
>> +
>> +static ssize_t rmi_f19_button_map_store(struct device *dev,
>> +				       struct device_attribute *attr,
>> +				       const char *buf, size_t count);
>> +static ssize_t rmi_f19_rezero_show(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 char *buf);
>> +static ssize_t rmi_f19_rezero_store(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 const char *buf, size_t count);
>> +static ssize_t rmi_f19_has_hysteresis_threshold_show(struct device *dev,
>> +				      struct device_attribute *attr, char *buf);
>> +static ssize_t rmi_f19_has_sensitivity_adjust_show(struct device *dev,
>> +				      struct device_attribute *attr, char *buf);
>> +static ssize_t rmi_f19_configurable_show(struct device *dev,
>> +				      struct device_attribute *attr, char *buf);
>> +static ssize_t rmi_f19_filter_mode_show(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 char *buf);
>> +static ssize_t rmi_f19_filter_mode_store(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 const char *buf, size_t count);
>> +static ssize_t rmi_f19_button_usage_show(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 char *buf);
>> +static ssize_t rmi_f19_button_usage_store(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 const char *buf, size_t count);
>> +static ssize_t rmi_f19_interrupt_enable_button_show(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 char *buf);
>> +static ssize_t rmi_f19_interrupt_enable_button_store(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 const char *buf, size_t count);
>> +static ssize_t rmi_f19_single_button_show(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 char *buf);
>> +static ssize_t rmi_f19_single_button_store(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 const char *buf, size_t count);
>> +static ssize_t rmi_f19_sensor_map_show(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 char *buf);
>> +static ssize_t rmi_f19_sensor_map_store(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 const char *buf, size_t count);
>> +static ssize_t rmi_f19_sensitivity_adjust_show(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 char *buf);
>> +static ssize_t rmi_f19_sensitivity_adjust_store(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 const char *buf, size_t count);
>> +static ssize_t rmi_f19_hysteresis_threshold_show(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 char *buf);
>> +static ssize_t rmi_f19_hysteresis_threshold_store(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 const char *buf, size_t count);
>> +
>> +
>> +
>> +static inline int rmi_f19_alloc_memory(struct rmi_function_container *fc);
>> +
>> +static inline void rmi_f19_free_memory(struct rmi_function_container *fc);
>> +
>> +static inline int rmi_f19_initialize(struct rmi_function_container *fc);
>> +
>> +static inline int rmi_f19_register_device(struct rmi_function_container *fc);
>> +
>> +static inline int rmi_f19_create_sysfs(struct rmi_function_container *fc);
>> +
>> +static int rmi_f19_config(struct rmi_function_container *fc);
>> +
>> +static int rmi_f19_reset(struct rmi_function_container *fc);
>> +
>> +static struct device_attribute attrs[] = {
>> +	__ATTR(button_count, RMI_RO_ATTR,
>> +		rmi_f19_button_count_show, rmi_store_error),
>
> Why not NULL instead of rmi_store_error?

We found that customers picking up our driver would try to write RO 
sysfs attributes (or read WO attrs) by invoking echo from the command 
line.  The operation would fail silently (I'm looking at you, Android 
shell), leaving the engineer baffled as to why the sensor behavior 
didn't change.  So we adopted this approach so as to give some clue as 
to the fact that the operation failed.

>> +	__ATTR(button_map, RMI_RW_ATTR,
>> +		rmi_f19_button_map_show, rmi_f19_button_map_store),
>> +	__ATTR(rezero, RMI_RW_ATTR,
>> +		rmi_f19_rezero_show, rmi_f19_rezero_store),
>> +	__ATTR(has_hysteresis_threshold, RMI_RO_ATTR,
>> +		rmi_f19_has_hysteresis_threshold_show, rmi_store_error),
>> +	__ATTR(has_sensitivity_adjust, RMI_RO_ATTR,
>> +		rmi_f19_has_sensitivity_adjust_show, rmi_store_error),
>> +	__ATTR(configurable, RMI_RO_ATTR,
>> +		rmi_f19_configurable_show, rmi_store_error),
>> +	__ATTR(filter_mode, RMI_RW_ATTR,
>> +		rmi_f19_filter_mode_show, rmi_f19_filter_mode_store),
>> +	__ATTR(button_usage, RMI_RW_ATTR,
>> +		rmi_f19_button_usage_show, rmi_f19_button_usage_store),
>> +	__ATTR(interrupt_enable_button, RMI_RW_ATTR,
>> +		rmi_f19_interrupt_enable_button_show,
>> +		rmi_f19_interrupt_enable_button_store),
>> +	__ATTR(single_button, RMI_RW_ATTR,
>> +		rmi_f19_single_button_show, rmi_f19_single_button_store),
>> +	__ATTR(sensor_map, RMI_RW_ATTR,
>> +		rmi_f19_sensor_map_show, rmi_f19_sensor_map_store),
>> +	__ATTR(sensitivity_adjust, RMI_RW_ATTR,
>> +		rmi_f19_sensitivity_adjust_show,
>> +		rmi_f19_sensitivity_adjust_store),
>> +	__ATTR(hysteresis_threshold, RMI_RW_ATTR,
>> +		rmi_f19_hysteresis_threshold_show,
>> +		rmi_f19_hysteresis_threshold_store)
>> +};
>> +
>> +
>> +int rmi_f19_read_control_parameters(struct rmi_device *rmi_dev,
>> +	struct f19_0d_control *button_control,
>> +	unsigned char button_count,
>> +	unsigned char int_button_enabled_count,
>> +	u8 ctrl_base_addr)
>> +{
>> +	int error = 0;
>> +	int i;
>> +
>> +	if (button_control->general_control) {
>
> It can't be NULL.

OK.

>> +		error = rmi_read_block(rmi_dev, ctrl_base_addr,
>> +				(u8 *)button_control->general_control,
>> +				sizeof(struct f19_0d_control_0));
>> +		if (error<  0) {
>> +			dev_err(&rmi_dev->dev,
>> +				"Failed to read f19_0d_control_0, code:"
>> +				" %d.\n", error);
>> +			return error;
>> +		}
>> +		ctrl_base_addr = ctrl_base_addr +
>> +				sizeof(struct f19_0d_control_0);
>> +	}
>> +
>> +	if (button_control->button_int_enable) {
>
> Neither can this.

OK.


>> +		for (i = 0; i<  int_button_enabled_count; i++) {
>> +			error = rmi_read_block(rmi_dev, ctrl_base_addr,
>> +				(u8 *)&button_control->button_int_enable[i],
>> +				sizeof(struct f19_0d_control_1));
>> +			if (error<  0) {
>> +				dev_err(&rmi_dev->dev,
>> +					"Failed to read f19_0d_control_2,"
>> +					" code: %d.\n", error);
>> +				return error;
>> +			}
>> +			ctrl_base_addr = ctrl_base_addr +
>> +				sizeof(struct f19_0d_control_1);
>> +		}
>> +	}
>> +
>> +	if (button_control->single_button_participation) {
>
> Nor this.

OK

>
>> +		for (i = 0; i<  int_button_enabled_count; i++) {
>> +			error = rmi_read_block(rmi_dev, ctrl_base_addr,
>> +					(u8 *)&button_control->
>> +						single_button_participation[i],
>> +					sizeof(struct f19_0d_control_2));
>> +			if (error<  0) {
>> +				dev_err(&rmi_dev->dev,
>> +					"Failed to read f19_0d_control_2,"
>> +					" code: %d.\n", error);
>> +				return error;
>> +			}
>> +			ctrl_base_addr = ctrl_base_addr +
>> +				sizeof(struct f19_0d_control_2);
>> +		}
>> +	}
>> +
>> +	if (button_control->sensor_map) {
>
> Nor this...

OK

>
>> +		for (i = 0; i<  button_count; i++) {
>> +			error = rmi_read_block(rmi_dev, ctrl_base_addr,
>> +					(u8 *)&button_control->sensor_map[i],
>> +					sizeof(struct f19_0d_control_3_4));
>> +			if (error<  0) {
>> +				dev_err(&rmi_dev->dev,
>> +				"Failed to read f19_0d_control_3_4,"
>> +				" code: %d.\n", error);
>> +				return error;
>> +			}
>> +			ctrl_base_addr = ctrl_base_addr +
>> +				sizeof(struct f19_0d_control_3_4);
>> +		}
>> +	}
>> +
>> +	if (button_control->all_button_sensitivity_adj) {
>
> Nor this.

OK.  And it probably shouldn't even be a pointer.


>> +		error = rmi_read_block(rmi_dev, ctrl_base_addr,
>> +				(u8 *)button_control->
>> +					all_button_sensitivity_adj,
>> +				sizeof(struct f19_0d_control_5));
>> +		if (error<  0) {
>> +			dev_err(&rmi_dev->dev,
>> +				"Failed to read f19_0d_control_5,"
>> +				" code: %d.\n", error);
>> +			return error;
>> +		}
>> +		ctrl_base_addr = ctrl_base_addr +
>> +			sizeof(struct f19_0d_control_5);
>> +	}
>> +
>> +	if (button_control->all_button_hysteresis_threshold) {
>
> ...

OK.

>
>> +		error = rmi_read_block(rmi_dev, ctrl_base_addr,
>> +				(u8 *)button_control->
>> +					all_button_hysteresis_threshold,
>> +				sizeof(struct f19_0d_control_6));
>> +		if (error<  0) {
>> +			dev_err(&rmi_dev->dev,
>> +				"Failed to read f19_0d_control_6,"
>> +				" code: %d.\n", error);
>> +			return error;
>> +		}
>> +		ctrl_base_addr = ctrl_base_addr +
>> +			sizeof(struct f19_0d_control_6);
>> +	}
>> +	return 0;
>> +}

[snip]

>> +
>> +
>> +static inline int rmi_f19_alloc_memory(struct rmi_function_container *fc)
>
> Please drop inline throughout, let compiler do its job.

Will do through out the driver.

>> +
>> +	f19->button_data_buffer_size = (f19->button_count + 7) / 8;
>
> 	DIV_ROUND_UP(f19->button_count, 8);

I think we tried this once, and found that some compilers/toolkits 
barfed on it.  I'll look into it.


>> +	f19->button_data_buffer =
>> +	    kcalloc(f19->button_data_buffer_size,
>> +		    sizeof(unsigned char), GFP_KERNEL);
>> +	if (!f19->button_data_buffer) {
>> +		dev_err(&fc->dev, "Failed to allocate button data buffer.\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	f19->button_map = kcalloc(f19->button_count,
>> +				sizeof(unsigned char), GFP_KERNEL);
>> +	if (!f19->button_map) {
>> +		dev_err(&fc->dev, "Failed to allocate button map.\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	f19->button_control = kzalloc(sizeof(struct f19_0d_control),
>> +				GFP_KERNEL);
>
> If you allocate a single copy of this structure why isn't it a member of
> struct f19_data to begin with?

Don't ask me questions I can't answer.  :-)  That's good point - we'll 
move it.

>> +	if (!f19->button_control) {
>> +		dev_err(&fc->dev, "Failed to allocate button_control.\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	f19->button_control->general_control =
>> +		kzalloc(sizeof(struct f19_0d_control_0), GFP_KERNEL);
>
> This a single byte, why do you need to allocate it separately?

See above.

>
>> +	if (!f19->button_control->general_control) {
>> +		dev_err(&fc->dev, "Failed to allocate"
>> +				" f19_0d_control_0.\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	f19->button_control->button_int_enable =
>> +		kzalloc(f19->button_data_buffer_size *
>> +			sizeof(struct f19_0d_control_2), GFP_KERNEL);
>> +	if (!f19->button_control->button_int_enable) {
>> +		dev_err(&fc->dev, "Failed to allocate f19_0d_control_1.\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	f19->button_control->single_button_participation =
>> +		kzalloc(f19->button_data_buffer_size *
>> +			sizeof(struct f19_0d_control_2), GFP_KERNEL);
>> +	if (!f19->button_control->single_button_participation) {
>> +		dev_err(&fc->dev, "Failed to allocate"
>> +			" f19_0d_control_2.\n");
>
> Do not split error messages; it's OK if they exceed 80 column limit.

We have one customer who refuses to accept any code if any line exceeds 
80 columns, so we wind up with ugliness like this.

>> +		return -ENOMEM;
>> +	}
>> +
>> +	f19->button_control->sensor_map =
>> +		kzalloc(f19->button_count *
>> +			sizeof(struct f19_0d_control_3_4), GFP_KERNEL);
>> +	if (!f19->button_control->sensor_map) {
>> +		dev_err(&fc->dev, "Failed to allocate"
>> +			" f19_0d_control_3_4.\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	f19->button_control->all_button_sensitivity_adj =
>> +		kzalloc(sizeof(struct f19_0d_control_5), GFP_KERNEL);
>> +	if (!f19->button_control->all_button_sensitivity_adj) {
>> +		dev_err(&fc->dev, "Failed to allocate"
>> +			" f19_0d_control_5.\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	f19->button_control->all_button_hysteresis_threshold =
>> +		kzalloc(sizeof(struct f19_0d_control_6), GFP_KERNEL);
>> +	if (!f19->button_control->all_button_hysteresis_threshold) {
>> +		dev_err(&fc->dev, "Failed to allocate"
>> +			" f19_0d_control_6.\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +
>> +
>> +static inline void rmi_f19_free_memory(struct rmi_function_container *fc)
>> +{
>> +	struct f19_data *f19 = fc->data;
>> +
>> +	if (f19) {
>
> Can it be NULL? How?

This is just defensive, in case someone calls this at the wrong place or 
time.

>> +		kfree(f19->button_down);
>> +		kfree(f19->button_data_buffer);
>> +		kfree(f19->button_map);
>> +		if (f19->button_control) {
>> +			kfree(f19->button_control->general_control);
>> +			kfree(f19->button_control->button_int_enable);
>> +			kfree(f19->button_control->single_button_participation);
>> +			kfree(f19->button_control->sensor_map);
>> +			kfree(f19->button_control->all_button_sensitivity_adj);
>> +			kfree(f19->button_control->
>> +				  all_button_hysteresis_threshold);
>> +			kfree(f19->button_control);
>> +		}
>> +		kfree(f19);
>> +		fc->data = NULL;
>> +	}
>> +}
>> +
>> +
>> +static inline int rmi_f19_initialize(struct rmi_function_container *fc)
>> +{
>> +	struct rmi_device *rmi_dev = fc->rmi_dev;
>> +	struct rmi_device_platform_data *pdata;
>> +	struct f19_data *f19 = fc->data;
>> +	int i;
>> +	int rc;
>> +
>> +	dev_info(&fc->dev, "Intializing F19 values.");
>
> dev_dbg()

OK.

>> +
>> +	/* initial all default values for f19 data here */
>> +	rc = rmi_read(rmi_dev, fc->fd.command_base_addr,
>> +		(u8 *)&f19->button_rezero);
>> +	if (rc<  0) {
>> +		dev_err(&fc->dev, "Failed to read command register.\n");
>> +		return rc;
>> +	}
>> +	f19->button_rezero = f19->button_rezero&  1;

[snip]

>> +
>> +static inline int rmi_f19_register_device(struct rmi_function_container *fc)
>> +{
>> +	struct rmi_device *rmi_dev = fc->rmi_dev;
>> +	struct input_dev *input_dev;
>> +	struct f19_data *f19 = fc->data;
>> +	int i;
>> +	int rc;
>> +
>> +	input_dev = input_allocate_device();
>> +	if (!input_dev) {
>> +		dev_err(&fc->dev, "Failed to allocate input device.\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	f19->input = input_dev;
>> +	snprintf(f19->input_name, MAX_LEN, "%sfn%02x", dev_name(&rmi_dev->dev),
>> +		fc->fd.function_number);
>> +	input_dev->name = f19->input_name;
>> +	snprintf(f19->input_phys, MAX_LEN, "%s/input0", input_dev->name);
>> +	input_dev->phys = f19->input_phys;
>> +	input_dev->dev.parent =&rmi_dev->dev;
>> +	input_set_drvdata(input_dev, f19);
>> +
>> +	/* Set up any input events. */
>> +	set_bit(EV_SYN, input_dev->evbit);
>> +	set_bit(EV_KEY, input_dev->evbit);
>
> __set_bit(), no need to lock the bus.

OK.

>> +	/* set bits for each button... */
>> +	for (i = 0; i<  f19->button_count; i++)
>> +		set_bit(f19->button_map[i], input_dev->keybit);
>> +	rc = input_register_device(input_dev);
>> +	if (rc<  0) {
>> +		dev_err(&fc->dev, "Failed to register input device.\n");
>> +		goto error_free_device;
>> +	}
>> +
>> +	return 0;

[snip]

>> +static inline int rmi_f19_create_sysfs(struct rmi_function_container *fc)
>> +{
>> +	int attr_count = 0;
>> +	int rc;
>> +
>> +	dev_dbg(&fc->dev, "Creating sysfs files.\n");
>> +	/* Set up sysfs device attributes. */
>> +	for (attr_count = 0; attr_count<  ARRAY_SIZE(attrs); attr_count++) {
>> +		if (sysfs_create_file
>> +		    (&fc->dev.kobj,&attrs[attr_count].attr)<  0) {
>> +			dev_err(&fc->dev,
>> +				"Failed to create sysfs file for %s.",
>> +				attrs[attr_count].attr.name);
>> +			rc = -ENODEV;
>> +			goto err_remove_sysfs;
>> +		}
>> +	}
>
> This is called attribute group, please use it.

Good point.  Will do that here and in the rest of the driver.



>> +
>> +	return 0;
>> +
>> +err_remove_sysfs:
>> +	for (attr_count--; attr_count>= 0; attr_count--)
>> +		sysfs_remove_file(&fc->dev.kobj,
>> +						&attrs[attr_count].attr);
>> +	return rc;
>> +
>> +}
>> +
>> +
>> +
>> +static int rmi_f19_config(struct rmi_function_container *fc)
>> +{
>> +	struct f19_data *data;
>> +	int retval;
>> +	int ctrl_base_addr;
>> +	int button_reg;
>> +
>> +	data = fc->data;
>> +
>> +	ctrl_base_addr = fc->fd.control_base_addr;
>> +
>> +	button_reg = (data->button_count / 7) + 1;
>
>
> Please combine variable declarations and initializations - this makes
> code a bit less verbose and easier to read.

Agree.

[snip]

>> +
>> +int rmi_f19_attention(struct rmi_function_container *fc, u8 *irq_bits)
>
> static.

Agree.

>> +{
>> +	struct rmi_device *rmi_dev = fc->rmi_dev;
>> +	struct f19_data *f19 = fc->data;
>> +	u8 data_base_addr = fc->fd.data_base_addr;
>> +	int error;
>> +	int button;
>> +
>> +	/* Read the button data. */
>> +
>> +	error = rmi_read_block(rmi_dev, data_base_addr, f19->button_data_buffer,
>> +			f19->button_data_buffer_size);
>> +	if (error<  0) {
>> +		dev_err(&fc->dev, "%s: Failed to read button data registers.\n",
>> +			__func__);
>> +		return error;
>> +	}
>> +
>> +	/* Generate events for buttons that change state. */
>> +	for (button = 0; button<  f19->button_count;
>> +	     button++) {
>> +		int button_reg;
>> +		int button_shift;
>> +		bool button_status;
>> +
>> +		/* determine which data byte the button status is in */
>> +		button_reg = button / 7;
>> +		/* bit shift to get button's status */
>> +		button_shift = button % 8;
>> +		button_status =
>> +		    ((f19->button_data_buffer[button_reg]>>  button_shift)
>> +			&  0x01) != 0;
>> +
>> +		/* if the button state changed from the last time report it
>> +		 * and store the new state */
>> +		if (button_status != f19->button_down[button]) {
>> +			dev_dbg(&fc->dev, "%s: Button %d (code %d) ->  %d.\n",
>> +				__func__, button, f19->button_map[button],
>> +				 button_status);
>> +			/* Generate an event here. */
>> +			input_report_key(f19->input, f19->button_map[button],
>> +					 button_status);
>> +			f19->button_down[button] = button_status;
>> +		}
>> +	}
>
> All of the above could be reduced to:
>
> 	for (button = 0; button<  f19->button_count; button++)
> 		input_report_key(f19->input, f19->button_map[button],
> 				 test_bit(button, f19->button_data_buffer);

I'd like to, but I'm not sure - can we count on the endian-ness of the 
host processor being the same as the RMI4 register endian-ness?

[snip]

>> +
>> +static ssize_t rmi_f19_sensor_map_store(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 const char *buf, size_t count)
>> +{
>> +	struct rmi_function_container *fc;
>> +	struct f19_data *data;
>> +	int sensor_map;
>> +	int i;
>> +	int retval = count;
>> +	int button_count = 0;
>> +	int ctrl_bass_addr;
>> +	int button_reg;
>> +	fc = to_rmi_function_container(dev);
>> +	data = fc->data;
>> +
>> +	if (data->button_query.configurable == 0) {
>> +		dev_err(dev,
>> +			"%s: Error - sensor map is not configuralbe at"
>> +			" run-time", __func__);
>
> This is not driver error, return error silently.

I don't like failing silently, for reasons outlined above.

>
>> +		return -EINVAL;
>> +	}
>
> If sensor is not cinfigurable maybe attributes mode should be adjusted
> to be read-only?

Good point.  Then we could eliminate the dev_err, above.  We'll look 
into this at the same time as the attribute groups.

[snip]

>> +
>> +static ssize_t rmi_f19_button_map_store(struct device *dev,
>> +				struct device_attribute *attr,
>> +				const char *buf,
>> +				size_t count)
>> +{
>> +	struct rmi_function_container *fc;
>> +	struct f19_data *data;
>> +	unsigned int button;
>> +	int i;
>> +	int retval = count;
>> +	int button_count = 0;
>> +	unsigned char temp_button_map[KEY_MAX];
>> +
>> +	fc = to_rmi_function_container(dev);
>> +	data = fc->data;
>> +
>> +	/* Do validation on the button map data passed in.  Store button
>> +	 * mappings into a temp buffer and then verify button count and
>> +	 * data prior to clearing out old button mappings and storing the
>> +	 * new ones. */
>> +	for (i = 0; i<  data->button_count&&  *buf != 0;
>> +	     i++) {
>> +		/* get next button mapping value and store and bump up to
>> +		 * point to next item in buf */
>> +		sscanf(buf, "%u",&button);
>> +
>> +		/* Make sure the key is a valid key */
>> +		if (button>  KEY_MAX) {
>> +			dev_err(dev,
>> +				"%s: Error - button map for button %d is not a"
>> +				" valid value 0x%x.\n", __func__, i, button);
>> +			retval = -EINVAL;
>> +			goto err_ret;
>> +		}
>> +
>> +		temp_button_map[i] = button;
>> +		button_count++;
>> +
>> +		/* bump up buf to point to next item to read */
>> +		while (*buf != 0) {
>> +			buf++;
>> +			if (*(buf - 1) == ' ')
>> +				break;
>> +		}
>> +	}
>> +
>> +	/* Make sure the button count matches */
>> +	if (button_count != data->button_count) {
>> +		dev_err(dev,
>> +		    "%s: Error - button map count of %d doesn't match device "
>> +		     "button count of %d.\n", __func__, button_count,
>> +		     data->button_count);
>> +		retval = -EINVAL;
>> +		goto err_ret;
>> +	}
>> +
>> +	/* Clear the key bits for the old button map. */
>> +	for (i = 0; i<  button_count; i++)
>> +		clear_bit(data->button_map[i], data->input->keybit);
>> +
>> +	/* Switch to the new map. */
>> +	memcpy(data->button_map, temp_button_map,
>> +	       data->button_count);
>> +
>> +	/* Loop through the key map and set the key bit for the new mapping. */
>> +	for (i = 0; i<  button_count; i++)
>> +		set_bit(data->button_map[i], data->input->keybit);
>> +
>> +err_ret:
>> +	return retval;
>> +}
>
> Button map (keymap) should be manipulated with EVIOCGKEYCODE and
> EVIOCSKEYCODE ioctls, no need to invent driver-specific way of doing
> this.

Makes sense, but... we had a customer request to specify the boot-time 
keymap through the RMI4 driver's platform data.  Is it legal to call 
setkeycode() to do that instead?  If so, we'll do that and get rid of 
the button_map entirely.

Thanks again for the review and input,

					Chris
