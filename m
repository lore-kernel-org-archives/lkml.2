Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab2JEWvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 18:51:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2JEWvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 18:51:10 -0400
Date: Fri, 5 Oct 2012 15:51:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shuah.khan@hp.com
Cc: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, stern@rowland.harvard.edu,
        joerg.roedel@amd.com, bhelgaas@google.com,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        devel@linuxdriverproject.org, x86@kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH v4] dma-debug: New interfaces to debug dma mapping
 errors
Message-Id: <20121005155108.d8d88fd2.akpm@linux-foundation.org>
In-Reply-To: <1349400193.2547.29.camel@lorien2>
References: <1347843171.4370.13.camel@lorien2>
	<1348621517.3091.6.camel@lorien2>
	<1349276159.3192.4.camel@lorien2>
	<1349400193.2547.29.camel@lorien2>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Oct 2012 19:23:13 -0600
Shuah Khan <shuah.khan@hp.com> wrote:

> A recent dma mapping error analysis effort showed that a large percentage
> of dma_map_single() and dma_map_page() returns are not checked for mapping
> errors.
> 
> Reference:
> http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis
> 
> Adding support for tracking dma mapping and unmapping errors to help assess
> the following:
> 
> When do dma mapping errors get detected?
> How often do these errors occur?
> Why don't we see failures related to missing dma mapping error checks?
> Are they silent failures?
> 
> Patch v4: Addresses extra tab review comments from Patch v3.
> Patch v3: Addresses review and design comments from Patch v2.
> Patch v2: Addressed design issues from Patch v1.
> 
> Enhance dma-debug infrastructure to track dma mapping, and unmapping errors.
> 
> map_errors: (system wide counter)
>   Total number of dma mapping errors returned by the dma mapping interfaces,
>   in response to mapping requests from all devices in the system.
> map_errors_not_checked: (system wide counter)
>   Total number of dma mapping errors devices failed to check before using
>   the returned address.
> unmap_errors: (system wide counter)
>   Total number of times devices tried to unmap or free an invalid dma
>   address.
> map_err_type: (new field added to dma_debug_entry structure)
>   New field to maintain dma mapping error check status. This error type
>   is applicable to the dma map page and dma map single entries tracked by
>   dma-debug api. This status indicates whether or not a good mapping is
>   checked by the device before its use. dma_map_single() and dma_map_page()
>   could fail to create a mapping in some cases, and drivers are expected to
>   call dma_mapping_error() to check for errors. Please note that this is not
>   counter.
> 
> Enhancements to dma-debug api are made to add new debugfs interfaces to
> report total dma errors, dma errors that are not checked, and unmap errors
> for the entire system. Please note that these are system wide counters for
> all devices in the system.
> 
> The following new dma-debug interface is added:
> 
> debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
> 	Sets dma map error checked status for the dma map entry if one is
> 	found. Decrements the system wide dma_map_errors_not_checked counter
> 	that is incremented by debug_dma_map_page() when it checks for
> 	mapping error before adding it to the dma debug entry table.
> 
> New dma-debug internal interface:
> check_mapping_error(struct device *dev, dma_addr_t dma_addr)
> Calling dma_mapping_error() from dma-debug api will result in dma mapping
> check when it shouldn't. This internal routine checks dma mapping error
> without any debug checks. 
> 
> The following existing dma-debug api are changed to support this feature:
> debug_dma_map_page()
> 	Increments dma_map_errors and dma_map_errors_not_checked errors totals
> 	for the system, dma-debug api keeps track of, when dma_addr is invalid.
> 	This routine now calls internal check_mapping_error() interface to
> 	avoid doing dma mapping debug checks from dma-debug internal mapping
> 	error checks.
> check_unmap()
> 	This is an existing internal routines that checks for various mapping
> 	errors. Changed to increment system wide dma_unmap_errors, when a
> 	device requests an invalid address to be unmapped. This routine now
> 	calls internal check_mapping_error() interface to avoid doing dma
> 	mapping debug checks from dma-debug internal mapping error checks.
> 
> Changed arch/x86/include/asm/dma-mapping.h to call debug_dma_mapping_error()
> to validate these new interfaces on x86_64. Other architectures will be
> changed in a subsequent patch.
> 
> Tested: Intel iommu and swiotlb (iommu=soft) on x86-64 with
>         CONFIG_DMA_API_DEBUG enabled and disabled.

