Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab1FBOns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 10:43:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab1FBOnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 10:43:46 -0400
Date: Thu, 2 Jun 2011 17:43:46 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Krishna Kumar2 <krkumar2@in.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Carsten Otte <cotte@de.ibm.com>, habanero@linux.vnet.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>, kvm@vger.kernel.org,
        lguest@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux390@de.ibm.com,
        netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, steved@us.ibm.com,
        Tom Lendacky <tahm@linux.vnet.ibm.com>,
        virtualization@lists.linux-foundation.org, Shirley Ma <xma@us.ibm.com>
Subject: Re: [PATCH RFC 3/3] virtio_net: limit xmit polling
Message-ID: <20110602144346.GA7995@redhat.com>
References: <cover.1306921434.git.mst@redhat.com>
 <1ec8eec325839ecf2eac9930a230361e7956047c.1306921434.git.mst@redhat.com>
 <87pqmwj3am.fsf@rustcorp.com.au>
 <20110602133425.GJ7141@redhat.com>
 <OF990F08C5.2ECE35B1-ON652578A3.004DC0FA-652578A3.004E3FE4@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF990F08C5.2ECE35B1-ON652578A3.004DC0FA-652578A3.004E3FE4@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 07:47:48PM +0530, Krishna Kumar2 wrote:
> > OK, I have something very similar, but I still dislike the screw the
> > latency part: this path is exactly what the IBM guys seem to hit.  So I
> > created two functions: one tries to free a constant number and another
> > one up to capacity. I'll post that now.
> 
> Please review this patch to see if it looks reasonable:

Hmm, since you decided to work on top of my patch,
I'd appreciate split-up fixes.

> 1. Picked comments/code from MST's code and Rusty's review.
> 2. virtqueue_min_capacity() needs to be called only if it returned
>    empty the last time it was called.
> 3. Fix return value bug in free_old_xmit_skbs (hangs guest).
> 4. Stop queue only if capacity is not enough for next xmit.

That's what we always did ...

> 5. Fix/clean some likely/unlikely checks (hopefully).
> 
> I have done some minimal netperf tests with this.
> 
> With this patch, add_buf returning capacity seems to be useful - it
> allows less virtio API calls.

Why bother? It's cheap ...

> 
> Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
> ---
>  drivers/net/virtio_net.c |  105 ++++++++++++++++++++++---------------
>  1 file changed, 64 insertions(+), 41 deletions(-)
> 
> diff -ruNp org/drivers/net/virtio_net.c new/drivers/net/virtio_net.c
> --- org/drivers/net/virtio_net.c	2011-06-02 15:49:25.000000000 +0530
> +++ new/drivers/net/virtio_net.c	2011-06-02 19:13:02.000000000 +0530
> @@ -509,27 +509,43 @@ again:
>  	return received;
>  }
>  
> -/* Check capacity and try to free enough pending old buffers to enable queueing
> - * new ones.  If min_skbs > 0, try to free at least the specified number of skbs
> - * even if the ring already has sufficient capacity.  Return true if we can
> - * guarantee that a following virtqueue_add_buf will succeed. */
> -static bool free_old_xmit_skbs(struct virtnet_info *vi, int min_skbs)
> +/* Return true if freed a skb, else false */
> +static inline bool free_one_old_xmit_skb(struct virtnet_info *vi)
>  {
>  	struct sk_buff *skb;
>  	unsigned int len;
> -	bool r;
>  
> -	while ((r = virtqueue_min_capacity(vi->svq) < MAX_SKB_FRAGS + 2) ||
> -	       min_skbs-- > 0) {
> -		skb = virtqueue_get_buf(vi->svq, &len);
> -		if (unlikely(!skb))
> +	skb = virtqueue_get_buf(vi->svq, &len);
> +	if (unlikely(!skb))
> +		return 0;
> +
> +	pr_debug("Sent skb %p\n", skb);
> +	vi->dev->stats.tx_bytes += skb->len;
> +	vi->dev->stats.tx_packets++;
> +	dev_kfree_skb_any(skb);
> +	return 1;
> +}
> +
> +static bool free_old_xmit_skbs(struct virtnet_info *vi, int to_free)
> +{
> +	bool empty = virtqueue_min_capacity(vi->svq) < MAX_SKB_FRAGS + 2;
> +
> +	do {
> +		if (!free_one_old_xmit_skb(vi)) {
> +			/* No more skbs to free up */
>  			break;
> -		pr_debug("Sent skb %p\n", skb);
> -		vi->dev->stats.tx_bytes += skb->len;
> -		vi->dev->stats.tx_packets++;
> -		dev_kfree_skb_any(skb);
> -	}
> -	return r;
> +		}
> +
> +		if (empty) {
> +			/* Check again if there is enough space */
> +			empty = virtqueue_min_capacity(vi->svq) <
> +				MAX_SKB_FRAGS + 2;
> +		} else {
> +			--to_free;
> +		}
> +	} while (to_free > 0);
> +
> +	return !empty;
>  }

