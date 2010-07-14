Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab0GNSZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:25:27 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:56159 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab0GNSZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:25:26 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Unai Uribarri <unai.uribarri@optenet.com>
Subject: Re: Workaround hardware bug addressing physical address
Date: Wed, 14 Jul 2010 21:18:05 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc5; KDE/4.4.3; x86_64; ; )
References: <28112199.68371279127209288.JavaMail.root@mail1-md.optenet.com>
In-Reply-To: <28112199.68371279127209288.JavaMail.root@mail1-md.optenet.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007142118.08024.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 14, 2010 08:06:49 pm you wrote:
> ----- "Marin Mitov" <mitov@issp.bas.bg> wrote:
> 
> | Hi,
> | 
> | This is pci driver. You can set dma mask:
> | 
> | dma_set_coheren_mask(pdev, DMA_BIT_MASK(31)) 
> | 
> | All further alloc_coherent() should be from the region 0-2GB.
> | 
> 
> But I'm using a 64 bit operating system with 32GB of RAM. It's a pity to be unable to use 4GB-32GB range because the 2-4GB range is unusable. So I've written this code to skip invalid areas. Do you think this code could be useful for other drivers?

Let me summarize if I have correctly understood what you do.

First, your hardware has problems when the physical (bus) address
is out of the 0-2GB region, so you cannot use buffers that are out 
of this range in any case. And the defect is in the peripheral, not in 
the bridge between it and the memory.

Second, you do allocations and check if dma_addr_t is in this range.
If it is, you keep it for use. If not, you put it in a list and allocate a new one.
When you allocate sufficiently memory in 0-2GB region, you deallocate 
the memory (kept in the list) that is out of the region. Right?

The same effect you could have if you first call 

dma_set_coheren_mask(pdev, DMA_BIT_MASK(31))

after that call every alloc_coherent() for this device only 
should return memory from the region 0-2GB

Setting the coherent mask is per device (the first argument of the function)
All the other devices will use 0-32GB memory according their own dma masks.

Hope that helps.

Marin Mitov

> 
> 
> /** Structure used to store all the information about a DMA allocation which is
>  * needed to free it. It also has a next field to chain the allocations.
>  */
> typedef struct dma_allocation
> {
>     struct device *dev;
>     size_t size;
>     dma_addr_t dma_handle;
>     struct list_head list;
> } dma_allocation_t;
> 
> /** Validates a dma allocation
>  * @param{in} ptr is the pointer to the allocated dma memory
>  * @param{in} dma_handle is the handle to the allocated dma memory
>  * @return 0 if the allocation isn't valid.
>  */
> typedef int (*dma_validator_t)(void *ptr, struct device *dev, size_t size, dma_addr_t handle);
> 
> /** Allocates validated coherent DMA memory.
>  *
>  * Same paremeters and return value as dma_alloc_coherent, and:
>  *  @param{in} invalid_allocs is a pointer to a list where invalid allocations are enqueued
>  *  @param{in} validator is the validation function
>  *
>  * While the chunk of memory allocated by dma_alloc_coherent doesn't pass the validator filter,
>  * it's queued in invalid_allocs and another chunk of memory is allocated.
>  */
> static void *dma_validated_alloc_coherent(struct list_head *invalid_allocs, dma_validator_t validator,
>      struct device *dev, size_t size, dma_addr_t *dma_handle, gfp_t flag)
> {
>     void *res = dma_alloc_coherent(dev, size, dma_handle, flag);
> 
>     while (!IS_ERR(res) && !validator(res, dev, size, *dma_handle)) {
>         dma_allocation_t *entry = res;
>         entry->dev = dev;
>         entry->size = size;
>         entry->dma_handle = *dma_handle;
>         list_add_tail(&entry->list, invalid_allocs);
> 
>         res = dma_alloc_coherent(dev, size, dma_handle, flag);
>     }
>     return res;
> }
> 
> /** Frees all the coherent dma allocations contained in list */
> static void dma_list_free_coherent(struct list_head *list)
> {
>     dma_allocation_t *cur, *next;
>     list_for_each_entry_safe(cur, next, list, list) {
>         dma_free_coherent(cur->dev, cur->size, cur, cur->dma_handle);
>     }
> }
> 
