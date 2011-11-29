Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab1K2OxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 09:53:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343Ab1K2OxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 09:53:19 -0500
Date: Tue, 29 Nov 2011 16:54:51 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        markmc@redhat.com
Subject: Re: [PATCH] virtio-ring: Use threshold for switching to indirect
 descriptors
Message-ID: <20111129145451.GD30966@redhat.com>
References: <1322559196-11139-1-git-send-email-levinsasha928@gmail.com>
 <20111129125622.GB19157@redhat.com>
 <1322573688.4395.11.camel@lappy>
 <20111129135406.GB30966@redhat.com>
 <1322576464.7003.6.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322576464.7003.6.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 04:21:04PM +0200, Sasha Levin wrote:
> > > > Need to verify the effect on block too, and do some more
> > > > benchmarks. In particular we are making the ring
> > > > in effect smaller, how will this affect small packet perf
> > > > with multiple streams?
> > > 
> > > I couldn't get good block benchmarks on my hardware. They were all over
> > > the place even when I was trying to get the baseline. I'm guessing my
> > > disk is about to kick the bucket.
> > 
> > Try using memory as a backing store.
> 
> Here are the results from fio doing random reads:
> 
> With indirect buffers:
> Run status group 0 (all jobs):
>    READ: io=2419.7MB, aggrb=126001KB/s, minb=12887KB/s, maxb=13684KB/s, mint=18461msec, maxt=19664msec
> 
> Disk stats (read/write):
>   vda: ios=612107/0, merge=0/0, ticks=37559/0, in_queue=32723, util=76.70%
> 
> Indirect buffers disabled in the host:
> Run status group 0 (all jobs):
>    READ: io=2419.7MB, aggrb=127106KB/s, minb=12811KB/s, maxb=14557KB/s, mint=17486msec, maxt=19493msec
> 
> Disk stats (read/write):
>   vda: ios=617315/0, merge=1/0, ticks=166751/0, in_queue=162807, util=88.19%

I don't know much about this, only difference I see is that
in_queue is way higher. 

> 
> Which is actually strange, weren't indirect buffers introduced to make
> the performance *better*? From what I see it's pretty much the
> same/worse for virtio-blk.

I know they were introduced to allow adding very large bufs.
See 9fa29b9df32ba4db055f3977933cd0c1b8fe67cd
Mark, you wrote the patch, could you tell us which workloads
benefit the most from indirect bufs?

> Here's my fio test file:
> [random-read]
> rw=randread
> size=256m
> filename=/dev/vda
> ioengine=libaio
> iodepth=8
> direct=1
> invalidate=1
> numjobs=10
> > 
> > > This threshold should be dynamic and be based on the amount of avail
> > > descriptors over time, so for example, if the vring is 90% full over
> > > time the threshold will go up allowing for more indirect buffers.
> > > Currently it's static, but it's a first step to making it dynamic :)
> > > 
> > > I'll do a benchmark with small packets.
> > > 
> > > > A very simple test is to disable indirect buffers altogether.
> > > > qemu-kvm has a flag for this.
> > > > Is this an equivalent test?
> > > > If yes I'll try that.
> > > 
> > > Yes, it should be equivalent to qemu without that flag.
> > > 
> > > > 
> > > > 
> > > > > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > > > > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > > > > Cc: virtualization@lists.linux-foundation.org
> > > > > Cc: kvm@vger.kernel.org
> > > > > Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> > > > > ---
> > > > >  drivers/virtio/virtio_ring.c |   12 ++++++++++--
> > > > >  1 files changed, 10 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > > > > index c7a2c20..5e0ce15 100644
> > > > > --- a/drivers/virtio/virtio_ring.c
> > > > > +++ b/drivers/virtio/virtio_ring.c
> > > > > @@ -82,6 +82,7 @@ struct vring_virtqueue
> > > > >  
> > > > >  	/* Host supports indirect buffers */
> > > > >  	bool indirect;
> > > > 
> > > > We can get rid of bool indirect now, just set indirect_threshold to 0,
> > > > right?
> > > 
> > > Yup.
> > > 
> > > > 
> > > > > +	unsigned int indirect_threshold;
> > > > 
> > > > Please add a comment. It should be something like
> > > > 'Min. number of free space in the ring to trigger direct descriptor use'
> > > 
> > > Will do.
> > > 
> > > > 
> > > > >  
> > > > >  	/* Host publishes avail event idx */
> > > > >  	bool event;
> > > > > @@ -176,8 +177,9 @@ int virtqueue_add_buf_gfp(struct virtqueue *_vq,
> > > > >  	BUG_ON(data == NULL);
> > > > >  
> > > > >  	/* If the host supports indirect descriptor tables, and we have multiple
> > > > > -	 * buffers, then go indirect. FIXME: tune this threshold */
> > > > > -	if (vq->indirect && (out + in) > 1 && vq->num_free) {
> > > > > +	 * buffers, then go indirect. */
> > > > > +	if (vq->indirect && (out + in) > 1 &&
> > > > > +	   (vq->num_free < vq->indirect_threshold)) {
> > > > 
> > > > If num_free is 0, this will allocate the buffer which is
> > > > not a good idea.
> > > > 
> > > > I think there's a regression here: with a small vq, we could
> > > > previously put in an indirect descriptor, with your patch
> > > > add_buf will fail. I think this is a real problem for block
> > > > which was the original reason indirect bufs were introduced.
> > > 
> > > I defined the threshold so at least 16 descriptors will be used as
> > > indirect buffers, so if you have a small vq theres still a solid minimum
> > > of indirect descriptors it could use.
> > 
> > Yes but request size might be > 16.
> > 
> > > > 
> > > > 
> > > > >  		head = vring_add_indirect(vq, sg, out, in, gfp);
> > > > >  		if (likely(head >= 0))
> > > > >  			goto add_head;
> > > > > @@ -485,6 +487,12 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
> > > > >  #endif
> > > > >  
> > > > >  	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC);
> > > > > +	/*
> > > > > +	 * Use indirect descriptors only when we have less than either 12%
> > > > > +	 * or 16 of the descriptors in the ring available.
> > > > > +	 */
> > > > > +	if (vq->indirect)
> > > > > +		vq->indirect_threshold = max(16U, num >> 3);
> > > > 
> > > > Let's add some defines at top of the file please, maybe even
> > > > a module parameter.
> > > > 
> > > > >  	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
> > > > >  
> > > > >  	/* No callback?  Tell other side not to bother us. */
> > > > > -- 
> > > > > 1.7.8.rc3
> > > 
> > > -- 
> > > 
> > > Sasha.
> 
> -- 
> 
> Sasha.
