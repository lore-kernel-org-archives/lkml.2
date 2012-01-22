Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab2AVLqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 06:46:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926Ab2AVLpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 06:45:46 -0500
Date: Sun, 22 Jan 2012 13:47:57 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] virtio: correct the memory barrier in
 virtqueue_kick_prepare()
Message-ID: <20120122114757.GD27222@redhat.com>
References: <20120120081658.50747.10625.stgit@amd-6168-8-1.englab.nay.redhat.com>
 <20120120081708.50747.60241.stgit@amd-6168-8-1.englab.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120120081708.50747.60241.stgit@amd-6168-8-1.englab.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 04:17:08PM +0800, Jason Wang wrote:
> Use virtio_mb() to make sure the available index to be exposed before
> checking the the avail event. Otherwise we may get stale value of
> avail event in guest and never kick the host after.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Good catch.
Note: this fixes a bug introduced by ee7cd8981e15bcb365fc762afe3fc47b8242f630.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/virtio/virtio_ring.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 78428a8..07d9360 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -308,9 +308,9 @@ bool virtqueue_kick_prepare(struct virtqueue *_vq)
>  	bool needs_kick;
>  
>  	START_USE(vq);
> -	/* Descriptors and available array need to be set before we expose the
> -	 * new available array entries. */
> -	virtio_wmb(vq);
> +	/* We need expose available array entries before checking avail

Nit:
We need expose -> Need to expose

> +	 * event. */
> +	virtio_mb(vq);
>  
>  	old = vq->vring.avail->idx - vq->num_added;
>  	new = vq->vring.avail->idx;
