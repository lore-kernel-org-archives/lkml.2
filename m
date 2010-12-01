Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab0LAULy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 15:11:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50791 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab0LAULx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 15:11:53 -0500
Date: Wed, 1 Dec 2010 21:11:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2] soc_camera: Add the ability to bind regulators to
 soc_camedra devices
In-Reply-To: <1291231412.3066.11.camel@realization>
Message-ID: <Pine.LNX.4.64.1012012058460.28110@axis700.grange>
References: <1291137176.6537.20.camel@realization> 
 <Pine.LNX.4.64.1012011803140.28110@axis700.grange> <1291231412.3066.11.camel@realization>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:MW4bvpl3dLmVZO5QKsIUXW0ZfHin5Q6fLbwSbQelZIg
 ustuZ2pkDI8vjvHXnHCOPvXnLJ71U7sy+qjTf/JTRnYBsC1fcp
 /pGpm4KuNsqe6Y7RpEfOAOurdHhHYxzYILl1U4cFCgJVNAYMs+
 ijEyP5gLatF8AKMuiYOW8IZxINfq2OriPFQlRhRwMpfibd8l1L
 gIbI+m4kMqtJKr1yv6n6jou7oi/GHTq7+0e5SPRQoA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010, Alberto Panizzo wrote:

> On mer, 2010-12-01 at 18:26 +0100, Guennadi Liakhovetski wrote:
> > On Tue, 30 Nov 2010, Alberto Panizzo wrote:
> > 
> > > In certain machines, camera devices are supplied directly
> > > by a number of regulators. This patch add the ability to drive
> > > these regulators directly by the soc_camera driver.
> > > 
> > > Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> > > ---
> > > 
> > > v2 changes:
> > > It is used the more standard regulator_bulk API, thanks to
> > > Mark Brown for pointing this.
> > > 
> > >  drivers/media/video/soc_camera.c |   73 +++++++++++++++++++++++++++-----------
> > >  include/media/soc_camera.h       |    5 +++
> > >  2 files changed, 57 insertions(+), 21 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> > > index 43848a7..f1c2094 100644
> > > --- a/drivers/media/video/soc_camera.c
> > > +++ b/drivers/media/video/soc_camera.c
> > 
> > Have to
> > 
> > #include <linux/regulator/consumer.h>
> > 
> > here
> > 
> > > @@ -43,6 +43,41 @@ static LIST_HEAD(hosts);
> > >  static LIST_HEAD(devices);
> > >  static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
> > >  
> > > +static int soc_camera_power_set(struct soc_camera_device *icd,
> > > +				struct soc_camera_link *icl,
> > > +				int power_on)
> > > +{
> > > +	int ret = 0;
> > 
> > "= 0" unneeded.
> > 
> > > +
> > > +	if (power_on) {
> > > +		ret = regulator_bulk_enable(icl->num_regulators,
> > > +					    icl->regulators);
> > > +	} else {
> > > +		ret = regulator_bulk_disable(icl->num_regulators,
> > > +					     icl->regulators);
> > > +	}
> > 
> > superfluous braces
> > 
> > > +	if (ret < 0) {
> > > +		dev_err(icd->pdev, "Cannot %s regulators",
> > > +			power_on ? "ENABLE" : "DISABLE");
> > 
> > why capitals?
> 
> To distinguish between hardcoded words and produced ones.
> Otherwise I prefer to separate the two messages and put them in the
> two branches of the if.
> 
> What do you think about?

Well, up to you, really, but just think, when you see in dmesg

Cannot ENABLE regulators

or

Cannot enable regulators

which of the two will look more naturally and would you really care, 
whether enable / disable were hardcoded or produced?

> > > +		goto err;
> > 
> > just return ret
> > 
> > > +	}
> > > +
> > > +	if (icl->power) {
> > > +		ret = icl->power(icd->pdev, power_on);
> > > +		if (ret < 0) {
> > > +			dev_err(icd->pdev,
> > > +				"Platform failed to power %s the camera.\n",
> > > +				power_on ? "ON" : "OFF");
> > 
> > why capitals?
> > 
> > > +			goto err;
> > 
> > just return ret, although, if switching on failed, and the platform us 
> > also using regulators, don't you want to turn them off? Still I would do 
> > this here inline without a goto, but that's already a matter of taste, so, 
> > if you prefer, in this case a goto would be justified.
> 
> regulator_bulk is an all or none API, so if an error happen enabling
> some regulators, it automatically disable the previous enabled ones.

Sorry, that's not what I mean. I mean, if both are used - regulators and 
the .power() callback. Regulators succeeded, but .power(1) failed. In this 
case you exit without disabling regulators again.

> > > +		}
> > > +	}
> > > +
> > > +	return 0;
> > > +
> > > +err:
> > > +	return ret;
> > 
> > with the above, this might go.
> > 
> > > +}
> > > +
> > >  const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
> > >  	struct soc_camera_device *icd, unsigned int fourcc)
> > >  {
> > > @@ -375,11 +410,9 @@ static int soc_camera_open(struct file *file)
> > >  			},
> > >  		};
> > >  
> > > -		if (icl->power) {
> > > -			ret = icl->power(icd->pdev, 1);
> > > -			if (ret < 0)
> > > -				goto epower;
> > > -		}
> > > +		ret = soc_camera_power_set(icd, icl, 1);
> > > +		if (ret < 0)
> > > +			goto epower;
> > >  
> > >  		/* The camera could have been already on, try to reset */
> > >  		if (icl->reset)
> > > @@ -425,8 +458,7 @@ esfmt:
> > >  eresume:
> > >  	ici->ops->remove(icd);
> > >  eiciadd:
> > > -	if (icl->power)
> > > -		icl->power(icd->pdev, 0);
> > > +	soc_camera_power_set(icd, icl, 0);
> > >  epower:
> > >  	icd->use_count--;
> > >  	mutex_unlock(&icd->video_lock);
> > > @@ -450,8 +482,7 @@ static int soc_camera_close(struct file *file)
> > >  
> > >  		ici->ops->remove(icd);
> > >  
> > > -		if (icl->power)
> > > -			icl->power(icd->pdev, 0);
> > > +		soc_camera_power_set(icd, icl, 0);
> > >  	}
> > >  
> > >  	if (icd->streamer == file)
> > > @@ -941,14 +972,14 @@ static int soc_camera_probe(struct device *dev)
> > >  
> > >  	dev_info(dev, "Probing %s\n", dev_name(dev));
> > >  
> > > -	if (icl->power) {
> > > -		ret = icl->power(icd->pdev, 1);
> > > -		if (ret < 0) {
> > > -			dev_err(dev,
> > > -				"Platform failed to power-on the camera.\n");
> > > -			goto epower;
> > > -		}
> > > -	}
> > > +	ret = regulator_bulk_get(icd->pdev, icl->num_regulators,
> > > +				 icl->regulators);
> > > +	if (ret)
> > 
> > "if (ret < 0)" for consistency, please
> 
> regulator_bulk_get return 0 on success..

