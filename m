Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab2IZNYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 09:24:04 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30338 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2IZNYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:24:01 -0400
Date: Wed, 26 Sep 2012 09:12:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Shuah Khan <shuah.khan@hp.com>
Cc: joerg.roedel@amd.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rob@landley.net, akpm@linux-foundation.org, bhelgaas@google.com,
        stern@rowland.harvard.edu, LKML <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, devel@linuxdriverproject.org,
        x86@kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH v2] dma-debug: New interfaces to debug dma mapping errors
Message-ID: <20120926131210.GA9309@phenom.dumpdata.com>
References: <1347843171.4370.13.camel@lorien2>
 <1348621517.3091.6.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348621517.3091.6.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Enhancements to dma-debug API are made to add new debugfs interfaces to
> report total dma errors, dma errors that are not checked, and unmap errors
> for the entire system. Please note that these are system wide counters for
> all devices in the system.
> 
> The following new dma-debug interface is added:
> 
> debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr):
> 	Sets dma map error checked status for the dma map entry if one is
> 	found. Decrements the system wide dma_map_errors_not_checked counter
> 	that is incremented by debug_dma_map_page() when it checks for
> 	mapping error before adding it to the dma debug entry table.
> 
> The following existing dma-debug APIs are changed to support this feature:
> 
> debug_dma_map_page():
> 	Increments dma_map_errors and dma_map_errors_not_checked error totals
> 	for the system when dma_addr is invalid. Please note that this routine
> 	can no longer call dma_mapping_error(), because of the newly added
> 	debug_dma_mapping_error() interface. Calling this routine at the time
> 	dma error unchecked state is registered, will not help if state gets
> 	changed right away.
> 
> check_unmap():
> 	This is an existing internal routine that checks for various mapping
> 	errors. Changed to increment system wide dma_unmap_errors, when a
> 	device requests an invalid address to be unmapped. Please note that
> 	this routine can no longer call dma_mapping_error(), because of the
> 	newly added debug_dma_mapping_error() interface. Calling
> 	dma_mapping_error() from this routine will change the dma map error
> 	flag erroneously.
> 
> Changed arch/x86/include/asm/dma-mapping.h to call debug_dma_mapping_error()
> to validate these new interfaces on x86_64. Other architectures will be
> changed in a subsequent patch.

Thanks for improving this patch. It is looking more and more ready for
the kernel. With that in mind, I've some comments below.

