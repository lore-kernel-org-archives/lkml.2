Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab1EUCew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 22:34:52 -0400
Received: from ozlabs.org ([203.10.76.45]:34436 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707Ab1EUCeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: Re: [PATCHv2 11/14] virtio: don't delay avail index update
In-Reply-To: <33d7df119ccbedc9b54fbe4b674076b4f7ba3499.1305846412.git.mst@redhat.com>
References: <cover.1305846412.git.mst@redhat.com> <33d7df119ccbedc9b54fbe4b674076b4f7ba3499.1305846412.git.mst@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Sat, 21 May 2011 11:56:32 +0930
Message-ID: <874o4ovlev.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011 02:12:19 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> Update avail index immediately instead of upon kick:
> for virtio-net RX this helps parallelism with the host.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/virtio/virtio_ring.c |   28 +++++++++++++++++++---------
>  1 files changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index eed5f29..8218fe6 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -89,7 +89,7 @@ struct vring_virtqueue
>  	unsigned int num_free;
>  	/* Head of free buffer list. */
>  	unsigned int free_head;
> -	/* Number we've added since last sync. */
> +	/* Number we've added since last kick. */
>  	unsigned int num_added;

I always like to see obsolescent nomenclature cleaned up like this.
Thanks.

>  	/* Last used index we've seen. */
> @@ -174,6 +174,13 @@ int virtqueue_add_buf_gfp(struct virtqueue *_vq,
>  
>  	BUG_ON(data == NULL);
>  
> +	/* Prevent drivers from adding more than num bufs without a kick. */
> +	if (vq->num_added == vq->vring.num) {
> +		printk(KERN_ERR "gaaa!!!\n");
> +		END_USE(vq);
> +		return -ENOSPC;
> +	}
> +

I like "gaaa!" but it won't tell us which driver.  How about the more
conventional:

        if (WARN_ON(vq->num_added >= vq->vring.num)) {
        	END_USE(vq);
        	return -ENOSPC;
        }

I'd really like to see the results of this patch.  It's useless for
outgoing net traffic (we deal with one packet at a time) but perhaps a
flood of incoming packets would show something.

Thanks,
Rusty.
