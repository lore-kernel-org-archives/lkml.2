Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab2LJNRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:17:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab2LJNRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:17:22 -0500
Date: Mon, 10 Dec 2012 08:17:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Add the values related to buddy system for filtering
 free pages.
Message-ID: <20121210131705.GC26447@redhat.com>
References: <20121210103913.020858db777e2f48c59713b6@mxc.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210103913.020858db777e2f48c59713b6@mxc.nes.nec.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 10:39:13AM +0900, Atsushi Kumagai wrote:
> This patch adds the values related to buddy system to vmcoreinfo data
> so that makedumpfile (dump filtering command) can filter out all free
> pages with the new logic.
> It's faster than the current logic because it can distinguish free page
> by analyzing page structure at the same time as filtering for other
> unnecessary pages (e.g. anonymous page).
> OTOH, the current logic has to trace free_list to distinguish free 
> pages while analyzing page structure to filter out other unnecessary
> pages.
> 
> The new logic uses the fact that buddy page is marked by _mapcount == 
> PAGE_BUDDY_MAPCOUNT_VALUE. But, _mapcount shares its memory with other
> fields for SLAB/SLUB when PG_slab is set, so we need to check if PG_slab
> is set or not before looking up _mapcount value.
> And we can get the order of buddy system from private field.
> To sum it up, the values below are required for this logic.
> 
> Required values:
>   - OFFSET(page._mapcount)
>   - OFFSET(page.private)
>   - NUMBER(PG_slab)
>   - NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE)
> 
> Changelog from v1 to v2:
> 1. remove SIZE(pageflags)
>   The new logic was changed after I sent v1 patch.  
>   Accordingly, SIZE(pageflags) has been unnecessary for makedumpfile.
> 
> What's makedumpfile:
>   makedumpfile creates a small dumpfile by excluding unnecessary pages
>   for the analysis. To distinguish unnecessary pages, makedumpfile gets
>   the vmcoreinfo data which has the minimum debugging information only
>   for dump filtering.
> 
> Signed-off-by: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

> ---
>  kernel/kexec.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 5e4bd78..b27efe4 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1490,6 +1490,8 @@ static int __init crash_save_vmcoreinfo_init(void)
> 	VMCOREINFO_OFFSET(page, _count);
> 	VMCOREINFO_OFFSET(page, mapping);
> 	VMCOREINFO_OFFSET(page, lru);
> +	VMCOREINFO_OFFSET(page, _mapcount);
> +	VMCOREINFO_OFFSET(page, private);
> 	VMCOREINFO_OFFSET(pglist_data, node_zones);
> 	VMCOREINFO_OFFSET(pglist_data, nr_zones);
>  #ifdef CONFIG_FLAT_NODE_MEM_MAP
> @@ -1512,6 +1514,8 @@ static int __init crash_save_vmcoreinfo_init(void)
> 	VMCOREINFO_NUMBER(PG_lru);
> 	VMCOREINFO_NUMBER(PG_private);
> 	VMCOREINFO_NUMBER(PG_swapcache);
> +	VMCOREINFO_NUMBER(PG_slab);
> +	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
> 
> 	arch_crash_save_vmcoreinfo();
> 	update_vmcoreinfo_note();
> --
> 1.7.9.2
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
