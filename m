Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908Ab1FATv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:51:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56839 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759225Ab1FATvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:51:53 -0400
Date: Wed, 1 Jun 2011 21:51:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Andrew Chew <AChew@nvidia.com>
cc: "mchehab@redhat.com" <mchehab@redhat.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/5 v2] [media] ov9740: Add suspend/resume
In-Reply-To: <643E69AA4436674C8F39DCC2C05F76382A75BF37C4@HQMAIL03.nvidia.com>
Message-ID: <Pine.LNX.4.64.1106012137320.29934@axis700.grange>
References: <1306368272-28279-1-git-send-email-achew@nvidia.com>
 <1306368272-28279-5-git-send-email-achew@nvidia.com>
 <Pine.LNX.4.64.1105291249220.18788@axis700.grange>
 <643E69AA4436674C8F39DCC2C05F76382A75BF37C4@HQMAIL03.nvidia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:SsFXV2Y8Nwgx2p7FpM+hXR4/R7YnE6oRtjICSc6IlzF
 uHSuPX1cVz0qz3v/4E2BX1ziw+BSFWzwthsK5GCYsdzKOhthL/
 vAXkTgaTMP/e+FwV3WYEl04qt4lI/nTqRZP/v2FOVtjKFgxPRB
 Y0Gm7PEomT5OElgaJe3PbGarIE3X4dOz2rAWdypeE5+G+zHdDk
 glVH66P14DIqiX6pvCERD6x0oahhDYHu6D77EyO4Lc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011, Andrew Chew wrote:

> > > +	/* For suspend/resume. */
> > > +	struct v4l2_mbus_framefmt	current_mf;
> > > +	int				current_enable;
> > 
> > bool?
> 
> Are you sure you want this to be a bool?  This thing is trying to shadow 
> the "enable" parameter of the s_stream() callback, and that enable 
> parameter is int.

You use it as a bool.

> > > +static int ov9740_suspend(struct soc_camera_device *icd, 
> > pm_message_t state)
> > > +{
> > > +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> > > +	struct ov9740_priv *priv = to_ov9740(sd);
> > > +
> > > +	if (priv->current_enable) {
> > > +		int current_enable = priv->current_enable;
> > > +
> > > +		ov9740_s_stream(sd, 0);
> > > +		priv->current_enable = current_enable;
> > 
> > You don't need the local variable, just set
> > 
> > 	priv->current_enable = true;
> 
> I think I do need that local variable, the way the code is arranged now.  
> I'm trying to save the state of enablement inside of 
> priv->current_enable, at the time we are suspending, so it won't 
> necessarily be true.  And one of the side effects of calling 
> ov9740_s_stream(sd, 0) is that priv->current_enable will be set to 
> false, which is why I save off the value of priv->current_enable, and 
> then restore it after the call to ov9740_s_stream().

? Sorry, don't understand. You only _enter_ that "if" statement, if 
priv->current_enable is true. So, your local variable is _certainly_ true. 
And that's what you're then writing in priv->current_enable back again.

> > >  static struct soc_camera_ops ov9740_ops = {
> > > +	.suspend		= ov9740_suspend,
> > > +	.resume			= ov9740_resume,
> > 
> > No, we don't want to use these, whey should disappear some 
> > time... Please, 
> > use .s_power() from struct v4l2_subdev_core_ops, you can check 
> > http://article.gmane.org/gmane.linux.drivers.video-input-infra
> > structure/33105 
> > for an example. If your host is not using these ops, it has 
> > to be fixed. 
> > So far in the mainline only one soc-camera host driver is using these 
> > callbacks: pxa_camera.c, which, looking at your email 
> > address, I doubt is 
> > the driver, that you're using;)
> 
> Okay, will do.  Thanks for pointing that out :)
> 
> Is the camera host driver expected to directly call the sensor driver's 
> s_power (via v4l2_subdev_call(sd, core, s_power, <some value>)?  Or does 
> the v4l2 framework do this for you?  I didn't see an example of this in 
> my last pull of linux-next.

yes, the host driver has to call s_power explicitly.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
