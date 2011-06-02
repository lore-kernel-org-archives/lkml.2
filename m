Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417Ab1FBDzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 23:55:41 -0400
Received: from ozlabs.org ([203.10.76.45]:49503 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab1FBDzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 23:55:36 -0400
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
Subject: Re: [PATCH RFC 3/3] virtio_net: limit xmit polling
In-Reply-To: <1ec8eec325839ecf2eac9930a230361e7956047c.1306921434.git.mst@redhat.com>
References: <cover.1306921434.git.mst@redhat.com> <1ec8eec325839ecf2eac9930a230361e7956047c.1306921434.git.mst@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 02 Jun 2011 13:24:57 +0930
Message-ID: <87pqmwj3am.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011 12:50:03 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> Current code might introduce a lot of latency variation
> if there are many pending bufs at the time we
> attempt to transmit a new one. This is bad for
> real-time applications and can't be good for TCP either.
> 
> Free up just enough to both clean up all buffers
> eventually and to be able to xmit the next packet.

OK, I found this quite confusing to read.

> -	while ((skb = virtqueue_get_buf(vi->svq, &len)) != NULL) {
> +	while ((r = virtqueue_min_capacity(vi->svq) < MAX_SKB_FRAGS + 2) ||
> +	       min_skbs-- > 0) {
> +		skb = virtqueue_get_buf(vi->svq, &len);
> +		if (unlikely(!skb))
> +			break;
>  		pr_debug("Sent skb %p\n", skb);
>  		vi->dev->stats.tx_bytes += skb->len;
>  		vi->dev->stats.tx_packets++;
>  		dev_kfree_skb_any(skb);
>  	}
> +	return r;
>  }

Gah... what a horrible loop.

Basically, this patch makes hard-to-read code worse, and we should try
to make it better.

Currently, xmit *can* fail when an xmit interrupt wakes the queue, but
the packet(s) xmitted didn't free up enough space for the new packet.
With indirect buffers this only happens if we hit OOM (and thus go to
direct buffers).

We could solve this by only waking the queue in skb_xmit_done if the
capacity is >= 2 + MAX_SKB_FRAGS.  But can we do it without a race?

If not, then I'd really prefer to see this, because I think it's clearer:

        // Try to free 2 buffers for every 1 xmit, to stay ahead.
        free_old_buffers(2)

        if (!add_buf()) {
                // Screw latency, free them all.
                free_old_buffers(UINT_MAX)
                // OK, this can happen if we are using direct buffers,
                // and the xmit interrupt woke us but the packets
                // xmitted were smaller than this one.  Rare though.
                if (!add_buf())
                        Whinge and stop queue, maybe loop.
        }

        if (capacity < 2 + MAX_SKB_FRAGS) {
                // We don't have enough for the next packet?  Try
                // freeing more.
                free_old_buffers(UINT_MAX);
                if (capacity < 2 + MAX_SKB_FRAGS) {
                        Stop queue, maybe loop.
        }

The current code makes my head hurt :(

Thoughts?
Rusty.
