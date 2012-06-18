Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010Ab2FRKpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:45:55 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62771 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab2FRKpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:45:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120618102108.GD23134@redhat.com>
References: <1340002390-3950-1-git-send-email-asias@redhat.com>
	<1340002390-3950-4-git-send-email-asias@redhat.com>
	<20120618102108.GD23134@redhat.com>
Date: Mon, 18 Jun 2012 11:45:52 +0100
Message-ID: <CAJSP0QXQi5bjza7yRbBBJCjrC0BzafY1-T5aq8tGb+-S0CToYg@mail.gmail.com>
Subject: Re: [PATCH 3/3] virtio-blk: Add bio-based IO path for virtio-blk
From: Stefan Hajnoczi <stefanha@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Asias He <asias@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Christoph Hellwig <hch@lst.de>,
        Minchan Kim <minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 11:21 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Mon, Jun 18, 2012 at 02:53:10PM +0800, Asias He wrote:
>> +static void virtblk_make_request(struct request_queue *q, struct bio *bio)
>> +{
>> +     struct virtio_blk *vblk = q->queuedata;
>> +     unsigned int num, out = 0, in = 0;
>> +     struct virtblk_req *vbr;
>> +
>> +     BUG_ON(bio->bi_phys_segments + 2 > vblk->sg_elems);
>> +     BUG_ON(bio->bi_rw & (REQ_FLUSH | REQ_FUA));
>> +
>> +     vbr = virtblk_alloc_req(vblk, GFP_NOIO);
>> +     if (!vbr) {
>> +             bio_endio(bio, -ENOMEM);
>> +             return;
>> +     }
>> +
>> +     vbr->bio = bio;
>> +     vbr->req = NULL;
>> +     vbr->out_hdr.type = 0;
>> +     vbr->out_hdr.sector = bio->bi_sector;
>> +     vbr->out_hdr.ioprio = bio_prio(bio);
>> +
>> +     sg_set_buf(&vbr->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
>> +
>> +     num = blk_bio_map_sg(q, bio, vbr->sg + out);
>> +
>> +     sg_set_buf(&vbr->sg[num + out + in++], &vbr->status,
>> +                sizeof(vbr->status));
>> +
>> +     if (num) {
>> +             if (bio->bi_rw & REQ_WRITE) {
>> +                     vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
>> +                     out += num;
>> +             } else {
>> +                     vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
>> +                     in += num;
>> +             }
>> +     }
>> +
>> +     spin_lock_irq(vblk->disk->queue->queue_lock);
>> +     if (virtqueue_add_buf(vblk->vq, vbr->sg, out, in, vbr,
>> +                           GFP_ATOMIC) < 0) {
>> +             spin_unlock_irq(vblk->disk->queue->queue_lock);
>
> Any implications of dropping lock like that?
> E.g. for suspend. like we are still discussing with
> unlocked kick?

Since we aquired the lock in this function there should be no problem.
 Whatever protects against vblk or vblk->disk disappearing upon
entering this function also protects after unlocking queue_lock.
Otherwise all .make_request_fn() functions would be broken.

I'd still like to understand the details though.

Stefan
