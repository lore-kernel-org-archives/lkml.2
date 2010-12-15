Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab0LOSob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 13:44:31 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36364 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab0LOSo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 13:44:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=W06YAZo8fOMPu4mvwMOFEoOxIBxsTUl4KTot4HCljbiMtVIaji6VFRJxFSWjHloX/Q
         lwxojQHvxGkFw9j+1sBeq6jBRM3XUF4kmzNV6TPAiOkYr+YfKKyYK14wpOCrfKhW9Sxr
         sL7Byu4mjU3I7WpXOOZD1VUwQ+cFg602StoZY=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Brandon Philips <brandon@ifup.org>
Subject: Re: [PATCH] bttv: fix mutex use before init
Date: Wed, 15 Dec 2010 18:44:04 +0000
User-Agent: KMail/1.9.10
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <20101212131550.GA2608@darkstar> <AANLkTinaNjPjNbxE+OyRsY_jJxDW-pwehTPgyAWzqfzd@mail.gmail.com> <20101214003024.GA3575@hanuman.home.ifup.org>
In-Reply-To: <20101214003024.GA3575@hanuman.home.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201012151844.04105.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 December 2010, Brandon Philips wrote:
> On 17:13 Sun 12 Dec 2010, Torsten Kaiser wrote:
> >  * change &fh->cap.vb_lock in bttv_open() AND radio_open() to
> > &btv->init.cap.vb_lock
> >  * add a mutex_init(&btv->init.cap.vb_lock) to the setup of init in
> > bttv_probe()
>
> That seems like a reasonable suggestion. An openSUSE user submitted this
> bug to our tracker too. Here is the patch I am having him test.
>
> Would you mind testing it?
>
> From 456dc0ce36db523c4c0c8a269f4eec43a72de1dc Mon Sep 17 00:00:00 2001
> From: Brandon Philips <bphilips@suse.de>
> Date: Mon, 13 Dec 2010 16:21:55 -0800
> Subject: [PATCH] bttv: fix locking for btv->init
>
> Fix locking for the btv->init by using btv->init.cap.vb_lock and in the
> process fix uninitialized deref introduced in c37db91fd0d.
>
> Signed-off-by: Brandon Philips <bphilips@suse.de>
> ---
>  drivers/media/video/bt8xx/bttv-driver.c |   24 +++++++++++++-----------
>  1 files changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/media/video/bt8xx/bttv-driver.c
> b/drivers/media/video/bt8xx/bttv-driver.c index a529619..e656424 100644
> --- a/drivers/media/video/bt8xx/bttv-driver.c
> +++ b/drivers/media/video/bt8xx/bttv-driver.c
> @@ -2391,16 +2391,11 @@ static int setup_window_lock(struct bttv_fh *fh,
> struct bttv *btv, fh->ov.field    = win->field;
>  	fh->ov.setup_ok = 1;
>
> -	/*
> -	 * FIXME: btv is protected by btv->lock mutex, while btv->init
> -	 *	  is protected by fh->cap.vb_lock. This seems to open the
> -	 *	  possibility for some race situations. Maybe the better would
> -	 *	  be to unify those locks or to use another way to store the
> -	 *	  init values that will be consumed by videobuf callbacks
> -	 */
> +	mutex_lock(&btv->init.cap.vb_lock);
>  	btv->init.ov.w.width   = win->w.width;
>  	btv->init.ov.w.height  = win->w.height;
>  	btv->init.ov.field     = win->field;
> +	mutex_unlock(&btv->init.cap.vb_lock);
>
>  	/* update overlay if needed */
>  	retval = 0;
> @@ -2620,9 +2615,11 @@ static int bttv_s_fmt_vid_cap(struct file *file,
> void *priv, fh->cap.last         = V4L2_FIELD_NONE;
>  	fh->width            = f->fmt.pix.width;
>  	fh->height           = f->fmt.pix.height;
> +	mutex_lock(&btv->init.cap.vb_lock);
>  	btv->init.fmt        = fmt;
>  	btv->init.width      = f->fmt.pix.width;
>  	btv->init.height     = f->fmt.pix.height;
> +	mutex_unlock(&btv->init.cap.vb_lock);
>  	mutex_unlock(&fh->cap.vb_lock);
>
>  	return 0;
> @@ -2855,6 +2852,7 @@ static int bttv_s_fbuf(struct file *file, void *f,
>
>  	retval = 0;
>  	fh->ovfmt = fmt;
> +	mutex_lock(&btv->init.cap.vb_lock);
>  	btv->init.ovfmt = fmt;
>  	if (fb->flags & V4L2_FBUF_FLAG_OVERLAY) {
>  		fh->ov.w.left   = 0;
> @@ -2876,6 +2874,7 @@ static int bttv_s_fbuf(struct file *file, void *f,
>  			retval = bttv_switch_overlay(btv, fh, new);
>  		}
>  	}
> +	mutex_unlock(&btv->init.cap.vb_lock);
>  	mutex_unlock(&fh->cap.vb_lock);
>  	return retval;
>  }
> @@ -3141,6 +3140,7 @@ static int bttv_s_crop(struct file *file, void *f,
> struct v4l2_crop *crop) fh->do_crop = 1;
>
>  	mutex_lock(&fh->cap.vb_lock);
> +	mutex_lock(&btv->init.cap.vb_lock);
>
>  	if (fh->width < c.min_scaled_width) {
>  		fh->width = c.min_scaled_width;
> @@ -3158,6 +3158,7 @@ static int bttv_s_crop(struct file *file, void *f,
> struct v4l2_crop *crop) btv->init.height = c.max_scaled_height;
>  	}
>
> +	mutex_unlock(&btv->init.cap.vb_lock);
>  	mutex_unlock(&fh->cap.vb_lock);
>
>  	return 0;
> @@ -3302,9 +3303,9 @@ static int bttv_open(struct file *file)
>  	 * Let's first copy btv->init at fh, holding cap.vb_lock, and then work
>  	 * with the rest of init, holding btv->lock.
>  	 */
> -	mutex_lock(&fh->cap.vb_lock);
> +	mutex_lock(&btv->init.cap.vb_lock);
>  	*fh = btv->init;
> -	mutex_unlock(&fh->cap.vb_lock);
> +	mutex_unlock(&btv->init.cap.vb_lock);
>
>  	fh->type = type;
>  	fh->ov.setup_ok = 0;
> @@ -3502,9 +3503,9 @@ static int radio_open(struct file *file)
>  	if (unlikely(!fh))
>  		return -ENOMEM;
>  	file->private_data = fh;
> -	mutex_lock(&fh->cap.vb_lock);
> +	mutex_lock(&btv->init.cap.vb_lock);
>  	*fh = btv->init;
> -	mutex_unlock(&fh->cap.vb_lock);
> +	mutex_unlock(&btv->init.cap.vb_lock);
>
>  	mutex_lock(&btv->lock);
>  	v4l2_prio_open(&btv->prio, &fh->prio);
> @@ -4489,6 +4490,7 @@ static int __devinit bttv_probe(struct pci_dev *dev,
>  	btv->opt_coring     = coring;
>
>  	/* fill struct bttv with some useful defaults */
> +	mutex_init(&btv->init.cap.vb_lock);
>  	btv->init.btv         = btv;
>  	btv->init.ov.w.width  = 320;
>  	btv->init.ov.w.height = 240;

The patch is good here too. Thanks.

Tested-by: Chris Clayton <chris2553@googlemail.com>



-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
