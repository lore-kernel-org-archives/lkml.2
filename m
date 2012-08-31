Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab2HaKkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 06:40:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48204 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab2HaKkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 06:40:46 -0400
From: "Patil, Rachna" <rachna@ti.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: RE: [PATCH v2 4/5] IIO : ADC: tiadc: Add support of TI's ADC driver
Thread-Topic: [PATCH v2 4/5] IIO : ADC: tiadc: Add support of TI's ADC driver
Thread-Index: AQHNhoTdA8S9lxwKiEi2CkRB2LfDqJdyZc+AgADrAtA=
Date: Fri, 31 Aug 2012 10:39:27 +0000
Message-ID: <4CE347531D4CA947960AF71FF095B9323E950B55@DBDE01.ent.ti.com>
References: <1346312306-21082-1-git-send-email-rachna@ti.com>
 <1346312306-21082-5-git-send-email-rachna@ti.com>
 <503FC209.8010802@kernel.org>
In-Reply-To: <503FC209.8010802@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 31, 2012 at 01:12:01, Jonathan Cameron wrote:
> On 08/30/2012 08:38 AM, Patil, Rachna wrote:
> > This patch adds support for TI's ADC driver.
> > This is a multifunctional device.
> > Analog input lines are provided on which voltage measurements can be 
> > carried out.
> > You can have upto 8 input lines.
> >
> Nice concise driver.
> 
> A few comments and questions inline.  Nothing significant really though...  Half of them are me wanting to improve my understanding of what is going on (and not have to remember it in the future ;)

Thanks for the comments. Please find my reply inline.

