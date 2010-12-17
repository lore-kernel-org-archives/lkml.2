Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab0LQULb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:11:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:56423 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab0LQUL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:11:28 -0500
Message-ID: <4D0BC3E6.8060100@infradead.org>
Date: Fri, 17 Dec 2010 18:11:18 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Brandon Philips <brandon@ifup.org>
CC: chris2553@googlemail.com, Torsten Kaiser <just.for.lkml@googlemail.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] bttv: fix mutex use before init
References: <20101212131550.GA2608@darkstar> <AANLkTinaNjPjNbxE+OyRsY_jJxDW-pwehTPgyAWzqfzd@mail.gmail.com> <20101214003024.GA3575@hanuman.home.ifup.org> <201012151844.04105.chris2553@googlemail.com> <4D093706.9040401@infradead.org> <20101217160723.GU2028@jenkins.home.ifup.org>
In-Reply-To: <20101217160723.GU2028@jenkins.home.ifup.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 17-12-2010 14:07, Brandon Philips escreveu:
> On 19:45 Wed 15 Dec 2010, Mauro Carvalho Chehab wrote:
>> Em 15-12-2010 16:44, Chris Clayton escreveu:
>>> On Tuesday 14 December 2010, Brandon Philips wrote:
>>>> On 17:13 Sun 12 Dec 2010, Torsten Kaiser wrote:
>>>>>  * change &fh->cap.vb_lock in bttv_open() AND radio_open() to
>>>>>  &btv->init.cap.vb_lock * add a mutex_init(&btv->init.cap.vb_lock)
>>>>>  to the setup of init in bttv_probe()
>>>>
>>>> That seems like a reasonable suggestion. An openSUSE user submitted
>>>> this bug to our tracker too. Here is the patch I am having him
>>>> test.
>>>>
>>>> Would you mind testing it?
>>>>
>>>> From 456dc0ce36db523c4c0c8a269f4eec43a72de1dc Mon Sep 17 00:00:00
>>>> 2001 From: Brandon Philips <bphilips@suse.de> Date: Mon, 13 Dec
>>>> 2010 16:21:55 -0800 Subject: [PATCH] bttv: fix locking for
>>>> btv->init
>>>>
>>>> Fix locking for the btv->init by using btv->init.cap.vb_lock and in
>>>> the process fix uninitialized deref introduced in c37db91fd0d.
>>>>
>>>> Signed-off-by: Brandon Philips <bphilips@suse.de>
>>
>> While your patch fixes the issue, it has some other troubles, like to
>> the presence of lock code at free_btres_lock(). It is possible to fix,
>> but the better is to just use the core-assisted locking schema. This
>> way, V4L2 core will serialize access to all
>> ioctl's/open/close/mmap/read/poll operations, avoiding to have two
>> processes accessing the hardware at the same time. Also, as there's
>> just one lock, instead of 3, there's no risk of dead locks.
> 
> Thanks, but, why wasn't this done instead of c37db91f?

Because c37db91f were a first attempt. I was expecting that it would be enough,
but, after some discussions at the ML, it seemed to be better to use a different
approach. As you probably noticed, the locking schema at bttv driver were very
complex, and it were likely to ask for problems. The new schema is simpler. The
principle is to serialize the access to the hardware or to the hardware-mirrored
data. It does that by serializing the access to all file operations for a given
bttv device.

While this is a little overkill (as there are a very few set of operations that
won't require locking, like retrieving some static read-only data), there's no
performance impact at the critical path, as such ioctl's typically happen only
during hardware discovery phase at the userspace apps.

> 
> Will this make it in before 2.6.37 is released? Otherwise 2.6.37 will
> need to be fixed in -stable immediatly after release.

I'll intend to add it today for -next, and send upstream by Sunday, hopefully
in time for .37.

> 
>> The net result is a cleaner code, with just one lock.
> 
> Could you take this patch to remove all of the comments about locking
> order with btv->lock since it doesn't seem to matter any longer.

Yes, sure. Thanks for the patch.
> 
> Cheers,
> 
> 	Brandon
> 
> P.S. Your mail client creates really long lines- somewhere around 90
> characters. Could you fix that?
> 
> From 7643db7bf5e9e557a27e3783786a1abecbdf82a7 Mon Sep 17 00:00:00 2001
> From: Brandon Philips <brandon@ifup.org>
> Date: Fri, 17 Dec 2010 07:58:22 -0800
> Subject: [PATCH] bttv: remove unneeded locking comments
> 
> After Mauro's "bttv: Fix locking issues due to BKL removal code" there
> are a number of comments that are no longer needed about lock ordering.
> Remove them.
> 
> Signed-off-by: Brandon Philips <bphilips@suse.de>
> ---
>  drivers/media/video/bt8xx/bttv-driver.c |   20 --------------------
>  1 files changed, 0 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
> index 25e1ca0..0902ec0 100644
> --- a/drivers/media/video/bt8xx/bttv-driver.c
> +++ b/drivers/media/video/bt8xx/bttv-driver.c
> @@ -2358,13 +2358,6 @@ static int setup_window_lock(struct bttv_fh *fh, struct bttv *btv,
>  	fh->ov.field    = win->field;
>  	fh->ov.setup_ok = 1;
>  
> -	/*
> -	 * FIXME: btv is protected by btv->lock mutex, while btv->init
> -	 *	  is protected by fh->cap.vb_lock. This seems to open the
> -	 *	  possibility for some race situations. Maybe the better would
> -	 *	  be to unify those locks or to use another way to store the
> -	 *	  init values that will be consumed by videobuf callbacks
> -	 */
>  	btv->init.ov.w.width   = win->w.width;
>  	btv->init.ov.w.height  = win->w.height;
>  	btv->init.ov.field     = win->field;
> @@ -3219,15 +3212,6 @@ static int bttv_open(struct file *file)
>  		return -ENOMEM;
>  	file->private_data = fh;
>  
> -	/*
> -	 * btv is protected by btv->lock mutex, while btv->init and other
> -	 * streaming vars are protected by fh->cap.vb_lock. We need to take
> -	 * care of both locks to avoid troubles. However, vb_lock is used also
> -	 * inside videobuf, without calling buf->lock. So, it is a very bad
> -	 * idea to hold both locks at the same time.
> -	 * Let's first copy btv->init at fh, holding cap.vb_lock, and then work
> -	 * with the rest of init, holding btv->lock.
> -	 */
>  	*fh = btv->init;
>  
>  	fh->type = type;
> @@ -3302,10 +3286,6 @@ static int bttv_release(struct file *file)
>  
>  	/* free stuff */
>  
> -	/*
> -	 * videobuf uses cap.vb_lock - we should avoid holding btv->lock,
> -	 * otherwise we may have dead lock conditions
> -	 */
>  	videobuf_mmap_free(&fh->cap);
>  	videobuf_mmap_free(&fh->vbi);
>  	v4l2_prio_close(&btv->prio, fh->prio);

