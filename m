Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0LQOF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 09:05:28 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:35633 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab0LQOFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 09:05:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q9up7cVp8tiabeyCjJbk1ZvZ7KKB3H7FrCS67TavvWkfB3MKGVv0yxDQle9nhAoBsk
         jkUpxSZR19yS2z6fqadNBlTV5376yS3Np+QF71WXslJzx/bXwp0Mi3WP7qIo+/QWWg+l
         j70xgBrVmdvjz5WI1oq4jXyoNfDiIGLRsdY3g=
MIME-Version: 1.0
In-Reply-To: <4D093706.9040401@infradead.org>
References: <20101212131550.GA2608@darkstar>
	<AANLkTinaNjPjNbxE+OyRsY_jJxDW-pwehTPgyAWzqfzd@mail.gmail.com>
	<20101214003024.GA3575@hanuman.home.ifup.org>
	<201012151844.04105.chris2553@googlemail.com>
	<4D093706.9040401@infradead.org>
Date: Fri, 17 Dec 2010 15:05:22 +0100
Message-ID: <AANLkTinyzoiUv3dCFGDa1e4yfu6FuDQ7QpUHNyNohvBU@mail.gmail.com>
Subject: Re: [PATCH] bttv: fix mutex use before init
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Brandon Philips <brandon@ifup.org>, chris2553@googlemail.com,
        Dave Young <hidave.darkstar@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 10:45 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> While your patch fixes the issue, it has some other troubles, like to the presence of
> lock code at free_btres_lock(). It is possible to fix, but the better is to just
> use the core-assisted locking schema. This way, V4L2 core will serialize access to all
> ioctl's/open/close/mmap/read/poll operations, avoiding to have two processes accessing
> the hardware at the same time. Also, as there's just one lock, instead of 3, there's no
> risk of dead locks.
>
> The net result is a cleaner code, with just one lock.
>
> I tested the patch here with an bttv-based STB board (card=3, tuner=6), and it worked fine for me.
> Could you please test if this fixes the issue?

I tested your patch against 2.6.37-rc6 and it fixed both problems I was seeing.
Restarting hald 100 times did not oops and tvtime now again quits cleanly.

So as it "WorksForMe", you can add my Tested-By, if you want.

Thanks,

Torsten

