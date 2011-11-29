Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab1K2Nwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 08:52:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab1K2Nwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 08:52:31 -0500
Date: Tue, 29 Nov 2011 15:54:06 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-ring: Use threshold for switching to indirect
 descriptors
Message-ID: <20111129135406.GB30966@redhat.com>
References: <1322559196-11139-1-git-send-email-levinsasha928@gmail.com>
 <20111129125622.GB19157@redhat.com>
 <1322573688.4395.11.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322573688.4395.11.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 03:34:48PM +0200, Sasha Levin wrote:
> On Tue, 2011-11-29 at 14:56 +0200, Michael S. Tsirkin wrote:
> > On Tue, Nov 29, 2011 at 11:33:16AM +0200, Sasha Levin wrote:
> > > Currently if VIRTIO_RING_F_INDIRECT_DESC is enabled we will use indirect
> > > descriptors even if we have plenty of space in the ring. This means that
> > > we take a performance hit at all times due to the overhead of creating
> > > indirect descriptors.
> > 
> > Is it the overhead of creating them or just allocating the pages?
> 
> My guess here is that it's the allocation since creating them is very
> similar to creating regular descriptors.

Well, there is some formatting overhead ...

> > The logic you propose is basically add direct as long as
> > the ring is mostly empty. So if the problem is in allocations,
> > one simple optimization for this one workload is add a small
> > cache of memory to use for indirect bufs. Of course building
> > a good API for this is where we got blocked in the past...
> 
> I thought the issue of using a single pool was that the sizes of
> indirect descriptors are dynamic, so you can't use a single kmemcache
> for all of them unless you're ok with having a bunch of wasted bytes.

If the pool size is limited, the waste is limited too, so maybe
we are OK with that...

> > 
> > > With this patch, we will use indirect descriptors only if we have less than
> > > either 16, or 12% of the total amount of descriptors available.
> > 
> > One notes that this to some level conflicts with patches that change
> > virtio net not to drain the vq before add buf, in that we are
> > required here to drain the vq to avoid indirect.
> 
> You don't have to avoid indirects by all means, if the vq is so full it
> has to resort to indirect buffers we better let him do that.

With the limited polling patches, the vq stays full all of
the time, we only poll enough to create space for the new
descriptor.
It's not a must to make them work as they are not upstream,
but worth considering.

> > 
> > Not necessarily a serious problem, but something to keep in mind:
> > a memory pool would not have this issue.
> > 
> > > 
> > > I did basic performance benchmark on virtio-net with vhost enabled.
> > > 
> > > Before:
> > > 	Recv   Send    Send
> > > 	Socket Socket  Message  Elapsed
> > > 	Size   Size    Size     Time     Throughput
> > > 	bytes  bytes   bytes    secs.    10^6bits/sec
> > > 
> > > 	 87380  16384  16384    10.00    4563.92
> > > 
> > > After:
> > > 	Recv   Send    Send
> > > 	Socket Socket  Message  Elapsed
> > > 	Size   Size    Size     Time     Throughput
> > > 	bytes  bytes   bytes    secs.    10^6bits/sec
> > > 
> > > 	 87380  16384  16384    10.00    5353.28
> > 
> > Is this with the kvm tool? what kind of benchmark is this?
> 
> It's using the kvm tool and netperf. It's a simple TCP_STREAM test with
> vhost enabled and using a regular TAP device to connect between guest
> and host.

guest to host?

> > 
> > Need to verify the effect on block too, and do some more
> > benchmarks. In particular we are making the ring
> > in effect smaller, how will this affect small packet perf
> > with multiple streams?
> 
> I couldn't get good block benchmarks on my hardware. They were all over
> the place even when I was trying to get the baseline. I'm guessing my
> disk is about to kick the bucket.

Try using memory as a backing store.

> This threshold should be dynamic and be based on the amount of avail
> descriptors over time, so for example, if the vring is 90% full over
> time the threshold will go up allowing for more indirect buffers.
> Currently it's static, but it's a first step to making it dynamic :)
> 
> I'll do a benchmark with small packets.
> 
> > A very simple test is to disable indirect buffers altogether.
> > qemu-kvm has a flag for this.
> > Is this an equivalent test?
> > If yes I'll try that.
> 
> Yes, it should be equivalent to qemu without that flag.
> 
> > 
> > 
> > > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > > Cc: virtualization@lists.linux-foundation.org
> > > Cc: kvm@vger.kernel.org
> > > Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> > > ---
> > >  drivers/virtio/virtio_ring.c |   12 ++++++++++--
> > >  1 files changed, 10 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > > index c7a2c20..5e0ce15 100644
> > > --- a/drivers/virtio/virtio_ring.c
> > > +++ b/drivers/virtio/virtio_ring.c
> > > @@ -82,6 +82,7 @@ struct vring_virtqueue
> > >  
> > >  	/* Host supports indirect buffers */
> > >  	bool indirect;
> > 
> > We can get rid of bool indirect now, just set indirect_threshold to 0,
> > right?
> 
> Yup.
> 
> > 
> > > +	unsigned int indirect_threshold;
> > 
> > Please add a comment. It should be something like
> > 'Min. number of free space in the ring to trigger direct descriptor use'
> 
> Will do.
> 
> > 
> > >  
> > >  	/* Host publishes avail event idx */
> > >  	bool event;
> > > @@ -176,8 +177,9 @@ int virtqueue_add_buf_gfp(struct virtqueue *_vq,
> > >  	BUG_ON(data == NULL);
> > >  
> > >  	/* If the host supports indirect descriptor tables, and we have multiple
> > > -	 * buffers, then go indirect. FIXME: tune this threshold */
> > > -	if (vq->indirect && (out + in) > 1 && vq->num_free) {
> > > +	 * buffers, then go indirect. */
> > > +	if (vq->indirect && (out + in) > 1 &&
> > > +	   (vq->num_free < vq->indirect_threshold)) {
> > 
> > If num_free is 0, this will allocate the buffer which is
> > not a good idea.
> > 
> > I think there's a regression here: with a small vq, we could
> > previously put in an indirect descriptor, with your patch
> > add_buf will fail. I think this is a real problem for block
> > which was the original reason indirect bufs were introduced.
> 
> I defined the threshold so at least 16 descriptors will be used as
> indirect buffers, so if you have a small vq theres still a solid minimum
> of indirect descriptors it could use.

Yes but request size might be > 16.

> > 
> > 
> > >  		head = vring_add_indirect(vq, sg, out, in, gfp);
> > >  		if (likely(head >= 0))
> > >  			goto add_head;
> > > @@ -485,6 +487,12 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
> > >  #endif
> > >  
> > >  	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC);
> > > +	/*
> > > +	 * Use indirect descriptors only when we have less than either 12%
> > > +	 * or 16 of the descriptors in the ring available.
> > > +	 */
> > > +	if (vq->indirect)
> > > +		vq->indirect_threshold = max(16U, num >> 3);
> > 
> > Let's add some defines at top of the file please, maybe even
> > a module parameter.
> > 
> > >  	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
> > >  
> > >  	/* No callback?  Tell other side not to bother us. */
> > > -- 
> > > 1.7.8.rc3
> 
> -- 
> 
> Sasha.
