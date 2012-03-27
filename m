Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab2C0Onk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 10:43:40 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46656 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2C0Onf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 10:43:35 -0400
Date: Tue, 27 Mar 2012 10:31:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH 1/2] xen: enter/exit lazy_mmu_mode around m2p_override
 calls
Message-ID: <20120327143142.GA31081@phenom.dumpdata.com>
References: <1332856364-29995-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332856364-29995-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090201.4F71D20C.0095,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 02:52:43PM +0100, Stefano Stabellini wrote:
> This patch is a significant performance improvement for the

How much? 10%? 90%?

> m2p_override.

Can you explain what those calls do in the git commit description please?

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  drivers/block/xen-blkback/blkback.c |    4 ++++
>  drivers/xen/grant-table.c           |    8 ++++++++
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index 0088bf6..60abff6 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -342,6 +342,7 @@ static void xen_blkbk_unmap(struct pending_req *req)
>  	 * Note, we use invcount, so nr->pages, so we can't index
>  	 * using vaddr(req, i).
>  	 */
> +	arch_enter_lazy_mmu_mode();
>  	for (i = 0; i < invcount; i++) {
>  		ret = m2p_remove_override(
>  			virt_to_page(unmap[i].host_addr), false);
> @@ -351,6 +352,7 @@ static void xen_blkbk_unmap(struct pending_req *req)
>  			continue;
>  		}
>  	}
> +	arch_leave_lazy_mmu_mode();
>  }
>  
>  static int xen_blkbk_map(struct blkif_request *req,
> @@ -386,6 +388,7 @@ static int xen_blkbk_map(struct blkif_request *req,
>  	 * so that when we access vaddr(pending_req,i) it has the contents of
>  	 * the page from the other domain.
>  	 */
> +	arch_enter_lazy_mmu_mode();
>  	for (i = 0; i < nseg; i++) {
>  		if (unlikely(map[i].status != 0)) {
>  			pr_debug(DRV_PFX "invalid buffer -- could not remap it\n");
> @@ -410,6 +413,7 @@ static int xen_blkbk_map(struct blkif_request *req,
>  		seg[i].buf  = map[i].dev_bus_addr |
>  			(req->u.rw.seg[i].first_sect << 9);
>  	}
> +	arch_leave_lazy_mmu_mode();
>  	return ret;
>  }
>  
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index b4d4eac..c7dc2d6 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -751,6 +751,8 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
>  	if (xen_feature(XENFEAT_auto_translated_physmap))
>  		return ret;
>  
> +	arch_enter_lazy_mmu_mode();
> +
>  	for (i = 0; i < count; i++) {
>  		/* Do not add to override if the map failed. */
>  		if (map_ops[i].status)
> @@ -769,6 +771,8 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
>  			return ret;
>  	}
>  
> +	arch_leave_lazy_mmu_mode();
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(gnttab_map_refs);
> @@ -785,12 +789,16 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
>  	if (xen_feature(XENFEAT_auto_translated_physmap))
>  		return ret;
>  
> +	arch_enter_lazy_mmu_mode();
> +
>  	for (i = 0; i < count; i++) {
>  		ret = m2p_remove_override(pages[i], clear_pte);
>  		if (ret)
>  			return ret;
>  	}
>  
> +	arch_leave_lazy_mmu_mode();
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(gnttab_unmap_refs);
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
