Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab0HVL6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 07:58:30 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:31498 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab0HVL62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 07:58:28 -0400
Date: Sun, 22 Aug 2010 13:58:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Axel Lin <axel.lin@gmail.com>, Paul Thomas <pthomas8589@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2] hwmon: (ads7871) Fix ads7871_probe  error path
Message-ID: <20100822135801.4861066d@hyperion.delvare>
In-Reply-To: <20100817161048.51b42394@hyperion.delvare>
References: <1282048884.2626.2.camel@phoenix>
	<20100817161048.51b42394@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel, Paul,

On Tue, 17 Aug 2010 16:10:48 +0200, Jean Delvare wrote:
> On Tue, 17 Aug 2010 20:41:24 +0800, Axel Lin wrote:
> > This patch moves hwmon_device_register() to the end of ads7871_probe().
> > So we can make sure the device exists and is properly initialized
> > before the device is exposed to user-space.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > ---
> >  drivers/hwmon/ads7871.c |   12 ++++++------
> >  1 files changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/hwmon/ads7871.c b/drivers/hwmon/ads7871.c
> > index b300a20..45f5829 100644
> > --- a/drivers/hwmon/ads7871.c
> > +++ b/drivers/hwmon/ads7871.c
> > @@ -176,12 +176,6 @@ static int __devinit ads7871_probe(struct spi_device *spi)
> >  	if (status < 0)
> >  		goto error_free;
> >  
> > -	pdata->hwmon_dev = hwmon_device_register(&spi->dev);
> > -	if (IS_ERR(pdata->hwmon_dev)) {
> > -		err = PTR_ERR(pdata->hwmon_dev);
> > -		goto error_remove;
> > -	}
> > -
> >  	spi_set_drvdata(spi, pdata);
> >  
> >  	/* Configure the SPI bus */
> > @@ -204,6 +198,12 @@ static int __devinit ads7871_probe(struct spi_device *spi)
> >  		goto error_remove;
> >  	}
> >  
> > +	pdata->hwmon_dev = hwmon_device_register(&spi->dev);
> > +	if (IS_ERR(pdata->hwmon_dev)) {
> > +		err = PTR_ERR(pdata->hwmon_dev);
> > +		goto error_remove;
> > +	}
> > +
> >  	return 0;
> >  
> >  error_remove:
> 
> Applied, thanks.

Hmm, looking at the code again as I was about to send the patch to
Linus, it seems that the above fix isn't sufficient. One problem is
that it makes little sense to create sysfs attributes for the device if
the probe is going to fail. So sysfs file creation should be delayed
until after the device presence check. A second, more important problem
is that no error code is returned if sysfs_create_group() fails. The
probe function will return success (0) while the device is not
registered, which means trouble when the remove function is called
later.

The second problem is caused by the presence of two local variables
carrying error values: err and status. The latter should be dropped to
avoid the confusion, and the former shouldn't be initialized to 0, so
that the compiler has a chance to warn about such issues.

Axel, Paul, can either of you please send an updated patch as a
replacement for this one, fixing the two remaining issues? Thanks.

As a side note, I also noticed that struct ads7871_data has an unused
member "update_lock". Someone familiar with the device and driver
should check whether it should be used somewhere, or if it can be
dropped.

-- 
Jean Delvare
