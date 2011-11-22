Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab1KVBAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:00:03 -0500
Received: from ozlabs.org ([203.10.76.45]:36935 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757654Ab1KVA74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:59:56 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 5 of 5] virtio: expose added descriptors immediately
In-Reply-To: <20111121115702.GA27580@redhat.com>
References: <patchbomb.1320306168@localhost6.localdomain6> <f3831c1617c86a51d875.1320306173@localhost6.localdomain6> <20111113210256.GA31621@redhat.com> <20111114065606.GA3779@redhat.com> <871ut8q5mh.fsf@rustcorp.com.au> <20111116071838.GE5433@redhat.com> <8739dib5z6.fsf@rustcorp.com.au> <20111121115702.GA27580@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 22 Nov 2011 11:03:04 +1030
Message-ID: <87lir9xagv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011 13:57:04 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Mon, Nov 21, 2011 at 12:18:45PM +1030, Rusty Russell wrote:
> > On Wed, 16 Nov 2011 09:18:38 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > My unlocked kick patches will trip this warning: they make
> > > virtio-net do add + get without kick.
> > 
> > Heh, it's a good sign if they do, since that means you're running really
> > well :)
> 
> They don't in fact, in my testing :(. But I think they can with luck.
> 
> > > I think block with unlocked kick can trip it too:
> > > add, lock is dropped and then an interrupt can get.
> > > 
> > > We also don't need a kick each num - each 2^15 is enough.
> > > Why don't we do this at start of add_buf:
> > > if (vq->num_added >= 0x7fff)
> > > 	return -ENOSPC;
> > 
> > The warning was there in case a driver is never doing a kick, and
> > getting away with it (mostly) because the device is polling.  Let's not
> > penalize good drivers to catch bad ones.
> > 
> > How about we do this properly, like so:
> 
> Absolutely. But I think we also need to handle num_added
> overflow of a 15 bit counter, no? Otherwise the
> vring_need_event logic might give us false negatives ....
> I'm guessing we can just assume we need a kick in that case.

You're right.  Thankyou.  My immediate reaction of "make it an unsigned
long" doesn't work.

Here's the diff to what I posted before:

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -254,9 +254,10 @@ add_head:
 	vq->vring.avail->idx++;
 	vq->num_added++;
 
-	/* If you haven't kicked in this long, you're probably doing something
-	 * wrong. */
-	WARN_ON(vq->num_added > vq->vring.num);
+	/* This is very unlikely, but theoretically possible.  Kick
+	 * just in case. */
+	if (unlikely(vq->num_added == 65535))
+		virtqueue_kick(_vq);
 
 	pr_debug("Added buffer head %i to %p\n", head, vq);
 	END_USE(vq);