> PS.: The patch is based against the bkl_removal patches, at my linux-next tree:
>
> http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=commit;h=673eb9ff33e26ee6f4278cdab06749aef1bbef5b
>
> (I just created the bkl_removal branch, so, it may take some time for you to see at the kernel.org
> mirrors, but it is basically changeset 673eb9ff. You may also just apply it on the top of the master
> branch of my linux-next tree).
>
> ---
>
> [media] bttv: Fix locking issues due to BKL removal code
>
> The BKL removal patch added a condition where the code would try to use a non-initialized
> lock. While a patch just addressing the issue is possible, there are some other troubles,
> like to the presence of lock code at free_btres_lock(), called on some places with the lock
> already taken. It is possible to fix, but the better is to just use the core-assisted
> locking schema.
>
> This way, V4L2 core will serialize access to all ioctl's/open/close/mmap/read/poll
> operations, avoiding to have two processes accessing the hardware at the same time.
> Also, as there's just one lock, instead of 3, there's no risk of dead locks.
>
> Tested with bttv STB, Gateway P/N 6000699 (card 3, tuner 6).
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
> index a529619..25e1ca0 100644
> --- a/drivers/media/video/bt8xx/bttv-driver.c
> +++ b/drivers/media/video/bt8xx/bttv-driver.c
> @@ -854,7 +854,6 @@ int check_alloc_btres_lock(struct bttv *btv, struct bttv_fh *fh, int bit)
>                xbits |= RESOURCE_VIDEO_READ | RESOURCE_VIDEO_STREAM;
>
>        /* is it free? */
> -       mutex_lock(&btv->lock);
>        if (btv->resources & xbits) {
>                /* no, someone else uses it */
>                goto fail;
> @@ -884,11 +883,9 @@ int check_alloc_btres_lock(struct bttv *btv, struct bttv_fh *fh, int bit)
>        /* it's free, grab it */
>        fh->resources  |= bit;
>        btv->resources |= bit;
> -       mutex_unlock(&btv->lock);
>        return 1;
>
>  fail:
> -       mutex_unlock(&btv->lock);
>        return 0;
>  }
>
> @@ -940,7 +937,6 @@ void free_btres_lock(struct bttv *btv, struct bttv_fh *fh, int bits)
>                /* trying to free ressources not allocated by us ... */
>                printk("bttv: BUG! (btres)\n");
>        }
> -       mutex_lock(&btv->lock);
>        fh->resources  &= ~bits;
>        btv->resources &= ~bits;
>
> @@ -951,8 +947,6 @@ void free_btres_lock(struct bttv *btv, struct bttv_fh *fh, int bits)
>
>        if (0 == (bits & VBI_RESOURCES))
>                disclaim_vbi_lines(btv);
> -
> -       mutex_unlock(&btv->lock);
>  }
>
>  /* ----------------------------------------------------------------------- */
> @@ -1713,28 +1707,20 @@ static int bttv_prepare_buffer(struct videobuf_queue *q,struct bttv *btv,
>
>                /* Make sure tvnorm and vbi_end remain consistent
>                   until we're done. */
> -               mutex_lock(&btv->lock);
>
>                norm = btv->tvnorm;
>
>                /* In this mode capturing always starts at defrect.top
>                   (default VDELAY), ignoring cropping parameters. */
>                if (btv->vbi_end > bttv_tvnorms[norm].cropcap.defrect.top) {
> -                       mutex_unlock(&btv->lock);
>                        return -EINVAL;
>                }
>
> -               mutex_unlock(&btv->lock);
> -
>                c.rect = bttv_tvnorms[norm].cropcap.defrect;
>        } else {
> -               mutex_lock(&btv->lock);
> -
>                norm = btv->tvnorm;
>                c = btv->crop[!!fh->do_crop];
>
> -               mutex_unlock(&btv->lock);
> -
>                if (width < c.min_scaled_width ||
>                    width > c.max_scaled_width ||
>                    height < c.min_scaled_height)
> @@ -1858,7 +1844,6 @@ static int bttv_s_std(struct file *file, void *priv, v4l2_std_id *id)
>        unsigned int i;
>        int err;
>
> -       mutex_lock(&btv->lock);
>        err = v4l2_prio_check(&btv->prio, fh->prio);
>        if (err)
>                goto err;
> @@ -1874,7 +1859,6 @@ static int bttv_s_std(struct file *file, void *priv, v4l2_std_id *id)
>        set_tvnorm(btv, i);
>
>  err:
> -       mutex_unlock(&btv->lock);
>
>        return err;
>  }
> @@ -1898,7 +1882,6 @@ static int bttv_enum_input(struct file *file, void *priv,
>        struct bttv *btv = fh->btv;
>        int rc = 0;
>
> -       mutex_lock(&btv->lock);
>        if (i->index >= bttv_tvcards[btv->c.type].video_inputs) {
>                rc = -EINVAL;
>                goto err;
> @@ -1928,7 +1911,6 @@ static int bttv_enum_input(struct file *file, void *priv,
>        i->std = BTTV_NORMS;
>
>  err:
> -       mutex_unlock(&btv->lock);
>
>        return rc;
>  }
> @@ -1938,9 +1920,7 @@ static int bttv_g_input(struct file *file, void *priv, unsigned int *i)
>        struct bttv_fh *fh = priv;
>        struct bttv *btv = fh->btv;
>
> -       mutex_lock(&btv->lock);
>        *i = btv->input;
> -       mutex_unlock(&btv->lock);
>
>        return 0;
>  }
> @@ -1952,7 +1932,6 @@ static int bttv_s_input(struct file *file, void *priv, unsigned int i)
>
>        int err;
>
> -       mutex_lock(&btv->lock);
>        err = v4l2_prio_check(&btv->prio, fh->prio);
>        if (unlikely(err))
>                goto err;
> @@ -1965,7 +1944,6 @@ static int bttv_s_input(struct file *file, void *priv, unsigned int i)
>        set_input(btv, i, btv->tvnorm);
>
>  err:
> -       mutex_unlock(&btv->lock);
>        return 0;
>  }
>
> @@ -1979,7 +1957,6 @@ static int bttv_s_tuner(struct file *file, void *priv,
>        if (unlikely(0 != t->index))
>                return -EINVAL;
>
> -       mutex_lock(&btv->lock);
>        if (unlikely(btv->tuner_type == TUNER_ABSENT)) {
>                err = -EINVAL;
>                goto err;
> @@ -1995,7 +1972,6 @@ static int bttv_s_tuner(struct file *file, void *priv,
>                btv->audio_mode_gpio(btv, t, 1);
>
>  err:
> -       mutex_unlock(&btv->lock);
>
>        return 0;
>  }
> @@ -2006,10 +1982,8 @@ static int bttv_g_frequency(struct file *file, void *priv,
>        struct bttv_fh *fh  = priv;
>        struct bttv *btv = fh->btv;
>
> -       mutex_lock(&btv->lock);
>        f->type = btv->radio_user ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>        f->frequency = btv->freq;
> -       mutex_unlock(&btv->lock);
>
>        return 0;
>  }
> @@ -2024,7 +1998,6 @@ static int bttv_s_frequency(struct file *file, void *priv,
>        if (unlikely(f->tuner != 0))
>                return -EINVAL;
>
> -       mutex_lock(&btv->lock);
>        err = v4l2_prio_check(&btv->prio, fh->prio);
>        if (unlikely(err))
>                goto err;
> @@ -2039,7 +2012,6 @@ static int bttv_s_frequency(struct file *file, void *priv,
>        if (btv->has_matchbox && btv->radio_user)
>                tea5757_set_freq(btv, btv->freq);
>  err:
> -       mutex_unlock(&btv->lock);
>
>        return 0;
>  }
> @@ -2172,7 +2144,6 @@ limit_scaled_size_lock       (struct bttv_fh *               fh,
>
>        /* Make sure tvnorm, vbi_end and the current cropping parameters
>           remain consistent until we're done. */
> -       mutex_lock(&btv->lock);
>
>        b = &bttv_tvnorms[btv->tvnorm].cropcap.bounds;
>
> @@ -2250,7 +2221,6 @@ limit_scaled_size_lock       (struct bttv_fh *               fh,
>        rc = 0; /* success */
>
>  fail:
> -       mutex_unlock(&btv->lock);
>
>        return rc;
>  }
> @@ -2282,9 +2252,7 @@ verify_window_lock                (struct bttv_fh *               fh,
>        if (V4L2_FIELD_ANY == field) {
>                __s32 height2;
>
> -               mutex_lock(&fh->btv->lock);
>                height2 = fh->btv->crop[!!fh->do_crop].rect.height >> 1;
> -               mutex_unlock(&fh->btv->lock);
>                field = (win->w.height > height2)
>                        ? V4L2_FIELD_INTERLACED
>                        : V4L2_FIELD_TOP;
> @@ -2360,7 +2328,6 @@ static int setup_window_lock(struct bttv_fh *fh, struct bttv *btv,
>                }
>        }
>
> -       mutex_lock(&fh->cap.vb_lock);
>        /* clip against screen */
>        if (NULL != btv->fbuf.base)
>                n = btcx_screen_clips(btv->fbuf.fmt.width, btv->fbuf.fmt.height,
> @@ -2412,7 +2379,6 @@ static int setup_window_lock(struct bttv_fh *fh, struct bttv *btv,
>                bttv_overlay_risc(btv, &fh->ov, fh->ovfmt, new);
>                retval = bttv_switch_overlay(btv,fh,new);
>        }
> -       mutex_unlock(&fh->cap.vb_lock);
>        return retval;
>  }
>
> @@ -2526,9 +2492,7 @@ static int bttv_try_fmt_vid_cap(struct file *file, void *priv,
>        if (V4L2_FIELD_ANY == field) {
>                __s32 height2;
>
> -               mutex_lock(&btv->lock);
>                height2 = btv->crop[!!fh->do_crop].rect.height >> 1;
> -               mutex_unlock(&btv->lock);
>                field = (f->fmt.pix.height > height2)
>                        ? V4L2_FIELD_INTERLACED
>                        : V4L2_FIELD_BOTTOM;
> @@ -2614,7 +2578,6 @@ static int bttv_s_fmt_vid_cap(struct file *file, void *priv,
>        fmt = format_by_fourcc(f->fmt.pix.pixelformat);
>
>        /* update our state informations */
> -       mutex_lock(&fh->cap.vb_lock);
>        fh->fmt              = fmt;
>        fh->cap.field        = f->fmt.pix.field;
>        fh->cap.last         = V4L2_FIELD_NONE;
> @@ -2623,7 +2586,6 @@ static int bttv_s_fmt_vid_cap(struct file *file, void *priv,
>        btv->init.fmt        = fmt;
>        btv->init.width      = f->fmt.pix.width;
>        btv->init.height     = f->fmt.pix.height;
> -       mutex_unlock(&fh->cap.vb_lock);
>
>        return 0;
>  }
> @@ -2649,11 +2611,9 @@ static int vidiocgmbuf(struct file *file, void *priv, struct video_mbuf *mbuf)
>        unsigned int i;
>        struct bttv_fh *fh = priv;
>
> -       mutex_lock(&fh->cap.vb_lock);
>        retval = __videobuf_mmap_setup(&fh->cap, gbuffers, gbufsize,
>                                     V4L2_MEMORY_MMAP);
>        if (retval < 0) {
> -               mutex_unlock(&fh->cap.vb_lock);
>                return retval;
>        }
>
> @@ -2665,7 +2625,6 @@ static int vidiocgmbuf(struct file *file, void *priv, struct video_mbuf *mbuf)
>        for (i = 0; i < gbuffers; i++)
>                mbuf->offsets[i] = i * gbufsize;
>
> -       mutex_unlock(&fh->cap.vb_lock);
>        return 0;
>  }
>  #endif
> @@ -2775,10 +2734,8 @@ static int bttv_overlay(struct file *file, void *f, unsigned int on)
>        int retval = 0;
>
>        if (on) {
> -               mutex_lock(&fh->cap.vb_lock);
>                /* verify args */
>                if (unlikely(!btv->fbuf.base)) {
> -                       mutex_unlock(&fh->cap.vb_lock);
>                        return -EINVAL;
>                }
>                if (unlikely(!fh->ov.setup_ok)) {
> @@ -2787,13 +2744,11 @@ static int bttv_overlay(struct file *file, void *f, unsigned int on)
>                }
>                if (retval)
>                        return retval;
> -               mutex_unlock(&fh->cap.vb_lock);
>        }
>
>        if (!check_alloc_btres_lock(btv, fh, RESOURCE_OVERLAY))
>                return -EBUSY;
>
> -       mutex_lock(&fh->cap.vb_lock);
>        if (on) {
>                fh->ov.tvnorm = btv->tvnorm;
>                new = videobuf_sg_alloc(sizeof(*new));
> @@ -2805,7 +2760,6 @@ static int bttv_overlay(struct file *file, void *f, unsigned int on)
>
>        /* switch over */
>        retval = bttv_switch_overlay(btv, fh, new);
> -       mutex_unlock(&fh->cap.vb_lock);
>        return retval;
>  }
>
> @@ -2844,7 +2798,6 @@ static int bttv_s_fbuf(struct file *file, void *f,
>        }
>
>        /* ok, accept it */
> -       mutex_lock(&fh->cap.vb_lock);
>        btv->fbuf.base       = fb->base;
>        btv->fbuf.fmt.width  = fb->fmt.width;
>        btv->fbuf.fmt.height = fb->fmt.height;
> @@ -2876,7 +2829,6 @@ static int bttv_s_fbuf(struct file *file, void *f,
>                        retval = bttv_switch_overlay(btv, fh, new);
>                }
>        }
> -       mutex_unlock(&fh->cap.vb_lock);
>        return retval;
>  }
>
> @@ -2955,7 +2907,6 @@ static int bttv_queryctrl(struct file *file, void *priv,
>             c->id >= V4L2_CID_PRIVATE_LASTP1))
>                return -EINVAL;
>
> -       mutex_lock(&btv->lock);
>        if (!btv->volume_gpio && (c->id == V4L2_CID_AUDIO_VOLUME))
>                *c = no_ctl;
>        else {
> @@ -2963,7 +2914,6 @@ static int bttv_queryctrl(struct file *file, void *priv,
>
>                *c = (NULL != ctrl) ? *ctrl : no_ctl;
>        }
> -       mutex_unlock(&btv->lock);
>
>        return 0;
>  }
> @@ -2974,10 +2924,8 @@ static int bttv_g_parm(struct file *file, void *f,
>        struct bttv_fh *fh = f;
>        struct bttv *btv = fh->btv;
>
> -       mutex_lock(&btv->lock);
>        v4l2_video_std_frame_period(bttv_tvnorms[btv->tvnorm].v4l2_id,
>                                    &parm->parm.capture.timeperframe);
> -       mutex_unlock(&btv->lock);
>
>        return 0;
>  }
> @@ -2993,7 +2941,6 @@ static int bttv_g_tuner(struct file *file, void *priv,
>        if (0 != t->index)
>                return -EINVAL;
>
> -       mutex_lock(&btv->lock);
>        t->rxsubchans = V4L2_TUNER_SUB_MONO;
>        bttv_call_all(btv, tuner, g_tuner, t);
>        strcpy(t->name, "Television");
> @@ -3005,7 +2952,6 @@ static int bttv_g_tuner(struct file *file, void *priv,
>        if (btv->audio_mode_gpio)
>                btv->audio_mode_gpio(btv, t, 0);
>
> -       mutex_unlock(&btv->lock);
>        return 0;
>  }
>
> @@ -3014,9 +2960,7 @@ static int bttv_g_priority(struct file *file, void *f, enum v4l2_priority *p)
>        struct bttv_fh *fh = f;
>        struct bttv *btv = fh->btv;
>
> -       mutex_lock(&btv->lock);
>        *p = v4l2_prio_max(&btv->prio);
> -       mutex_unlock(&btv->lock);
>
>        return 0;
>  }
> @@ -3028,9 +2972,7 @@ static int bttv_s_priority(struct file *file, void *f,
>        struct bttv *btv = fh->btv;
>        int     rc;
>
> -       mutex_lock(&btv->lock);
>        rc = v4l2_prio_change(&btv->prio, &fh->prio, prio);
> -       mutex_unlock(&btv->lock);
>
>        return rc;
>  }
> @@ -3045,9 +2987,7 @@ static int bttv_cropcap(struct file *file, void *priv,
>            cap->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
>                return -EINVAL;
>
> -       mutex_lock(&btv->lock);
>        *cap = bttv_tvnorms[btv->tvnorm].cropcap;
> -       mutex_unlock(&btv->lock);
>
>        return 0;
>  }
> @@ -3065,9 +3005,7 @@ static int bttv_g_crop(struct file *file, void *f, struct v4l2_crop *crop)
>           inconsistent with fh->width or fh->height and apps
>           do not expect a change here. */
>
> -       mutex_lock(&btv->lock);
>        crop->c = btv->crop[!!fh->do_crop].rect;
> -       mutex_unlock(&btv->lock);
>
>        return 0;
>  }
> @@ -3091,17 +3029,14 @@ static int bttv_s_crop(struct file *file, void *f, struct v4l2_crop *crop)
>        /* Make sure tvnorm, vbi_end and the current cropping
>           parameters remain consistent until we're done. Note
>           read() may change vbi_end in check_alloc_btres_lock(). */
> -       mutex_lock(&btv->lock);
>        retval = v4l2_prio_check(&btv->prio, fh->prio);
>        if (0 != retval) {
> -               mutex_unlock(&btv->lock);
>                return retval;
>        }
>
>        retval = -EBUSY;
>
>        if (locked_btres(fh->btv, VIDEO_RESOURCES)) {
> -               mutex_unlock(&btv->lock);
>                return retval;
>        }
>
> @@ -3113,7 +3048,6 @@ static int bttv_s_crop(struct file *file, void *f, struct v4l2_crop *crop)
>
>        b_top = max(b->top, btv->vbi_end);
>        if (b_top + 32 >= b_bottom) {
> -               mutex_unlock(&btv->lock);
>                return retval;
>        }
>
> @@ -3136,12 +3070,8 @@ static int bttv_s_crop(struct file *file, void *f, struct v4l2_crop *crop)
>
>        btv->crop[1] = c;
>
> -       mutex_unlock(&btv->lock);
> -
>        fh->do_crop = 1;
>
> -       mutex_lock(&fh->cap.vb_lock);
> -
>        if (fh->width < c.min_scaled_width) {
>                fh->width = c.min_scaled_width;
>                btv->init.width = c.min_scaled_width;
> @@ -3158,8 +3088,6 @@ static int bttv_s_crop(struct file *file, void *f, struct v4l2_crop *crop)
>                btv->init.height = c.max_scaled_height;
>        }
>
> -       mutex_unlock(&fh->cap.vb_lock);
> -
>        return 0;
>  }
>
> @@ -3227,7 +3155,6 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
>                return videobuf_poll_stream(file, &fh->vbi, wait);
>        }
>
> -       mutex_lock(&fh->cap.vb_lock);
>        if (check_btres(fh,RESOURCE_VIDEO_STREAM)) {
>                /* streaming capture */
>                if (list_empty(&fh->cap.stream))
> @@ -3262,7 +3189,6 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
>        else
>                rc = 0;
>  err:
> -       mutex_unlock(&fh->cap.vb_lock);
>        return rc;
>  }
>
> @@ -3302,14 +3228,11 @@ static int bttv_open(struct file *file)
>         * Let's first copy btv->init at fh, holding cap.vb_lock, and then work
>         * with the rest of init, holding btv->lock.
>         */
> -       mutex_lock(&fh->cap.vb_lock);
>        *fh = btv->init;
> -       mutex_unlock(&fh->cap.vb_lock);
>
>        fh->type = type;
>        fh->ov.setup_ok = 0;
>
> -       mutex_lock(&btv->lock);
>        v4l2_prio_open(&btv->prio, &fh->prio);
>
>        videobuf_queue_sg_init(&fh->cap, &bttv_video_qops,
> @@ -3317,13 +3240,13 @@ static int bttv_open(struct file *file)
>                            V4L2_BUF_TYPE_VIDEO_CAPTURE,
>                            V4L2_FIELD_INTERLACED,
>                            sizeof(struct bttv_buffer),
> -                           fh, NULL);
> +                           fh, &btv->lock);
>        videobuf_queue_sg_init(&fh->vbi, &bttv_vbi_qops,
>                            &btv->c.pci->dev, &btv->s_lock,
>                            V4L2_BUF_TYPE_VBI_CAPTURE,
>                            V4L2_FIELD_SEQ_TB,
>                            sizeof(struct bttv_buffer),
> -                           fh, NULL);
> +                           fh, &btv->lock);
>        set_tvnorm(btv,btv->tvnorm);
>        set_input(btv, btv->input, btv->tvnorm);
>
> @@ -3346,7 +3269,6 @@ static int bttv_open(struct file *file)
>        bttv_vbi_fmt_reset(&fh->vbi_fmt, btv->tvnorm);
>
>        bttv_field_count(btv);
> -       mutex_unlock(&btv->lock);
>        return 0;
>  }
>
> @@ -3355,7 +3277,6 @@ static int bttv_release(struct file *file)
>        struct bttv_fh *fh = file->private_data;
>        struct bttv *btv = fh->btv;
>
> -       mutex_lock(&btv->lock);
>        /* turn off overlay */
>        if (check_btres(fh, RESOURCE_OVERLAY))
>                bttv_switch_overlay(btv,fh,NULL);
> @@ -3385,10 +3306,8 @@ static int bttv_release(struct file *file)
>         * videobuf uses cap.vb_lock - we should avoid holding btv->lock,
>         * otherwise we may have dead lock conditions
>         */
> -       mutex_unlock(&btv->lock);
>        videobuf_mmap_free(&fh->cap);
>        videobuf_mmap_free(&fh->vbi);
> -       mutex_lock(&btv->lock);
>        v4l2_prio_close(&btv->prio, fh->prio);
>        file->private_data = NULL;
>        kfree(fh);
> @@ -3398,7 +3317,6 @@ static int bttv_release(struct file *file)
>
>        if (!btv->users)
>                audio_mute(btv, 1);
> -       mutex_unlock(&btv->lock);
>
>        return 0;
>  }
> @@ -3502,11 +3420,8 @@ static int radio_open(struct file *file)
>        if (unlikely(!fh))
>                return -ENOMEM;
>        file->private_data = fh;
> -       mutex_lock(&fh->cap.vb_lock);
>        *fh = btv->init;
> -       mutex_unlock(&fh->cap.vb_lock);
>
> -       mutex_lock(&btv->lock);
>        v4l2_prio_open(&btv->prio, &fh->prio);
>
>        btv->radio_user++;
> @@ -3514,7 +3429,6 @@ static int radio_open(struct file *file)
>        bttv_call_all(btv, tuner, s_radio);
>        audio_input(btv,TVAUDIO_INPUT_RADIO);
>
> -       mutex_unlock(&btv->lock);
>        return 0;
>  }
>
> @@ -3524,7 +3438,6 @@ static int radio_release(struct file *file)
>        struct bttv *btv = fh->btv;
>        struct rds_command cmd;
>
> -       mutex_lock(&btv->lock);
>        v4l2_prio_close(&btv->prio, fh->prio);
>        file->private_data = NULL;
>        kfree(fh);
> @@ -3532,7 +3445,6 @@ static int radio_release(struct file *file)
>        btv->radio_user--;
>
>        bttv_call_all(btv, core, ioctl, RDS_CMD_CLOSE, &cmd);
> -       mutex_unlock(&btv->lock);
>
>        return 0;
>  }
> @@ -3561,7 +3473,6 @@ static int radio_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
>                return -EINVAL;
>        if (0 != t->index)
>                return -EINVAL;
> -       mutex_lock(&btv->lock);
>        strcpy(t->name, "Radio");
>        t->type = V4L2_TUNER_RADIO;
>
> @@ -3570,8 +3481,6 @@ static int radio_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
>        if (btv->audio_mode_gpio)
>                btv->audio_mode_gpio(btv, t, 0);
>
> -       mutex_unlock(&btv->lock);
> -
>        return 0;
>  }
>
> @@ -3692,7 +3601,7 @@ static const struct v4l2_file_operations radio_fops =
>        .open     = radio_open,
>        .read     = radio_read,
>        .release  = radio_release,
> -       .ioctl    = video_ioctl2,
> +       .unlocked_ioctl = video_ioctl2,
>        .poll     = radio_poll,
>  };
>
>
