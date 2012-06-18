Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab2FRKVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:21:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab2FRKVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:21:17 -0400
Date: Mon, 18 Jun 2012 13:21:08 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Asias He <asias@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Christoph Hellwig <hch@lst.de>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/3] virtio-blk: Add bio-based IO path for virtio-blk
Message-ID: <20120618102108.GD23134@redhat.com>
References: <1340002390-3950-1-git-send-email-asias@redhat.com>
 <1340002390-3950-4-git-send-email-asias@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340002390-3950-4-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 02:53:10PM +0800, Asias He wrote:
> +static void virtblk_make_request(struct request_queue *q, struct bio *bio)
> +{
> +	struct virtio_blk *vblk = q->queuedata;
> +	unsigned int num, out = 0, in = 0;
> +	struct virtblk_req *vbr;
> +
> +	BUG_ON(bio->bi_phys_segments + 2 > vblk->sg_elems);
> +	BUG_ON(bio->bi_rw & (REQ_FLUSH | REQ_FUA));
> +
> +	vbr = virtblk_alloc_req(vblk, GFP_NOIO);
> +	if (!vbr) {
> +		bio_endio(bio, -ENOMEM);
> +		return;
> +	}
> +
> +	vbr->bio = bio;
> +	vbr->req = NULL;
> +	vbr->out_hdr.type = 0;
> +	vbr->out_hdr.sector = bio->bi_sector;
> +	vbr->out_hdr.ioprio = bio_prio(bio);
> +
> +	sg_set_buf(&vbr->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
> +
> +	num = blk_bio_map_sg(q, bio, vbr->sg + out);
> +
> +	sg_set_buf(&vbr->sg[num + out + in++], &vbr->status,
> +		   sizeof(vbr->status));
> +
> +	if (num) {
> +		if (bio->bi_rw & REQ_WRITE) {
> +			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
> +			out += num;
> +		} else {
> +			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
> +			in += num;
> +		}
> +	}
> +
> +	spin_lock_irq(vblk->disk->queue->queue_lock);
> +	if (virtqueue_add_buf(vblk->vq, vbr->sg, out, in, vbr,
> +			      GFP_ATOMIC) < 0) {
> +		spin_unlock_irq(vblk->disk->queue->queue_lock);

Any implications of dropping lock like that?
E.g. for suspend. like we are still discussing with
unlocked kick?

> +		virtblk_add_buf_wait(vblk, vbr, out, in);
> +	} else {
> +		virtqueue_kick(vblk->vq);

Why special case the first call? task state manipulation so expensive?

> +		spin_unlock_irq(vblk->disk->queue->queue_lock);
> +	}
> +}
> +