Why bother doing the capacity check in this function?

>  static int xmit_skb(struct virtnet_info *vi, struct sk_buff *skb)
> @@ -582,46 +598,53 @@ static int xmit_skb(struct virtnet_info 
>  static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>  {
>  	struct virtnet_info *vi = netdev_priv(dev);
> -	int ret, n;
> +	int capacity;
>  
> -	/* Free up space in the ring in case this is the first time we get
> -	 * woken up after ring full condition.  Note: this might try to free
> -	 * more than strictly necessary if the skb has a small
> -	 * number of fragments, but keep it simple. */
> -	free_old_xmit_skbs(vi, 0);
> +	/* Try to free 2 buffers for every 1 xmit, to stay ahead. */
> +	free_old_xmit_skbs(vi, 2);
>  
>  	/* Try to transmit */
> -	ret = xmit_skb(vi, skb);
> +	capacity = xmit_skb(vi, skb);
>  
> -	/* Failure to queue is unlikely. It's not a bug though: it might happen
> -	 * if we get an interrupt while the queue is still mostly full.
> -	 * We could stop the queue and re-enable callbacks (and possibly return
> -	 * TX_BUSY), but as this should be rare, we don't bother. */
> -	if (unlikely(ret < 0)) {
> +	if (unlikely(capacity < 0)) {
> +		/*
> +		 * Failure to queue should be impossible. The only way to
> +		 * reach here is if we got a cb before 3/4th of space was
> +		 * available. We could stop the queue and re-enable
> +		 * callbacks (and possibly return TX_BUSY), but we don't
> +		 * bother since this is impossible.

It's far from impossible.  The 3/4 thing is only a hint, and old devices
don't support it anyway.

> +		 */
>  		if (net_ratelimit())
> -			dev_info(&dev->dev, "TX queue failure: %d\n", ret);
> +			dev_info(&dev->dev, "TX queue failure: %d\n", capacity);
>  		dev->stats.tx_dropped++;
>  		kfree_skb(skb);
>  		return NETDEV_TX_OK;
>  	}
> +
>  	virtqueue_kick(vi->svq);
>  
>  	/* Don't wait up for transmitted skbs to be freed. */
>  	skb_orphan(skb);
>  	nf_reset(skb);
>  
> -	/* Apparently nice girls don't return TX_BUSY; check capacity and stop
> -	 * the queue before it gets out of hand.
> -	 * Naturally, this wastes entries. */
> -	/* We transmit one skb, so try to free at least two pending skbs.
> -	 * This is so that we don't hog the skb memory unnecessarily. */
> -	if (!likely(free_old_xmit_skbs(vi, 2))) {
> -		netif_stop_queue(dev);
> -		if (unlikely(!virtqueue_enable_cb_delayed(vi->svq))) {
> -			/* More just got used, free them and recheck. */
> -			if (!likely(free_old_xmit_skbs(vi, 0))) {
> -				netif_start_queue(dev);
> -				virtqueue_disable_cb(vi->svq);
> +	/*
> +	 * Apparently nice girls don't return TX_BUSY; check capacity and
> +	 * stop the queue before it gets out of hand. Naturally, this wastes
> +	 * entries. 
> +	 */
> +	if (capacity < 2+MAX_SKB_FRAGS) {
> +		/*
> +		 * We don't have enough space for the next packet. Try
> +		 * freeing more.
> +		 */
> +		if (likely(!free_old_xmit_skbs(vi, UINT_MAX))) {
> +			netif_stop_queue(dev);
> +			if (unlikely(!virtqueue_enable_cb_delayed(vi->svq))) {
> +				/* More just got used, free them and recheck. */
> +				if (likely(free_old_xmit_skbs(vi, UINT_MAX))) {

Is this where the bug was?

> +					netif_start_queue(dev);
> +					virtqueue_disable_cb(vi->svq);
> +				}
>  			}
>  		}
>  	}