Still seems overly complicated to me, but whatev.

I think the way to handle this is pretty simple: set a flag in the dma
entry when someone runs dma_mapping_error() and, if that flag wasn't
set at unmap time, emit a loud warning.

>From my reading of the code, this patch indeed does that, along with a
bunch of other (unnecessary?) stuff.  But boy, the changelog conceals
this information well!

>  Documentation/DMA-API.txt          |   13 +++++
>  arch/x86/include/asm/dma-mapping.h |    1 +
>  include/linux/dma-debug.h          |    7 +++
>  lib/dma-debug.c                    |  110 ++++++++++++++++++++++++++++++++++--

Please, go through Documentation/DMA-API-HOWTO.txt with a toothcomb and
ensure that all this is appropriately covered and that the examples are
completed for error checking.

>
> ...
>
> +static inline int check_mapping_error(struct device *dev, dma_addr_t dma_addr)
> +{
> +	const struct dma_map_ops *ops = get_dma_ops(dev);
> +	if (ops->mapping_error)
> +		return ops->mapping_error(dev, dma_addr);
> +
> +	return (dma_addr == DMA_ERROR_CODE);
> +}

I'm not a fan of functions called check_foo() because I never know
whether their return value means "foo is true" or "foo is false".  It
doesn't help that the return value here is undocumented.  Names such as
has_mapping_error() or mapping_has_error() will remove this question,
thereby making the call sites more readable.

>  static void check_unmap(struct dma_debug_entry *ref)
>  {
>  	struct dma_debug_entry *entry;
>  	struct hash_bucket *bucket;
>  	unsigned long flags;
>  
> -	if (dma_mapping_error(ref->dev, ref->dev_addr)) {
> +	if (unlikely(check_mapping_error(ref->dev, ref->dev_addr))) {
> +		unmap_errors += 1;
>  		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
>  			   "to free an invalid DMA memory address\n");
>  		return;
> @@ -915,6 +975,15 @@ static void check_unmap(struct dma_debug_entry *ref)
>  			   dir2name[ref->direction]);
>  	}
>  
> +	if (entry->map_err_type == MAP_ERR_NOT_CHECKED) {
> +		err_printk(ref->dev, entry,
> +			   "DMA-API: device driver failed to check map error"
> +			   "[device address=0x%016llx] [size=%llu bytes] "
> +			   "[mapped as %s]",
> +			   ref->dev_addr, ref->size,
> +			   type2name[entry->type]);
> +	}

It's important that this warning be associated with a backtrace so we
can identify the offending call site in the usual fashion. 
err_printk() does include a backtrace under some circumstances, but
those circumstances hurt my brain.

Is it guaranteed that we'll have that backtrace?  If not, I'd suggest
making it so.

>  	hash_bucket_del(entry);
>  	dma_entry_free(entry);
>  
>
> ...
>
> +void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
> +{
> +	struct dma_debug_entry ref;
> +	struct dma_debug_entry *entry;
> +	struct hash_bucket *bucket;
> +	unsigned long flags;
> +
> +	if (unlikely(global_disable))
> +		return;
> +
> +	ref.dev = dev;
> +	ref.dev_addr = dma_addr;
> +	bucket = get_hash_bucket(&ref, &flags);
> +	entry = bucket_find_exact(bucket, &ref);
> +
> +	if (!entry) {
> +		/* very likley dma-api didn't call debug_dma_map_page() or
> +		   debug_dma_map_page() detected mapping error */
> +		if (map_errors_not_checked)
> +			map_errors_not_checked -= 1;
> +		goto out;
> +	}
> +
> +	entry->map_err_type = MAP_ERR_CHECKED;
> +out:
> +	put_hash_bucket(bucket, &flags);
> +}
> +EXPORT_SYMBOL(debug_dma_mapping_error);

Well, it's a global, exported-to-modules symbol.  Some formal
documentation is appropriate for such things.

>
> ...
>

