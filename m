Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab1EUCet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 22:34:49 -0400
Received: from ozlabs.org ([203.10.76.45]:38640 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756693Ab1EUCeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 22:34:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: Re: [PATCHv2 10/14] virtio_net: limit xmit polling
In-Reply-To: <aced8619c07018b5495f9ceb2c02d4fbf897a098.1305846412.git.mst@redhat.com>
References: <cover.1305846412.git.mst@redhat.com> <aced8619c07018b5495f9ceb2c02d4fbf897a098.1305846412.git.mst@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Sat, 21 May 2011 11:49:59 +0930
Message-ID: <877h9kvlps.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011 02:11:56 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> Current code might introduce a lot of latency variation
> if there are many pending bufs at the time we
> attempt to transmit a new one. This is bad for
> real-time applications and can't be good for TCP either.

Do we have more than speculation to back that up, BTW?

This patch is pretty sloppy; the previous ones were better polished.

> -static void free_old_xmit_skbs(struct virtnet_info *vi)
> +static bool free_old_xmit_skbs(struct virtnet_info *vi, int capacity)
>  {

A comment here indicating it returns true if it frees something?

>  	struct sk_buff *skb;
>  	unsigned int len;
> -
> -	while ((skb = virtqueue_get_buf(vi->svq, &len)) != NULL) {
> +	bool c;
> +	int n;
> +
> +	/* We try to free up at least 2 skbs per one sent, so that we'll get
> +	 * all of the memory back if they are used fast enough. */
> +	for (n = 0;
> +	     ((c = virtqueue_get_capacity(vi->svq) < capacity) || n < 2) &&
> +	     ((skb = virtqueue_get_buf(vi->svq, &len)));
> +	     ++n) {
>  		pr_debug("Sent skb %p\n", skb);
>  		vi->dev->stats.tx_bytes += skb->len;
>  		vi->dev->stats.tx_packets++;
>  		dev_kfree_skb_any(skb);
>  	}
> +	return !c;

This is for() abuse :)

Why is the capacity check in there at all?  Surely it's simpler to try
to free 2 skbs each time around?

   for (n = 0; n < 2; n++) {
        skb = virtqueue_get_buf(vi->svq, &len);
        if (!skb)
                break;
	pr_debug("Sent skb %p\n", skb);
	vi->dev->stats.tx_bytes += skb->len;
	vi->dev->stats.tx_packets++;
	dev_kfree_skb_any(skb);
   }

>  static int xmit_skb(struct virtnet_info *vi, struct sk_buff *skb)
> @@ -574,8 +582,8 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>  	struct virtnet_info *vi = netdev_priv(dev);
>  	int capacity;
>  
> -	/* Free up any pending old buffers before queueing new ones. */
> -	free_old_xmit_skbs(vi);
> +	/* Free enough pending old buffers to enable queueing new ones. */
> +	free_old_xmit_skbs(vi, 2+MAX_SKB_FRAGS);
>  
>  	/* Try to transmit */
>  	capacity = xmit_skb(vi, skb);
> @@ -609,9 +617,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>  		netif_stop_queue(dev);
>  		if (unlikely(!virtqueue_enable_cb_delayed(vi->svq))) {
>  			/* More just got used, free them then recheck. */
> -			free_old_xmit_skbs(vi);
> -			capacity = virtqueue_get_capacity(vi->svq);
> -			if (capacity >= 2+MAX_SKB_FRAGS) {
> +			if (!likely(free_old_xmit_skbs(vi, 2+MAX_SKB_FRAGS))) {

This extra argument to free_old_xmit_skbs seems odd, unless you have
future plans?

Thanks,
Rusty.
