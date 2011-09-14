Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab1INPfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 11:35:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60458 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab1INPfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 11:35:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110914143247.GA17206@phenom.oracle.com>
References: <20110907174832.GN32190@dumpdata.com> <4E6F50170200007800055CF5@nat28.tlf.novell.com>
 <20110914085913.GB25628@phenom.oracle.com> <4E708C240200007800055FDF@nat28.tlf.novell.com>
 <20110914143247.GA17206@phenom.oracle.com>
From: Mike Snitzer <snitzer@redhat.com>
Date: Wed, 14 Sep 2011 11:34:55 -0400
X-Google-Sender-Auth: ghsiA1ETWgc5Lajd5uJL5KoCvKQ
Message-ID: <CAMM=eLcvpQRef34-xoxg8qpJiexqesdhcauhU+dRgBw5wNVoag@mail.gmail.com>
Subject: Re: Help with implementing some form of barriers in 3.0 kernels.
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jan Beulich <JBeulich@suse.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        hch@infradead.org, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 10:32 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
> > > +   if (drain) {
> > > +           struct request_queue *q = bdev_get_queue(preq.bdev);
> > > +           unsigned long flags;
> > > +
>
> > > +           /* Emulate the original behavior of write barriers */
> > > +           spin_lock_irqsave(q->queue_lock, flags);
> > > +           elv_drain_elevator(q);
> > > +           __blk_run_queue(q);
> > > +           spin_unlock_irqrestore(q->queue_lock, flags);
> > > +   }
> I also had to add:
>
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index eaf49d1..20fddbc 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -679,6 +679,10 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>                struct request_queue *q = bdev_get_queue(preq.bdev);
>                unsigned long flags;
>
> +               if (!q->elevator) {
> +                       __end_block_io_op(pending_req, -EOPNOTSUPP);
> +                       return -EOPNOTSUPP;
> +               }
>                /* Emulate the original behavior of write barriers */
>                spin_lock_irqsave(q->queue_lock, flags);
>                elv_drain_elevator(q);
> diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
> index 52d8893..722714a 100644
> --- a/drivers/block/xen-blkback/common.h
> +++ b/drivers/block/xen-blkback/common.h
> @@ -157,6 +157,7 @@ struct xen_vbd {
>        /* Cached size parameter. */
>        sector_t                size;
>        bool                    flush_support;
> +       bool                    barrier_support;
>  };
>
>  struct backend_info;
> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> index da1e27a..7189ecd 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -384,6 +384,9 @@ static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
>        if (q && q->flush_flags)
>                vbd->flush_support = true;
>
> +       if (q && q->elevator && q->elevator->ops)
> +               vbd->barrier_support = true;
> +
>        DPRINTK("Successful creation of handle=%04x (dom=%u)\n",
>                handle, blkif->domid);
>        return 0;
> @@ -728,7 +731,7 @@ again:
>        if (err)
>                goto abort;
>
> -       err = xen_blkbk_barrier(xbt, be, be->blkif->vbd.flush_support);
> +       err = xen_blkbk_barrier(xbt, be, be->blkif->vbd.barrier_support);
>
>        err = xen_blkbk_discard(xbt, be);
>
>
> Otherwise it would crash.. Thought I am not sure why the elevator is not
> set (the guest is on a LVM LV).

bio-based DM devices do not have an elevator.  But that doesn't mean
barriers (or FLUSH/FUA) aren't supported and/or needed by the
underlying devices.
