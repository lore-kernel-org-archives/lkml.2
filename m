Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab1KPCeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 21:34:37 -0500
Received: from ozlabs.org ([203.10.76.45]:37948 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757716Ab1KPCdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 21:33:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 5 of 5] virtio: expose added descriptors immediately
In-Reply-To: <20111114065606.GA3779@redhat.com>
References: <patchbomb.1320306168@localhost6.localdomain6> <f3831c1617c86a51d875.1320306173@localhost6.localdomain6> <20111113210256.GA31621@redhat.com> <20111114065606.GA3779@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 16 Nov 2011 10:51:26 +1030
Message-ID: <871ut8q5mh.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Nov 2011 08:56:06 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Sun, Nov 13, 2011 at 11:03:13PM +0200, Michael S. Tsirkin wrote:
> > On Thu, Nov 03, 2011 at 06:12:53PM +1030, Rusty Russell wrote:
> > > A virtio driver does virtqueue_add_buf() multiple times before finally
> > > calling virtqueue_kick(); previously we only exposed the added buffers
> > > in the virtqueue_kick() call.  This means we don't need a memory
> > > barrier in virtqueue_add_buf(), but it reduces concurrency as the
> > > device (ie. host) can't see the buffers until the kick.
> > > 
> > > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > 
> > In the past I played with a patch like this, but I didn't see a
> > performance gain either way. Do you see any gain?
> > 
> > I'm a bit concerned that with this patch, a buggy driver that
> > adds more than 2^16 descriptors without a kick
> > would seem to work sometimes. Let's add WARN_ON(vq->num_added > (1 << 16))?
> 
> Thinking about it more - it might be tricky for drivers
> to ensure this. add used to fail when vq is full, but now
> driver might do get between add and notify:
> 	lock
> 	add_buf * N
> 	prep
> 	unlock
> 	lock
> 	get_buf * N
> 	unlock
> 	lock
> 	add_buf
> 	prep
> 	unlock
> 	notify
> 
> and since add was followed by get, this doesn't fail.

Right, the driver could, in theory, do:
        add_buf()
        if (!get_buf())
                notify()

But we don't allow that at the moment in our API: we insist on a notify
occasionally.  Noone does this at the moment, so a WARN_ON is correct.

If you're just add_buf() without the get_buf() then add_buf() will fail
already.

Here's my current variant:

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -245,9 +245,19 @@ add_head:
 
 	/* Put entry in available array (but don't update avail->idx until they
 	 * do sync). */
-	avail = ((vq->vring.avail->idx + vq->num_added++) & (vq->vring.num-1));
+	avail = (vq->vring.avail->idx & (vq->vring.num-1));
 	vq->vring.avail->ring[avail] = head;
 
+	/* Descriptors and available array need to be set before we expose the
+	 * new available array entries. */
+	virtio_wmb();
+	vq->vring.avail->idx++;
+	vq->num_added++;
+
+	/* If you haven't kicked in this long, you're probably doing something
+	 * wrong. */
+	WARN_ON(vq->num_added > vq->vring.num);
+
 	pr_debug("Added buffer head %i to %p\n", head, vq);
 	END_USE(vq);
 
It's hard to write a useful WARN_ON() for the "you should kick more
regularly" case (we could take timestamps if DEBUG is defined, I guess),
so let's leave this until someone actually trips it.

Thanks,
Rusty.

