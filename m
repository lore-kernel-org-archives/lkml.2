Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab2GBHZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 03:25:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272Ab2GBHZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 03:25:49 -0400
Date: Mon, 2 Jul 2012 10:25:58 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Rafael Aquini <aquini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: RFD: virtio balloon API use (was Re: [PATCH 5 of 5] virtio:
 expose added descriptors immediately)
Message-ID: <20120702072558.GA8268@redhat.com>
References: <patchbomb.1320306168@localhost6.localdomain6>
 <f3831c1617c86a51d875.1320306173@localhost6.localdomain6>
 <20120701092051.GA4515@redhat.com>
 <87d34fx990.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d34fx990.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 10:35:47AM +0930, Rusty Russell wrote:
> On Sun, 1 Jul 2012 12:20:51 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Thu, Nov 03, 2011 at 06:12:53PM +1030, Rusty Russell wrote:
> > > A virtio driver does virtqueue_add_buf() multiple times before finally
> > > calling virtqueue_kick(); previously we only exposed the added buffers
> > > in the virtqueue_kick() call.  This means we don't need a memory
> > > barrier in virtqueue_add_buf(), but it reduces concurrency as the
> > > device (ie. host) can't see the buffers until the kick.
> > > 
> > > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > 
> > Looking at recent mm compaction patches made me look at locking
> > in balloon closely. And I noticed the referenced patch (commit
> > ee7cd8981e15bcb365fc762afe3fc47b8242f630 upstream) interacts strangely
> > with virtio balloon; balloon currently does:
> > 
> > static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
> > {
> >         struct scatterlist sg;
> > 
> >         sg_init_one(&sg, vb->pfns, sizeof(vb->pfns[0]) * vb->num_pfns);
> > 
> >         init_completion(&vb->acked);
> > 
> >         /* We should always be able to add one buffer to an empty queue. */
> >         if (virtqueue_add_buf(vq, &sg, 1, 0, vb, GFP_KERNEL) < 0)
> >                 BUG();
> >         virtqueue_kick(vq);
> > 
> >         /* When host has read buffer, this completes via balloon_ack */
> >         wait_for_completion(&vb->acked);
> > }
> > 
> > 
> > While vq callback does:
> > 
> > static void balloon_ack(struct virtqueue *vq)
> > {
> >         struct virtio_balloon *vb;
> >         unsigned int len;
> > 
> >         vb = virtqueue_get_buf(vq, &len);
> >         if (vb)
> >                 complete(&vb->acked);
> > }
> > 
> > 
> > So virtqueue_get_buf might now run concurrently with virtqueue_kick.
> > I audited both and this seems safe in practice but I think
> 
> Good spotting!
> 
> Agreed.  Because there's only add_buf, we get away with it: the add_buf
> must be almost finished by the time get_buf runs because the device has
> seen the buffer.
> 
> > we need to either declare this legal at the API level
> > or add locking in driver.
> 
> I wonder if we should just lock in the balloon driver, rather than
> document this corner case and set a bad example.

We'll need to replace &vb->acked with a waitqueue
and do get_buf from the same thread.
But I note that stats_request hash the same issue.
Let's see if we can fix it.

> Are there other
> drivers which take the same shortcut?

Not that I know.

> > Further, is there a guarantee that we never get
> > spurious callbacks?  We currently check ring not empty
> > but esp for non shared MSI this might not be needed.
> 
> Yes, I think this saves us.  A spurious interrupt won't trigger
> a spurious callback.
> 
> > If a spurious callback triggers, virtqueue_get_buf can run
> > concurrently with virtqueue_add_buf which is known to be racy.
> > Again I think this is currently safe as no spurious callbacks in
> > practice but should we guarantee no spurious callbacks at the API level
> > or add locking in driver?
> 
> I think we should guarantee it, but is there a hole in the current
> implementation?
> 
> Thanks,
> Rusty.

Could be. The check for ring empty looks somewhat suspicious.
It might be expensive to make it 100% robust - that check was
intended as an optimization for shared interrupts.
Whith per vq interrupts we IMO do not need the check.
If we add locking in balloon I think there's no need
to guarantee no spurious interrupts.


-- 
MST
