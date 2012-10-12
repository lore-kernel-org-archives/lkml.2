Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381Ab2JLJHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:07:01 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:41038 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab2JLJHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:07:00 -0400
X-IronPort-AV: E=Sophos;i="4.80,576,1344211200"; 
   d="scan'208";a="15121246"
Message-ID: <1350032817.14806.58.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH V2 6/7]: PVH: balloon and grant changes
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 12 Oct 2012 10:06:57 +0100
In-Reply-To: <20121011150113.4d525407@mantra.us.oracle.com>
References: <20121011150113.4d525407@mantra.us.oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 23:01 +0100, Mukesh Rathor wrote:
> PVH: balloon and grant changes. For balloon changes we skip setting of
> local p2m as it's updated in xen. For grant, the shared grant frame is
> the pfn and not mfn, hence its mapped via the same code path as HVM
> 
> Signed-off-by: Mukesh R <mukesh.rathor@oracle.com>
> ---
>  drivers/xen/balloon.c     |   18 +++++++++++-------
>  drivers/xen/gntdev.c      |    3 ++-
>  drivers/xen/grant-table.c |   25 +++++++++++++++++++++----
>  3 files changed, 34 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index 31ab82f..9b895ad 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -358,10 +358,13 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
>  		BUG_ON(!xen_feature(XENFEAT_auto_translated_physmap) &&
>  		       phys_to_machine_mapping_valid(pfn));
>  
> -		set_phys_to_machine(pfn, frame_list[i]);
> +		if (!xen_feature(XENFEAT_auto_translated_physmap))
> +			set_phys_to_machine(pfn, frame_list[i]);

set_phys_to_machine is a NOP if XENFEAT_auto_translated_physmap but it
includes some useful sanity checks (BUG_ON(pfn != mfn && mfn !=
INVALID_P2M_ENTRY)) so it would be useful to keep calling it I think.

>  
>  		/* Link back into the page tables if not highmem. */
> -		if (xen_pv_domain() && !PageHighMem(page)) {
> +		if (xen_pv_domain() && !PageHighMem(page) &&
> +		    !xen_feature(XENFEAT_auto_translated_physmap)) {
> +
>  			int ret;
>  			ret = HYPERVISOR_update_va_mapping(
>  				(unsigned long)__va(pfn << PAGE_SHIFT),
> @@ -418,12 +421,13 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>  		scrub_page(page);
>  
>  		if (xen_pv_domain() && !PageHighMem(page)) {
> -			ret = HYPERVISOR_update_va_mapping(
> -				(unsigned long)__va(pfn << PAGE_SHIFT),
> -				__pte_ma(0), 0);
> -			BUG_ON(ret);
> +			if (!xen_feature(XENFEAT_auto_translated_physmap)) {

You can combine this two ifs into one (like you did above).

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
> @@ -1055,7 +1060,7 @@ static void gnttab_request_version(void)
>  	int rc;
>  	struct gnttab_set_version gsv;
>  
> -	if (xen_hvm_domain())
> +	if (xen_hvm_domain() || xen_feature(XENFEAT_auto_translated_physmap))

This is just a case of not yet implemented rather than a fundamental
problem with v2 grant tables, correct? (i.e. future work)

>  		gsv.version = 1;
>  	else
>  		gsv.version = 2;
> @@ -1083,12 +1088,24 @@ static void gnttab_request_version(void)
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
> +	 * XENMEM_add_to_physmap */

It doesn't leak it?

We should consider using xenballoon_alloc_pages here.

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