> 
> > Signed-off-by: Patil, Rachna <rachna@ti.com>
> > ---
> > Changes in v2:
> > 	Addressed review comments from Matthias Kaehlcke
> >
> >  drivers/iio/adc/Kconfig              |    7 +
> >  drivers/iio/adc/Makefile             |    1 +
> >  drivers/iio/adc/ti_adc.c             |  216 ++++++++++++++++++++++++++++++++++
> >  drivers/mfd/ti_tscadc.c              |   18 +++-
> >  include/linux/mfd/ti_tscadc.h        |    9 ++-
> >  include/linux/platform_data/ti_adc.h |   14 ++
> >  6 files changed, 263 insertions(+), 2 deletions(-)  create mode 
> > 100644 drivers/iio/adc/ti_adc.c  create mode 100644 
> > include/linux/platform_data/ti_adc.h
> >
> > diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig index 
> > 8a78b4f..ad32df8 100644
> > --- a/drivers/iio/adc/Kconfig
> > +++ b/drivers/iio/adc/Kconfig
> > @@ -22,4 +22,11 @@ config AT91_ADC
> >  	help
> >  	  Say yes here to build support for Atmel AT91 ADC.
> >
> > +config TI_ADC
> > +	tristate "TI's ADC driver"
> > +	depends on ARCH_OMAP2PLUS
> > +	help
> > +	  Say yes here to build support for Texas Instruments ADC
> > +	  driver which is also a MFD client.
> > +
> >  endmenu
> > diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile index 
> > 52eec25..a930cee 100644
> > --- a/drivers/iio/adc/Makefile
> > +++ b/drivers/iio/adc/Makefile
> > @@ -4,3 +4,4 @@
> >
> >  obj-$(CONFIG_AD7266) += ad7266.o
> >  obj-$(CONFIG_AT91_ADC) += at91_adc.o
> > +obj-$(CONFIG_TI_ADC) += ti_adc.o
> > diff --git a/drivers/iio/adc/ti_adc.c b/drivers/iio/adc/ti_adc.c new 
> > file mode 100644 index 0000000..d2e621c
> > --- /dev/null
> > +++ b/drivers/iio/adc/ti_adc.c
> > @@ -0,0 +1,216 @@
> > +/*
> > + * TI ADC MFD driver
> > + *
> > + * Copyright (C) 2012 Texas Instruments Incorporated - 
> > +http://www.ti.com/
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation version 2.
> > + *
> > + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> > + * kind, whether express or implied; without even the implied 
> > +warranty
> > + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/kernel.h>
> > +#include <linux/err.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/io.h>
> > +#include <linux/iio/iio.h>
> > +
> > +#include <linux/mfd/ti_tscadc.h>
> > +#include <linux/platform_data/ti_adc.h>
> > +
> > +struct adc_device {
> > +	struct ti_tscadc_dev *mfd_tscadc;
> > +	struct iio_dev *idev;
> > +	int channels;
> > +};
> > +
> > +static unsigned int adc_readl(struct adc_device *adc, unsigned int 
> > +reg) {
> > +	return readl(adc->mfd_tscadc->tscadc_base + reg); }
> > +
> > +static void adc_writel(struct adc_device *adc, unsigned int reg,
> > +					unsigned int val)
> > +{
> > +	writel(val, adc->mfd_tscadc->tscadc_base + reg); }
> > +
> > +static void adc_step_config(struct adc_device *adc_dev) {
> > +	unsigned int    stepconfig;
> > +	int i, channels = 0, steps;
> > +
> > +	/*
> 
> Don't suppose you could tell us what the steps actually are?
> It's not a term I've come across before and right now I can't seem to find the relevant datasheet (and am inherently lazy ;)

The user must first program the Step Configuration registers in order to configure a channel input to be sampled. There are 16 programmable Step Configuration registers which are used by the sequencer to control which switches to turn on or off (inputs to the Analog front end used for touchscreen), which channel to sample, and which mode to use (HW triggered or SW enabled, one-shot or continuous mode), averaging, where to save the FIFO data, etc. The sequencer is completely controlled by software and behaves accordingly to how the Step Registers are programmed. A step is the general term for sampling a channel input.

> 
> > +	 * There are 16 configurable steps and 8 analog input
> > +	 * lines available which are shared between Touchscreen and ADC.
> > +	 *
> > +	 * Steps backwards i.e. from 16 towards 0 are used by ADC
> > +	 * depending on number of input lines needed.
> > +	 * Channel would represent which analog input
> > +	 * needs to be given to ADC to digitalize data.
> > +	 */
> > +
> > +	steps = TOTAL_STEPS - adc_dev->channels;
> > +	channels = TOTAL_CHANNELS - adc_dev->channels;
> > +
> > +	stepconfig = STEPCONFIG_AVG_16 | STEPCONFIG_FIFO1;
> > +
> > +	for (i = (steps + 1); i <= TOTAL_STEPS; i++) {
> > +		adc_writel(adc_dev, REG_STEPCONFIG(i),
> > +				stepconfig | STEPCONFIG_INP(channels));
> > +		adc_writel(adc_dev, REG_STEPDELAY(i),
> > +				STEPCONFIG_OPENDLY);
> > +		channels++;
> > +	}
> > +	adc_writel(adc_dev, REG_SE, STPENB_STEPENB); }
> > +
> > +static int tiadc_channel_init(struct iio_dev *idev, struct adc_device 
> > +*adc_dev) {
> > +	struct iio_chan_spec *chan_array;
> > +	int i;
> > +
> > +	idev->num_channels = adc_dev->channels;
> Given adc_dev is just used for this why not just pass in the number of channels?

Yes, I can just pass the channel information directly.

> 
> > +	chan_array = kcalloc(idev->num_channels, sizeof(struct iio_chan_spec),
> > +					GFP_KERNEL);
> > +
> > +	if (chan_array == NULL)
> > +		return -ENOMEM;
> > +
> > +	for (i = 0; i < (idev->num_channels); i++) {
> > +		struct iio_chan_spec *chan = chan_array + i;
> > +		chan->type = IIO_VOLTAGE;
> > +		chan->indexed = 1;
> > +		chan->channel = i;
> You don't use the buffered interfaces so don't need anything below here.

Ok. I will drop this.

> > +		chan->scan_type.sign = 'u';
> > +		chan->scan_type.realbits = 12;
> > +		chan->scan_type.storagebits = 32;
> > +		chan->scan_type.shift = 0;
> > +	}
> > +
> > +	idev->channels = chan_array;
> whilst not critical it's a nice convention to drop in a blank line before return statements..  Just makes it slightly easier to parse.

Ok. I will add blank line here.

> > +	return idev->num_channels;
> > +}
> > +
> channels would be slightly more acurate I think...

