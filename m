Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab1GCI1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 04:27:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab1GCI1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 04:27:43 -0400
Date: Sun, 3 Jul 2011 11:27:48 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        dave@linux.vnet.ibm.com, Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio_balloon: Notify guest only after deflating the
 balloon
Message-ID: <20110703082748.GD13183@redhat.com>
References: <1309576016-22800-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309576016-22800-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Doesn't this basically just revert
bf50e69f63d21091e525185c3ae761412be0ba72?


On Sat, Jul 02, 2011 at 06:06:56AM +0300, Sasha Levin wrote:
> Unless the host requires that requested pages won't be used until
> he us notified (VIRTIO_BALLOON_F_MUST_TELL_HOST), only notify after
> deflating the balloon.
> 
> This will avoid having to take an exit before actually using the pages.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> Cc: kvm@vger.kernel.org
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  drivers/virtio/virtio_balloon.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index e058ace..055f95d 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -148,14 +148,18 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
>  		vb->num_pages--;
>  	}
>  
> -
>  	/*
> -	 * Note that if
> -	 * virtio_has_feature(vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST);
> -	 * is true, we *have* to do it in this order
> +	 * If the host doesn't require us to notify him before using
> +	 * pages which belong to the balloon, update him only after
> +	 * freeing those pages for guest use.
>  	 */
> -	tell_host(vb, vb->deflate_vq);
> -	release_pages_by_pfn(vb->pfns, vb->num_pfns);
> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST)) {
> +		tell_host(vb, vb->deflate_vq);
> +		release_pages_by_pfn(vb->pfns, vb->num_pfns);
> +	} else {
> +		release_pages_by_pfn(vb->pfns, vb->num_pfns);
> +		tell_host(vb, vb->deflate_vq);
> +	}
>  }
>  
>  static inline void update_stat(struct virtio_balloon *vb, int idx,
> -- 
> 1.7.6
