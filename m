Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab2JIRYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:24:43 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46797 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347Ab2JIRYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:24:40 -0400
Date: Tue, 9 Oct 2012 13:12:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Shuah Khan <shuah.khan@hp.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rob@landley.net,
        akpm@linux-foundation.org, stern@rowland.harvard.edu,
        joerg.roedel@amd.com, bhelgaas@google.com,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        devel@linuxdriverproject.org, x86@kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH v5] dma-debug: New interfaces to debug dma mapping errors
Message-ID: <20121009171220.GJ31499@phenom.dumpdata.com>
References: <1349716086.2674.20.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349716086.2674.20.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 11:08:06AM -0600, Shuah Khan wrote:
> Add dma-debug interface debug_dma_mapping_error() to debug drivers that fail
> to check dma mapping errors on addresses returned by dma_map_single() and
> dma_map_page() interfaces. This interface clears a flag set by
> debug_dma_map_page() to indicate that dma_mapping_error() has been called by
> the driver. When driver does unmap, debug_dma_unmap() checks the flag and if
> this flag is still set, prints warning message that includes call trace that
> leads up to the unmap. This interface can be called from dma_mapping_error()
> routines to enable dma mapping error check debugging.
> 
> Tested: Intel iommu and swiotlb (iommu=soft) on x86-64 with
>         CONFIG_DMA_API_DEBUG enabled and disabled.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>

Not sure why it disappeared, but:

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  Documentation/DMA-API.txt          |   12 ++++++
>  arch/x86/include/asm/dma-mapping.h |    1 +
>  include/linux/dma-debug.h          |    7 ++++
>  lib/dma-debug.c                    |   71 ++++++++++++++++++++++++++++++++++--
>  4 files changed, 87 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
> index 66bd97a..78a6c56 100644
> --- a/Documentation/DMA-API.txt
> +++ b/Documentation/DMA-API.txt
> @@ -678,3 +678,15 @@ out of dma_debug_entries. These entries are preallocated at boot. The number
>  of preallocated entries is defined per architecture. If it is too low for you
>  boot with 'dma_debug_entries=<your_desired_number>' to overwrite the
>  architectural default.
> +
> +void debug_dmap_mapping_error(struct device *dev, dma_addr_t dma_addr);
> +
> +dma-debug interface debug_dma_mapping_error() to debug drivers that fail
> +to check dma mapping errors on addresses returned by dma_map_single() and
> +dma_map_page() interfaces. This interface clears a flag set by
> +debug_dma_map_page() to indicate that dma_mapping_error() has been called by
> +the driver. When driver does unmap, debug_dma_unmap() checks the flag and if
> +this flag is still set, prints warning message that includes call trace that
> +leads up to the unmap. This interface can be called from dma_mapping_error()
> +routines to enable dma mapping error check debugging.
> +
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
> index b9087bf..94aa94e 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -45,6 +45,12 @@ enum {
>  	dma_debug_coherent,
>  };
>  
> +enum map_err_types {
> +	MAP_ERR_CHECK_NOT_APPLICABLE,
> +	MAP_ERR_NOT_CHECKED,
> +	MAP_ERR_CHECKED,
> +};
> +
>  #define DMA_DEBUG_STACKTRACE_ENTRIES 5
>  
>  struct dma_debug_entry {
> @@ -57,6 +63,7 @@ struct dma_debug_entry {
>  	int              direction;
>  	int		 sg_call_ents;
>  	int		 sg_mapped_ents;
> +	enum map_err_types  map_err_type;
>  #ifdef CONFIG_STACKTRACE
>  	struct		 stack_trace stacktrace;
>  	unsigned long	 st_entries[DMA_DEBUG_STACKTRACE_ENTRIES];
> @@ -114,6 +121,12 @@ static struct device_driver *current_driver                    __read_mostly;
>  
>  static DEFINE_RWLOCK(driver_name_lock);
>  
> +static const char *const maperr2str[] = {
> +	[MAP_ERR_CHECK_NOT_APPLICABLE] = "dma map error check not applicable",
> +	[MAP_ERR_NOT_CHECKED] = "dma map error not checked",
> +	[MAP_ERR_CHECKED] = "dma map error checked",
> +};
> +
>  static const char *type2name[4] = { "single", "page",
>  				    "scather-gather", "coherent" };
>  
> @@ -376,11 +389,12 @@ void debug_dma_dump_mappings(struct device *dev)
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
> +					 maperr2str[entry->map_err_type]);
>  			}
>  		}
>  
> @@ -838,13 +852,28 @@ static __init int dma_debug_entries_cmdline(char *str)
>  __setup("dma_debug=", dma_debug_cmdline);
>  __setup("dma_debug_entries=", dma_debug_entries_cmdline);
>  
> +/* Calling dma_mapping_error() from dma-debug api will result in calling
> +   debug_dma_mapping_error() - need internal mapping error routine to
> +   avoid debug checks */
> +#ifndef DMA_ERROR_CODE
> +#define DMA_ERROR_CODE 0
> +#endif
> +static inline int has_mapping_error(struct device *dev, dma_addr_t dma_addr)
> +{
> +	const struct dma_map_ops *ops = get_dma_ops(dev);
> +	if (ops->mapping_error)
> +		return ops->mapping_error(dev, dma_addr);
> +
> +	return (dma_addr == DMA_ERROR_CODE);
> +}
> +
>  static void check_unmap(struct dma_debug_entry *ref)
>  {
>  	struct dma_debug_entry *entry;
>  	struct hash_bucket *bucket;
>  	unsigned long flags;
>  
> -	if (dma_mapping_error(ref->dev, ref->dev_addr)) {
> +	if (unlikely(has_mapping_error(ref->dev, ref->dev_addr))) {
>  		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
>  			   "to free an invalid DMA memory address\n");
>  		return;
> @@ -910,6 +939,15 @@ static void check_unmap(struct dma_debug_entry *ref)
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
> +
>  	hash_bucket_del(entry);
>  	dma_entry_free(entry);
>  
> @@ -1017,7 +1055,7 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
>  	if (unlikely(global_disable))
>  		return;
>  
> -	if (unlikely(dma_mapping_error(dev, dma_addr)))
> +	if (unlikely(has_mapping_error(dev, dma_addr)))
>  		return;
>  
>  	entry = dma_entry_alloc();
> @@ -1030,6 +1068,7 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
>  	entry->dev_addr  = dma_addr;
>  	entry->size      = size;
>  	entry->direction = direction;
> +	entry->map_err_type = MAP_ERR_NOT_CHECKED;
>  
>  	if (map_single)
>  		entry->type = dma_debug_single;
> @@ -1045,6 +1084,30 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
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
> +	ref.dev = dev;
> +	ref.dev_addr = dma_addr;
> +	bucket = get_hash_bucket(&ref, &flags);
> +	entry = bucket_find_exact(bucket, &ref);
> +
> +	if (!entry)
> +		goto out;
> +
> +	entry->map_err_type = MAP_ERR_CHECKED;
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
