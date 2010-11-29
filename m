Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab0K2JfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:35:07 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33956 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab0K2JfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:35:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TKu7TCCyyrhA1KaTOZXNCL7Q50xPpUt6NZuIvNNTietf4SdFeHRGqVB4yngwveuENk
         ogdqrmjY1+SLmF7DzLzOLbXFtgb/fzEel+qFq4BaK/mDDxh6/4U//ott94Puwaz3CVrs
         +js0Q82Aua8BEj9l1JmbZL3vwiTtmmEAfP+bU=
Subject: Re: [PATCH 1/3] soc_camera: Add the ability to bind regulators to
 soc_camedra devices
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <damm@opensource.se>,
        =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
        linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1011281923440.5731@axis700.grange>
References: <1290964687.3016.5.camel@realization>
	 <Pine.LNX.4.64.1011281923440.5731@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 10:34:57 +0100
Message-ID: <1291023297.3139.55.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,
On dom, 2010-11-28 at 20:05 +0100, Guennadi Liakhovetski wrote:
> On Sun, 28 Nov 2010, Alberto Panizzo wrote:
> 
> > In certain machines, camera devices are supplied directly
> > by a number of regulators. This patch add the ability to drive
> > these regulators directly by the soc_camera driver.
> 
> IIRC, there has been a discussion a while ago, how to supply power to 
> cameras by regulators. Someone has tried to provide a .power() hook in the 
> platform code, but the problem was the order of driver loading / probing. 
> So, how about doing the following:
> 
> 1. in your platform code you register a notifier like
> 	bus_register_notifier(&soc_camera_bus_type, &cam_notifier);
> 2. in your notifier you verify, that the driver is already available, or 
> request_module("my-regulator-driver"), and use another notifier to wait, 
> until the driver is probed.
> 3. if the above has been successful, in your .power() method you just use 
> the regulator as usual.
> 
> Notice, that your current patch doesn't load regulator driver modules, so, 
> it also relies on them being already available at the time of camera 
> probing. If you can live with that restriction, you can skip loading the 
> module and waiting for its probe above too.

The reason I propose this implementation is because in a different 
subsystem (mmc) the regulator management is similar and accepted.
In that case, platform code that drive regulators directly is not 
considered successful and it is maintained a platform .power() function
that can manage other operations than regulators driving.
The power of binding regulators to devices, I think, is given by the 
ability to fine manage these objects in terms of power management.

But of course you are right in some objections:
> 
> The reasons why I do not want to add this to the core are: (1) I do not 
> want to have two methods for turning power on and off: a platform provided 
> .power() hook and and a set of regulators,

Why? The implementation I gave, abstract these power management actions 
in a single layer. Of course I had to manage the way of passing 
preferred voltage values and the results are not perfect.

>  (2) would anyone really want to 
> use several regulators for a camera sensor? If so, can it be the case, 
> that, for example, the regulators have to be switched off in the reverse 
> order to switching on? Or something else?

Well, I'm working on the i.MX31 3 Stack board support and there are 2 
regulators that powers the camera and if you consider the digital output
that enable another supplier needed, the total regulators are three..
So, yes a list of regulators is needed in this case, and Yes I did not 
considered the order of enabling and disabling operations. Just because
even the freescale drivers didn't.

A practical general rule is to turn off switchers in the reverse order
than the turning on one. And this can be easily implemented here.
But as you rose the question, we can add priorities of turning on and 
off.

> (3) regulators can often do 
> more, than just set one of two power levels - for on and off. What if a 
> need arises to use other voltages?

Well, you are thinking at the possibility to have one camera that have
different voltage levels needs during the ON time (between open and a
close).
IMHO I think that this could be considered only if a power management
event happen and we decide that, in some way, the camera chip can be
maintained powered with a different voltage level instead of turning 
it off and reinitializing it on resume.
Is this really the situation you are trying to address? 

> Is there any really good reason, why we _have_ to do this in soc-camera 
> core?

There are three options in regulators management:
1 Pure platform code.
2 Pure driver code.
3 subsystem code.

The first is the one you are suggesting me, but other subsystems 
rejected it.
The third IMHO is better than the first but solve the needs of the
single driver.
The second is the one I proposed and I think is the best way because
add a general framework to manage regulators in this subsystem.

Thanks you!
Alberto!


