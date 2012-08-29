Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab2H2SLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 14:11:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab2H2SLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 14:11:23 -0400
Date: Wed, 29 Aug 2012 21:12:35 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio-ring: Allocate indirect buffers from cache
 when possible
Message-ID: <20120829181235.GE7877@redhat.com>
References: <1346159043-16446-1-git-send-email-levinsasha928@gmail.com>
 <1346159043-16446-2-git-send-email-levinsasha928@gmail.com>
 <20120829153812.GD7407@redhat.com>
 <503E4DD9.1020102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503E4DD9.1020102@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 07:14:01PM +0200, Sasha Levin wrote:
> On 08/29/2012 05:38 PM, Michael S. Tsirkin wrote:
> > On Tue, Aug 28, 2012 at 03:04:03PM +0200, Sasha Levin wrote:
> >> Currently if VIRTIO_RING_F_INDIRECT_DESC is enabled we will
> >> use indirect descriptors and allocate them using a simple
> >> kmalloc().
> >>
> >> This patch adds a cache which will allow indirect buffers under
> >> a configurable size to be allocated from that cache instead.
> >>
> >> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> > 
> > The API is ugly - how does driver know what to set?
> > Is this a typical request size? Then let's call it that.
> 
> We've discussed it during the RFC phase, the idea is that we don't know what
> would be a good number to use as threshold - which is why I'd like to keep it
> disabled as default until it gets more serious tests.
> 
> The driver doesn't know what to set, the plan was to make it a dynamic
> algorithms which would change it based on current load. Since I can't really do
> testing which will provide the correct values for that, the decision was to do
> it this way as the first stage and modify it later.
> 
> > Also this is really per VQ, right?
> 
> Right, we keep it per-device at this stage to keep it simple.
> 
> > What is a good default for net? I guess max sg?
> 
> I think that it depends on the workload. I'd say we should keep the default to 0
> (disabled) unless we can have a good way to adjust it to the load.

For *all* drivers?

Then it is mostly useless. No one has the time to tweak module
parameters in real life.

For virtio-net, 16+1 is not too much and ensures we always
use the cache.

If that works better than 0 I would say run with 17.


