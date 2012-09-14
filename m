Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153Ab2INA7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 20:59:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57335 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757627Ab2INA7V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 20:59:21 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
CC: Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] iio: inkern: add error case in iio_channel_get()
Thread-Topic: [PATCH 2/2] iio: inkern: add error case in iio_channel_get()
Thread-Index: Ac2PKqkZZFI0lKCnQcyWC+Ovo9lkG///jomA//nBTOA=
Date: Fri, 14 Sep 2012 00:59:01 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF4C19@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF45EB@DQHE02.ent.ti.com>
 <504DAFF7.1070902@jic23.retrosnub.co.uk>
In-Reply-To: <504DAFF7.1070902@jic23.retrosnub.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 10/09/12 09:02, Kim, Milo wrote:
> >   The datasheet name is defined in the IIO driver.
> >   On the other hand, the adc_channel_label is configured in
> >   the platform machine side.
> >   If the datasheet name is not matched with any adc_channel_label,
> >   the iio_channel_get() should be returned as error for preventing
> >   using invalid IIO channel data.
> >
> >   Moreover, this patch detects NULL pointer dereference problem at
> early time.
> >   In general, the IIO driver just accesses to any member of the
> iio_chan_spec
> >   in own xxx_read_raw() function.
> >   If the iio_chan_spec is invalid pointer, NULL dereference problem
> may occur
> >   such like 'iio_chan_spec->channel' or 'iio_chan_spec->type'.
> >   If the iio_channel_get() gets failed in the IIO consumer,
> >   then no read_raw() operation proceeds.

> I guess this is marginally cleaner, but either way it is up to the
> calling driver to check whether the call succeeded.

IMO, it would be better if iio_channel_get() gets failed
when the consumer tries to get the channel rather than when using it.

The channel spec is retrieved when the channel is requested, - iio_channel_get()
So it's reasonable if error returns in case of invalid channel spcec.

And I just found similar handling in iio_channel_get_all().
But my patch needs releasing the memory as Lars-Peter noted.

Thanks !

Best Regards,
Milo 

> >
> > Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> > ---
> >   drivers/iio/inkern.c |    6 +++++-
> >   1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
> > index 1faa240..a5caf6b 100644
> > --- a/drivers/iio/inkern.c
> > +++ b/drivers/iio/inkern.c
> > @@ -136,11 +136,15 @@ struct iio_channel *iio_channel_get(const char
> *name, const char *channel_name)
> >
> >   	channel->indio_dev = c->indio_dev;
> >
> > -	if (c->map->adc_channel_label)
> > +	if (c->map->adc_channel_label) {
> >   		channel->channel =
> >   			iio_chan_spec_from_name(channel->indio_dev,
> >   						c->map->adc_channel_label);
> >
> > +		if (channel->channel == NULL)
> > +			return ERR_PTR(-ENODEV);
> > +	}
> > +
> >   	return channel;
> >   }
> >   EXPORT_SYMBOL_GPL(iio_channel_get);
> >

