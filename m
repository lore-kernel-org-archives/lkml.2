Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768541Ab2KOREb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 12:04:31 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:4128 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768440Ab2KORE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 12:04:29 -0500
Message-ID: <1352999057.2532.16.camel@lorien2>
Subject: Re: [PATCH] dma-debug: fix to not have dependency on get_dma_ops()
 interface
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>,
        kubakici@wp.pl, stern@rowland.harvard.edu,
        Greg KH <gregkh@linuxfoundation.org>, Mark Salter <msalter@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, konrad.wilk@oracle.com,
        shuahkhan@gmail.com
Date: Thu, 15 Nov 2012 10:04:17 -0700
In-Reply-To: <20121105135929.GF11802@phenom.dumpdata.com>
References: <1351983607.2773.9.camel@lorien2>
	 <20121105135929.GF11802@phenom.dumpdata.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-05 at 08:59 -0500, Konrad Rzeszutek Wilk wrote:
> On Sat, Nov 03, 2012 at 05:00:07PM -0600, Shuah Khan wrote:
> > dma-debug depends on get_dma_ops() interface. Several architectures
> > do not define dma_ops and get_dma_ops(). When dma debug interfaces are
> > used on an architecture (e.g: c6x) that doesn't define get_dmap_ops(),
> > compilation fails. Changing dma-debug to call dma_mapping_error() instead
> > of defining its own that calls get_dma_ops(), such that the internal use of
> > dma_mapping_error() doesn't interfere with the debug_dma_mapping_error()
> > interface's mapping error checks. Moving dma_mapping_error() checks in
> > check_unmap() under the dma debug entry not found is sufficient to fix the
> > problem.
> 
> OK.
> 
> It looks ok to me.

Marek,

Following up on our off-line discussion about your offer to pull
dma-debug patch and the arch patches that call debug_dma_mapping_error()
interface in to your tree. Thanks again for offering to do that. This
patch is depends on the first debug_dma_mapping_error() patch that is in
linux-next and in the dma-debug tree.

Reference - https://lkml.org/lkml/2012/10/8/296

linux-next commit-id is commit 6c9c6d6301287e369a754d628230fa6e50cdb74b

You will need to pull these two first into your tree and then the arch
patches - I will include you on my responses to those patches shortly.

-- Shuah

> 
> > -   debug_dma_mapping_error() - need internal mapping error routine to
> > -   avoid debug checks */
> > -#ifndef DMA_ERROR_CODE
> > -#define DMA_ERROR_CODE 0
> > -#endif
> > -static inline int has_mapping_error(struct device *dev, dma_addr_t dma_addr)
> > -{
> > -	const struct dma_map_ops *ops = get_dma_ops(dev);
> > -	if (ops->mapping_error)
> > -		return ops->mapping_error(dev, dma_addr);
> > -
> > -	return (dma_addr == DMA_ERROR_CODE);
> > -}
> > -
> >  static void check_unmap(struct dma_debug_entry *ref)
> >  {
> >  	struct dma_debug_entry *entry;
> >  	struct hash_bucket *bucket;
> >  	unsigned long flags;
> >  
> > -	if (unlikely(has_mapping_error(ref->dev, ref->dev_addr))) {
> > -		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
> > -			   "to free an invalid DMA memory address\n");
> > -		return;
> > -	}
> > -
> >  	bucket = get_hash_bucket(ref, &flags);
> >  	entry = bucket_find_exact(bucket, ref);
> >  
> >  	if (!entry) {
> > +		if (dma_mapping_error(ref->dev, ref->dev_addr)) {
> > +			err_printk(ref->dev, NULL,
> > +				   "DMA-API: device driver tries "
> > +				   "to free an invalid DMA memory address\n");
> > +			return;
> > +		}
> >  		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
> >  			   "to free DMA memory it has not allocated "
> >  			   "[device address=0x%016llx] [size=%llu bytes]\n",
> > @@ -1055,7 +1040,7 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
> >  	if (unlikely(global_disable))
> >  		return;
> >  
> > -	if (unlikely(has_mapping_error(dev, dma_addr)))
> > +	if (dma_mapping_error(dev, dma_addr))
> >  		return;
> >  
> >  	entry = dma_entry_alloc();
> > -- 
> > 1.7.9.5
> > 
> > 