> 
> Tested: Intel iommu and swiotlb (iommu=soft) on x86-64 with
>         CONFIG_DMA_API_DEBUG enabled and disabled.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  Documentation/DMA-API.txt          |   13 +++++
>  arch/x86/include/asm/dma-mapping.h |    1 +
>  include/linux/dma-debug.h          |    7 +++
>  lib/dma-debug.c                    |   92 ++++++++++++++++++++++++++++++++++--
>  4 files changed, 109 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
> index 66bd97a..59d58b9 100644
> --- a/Documentation/DMA-API.txt
> +++ b/Documentation/DMA-API.txt
> @@ -638,6 +638,19 @@ this directory the following files can currently be found:
>  	dma-api/error_count	This file is read-only and shows the total
>  				numbers of errors found.
>  
> +	dma-api/dma_map_errors  This file is read-only and shows the total
> +				number of dma mapping errors detected.
> +
> +	dma-api/dma_map_errors_not_checked
> +				This file is read-only and shows the total
> +				number of dma mapping errors, device drivers
> +				failed to check prior to using the returned
> +				address.
> +
> +	dma-api/dma_unmap_errors
> +				This file is read-only and shows the total
> +				number of invalid dma unmapping attempts.
> +
>  	dma-api/num_errors	The number in this file shows how many
>  				warnings will be printed to the kernel log
>  				before it stops. This number is initialized to
> diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
> index f7b4c79..808dae6 100644
> --- a/arch/x86/include/asm/dma-mapping.h
> +++ b/arch/x86/include/asm/dma-mapping.h
> @@ -47,6 +47,7 @@ static inline struct dma_map_ops *get_dma_ops(struct device *dev)
>  static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
>  {
>  	struct dma_map_ops *ops = get_dma_ops(dev);
> +	debug_dma_mapping_error(dev, dma_addr);
>  	if (ops->mapping_error)
>  		return ops->mapping_error(dev, dma_addr);
>  
> diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
> index 171ad8a..fc0e34c 100644
> --- a/include/linux/dma-debug.h
> +++ b/include/linux/dma-debug.h
> @@ -39,6 +39,8 @@ extern void debug_dma_map_page(struct device *dev, struct page *page,
>  			       int direction, dma_addr_t dma_addr,
>  			       bool map_single);
>  
> +extern void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
> +
>  extern void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
>  				 size_t size, int direction, bool map_single);
>  
> @@ -105,6 +107,11 @@ static inline void debug_dma_map_page(struct device *dev, struct page *page,
>  {
>  }
>  
> +static inline void debug_dma_mapping_error(struct device *dev,
> +					  dma_addr_t dma_addr)
> +{
> +}
> +
>  static inline void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
>  					size_t size, int direction,
>  					bool map_single)
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 66ce414..70724a5 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -57,6 +57,7 @@ struct dma_debug_entry {
>  	int              direction;
>  	int		 sg_call_ents;
>  	int		 sg_mapped_ents;
> +	int		 dma_map_error_flag;

I don't think you need 'dma_map' as a prefix a this is in an
dma_debug structure. Perhaps 'map_error_cnt' ?

But looking at the implementation this is actually an enum?
Can you do this instead:

	enum map_err_type	map_err_type;
?

>  #ifdef CONFIG_STACKTRACE
>  	struct		 stack_trace stacktrace;
>  	unsigned long	 st_entries[DMA_DEBUG_STACKTRACE_ENTRIES];
> @@ -83,6 +84,11 @@ static u32 global_disable __read_mostly;
>  /* Global error count */
>  static u32 error_count;
>  
> +/* dma mapping error counts */
> +static u32 dma_map_errors;
> +static u32 dma_map_errors_not_checked;
> +static u32 dma_unmap_errors;

s/dma//

> +
>  /* Global error show enable*/
>  static u32 show_all_errors __read_mostly;
>  /* Number of errors to show */
> @@ -104,6 +110,9 @@ static struct dentry *show_num_errors_dent  __read_mostly;
>  static struct dentry *num_free_entries_dent __read_mostly;
>  static struct dentry *min_free_entries_dent __read_mostly;
>  static struct dentry *filter_dent           __read_mostly;
> +static struct dentry *dma_map_errors_dent   __read_mostly;
> +static struct dentry *dma_map_errors_not_checked_dent   __read_mostly;
> +static struct dentry *dma_unmap_errors_dent __read_mostly;

Ditto.

>  
>  /* per-driver filter related state */
>  
> @@ -120,6 +129,15 @@ static const char *type2name[4] = { "single", "page",
>  static const char *dir2name[4] = { "DMA_BIDIRECTIONAL", "DMA_TO_DEVICE",
>  				   "DMA_FROM_DEVICE", "DMA_NONE" };
>  
> +enum {
> +	dma_map_error_check_not_applicable,
> +	dma_map_error_not_checked,
> +	dma_map_error_checked,
> +};

s/dma//
s/error/err//

And perhaps make them uppercase?

Can you name the enum? Say 'map_err_types'


> +static const char *maperr2str[3] = { "dma map error check not applicable",
> +				     "dma map error not checked",
> +				     "dma map error checked" };
> +

Just do this:

static const char *const names[] = {
		[err_check_na] = {"check n/a"},
		[err_not_checked] = {"not checked"},
		.. snip..
		};

That way you don't have to worry about the size and can just
use ARRAY_SIZE(names) to check for valid enum size.

>  /* little merge helper - remove it after the merge window */
>  #ifndef BUS_NOTIFY_UNBOUND_DRIVER
>  #define BUS_NOTIFY_UNBOUND_DRIVER 0x0005
> @@ -381,11 +399,12 @@ void debug_dma_dump_mappings(struct device *dev)
>  		list_for_each_entry(entry, &bucket->list, list) {
>  			if (!dev || dev == entry->dev) {
>  				dev_info(entry->dev,
> -					 "%s idx %d P=%Lx D=%Lx L=%Lx %s\n",
> +					 "%s idx %d P=%Lx D=%Lx L=%Lx %s %s\n",
>  					 type2name[entry->type], idx,
>  					 (unsigned long long)entry->paddr,
>  					 entry->dev_addr, entry->size,
> -					 dir2name[entry->direction]);
> +					 dir2name[entry->direction],
> +					 maperr2str[entry->dma_map_error_flag]);
>  			}
>  		}
>  
> @@ -695,6 +714,28 @@ static int dma_debug_fs_init(void)
>  	if (!filter_dent)
>  		goto out_err;
>  
> +	dma_map_errors_dent = debugfs_create_u32("dma_map_errors", 0444,

Just call it 'map_errors'

> +			dma_debug_dent,
> +			&dma_map_errors);
> +
> +	if (!dma_map_errors_dent)
> +		goto out_err;
> +
> +	dma_map_errors_not_checked_dent = debugfs_create_u32(
> +			"dma_map_errors_not_checked",

Ditto. s/dma//
> +			0444,
> +			dma_debug_dent,
> +			&dma_map_errors_not_checked);
> +
> +	if (!dma_map_errors_not_checked_dent)
> +		goto out_err;
> +
> +	dma_unmap_errors_dent = debugfs_create_u32("dma_unmap_errors", 0444,

s/dma//
> +			dma_debug_dent,
> +			&dma_unmap_errors);
> +	if (!dma_unmap_errors_dent)
> +		goto out_err;
> +

This whole function could use a a loop to set this up instead of doing
one by one... But that is another patch that can be done later.

>  	return 0;
>  
>  out_err:
> @@ -849,7 +890,8 @@ static void check_unmap(struct dma_debug_entry *ref)
>  	struct hash_bucket *bucket;
>  	unsigned long flags;
>  
> -	if (dma_mapping_error(ref->dev, ref->dev_addr)) {
> +	if (ref->dev_addr == DMA_ERROR_CODE) {

The DMA_ERROR_CODE is not exported on every architecture. Worst yet,
it is not used universally on all IOMMUs - if you look in the GART
(gart_mapping_error) it does not check for the DMA_ERROR_CODE but for
its own bad_dma_addr address. I think using the dma_mapping_errors here
is still a good idea.

> +		dma_unmap_errors += 1;
>  		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
>  			   "to free an invalid DMA memory address\n");
>  		return;
> @@ -915,6 +957,15 @@ static void check_unmap(struct dma_debug_entry *ref)
>  			   dir2name[ref->direction]);
>  	}
>  
> +	if (entry->dma_map_error_flag == dma_map_error_not_checked) {

Wait. Aren't you using dma_map_error_flag to only be up to 3 - as you
are using it to lookup in the string table for its proper name?

Perhaps the string table lookup should use a different flag??

> +		err_printk(ref->dev, entry,
> +			   "DMA-API: device driver failed to check map error"
> +			   "[device address=0x%016llx] [size=%llu bytes] "
> +			   "[mapped as %s]",
> +			   ref->dev_addr, ref->size,
> +			   type2name[entry->type]);
> +	}
> +
>  	hash_bucket_del(entry);
>  	dma_entry_free(entry);
>  
> @@ -1022,8 +1073,11 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
>  	if (unlikely(global_disable))
>  		return;
>  
> -	if (unlikely(dma_mapping_error(dev, dma_addr)))
> +	if (dma_addr == DMA_ERROR_CODE) {

Ditto
> +		dma_map_errors += 1;
> +		dma_map_errors_not_checked += 1;
>  		return;
> +	}
>  
>  	entry = dma_entry_alloc();
>  	if (!entry)
> @@ -1035,6 +1089,7 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
>  	entry->dev_addr  = dma_addr;
>  	entry->size      = size;
>  	entry->direction = direction;
> +	entry->dma_map_error_flag = dma_map_error_not_checked;

