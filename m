Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab0LNMFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 07:05:47 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33599 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab0LNMFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 07:05:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e32oKJ8wxAXny0E5Gliem07BidNLJsw1bSyiKWtVZ9inFwzxaECX2kRDySqHYCOSyT
         cozvhE+ApIPl1uHcvDbNstwmo4yf/itmNGbV5XDWhcW+hBrDE8i/YQp1nDx3/2cwij98
         tCEbEBUGBuC8ZqU73XFXX4BLtcDEiUMxyevC4=
Date: Tue, 14 Dec 2010 20:05:34 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Brandon Philips <brandon@ifup.org>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Chris Clayton <chris2553@googlemail.com>
Subject: Re: [PATCH] bttv: fix mutex use before init
Message-ID: <20101214120534.GA2483@darkstar>
References: <20101212131550.GA2608@darkstar>
 <AANLkTinaNjPjNbxE+OyRsY_jJxDW-pwehTPgyAWzqfzd@mail.gmail.com>
 <20101214003024.GA3575@hanuman.home.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214003024.GA3575@hanuman.home.ifup.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 04:30:24PM -0800, Brandon Philips wrote:
> On 17:13 Sun 12 Dec 2010, Torsten Kaiser wrote:
> >  * change &fh->cap.vb_lock in bttv_open() AND radio_open() to
> > &btv->init.cap.vb_lock
> >  * add a mutex_init(&btv->init.cap.vb_lock) to the setup of init in bttv_probe()
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

Tested this patch, seems fine. But there's still possible deadlock, kernel hangs with lockdep warning, I think maybe it is another issue.

Could some v4l2 guys who have deep understand about bttv driver have a look at this issue?

[  322.172772] bttv: driver version 0.9.18 loaded
[  322.172781] bttv: using 8 buffers with 2080k (520 pages) each for capture
[  322.173300] bttv: Bt8xx card found (0).
[  322.174510] bttv 0000:03:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  322.174560] bttv0: Bt878 (rev 17) at 0000:03:01.0, irq: 17, latency: 64, mmio: 0xd0001000
[  322.174679] bttv0: detected: Leadtek WinFast TV 2000 [card=34], PCI subsystem ID is 107d:6606
[  322.174687] bttv0: using: Leadtek WinFast 2000/ WinFast 2000 XP [card=34,autodetected]
[  322.175062] bttv0: gpio: en=00000000, out=00000000 in=003fbfff [init]
[  322.178792] bttv0: tuner type=5
[  322.254454] bttv0: audio absent, no audio device found!
[  322.289946] tuner 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
[  322.290944] tuner-simple 1-0061: creating new instance
[  322.290953] tuner-simple 1-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
[  322.295830] bttv0: registered device video0
[  322.300020] bttv0: registered device vbi0
[  322.303216] bttv0: registered device radio0
[  322.303636] bttv0: PLL: 28636363 => 35468950 .. ok
[  322.334635] Registered IR keymap rc-winfast
[  322.341201] input: bttv IR (card=34) as /devices/pci0000:00/0000:00:1e.0/0000:03:01.0/rc/rc0/input4
[  322.357025] rc0: bttv IR (card=34) as /devices/pci0000:00/0000:00:1e.0/0000:03:01.0/rc/rc0
[  382.342433] bttv0: PLL can sleep, using XTAL (28636363).
[  382.816353] irq event stamp: 1078776
[  382.816363] hardirqs last  enabled at (1078775): [<c105604d>] debug_check_no_locks_freed+0x102/0x113
[  382.816381] 
[  382.816384] =======================================================
[  382.816389] [ INFO: possible circular locking dependency detected ]
[  382.816394] 2.6.37-rc5-00062-g6313e3c-dirty #114
[  382.816398] -------------------------------------------------------
[  382.816403] kdetv/2109 is trying to acquire lock:
[  382.816408]  (&mm->mmap_sem){++++++}, at: [<c10b1bf5>] might_fault+0x47/0x81
[  382.816422] 
[  382.816424] but task is already holding lock:
[  382.816427]  (&q->vb_lock){+.+.+.}, at: [<e00af2be>] videobuf_queue_lock+0x10/0x12 [videobuf_core]
[  382.816442] 
[  382.816444] which lock already depends on the new lock.
[  382.816446] 
[  382.816449] 
[  382.816450] the existing dependency chain (in reverse order) is:
[  382.816455] 
[  382.816456] -> #1 (&q->vb_lock){+.+.+.}:
[  382.816463]        [<c10574dc>] lock_acquire+0xa1/0xc4
[  382.816472]        [<c14ef90d>] __mutex_lock_common+0x35/0x2dc
[  382.816482]        [<c14efc52>] mutex_lock_nested+0x30/0x38
[  382.816489]        [<e00af2be>] videobuf_queue_lock+0x10/0x12 [videobuf_core]
[  382.816499]        [<e00af339>] videobuf_mmap_mapper+0x69/0xc0 [videobuf_core]
[  382.816509]        [<e18aae49>] bttv_mmap+0x66/0x6d [bttv]
[  382.816522]        [<c140009a>] v4l2_mmap+0x5a/0x73
[  382.816532]        [<c10b7f0c>] mmap_region+0x24c/0x400
[  382.816540]        [<c10b82ef>] do_mmap_pgoff+0x22f/0x27f
[  382.816547]        [<c10b841c>] sys_mmap_pgoff+0xdd/0x119
[  382.816560]        [<c14f0d55>] syscall_call+0x7/0xb
[  382.816569] 
[  382.816571] -> #0 (&mm->mmap_sem){++++++}:
[  382.816577]        [<c105718c>] __lock_acquire+0x9d7/0xc86
[  382.816585]        [<c10574dc>] lock_acquire+0xa1/0xc4
[  382.816592]        [<c10b1c12>] might_fault+0x64/0x81
[  382.816599]        [<c1297552>] copy_to_user+0x2c/0xfe
[  382.816608]        [<e00b0851>] videobuf_read_stream+0x17f/0x24c [videobuf_core]
[  382.816619]        [<e18ab05b>] bttv_read+0xcf/0xe9 [bttv]
[  382.816633]        [<c14002bb>] v4l2_read+0x63/0x7f
[  382.816640]        [<c10ce67e>] vfs_read+0x81/0xdb
[  382.816649]        [<c10ce771>] sys_read+0x3b/0x60
[  382.816655]        [<c14f0d55>] syscall_call+0x7/0xb
[  382.816663] 
[  382.816665] other info that might help us debug this:
[  382.816667] 
[  382.816671] 1 lock held by kdetv/2109:
[  382.816675]  #0:  (&q->vb_lock){+.+.+.}, at: [<e00af2be>] videobuf_queue_lock+0x10/0x12 [videobuf_core]
[  382.816688] 
[  382.816690] stack backtrace:
[  382.816695] Pid: 2109, comm: kdetv Not tainted 2.6.37-rc5-00062-g6313e3c-dirty #114
[  382.816700] Call Trace:
[  382.816639] hardirqs last disabled at (1078776): [<c1002ea7>] common_interrupt+0x27/0x34
[  382.816639] softirqs last  enabled at (1078294): [<c1034a8b>] __do_softirq+0x17b/0x183
[  382.816639] softirqs last disabled at (1078271): [<c1003ffb>] do_softirq+0x67/0xc0
[  382.816738]  [<c14ee80b>] ? printk+0x20/0x24
[  382.816748]  [<c1056480>] print_circular_bug+0x9c/0xa8
[  382.816758]  [<c105718c>] __lock_acquire+0x9d7/0xc86
[  382.816769]  [<c103a908>] ? __mod_timer+0x10c/0x117
[  382.816779]  [<c10574dc>] lock_acquire+0xa1/0xc4
[  382.816788]  [<c10b1bf5>] ? might_fault+0x47/0x81
[  382.816798]  [<c10b1c12>] might_fault+0x64/0x81
[  382.816807]  [<c10b1bf5>] ? might_fault+0x47/0x81
[  382.816815]  [<c1297552>] copy_to_user+0x2c/0xfe
[  382.816828]  [<e00b0851>] videobuf_read_stream+0x17f/0x24c [videobuf_core]
[  382.816844]  [<e18ab05b>] bttv_read+0xcf/0xe9 [bttv]
[  382.816854]  [<c14002bb>] v4l2_read+0x63/0x7f
[  382.816865]  [<c1400258>] ? v4l2_read+0x0/0x7f
[  382.816874]  [<c10ce67e>] vfs_read+0x81/0xdb
[  382.816883]  [<c10ce771>] sys_read+0x3b/0x60
[  382.816893]  [<c14f0d55>] syscall_call+0x7/0xb
[  382.816902]  [<c14f0000>] ? rt_mutex_trylock+0x2a/0x2d

