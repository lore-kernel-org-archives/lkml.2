Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab0LATXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:23:45 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58593 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab0LATXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:23:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rBc99ivSc84YgJC4OshBDxMTYW1T19UTe4b8Rwf92oTiX5P4VTthKbMW4R2xGLCl9l
         9L2A5c/MaKclc7Rv3PoG5DvQyx6DkV0PLp068IpaQfXlj18x68no+K8DCDo6/PmcBPdT
         hvzhAyWrsIxjdHE18jcn853eVPwcaKswykBfU=
Subject: Re: [PATCH v2] soc_camera: Add the ability to bind regulators to
 soc_camedra devices
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <Pine.LNX.4.64.1012011803140.28110@axis700.grange>
References: <1291137176.6537.20.camel@realization>
	 <Pine.LNX.4.64.1012011803140.28110@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 20:23:32 +0100
Message-ID: <1291231412.3066.11.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On mer, 2010-12-01 at 18:26 +0100, Guennadi Liakhovetski wrote:
> On Tue, 30 Nov 2010, Alberto Panizzo wrote:
> 
> > In certain machines, camera devices are supplied directly
> > by a number of regulators. This patch add the ability to drive
> > these regulators directly by the soc_camera driver.
> > 
> > Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> > ---
> > 
> > v2 changes:
> > It is used the more standard regulator_bulk API, thanks to
> > Mark Brown for pointing this.
> > 
> >  drivers/media/video/soc_camera.c |   73 +++++++++++++++++++++++++++-----------
> >  include/media/soc_camera.h       |    5 +++
> >  2 files changed, 57 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> > index 43848a7..f1c2094 100644
> > --- a/drivers/media/video/soc_camera.c
> > +++ b/drivers/media/video/soc_camera.c
> 
> Have to
> 
> #include <linux/regulator/consumer.h>
> 
> here
> 
> > @@ -43,6 +43,41 @@ static LIST_HEAD(hosts);
> >  static LIST_HEAD(devices);
> >  static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
> >  
> > +static int soc_camera_power_set(struct soc_camera_device *icd,
> > +				struct soc_camera_link *icl,
> > +				int power_on)
> > +{
> > +	int ret = 0;
> 
> "= 0" unneeded.
> 
> > +
> > +	if (power_on) {
> > +		ret = regulator_bulk_enable(icl->num_regulators,
> > +					    icl->regulators);
> > +	} else {
> > +		ret = regulator_bulk_disable(icl->num_regulators,
> > +					     icl->regulators);
> > +	}
> 
> superfluous braces
> 
> > +	if (ret < 0) {
> > +		dev_err(icd->pdev, "Cannot %s regulators",
> > +			power_on ? "ENABLE" : "DISABLE");
> 
> why capitals?

To distinguish between hardcoded words and produced ones.
Otherwise I prefer to separate the two messages and put them in the
two branches of the if.

What do you think about?


> 
> > +		goto err;
> 
> just return ret
> 
> > +	}
> > +
> > +	if (icl->power) {
> > +		ret = icl->power(icd->pdev, power_on);
> > +		if (ret < 0) {
> > +			dev_err(icd->pdev,
> > +				"Platform failed to power %s the camera.\n",
> > +				power_on ? "ON" : "OFF");
> 
> why capitals?
> 
> > +			goto err;
> 
> just return ret, although, if switching on failed, and the platform us 
> also using regulators, don't you want to turn them off? Still I would do 
> this here inline without a goto, but that's already a matter of taste, so, 
> if you prefer, in this case a goto would be justified.

regulator_bulk is an all or none API, so if an error happen enabling
some regulators, it automatically disable the previous enabled ones.

> 
> > +		}
> > +	}
> > +
> > +	return 0;
> > +
> > +err:
> > +	return ret;
> 
> with the above, this might go.
> 
> > +}
> > +
> >  const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
> >  	struct soc_camera_device *icd, unsigned int fourcc)
> >  {
> > @@ -375,11 +410,9 @@ static int soc_camera_open(struct file *file)
> >  			},
> >  		};
> >  
> > -		if (icl->power) {
> > -			ret = icl->power(icd->pdev, 1);
> > -			if (ret < 0)
> > -				goto epower;
> > -		}
> > +		ret = soc_camera_power_set(icd, icl, 1);
> > +		if (ret < 0)
> > +			goto epower;
> >  
> >  		/* The camera could have been already on, try to reset */
> >  		if (icl->reset)
> > @@ -425,8 +458,7 @@ esfmt:
> >  eresume:
> >  	ici->ops->remove(icd);
> >  eiciadd:
> > -	if (icl->power)
> > -		icl->power(icd->pdev, 0);
> > +	soc_camera_power_set(icd, icl, 0);
> >  epower:
> >  	icd->use_count--;
> >  	mutex_unlock(&icd->video_lock);
> > @@ -450,8 +482,7 @@ static int soc_camera_close(struct file *file)
> >  
> >  		ici->ops->remove(icd);
> >  
> > -		if (icl->power)
> > -			icl->power(icd->pdev, 0);
> > +		soc_camera_power_set(icd, icl, 0);
> >  	}
> >  
> >  	if (icd->streamer == file)
> > @@ -941,14 +972,14 @@ static int soc_camera_probe(struct device *dev)
> >  
> >  	dev_info(dev, "Probing %s\n", dev_name(dev));
> >  
> > -	if (icl->power) {
> > -		ret = icl->power(icd->pdev, 1);
> > -		if (ret < 0) {
> > -			dev_err(dev,
> > -				"Platform failed to power-on the camera.\n");
> > -			goto epower;
> > -		}
> > -	}
> > +	ret = regulator_bulk_get(icd->pdev, icl->num_regulators,
> > +				 icl->regulators);
> > +	if (ret)
> 
> "if (ret < 0)" for consistency, please