True, I will change this.

> > +static void tiadc_channel_remove(struct iio_dev *idev) {
> > +	kfree(idev->channels);
> > +}
> > +
> > +static int tiadc_read_raw(struct iio_dev *idev,
> > +		struct iio_chan_spec const *chan,
> > +		int *val, int *val2, long mask)
> > +{
> > +	struct adc_device *adc_dev = iio_priv(idev);
> > +	int i;
> > +	unsigned int fifo1count, readx1;
> > +
> Given adc_dev is only passed directly to adc_readl and adc_writel you could make those functions take the iio_dev instead..

adc_dev holds base address of registers to be accessed. Passing iio_dev does not serve the purpose.

> > +	fifo1count = adc_readl(adc_dev, REG_FIFO1CNT);
> What are the semantics of this?  Is the channel guaranteed to be there?  Is this just about ensuring we always get the latest reading?
> This is definitely a case where a little commenting would help the reader :)

This is not a channel. Here I am reading number of words present in FIFO1.
The IP has 2 FIFO's and ADC uses FIFO1.
In the next steps I read all the data in FIFO1, and return only the ADC value of channel user has asked for.
The IP has a sequencer which starts from the 1st step configured. If one has configured for all 8 channels available and is trying to read
Data on only one of the lines, Data pertaining to other lines is also still generated.
We need to flush this data, so that when user tries to access any other channel, the latest value on the channel is read.
 
I will add comments here.

> > +	for (i = 0; i < fifo1count; i++) {
> > +		readx1 = adc_readl(adc_dev, REG_FIFO1);
> > +		if (i == chan->channel) {
> > +			readx1 = readx1 & 0xfff;
> > +			*val = readx1;
> might as well combine the two lines above...

Yes. I can do this.

> > +		}
> > +	}
> > +	adc_writel(adc_dev, REG_SE, STPENB_STEPENB);
> > +	return IIO_VAL_INT;
> > +}
> > +
> > +static const struct iio_info tiadc_info = {
> > +	.read_raw = &tiadc_read_raw,
> > +};
> > +
> > +static int __devinit tiadc_probe(struct platform_device *pdev) {
> > +	struct iio_dev		*idev;
> > +	int			err;
> > +	struct adc_device	*adc_dev = NULL;
> I don't think there is any reason to initialize adc_dev...

Ok. I will drop this.

> 
> > +	struct ti_tscadc_dev	*tscadc_dev = pdev->dev.platform_data;
> > +	struct mfd_tscadc_board	*pdata;
> > +
> > +	pdata = (struct mfd_tscadc_board *)tscadc_dev->dev->platform_data;
> > +	if (!pdata || !pdata->adc_init) {
> > +		dev_err(tscadc_dev->dev, "Could not find platform data\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	idev = iio_device_alloc(sizeof(struct adc_device));
> > +	if (idev == NULL) {
> > +		dev_err(&pdev->dev, "failed to allocate iio device.\n");
> > +		err = -ENOMEM;
> > +		goto err_allocate;
> > +	}
> > +	adc_dev = iio_priv(idev);
> > +
> > +	tscadc_dev->adc = adc_dev;
> > +	adc_dev->mfd_tscadc = tscadc_dev;
> > +	adc_dev->idev = idev;
> 
> hmm.. this is getting a bit circular...  You could store the iio_dev pointer in tscadc_dev intead of the adc_dev one thus I think avoiding the need for this..  Still I guess it may be best to leave it as it currently is for consistency with the input driver.

Yes, this is in consistence with input driver.

<SNIP>

Regards,
Rachna

