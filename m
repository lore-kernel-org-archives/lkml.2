Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab2KEOMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:12:30 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37013 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276Ab2KEOM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:12:28 -0500
Date: Mon, 5 Nov 2012 08:59:29 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Shuah Khan <shuah.khan@hp.com>
Cc: Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>,
        kubakici@wp.pl, stern@rowland.harvard.edu,
        Greg KH <gregkh@linuxfoundation.org>, Mark Salter <msalter@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Subject: Re: [PATCH] dma-debug: fix to not have dependency on get_dma_ops()
 interface
Message-ID: <20121105135929.GF11802@phenom.dumpdata.com>
References: <1351983607.2773.9.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351983607.2773.9.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 05:00:07PM -0600, Shuah Khan wrote:
> dma-debug depends on get_dma_ops() interface. Several architectures
> do not define dma_ops and get_dma_ops(). When dma debug interfaces are
> used on an architecture (e.g: c6x) that doesn't define get_dmap_ops(),
> compilation fails. Changing dma-debug to call dma_mapping_error() instead
> of defining its own that calls get_dma_ops(), such that the internal use of
> dma_mapping_error() doesn't interfere with the debug_dma_mapping_error()
> interface's mapping error checks. Moving dma_mapping_error() checks in
> check_unmap() under the dma debug entry not found is sufficient to fix the
> problem.

OK.

It looks ok to me.

> -   debug_dma_mapping_error() - need internal mapping error routine to
> -   avoid debug checks */
> -#ifndef DMA_ERROR_CODE
> -#define DMA_ERROR_CODE 0
> -#endif
> -static inline int has_mapping_error(struct device *dev, dma_addr_t dma_addr)
> -{
> -	const struct dma_map_ops *ops = get_dma_ops(dev);
> -	if (ops->mapping_error)
> -		return ops->mapping_error(dev, dma_addr);
> -
> -	return (dma_addr == DMA_ERROR_CODE);
> -}
> -
>  static void check_unmap(struct dma_debug_entry *ref)
>  {
>  	struct dma_debug_entry *entry;
>  	struct hash_bucket *bucket;
>  	unsigned long flags;
>  
> -	if (unlikely(has_mapping_error(ref->dev, ref->dev_addr))) {
> -		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
> -			   "to free an invalid DMA memory address\n");
> -		return;
> -	}
> -
>  	bucket = get_hash_bucket(ref, &flags);
>  	entry = bucket_find_exact(bucket, ref);
>  
>  	if (!entry) {
> +		if (dma_mapping_error(ref->dev, ref->dev_addr)) {
> +			err_printk(ref->dev, NULL,
> +				   "DMA-API: device driver tries "
> +				   "to free an invalid DMA memory address\n");
> +			return;
> +		}
>  		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
>  			   "to free DMA memory it has not allocated "
>  			   "[device address=0x%016llx] [size=%llu bytes]\n",
> @@ -1055,7 +1040,7 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
>  	if (unlikely(global_disable))
>  		return;
>  
> -	if (unlikely(has_mapping_error(dev, dma_addr)))
> +	if (dma_mapping_error(dev, dma_addr))
>  		return;
>  
>  	entry = dma_entry_alloc();
> -- 
> 1.7.9.5
> 
> 
