Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1CUWnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 18:43:16 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55404 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab1CUWnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 18:43:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kB08hZFlcyWPBar3ZPu55bpl73iD+khiK6uCwrhLWBTrzKCgk6wuGOijmveLX/z+zm
         fHpnosVMqWqTWV3yTR+KZUpCcUjeZJ5N+KnA8prr6CRXxWFC1dqSgQJpaZ5Qyvpe/gSW
         YQbhUzAV6W41E9UVcPzYikU4iEn5kZbXalO8s=
Message-ID: <4D87D47B.80206@gmail.com>
Date: Mon, 21 Mar 2011 19:43:07 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Subject: Re: [PATCH v2 -resend#1 1/1] V4L: videobuf, don't use dma addr as
 physical
References: <1298885822-10083-1-git-send-email-jslaby@suse.cz> <20110228145301.GC10846@dumpdata.com> <4D6BC3AE.903@suse.cz> <4D6BE756.1090800@infradead.org>
In-Reply-To: <4D6BE756.1090800@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-02-2011 15:20, Mauro Carvalho Chehab escreveu:
> Em 28-02-2011 12:47, Jiri Slaby escreveu:
>> On 02/28/2011 03:53 PM, Konrad Rzeszutek Wilk wrote:
>>> On Mon, Feb 28, 2011 at 10:37:02AM +0100, Jiri Slaby wrote:
>>>> mem->dma_handle is a dma address obtained by dma_alloc_coherent which
>>>> needn't be a physical address in presence of IOMMU. So ensure we are
>>>
>>> Can you add a comment why you are fixing it? Is there a bug report for this?
>>> Under what conditions did you expose this fault?
>>
>> No, by a just peer review when I was looking for something completely
>> different.
>>
>>> You also might want to mention that "needn't be a physical address as
>>> a hardware IOMMU can (and most likely) will return a bus address where
>>> physical != bus address."
>>
>> Mauro, do you want me to resend this with such an udpate in the changelog?
> 
> Having it properly documented is always a good idea, especially since a similar
> fix might be needed on other drivers that also need contiguous memory. While it
> currently is used only on devices embedded on hardware with no iommu, there are
> some x86 hardware that doesn't allow DMA scatter/gather.
> 
> Btw, it may be worth to take a look at vb2 dma contig module, as it might have
> similar issues.
> 
>>> Otherwise you can stick 'Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>'
>>> on it.
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

As I got no return, and the patch looked sane, I've reviewed the comment myself,
in order to make it more explicit, as suggested by Konrad, and added his
reviewed-by: tag:

Author: Jiri Slaby <jslaby@suse.cz>
Date:   Mon Feb 28 06:37:02 2011 -0300

    [media] V4L: videobuf, don't use dma addr as physical
    
    mem->dma_handle is a dma address obtained by dma_alloc_coherent which
    needn't be a physical address in presence of IOMMU, as
    a hardware IOMMU can (and most likely) will return a bus address where
    physical != bus address.
    
    So ensure we are remapping (remap_pfn_range) the right page in
    __videobuf_mmap_mapper by using virt_to_phys(mem->vaddr) and not
    mem->dma_handle.
    
    While at it, use PFN_DOWN instead of explicit shift.
    
    Signed-off-by: Jiri Slaby <jslaby@suse.cz>
    Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index c969111..19d3e4a 100644
--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -300,7 +300,7 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 
        vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
        retval = remap_pfn_range(vma, vma->vm_start,
-                            mem->dma_handle >> PAGE_SHIFT,
+                          PFN_DOWN(virt_to_phys(mem->vaddr))
                                 size, vma->vm_page_prot);
        if (retval) {
                dev_err(q->dev, "mmap: remap failed with error %d. ", retval);