So if it is greater than three, then maperr2str[entry->dma_map_error_flag] is going
to blow up, right?

>  
>  	if (map_single)
>  		entry->type = dma_debug_single;
> @@ -1050,6 +1105,35 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
>  }
>  EXPORT_SYMBOL(debug_dma_map_page);
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
> +	if (dma_addr == DMA_ERROR_CODE) {

Don't use that... Just the IOMMUs' dma_mapping_error call..

> +		dma_map_errors_not_checked -= 1;

Should you check in case the user calls dma_mapping_error more than once on
the same dma_addr?

> +		return;
> +	}
> +
> +	ref.dev = dev;
> +	ref.dev_addr = dma_addr;
> +	bucket = get_hash_bucket(&ref, &flags);
> +	entry = bucket_find_exact(bucket, &ref);
> +
> +	if (!entry) /* very likley dma-api didn't call debug_dma_map_page() */

Ok, so should we re-adjust dma_map_errors_not_checked? Or we
don't care?

> +		goto out;
> +
> +	entry->dma_map_error_flag = dma_map_error_checked;
> +out:
> +	put_hash_bucket(bucket, &flags);
> +}
> +EXPORT_SYMBOL(debug_dma_mapping_error);
> +
>  void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
>  			  size_t size, int direction, bool map_single)
>  {
> -- 
> 1.7.9.5
> 
> 
> 
