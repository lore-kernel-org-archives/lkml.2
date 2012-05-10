Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab2EJB03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 21:26:29 -0400
Received: from ozlabs.org ([203.10.76.45]:43513 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227Ab2EJB02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 21:26:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: [RFC PATCH] virtio_console: link vq to port with a private pointer in struct virtqueue
In-Reply-To: <20120508101839.GA15598@redhat.com>
References: <87397be80k.fsf@rustcorp.com.au> <1336470355-19257-1-git-send-email-pbonzini@redhat.com> <20120508101839.GA15598@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 10 May 2012 10:56:09 +0930
Message-ID: <877gwkddxq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2012 13:18:39 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Tue, May 08, 2012 at 11:45:55AM +0200, Paolo Bonzini wrote:
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -76,8 +76,6 @@
> >  
> >  struct vring_virtqueue
> >  {
> > -	struct virtqueue vq;
> > -
> >  	/* Actual memory layout for this queue */
> >  	struct vring vring;
> >  
> > @@ -106,6 +104,9 @@ struct vring_virtqueue
> >  	/* How to notify other side. FIXME: commonalize hcalls! */
> >  	void (*notify)(struct virtqueue *vq);
> >  
> > +	/* Tokens for callbacks. */
> > +	void **data;
> > +
> >  #ifdef DEBUG
> >  	/* They're supposed to lock for us. */
> >  	unsigned int in_use;
> > @@ -115,8 +116,9 @@ struct vring_virtqueue
> >  	ktime_t last_add_time;
> >  #endif
> >  
> > -	/* Tokens for callbacks. */
> > -	void *data[];
> > +	struct virtqueue vq;
> > +
> > +	/* Bus-specific virtqueue data goes here.  */
> >  };
> >  
> >  #define to_vvq(_vq) container_of(_vq, struct vring_virtqueue, vq)
> 
> 
> This moves the data out of line and the bus specific stuff inline.
> But bus accesses only happen on io and interrupt which are already
> slow, while data accesses happen on fast path.
> 
> >From that POV this looks like a wrong thing to do.

(Resend to all)

Most of it was on a different cacheline anyway though, so it's probably
not measurable.  We avoid the pci_vq->vq indirection, but add the
vq->data indirection.

I share your discomfort with the offset arg method, too.

So unless benchmarks show otherwise, let's do it the vanilla way?

I think that making vring_virtqueue public looks like the way to go,
too.

Of course, a nice series would be great as well :)

Thanks!
Rusty.
