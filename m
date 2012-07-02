Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab2GBBxc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 21:53:32 -0400
Received: from ozlabs.org ([203.10.76.45]:58304 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab2GBBwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 21:52:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: RFD: virtio balloon API use (was Re: [PATCH 5 of 5] virtio: expose added descriptors immediately)
In-Reply-To: <20120701092051.GA4515@redhat.com>
References: <patchbomb.1320306168@localhost6.localdomain6> <f3831c1617c86a51d875.1320306173@localhost6.localdomain6> <20120701092051.GA4515@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 02 Jul 2012 10:35:47 +0930
Message-ID: <87d34fx990.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jul 2012 12:20:51 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Nov 03, 2011 at 06:12:53PM +1030, Rusty Russell wrote:
> > A virtio driver does virtqueue_add_buf() multiple times before finally
> > calling virtqueue_kick(); previously we only exposed the added buffers
> > in the virtqueue_kick() call.  This means we don't need a memory
> > barrier in virtqueue_add_buf(), but it reduces concurrency as the
> > device (ie. host) can't see the buffers until the kick.
> > 
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Looking at recent mm compaction patches made me look at locking
> in balloon closely. And I noticed the referenced patch (commit
> ee7cd8981e15bcb365fc762afe3fc47b8242f630 upstream) interacts strangely
> with virtio balloon; balloon currently does:
> 
> static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
> {
>         struct scatterlist sg;
> 
>         sg_init_one(&sg, vb->pfns, sizeof(vb->pfns[0]) * vb->num_pfns);
> 
>         init_completion(&vb->acked);
> 
>         /* We should always be able to add one buffer to an empty queue. */
>         if (virtqueue_add_buf(vq, &sg, 1, 0, vb, GFP_KERNEL) < 0)
>                 BUG();
>         virtqueue_kick(vq);
> 
>         /* When host has read buffer, this completes via balloon_ack */
>         wait_for_completion(&vb->acked);
> }
> 
> 
> While vq callback does:
> 
> static void balloon_ack(struct virtqueue *vq)
> {
>         struct virtio_balloon *vb;
>         unsigned int len;
> 
>         vb = virtqueue_get_buf(vq, &len);
>         if (vb)
>                 complete(&vb->acked);
> }
> 
> 
> So virtqueue_get_buf might now run concurrently with virtqueue_kick.
> I audited both and this seems safe in practice but I think

Good spotting!

Agreed.  Because there's only add_buf, we get away with it: the add_buf
must be almost finished by the time get_buf runs because the device has
seen the buffer.

> we need to either declare this legal at the API level
> or add locking in driver.

I wonder if we should just lock in the balloon driver, rather than
document this corner case and set a bad example.  Are there other
drivers which take the same shortcut?

> Further, is there a guarantee that we never get
> spurious callbacks?  We currently check ring not empty
> but esp for non shared MSI this might not be needed.

Yes, I think this saves us.  A spurious interrupt won't trigger
a spurious callback.

> If a spurious callback triggers, virtqueue_get_buf can run
> concurrently with virtqueue_add_buf which is known to be racy.
> Again I think this is currently safe as no spurious callbacks in
> practice but should we guarantee no spurious callbacks at the API level
> or add locking in driver?

I think we should guarantee it, but is there a hole in the current
implementation?

Thanks,
Rusty.