> 
> Signed-off-by: Brandon Philips <bphilips@suse.de>
> ---
>  drivers/media/video/bt8xx/bttv-driver.c |   24 +++++++++++++-----------
>  1 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
> index a529619..e656424 100644
> --- a/drivers/media/video/bt8xx/bttv-driver.c
> +++ b/drivers/media/video/bt8xx/bttv-driver.c
> @@ -2391,16 +2391,11 @@ static int setup_window_lock(struct bttv_fh *fh, struct bttv *btv,
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
> +	mutex_lock(&btv->init.cap.vb_lock);
>  	btv->init.ov.w.width   = win->w.width;
>  	btv->init.ov.w.height  = win->w.height;
>  	btv->init.ov.field     = win->field;
> +	mutex_unlock(&btv->init.cap.vb_lock);
>  
>  	/* update overlay if needed */
>  	retval = 0;
> @@ -2620,9 +2615,11 @@ static int bttv_s_fmt_vid_cap(struct file *file, void *priv,
>  	fh->cap.last         = V4L2_FIELD_NONE;
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
> @@ -3141,6 +3140,7 @@ static int bttv_s_crop(struct file *file, void *f, struct v4l2_crop *crop)
>  	fh->do_crop = 1;
>  
>  	mutex_lock(&fh->cap.vb_lock);
> +	mutex_lock(&btv->init.cap.vb_lock);
>  
>  	if (fh->width < c.min_scaled_width) {
>  		fh->width = c.min_scaled_width;
> @@ -3158,6 +3158,7 @@ static int bttv_s_crop(struct file *file, void *f, struct v4l2_crop *crop)
>  		btv->init.height = c.max_scaled_height;
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
> -- 
> 1.7.3.1
> 
