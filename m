Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab1KBD0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 23:26:01 -0400
Received: from ozlabs.org ([203.10.76.45]:56823 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab1KBDZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 23:25:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Wright <chrisw@sous-sol.org>,
        Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] virtio: support unlocked queue kick
In-Reply-To: <20111101144045.GA15433@redhat.com>
References: <20111005195403.407628164@bombadil.infradead.org> <20111005195529.964397366@bombadil.infradead.org> <87r52qgaf3.fsf@rustcorp.com.au> <20111006131828.GC19023@redhat.com> <20111101144045.GA15433@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 02 Nov 2011 13:49:36 +1030
Message-ID: <87ty6ntdmf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Nov 2011 16:40:45 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Oct 06, 2011 at 11:18:28AM -0200, Michael S. Tsirkin wrote:
> > On Thu, Oct 06, 2011 at 12:15:36PM +1030, Rusty Russell wrote:
> > > On Wed, 05 Oct 2011 15:54:05 -0400, Christoph Hellwig <hch@infradead.org> wrote:
> > > > Split virtqueue_kick to be able to do the actual notification outside the
> > > > lock protecting the virtqueue.  This patch was originally done by
> > > An alternative to this is to update the ring on every virtqueue_add_buf.
> > > MST discussed this for virtio_net, and I think it's better in general.
> > > 
> > > The only reason that it wasn't written that way originally is that the
> > > barriers make add_buf slightly more expensive.
> > 
> > With event index, I'm not sure that's enough to make the kick lockless
> > anymore.
> 
> Hmm, any comment on this? These have been benchmarked
> to give a sizeable speedup, so I'm thinking it's better to take
> the patches as is, if someone has the inclination to redo
> the work with an atomic virtqueue_add_buf, that can
> be applied on top.

I thought it was still a WIP?

Since the problem is contention on the lock inside the block layer, the
simplest solution is to have a separate lock to protect the virtqueue.

A bit more work for virtio_blk, but probably in the noise.  And it
eliminated the number of gratuitous wakeups a race would cause in the
lockless patch.

Something like this (untested):

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -19,8 +19,12 @@ struct workqueue_struct *virtblk_wq;
 
 struct virtio_blk
 {
+	/* Lock for block layer. */
 	spinlock_t lock;
 
+	/* Lock for virtqueue (nests inside vblk->lock). */
+	spinlock_t vq_lock;
+
 	struct virtio_device *vdev;
 	struct virtqueue *vq;
 
@@ -62,6 +66,7 @@ static void blk_done(struct virtqueue *v
 	unsigned long flags;
 
 	spin_lock_irqsave(&vblk->lock, flags);
+	spin_lock(&vblk->vq_lock);
 	while ((vbr = virtqueue_get_buf(vblk->vq, &len)) != NULL) {
 		int error;
 
@@ -94,6 +99,7 @@ static void blk_done(struct virtqueue *v
 		list_del(&vbr->list);
 		mempool_free(vbr, vblk->pool);
 	}
+	spin_unlock(&vblk->vq_lock);
 	/* In case queue is stopped waiting for more buffers. */
 	blk_start_queue(vblk->disk->queue);
 	spin_unlock_irqrestore(&vblk->lock, flags);
@@ -171,10 +177,13 @@ static bool do_req(struct request_queue 
 		}
 	}
 
+	spin_lock(&vblk->vq_lock);
 	if (virtqueue_add_buf(vblk->vq, vblk->sg, out, in, vbr) < 0) {
+		spin_unlock(&vblk->vq_lock);
 		mempool_free(vbr, vblk->pool);
 		return false;
 	}
+	spin_unlock(&vblk->vq_lock);
 
 	list_add_tail(&vbr->list, &vblk->reqs);
 	return true;
@@ -199,8 +208,11 @@ static void do_virtblk_request(struct re
 		issued++;
 	}
 
-	if (issued)
+	if (issued) {
+		spin_lock(&vblk->vq_lock);
 		virtqueue_kick(vblk->vq);
+		spin_unlock(&vblk->vq_lock);
+	}
 }
 
 /* return id (s/n) string for *disk to *id_str
@@ -384,6 +396,7 @@ static int __devinit virtblk_probe(struc
 
 	INIT_LIST_HEAD(&vblk->reqs);
 	spin_lock_init(&vblk->lock);
+	spin_lock_init(&vblk->vq_lock);
 	vblk->vdev = vdev;
 	vblk->sg_elems = sg_elems;
 	sg_init_table(vblk->sg, vblk->sg_elems);
