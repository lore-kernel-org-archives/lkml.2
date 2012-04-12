Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab2DLILb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 04:11:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab2DLILZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 04:11:25 -0400
Date: Thu, 12 Apr 2012 11:11:25 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, qemu-devel@nongnu.org
Subject: Re: [PATCH 1/3] virtio_balloon: Remove unnecessarily persistent state
Message-ID: <20120412081125.GA12585@redhat.com>
References: <1334208995-29985-1-git-send-email-david@gibson.dropbear.id.au>
 <1334208995-29985-2-git-send-email-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334208995-29985-2-git-send-email-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 03:36:33PM +1000, David Gibson wrote:
> The main virtio_balloon state structure contains the fields num_pfns and
> array 'pfns'.  Although they are stored here persistently, the lifetime of
> useful data in there is never more than one function - they're essentially
> used as though they were local variables.
> 
> For the pfns buffer, used to communicate a batch of pfns this is useful to
> avoid either transient kmalloc()s or putting too much data on the stack.
> For num_pfns, there is no reason it should not be a local, though.
> 
> This patch cleans things up by making num_pfns a local in the functions it
> is used in.  The pfns array remains, but the comment is updated to clarify
> that it contains no truly persistent data.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>

nak

IMO it makes sense to keep the array size around together with the
array: either we use local storage for both or for neither.

OTOH a comment is a good thing to add, just make it more specific,
see below.

> ---
>  drivers/virtio/virtio_balloon.c |   28 ++++++++++++++++------------
>  1 file changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 05f0a80..6c07793 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -46,8 +46,8 @@ struct virtio_balloon
>  	unsigned int num_pages;
>  	struct list_head pages;
>  
> -	/* The array of pfns we tell the Host about. */
> -	unsigned int num_pfns;
> +	/* Temporary buffer of pfns to pass to the host */

This needs to be more specific to be informative:
all things are temporary in this world :)

+ /* Valid for the duration of one command only */


> +	/* Store this here to avoid a too-large local array */
>  	u32 pfns[256];
>  
>  	/* Memory statistics */
> @@ -79,11 +79,12 @@ static void balloon_ack(struct virtqueue *vq)
>  		complete(&vb->acked);
>  }
>  
> -static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
> +static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq,
> +		      unsigned int n)
>  {
>  	struct scatterlist sg;
>  
> -	sg_init_one(&sg, vb->pfns, sizeof(vb->pfns[0]) * vb->num_pfns);
> +	sg_init_one(&sg, vb->pfns, sizeof(vb->pfns[0]) * n);
>  
>  	init_completion(&vb->acked);
>  
> @@ -98,10 +99,12 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
>  
>  static void fill_balloon(struct virtio_balloon *vb, size_t num)
>  {
> +	unsigned int n;
> +
>  	/* We can only do one array worth at a time. */
>  	num = min(num, ARRAY_SIZE(vb->pfns));
>  
> -	for (vb->num_pfns = 0; vb->num_pfns < num; vb->num_pfns++) {
> +	for (n = 0; n < num; n++) {
>  		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_NORETRY |
>  					__GFP_NOMEMALLOC | __GFP_NOWARN);
>  		if (!page) {
> @@ -113,17 +116,17 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
>  			msleep(200);
>  			break;
>  		}
> -		vb->pfns[vb->num_pfns] = page_to_balloon_pfn(page);
> +		vb->pfns[n] = page_to_balloon_pfn(page);
>  		totalram_pages--;
>  		vb->num_pages++;
>  		list_add(&page->lru, &vb->pages);
>  	}
>  
>  	/* Didn't get any?  Oh well. */
> -	if (vb->num_pfns == 0)
> +	if (n == 0)
>  		return;
>  
> -	tell_host(vb, vb->inflate_vq);
> +	tell_host(vb, vb->inflate_vq, n);
>  }
>  
>  static void release_pages_by_pfn(const u32 pfns[], unsigned int num)
> @@ -139,14 +142,15 @@ static void release_pages_by_pfn(const u32 pfns[], unsigned int num)
>  static void leak_balloon(struct virtio_balloon *vb, size_t num)
>  {
>  	struct page *page;
> +	unsigned int n;
>  
>  	/* We can only do one array worth at a time. */
>  	num = min(num, ARRAY_SIZE(vb->pfns));
>  
> -	for (vb->num_pfns = 0; vb->num_pfns < num; vb->num_pfns++) {
> +	for (n = 0; n < num; n++) {
>  		page = list_first_entry(&vb->pages, struct page, lru);
>  		list_del(&page->lru);
> -		vb->pfns[vb->num_pfns] = page_to_balloon_pfn(page);
> +		vb->pfns[n] = page_to_balloon_pfn(page);
>  		vb->num_pages--;
>  	}
>  
> @@ -155,8 +159,8 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
>  	 * virtio_has_feature(vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST);
>  	 * is true, we *have* to do it in this order
>  	 */
> -	tell_host(vb, vb->deflate_vq);
> -	release_pages_by_pfn(vb->pfns, vb->num_pfns);
> +	tell_host(vb, vb->deflate_vq, n);
> +	release_pages_by_pfn(vb->pfns, n);
>  }
>  
>  static inline void update_stat(struct virtio_balloon *vb, int idx,
> -- 
> 1.7.9.5
