Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab2DRQKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 12:10:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab2DRQKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 12:10:23 -0400
Date: Wed, 18 Apr 2012 19:10:29 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC PATCH] virtio_console: link vq to port with a private
 pointer in struct virtqueue
Message-ID: <20120418161028.GB12815@redhat.com>
References: <1334756013-11752-1-git-send-email-pbonzini@redhat.com>
 <20120418142146.GB11801@redhat.com>
 <4F8ED0E4.6000702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8ED0E4.6000702@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 04:34:12PM +0200, Paolo Bonzini wrote:
> Il 18/04/2012 16:21, Michael S. Tsirkin ha scritto:
> >> @@ -1872,6 +1864,8 @@ static int virtcons_restore(struct virtio_device *vdev)
> >>  	list_for_each_entry(port, &portdev->ports, list) {
> >>  		port->in_vq = portdev->in_vqs[port->id];
> >>  		port->out_vq = portdev->out_vqs[port->id];
> >> +		port->in_vq->vdev_priv = port;
> >> +		port->out_vq->vdev_priv = port;
> >>  
> >>  		fill_queue(port->in_vq, &port->inbuf_lock);
> >>  
> > 
> > Let's add an API to set this pointer.
> > Document that you must not set it after
> > probe/restore returned.
> 
> Why?

How would you prevent races if you do?

> > With an API we can actually have a BUG_ON that checks it's not modified
> > after probe.
> > 
> >> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> >> index c193ccf..6b39c1a 100644
> >> --- a/include/linux/virtio.h
> >> +++ b/include/linux/virtio.h
> >> @@ -14,6 +14,7 @@
> >>   * @callback: the function to call when buffers are consumed (can be NULL).
> >>   * @name: the name of this virtqueue (mainly for debugging)
> >>   * @vdev: the virtio device this queue was created for.
> >> + * @vdev_priv: a pointer for the virtio device to use.
> > 
> > It's for the driver actually.
> 
> Right.  However...

pointer for a device can also be misunerstood as
'pointer to a device'. Note priv below actually
gets the correct meaning however you interpret 'for'.

Better 'pointer for the virtqueue driver to use'.

> 
> >>   * @priv: a pointer for the virtqueue implementation to use.
> >>   */
> >>  struct virtqueue {
> >> @@ -21,6 +22,7 @@ struct virtqueue {
> >>  	void (*callback)(struct virtqueue *vq);
> >>  	const char *name;
> >>  	struct virtio_device *vdev;
> >> +	void *vdev_priv;
> >>  	void *priv;
> > 
> > The name is confusing: it seems to imply it's a device pointer.
> 
> ... it's private to the driver that owns vdev, hence the name.

I own a car but I'm not called Michael Car :)
driver_priv might be ok too. unfortunately virtio-pci
is also a driver so it can be misunderstood.

> > Maybe we should rename priv to something like __priv and make
> > priv useful for devices?
> 
> I wanted to go for the smallest possible changes.  Right now we have 1
> user for each member (virtio-ring vs. virtio-console) so neither member
> is really dominating.
> 
> Paolo

devices should dominate. ring is an implementation detail.

-- 
MST
