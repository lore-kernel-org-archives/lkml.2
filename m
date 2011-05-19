Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab1ESBEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 21:04:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50299 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab1ESBEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 21:04:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=gErzuoYYJ69lbvRQpY1aSYvKNxvOPHjciku98uRwDCjjidDUd/gOcxED22dXBnJ+by
         drF4UlROPf/+yTHvOV1TmXsSsK6uX+gAzlNvUlR7vv7AojGw+g43iyt7xg2Q8DtHZJ/m
         17ap3CM+SJGIHBAcXrz2lurbY3myr4JPPuEms=
MIME-Version: 1.0
In-Reply-To: <BANLkTi==cinS1bZc_ARRbnYT3YD+FQr8gA@mail.gmail.com>
References: <BANLkTi==cinS1bZc_ARRbnYT3YD+FQr8gA@mail.gmail.com>
Date: Thu, 19 May 2011 03:04:38 +0200
Message-ID: <BANLkTinZJUWMc39TLP28M5=cRvqev+0QWg@mail.gmail.com>
Subject: Re: mmap() implementation for pci_alloc_consistent() memory?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: linux-pci@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 19, 2011 at 12:14 AM, Leon Woestenberg
<leon.woestenberg@gmail.com> wrote:
>
> int ringbuffer_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> {
>        /* the buffer allocated with pci_alloc_consistent() */
>        void *vaddr = ringbuffer_virt;
>        int ret;
>
>        /* find the struct page that describes vaddr, the buffer
>         * allocated with pci_alloc_consistent() */
>        struct page *page = virt_to_page(lro_char->engine->ringbuffer_virt);
>        vmf->page = page;
>
>        /*** I have verified that vaddr, page, and the pfn correspond
> with vaddr = pci_alloc_consistent() ***/
>        ret = vm_insert_pfn(vma, address, page_to_pfn(page));
>        return ret;
> }
>

Some further debugging insights:

I found that pfn_valid is 0 on page_to_pfn(page). Isn't
pci_alloc_consistent() memory backed by a real struct page?

I found that when I use the allocation/mapping below instead of
pci_alloc_consistent(), the fault handler does the mapping correctly.

	vaddr = __get_free_pages(GFP_KERNEL, 4);
	busaddr = dma_map_single(lro->pci_dev, vaddr,
		psize, dir_to_dev? DMA_TO_DEVICE: DMA_FROM_DEVICE);

Still no clue why the mmap fails on pci_alloc_consistent() memory.

Regards,
-- 
Leon
