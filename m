Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034Ab0LNVDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:03:42 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41102 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758723Ab0LNVDl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:03:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e5BU+WFABTi+wjhg8auy723VOZZ592h4AI4fl0U7NZfPUKGFnxQxp5+Lae5MEdXWWZ
         ovxxUEeTcxdFRooFTIGrHiIK2vFhwxCYdyLt2JpmiyyeW9szJ2AuZp92V62HMITMGMoe
         coimsm1ZLKFthNK7mF2CpYOEOGUGGXvE/ShV8=
MIME-Version: 1.0
In-Reply-To: <20101214003024.GA3575@hanuman.home.ifup.org>
References: <20101212131550.GA2608@darkstar>
	<AANLkTinaNjPjNbxE+OyRsY_jJxDW-pwehTPgyAWzqfzd@mail.gmail.com>
	<20101214003024.GA3575@hanuman.home.ifup.org>
Date: Tue, 14 Dec 2010 21:56:33 +0100
Message-ID: <AANLkTi=ic4i+whV7-gtA7jvWJkPE+bizLdra6OMDf6Cp@mail.gmail.com>
Subject: Re: [PATCH] bttv: fix mutex use before init
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Brandon Philips <brandon@ifup.org>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Chris Clayton <chris2553@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 1:30 AM, Brandon Philips <brandon@ifup.org> wrote:
> On 17:13 Sun 12 Dec 2010, Torsten Kaiser wrote:
>>  * change &fh->cap.vb_lock in bttv_open() AND radio_open() to
>> &btv->init.cap.vb_lock
>>  * add a mutex_init(&btv->init.cap.vb_lock) to the setup of init in bttv_probe()
>
> That seems like a reasonable suggestion. An openSUSE user submitted this
> bug to our tracker too. Here is the patch I am having him test.
>
> Would you mind testing it?

No. :-)

Without this patch (==vanilla 2.6.37-rc5) I got 2 more OOPSe by
restarting hal around 20 times.
After applying this patch, I did not see a single OOPS after 100 restarts.
So it looks like the fix is correct.

Using the card also still works, but I think I found out what was
causing sporadic shutdown problems with 37-rc kernels: When I try to
exit tvtime it gets stuck in an uninterruptible D state and can't be
killed. And that seems to mess up the shutdown.

But this happens independent with or without your patch and looks like
different problem.

