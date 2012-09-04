Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827Ab2IDVQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:16:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48110 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678Ab2IDVQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:16:46 -0400
Date: Tue, 4 Sep 2012 17:05:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Shuah Khan <shuah.khan@hp.com>
Cc: joerg.roedel@amd.com, paul.gortmaker@windriver.com, kubakici@wp.pl,
        stern@rowland.harvard.edu, dan.carpenter@oracle.com, rob@landley.net,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Subject: Re: [PATCH] dma-debug: Add dma map/unmap error tracking support
Message-ID: <20120904210555.GG3155@phenom.dumpdata.com>
References: <1346595257.4377.5.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346595257.4377.5.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2012 at 08:14:17AM -0600, Shuah Khan wrote:
> A recent dma mapping error analysis effort showed that a large precentage
> of dma_map_single() and dma_map_page() returns are not checked for mapping
> errors. Reference: https://lkml.org/lkml/2012/8/10/326
> 

So were you able to catch some naughty drivers with this?

> Adding support for tracking dma mapping and unmapping errors to help assess
> the following:
> 
> When do dma mapping errors get detected?
> How often do these errors occur?
> Why don't we see failures related to missing dma mapping error checks?
> Are they silent failures?
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  Documentation/DMA-API.txt |    7 +++++++
>  lib/dma-debug.c           |   26 +++++++++++++++++++++++++-
>  2 files changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
> index 66bd97a..ee10a11 100644
> --- a/Documentation/DMA-API.txt
> +++ b/Documentation/DMA-API.txt
> @@ -638,6 +638,13 @@ this directory the following files can currently be found:
>  	dma-api/error_count	This file is read-only and shows the total
>  				numbers of errors found.
>  
> +	dma-api/dma_map_errors  This file is read-only and shows the total
> +				number of dma mapping errors detected.
> +
> +	dma-api/dma_unmap_errors
> +				This file is read-only and shows the total
> +				number of invalid dma unmapping attempts.
> +
>  	dma-api/num_errors	The number in this file shows how many
>  				warnings will be printed to the kernel log
>  				before it stops. This number is initialized to
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 66ce414..8596114 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -83,6 +83,10 @@ static u32 global_disable __read_mostly;
>  /* Global error count */
>  static u32 error_count;
>  
> +/* dma mapping error counts */
> +static u32 dma_map_errors;
> +static u32 dma_unmap_errors;
> +
>  /* Global error show enable*/
>  static u32 show_all_errors __read_mostly;
>  /* Number of errors to show */
> @@ -104,6 +108,8 @@ static struct dentry *show_num_errors_dent  __read_mostly;
>  static struct dentry *num_free_entries_dent __read_mostly;
>  static struct dentry *min_free_entries_dent __read_mostly;
>  static struct dentry *filter_dent           __read_mostly;
> +static struct dentry *dma_map_errors_dent   __read_mostly;
> +static struct dentry *dma_unmap_errors_dent __read_mostly;
>  
>  /* per-driver filter related state */
>  
> @@ -695,6 +701,19 @@ static int dma_debug_fs_init(void)
>  	if (!filter_dent)
>  		goto out_err;
>  
> +	dma_map_errors_dent = debugfs_create_u32("dma_map_errors", 0444,
> +			dma_debug_dent,
> +			&dma_map_errors);
> +
> +	if (!dma_map_errors_dent)
> +		goto out_err;
> +
> +	dma_unmap_errors_dent = debugfs_create_u32("dma_unmap_errors", 0444,
> +			dma_debug_dent,
> +			&dma_unmap_errors);
> +	if (!dma_unmap_errors_dent)
> +		goto out_err;
> +
>  	return 0;
>  
>  out_err:
> @@ -850,6 +869,7 @@ static void check_unmap(struct dma_debug_entry *ref)
>  	unsigned long flags;
>  
>  	if (dma_mapping_error(ref->dev, ref->dev_addr)) {
> +		dma_unmap_errors += 1;
>  		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
>  			   "to free an invalid DMA memory address\n");
>  		return;
> @@ -1022,8 +1042,12 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
>  	if (unlikely(global_disable))
>  		return;
>  
> -	if (unlikely(dma_mapping_error(dev, dma_addr)))
> +	if (unlikely(dma_mapping_error(dev, dma_addr))) {
> +		dma_map_errors += 1;
> +		err_printk(dev, NULL,
> +			   "DMA-API: dma_map_page() returned error\n");
>  		return;
> +	}

So this will print if the dma_map_page failed (which can happen).

I was initially thinking that this patch would contain a state for the driver
of whether after map it has called dma_mapping_error. So this function would
increment some internal state, and if dma_mapping_error on that specific dma_addr
it would decrement it. If it never occured, then we would print on the unmap
that the device never had called dma_mapping_error on said dma_addr?

>  
>  	entry = dma_entry_alloc();
>  	if (!entry)
> -- 
> 1.7.9.5
> 
> 
