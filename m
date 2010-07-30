Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab0G3Lks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 07:40:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51425 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab0G3Lkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 07:40:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GSMc/VJ+/SDJvxH/kLsPMu9Bg/gqfK2kPQiX95ZimVmb7aWJVJiyFz0aJ9pzaBRPsk
         QmMArlpR5LeH7TD68U3gpCEGhEws3JMk0qXzBlRYqkW70Nfe12JBRIOLV+r5cJlQWz/D
         zB3XBuozN3YJRmwL2QrlMJ/QFOwmn/IIVP8pU=
Subject: Re: [PATCH v2]Resend:videobuf_dma_sg: a new implementation for mmap
From: "Figo.zhang" <figo1802@gmail.com>
To: npiggin@suse.de, Mauro Carvalho Chehab <mchehab@infradead.org>,
        akpm <akpm@linux-foundation.org>
Cc: linux-media <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <201007301131.17638.laurent.pinchart@ideasonboard.com>
References: <1280448482.2648.2.camel@localhost.localdomain>
	 <201007301131.17638.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 19:38:31 +0800
Message-ID: <1280489911.2648.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-30 at 11:31 +0200, Laurent Pinchart wrote:
> Hi,
> 
> On Friday 30 July 2010 02:08:02 Figo.zhang wrote:
> > a mmap issue for videobuf-dma-sg: it will alloc a new page for mmaping when
> > it encounter page fault at video_vm_ops->fault(). pls see
> > http://www.spinics.net/lists/linux-media/msg21243.html
> > 
> > a new implementation for mmap, it translate to vmalloc to page at
> > video_vm_ops->fault().
> > 
> > in v2, if mem->dma.vmalloc is NULL at video_vm_ops->fault(), it will alloc
> > memory by vmlloc_32().
> 
> You're replacing allocation in videobuf_vm_fault by allocationg in 
> videobuf_vm_fault. I don't see the point. videobuf_vm_fault needs to go away 
> completely.
in now videobuf code, the mmap alloc a new buf, the capture dma buffer
using vmalloc() alloc buffer, how is
relationship with them? in usrspace , the mmap region will not the
actual capture dma data, how is work? 

> 
> This has been discussed previously: fixing videobuf is not really possible. A 
> videobuf2 implementation is needed and is (slowly) being worked on. 
hi Mauro, do you think this is a issue for videobuf-dma-sg?

> I wouldn't 
> bother with this patch, just drop it.
> 
> > Signed-off-by: Figo.zhang <figo1802@gmail.com>
> > ---
> > drivers/media/video/videobuf-dma-sg.c |   50
> > +++++++++++++++++++++++++++------ 1 files changed, 41 insertions(+), 9
> > deletions(-)
> > 
> > diff --git a/drivers/media/video/videobuf-dma-sg.c
> > b/drivers/media/video/videobuf-dma-sg.c index 8359e6b..f7295da 100644
> > --- a/drivers/media/video/videobuf-dma-sg.c
> > +++ b/drivers/media/video/videobuf-dma-sg.c
> > @@ -201,10 +201,11 @@ int videobuf_dma_init_kernel(struct videobuf_dmabuf
> > *dma, int direction, dprintk(1, "init kernel [%d pages]\n", nr_pages);
> > 
> >  	dma->direction = direction;
> > -	dma->vmalloc = vmalloc_32(nr_pages << PAGE_SHIFT);
> > -	if (NULL == dma->vmalloc) {
> > -		dprintk(1, "vmalloc_32(%d pages) failed\n", nr_pages);
> > -		return -ENOMEM;
> > +	if (!dma->vmalloc)
> > +		dma->vmalloc = vmalloc_32(nr_pages << PAGE_SHIFT);
> > +		if (NULL == dma->vmalloc) {
> > +			dprintk(1, "vmalloc_32(%d pages) failed\n", nr_pages);
> > +			return -ENOMEM;
> >  	}
> > 
> >  	dprintk(1, "vmalloc is at addr 0x%08lx, size=%d\n",
> > @@ -397,16 +398,47 @@ static void videobuf_vm_close(struct vm_area_struct
> > *vma) */
> >  static int videobuf_vm_fault(struct vm_area_struct *vma, struct vm_fault
> > *vmf) {
> > -	struct page *page;
> > +	struct page *page = NULL;
> > +	struct videobuf_mapping *map = vma->vm_private_data;
> > +	struct videobuf_queue *q = map->q;
> > +	struct videobuf_dma_sg_memory *mem = NULL;
> > +
> > +	unsigned long offset;
> > +	unsigned long page_nr;
> > +	int first;
> > 
> >  	dprintk(3, "fault: fault @ %08lx [vma %08lx-%08lx]\n",
> >  		(unsigned long)vmf->virtual_address,
> >  		vma->vm_start, vma->vm_end);
> > 
> > -	page = alloc_page(GFP_USER | __GFP_DMA32);
> > -	if (!page)
> > -		return VM_FAULT_OOM;
> > -	clear_user_highpage(page, (unsigned long)vmf->virtual_address);
> > +	mutex_lock(&q->vb_lock);
> > +	offset = (unsigned long)vmf->virtual_address - vma->vm_start;
> > +	page_nr = offset >> PAGE_SHIFT;
> > +
> > +	for (first = 0; first < VIDEO_MAX_FRAME; first++) {
> > +			if (NULL == q->bufs[first])
> > +				continue;
> > +
> > +			MAGIC_CHECK(mem->magic, MAGIC_SG_MEM);
> > +
> > +			if (q->bufs[first]->map == map)
> > +				break;
> > +	}
> > +
> > +	mem = q->bufs[first]->priv;
> > +	if (!mem)
> > +		return VM_FAULT_SIGBUS;
> > +	if (!mem->dma.vmalloc) {
> > +		mem->dma.vmalloc = vmalloc_32(PAGE_ALIGN(q->bufs[first]->size));
> > +		if (NULL == mem->dma.vmalloc) {
> > +			dprintk(1, "%s: vmalloc_32() failed\n", __func__);
> > +			return VM_FAULT_OOM;
> > +		}
> > +	} else
> > +		page = vmalloc_to_page(mem->dma.vmalloc+
> > +				(offset & (~PAGE_MASK)));
> > +	mutex_unlock(&q->vb_lock);
> > +
> >  	vmf->page = page;
> > 
> >  	return 0;
> 