> > 
> > What the machine code have to do to use this functionality is to:
> > 1- Define a number of useful regulator supply descriptions such as:
> > 
> > static struct regulator_consumer_supply camera_reg1_consumers[] = {
> > 	...
> > 	REGULATOR_SUPPLY("camera_reg1", "soc-camera-pdrv.0"),
> > 	...
> > };
> > 
> > (Pay attention at the .N suffix of "soc-camera-pdrv" in case of
> > a system with multiple cameras)
> > 
> > 2- Define the list of regulators to bind to a specific instance of
> >    soc-camera-pdrv with their voltages:
> > 
> > static struct soc_camera_regulator_desc soc_camera_regs[] = {
> > 	SOCAM_REG_DESC("camera_reg1", 1300000, 1300000),
> > 	SOCAM_REG_DESC("camera_reg2",   2800000, 2800000),
> > 	...
> > };
> > 
> > 3- Add the list to the corresponding soc_camera_link description:
> > 
> > static struct soc_camera_link iclink_my_camera = {
> > ...
> > 	.soc_regulator_descs		= soc_camera_regs,
> > 	.num_soc_regulator_descs	= ARRAY_SIZE(soc_camera_regs),
> > };
> > 
> > 4- And register it as usual with the platform device description:
> > 
> > static struct platform_device machine_my_camera = {
> > 	.name	= "soc-camera-pdrv",
> > 	.id	= 0,
> > 	.dev	= {
> > 		.platform_data = &iclink_my_camera,
> > 	},
> > };
> > 
> > Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> > ---
> >  drivers/media/video/soc_camera.c |  135 +++++++++++++++++++++++++++++++------
> >  include/media/soc_camera.h       |   16 +++++
> >  2 files changed, 129 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> > index 43848a7..8fc5831 100644
> > --- a/drivers/media/video/soc_camera.c
> > +++ b/drivers/media/video/soc_camera.c
> > @@ -43,6 +43,96 @@ static LIST_HEAD(hosts);
> >  static LIST_HEAD(devices);
> >  static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
> >  
> > +static int soc_camera_setup_regulators(struct soc_camera_device *icd,
> > +					struct soc_camera_link *icl)
> > +{
> > +	int i, ret;
> > +
> > +	icd->soc_regulators = kzalloc(icl->num_soc_regulator_descs *
> > +		sizeof(struct regulator *), GFP_KERNEL);
> > +	if (!icd->soc_regulators) {
> > +		dev_err(icd->pdev, "Not enough memory.\n");
> > +		ret = -ENOMEM;
> > +		goto err;
> > +	}
> > +
> > +	for (i = 0; i < icl->num_soc_regulator_descs; i++) {
> > +		dev_dbg(icd->pdev, "Looking for reg:'%s' bound to dev:'%s'",
> > +			icl->soc_regulator_descs[i].supply,
> > +			dev_name(icd->pdev));
> > +		icd->soc_regulators[i] = regulator_get(icd->pdev,
> > +					    icl->soc_regulator_descs[i].supply);
> > +		if (IS_ERR(icd->soc_regulators[i])) {
> > +			icd->soc_regulators[i] = NULL;
> > +			dev_err(icd->pdev, "Unable to get regulator: \"%s\".\n",
> > +					icl->soc_regulator_descs[i].supply);
> > +			ret = -ENODEV;
> > +			goto free_regs;
> > +		}
> > +	}
> > +
> > +	icd->num_soc_regulators = icl->num_soc_regulator_descs;
> > +
> > +	return 0;
> > +
> > +free_regs:
> > +	for (i--; i >= 0; i--)
> > +		regulator_put(icd->soc_regulators[i]);
> > +err:
> > +	return ret;
> > +}
> > +
> > +static int soc_camera_power_set(struct soc_camera_device *icd,
> > +				struct soc_camera_link *icl,
> > +				int power_on)
> > +{
> > +	int ret, i;
> > +
> > +	for (i = 0; i < icd->num_soc_regulators; i++) {
> > +		if (power_on) {
> > +			ret = regulator_set_voltage(icd->soc_regulators[i],
> > +				icl->soc_regulator_descs[i].value_on_min,
> > +				icl->soc_regulator_descs[i].value_on_max);
> > +			if (ret) {
> > +				dev_err(icd->pdev, "Cannot set '%s' to %d:%d",
> > +				  icl->soc_regulator_descs[i].supply,
> > +				  icl->soc_regulator_descs[i].value_on_min,
> > +				  icl->soc_regulator_descs[i].value_on_max);
> > +				goto err;
> > +			}
> > +
> > +			ret = regulator_enable(icd->soc_regulators[i]);
> > +			if (ret < 0) {
> > +				dev_err(icd->pdev, "Cannot enable reg '%s'",
> > +					icl->soc_regulator_descs[i].supply);
> > +				goto err;
> > +			}
> > +		} else {
> > +			ret = regulator_disable(icd->soc_regulators[i]);
> > +			if (ret) {
> > +				dev_err(icd->pdev, "Cannot disable reg '%s'",
> > +					icl->soc_regulator_descs[i].supply);
> > +				goto err;
> > +			}
> > +		}
> > +	}
> > +
> > +	if (icl->power) {
> > +		ret = icl->power(icd->pdev, power_on);
> > +		if (ret < 0) {
> > +			dev_err(icd->pdev,
> > +				"Platform failed to power-%s the camera.\n",
> > +				power_on ? "ON" : "OFF");
> > +			goto err;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +
> > +err:
> > +	return ret;
> > +}
> > +
> >  const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
> >  	struct soc_camera_device *icd, unsigned int fourcc)
> >  {
> > @@ -375,11 +465,9 @@ static int soc_camera_open(struct file *file)
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
> > @@ -425,8 +513,7 @@ esfmt:
> >  eresume:
> >  	ici->ops->remove(icd);
> >  eiciadd:
> > -	if (icl->power)
> > -		icl->power(icd->pdev, 0);
> > +	soc_camera_power_set(icd, icl, 0);
> >  epower:
> >  	icd->use_count--;
> >  	mutex_unlock(&icd->video_lock);
> > @@ -450,8 +537,7 @@ static int soc_camera_close(struct file *file)
> >  
> >  		ici->ops->remove(icd);
> >  
> > -		if (icl->power)
> > -			icl->power(icd->pdev, 0);
> > +		soc_camera_power_set(icd, icl, 0);
> >  	}
> >  
> >  	if (icd->streamer == file)
> > @@ -937,18 +1023,18 @@ static int soc_camera_probe(struct device *dev)
> >  	struct device *control = NULL;
> >  	struct v4l2_subdev *sd;
> >  	struct v4l2_mbus_framefmt mf;
> > -	int ret;
> > +	int ret = 0, i;
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
> > +	if (icl->num_soc_regulator_descs)
> > +		ret = soc_camera_setup_regulators(icd, icl);
> > +	if (ret)
> > +		goto err;
> > +
> > +	ret = soc_camera_power_set(icd, icl, 1);
> > +	if (ret < 0)
> > +		goto epower;
> >  
> >  	/* The camera could have been already on, try to reset */
> >  	if (icl->reset)
> > @@ -1021,8 +1107,7 @@ static int soc_camera_probe(struct device *dev)
> >  
> >  	ici->ops->remove(icd);
> >  
> > -	if (icl->power)
> > -		icl->power(icd->pdev, 0);
> > +	soc_camera_power_set(icd, icl, 0);
> >  
> >  	mutex_unlock(&icd->video_lock);
> >  
> > @@ -1044,9 +1129,11 @@ eadddev:
> >  evdc:
> >  	ici->ops->remove(icd);
> >  eadd:
> > -	if (icl->power)
> > -		icl->power(icd->pdev, 0);
> > +	soc_camera_power_set(icd, icl, 0);
> >  epower:
> > +	for (i = icd->num_soc_regulators; i >= 0; i--)
> > +		regulator_put(icd->soc_regulators[i]);
> > +err:
> >  	return ret;
> >  }
> >  
> > @@ -1059,6 +1146,7 @@ static int soc_camera_remove(struct device *dev)
> >  	struct soc_camera_device *icd = to_soc_camera_dev(dev);
> >  	struct soc_camera_link *icl = to_soc_camera_link(icd);
> >  	struct video_device *vdev = icd->vdev;
> > +	int i;
> >  
> >  	BUG_ON(!dev->parent);
> >  
> > @@ -1081,6 +1169,9 @@ static int soc_camera_remove(struct device *dev)
> >  	}
> >  	soc_camera_free_user_formats(icd);
> >  
> > +	for (i = icd->num_soc_regulators; i >= 0; i--)
> > +		regulator_put(icd->soc_regulators[i]);
> > +
> >  	return 0;
> >  }
> >  
> > diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> > index 86e3631..ae589a4 100644
> > --- a/include/media/soc_camera.h
> > +++ b/include/media/soc_camera.h
> > @@ -15,6 +15,7 @@
> >  #include <linux/device.h>
> >  #include <linux/mutex.h>
> >  #include <linux/pm.h>
> > +#include <linux/regulator/consumer.h>
> >  #include <linux/videodev2.h>
> >  #include <media/videobuf-core.h>
> >  #include <media/v4l2-device.h>
> > @@ -45,6 +46,8 @@ struct soc_camera_device {
> >  	struct mutex video_lock;	/* Protects device data */
> >  	struct file *streamer;		/* stream owner */
> >  	struct videobuf_queue vb_vidq;
> > +	struct regulator **soc_regulators;
> > +	int num_soc_regulators;
> >  };
> >  
> >  struct soc_camera_host {
> > @@ -96,6 +99,15 @@ struct soc_camera_host_ops {
> >  #define SOCAM_SENSOR_INVERT_VSYNC	(1 << 3)
> >  #define SOCAM_SENSOR_INVERT_DATA	(1 << 4)
> >  
> > +struct soc_camera_regulator_desc {
> > +	const char *supply;
> > +	int value_on_min;
> > +	int value_on_max;
> > +};
> > +
> > +#define SOCAM_REG_DESC(s, min, max) \
> > +	{ .supply = s , .value_on_min = min , .value_on_max = max }
> > +
> >  struct i2c_board_info;
> >  
> >  struct soc_camera_link {
> > @@ -108,6 +120,10 @@ struct soc_camera_link {
> >  	const char *module_name;
> >  	void *priv;
> >  
> > +	/* Optional regulators that have to be managed on power on/off events */
> > +	struct soc_camera_regulator_desc *soc_regulator_descs;
> > +	int num_soc_regulator_descs;
> > +
> >  	/*
> >  	 * For non-I2C devices platform platform has to provide methods to
> >  	 * add a device to the system and to remove
> > -- 
> > 1.6.3.3
> > 
> > 
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/


-- 
Alberto!

        Be Persistent!
                - Greg Kroah-Hartman (FOSDEM 2010)

