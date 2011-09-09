Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab1IIFHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 01:07:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50603 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab1IIFHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 01:07:17 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7b7fae000005864-08-4e699f03b5ef
Message-id: <4E699EDD.1010601@samsung.com>
Date: Fri, 09 Sep 2011 14:06:37 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110419
 Thunderbird/3.1.9
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        akpm@linux-foundation.org, gregkh@suse.de, kyungmin.park@samsung.com
Subject: Re: [PATCH] misc: Add driver for GP2AP002 proximity/ambient light
 sensor
References: <1315479654-19836-1-git-send-email-dg77.kim@samsung.com>
 <4E68D04F.40506@cam.ac.uk>
In-reply-to: <4E68D04F.40506@cam.ac.uk>
X-OriginalArrivalTime: 09 Sep 2011 05:07:49.0161 (UTC)
 FILETIME=[6B5E5190:01CC6EAE]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011년 09월 08일 23:25, Jonathan Cameron wrote:
>> +This chip only exports current as the result of ambient light sensor.
>> +To get illuminance, CPU measures the current exported
>> +from the sensor through ADC.
>> +The relationship between current and illuminance is as follows:
>> +	illuminance = 10^(current/10)  - (1)
>> +This driver only exposes the measured current.
>> +Illuminance should be calculated at the user space by (1) formula.
>> +
>> +Sysfs Interface
>> +---------------
>> +prox0_input	proximity sensor result
>> +		0: object is not detected
>> +		1: object is detected
>> +		RO
>> +
>> +adc0_input	ADC result for ambient light sensor
>> +		current [unit: uA]
>> +		RO
> My issue here is generality.  To use this value userspace needs to
> have the conversion function. That means a large library of
> conversion functions for every sensor out there. Does such a thing
> exist?  For sensors like this we have typically done the maths
> in kernel simply to avoid the issue (be it somewhat hideous!)
> 
> Also it's really not a general adc so that name is missleading.
> At very least call it curr0_input to match (more or less hwmon).
> 
I don't have good idea to handle this.
A current-illuminance mapping table can be used.
But I guess the illuminance may be the approximate value when handling
in kernel by using current-illuminance mapping table.
>> +static void gp2ap002_get_proximity(struct gp2ap002_chip *chip)
>> +{
>> +	struct gp2ap002_platform_data *pdata = chip->pdata;
>> +	int prox_mode;
>> +
>> +	prox_mode = pdata->prox_mode << OPMOD_VCON_SHIFT;
>> +	/* interrupt output mode */
>> +	if ((prox_mode & OPMOD_VCON_MASK) == OPMOD_VCON_IRQ) {
>> +		/* Determine whether the object is detected
>> +		   by reading proximity output register */
>> +		chip->proximity = i2c_smbus_read_byte_data(chip->client,
>> +					GP2AP002_PROX) & PROX_VO_DETECT;
>> +	} else { /* normal output mode */
>> +		/* vo_gpio is changed from high to low
>> +		   when the object is detected */
>> +		chip->proximity = !gpio_get_value(pdata->vout_gpio);
>> +	}
> Silly question but is the value really not available in that register
> if we aren't in interrupt mode?  Seems 'odd', but then it's hardware so
> what the heck.  If it is I'd just always read that register so as to
> have cleaner code (at the cost of a small bus transaction).
I overlooked that gpio value and register value can be read for
proximity sensing results. So, this should be changed to access the
register.
>> +}
>> +
>> +static int gp2ap002_chip_enable(struct gp2ap002_chip *chip, bool enable)
>> +{
>> +	struct gp2ap002_platform_data *pdata = chip->pdata;
>> +	int ret;
>> +	u8 value;
>> +
>> +	if (enable == chip->enabled)
>> +		return 0;
>> +
>> +	value = (pdata->analog_sleep << OPMOD_ASD_SHIFT) |
>> +		(pdata->prox_mode << OPMOD_VCON_SHIFT);
>> +	/* software shutdown mode */
>> +	if (enable)
>> +		value |= OPMOD_SSD_OPERATING;
>> +	else /* operating mode */
>> +		value |= OPMOD_SSD_SHUTDOWN;
>> +
>> +	ret = i2c_smbus_write_byte_data(chip->client, GP2AP002_OPMOD, value);
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	chip->enabled = enable;
>> +out:
>> +	return ret;
>> +}
>> +
>> +static void gp2ap002_work(struct work_struct *work)
>> +{
>> +	struct gp2ap002_chip *chip = container_of(work,
>> +			struct gp2ap002_chip, work);
>> +
>> +	mutex_lock(&chip->lock);
>> +	gp2ap002_get_proximity(chip);
>> +
>> +	kobject_uevent(&chip->client->dev.kobj, KOBJ_CHANGE);
> as you can poll on sysfs files, would it not be cleaner to use
> that interface to tell userspace there are new values?
I will add sysfs_notify function for sysfs files.
>> +	if (client->irq > 0) {
>> +		unsigned long irq_flag = IRQF_DISABLED;
>> +
> Could do with some explanation. I have no idea what VCON is!
I don't exactly know what VCON stands for. I just followed the name in
datasheet.
This chip can be set to operate interrupt mode or normal mode.
The macros having OPMOD_VCON_ prefix is related to interrupt or normal mode.
But the following code should be changed to only set flags as
IRQF_TRIGGER_FALLING.
>> +		if (chip->mode == OPMOD_VCON_IRQ)
>> +			irq_flag |= IRQF_TRIGGER_FALLING;
>> +		else
>> +			irq_flag |= IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING;
>> +
>   WHy not threaded?
I should have used threaded function. I will change it.
> None of these needs to be int as far as I can see so 
> you might as well make them u8s/u16s or bitfields of
> the right size.
>> +	int led_mode;
>> +	int hysd;
>> +	int hysc;
>> +	int hysf;
>> +	int cycle;
>> +	int oscillator;
>> +	int analog_sleep;
>> +	int prox_mode;
>> +	int vout_control;
>> +
>> +	bool chip_enable;
>> +};
>> +
>> +#endif
> 
It would be better to change the data type.

Thank you for your review.


