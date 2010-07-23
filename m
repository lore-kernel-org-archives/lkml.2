Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416Ab0GWO6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 10:58:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757040Ab0GWO6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 10:58:14 -0400
Date: Fri, 23 Jul 2010 10:52:35 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Chris Mason <chris.mason@oracle.com>, stable@kernel.org
Subject: Re: [stable] [PATCH] virtio: fix oops on OOM
Message-ID: <20100723105235.35bf9969@katamari>
In-Reply-To: <201007231548.38037.rusty@rustcorp.com.au>
References: <201007231548.38037.rusty@rustcorp.com.au>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jul 2010 15:48:37 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:

Note that commit 686d363786a53ed28ee875b84ef24e6d5126ef6f,
which caused this problem, is already queued for -stable,
so it should either be removed or this should be sent for
-stable as well.

> From: "Michael S. Tsirkin" <mst@redhat.com>
> 
> virtio ring was changed to return an error code on OOM,
> but one caller was missed and still checks for vq->vring.num.
> The fix is just to check for <0 error code.
> 
> Long term it might make sense to change goto add_head to
> just return an error on oom instead, but let's apply
> a minimal fix for 2.6.35.
> 
> Reported-by: Chris Mason <chris.mason@oracle.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Tested-by: Chris Mason <chris.mason@oracle.com>
> ---
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index dd35b34..bffec32 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -164,7 +164,8 @@ int virtqueue_add_buf_gfp(struct virtqueue *_vq,
>  			  gfp_t gfp)
>  {
>  	struct vring_virtqueue *vq = to_vvq(_vq);
> -	unsigned int i, avail, head, uninitialized_var(prev);
> +	unsigned int i, avail, uninitialized_var(prev);
> +	int head;
>  
>  	START_USE(vq);
>  
> @@ -174,8 +175,8 @@ int virtqueue_add_buf_gfp(struct virtqueue *_vq,
>  	 * buffers, then go indirect. FIXME: tune this threshold */
>  	if (vq->indirect && (out + in) > 1 && vq->num_free) {
>  		head = vring_add_indirect(vq, sg, out, in, gfp);
> -		if (head != vq->vring.num)
> +		if (likely(head >= 0))
>  			goto add_head;
>  	}
>  
>  	BUG_ON(out + in > vq->vring.num);
> --

