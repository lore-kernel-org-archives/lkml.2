Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab2JRLon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:44:43 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:23781 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab2JRLom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:44:42 -0400
X-IronPort-AV: E=Sophos;i="4.80,606,1344211200"; 
   d="scan'208";a="15252812"
Date: Thu, 18 Oct 2012 12:44:16 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 5/6]: PVH:balloon and grant changes
In-Reply-To: <20121017173327.6994152e@mantra.us.oracle.com>
Message-ID: <alpine.DEB.2.02.1210181244070.2689@kaball.uk.xensource.com>
References: <20121017173327.6994152e@mantra.us.oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Mukesh Rathor wrote:
> PVH: balloon and grant changes. For balloon changes we skip setting of local p2m as it's updated in xen. For grant, the shared grant frame is the pfn and not mfn, hence its mapped via the same code path as HVM
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>

this patch looks good


>  drivers/xen/balloon.c     |   15 +++++++++------
>  drivers/xen/gntdev.c      |    3 ++-
>  drivers/xen/grant-table.c |   26 ++++++++++++++++++++++----
>  3 files changed, 33 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index 31ab82f..c825b63 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -361,7 +361,9 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
>  		set_phys_to_machine(pfn, frame_list[i]);
>  
>  		/* Link back into the page tables if not highmem. */
> -		if (xen_pv_domain() && !PageHighMem(page)) {
> +		if (xen_pv_domain() && !PageHighMem(page) &&
> +		    !xen_feature(XENFEAT_auto_translated_physmap)) {
> +
>  			int ret;
>  			ret = HYPERVISOR_update_va_mapping(
>  				(unsigned long)__va(pfn << PAGE_SHIFT),
> @@ -418,12 +420,13 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>  		scrub_page(page);
>  
>  		if (xen_pv_domain() && !PageHighMem(page)) {
> -			ret = HYPERVISOR_update_va_mapping(
> -				(unsigned long)__va(pfn << PAGE_SHIFT),
> -				__pte_ma(0), 0);
> -			BUG_ON(ret);
> +			if (!xen_feature(XENFEAT_auto_translated_physmap)) {
> +				ret = HYPERVISOR_update_va_mapping(
> +					(unsigned long)__va(pfn << PAGE_SHIFT),
> +					__pte_ma(0), 0);
> +				BUG_ON(ret);
> +			}
>  		}
> -
>  	}
>  
>  	/* Ensure that ballooned highmem pages don't have kmaps. */
> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> index 5df9fd8..36ec380 100644
> --- a/drivers/xen/gntdev.c
> +++ b/drivers/xen/gntdev.c
> @@ -803,7 +803,8 @@ static int __init gntdev_init(void)
>  	if (!xen_domain())
>  		return -ENODEV;
>  
> -	use_ptemod = xen_pv_domain();
> +	use_ptemod = xen_pv_domain() &&
> +		     !xen_feature(XENFEAT_auto_translated_physmap);
>  
>  	err = misc_register(&gntdev_miscdev);
>  	if (err != 0) {
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index f37faf6..1b851fa 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -976,14 +976,19 @@ static void gnttab_unmap_frames_v2(void)
>  static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
>  {
>  	struct gnttab_setup_table setup;
> -	unsigned long *frames;
> +	unsigned long *frames, start_gpfn;
>  	unsigned int nr_gframes = end_idx + 1;
>  	int rc;
>  
> -	if (xen_hvm_domain()) {
> +	if (xen_hvm_domain() || xen_feature(XENFEAT_auto_translated_physmap)) {
>  		struct xen_add_to_physmap xatp;
>  		unsigned int i = end_idx;
>  		rc = 0;
> +
> +		if (xen_hvm_domain())
> +			start_gpfn = xen_hvm_resume_frames >> PAGE_SHIFT;
> +		else
> +			start_gpfn = virt_to_pfn(gnttab_shared.addr);
>  		/*
>  		 * Loop backwards, so that the first hypercall has the largest
>  		 * index, ensuring that the table will grow only once.
> @@ -992,7 +997,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
>  			xatp.domid = DOMID_SELF;
>  			xatp.idx = i;
>  			xatp.space = XENMAPSPACE_grant_table;
> -			xatp.gpfn = (xen_hvm_resume_frames >> PAGE_SHIFT) + i;
> +			xatp.gpfn = start_gpfn + i;
>  			rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
>  			if (rc != 0) {
>  				printk(KERN_WARNING
> @@ -1055,7 +1060,7 @@ static void gnttab_request_version(void)
>  	int rc;
>  	struct gnttab_set_version gsv;
>  
> -	if (xen_hvm_domain())
> +	if (xen_hvm_domain() || xen_feature(XENFEAT_auto_translated_physmap))
>  		gsv.version = 1;
>  	else
>  		gsv.version = 2;
> @@ -1083,12 +1088,25 @@ static void gnttab_request_version(void)
>  int gnttab_resume(void)
>  {
>  	unsigned int max_nr_gframes;
> +	char *kmsg = "Failed to kmalloc pages for pv in hvm grant frames\n";
>  
>  	gnttab_request_version();
>  	max_nr_gframes = gnttab_max_grant_frames();
>  	if (max_nr_gframes < nr_grant_frames)
>  		return -ENOSYS;
>  
> +	/* PVH note: xen will free existing kmalloc'd mfn in
> +	 * XENMEM_add_to_physmap. TBD/FIXME: use xen ballooning instead of
> +	 * kmalloc(). */
> +	if (xen_pv_domain() && xen_feature(XENFEAT_auto_translated_physmap) &&
> +	    !gnttab_shared.addr) {
> +		gnttab_shared.addr =
> +			kmalloc(max_nr_gframes * PAGE_SIZE, GFP_KERNEL);
> +		if (!gnttab_shared.addr) {
> +			pr_warn("%s", kmsg);
> +			return -ENOMEM;
> +		}
> +	}
>  	if (xen_pv_domain())
>  		return gnttab_map(0, nr_grant_frames - 1);
>  
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
