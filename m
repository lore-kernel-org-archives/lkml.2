Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128Ab0FJRRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 13:17:45 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33936 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab0FJRRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 13:17:44 -0400
Subject: Re: [PATCH for-2.6.35] virtio_net: fix oom handling on tx
From: Sridhar Samudrala <sri@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>, Jiri Pirko <jpirko@redhat.com>,
       Shirley Ma <xma@us.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100610152041.GA3480@redhat.com>
References: <20100610152041.GA3480@redhat.com>
Content-Type: text/plain
Date: Thu, 10 Jun 2010 10:17:07 -0700
Message-Id: <1276190227.22064.19.camel@w-sridhar.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 18:20 +0300, Michael S. Tsirkin wrote:
> virtio net will never try to overflow the TX ring, so the only reason
> add_buf may fail is out of memory. Thus, we can not stop the
> device until some request completes - there's no guarantee anything
> at all is outstanding.
> 
> Make the error message clearer as well: error here does not
> indicate queue full.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/net/virtio_net.c |   15 ++++++++-------
>  1 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 85615a3..e48a06f 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -563,7 +563,6 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>  	struct virtnet_info *vi = netdev_priv(dev);
>  	int capacity;
> 
> -again:
>  	/* Free up any pending old buffers before queueing new ones. */
>  	free_old_xmit_skbs(vi);
> 
> @@ -572,12 +571,14 @@ again:
> 
>  	/* This can happen with OOM and indirect buffers. */
>  	if (unlikely(capacity < 0)) {
> -		netif_stop_queue(dev);
> -		dev_warn(&dev->dev, "Unexpected full queue\n");
> -		if (unlikely(!virtqueue_enable_cb(vi->svq))) {
> -			virtqueue_disable_cb(vi->svq);
> -			netif_start_queue(dev);
> -			goto again;
> +		if (net_ratelimit()) {
> +			if (likely(capacity == -ENOMEM))
> +				dev_warn(&dev->dev,
> +					 "TX queue failure: out of memory\n");
> +			else
> +				dev_warn(&dev->dev,
> +					 "Unexpected TX queue failure: %d\n",
> +					 capacity);
>  		}
>  		return NETDEV_TX_BUSY;
>  	}

It is not clear to me how xmit_skb() can return -ENOMEM.
xmit_skb() calls virtqueue_add_buf_gfp() which can return -ENOSPC.
Even vring_add_indirect() doesn't return -ENOMEM on kmalloc failure.

Thanks
Sridhar

