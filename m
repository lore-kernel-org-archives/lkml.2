Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923Ab2INIU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 04:20:58 -0400
Received: from ppsw-43.csi.cam.ac.uk ([131.111.8.143]:40971 "EHLO
	ppsw-43.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab2INIUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 04:20:52 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <5052E8E9.4030206@kernel.org>
Date: Fri, 14 Sep 2012 09:20:57 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Patil, Rachna" <rachna@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH v3 4/5] IIO : ADC: tiadc: Add support of TI's ADC driver
References: <1347532819-505-1-git-send-email-rachna@ti.com> <1347532819-505-5-git-send-email-rachna@ti.com> <5051CDEA.5080200@kernel.org> <4CE347531D4CA947960AF71FF095B9323E953D32@DBDE01.ent.ti.com>
In-Reply-To: <4CE347531D4CA947960AF71FF095B9323E953D32@DBDE01.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/09/12 07:00, Patil, Rachna wrote:
> On Thu, Sep 13, 2012 at 17:43:30, Jonathan Cameron wrote:
>> On 13/09/12 11:40, Patil, Rachna wrote:
>>> This patch adds support for TI's ADC driver.
>>> This is a multifunctional device.
>>> Analog input lines are provided on which voltage measurements can be
>>> carried out.
>>> You can have upto 8 input lines.
>>>
>>> Signed-off-by: Patil, Rachna <rachna@ti.com>
>>
>> There's a little fuzz in applying this due to other drivers that have gone in recently.
>>
>> Actually this is going to be 'interesting' to merge. Dmitry, Samuel thoughts on who takes this one and how?  Maybe this is a case for a 'special' branch pulled into more than one tree?
>>
>>
>> One minor thing inline.  I have an aversion to dynamic allocation of
>> things that are then constant.
>>
>> Also the module name is simply ti_adc. Does seem a little 'vague'
>> given the range of ADC's TI makes :)  Perhaps keep the reference
>> to the tsc in there?  Personally I'd have preferred the whole thing
>> being named after a particular part number (any one it support would
>> do) to avoid a clash in future with a new touch screen adc from TI.
>> Bit late for that though I guess ;)
>
> Yes, true.
> TI definitely might come up with more IP's of this type.
> This IP(TSC / ADC) is present on AM335x. If necessary we can rename the driver to ti_am335x_XXX.
I'd be in favour of doing this now rather than when the problem presents 
itself.  Anyone mind?
>
>>
>> Jonathan
>>> ---
>>> Changes in v2:
>>> 	Addressed review comments from Matthias Kaehlcke
>>>
>>> Changes in v3:
>>> 	Addressed review comments from Jonathan Cameron.
>>> 	Added comments, new line appropriately.
>>>
>>>    drivers/iio/adc/Kconfig              |    7 +
>>>    drivers/iio/adc/Makefile             |    1 +
>>>    drivers/iio/adc/ti_adc.c             |  223 ++++++++++++++++++++++++++++++++++
>>>    drivers/mfd/ti_tscadc.c              |   18 +++-
>>>    include/linux/mfd/ti_tscadc.h        |    9 ++-
>>>    include/linux/platform_data/ti_adc.h |   14 ++
>>>    6 files changed, 270 insertions(+), 2 deletions(-)
>>>    create mode 100644 drivers/iio/adc/ti_adc.c
>>>    create mode 100644 include/linux/platform_data/ti_adc.h
>>>
>>> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
>>> index 8a78b4f..ad32df8 100644
>>> --- a/drivers/iio/adc/Kconfig
>>> +++ b/drivers/iio/adc/Kconfig
>>> @@ -22,4 +22,11 @@ config AT91_ADC
>>>    	help
>>>    	  Say yes here to build support for Atmel AT91 ADC.
>>>
>>> +config TI_ADC
>>> +	tristate "TI's ADC driver"
>>> +	depends on ARCH_OMAP2PLUS
>>> +	help
>>> +	  Say yes here to build support for Texas Instruments ADC
>>> +	  driver which is also a MFD client.
>>> +
>>>    endmenu
>>> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
>>> index 52eec25..a930cee 100644
>>> --- a/drivers/iio/adc/Makefile
>>> +++ b/drivers/iio/adc/Makefile
>>> @@ -4,3 +4,4 @@
>>>
>>>    obj-$(CONFIG_AD7266) += ad7266.o
>>>    obj-$(CONFIG_AT91_ADC) += at91_adc.o
>>> +obj-$(CONFIG_TI_ADC) += ti_adc.o
>>> diff --git a/drivers/iio/adc/ti_adc.c b/drivers/iio/adc/ti_adc.c
>>> new file mode 100644
>>> index 0000000..56f8af2
>>> --- /dev/null
>>> +++ b/drivers/iio/adc/ti_adc.c
>>> @@ -0,0 +1,223 @@
>>> +/*
>>> + * TI ADC MFD driver
>>> + *
>>> + * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
>>> + *
>>> + * This program is free software; you can redistribute it and/or
>>> + * modify it under the terms of the GNU General Public License as
>>> + * published by the Free Software Foundation version 2.
>>> + *
>>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>>> + * kind, whether express or implied; without even the implied warranty
>>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + */
>>> +
>>> +#include <linux/init.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/err.h>
>>> +#include <linux/module.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/interrupt.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/io.h>
>>> +#include <linux/iio/iio.h>
>>> +
>>> +#include <linux/mfd/ti_tscadc.h>
>>> +#include <linux/platform_data/ti_adc.h>
>>> +
>>> +struct adc_device {
>>> +	struct ti_tscadc_dev *mfd_tscadc;
>>> +	struct iio_dev *idev;
>>> +	int channels;
>>> +};
>>> +
>>> +static unsigned int adc_readl(struct adc_device *adc, unsigned int reg)
>>> +{
>>> +	return readl(adc->mfd_tscadc->tscadc_base + reg);
>>> +}
>>> +
>>> +static void adc_writel(struct adc_device *adc, unsigned int reg,
>>> +					unsigned int val)
>>> +{
>>> +	writel(val, adc->mfd_tscadc->tscadc_base + reg);
>>> +}
>>> +
>>> +static void adc_step_config(struct adc_device *adc_dev)
>>> +{
>>> +	unsigned int    stepconfig;
>>> +	int i, channels = 0, steps;
>>> +
>>> +	/*
>>> +	 * There are 16 configurable steps and 8 analog input
>>> +	 * lines available which are shared between Touchscreen and ADC.
>>> +	 *
>>> +	 * Steps backwards i.e. from 16 towards 0 are used by ADC
>>> +	 * depending on number of input lines needed.
>>> +	 * Channel would represent which analog input
>>> +	 * needs to be given to ADC to digitalize data.
>>> +	 */
>>> +
>>> +	steps = TOTAL_STEPS - adc_dev->channels;
>>> +	channels = TOTAL_CHANNELS - adc_dev->channels;
>>> +
>>> +	stepconfig = STEPCONFIG_AVG_16 | STEPCONFIG_FIFO1;
>>> +
>>> +	for (i = (steps + 1); i <= TOTAL_STEPS; i++) {
>>> +		adc_writel(adc_dev, REG_STEPCONFIG(i),
>>> +				stepconfig | STEPCONFIG_INP(channels));
>>> +		adc_writel(adc_dev, REG_STEPDELAY(i),
>>> +				STEPCONFIG_OPENDLY);
>>> +		channels++;
>>> +	}
>>> +	adc_writel(adc_dev, REG_SE, STPENB_STEPENB);
>>> +}
>>> +
>>> +static int tiadc_channel_init(struct iio_dev *idev, int channels)
>>> +{
>>> +	struct iio_chan_spec *chan_array;
>>> +	int i;
>>> +
>>> +	idev->num_channels = channels;
>>> +	chan_array = kcalloc(idev->num_channels, sizeof(struct iio_chan_spec),
>>> +					GFP_KERNEL);
>>> +
>>> +	if (chan_array == NULL)
>>> +		return -ENOMEM;
>>> +
>> Minor point, but I'd be tempted to do this as a static const array and
>> then just set num_channels appropriately.  Still it's such a simple
>> driver that I'm not that fussed.
>
> I looked at some other drivers, they seem to be doing the same way.
> I would like to go with the existing convention.
>
>>> +	for (i = 0; i < (idev->num_channels); i++) {
>>> +		struct iio_chan_spec *chan = chan_array + i;
>>> +		chan->type = IIO_VOLTAGE;
>>> +		chan->indexed = 1;
>>> +		chan->channel = i;
>>> +		chan->info_mask = IIO_CHAN_INFO_RAW_SEPARATE_BIT;
>>> +	}
>>> +
>>> +	idev->channels = chan_array;
>>> +
>>> +	return idev->num_channels;
>>> +}
>>> +
>
> Regards,
> Rachna
>

