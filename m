Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab0FEVG6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 17:06:58 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:53012 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658Ab0FEVG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 17:06:57 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C0ABC75.9020908@jic23.retrosnub.co.uk>
Date: Sat, 05 Jun 2010 22:07:01 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100426 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [RFC][PATCH 22/26] hwmon: Add JZ4740 ADC driver
References: <1275505397-16758-1-git-send-email-lars@metafoo.de>	<1275505950-17334-6-git-send-email-lars@metafoo.de>	<4C0A87F1.8000201@jic23.retrosnub.co.uk> <4C0AA0CA.9020808@metafoo.de>
In-Reply-To: <4C0AA0CA.9020808@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/10 20:08, Lars-Peter Clausen wrote:
> Hi
> 
> Jonathan Cameron wrote:
>> On 06/02/10 20:12, Lars-Peter Clausen wrote:
>>   
>>> This patch adds support for the ADC module on JZ4740 SoCs.
>>>
>>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>>> Cc: lm-sensors@lm-sensors.org
>>> ---
>>>  drivers/hwmon/Kconfig      |   11 ++
>>>  drivers/hwmon/Makefile     |    1 +
>>>  drivers/hwmon/jz4740-adc.c |  423 ++++++++++++++++++++++++++++++++++++++++++++
>>>  include/linux/jz4740-adc.h |   25 +++
>>>  4 files changed, 460 insertions(+), 0 deletions(-)
>>>  create mode 100644 drivers/hwmon/jz4740-adc.c
>>>  create mode 100644 include/linux/jz4740-adc.h
>>>     
>> Hi, I'm just wondering of one wants the majority of this driver to sit in hwmon?
>>
>> Looks to me like a fairly classic case for something that might be best implemented
>> as an mfd with the hwmon, touchscreen and battery drivers separately hanging off that.
>> You might well have someone who needs the battery driver to work, but doesn't care
>> about hwmon and so doesn't want to build that bit in... 
>>
>> Just an immediate thought.  Perhaps this is the best way to do things...
>>   
> I've thought about it before and rejected the idea at that time, because
> I thought it will add more abstraction then actually needed.
> But at that time the adc driver was not a hwmon driver yet and thus
> didn't pull in the whole hwmon framework if you only wanted to use the
> battery driver.
> But the more I'm thinking about it now it might actually make sense to
> move the common code to a MFD driver.
>> Also after a quick look.  How is it used by the touchscreen driver?
>> If not, please remove the reference from kconfig until it it is true.
>>   
> There is no touchscreen driver yet. But if I'm going to remove the
> reference I'm pretty sure that someone will come up and ask why it
> actually is necessary to have a separate driver instead of putting all
> the code into the battery driver.
Fair enough.  Perhaps a comment for the patch rather than in Kconfig
as it currently is.  People will enable it then go 'Why can't I now
enable the touchscreen driver?'

>> Few other bits and bobs inline.
>>   
>>>
>>> diff --git a/drivers/hwmon/jz4740-adc.c b/drivers/hwmon/jz4740-adc.c
>>> new file mode 100644
>>> index 0000000..635dfe9
>>> --- /dev/null
>>> +++ b/drivers/hwmon/jz4740-adc.c
>>> @@ -0,0 +1,423 @@
>>> + [...]
>>> +static ssize_t jz4740_adc_read_adcin(struct device *dev,
>>> +					struct device_attribute *dev_attr,
>>> +					char *buf)
>>> +{
>>> +	struct jz4740_adc *adc = dev_get_drvdata(dev);
>>> +	unsigned long t;
>>> +	uint16_t val;
>>> +
>>> +	jz4740_adc_clk_enable(adc);
>>> +
>>>     
>> Is there a possible race here?
>>   
> Where exactly?
I can't recall off the top of my head if sysfs attributes can having multiple
simultaneous readers. If they can then thread two is just past the next line.
Whilst the earlier thread has passed the t = wait.... line as the interrupt has
fired.  The irq is then disabled by thread 1 whilst thread 2 enables the adc.
Clearly the timeout will prevent any serious issues but the 2nd thread is going
to falsely wait a second I think... ?
>>> +	jz4740_adc_enable_irq(adc, JZ_ADC_IRQ_ADCIN);
>>> +	jz4740_adc_enable_adc(adc, JZ_ADC_ENABLE_ADCIN);
>>> +
>>> +	t = wait_for_completion_interruptible_timeout(&adc->adc_completion,
>>> +							HZ);
>>> +
>>> +	jz4740_adc_disable_irq(adc, JZ_ADC_IRQ_ADCIN);
>>> +
>>> +	if (t <= 0) {
>>> +		jz4740_adc_disable_adc(adc, JZ_ADC_ENABLE_ADCIN);
>>> +		return t ? t : -ETIMEDOUT;
>>> +	}
>>> +
>>> +	val = readw(adc->base + JZ_REG_ADC_ADCIN);
>>> +	jz4740_adc_clk_disable(adc);
>>> +
>>>     
>> Does this device really use units of milivolts? (standard in hwmon).
>> I couldn't confirm either way via quick googling.
>>   
> Hm, right, it does not. Interestingly the datasheet does not tell the
> unit of the returned data, but I found a formula in the datasheet for a
> similar SoC.
>>> +	return sprintf(buf, "%d\n", val);
>>> +}
>>> +
>>> + [...]
>>>     
> Thanks for reviewing the patch.
You are welcome.
