Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab2ENIJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:09:32 -0400
Received: from mail.telros.ru ([83.136.244.21]:65130 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab2ENIJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:09:29 -0400
Date: Mon, 14 May 2012 12:09:18 +0400
From: volokh@telros.ru
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Volokh Konstantin <volokh84@gmail.com>, my84@bk.ru,
        devel@driverdev.osuosl.org, hverkuil@xs4all.nl,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        mchehab@infradead.org, dhowells@redhat.com, justinmattock@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: media: go7007: Adlink MPG24 board
Message-ID: <20120514080918.GC1497@VPir.telros.lan>
References: <1336935162-5068-1-git-send-email-volokh84@gmail.com>
 <20120513192148.GE16984@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120513192148.GE16984@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 10:21:48PM +0300, Dan Carpenter wrote:
> On Sun, May 13, 2012 at 10:52:41PM +0400, Volokh Konstantin wrote:
> > This patch applies only for Adlink MPG24 board with go7007, all these changes were tested for continuous loading & restarting modes
> > 
> > This is minimal changes needed for start up go7007 to work correctly
> >   in 3.4 branch
> > 
> > Changes:
> >   - When go7007 reset device, i2c was not working (need rewrite GPIO5)
> >   - As wis2804 has i2c_addr=0x00/*really*/, so Need set I2C_CLIENT_TEN flag for validity
> >   - some main nonzero initialization, rewrites with kzalloc instead kmalloc
> >   - STATUS_SHUTDOWN was placed in incorrect place, so if firmware wasn`t loaded, we
> >     failed v4l2_device_unregister with kernel panic (OOPS)
> >   - some new v4l2 style features as call_all(...s_stream...) for using subdev calls
> > 
> 
> In some ways, yes, I can see that this seems like one thing "Make
> go7007 work correctly", but really it would be better if each of
> the bullet points was its own patch.
> 
> The changelogs should explain why you do something not what you do.
> We can all see that kmalloc() was changed to kzalloc() but why? Is

struct go7007 contains "struct v4l2_device v4l2_dev;" field, so if transfer it uninitialized (may be nonzero)
in function: "int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev, struct v4l2_subdev *sd)"
(drivers/media/video/v4l2-device.c), so next code may be called:
#if defined(CONFIG_MEDIA_CONTROLLER)
	/* Register the entity. */
	if (v4l2_dev->mdev) {
		err = media_device_register_entity(v4l2_dev->mdev, entity);
		if (err < 0) {
			if (sd->internal_ops && sd->internal_ops->unregistered)
				sd->internal_ops->unregistered(sd);
			module_put(sd->owner);
			return err;
		}
	}
#endif
I`ve got error here. because go7007 don`t control mdev field.

The next kzalloc: "gofh = kzalloc(sizeof(struct go7007_file), GFP_KERNEL);" was written only for zero initialization on creation purpose, driver work properly without it changing
> their and information leak for example?  That might have security
> implications and be good thing to know about.
> 
> regards,
> dan carpenter
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

It`s very horrible to describe every changing...

Volokh Konstantin
