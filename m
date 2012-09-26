Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab2IZQXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:23:38 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:9972 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781Ab2IZQXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:23:37 -0400
Message-ID: <1348676613.4020.13.camel@lorien2>
Subject: Re: [PATCH v2] dma-debug: New interfaces to debug dma mapping errors
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: joerg.roedel@amd.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rob@landley.net, akpm@linux-foundation.org, bhelgaas@google.com,
        stern@rowland.harvard.edu, LKML <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, devel@linuxdriverproject.org,
        x86@kernel.org, shuahkhan@gmail.com
Date: Wed, 26 Sep 2012 10:23:33 -0600
In-Reply-To: <20120926131210.GA9309@phenom.dumpdata.com>
References: <1347843171.4370.13.camel@lorien2>
	 <1348621517.3091.6.camel@lorien2>
	 <20120926131210.GA9309@phenom.dumpdata.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 09:12 -0400, Konrad Rzeszutek Wilk wrote:
> >
> 
> Thanks for improving this patch. It is looking more and more ready for
> the kernel. With that in mind, I've some comments below.

Good. Thanks for the comments and good suggestions. Will work on v3.
> 
> > 
> > 
> > --- a/lib/dma-debug.c
> > +++ b/lib/dma-debug.c
> > @@ -57,6 +57,7 @@ struct dma_debug_entry {
> >  	int              direction;
> >  	int		 sg_call_ents;
> >  	int		 sg_mapped_ents;
> > +	int		 dma_map_error_flag;
> 
> I don't think you need 'dma_map' as a prefix a this is in an
> dma_debug structure. Perhaps 'map_error_cnt' ?

I can drop dma prefix from all the counts I added.
> 
> But looking at the implementation this is actually an enum?
> Can you do this instead:
> 
> 	enum map_err_type	map_err_type;

Correct. It can be a enum type.

> ?
> 
> >  #ifdef CONFIG_STACKTRACE
> >  	struct		 stack_trace stacktrace;
> >  	unsigned long	 st_entries[DMA_DEBUG_STACKTRACE_ENTRIES];
> > @@ -83,6 +84,11 @@ static u32 global_disable __read_mostly;
> >  /* Global error count */
> >  static u32 error_count;
> >  
> > +/* dma mapping error counts */
> > +static u32 dma_map_errors;
> > +static u32 dma_map_errors_not_checked;
> > +static u32 dma_unmap_errors;
> 
> s/dma//

Will drop dma prefix here.

> 
> > +
> >  /* Global error show enable*/
> >  static u32 show_all_errors __read_mostly;
> >  /* Number of errors to show */
> > @@ -104,6 +110,9 @@ static struct dentry *show_num_errors_dent  __read_mostly;
> >  static struct dentry *num_free_entries_dent __read_mostly;
> >  static struct dentry *min_free_entries_dent __read_mostly;
> >  static struct dentry *filter_dent           __read_mostly;
> > +static struct dentry *dma_map_errors_dent   __read_mostly;
> > +static struct dentry *dma_map_errors_not_checked_dent   __read_mostly;
> > +static struct dentry *dma_unmap_errors_dent __read_mostly;
> 
> Ditto.
ok
> 
> >  
> >  /* per-driver filter related state */
> >  
> > @@ -120,6 +129,15 @@ static const char *type2name[4] = { "single", "page",
> >  static const char *dir2name[4] = { "DMA_BIDIRECTIONAL", "DMA_TO_DEVICE",
> >  				   "DMA_FROM_DEVICE", "DMA_NONE" };
> >  
> > +enum {
> > +	dma_map_error_check_not_applicable,
> > +	dma_map_error_not_checked,
> > +	dma_map_error_checked,
> > +};
> 
> s/dma//
> s/error/err//
> 
> And perhaps make them uppercase?
Yup. Uppercase will be in line with the general enum convention.
> 
> Can you name the enum? Say 'map_err_types'
> 
> 
> > +static const char *maperr2str[3] = { "dma map error check not applicable",
> > +				     "dma map error not checked",
> > +				     "dma map error checked" };
> > +
> 
> Just do this:
> 
> static const char *const names[] = {
> 		[err_check_na] = {"check n/a"},
> 		[err_not_checked] = {"not checked"},
> 		.. snip..
> 		};
> 

yes. Will work better than the current.

> That way you don't have to worry about the size and can just
> use ARRAY_SIZE(names) to check for valid enum size.
> 
> >  /* little merge helper - remove it after the merge window */
> >  #ifndef BUS_NOTIFY_UNBOUND_DRIVER
> >  #define BUS_NOTIFY_UNBOUND_DRIVER 0x0005
> > @@ -381,11 +399,12 @@ void debug_dma_dump_mappings(struct device *dev)
> >  		list_for_each_entry(entry, &bucket->list, list) {
> >  			if (!dev || dev == entry->dev) {
> >  				dev_info(entry->dev,
> > -					 "%s idx %d P=%Lx D=%Lx L=%Lx %s\n",
> > +					 "%s idx %d P=%Lx D=%Lx L=%Lx %s %s\n",
> >  					 type2name[entry->type], idx,
> >  					 (unsigned long long)entry->paddr,
> >  					 entry->dev_addr, entry->size,
> > -					 dir2name[entry->direction]);
> > +					 dir2name[entry->direction],
> > +					 maperr2str[entry->dma_map_error_flag]);
> >  			}
> >  		}
> >  
> > @@ -695,6 +714,28 @@ static int dma_debug_fs_init(void)
> >  	if (!filter_dent)
> >  		goto out_err;
> >  
> > +	dma_map_errors_dent = debugfs_create_u32("dma_map_errors", 0444,
> 
> Just call it 'map_errors'
> 
> > +			dma_debug_dent,
> > +			&dma_map_errors);
> > +
> > +	if (!dma_map_errors_dent)
> > +		goto out_err;
> > +
> > +	dma_map_errors_not_checked_dent = debugfs_create_u32(
> > +			"dma_map_errors_not_checked",
> 
> Ditto. s/dma//
> > +			0444,
> > +			dma_debug_dent,
> > +			&dma_map_errors_not_checked);
> > +
> > +	if (!dma_map_errors_not_checked_dent)
> > +		goto out_err;
> > +
> > +	dma_unmap_errors_dent = debugfs_create_u32("dma_unmap_errors", 0444,
> 
> s/dma//
> > +			dma_debug_dent,
> > +			&dma_unmap_errors);
> > +	if (!dma_unmap_errors_dent)
> > +		goto out_err;
> > +
> 
> This whole function could use a a loop to set this up instead of doing
> one by one... But that is another patch that can be done later.

Yes.
> 
> >  	return 0;
> >  
> >  out_err:
> > @@ -849,7 +890,8 @@ static void check_unmap(struct dma_debug_entry *ref)
> >  	struct hash_bucket *bucket;
> >  	unsigned long flags;
> >  
> > -	if (dma_mapping_error(ref->dev, ref->dev_addr)) {
> > +	if (ref->dev_addr == DMA_ERROR_CODE) {
> 
> The DMA_ERROR_CODE is not exported on every architecture. Worst yet,
> it is not used universally on all IOMMUs - if you look in the GART
> (gart_mapping_error) it does not check for the DMA_ERROR_CODE but for
> its own bad_dma_addr address. I think using the dma_mapping_errors here
> is still a good idea.

Good point.
> 
> > +		dma_unmap_errors += 1;
> >  		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
> >  			   "to free an invalid DMA memory address\n");
> >  		return;
> > @@ -915,6 +957,15 @@ static void check_unmap(struct dma_debug_entry *ref)
> >  			   dir2name[ref->direction]);
> >  	}
> >  
> > +	if (entry->dma_map_error_flag == dma_map_error_not_checked) {
> 
> Wait. Aren't you using dma_map_error_flag to only be up to 3 - as you
> are using it to lookup in the string table for its proper name?
> 
> Perhaps the string table lookup should use a different flag??
> 
> > +		err_printk(ref->dev, entry,
> > +			   "DMA-API: device driver failed to check map error"
> > +			   "[device address=0x%016llx] [size=%llu bytes] "
> > +			   "[mapped as %s]",
> > +			   ref->dev_addr, ref->size,
> > +			   type2name[entry->type]);
> > +	}
> > +
> >  	hash_bucket_del(entry);
> >  	dma_entry_free(entry);
> >  
> > @@ -1022,8 +1073,11 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
> >  	if (unlikely(global_disable))
> >  		return;
> >  
> > -	if (unlikely(dma_mapping_error(dev, dma_addr)))
> > +	if (dma_addr == DMA_ERROR_CODE) {
> 
> Ditto
> > +		dma_map_errors += 1;
> > +		dma_map_errors_not_checked += 1;
> >  		return;
> > +	}
> >  
> >  	entry = dma_entry_alloc();
> >  	if (!entry)
> > @@ -1035,6 +1089,7 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
> >  	entry->dev_addr  = dma_addr;
> >  	entry->size      = size;
> >  	entry->direction = direction;
> > +	entry->dma_map_error_flag = dma_map_error_not_checked;
> 
> So if it is greater than three, then maperr2str[entry->dma_map_error_flag] is going
> to blow up, right?
Yeah. It shouldn't, but would  be good to check.
> 
> >  
> >  	if (map_single)
> >  		entry->type = dma_debug_single;
> > @@ -1050,6 +1105,35 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
> >  }
> >  EXPORT_SYMBOL(debug_dma_map_page);
> >  
> > +void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
> > +{
> > +	struct dma_debug_entry ref;
> > +	struct dma_debug_entry *entry;
> > +	struct hash_bucket *bucket;
> > +	unsigned long flags;
> > +
> > +	if (unlikely(global_disable))
> > +		return;
> > +
> > +	if (dma_addr == DMA_ERROR_CODE) {
> 
> Don't use that... Just the IOMMUs' dma_mapping_error call..
> 
> > +		dma_map_errors_not_checked -= 1;
> 
> Should you check in case the user calls dma_mapping_error more than once on
> the same dma_addr?

Correct. Check is needed especially coupled with dma-debug internal use
of dma_mapping_error().

> 
> > +		return;
> > +	}
> > +
> > +	ref.dev = dev;
> > +	ref.dev_addr = dma_addr;
> > +	bucket = get_hash_bucket(&ref, &flags);
> > +	entry = bucket_find_exact(bucket, &ref);
> > +
> > +	if (!entry) /* very likley dma-api didn't call debug_dma_map_page() */
> 
> Ok, so should we re-adjust dma_map_errors_not_checked? Or we
> don't care?
> 
> > +		goto out;
> > +
> > +	entry->dma_map_error_flag = dma_map_error_checked;
> > +out:
> > +	put_hash_bucket(bucket, &flags);
> > +}
> > +EXPORT_SYMBOL(debug_dma_mapping_error);
> > +
> >  void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
> >  			  size_t size, int direction, bool map_single)
> >  {
> > -- 
> > 1.7.9.5
> > 
> > 
> > 