regulator_bulk_get return 0 on success..

> 
> > +		goto epower;
> > +
> > +	ret = soc_camera_power_set(icd, icl, 1);
> > +	if (ret < 0)
> > +		goto epower;
> 
> You need a new label for this error - you also have to free regulators, if 
> this fails.

The same as before regulator_bulk_get is an all or none call that free
regulators itself on error.

Maybe return ret instead of goto epower?

> 
> >  
> >  	/* The camera could have been already on, try to reset */
> >  	if (icl->reset)
> > @@ -1021,8 +1052,7 @@ static int soc_camera_probe(struct device *dev)
> >  
> >  	ici->ops->remove(icd);
> >  
> > -	if (icl->power)
> > -		icl->power(icd->pdev, 0);
> > +	soc_camera_power_set(icd, icl, 0);
> >  
> >  	mutex_unlock(&icd->video_lock);
> >  
> > @@ -1044,8 +1074,7 @@ eadddev:
> >  evdc:
> >  	ici->ops->remove(icd);
> >  eadd:
> > -	if (icl->power)
> > -		icl->power(icd->pdev, 0);
> > +	soc_camera_power_set(icd, icl, 0);
> >  epower:
> >  	return ret;
> >  }
> > @@ -1081,6 +1110,8 @@ static int soc_camera_remove(struct device *dev)
> >  	}
> >  	soc_camera_free_user_formats(icd);
> >  
> > +	regulator_bulk_free(icl->num_regulators, icl->regulators);
> > +
> >  	return 0;
> >  }
> >  
> > diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> > index 86e3631..3e6b903 100644
> > --- a/include/media/soc_camera.h
> > +++ b/include/media/soc_camera.h
> > @@ -15,6 +15,7 @@
> >  #include <linux/device.h>
> >  #include <linux/mutex.h>
> >  #include <linux/pm.h>
> > +#include <linux/regulator/consumer.h>
> 
> No need to include the header here, just declare
> 
> struct regulator_bulk_data;

Ok, this is a coding style tip that I didn't know.

Thanks to you Guennadi!

-- 
Alberto!

        Be Persistent!
                - Greg Kroah-Hartman (FOSDEM 2010)

