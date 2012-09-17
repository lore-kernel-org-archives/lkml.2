Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2IQJ6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:58:06 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47486 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab2IQJ6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:58:05 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Jonathan Cameron <jic23@kernel.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] iio: inkern: put the IIO device when mem alloc gets
 failed
Thread-Topic: [PATCH 2/2] iio: inkern: put the IIO device when mem alloc
 gets failed
Thread-Index: Ac2UsLDnnWGaETPgRrGpn005azMcx///h7OA//95iwA=
Date: Mon, 17 Sep 2012 09:57:52 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF5120@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF50A5@DQHE02.ent.ti.com>
 <5056EE95.6050101@metafoo.de>
In-Reply-To: <5056EE95.6050101@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  drivers/iio/inkern.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
> > index 13748c0..aff034b 100644
> > --- a/drivers/iio/inkern.c
> > +++ b/drivers/iio/inkern.c
> > @@ -132,7 +132,7 @@ struct iio_channel *iio_channel_get(const char
> *name, const char *channel_name)
> >
> >  	channel = kzalloc(sizeof(*channel), GFP_KERNEL);
> >  	if (channel == NULL)
> > -		return ERR_PTR(-ENOMEM);
> > +		goto error_no_mem;
> >
> >  	channel->indio_dev = c->indio_dev;
> >
> > @@ -151,6 +151,9 @@ error_no_chan:
> >  	iio_device_put(c->indio_dev);
> >  	kfree(channel);
> >  	return ERR_PTR(-EINVAL);
> > +error_no_mem:
> > +	iio_device_put(c->indio_dev);
> > +	return ERR_PTR(-ENOMEM);
> >  }
> >  EXPORT_SYMBOL_GPL(iio_channel_get);
> >
> 
> If you do it that way, you don't really need the goto, something like
> 
> error_no_chan:
>   	kfree(channel);
> error_no_mem:
> 	iio_device_put(c->indio_dev);
> 	return ret
> 
> would be better in my opinion. With ret being initialized in the if
> branch
> before the goto.

Thanks for your opinion. I was hesitating before sending ;) 

The reason why this patch need separate goto statement is as below.
 
There are two different types when requesting the channel.
One is a pointer of iio_channel, the other is the error.
So return type will be two - allocated iio_channel and integer.
For simplicity, I would use just one return variable when it runs successfully.
In error cases, do return as explicit name such like ERR_PTR() rather than
saving into local integer.

Just my two cents.
But your code has better readability.

Thank you.

Best Regards,
Milo


