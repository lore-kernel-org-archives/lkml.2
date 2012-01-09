Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab2AJUNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 15:13:22 -0500
Received: from us-mx3.synaptics.com ([12.239.217.85]:10990 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab2AJUNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 15:13:19 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Tue, 10 Jan 2012 12:00:32 -0800
Message-ID: <4F0B55E7.1070909@synaptics.com>
Date: Mon, 9 Jan 2012 13:02:31 -0800
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
References: <1324519802-23894-1-git-send-email-cheiny@synaptics.com> <1324519802-23894-11-git-send-email-cheiny@synaptics.com> <20120105075339.GC31895@core.coreip.homeip.net> <4F063AD7.8010501@synaptics.com> <20120106025045.GB10062@core.coreip.homeip.net>
In-Reply-To: <20120106025045.GB10062@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2012 06:50 PM, Dmitry Torokhov wrote:
> On Thu, Jan 05, 2012 at 04:05:43PM -0800, Christopher Heiny wrote:
>> On 01/04/2012 11:53 PM, Dmitry Torokhov wrote:
>>> Hi Christopher,
>>>
>>> On Wed, Dec 21, 2011 at 06:10:01PM -0800, Christopher Heiny wrote:
>>>> +
>>>> +struct f19_0d_control {
>>>> +	struct f19_0d_control_0 *general_control;
>>>
>>> Single instance, does not need to be allocated separately.
>>>
>>>> +	struct f19_0d_control_1 *button_int_enable;
>>>> +	struct f19_0d_control_2 *single_button_participation;
>>>> +	struct f19_0d_control_3_4 *sensor_map;
>>>
>>> This should probably be an array of
>>>
>>> struct f19_button_ctrl {
>>> 	struct f19_0d_control_1 int_enable;
>>> 	struct f19_0d_control_2 participation;
>>> 	struct f19_0d_control_3_4 sensor_map;
>>> };
>>>
>>> located at the end of f19_0d_control structure so it can be all
>>> allocated in one shot.
>>
>> We organized it this way because of how the controls are organized
>> in the register map: first the interrupt enables for all buttons,
>> then the participation for all buttons, and then the sensor map for
>> all buttons.  Typical client interactions are to adjust these in an
>> "all at once" approach - that is, change as a single group all the
>> interrupt enables, all the participation settings, or all the sensor
>> map.  By organizing them the way we did, it makes it very easy to
>> read/write the data to the RMI4 sensor's register map.  Using an
>> array of structs would require a building buffers (on write) or
>> tedious extraction from buffers (on read).
>>
>> However, the first two of these are bitmasks, and don't really need
>> their own structs - they can conveniently be u8 * instead.
>
> I'll try coding something to show that it is not as bad as it seems...

OK, we'll look forward to that.

[snip]

>
>>>> +
>>>> +static struct device_attribute attrs[] = {
>>>> +	__ATTR(button_count, RMI_RO_ATTR,
>>>> +		rmi_f19_button_count_show, rmi_store_error),
>>>
>>> Why not NULL instead of rmi_store_error?
>>
>> We found that customers picking up our driver would try to write RO
>> sysfs attributes (or read WO attrs) by invoking echo from the
>> command line.  The operation would fail silently (I'm looking at
>> you, Android shell), leaving the engineer baffled as to why the
>> sensor behavior didn't change.  So we adopted this approach so as to
>> give some clue as to the fact that the operation failed.
>
> But this ends up in various logs (dmesg, /var/log/messages, etc) making
> it potentially DOS scenario. Please help fixing tools instead.

I see your point about the DOS scenario.  How about we do this: make the 
rmi_store/show_error routines a #define, that normally is set to NULL, 
but have an optional debug flag (RMI4_SYSFS_DEBUG) that uses these 
verbose functions.

>
>>>> +
>>>> +	f19->button_control->single_button_participation =
>>>> +		kzalloc(f19->button_data_buffer_size *
>>>> +			sizeof(struct f19_0d_control_2), GFP_KERNEL);
>>>> +	if (!f19->button_control->single_button_participation) {
>>>> +		dev_err(&fc->dev, "Failed to allocate"
>>>> +			" f19_0d_control_2.\n");
>>>
>>> Do not split error messages; it's OK if they exceed 80 column limit.
>>
>> We have one customer who refuses to accept any code if any line
>> exceeds 80 columns, so we wind up with ugliness like this.
>
> This is contrary to current kernel policy though
> (Documentation/CodingStyle, ch 2):
>
> "However, never break user-visible strings such as
> printk messages, because that breaks the ability to grep for them."

Yes, but then checkpatch.pl whines about them, which is also 
unacceptable to that customer.  However, at this point I think 
usefulness takes priority, so we'll unbreak those strings.

[snip]

>>>> +
>>>> +	/* Generate events for buttons that change state. */
>>>> +	for (button = 0; button<   f19->button_count;
>>>> +	     button++) {
>>>> +		int button_reg;
>>>> +		int button_shift;
>>>> +		bool button_status;
>>>> +
>>>> +		/* determine which data byte the button status is in */
>>>> +		button_reg = button / 7;
>>>> +		/* bit shift to get button's status */
>>>> +		button_shift = button % 8;
>>>> +		button_status =
>>>> +		    ((f19->button_data_buffer[button_reg]>>   button_shift)
>>>> +			&   0x01) != 0;
>>>> +
>>>> +		/* if the button state changed from the last time report it
>>>> +		 * and store the new state */
>>>> +		if (button_status != f19->button_down[button]) {
>>>> +			dev_dbg(&fc->dev, "%s: Button %d (code %d) ->   %d.\n",
>>>> +				__func__, button, f19->button_map[button],
>>>> +				 button_status);
>>>> +			/* Generate an event here. */
>>>> +			input_report_key(f19->input, f19->button_map[button],
>>>> +					 button_status);
>>>> +			f19->button_down[button] = button_status;
>>>> +		}
>>>> +	}
>>>
>>> All of the above could be reduced to:
>>>
>>> 	for (button = 0; button<   f19->button_count; button++)
>>> 		input_report_key(f19->input, f19->button_map[button],
>>> 				 test_bit(button, f19->button_data_buffer);
>>
>> I'd like to, but I'm not sure - can we count on the endian-ness of
>> the host processor being the same as the RMI4 register endian-ness?
>
> Hmm, I'd expect RMI transport functions take care of converting into
> proper endianness.

If I can convince myself that it will never do something surprising, 
we'll implement that.

>
>>
>> [snip]
>>
>>>> +
>>>> +static ssize_t rmi_f19_sensor_map_store(struct device *dev,
>>>> +					 struct device_attribute *attr,
>>>> +					 const char *buf, size_t count)
>>>> +{
>>>> +	struct rmi_function_container *fc;
>>>> +	struct f19_data *data;
>>>> +	int sensor_map;
>>>> +	int i;
>>>> +	int retval = count;
>>>> +	int button_count = 0;
>>>> +	int ctrl_bass_addr;
>>>> +	int button_reg;
>>>> +	fc = to_rmi_function_container(dev);
>>>> +	data = fc->data;
>>>> +
>>>> +	if (data->button_query.configurable == 0) {
>>>> +		dev_err(dev,
>>>> +			"%s: Error - sensor map is not configuralbe at"
>>>> +			" run-time", __func__);
>>>
>>> This is not driver error, return error silently.
>>
>> I don't like failing silently, for reasons outlined above.
>
> And for the reason also outlined above I disagree. Driver errors
> (especially KERNEL_ERR level) should be used to signal conditions when
> driver either can't continue or its functionality is seriously impaired.
> Bad user input does not qualify here.

I think switching to the attribute groups will eliminate this particular 
case, along with a few others.  We'll switch others to warning, which is 
a more appropriate level, and look at making them conditional (default 
to silent).

[snip]

>>>> +static ssize_t rmi_f19_button_map_store(struct device *dev,
>>>> +				struct device_attribute *attr,
>>>> +				const char *buf,
>>>> +				size_t count)
>>>> +{
>>>> +	struct rmi_function_container *fc;
>>>> +	struct f19_data *data;
>>>> +	unsigned int button;
>>>> +	int i;
>>>> +	int retval = count;
>>>> +	int button_count = 0;
>>>> +	unsigned char temp_button_map[KEY_MAX];
>>>> +
>>>> +	fc = to_rmi_function_container(dev);
>>>> +	data = fc->data;
>>>> +
>>>> +	/* Do validation on the button map data passed in.  Store button
>>>> +	 * mappings into a temp buffer and then verify button count and
>>>> +	 * data prior to clearing out old button mappings and storing the
>>>> +	 * new ones. */
>>>> +	for (i = 0; i<   data->button_count&&   *buf != 0;
>>>> +	     i++) {
>>>> +		/* get next button mapping value and store and bump up to
>>>> +		 * point to next item in buf */
>>>> +		sscanf(buf, "%u",&button);
>>>> +
>>>> +		/* Make sure the key is a valid key */
>>>> +		if (button>   KEY_MAX) {
>>>> +			dev_err(dev,
>>>> +				"%s: Error - button map for button %d is not a"
>>>> +				" valid value 0x%x.\n", __func__, i, button);
>>>> +			retval = -EINVAL;
>>>> +			goto err_ret;
>>>> +		}
>>>> +
>>>> +		temp_button_map[i] = button;
>>>> +		button_count++;
>>>> +
>>>> +		/* bump up buf to point to next item to read */
>>>> +		while (*buf != 0) {
>>>> +			buf++;
>>>> +			if (*(buf - 1) == ' ')
>>>> +				break;
>>>> +		}
>>>> +	}
>>>> +
>>>> +	/* Make sure the button count matches */
>>>> +	if (button_count != data->button_count) {
>>>> +		dev_err(dev,
>>>> +		    "%s: Error - button map count of %d doesn't match device "
>>>> +		     "button count of %d.\n", __func__, button_count,
>>>> +		     data->button_count);
>>>> +		retval = -EINVAL;
>>>> +		goto err_ret;
>>>> +	}
>>>> +
>>>> +	/* Clear the key bits for the old button map. */
>>>> +	for (i = 0; i<   button_count; i++)
>>>> +		clear_bit(data->button_map[i], data->input->keybit);
>>>> +
>>>> +	/* Switch to the new map. */
>>>> +	memcpy(data->button_map, temp_button_map,
>>>> +	       data->button_count);
>>>> +
>>>> +	/* Loop through the key map and set the key bit for the new mapping. */
>>>> +	for (i = 0; i<   button_count; i++)
>>>> +		set_bit(data->button_map[i], data->input->keybit);
>>>> +
>>>> +err_ret:
>>>> +	return retval;
>>>> +}
>>>
>>> Button map (keymap) should be manipulated with EVIOCGKEYCODE and
>>> EVIOCSKEYCODE ioctls, no need to invent driver-specific way of doing
>>> this.
>>
>> Makes sense, but... we had a customer request to specify the
>> boot-time keymap through the RMI4 driver's platform data.  Is it
>> legal to call setkeycode() to do that instead?
>
> No, the input device should be fully registered for that... But you can
> supply initial keymap in platform data, almost all drivers do that. It
> is new sysfs interface I object to here.

Thanks - we'll study this more closely.  I agree with not having another 
sysfs interface if the functionality is already there.  We just don't 
always realize that there is already an existing interface.
