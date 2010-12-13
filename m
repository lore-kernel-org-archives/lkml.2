Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab0LMOEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 09:04:47 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44448 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab0LMOEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 09:04:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=P6AZ98yjWkajfsy5uBC2y+3PYvqOWCRSfhUKdb0E0OtRTnv7o0palyTvqAPtX0/3yc
         3Z7t+5UazABLy6wudvsPzJReOfK7Y87zcoWen0h+6P3F62vo6BpAkXdd/TAVPh4/bTQk
         puGZyJovjVVzRCSlDmm7bYk/q4HGIckfLzdec=
Date: Mon, 13 Dec 2010 22:04:21 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Chris Clayton <chris2553@googlemail.com>
Subject: Re: [PATCH] bttv: fix mutex use before init
Message-ID: <20101213140421.GA2826@darkstar>
References: <20101212131550.GA2608@darkstar>
 <AANLkTinaNjPjNbxE+OyRsY_jJxDW-pwehTPgyAWzqfzd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinaNjPjNbxE+OyRsY_jJxDW-pwehTPgyAWzqfzd@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 05:13:47PM +0100, Torsten Kaiser wrote:
> On Sun, Dec 12, 2010 at 2:15 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > oops happen in bttv_open while locking uninitialized mutex fh->cap.vb_lock
> > add mutex_init before usage
> 
> I have seen the same problem twice since I switched of the BKL in
> 2.6.37-rc2, but only had the time today to search for the cause.
> (It only happend on two boots out of probably more then 50, so I only
> investigated after it happened a second time with -rc5)
> 
> The cause was making this change to bttv_open() and radio_open() to
> remove the BKL from them:
> +	mutex_lock(&fh->cap.vb_lock);
>  	*fh = btv->init;
> +	mutex_unlock(&fh->cap.vb_lock);
> 
> This is wrong because of two things:
> First: The fh->cap.vb_lock has not been initialised, as you noted.
> Second: The middle line will overwrite the mutex!
> 
> Just adding mutex_init() will not really help the second problem and
> seems to be wrong from the point that cap.vb_lock already has a
> mutex_init() via videobuf_queue_sg_init().

Yes, you are right. I wonder if the above lock code in bttv_open and radio_open can be removed or just use btv->lock.

> 
> I'm not sure what the correct fix is, but I would rather suggest this:
> 
>  * change &fh->cap.vb_lock in bttv_open() AND radio_open() to
> &btv->init.cap.vb_lock
>  * add a mutex_init(&btv->init.cap.vb_lock) to the setup of init in bttv_probe()

I will test this when the bttv card is available for me tommorrow.

> 
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> > Tested-by: Chris Clayton <chris2553@googlemail.com>
> > ---
> >  drivers/media/video/bt8xx/bttv-driver.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > --- linux-2.6.orig/drivers/media/video/bt8xx/bttv-driver.c      2010-11-27 11:21:30.000000000 +0800
> > +++ linux-2.6/drivers/media/video/bt8xx/bttv-driver.c   2010-12-12 16:31:39.633333338 +0800
> > @@ -3291,6 +3291,8 @@ static int bttv_open(struct file *file)
> >        fh = kmalloc(sizeof(*fh), GFP_KERNEL);
> >        if (unlikely(!fh))
> >                return -ENOMEM;
> > +
> > +       mutex_init(&fh->cap.vb_lock);
> >        file->private_data = fh;
> >
> >        /*
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
