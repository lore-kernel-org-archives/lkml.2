Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3ACNbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:31:19 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:56112 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab3ACNbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 08:31:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        LKML <linux-kernel@vger.kernel.org>,
        LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] tvp7002: use devm_kzalloc() instead of kzalloc()
Date: Thu, 03 Jan 2013 14:32:50 +0100
Message-ID: <8037573.45Pa1cP0Ir@avalon>
User-Agent: KMail/4.9.2 (Linux/3.6.11-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <1883891.1g43jikvbT@avalon>
References: <1357219362-9080-1-git-send-email-prabhakar.lad@ti.com> <1357219362-9080-4-git-send-email-prabhakar.lad@ti.com> <1883891.1g43jikvbT@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2013 14:31:20 Laurent Pinchart wrote:
> On Thursday 03 January 2013 18:52:42 Lad, Prabhakar wrote:
> > I2C drivers can use devm_kzalloc() too in their .probe() methods. Doing so
> > simplifies their clean up paths.
> > 
> > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > ---
> > 
> >  drivers/media/i2c/tvp7002.c |   10 ++--------
> >  1 files changed, 2 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
> > index fb6a5b5..2d4c86e 100644
> > --- a/drivers/media/i2c/tvp7002.c
> > +++ b/drivers/media/i2c/tvp7002.c
> > @@ -1036,7 +1036,7 @@ static int tvp7002_probe(struct i2c_client *c, const
> > struct i2c_device_id *id) return -ENODEV;
> > 
> >  	}
> > 
> > -	device = kzalloc(sizeof(struct tvp7002), GFP_KERNEL);
> > +	device = devm_kzalloc(&c->dev, sizeof(struct tvp7002), GFP_KERNEL);
> > 
> >  	if (!device)
> >  	
> >  		return -ENOMEM;
> > 
> > @@ -1088,17 +1088,12 @@ static int tvp7002_probe(struct i2c_client *c,
> > const struct i2c_device_id *id) V4L2_CID_GAIN, 0, 255, 1, 0);
> > 
> >  	sd->ctrl_handler = &device->hdl;
> >  	if (device->hdl.error) {
> > 
> > -		int err = device->hdl.error;
> > -
> > 
> >  		v4l2_ctrl_handler_free(&device->hdl);
> > 
> > -		kfree(device);
> > -		return err;
> > +		return device->hdl.error;
> 
> At this point device->hdl as been freed (or rather uninitialized, as the
> structure is not dynamically allocated by the control framework), so device-
> >hdl.error is undefined. That's why you need the local err variable.

And this comment holds true for the other patches in this series.

> >
> >  	}
> >  	v4l2_ctrl_handler_setup(&device->hdl);
> >  
> >  found_error:
> > -	if (error < 0)
> > -		kfree(device);
> 
> You can remove the found_error label and return errors directly instead of
> using goto's.
> 
> >  	return error;
> 
> And this can then be turned into return 0.
> 
> >  }
> > 
> > @@ -1120,7 +1115,6 @@ static int tvp7002_remove(struct i2c_client *c)
> > 
> >  	v4l2_device_unregister_subdev(sd);
> >  	v4l2_ctrl_handler_free(&device->hdl);
> > 
> > -	kfree(device);
> > 
> >  	return 0;
> >  
> >  }

-- 
Regards,

Laurent Pinchart

