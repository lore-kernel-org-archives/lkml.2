Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab1KRJvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:51:31 -0500
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:50216 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab1KRJv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:51:29 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: 18 Nov 2011 09:51:24 +0000
From: "J.I. Cameron" <jic23@cam.ac.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, drivers@analog.com
Subject: Re: [PATCH 7/7] staging:iio:dac: Add AD5380 driver
Message-ID: <Prayer.1.3.4.1111180951240.21154@hermes-2.csi.cam.ac.uk>
In-Reply-To: <4EC62098.9030406@metafoo.de>
References: <1321457302-8724-1-git-send-email-lars@metafoo.de>
 <1321457302-8724-7-git-send-email-lars@metafoo.de>
 <4EC56D7B.9080700@kernel.org>
 <4EC62098.9030406@metafoo.de>
X-Mailer: Prayer v1.3.4
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 18 2011, Lars-Peter Clausen wrote:

>On 11/17/2011 09:24 PM, Jonathan Cameron wrote:
>> On 11/16/2011 03:28 PM, Lars-Peter Clausen wrote:
>>> This patch adds support for the Analog Devices D5380, AD5381,
>>> AD5382, AD5383, AD5384, AD5390, AD5391, AD5392 multi-channel
>>> Digital to Analog Converters.
>>>
>>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>>>
>>> --- There should be no compile time dependencies to the regmap patches 
>>> earlier in this series, so this patch can be merged independently of 
>>> it.
>> Should probably have been a separate series!  Doesn't matter for review
>> though and I guess you justified some of the other patches with it.
>>> ---
>>>  drivers/staging/iio/dac/Kconfig  |   11 +
>>>  drivers/staging/iio/dac/Makefile |    1 +
>>>  drivers/staging/iio/dac/ad5380.c | 669 
>>> ++++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 681 insertions(+), 0 deletions(-)
>>>  create mode 100644 drivers/staging/iio/dac/ad5380.c
>>>[...]
>>> +
>>> +static ssize_t ad5380_write_powerdown_mode(struct device *dev,
>>> +	struct device_attribute *attr, const char *buf, size_t len)
>>> +{
>>> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +	struct ad5380_state *st = iio_priv(indio_dev);
>>> +	unsigned int i;
>>> +	int ret;
>>> +
>> Excess brackets for that for loop I think
>
>I prefer to have them since the loop contains a multiple lines.
Hmm.. might be out of coding standard, but only just so fine...
>
>>> +	for (i = 0; i < ARRAY_SIZE(ad5380_powerdown_modes); ++i) {
>>> +		if (sysfs_streq(buf, ad5380_powerdown_modes[i]))
>>> +			break;
>>> +	}
>>> +
>>> +	if (i == ARRAY_SIZE(ad5380_powerdown_modes))
>>> +		return -EINVAL;
>>> +
>>> +	ret = regmap_update_bits(st->regmap, AD5380_REG_SF_CTRL,
>>> +		1 << AD5380_CTRL_PWR_DOWN_MODE_OFFSET,
>>> +		i << AD5380_CTRL_PWR_DOWN_MODE_OFFSET);
>> Obviously both of these will be cleaner with it as a bit.
>
>When writing this using BIT it would be i ? AD5380_CTRL_PWR_DOWN_MODE_BIT :
>0... And also this is about semantics. The other bits are bits in the sense
>of true/false. While this is an enumeration which just happens to have only
>one bit. But I can change it, if you prefer using BIT here.
Gah, I read them as both 1 <<. oops. you are of course correct that my
suggestion makes no sense so don't worry about that!
>
>>> +
>>> +	return ret ? ret : len;
>>> +}
>>> +
>> Not a comment on this driver, but we need to have a think about
>> whether these will ever want to be controlled via in kernel
>> interfaces and if so how the heck we are going to do it!
>
> Yes, definitely. But I think it is best to discuss this in a separate 
> thread.
Agreed. Feel free to start it ;)
>
>>> +static IIO_DEVICE_ATTR(out_voltage_powerdown_mode,
>>> +			S_IRUGO | S_IWUSR,
>>> +			ad5380_read_powerdown_mode,
>>> +			ad5380_write_powerdown_mode, 0);
>>> +
>>> +static IIO_CONST_ATTR(out_voltage_powerdown_mode_available,
>>> +			"100kohm_to_gnd three_state");
>>> +
>>> +static struct attribute *ad5380_attributes[] = {
>>> +	&iio_dev_attr_out_voltage_powerdown.dev_attr.attr,
>>> +	&iio_dev_attr_out_voltage_powerdown_mode.dev_attr.attr,
>>> +	&iio_const_attr_out_voltage_powerdown_mode_available.dev_attr.attr,
>>> +	NULL,
>>> +};
>> [...]
>>> +static const struct i2c_device_id ad5380_i2c_ids[] = {
>>> +	{ "ad5380-3", ID_AD5380_3 },
>>> +	{ "ad5380-5", ID_AD5380_5 },
>>> +	{ "ad5381-3", ID_AD5381_3 },
>>> +	{ "ad5381-5", ID_AD5381_5 },
>>> +	{ "ad5382-3", ID_AD5382_3 },
>>> +	{ "ad5382-5", ID_AD5382_5 },
>>> +	{ "ad5383-3", ID_AD5383_3 },
>>> +	{ "ad5383-5", ID_AD5383_5 },
>>> +	{ "ad5390-3", ID_AD5380_3 },
>>> +	{ "ad5390-5", ID_AD5380_5 },
>>> +	{ "ad5391-3", ID_AD5381_3 },
>>> +	{ "ad5391-5", ID_AD5381_5 },
>>> +	{ "ad5392-3", ID_AD5382_3 },
>>> +	{ "ad5392-5", ID_AD5382_5 },
>> I'm guessing you defined the ID_AD5392 etc for a reason?
>
>Ooops, yes. Good catch.
>
>Thanks for the review.
You are welcome.
