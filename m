Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab1EIGC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 02:02:59 -0400
Received: from ozlabs.org ([203.10.76.45]:44082 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab1EIGC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 02:02:57 -0400
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
Subject: Re: [PATCH 08/18] virtio_ring: support for used_event idx feature
In-Reply-To: <dd16b9f3bad847b0eadc7f94368e27982c1a7560.1304541919.git.mst@redhat.com>
References: <cover.1304541918.git.mst@redhat.com> <dd16b9f3bad847b0eadc7f94368e27982c1a7560.1304541919.git.mst@redhat.com>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Mon, 09 May 2011 13:47:32 +0930
Message-ID: <878vugh5ib.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011 23:51:38 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> Add support for the used_event idx feature: when enabling
> interrupts, publish the current avail index value to
> the host so that we get interrupts on the next update.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/virtio/virtio_ring.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 507d6eb..3a3ed75 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -320,6 +320,14 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
>  	ret = vq->data[i];
>  	detach_buf(vq, i);
>  	vq->last_used_idx++;
> +	/* If we expect an interrupt for the next entry, tell host
> +	 * by writing event index and flush out the write before
> +	 * the read in the next get_buf call. */
> +	if (!(vq->vring.avail->flags & VRING_AVAIL_F_NO_INTERRUPT)) {
> +		vring_used_event(&vq->vring) = vq->last_used_idx;
> +		virtio_mb();
> +	}
> +

Hmm, so you're still using the avail->flags; it's just if thresholding
is enabled the host will ignore it?

It's a little subtle, but it keeps this patch small.  Perhaps we'll want
to make it more explicit later.

Thanks,
Rusty.