SysRQ+W provided this stack trace, maybe someone seens an obvious bug...:
[  274.772528]  ffff8800dec69680 0000000000000086 ffffffff81089d73
ffff8800729d05a0
[  274.778599]  0000000000011480 ffff8800df923fd8 0000000000011480
ffff8800df922000
[  274.778599]  ffff8800df923fd8 0000000000011480 ffff8800dec69680
0000000000011480
[  274.778599] Call Trace:
[  274.778599]  [<ffffffff81089d73>] ? free_pcppages_bulk+0x343/0x3b0
[  274.778599]  [<ffffffff8156d0e1>] ? __mutex_lock_slowpath+0xe1/0x160
[  274.778599]  [<ffffffff8156cd8a>] ? mutex_lock+0x1a/0x40
[  274.778599]  [<ffffffff8141ab7f>] ? free_btres_lock.clone.19+0x3f/0x100
[  274.778599]  [<ffffffff8141d311>] ? bttv_release+0x1c1/0x1e0
[  274.778599]  [<ffffffff813fe4ba>] ? v4l2_release+0x4a/0x70
[  274.778599]  [<ffffffff810c5291>] ? fput+0xe1/0x250
[  274.778599]  [<ffffffff810c1d59>] ? filp_close+0x59/0x80
[  274.778599]  [<ffffffff810c1e0b>] ? sys_close+0x8b/0xe0
[  274.778599]  [<ffffffff8100253b>] ? system_call_fastpath+0x16/0x1b


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
>  drivers/media/video/bt8xx/bttv-driver.c |   24 +++++++++++++-----------
>  1 files changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
> index a529619..e656424 100644
> --- a/drivers/media/video/bt8xx/bttv-driver.c
> +++ b/drivers/media/video/bt8xx/bttv-driver.c
> @@ -2391,16 +2391,11 @@ static int setup_window_lock(struct bttv_fh *fh, struct bttv *btv,
>        fh->ov.field    = win->field;
>        fh->ov.setup_ok = 1;
>
> -       /*
> -        * FIXME: btv is protected by btv->lock mutex, while btv->init
> -        *        is protected by fh->cap.vb_lock. This seems to open the
> -        *        possibility for some race situations. Maybe the better would
> -        *        be to unify those locks or to use another way to store the
> -        *        init values that will be consumed by videobuf callbacks
> -        */
> +       mutex_lock(&btv->init.cap.vb_lock);
>        btv->init.ov.w.width   = win->w.width;
>        btv->init.ov.w.height  = win->w.height;
>        btv->init.ov.field     = win->field;
> +       mutex_unlock(&btv->init.cap.vb_lock);
>
>        /* update overlay if needed */
>        retval = 0;
> @@ -2620,9 +2615,11 @@ static int bttv_s_fmt_vid_cap(struct file *file, void *priv,
>        fh->cap.last         = V4L2_FIELD_NONE;
>        fh->width            = f->fmt.pix.width;
>        fh->height           = f->fmt.pix.height;
> +       mutex_lock(&btv->init.cap.vb_lock);
>        btv->init.fmt        = fmt;
>        btv->init.width      = f->fmt.pix.width;
>        btv->init.height     = f->fmt.pix.height;
> +       mutex_unlock(&btv->init.cap.vb_lock);
>        mutex_unlock(&fh->cap.vb_lock);
>
>        return 0;
> @@ -2855,6 +2852,7 @@ static int bttv_s_fbuf(struct file *file, void *f,
>
>        retval = 0;
>        fh->ovfmt = fmt;
> +       mutex_lock(&btv->init.cap.vb_lock);
>        btv->init.ovfmt = fmt;
>        if (fb->flags & V4L2_FBUF_FLAG_OVERLAY) {
>                fh->ov.w.left   = 0;
> @@ -2876,6 +2874,7 @@ static int bttv_s_fbuf(struct file *file, void *f,
>                        retval = bttv_switch_overlay(btv, fh, new);
>                }
>        }
> +       mutex_unlock(&btv->init.cap.vb_lock);
>        mutex_unlock(&fh->cap.vb_lock);
>        return retval;
>  }
> @@ -3141,6 +3140,7 @@ static int bttv_s_crop(struct file *file, void *f, struct v4l2_crop *crop)
>        fh->do_crop = 1;
>
>        mutex_lock(&fh->cap.vb_lock);
> +       mutex_lock(&btv->init.cap.vb_lock);
>
>        if (fh->width < c.min_scaled_width) {
>                fh->width = c.min_scaled_width;
> @@ -3158,6 +3158,7 @@ static int bttv_s_crop(struct file *file, void *f, struct v4l2_crop *crop)
>                btv->init.height = c.max_scaled_height;
>        }
>
> +       mutex_unlock(&btv->init.cap.vb_lock);
>        mutex_unlock(&fh->cap.vb_lock);
>
>        return 0;
> @@ -3302,9 +3303,9 @@ static int bttv_open(struct file *file)
>         * Let's first copy btv->init at fh, holding cap.vb_lock, and then work
>         * with the rest of init, holding btv->lock.
>         */
> -       mutex_lock(&fh->cap.vb_lock);
> +       mutex_lock(&btv->init.cap.vb_lock);
>        *fh = btv->init;
> -       mutex_unlock(&fh->cap.vb_lock);
> +       mutex_unlock(&btv->init.cap.vb_lock);
>
>        fh->type = type;
>        fh->ov.setup_ok = 0;
> @@ -3502,9 +3503,9 @@ static int radio_open(struct file *file)
>        if (unlikely(!fh))
>                return -ENOMEM;
>        file->private_data = fh;
> -       mutex_lock(&fh->cap.vb_lock);
> +       mutex_lock(&btv->init.cap.vb_lock);
>        *fh = btv->init;
> -       mutex_unlock(&fh->cap.vb_lock);
> +       mutex_unlock(&btv->init.cap.vb_lock);
>
>        mutex_lock(&btv->lock);
>        v4l2_prio_open(&btv->prio, &fh->prio);
> @@ -4489,6 +4490,7 @@ static int __devinit bttv_probe(struct pci_dev *dev,
>        btv->opt_coring     = coring;
>
>        /* fill struct bttv with some useful defaults */
> +       mutex_init(&btv->init.cap.vb_lock);
>        btv->init.btv         = btv;
>        btv->init.ov.w.width  = 320;
>        btv->init.ov.w.height = 240;
> --
> 1.7.3.1
>
>
