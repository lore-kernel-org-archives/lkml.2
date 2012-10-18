Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab2JRDSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 23:18:38 -0400
Received: from ozlabs.org ([203.10.76.45]:43131 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab2JRDSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 23:18:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>, Sasha Levin <levinsasha928@gmail.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "lf-virt" <virtualization@lists.linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: Re: [PATCH] virtio: 9p: correctly pass physical address to userspace for high pages
In-Reply-To: <1350468877-7677-1-git-send-email-will.deacon@arm.com>
References: <1350468877-7677-1-git-send-email-will.deacon@arm.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 18 Oct 2012 12:49:06 +1030
Message-ID: <87lif4o739.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Deacon <will.deacon@arm.com> writes:
> When using a virtio transport, the 9p net device allocates pages to back
> the descriptors inserted into the virtqueue. These allocations may be
> performed from atomic context (under the channel lock) and can therefore
> return high mappings which aren't suitable for virt_to_phys.

I had not appreciated that subtlety about GFP_ATOMIC :(

This isn't just 9p, the console, block, scsi and net devices also use
GFP_ATOMIC.

> @@ -165,7 +166,8 @@ static int vring_add_indirect(struct vring_virtqueue *vq,
>  	/* Use a single buffer which doesn't continue */
>  	head = vq->free_head;
>  	vq->vring.desc[head].flags = VRING_DESC_F_INDIRECT;
> -	vq->vring.desc[head].addr = virt_to_phys(desc);
> +	vq->vring.desc[head].addr = page_to_phys(kmap_to_page(desc)) +
> +				    ((unsigned long)desc & ~PAGE_MASK);
>  	vq->vring.desc[head].len = i * sizeof(struct vring_desc);

Gah, virt_to_phys_harder()?

What's the performance effect?  If it's negligible, why doesn't
virt_to_phys() just do this for us?

We do have an alternate solution: masking out __GFP_HIGHMEM from the
kmalloc of desc.  If it fails, we will fall back to laying out the
virtio request directly inside the ring; if it doesn't fit, we'll wait
for the device to consume more buffers.

> @@ -325,7 +326,7 @@ static int p9_get_mapped_pages(struct virtio_chan *chan,
>  		int count = nr_pages;
>  		while (nr_pages) {
>  			s = rest_of_page(data);
> -			pages[index++] = virt_to_page(data);
> +			pages[index++] = kmap_to_page(data);
>  			data += s;
>  			nr_pages--;
>  		}

This seems like a separate bug fix.

Cheers,
Rusty.