> >> ---
> >>
> >> Changes in v2:
> >>
> >>  - Free correctly indirect buffers.
> >>
> >>  drivers/block/virtio_blk.c          |  4 ++++
> >>  drivers/char/hw_random/virtio-rng.c |  4 ++++
> >>  drivers/char/virtio_console.c       |  4 ++++
> >>  drivers/net/virtio_net.c            |  4 ++++
> >>  drivers/virtio/virtio_balloon.c     |  4 ++++
> >>  drivers/virtio/virtio_ring.c        | 28 ++++++++++++++++++++++++----
> >>  include/linux/virtio.h              |  1 +
> >>  net/9p/trans_virtio.c               |  5 +++++
> >>  8 files changed, 50 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> >> index 13b8ae9..7f670af 100644
> >> --- a/drivers/block/virtio_blk.c
> >> +++ b/drivers/block/virtio_blk.c
> >> @@ -25,6 +25,9 @@ struct workqueue_struct *virtblk_wq;
> >>  static unsigned int indirect_thresh;
> >>  module_param(indirect_thresh, uint, S_IRUGO);
> >>  
> >> +static unsigned int indirect_alloc_thresh;
> >> +module_param(indirect_alloc_thresh, uint, S_IRUGO);
> >> +
> >>  struct virtio_blk
> >>  {
> >>  	struct virtio_device *vdev;
> >> @@ -739,6 +742,7 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
> >>  	INIT_WORK(&vblk->config_work, virtblk_config_changed_work);
> >>  	vblk->config_enable = true;
> >>  	vdev->indirect_thresh = indirect_thresh;
> >> +	vdev->indirect_alloc_thresh = indirect_alloc_thresh;
> >>  
> >>  	err = init_vq(vblk);
> >>  	if (err)
> >> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> >> index 02d8421..8475ece 100644
> >> --- a/drivers/char/hw_random/virtio-rng.c
> >> +++ b/drivers/char/hw_random/virtio-rng.c
> >> @@ -28,6 +28,9 @@
> >>  static unsigned int indirect_thresh;
> >>  module_param(indirect_thresh, uint, S_IRUGO);
> >>  
> >> +static unsigned int indirect_alloc_thresh;
> >> +module_param(indirect_alloc_thresh, uint, S_IRUGO);
> >> +
> >>  static struct virtqueue *vq;
> >>  static unsigned int data_avail;
> >>  static DECLARE_COMPLETION(have_data);
> >> @@ -97,6 +100,7 @@ static int probe_common(struct virtio_device *vdev)
> >>  
> >>  	/* We expect a single virtqueue. */
> >>  	vdev->indirect_thresh = indirect_thresh;
> >> +	vdev->indirect_alloc_thresh = indirect_alloc_thresh;
> >>  	vq = virtio_find_single_vq(vdev, random_recv_done, "input");
> >>  	if (IS_ERR(vq))
> >>  		return PTR_ERR(vq);
> >> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> >> index fc14e7f..c6f24a7 100644
> >> --- a/drivers/char/virtio_console.c
> >> +++ b/drivers/char/virtio_console.c
> >> @@ -42,6 +42,9 @@
> >>  static unsigned int indirect_thresh;
> >>  module_param(indirect_thresh, uint, S_IRUGO);
> >>  
> >> +static unsigned int indirect_alloc_thresh;
> >> +module_param(indirect_alloc_thresh, uint, S_IRUGO);
> >> +
> >>  /*
> >>   * This is a global struct for storing common data for all the devices
> >>   * this driver handles.
> >> @@ -1891,6 +1894,7 @@ static int __devinit virtcons_probe(struct virtio_device *vdev)
> >>  			      &portdev->config.max_nr_ports) == 0)
> >>  		multiport = true;
> >>  	vdev->indirect_thresh = indirect_thresh;
> >> +	vdev->indirect_alloc_thresh = indirect_alloc_thresh;
> >>  
> >>  	err = init_vqs(portdev);
> >>  	if (err < 0) {
> >> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >> index 64a8321..c091efd 100644
> >> --- a/drivers/net/virtio_net.c
> >> +++ b/drivers/net/virtio_net.c
> >> @@ -37,6 +37,9 @@ module_param(gso, bool, 0444);
> >>  static unsigned int indirect_thresh;
> >>  module_param(indirect_thresh, uint, S_IRUGO);
> >>  
> >> +static unsigned int indirect_alloc_thresh;
> >> +module_param(indirect_alloc_thresh, uint, S_IRUGO);
> >> +
> >>  /* FIXME: MTU in config. */
> >>  #define MAX_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
> >>  #define GOOD_COPY_LEN	128
> >> @@ -1132,6 +1135,7 @@ static int virtnet_probe(struct virtio_device *vdev)
> >>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
> >>  		vi->mergeable_rx_bufs = true;
> >>  	vdev->indirect_thresh = indirect_thresh;
> >> +	vdev->indirect_alloc_thresh = indirect_alloc_thresh;
> >>  
> >>  	err = init_vqs(vi);
> >>  	if (err)
> >> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> >> index fce7347..ccf87db 100644
> >> --- a/drivers/virtio/virtio_balloon.c
> >> +++ b/drivers/virtio/virtio_balloon.c
> >> @@ -38,6 +38,9 @@
> >>  static unsigned int indirect_thresh;
> >>  module_param(indirect_thresh, uint, S_IRUGO);
> >>  
> >> +static unsigned int indirect_alloc_thresh;
> >> +module_param(indirect_alloc_thresh, uint, S_IRUGO);
> >> +
> >>  struct virtio_balloon
> >>  {
> >>  	struct virtio_device *vdev;
> >> @@ -360,6 +363,7 @@ static int virtballoon_probe(struct virtio_device *vdev)
> >>  	vb->vdev = vdev;
> >>  	vb->need_stats_update = 0;
> >>  	vdev->indirect_thresh = indirect_thresh;
> >> +	vdev->indirect_alloc_thresh = indirect_alloc_thresh;
> >>  
> >>  	err = init_vqs(vb);
> >>  	if (err)
> >> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> >> index 99a64a7..e8b9c54 100644
> >> --- a/drivers/virtio/virtio_ring.c
> >> +++ b/drivers/virtio/virtio_ring.c
> >> @@ -93,6 +93,10 @@ struct vring_virtqueue
> >>  	 */
> >>  	unsigned int indirect_thresh;
> >>  
> >> +	/* Buffers below this size will be allocated from cache */
> >> +	unsigned int indirect_alloc_thresh;
> >> +	struct kmem_cache *indirect_cache;
> >> +
> >>  	/* Host publishes avail event idx */
> >>  	bool event;
> >>  
> >> @@ -135,7 +139,10 @@ static int vring_add_indirect(struct vring_virtqueue *vq,
> >>  	unsigned head;
> >>  	int i;
> >>  
> >> -	desc = kmalloc((out + in) * sizeof(struct vring_desc), gfp);
> >> +	if ((out + in) <= vq->indirect_alloc_thresh)
> >> +		desc = kmem_cache_alloc(vq->indirect_cache, gfp);
> >> +	else
> >> +		desc = kmalloc((out + in) * sizeof(struct vring_desc), gfp);
> >>  	if (!desc)
> >>  		return -ENOMEM;
> > 
> > So this means that drivers need to know how large each
> > descriptor is to avoid trying to allocate 32Mbyte chunks :)
> 
> Right, this interface isn't perfect and would hopefully be removed in favour of
> a dynamic algorithm in the driver.
> 
> >>  
> >> @@ -384,8 +391,13 @@ static void detach_buf(struct vring_virtqueue *vq, unsigned int head)
> >>  	i = head;
> >>  
> >>  	/* Free the indirect table */
> >> -	if (vq->vring.desc[i].flags & VRING_DESC_F_INDIRECT)
> >> -		kfree(phys_to_virt(vq->vring.desc[i].addr));
> >> +	if (vq->vring.desc[i].flags & VRING_DESC_F_INDIRECT) {
> >> +		if (vq->vring.desc[i].len > vq->indirect_alloc_thresh)
> > 
> > This looks wrong. indirect_alloc_thresh is in entries but len is in
> > bytes, isn't it?
> 
> Uh, yes. It's supposed to be '.len/sizeof(struct vring_desc)'.
> 
> >> +			kfree(phys_to_virt(vq->vring.desc[i].addr));
> >> +		else
> >> +			kmem_cache_free(vq->indirect_cache,
> >> +					phys_to_virt(vq->vring.desc[i].addr));
> >> +	}
> >>  
> >>  	while (vq->vring.desc[i].flags & VRING_DESC_F_NEXT) {
> >>  		i = vq->vring.desc[i].next;
> >> @@ -654,14 +666,20 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
> >>  	vq->last_used_idx = 0;
> >>  	vq->num_added = 0;
> >>  	vq->indirect_thresh = 0;
> >> +	vq->indirect_alloc_thresh = 0;
> >> +	vq->indirect_cache = NULL;
> >>  	list_add_tail(&vq->vq.list, &vdev->vqs);
> >>  #ifdef DEBUG
> >>  	vq->in_use = false;
> >>  	vq->last_add_time_valid = false;
> >>  #endif
> >>  
> >> -	if (virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC))
> >> +	if (virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC)) {
> >>  		vq->indirect_thresh = vdev->indirect_thresh;
> >> +		vq->indirect_alloc_thresh = vdev->indirect_alloc_thresh;
> >> +		if (vq->indirect_alloc_thresh)
> >> +			vq->indirect_cache = KMEM_CACHE(vring_desc[vq->indirect_alloc_thresh],
> >> 0);
> > 
> > I am not a purist but this line looks way too long.
> > Also - no need to check cache creation succeeded?
> > On failure - disable caching?
> > 
> > Also - let's check that values are sane before passing them on?
> > They come from user after all.
> 
> will fix these two.
> 
> > Also - should not threshold be per VQ? E.g. for -net we do not
> > need the cache for RX unless in legacy big packet mode.
> 
> We've discussed it two months ago over IRC (at least thats what I have in my
> notes) - the plan was to keep it simple per-device until something more advanced
> to deal with the threshold shows up.
> 
> 
> Thanks,
> Sasha
> 
> > 
> >> +	}
> >>  
> >>  	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
> >>  
> >> @@ -685,6 +703,8 @@ EXPORT_SYMBOL_GPL(vring_new_virtqueue);
> >>  void vring_del_virtqueue(struct virtqueue *vq)
> >>  {
> >>  	list_del(&vq->list);
> >> +	if (to_vvq(vq)->indirect_cache)
> >> +		kmem_cache_destroy(to_vvq(vq)->indirect_cache);
> >>  	kfree(to_vvq(vq));
> >>  }
> >>  EXPORT_SYMBOL_GPL(vring_del_virtqueue);
> >> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> >> index 48bc457..3261c02 100644
> >> --- a/include/linux/virtio.h
> >> +++ b/include/linux/virtio.h
> >> @@ -70,6 +70,7 @@ struct virtio_device {
> >>  	unsigned long features[1];
> >>  	void *priv;
> >>  	unsigned int indirect_thresh;
> >> +	unsigned int indirect_alloc_thresh;
> >>  };
> >>  
> >>  #define dev_to_virtio(dev) container_of(dev, struct virtio_device, dev)
> >> diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
> >> index fc93962..3044c86 100644
> >> --- a/net/9p/trans_virtio.c
> >> +++ b/net/9p/trans_virtio.c
> >> @@ -55,6 +55,9 @@
> >>  static unsigned int indirect_thresh;
> >>  module_param(indirect_thresh, uint, S_IRUGO);
> >>  
> >> +static unsigned int indirect_alloc_thresh;
> >> +module_param(indirect_alloc_thresh, uint, S_IRUGO);
> >> +
> >>  /* a single mutex to manage channel initialization and attachment */
> >>  static DEFINE_MUTEX(virtio_9p_lock);
> >>  static DECLARE_WAIT_QUEUE_HEAD(vp_wq);
> >> @@ -505,6 +508,8 @@ static int p9_virtio_probe(struct virtio_device *vdev)
> >>  
> >>  	/* We expect one virtqueue, for requests. */
> >>  	vdev->indirect_thresh = indirect_thresh;
> >> +	vdev->indirect_alloc_thresh = indirect_alloc_thresh;
> >> +
> >>  	chan->vq = virtio_find_single_vq(vdev, req_done, "requests");
> >>  	if (IS_ERR(chan->vq)) {
> >>  		err = PTR_ERR(chan->vq);
> >> -- 
> >> 1.7.12
