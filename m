Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab0GNRHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 13:07:18 -0400
Received: from mta-mad.optenet.com ([130.117.93.253]:61215 "EHLO
	mta-mad.optenet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab0GNRHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 13:07:16 -0400
Date: Wed, 14 Jul 2010 19:07:14 +0200 (CEST)
From: Unai Uribarri <unai.uribarri@optenet.com>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <12797200.68401279127234158.JavaMail.root@mail1-md.optenet.com>
In-Reply-To: <28112199.68371279127209288.JavaMail.root@mail1-md.optenet.com>
Subject: Re: Workaround hardware bug addressing physical address
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.3.29]
X-Mailer: Zimbra 5.0.11_GA_2695.UBUNTU8 (ZimbraWebClient - FF3.0 (Linux)/5.0.11_GA_2695.UBUNTU8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Marin Mitov" <mitov@issp.bas.bg> wrote:

| Hi,
| 
| This is pci driver. You can set dma mask:
| 
| dma_set_coheren_mask(pdev, DMA_BIT_MASK(31)) 
| 
| All further alloc_coherent() should be from the region 0-2GB.
| 

But I'm using a 64 bit operating system with 32GB of RAM. It's a pity to be unable to use 4GB-32GB range because the 2-4GB range is unusable. So I've written this code to skip invalid areas. Do you think this code could be useful for other drivers?


/** Structure used to store all the information about a DMA allocation which is
 * needed to free it. It also has a next field to chain the allocations.
 */
typedef struct dma_allocation
{
    struct device *dev;
    size_t size;
    dma_addr_t dma_handle;
    struct list_head list;
} dma_allocation_t;

/** Validates a dma allocation
 * @param{in} ptr is the pointer to the allocated dma memory
 * @param{in} dma_handle is the handle to the allocated dma memory
 * @return 0 if the allocation isn't valid.
 */
typedef int (*dma_validator_t)(void *ptr, struct device *dev, size_t size, dma_addr_t handle);

/** Allocates validated coherent DMA memory.
 *
 * Same paremeters and return value as dma_alloc_coherent, and:
 *  @param{in} invalid_allocs is a pointer to a list where invalid allocations are enqueued
 *  @param{in} validator is the validation function
 *
 * While the chunk of memory allocated by dma_alloc_coherent doesn't pass the validator filter,
 * it's queued in invalid_allocs and another chunk of memory is allocated.
 */
static void *dma_validated_alloc_coherent(struct list_head *invalid_allocs, dma_validator_t validator,
     struct device *dev, size_t size, dma_addr_t *dma_handle, gfp_t flag)
{
    void *res = dma_alloc_coherent(dev, size, dma_handle, flag);

    while (!IS_ERR(res) && !validator(res, dev, size, *dma_handle)) {
        dma_allocation_t *entry = res;
        entry->dev = dev;
        entry->size = size;
        entry->dma_handle = *dma_handle;
        list_add_tail(&entry->list, invalid_allocs);

        res = dma_alloc_coherent(dev, size, dma_handle, flag);
    }
    return res;
}

/** Frees all the coherent dma allocations contained in list */
static void dma_list_free_coherent(struct list_head *list)
{
    dma_allocation_t *cur, *next;
    list_for_each_entry_safe(cur, next, list, list) {
        dma_free_coherent(cur->dev, cur->size, cur, cur->dma_handle);
    }
}