I know, just as well as most other calls do. So, in this case both tests 
"if (ret)" or "if (ret < 0)" are equivalent, but since the rest of the 
file uses the "< 0" form, I'd prefer to be consistent.

> > > +		goto epower;
> > > +
> > > +	ret = soc_camera_power_set(icd, icl, 1);
> > > +	if (ret < 0)
> > > +		goto epower;
> > 
> > You need a new label for this error - you also have to free regulators, if 
> > this fails.
> 
> The same as before regulator_bulk_get is an all or none call that free
> regulators itself on error.

No. This is not for failing regulator_bulk_get(), this is for failing 
soc_camera_power_set(icd, icl, 1), in which case probing is aborted with 
an error, so, you have to free all resources, including regulators.

> Maybe return ret instead of goto epower?

You could do for the very first failure, yes. But there's no need to 
change this.

> > >  	/* The camera could have been already on, try to reset */
> > >  	if (icl->reset)
> > > @@ -1021,8 +1052,7 @@ static int soc_camera_probe(struct device *dev)
> > >  
> > >  	ici->ops->remove(icd);
> > >  
> > > -	if (icl->power)
> > > -		icl->power(icd->pdev, 0);
> > > +	soc_camera_power_set(icd, icl, 0);
> > >  
> > >  	mutex_unlock(&icd->video_lock);
> > >  
> > > @@ -1044,8 +1074,7 @@ eadddev:
> > >  evdc:
> > >  	ici->ops->remove(icd);
> > >  eadd:
> > > -	if (icl->power)
> > > -		icl->power(icd->pdev, 0);
> > > +	soc_camera_power_set(icd, icl, 0);
> > >  epower:
> > >  	return ret;
> > >  }
> > > @@ -1081,6 +1110,8 @@ static int soc_camera_remove(struct device *dev)
> > >  	}
> > >  	soc_camera_free_user_formats(icd);
> > >  
> > > +	regulator_bulk_free(icl->num_regulators, icl->regulators);
> > > +
> > >  	return 0;
> > >  }
> > >  
> > > diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> > > index 86e3631..3e6b903 100644
> > > --- a/include/media/soc_camera.h
> > > +++ b/include/media/soc_camera.h
> > > @@ -15,6 +15,7 @@
> > >  #include <linux/device.h>
> > >  #include <linux/mutex.h>
> > >  #include <linux/pm.h>
> > > +#include <linux/regulator/consumer.h>
> > 
> > No need to include the header here, just declare
> > 
> > struct regulator_bulk_data;
> 
> Ok, this is a coding style tip that I didn't know.
> 
> Thanks to you Guennadi!

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
