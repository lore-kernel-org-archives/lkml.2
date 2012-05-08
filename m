Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab2EHKSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 06:18:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab2EHKSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 06:18:39 -0400
Date: Tue, 8 May 2012 13:18:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: [RFC PATCH] virtio_console: link vq to port with a private
 pointer in struct virtqueue
Message-ID: <20120508101839.GA15598@redhat.com>
References: <87397be80k.fsf@rustcorp.com.au>
 <1336470355-19257-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336470355-19257-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 11:45:55AM +0200, Paolo Bonzini wrote:
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -76,8 +76,6 @@
>  
>  struct vring_virtqueue
>  {
> -	struct virtqueue vq;
> -
>  	/* Actual memory layout for this queue */
>  	struct vring vring;
>  
> @@ -106,6 +104,9 @@ struct vring_virtqueue
>  	/* How to notify other side. FIXME: commonalize hcalls! */
>  	void (*notify)(struct virtqueue *vq);
>  
> +	/* Tokens for callbacks. */
> +	void **data;
> +
>  #ifdef DEBUG
>  	/* They're supposed to lock for us. */
>  	unsigned int in_use;
> @@ -115,8 +116,9 @@ struct vring_virtqueue
>  	ktime_t last_add_time;
>  #endif
>  
> -	/* Tokens for callbacks. */
> -	void *data[];
> +	struct virtqueue vq;
> +
> +	/* Bus-specific virtqueue data goes here.  */
>  };
>  
>  #define to_vvq(_vq) container_of(_vq, struct vring_virtqueue, vq)


This moves the data out of line and the bus specific stuff inline.
But bus accesses only happen on io and interrupt which are already
slow, while data accesses happen on fast path.

>From that POV this looks like a wrong thing to do.

-- 
MST
