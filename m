Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2JRJnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:43:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56338 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752998Ab2JRJnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:43:01 -0400
Date: Thu, 18 Oct 2012 10:42:47 +0100
From: Will Deacon <will.deacon@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: Re: [PATCH] virtio: 9p: correctly pass physical address to userspace
 for high pages
Message-ID: <20121018094247.GA17296@mudshark.cambridge.arm.com>
References: <1350468877-7677-1-git-send-email-will.deacon@arm.com>
 <87lif4o739.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lif4o739.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Thu, Oct 18, 2012 at 03:19:06AM +0100, Rusty Russell wrote:
> Will Deacon <will.deacon@arm.com> writes:
> > When using a virtio transport, the 9p net device allocates pages to back
> > the descriptors inserted into the virtqueue. These allocations may be
> > performed from atomic context (under the channel lock) and can therefore
> > return high mappings which aren't suitable for virt_to_phys.
> 
> I had not appreciated that subtlety about GFP_ATOMIC :(

Yeah, it's unfortunate for poor old userspace.

> This isn't just 9p, the console, block, scsi and net devices also use
> GFP_ATOMIC.

Ok, I'll split this patch in two since I think that only 9p has the
zero-copy stuff, which is why an extra fix is needed there for creating the
scatterlist correctly.

> > @@ -165,7 +166,8 @@ static int vring_add_indirect(struct vring_virtqueue *vq,
> >  	/* Use a single buffer which doesn't continue */
> >  	head = vq->free_head;
> >  	vq->vring.desc[head].flags = VRING_DESC_F_INDIRECT;
> > -	vq->vring.desc[head].addr = virt_to_phys(desc);
> > +	vq->vring.desc[head].addr = page_to_phys(kmap_to_page(desc)) +
> > +				    ((unsigned long)desc & ~PAGE_MASK);
> >  	vq->vring.desc[head].len = i * sizeof(struct vring_desc);
> 
> Gah, virt_to_phys_harder()?

Tell me about it...

> What's the performance effect?  If it's negligible, why doesn't
> virt_to_phys() just do this for us?

I've not measured it, but even when you don't have CONFIG_HIGHMEM, there's
going to be an overhead here because we go around the houses to get the page
and then add the offset on afterwards. I doubt it's something we want to
plumb directly into virt_to_phys (also, kmap_to_page may call virt_to_phys via
the __pa macro so we'd get stuck).

> We do have an alternate solution: masking out __GFP_HIGHMEM from the
> kmalloc of desc.  If it fails, we will fall back to laying out the
> virtio request directly inside the ring; if it doesn't fit, we'll wait
> for the device to consume more buffers.

Hmm, that will probably work for the vring but the zero-copy code for 9p may
just give us an address from userspace if I'm understanding it correctly. In
that case, we really have to do the translation as below (which is actually
much cleaner because everything is page-aligned).

> > @@ -325,7 +326,7 @@ static int p9_get_mapped_pages(struct virtio_chan *chan,
> >  		int count = nr_pages;
> >  		while (nr_pages) {
> >  			s = rest_of_page(data);
> > -			pages[index++] = virt_to_page(data);
> > +			pages[index++] = kmap_to_page(data);
> >  			data += s;
> >  			nr_pages--;
> >  		}

So what do you reckon? How about I leave this hunk as a separate patch and
have a play masking out __GFP_HIGHMEM for the vring descriptor?

Cheers,

Will
