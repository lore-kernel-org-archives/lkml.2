Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab1FAB6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 21:58:38 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2819 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab1FAB6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 21:58:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 31 May 2011 18:58:30 -0700
From: Andrew Chew <AChew@nvidia.com>
To: "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>
CC: "mchehab@redhat.com" <mchehab@redhat.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 31 May 2011 18:58:29 -0700
Subject: RE: [PATCH 5/5 v2] [media] ov9740: Add suspend/resume
Thread-Topic: [PATCH 5/5 v2] [media] ov9740: Add suspend/resume
Thread-Index: Acwd72zH+T8EAUCySA+LCVEl3Dbp1QCDu1HQ
Message-ID: <643E69AA4436674C8F39DCC2C05F76382A75BF37C4@HQMAIL03.nvidia.com>
References: <1306368272-28279-1-git-send-email-achew@nvidia.com>
 <1306368272-28279-5-git-send-email-achew@nvidia.com>
 <Pine.LNX.4.64.1105291249220.18788@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105291249220.18788@axis700.grange>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	/* For suspend/resume. */
> > +	struct v4l2_mbus_framefmt	current_mf;
> > +	int				current_enable;
> 
> bool?

Are you sure you want this to be a bool?  This thing is trying to shadow the "enable" parameter of the s_stream() callback, and that enable parameter is int.


> > +static int ov9740_suspend(struct soc_camera_device *icd, 
> pm_message_t state)
> > +{
> > +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> > +	struct ov9740_priv *priv = to_ov9740(sd);
> > +
> > +	if (priv->current_enable) {
> > +		int current_enable = priv->current_enable;
> > +
> > +		ov9740_s_stream(sd, 0);
> > +		priv->current_enable = current_enable;
> 
> You don't need the local variable, just set
> 
> 	priv->current_enable = true;

I think I do need that local variable, the way the code is arranged now.  I'm trying to save the state of enablement inside of priv->current_enable, at the time we are suspending, so it won't necessarily be true.  And one of the side effects of calling ov9740_s_stream(sd, 0) is that priv->current_enable will be set to false, which is why I save off the value of priv->current_enable, and then restore it after the call to ov9740_s_stream().


> >  static struct soc_camera_ops ov9740_ops = {
> > +	.suspend		= ov9740_suspend,
> > +	.resume			= ov9740_resume,
> 
> No, we don't want to use these, whey should disappear some 
> time... Please, 
> use .s_power() from struct v4l2_subdev_core_ops, you can check 
> http://article.gmane.org/gmane.linux.drivers.video-input-infra
> structure/33105 
> for an example. If your host is not using these ops, it has 
> to be fixed. 
> So far in the mainline only one soc-camera host driver is using these 
> callbacks: pxa_camera.c, which, looking at your email 
> address, I doubt is 
> the driver, that you're using;)

Okay, will do.  Thanks for pointing that out :)

Is the camera host driver expected to directly call the sensor driver's s_power (via v4l2_subdev_call(sd, core, s_power, <some value>)?  Or does the v4l2 framework do this for you?  I didn't see an example of this in my last pull of linux-next.