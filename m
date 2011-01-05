Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1AEU0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 15:26:00 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52325 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab1AEUZ7 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 5 Jan 2011 15:25:59 -0500
Date: Wed, 5 Jan 2011 15:25:21 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH 01/11] xen: define gnttab_set_map_op/unmap_op
Message-ID: <20110105202521.GG29993@dumpdata.com>
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
 <1292420446-3348-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292420446-3348-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 01:40:36PM +0000, stefano.stabellini@eu.citrix.com wrote:
> From: Ian Campbell <ian.campbell@citrix.com>
> 
> Impact: hypercall definitions
> 
> These functions populate the gnttab data structures used by the
> granttab map and unmap ops and are used in the backend drivers.
> 
> Originally xen-unstable.hg 9625:c3bb51c443a7
> 
> [ Include Stefano's fix for phys_addr_t ]
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  include/xen/grant_table.h |   39 ++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 38 insertions(+), 1 deletions(-)
> 
> diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
> index 9a73170..1821aa1 100644
> --- a/include/xen/grant_table.h
> +++ b/include/xen/grant_table.h
> @@ -37,10 +37,16 @@
>  #ifndef __ASM_GNTTAB_H__
>  #define __ASM_GNTTAB_H__
>  
> -#include <asm/xen/hypervisor.h>
> +#include <asm/page.h>
> +
> +#include <xen/interface/xen.h>
>  #include <xen/interface/grant_table.h>
> +
> +#include <asm/xen/hypervisor.h>
>  #include <asm/xen/grant_table.h>
>  
> +#include <xen/features.h>
> +
>  /* NR_GRANT_FRAMES must be less than or equal to that configured in Xen */
>  #define NR_GRANT_FRAMES 4
>  
> @@ -107,6 +113,37 @@ void gnttab_grant_foreign_access_ref(grant_ref_t ref, domid_t domid,
>  void gnttab_grant_foreign_transfer_ref(grant_ref_t, domid_t domid,
>  				       unsigned long pfn);
>  
> +static inline void
> +gnttab_set_map_op(struct gnttab_map_grant_ref *map, phys_addr_t addr,
> +		  uint32_t flags, grant_ref_t ref, domid_t domid)
> +{
> +	if (flags & GNTMAP_contains_pte)
> +		map->host_addr = addr;
> +	else if (xen_feature(XENFEAT_auto_translated_physmap))
> +		map->host_addr = __pa(addr);
> +	else
> +		map->host_addr = addr;

Why not just get rid of the "flags & GNTMAP_contains_pte"? If
that returns false you still end up setting map->host_addr to addr.

> +
> +	map->flags = flags;
> +	map->ref = ref;
> +	map->dom = domid;
> +}
> +
> +static inline void
> +gnttab_set_unmap_op(struct gnttab_unmap_grant_ref *unmap, phys_addr_t addr,
> +		    uint32_t flags, grant_handle_t handle)
> +{
> +	if (flags & GNTMAP_contains_pte)
> +		unmap->host_addr = addr;
> +	else if (xen_feature(XENFEAT_auto_translated_physmap))
> +		unmap->host_addr = __pa(addr);
> +	else
> +		unmap->host_addr = addr;

Ditto here..
