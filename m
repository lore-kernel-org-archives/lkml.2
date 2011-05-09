Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab1EIFx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 01:53:56 -0400
Received: from ozlabs.org ([203.10.76.45]:39355 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab1EIFxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 01:53:54 -0400
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
Subject: Re: [PATCH 09/18] virtio: use avail_event index
In-Reply-To: <8bba6a0a8eee17e741c5155b04ff1b1c9f34bf94.1304541919.git.mst@redhat.com>
References: <cover.1304541918.git.mst@redhat.com> <8bba6a0a8eee17e741c5155b04ff1b1c9f34bf94.1304541919.git.mst@redhat.com>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Mon, 09 May 2011 14:03:26 +0930
Message-ID: <874o54h4rt.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011 23:51:47 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> Use the new avail_event feature to reduce the number
> of exits from the guest.

Figures here would be nice :)

> @@ -228,6 +237,12 @@ add_head:
>  	 * new available array entries. */
>  	virtio_wmb();
>  	vq->vring.avail->idx++;
> +	/* If the driver never bothers to kick in a very long while,
> +	 * avail index might wrap around. If that happens, invalidate
> +	 * kicked_avail index we stored. TODO: make sure all drivers
> +	 * kick at least once in 2^16 and remove this. */
> +	if (unlikely(vq->vring.avail->idx == vq->kicked_avail))
> +		vq->kicked_avail_valid = true;

If they don't, they're already buggy.  Simply do:
        WARN_ON(vq->vring.avail->idx == vq->kicked_avail);

> +static bool vring_notify(struct vring_virtqueue *vq)
> +{
> +	u16 old, new;
> +	bool v;
> +	if (!vq->event)
> +		return !(vq->vring.used->flags & VRING_USED_F_NO_NOTIFY);
> +
> +	v = vq->kicked_avail_valid;
> +	old = vq->kicked_avail;
> +	new = vq->kicked_avail = vq->vring.avail->idx;
> +	vq->kicked_avail_valid = true;
> +	if (unlikely(!v))
> +		return true;

This is the only place you actually used kicked_avail_valid.  Is it
possible to initialize it in such a way that you can remove this?

> @@ -482,6 +517,8 @@ void vring_transport_features(struct virtio_device *vdev)
>  			break;
>  		case VIRTIO_RING_F_USED_EVENT_IDX:
>  			break;
> +		case VIRTIO_RING_F_AVAIL_EVENT_IDX:
> +			break;
>  		default:
>  			/* We don't understand this bit. */
>  			clear_bit(i, vdev->features);

Does this belong in a prior patch?

Thanks,
Rusty.
