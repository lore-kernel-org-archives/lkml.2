Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab1EUCef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 22:34:35 -0400
Received: from ozlabs.org ([203.10.76.45]:59976 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399Ab1EUCeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 22:34:01 -0400
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
Subject: Re: [PATCHv2 09/14] virtio_net: fix TX capacity checks using new API
In-Reply-To: <42ca2494c92f572388e3ab4c6f613dd4f038361b.1305846412.git.mst@redhat.com>
References: <cover.1305846412.git.mst@redhat.com> <42ca2494c92f572388e3ab4c6f613dd4f038361b.1305846412.git.mst@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Sat, 21 May 2011 11:43:19 +0930
Message-ID: <878vu0vm0w.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011 02:11:47 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> virtio net uses the number of sg entries to
> check for TX ring capacity freed. But this
> gives incorrect results when indirect buffers
> are used. Use the new capacity API instead.

OK, but this explanation needs enhancement, such as noting the actual
results of that miscalculation.  Something like:

 virtio_net uses the number of sg entries in the skb it frees to
 calculate how many descriptors in the ring have just been made
 available.  But this value is an overestimate: with indirect buffers
 each skb only uses one descriptor entry, meaning we may wake the queue
 only to find we still can't transmit anything.

 Using the new virtqueue_get_capacity() call, we can exactly determine
 the remaining capacity, so we should use that instead.

But, here's the side effect:
>  			/* More just got used, free them then recheck. */
> -			capacity += free_old_xmit_skbs(vi);
> +			free_old_xmit_skbs(vi);
> +			capacity = virtqueue_get_capacity(vi->svq);
>  			if (capacity >= 2+MAX_SKB_FRAGS) {

That capacity >= 2+MAX_SKB_FRAGS is too much for indirect buffers.  This
means we waste 20 entries in the ring, but OTOH if we hit OOM we fall
back to direct buffers and we *will* need this.

Which means this comment in the driver is now wrong:

	/* This can happen with OOM and indirect buffers. */
	if (unlikely(capacity < 0)) {
		if (net_ratelimit()) {
			if (likely(capacity == -ENOMEM)) {
				dev_warn(&dev->dev,
					 "TX queue failure: out of memory\n");
			} else {
				dev->stats.tx_fifo_errors++;
				dev_warn(&dev->dev,
					 "Unexpected TX queue failure: %d\n",
					 capacity);
			}
		}
		dev->stats.tx_dropped++;
		kfree_skb(skb);
		return NETDEV_TX_OK;
	}
	virtqueue_kick(vi->svq);

So I'm not applying this patch (nor the virtqueue_get_capacity
predeccessor) for the moment.

Thanks,
Rusty.
